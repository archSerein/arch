# folded and pipelined sequential circuits
## expressing a loop using registers
```c
int s = s0;
while (p(s)) {
    s = f(s);
}
return s;
```
- such a loop cannot be implemented by unfolding because the number of iterations is input-data dependent
- A register is needed to hold the value of s form one iteration to the next
- s hax to be initialized whnee the computation starts, and updated every cycle until the computation terminates
## expressing a loop in bsv
```bsv
Reg#(n) s <- mkRegU();
rule step;
    if (p(s)) s <- f(s);
endrule
```
- when a rule executes:
    - the register s is read at the beginning of a clock cycle 在时钟开始时读取寄存器的值
    - computations to evaluate the next value of the register and the Sen are performed
    - if Sen is True then s is uodated at the end of the clock cycle 在时钟结束时更新寄存器的值(非阻塞赋值)
### packaging a computation as a Latency-Insensitive Module
```bsv
interface GFMI#(n);
    method Action start (Bit#(n) x);
    method ActionValue#(Bit#(n)) getResult;
endinterface
module mkF (GFMI#(n));
    Reg#(n) s <- mkRegU();
    Reg#(Bool) busy <- mkReg(False);
    rule step if (p(s))&&busy;
        s <= f(s);
    endrule
    method Action start(Bit#(n) x) if (!busy);
        s <= x; busy <= True;
    endmethod
    method ActionValue Bit#(n) getResult if (!p(s) && busy);
        busy <= False; return s;
    endmethod
endmodule
```
> 使用`bsc`编译不通过这个`module`, 或许是因为这不是一个顶层`module`不能直接使用
## Combinational 32-bit multiply
```bsv
function Bit#(64) mul32(Bit#(32) a, Bit#(32) b);
    Bit#(32) tp = 0;
    Bit#(32) prod = 0;
    for(Integer i = 0; i < 32; i = i+1) begin
        Bit#(32) m = (a[i]==0)? 0 : b;
        Bit#(33) sum = add32(m,tp,0);
        prod[i] = sum[0];
        tp = sum[32:1];
    end
    return {tp,prod};
endfunction
```
- we can reuse the same add32 circuitif we store the partial results, e,g., sum, in aregister
- need register to hold a, b, tp, prod, and i
- update the register every cycle until we are done
### packagign Multiply as a Latency-Insensitive Module
```bsv
interface Multiply;
    method Action start (Bit#(32) a, Bit#(32) b);
    method ActionValue#(Bit#(64)) getResult;
endinterface
```
## dynamic selection requires a mux
当选择指数的模式固定时使用移位更好
### Replacing repeated selection by shifts
```
rule mulStep if (i < 32);
    Bit#(32) m = (a[0]==0)? 0 : b;
    a <= a >> 1;
    Bit#(33) sum = add32(m,tp,0);
    prod <= {sum[0], prod[31:1]};
    tp <= sum[32:1];
    i <= i+1;
endrule
```


