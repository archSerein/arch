// OneCycle.bsv
//
// This is a one cycle implementation of the RISC-V processor.

import Types::*;
import ProcTypes::*;
import MemTypes::*;
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

Bit#(2) userMod     = 2'b00;
Bit#(2) machineMod  = 2'b11;
Bit#(1) iEDisable   = 1'b0;
Bit#(1) iEEnable    = 1'b1;

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr) pc <- mkRegU;
    RFile      rf <- mkRFile;
    IMemory  iMem <- mkIMemory;
    DMemory  dMem <- mkDMemory;
    CsrFile  csrf <- mkCsrFile;

    Bool memReady = iMem.init.done() && dMem.init.done();
    rule test (!memReady);
	    let e = tagged InitDone;
	    iMem.init.request.put(e);
	    dMem.init.request.put(e);
    endrule

    rule doProc(csrf.started);
        Data inst = iMem.req(pc);

        // decode
        DecodedInst dInst = decode(inst, csrf.getMstatus[2:1] == userMod);

        // read general purpose register values 
        // Data rVal1 = rf.rd1(fromMaybe(?, dInst.src1));
        Data rVal1 = rf.rd1(fromMaybe(?, dInst.src1));
        Data rVal2 = rf.rd2(fromMaybe(?, dInst.src2));

        // read CSR values (for CSRR inst)
        Data csrVal = csrf.rd(fromMaybe(?, dInst.csr));

        // execute
        ExecInst eInst = exec(dInst, rVal1, rVal2, pc, ?, csrVal);  
		// The fifth argument above is the predicted pc, to detect if it was mispredicted. 
		// Since there is no branch prediction, this field is sent with a random value

        // memory
        if(eInst.iType == Ld) begin
            eInst.data <- dMem.req(MemReq{op: Ld, addr: eInst.addr, data: ?});
        end else if(eInst.iType == St) begin
            let d <- dMem.req(MemReq{op: St, addr: eInst.addr, data: eInst.data});
        end

		// commit

        // trace - print the instruction
        $display("pc: %h inst: (%h) expanded: ", pc, inst, showInst(inst));

        // check nopermission instruction at  commit time. Exiting
        if (eInst.iType == NoPermission) begin
            $fwrite(stderr, "ERROR: Executing nopermission instruction at pc: %x, inst: %x. Exiting\n", 
                        pc, inst);
            $finish;
        end
        // check unsupported instruction at commit time. Exiting
        else if(eInst.iType == Unsupported) begin
            let newStatus   = csrf.getMstatus << 3;
            newStatus[2:1]  = machineMod;
            newStatus[0]    = iEDisable; 
            csrf.startExcep(pc, 32'h02, newStatus);
        end else if (eInst.iType==ECall) begin
            let newStatus   = csrf.getMstatus << 3;
            newStatus[2:1]  = machineMod;
            newStatus[0]    = iEDisable; 
            csrf.startExcep(pc, 32'h08, newStatus);
        end else if ( eInst.iType == ERet) begin
            let newStatus   = csrf.getMstatus >> 3;
            newStatus[11:10]= userMod;
            newStatus[9]    = iEEnable;
            csrf.eret(newStatus);
        end else begin
            // write back to reg file
            if(isValid(eInst.dst)) begin
                rf.wr(fromMaybe(?, eInst.dst), eInst.data);
            end
            // CSR write for sending data to host & stats
            csrf.wr(eInst.iType == Csrrw ? eInst.csr : Invalid, eInst.data);
        end

        // update the pc depending on whether the branch is taken or not
        if (eInst.iType == ECall || eInst.iType == Unsupported) begin
            pc <= csrf.getMtvec;
        end else if (eInst.iType == ERet) begin
            pc <= csrf.getMepc;
        end else begin
            pc <= eInst.brTaken ? eInst.addr : pc + 4;
        end

    endrule

    method ActionValue#(CpuToHostData) cpuToHost;
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !csrf.started && memReady );
        csrf.start(0); // only 1 core, id = 0
	    $display("Start at pc 200\n");
        pc <= startpc;
    endmethod

    interface iMemInit = iMem.init;
    interface dMemInit = dMem.init;
endmodule

