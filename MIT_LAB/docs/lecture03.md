# complex combinational circuits i bluespec
## selecting a wire: x[i]
assume x is 4 bits wide
- Constant selector: eg, x[2]
```txt
x0 ---|---------|
x1 ---|         |_____
x2 ---|--------/|
x3 ---|---------|
```
- Dynamic selector: x[i]
```txt
        i |
x0 ---|---------|
x1 ---|         |_____
x2 ---|         |
x3 ---|---------|

4-way mux
    x0 ----|\| i
    x1 ----| |____
    x2 ----| |
    x3 ----|/
```
### multiplexer
#### A 2-way multiplexer
a mux is simple conditional expression
```bsv
result = (p) ? a : b
true -> 1
false -> 0
```
if a and b are b-bit wide then this structure is replicated n times; p is the same input for all the replicated structure
#### A 4-way multiplexer
```bsv
case ({s1, s0})
    2'b00:  a;
    2'b01:  b;
    2'b10:  c;
    2'b11:  d;
endcase
(s1 == 0) & (s0 == 1) is the same writing ~s1&s0
```
n-way mux can be implemented using n-1 two-way muxes
### shift operators
- fixed size shift operation is cheap in hardware
    - just wire the circuit appropriately
- arithmetic is similar logic
#### conditional operation: shift versus no-shift
- We need a mux to select the appropriate wires:
if s is one the mux will select the wires on the
left (shift) otherwise it would select wires on the
right (no-shift)
```verilog
// 32-bit shiftor
module shift(
    input [31:0] shift_a_i,
    input [4:0] shift_b_i,
    input [1:0] shift_op_i,
    output [31:0] shift_o
);

    wire [31:0] x = shift_a_i;
    wire [4:0] y = shift_b_i;
    wire [1:0] fn = shift_op_i;
    wire [31:0] out;
    // shift left
    wire [31:0] Q, R, S, T, SL;

    assign Q = y[4] == 1'b1 ? {x[15:0], {16{1'b0}}} : x;
    assign R = y[3] == 1'b1 ? {Q[23:0], {8{1'b0}}} : Q;
    assign S = y[2] == 1'b1 ? {R[27:0], {4{1'b0}}} : R;
    assign T = y[1] == 1'b1 ? {S[29:0], {2{1'b0}}} : S;
    assign SL = y[0] == 1'b1 ? {T[30:0], {1{1'b0}}} : T;

    // shift right logic
    wire [31:0] Q1, R1, S1, T1, SR;

    assign Q1 = y[4] == 1'b1 ? {{16{1'b0}}, x[31:16]} : x;
    assign R1 = y[3] == 1'b1 ? {{8{1'b0}}, Q1[31:8]} : Q1;
    assign S1 = y[2] == 1'b1 ? {{4{1'b0}}, R1[31:4]} : R1;
    assign T1 = y[1] == 1'b1 ? {{2{1'b0}}, S1[31:2]} : S1;
    assign SR = y[0] == 1'b1 ? {{1{1'b0}}, T1[31:1]} : T1;

    // shift right arithmetic
    wire [31:0] Q2, R2, S2, T2, SA;

    assign Q2 = y[4] == 1'b1 ? {{16{x[31]}}, x[31:16]} : x;
    assign R2 = y[3] == 1'b1 ? {{8{x[31]}}, Q2[31:8]} : Q2;
    assign S2 = y[2] == 1'b1 ? {{4{x[31]}}, R2[31:4]} : R2;
    assign T2 = y[1] == 1'b1 ? {{2{x[31]}}, S2[31:2]} : S2;
    assign SA = y[0] == 1'b1 ? {{1{x[31]}}, T2[31:1]} : T2;

    // Output logic
    /*
    wire [31:0] out_SL, out_SR, out_SA;

    assign out_SL = fn == 2'b00 ? SL : 32'b0;
    assign out_SR = fn == 2'b01 ? SR : 32'b0;
    assign out_SA = fn == 2'b11 ? SA : 32'b0;

    assign out = out_SL | out_SR | out_SA;
    */

    wire [31:0] mux_1, mux_2;
    assign mux_1 = fn[0]    ?   SR  :   SL;
    assign mux_2 = fn[0]    ?   SA  :   32'b0;
    assign out = fn[1]  ?   mux_2   :   mux_1;
    assign shift_o = out;
endmodule
```
#### logical right shift circuit
- define log n shifters f sizes 1, 2, 4, ...
- define log n ,uxes to perform a particular size shift
suppose n = {..., n1, n0} is a n bit number.
```bsv
// 4-bit shift
Bit#(4) input = {a,b,c,d}
Bit#(4) tmp = (s1==1)? {2’b0,a,b}:input;
Bit#(4) output = (s0==1)? {1’b0,tmp[3],tmp[2],tmp[1]}:tmp;
```
#### multiplication by repeated addtion
We also shift the result by
one position at every step
Notice, the first addition is
unnecessary because it
simply yields m0
## combinational IFFT
所有的数都是复数，都表示为两个`16`位的数。减少定点运算的面积和能耗
### 4-way Butterfly Node
```bsv
function Vector#(4, Complex) bfly4
    (Vector#(4,Complex) t, Vector#(4,Complex) x);
```
- twiddle cnefficients 是根据在计算网络中的每个`bfly4`de位置推导出的常数。以便于在不同的位置执行旋转和缩放操作
```
function Vector#(4,Complex#(s)) bfly4
        (Vector#(4,Complex#(s)) t, Vector#(4,Complex#(s)) x);
    Vector#(4,Complex#(s)) m, y, z;
    m[0] = x[0] * t[0]; m[1] = x[1] * t[1];
    m[2] = x[2] * t[2]; m[3] = x[3] * t[3];
    y[0] = m[0] + m[2]; y[1] = m[0] – m[2];
    y[2] = m[1] + m[3]; y[3] = i*(m[1] – m[3]);
    z[0] = y[0] + y[2]; z[1] = y[1] + y[3];
    z[2] = y[0] – y[2]; z[3] = y[1] – y[3];
    return(z);
endfunction
```
> Vector does not mean storage; a vector is just a group of wire with names
> Polymorphic code `多态代码`:
>  works on any type of numbers for which *, + and - have been defined
## sequential assignments
- sometimes it is convenient reassign a veriable (x is zero every where except in bits 4 and 8)
```bsv
Bit#(32) x = 0;
x[4] = 1;   x[8] = 1;
```
- this may result in the introduction of muxes in a circuit
```bsv
Bit#(32) x = 0;
let y = x + 1;
if (p) x = 100;
let z = x + 1;
```
```txt
0---> `+1` ---> y
  |______|0   x
         |  |--- `+1` ---> z
100 -----|1
```
## representing complex numbers as astruct
```bsv
typedef struct {
    Int#(t) r;
    Int#(t) i;
} Complex#(numeric type t) deriving (Eq, Bits)
```
- notice the complex type is parameterized by the size of Int chosen to represent its real and imaginary parts
- if x is a struct then its fields can be selected by writing x.r and x.i
### Complex numbers addtion
```
function Complex#(t) cAdd
    (Complex#(t) x, Complex#(t) y);
    Int#(t) real = x.r + y.r;
    Int#(t) imag = x.i + y.i;
    return (Complex{r:read, i:imag});
endfunction
```
### type classes
- 可以通过`type classes`使用相同的符号表示不同但是相关的操作
- `type classes` 可以将一系列具有相似操作的`type`组合在一起
    - `type classes Arith` requires that each type belong to this class has operators +,-,*,/ etc. defined
- 可以将 `Complex type`声明成`arith type class`的实例
```
instance Arith#(Complex#(t));
function Complex#(t) \+
        (Complex#(t) x, Complex#(t) y);
    Int#(t) real = x.r + y.r;
    Int#(t) imag = x.i + y.i;
    return(Complex{r:real, i:imag});
endfunction
function Complex#(t) \*
        (Complex#(t) x, Complex#(t) y);
    Int#(t) real = x.r*y.r – x.i*y.i;
    Int#(t) imag = x.r*y.i + x.i*y.r;
    return(Complex{r:real, i:imag});
endfunction
// ...
endinstance
// The context allows the compiler to pick the appropriate definition of an operator
```
## Combinational IFFT
> 实现在 6.175 Lab2