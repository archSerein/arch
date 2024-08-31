// 1. Branch Prediction
// 2. Branch Target Buffer

import Types::*;
import ProcTypes::*;
import RegFile::*;
import Vector::*;

// indexSize is the number of bits in the index
interface Btb#(numeric type indexSize);
    method Addr predPc(Addr pc);
    method Action update(Addr thispc, Addr nextpc);
endinterface

// BTB use full tages, and should be only updated fore BRANCH/JUMP instructions
// so it always predict pc+4 for non-branch instructions
module mkBtb( Btb#(indexSize) ) provisos(Add#(indexSize, a__,32), NumAlias#(TSub#(TSub#(AddrSz,2), indexSize), tagSize));
    Vector#(TExp#(indexSize), Reg#(Addr))      targets <- replicateM(mkReg(0));
    Vector#(TExp#(indexSize), Reg#(Bit#(tagSize)))  tags <- replicateM(mkReg(0));
    Vector#(TExp#(indexSize), Reg#(Bool))      valid <- replicateM(mkReg(False));

    function Bit#(indexSize) getIndex(Addr pc) = truncate(pc >> 2);
    function Bit#(tagSize) getTag(Addr pc) = truncateLSB(pc);

    method Addr predPc(Addr pc);
        let index = getIndex(pc);
        let tag = getTag(pc);

        if (valid[index] && (tag == tags[index])) begin
            return targets[index];
        end else begin
            return (pc + 4);
        end
    endmethod

    method Action update(Addr thispc, Addr nextpc);
        if (nextpc != (thispc + 4)) begin
            let index = getIndex(thispc);
            let tag = getTag(thispc);

            // update the entry
            valid[index] <= True;
            tags[index] <= tag;
            targets[index] <= nextpc;
        end
    endmethod

endmodule