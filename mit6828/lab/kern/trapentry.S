/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(T_DIVIDE_handle, T_DIVIDE);
TRAPHANDLER_NOEC(T_DEBUG_handle, T_DEBUG);
TRAPHANDLER_NOEC(T_NMI_handle, T_NMI);
TRAPHANDLER_NOEC(T_BRKPT_handle, T_BRKPT);
TRAPHANDLER_NOEC(T_OFLOW_handle, T_OFLOW);
TRAPHANDLER_NOEC(T_BOUND_handle, T_BOUND);
TRAPHANDLER_NOEC(T_ILLOP_handle, T_ILLOP);
TRAPHANDLER_NOEC(T_DEVICE_handle, T_DEVICE);
TRAPHANDLER(T_DBLFLT_handle, T_DBLFLT);
TRAPHANDLER(T_TSS_handle, T_TSS);
TRAPHANDLER(T_SEGNP_handle, T_SEGNP);
TRAPHANDLER(T_STACK_handle, T_STACK);
TRAPHANDLER(T_GPFLT_handle, T_GPFLT);
TRAPHANDLER(T_PGFLT_handle, T_PGFLT);
TRAPHANDLER_NOEC(T_FPERR_handle, T_FPERR);
TRAPHANDLER(T_ALIGN_handle, T_ALIGN);
TRAPHANDLER_NOEC(T_MCHK_handle, T_MCHK);
TRAPHANDLER_NOEC(T_SIMDERR_handle, T_SIMDERR);
TRAPHANDLER_NOEC(T_SYSCALL_handle, T_SYSCALL);
TRAPHANDLER_NOEC(T_DEFAULT_handle, T_DEFAULT);


/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
# build trapframes
	pushl %ds
	pushl %es
	pushal

# set up data segments
	movw $GD_KT, %ax
	movw %ax, %ds
	movw %ax, %es

# call trap(tf), where tf = %esp
	pushl %esp
	call trap


