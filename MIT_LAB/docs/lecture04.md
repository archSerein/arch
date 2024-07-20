# Sequential Circuits: Modules with Guarded Interfaces
## a different view of digital Hardware
- Complex Digital Systems 是一群协作时序机器的集合，它们同时运行
- a sequential machine is like an object in an Object-Oriented language like Cpp or Java
- a sequential machine 只能通过它的`interface methods`调用
## Finite State Machines(FSMs)
- 状态机被广泛的应用在软件设计中
- a computer(any digital hardware) 是一个状态机
- 同步时序电路`Synchronous Sequential Circuits`就是用硬件实现状态机
### D Filp-flop with Write Enable
只有`write enable`时数据才能被捕获
```txt
EN  D   Qt  Qt+1
0   X   0   0       hold
0   X   1   1       hold
1   0   X   0       copy input
1   1   X   1       copy input
```
### Register
a group of flip-flop with a common clock and enable
### Register file
a group of register with a common clock, a shared set of input and output ports
## Clocked Sequential Circuits
- In this class we will deal with only clocked sequential circuits
- all flip-flop are connected to the same clock
- 时钟信号是隐式输出并且不会显示在电路图里
- 使用`bsv`描述电路时不需要写`clock`，除非是在设计多时钟电路
### modulo-4 counter
```txt
Prev        next
q1q0    inc=0   inc=1
00      00      01
01      01      10
10      10      11
11      11      00
```
### Circuit for the modulo counter using D flip-flops with enables
- Use two D flip-flops, q0 and q1, to store the counter value
- Notice, the state of flip-flop changes only when inc is true
```bsv
{q1t+1,q0t+1} = {(q1t ^ q0t) q0t } (assume inc is True)
```
### Sequential Circuit as a module with Interface
- a module 有内部的状态和一个接口
- 内部的状态可以通过调用接口方法读取
- 一个指定的`action method`用来修改状态; 只有在`enable wire is true`时才会执行这个`action`
- `Actions`是原子执行的--either all the specified state elements
are modified or none of them are modified (no partially modified state is visible)
- Informally we refer to the interface of a module as its type
#### modulo-4 Counter implementation in bluespec
```bluespec
interface Counter;
    method Action inc;
    method Bit#(2) read;
endinterface

module mkCounter(Counter);
    Reg#(Bit#(2)) cnt <- mkReg(0);
    method Action inc;
        cnt <= {cnt[1]^cnt[0],~cnt[0]};
    endmethod
    method Bit#(2) read;
        return cnt;
    endmethod
endmodule
```
#### GCD module
GCD can be started if the module is not busy; Results can be read when ready
```bsv
interface GCD;
    method Action start (Bit#(32) a, Bit#(32) b);
    method ActionValue#(Bit#(32)) getResult;
    method Bool busy;
    method Bool ready;
endinterface
module mkGCD (GCD);
    Reg#(Bit#(32)) x <- mkReg(0); Reg#(Bit#(32)) y <- mkReg(0);
    Reg#(Bool) busy_flag <- mkReg(False);
    rule gcd;
        if (x >= y) begin x <= x – y; end //subtract
        else if (x != 0) begin x <= y; y <= x; end //swap
    endrule
    method Action start(Bit#(32) a, Bit#(32) b) ;
        x <= a; y <= b; busy_flag <= True;
    endmethod
    method ActionValue#(Bit#(32)) getResult ;
        busy_flag <= False; return y;
    endmethod
    method Bool busy
        = busy_flag;
    method Bool ready
        = (x==0);
endmodule
```
#### Rule
- A rule has a name (e.g., gcd)
- A rule is a collection of actions, which invoke methods
- All actions in a rule execute in parallel
- A rule can execute any time and when it executes
all of its actions must execute
#### GCD with Guards
#### rules with Guards
### FIFO
- FIFO data structure is used extensively both in hardware and software to connect things
- In hardware, fifo have fixed size which is often as small as 1, and therefore the producer blocks when enqueuing into a full fifo and the consumer blocks when
dequeueing from an empty fifo
#### one-element FIFO implementation with guards
```bsv
module mkFifo (Fifo#(1, Bit#(n)));
    Reg#(Bit#(n)) d <- mkRegU;
    Reg#(Bool) v <- mkReg(False);
    method Action enq(Bit#(n) x) if (!v)
        v <= True; d <= x;
    endmethod
    method Action deq if (v)
        v <= False;
    endmethod
    method Bit#(n) first if (v)
        return d;
    endmethod
endmodule
```
Guard expression is what is connected to the rdy wire of a method
