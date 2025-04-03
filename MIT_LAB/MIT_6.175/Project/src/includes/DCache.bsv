import CacheTypes::*;
import Vector::*;
import FShow::*;
import MemTypes::*;
import Types::*;
import ProcTypes::*;
import Fifo::*;
import Ehr::*;
import RefTypes::*;

typedef enum {Ready, StartMiss, SendFillReq, WaitFillResp, Response, 
                CacheFlush} ReqState deriving (Eq, Bits);

module mkDCache#(CoreID id)(
    MessageGet fromMem,
    MessagePut toMem,
    RefDMem refDMem,
    DCache ifc
);

    Vector#(CacheRows, Reg#(CacheLine))         dataArray <-replicateM(mkRegU);
    Vector#(CacheRows, Reg#(CacheTag))          tagArray  <-replicateM(mkRegU);
    Vector#(CacheRows, Reg#(MSI))               stateArray<-replicateM(mkReg(I));

    Fifo#(8, Data)                              hitQ    <- mkBypassFifo;
    Fifo#(8, MemReq)                            reqQ    <- mkBypassFifo;
    Reg#(MemReq)                                missReq <- mkRegU;
    Reg#(ReqState)                              mshr    <- mkReg(Ready);

    Reg#(Bit#(TLog#(CacheRows))) flushIdx               <- mkReg(0);
    Reg#(Maybe#(CacheLineAddr))                 lineAddr <- mkReg(Invalid);

    rule doStartMiss if (mshr == StartMiss);
        let index = getIndex(missReq.addr);
        if (stateArray[index] != I) begin
            stateArray[index] <= I;
            let addr = {tagArray[index], index, getWordSelect(missReq.addr), 2'b0};
            Maybe#(CacheLine) data = (stateArray[index] == M) ? Valid(dataArray[index]) : Invalid;
            CacheMemResp message = CacheMemResp{
                child: id,
                addr: addr,
                state: I,
                data: data
            };
            toMem.enq_resp(message);
            if (fromMaybe(?, lineAddr) == getLineAddr(addr)) begin
                lineAddr <= Invalid;
            end
        end
        mshr <= SendFillReq;
    endrule

    rule doSendFillReq if (mshr == SendFillReq);
        let upg = (missReq.op == Ld || missReq.op == Lr) ? S : M;
        CacheMemReq message = CacheMemReq{
            child:  id,
            addr:   missReq.addr,
            state:  upg
        };
        toMem.enq_req(message);
        mshr <= WaitFillResp;
    endrule

    rule doWaitFillResp if (mshr == WaitFillResp &&&
                            fromMem.first matches tagged Resp .resp);
        let index        = getIndex(missReq.addr);
        CacheLine rdata  = isValid(resp.data) ? fromMaybe(?, resp.data) : dataArray[index];
        let old          = rdata;
        let offset       = getWordSelect(missReq.addr);
        if (missReq.op == St) begin
            rdata[offset] = missReq.data;
            refDMem.commit(missReq, Valid(old), Invalid);
        end else if (missReq.op == Sc) begin
            if (isValid(lineAddr) && fromMaybe(?, lineAddr) == getLineAddr(missReq.addr)) begin
                rdata[offset] = missReq.data;
                refDMem.commit(missReq, Valid(old), Valid(scSucc));
                hitQ.enq(scSucc);
                $display("core %d cache sc data: %h", id, missReq.data);
            end else begin
                hitQ.enq(scFail);
                refDMem.commit(missReq, Valid(old), Valid(scFail));
            end
            lineAddr <= Invalid;
        end
        dataArray[index]  <= rdata;
        stateArray[index] <= resp.state;
        tagArray[index]   <= getTag(missReq.addr);
        fromMem.deq;
        mshr <= Response;
    endrule

    rule doResponse if (mshr == Response);
        if (missReq.op == Ld || missReq.op == Lr) begin
            let index        = getIndex(missReq.addr);
            let offset       = getWordSelect(missReq.addr);
            CacheLine   data = dataArray[index];
            hitQ.enq(data[offset]);
            refDMem.commit(missReq, Valid(dataArray[index]), Valid(data[offset]));
        end
        if (missReq.op == Lr) begin
            $display("core %d cache lr data: %h", id, dataArray[getWordSelect(missReq.addr)]);
            lineAddr <= tagged Valid getLineAddr(missReq.addr);
        end
        mshr <= Ready;
    endrule

    rule doDng if (mshr != Response &&&
                    fromMem.first matches tagged Req .req);
        let index = getIndex(req.addr);
        if (stateArray[index] > req.state) begin
            Maybe#(CacheLine) d = (stateArray[index] == M) ? Valid(dataArray[index]) : Invalid;
            CacheMemResp cacheResp = CacheMemResp {
                child:  id,
                addr:   req.addr,
                state:  req.state,
                data:   d
            };
            toMem.enq_resp(cacheResp);
            stateArray[index] <= req.state;
            if (isValid(lineAddr) && fromMaybe(?, lineAddr) == getLineAddr(req.addr)) begin
                lineAddr <= Invalid;
            end
        end
        fromMem.deq;
    endrule

    rule doReady if (mshr == Ready);
        let r = reqQ.first;
        refDMem.issue(r);
        reqQ.deq;
        let addr = r.addr;
        let index = getIndex(addr);
        let state = stateArray[index];
        let tag = getTag(addr);
        let hit = state != I && tagArray[index] == tag;
        let proceed = (r.op != Sc || (r.op == Sc && isValid(lineAddr) &&
                          fromMaybe(?, lineAddr) == getLineAddr(addr)));

        if (!proceed) begin
            hitQ.enq(scFail);
            lineAddr <= Invalid;
        end else begin
            if (!hit) begin
                missReq <= r;
                mshr    <= StartMiss;
            end else begin
                let data = dataArray[index];
                let offset = getWordSelect(addr);
                case (r.op)
                    Ld: begin
                        hitQ.enq(data[offset]);
                        refDMem.commit(r, Valid(dataArray[index]), Valid(data[offset]));
                    end
                    St: begin
                        if (state == M) begin
                            data[offset] = r.data;
                            let old = dataArray[index];
                            dataArray[index] <= data;
                            refDMem.commit(missReq, Valid(dataArray[index]), Valid(data[offset]));
                        end else begin
                            missReq <= r;
                            mshr    <= SendFillReq;
                        end
                    end
                    Lr: begin
                        hitQ.enq(data[offset]);
                        refDMem.commit(r, Valid(dataArray[index]), Valid(data[offset]));
                        lineAddr    <= tagged Valid getLineAddr(addr);
                        $display("core %d cache lr data: %h", id, data[offset]);
                    end
                    Sc: begin
                        if (state == M) begin
                            data[offset] = r.data;
                            let old = dataArray[index];
                            hitQ.enq(scSucc);
                            dataArray[index] <= data;
                            $display("core %d cache sc data: %h", id, r.data);
                            refDMem.commit(missReq, Valid(old), Valid(scSucc));
                            lineAddr    <= Invalid;
                        end else begin
                            missReq <= r;
                            mshr    <= SendFillReq;
                        end
                    end
                    Fence: begin
                        // 降级请求
                        mshr <= CacheFlush;
                    end
                endcase
            end
        end
    endrule

    rule cacheFlush if (mshr == CacheFlush);
        let idx = flushIdx;

        if (stateArray[idx] != I) begin
            Addr evictAddr = {tagArray[idx], idx, 0};
            CacheMemResp message = CacheMemResp {
                child: id,
                addr: evictAddr,
                state: I,
                data: Valid(dataArray[idx])
            };
            toMem.enq_resp(message);
            stateArray[idx] <= I;
        end

        // 增加 flush index
        if (idx == fromInteger(valueOf(CacheRows) - 1)) begin
            mshr <= Ready;
            flushIdx <= 0;
        end else begin
            flushIdx <= idx + 1;
        end
    endrule

    method Action req(MemReq r) if (reqQ.notFull);
        reqQ.enq(r);
    endmethod

    method ActionValue#(MemResp) resp;
        hitQ.deq;
        let data = hitQ.first;
        return data;
    endmethod

endmodule