Part A: User Environments and Exception Handling

Exercise1：分配环境数组
Modify mem_init() in kern/pmap.c to allocate and map the envs array. This array consists of exactly NENV instances of the Env structure allocated much like how you allocated the pages array. Also like the pages array, the memory backing envs should also be mapped user read-only at UENVS (defined in inc/memlayout.h) so user processes can read from this array.
有了lab2的铺垫和理解，这个Exe就很容易做了。

```c
   // LAB 3: Your code here.
    envs = (struct Env*)boot_alloc(sizeof(struct Env)*NENV);
    memset(envs, 0, sizeof(struct Env)*NENV);
    
  // LAB 3: Your code here.
    boot_map_region(kern_pgdir, 
                    UENVS, 
                    ROUNDUP((sizeof(struct Env)*NENV), PGSIZE),
                    PADDR(envs),
                    PTE_U);
```
创建和运行环境（进程）
在这里，环境和进程是可以对等的，都指程序运行期间的抽象。不直接叫进程是因为jos中实现的系统调用和UNIX是有差别的。

我们需要编写运行用户环境所需的kern/env.c代码。 因为我们还没有文件系统，所以我们将设置内核来加载嵌入在内核中的静态二进制映像。JOS将此二进制文件作为ELF可执行映像嵌入内核中。

在kern/Makefrag文件中，你会发现一些魔法将这些二进制文件直接“链接”到内核可执行文件中，就好像它们是.o文件一样。 链接器命令行上的-b binary选项会将这些文件作为“原始”未解释的二进制文件链接，而不是作为编译器生成的常规.o文件链接。（就链接器而言，这些文件根本不必是ELF文件——它们可以是任何格式，例如文本文件或图片）如果在构建内核后查看obj/kern/kernel.sym， 你会注意到链接器“神奇地”产生了许多有趣的符号，这些符号具有晦涩的名字，如_binary_obj_user_hello_start，_binary_obj_user_hello_end和_binary_obj_user_hello_size。 链接器通过修改二进制文件的文件名来生成这些符号名称; 这些符号为常规内核代码提供了引用嵌入式二进制文件的方法。

1.3. Exercise 2
in the file env.c, finish coding the following functions:
```c
env_init()
env_setup_vm()
region_alloc()
load_icode()
env_create()
env_run()

env_init()
void
env_init(void)
{
  // Set up envs array
  // LAB 3: Your code here.
  int i;
  // 确保最小的env在最前端
  for (i = NENV-1; i >= 0; --i) {
      envs[i].env_id = 0;
  
      envs[i].env_link = env_free_list;
      env_free_list = &envs[i];
  }
  
  // Per-CPU part of the initialization
  env_init_percpu();
}
```
env_setup_vm()
为当前的进程分配一个页，用来存放页表目录，同时将内核部分的内存的映射完成。所有的进程，不论是内核还是用户，在虚地址UTOP之上的内容都是一样的。

在lab2的mem_init()中我们完成了地址空间的内核部分映射

load_icode()
这里的拷贝到指定的虚地址处，是指用户空间的虚地址，而不是内核空间的虚地址，所以还需要用lcr3函数加载用户空间的页表目录才能将地址转换为用户空间地址。

结果
通常，您会看到CPU重置和系统重启。
但我的实验结果并不是CPU重置和系统重启， 而是访问了一个错误地址Trying to execute code outside RAM or ROM at 0x97960000,导致qemu都abort了。 暂时不知道为什么。

check_page_installed_pgdir() succeeded!
[00000000] new env 00001000
qemu-system-i386: Trying to execute code outside RAM or ROM at 0x97960000
This usually means one of the following happened:
我们很快就会解决这个问题，但是现在我们可以使用调试器来检查我们是否正在进入用户模式。

(gdb) b *0xf0100092


(gdb) x/10i 
   0xf0102dd1 <env_run+1>:    mov    %esp,%ebp
   0xf0102dd3 <env_run+3>:    sub    $0x8,%esp
   0xf0102dd6 <env_run+6>:    mov    0x8(%ebp),%eax
   0xf0102dd9 <env_run+9>:    mov    0xf017be44,%edx
   0xf0102ddf <env_run+15>:    test   %edx,%edx
   0xf0102de1 <env_run+17>:    je     0xf0102df0 <env_run+32>
   0xf0102de3 <env_run+19>:    cmpl   $0x3,0x54(%edx)
   0xf0102de7 <env_run+23>:    jne    0xf0102df0 <env_run+32>
   0xf0102de9 <env_run+25>:    movl   $0x2,0x54(%edx)
   0xf0102df0 <env_run+32>:    mov    %eax,0xf017be44
