# combinational circuits in bluespec
## ripple-carry adder
- Cascade FAs to perform binary addition
### full adder: A one-bit adder
- boolean equations
```txt
t = a ^ b
s = t ^ Cin
Cout = a * b + Cin * t
```
```bsv
function fa(Bit#(1) a, Bit#(1) b, Bit#(1) c_in);
    Bit#(1) t;
    Bit#(1) s;
    Bit#(1) c_out;
    Bit#(2) result;

    t = (a ^ b);
    s = (t ^ c_in);
    c_out = (a & b) | (t & c_in);
    result[0] = s;
    result[1] = c_out;
    return result;
    // return {c_out, s}
    // 这是位连接, 可以避免对中间变量命名
    // c_out 和 s 都是一位，连接后变成两位
endfunction
```
### type checking
- the bluespec compiler checks if all the declared types are user consistently
- the compiler can reduce the programmer's burden by deducing  some types and not asking for explicity type declarations
    - use "let" syntax, 可以根据右边表达式的类型推导出左边表达式的类型
### 2-bit ripple-carry adder
> use fa as a black-box
```bsv
function Bit#(3) add2(Bit#(2) x, Bit#(2) y);
    let s = 2'b00;
    Bit#(3) c = 3'b000;
    c[0] = 0;
    let cs0 = fa(x[0], y[0], c[0]);
    s[0] = cs0[0];
    c[1] = cs0[1];
    let cs1 = fa(x[1], y[1], c[1]);
    s[1] = cs1[0];
    c[2] = cs1[1];
    return {c[2], s};
endfunction
```
### 32-bit ripple adder
> 可以显示的实现 the chain of RCA
> 但是使用 loops 更方便和简洁
```bsv
function Bit#(33) add32(Bit#(32) x, Bit#(32) y, Bit#(1) c0);
    Bit#(32) s = 0;
    Bit#(33) c = 0;
    c[0] = c0;
    for (Integer i = 0; i < 32; i = i + 1) begin
        Bit#(2) cs = fa(x[i], y[i], c[i]);
        c[i+1] = cs[1];
        s[i] = cs[0];
    end
    return {c[32], s}
endfunction
```
#### the gates generated from a loop
- Loop is unfolded by the compiler
    > cs in the loop body is a local variable. hence each of these cs refers to a different value. we could have named them cs0 ... cs31.
- loops to gates
    > unfolded loop defines an acyclic diagram(无环图)
    ```
    |- - -| c[i]|- - -|
    |  FA | --- |  FA | ...
    |- - -|  |  |- - -|
            s[i]
    ```
    > each instance of function fa is replaced by its body
## type in bluespec
- Every expression in a Bluespec program has a type
- A type is a grouping of values, examples
    - Bit#(16) // 16-bit wide bit-vector (16 is a numeric type)
    - Bool // 1-bit value representing True or False
    - Vector#(16,Bit#(8)) // Vector of size 16 containing Bit#(8)’s
- A type declaration can be parameterized by other
types using the syntax ‘#’, for example
    - Bit#(n) represents n bits, e.g., Bit#(8), Bit#(32), ...
    - Tuple2#(Bit#(8), Integer) represents a pair of 8-bitvector and an integer.
    - function Bit#(8) fname (Bit#(8) arg) represents a function
from Bit#(8) to Bit#(8) values
- A type name always begins with a capital letter,
while a variable identifier begins with a small letter
#### neumerated type
1. Suppose we have a variable c whose values can represent three different colors
    - declare the type of c to be Bit#(2) and adopt the convention that 00 -> red 01 -> blue 10 green
2. a better way is to create a new types called color :
    ```
    typedef neum {REd, Blue, Green}
    Color deriving(Bits, Eq);
3. Bluespec compiler automatically assigns a bit representation to the three colors and provides a function to test whether two colors are equal
4. if you do not use "deriving(派生)" then you will have to specify yopur own encoding and equality function
## parameterized circuits
### n-bit ripple-carry adder
```
function Bit#(n+1) addN(Bit#(n) x, Bit#(n) y, Bit#(1) c0);
    Bit#(n) s = 0;
    Bit#(n+1) c = 0;
    c[0] = c0;
    for (Integer i=0; i<n; i=i+1) begin
        let cs = fa(x[i],y[i],c[i]);
        c[i+1] = cs[1];
        s[i] = cs[0];
    end
    return {c[n],s};
endfunction
```
> n is numeric type and Bluespec does not allow arithmetic on types
> 使用 valueOf(n) 修复这个错误
#### valueOf(n) 和 n
- each expression has a type and a value, and these two come from entirely disjoint worlds
- n in Bit#(n) is a numeric type variable and resides in the types world
- Sometimes we need to use values from the types world in actual computation. the function valueOf extracts the integer from a numeric type
    - i < n not type correct
    - i < valueOf(n) is type correct
#### TAdd#(n, 1) versus n+1
- 当需要改变数据类型时，需要使用TAdd#(n, 1) 将信号宽度增加
- n + 1 是用于 value 的计算
所以 parameterized ripple-carry adder 的正确实现应该是:
```
function Bit#(TAdd#(n, 1)) addN(Bit#(n) x, Bit#(n) y, Bit#(1) c0);
    Bit#(n) s = 0;
    Bit#(TAdd#(n, 1)) c = 0;
    c[0] = c0;
    for (Integer i=0; i<valueOf(n); i=i+1) begin
        let cs = fa(x[i],y[i],c[i]);
        c[i+1] = cs[1];
        s[i] = cs[0];
    end
    return {c[valueOf(n)],s};
endfunction
```
### 实例化 n-bit adder
```bsv
function Bit#(33) add32(Bit#(32) x, Bit#(32) y, Bit#(1) c0) = addN(x,y,c0);
function Bit#(4) add3(Bit#(3) x, Bit#(3) y, Bit#(1) c0) = addN(x,y,c0);
```
> bsv 会根据左边参数的位宽自动推断出该泛型函数参数的值