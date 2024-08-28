import ClientServer::*;
import Complex::*;
import ComplexMP::*;
import FixedPoint::*;
import FIFO::*;
import Vector::*;
import Cordic::*;
import GetPut::*;

typedef Server#(
    Vector#(nbins, ComplexMP#(isize, fsize, psize)),
    Vector#(nbins, Complex#(FixedPoint#(isize, fsize)))
) FromMP#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);

typedef Server#(
    Vector#(nbins, Complex#(FixedPoint#(isize, fsize))),
    Vector#(nbins, ComplexMP#(isize, fsize, psize))
) ToMP#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);

module mkFromMP (FromMP#(nbins, isize, fsize, psize))
        provisos(Min#(TAdd#(isize, fsize), 2, 2), Min#(isize, 1, 1));
    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) infifo <- mkFIFO();
    FIFO#(Vector#(nbins, Complex#(FixedPoint#(isize, fsize))))  outfifo <- mkFIFO();
    
    Vector#(nbins, FromMagnitudePhase#(isize, fsize, psize)) fromMP <- replicateM(mkCordicFromMagnitudePhase());

    let nbins_int = valueOf(nbins);

    rule in_data;
        for (Integer i = 0; i < nbins_int; i = i + 1) begin
            fromMP[i].request.put(infifo.first[i]);
        end
        infifo.deq();
    endrule

    rule out_data;
        Vector#(nbins, Complex#(FixedPoint#(isize, fsize))) out ;
        for (Integer i = 0; i < nbins_int; i = i + 1) begin
            out[i] <- fromMP[i].response.get();
        end
        outfifo.enq(out);
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);

endmodule


module mkToMP (ToMP#(nbins, isize, fsize, psize) ifc)
        provisos(Min#(TAdd#(isize, fsize), 2, 2), Min#(isize, 1, 1));

    FIFO#(Vector#(nbins, Complex#(FixedPoint#(isize, fsize)))) infifo <- mkFIFO();
    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) outfifo <- mkFIFO();

    Vector#(nbins, ToMagnitudePhase#(isize, fsize, psize)) toMP <- replicateM(mkCordicToMagnitudePhase());

    let nbins_int = valueOf(nbins);

    rule in_data;
        for (Integer i = 0; i < nbins_int; i = i + 1) begin
            toMP[i].request.put(infifo.first[i]);
        end
        infifo.deq();
    endrule
    
    rule out_data;
        Vector#(nbins, ComplexMP#(isize, fsize, psize)) out;
        for (Integer i = 0; i < nbins_int; i = i + 1) begin
            out[i] <- toMP[i].response.get();
        end
        outfifo.enq(out);
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);

endmodule
