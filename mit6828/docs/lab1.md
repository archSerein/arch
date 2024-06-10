# MIT6.828 官网 Lab 1: Booting a PC。

## GDB调试中常用指令：
### MIT6.828 LAB1_Part1-2 启动 PC

## 下载源码并且编译执行：

-> mkdir ~/6.828
-> cd ~/6.828
-> git clone https://pdos.csail.mit.edu/6.828/2018/jos.git lab

cd lab
# 编译源码
make 
# qemu 模拟x86环境，运行minimal kernel
make qemu
# 如果你是在服务器等其他无图形界面的环境下实验可以执行下面的命令启动
# make qemu-nox 
运行成功的话终端就会打印出以下字符：

```txt
6828 decimal is 015254 octal!
Physical memory: 66556K available, base = 640K, extended = 65532K
check_page_alloc() succeeded!
check_page() succeeded!
check_kern_pgdir() succeeded!
check_page_installed_pgdir() succeeded!
[00000000] new env 00001000
Incoming TRAP frame at 0xefffffbc
Incoming TRAP frame at 0xefffffbc
hello, world
Incoming TRAP frame at 0xefffffbc
i am environment 00001000
Incoming TRAP frame at 0xefffffbc
[00001000] exiting gracefully
[00001000] free env 00001000
Destroyed the only environment - nothing more to do!
Welcome to the JOS kernel monitor!
Type 'help' for a list of commands.
K> 
```
-> 键入kerninfo,值得注意的是，此内核监视器“直接”在模拟PC的“原始（虚拟）硬件”上运行。
-> 
-> 细节记录
-> PC中BIOS大小为64k, 物理地址范围0x000f0000-0x000fffff
-> PC 开机首先0xfffff0处执行 jmp [0xf000,0xe05b] 指令。在gdb中使用si(Step Instruction)进行跟踪。
```gdb
(gdb) si
[f000:e05b]    0xfe05b:    cmpw   $0xffc8,%cs:(%esi)   # 比较大小，改变PSW
0x0000e05b in ?? ()
(gdb) si
[f000:e062]    0xfe062:    jne    0xd241d416           # 不相等则跳转
0x0000e062 in ?? ()
(gdb) si
[f000:e066]    0xfe066:    xor    %edx,%edx            # 清零edx
0x0000e066 in ?? ()
(gdb) si
[f000:e068]    0xfe068:    mov    %edx,%ss
0x0000e068 in ?? ()
(gdb) si
[f000:e06a]    0xfe06a:    mov    $0x7000,%sp
0x0000e06a in ?? ()
```
-> BIOS运行过程中，它设定了中断描述符表，对VGA显示器等设备进行了初始化。在初始化完PCI总线和所有BIOS负责的重要设备后，它就开始搜索软盘、硬盘、或是CD-ROM等可启动的设备。最终，当它找到可引导磁盘时，BIOS从磁盘读取引导加载程序并将控制权转移给它1。

# Part 2: The Boot Loader
-> 对于6.828，我们将使用传统的硬盘启动机制，这意味着我们的boot loader必须满足于512字节。

-> boot loader由一个汇编语言源文件boot / boot.S和一个C源文件boot / main.c组成。

-> boot.S
-> BIOS将boot.S这段代码从硬盘的第一个扇区load到物理地址为0x7c00的位置，同时CPU工作在real mode。
-> 
-> boot.S需要将CPU的工作模式从实模式转换到32位的保护模式， 并且 jump 到 C 语言程序。
-> 
-> 源码阅读，知识点：
-> 
-> cli (clear interrupt)
-> cld (clear direction flag)
-> 
-> df: 方向标志位。在串处理指令中，控制每次操作后si，di的增减。（df=0，每次操作后si、di递增；df=1，每次操作后si、di递减）。
-> 为了向前兼容早期的PC机，A20地址线接地，所以当地址大于1M范围时，会默认回滚到0处。所以在转向32位模式之前，需要使能A20。
-> 
-> test 逻辑运算指令，对两个操作数进行AND操作，并且修改PSW, test 与 AND 指令唯一不同的地方是，TEST 指令不修改目标操作数。
-> 
-> test al, 00001001b ;测试位 0 和位 3
-> lgdt gdtdesc, 加载全局描述符表，暂时不管全局描述表是如何生成的。
-> cr0, control register,控制寄存器。
-> 
-> CR0中包含了6个预定义标志，0位是保护允许位PE(Protedted Enable)，用于启动保护模式，如果PE位置1，则保护模式启动，如果PE=0，则在实模式下运行。
-> ljmp $PROT_MODE_CSEG, $protcseg,
-> PROT_MODE_CSEG = 8 ,这个值好像是很有讲究的，在《自己动手写操作系统》这本书里面看到过。因为此时已经进入了32位实模式，此时的8不再是实模式下简单的cs了，貌似与GDT有关，当时觉得GDT的初始化贼复杂，此处先不深究。
-> 
-> 调试boot.S
-> 在一个terminal中cd到lab目录下，执行 make qemu-gdb。再开一个 terminal执行make gdb。
-> 
-> 因为BIOS会把boot loader加载到0x7c00的位置，因此设置断点b *0x7c00。再执行c,会看到QUMU终端上显示Booting from hard disk。
-> 
-> 执行x/30i 0x7c00就能看到与boot.S中类似的汇编代码了。


