# MIT6.828 LAB2_Part1_物理内存管理
## 简介
-> 在本实验中，我们将编写操作系统的内存管理代码。 内存管理有两个组成部分。

-> 第一个部分是内核的物理内存分配器，以致于内核可以分配和释放内存。 分配器将以4096字节为操作单位，称为一个页面。 我们的任务是维护一个数据结构，去记录哪些物理页面是空闲的，哪些是已分配的，以及共享每个已分配页面的进程数。 我们还要编写例程来分配和释放内存页面。

-> 内存管理的第二个组件是虚拟内存，它将内核和用户软件使用的虚拟地址映射到物理内存中的地址。 当指令使用内存时，x86硬件的内存管理单元（MMU）执行映射，查询一组页表。 我们根据任务提供的规范修改JOS以设置MMU的页面表。

-> lab2包含的新源文件：

---
inc/memlayout.h
kern/pmap.c
kern/pmap.h
kern/kclock.h
kern/kclock.c
---

## Part 1: Physical Page Management
### 物理内存页管理
-> 操作系统必须跟踪物理RAM的哪些部分是空闲的以及哪些是当前正在使用的。 JOS以页为粒度管理PC的物理内存，以便它可以使用MMU映射和保护每个分配的内存。
-> 
-> 在编写剩余的虚拟内存实现之前，您需要编写物理页分配器，因为页表管理代码为页表的存储 分配物理内存。
-> 
Exercise 1
-> 必须实现kern/pmap.c 中的以下函数
```c
boot_alloc()
mem_init() (only up to the call to check_page_free_list(1))
page_init()
page_alloc()
page_free()
check_page_free_list() and check_page_alloc()可以测试你的物理分页器。
```
发现突然不像LAB1那样有详细的步骤，有点无从下手的感觉。

```c

typedef char* va_list;
// 以4字节为单位对齐
#define _INTSIZEOF(n) (sizeof(n)+sizeof(int)-1)& ~(sizeof(int)-1)
// 求得参数栈的第一个参数地址
#define va_start(ap, v) (ap = (va_list)&v + _INTSIZEOF(v)) 
// 这里很巧妙，ap+SIZE指向下一个参数地址，再返回总体减去size（即又指回了当前变量） 
#define va_arg(ap, t)   (*(t *) ((ap+=_INTSIZEOF(t)) - _INTSIZEOF(t)) )
#define va_end(ap)  (ap = (va_list) 0)
va_list ap	// 定义一个变差变量ap
va_start(ap, last)	// 初始化ap,得到可变参数列表的第一个参数的确切地址。实际就是指向参数堆栈的栈顶
va_arg(ap, type)	// 已知变量类型为type的情况下，获得下一个变参变量
va_end(ap)	// 结束操作
// 感觉还是需要详细理解一下lab1中Part3的虚拟内存部分。
// 在对entry_pgdir进行初始化的时候发现一个神奇的写法，暂时不明白，占个坑。
// entry_pgdir的写法也是内存映射的一个重要部分。

__attribute__((__aligned__(PGSIZE)))
pde_t entry_pgdir[NPDENTRIES] = {
 // Map VA's [0, 4MB) to PA's [0, 4MB)
 // 在数组定义中，这是什么写法？
 [0]
     = ((uintptr_t)entry_pgtable - KERNBASE) + PTE_P,
 // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
 [KERNBASE>>PDXSHIFT]
     = ((uintptr_t)entry_pgtable - KERNBASE) + PTE_P + PTE_W
};
```
-> 实现

-> boot_alloc(), 源代码中有个骚操作，其利用链接器来得到第一个未使用的bss段的内存地址。extern char end[];不得不说 amazing !

