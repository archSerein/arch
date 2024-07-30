# hardware synthesis: Bluespec Module as Sequential Circuits
## hardware synthensis from bluespec
- bsv 每个`module`都表示一个时序逻辑电路
    - 寄存器是一个原始的模块, its implementation is outside the language
- 时序电路的`input/output wires`来自于相应模块的接口
- 一个模块包含一系列的寄存器和其他模块的实例化(explicitly)
- 每个`method`被综合成组合逻辑电路
    - 输入端口包含`method`的参数, 如果是`action`还有使能信号
    - 输出端口包括`method`的`ready`信号,参数以及每个`method`的使能信号(if needed). 对于`Value and ActionValue methods`输出端口还包括返回值
- `rules`也是定义了一个组合逻辑电路.`rule`的`ready signal`通常被称为`can fire signal`
- `rule0`和`method`的组合逻辑使用`mux`与实例化的寄存器和模块连接起来
### interface defines input/output wires
- input and output are defined by the type of the module(interface)
    - Each method has a output ready wire
    - Each method may have 0 or more input data wires
    - Each Action method and ActionValue method has an input enable wire
    - Each value method and ActionValue method has output data wires
```bsv
// eg:
interface GCD#(Bit#(n));
    method Action start
        (Bit#(n) a,Bit#(n) b);
    method ActionValue(Bit#(n))
                getResult;
endinterface
```
```
--->|---------------|
--->|               |---->
 en |start          |<---- en
--->|      getResult|----> rdy
rdy |               |
<---|---------------|
```
### Register
- Implementation is defined outside the language
§ A register is created using mkReg or mkRegU
- The guards of _write and _read are always true and not
generated
- Special syntax
    - x <= e instead of x._write(e)
    - x instead of x._read in expressions
- Since we never look inside a register, we represent it
simply in terms of its input/output wires
### rdy-en协议的含义
`rsy`: 表示方法是否可以被调用

`en`: 表示方法的调用是否被触发
- 只有在`rdy` is true时，才会设置`en`信号为true. 防止在`method`没有准备好时触发该`method`,从而导致错误
- 在模块的内部`rdy`不应该依赖`en`, 信号应该只基于模块内部的信号和状态,避免导致组合逻辑环路, 从而导致不稳定或者错误的电路
#### example: FIFO Circuit
```
module mkFifo (Fifo#(1, Bit#(n)));
    Reg#(Bit#(n)) d <- mkRegU;
    Reg#(Bool) v <- mkReg(False);
    method Action enq(Bit#(n) x) if (!v);
        v <= True; d <= x;
    endmethod
    method Action deq if (v);
        v <= False;
    endmethod
    method Bit#(n) first if (v);
        return d;
    endmethod
endmodule
interface Fifo#(numeric type size, type Bit#(n));
    method Action enq(Bit#(n) x);
    method Action deq;
    method Bit#(n) first;
endinterface
```
### Combing the methods init a one circuit
- An issue arises in combing these circuits if an input
port has several sources
- We introduce a new type of mux for this purpose
(we will call it emux for mux-with-enable)
```txt
true    ---->|\ 
enq.en  ---->| |---->x 
false   ---->| |---->v
deq.en  ---->|/
```
> x = (v1 & x1) | (v2 & x2)

> v = v1 | v2 
- xi has a meaningful value only if its corresponding vi is true
- Compiler has to ensure that at most one vi input to the mux
is true at any given time; the circuit will behave unpredictably
if multiple input signals are valid
### ready signals and guards
- We can see that in this example the readiness of each method depends only on the internal state of the module
- rdy signals are derived from guards and therefore, guard
expressions should be written to avoid any dependence on inputs
## an issue in combining multiple source
- The procedure we have given will result in the above circuit
and will execute rules foo and baz concurrently
- But to avoid a double write error, the compiler has to ensure
that
    - Either p and q are mutually exclusive and thus, rules foo and baz will not be rdy to execute at the same time,
    - Otherwise the compiler must prevent one of the rules from executing
```
module mkEx (...);
    Reg#(Bit#(n)) x <- mkRegU;
    rule foo if p(x);
        x <= e1;
    endrule
    rule baz if q(x);
        x <= e2;
    endmethod
endmodule
```
- Suppose p and q can be true simultaneously. We can give
priority to (say) rule foo over baz by preventing the execution
of baz if foo “can fire”
- Preventing a rule from firing is the same as not letting it
update any state.
- Rule baz can execute only when the “can fire” signal of rule foo is false
## 使用`scheduler`抑制`rules`的执行
> 设置不同的优先级
# summery
> 时序逻辑是真的麻烦