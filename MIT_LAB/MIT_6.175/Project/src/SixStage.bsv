import Types::*;
import ProcTypes::*;
import MemTypes::*;
import RFile::*;
import Decode::*;
import Exec::*;
import CsrFile::*;
import Fifo::*;
import Ehr::*;
import Btb::*;
import Scoreboard::*;
import Bht::*;
import GetPut::*;
import ClientServer::*;
import Memory::*;
import ICache::*;
import DCache::*;
import CacheTypes::*;
import WideMemInit::*;
import MemUtil::*;
import Vector::*;
import FShow::*;
import MemReqIDGen::*;
import RefTypes::*;
import MessageFifo::*;

typedef struct {
    Addr        pc;
    Addr        predPc;
    Bool        ifExeEpoch;
    Bool        ifDecodeEpoch;
}   F2D deriving (Bits, Eq);

typedef struct {
    Addr        pc;
    Addr        predPc;
    DecodedInst dInst;
    Bool        idExeEpoch;
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

module mkCore(
    CoreID id,
    WideMem iMem,
    RefDMem refDMem,
    Core ifc
);

    Ehr#(2, Addr)         pcReg <- mkEhr(?);
    CsrFile                csrf <- mkCsrFile(id);
    RFile                    rf <- mkRFile;
    MemReqIDGen     memReqIDGen <- mkMemReqIDGen;
    ICache               iCache <- mkICache(iMem);
    MessageFifo#(8)   toParentQ <- mkMessageFifo;
    MessageFifo#(8) fromParentQ <- mkMessageFifo;
    DCache               dCache <- mkDCache(id, toMessageGet(fromParentQ), toMessagePut(toParentQ), refDMem);
    Btb#(6)                 btb <- mkBtb; // 64-entry BTB
    Bht#(8)                 bht <- mkBht;
	Scoreboard#(6)           sb <- mkCFScoreboard;

	// global epoch for redirection from Execute stage
	Reg#(Bool)    exeEpoch    <- mkReg(False);
	Reg#(Bool)    decodeEpoch <- mkReg(False);
    Reg#(Data)    scSuccValue <- mkRegU;

    Fifo#(2, F2D)           f2dFifo <- mkCFFifo;
    Fifo#(2, D2R)           d2rFifo <- mkCFFifo;
    Fifo#(2, R2E)           r2eFifo <- mkCFFifo;
    Fifo#(2, E2M)           e2mFifo <- mkCFFifo;
    Fifo#(2, M2W)           m2wFifo <- mkCFFifo;

    rule doFetch (csrf.started);
        iCache.req(pcReg[0]);
        Addr predPc = btb.predPc(pcReg[0]);

        f2dFifo.enq(F2D{pc: pcReg[0], predPc: predPc, ifExeEpoch: exeEpoch,
                        ifDecodeEpoch: decodeEpoch});
        pcReg[0] <= predPc;
        // $display("pc: %h, ppc: %h", pcReg[0], predPc);
    endrule

    rule doDecode (csrf.started);
        let inst <- iCache.resp();
        DecodedInst dInst = decode(inst);

        let _Fetch = f2dFifo.first();
        if (decodeEpoch == _Fetch.ifDecodeEpoch && exeEpoch == _Fetch.ifExeEpoch) begin
            Addr    ppc;
            if (dInst.iType == Br) begin
                ppc = bht.ppcDP(_Fetch.pc, fromMaybe(?, dInst.imm) + _Fetch.pc);
            end else if (dInst.iType == J) begin
                ppc = fromMaybe(?, dInst.imm) + _Fetch.pc;
            end else begin
                ppc = _Fetch.predPc;
            end
            if (ppc != _Fetch.predPc) begin
                decodeEpoch <= !decodeEpoch;
                pcReg[1] <= ppc;
            end

            // $display("pc: %h, inst: %h extended: ", _Fetch.pc, inst, fshow(dInst));
            d2rFifo.enq(D2R{pc: _Fetch.pc, predPc: ppc, dInst: dInst,
                        idExeEpoch: _Fetch.ifExeEpoch});
        end
        f2dFifo.deq();
    endrule

    rule doRrf (csrf.started);
        let _Decode = d2rFifo.first();
        let rInst   = _Decode.dInst;

        // search scoreboard to determine stall
        if (!sb.search1(rInst.src1) && !sb.search2(rInst.src2)) begin
            Data    rVal1 = rf.rd1(fromMaybe(?, rInst.src1));
            Data    rVal2 = rf.rd2(fromMaybe(?, rInst.src2));
            Data    csrVal= csrf.rd(fromMaybe(?, rInst.csr));

            // $display("RegFile: PC = %x, rVal1 = %x, rVal2 = %x, csrVal = %x", _Decode.pc, rVal1, rVal2, csrVal);
            r2eFifo.enq(R2E{pc: _Decode.pc, predPc: _Decode.predPc, rVal1: rVal1, rVal2: rVal2, csrVal: csrVal,
                            rInst: rInst, irExeEpoch: _Decode.idExeEpoch});
            sb.insert(rInst.dst);
            d2rFifo.deq();
        end
    endrule

    rule doExec (csrf.started);
        let _Rrf = r2eFifo.first();
        r2eFifo.deq();

        if (exeEpoch == _Rrf.irExeEpoch) begin
            ExecInst eInst = exec(_Rrf.rInst, _Rrf.rVal1, _Rrf.rVal2, _Rrf.pc, _Rrf.predPc, _Rrf.csrVal);
            // check unsupported instruction at commit time. Exiting
            if (eInst.iType == Unsupported) begin
                $fwrite(stderr,"ERROR: Executing unsupported instruction at pc: %x. Exiting\n", _Rrf.pc);
                $finish;
                end
            if (eInst.mispredict) begin
                // 更新 epoch
                // redirection
                // 移除此时处于 Rrf 级向计分板写入的数据
                exeEpoch <= !exeEpoch;
                pcReg[1] <= eInst.addr;
                btb.update(_Rrf.pc, eInst.addr);
                // $display("Exec: mispredict ppc: %h, real pc: %h", _Rrf.predPc, eInst.addr);
            end else begin
                btb.update(_Rrf.pc, _Rrf.predPc);
                // $display("Exec: pc: %h", _Rrf.pc);
            end

            e2mFifo.enq(E2M{pc: _Rrf.pc, eInst: tagged Valid eInst});
        end else begin
            e2mFifo.enq(E2M{pc: _Rrf.pc, eInst: tagged Invalid});
        end
    endrule

    rule doMemory (csrf.started);
        let _Exec = e2mFifo.first();
        e2mFifo.deq();

        if (isValid(_Exec.eInst)) begin
            let _eInst = fromMaybe(?, _Exec.eInst);
            case (_eInst.iType)
                Ld: begin
                    let rid <- memReqIDGen.getID;
                    let req = MemReq { op: Ld, addr: _eInst.addr, data: ?, rid: rid };
                    dCache.req(req);
                end
                St: begin
                    let rid <- memReqIDGen.getID;
                    let req = MemReq { op: St, addr: _eInst.addr, data: _eInst.data, rid: rid };
                    scSuccValue <= _eInst.data;
                    dCache.req(req);
                end
                Lr: begin
                    let rid <- memReqIDGen.getID;
                    let req = MemReq { op: Lr, addr: _eInst.addr, data: ?, rid: rid };
                    dCache.req(req);
                end
                Sc: begin
                    let rid <- memReqIDGen.getID;
                    let req = MemReq { op: Sc, addr: _eInst.addr, data: _eInst.data, rid: rid };
                    dCache.req(req);
                end
                Fence: begin
                    let rid <- memReqIDGen.getID;
                    let req = MemReq { op: Fence, addr: ?, data: ?, rid: rid };
                    dCache.req(req);
                end
                default: begin
                end
            endcase
            // $display("doMemory: pc: %h", _Exec.pc);

            m2wFifo.enq(M2W{pc: _Exec.pc, mInst: tagged Valid _eInst});
        end else begin
            m2wFifo.enq(M2W{pc: _Exec.pc, mInst: tagged Invalid});
        end
    endrule

    rule doWriteback (csrf.started);
        let _Mem = m2wFifo.first();
        m2wFifo.deq();

        if (isValid(_Mem.mInst)) begin
            let _mInst = fromMaybe(?, _Mem.mInst);
            if (_mInst.iType == Ld || _mInst.iType == Lr ||
                _mInst.iType == Sc) begin
                _mInst.data <- dCache.resp();
            end

            // write back
            if (isValid(_mInst.dst)) begin
                rf.wr(fromMaybe(?, _mInst.dst), _mInst.data);
            end

            // CSR write for sending data to host & stats
            csrf.wr(_mInst.iType == Csrw ? _mInst.csr : Invalid, _mInst.data);
        end
        sb.remove();
    endrule

    interface MessageGet toParent = toMessageGet(toParentQ);
    interface MessagePut fromParent = toMessagePut(fromParentQ);

    method ActionValue#(CpuToHostData) cpuToHost if (csrf.started);
        let ret <- csrf.cpuToHost;
        return ret;
    endmethod

    method Bool cpuToHostValid = csrf.cpuToHostValid;

    method Action hostToCpu(Bit#(32) startpc) if (!csrf.started);
        csrf.start;
        pcReg[0] <= startpc;
    endmethod
endmodule