-> 'end'是链接器自动生成的魔术符号，它指向内核的bss段的末尾：链接器未分配给任何内核代码或全局变量的第一个虚拟地址。
```c
// LAB 2: Your code here.
    result = nextfree;
    nextfree = ROUNDUP(nextfree+n, PGSIZE); 
    
    return result;
```
-> page_init()其实并不复杂，但是有很多细节部分要注意好。一开始没看懂注释要表达什么意思，查看了其他大神的代码才豁然开朗。
```c
// 1.mark page 0 as in use
    // 这样我们就可以保留实模式IDT和BIOS结构，以备不时之需。
    pages[0].pp_ref = 1;

    // 2.
    size_t i;
    for (i = 1; i < npages_basemem; i++) {
        pages[i].pp_ref = 0;
        pages[i].pp_link = page_free_list;
        page_free_list = &pages[i];
    }

    // 3.[IOPHYSMEM, EXTPHYSMEM)
    // mark I/O hole
    for (;i<EXTPHYSMEM/PGSIZE;i++) {

        pages[i].pp_ref = 1;
    }

    // 4. Extended memory 
    // 还要注意哪些内存已经被内核、页表使用了！
    // first需要向上取整对齐。同时此时已经工作在虚拟地址模式（entry.S对内存进行了映射）下，
    // 需要求得first的物理地址
    physaddr_t first_free_addr = PADDR(boot_alloc(0));
    size_t first_free_page = first_free_addr/PGSIZE;
    for(;i<first_free_page;i++) {
        pages[i].pp_ref = 1;
    }
    // mark other pages as free
    for(;i<npages;i++) {
        pages[i].pp_ref = 0;
        pages[i].pp_link = page_free_list;
        page_free_list = &pages[i];
    }
```
-> page_alloc(),页分配并不是我一开始理解的需要让一个虚存（填到页表项中，这样就会很复杂）指向目前的空闲物理页。所以我认为其函数的返回值struct PageInfo *很没有道理。 实际上只需要从空闲链表中取出第一个空闲页即可。如果传了标志alloc_flags则对一个PAGESIZE的内存进行清零。
```c
// Fill this function in
    struct PageInfo* pp;
    if (!page_free_list) {
        return NULL;
    }
    pp = page_free_list;
    page_free_list = page_free_list->pp_link;
    pp->pp_link = NULL;
    
    //page2kva 返回值 KernelBase + 物理页号<<PGSHIFT,  虚拟地址
    
    if (alloc_flags & ALLOC_ZERO) {

        void * va = page2kva(pp);
        memset(va, '\0', PGSIZE);
    }
    return pp;
```
-> page_free(),这个函数编写就很简单了，注释里的hint页给得比较详细了，清楚地告诉了你需要注意的点。

```c
if(pp->pp_link || pp->pp_ref) {
     panic("pp->pp_ref is nonzero or pp->pp_link is not NULL\n");
 }
 pp->pp_link = page_free_list;
 page_free_list = pp;
```
### 结果
-> 运行make qemu终端打印如下：

```txt
check_page_free_list() succeeded!
check_page_alloc() succeeded!
kernel panic at kern/pmap.c:745: assertion failed: page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0
```
-> check_page_free_list and check_page_alloc都已经通过了，但是在chek_page时发生了panic，因为我们的page_insert还没有是实现。之后的练习会进一步实现其功能。

Part2：Virtual Memory
首先要熟悉x86的保护模式的内存管理体系，也就是分段和页转换。

Exercise 2
如果您还不熟悉分段与分页，请查看“Intel 80386参考手册”的第5章和第6章。 仔细阅读有关页面转换和基于页面的保护的部分（5.2和6.4）。 我们建议您浏览有关细分的部分; 虽然JOS使用分页硬件进行虚拟内存和保护，但在x86上无法禁用分段转换和基于段的保护，因此您需要对它有基本的了解。
Intel 80386 Reference Programmer's ManualTable of Contents

感觉x86的分段式特别复杂，配置起来很繁琐。 分页式相对来说就很清晰明了了，I like it.

虚拟、线性和物理内存
在x86术语中，虚拟地址由段选择器和段内偏移组成。 线性地址是段转换之后但在页转换之前获得的。 物理地址是在段和页面转换之后得到的，以及最终经过总线到达RAM的内容。
MIT6.828 LAB2_Part2_虚拟内存

exercise 3
第一个窗口执行make qemu-gdb， 第二个执行make gdb. 然后第二个窗口执行c 在ctrl+c终止程序。键入查看内存指令x/16xw 0xf0100000:

(gdb) x/16xw 0xf0100000
0xf0100000 <_start+4026531828>:    0x1badb002    0x00000000    0xe4524ffe    0x7205c766
0xf0100010 <entry+4>:    0x34000004    0x2000b812    0x220f0011    0xc0200fd8
0xf0100020 <entry+20>:    0x0100010d    0xc0220f80    0x10002fb8    0xbde0fff0
0xf0100030 <relocated+1>:    0x00000000    0x112000bc    0x0056e8f0    0xfeeb0000
第二终端再按c，保持程序的运行。 第一终端按ctrl+a c 出现qemu终端。

