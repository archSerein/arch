# Preemptive Multitasking
## Part A: Multiprocessor Support and Cooperative Multitasking

### 多处理器支持
-> 我们将让 JOS 支持对称多处理器（symmetric multiprocessing，SMP），这是一种多处理器模型，其中所有CPU都具有对系统资源（如内存和I / O总线）的等效访问。虽然所有CPU在SMP中功能相同，但在引导过程中它们可分为两种类型：

-> 引导处理器（BSP）：负责初始化系统和引导操作系统;
-> 应用程序处理器（AP）：只有在操作系统启动并运行后，BSP才会激活应用程序处理器。
-> 在SMP系统中，每个CPU都有一个附带的本地APIC（LAPIC）单元。
->
-> APIC:Advanced Programmable Interrupt Controller高级可编程中断控制器 。APIC 是装置的扩充组合用来驱动 Interrupt 控制器 [1] 。在目前的建置中，系统的每一个部份都是经由 APIC Bus 连接的。"本机 APIC" 为系统的一部份，负责传递 Interrupt 至指定的处理器；举例来说，当一台机器上有三个处理器则它必须相对的要有三个本机 APIC。自 1994 年的 Pentium P54c 开始Intel 已经将本机 APIC 建置在它们的处理器中。实际建置了 Intel 处理器的电脑就已经包含了 APIC 系统的部份。
-> LAPIC单元负责在整个系统中提供中断。 LAPIC还为其连接的CPU提供唯一标识符。 在本实验中，我们使用LAPIC单元的以下基本功能（在kern/lapic.c中）：
->
-> 根据LAPIC识别码（APIC ID）区别我们的代码运行在哪个CPU上。（cpunum()）
-> 从BSP向APs发送STARTUP处理器间中断（IPI）去唤醒其他的CPU。（lapic_startap()）
-> 在Part C，我们编写LAPIC的内置定时器来触发时钟中断，以支持抢占式多任务（pic_init()）。
-> LAPIC的 hole 开始于物理地址0xFE000000(4GB之下的32MB)，但是这地址太高我们无法访问通过过去的直接映射(虚拟地址0xF0000000映射0x0，即只有256MB)。但是JOS虚拟地址映射预留了4MB空间在MMIOBASE处，我们需要分配映射空间。

```c
// 2.1.1. Exercise 1.
// Implement mmio_map_region in kern/pmap.c. To see how this is used, look at the beginning of lapic_init in kern/lapic.c. You'll have to do the next exercise, too, before the tests for mmio_map_region will run.

// 使用 ret 展示保存需要返回的 base 地址
void *ret = (void *)base;

size = ROUNDUP(size, PGSIZE);

boot_map_region(kern_pgdir, base, size, pa, PTE_PCD | PTE_PWT | PTE_W);

// 更新 base
base += size;

return ret;
```

### 2.2. 应用处理器（APs）引导程序
-> 在启动APs之前，BSP应该先收集关于多处理器系统的配置信息，比如CPU总数，CPUs的APIC ID，LAPIC单元的MMIO地址等。 kern/mpconfig.c中的mp_init（）函数通过读取驻留在BIOS内存区域中的MP配置表来检索此信息。 也就是说在出厂时，厂家就将此计算机的处理器信息写入了BIOS中，其有一定的规范，也就是kern/mpconfig.c中struct mp定义的。(但是我在使用make qemu CPUS = 4启动qemu时，总是只有一个CPU)

-> boot_aps()（在kern / init.c中）函数驱动了AP引导过程。 AP以实模式启动，非常类似于 bootloader 在boot/boot.S中启动的方式，因此boot_aps()将AP进入代码（kern / mpentry.S）复制到可在实模式下寻址的内存位置。与 bootloader 不同，我们可以控制 AP 开始执行代码的位置; 我们将 entry 代码复制到0x7000（MPENTRY_PADDR），但任何未使用的，页面对齐的物理地址低于640KB都可以。

-> 之后，boot_aps函数通过发送STARTUP的IPI(处理器间中断)信号到AP的 LAPIC 单元来一个个地激活AP。在kern/mpentry.S中的入口代码跟boot/boot.S中的代码类似。在一些简短的配置后，它使AP进入开启分页机制的保护模式，调用C语言的setup函数mp_main。boot_aps 等待AP在其结构CpuInfo的cpu_status字段中发出CPU_STARTED标志信号，然后再唤醒下一个。

