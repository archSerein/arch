import Ehr::*;
import Vector::*;
import FIFO::*;

interface Fifo#(numeric type n, type t);
    method Action enq(t x);
    method Action deq;
    method t first;
    method Bool notEmpty;
    method Bool notFull;
endinterface

// Exercise 1
// Completes the code in Fifo.bsv to implements a 3-elements fifo with properly
// guarded methods. Feel free to take inspiration from the class slides.
// The interface defined in Fifo.bsv tells you the type of the methods
// (enq, deq, first) that your module should define.
module mkFifo(Fifo#(3,t)) provisos (Bits#(t,tSz));
    // define your own 3-elements fifo here.
    // TODO
    Reg#(Maybe#(t)) d[3];
	d[0] <- mkReg(tagged Invalid);
	d[1] <- mkReg(tagged Invalid);
	d[2] <- mkReg(tagged Invalid);
    // Enq if there's at least one spot open... so, dc is invalid.
	// if (!isValid (d[2])) 执行条件
	// 只有在 fifo 缓冲区未满的时候执行
    method Action enq(t x) if (!isValid (d[2]));
	// TODO
	if (!isValid (d[0]))
	begin
		d[0] <= tagged Valid x;
	end
	else if (!isValid (d[1]))
	begin
		d[1] <= tagged Valid x;
	end
	else
	begin
		d[2] <= tagged Valid x;
	end
    endmethod

    // Deq if there's a valid d[0]ta at d[0]
	// 在fifo 缓冲区中还有数据时才会执行
	// 可以使用 <= 代替写寄存器的方法_write
    method Action deq() if (isValid (d[0]));
	// TODO
	d[0] <= d[1];
	d[1] <= d[2];
	d[2] <= tagged Invalid;
    endmethod

    // First if there's a valid data at d[0]
	// 获取 fifo 中第一个元素
    method t first() if (isValid (d[0]));
	// TODO
	return fromMaybe (?, d[0]);
    endmethod

    // Check if fifo's empty
    method Bool notEmpty();
	return isValid(d[0]);
    endmethod

    method Bool notFull();
        return !isValid(d[2]);
    endmethod

endmodule


// Two elements conflict-free fifo given as black box
module mkCFFifo( Fifo#(2, t) ) provisos (Bits#(t, tSz));
    Ehr#(2, t) da <- mkEhr(?);
    Ehr#(2, Bool) va <- mkEhr(False);
    Ehr#(2, t) db <- mkEhr(?);
    Ehr#(2, Bool) vb <- mkEhr(False);

    rule canonicalize;
        if( vb[1] && !va[1] ) begin
            da[1] <= db[1];
            va[1] <= True;
            vb[1] <= False;
        end
    endrule

    method Action enq(t x) if(!vb[0]);
        db[0] <= x;
        vb[0] <= True;
    endmethod

    method Action deq() if(va[0]);
        va[0] <= False;
    endmethod

    method t first if (va[0]);
        return da[0];
    endmethod

    method Bool notEmpty();
        return va[0];
    endmethod

    method Bool notFull();
        return !vb[0];
    endmethod

endmodule

module mkCF3Fifo(Fifo#(3,t)) provisos (Bits#(t, tSz));
    FIFO#(t) bsfif <-  mkSizedFIFO(3);
    method Action enq( t x);
        bsfif.enq(x);
    endmethod

    method Action deq();
        bsfif.deq();
    endmethod

    method t first();
        return bsfif.first();
    endmethod

    method Bool notEmpty();
        return True;
    endmethod

    method Bool notFull();
        return True;
    endmethod

endmodule
