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
import Bht::*;

import Memory::*;
import SimMem::*;
import ClientServer::*;
import CacheTypes::*;
import WideMemInit::*;
import MemUtil::*;
import Cache::*;

typedef struct {
    Addr        pc;
    Addr        predPc;
    Bool        ifExeEpoch;
    Bool        ifDecodeEpoch;
    Bool        ifRrfEpoch;
}   F2D deriving (Bits, Eq);

typedef struct {
    Addr        pc;
    Addr        predPc;
    DecodedInst dInst;
    Bool        idExeEpoch;
    Bool        idRrfEpoch;
}   D2R deriving (Bits, Eq);

typedef struct {
    Addr        pc;
    Addr        predPc;
    Data        rVal1;
    Data        rVal2;
    Data        csrVal;
    DecodedInst rInst;
    Bool        irExeEpoch;
}   R2E deriving (Bits, Eq);

typedef struct {
    Addr                pc;
    Maybe#(ExecInst)    eInst;
}   E2M deriving (Bits, Eq);

typedef struct {
    Addr                pc;
    Maybe#(ExecInst)    mInst;
}   M2W deriving (Bits, Eq);

// (* synthesize *)
module mkProc#(Fifo#(2,DDR3_Req) ddr3ReqFifo, Fifo#(2,DDR3_Resp) ddr3RespFifo)(Proc);
    Ehr#(4, Addr) pcReg <- mkEhr(?);
    RFile            rf <- mkRFile;
	Scoreboard#(6)   sb <- mkCFScoreboard;
    CsrFile        csrf <- mkCsrFile;
    Btb#(6)         btb <- mkBtb; // 64-entry BTB
    Bht#(8)         bht <- mkBht;

	// global epoch for redirection from Execute stage
	Reg#(Bool)    exeEpoch      <- mkReg(False);
    Reg#(Bool)    decodeEpoch   <- mkReg(False);
    Reg#(Bool)    rrfEpoch      <- mkReg(False);

    Vector#(8, Ehr#(2, Data))  ras <- replicateM(mkEhr(0));
    Ehr#(2, Bit#(TLog#(8)))    index <- mkEhr(0);
	// EHR for redirection
	// Ehr#(2, Maybe#(ExeRedirect)) exeRedirect <- mkEhr(Invalid);

	// FIFO between two stages
    Fifo#(2, F2D)           f2dFifo <- mkCFFifo;
    Fifo#(2, D2R)           d2rFifo <- mkCFFifo;
    Fifo#(2, R2E)           r2eFifo <- mkCFFifo;
    Fifo#(2, E2M)           e2mFifo <- mkCFFifo;
    Fifo#(2, M2W)           m2wFifo <- mkCFFifo;

    Bool memReady = True;

	// wrap DDR3 to WideMem interface
    WideMem           wideMemWrapper <- mkWideMemFromDDR3( ddr3ReqFifo, ddr3RespFifo );
    // split WideMem interface to two (use it in a multiplexed way) 
    // This spliter only take action after reset (i.e. memReady && csrf.started)
    // otherwise the guard may fail, and we get garbage DDR3 resp
	Vector#(2, WideMem)     wideMems <- mkSplitWideMem( memReady && csrf.started, wideMemWrapper );
	// Instruction cache should use wideMems[1]
	// Data cache should use wideMems[0]

    Cache          iMem <- mkCache(wideMems[1]);
    Cache          dMem <- mkCache(wideMems[0]);

	// some garbage may get into ddr3RespFifo during soft reset
	// this rule drains all such garbage
	rule drainMemResponses( !csrf.started );
		ddr3RespFifo.deq;
	endrule

    rule doFetch if (csrf.started);
        iMem.req(MemReq{op:Ld, addr: pcReg[0], data: ?});
        Addr predPc = btb.predPc(pcReg[0]);

        f2dFifo.enq(F2D{pc: pcReg[0], predPc: predPc, ifExeEpoch: exeEpoch,
                        ifDecodeEpoch: decodeEpoch, ifRrfEpoch: rrfEpoch});
        pcReg[0] <= predPc;
        $display("pc: %h, ppc: %h", pcReg[0], predPc);
    endrule

    rule doDecode if (csrf.started);
        let inst <- iMem.resp();
        DecodedInst dInst = decode(inst);

        let _Fetch = f2dFifo.first();

        if (decodeEpoch == _Fetch.ifDecodeEpoch && exeEpoch == _Fetch.ifExeEpoch && 
                rrfEpoch == _Fetch.ifRrfEpoch) begin
            Addr    ppc;
            if (dInst.iType == Br) begin
                ppc = bht.ppcDP(_Fetch.pc, fromMaybe(?, dInst.imm) + _Fetch.pc);
            end else if (dInst.iType == J) begin
                ppc = fromMaybe(?, dInst.imm) + _Fetch.pc;
                if (fromMaybe(?, dInst.dst) == 1) begin
                    ras[index[0]][0] <= _Fetch.pc + 4;
                    index[0] <= index[0] + 1;
                end
            end else begin
                ppc = _Fetch.predPc;
            end
            if (ppc != _Fetch.predPc) begin
                decodeEpoch <= !decodeEpoch;
                pcReg[1] <= ppc;
            end
            $display("pc: %h, inst: %h extended: ", _Fetch.pc, inst, fshow(dInst));
            d2rFifo.enq(D2R{pc: _Fetch.pc, predPc: ppc, dInst: dInst,
                            idExeEpoch: _Fetch.ifExeEpoch, idRrfEpoch: _Fetch.ifRrfEpoch});
        end
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

            if (rrfEpoch == _Decode.idRrfEpoch && exeEpoch == _Decode.idExeEpoch) begin
                Addr    ppc;
                if (rInst.iType == Jr) begin
                    if (fromMaybe(?, rInst.src1) == 1 && fromMaybe(?, rInst.dst) == 0) begin
                        ppc = ras[index[1]-1][1];
                        index[1] <= index[1] - 1;
                    end else begin
                        ppc = rVal1 + fromMaybe(?, rInst.imm);
                        if (fromMaybe(?, rInst.dst) == 1) begin
                            ras[index[1]][1] <= _Decode.pc + 4;
                            index[1] <= index[1] + 1;
                        end
                    end
                end else begin
                    ppc = _Decode.predPc;
                end
                if (ppc != _Decode.predPc) begin
                    rrfEpoch <= !rrfEpoch;
                    pcReg[2] <= ppc;
                end
                $display("RegFile: PC = %x, rVal1 = %x, rVal2 = %x, csrVal = %x", _Decode.pc, rVal1, rVal2, csrVal);
                r2eFifo.enq(R2E{pc: _Decode.pc, predPc: ppc, rVal1: rVal1, rVal2: rVal2, csrVal: csrVal,
                                rInst: rInst, irExeEpoch: _Decode.idExeEpoch});
                sb.insert(rInst.dst);
            end
            d2rFifo.deq();
        end else begin
            $display("Stall at pc: %x.", _Decode.pc);
        end
    endrule

    rule doExec if (csrf.started);
        let _Rrf = r2eFifo.first();
        r2eFifo.deq();

        if (exeEpoch == _Rrf.irExeEpoch) begin
            ExecInst eInst = exec(_Rrf.rInst, _Rrf.rVal1, _Rrf.rVal2, _Rrf.pc, _Rrf.predPc, _Rrf.csrVal);
            // check unsupported instruction at commit time. Exiting
            if (eInst.iType == Unsupported) begin
                $fwrite(stderr,"ERROR: Executing unsupported instruction at pc: %x. Exiting\n", _Rrf.pc);
                $finish;
                end
            if (eInst.iType == J || eInst.iType == Br) begin
                // update the branch predictor
                bht.update(_Rrf.pc, eInst.brTaken);
            end
            if (eInst.mispredict) begin
                // 更新 exeEpoch
                // redirection
                // 移除此时处于 Rrf 级向计分板写入的数据
                exeEpoch <= !exeEpoch;
                pcReg[3] <= eInst.addr;
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
            $display("doWriteback: pc: %h, addr: %d data: %h", _Mem.pc, fromMaybe(?, _mInst.dst), _mInst.data);
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

endmodule