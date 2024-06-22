// Reference functions that use Bluespec's '*' operator
function Bit#(TAdd#(n,n)) multiply_unsigned( Bit#(n) a, Bit#(n) b );
    UInt#(n) a_uint = unpack(a);
    UInt#(n) b_uint = unpack(b);
    UInt#(TAdd#(n,n)) product_uint = zeroExtend(a_uint) * zeroExtend(b_uint);
    return pack( product_uint );
endfunction

function Bit#(TAdd#(n,n)) multiply_signed( Bit#(n) a, Bit#(n) b );
    Int#(n) a_int = unpack(a);
    Int#(n) b_int = unpack(b);
    Int#(TAdd#(n,n)) product_int = signExtend(a_int) * signExtend(b_int);
    return pack( product_int );
endfunction

// Multiplication by repeated addition
function Bit#(TAdd#(n,n)) multiply_by_adding(Bit#(n) a, Bit#(n) b);
	// TODO
	Bit#(n) high = 0;
	Bit#(n) low = 0;
	for (Integer i = 0; i < valueOf(n); i = i + 1)
	begin
		Bit#(TAdd#(1, n)) sum = zeroExtend(high) + zeroExtend((b[i] == '1) ? a : 0);
		low[i] = sum[0];
		high = truncateLSB(sum);
	end

	return {high, low};	
	// Bit#(TAdd#(n, n)) sum = 0;
	// for (Bit#(n) i = 0; i < b; i = i + 1)
	//     begin
	// 	    sum = zeroExtend(a) + sum;
	//     end
	// return sum;
endfunction