```c
// 2.2.1. Exercise 2
// Read boot_aps() and mp_main() in kern/init.c, and the assembly code in kern/mpentry.S. Make sure you understand the control flow transfer during the bootstrap of APs.
// Then modify your implementation of page_init() in kern/pmap.c to avoid adding the page at MPENTRY_PADDR to the free list, so that we can safely copy and run AP bootstrap code at that physical address.

// 原来直接页面 page_index -> [1, npages_base)
// 现在需要分一部分提供给mpentry使用
// mpentry的起始物理地址是 MPENTRY_PADDR
// size = [mpentry_start, mpentry_end)
extern char mpentry_start[], mpentry_end[];
size_t mpenrty_page_index_start = MPENTRY_PADDR / PGSIZE;
size_t size = ROUNDUP((size_t)mpentry_end - (size_t)mpentry_start, PGSIZE);
size_t mpentry_page_index_end = (MPENTRY_PADDR + size) / PGSIZE;
for (i = 1; i < mpentry_map_index_start; i++) {
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}

	for (i = mpentry_map_index_start; i < mpentry_map_index_end; i++) {
		pages[i].pp_ref = 1;
	}
```

---
在启动计算机的引导加载过程时，是可以直接访问物理地址的，没有启用分页
在mpentry时，所有的地址都会经过mmu转换后才能访问，无法直接访问物理地址
---
### 2.3. 多处理器的状态和初始化

-> 在编写多处理器的系统时，需要区分每个'CPU'的状态和系统共享的全局状态
1. per-CPU kernel stack:
-> 由于每个'CPU'都可以同时陷入'kernel'，所以需要区分每个'CPU'的栈和'kernel'的栈，防止他们相互干扰，使用 array percpu_kstacks[NCPU][KSTKSIZE] 保存栈空间
2. per-CPU TSS and TSS descriptor
-> A per-CPU task state segment(TSS) is also needed in order to specify where each CPU's kernel stack lives. The TSS for The TSS for CPU i is stored in cpus[i].cpu_ts, and the corresponding TSS descriptor is defined in the GDT entry gdt[(GD_TSS0 >> 3) + i]. The global ts variable defined in kern/trap.c will no longer be useful.

3. Per-CPU current environment pointer.
-> Since each CPU can run different user process simultaneously, we redefined the symbol curenv to refer to cpus[cpunum()].cpu_env (or thiscpu->cpu_env), which points to the environment currently executing on the current CPU (the CPU on which the code is running).

4. Per-CPU system registers.
-> All registers, including system registers, are private to a CPU. Therefore, instructions that initialize these registers, such as lcr3(), ltr(), lgdt(), lidt(), etc., must be executed once on each CPU. Functions env_init_percpu() and trap_init_percpu() are defined for this purpose.
---
所以需要在 mem_init_mp 中为每个 CPU 映射内核栈，为每个 CPU 分配了两个 PAGE ，但是只需要映射一个 PAGE ，另一个使用保护 CPU 的栈用以保护栈溢出导致的错误
```c
for (int i; i < NCPU; i++) {
    boot_map_region(kern_pgdir,
                    KSTACKTOP - KSTKSIZE - i * (KSTKSIZE + KSTKGAP),
                    KSTKSIZE,
                    PADDR(percpu_kstacks[i]),
                    PTE_W);
    }
```

由于现在时多核处理器，原来在 trap_init_percpu 中使用全局的TSS and TSS descriptor for BSP 已经不再适用，需要为每个 CPU 初始化
```c
	int cid = thiscpu->cpu_id;
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - cid * (KSTKSIZE + KSTKGAP);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3)+cid] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
					sizeof(struct Taskstate), 0);
	gdt[(GD_TSS0 >> 3)+cid].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0+8*cid);

	// Load the IDT
	lidt(&idt_pd);
```

### 2.4. 多处理器的状态和初始化

-> Our current code spins after initializing the AP in mp_main(). Before letting the AP get any further, we need to first address race conditions when multiple CPUs run kernel code simultaneously. The simplest way to achieve this is to use a big kernel lock. The big kernel lock is a single global lock that is held whenever an environment enters kernel mode, and is released when the environment returns to user mode. In this model, environments in user mode can run concurrently on any available CPUs, but no more than one environment can run in kernel mode; any other environments that try to enter kernel mode are forced to wait.

-> kern/spinlock.h declares the big kernel lock, namely kernel_lock. It also provides lock_kernel() and unlock_kernel(), shortcuts to acquire and release the lock. You should apply the big kernel lock at four locations:

1. In i386_init(), acquire the lock before the BSP wakes up the other CPUs.
2. In mp_main(), acquire the lock after initializing the AP, and then call sched_yield() to start running environments on this AP.
3. In trap(), acquire the lock when trapped from user mode. To determine whether a trap happened in user mode or in kernel mode, check the low bits of the tf_cs.
4. In env_run(), release the lock right before switching to user mode. Do not do that too early or too late, otherwise you will experience races or deadlocks.
---
只需要在相应的位置加上 lock_kernel/unlock_kernel

Question:
-> 因为每个 CPU 运行的内容不一样，但是保存在栈中的内容是不同的


### 2.5. 轮转调度实现