(qemu) xp/16xw 0x100000
0000000000100000: 0x1badb002 0x00000000 0xe4524ffe 0x7205c766
0000000000100010: 0x34000004 0x2000b812 0x220f0011 0xc0200fd8
0000000000100020: 0x0100010d 0xc0220f80 0x10002fb8 0xbde0fff0
0000000000100030: 0x00000000 0x112000bc 0x0056e8f0 0xfeeb0000
两个地址上的内容一致，故可以证明0xf0100000虚拟地址映射到了0x100000物理地址上。

一旦进入保护模式，所有的指针都会被解释成虚拟地址并由MMU翻译。

JOS内核通常需要将地址转换为不透明值或整数，而不需要对它们解引用，例如在物理内存分配器中。 有时这些是虚拟地址，有时它们是物理地址。 为了帮助规范代码，JOS源代码区分了两种情况：类型uintptr_t表示不透明的虚拟地址，physaddr_t表示物理地址。 这两种类型实际上只是32位整数（uint32_t）的同义词，因此编译器不会阻止您将一种类型分配给另一种类型！ 由于它们是整数类型（不是指针），如果您尝试对它们解引用，编译器就会给出警告或错误。

JOS内核可以通过首先将其转换为指针类型来解引用uintptr_t。 相反，内核不能明智地解引用物理地址，因为MMU会转换所有内存引用。 如果将physaddr_t转换为指针并解引用它，您可以加载并存储到结果地址（硬件会将其解释为虚拟地址），但您可能无法获得预期的内存位置。

Questions
Assuming that the following JOS kernel code is correct, what type should variable x have, uintptr_t or physaddr_t?
mystery_t x;
char* value = return_a_pointer();
*value = 10;
x = (mystery_t) value;
答： 是uintprt_t

第三句对*value进行了赋值，所以value肯定是一个虚拟地址，因为直接解引用物理地址是没有意义的。那么x肯定也是虚拟地址，要不然将虚拟地址赋值给一个物理地址也没有意义的。
引用计数
使用page_alloc时要小心。 它返回的页面的引用计数始终为0，因此只要您对返回的页面执行某些操作（例如将其插入页面表），pp_ref就应该递增。 有时这是由其他函数处理的（例如，page_insert），有时调用page_alloc的函数必须直接执行。

页表管理
现在，您将编写一组用于管理页表的例程：插入和删除线性到物理映射，以及在需要时创建页表页。

