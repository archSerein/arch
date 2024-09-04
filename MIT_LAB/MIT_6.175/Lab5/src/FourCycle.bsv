// FourCycle.bsv
//
// This is a four cycle implementation of the RISC-V processor.

import Types::*;
import ProcTypes::*;
import CMemTypes::*;
import MemInit::*;
import RFile::*;
import DelayedMemory::*;
import DMemory::*;
import Decode::*;
import Exec::*;
import CsrFile::*;
import Vector::*;
import FIFO::*;
import Ehr::*;
import GetPut::*;

typedef enum {Fetch, Decode, Execute, WriteBack} Stage deriving (Bits, Eq, FShow);

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr)       pc <- mkRegU;
    RFile            rf <- mkRFile;
    DelayedMemory   mem <- mkDelayedMemory;
    // DMemory        dMem <- mkDMemory;
    CsrFile        csrf <- mkCsrFile;

    MemInitIfc dummyMemInit <- mkDummyMemInit;
    Reg#(DecodedInst) dInst <- mkRegU;
    Reg#(ExecInst)    eInst <- mkRegU;
    Reg#(Stage)       stage <- mkReg(Fetch);
    Vector#(3, Reg#(Data))  rfVal <- replicateM(mkRegU);

    Bool memReady = mem.init.done() && dummyMemInit.done();
    rule test (!memReady);
        let e = tagged InitDone;
        mem.init.request.put(e);
        dummyMemInit.request.put(e);
    endrule

    rule doFetch if (csrf.started && stage == Fetch);
        mem.req(MemReq{ op: Ld, addr: pc, data: ? });
        stage <= Decode;
    endrule

    rule doDecode if (csrf.started && stage == Decode);
        let inst <- mem.resp();
        let _dInst = decode(inst);

        dInst    <= _dInst;
        rfVal[0] <= rf.rd1(fromMaybe(?, _dInst.src1));
        rfVal[1] <= rf.rd2(fromMaybe(?, _dInst.src2));
        rfVal[2] <= csrf.rd(fromMaybe(?, _dInst.csr));
        stage    <= Execute;
    endrule

    rule doExecute if (csrf.started && stage == Execute);
        let rVal1  = rfVal[0];
        let rVal2  = rfVal[1];
        let csrVal = rfVal[2];

        let _eInst = exec(dInst, rVal1, rVal2, pc, ?, csrVal);

        if (_eInst.iType == Ld) begin
            mem.req(MemReq{op: Ld, addr: _eInst.addr, data: ?});
        end else if (_eInst.iType == St) begin
            mem.req(MemReq{op: St, addr: _eInst.addr, data: _eInst.data});
        end

        if (_eInst.iType == Unsupported) begin
            $fwrite(stderr, "ERROR: Executing unsupported instruction at pc: %x. Exiting\n", pc);
            $finish;
        end

        eInst <= _eInst;
        stage <= WriteBack;
    endrule

    rule doWriteback if (csrf.started && stage == WriteBack);
        let wInst = eInst;
        if (wInst.iType == Ld) begin
            wInst.data <- mem.resp();
        end

        if (isValid(wInst.dst)) begin
            rf.wr(fromMaybe(?, wInst.dst), wInst.data);
        end

        csrf.wr(wInst.iType == Csrw? wInst.csr : Invalid, wInst.data);
        pc <= wInst.brTaken ? wInst.addr : pc + 4;
        stage <= Fetch;
    endrule

    method ActionValue#(CpuToHostData) cpuToHost;
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if (!csrf.started && memReady);
        csrf.start(0);
        $display("Start at pc %h\n", startpc);
	    $fflush(stdout);
        pc <= startpc;
    endmethod

    interface iMemInit = dummyMemInit;
    interface dMemInit = mem.init;
endmodule