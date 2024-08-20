
import ClientServer::*;
import FIFO::*;
import GetPut::*;

import FixedPoint::*;
import Vector::*;

import ComplexMP::*;


typedef Server#(
    Vector#(nbins, ComplexMP#(isize, fsize, psize)),
    Vector#(nbins, ComplexMP#(isize, fsize, psize))
) PitchAdjust#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);

typedef struct {
    FixedPoint#(isize, fsize)       mag;
    FixedPoint#(isize, fsize)       bin;
    FixedPoint#(isize, fsize)       nbin;
    Phase#(psize)                   phs;
    Phase#(psize)                   dphase;
    Phase#(psize)                   out_phase;
    Bit#(TLog#(nbins))              bin_idx;
    Int#(psize)                     bin_int;
    Int#(psize)                     nbin_int;
} LmOutput#(numeric type isize, numeric type fsize, numeric type psize, numeric type nbins);

// s - the amount each window is shifted from the previous window.
//
// factor - the amount to adjust the pitch.
//  1.0 makes no change. 2.0 goes up an octave, 0.5 goes down an octave, etc...
module mkPitchAdjust(Integer s, FixedPoint#(isize, fsize) factor, PitchAdjust#(nbins, isize, fsize, psize) ifc)
        provisos(Min#(isize, 1, 1), Min#(TAdd#(isize, fsize), 2, 2), Add#(isize, 0, psize),
            Min#(psize, 1, 1), Min#(TAdd#(psize, fsize), 2, 2), Add#(a__, TLog#(nbins), psize));
    
    // TODO: implement this module 
	FIFO#( Vector#( nbins, ComplexMP#( isize, fsize, psize) ) ) inFIFO  <- mkFIFO();
	FIFO#( Vector#( nbins, ComplexMP#( isize, fsize, psize) ) ) outFIFO <- mkFIFO();

    Vector#( nbins, Reg#( Phase#(psize) ) )  inphases  <- replicateM(mkReg(0));
    Vector#( nbins, Reg#( Phase#(psize) ) )  outphases <- replicateM(mkReg(0));

    Reg#( Vector#(nbins, ComplexMP#(isize, fsize, psize) ) ) in  <- mkRegU();
    Reg#( Vector#(nbins, ComplexMP#(isize, fsize, psize) ) ) out <- mkRegU();

    Reg#( FixedPoint#(isize, fsize))                     bin_reg <- mkReg(0);

    Reg#( Bit#( TLog#(nbins))) i    <- mkReg(0);
    Reg#( Bool)         finish      <- mkReg(True);

    // 组合逻辑放到 function 里实现
    // return value: a LmOutput 参数化的结构体
    // 传递给 pitchadjust rule 更新状态
    // finish 控制是否有数据处理完成
    function    LmOutput#(isize, fsize, psize, nbins) lm();
        let mag         = in[i].magnitude;
        let phs         = in[i].phase;
        let dphase      = phs - inphases[i];
        let bin         = bin_reg;
        let nbin        = bin + factor;
        Bit#(TLog#(nbins)) bin_idx = pack(truncate(fxptGetInt(bin)));
        FixedPoint#(isize, fsize) dphase_FxPt = fromInt(dphase);
        let shifted     = truncate(fxptGetInt(fxptMult(factor, dphase_FxPt)));
        let out_phase   = truncate(outphases[bin_idx] + shifted);
        let bin_int     = fxptGetInt(bin);
        let nbin_int    = fxptGetInt(nbin);

        return LmOutput {
            mag:        mag,
            bin:        bin,
            nbin:       nbin,
            phs:        phs,
            dphase:     dphase,
            out_phase:  out_phase,
            bin_idx:    bin_idx,
            bin_int:    bin_int,
            nbin_int:   nbin_int
        };
    endfunction
    // entry
    rule entry if (finish && i == 0);
        in <= inFIFO.first();
        inFIFO.deq();
        out <= replicate(cmplxmp(0, 0));
        finish <= False;
        bin_reg <= 0;
    endrule

    rule pitchadjust if (!finish);
        LmOutput#(isize, fsize, psize, nbins) lm_result = lm();
        bin_reg <= lm_result.nbin;
        inphases[i] <= lm_result.phs;
        if (lm_result.nbin_int != lm_result.bin_int && lm_result.bin_int >= 0 &&
                lm_result.bin_int < fromInteger(valueOf(nbins))) begin
            outphases[lm_result.bin_idx]  <= lm_result.out_phase;
            out[lm_result.bin_idx]        <= cmplxmp(lm_result.mag, lm_result.out_phase);
        end
        if (i == fromInteger(valueOf(nbins) - 1)) begin
            finish <= True;
        end else begin
            i <= i + 1;
        end
    endrule

    rule exit if(finish && i == fromInteger(valueOf(nbins) - 1));
        outFIFO.enq(out);
        i <= 0;
    endrule
	interface Put request;
		method Action put(Vector#(nbins, ComplexMP#(isize, fsize, psize)) x);
			inFIFO.enq(x);
		endmethod
	endinterface

	interface Get response = toGet(outFIFO);

endmodule