首先还复习一下MMU的知识。MMU (一）

Execise 4
```c
// In the file kern/pmap.c, you must implement code for the following functions.
pgdir_walk()
boot_map_region()
page_lookup()
page_remove()
page_insert()

/*
check_page(), called from mem_init(), tests your page table management routines. You should make sure it reports success before proceeding.
*/
```
-> 需要复习一下LAB1的PART3部分，其处通过一个手写的页表，实现了4M的虚拟内存向物理内存的映射，理解页目录表，页目录项，页表，页表项的异同。
-> 
-> 名词	说明
-> 页目录表	存放各个页目录项的表，页目录常驻内存，页目录表的物理地址存在寄存器CR3中
-> 页目录项	存放各个二级页表起始物理地址
-> 页表	存放页表项
-> 页表项	页表项的高20位存放各页的对应的物理地址的高20位
### 最终代码
```c
pgdir_walk
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
    // Fill this function in
    uint32_t pdx = PDX(va);   // 页目录项索引
    uint32_t ptx = PTX(va);   // 页表项索引
    pte_t   *pde;             // 页目录项指针
    pte_t   *pte;             // 页表项指针
    struct PageInfo *pp;
    
    pde = &pgdir[pdx];        //获取页目录项
    
    if (*pde & PTE_P) {
        // 二级页表有效
        // PTE_ADDR得到物理地址，KADDR转为虚拟地址
        pte = (KADDR(PTE_ADDR(*pde)));
    }
    else {

        // 二级页表不存在，
        if (!create) {
            return NULL;
        }
        // 获取一页的内存，创建一个新的页表，来存放页表项
        if(!(pp = page_alloc(ALLOC_ZERO))) {  
            return NULL;
        }
        pte = (pte_t *)page2kva(pp);
        pp->pp_ref++; 
        *pde = PADDR(pte) | (PTE_P | PTE_W | PTE_U);  // 设置页目录项
    }
     // 返回页表项的虚拟地址
    return &pte[ptx];                              
}
```
```c
// 1.5.2. boot_map_region
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    size_t pgs = size / PGSIZE;    
    if (size % PGSIZE != 0) {
        pgs++;
    }                            //计算总共有多少页
    for (int i = 0; i < pgs; i++) {
        pte_t *pte = pgdir_walk(pgdir, (void *)va, 1);//获取va对应的PTE的地址
        if (pte == NULL) {
            panic("boot_map_region(): out of memory\n");
        }
        *pte = pa | PTE_P | perm; //修改va对应的PTE的值
        pa += PGSIZE;             //更新pa和va，进行下一轮循环
        va += PGSIZE;
    }
}
```
```c
// 1.5.3. page_insert
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    // Fill this function in
    pte_t *pte = pgdir_walk(pgdir, va, 1);
    
    if (!pte) {

        return -E_NO_MEM;
    }
    
    if (*pte & PTE_P) {
        if (PTE_ADDR(*pte) == page2pa(pp)) {

            // 插入的是同一个页面，只需要修改权限等即可
            pp->pp_ref--;
        }
        else {

            page_remove(pgdir, va);
        }
        
    }
    
    pp->pp_ref++;
    *pte = page2pa(pp)| perm | PTE_P;
    
    return 0;
}
```

```c
// 1.5.4. page_lookup
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
    // Fill this function in
    pte_t *pte = pgdir_walk(pgdir, va, 0);
    if (!pte) {

        return NULL;
    }
    if (pte_store) {
        *pte_store = pte;  // 通过指针的指针返回指针给调用者
    }
    
    // 难道不用考虑页表项是否存在
    
    if (*pte & PTE_P) {

        return (pa2page(PTE_ADDR(*pte)));
    }
    
    return NULL;
    
    //return pa2page(PTE_ADDR(*pte));
}
```

```c
// 1.5.5. page_remove
void
page_remove(pde_t *pgdir, void *va)
{
    // Fill this function in
    // 二级指针有点晕
    pte_t *pte;
    pte_t **pte_store = &pte;
    
    struct PageInfo *pi = page_lookup(pgdir, va, pte_store);
    if (!pi) {
        return ;
    }
    
    page_decref(pi);     // 减引用
    
    **pte_store = 0;     // 取消映射
    tlb_invalidate(pgdir, va);
}
```

初始化内核地址空间
Exercise 5
Fill in the missing code in mem_init() after the call to check_page().
Your code should now pass the check_kern_pgdir() and check_page_installed_pgdir() checks.
错误
kernel panic at kern/pmap.c:787: assertion failed: check_va2pa(pgdir, KERNBASE + i) == i

实际卡在以下语句下，

// check phys mem
 for (i = 0; i < npages * PGSIZE; i += PGSIZE)
     assert(check_va2pa(pgdir, KERNBASE + i) == i);
发现其以npages * PGSIZE为检查边界，修改KERNBASE以上内存的映射代码为

boot_map_region(kern_pgdir, 
                 KERNBASE, 
                 npages * PGSIZE,
                 0,
                 PTE_W );
又出现了以下错误：

kernel panic at kern/pmap.c:804: assertion failed: pgdir[i] & PTE_P.
调试发现，页目录表中的页目录项，960-991索引项都通过assert,错误发生在992项处，即992项无效。（991-960+1）*2^10 = 2^15 = 32768. 刚好等于npages的值。
感觉是npages 与 0xFFFFFFFF-KERNBASE不一致导致的。打印npages =32768, (0xFFFFFFFF-KERNBASE)/PGSIZE 向上取整= 65536页。很明显用npages映射的内存远远没有后一种方法多，所以出现第二种错误很正常，但是第一种错误为什么会出现呢？

继续改为出现第一种错误的写法，通过调试发现，在 i=0时就出错了，证明KERNBASE根本就没有映射到物理地址0处。

根本没有道理啊，第二种能映射成功，证明是没有问题的呀。而且之前的两次boot_map_region都没有问题， 应该是第三次的size= 268435456过大导致boot_map_region（）出现了Bug。

最初写法,发现用va+size会出现溢出的情况，比如当前情况，size=268435456=0x10000000, va=0xF0000000, 两者相加直接等于0了。 所以当我们用第二种npage*PGSIZE时能成功初始化一部分映射。
并且，当我们直接给size传入0xFFFFFFFF-KERNBASE即等于0xFFF_FFFF,其与va相加为0xFFFF_FFFF, 就会出现死循环。因为pva从0xF000_0000开始增长，最大只能为0xFFFF_F000，永远不会有大于等于va+size的时候。

static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    uintptr_t pva = va;
    physaddr_t ppa = pa;
    pte_t *pte;
 
    for (; pva < va+size; pva+=PGSIZE, ppa+=PGSIZE) //循环映射
    {
        pte = pgdir_walk(pgdir, (void *)pva, 1);    //查找页表项
        if (!pte)
        {
            return;
        }
        *pte = PTE_ADDR(ppa) | (perm | PTE_P);        //设置页表项
    }
}
修改后：

