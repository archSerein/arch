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
module mkAudioPipeline(AudioProcessor);

    AudioProcessor fir <- mkFIRFilter(c);
    // Chunker#(FFT_POINTS, ComplexSample) chunker <- mkChunker();
    Chunker#(S, Sample ) chunker <- mkChunker();

	OverSampler#(S, N, Sample ) oversampler  <- mkOverSampler(replicate(0));

    // FFT#(FFT_POINTS, FixedPoint#(16, 16)) fft <- mkFFT();
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    // FFT#(FFT_POINTS, FixedPoint#(16, 16)) ifft <- mkIFFT();
    ToMP#(N, ISIZE, FSIZE, PSIZE)      tomp <- mkToMP();

    PitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitchadjust <- mkPitchAdjust(valueOf(S), 2);

    FromMP#(N, ISIZE, FSIZE, PSIZE)    frommp <- mkFromMP();

    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkIFFT();

	Overlayer#(N, S, Sample ) overlayer <- mkOverlayer(replicate(0));

    Splitter#(S, Sample) splitter <- mkSplitter();

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
    
    method Action putSampleInput(Sample x);
        fir.putSampleInput(x);
    endmethod

    method ActionValue#(Sample) getSampleOutput();
        let x <- splitter.response.get();
        return x;
    endmethod

endmodule