// Multiplier Interface
interface Multiplier#( numeric type n );
    method Bool start_ready();
    method Action start( Bit#(n) a, Bit#(n) b );
    method Bool result_ready();
    method ActionValue#(Bit#(TAdd#(n,n))) result();
endinterface


// Folded multiplier by repeated addition
module mkFoldedMultiplier( Multiplier#(n) ) provisos(Add#(1, a__, n)); // make sure n >= 1
	
	// TODO

    // You can use these registers or create your own if you want
	Reg#(Bit#(n)) aReg <- mkRegU;
	Reg#(Bit#(n)) bReg <- mkRegU;
	Reg#(Bit#(n)) low <- mkRegU;
	Reg#(Bit#(n)) high <- mkRegU;
	// 定义 i 的宽度为 log2n 向上取整
	Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg(fromInteger(valueOf(n) + 1));

	rule mul_step(i < fromInteger(valueOf(n)));
		// Bit#(n) mask = i << i;
		Bit#(TAdd#(1, n)) sum = zeroExtend(high) + zeroExtend((bReg[i] == '1) ? aReg : 0);
		// Bit#(TAdd#(1, n)) sum = zeroExtend(high) + zeroExtend(((bReg & mask) != '0) ? aReg : 0);
		low[i] <= sum[0];
		high <= truncateLSB(sum);
		i <= i + 1;
	endrule

	method Bool start_ready();
		// 调用 ActionValue 后表示已经可以重新启动了
		// 返回 i == fromInteger(valueOf(n) + 1) (应该为 true)
		return i == fromInteger(valueOf(n) + 1);
	endmethod

	method Action start( Bit#(n) a, Bit#(n) b ) if (i == fromInteger(valueOf(n) + 1));
		// 在 start_ready 返回 true 后，调用 start 将状态设置为正确的初始值
		aReg <= a;
		bReg <= b;
		i <= 0;
		high <= 0;
		low <= 0;
	endmethod

	method Bool result_ready();
		// 当 i == n 时返回true, 代表结果已经准备好
		return i == fromInteger(valueOf(n));
	endmethod

	method ActionValue#(Bit#(TAdd#(n,n))) result if (i == fromInteger(valueOf(n)));
		// 表示模块已经准备好重新启动
		// 需要 start_ready 返回 true
		i <= i + 1;
		return { high, low };
	endmethod
endmodule



function Bit#(n) arth_shift(Bit#(n) a, Integer n, Bool right_shift);
    Int#(n) a_int = unpack(a);
    if (right_shift) begin
        return  pack(a_int >> n);
    end else begin //left shift
        return  pack(a_int <<n);
    end
endfunction



// Booth Multiplier
module mkBoothMultiplier( Multiplier#(n) )
	provisos(Add#(2, a__, n)); // make sure n >= 2

	// TODO
    // Reg#(Bit#(TAdd#(TAdd#(n,n),1))) m_pos <- mkRegU;
    // Reg#(Bit#(TAdd#(TAdd#(n,n),1))) m_neg <- mkRegU;
    // Reg#(Bit#(TAdd#(TAdd#(n,n),1))) p <- mkRegU;
    // Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg( fromInteger(valueOf(n)+1) );

    // rule mul_step(i < fromInteger(valueOf(n)));
    //     let pr = p[1:0];
    //     Bit#(TAdd#(TAdd#(n,n), 1)) temp = p;

    //     if (pr == 2'b01) begin
    //         temp = p + m_pos;
    //     end

    //     if (pr == 2'b10) begin
    //         temp = p + m_neg;
    //     end

    //     p <= arth_shift(temp, 1, True);
    //     i <= i + 1;
    // endrule

    // method Bool start_ready();
    //     return i == fromInteger(valueOf(n) + 1);
    // endmethod

    // method Action start( Bit#(n) m, Bit#(n) r ) if (i == fromInteger(valueOf(n) + 1));
    //     m_pos <= {m, 0};
    //     m_neg <= {-m, 0};
    //     p <= {0, r, 1'b0};
    //     i <= 0;
    // endmethod

    // method Bool result_ready();
    //     return i == fromInteger(valueOf(n));
    // endmethod

    // method ActionValue#(Bit#(TAdd#(n,n))) result() if (i == fromInteger(valueOf(n)));
    //     i <= i + 1;
    //     return truncateLSB(p);
    // endmethod
endmodule



// Radix-4 Booth Multiplier
module mkBoothMultiplierRadix4( Multiplier#(n) )
	provisos(Mul#(a__, 2, n), Add#(1, b__, a__)); // make sure n >= 2 and n is even

	// TODO
    // Reg#(Bit#(TAdd#(TAdd#(n,n),2))) m_pos <- mkRegU;
    // Reg#(Bit#(TAdd#(TAdd#(n,n),2))) m_neg <- mkRegU;
    // Reg#(Bit#(TAdd#(TAdd#(n,n),2))) p <- mkRegU;
    // Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg( fromInteger(valueOf(n)/2+1) );

    // rule mul_step(i < fromInteger(valueOf(n))/2);
    //     let pr  = p[2:0];
    //     Bit#(TAdd#(TAdd#(n, n), 2)) temp = p;

    //     if ((pr == 3'b001) || (pr == 3'b010)) begin temp = p + m_pos; end
    //     if ((pr == 3'b101) || (pr == 3'b110)) begin temp = p + m_neg; end
    //     if (pr == 3'b011) begin temp = p + arth_shift(m_pos, 1, False); end
    //     if (pr == 3'b100) begin temp = p + arth_shift(m_neg, 1, False); end

    //     p <= arth_shift(temp, 2, True);
    //     i <= i + 1;
    // endrule

    // method Bool start_ready();
    //     return i == fromInteger(valueOf(n)/2 + 1);
    // endmethod

    // method Action start( Bit#(n) m, Bit#(n) r ) if (i == fromInteger(valueOf(n)/2 + 1));
    //     m_pos <= {msb(m), m, 0};
    //     m_neg <= {msb(-m), -m, 0};
    //     p <= {0, r, 1'b0};
    //     i <= 0;
    // endmethod

    // method Bool result_ready();
    //     return i == fromInteger(valueOf(n)/2);
    // endmethod

    // method ActionValue#(Bit#(TAdd#(n,n))) result() if (i == fromInteger(valueOf(n)/2));
    //     i <= i + 1;
    //     return p [(2*valueOf(n)):1];
    // endmethod
endmodule