-> The function sched_yield() in the new kern/sched.c is responsible for selecting a new environment to run. It searches sequentially through the envs[] array in circular fashion, starting just after the previously running environment (or at the beginning of the array if there was no previously running environment), picks the first environment it finds with a status of ENV_RUNNABLE (see inc/env.h), and calls env_run() to jump into that environment.
-> sched_yield() must never run the same environment on two CPUs at the same time. It can tell that an environment is currently running on some CPU (possibly the current CPU) because that environment's status will be ENV_RUNNING.
-> We have implemented a new system call for you, sys_yield(), which user environments can call to invoke the kernel's sched_yield() function and thereby voluntarily give up the CPU to a different environment.

```c
	int start = 0;
	int j;
	if (curenv) {
		start = ENVX(curenv->env_id) + 1;	//从当前Env结构的后一个开始
	}
	for (int i = 0; i < NENV; i++) {		//遍历所有Env结构
		j = (start + i) % NENV;
		if (envs[j].env_status == ENV_RUNNABLE) {
			env_run(&envs[j]);
		}
	}
	if (curenv && curenv->env_status == ENV_RUNNING) {
		env_run(curenv);
	}
	// sched_halt never returns
	sched_halt();
```
---
从当前运行的 env 向后查询，如何存在 state 为 RUNNABLE 就通过 env_run 运行新的 env 并结束循环，如何向后查询到最后还没有符合的 env 就从 0 开始直到当前 env，如何都没有，就继续运行当前的 env

Question:
> 因为当前是运行在系统内核中的，而每个进程的页表中都是存在内核映射的。每个进程页表中虚拟地址高于UTOP之上的地方，只有UVPT不一样，其余的都是一样的，只不过在用户态下是看不到的。所以虽然这个时候的页表换成了下一个要运行的进程的页表，但是curenv的地址没变，映射也没变，还是依然有效的。
>因为不保存下来就无法正确地恢复到原来的环境。用户进程之间的切换，会调用系统调用sched_yield()；用户态陷入到内核态，可以通过中断、异常、系统调用；这样的切换之处都是要在系统栈上建立用户态的TrapFrame，在进入trap()函数后，语句curenv->env_tf = *tf;将内核栈上需要保存的寄存器的状态实际保存在用户环境的env_tf域中

## System Calls for Environment Creation
-> 尽管现在我们的内核已经实现了在多个用户环境之间切换，但还是局限于内核最初建立的环境。以下我们要实现允许用户环境去创建并启动新的用户环境。
Unix使用fork实现，其copy了父进程的整个地址空间，唯一可见的不同在于父子进程的ID不一样。父进程中的fork返回子进程号，子进程中的fork返回0。By default, each process gets its own private address space, and neither process's modifications to memory are visible to the other.

### 需要实现以下几个系统调用

#### 系统调用	功能
1. sys_exofork	创建一个新环境， 设定运行状态为ENV_NOT_RUNNABLE，拷贝父进程的寄存器值，置返回值eax为0。
2. sys_env_set_status	修改环境的status
3. sys_page_alloc	分配一个物理页，并插入到页表中（映射到虚拟地址上）
4. sys_page_map	将源进程中的某个虚拟地址对应的页（注意不是拷贝页里面的内容！）映射到目标进程的某个虚拟地址上。
5. sys_page_unmap	解除给定虚拟地址上的的映射
6. sys_exofork，将子进程的Trap Frame – env_tf中的eax寄存器设置为0，就可以实现系统调用sys_exofork给子进程返回0：

```c
// LAB 4: Your code here.
 struct Env *newenv;
 int32_t ret = 0;
 if ((ret = env_alloc(&newenv, curenv->env_id)) < 0) {
     // 两个函数的返回值是一样的
     return ret;
 }
 newenv->env_status = ENV_NOT_RUNNABLE;
 newenv->env_tf = curenv->env_tf;
 // newenv的返回值为0
 newenv->env_tf.tf_regs.reg_eax = 0;

 return newenv->env_id;
sys_env_set_status

// LAB 4: Your code here.
 int ret = 0;
 struct Env *env;
 if (status != ENV_RUNNABLE || status != ENV_NOT_RUNNABLE)
     return -E_INVAL;

 if ((ret = envid2env(envid, &env, 1)) < 0)
     return -E_BAD_ENV;

 env->env_status = status;
 return 0;
sys_page_alloc

// LAB 4: Your code here.
 int ret = 0;
 struct Env *env;

 if ((ret = envid2env(envid, &env, 1)) < 0)
     return -E_BAD_ENV;

 if((uintptr_t)va >= UTOP || PGOFF(va))
     return -E_INVAL;
 if((perm & PTE_SYSCALL) == 0)
     return -E_INVAL;
 if (perm & ~PTE_SYSCALL)
     return -E_INVAL;

 struct PageInfo *pp = page_alloc(ALLOC_ZERO);
 if(!pp)
     return -E_NO_MEM;

 if (page_insert(env->env_pgdir, pp, va, perm) < 0)
     return -E_NO_MEM;

 return 0;
sys_page_map

// LAB 4: Your code here.
 int ret = 0;
 struct Env *srcenv, *dstenv;
 struct PageInfo *srcpp, *dstpp;
 pte_t *pte;
 if ((envid2env(srcenvid, &srcenv, 1) < 0 )|| ( envid2env(dstenvid, &dstenv, 1) < 0)) 
     return -E_BAD_ENV;
 if ((uintptr_t)srcva >= UTOP || PGOFF(srcva) || (uintptr_t)dstva >= UTOP || PGOFF(dstva))
     return -E_INVAL;
 if ( (perm & PTE_SYSCALL)==0 || (perm & ~PTE_SYSCALL))
     return -E_INVAL;
 if (!(srcpp = page_lookup(srcenv->env_pgdir, srcva, &pte)))
     return -E_INVAL;
 if ((perm & PTE_W) && ((*pte & PTE_W) == 0))
     return -E_INVAL;
 if (page_insert(dstenv->env_pgdir, srcpp, dstva, perm) < 0)
     return -E_NO_MEM;

 return 0;
sys_page_unmap

// LAB 4: Your code here.
 int ret = 0;
 struct Env *env;

 if ((ret = envid2env(envid, &env, 1)) < 0)
     return -E_BAD_ENV;
 if ((uintptr_t)va >= UTOP || PGOFF(va))
     return -E_INVAL;
 page_remove(env->env_pgdir, va);
 return 0;
```
---

