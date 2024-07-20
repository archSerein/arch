import FIFO::*;
import Vector::*;
import FixedPoint::*;

import AudioProcessorTypes :: *;
import FilterCoefficients::*;
import Multiplier::*;

module mkFIRFilter(AudioProcessor);
	// 实例化两个 mkFIFO module
	// FIFO 元素的类型是 Sample
    FIFO#(Sample) infifo <- mkFIFO();
    FIFO#(Sample) outfifo <- mkFIFO();

	// 实例化八个寄存器，类型是 Sample
	// 初始化寄存器的值为0
    // Reg#(Sample) r0 <- mkReg(0);
    // Reg#(Sample) r1 <- mkReg(0);
    // Reg#(Sample) r2 <- mkReg(0);
    // Reg#(Sample) r3 <- mkReg(0);
    // Reg#(Sample) r4 <- mkReg(0);
    // Reg#(Sample) r5 <- mkReg(0);
    // Reg#(Sample) r6 <- mkReg(0);
    // Reg#(Sample) r7 <- mkReg(0);
	// 使用 Vector 代替上面的八个分离的寄存器
    Vector#(8, Reg#(Sample)) r <- replicateM(mkReg(0));

    Vector#(9, Multiplier) muls <- replicateM(mkMultiplier());

	// state elements update rules
    rule process (True);
        Sample sample = infifo.first();
        infifo.deq();

        // r0 <= sample;
        // r1 <= r0;
        // r2 <= r1;
        // r3 <= r2;
        // r4 <= r3;
        // r5 <= r4;
        // r6 <= r5;
        // r7 <= r6;
		// 使用 for-loop 更新寄存器的值
		// compiler will replace this for-loop with its fully unrolled verson
		// during its static elaboration
        r[0] <= sample;
        for (Integer i = 0; i < 7; i = i + 1) begin
            r[i + 1] <= r[i];
        end
        
        // FixedPoint#(16,16) accumulate = 
        //         c[0] * fromInt(sample)
        //     +   c[1] * fromInt(r0)
        //     +   c[2] * fromInt(r1)
        //     +   c[3] * fromInt(r2)
        //     +   c[4] * fromInt(r3)
        //     +   c[5] * fromInt(r4)
        //     +   c[6] * fromInt(r5)
        //     +   c[7] * fromInt(r6)
        //     +   c[8] * fromInt(r7);
        muls[0].putOperands(c[0], sample);
        for (Integer i = 0; i < 8; i = i + 1) begin
            muls[i + 1].putOperands(c[i + 1], r[i]);
        end
    endrule

    rule acc;
        FixedPoint#(16, 16) accumulate <- muls[0].getResult();
        for (Integer i = 0; i < 8; i = i + 1) begin
            let result <- muls[i + 1].getResult();
            accumulate = accumulate + result;
        end
        outfifo.enq(fxptGetInt(accumulate));
    endrule

    method Action putSampleInput(Sample in);
        infifo.enq(in);
    endmethod

    method ActionValue#(Sample) getSampleOutput();
        outfifo.deq();
        return outfifo.first();
    endmethod
endmodule
