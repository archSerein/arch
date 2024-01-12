import Multiplexer::*;

function Bit#(1) fa_sum(Bit#(1) a, Bit#(1) b, Bit#(1) c);
    return a ^ b ^ c;
endfunction

function Bit#(1) fa_carry(Bit#(1) a, Bit#(1) b, Bit#(1) c);
    return (a&b) | (a&c) | (b&c);
endfunction

// Exercise 4
// 使用提供的全加器的两个模块，构成4bit行波进位加法器
// 低位的进位位作为高位的cin

function Bit#(5) add4(Bit#(4) a, Bit#(4) b, Bit#(1) cin);
    Bit#(4) sum;
    Bit#(5) c = 0;
    c[0] = cin;
    for(Integer i = 0; i < 4; i = i + 1)
    begin
        sum[i] = fa_sum(a[i], b[i], c[i]);
        c[i+1] = fa_carry(a[i], b[i], c[i]);
    end
    return {c[4], sum};
endfunction

// 加法器是作为模块而不是函数实现的，并且加入了接口；通过使用模块，多个源可以使用相同的8位加法器
interface Adder8;
    method ActionValue#(Bit#(9)) sum(Bit#(8) a,Bit#(8) b, Bit#(1) c_in);
endinterface

module mkRCAdder(Adder8);
    method ActionValue#(Bit#(9)) sum(Bit#(8) a,Bit#(8) b,Bit#(1) c_in);
        let low = add4(a[3:0], b[3:0], c_in);
        let high = add4(a[7:4], b[7:4], low[4]);
        return { high, low[3:0] };
    endmethod
endmodule

// Exercise 5
// 实现8bit进位选择加法器
module mkCSAdder(Adder8);
    method ActionValue#(Bit#(9)) sum(Bit#(8) a,Bit#(8) b, Bit#(1) c_in);
        Bit#(1) c;
        Bit#(4) sum_low;
        Bit#(4) sum_high;
        let low = add4(a[3:0], b[3:0], c_in);
        let high0 = add4(a[7:4], b[7:4], 0);
        let high1 = add4(a[7:4], b[7:4], 1);
        sum_low = low[3:0];
        sum_high = multiplexer_n(low[4], high0[3:0], high1[3:0]);
        c = multiplexer1(low[4], high0[4], high1[4]);
        return { c, sum_high, sum_low };
    endmethod
endmodule