```c
case SYS_page_alloc:
        return sys_page_alloc((envid_t)a1, (void * )a2, (int )a3);
        break;
    case SYS_page_map:
        return sys_page_map((envid_t) a1, (void *) a2, (envid_t) a3, (void *) a4, (int) a5);
        break;
    case SYS_page_unmap:
        return sys_page_unmap((envid_t) a1, (void *) a2);
        break;
    case SYS_exofork:
        return sys_exofork();
        break;
```

小结
多任务并行，需要由多处理器来支持。如何由引导处理器（BSP)加载应用处理器（APs）是PartA的一个重要环节。应用处理器的启动代码与BSP的启动代码最大的一个区别是：此时的BSP工作在保护模式，以虚拟地址的形式进行寻址，在启动APs时需要由物理地址变换为虚拟地址来加载页目录等操作。启动多处理器后，需要记录各个CPU的Info。因为不能让多个CPU同时进入内核，因此很重要的一点是实现内核的互斥访问。内核互斥与循环调度很容易理解，这个Part最难的一部分在于fork system call 的实现，fork实现了用户环境创建新的用户进程，以区别于之前只是在内建环境之间切换。因为我的 Exe7 实验结果不正确，以至我对这部分代码进行了仔细的研读，虽然最后发现只是在 syscall() 函数中少了一个 return ，但我深刻体会到了 fork 神奇的实现过程。 fork()的实现，创建一个环境并且进行环境复制(tf)，以至于孩子进程也像调用了sys_exofork，并且其返回0（从而可以区分父子进程）。

子进程不像我理解的真正进入了sys_exofork, 而是 fake 的。 子进程只需要保存父进程的 env_tf ， 我一直想要知道的 ret实际上发生在sched_yield()中的env_run()函数 的env_pop_tf(&(curenv->env_tf));语句。 其使得 eip 指向tf->eip， 从而能继续执行sys_exofork的下一条语句。

PART_A 疑问
在Question 1中：
现在遇到链接与加载的问题，还是会觉得有点绕，概念还是有点模糊。比如链接脚本将内核链接到0xF0100000到底是个什么样的概念呢？实际上可以理解为：为所有位置相关代码加上一个偏移。

/* Link the kernel at this address: "." means the current address */
 . = 0xF0100000;
Exercise4: 运行结果为什么会出现3次重复的操作。讲道理只会出现一次啊!
发现经过Exercise 5 之后就没有重启多次的现象了，难道是因为没有Locking，导致在内核中发生了某种错误? 注释掉mp_main中的lock_kernel后输出明显增多。全注释之后，又出现了重启多次的现象！

突然产生了一个疑问，系统是在什么时候进入用户态的？
运行第一个用户程序时，进入用户态，但是这其中怎么实现切换的呢？iret指令？可能与下面这段代码有关。
env_create中加载了二进制文件，其eip等信息存放在e->env_tf中， 在env_run中调用了env_pop_tf(&(curenv->env_tf));， 即执行完这个函数之后，eip已经指向了需要执行的用户程序。
This exits the kernel and starts executing some environment's code.
void
env_pop_tf(struct Trapframe *tf)
{
    // Record the CPU we are running on for user-space debugging
    curenv->env_cpunum = cpunum();

    asm volatile(
        "\tmovl %0,%%esp\n"
        "\tpopal\n"
        "\tpopl %%es\n"
        "\tpopl %%ds\n"
        "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
        "\tiret\n"
        : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
}
COW，spawn， 方法级切换，内核用户态切换，线程级&进程级，VM级，不同层次的切换涉及的上下文不一样。很多工作都与这个相关，像上次说的checkpoint，快照，或是code offloading。

Exercise 8
Now it comes to Part B, the hardest part of this lab, also the hardest part so far. But this exercise is as simple as the previous one. Read the comment thoroughly will give you all you need.

static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
    struct Env *e;
    int r;

    if ((r = envid2env(envid, &e, 1)) != 0) {
        return r;
    }
    e->env_pgfault_upcall = func;
    return 0;
}
Also, don't forget to add a case in syscall().

