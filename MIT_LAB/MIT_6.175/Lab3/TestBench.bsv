import TestBenchTemplates::*;
import Vector::*;
import LFSR::*;
import Multipliers::*;

// Example testbenches
(* synthesize *)
module mkTbDumb();
    function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_unsigned( a, b );
    function Bit#(16) ref_function( Bit#(8) a, Bit#(8) b ) = multiply_unsigned( a, b );
    Empty tb <- mkTbMulFunction(test_function, ref_function, True);
    return tb;
endmodule

(* synthesize *)
module mkTbFoldedMultiplier();
    Multiplier#(8) dut <- mkFoldedMultiplier();
    Empty tb <- mkTbMulModule(dut, multiply_signed, True);
    return tb;
endmodule

(* synthesize *)
module mkTbSignedVsUnsigned();
    // function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_signed( a, b );
    // Empty tb <- mkTbMulFunction(test_function, multiply_unsigned, True);
    // return tb;
        Reg#(int) cnt <- mkReg(0);
	let max_cnt = 512;

	Reg#(Bit#(8)) val1 <- mkReg(105);
	Reg#(Bit#(8)) val2 <- mkReg(115);
	rule counter;
        	let cnt_next = cnt + 1;
		cnt <= cnt_next;
		if (cnt_next == max_cnt) begin
			$finish;
		end
        endrule

	rule feed_and_check;
                let unsigned_result = multiply_unsigned(val1, val2);
		let signed_result = multiply_signed(val1, val2);
		if (signed_result != unsigned_result) begin
			$display("neq: %d * %d = %d (unsigned) != %d (signed)", val1, val2, unsigned_result, signed_result);
		end
		else begin
			$display("OK: %d * %d = %d (unsigned) == %d (signed)", val1, val2, unsigned_result, signed_result);
		end
		val1 <= val1 + 1;
		val2  <= val2 + 1;
	endrule

endmodule

(* synthesize *)
module mkTbEx3();
    function Bit#(16) func(Bit#(8) a, Bit#(8) b) = multiply_by_adding(a, b);
    Empty tb <- mkTbMulFunction(func, multiply_unsigned, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx5();
    Multiplier#(8) mod <- mkFoldedMultiplier();
    Empty tb <- mkTbMulModule(mod, multiply_by_adding(), True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx7a();
    Multiplier#(8) mod <- mkBoothMultiplier();
    Empty tb <- mkTbMulModule(mod, multiply_signed, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx7b();
    Multiplier#(16) mod <- mkBoothMultiplier();
    Empty tb <- mkTbMulModule(mod, multiply_signed, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx9a();
    Multiplier#(32) mod <- mkBoothMultiplierRadix4();
    Empty tb <- mkTbMulModule(mod, multiply_signed, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx9b();
    Multiplier#(64) mod <- mkBoothMultiplierRadix4();
    Empty tb <- mkTbMulModule(mod, multiply_signed, True);
    return tb;
endmodule