# 加载内核
## 接下来我们分析boot loader的C语言部分。

-> 首先熟悉以下C指针。 编译运行pointer.c结果。 可以发现 a[],b的地址相差很多，因为两者所存放的段不同。

```c
1: a = 0xbfa8bdbc, b = 0x9e3a160, c = (nil)
2: a[0] = 200, a[1] = 101, a[2] = 102, a[3] = 103
3: a[0] = 200, a[1] = 300, a[2] = 301, a[3] = 302
4: a[0] = 200, a[1] = 400, a[2] = 301, a[3] = 302
5: a[0] = 200, a[1] = 128144, a[2] = 256, a[3] = 302

// b = a + 4
6: a = 0xbfa8bdbc, b = 0xbfa8bdc0, c = 0xbfa8bdbd
```
-> ELF格式非常强大和复杂，但大多数复杂的部分都是为了支持共享库的动态加载，在6.828课程中并不会用到。在本课程中，我们可以把ELF可执行文件简单地看为带有加载信息的标头，后跟几个程序部分，每个程序部分都是一个连续的代码块或数据，其将被加载到指定内存中。

-> 我们所需要关心的Program Section是：
-> 
-> .text : 可执行指令
-> .rodata: 只读数据段,例如字符串常量。（但是，我们不会费心设置硬件来禁止写入。）
-> .data : 存放已经初始化的数据
-> .bss ： 存放未初始化的变量， 但是在ELF中只需要记录.bss的起始地址和长度。Loader and program必须自己将.bss段清零。
-> 每个程序头的ph-> p_pa字段包含段的目标物理地址（在这种情况下，它实际上是一个物理地址，尽管ELF规范对该字段的实际含义含糊不清）
-> 
-> BIOS会将引导扇区的内容加载到 0x7c00 的位置，引导程序也就从0x7C00的位置开始执行。我们通过-Ttext 0x7C00将链接地址传递给boot / Makefrag中的链接器，因此链接器将在生成的代码中生成正确的内存地址。
-> 
-> 除了部分信息之外，ELF头中还有一个对我们很重要的字段，名为e_entry。该字段保存程序中入口点的链接地址：程序应该开始执行的代码段的存储地址。 在反汇编代码中，可以看到最后call 了 0x10018地址。
```c
((void (*)(void)) (ELFHDR->e_entry))();
    7d6b:    ff 15 18 00 01 00        call   *0x10018
```
-> 在0x7d6b 打断点后，c 再si一次，发现实际跳转地址位0x10000c

---
(gdb) b *0x7d6b
Breakpoint 3 at 0x7d6b
(gdb) c
Continuing.
=> 0x7d6b:    call   *0x10018

Breakpoint 3, 0x00007d6b in ?? ()
(gdb) si
=> 0x10000c:    movw   $0x1234,0x472
与实际执行objdump -f kernel的 结果一致。

../kern/kernel:     file format elf32-i386
architecture: i386, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x0010000c
---
# Exercise 6
-> 在BIOS进入Boot loader时检查内存的8个字在0x00100000处，然后在引导加载程序进入内核时再次检查。 他们为什么不同？ 第二个断点有什么？ （你真的不需要用QEMU来回答这个问题。试想一下)
-> 答案应该很明显，在BIOS进入Boot loader时，0x100000内存后的8个字都为零，因为此时内核程序还没有加载进入内存。 内核的加载在bootmain函数中完成。
-> 
-> 若需要用gdb调试，可以使用x/8x 0x100000 查看其内存内容。