case SYS_env_set_pgfault_upcall:
    return sys_env_set_pgfault_upcall(a1, (void *)a2);
Exercise 9
Now we need to set up the UTrapframe structure and save the trap-time state in it for the copy-on-write page fault handler. Though the comment in page_fault_handler() is very long, it worth reading as such a long comment contains almost everything we need. You should also read the lab page thoroughly. What we need to do can be concluded into the 5 steps following:

Check whether the environment's page fault upcall exists. If not, destroy the environment.

Find where the page fault stack frame UTrapframe should be located. If it is not caused by another page fault, it is right below UXSTACKTOP. Or it is below the previous stack frame, a 32-bit should be pushed first. To test whether tf->tf_esp is already on the user exception stack, check whether it is in the range between UXSTACKTOP-PGSIZE and UXSTACKTOP-1, inclusive.

Check whether the environment allocated a page for its exception stack, the permission to write it and whether the exception stack overflows. If one of these situations occurs, destroy the environment. This can be done with calling user_mem_assert() as the hint says.

Set up the UTrapframe, copy the register values, error code and fault_va into it. Most of these values are in the TrapFrame and fault_va is provided.

Run the page fault handler with UTrapframe in user mode. So we need to modify the esp and eip of TrapFrame and call env_run() to give control back to the user environment and run the page fault handler.

Here is my code:

void
page_fault_handler(struct Trapframe *tf)
{
    uint32_t fault_va;

    // Read processor's CR2 register to find the faulting address
    fault_va = rcr2();

    // Handle kernel-mode page faults.
    if ((tf->tf_cs & 0x3) == 0) {
        panic("page_fault_handler: page fault in kernel mode");
    }

    // We've already handled kernel-mode exceptions, so if we get here,
    // the page fault happened in user mode.
    if (curenv->env_pgfault_upcall) {
        struct UTrapframe *utf;

        // Determine the location
        if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
            *(uint32_t *)(tf->tf_esp - 4) = 0;  // push an empty 32-bit word
            utf = (struct UTrapframe *)(tf->tf_esp - 4 - sizeof(struct UTrapframe));
        } else {
            utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
        }

        // Check permission
        user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W | PTE_U);

        // Set up the user trap frame
        utf->utf_esp = tf->tf_esp;
        utf->utf_eflags = tf->tf_eflags;
        utf->utf_eip = tf->tf_eip;
        utf->utf_regs = tf->tf_regs;
        utf->utf_err = tf->tf_err;
        utf->utf_fault_va = fault_va;

        // Switch the environment
        tf->tf_esp = (uint32_t)utf;
        tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
        env_run(curenv);
    }

    // Destroy the environment that caused the fault.
    cprintf("[%08x] user fault va %08x ip %08x\n",
        curenv->env_id, fault_va, tf->tf_eip);
    print_trapframe(tf);
    env_destroy(curenv);
}

There is also a simple question to answer, "What happens if the user environment runs out of space on the exception stack?". The comment of page_fault_handler() has already given us the answer. If it runs out of space, it cannot pass the user_mem_assert() and the function will destroy the environment that caused the fault.

Exercise 10
This is really a hard one since what we need to write here is all x86 assembly code here. The _pgfault_upcall routine in lib/pfentry.S has already implemented the procedure to call the page fault handler. What we need to write here is the procedure to return to the original point in the user code that caused the page fault, so we must have a clear view of how a control transfer is performed at the machine level.

The following figure from Figure 3.26 of CS:APP3e shows how a usual call-return procedure is performed on x86-64. x86 is very similar to this, except for the register name.

call-ret.jpg

The call instruction will push the next instruction of the caller to be executed in eip onto the stack, then create a new stack frame for the callee. The callee will push registers to save like ebp onto the stack. After the callee has done its job, it will pop these saved registers back, and use a ret instruction to give control back to the caller. The ret works the same as pop %eip.

Here since it is not a usual call-return. We need to modify the caller's stack frame to "push" the eip onto the stack frame of the caller. That is to say, we need to enlarge the stack of the caller for 4 bytes to put the saved eip. And that's why we need the empty 32-bit word for nested page faults. Then we need to manually pop back the saved registers in a user exception stack frame, and finally, give control back to where the page fault is encountered.

So what we need to adjust the stack like this:

Before:
   Previous Frame                 User Trap Frame
