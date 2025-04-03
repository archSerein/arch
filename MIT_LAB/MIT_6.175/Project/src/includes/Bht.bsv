import Types::*;
import Vector::*;


interface Bht#(numeric type indexSize);
    method  Addr    ppcDP(Addr pc, Addr targetPC);
    method  Action  update(Addr pc, Bool taken);
endinterface

module mkBht(Bht#(indexSize)) provisos(Add#(a__, indexSize, 32));
    Vector#(TExp#(indexSize), Reg#(Bit#(2)))   bhtArr <- replicateM(mkReg(2'b01));

    function Bit#(indexSize) getBhtIndex(Addr pc);
        return truncate(pc >> 2);
    endfunction

    function Bit#(2) getBhtEntry(Bit#(indexSize) index);
        return bhtArr[index];
    endfunction

    function Bit#(2) newDpBits(Bit#(2) dpBits, Bool taken);
        Bit#(2) newDp = case (dpBits)
            2'b00:  (taken ? 2'b01 : 2'b00);
            2'b01:  (taken ? 2'b10 : 2'b00);
            2'b10:  (taken ? 2'b11 : 2'b01);
            2'b11:  (taken ? 2'b11 : 2'b10);
        endcase;

        return newDp;
    endfunction

    method Action update(Addr pc, Bool taken);
        Bit#(indexSize) index = getBhtIndex(pc);
        let dpBits = getBhtEntry(index);
        bhtArr[index] <= newDpBits(dpBits, taken);
    endmethod

    method Addr ppcDP(Addr pc, Addr targetPC);
        Bit#(indexSize) index = getBhtIndex(pc);
        let dpBits = getBhtEntry(index);

        Bool direction = (dpBits == 2'b00 || dpBits == 2'b01) ? False : True;
        if (direction) begin
            return targetPC;
        end else begin
            return pc + 4;
        end
    endmethod
endmodule
