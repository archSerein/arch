// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.


	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	if (!(err & FEC_WR)) {
		panic("pgfault: faulting access was not a write");
	}
	if (!(uvpt[PGNUM(addr)] & PTE_COW)) {
		panic("pgfault: faulting page is not copy-on-write");
	}

	// LAB 4: Your code here.
	sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P | PTE_U | PTE_W);
	addr = ROUNDDOWN(addr, PGSIZE);
	memcpy(PFTEMP, addr, PGSIZE);
	sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_P | PTE_U | PTE_W);
	sys_page_unmap(sys_getenvid(), PFTEMP);

	// panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	// panic("duppage not implemented");
  envid_t parent_id = sys_getenvid();
  void *addr = (void *)(pn * PGSIZE);
  // if page is writable or copy-on-write
  // the new page must be created copy-on-write, and then our mapping must be copy-on-write
  if (uvpt[pn] & PTE_W || uvpt[pn] & PTE_COW) {
    if ((r = sys_page_map(parent_id, addr, envid, addr, PTE_COW | PTE_U | PTE_P)) != 0)
      panic("sys_page_map: %e", r);
    if ((r = sys_page_map(parent_id, addr, parent_id, addr, PTE_COW | PTE_P | PTE_U)) != 0)
      panic("sys_page_map: %e", r);
  } else {
    r = sys_page_map(parent_id, addr, envid, addr, PTE_U | PTE_P);
    if (r != 0)   panic("sys_page_map: e", r);
  }

	return r;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	// panic("fork not implemented");
  // Set up our page fault handler appropriately.
  int r;
  uint32_t addr;
  set_pgfault_handler(pgfault);
  // create a child
  envid_t id = sys_exofork();
  if (id < 0) {
    panic("create a child fault");
  } else if (id == 0) {
    // child process: set thisenv
    // return 0 on success
    thisenv = &envs[ENVX(sys_getenvid())];
    return 0;
  } else {
    for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
      // 在 fork 的时候需要处理所有存在的页表和页表条目
      // 调用 duppage ，根据权限位判断 PTE_W | PTE_COW 是否有效，进行不同的处理
      if (((uvpd[PDX(addr)] & PTE_P) == PTE_P) && ((uvpt[PGNUM(addr)] & PTE_P)) == PTE_P) {
        if (duppage(id, PGNUM(addr)) < 0) {
          panic("duppage fault");
        }
      }
    }

    extern void _pgfault_upcall(void);
    // 为子程序分配一个新的页面，用于异常堆栈
    // #define UXSTACKTOP UTOP
    if ((r = sys_page_alloc(id, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_W | PTE_U)) != 0) {
      panic("sys_page_alloc: %e", r);
    }
    if ((r = sys_env_set_pgfault_upcall(id, (void *)_pgfault_upcall)) != 0) {
      panic("sys_env_set_pgfault_upcall: %e", r);
    }
    if ((r = sys_env_set_status(id, ENV_RUNNABLE)) != 0) {
      panic("sys_env_set_status: %e", r);
    }
  }
	return id;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
