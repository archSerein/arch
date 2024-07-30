# Serializability of Concurrent Execution of Rules
## Linearizability
- 规则的原子性是指在规则执行的过程中没有其他的规则交替执行
- 线性化(linearizability), 并发执行的结果必须与某个顺序执行的结果一致
```bsv
rule ra;
    x <= y+1;
endrule
rule rb;
    y <= x+2;
endrule
```
- 这个示例没有`double write`的错误，但是如果`ra and rb`同时执行违反了并发执行的`linearizability`
## Serializability
- `methods or rules`在不会出现`double write`的错误时就可以并发执行, 这个执行是线性化的
- 在规则的并发执行上增加了一些串行化的约束：
    - 串行化意味着规则的并发执行必须与一些串行的规则相匹配, 又被称为`onr-rule-at-a-time execution rules`
- 串行的约束条件是为了在分析并发系统时变得更容易
## synthesis of the scheduler
通过显示和隐式的条件推导出`scheduling priority`, 并计算出`rule's can-fire signal`