# Part3：The Kernel
-> 使用虚拟内存来解决位置依赖问题
-> 操作系统内核通常被链接到非常高的虚拟地址（例如0xf0100000）下运行，以便留下处理器虚拟地址空间的低地址部分供用户程序使用。 在下一个lab中，这种安排的原因将变得更加清晰。
-> 
-> 许多机器在地址范围无法达到0xf0100000，因此我们无法指望能够在那里存储内核。相反，我们将使用处理器的内存管理硬件将虚拟地址0xf0100000（内核代码期望运行的链接地址）映射到物理地址0x00100000（引导加载程序将内核加载到物理内存中）。
-> 
-> 现在，我们只需映射前4MB的物理内存，这足以让我们启动并运行。 我们使用kern/entrypgdir.c中手写的，静态初始化的页面目录和页表来完成此操作。 现在，你不必了解其工作原理的细节，只需注意其实现的效果。
-> 
-> 实现虚拟地址，有一个很重要的寄存器CR0-PG;
-> 
-> PG：CR0的位31是分页（Paging）标志。当设置该位时即开启了分页机制；当复位时则禁止分页机制，此时所有线性地址等同于物理地址。在开启这个标志之前必须已经或者同时开启PE标志。即若要启用分页机制，那么PE和PG标志都要置位。
-> Exercise 7
-> 1.使用QEMU和GDB跟踪到JOS内核并停在movl％eax，％cr0。 检查内存为0x00100000和0xf0100000。 现在，使用stepi GDB命令单步执行该指令。 再次检查内存为0x00100000和0xf0100000。 确保你了解刚刚发生的事情。
-> 在地址0x100020处，将第31位PG置为1，后写入cr0中
-> 
```asm
0x100015:    mov    $0x118000,%eax
0x10001a:    mov    %eax,%cr3

0x100020:    or     $0x80010001,%eax
0x100025:    mov    %eax,%cr0
```
```gdb
在0x00100000内存处没有变化
执行前：
(gdb) x/8x 0x100000
0x100000:    0x1badb002    0x00000000    0xe4524ffe    0x7205c766
0x100010:    0x34000004    0x8000b812    0x220f0011    0xc0200fd8

(gdb) x/8x 0xf0100000
0xf0100000 <_start+4026531828>:    0x00000000    0x00000000    0x00000000    0x00000000
0xf0100010 <entry+4>:    0x00000000    0x00000000    0x00000000    0x00000000
执行后
(gdb) x/8x 0xf0100000
0xf0100000 <_start+4026531828>:    0x1badb002    0x00000000    0xe4524ffe    0x7205c766
0xf0100010 <entry+4>:    0x34000004    0x8000b812    0x220f0011    0xc0200fd8
```
-> 可以发现，两者内容完全一致，虚拟地址0xf0100000已经被映射到0x00100000处了,为什么会出现这种变化？
-> 在修改cr0之前修改了cr3寄存器。将地址0x118000写入了页目录寄存器，页目录表应该就是存放在地址0x118000处。其他操作应该是由entry_pgdir的// Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)，完成了映射。使得再读取0xf0100000地址时，自动映射到了0~4M的某个位置（暂时不清楚）。
-> 
-> CR3是页目录基址寄存器，保存页目录表的物理地址，页目录表总是放在以4K字节为单位的存储器边界上，因此，它的地址的低12位总为0，不起作用，即使写上内容，也不会被理会。
-> 在entry.S中说：
-> 
-> The kernel (this code) is linked at address ~(KERNBASE + 1 Meg),
-> 在程序编译后，被链接到高地址处。在kernel.ld链接脚本文件里指定了。
-> 
-> /* Link the kernel at this address: "." means the current address */
->     . = 0xF0100000;
-> 但是bootloader 实际把kernel加载到了0x100000的位置
-> 
-> 2.注释掉 kern/entry.S中的movl %eax, %cr0，再编译执行会出现什么问题。
-> 因为没有开启分页虚拟存储机制，当访问高位地址时，会出现RAM or ROM 越界错误。
-> 
-> 格式化输出到控制台
-> 激动人心的时刻到了，我们终于到了能对设备进行操作的阶段了，Linus当时为自己能在显示屏上打印出信息而感到十分自豪（尽管他拿给她妹妹看，他妹妹不以为然，哈哈）。能打印出信息，是实现交互的开始，也是我们之后调试的一个重要途径。
-> 
-> 大多数人都把printf（）这样的函数认为是理所当然的，有时甚至认为它们是C语言的“原语“。但在OS内核中，我们必须自己实现所有I / O.
-> 
-> 阅读kern/printf.c, lib/printfmt.c, and kern/console.c三个源代码，理清三者之间的关系。
-> 
-> printf.c 基于 printfmt()和 kernel console's cputchar()；
-> Exercise 8
-> 我们省略了一小段代码 - 使用“％o”形式的模式打印八进制数所需的代码。 查找并填写此代码片段。
```c
case 'o':
            // Replace this with your code.
            num = getuint(&ap, lflag);
            base = 8;
            goto number;
```
-> 就是把%u的代码复制一遍，base 改为 8 就差不多了，并不复杂。

