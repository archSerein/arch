// TwoStage.bsv
//
// This is a two stage pipelined implementation of the SMIPS processor.

import FIFOF::*;
import Types::*;
import ProcTypes::*;
import CMemTypes::*;
import RFile::*;
import IMemory::*;
import DMemory::*;
import Decode::*;
import Exec::*;
import CsrFile::*;
import Vector::*;
import Fifo::*;
import Ehr::*;
import GetPut::*;

typedef struct {
    Addr        pc;
    Addr        ppc;
    DecodedInst dInst;
} F2E deriving (Bits, Eq);

(* synthesize *)
module mkProc(Proc);
    Ehr#(2, Addr) pc <- mkEhr(0);
    RFile      rf    <- mkRFile;
    IMemory  iMem    <- mkIMemory;
    DMemory  dMem    <- mkDMemory;
    CsrFile  csrf    <- mkCsrFile;

    FIFOF#(F2E) f2e <- mkFIFOF;

    Bool memReady = iMem.init.done() && dMem.init.done();
    rule test if (!memReady);
        let e = tagged InitDone;
        iMem.init.request.put(e);
        dMem.init.request.put(e);
    endrule

    // TODO: Complete the implementation of this processor
    rule doFetch if (csrf.started);
        Data inst = iMem.req(pc[0]);
        let dInst = decode(inst);
        let ppc = pc[0] + 4;

        f2e.enq(F2E{pc: pc[0], ppc: ppc, dInst: dInst});

        pc[0] <= ppc;
    endrule

    rule doExec if (csrf.started);
        let x     = f2e.first;
        let dInst = x.dInst;
        let _pc   = x.pc;
        let ppc   = x.ppc;

        let rVal1   = rf.rd1(fromMaybe(?, dInst.src1));
        let rVal2   = rf.rd2(fromMaybe(?, dInst.src2));
        let csrVal  = csrf.rd(fromMaybe(?, dInst.csr));

        ExecInst eInst = exec(dInst, rVal1, rVal2, _pc, ppc, csrVal);

        // memory
        if (eInst.iType == Ld) begin
            eInst.data <- dMem.req(MemReq{op: Ld, addr: eInst.addr, data: ?});
        end else if (eInst.iType == St) begin
            let d <- dMem.req(MemReq{op: St, addr: eInst.addr, data: eInst.data});
        end

        // write back
        if (isValid(eInst.dst)) begin
            rf.wr(fromMaybe(?, eInst.dst), eInst.data);
        end

        // CSR write for sending data to host & stats
        csrf.wr(eInst.iType == Csrw ? eInst.csr : Invalid, eInst.data);

        if (eInst.mispredict) begin
            pc[1] <= eInst.addr;
            f2e.clear;
        end else begin
            f2e.deq;
        end
    endrule

    method ActionValue#(CpuToHostData) cpuToHost;
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !csrf.started && memReady );
        csrf.start(0); // only 1 core, id = 0
        $display("Start at pc 200\n");
	    $fflush(stdout);
        pc[0] <= startpc;
    endmethod

    interface MemInit iMemInit = iMem.init;
    interface MemInit dMemInit = dMem.init;
endmodule