可以直接断电打到vcprintf中的sys_cputs。
b *80012c


void
sys_cputs(const char *s, size_t len)
{
  800a84:    55                       push   %ebp
  800a85:    89 e5                    mov    %esp,%ebp
  800a87:    57                       push   %edi
  800a88:    56                       push   %esi
  800a89:    53                       push   %ebx
    //
    // The last clause tells the assembler that this can
    // potentially change the condition codes and arbitrary
    // memory locations.

    asm volatile("int %1\n"
  800a8a:    b8 00 00 00 00           mov    $0x0,%eax
  800a8f:    8b 4d 0c                 mov    0xc(%ebp),%ecx
  800a92:    8b 55 08                 mov    0x8(%ebp),%edx
  800a95:    89 c3                    mov    %eax,%ebx
  800a97:    89 c7                    mov    %eax,%edi
  800a99:    89 c6                    mov    %eax,%esi
  800a9b:    cd 30                    int    $0x30

(gdb) si
=> 0x800a9b:    int    $0x30
单步执行，最后死在了hello的vcprintf()中的sys_cputs(b.buf, b.idx);函数。照这样看来，内核加载了hello.c的程序，但是在什么时候加载（也就是初始化env[0]）的呢？

处理中断和异常
此时，用户空间中的第一个int $ 0x30系统调用指令是一个死胡同：一旦处理器进入用户模式，就无法退出。 您现在需要实现基本异常和系统调用处理，以便内核可以从用户模式代码恢复对处理器的控制。 您应该做的第一件事是彻底熟悉x86中断和异常机制。

Exercise 3
Read Chapter 9, Exceptions and Interrupts in the 80386 Programmer's Manual (or Chapter 5 of the IA-32 Developer's Manual), if you haven't already.
IDT可以驻留在物理内存中的任何位置。 处理器通过IDT寄存器（IDTR）定位IDT。
MIT6.828 LAB3_PartA_User Environments and Exception Handling

IDT包含了三种描述子

任务门
中断门
陷阱门
MIT6.828 LAB3_PartA_User Environments and Exception Handling
每个entry为8bytes，有以下关键bit：
16~31：code segment selector
0~15 & 46-64：segment offset （根据以上两项可确定中断处理函数的地址）
Type （8-11）：区分中断门、陷阱门、任务门等
DPL：Descriptor Privilege Level， 访问特权级
P：该描述符是否在内存中

1.5. 保护控制转移基础
为了确保这些受保护的控制传输实际受到保护，处理器的中断/异常机制被设计为使得当发生中断或异常时，当前运行的代码无法随意选择内核的进入点或方式。有两种机制

中断向量表：

x86允许最多256个不同的中断或异常入口点进入内核，每个入口点都有不同的中断向量。 向量是介于0和255之间的数字。中断的向量由中断源决定：不同的设备，错误条件和对内核的应用程序请求会产生具有不同向量的中断。 CPU使用向量作为处理器中断描述符表（IDT）的索引，其由内核在内核专用内存中设置，就像GDT一样。 处理器从该表中的相应条目处加载信息。
任务状态段

状态保存于状态恢复
尽管TSS很大并且可能用于各种目的，但是JOS仅使用它来定义处理器在从用户模式转换到内核模式时应切换到的内核堆栈。 由于JOS中的“内核模式”是x86上的特权级别0，因此处理器在进入内核模式时使用TSS的ESP0和SS0字段来定义内核堆栈。 JOS不使用任何其他TSS字段。

异常与中断的嵌套
处理器可以从内核和用户模式中获取异常和中断。 然而，只有当从用户模式进入内核时，x86处理器才会在将旧的寄存器状态压栈并通过IDT调用相应的异常处理程序之前自动切换堆栈。 如果处理器在发生中断或异常时已经处于内核模式（CS寄存器的低2位已经为零），则CPU只会向同一内核堆栈压入参数。通过这种方式，内核可以优雅地处理由内核本身内的代码引起的嵌套异常。 此功能是实现保护的重要工具，我们将在后面的系统调用一节中看到。

处理器的嵌套异常功能有一个重要的注意点。 如果处理器在已经处于内核模式时发生异常，并且由于任何原因（例如缺少堆栈空间）而无法将其旧状态压入内核堆栈，则处理器无法进行任何恢复，因此它只能重启。 不用说，设计内核应该避免这种情况的发生。

1.7. 建立IDT表
The header files inc/trap.h and kern/trap.h contain important definitions related to interrupts and exceptions that you will need to become familiar with. The file kern/trap.h contains definitions that are strictly private to the kernel, while inc/trap.h contains definitions that may also be useful to user-level programs and libraries.

1.8. Exercise 4
Edit trapentry.S and trap.c and implement the features described above. The macros TRAPHANDLER and TRAPHANDLER_NOEC in trapentry.S should help you, as well as the T_ defines in inc/trap.h. You will need to add an entry point in trapentry.S (using those macros) for each trap defined in inc/trap.h, and you'll have to provide _alltraps which the TRAPHANDLER macros refer to. You will also need to modify trap_init() to initialize the idt to point to each of these entry points defined in trapentry.S; the SETGATE macro will be helpful here.
1.8.1. 源码阅读
trapentry.S
#define TRAPHANDLER(name, num)                        \
    .globl name;        /* define global symbol for 'name' */    \
    .type name, @function;    /* symbol type is function */        \
    .align 2;        /* align function definition */        \
    name:            /* function starts here */        \
    pushl $(num);                            \
    jmp _alltraps
.type 指令指定 name 这个符号是函数类型的
name 为函数名
@function 表示函数内容开始
1.8.2. 过程分析
首先需要产生一个struct trapframe结构的栈， 而压参数是从右往左，对应这个结构体就是从下往上对应。注意到tf_esp以及tf_ss只用在发生特权级变化的时候才会有，再往上是由硬件自动产生的。在TRAPHANDLER函数中压入了trapno，同时为了保证没有错误代码的trap能符合这个结构体，使用TRAPHANDLER_NOEC压入0占位err。最后我们的程序只需要压入trapno以上的参数即可。

struct Trapframe {
    struct PushRegs tf_regs;
    uint16_t tf_es;
    uint16_t tf_padding1;
    uint16_t tf_ds;
    uint16_t tf_padding2;
    uint32_t tf_trapno;
    /* below here defined by x86 hardware */
    uint32_t tf_err;
    uintptr_t tf_eip;
    uint16_t tf_cs;
    uint16_t tf_padding3;
    uint32_t tf_eflags;
    /* below here only when crossing rings, such as from user to kernel */
    uintptr_t tf_esp;
    uint16_t tf_ss;
    uint16_t tf_padding4;
} __attribute__((packed));
还需要修改trap_init()以初始化 idt 以指向trapentry.S中定义的每个入口点; SETGATE宏在这里会有所帮助。
这里因为对x86的IDT不太熟悉（Exercise 3略看了）导致有点不太理解各个参数的含义。比如说gate这个概念。

#define SETGATE(gate, istrap, sel, off, dpl)

istrap: 1 for a trap (= exception) gate, 0 for an interrupt gate.
sel: 代码段选择子 for interrupt/trap handler

off: 代码段偏移 for interrupt/trap handler
dpl: 描述符特权级
    void divide_handler();
    void debug_handler();
    void nmi_handler();
    void brkpt_handler();
    void oflow_handler();
    void bound_handler();
    void device_handler();
    void illop_handler();
    void tss_handler();
    void segnp_handler();
    void stack_handler();
    void gpflt_handler();
    void pgflt_handler();
    void fperr_handler();
    void align_handler();
    void mchk_handler();
    void simderr_handler();
    void syscall_handler();
    void dblflt_handler();
    // LAB 3: Your code here.
    // GD_KT 全局描述符， kernel text
    SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
    SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
    SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
    SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 0);
    SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
    SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
    SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
    SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
    SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
    SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
    SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
    SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
    SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
    SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
    SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
    SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
    SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
    SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
    SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
    
