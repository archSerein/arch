// six stage

import Types::*;
import ProcTypes::*;
import CMemTypes::*;
import RFile::*;
import Decode::*;
import Exec::*;
import CsrFile::*;
import Vector::*;
import Fifo::*;
import Ehr::*;
import GetPut::*;
import Btb::*;
import Scoreboard::*;
import FPGAMemory::*;

typedef struct {
    Addr        pc;
    Addr        predPc;
    Bool        fetchEpoch;
}   F2D deriving (Bits, Eq);

typedef struct {
    Addr        pc;
    Addr        predPc;
    DecodedInst dInst;
    Bool        decodeEpoch;
}   D2R deriving (Bits, Eq);

typedef struct {
    Addr        pc;
    Addr        predPc;
    Data        rVal1;
    Data        rVal2;
    Data        csrVal;
    DecodedInst rInst;
    Bool        rrfEpoch;
}   R2E deriving (Bits, Eq);

typedef struct {
    Addr                pc;
    Maybe#(ExecInst)    eInst;
}   E2M deriving (Bits, Eq);

typedef struct {
    Addr                pc;
    Maybe#(ExecInst)    mInst;
}   M2W deriving (Bits, Eq);

(* synthesize *)
module mkProc(Proc);
    Ehr#(2, Addr) pcReg <- mkEhr(?);
    RFile            rf <- mkRFile;
	Scoreboard#(6)   sb <- mkCFScoreboard;
    FPGAMemory     iMem <- mkFPGAMemory;
    FPGAMemory     dMem <- mkFPGAMemory;
    CsrFile        csrf <- mkCsrFile;
    Btb#(6)         btb <- mkBtb; // 64-entry BTB

	// global epoch for redirection from Execute stage
	Reg#(Bool)    epoch <- mkReg(False);

	// EHR for redirection
	// Ehr#(2, Maybe#(ExeRedirect)) exeRedirect <- mkEhr(Invalid);

	// FIFO between two stages
    Fifo#(6, F2D)           f2dFifo <- mkCFFifo;
    Fifo#(6, D2R)           d2rFifo <- mkCFFifo;
    Fifo#(6, R2E)           r2eFifo <- mkCFFifo;
    Fifo#(6, E2M)           e2mFifo <- mkCFFifo;
    Fifo#(6, M2W)           m2wFifo <- mkCFFifo;

    Bool memReady = iMem.init.done && dMem.init.done;
    rule test (!memReady);
        let e = tagged InitDone;
        iMem.init.request.put(e);
        dMem.init.request.put(e);
    endrule

    rule doFetch if (csrf.started);
        iMem.req(MemReq{op:Ld, addr: pcReg[0], data: ?});
        Addr predPc = btb.predPc(pcReg[0]);

        f2dFifo.enq(F2D{pc: pcReg[0], predPc: predPc, fetchEpoch: epoch});
        pcReg[0] <= predPc;
        $display("pc: %h, ppc: %h", pcReg[0], predPc);
    endrule

    rule doDecode if (csrf.started);
        let inst <- iMem.resp();
        DecodedInst dInst = decode(inst);

        let _Fetch = f2dFifo.first();
        $display("pc: %h, inst: %h extended: ", _Fetch.pc, inst, fshow(dInst));
        d2rFifo.enq(D2R{pc: _Fetch.pc, predPc: _Fetch.predPc, dInst: dInst,
                        decodeEpoch: _Fetch.fetchEpoch});
        f2dFifo.deq();
    endrule

    rule doRrf if (csrf.started);
        let _Decode = d2rFifo.first();
        let rInst   = _Decode.dInst;

        // search scoreboard to determine stall
        if (!sb.search1(rInst.src1) && !sb.search2(rInst.src2)) begin
            Data    rVal1 = rf.rd1(fromMaybe(?, rInst.src1));
            Data    rVal2 = rf.rd2(fromMaybe(?, rInst.src2));
            Data    csrVal= csrf.rd(fromMaybe(?, rInst.csr));

            $display("RegFile: PC = %x, rVal1 = %x, rVal2 = %x, csrVal = %x", _Decode.pc, rVal1, rVal2, csrVal);
            r2eFifo.enq(R2E{pc: _Decode.pc, predPc: _Decode.predPc, rVal1: rVal1, rVal2: rVal2, csrVal: csrVal,
                            rInst: rInst, rrfEpoch: _Decode.decodeEpoch});
            sb.insert(rInst.dst);
            d2rFifo.deq();
        end else begin
            $display("Stall at pc: %x.", _Decode.pc);
        end
    endrule

    rule doExec if (csrf.started);
        let _Rrf = r2eFifo.first();
        r2eFifo.deq();

        if (epoch == _Rrf.rrfEpoch) begin
            ExecInst eInst = exec(_Rrf.rInst, _Rrf.rVal1, _Rrf.rVal2, _Rrf.pc, _Rrf.predPc, _Rrf.csrVal);
            // check unsupported instruction at commit time. Exiting
            if (eInst.iType == Unsupported) begin
                $fwrite(stderr,"ERROR: Executing unsupported instruction at pc: %x. Exiting\n", _Rrf.pc);
                $finish;
                end
            // if (eInst.iType == J || eInst.iType == Jr || eInst.iType == Br) begin
            //     // update the branch predictor
            //     btb.update(_Rrf.pc, eInst.addr);
            // end
            if (eInst.mispredict) begin
                // 更新 epoch
                // redirection
                // 移除此时处于 Rrf 级向计分板写入的数据
                epoch <= !epoch;
                pcReg[1] <= eInst.addr;
                btb.update(_Rrf.pc, eInst.addr);
                $display("Exec: mispredict ppc: %h, real pc: %h", _Rrf.predPc, eInst.addr);
            end else begin
                btb.update(_Rrf.pc, _Rrf.predPc);
                $display("Exec: pc: %h", _Rrf.pc);
            end

            e2mFifo.enq(E2M{pc: _Rrf.pc, eInst: tagged Valid eInst});
        end else begin
            e2mFifo.enq(E2M{pc: _Rrf.pc, eInst: tagged Invalid});
            $display("has been redirection");
        end
    endrule

    rule doMemory if (csrf.started);
        let _Exec = e2mFifo.first();
        e2mFifo.deq();

        if (isValid(_Exec.eInst)) begin
            let _eInst = fromMaybe(?, _Exec.eInst);
            if (_eInst.iType == Ld) begin
                dMem.req(MemReq{op: Ld, addr: _eInst.addr, data: ?});
            end else if (_eInst.iType == St) begin
                dMem.req(MemReq{op: St, addr: _eInst.addr, data: _eInst.data});
            end
            $display("doMemory: pc: %h", _Exec.pc);

            m2wFifo.enq(M2W{pc: _Exec.pc, mInst: tagged Valid _eInst});
        end else begin
            m2wFifo.enq(M2W{pc: _Exec.pc, mInst: tagged Invalid});
        end
    endrule

    rule doWriteback if (csrf.started);
        let _Mem = m2wFifo.first();
        m2wFifo.deq();

        if (isValid(_Mem.mInst)) begin
            let _mInst = fromMaybe(?, _Mem.mInst);
            if (_mInst.iType == Ld) begin
                _mInst.data <- dMem.resp();
            end

            // write back
            if (isValid(_mInst.dst)) begin
                rf.wr(fromMaybe(?, _mInst.dst), _mInst.data);
            end

            // CSR write for sending data to host & stats
            csrf.wr(_mInst.iType == Csrw ? _mInst.csr : Invalid, _mInst.data);
            $display("doWriteback: pc: %h, data: %h", _Mem.pc, _mInst.data);
        end else begin
            $display("Invalid mInst");
        end
        sb.remove();
    endrule

    method ActionValue#(CpuToHostData) cpuToHost;
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !csrf.started && memReady );
		csrf.start(0); // only 1 core, id = 0
		$display("Start at pc %h\n", startpc);
		// $fflush(stdout);
        pcReg[0] <= startpc;
    endmethod

	interface iMemInit = iMem.init;
    interface dMemInit = dMem.init;
endmodule