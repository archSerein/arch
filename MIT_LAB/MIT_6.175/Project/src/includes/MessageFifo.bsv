import CacheTypes::*;
import Fifo::*;

module mkMessageFifo(MessageFifo#(n));
    Fifo#(2, CacheMemReq) req_fifo <- mkCFFifo;
    Fifo#(2, CacheMemResp) resp_fifo <- mkCFFifo;

    method Action enq_resp(CacheMemResp d);
        resp_fifo.enq(d);
    endmethod

    method Action enq_req(CacheMemReq d);
        req_fifo.enq(d);
    endmethod

    method Bool hasResp;
        return resp_fifo.notEmpty;
    endmethod

    method Bool hasReq;
        return req_fifo.notEmpty;
    endmethod

    method Bool notEmpty;
        return req_fifo.notEmpty || resp_fifo.notEmpty;
    endmethod

    method CacheMemMessage first;
        if (resp_fifo.notEmpty) begin
            return tagged Resp resp_fifo.first;
        end else begin
            return tagged Req req_fifo.first;
        end
    endmethod

    method Action deq;
        if (resp_fifo.notEmpty) begin
            resp_fifo.deq;
        end else begin
            req_fifo.deq;
        end
    endmethod
endmodule
