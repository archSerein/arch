# IP look up: Application requirements and concurrency issues
## IP lookup block in a router
- Packet Process
    > SRAM(lookup table) -> IP lookup
- a packet is routed based on the `Longest Prefix Match 最长前缀匹配`(LPM) of it's IP address with entries in a routing table
> Packet: 网络中传输的数据包, 通常包括源 ip 地址和目标 ip 地址等信息
> 在网络路由中，路由器会通过目的 IP 的地址来决定数据包的转发路径
> 路由器通常会通过查找路由表中的条目找到最合适的路径, 会选择与数据包 IP 地址匹配最长的前缀
- line rate and the order of arrival must be maintained
> line rate: 是数据传输的速度
> order of arrival: 数据到达的顺序
> 保持最大的数据传输速率和保持数据到达的顺序
## Sparse tree representation `稀疏树形表示法`
## IP-lookup module: circular pipeline
- Completion buffer 确保在即使 lookup完成是无序的, 在 getResult 的时候是有序的
- 由于 cbuf 的容量有限, 所以会有一个 token 标识是否可以进入 circular pipeline
- 当 fifo 在访问内存时必须要持有`token`: Tuplel2#(Token, Bit#(16))
> Bit#(16) 保存的是剩余的 IP
### Request-Response Interface for Synchronous Memory
> 同步内存的请求/相应接口
```bsv
// 使用 bsv 封装一个对延迟不敏感的同步组件
    interface Mem#(type addrT, type dataT);
        method Action req(adrT x);
        method Action deq;
        method dataT oeek;
    endinterface
```
### Completion buffer
```bsv
interface CBuffer#(type t);
    method ActionValue#(Token) getToken;
    method Action put(Token tok, t d);
    method ActionValue#(t) getResult;
endinterface
```
- Comppletion buffer 用于重排序(同进入处理的输入顺序相同)
    - Tokens are given out in order
    - data with a token can bu put in any order in cbuf
    - Results are returned in the same order in which tokes were issued(返回结果的顺序与发出的顺序相同)
### IP-Lookup module: Interface methods
```bsv
module mkIPLookup(IPLookup);
    instantiate cbuf, RAM and fifo
    rule recirculate...  ; 
    method Action enter (IP ip);
        Token tok <- cbuf.getToken;
        ram.req(ip[31:16]);
        fifo.enq(tuple2(tok,ip[15:0]));
    endmethod
    method ActionValue#(Msg) getResult(); 
        let result <- cbuf.getResult;
        return result;
    endmethod
endmodule
```
- when can enter fire?
> cbuf ram fifo 都没有满的时候(is rdy)
### Circular Pipeline Rules
```bsv
rule recirculate; 
    match{.tok,.rip} = fifo.first; 
    fifo.deq; ram.deq;
    if (isLeaf(ram.peek)) 
        cbuf.put(tok, ram.peek); 
    else begin
        fifo.enq(tuple2(tok,(rip << 8)));
        ram.req(ram.peek + rip[15:8]);
    end
endrule
```
- when recirculate fire?
> ram and fifo is not empty
> ram, fifo and cbuf has space
## Performance
在响应前一个请求时新的请求不能进入(会产生死循环)
因为 enter 和 recirculate 在 fifo enq 时有冲突
### the Effect of Dead cycles
Circular Pipeline
- RAM takes several cycles to response to a request
- Each IP request generates 1-3 RAM requests
- FIFO entries hold base pointer for next lookup and unprcessed part of the IP address
在 isLeaf 成立的时候 enter and recirculate 没有冲突
## rules spliting
```bsv
// 当 isLeaf 不满足时不能与 enter 并行, ram 和 FIFO 都会有冲突
rule recirculate(!isLeaf(ram.peek));
    match{.tok,.rip} = fifo.first;    
    fifo.enq(tuple2(tok,(rip << 8)));
    ram.req(ram.peek + rip[15:8]);
    fifo.deq; ram.deq;
endrule

rule exit (isLeaf(ram.peek));
    match{.tok,.rip} = fifo.first;    
    cbuf.put(tok, ram.peek);
    fifo.deq; ram.deq;
endrule

method Action enter (IP ip);
    Token tok <- cbuf.getToken;
    ram.req(ip[31.16]);
    fifo.enq(tuple(tok,ip[15:0]));
endmathod
```
> rule exit and enter execute concurrently, if cbuf.put and cbuf.getToken can execute concurrently
## Completion buffer: Implementation
- A circular buffer with two pointers iidx and ridx, and a countter cnt
- Esch data element has a valid bit associated with it
```bsv
module mkCompletionBuffer(CompletionBuffer#(t));
    Vector#(32, Reg#(Bool)) cbv <- replicateM(mkReg(False));
    Vector#(32, Reg#(t)) cbData <- replicateM(mkRegU());
    Reg#(Bit#(5))   iidx <- mkReg(0);
    Reg#(Bit#(5)) ridx <- mkReg(0);
    Reg#(Bit#(6))    cnt <- mkReg(0);
    
    method ActionValue#(Bit#(5)) getToken() if (cnt < 32);
        cbv[iidx] <= False;
        iidx <= (iidx==31) ? 0 : iidx + 1;
        cnt <= cnt + 1;
        return iidx;
    endmethod
    method Action put(Token idx, t data);
        cbData[idx] <= data;
        cbv[idx] <= True;
    endmethod
    method ActionValue#(t) getResult() if ((cnt > 0)&&(cbv[ridx]));
        cbv[ridx] <= False;
        ridx <= (ridx==31) ? 0 : ridx + 1;         
        cnt <= cnt – 1;
        return cbData[ridx];
    endmethod
endmodule
```