```S
__alltrap:
    pushal %ds
    pushal %es

    pushal

    pushl %esp
    movw $GD_KD, $ax
    movw $ax, $ds
    movw $ax, $es
```
make grade结果:
divzero: OK (4.4s)
softint: OK (3.4s)
badsegment: OK (3.1s)
Part A score: 30/30

1.9. Questions
为每个异常/中断设置单独的处理函数的目的是什么？ （即，如果所有异常/中断都传递给同一个处理程序，则无法提供当前实现中存在哪些功能？）
不同的中断需要不同的中断处理程序。因为对待不同的中断需要进行不同的处理方式，有些中断比如指令错误，就需要直接中断程序的运行。 而I/O中断只需要读取数据后，程序再继续运行。

需要做什么才能使user/softint程序正常运行？ 评分脚本期望它产生一般保护错误（trap 13），但softint的代码为int $14。 为什么这会产生中断向量13？ 如果内核实际上允许softint的int $14指令调用内核的页面错误处理程序（中断向量14）会发生什么？
因为当前系统运行在用户态下，特权级为3，而INT 指令为系统指令，特权级为0。 会引发General Protection Exception。

PartA问题
Exe2: 内核加载了hello.c的程序，但是在什么时候加载（也就是初始化env[0]）的呢？
Exe4: 为什么handler不用具体实现，只需要声明再注册到IDT就行了 ？

