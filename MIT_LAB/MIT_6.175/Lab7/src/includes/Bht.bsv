// Branch Prediction
// BHT - Branch History Table

import Types::*;
import ProcTypes::*;
import RegFile::*;
import Vector::*;

interface Bht#(numeric type indexSize);
    method Addr ppcDP(Addr pc, Addr targetPc);
    method Action update(Addr pc, Bool taken);
endinterface

module mkBht(Bht#(indexSize)) provisos ( Add#(indexSize, a__, 32), NumAlias#(TExp#(indexSize), bhtEntries));
    
    Vector#(bhtEntries, Reg#(Bit#(2))) bhtArr <- replicateM(mkReg(2'b01));

    Bit#(2) maxDP = 2'b11;
    Bit#(2) minDP = 2'b00;

    function Bit#(indexSize) getIndex(Addr pc) = truncate(pc >> 2);
    
    function Bit#(2) getBhtEntry(Addr pc); 
        return bhtArr[getIndex(pc)];
    endfunction

    function Bit#(2) newDPBits(Bit#(2) oldDPBits, Bool taken);
        let newDP = oldDPBits;
        if (taken) begin
            newDP = newDP + 1;
            newDP = (newDP == minDP) ? maxDP : newDP;
        end else begin
            newDP = newDP - 1;
            newDP = (newDP == maxDP) ? minDP : newDP;
        end
        return newDP;
    endfunction

    method Addr ppcDP(Addr pc, Addr targetPc);
        let dpBits = getBhtEntry(pc);
        let taken = (dpBits == 2'b11 || dpBits == 2'b10) ? True : False;
        let pred_pc = taken ? targetPc : pc + 4;
        return pred_pc;
    endmethod

    method Action update(Addr pc, Bool taken);
        let index = getIndex(pc);
        let dpBits = getBhtEntry(pc);
        bhtArr[index] <= newDPBits(dpBits, taken);
    endmethod

endmodule
    