1.Explain the interface between printf.c and console.c. Specifically, what function does console.c export? How is this function used by printf.c?
printf.c中使用了console.c 中的cputchar函数，并封装为putch函数。并以函数形参传递到printfmt.c中的vprintfmt函数，用于向屏幕上输出一个字符。

```c
// 解释console.c中的一段代码。
// What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
    // 显示字符数超过CRT一屏可显示的字符数
        int i;
    //清除buf中"第一行"的字符
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        //CRT显示器需要对其用空格擦写才能去掉本来以及显示了的字符。
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
            crt_buf[i] = 0x0700 | ' ';
        //显示起点退回到最后一行起始
        crt_pos -= CRT_COLS;
    }    
```
首先理解几个宏定义和函数

CRT_ROWS，CRT_COLS：CRT显示器行列最大值， 此处是25x80
ctr_buf 在初始化时指向了显示器I/O地址
memmove 没有理清哪个是源，哪个是目的。 按理解清除第一行的数据，应该第二个是源。即2~n行的数据（CRT_SIZE - CRT_COLS）个，移动到1~n-1行的位置。
跟踪执行以下代码，在调用cprintf()时，fmt, ap指向什么？
```c
int x = 1, y = 3, z = 4;
cprintf("x %d, y %x, z %d\n", x, y, z);
```
在kern/init.c的i386_init()下加入代码，就可以直接测试；加Lab1_exercise8_3标号的目的是为了在kern/kernel.asm反汇编代码中容易找到添加的代码的位置。可以看到地址在0xf0100080处

```c
// lab1 Exercise_8
{
    cprintf("Lab1_Exercise_8:\n");
    int x = 1, y = 3, z = 4;
    // 
    Lab1_exercise8_3:
    cprintf("x %d, y %x, z %d\n", x, y, z);

    unsigned int i = 0x00646c72;
    cprintf("H%x Wo%s", 57616, &i);
}
调试过程fmt=0xf010478d ， ap=0xf0118fc4； fmt指向字符串，ap指向栈顶

cprintf (fmt=0xf010478d "x %d, y %x, z %d\n") at kern/printf.c:27
可以看到以上地址处就存了字符串
(gdb) x/s 0xf010478d
0xf010478d:    "x %d, y %x, z %d\n"

gdb) si
=> 0xf0102f85 <vcprintf>:    push   %ebp
vcprintf (fmt=0xf010478d "x %d, y %x, z %d\n", ap=0xf0118fc4 "\001")
    at kern/printf.c:18
18    {

(gdb) x/16b 0xf0118fc4
0xf0118fc4:    0x01    0x00    0x00    0x00    0x03    0x00    0x00    0x00
0xf0118fcc:    0x04    0x00    0x00    0x00    0x7b    0x47    0x10    0xf0
```
引用一段Github上大神做的labclpsz/mit-jos-2014的execise8中的一段话。

从这个练习可以看出来，正是因为C函数调用实参的入栈顺序是从右到左的，才使得调用参数个数可变的函数成为可能(且不用显式地指出参数的个数)。但是必须有一个方式来告诉实际调用时传入的参数到底是几个，这个是在格式化字符串中指出的。如果这个格式化字符串指出的参数个数和实际传入的个数不一致，比如说传入的参数比格式化字符串指出的要少，就可能会使用到栈上错误的内存作为传入的参数，编译器必须检查出这样的错误。

4.运行以下代码，输出结果是什么。

```c
unsigned int i = 0x00646c72;
cprintf("H%x Wo%s", 57616, &i);
```
-> 调试出来竟然输出了Hello World！ 57616的十六进制形式为E110, 因为是小端机，i的在内存中为0x72,0x6c,0x64,0x00. 对应ASCII为rld\0

