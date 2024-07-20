# Wide Variety of Products RElu on ASICs
## asic:
 application-specific integrated circuit(专用集成电路)
### what's required
1. 集成电路针对各种应用进行优化性能显著提升
2. size and power to deliver mobility(面积和能耗可以调节)
3. 满足大众消费市场
### real power save impies specialized hardware
#### dominance
the power savings could be 100 to 1000 fold
#### inferior
1. difficulkt, risky
    - increases time-to market
2. inflexble brittle error prone
    - difficult to deal with changing standards
## SOC & Multicore Convergence
- more application specific blocks
### to reduce the design cost of SoCs need
- Exterme Ip reuse "intellectual property"
    - Multiple instantiations of ablock for different performance and application requirements
    - Packaging of IP sothat the blocks can be assembled easily to build a large system
- architectural exploration to understand cost, power and performance tradeoffs
- full system simulations for validation and verification
# bluespec: anew way of expressing behavior
- A formal method of composing modules with parallel interfaces(ports)
    - Compiler managers muxing of ports anf associated control
- powerful and zero-cost parameterization(参数化) of modules
    - Encapsulation(封装) if C and verilog codes using Bluespec wrappers
    - helps Transaction level modeling(行为建模)