PartB: Page Faults, Breakpoints Exceptions, and System Calls
处理页错误
Exercise 5.
修改 trap_dispatch() 将 page fault exceptions 分配到 page_fault_handler(). 记住你可以用 make run-x or make run-x-nox是启动JOS执行特定的用户程序. For instance, make run-hello-nox runs the hello user program.
直接修改trap_dispatch函数，用switch case实现

// LAB 3: Your code here.
    switch(tf->tf_trapno) {
        case T_PGFLT: page_fault_handler(tf);break;
        default: break;
    }
运行结果:

faultread: OK (4.0s)  
    (Old jos.out.faultread failure log removed)  
faultreadkernel: OK (3.7s)   
    (Old jos.out.faultreadkernel failure log removed)  
faultwrite: OK (3.1s)   
    (Old jos.out.faultwrite failure log removed)  
faultwritekernel: OK (3.3s)   
    (Old jos.out.faultwritekernel failure log removed)  
The Breakpoint Exception(断点异常)
断点异常，中断向量3（T_BRKPT），通常用于允许调试器通过使用特殊的1字节int 3软件中断指令临时替换相关的程序指令，在程序代码中插入断点。

在JOS中，我们将稍微滥用此异常，将其转换为用户环境用于调用JOS内核监视器的原始伪系统调用。 如果我们将JOS内核监视器视为原始调试器，这种用法实际上是合适的。 例如，lib/panic.c中的panic()的用户模式实现在打印panic消息后执行int 3。

    // Cause a breakpoint exception
    while (1)
        asm volatile("int3");
Exercise 6
Modify trap_dispatch() to make breakpoint exceptions invoke the kernel monitor. You should now be able to get make grade to succeed on the breakpoint test.
同样在trap_dispatch中加入一个breakpiont的case就可以了。

case T_BRKPT:
            monitor(tf);
            break;
Questions
3.断点测试例子中，产生断点异常还是通用保护错误取决于我们如何初始化断点异常的IDT项。为什么？

如果设置其DPL为0，则会产生GPF，因为用户程序跳转执行内核态程序。如果我们想要当前执行的程序能够跳转到这个描述符所指向的程序哪里继续执行的话，有个要求，就是要求当前运行程序的CPL，RPL的最大值需要小于等于DPL，否则就会出现优先级低的代码试图去访问优先级高的代码的情况，就会触发general protection exception。

4.尤其考虑到user/softint测试程序，你认为这些机制的关键点是什么？

DPL的设置，可以限制用户态对关键指令的使用。

系统调用
用户进程通过系统调用要求内容去做一定的操作。当用户进程调用系统调用时，处理器进入内核模式（ 怎么进入的？硬件自动，软件设置标志位？ ），处理器和内核协同保存用户进程的状态，内核执行适当的代码以执行系统调用，然后恢复用户进程。 用户进程如何获得内核注意的确切细节以及它如何指定它想要执行的调用因系统而异。