In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?
压栈的时候，地址是向低位还是高位增长？ 入栈由高位向低位增长（即sp减小），x会先读出3，再出栈，y会读出3内存的”+1“的位置的值并以整型打印。
假设GCC改变了它的调用约定，以致于它按声明顺序压栈。 你要如何更改cprintf或其接口，以便仍然可以传递可变数量的参数？
猜想，同时向cprintf传入可变参数个数。 无从验证，暂并不论。
The Stack
Exercise 9
确定内核在什么时候初始化了堆栈，以及堆栈所在内存的确切位置。 内核如何为其堆栈保留空间？ 并且在这个保留区域的“end”是堆栈指针最初指向的位置吗？
entry.S 77行初始化栈
栈的位置是0xf0108000-0xf0110000
设置栈的方法是在kernel的数据段预留32KB空间(entry.S 92行)
栈顶的初始化位置是0xf0110000
将值压入堆栈涉及到堆栈指针--，然后将值写入堆栈指针指向的位置。 从堆栈中弹出一个值包括读取堆栈指针指向的值，然后堆栈指针++。

Exercise 10
在obj/kern/kernel.asm找到test_backtrace函数，并设置断点。进行调试。此次练习最好使用工具页面提到的QEMU修补版本。 否则，您必须手动将所有断点和内存地址转换为线性地址。
没找到test_backtrace, 只找到了mon_backtrace; 占坑----
下载的代码里竟然没有test_backtrace函数，果断弃坑找了Github上另一位大神的代码。

```c
// 在另一份代码反汇编的kernel.asm中，找到test_backtrace函数。

    // Test the stack backtrace function (lab 1 only)
    test_backtrace(5);
f0100104:    c7 04 24 05 00 00 00     movl   $0x5,(%esp)
f010010b:    e8 30 ff ff ff           call   f0100040 <test_backtrace>
我们分析下最初两次调用函数test_backtrace的栈里面的内容：

                                                0x00000000      0x00000000
0xf010ffa0:     0x00000000      0x00000005      0xf010ffc8      0xf0100069
                                            --------------------------------
                                            |   ->第一次init 调用test_backtrace
0xf010ffb0:     0x00000004      0x00000005  |    0x00000000      0x00010094
--------------------------------------------|  
0xf010ffc0:     0x00010094      0x00010094      0xf010fff8      0xf0100144
0xf010ffd0:     0x00000005
```
最后一个是init调用函数传入的参数5，倒数第二个为init函数中test_backtrace的下一行指令地址。 第三行第二个数0x00000005是临时变量x的值，0x00000004是传入test_backtrace的值，0xf0100069为函数的返回地址。

Ecercise 11
实现指定的回溯函数
执行结果，打印的第一行反映当前正在执行的函数，即 mon_backtrace 本身，第二行反映调用mon_backtrace的函数，第三行反映调用该函数的函数，依此类推。 您应该打印所有未完成的堆栈帧。 通过研究kern / entry.S你会发现有一种简单的方法可以判断何时停止。

在entry.S函数的中执行了 movl $0x0,%ebp # nuke frame pointer然后就call了init函数，所以函数终止点为ebp == 0x0;

monitor.c中mon_backtrace函数：

```c
int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
    
    uint32_t *ebp;
     ebp = (uint32_t *)read_ebp();
    cprintf("Stack backtrace:\n");
    while(ebp!=0){
        cprintf("  ebp %08x",ebp);
        cprintf("  eip %08x  args",*(ebp+1));
        cprintf("  args");
        cprintf(" %08x", *(ebp+2));
        cprintf(" %08x", *(ebp+3));
        cprintf(" %08x", *(ebp+4));
        cprintf(" %08x", *(ebp+5));
        cprintf(" %08x\n", *(ebp+6));
        ebp  = (uint32_t*) *ebp;
    }

    return 0;
}
```
-> mon_backtrace函数中调用的read_ebp()函数声明在 inc/x86.h中，函数实现

```c
static __inline uint32_t
read_ebp(void)
{
    uint32_t ebp;
    __asm __volatile("movl %%ebp,%0" : "=r" (ebp));
    return ebp;
}
```
Execise 12
修改堆栈回溯功能，为每个eip显示与该eip对应的函数名称，源文件名和行号。
```c
int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uint32_t *ebp = (uint32_t *)read_ebp();
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");
	while(ebp != 0) {
		debuginfo_eip(*(ebp+1), &info);
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, \
				*(ebp + 1), *(ebp + 2), *(ebp + 3), *(ebp + 4), *(ebp + 5), *(ebp + 6));
		
		cprintf("         %s:%d:  %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, \
					info.eip_fn_name, *(ebp+1) - info.eip_fn_addr);
		ebp = (uint32_t *)(*ebp);
	}
	return 0;
}
```