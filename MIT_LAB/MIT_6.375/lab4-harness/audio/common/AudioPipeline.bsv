import Vector::*;
import ClientServer::*;
import GetPut::*;

import AudioProcessorTypes::*;
import Chunker::*;
import FFT::*;
import FIRFilter::*;
import FilterCoefficients::*;
import Splitter::*;
import FixedPoint::*;
import convertMP::*;
import PitchAdjust::*;
import Complex::*;
import Overlayer::*;
import OverSampler::*;
// lab3
typedef 8   N;
typedef 2   S;
typedef 16	ISIZE;
typedef 16	FSIZE;
typedef 16	PSIZE;

(* synthesize *)
module mkAudioPipelineFIR(AudioProcessor);
    AudioProcessor fir <- mkFIRFilter(c);
    return fir;
endmodule

(* synthesize *)
module mkAudioPipelineChunker(Chunker#(S, Sample));
    Chunker#(S, Sample) chunker <- mkChunker();
    return chunker;
endmodule

(* synthesize *)
module mkAudioPipelineOverSampler(OverSampler#(S, N, Sample));
    OverSampler#(S, N, Sample) oversampler <- mkOverSampler(replicate(0));
    return oversampler;
endmodule

(* synthesize *)
module mkAudioPipelineFFT(FFT#(N, FixedPoint#(ISIZE, FSIZE)));
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    return fft;
endmodule

(* synthesize *)
module mkAudioPipelineToMP(ToMP#(N, ISIZE, FSIZE, PSIZE));
    ToMP#(N, ISIZE, FSIZE, PSIZE)   tomp <- mkToMP();
    return tomp;
endmodule

(* synthesize *)
module mkAudioPipelinePitchAdjust(SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE));
    SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE)    pitch <- mkPitchAdjust(valueOf(S));
    return pitch;
endmodule

(* synthesize *)
module mkAudioPipelineFromMP(FromMP#(N, ISIZE, FSIZE, PSIZE));
    FromMP#(N, ISIZE, FSIZE, PSIZE) frommp <- mkFromMP();
    return frommp;
endmodule

(* synthesize *)
module mkAudioPipelineOverlayer(Overlayer#(N, S, Sample));
    Overlayer#(N, S, Sample) overlayer <- mkOverlayer(replicate(0));
    return overlayer;
endmodule

(* synthesize *)
module mkAudioPipelineIFFT(FFT#(N, FixedPoint#(ISIZE, FSIZE)));
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkIFFT();
    return ifft;
endmodule

(* synthesize *)
module mkAudioPipelineSplitter(Splitter#(S, Sample));
    Splitter#(S, Sample) splitter <- mkSplitter();
    return splitter;
endmodule

module mkAudioPipeline(SettableAudioProcessor#(ISIZE, FSIZE));

    // AudioProcessor fir <- mkFIRFilter(c);
    AudioProcessor fir <- mkAudioPipelineFIR();
    // Chunker#(FFT_POINTS, ComplexSample) chunker <- mkChunker();
    // Chunker#(S, Sample ) chunker <- mkChunker();
    Chunker#(S, Sample) chunker <- mkAudioPipelineChunker();

	// OverSampler#(S, N, Sample ) oversampler  <- mkOverSampler(replicate(0));
	OverSampler#(S, N, Sample ) oversampler  <- mkAudioPipelineOverSampler();

    // FFT#(FFT_POINTS, FixedPoint#(16, 16)) fft <- mkFFT();
    // FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkAudioPipelineFFT();
    // FFT#(FFT_POINTS, FixedPoint#(16, 16)) ifft <- mkIFFT();
    // ToMP#(N, ISIZE, FSIZE, PSIZE)      tomp <- mkToMP();
    ToMP#(N, ISIZE, FSIZE, PSIZE)      tomp <- mkAudioPipelineToMP();

    // SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitch <- mkPitchAdjust(valueOf(S));
    SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitch <- mkAudioPipelinePitchAdjust();
    PitchAdjust#(N, ISIZE, FSIZE, PSIZE)   pitchadjust = pitch.adjust;

    FromMP#(N, ISIZE, FSIZE, PSIZE)    frommp <- mkAudioPipelineFromMP();

    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkAudioPipelineIFFT();

	Overlayer#(N, S, Sample ) overlayer <- mkAudioPipelineOverlayer();

    Splitter#(S, Sample) splitter <- mkAudioPipelineSplitter();

    rule fir_to_chunker (True);
        let x <- fir.getSampleOutput();
        chunker.request.put(x);
    endrule

	rule chunker_to_oversampler (True);
		let x <- chunker.response.get();
		oversampler.request.put(x);
	endrule

	rule oversampler_to_fft (True);
		let x <- oversampler.response.get();
		fft.request.put(map(tocmplx, x));
	endrule

    // rule chunker_to_fft (True);
    //     let x <- chunker.response.get();
    //     fft.request.put(x);
    // endrule

    // rule fft_to_ifft (True);
    //     let x <- fft.response.get();
    //     ifft.request.put(x);
    // endrule
	rule fft_to_tomp (True);
		let x <- fft.response.get();
		tomp.request.put(x);
	endrule

	rule tomp_to_pitchadjust (True);
		let x <- tomp.response.get();
		pitchadjust.request.put(x);
	endrule

	rule pitchadjust_to_frommp (True);
		let x <- pitchadjust.response.get();
		frommp.request.put(x);
	endrule

	rule frommp_to_ifft (True);
		let x <- frommp.response.get();
		ifft.request.put(x);
	endrule

	rule ifft_to_overlayer (True);
		let x <- ifft.response.get();
		overlayer.request.put(map(frcmplx, x));
	endrule

	rule overlayer_to_splitter (True);
		let x <- overlayer.response.get();
		splitter.request.put(x);
	endrule
    // rule ifft_to_splitter (True);
    //     let x <- ifft.response.get();
    //     splitter.request.put(x);
    // endrule
    
    interface AudioProcessor pipeline;
        method Action putSampleInput(Sample x);
            fir.putSampleInput(x);
        endmethod

        method ActionValue#(Sample) getSampleOutput();
            let x <- splitter.response.get();
            return x;
        endmethod
    endinterface

    interface Put pipelineSetFactor;
        method Action put(FixedPoint#(ISIZE, FSIZE) x);
            pitch.setFactor.put(x);
        endmethod
    endinterface
endmodule