注意硬件不能产生int 0x30中断，需要程序自行产生此中断，并且没有二义性。

应用程序通过寄存器传递系统调用号和系统调用参数。 这样，内核就不需要在用户环境的堆栈或指令流中获取参数。系统调用号将存放在％eax中，参数（最多五个）将分别位于％edx，％ecx，％ebx，％edi和％esi中。内核通过%eax传递返回值。

    asm volatile("int %1\n"
             : "=a" (ret)
             : "i" (T_SYSCALL),
               "a" (num),
               "d" (a1),
               "c" (a2),
               "b" (a3),
               "D" (a4),
               "S" (a5)
                 : "cc", "memory");
"__volatile__"表示编译器不要优化代码，后面的指令 保留原样，其中"=a"表示"ret"是输出操作数; "i"=立即数;
最后一个子句告诉汇编器这可能会改变条件代码和任意内存位置。memory强制gcc编译器假设所有内存单元均被汇编指令修改，这样cpu中的registers和cache中已缓存的内存单元中的数据将作废。cpu将不得不在需要的时候重新读取内存中的数据。这就阻止了cpu又将registers，cache中的数据用于去优化指令，而避免去访问内存。

Exercise 7
在内核中为中断向量T_SYSCALL添加一个handler.

根据其提示应该很容易写出这个Exe的代码，这里就不一一贴出。在此我们简单分析以下系统调用执行过程。用户态调用的是lib文件下的syscall.c中的sys_cputs()等函数，然后转到lib中的syscall(), 其中汇编代码使用寄存器传递参数并执行了int 0x30产生系统调用中断。最后进入trap中并dispatch。内核态调用了kern文件下的syscall根据系统调用号，执行相应的系统调用函数。 实际上我们可以发现，自从引进了用户进程这个概念后，lib and kern两个文件夹下的syscall.c and printf.c会出现很多函数名相似的代码。 这都是为了区分用户态与内核态。lib下的函数并不真正执行相应的操作，而是通过系统调用进入内核态，执行kern下的代码。

那我们可不可以直接调用kern下的函数呢？盲猜，kern下的代码在内存中有权限保护，所以不能在用户态调用。

make run-hello后打印出了hello world。并且出现了如练习中所说的page fault。但是为什么会出现页错误呢？ user-mode startup部分给出了解释，在hello.c中it tries to access thisenv->env_id，而thisenv并没有初始化。

Incoming TRAP frame at 0xefffffbc
hello, world
Incoming TRAP frame at 0xefffffbc
[00001000] user fault va 00000048 ip 00800048
TRAP frame at 0xf01be000
  ...
  trap 0x0000000e Page Fault
  cr2  0x00000048
  err  0x00000004 [user, read, not-present]
  ...
[00001000] free env 00001000
user-mode startup
用户程序首先从lib/entry.S开始运行。 经过一些初始化后，此代码在lib/libmain.c中调用libmain()。 我们应该修改libmain()以初始化全局指针thisenv以指向envs[]数组中此环境对应的struct Env。 程序是如何执行到这里来的？ 应该问题还是会回到之前提出的env[0]到底是什么时候初始化的。

一个环境ID 'envid_t' 有三个部分：

0~9bit :为环境索引，也等于ENVX(eid)
10~30bit: uniqueifier可区分在不同时间创建的环境，但共享相同的环境索引。
31bit: 恒为0, All real environments are greater than 0 (so the sign bit is zero).
修改libmain.c,添加一条语句即可。

  // set thisenv to point at our Env structure in envs[].
    // LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
页错误和内存保护
内存保护是操作系统的一个重要特性，可确保一个程序中的错误不会破坏其他程序或破坏操作系统本身。

操作系统通常依靠硬件支持来实现内存保护。 操作系统会通知硬件哪些虚拟地址有效，哪些虚拟地址无效。 当程序试图访问无效地址或无权地址时，处理器会在导致故障的指令处停止程序，然后携带者有关操作的信息陷入内核。

故障分为可修复故障（例如自动栈扩展，缺页）和不可修复故障。

