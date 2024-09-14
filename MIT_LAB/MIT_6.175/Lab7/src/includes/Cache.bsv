import CacheTypes::*;
import Fifo::*;
import MemUtil::*;
import Types::*;
import CMemTypes::*;
import Vector::*;

module mkTranslator(WideMem wideMem, Cache ifc);
    // 记录向主存发起的请求, 用于计算从主村中返回的数据里需要的 word
    Fifo#(4, MemReq)        reqFIFO <- mkCFFifo;

    function CacheWordSelect getOfset(Addr addr);
        return truncate(addr >> 2);
    endfunction

    method Action req(MemReq r);
        // 如果是 Ld, 需要将请求放入 reqFIFO 队列中
        if (r.op == Ld) begin
            reqFIFO.enq(r);
        end
        wideMem.req( toWideMemReq(r) );
    endmethod
    method ActionValue#(MemResp) resp;
        let cacheLine <- wideMem.resp;
        
        let r = reqFIFO.first();
        reqFIFO.deq();

        CacheWordSelect offset = getOfset(r.addr);
        return cacheLine[offset];
    endmethod
endmodule

typedef enum {Ready, StartMiss, SendFillReq, WaitFillREsp} ReqState deriving (Eq, Bits);
module mkCache(WideMem wideMem, Cache ifc);
    Vector#(CacheRows, Reg#(CacheLine))             dataArray   <- replicateM(mkRegU);
    // tag and valid are kept together as a Maybe type
    Vector#(CacheRows, Reg#(Maybe#(CacheTag)))      tagArray    <- replicateM(mkReg(tagged Invalid));
    Vector#(CacheRows, Reg#(Bool))                  dirtyArray  <- replicateM(mkReg(False));
    
    Fifo#(1, Data)                          hitQ        <- mkBypassFifo;
    Reg#(MemReq)                            missReq     <- mkRegU;
    Reg#(ReqState)                          mshr        <- mkReg(Ready);

    function CacheIndex getIndex (Addr addr);
        return truncate(addr >> 6);
    endfunction

    function CacheWordSelect getOffset(Addr addr);
        return truncate(addr >> 2);
    endfunction

    function CacheTag getTag(Addr addr);
        // 使用 truncateLSB 截取除了 offset 和 index 之后的高位作为 tag
        return truncateLSB(addr);
    endfunction
    
    rule doStartMiss if(mshr == StartMiss);
        let index   = getIndex(missReq.addr);
        let tag     = tagArray[index];
        let dirty   = dirtyArray[index];
        if (isValid(tag) && dirty) begin    // write-back
            let addr = {fromMaybe(?, tag), index, 6'b0};
            let data = dataArray[index];
            wideMem.req(WideMemReq{write_en: '1 ,addr: addr, data: data});
        end
        mshr <= SendFillReq;
    endrule

    rule doSendFillReq if (mshr == SendFillReq);
        wideMem.req(toWideMemReq(MemReq{op: Ld, addr: missReq.addr, data: missReq.data}));
        mshr <= WaitFillREsp;
    endrule

    rule doWaitFillREsp if (mshr == WaitFillREsp);
        let index   = getIndex(missReq.addr);
        let tag     = getTag(missReq.addr);
        let offset  = getOffset(missReq.addr);
        let data    <- wideMem.resp();
        tagArray[index] <= Valid(tag);
        if (missReq.op == Ld) begin
            dirtyArray[index]   <= False;
            dataArray[index]    <= data;
            hitQ.enq(data[offset]);
        end else begin
            data[offset]      = missReq.data;
            dirtyArray[index] <= True;
            dataArray[index]  <= data;
        end
        mshr <= Ready;
    endrule

    method Action req(MemReq r) if (mshr == Ready);
        let index   = getIndex(r.addr);
        let offset  = getOffset(r.addr);
        let currTag = getTag(r.addr);

        // 获取 cache 中记录的 tag
        let tag = tagArray[index];
        let hit = isValid(tag) ? fromMaybe(?, tag) == currTag : False;
        if (hit) begin
            let x = dataArray[index];
            if (r.op == Ld) begin
                hitQ.enq(x[offset]);
            end else begin
                x[offset] = r.data;
                dataArray[index] <= x;
                dirtyArray[index] <= True;
            end
        end else begin
            mshr    <= StartMiss;
            missReq <= r;
        end
    endmethod

    method ActionValue#(Data) resp;
        hitQ.deq();
        return hitQ.first();
    endmethod
endmodule