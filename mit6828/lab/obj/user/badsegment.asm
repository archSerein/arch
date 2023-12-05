
obj/user/badsegment:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	57                   	push   %edi
  80003e:	56                   	push   %esi
  80003f:	53                   	push   %ebx
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	e8 4e 00 00 00       	call   800096 <__x86.get_pc_thunk.bx>
  800048:	81 c3 b8 1f 00 00    	add    $0x1fb8,%ebx
  80004e:	8b 75 08             	mov    0x8(%ebp),%esi
  800051:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800054:	e8 f4 00 00 00       	call   80014d <sys_getenvid>
  800059:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005e:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800061:	c1 e0 05             	shl    $0x5,%eax
  800064:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80006a:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 f6                	test   %esi,%esi
  800072:	7e 08                	jle    80007c <libmain+0x42>
		binaryname = argv[0];
  800074:	8b 07                	mov    (%edi),%eax
  800076:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	57                   	push   %edi
  800080:	56                   	push   %esi
  800081:	e8 ad ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800086:	e8 0f 00 00 00       	call   80009a <exit>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800091:	5b                   	pop    %ebx
  800092:	5e                   	pop    %esi
  800093:	5f                   	pop    %edi
  800094:	5d                   	pop    %ebp
  800095:	c3                   	ret    

00800096 <__x86.get_pc_thunk.bx>:
  800096:	8b 1c 24             	mov    (%esp),%ebx
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	53                   	push   %ebx
  80009e:	83 ec 10             	sub    $0x10,%esp
  8000a1:	e8 f0 ff ff ff       	call   800096 <__x86.get_pc_thunk.bx>
  8000a6:	81 c3 5a 1f 00 00    	add    $0x1f5a,%ebx
	sys_env_destroy(0);
  8000ac:	6a 00                	push   $0x0
  8000ae:	e8 45 00 00 00       	call   8000f8 <sys_env_destroy>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	57                   	push   %edi
  8000bf:	56                   	push   %esi
  8000c0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 c6                	mov    %eax,%esi
  8000d2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d4:	5b                   	pop    %ebx
  8000d5:	5e                   	pop    %esi
  8000d6:	5f                   	pop    %edi
  8000d7:	5d                   	pop    %ebp
  8000d8:	c3                   	ret    

008000d9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	57                   	push   %edi
  8000dd:	56                   	push   %esi
  8000de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	89 d3                	mov    %edx,%ebx
  8000ed:	89 d7                	mov    %edx,%edi
  8000ef:	89 d6                	mov    %edx,%esi
  8000f1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 1c             	sub    $0x1c,%esp
  800101:	e8 66 00 00 00       	call   80016c <__x86.get_pc_thunk.ax>
  800106:	05 fa 1e 00 00       	add    $0x1efa,%eax
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80010e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800113:	8b 55 08             	mov    0x8(%ebp),%edx
  800116:	b8 03 00 00 00       	mov    $0x3,%eax
  80011b:	89 cb                	mov    %ecx,%ebx
  80011d:	89 cf                	mov    %ecx,%edi
  80011f:	89 ce                	mov    %ecx,%esi
  800121:	cd 30                	int    $0x30
	if(check && ret > 0)
  800123:	85 c0                	test   %eax,%eax
  800125:	7f 08                	jg     80012f <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	50                   	push   %eax
  800133:	6a 03                	push   $0x3
  800135:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800138:	8d 83 6e ee ff ff    	lea    -0x1192(%ebx),%eax
  80013e:	50                   	push   %eax
  80013f:	6a 23                	push   $0x23
  800141:	8d 83 8b ee ff ff    	lea    -0x1175(%ebx),%eax
  800147:	50                   	push   %eax
  800148:	e8 23 00 00 00       	call   800170 <_panic>