系统调用为内存保护提出了一个有趣的问题。 大多数系统调用接口允许用户程序传递指向内核的指针。 这些指针指向要读取或写入的用户缓冲区。 然后内核在执行系统调用时对这些指针进行解引用操作。 这有两个问题：

内核中的页错误可能比用户程序中的页面错误严重得多。如果内核在处理自己的数据结构时发生页错误，那就是内核错误，并且错误处理程序应该使内核（进而整个系统）panic。 但是，当内核解引用用户程序传递的指针时，它需要一种方法来记住这些解引用操作引起的任何页错误实际上都代表用户程序。
内核通常比用户程序拥有更多的内存权限。用户程序可能传递一个指向系统调用的指针，该系统调用指向内核可以读写但程序不能读写的内存。内核必须小心不要被诱骗去解引用这样的指针，因为这可能会暴露私有信息或者破坏内核的完整性。
Exercise 9
Change kern/trap.c to panic if a page fault happens in kernel mode.
首先通过CPL位来判断处理器是否处于内核态。tf->tf_cs & 0x01 == 0。
To determine whether a fault happened in user mode or in kernel mode, check the low bits of the tf_cs.

    if(tf->tf_cs && 3 == 0) {
        panic("page_fault in kernel mode, fault address %d\n", fault_va);
    }
阅读 kern/pmap.c 文件中的 user_mem_assert 函数并实现 user_mem_check 函数，实现如下：

int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
    // LAB 3: Your code here.
    uint32_t start = (uint32_t)ROUNDDOWN((char *)va, PGSIZE);
    uint32_t end = (uint32_t)ROUNDUP((char *)va+len, PGSIZE);
    for(; start < end; start += PGSIZE) {
        pte_t *pte = pgdir_walk(env->env_pgdir, (void*)start, 0);
        if((start >= ULIM) || (pte == NULL) || !(*pte & PTE_P) || ((*pte & perm) != perm)) {
            user_mem_check_addr = (start < (uint32_t)va ? (uint32_t)va : start);
            return -E_FAULT;
        }
    }
    return 0;
}
Finally, change debuginfo_eip in kern/kdebug.c to call user_mem_check on usd, stabs, and stabstr.

    if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U))
        return -1;
    ...
    if (user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_U))
        return -1;

    if (user_mem_check(curenv, stabstr, stabstr_end-stabstr, PTE_U))
        return -1;
写完后运行发现后面的evilhello，buggyhello，buggyhello2都能通过，但是faultread、faultreadkernel，faultwrite, faultwritekernel都通不过了。最后发现是我理解错了，我以为在page_fault_handler中如果不是内核模式而在用户模式，还需要进行user_mem_assert操作，即如下代码所示。导致程序每次都会终止在user_mem_assert，而不会打印之后的字符了。 正确的实现代码应删除user_mem_assert(curenv, (const void *) fault_va, PGSIZE, 0); 这一行。

    // LAB 3: Your code here.
    // 怎么判断是内核模式， CPL位
    if(tf->tf_cs && 3 == 0) {
        panic("page_fault in kernel mode, fault address %d\n", fault_va);
    }
    
    // We've already handled kernel-mode exceptions, so if we get here,
    // the page fault happened in user mode.
    // user_mem_assert(curenv, (const void *) fault_va, PGSIZE, 0);
    
    // Destroy the environment that caused the fault.
    cprintf("[%08x] user fault va %08x ip %08x\n",
        curenv->env_id, fault_va, tf->tf_eip);
    print_trapframe(tf);
    env_destroy(curenv);
以上我们实现的机制，同样适用于对恶意程序的处理。因此Exercise10可以直接通过。

总结
此lab让我们在头脑中建立了一个用户环境（进程）实现的框架，对用户程序的运行有了一个较清晰的概念。

首先我们需要创建用户环境、初始化用户环境的虚拟内存机制、并实现用户代码的加载与进程的运行。之后我们需要了解x86的中断与异常机制，以及IDT表的基本结构，并对IDT表进行初始化。对IDT，我一开始的理解是：具体实现handler，当中断发生时，直接查IDT表去调用相应的handler，但是在实际中是用trap的dispatch来实现分流。对这我有点不解。

最后实现通过dispatch来分流，实现页错误、断点异常以及系统调用等的处理。