+------------------+            +------------------+
| stack data       |      +---- | trap-time esp    |
| ...              |      |     | trap-time eflags |
+------------------+ <----+     | trap-time eip    |
                                | trap-time eax    |  
                                | ...              |
                                | trap-time esi    |
                                | trap-time edi    |  
                                | tf_err           |
                                | fault_va         |
                                +------------------+  <-- %esp
After:
   Previous Frame                 User Trap Frame
+------------------+            +------------------+
| stack data       |      +---- | trap-time esp-4  |
| ...              |      |     | trap-time eflags |
| trap-time eip    |      |     | trap-time eip    |
+------------------+ <----+     | trap-time eax    |  
                                | ...              |
                                | trap-time esi    |
                                | trap-time edi    |  
                                | tf_err           |
                                | fault_va         |
                                +------------------+  <-- %esp
Beware that previous stack frame can either a normal user stack frame or an exception stack frame. So we cannot use move the trap-time eip directly to 0x34(%esp).

And this is my implementation.

// Save trap-time eip next to previous stack (that's why we need the empty dword)
movl 0x30(%esp), %ecx    // save trap-time esp in ecx
subl $4, %ecx            // enlarge the previous stack for 4 bytes
movl %ecx, 0x30(%esp)    // write the modified esp back
movl 0x28(%esp), %edx    // save trap-time eip in edx
movl %edx, (%ecx)        // save eip at new esp for return

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
addl $8, %esp            // skip fault_va and tf_err
popal                    // pop PushRegs

// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
addl $4, %esp            // skip eip
popfl                    // pop eflags

// Switch back to the adjusted trap-time stack.
pop %esp

// Return to re-execute the instruction that faulted.
ret
Exercise 11
This exercise is not difficult. Since it is in user mode, we need to use the syscalls implemented in Exercise 7 & 8 to implement this. Also remember to handle errors.

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
    int r;

    if (_pgfault_handler == 0) {
        // First time through!
        if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
            panic("set_pgfault_handler: %e", r);
        }
        if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
            panic("set_pgfault_handler: %e", r);
        }
    }

    // Save handler pointer for assembly to call.
    _pgfault_handler = handler;
}
Now run make grade we shall pass all tests in Part B except for forktree.

Exercise 12
After doing so much prepare work, now we are going to implement the copy-on-write fork.

Before coding, it is suggested to take a look at the uvpt[] and uvpd[] we will use later here. Here, JOS uses a clever mapping trick which maps the page table to UVPT so that user code can read the PTE and PDE contents. x86 processors will read the 2 level page table to access a virtual memory address. If we access the address at UVPT+i, it will return us the PTE, and the offset i is the page number. For example, if we access 0xef410100, the processor will first read the PDE, the 0x3bd entry of page directory, then the PTE, the 0x10 entry of page table, then the content, the 0x100 entry of the page. Here the PDE points to the page table, so the PTE being read is the same as PDE, and the content is the PTE of 0x04040000~0x04040fff. The offset is the DIR and the PAGE part of the virtual address, so it is the page number. In the example, uvpt[0x10100] is the PTE for 0x04040000~0x04040fff. Specially, if we access uvpt + UVPT >> 10, it will return the PDE since the content is still the PDE, and the offset here is the page directory index.

Below shows what is at UVPT:

     0                 4                 8                                ...
     +-----------------+-----------------+-----+----------------------+-----+
UVPT | PTEs for 0x0000 | PTEs for 0x1000 | ... | PTEs for UVPT / PDEs | ... | UVPT+PGSIZE
     +-----------------+-----------------+-----+----------------------+-----+
     ^ uvpt[]                                  ^ uvpd[]
It is very confusing and hard to understand. The following figure may help you understand it.'

vpt.png

In this figure, the circular arrow is followed once for uvpt[] and twice for uvpd[].

Now we can proceed to coding. The first one to implement is fork(). It is very similar to dumbfork(), except how the copy is performed. As the comment says we also need to set up page fault handler, create a child and allocate a new page for the child's user exception stack. A page fault upcall also needs to be set, and that's we will easily neglect here, including me. And here is my implemention.

envid_t
fork(void)
{
    envid_t envid;
    uint32_t addr;
    int r;

    set_pgfault_handler(pgfault);
    envid = sys_exofork();
    if (envid < 0) {
        panic("sys_exofork: %e", envid);
    }
    if (envid == 0) {
        // fix thisenv in child
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // copy the address space mappings to child
    for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
        if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
            duppage(envid, PGNUM(addr));
        }
    }

    // allocate new page for child's user exception stack
    void _pgfault_upcall();

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
        panic("fork: %e", r);
    }
    if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
        panic("fork: %e", r);
    }

    // mark the child as runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
        panic("fork: %e", r);

    return envid;
}
duppage() is not difficult. Here we map the page for the child environment. If the page is writable, we need to map it in both environments as a COW page so that they won't interfere with each other, and if it is read-only, simply map it in the child. Here we should use the syscalls we implemented in Exercise 8.