0080014d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
	asm volatile("int %1\n"
  800153:	ba 00 00 00 00       	mov    $0x0,%edx
  800158:	b8 02 00 00 00       	mov    $0x2,%eax
  80015d:	89 d1                	mov    %edx,%ecx
  80015f:	89 d3                	mov    %edx,%ebx
  800161:	89 d7                	mov    %edx,%edi
  800163:	89 d6                	mov    %edx,%esi
  800165:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <__x86.get_pc_thunk.ax>:
  80016c:	8b 04 24             	mov    (%esp),%eax
  80016f:	c3                   	ret    

00800170 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	e8 18 ff ff ff       	call   800096 <__x86.get_pc_thunk.bx>
  80017e:	81 c3 82 1e 00 00    	add    $0x1e82,%ebx
	va_list ap;

	va_start(ap, fmt);
  800184:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800187:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80018d:	8b 38                	mov    (%eax),%edi
  80018f:	e8 b9 ff ff ff       	call   80014d <sys_getenvid>
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	ff 75 0c             	push   0xc(%ebp)
  80019a:	ff 75 08             	push   0x8(%ebp)
  80019d:	57                   	push   %edi
  80019e:	50                   	push   %eax
  80019f:	8d 83 9c ee ff ff    	lea    -0x1164(%ebx),%eax
  8001a5:	50                   	push   %eax
  8001a6:	e8 d1 00 00 00       	call   80027c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ab:	83 c4 18             	add    $0x18,%esp
  8001ae:	56                   	push   %esi
  8001af:	ff 75 10             	push   0x10(%ebp)
  8001b2:	e8 63 00 00 00       	call   80021a <vcprintf>
	cprintf("\n");
  8001b7:	8d 83 bf ee ff ff    	lea    -0x1141(%ebx),%eax
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 b7 00 00 00       	call   80027c <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c8:	cc                   	int3   
  8001c9:	eb fd                	jmp    8001c8 <_panic+0x58>

008001cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	e8 c1 fe ff ff       	call   800096 <__x86.get_pc_thunk.bx>
  8001d5:	81 c3 2b 1e 00 00    	add    $0x1e2b,%ebx
  8001db:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001de:	8b 16                	mov    (%esi),%edx
  8001e0:	8d 42 01             	lea    0x1(%edx),%eax
  8001e3:	89 06                	mov    %eax,(%esi)
  8001e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e8:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f1:	74 0b                	je     8001fe <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f3:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001fa:	5b                   	pop    %ebx
  8001fb:	5e                   	pop    %esi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	68 ff 00 00 00       	push   $0xff
  800206:	8d 46 08             	lea    0x8(%esi),%eax
  800209:	50                   	push   %eax
  80020a:	e8 ac fe ff ff       	call   8000bb <sys_cputs>
		b->idx = 0;
  80020f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	eb d9                	jmp    8001f3 <putch+0x28>

0080021a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	53                   	push   %ebx
  80021e:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800224:	e8 6d fe ff ff       	call   800096 <__x86.get_pc_thunk.bx>
  800229:	81 c3 d7 1d 00 00    	add    $0x1dd7,%ebx
	struct printbuf b;

	b.idx = 0;
  80022f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800236:	00 00 00 
	b.cnt = 0;
  800239:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800240:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800243:	ff 75 0c             	push   0xc(%ebp)
  800246:	ff 75 08             	push   0x8(%ebp)
  800249:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024f:	50                   	push   %eax
  800250:	8d 83 cb e1 ff ff    	lea    -0x1e35(%ebx),%eax
  800256:	50                   	push   %eax
  800257:	e8 2c 01 00 00       	call   800388 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025c:	83 c4 08             	add    $0x8,%esp
  80025f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800265:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	e8 4a fe ff ff       	call   8000bb <sys_cputs>

	return b.cnt;
}
  800271:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800282:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800285:	50                   	push   %eax
  800286:	ff 75 08             	push   0x8(%ebp)
  800289:	e8 8c ff ff ff       	call   80021a <vcprintf>
	va_end(ap);

	return cnt;
}
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 2c             	sub    $0x2c,%esp
  800299:	e8 07 06 00 00       	call   8008a5 <__x86.get_pc_thunk.cx>
  80029e:	81 c1 62 1d 00 00    	add    $0x1d62,%ecx
  8002a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	89 d6                	mov    %edx,%esi
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	89 d1                	mov    %edx,%ecx
  8002b3:	89 c2                	mov    %eax,%edx
  8002b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002b8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002be:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002cb:	39 c2                	cmp    %eax,%edx
  8002cd:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d0:	72 41                	jb     800313 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	ff 75 18             	push   0x18(%ebp)
  8002d8:	83 eb 01             	sub    $0x1,%ebx
  8002db:	53                   	push   %ebx
  8002dc:	50                   	push   %eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	ff 75 e4             	push   -0x1c(%ebp)
  8002e3:	ff 75 e0             	push   -0x20(%ebp)
  8002e6:	ff 75 d4             	push   -0x2c(%ebp)
  8002e9:	ff 75 d0             	push   -0x30(%ebp)
  8002ec:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002ef:	e8 3c 09 00 00       	call   800c30 <__udivdi3>
  8002f4:	83 c4 18             	add    $0x18,%esp
  8002f7:	52                   	push   %edx
  8002f8:	50                   	push   %eax
  8002f9:	89 f2                	mov    %esi,%edx
  8002fb:	89 f8                	mov    %edi,%eax
  8002fd:	e8 8e ff ff ff       	call   800290 <printnum>
  800302:	83 c4 20             	add    $0x20,%esp
  800305:	eb 13                	jmp    80031a <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	56                   	push   %esi
  80030b:	ff 75 18             	push   0x18(%ebp)
  80030e:	ff d7                	call   *%edi
  800310:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800313:	83 eb 01             	sub    $0x1,%ebx
  800316:	85 db                	test   %ebx,%ebx
  800318:	7f ed                	jg     800307 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	56                   	push   %esi
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	ff 75 e4             	push   -0x1c(%ebp)
  800324:	ff 75 e0             	push   -0x20(%ebp)
  800327:	ff 75 d4             	push   -0x2c(%ebp)
  80032a:	ff 75 d0             	push   -0x30(%ebp)
  80032d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800330:	e8 1b 0a 00 00       	call   800d50 <__umoddi3>
  800335:	83 c4 14             	add    $0x14,%esp
  800338:	0f be 84 03 c1 ee ff 	movsbl -0x113f(%ebx,%eax,1),%eax
  80033f:	ff 
  800340:	50                   	push   %eax
  800341:	ff d7                	call   *%edi
}
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800349:	5b                   	pop    %ebx
  80034a:	5e                   	pop    %esi
  80034b:	5f                   	pop    %edi
  80034c:	5d                   	pop    %ebp
  80034d:	c3                   	ret    

0080034e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800354:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800358:	8b 10                	mov    (%eax),%edx
  80035a:	3b 50 04             	cmp    0x4(%eax),%edx
  80035d:	73 0a                	jae    800369 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800362:	89 08                	mov    %ecx,(%eax)
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	88 02                	mov    %al,(%edx)
}
  800369:	5d                   	pop    %ebp
  80036a:	c3                   	ret    

0080036b <printfmt>:
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800371:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800374:	50                   	push   %eax
  800375:	ff 75 10             	push   0x10(%ebp)
  800378:	ff 75 0c             	push   0xc(%ebp)
  80037b:	ff 75 08             	push   0x8(%ebp)
  80037e:	e8 05 00 00 00       	call   800388 <vprintfmt>
}
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <vprintfmt>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	57                   	push   %edi
  80038c:	56                   	push   %esi
  80038d:	53                   	push   %ebx
  80038e:	83 ec 3c             	sub    $0x3c,%esp
  800391:	e8 d6 fd ff ff       	call   80016c <__x86.get_pc_thunk.ax>
  800396:	05 6a 1c 00 00       	add    $0x1c6a,%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039e:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a7:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003b0:	eb 0a                	jmp    8003bc <vprintfmt+0x34>
			putch(ch, putdat);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	57                   	push   %edi
  8003b6:	50                   	push   %eax
  8003b7:	ff d6                	call   *%esi
  8003b9:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003bc:	83 c3 01             	add    $0x1,%ebx
  8003bf:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003c3:	83 f8 25             	cmp    $0x25,%eax
  8003c6:	74 0c                	je     8003d4 <vprintfmt+0x4c>
			if (ch == '\0')
  8003c8:	85 c0                	test   %eax,%eax
  8003ca:	75 e6                	jne    8003b2 <vprintfmt+0x2a>
}
  8003cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    
		padc = ' ';
  8003d4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003d8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f5:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8d 43 01             	lea    0x1(%ebx),%eax
  8003fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fe:	0f b6 13             	movzbl (%ebx),%edx
  800401:	8d 42 dd             	lea    -0x23(%edx),%eax
  800404:	3c 55                	cmp    $0x55,%al
  800406:	0f 87 fd 03 00 00    	ja     800809 <.L20>
  80040c:	0f b6 c0             	movzbl %al,%eax
  80040f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800412:	89 ce                	mov    %ecx,%esi
  800414:	03 b4 81 50 ef ff ff 	add    -0x10b0(%ecx,%eax,4),%esi
  80041b:	ff e6                	jmp    *%esi

