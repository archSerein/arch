// TwoCycle.bsv
//
// This is a two cycle implementation of the SMIPS processor.

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

typedef enum {Fetch, Execute} Stage deriving (Bits, Eq, FShow);

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr) pc <- mkRegU;
    RFile      rf <- mkRFile;
    // IMemory   imem <- mkIMemory;
    DMemory   mem <- mkDMemory;
    CsrFile  csrf <- mkCsrFile;

    Bool memReady = mem.init.done();

    // TODO: Complete the implementation of this processor

    rule test (!memReady);
        let e = tagged InitDone;
        mem.init.request.put(e);
    endrule

    Reg#(Stage) stage <- mkReg(Fetch);
    Reg#(DecodedInst) dInst <- mkRegU;
    Reg#(Data)      fetchInst <- mkRegU;

    rule doFetch if (csrf.started && stage == Fetch);
        Data inst <- mem.req(MemReq{op: Ld, addr: pc, data: ?});
        // decode
        fetchInst <= inst;
        dInst <= decode(inst);
        stage <= Execute;
        // trace - print the instruction
        $display("pc=%h inst=%h expanded=", pc, inst, showInst(inst));
        $fflush(stdout);
    endrule

    rule deExec if(csrf.started && stage == Execute);
        // read registers
        Data rVal1 = rf.rd1(fromMaybe(?, dInst.src1));
        Data rVal2 = rf.rd2(fromMaybe(?, dInst.src2));

        // read CSR values
        Data csrVal = csrf.rd(fromMaybe(?, dInst.csr));

        // Execute
        ExecInst eInst = exec(dInst, rVal1, rVal2, pc, ?, csrVal);
        // The fifth argument above is the predicted pc, to detect if it was mispredicted. 
	    //ce there is no branch prediction, this field is sent with a random value

        // check unsupported instruction at commit time. Exiting
        if(eInst.iType == Unsupported) begin
            $fwrite(stderr, "ERROR: Executing unsupported instruction at pc: %x inst: %x. Exiting\n", pc, fetchInst);
            $finish;
        end

        // memory
        if (eInst.iType == Ld) begin
            eInst.data <- mem.req(MemReq{op: Ld, addr: eInst.addr, data: ?});
        end else if (eInst.iType == St) begin
            let d <- mem.req(MemReq{op: St, addr: eInst.addr, data: eInst.data});
        end

        // write back
        if (isValid(eInst.dst)) begin
            rf.wr(fromMaybe(?, eInst.dst), eInst.data);
        end

        // update pc
        pc <= eInst.brTaken ? eInst.addr : pc + 4;

        // CSR write for sending data to host & stats
        csrf.wr(eInst.iType == Csrw ? eInst.csr : Invalid, eInst.data);
        stage <= Fetch;
    endrule

    method ActionValue#(CpuToHostData) cpuToHost;
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !csrf.started && memReady );
        csrf.start(0); // only 1 core, id = 0
        $display("Start at pc 200\n");
	    $fflush(stdout);
        pc <= startpc;
    endmethod

    interface MemInit iMemInit = mem.init;
    interface MemInit dMemInit = mem.init;
endmodule



