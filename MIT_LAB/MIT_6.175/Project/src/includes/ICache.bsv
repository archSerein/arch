import CacheTypes::*;
import Types::*;
import ProcTypes::*;
import Fifo::*;
import Vector::*;
import MemTypes::*;
import MemUtil::*;
import SimMem::*;


typedef enum {Ready, SendFillReq, WaitFillREsp} ReqState deriving (Eq, Bits);
module mkICache(WideMem wideMem, ICache ifc);
    Vector#(CacheRows, Reg#(CacheLine))             dataArray   <- replicateM(mkRegU);
    // tag and valid are kept together as a Maybe type
    Vector#(CacheRows, Reg#(Maybe#(CacheTag)))      tagArray    <- replicateM(mkReg(tagged Invalid));
    
    Fifo#(1, Data)                          hitQ        <- mkBypassFifo;
    Reg#(Addr)                              missReq     <- mkRegU;
    Reg#(ReqState)                          mshr        <- mkReg(Ready);

    rule doSendFillReq if (mshr == SendFillReq);
        wideMem.req(toWideMemReq(MemReq{op: Ld, addr: missReq, data: ?}));
        mshr <= WaitFillREsp;
    endrule

    rule doWaitFillResp if (mshr == WaitFillREsp);
        let index   = getIndex(missReq);
        let tag     = getTag(missReq);
        let offset  = getWordSelect(missReq);
        let data    <- wideMem.resp();
        tagArray[index] <= Valid(tag);
        dataArray[index]    <= data;
        hitQ.enq(data[offset]);
        mshr <= Ready;
    endrule

    method Action req(Addr r) if (mshr == Ready);
        let index   = getIndex(r);
        let offset  = getWordSelect(r);
        let currTag = getTag(r);

        // 获取 cache 中记录的 tag
        let tag = tagArray[index];
        let hit = isValid(tag) ? fromMaybe(?, tag) == currTag : False;
        if (hit) begin
            let x = dataArray[index];
            hitQ.enq(x[offset]);
        end else begin
            mshr    <= SendFillReq;
            missReq <= r;
        end
    endmethod

    method ActionValue#(Data) resp;
        hitQ.deq();
        return hitQ.first();
    endmethod
endmodule