0080041d <.L68>:
  80041d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800420:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800424:	eb d2                	jmp    8003f8 <vprintfmt+0x70>

00800426 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80042d:	eb c9                	jmp    8003f8 <vprintfmt+0x70>

0080042f <.L31>:
  80042f:	0f b6 d2             	movzbl %dl,%edx
  800432:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
  80043a:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80043d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800440:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800444:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800447:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044a:	83 f9 09             	cmp    $0x9,%ecx
  80044d:	77 58                	ja     8004a7 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80044f:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800452:	eb e9                	jmp    80043d <.L31+0xe>

00800454 <.L34>:
			precision = va_arg(ap, int);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	8d 40 04             	lea    0x4(%eax),%eax
  800462:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046c:	79 8a                	jns    8003f8 <vprintfmt+0x70>
				width = precision, precision = -1;
  80046e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800471:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800474:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047b:	e9 78 ff ff ff       	jmp    8003f8 <vprintfmt+0x70>

00800480 <.L33>:
  800480:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800483:	85 d2                	test   %edx,%edx
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	0f 49 c2             	cmovns %edx,%eax
  80048d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800490:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  800493:	e9 60 ff ff ff       	jmp    8003f8 <vprintfmt+0x70>

00800498 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  800498:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  80049b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004a2:	e9 51 ff ff ff       	jmp    8003f8 <vprintfmt+0x70>
  8004a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004aa:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ad:	eb b9                	jmp    800468 <.L34+0x14>

008004af <.L27>:
			lflag++;
  8004af:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b6:	e9 3d ff ff ff       	jmp    8003f8 <vprintfmt+0x70>

008004bb <.L30>:
			putch(va_arg(ap, int), putdat);
  8004bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8d 58 04             	lea    0x4(%eax),%ebx
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	57                   	push   %edi
  8004c8:	ff 30                	push   (%eax)
  8004ca:	ff d6                	call   *%esi
			break;
  8004cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cf:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004d2:	e9 c8 02 00 00       	jmp    80079f <.L25+0x45>

008004d7 <.L28>:
			err = va_arg(ap, int);
  8004d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e0:	8b 10                	mov    (%eax),%edx
  8004e2:	89 d0                	mov    %edx,%eax
  8004e4:	f7 d8                	neg    %eax
  8004e6:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e9:	83 f8 06             	cmp    $0x6,%eax
  8004ec:	7f 27                	jg     800515 <.L28+0x3e>
  8004ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f1:	8b 14 82             	mov    (%edx,%eax,4),%edx
  8004f4:	85 d2                	test   %edx,%edx
  8004f6:	74 1d                	je     800515 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  8004f8:	52                   	push   %edx
  8004f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fc:	8d 80 e2 ee ff ff    	lea    -0x111e(%eax),%eax
  800502:	50                   	push   %eax
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	e8 61 fe ff ff       	call   80036b <printfmt>
  80050a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050d:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800510:	e9 8a 02 00 00       	jmp    80079f <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800515:	50                   	push   %eax
  800516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800519:	8d 80 d9 ee ff ff    	lea    -0x1127(%eax),%eax
  80051f:	50                   	push   %eax
  800520:	57                   	push   %edi
  800521:	56                   	push   %esi
  800522:	e8 44 fe ff ff       	call   80036b <printfmt>
  800527:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052a:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052d:	e9 6d 02 00 00       	jmp    80079f <.L25+0x45>