static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    size_t pgs = size / PGSIZE;    
    if (size % PGSIZE != 0) {
        pgs++;
    }                            //计算总共有多少页
    for (int i = 0; i < pgs; i++) {
        pte_t *pte = pgdir_walk(pgdir, (void *)va, 1);//获取va对应的PTE的地址
        if (pte == NULL) {
            panic("boot_map_region(): out of memory\n");
        }
        *pte = pa | PTE_P | perm; //修改va对应的PTE的值
        pa += PGSIZE;             //更新pa和va，进行下一轮循环
        va += PGSIZE;
    }
}
最终代码
要求把pages结构体所在的页面和虚拟地址UPAGES相互映射。这里只要计算出pages结构体的大小，就可以进行映射了。说实话，之前注释有点没看懂。以为要实现虚存对pages指向的物理页的映射。

boot_map_region(kern_pgdir, 
                 UPAGES, 
                 ROUNDUP((sizeof(struct PageInfo)*npages), PGSIZE),
                 PADDR(pages),
                 PTE_U );
映射内核栈KSTACKTOP

boot_map_region(kern_pgdir, 
                 KSTACKTOP-KSTKSIZE, 
                 KSTKSIZE,
                 PADDR(bootstack),
                 PTE_W );
映射内核基址KSTACKTOP

uint32_t kern_size = ROUNDUP((0xFFFFFFFF-KERNBASE), PGSIZE);
cprintf("size: %d   pages:%d\n", kern_size, kern_size/PGSIZE);
boot_map_region(kern_pgdir, 
             (uintptr_t) KSTACKTOP, 
             kern_size,
             (physaddr_t)0, 
             PTE_W );
1.1.4. Questions
我们已将内核和用户环境放在同一地址空间中。 为什么用户程序无法读取或写入内核的内存？ 哪些特定机制保护内核内存？
A：页表项中有读写保护位，以及PTE_U区分内核和用户，MMU应该会实现这种保护。

此操作系统可以支持的最大物理内存量是多少？ 为什么？
A：4GB，因为32位地址线，可以寻址4GB大小。

如果我们实际拥有最大的物理内存量，那么管理内存的空间开销是多少？ 这个开销是如何分解的？
A：4GB/PASIZE = 2^32/2^12 = 2^20页， 每个页表项4B，

页表占用内存2^20x4B = 4M，
page directory = 4K,
Pages结构体2^20*(4+2) = 6M
地址空间布局替代方案
我们在JOS中使用的地址空间布局不是唯一的。操作系统可以将内核映射到低线性地址，同时将线性地址空间的上部留给用户进程。但是x86内核一般不采用这种方法，因为x86的向后兼容模式之一，称为虚拟8086模式，在处理器中“硬连线”使用线性地址空间的底部。因此如果内核映射到那里，就无法可以使用。

Challenge感觉都好难啊，占坑！！

总结
整个lab2都在填充mem_init()这个函数，也就是建立一个二级页表，可分为以下几个步骤。

内存检查
读取基本内存大小、扩展内存大小，并根据PGSIZE求出有多少个page，同时打印可用内存大小。

创建页目录表
在kernel.ld链接文件中，声明了end在bss段的未使用位置的最前端，实现了boot_alloc()在bss段未使用的最前端进行页目录、页表存储空间的申请。

.bss : {
        PROVIDE(edata = .);
        *(.bss)
        PROVIDE(end = .);
        BYTE(0)
    }
第一次进入boot_alloc函数会执行以下代码。

    if (!nextfree) {
        extern char end[];
        nextfree = ROUNDUP((char *) end, PGSIZE);
    }
创建物理页表记录的数据结构，并对其初始化
记录各个页面的引用计数，将物理内存的分页用链表串接起来，同时记录目前空闲可用的页。

建立虚拟内存与物理内存映射关系，即初始化各个页表项
首先要实现通过页目录查到对应的页表，判断页表是否存在，是否需要申请空间存储新的页表。以及页表项的初始化，页的插入，页的查询等等操作。

页表的地址空间也是使用boot_alloc()函数分配，即都是紧跟在bss段后面。 分别映射UPAGES、KSTACKTOP、KERNBASE三个区域。