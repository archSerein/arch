import ProcTypes::*;
import MemTypes::*;
import Types::*;
import CacheTypes::*;
import MessageFifo::*;
import Vector::*;
import FShow::*;

module mkPPP(MessageGet c2m, MessagePut m2c, WideMem mem, Empty ifc);
    Vector#(CoreNum, Vector#(CacheRows, Reg#(MSI))) childState <- replicateM(replicateM(mkReg(I)));
    Vector#(CoreNum, Vector#(CacheRows, Reg#(CacheTag))) childTag <- replicateM(replicateM(mkRegU));
    Vector#(CoreNum, Vector#(CacheRows, Reg#(Bool)))    waitState <- replicateM(replicateM(mkReg(False)));

    Reg#(Bool)      miss    <- mkReg(False);
    Reg#(Bool)      ready   <- mkReg(False);

    function Bool isCompatible(MSI x, MSI y);
        Bool res = True;
        if (x == M && y == M) begin
            res = False;
        end
        if (x == M && y == S) begin
            res = False;
        end
        if (x == S && y == M) begin
            res = False;
        end
        return res;
    endfunction
    rule parentResp if (c2m.first matches tagged Req .req &&& ready &&& !miss);
        let index = getIndex(req.addr);
        let child = req.child;
        Bool conflict = False;
        for (Integer i = 0; i < valueOf(CoreNum); i = i + 1) begin
            if (fromInteger(i) != child) begin
                MSI state = childTag[fromInteger(i)][index] == getTag(req.addr) ?
                                childState[fromInteger(i)][index] : I;
                if (!isCompatible(state, req.state) || waitState[child][index]) begin
                    conflict = True;
                end
            end
        end

        if (!conflict) begin
            let state = getTag(req.addr) == childTag[child][index] ? childState[child][index] : I;
            if (state != I) begin
                CacheMemResp message = CacheMemResp {
                    child: child,
                    addr:  req.addr,
                    state: req.state,
                    data:  Invalid
                };
                m2c.enq_resp(message);
                childState[child][index] <= req.state;
                childTag[child][index]  <= getTag(req.addr);
                c2m.deq;
            end else begin
                // 需要向 Mem 请求数据
                WideMemReq message = WideMemReq{
                    write_en: '0,
                    addr:  req.addr,
                    data:  ?
                };
                mem.req(message);
                miss <= True;
            end
        end else begin
            ready <= False;
        end
    endrule

    rule parentRespData if (miss &&& c2m.first matches tagged Req .req &&& ready);
        let data <- mem.resp();
        let valid = mem.respValid();
        CacheMemResp message = CacheMemResp{
            child: req.child,
            addr:  req.addr,
            state: req.state,
            data:  Valid(data)
        };
        childState[req.child][getIndex(req.addr)] <= req.state;
        childTag[req.child][getIndex(req.addr)] <= getTag(req.addr);
        m2c.enq_resp(message);
        c2m.deq;
        miss <= False;
    endrule

    rule dwn (c2m.first matches tagged Req .req &&& !ready &&& !miss);
        let child = req.child;
        Maybe#(CoreID)  index = Invalid;
        for (Integer i = 0; i < valueOf(CoreNum); i = i + 1) begin
            if (fromInteger(i) != child) begin
                MSI state = childTag[fromInteger(i)][getIndex(req.addr)] == getTag(req.addr) ?
                                childState[fromInteger(i)][getIndex(req.addr)] : I;
                if (!isCompatible(state, req.state) || waitState[fromInteger(i)][getIndex(req.addr)]) begin
                    index = tagged Valid fromInteger(i);
                end
            end
        end
        if (isValid(index)) begin
            let id = fromMaybe(?, index);
            CacheMemReq message = CacheMemReq{
                child: id,
                addr:  req.addr,
                state:  req.state == M ? I : S
            };
            waitState[id][getIndex(req.addr)] <= True;
            $display("downgrade request");
            m2c.enq_req(message);
        end else begin
            ready <= True;
        end
    endrule

    rule dwnRsp (c2m.first matches tagged Resp .resp);
        let child = resp.child;
        let index = getIndex(resp.addr);
        MSI state = childTag[child][index] == getTag(resp.addr) ? childState[child][index] : I;
        let data  = fromMaybe(?, resp.data);
        if (state == M) begin
            WideMemReq message = WideMemReq{
                write_en:  '1,
                addr:  resp.addr,
                data:  data
            };
            mem.req(message);
        end
        childTag[child][index]  <= getTag(resp.addr);
        childState[child][index] <= resp.state;
        waitState[child][index] <= False;
        c2m.deq;
    endrule

endmodule