00800532 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  800532:	8b 75 08             	mov    0x8(%ebp),%esi
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	83 c0 04             	add    $0x4,%eax
  80053b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800543:	85 d2                	test   %edx,%edx
  800545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800548:	8d 80 d2 ee ff ff    	lea    -0x112e(%eax),%eax
  80054e:	0f 45 c2             	cmovne %edx,%eax
  800551:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800554:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800558:	7e 06                	jle    800560 <.L24+0x2e>
  80055a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80055e:	75 0d                	jne    80056d <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	89 c3                	mov    %eax,%ebx
  800565:	03 45 d4             	add    -0x2c(%ebp),%eax
  800568:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80056b:	eb 58                	jmp    8005c5 <.L24+0x93>
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	ff 75 d8             	push   -0x28(%ebp)
  800573:	ff 75 c8             	push   -0x38(%ebp)
  800576:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800579:	e8 43 03 00 00       	call   8008c1 <strnlen>
  80057e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800581:	29 c2                	sub    %eax,%edx
  800583:	89 55 bc             	mov    %edx,-0x44(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  80058b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80058f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800592:	eb 0f                	jmp    8005a3 <.L24+0x71>
					putch(padc, putdat);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	57                   	push   %edi
  800598:	ff 75 d4             	push   -0x2c(%ebp)
  80059b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	83 eb 01             	sub    $0x1,%ebx
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	85 db                	test   %ebx,%ebx
  8005a5:	7f ed                	jg     800594 <.L24+0x62>
  8005a7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b1:	0f 49 c2             	cmovns %edx,%eax
  8005b4:	29 c2                	sub    %eax,%edx
  8005b6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b9:	eb a5                	jmp    800560 <.L24+0x2e>
					putch(ch, putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	57                   	push   %edi
  8005bf:	52                   	push   %edx
  8005c0:	ff d6                	call   *%esi
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005c8:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ca:	83 c3 01             	add    $0x1,%ebx
  8005cd:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005d1:	0f be d0             	movsbl %al,%edx
  8005d4:	85 d2                	test   %edx,%edx
  8005d6:	74 4b                	je     800623 <.L24+0xf1>
  8005d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005dc:	78 06                	js     8005e4 <.L24+0xb2>
  8005de:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e2:	78 1e                	js     800602 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e8:	74 d1                	je     8005bb <.L24+0x89>
  8005ea:	0f be c0             	movsbl %al,%eax
  8005ed:	83 e8 20             	sub    $0x20,%eax
  8005f0:	83 f8 5e             	cmp    $0x5e,%eax
  8005f3:	76 c6                	jbe    8005bb <.L24+0x89>
					putch('?', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	57                   	push   %edi
  8005f9:	6a 3f                	push   $0x3f
  8005fb:	ff d6                	call   *%esi
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	eb c3                	jmp    8005c5 <.L24+0x93>
  800602:	89 cb                	mov    %ecx,%ebx
  800604:	eb 0e                	jmp    800614 <.L24+0xe2>
				putch(' ', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	57                   	push   %edi
  80060a:	6a 20                	push   $0x20
  80060c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80060e:	83 eb 01             	sub    $0x1,%ebx
  800611:	83 c4 10             	add    $0x10,%esp
  800614:	85 db                	test   %ebx,%ebx
  800616:	7f ee                	jg     800606 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800618:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
  80061e:	e9 7c 01 00 00       	jmp    80079f <.L25+0x45>
  800623:	89 cb                	mov    %ecx,%ebx
  800625:	eb ed                	jmp    800614 <.L24+0xe2>

00800627 <.L29>:
	if (lflag >= 2)
  800627:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80062a:	8b 75 08             	mov    0x8(%ebp),%esi
  80062d:	83 f9 01             	cmp    $0x1,%ecx
  800630:	7f 1b                	jg     80064d <.L29+0x26>
	else if (lflag)
  800632:	85 c9                	test   %ecx,%ecx
  800634:	74 63                	je     800699 <.L29+0x72>
		return va_arg(*ap, long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	99                   	cltd   
  80063f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 04             	lea    0x4(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	eb 17                	jmp    800664 <.L29+0x3d>
		return va_arg(*ap, long long);
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 50 04             	mov    0x4(%eax),%edx
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 08             	lea    0x8(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800664:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800667:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  80066a:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  80066f:	85 db                	test   %ebx,%ebx
  800671:	0f 89 0e 01 00 00    	jns    800785 <.L25+0x2b>
				putch('-', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	57                   	push   %edi
  80067b:	6a 2d                	push   $0x2d
  80067d:	ff d6                	call   *%esi
				num = -(long long) num;
  80067f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800682:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800685:	f7 d9                	neg    %ecx
  800687:	83 d3 00             	adc    $0x0,%ebx
  80068a:	f7 db                	neg    %ebx
  80068c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800694:	e9 ec 00 00 00       	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, int);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	99                   	cltd   
  8006a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 04             	lea    0x4(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ae:	eb b4                	jmp    800664 <.L29+0x3d>

008006b0 <.L23>:
	if (lflag >= 2)
  8006b0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b6:	83 f9 01             	cmp    $0x1,%ecx
  8006b9:	7f 1e                	jg     8006d9 <.L23+0x29>
	else if (lflag)
  8006bb:	85 c9                	test   %ecx,%ecx
  8006bd:	74 32                	je     8006f1 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 08                	mov    (%eax),%ecx
  8006c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c9:	8d 40 04             	lea    0x4(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cf:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006d4:	e9 ac 00 00 00       	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 08                	mov    (%eax),%ecx
  8006de:	8b 58 04             	mov    0x4(%eax),%ebx
  8006e1:	8d 40 08             	lea    0x8(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e7:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  8006ec:	e9 94 00 00 00       	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 08                	mov    (%eax),%ecx
  8006f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800701:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800706:	eb 7d                	jmp    800785 <.L25+0x2b>

00800708 <.L26>:
	if (lflag >= 2)
  800708:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80070b:	8b 75 08             	mov    0x8(%ebp),%esi
  80070e:	83 f9 01             	cmp    $0x1,%ecx
  800711:	7f 1b                	jg     80072e <.L26+0x26>
	else if (lflag)
  800713:	85 c9                	test   %ecx,%ecx
  800715:	74 2c                	je     800743 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 08                	mov    (%eax),%ecx
  80071c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800727:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  80072c:	eb 57                	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 08                	mov    (%eax),%ecx
  800733:	8b 58 04             	mov    0x4(%eax),%ebx
  800736:	8d 40 08             	lea    0x8(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  800741:	eb 42                	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 08                	mov    (%eax),%ecx
  800748:	bb 00 00 00 00       	mov    $0x0,%ebx
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800753:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800758:	eb 2b                	jmp    800785 <.L25+0x2b>

0080075a <.L25>:
			putch('0', putdat);
  80075a:	8b 75 08             	mov    0x8(%ebp),%esi
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	57                   	push   %edi
  800761:	6a 30                	push   $0x30
  800763:	ff d6                	call   *%esi
			putch('x', putdat);
  800765:	83 c4 08             	add    $0x8,%esp
  800768:	57                   	push   %edi
  800769:	6a 78                	push   $0x78
  80076b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 08                	mov    (%eax),%ecx
  800772:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800777:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800780:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800785:	83 ec 0c             	sub    $0xc,%esp
  800788:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80078c:	50                   	push   %eax
  80078d:	ff 75 d4             	push   -0x2c(%ebp)
  800790:	52                   	push   %edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	89 fa                	mov    %edi,%edx
  800795:	89 f0                	mov    %esi,%eax
  800797:	e8 f4 fa ff ff       	call   800290 <printnum>
			break;
  80079c:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a2:	e9 15 fc ff ff       	jmp    8003bc <vprintfmt+0x34>

008007a7 <.L21>:
	if (lflag >= 2)
  8007a7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ad:	83 f9 01             	cmp    $0x1,%ecx
  8007b0:	7f 1b                	jg     8007cd <.L21+0x26>
	else if (lflag)
  8007b2:	85 c9                	test   %ecx,%ecx
  8007b4:	74 2c                	je     8007e2 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 08                	mov    (%eax),%ecx
  8007bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c6:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007cb:	eb b8                	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 08                	mov    (%eax),%ecx
  8007d2:	8b 58 04             	mov    0x4(%eax),%ebx
  8007d5:	8d 40 08             	lea    0x8(%eax),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007db:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007e0:	eb a3                	jmp    800785 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 08                	mov    (%eax),%ecx
  8007e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ec:	8d 40 04             	lea    0x4(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f2:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  8007f7:	eb 8c                	jmp    800785 <.L25+0x2b>

008007f9 <.L35>:
			putch(ch, putdat);
  8007f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	57                   	push   %edi
  800800:	6a 25                	push   $0x25
  800802:	ff d6                	call   *%esi
			break;
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	eb 96                	jmp    80079f <.L25+0x45>

00800809 <.L20>:
			putch('%', putdat);
  800809:	8b 75 08             	mov    0x8(%ebp),%esi
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	57                   	push   %edi
  800810:	6a 25                	push   $0x25
  800812:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	89 d8                	mov    %ebx,%eax
  800819:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081d:	74 05                	je     800824 <.L20+0x1b>
  80081f:	83 e8 01             	sub    $0x1,%eax
  800822:	eb f5                	jmp    800819 <.L20+0x10>
  800824:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800827:	e9 73 ff ff ff       	jmp    80079f <.L25+0x45>

0080082c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	83 ec 14             	sub    $0x14,%esp
  800833:	e8 5e f8 ff ff       	call   800096 <__x86.get_pc_thunk.bx>
  800838:	81 c3 c8 17 00 00    	add    $0x17c8,%ebx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800847:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80084b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800855:	85 c0                	test   %eax,%eax
  800857:	74 2b                	je     800884 <vsnprintf+0x58>
  800859:	85 d2                	test   %edx,%edx
  80085b:	7e 27                	jle    800884 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085d:	ff 75 14             	push   0x14(%ebp)
  800860:	ff 75 10             	push   0x10(%ebp)
  800863:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800866:	50                   	push   %eax
  800867:	8d 83 4e e3 ff ff    	lea    -0x1cb2(%ebx),%eax
  80086d:	50                   	push   %eax
  80086e:	e8 15 fb ff ff       	call   800388 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800876:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087c:	83 c4 10             	add    $0x10,%esp
}
  80087f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800882:	c9                   	leave  
  800883:	c3                   	ret    
		return -E_INVAL;
  800884:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800889:	eb f4                	jmp    80087f <vsnprintf+0x53>

0080088b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800891:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800894:	50                   	push   %eax
  800895:	ff 75 10             	push   0x10(%ebp)
  800898:	ff 75 0c             	push   0xc(%ebp)
  80089b:	ff 75 08             	push   0x8(%ebp)
  80089e:	e8 89 ff ff ff       	call   80082c <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <__x86.get_pc_thunk.cx>:
  8008a5:	8b 0c 24             	mov    (%esp),%ecx
  8008a8:	c3                   	ret    

008008a9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008af:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b4:	eb 03                	jmp    8008b9 <strlen+0x10>
		n++;
  8008b6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bd:	75 f7                	jne    8008b6 <strlen+0xd>
	return n;
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cf:	eb 03                	jmp    8008d4 <strnlen+0x13>
		n++;
  8008d1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d4:	39 d0                	cmp    %edx,%eax
  8008d6:	74 08                	je     8008e0 <strnlen+0x1f>
  8008d8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008dc:	75 f3                	jne    8008d1 <strnlen+0x10>
  8008de:	89 c2                	mov    %eax,%edx
	return n;
}
  8008e0:	89 d0                	mov    %edx,%eax
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	53                   	push   %ebx
  8008e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008f7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	84 d2                	test   %dl,%dl
  8008ff:	75 f2                	jne    8008f3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800901:	89 c8                	mov    %ecx,%eax
  800903:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	53                   	push   %ebx
  80090c:	83 ec 10             	sub    $0x10,%esp
  80090f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800912:	53                   	push   %ebx
  800913:	e8 91 ff ff ff       	call   8008a9 <strlen>
  800918:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091b:	ff 75 0c             	push   0xc(%ebp)
  80091e:	01 d8                	add    %ebx,%eax
  800920:	50                   	push   %eax
  800921:	e8 be ff ff ff       	call   8008e4 <strcpy>
	return dst;
}
  800926:	89 d8                	mov    %ebx,%eax
  800928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	56                   	push   %esi
  800931:	53                   	push   %ebx
  800932:	8b 75 08             	mov    0x8(%ebp),%esi
  800935:	8b 55 0c             	mov    0xc(%ebp),%edx
  800938:	89 f3                	mov    %esi,%ebx
  80093a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093d:	89 f0                	mov    %esi,%eax
  80093f:	eb 0f                	jmp    800950 <strncpy+0x23>
		*dst++ = *src;
  800941:	83 c0 01             	add    $0x1,%eax
  800944:	0f b6 0a             	movzbl (%edx),%ecx
  800947:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094a:	80 f9 01             	cmp    $0x1,%cl
  80094d:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800950:	39 d8                	cmp    %ebx,%eax
  800952:	75 ed                	jne    800941 <strncpy+0x14>
	}
	return ret;
}
  800954:	89 f0                	mov    %esi,%eax
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 75 08             	mov    0x8(%ebp),%esi
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800965:	8b 55 10             	mov    0x10(%ebp),%edx
  800968:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096a:	85 d2                	test   %edx,%edx
  80096c:	74 21                	je     80098f <strlcpy+0x35>
  80096e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800972:	89 f2                	mov    %esi,%edx
  800974:	eb 09                	jmp    80097f <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800976:	83 c1 01             	add    $0x1,%ecx
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80097f:	39 c2                	cmp    %eax,%edx
  800981:	74 09                	je     80098c <strlcpy+0x32>
  800983:	0f b6 19             	movzbl (%ecx),%ebx
  800986:	84 db                	test   %bl,%bl
  800988:	75 ec                	jne    800976 <strlcpy+0x1c>
  80098a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80098c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098f:	29 f0                	sub    %esi,%eax
}
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099e:	eb 06                	jmp    8009a6 <strcmp+0x11>
		p++, q++;
  8009a0:	83 c1 01             	add    $0x1,%ecx
  8009a3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a6:	0f b6 01             	movzbl (%ecx),%eax
  8009a9:	84 c0                	test   %al,%al
  8009ab:	74 04                	je     8009b1 <strcmp+0x1c>
  8009ad:	3a 02                	cmp    (%edx),%al
  8009af:	74 ef                	je     8009a0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b1:	0f b6 c0             	movzbl %al,%eax
  8009b4:	0f b6 12             	movzbl (%edx),%edx
  8009b7:	29 d0                	sub    %edx,%eax
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	89 c3                	mov    %eax,%ebx
  8009c7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ca:	eb 06                	jmp    8009d2 <strncmp+0x17>
		n--, p++, q++;
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d2:	39 d8                	cmp    %ebx,%eax
  8009d4:	74 18                	je     8009ee <strncmp+0x33>
  8009d6:	0f b6 08             	movzbl (%eax),%ecx
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	74 04                	je     8009e1 <strncmp+0x26>
  8009dd:	3a 0a                	cmp    (%edx),%cl
  8009df:	74 eb                	je     8009cc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e1:	0f b6 00             	movzbl (%eax),%eax
  8009e4:	0f b6 12             	movzbl (%edx),%edx
  8009e7:	29 d0                	sub    %edx,%eax
}
  8009e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    
		return 0;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f3:	eb f4                	jmp    8009e9 <strncmp+0x2e>

008009f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ff:	eb 03                	jmp    800a04 <strchr+0xf>
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	0f b6 10             	movzbl (%eax),%edx
  800a07:	84 d2                	test   %dl,%dl
  800a09:	74 06                	je     800a11 <strchr+0x1c>
		if (*s == c)
  800a0b:	38 ca                	cmp    %cl,%dl
  800a0d:	75 f2                	jne    800a01 <strchr+0xc>
  800a0f:	eb 05                	jmp    800a16 <strchr+0x21>
			return (char *) s;
	return 0;
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a22:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a25:	38 ca                	cmp    %cl,%dl
  800a27:	74 09                	je     800a32 <strfind+0x1a>
  800a29:	84 d2                	test   %dl,%dl
  800a2b:	74 05                	je     800a32 <strfind+0x1a>
	for (; *s; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	eb f0                	jmp    800a22 <strfind+0xa>
			break;
	return (char *) s;
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a40:	85 c9                	test   %ecx,%ecx
  800a42:	74 2f                	je     800a73 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a44:	89 f8                	mov    %edi,%eax
  800a46:	09 c8                	or     %ecx,%eax
  800a48:	a8 03                	test   $0x3,%al
  800a4a:	75 21                	jne    800a6d <memset+0x39>
		c &= 0xFF;
  800a4c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	c1 e0 08             	shl    $0x8,%eax
  800a55:	89 d3                	mov    %edx,%ebx
  800a57:	c1 e3 18             	shl    $0x18,%ebx
  800a5a:	89 d6                	mov    %edx,%esi
  800a5c:	c1 e6 10             	shl    $0x10,%esi
  800a5f:	09 f3                	or     %esi,%ebx
  800a61:	09 da                	or     %ebx,%edx
  800a63:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a65:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a68:	fc                   	cld    
  800a69:	f3 ab                	rep stos %eax,%es:(%edi)
  800a6b:	eb 06                	jmp    800a73 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	fc                   	cld    
  800a71:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a73:	89 f8                	mov    %edi,%eax
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5f                   	pop    %edi
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	57                   	push   %edi
  800a7e:	56                   	push   %esi
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a88:	39 c6                	cmp    %eax,%esi
  800a8a:	73 32                	jae    800abe <memmove+0x44>
  800a8c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	76 2b                	jbe    800abe <memmove+0x44>
		s += n;
		d += n;
  800a93:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a96:	89 d6                	mov    %edx,%esi
  800a98:	09 fe                	or     %edi,%esi
  800a9a:	09 ce                	or     %ecx,%esi
  800a9c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa2:	75 0e                	jne    800ab2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa4:	83 ef 04             	sub    $0x4,%edi
  800aa7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aaa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aad:	fd                   	std    
  800aae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab0:	eb 09                	jmp    800abb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab2:	83 ef 01             	sub    $0x1,%edi
  800ab5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab8:	fd                   	std    
  800ab9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abb:	fc                   	cld    
  800abc:	eb 1a                	jmp    800ad8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abe:	89 f2                	mov    %esi,%edx
  800ac0:	09 c2                	or     %eax,%edx
  800ac2:	09 ca                	or     %ecx,%edx
  800ac4:	f6 c2 03             	test   $0x3,%dl
  800ac7:	75 0a                	jne    800ad3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb 05                	jmp    800ad8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	fc                   	cld    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae2:	ff 75 10             	push   0x10(%ebp)
  800ae5:	ff 75 0c             	push   0xc(%ebp)
  800ae8:	ff 75 08             	push   0x8(%ebp)
  800aeb:	e8 8a ff ff ff       	call   800a7a <memmove>
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 c6                	mov    %eax,%esi
  800aff:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b02:	eb 06                	jmp    800b0a <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b0a:	39 f0                	cmp    %esi,%eax
  800b0c:	74 14                	je     800b22 <memcmp+0x30>
		if (*s1 != *s2)
  800b0e:	0f b6 08             	movzbl (%eax),%ecx
  800b11:	0f b6 1a             	movzbl (%edx),%ebx
  800b14:	38 d9                	cmp    %bl,%cl
  800b16:	74 ec                	je     800b04 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b18:	0f b6 c1             	movzbl %cl,%eax
  800b1b:	0f b6 db             	movzbl %bl,%ebx
  800b1e:	29 d8                	sub    %ebx,%eax
  800b20:	eb 05                	jmp    800b27 <memcmp+0x35>
	}

	return 0;
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b34:	89 c2                	mov    %eax,%edx
  800b36:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b39:	eb 03                	jmp    800b3e <memfind+0x13>
  800b3b:	83 c0 01             	add    $0x1,%eax
  800b3e:	39 d0                	cmp    %edx,%eax
  800b40:	73 04                	jae    800b46 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b42:	38 08                	cmp    %cl,(%eax)
  800b44:	75 f5                	jne    800b3b <memfind+0x10>
			break;
	return (void *) s;
}
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b54:	eb 03                	jmp    800b59 <strtol+0x11>
		s++;
  800b56:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b59:	0f b6 02             	movzbl (%edx),%eax
  800b5c:	3c 20                	cmp    $0x20,%al
  800b5e:	74 f6                	je     800b56 <strtol+0xe>
  800b60:	3c 09                	cmp    $0x9,%al
  800b62:	74 f2                	je     800b56 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b64:	3c 2b                	cmp    $0x2b,%al
  800b66:	74 2a                	je     800b92 <strtol+0x4a>
	int neg = 0;
  800b68:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6d:	3c 2d                	cmp    $0x2d,%al
  800b6f:	74 2b                	je     800b9c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b71:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b77:	75 0f                	jne    800b88 <strtol+0x40>
  800b79:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7c:	74 28                	je     800ba6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b85:	0f 44 d8             	cmove  %eax,%ebx
  800b88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b90:	eb 46                	jmp    800bd8 <strtol+0x90>
		s++;
  800b92:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b95:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9a:	eb d5                	jmp    800b71 <strtol+0x29>
		s++, neg = 1;
  800b9c:	83 c2 01             	add    $0x1,%edx
  800b9f:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba4:	eb cb                	jmp    800b71 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba6:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800baa:	74 0e                	je     800bba <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bac:	85 db                	test   %ebx,%ebx
  800bae:	75 d8                	jne    800b88 <strtol+0x40>
		s++, base = 8;
  800bb0:	83 c2 01             	add    $0x1,%edx
  800bb3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb8:	eb ce                	jmp    800b88 <strtol+0x40>
		s += 2, base = 16;
  800bba:	83 c2 02             	add    $0x2,%edx
  800bbd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc2:	eb c4                	jmp    800b88 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bc4:	0f be c0             	movsbl %al,%eax
  800bc7:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bca:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bcd:	7d 3a                	jge    800c09 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bcf:	83 c2 01             	add    $0x1,%edx
  800bd2:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bd6:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bd8:	0f b6 02             	movzbl (%edx),%eax
  800bdb:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bde:	89 f3                	mov    %esi,%ebx
  800be0:	80 fb 09             	cmp    $0x9,%bl
  800be3:	76 df                	jbe    800bc4 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800be5:	8d 70 9f             	lea    -0x61(%eax),%esi
  800be8:	89 f3                	mov    %esi,%ebx
  800bea:	80 fb 19             	cmp    $0x19,%bl
  800bed:	77 08                	ja     800bf7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bef:	0f be c0             	movsbl %al,%eax
  800bf2:	83 e8 57             	sub    $0x57,%eax
  800bf5:	eb d3                	jmp    800bca <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bf7:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bfa:	89 f3                	mov    %esi,%ebx
  800bfc:	80 fb 19             	cmp    $0x19,%bl
  800bff:	77 08                	ja     800c09 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c01:	0f be c0             	movsbl %al,%eax
  800c04:	83 e8 37             	sub    $0x37,%eax
  800c07:	eb c1                	jmp    800bca <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0d:	74 05                	je     800c14 <strtol+0xcc>
		*endptr = (char *) s;
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c14:	89 c8                	mov    %ecx,%eax
  800c16:	f7 d8                	neg    %eax
  800c18:	85 ff                	test   %edi,%edi
  800c1a:	0f 45 c8             	cmovne %eax,%ecx
}
  800c1d:	89 c8                	mov    %ecx,%eax
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
  800c24:	66 90                	xchg   %ax,%ax
  800c26:	66 90                	xchg   %ax,%ax
  800c28:	66 90                	xchg   %ax,%ax
  800c2a:	66 90                	xchg   %ax,%ax
  800c2c:	66 90                	xchg   %ax,%ax
  800c2e:	66 90                	xchg   %ax,%ax

00800c30 <__udivdi3>:
  800c30:	f3 0f 1e fb          	endbr32 
  800c34:	55                   	push   %ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 1c             	sub    $0x1c,%esp
  800c3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800c3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c43:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	75 19                	jne    800c68 <__udivdi3+0x38>
  800c4f:	39 f3                	cmp    %esi,%ebx
  800c51:	76 4d                	jbe    800ca0 <__udivdi3+0x70>
  800c53:	31 ff                	xor    %edi,%edi
  800c55:	89 e8                	mov    %ebp,%eax
  800c57:	89 f2                	mov    %esi,%edx
  800c59:	f7 f3                	div    %ebx
  800c5b:	89 fa                	mov    %edi,%edx
  800c5d:	83 c4 1c             	add    $0x1c,%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    
  800c65:	8d 76 00             	lea    0x0(%esi),%esi
  800c68:	39 f0                	cmp    %esi,%eax
  800c6a:	76 14                	jbe    800c80 <__udivdi3+0x50>
  800c6c:	31 ff                	xor    %edi,%edi
  800c6e:	31 c0                	xor    %eax,%eax
  800c70:	89 fa                	mov    %edi,%edx
  800c72:	83 c4 1c             	add    $0x1c,%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    
  800c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c80:	0f bd f8             	bsr    %eax,%edi
  800c83:	83 f7 1f             	xor    $0x1f,%edi
  800c86:	75 48                	jne    800cd0 <__udivdi3+0xa0>
  800c88:	39 f0                	cmp    %esi,%eax
  800c8a:	72 06                	jb     800c92 <__udivdi3+0x62>
  800c8c:	31 c0                	xor    %eax,%eax
  800c8e:	39 eb                	cmp    %ebp,%ebx
  800c90:	77 de                	ja     800c70 <__udivdi3+0x40>
  800c92:	b8 01 00 00 00       	mov    $0x1,%eax
  800c97:	eb d7                	jmp    800c70 <__udivdi3+0x40>
  800c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ca0:	89 d9                	mov    %ebx,%ecx
  800ca2:	85 db                	test   %ebx,%ebx
  800ca4:	75 0b                	jne    800cb1 <__udivdi3+0x81>
  800ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  800cab:	31 d2                	xor    %edx,%edx
  800cad:	f7 f3                	div    %ebx
  800caf:	89 c1                	mov    %eax,%ecx
  800cb1:	31 d2                	xor    %edx,%edx
  800cb3:	89 f0                	mov    %esi,%eax
  800cb5:	f7 f1                	div    %ecx
  800cb7:	89 c6                	mov    %eax,%esi
  800cb9:	89 e8                	mov    %ebp,%eax
  800cbb:	89 f7                	mov    %esi,%edi
  800cbd:	f7 f1                	div    %ecx
  800cbf:	89 fa                	mov    %edi,%edx
  800cc1:	83 c4 1c             	add    $0x1c,%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
  800cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cd0:	89 f9                	mov    %edi,%ecx
  800cd2:	ba 20 00 00 00       	mov    $0x20,%edx
  800cd7:	29 fa                	sub    %edi,%edx
  800cd9:	d3 e0                	shl    %cl,%eax
  800cdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 d8                	mov    %ebx,%eax
  800ce3:	d3 e8                	shr    %cl,%eax
  800ce5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ce9:	09 c1                	or     %eax,%ecx
  800ceb:	89 f0                	mov    %esi,%eax
  800ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cf1:	89 f9                	mov    %edi,%ecx
  800cf3:	d3 e3                	shl    %cl,%ebx
  800cf5:	89 d1                	mov    %edx,%ecx
  800cf7:	d3 e8                	shr    %cl,%eax
  800cf9:	89 f9                	mov    %edi,%ecx
  800cfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cff:	89 eb                	mov    %ebp,%ebx
  800d01:	d3 e6                	shl    %cl,%esi
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	d3 eb                	shr    %cl,%ebx
  800d07:	09 f3                	or     %esi,%ebx
  800d09:	89 c6                	mov    %eax,%esi
  800d0b:	89 f2                	mov    %esi,%edx
  800d0d:	89 d8                	mov    %ebx,%eax
  800d0f:	f7 74 24 08          	divl   0x8(%esp)
  800d13:	89 d6                	mov    %edx,%esi
  800d15:	89 c3                	mov    %eax,%ebx
  800d17:	f7 64 24 0c          	mull   0xc(%esp)
  800d1b:	39 d6                	cmp    %edx,%esi
  800d1d:	72 19                	jb     800d38 <__udivdi3+0x108>
  800d1f:	89 f9                	mov    %edi,%ecx
  800d21:	d3 e5                	shl    %cl,%ebp
  800d23:	39 c5                	cmp    %eax,%ebp
  800d25:	73 04                	jae    800d2b <__udivdi3+0xfb>
  800d27:	39 d6                	cmp    %edx,%esi
  800d29:	74 0d                	je     800d38 <__udivdi3+0x108>
  800d2b:	89 d8                	mov    %ebx,%eax
  800d2d:	31 ff                	xor    %edi,%edi
  800d2f:	e9 3c ff ff ff       	jmp    800c70 <__udivdi3+0x40>
  800d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d3b:	31 ff                	xor    %edi,%edi
  800d3d:	e9 2e ff ff ff       	jmp    800c70 <__udivdi3+0x40>
  800d42:	66 90                	xchg   %ax,%ax
  800d44:	66 90                	xchg   %ax,%ax
  800d46:	66 90                	xchg   %ax,%ax
  800d48:	66 90                	xchg   %ax,%ax
  800d4a:	66 90                	xchg   %ax,%ax
  800d4c:	66 90                	xchg   %ax,%ax
  800d4e:	66 90                	xchg   %ax,%ax

00800d50 <__umoddi3>:
  800d50:	f3 0f 1e fb          	endbr32 
  800d54:	55                   	push   %ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 1c             	sub    $0x1c,%esp
  800d5b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d5f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d63:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800d67:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800d6b:	89 f0                	mov    %esi,%eax
  800d6d:	89 da                	mov    %ebx,%edx
  800d6f:	85 ff                	test   %edi,%edi
  800d71:	75 15                	jne    800d88 <__umoddi3+0x38>
  800d73:	39 dd                	cmp    %ebx,%ebp
  800d75:	76 39                	jbe    800db0 <__umoddi3+0x60>
  800d77:	f7 f5                	div    %ebp
  800d79:	89 d0                	mov    %edx,%eax
  800d7b:	31 d2                	xor    %edx,%edx
  800d7d:	83 c4 1c             	add    $0x1c,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    
  800d85:	8d 76 00             	lea    0x0(%esi),%esi
  800d88:	39 df                	cmp    %ebx,%edi
  800d8a:	77 f1                	ja     800d7d <__umoddi3+0x2d>
  800d8c:	0f bd cf             	bsr    %edi,%ecx
  800d8f:	83 f1 1f             	xor    $0x1f,%ecx
  800d92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d96:	75 40                	jne    800dd8 <__umoddi3+0x88>
  800d98:	39 df                	cmp    %ebx,%edi
  800d9a:	72 04                	jb     800da0 <__umoddi3+0x50>
  800d9c:	39 f5                	cmp    %esi,%ebp
  800d9e:	77 dd                	ja     800d7d <__umoddi3+0x2d>
  800da0:	89 da                	mov    %ebx,%edx
  800da2:	89 f0                	mov    %esi,%eax
  800da4:	29 e8                	sub    %ebp,%eax
  800da6:	19 fa                	sbb    %edi,%edx
  800da8:	eb d3                	jmp    800d7d <__umoddi3+0x2d>
  800daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800db0:	89 e9                	mov    %ebp,%ecx
  800db2:	85 ed                	test   %ebp,%ebp
  800db4:	75 0b                	jne    800dc1 <__umoddi3+0x71>
  800db6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbb:	31 d2                	xor    %edx,%edx
  800dbd:	f7 f5                	div    %ebp
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	89 d8                	mov    %ebx,%eax
  800dc3:	31 d2                	xor    %edx,%edx
  800dc5:	f7 f1                	div    %ecx
  800dc7:	89 f0                	mov    %esi,%eax
  800dc9:	f7 f1                	div    %ecx
  800dcb:	89 d0                	mov    %edx,%eax
  800dcd:	31 d2                	xor    %edx,%edx
  800dcf:	eb ac                	jmp    800d7d <__umoddi3+0x2d>
  800dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800dd8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ddc:	ba 20 00 00 00       	mov    $0x20,%edx
  800de1:	29 c2                	sub    %eax,%edx
  800de3:	89 c1                	mov    %eax,%ecx
  800de5:	89 e8                	mov    %ebp,%eax
  800de7:	d3 e7                	shl    %cl,%edi
  800de9:	89 d1                	mov    %edx,%ecx
  800deb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800def:	d3 e8                	shr    %cl,%eax
  800df1:	89 c1                	mov    %eax,%ecx
  800df3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800df7:	09 f9                	or     %edi,%ecx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800dff:	89 c1                	mov    %eax,%ecx
  800e01:	d3 e5                	shl    %cl,%ebp
  800e03:	89 d1                	mov    %edx,%ecx
  800e05:	d3 ef                	shr    %cl,%edi
  800e07:	89 c1                	mov    %eax,%ecx
  800e09:	89 f0                	mov    %esi,%eax
  800e0b:	d3 e3                	shl    %cl,%ebx
  800e0d:	89 d1                	mov    %edx,%ecx
  800e0f:	89 fa                	mov    %edi,%edx
  800e11:	d3 e8                	shr    %cl,%eax
  800e13:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e18:	09 d8                	or     %ebx,%eax
  800e1a:	f7 74 24 08          	divl   0x8(%esp)
  800e1e:	89 d3                	mov    %edx,%ebx
  800e20:	d3 e6                	shl    %cl,%esi
  800e22:	f7 e5                	mul    %ebp
  800e24:	89 c7                	mov    %eax,%edi
  800e26:	89 d1                	mov    %edx,%ecx
  800e28:	39 d3                	cmp    %edx,%ebx
  800e2a:	72 06                	jb     800e32 <__umoddi3+0xe2>
  800e2c:	75 0e                	jne    800e3c <__umoddi3+0xec>
  800e2e:	39 c6                	cmp    %eax,%esi
  800e30:	73 0a                	jae    800e3c <__umoddi3+0xec>
  800e32:	29 e8                	sub    %ebp,%eax
  800e34:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800e38:	89 d1                	mov    %edx,%ecx
  800e3a:	89 c7                	mov    %eax,%edi
  800e3c:	89 f5                	mov    %esi,%ebp
  800e3e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e42:	29 fd                	sub    %edi,%ebp
  800e44:	19 cb                	sbb    %ecx,%ebx
  800e46:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e4b:	89 d8                	mov    %ebx,%eax
  800e4d:	d3 e0                	shl    %cl,%eax
  800e4f:	89 f1                	mov    %esi,%ecx
  800e51:	d3 ed                	shr    %cl,%ebp
  800e53:	d3 eb                	shr    %cl,%ebx
  800e55:	09 e8                	or     %ebp,%eax
  800e57:	89 da                	mov    %ebx,%edx
  800e59:	83 c4 1c             	add    $0x1c,%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