static int
duppage(envid_t envid, unsigned pn)
{
    envid_t parent_envid = sys_getenvid();
    void *va = (void *)(pn * PGSIZE);
    int r;

    if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
        if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
            panic("duppage: %e", r);
        }
        if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
            panic("duppage: %e", r);
        }
    } else {
        if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
            panic("duppage: %e", r);
        }
    }

    return 0;
}
The last one pgfault() uses syscalls to copy the page on page faults. The comment provides many hints so it is easy to implement.

static void
pgfault(struct UTrapframe *utf)
{
    void *addr = (void *) utf->utf_fault_va;
    uint32_t err = utf->utf_err;
    pte_t pte = uvpt[PGNUM(addr)];
    envid_t envid = sys_getenvid();
    int r;

    if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
        panic("pgfault: bad faulting access\n");
    }
    if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
        panic("pgfault: %e", r);
    }
    memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
    if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
        panic("pgfault: %e", r);
    }
    if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
        panic("pgfault: %e", r);
    }
}
Now forktree test in make grade will be passed.

Exercise 13
This part is much simpler than Part B. This exercise requires to add more interrupt handler in kern/trapentry.S and kern/trap.c:trap(). Adding a handler is very simple. If you forget how to do this, see Exercise 4 of Lab 3.

Section 6.15 of Intel® 64 and IA-32 Architectures Software Developer's Manual: Volume 3 indicates that user-defined interrupts don't contain an error code.

In kern/trapentry.S:

@@ -66,3 +66,9 @@ TRAPHANDLER(th_align, T_ALIGN)
 TRAPHANDLER_NOEC(th_mchk, T_MCHK)
 TRAPHANDLER_NOEC(th_simderr, T_SIMDERR)
 TRAPHANDLER_NOEC(th_syscall, T_SYSCALL)
+TRAPHANDLER_NOEC(th_irq_timer, IRQ_OFFSET + IRQ_TIMER)
+TRAPHANDLER_NOEC(th_irq_kbd, IRQ_OFFSET + IRQ_KBD)
+TRAPHANDLER_NOEC(th_irq_serial, IRQ_OFFSET + IRQ_SERIAL)
+TRAPHANDLER_NOEC(th_irq_spurious, IRQ_OFFSET + IRQ_SPURIOUS)
+TRAPHANDLER_NOEC(th_irq_ide, IRQ_OFFSET + IRQ_IDE)
+TRAPHANDLER_NOEC(th_irq_error, IRQ_OFFSET + IRQ_ERROR)
In kern/trap.c


@@ -90,3 +90,9 @@ trap_init(void)
        void th_mchk();
        void th_simderr();
        void th_syscall();
+       void th_irq_timer();
+       void th_irq_kbd();
+       void th_irq_serial();
+       void th_irq_spurious();
+       void th_irq_ide();
+       void th_irq_error();
@@ -110,3 +116,9 @@ trap_init(void)
        SETGATE(idt[T_MCHK], 0, GD_KT, &th_mchk, 0);
        SETGATE(idt[T_SIMDERR], 0, GD_KT, &th_simderr, 0);
        SETGATE(idt[T_SYSCALL], 0, GD_KT, &th_syscall, 3);
+       SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, &th_irq_timer, 0);
+       SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, &th_irq_kbd, 0);
+       SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, &th_irq_serial, 0);
+       SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS], 0, GD_KT, &th_irq_spurious, 0);
+       SETGATE(idt[IRQ_OFFSET + IRQ_IDE], 0, GD_KT, &th_irq_ide, 0);
+       SETGATE(idt[IRQ_OFFSET + IRQ_ERROR], 0, GD_KT, &th_irq_error, 0);
We also need to enable interrupts in user mode. This can be done by adding this to kern/env.c:env_alloc().

@@ -256,2 +256,2 @@ env_alloc(struct Env **newenv_store, envid_t parent_id)
        // Enable interrupts while in user mode.
-       // LAB 4: Your code here.
+       e->env_tf.tf_eflags |= FL_IF;
And don't forget to uncomment the sti instruction in kern/sched.c:sched_halt() so that idle CPUs unmask interrupts.

---
在注册异常处理函数时，我把 syscall 作为 trap 通过 SETGATE 注册，但是在运行 StressSched 时出现了 assert(!(read_eflags() & FL_IF)); 断言失败的错误，一开始我以为是设置 FL_IF 标志的位置不对，代是在检查 env_alloc 后发现没有问题，然后我就去找了一个别人的正确实现做 difftest，发现在 env_run 中 lcr3 之前的行为是一致的，百思不得其解，反复的 rtfsc，突然在 trap_init 里 使用 SETGATE 注册 syscall 的异常处理函数时，发现别人实现的是 istrap 参数的值是0, 而我是1, 因为我觉得 syscall 是用户陷入 kernel， 并不是 interrupt.但是事实是却是需要将 istrap 的参数设置为0.

