import Vector::*;
import Complex::*;

import FftCommon::*;
import Fifo::*;
import FIFOF::*;

interface Fft;
    method Action enq(Vector#(FftPoints, ComplexData) in);
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
endinterface

`include "Fifo.bsv"

(* synthesize *)
module mkFftCombinational(Fft);
    FIFOF#(Vector#(FftPoints, ComplexData)) inFifo <- mkFIFOF;
    FIFOF#(Vector#(FftPoints, ComplexData)) outFifo <- mkFIFOF;
    Vector#(NumStages, Vector#(BflysPerStage, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    function Vector#(FftPoints, ComplexData) stage_f(StageIdx stage, Vector#(FftPoints, ComplexData) stage_in);
        Vector#(FftPoints, ComplexData) stage_temp, stage_out;
        for (FftIdx i = 0; i < fromInteger(valueOf(BflysPerStage)); i = i + 1)  begin
            FftIdx idx = i * 4;
            Vector#(4, ComplexData) x;
            Vector#(4, ComplexData) twid;
            for (FftIdx j = 0; j < 4; j = j + 1 ) begin
                x[j] = stage_in[idx+j];
                twid[j] = getTwiddle(stage, idx+j);
            end
            let y = bfly[stage][i].bfly4(twid, x);

            for(FftIdx j = 0; j < 4; j = j + 1 ) begin
                stage_temp[idx+j] = y[j];
            end
        end

        stage_out = permute(stage_temp);

        return stage_out;
    endfunction

    rule doFft;
            inFifo.deq;
            Vector#(4, Vector#(FftPoints, ComplexData)) stage_data;
            stage_data[0] = inFifo.first;

            for (StageIdx stage = 0; stage < 3; stage = stage + 1) begin
                stage_data[stage + 1] = stage_f(stage, stage_data[stage]);
            end
            outFifo.enq(stage_data[3]);
    endrule

    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod

    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

(* synthesize *)
module mkFftInelasticPipeline(Fft);
	// TODO
    FIFOF#(Vector#(FftPoints, ComplexData)) inFifo <- mkFIFOF;
    FIFOF#(Vector#(FftPoints, ComplexData)) outFifo <- mkFIFOF;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));
	
	Reg#(Maybe#(Vector#(FftPoints, ComplexData))) sReg1 <- mkRegU; // 创建一个未初始化的寄存器
	Reg#(Maybe#(Vector#(FftPoints, ComplexData))) sReg2 <- mkRegU; // 创建一个未初始化的寄存器

	function Vector#(FftPoints, ComplexData) stage_f (StageIdx stage, Vector#(FftPoints, ComplexData) stage_in);
        	Vector#(FftPoints, ComplexData) stage_temp, stage_out;
        	for (FftIdx i = 0; i < fromInteger(valueOf(BflysPerStage)); i = i + 1)  begin
        	    FftIdx idx = i * 4;
        	    Vector#(4, ComplexData) x;
        	    Vector#(4, ComplexData) twid;
        	    for (FftIdx j = 0; j < 4; j = j + 1 ) begin
        	        x[j] = stage_in[idx+j];
        	        twid[j] = getTwiddle(stage, idx+j);
        	    end
        	    let y = bfly[stage][i].bfly4(twid, x);

        	    for(FftIdx j = 0; j < 4; j = j + 1 ) begin
        	        stage_temp[idx+j] = y[j];
        	    end
        	end

        	stage_out = permute(stage_temp);

        	return stage_out;
   	endfunction
    rule doFft;
	// stage0, 从 infifo 中拿到数据
	if (inFifo.notEmpty())
	begin
		sReg1 <= tagged Valid (stage_f(0, inFifo.first()));
		inFifo.deq();
	end
	else
	begin
		sReg1 <= tagged Invalid;
	end

	// stage 1
	if (isValid(sReg1))
	begin
		sReg2 <= tagged Valid (stage_f(1, fromMaybe(?, sReg1)));
	end
	else
	begin
		sReg2 <= tagged Invalid;
	end

	// stage2
	if (isValid(sReg2))
	begin
		outFifo.enq(stage_f(2, fromMaybe(?, sReg2)));
	end
    endrule

    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod

    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

(* synthesize *)
module mkFftElasticPipeline(Fft);
	// TODO
    FIFOF#(Vector#(FftPoints, ComplexData)) inFifo <- mkFIFOF;
    FIFOF#(Vector#(FftPoints, ComplexData)) outFifo <- mkFIFOF;
    // FIFOF#(Vector#(FftPoints, ComplexData)) sReg1Fifo <- mkFIFOF;
    // FIFOF#(Vector#(FftPoints, ComplexData)) sReg2Fifo <- mkFIFOF;
    Fifo#(3, Vector#(FftPoints, ComplexData)) sReg1Fifo <- mkFifo;
    Fifo#(3, Vector#(FftPoints, ComplexData)) sReg2Fifo <- mkFifo;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));
	
	function Vector#(FftPoints, ComplexData) stage_f (StageIdx stage, Vector#(FftPoints, ComplexData) stage_in);
        	Vector#(FftPoints, ComplexData) stage_temp, stage_out;
        	for (FftIdx i = 0; i < fromInteger(valueOf(BflysPerStage)); i = i + 1)  begin
        	    FftIdx idx = i * 4;
        	    Vector#(4, ComplexData) x;
        	    Vector#(4, ComplexData) twid;
        	    for (FftIdx j = 0; j < 4; j = j + 1 ) begin
        	        x[j] = stage_in[idx+j];
        	        twid[j] = getTwiddle(stage, idx+j);
        	    end
        	    let y = bfly[stage][i].bfly4(twid, x);

        	    for(FftIdx j = 0; j < 4; j = j + 1 ) begin
        	        stage_temp[idx+j] = y[j];
        	    end
        	end

        	stage_out = permute(stage_temp);

        	return stage_out;
   	endfunction
    // You should use more than one rule
	rule stage0 if (inFifo.notEmpty && sReg1Fifo.notFull);
		sReg1Fifo.enq(stage_f(0, inFifo.first));
		inFifo.deq;
	endrule

	rule stage1 if (sReg1Fifo.notEmpty && sReg2Fifo.notFull);
		sReg2Fifo.enq(stage_f(1, sReg1Fifo.first));
		sReg1Fifo.deq;
	endrule

	rule stage2 if (sReg2Fifo.notEmpty);
		outFifo.enq(stage_f(2, sReg2Fifo.first));
		sReg2Fifo.deq;
	endrule

	method Action enq(Vector#(FftPoints, ComplexData) in);
		inFifo.enq(in);
	endmethod

	method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
		outFifo.deq;
		return outFifo.first;
	endmethod
		
endmodule
