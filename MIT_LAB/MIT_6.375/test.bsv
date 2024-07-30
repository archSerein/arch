nearFFT (FFT);
    // 静态生成 twiddle factors table
    TwiddleTable twiddles = genTwiddles();

    function Vector#(FFT_POINTS, ComplexSample) stage_f(Bit#(TLog#(FFT_LOG_POINTS)) stage, Vector#(FFT_POINTS, ComplexSamPle) stage_in);
        return stage_ft(twiddles, stage, stage_in);
    endfunction

    FIFO#(Vector#(FFT_POINTS, ComplexSamPle)) inputFIFO <- mkFIFO();
    FIFO#(Vector#(FFT_POINTS, ComplexSamPle)) outputFIFO <- mkFIFO();

    rule linear_fft;
        Vector#(TAdd#(1, FFT_LOG_POINTS), Reg#(Vector#(FFT_POINTS, ComplexSample))) stage_data <- replicateM(mkRegU);
        Vector#(TAdd#(1, FFT_LOG_POINTS), Reg#(bool)) stage_valid <- replicateM(mkReg(False));
        Stage_data[0] = inputFIFO.first();
        inputFIFO.deq();

        for(Integer stage = 0; stage < valueOf(FFT_LOG_POINTS); stage = stage + 1) begin
            if (stage_valid[stage]) begin
                stage_date[stage+1] = stage_f(fromInteger(stage), stage_date[stage]);
                stage_valid[stage] = False;
            end else
                stage_valid[stage] = True;
            end
        end

        if (stage_valid[valueOf(FFT_LOG_POINTS)]) begin
            outputFIFO.enq(stage_data[valueOf(FFT_LOG_POINTS)]);
        end
    endrule

  interface Put request;
    method Action put(Vector#(FFT_POINTS, ComplexSample) x);
        inputFIFO.enq(bitReverse(x));
    endmethod
  endinterface

  interface Get response = toGet(outputFIFO);
endmodule