#### transferring pages
---
When an environment calls sys_ipc_recv with a valid dstva parameter (below UTOP), the environment is stating that it is willing to receive a page mapping. If the sender sends a page, then that page should be mapped at dstva in the receiver's address space. If the receiver already had a page mapped at dstva, then that previous page is unmapped.

When an environment calls sys_ipc_try_send with a valid srcva (below UTOP), it means the sender wants to send the page currently mapped at srcva to the receiver, with permissions perm. After a successful IPC, the sender keeps its original mapping for the page at srcva in its address space, but the receiver also obtains a mapping for this same physical page at the dstva originally specified by the receiver, in the receiver's address space. As a result this page becomes shared between the sender and receiver.

If either the sender or the receiver does not indicate that a page should be transferred, then no page is transferred. After any IPC the kernel sets the new field env_ipc_perm in the receiver's Env structure to the permissions of the page received, or zero if no page was received.


```c
// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	/* panic("sys_ipc_try_send not implemented"); */
  struct Env *e;
  if (envid2env(envid, &e, 0) < 0)
    return -E_BAD_ENV;
  if (e->env_ipc_recving == 0)
    return -E_IPC_NOT_RECV;

  if ((uint32_t)srcva < UTOP) {
    if (srcva != ROUNDDOWN(srcva, PGSIZE))
      return -E_INVAL;

	  if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
	      return -E_INVAL;
	  }

	  if ((perm & ~(PTE_SYSCALL)) != 0) {
	      return -E_INVAL;
	  }

    pte_t *pte;
    struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
    if (pp == NULL)
      return -E_INVAL;

    if ((perm & PTE_W) && !(*pte & PTE_W))
      return -E_INVAL;

    if (page_insert(e->env_pgdir, pp, e->env_ipc_dstva, perm) < 0)
      return -E_INVAL;
    e->env_ipc_perm = perm;
  } else {
    e->env_ipc_perm = 0;
  }

  e->env_ipc_recving = 0;
  e->env_ipc_from = curenv->env_id;
  e->env_ipc_value = value;
  e->env_status = ENV_RUNNABLE;
  e->env_tf.tf_regs.reg_eax = 0;
  return 0;
}
// 首先需要通过 envid 获取 env，如果 envid 对应的 env 不存在就返回 -E_BAD_ENV
// 然后在判断 env 是否正在 recving， 如果是就返回 -E_IPC_NOT_RECV
// 如果 srcva < UTOP, 就类似 sys_page_alloc 检查权限
// 符合所有的条件后，就把 perm 存放到 env 中的 env_ipc_perm
// 更新 target's ipc fields
// env_ipc_from is sending envid(curenv->env_id)
// envid is receive envid
// 为什么需要设置寄存器 reg_eax 的值为0
```

```c
// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	/* panic("sys_ipc_recv not implemented"); */
  if ((uint32_t)dstva < UTOP && dstva != ROUNDDOWN(dstva, PGSIZE))
    return -E_INVAL;

  curenv->env_ipc_recving = 1;
  curenv->env_ipc_dstva = dstva;
  curenv->env_status = ENV_NOT_RUNNABLE;
  sched_yield();
	return 0;
}
// 检查 dstva，dstva < UTOP并且没有对齐就返回 -E_INVAL
// 更新 dst env 的 ipc fields
// 主动放弃 CPU
```
```c
// Receive a value via IPC and return it.
// If 'pg' is nonnull, then any page sent by the sender will be mapped at
//	that address.
// If 'from_env_store' is nonnull, then store the IPC sender's envid in
//	*from_env_store.
// If 'perm_store' is nonnull, then store the IPC sender's page permission
//	in *perm_store (this is nonzero iff a page was successfully
//	transferred to 'pg').
// If the system call fails, then store 0 in *fromenv and *perm (if
//	they're nonnull) and return the error.
// Otherwise, return the value sent by the sender
//
// Hint:
//   Use 'thisenv' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
	// LAB 4: Your code here.
	/* panic("ipc_recv not implemented"); */
  if (pg == NULL)
    pg = (void *)UTOP;
  int ret;
  if ((ret= sys_ipc_recv(pg)) < 0) {
    if (from_env_store != NULL)
      *from_env_store = 0;
    if (perm_store != NULL)
      *perm_store = 0;
    return ret;
  }
  if (from_env_store != NULL)
    *from_env_store = thisenv->env_ipc_from;
  if (perm_store != NULL)
    *perm_store = thisenv->env_ipc_perm;
	return thisenv->env_ipc_value;
}

// Send 'val' (and 'pg' with 'perm', if 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	/* panic("ipc_send not implemented"); */
  int ret;
  if (pg == NULL)
    pg = (void *)UTOP;
  do {
    ret = sys_ipc_try_send(to_env, val, pg, perm);
    if (ret < 0 && ret != -E_IPC_NOT_RECV)
      panic("ipc_send: %e", E_IPC_NOT_RECV);
    sys_yield();
  } while(ret != 0);
}
```

