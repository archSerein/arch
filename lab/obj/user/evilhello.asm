
obj/user/evilhello:     file format elf32-i386


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
  80002c:	e8 2c 00 00 00       	call   80005d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	e8 1a 00 00 00       	call   800059 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800045:	6a 64                	push   $0x64
  800047:	68 0c 00 10 f0       	push   $0xf010000c
  80004c:	e8 89 00 00 00       	call   8000da <sys_cputs>
}
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <__x86.get_pc_thunk.bx>:
  800059:	8b 1c 24             	mov    (%esp),%ebx
  80005c:	c3                   	ret    

0080005d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	e8 ee ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  80006b:	81 c3 95 1f 00 00    	add    $0x1f95,%ebx
  800071:	8b 75 08             	mov    0x8(%ebp),%esi
  800074:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800077:	e8 f0 00 00 00       	call   80016c <sys_getenvid>
  80007c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800081:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800084:	c1 e0 05             	shl    $0x5,%eax
  800087:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80008d:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800093:	85 f6                	test   %esi,%esi
  800095:	7e 08                	jle    80009f <libmain+0x42>
		binaryname = argv[0];
  800097:	8b 07                	mov    (%edi),%eax
  800099:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	e8 8a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a9:	e8 0b 00 00 00       	call   8000b9 <exit>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b4:	5b                   	pop    %ebx
  8000b5:	5e                   	pop    %esi
  8000b6:	5f                   	pop    %edi
  8000b7:	5d                   	pop    %ebp
  8000b8:	c3                   	ret    

008000b9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b9:	55                   	push   %ebp
  8000ba:	89 e5                	mov    %esp,%ebp
  8000bc:	53                   	push   %ebx
  8000bd:	83 ec 10             	sub    $0x10,%esp
  8000c0:	e8 94 ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8000c5:	81 c3 3b 1f 00 00    	add    $0x1f3b,%ebx
	sys_env_destroy(0);
  8000cb:	6a 00                	push   $0x0
  8000cd:	e8 45 00 00 00       	call   800117 <sys_env_destroy>
}
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d8:	c9                   	leave  
  8000d9:	c3                   	ret    

008000da <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000eb:	89 c3                	mov    %eax,%ebx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800103:	b8 01 00 00 00       	mov    $0x1,%eax
  800108:	89 d1                	mov    %edx,%ecx
  80010a:	89 d3                	mov    %edx,%ebx
  80010c:	89 d7                	mov    %edx,%edi
  80010e:	89 d6                	mov    %edx,%esi
  800110:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5f                   	pop    %edi
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    

00800117 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	83 ec 1c             	sub    $0x1c,%esp
  800120:	e8 66 00 00 00       	call   80018b <__x86.get_pc_thunk.ax>
  800125:	05 db 1e 00 00       	add    $0x1edb,%eax
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80012d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800132:	8b 55 08             	mov    0x8(%ebp),%edx
  800135:	b8 03 00 00 00       	mov    $0x3,%eax
  80013a:	89 cb                	mov    %ecx,%ebx
  80013c:	89 cf                	mov    %ecx,%edi
  80013e:	89 ce                	mov    %ecx,%esi
  800140:	cd 30                	int    $0x30
	if(check && ret > 0)
  800142:	85 c0                	test   %eax,%eax
  800144:	7f 08                	jg     80014e <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	6a 03                	push   $0x3
  800154:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800157:	8d 83 8e ee ff ff    	lea    -0x1172(%ebx),%eax
  80015d:	50                   	push   %eax
  80015e:	6a 23                	push   $0x23
  800160:	8d 83 ab ee ff ff    	lea    -0x1155(%ebx),%eax
  800166:	50                   	push   %eax
  800167:	e8 23 00 00 00       	call   80018f <_panic>

0080016c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
	asm volatile("int %1\n"
  800172:	ba 00 00 00 00       	mov    $0x0,%edx
  800177:	b8 02 00 00 00       	mov    $0x2,%eax
  80017c:	89 d1                	mov    %edx,%ecx
  80017e:	89 d3                	mov    %edx,%ebx
  800180:	89 d7                	mov    %edx,%edi
  800182:	89 d6                	mov    %edx,%esi
  800184:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800186:	5b                   	pop    %ebx
  800187:	5e                   	pop    %esi
  800188:	5f                   	pop    %edi
  800189:	5d                   	pop    %ebp
  80018a:	c3                   	ret    

0080018b <__x86.get_pc_thunk.ax>:
  80018b:	8b 04 24             	mov    (%esp),%eax
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	57                   	push   %edi
  800193:	56                   	push   %esi
  800194:	53                   	push   %ebx
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	e8 bc fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  80019d:	81 c3 63 1e 00 00    	add    $0x1e63,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001a3:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a6:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001ac:	8b 38                	mov    (%eax),%edi
  8001ae:	e8 b9 ff ff ff       	call   80016c <sys_getenvid>
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	ff 75 0c             	push   0xc(%ebp)
  8001b9:	ff 75 08             	push   0x8(%ebp)
  8001bc:	57                   	push   %edi
  8001bd:	50                   	push   %eax
  8001be:	8d 83 bc ee ff ff    	lea    -0x1144(%ebx),%eax
  8001c4:	50                   	push   %eax
  8001c5:	e8 d1 00 00 00       	call   80029b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ca:	83 c4 18             	add    $0x18,%esp
  8001cd:	56                   	push   %esi
  8001ce:	ff 75 10             	push   0x10(%ebp)
  8001d1:	e8 63 00 00 00       	call   800239 <vcprintf>
	cprintf("\n");
  8001d6:	8d 83 df ee ff ff    	lea    -0x1121(%ebx),%eax
  8001dc:	89 04 24             	mov    %eax,(%esp)
  8001df:	e8 b7 00 00 00       	call   80029b <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e7:	cc                   	int3   
  8001e8:	eb fd                	jmp    8001e7 <_panic+0x58>

008001ea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	e8 65 fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8001f4:	81 c3 0c 1e 00 00    	add    $0x1e0c,%ebx
  8001fa:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001fd:	8b 16                	mov    (%esi),%edx
  8001ff:	8d 42 01             	lea    0x1(%edx),%eax
  800202:	89 06                	mov    %eax,(%esi)
  800204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800207:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  80020b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800210:	74 0b                	je     80021d <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800212:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800216:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800219:	5b                   	pop    %ebx
  80021a:	5e                   	pop    %esi
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	68 ff 00 00 00       	push   $0xff
  800225:	8d 46 08             	lea    0x8(%esi),%eax
  800228:	50                   	push   %eax
  800229:	e8 ac fe ff ff       	call   8000da <sys_cputs>
		b->idx = 0;
  80022e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	eb d9                	jmp    800212 <putch+0x28>

00800239 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	53                   	push   %ebx
  80023d:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800243:	e8 11 fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800248:	81 c3 b8 1d 00 00    	add    $0x1db8,%ebx
	struct printbuf b;

	b.idx = 0;
  80024e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800255:	00 00 00 
	b.cnt = 0;
  800258:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800262:	ff 75 0c             	push   0xc(%ebp)
  800265:	ff 75 08             	push   0x8(%ebp)
  800268:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026e:	50                   	push   %eax
  80026f:	8d 83 ea e1 ff ff    	lea    -0x1e16(%ebx),%eax
  800275:	50                   	push   %eax
  800276:	e8 2c 01 00 00       	call   8003a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80027b:	83 c4 08             	add    $0x8,%esp
  80027e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800284:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80028a:	50                   	push   %eax
  80028b:	e8 4a fe ff ff       	call   8000da <sys_cputs>

	return b.cnt;
}
  800290:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800299:	c9                   	leave  
  80029a:	c3                   	ret    

0080029b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a4:	50                   	push   %eax
  8002a5:	ff 75 08             	push   0x8(%ebp)
  8002a8:	e8 8c ff ff ff       	call   800239 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	57                   	push   %edi
  8002b3:	56                   	push   %esi
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 2c             	sub    $0x2c,%esp
  8002b8:	e8 07 06 00 00       	call   8008c4 <__x86.get_pc_thunk.cx>
  8002bd:	81 c1 43 1d 00 00    	add    $0x1d43,%ecx
  8002c3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	89 d6                	mov    %edx,%esi
  8002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d0:	89 d1                	mov    %edx,%ecx
  8002d2:	89 c2                	mov    %eax,%edx
  8002d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002da:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002ea:	39 c2                	cmp    %eax,%edx
  8002ec:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ef:	72 41                	jb     800332 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	ff 75 18             	push   0x18(%ebp)
  8002f7:	83 eb 01             	sub    $0x1,%ebx
  8002fa:	53                   	push   %ebx
  8002fb:	50                   	push   %eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	ff 75 e4             	push   -0x1c(%ebp)
  800302:	ff 75 e0             	push   -0x20(%ebp)
  800305:	ff 75 d4             	push   -0x2c(%ebp)
  800308:	ff 75 d0             	push   -0x30(%ebp)
  80030b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80030e:	e8 3d 09 00 00       	call   800c50 <__udivdi3>
  800313:	83 c4 18             	add    $0x18,%esp
  800316:	52                   	push   %edx
  800317:	50                   	push   %eax
  800318:	89 f2                	mov    %esi,%edx
  80031a:	89 f8                	mov    %edi,%eax
  80031c:	e8 8e ff ff ff       	call   8002af <printnum>
  800321:	83 c4 20             	add    $0x20,%esp
  800324:	eb 13                	jmp    800339 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	56                   	push   %esi
  80032a:	ff 75 18             	push   0x18(%ebp)
  80032d:	ff d7                	call   *%edi
  80032f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800332:	83 eb 01             	sub    $0x1,%ebx
  800335:	85 db                	test   %ebx,%ebx
  800337:	7f ed                	jg     800326 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	ff 75 e4             	push   -0x1c(%ebp)
  800343:	ff 75 e0             	push   -0x20(%ebp)
  800346:	ff 75 d4             	push   -0x2c(%ebp)
  800349:	ff 75 d0             	push   -0x30(%ebp)
  80034c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80034f:	e8 1c 0a 00 00       	call   800d70 <__umoddi3>
  800354:	83 c4 14             	add    $0x14,%esp
  800357:	0f be 84 03 e1 ee ff 	movsbl -0x111f(%ebx,%eax,1),%eax
  80035e:	ff 
  80035f:	50                   	push   %eax
  800360:	ff d7                	call   *%edi
}
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800368:	5b                   	pop    %ebx
  800369:	5e                   	pop    %esi
  80036a:	5f                   	pop    %edi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800373:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800377:	8b 10                	mov    (%eax),%edx
  800379:	3b 50 04             	cmp    0x4(%eax),%edx
  80037c:	73 0a                	jae    800388 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800381:	89 08                	mov    %ecx,(%eax)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	88 02                	mov    %al,(%edx)
}
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <printfmt>:
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800390:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800393:	50                   	push   %eax
  800394:	ff 75 10             	push   0x10(%ebp)
  800397:	ff 75 0c             	push   0xc(%ebp)
  80039a:	ff 75 08             	push   0x8(%ebp)
  80039d:	e8 05 00 00 00       	call   8003a7 <vprintfmt>
}
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	c9                   	leave  
  8003a6:	c3                   	ret    

008003a7 <vprintfmt>:
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	57                   	push   %edi
  8003ab:	56                   	push   %esi
  8003ac:	53                   	push   %ebx
  8003ad:	83 ec 3c             	sub    $0x3c,%esp
  8003b0:	e8 d6 fd ff ff       	call   80018b <__x86.get_pc_thunk.ax>
  8003b5:	05 4b 1c 00 00       	add    $0x1c4b,%eax
  8003ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c6:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003cf:	eb 0a                	jmp    8003db <vprintfmt+0x34>
			putch(ch, putdat);
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	57                   	push   %edi
  8003d5:	50                   	push   %eax
  8003d6:	ff d6                	call   *%esi
  8003d8:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003db:	83 c3 01             	add    $0x1,%ebx
  8003de:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003e2:	83 f8 25             	cmp    $0x25,%eax
  8003e5:	74 0c                	je     8003f3 <vprintfmt+0x4c>
			if (ch == '\0')
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	75 e6                	jne    8003d1 <vprintfmt+0x2a>
}
  8003eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    
		padc = ' ';
  8003f3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003f7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800405:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80040c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800411:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800414:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8d 43 01             	lea    0x1(%ebx),%eax
  80041a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041d:	0f b6 13             	movzbl (%ebx),%edx
  800420:	8d 42 dd             	lea    -0x23(%edx),%eax
  800423:	3c 55                	cmp    $0x55,%al
  800425:	0f 87 fd 03 00 00    	ja     800828 <.L20>
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800431:	89 ce                	mov    %ecx,%esi
  800433:	03 b4 81 70 ef ff ff 	add    -0x1090(%ecx,%eax,4),%esi
  80043a:	ff e6                	jmp    *%esi

0080043c <.L68>:
  80043c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80043f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800443:	eb d2                	jmp    800417 <vprintfmt+0x70>

00800445 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800445:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800448:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80044c:	eb c9                	jmp    800417 <vprintfmt+0x70>

0080044e <.L31>:
  80044e:	0f b6 d2             	movzbl %dl,%edx
  800451:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80045c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80045f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800463:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800466:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800469:	83 f9 09             	cmp    $0x9,%ecx
  80046c:	77 58                	ja     8004c6 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80046e:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800471:	eb e9                	jmp    80045c <.L31+0xe>

00800473 <.L34>:
			precision = va_arg(ap, int);
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	8d 40 04             	lea    0x4(%eax),%eax
  800481:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800487:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80048b:	79 8a                	jns    800417 <vprintfmt+0x70>
				width = precision, precision = -1;
  80048d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800490:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800493:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049a:	e9 78 ff ff ff       	jmp    800417 <vprintfmt+0x70>

0080049f <.L33>:
  80049f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004a2:	85 d2                	test   %edx,%edx
  8004a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a9:	0f 49 c2             	cmovns %edx,%eax
  8004ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b2:	e9 60 ff ff ff       	jmp    800417 <vprintfmt+0x70>

008004b7 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004ba:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004c1:	e9 51 ff ff ff       	jmp    800417 <vprintfmt+0x70>
  8004c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cc:	eb b9                	jmp    800487 <.L34+0x14>

008004ce <.L27>:
			lflag++;
  8004ce:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d5:	e9 3d ff ff ff       	jmp    800417 <vprintfmt+0x70>

008004da <.L30>:
			putch(va_arg(ap, int), putdat);
  8004da:	8b 75 08             	mov    0x8(%ebp),%esi
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	57                   	push   %edi
  8004e7:	ff 30                	push   (%eax)
  8004e9:	ff d6                	call   *%esi
			break;
  8004eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ee:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004f1:	e9 c8 02 00 00       	jmp    8007be <.L25+0x45>

008004f6 <.L28>:
			err = va_arg(ap, int);
  8004f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 58 04             	lea    0x4(%eax),%ebx
  8004ff:	8b 10                	mov    (%eax),%edx
  800501:	89 d0                	mov    %edx,%eax
  800503:	f7 d8                	neg    %eax
  800505:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800508:	83 f8 06             	cmp    $0x6,%eax
  80050b:	7f 27                	jg     800534 <.L28+0x3e>
  80050d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800510:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800513:	85 d2                	test   %edx,%edx
  800515:	74 1d                	je     800534 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  800517:	52                   	push   %edx
  800518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051b:	8d 80 02 ef ff ff    	lea    -0x10fe(%eax),%eax
  800521:	50                   	push   %eax
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	e8 61 fe ff ff       	call   80038a <printfmt>
  800529:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052c:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80052f:	e9 8a 02 00 00       	jmp    8007be <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800534:	50                   	push   %eax
  800535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800538:	8d 80 f9 ee ff ff    	lea    -0x1107(%eax),%eax
  80053e:	50                   	push   %eax
  80053f:	57                   	push   %edi
  800540:	56                   	push   %esi
  800541:	e8 44 fe ff ff       	call   80038a <printfmt>
  800546:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800549:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054c:	e9 6d 02 00 00       	jmp    8007be <.L25+0x45>

00800551 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  800551:	8b 75 08             	mov    0x8(%ebp),%esi
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 c0 04             	add    $0x4,%eax
  80055a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800562:	85 d2                	test   %edx,%edx
  800564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800567:	8d 80 f2 ee ff ff    	lea    -0x110e(%eax),%eax
  80056d:	0f 45 c2             	cmovne %edx,%eax
  800570:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800577:	7e 06                	jle    80057f <.L24+0x2e>
  800579:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057d:	75 0d                	jne    80058c <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800582:	89 c3                	mov    %eax,%ebx
  800584:	03 45 d4             	add    -0x2c(%ebp),%eax
  800587:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80058a:	eb 58                	jmp    8005e4 <.L24+0x93>
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	ff 75 d8             	push   -0x28(%ebp)
  800592:	ff 75 c8             	push   -0x38(%ebp)
  800595:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800598:	e8 43 03 00 00       	call   8008e0 <strnlen>
  80059d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a0:	29 c2                	sub    %eax,%edx
  8005a2:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005aa:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	eb 0f                	jmp    8005c2 <.L24+0x71>
					putch(padc, putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	57                   	push   %edi
  8005b7:	ff 75 d4             	push   -0x2c(%ebp)
  8005ba:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bc:	83 eb 01             	sub    $0x1,%ebx
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	85 db                	test   %ebx,%ebx
  8005c4:	7f ed                	jg     8005b3 <.L24+0x62>
  8005c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c9:	85 d2                	test   %edx,%edx
  8005cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d0:	0f 49 c2             	cmovns %edx,%eax
  8005d3:	29 c2                	sub    %eax,%edx
  8005d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d8:	eb a5                	jmp    80057f <.L24+0x2e>
					putch(ch, putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	57                   	push   %edi
  8005de:	52                   	push   %edx
  8005df:	ff d6                	call   *%esi
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e7:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e9:	83 c3 01             	add    $0x1,%ebx
  8005ec:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005f0:	0f be d0             	movsbl %al,%edx
  8005f3:	85 d2                	test   %edx,%edx
  8005f5:	74 4b                	je     800642 <.L24+0xf1>
  8005f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fb:	78 06                	js     800603 <.L24+0xb2>
  8005fd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800601:	78 1e                	js     800621 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800603:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800607:	74 d1                	je     8005da <.L24+0x89>
  800609:	0f be c0             	movsbl %al,%eax
  80060c:	83 e8 20             	sub    $0x20,%eax
  80060f:	83 f8 5e             	cmp    $0x5e,%eax
  800612:	76 c6                	jbe    8005da <.L24+0x89>
					putch('?', putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	57                   	push   %edi
  800618:	6a 3f                	push   $0x3f
  80061a:	ff d6                	call   *%esi
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb c3                	jmp    8005e4 <.L24+0x93>
  800621:	89 cb                	mov    %ecx,%ebx
  800623:	eb 0e                	jmp    800633 <.L24+0xe2>
				putch(' ', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	57                   	push   %edi
  800629:	6a 20                	push   $0x20
  80062b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062d:	83 eb 01             	sub    $0x1,%ebx
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	85 db                	test   %ebx,%ebx
  800635:	7f ee                	jg     800625 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800637:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
  80063d:	e9 7c 01 00 00       	jmp    8007be <.L25+0x45>
  800642:	89 cb                	mov    %ecx,%ebx
  800644:	eb ed                	jmp    800633 <.L24+0xe2>

00800646 <.L29>:
	if (lflag >= 2)
  800646:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800649:	8b 75 08             	mov    0x8(%ebp),%esi
  80064c:	83 f9 01             	cmp    $0x1,%ecx
  80064f:	7f 1b                	jg     80066c <.L29+0x26>
	else if (lflag)
  800651:	85 c9                	test   %ecx,%ecx
  800653:	74 63                	je     8006b8 <.L29+0x72>
		return va_arg(*ap, long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	99                   	cltd   
  80065e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	eb 17                	jmp    800683 <.L29+0x3d>
		return va_arg(*ap, long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 50 04             	mov    0x4(%eax),%edx
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800683:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800686:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800689:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  80068e:	85 db                	test   %ebx,%ebx
  800690:	0f 89 0e 01 00 00    	jns    8007a4 <.L25+0x2b>
				putch('-', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	57                   	push   %edi
  80069a:	6a 2d                	push   $0x2d
  80069c:	ff d6                	call   *%esi
				num = -(long long) num;
  80069e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006a1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a4:	f7 d9                	neg    %ecx
  8006a6:	83 d3 00             	adc    $0x0,%ebx
  8006a9:	f7 db                	neg    %ebx
  8006ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ae:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b3:	e9 ec 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	99                   	cltd   
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cd:	eb b4                	jmp    800683 <.L29+0x3d>

008006cf <.L23>:
	if (lflag >= 2)
  8006cf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d5:	83 f9 01             	cmp    $0x1,%ecx
  8006d8:	7f 1e                	jg     8006f8 <.L23+0x29>
	else if (lflag)
  8006da:	85 c9                	test   %ecx,%ecx
  8006dc:	74 32                	je     800710 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 08                	mov    (%eax),%ecx
  8006e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e8:	8d 40 04             	lea    0x4(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ee:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006f3:	e9 ac 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 08                	mov    (%eax),%ecx
  8006fd:	8b 58 04             	mov    0x4(%eax),%ebx
  800700:	8d 40 08             	lea    0x8(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800706:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  80070b:	e9 94 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 08                	mov    (%eax),%ecx
  800715:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800720:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800725:	eb 7d                	jmp    8007a4 <.L25+0x2b>

00800727 <.L26>:
	if (lflag >= 2)
  800727:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80072a:	8b 75 08             	mov    0x8(%ebp),%esi
  80072d:	83 f9 01             	cmp    $0x1,%ecx
  800730:	7f 1b                	jg     80074d <.L26+0x26>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	74 2c                	je     800762 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 08                	mov    (%eax),%ecx
  80073b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800746:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  80074b:	eb 57                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 08                	mov    (%eax),%ecx
  800752:	8b 58 04             	mov    0x4(%eax),%ebx
  800755:	8d 40 08             	lea    0x8(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075b:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  800760:	eb 42                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 08                	mov    (%eax),%ecx
  800767:	bb 00 00 00 00       	mov    $0x0,%ebx
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800772:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800777:	eb 2b                	jmp    8007a4 <.L25+0x2b>

00800779 <.L25>:
			putch('0', putdat);
  800779:	8b 75 08             	mov    0x8(%ebp),%esi
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	57                   	push   %edi
  800780:	6a 30                	push   $0x30
  800782:	ff d6                	call   *%esi
			putch('x', putdat);
  800784:	83 c4 08             	add    $0x8,%esp
  800787:	57                   	push   %edi
  800788:	6a 78                	push   $0x78
  80078a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 08                	mov    (%eax),%ecx
  800791:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800796:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	83 ec 0c             	sub    $0xc,%esp
  8007a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007ab:	50                   	push   %eax
  8007ac:	ff 75 d4             	push   -0x2c(%ebp)
  8007af:	52                   	push   %edx
  8007b0:	53                   	push   %ebx
  8007b1:	51                   	push   %ecx
  8007b2:	89 fa                	mov    %edi,%edx
  8007b4:	89 f0                	mov    %esi,%eax
  8007b6:	e8 f4 fa ff ff       	call   8002af <printnum>
			break;
  8007bb:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c1:	e9 15 fc ff ff       	jmp    8003db <vprintfmt+0x34>

008007c6 <.L21>:
	if (lflag >= 2)
  8007c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cc:	83 f9 01             	cmp    $0x1,%ecx
  8007cf:	7f 1b                	jg     8007ec <.L21+0x26>
	else if (lflag)
  8007d1:	85 c9                	test   %ecx,%ecx
  8007d3:	74 2c                	je     800801 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 08                	mov    (%eax),%ecx
  8007da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007df:	8d 40 04             	lea    0x4(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e5:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007ea:	eb b8                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 08                	mov    (%eax),%ecx
  8007f1:	8b 58 04             	mov    0x4(%eax),%ebx
  8007f4:	8d 40 08             	lea    0x8(%eax),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fa:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007ff:	eb a3                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 08                	mov    (%eax),%ecx
  800806:	bb 00 00 00 00       	mov    $0x0,%ebx
  80080b:	8d 40 04             	lea    0x4(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800811:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  800816:	eb 8c                	jmp    8007a4 <.L25+0x2b>

00800818 <.L35>:
			putch(ch, putdat);
  800818:	8b 75 08             	mov    0x8(%ebp),%esi
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	57                   	push   %edi
  80081f:	6a 25                	push   $0x25
  800821:	ff d6                	call   *%esi
			break;
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb 96                	jmp    8007be <.L25+0x45>

00800828 <.L20>:
			putch('%', putdat);
  800828:	8b 75 08             	mov    0x8(%ebp),%esi
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	57                   	push   %edi
  80082f:	6a 25                	push   $0x25
  800831:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 d8                	mov    %ebx,%eax
  800838:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083c:	74 05                	je     800843 <.L20+0x1b>
  80083e:	83 e8 01             	sub    $0x1,%eax
  800841:	eb f5                	jmp    800838 <.L20+0x10>
  800843:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800846:	e9 73 ff ff ff       	jmp    8007be <.L25+0x45>

0080084b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	83 ec 14             	sub    $0x14,%esp
  800852:	e8 02 f8 ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800857:	81 c3 a9 17 00 00    	add    $0x17a9,%ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800866:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800874:	85 c0                	test   %eax,%eax
  800876:	74 2b                	je     8008a3 <vsnprintf+0x58>
  800878:	85 d2                	test   %edx,%edx
  80087a:	7e 27                	jle    8008a3 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087c:	ff 75 14             	push   0x14(%ebp)
  80087f:	ff 75 10             	push   0x10(%ebp)
  800882:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	8d 83 6d e3 ff ff    	lea    -0x1c93(%ebx),%eax
  80088c:	50                   	push   %eax
  80088d:	e8 15 fb ff ff       	call   8003a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089b:	83 c4 10             	add    $0x10,%esp
}
  80089e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    
		return -E_INVAL;
  8008a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a8:	eb f4                	jmp    80089e <vsnprintf+0x53>

008008aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b3:	50                   	push   %eax
  8008b4:	ff 75 10             	push   0x10(%ebp)
  8008b7:	ff 75 0c             	push   0xc(%ebp)
  8008ba:	ff 75 08             	push   0x8(%ebp)
  8008bd:	e8 89 ff ff ff       	call   80084b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <__x86.get_pc_thunk.cx>:
  8008c4:	8b 0c 24             	mov    (%esp),%ecx
  8008c7:	c3                   	ret    

008008c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d3:	eb 03                	jmp    8008d8 <strlen+0x10>
		n++;
  8008d5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008dc:	75 f7                	jne    8008d5 <strlen+0xd>
	return n;
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ee:	eb 03                	jmp    8008f3 <strnlen+0x13>
		n++;
  8008f0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f3:	39 d0                	cmp    %edx,%eax
  8008f5:	74 08                	je     8008ff <strnlen+0x1f>
  8008f7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008fb:	75 f3                	jne    8008f0 <strnlen+0x10>
  8008fd:	89 c2                	mov    %eax,%edx
	return n;
}
  8008ff:	89 d0                	mov    %edx,%eax
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800916:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	84 d2                	test   %dl,%dl
  80091e:	75 f2                	jne    800912 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800920:	89 c8                	mov    %ecx,%eax
  800922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	83 ec 10             	sub    $0x10,%esp
  80092e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800931:	53                   	push   %ebx
  800932:	e8 91 ff ff ff       	call   8008c8 <strlen>
  800937:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80093a:	ff 75 0c             	push   0xc(%ebp)
  80093d:	01 d8                	add    %ebx,%eax
  80093f:	50                   	push   %eax
  800940:	e8 be ff ff ff       	call   800903 <strcpy>
	return dst;
}
  800945:	89 d8                	mov    %ebx,%eax
  800947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	56                   	push   %esi
  800950:	53                   	push   %ebx
  800951:	8b 75 08             	mov    0x8(%ebp),%esi
  800954:	8b 55 0c             	mov    0xc(%ebp),%edx
  800957:	89 f3                	mov    %esi,%ebx
  800959:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	eb 0f                	jmp    80096f <strncpy+0x23>
		*dst++ = *src;
  800960:	83 c0 01             	add    $0x1,%eax
  800963:	0f b6 0a             	movzbl (%edx),%ecx
  800966:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800969:	80 f9 01             	cmp    $0x1,%cl
  80096c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80096f:	39 d8                	cmp    %ebx,%eax
  800971:	75 ed                	jne    800960 <strncpy+0x14>
	}
	return ret;
}
  800973:	89 f0                	mov    %esi,%eax
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	8b 75 08             	mov    0x8(%ebp),%esi
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800984:	8b 55 10             	mov    0x10(%ebp),%edx
  800987:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800989:	85 d2                	test   %edx,%edx
  80098b:	74 21                	je     8009ae <strlcpy+0x35>
  80098d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800991:	89 f2                	mov    %esi,%edx
  800993:	eb 09                	jmp    80099e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800995:	83 c1 01             	add    $0x1,%ecx
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80099e:	39 c2                	cmp    %eax,%edx
  8009a0:	74 09                	je     8009ab <strlcpy+0x32>
  8009a2:	0f b6 19             	movzbl (%ecx),%ebx
  8009a5:	84 db                	test   %bl,%bl
  8009a7:	75 ec                	jne    800995 <strlcpy+0x1c>
  8009a9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ae:	29 f0                	sub    %esi,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009bd:	eb 06                	jmp    8009c5 <strcmp+0x11>
		p++, q++;
  8009bf:	83 c1 01             	add    $0x1,%ecx
  8009c2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009c5:	0f b6 01             	movzbl (%ecx),%eax
  8009c8:	84 c0                	test   %al,%al
  8009ca:	74 04                	je     8009d0 <strcmp+0x1c>
  8009cc:	3a 02                	cmp    (%edx),%al
  8009ce:	74 ef                	je     8009bf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d0:	0f b6 c0             	movzbl %al,%eax
  8009d3:	0f b6 12             	movzbl (%edx),%edx
  8009d6:	29 d0                	sub    %edx,%eax
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e4:	89 c3                	mov    %eax,%ebx
  8009e6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e9:	eb 06                	jmp    8009f1 <strncmp+0x17>
		n--, p++, q++;
  8009eb:	83 c0 01             	add    $0x1,%eax
  8009ee:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f1:	39 d8                	cmp    %ebx,%eax
  8009f3:	74 18                	je     800a0d <strncmp+0x33>
  8009f5:	0f b6 08             	movzbl (%eax),%ecx
  8009f8:	84 c9                	test   %cl,%cl
  8009fa:	74 04                	je     800a00 <strncmp+0x26>
  8009fc:	3a 0a                	cmp    (%edx),%cl
  8009fe:	74 eb                	je     8009eb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a00:	0f b6 00             	movzbl (%eax),%eax
  800a03:	0f b6 12             	movzbl (%edx),%edx
  800a06:	29 d0                	sub    %edx,%eax
}
  800a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    
		return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	eb f4                	jmp    800a08 <strncmp+0x2e>

00800a14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1e:	eb 03                	jmp    800a23 <strchr+0xf>
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	0f b6 10             	movzbl (%eax),%edx
  800a26:	84 d2                	test   %dl,%dl
  800a28:	74 06                	je     800a30 <strchr+0x1c>
		if (*s == c)
  800a2a:	38 ca                	cmp    %cl,%dl
  800a2c:	75 f2                	jne    800a20 <strchr+0xc>
  800a2e:	eb 05                	jmp    800a35 <strchr+0x21>
			return (char *) s;
	return 0;
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a41:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a44:	38 ca                	cmp    %cl,%dl
  800a46:	74 09                	je     800a51 <strfind+0x1a>
  800a48:	84 d2                	test   %dl,%dl
  800a4a:	74 05                	je     800a51 <strfind+0x1a>
	for (; *s; s++)
  800a4c:	83 c0 01             	add    $0x1,%eax
  800a4f:	eb f0                	jmp    800a41 <strfind+0xa>
			break;
	return (char *) s;
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	57                   	push   %edi
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5f:	85 c9                	test   %ecx,%ecx
  800a61:	74 2f                	je     800a92 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a63:	89 f8                	mov    %edi,%eax
  800a65:	09 c8                	or     %ecx,%eax
  800a67:	a8 03                	test   $0x3,%al
  800a69:	75 21                	jne    800a8c <memset+0x39>
		c &= 0xFF;
  800a6b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6f:	89 d0                	mov    %edx,%eax
  800a71:	c1 e0 08             	shl    $0x8,%eax
  800a74:	89 d3                	mov    %edx,%ebx
  800a76:	c1 e3 18             	shl    $0x18,%ebx
  800a79:	89 d6                	mov    %edx,%esi
  800a7b:	c1 e6 10             	shl    $0x10,%esi
  800a7e:	09 f3                	or     %esi,%ebx
  800a80:	09 da                	or     %ebx,%edx
  800a82:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a84:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a87:	fc                   	cld    
  800a88:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8a:	eb 06                	jmp    800a92 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	fc                   	cld    
  800a90:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a92:	89 f8                	mov    %edi,%eax
  800a94:	5b                   	pop    %ebx
  800a95:	5e                   	pop    %esi
  800a96:	5f                   	pop    %edi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	57                   	push   %edi
  800a9d:	56                   	push   %esi
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa7:	39 c6                	cmp    %eax,%esi
  800aa9:	73 32                	jae    800add <memmove+0x44>
  800aab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aae:	39 c2                	cmp    %eax,%edx
  800ab0:	76 2b                	jbe    800add <memmove+0x44>
		s += n;
		d += n;
  800ab2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 d6                	mov    %edx,%esi
  800ab7:	09 fe                	or     %edi,%esi
  800ab9:	09 ce                	or     %ecx,%esi
  800abb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac1:	75 0e                	jne    800ad1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac3:	83 ef 04             	sub    $0x4,%edi
  800ac6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acc:	fd                   	std    
  800acd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acf:	eb 09                	jmp    800ada <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad1:	83 ef 01             	sub    $0x1,%edi
  800ad4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad7:	fd                   	std    
  800ad8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ada:	fc                   	cld    
  800adb:	eb 1a                	jmp    800af7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800add:	89 f2                	mov    %esi,%edx
  800adf:	09 c2                	or     %eax,%edx
  800ae1:	09 ca                	or     %ecx,%edx
  800ae3:	f6 c2 03             	test   $0x3,%dl
  800ae6:	75 0a                	jne    800af2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aeb:	89 c7                	mov    %eax,%edi
  800aed:	fc                   	cld    
  800aee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af0:	eb 05                	jmp    800af7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af2:	89 c7                	mov    %eax,%edi
  800af4:	fc                   	cld    
  800af5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af7:	5e                   	pop    %esi
  800af8:	5f                   	pop    %edi
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b01:	ff 75 10             	push   0x10(%ebp)
  800b04:	ff 75 0c             	push   0xc(%ebp)
  800b07:	ff 75 08             	push   0x8(%ebp)
  800b0a:	e8 8a ff ff ff       	call   800a99 <memmove>
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c6                	mov    %eax,%esi
  800b1e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b21:	eb 06                	jmp    800b29 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b23:	83 c0 01             	add    $0x1,%eax
  800b26:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b29:	39 f0                	cmp    %esi,%eax
  800b2b:	74 14                	je     800b41 <memcmp+0x30>
		if (*s1 != *s2)
  800b2d:	0f b6 08             	movzbl (%eax),%ecx
  800b30:	0f b6 1a             	movzbl (%edx),%ebx
  800b33:	38 d9                	cmp    %bl,%cl
  800b35:	74 ec                	je     800b23 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b37:	0f b6 c1             	movzbl %cl,%eax
  800b3a:	0f b6 db             	movzbl %bl,%ebx
  800b3d:	29 d8                	sub    %ebx,%eax
  800b3f:	eb 05                	jmp    800b46 <memcmp+0x35>
	}

	return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b58:	eb 03                	jmp    800b5d <memfind+0x13>
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	73 04                	jae    800b65 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b61:	38 08                	cmp    %cl,(%eax)
  800b63:	75 f5                	jne    800b5a <memfind+0x10>
			break;
	return (void *) s;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b73:	eb 03                	jmp    800b78 <strtol+0x11>
		s++;
  800b75:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b78:	0f b6 02             	movzbl (%edx),%eax
  800b7b:	3c 20                	cmp    $0x20,%al
  800b7d:	74 f6                	je     800b75 <strtol+0xe>
  800b7f:	3c 09                	cmp    $0x9,%al
  800b81:	74 f2                	je     800b75 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b83:	3c 2b                	cmp    $0x2b,%al
  800b85:	74 2a                	je     800bb1 <strtol+0x4a>
	int neg = 0;
  800b87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8c:	3c 2d                	cmp    $0x2d,%al
  800b8e:	74 2b                	je     800bbb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b90:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b96:	75 0f                	jne    800ba7 <strtol+0x40>
  800b98:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9b:	74 28                	je     800bc5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9d:	85 db                	test   %ebx,%ebx
  800b9f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba4:	0f 44 d8             	cmove  %eax,%ebx
  800ba7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800baf:	eb 46                	jmp    800bf7 <strtol+0x90>
		s++;
  800bb1:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb9:	eb d5                	jmp    800b90 <strtol+0x29>
		s++, neg = 1;
  800bbb:	83 c2 01             	add    $0x1,%edx
  800bbe:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc3:	eb cb                	jmp    800b90 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc5:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bc9:	74 0e                	je     800bd9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	75 d8                	jne    800ba7 <strtol+0x40>
		s++, base = 8;
  800bcf:	83 c2 01             	add    $0x1,%edx
  800bd2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd7:	eb ce                	jmp    800ba7 <strtol+0x40>
		s += 2, base = 16;
  800bd9:	83 c2 02             	add    $0x2,%edx
  800bdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be1:	eb c4                	jmp    800ba7 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800be3:	0f be c0             	movsbl %al,%eax
  800be6:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bec:	7d 3a                	jge    800c28 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bf5:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bf7:	0f b6 02             	movzbl (%edx),%eax
  800bfa:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bfd:	89 f3                	mov    %esi,%ebx
  800bff:	80 fb 09             	cmp    $0x9,%bl
  800c02:	76 df                	jbe    800be3 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c04:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 08                	ja     800c16 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c0e:	0f be c0             	movsbl %al,%eax
  800c11:	83 e8 57             	sub    $0x57,%eax
  800c14:	eb d3                	jmp    800be9 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c16:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c19:	89 f3                	mov    %esi,%ebx
  800c1b:	80 fb 19             	cmp    $0x19,%bl
  800c1e:	77 08                	ja     800c28 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c20:	0f be c0             	movsbl %al,%eax
  800c23:	83 e8 37             	sub    $0x37,%eax
  800c26:	eb c1                	jmp    800be9 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 05                	je     800c33 <strtol+0xcc>
		*endptr = (char *) s;
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c33:	89 c8                	mov    %ecx,%eax
  800c35:	f7 d8                	neg    %eax
  800c37:	85 ff                	test   %edi,%edi
  800c39:	0f 45 c8             	cmovne %eax,%ecx
}
  800c3c:	89 c8                	mov    %ecx,%eax
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    
  800c43:	66 90                	xchg   %ax,%ax
  800c45:	66 90                	xchg   %ax,%ax
  800c47:	66 90                	xchg   %ax,%ax
  800c49:	66 90                	xchg   %ax,%ax
  800c4b:	66 90                	xchg   %ax,%ax
  800c4d:	66 90                	xchg   %ax,%ax
  800c4f:	90                   	nop

00800c50 <__udivdi3>:
  800c50:	f3 0f 1e fb          	endbr32 
  800c54:	55                   	push   %ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 1c             	sub    $0x1c,%esp
  800c5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800c5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c63:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	75 19                	jne    800c88 <__udivdi3+0x38>
  800c6f:	39 f3                	cmp    %esi,%ebx
  800c71:	76 4d                	jbe    800cc0 <__udivdi3+0x70>
  800c73:	31 ff                	xor    %edi,%edi
  800c75:	89 e8                	mov    %ebp,%eax
  800c77:	89 f2                	mov    %esi,%edx
  800c79:	f7 f3                	div    %ebx
  800c7b:	89 fa                	mov    %edi,%edx
  800c7d:	83 c4 1c             	add    $0x1c,%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    
  800c85:	8d 76 00             	lea    0x0(%esi),%esi
  800c88:	39 f0                	cmp    %esi,%eax
  800c8a:	76 14                	jbe    800ca0 <__udivdi3+0x50>
  800c8c:	31 ff                	xor    %edi,%edi
  800c8e:	31 c0                	xor    %eax,%eax
  800c90:	89 fa                	mov    %edi,%edx
  800c92:	83 c4 1c             	add    $0x1c,%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
  800c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ca0:	0f bd f8             	bsr    %eax,%edi
  800ca3:	83 f7 1f             	xor    $0x1f,%edi
  800ca6:	75 48                	jne    800cf0 <__udivdi3+0xa0>
  800ca8:	39 f0                	cmp    %esi,%eax
  800caa:	72 06                	jb     800cb2 <__udivdi3+0x62>
  800cac:	31 c0                	xor    %eax,%eax
  800cae:	39 eb                	cmp    %ebp,%ebx
  800cb0:	77 de                	ja     800c90 <__udivdi3+0x40>
  800cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb7:	eb d7                	jmp    800c90 <__udivdi3+0x40>
  800cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cc0:	89 d9                	mov    %ebx,%ecx
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	75 0b                	jne    800cd1 <__udivdi3+0x81>
  800cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccb:	31 d2                	xor    %edx,%edx
  800ccd:	f7 f3                	div    %ebx
  800ccf:	89 c1                	mov    %eax,%ecx
  800cd1:	31 d2                	xor    %edx,%edx
  800cd3:	89 f0                	mov    %esi,%eax
  800cd5:	f7 f1                	div    %ecx
  800cd7:	89 c6                	mov    %eax,%esi
  800cd9:	89 e8                	mov    %ebp,%eax
  800cdb:	89 f7                	mov    %esi,%edi
  800cdd:	f7 f1                	div    %ecx
  800cdf:	89 fa                	mov    %edi,%edx
  800ce1:	83 c4 1c             	add    $0x1c,%esp
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    
  800ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cf0:	89 f9                	mov    %edi,%ecx
  800cf2:	ba 20 00 00 00       	mov    $0x20,%edx
  800cf7:	29 fa                	sub    %edi,%edx
  800cf9:	d3 e0                	shl    %cl,%eax
  800cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d8                	mov    %ebx,%eax
  800d03:	d3 e8                	shr    %cl,%eax
  800d05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d09:	09 c1                	or     %eax,%ecx
  800d0b:	89 f0                	mov    %esi,%eax
  800d0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d11:	89 f9                	mov    %edi,%ecx
  800d13:	d3 e3                	shl    %cl,%ebx
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	d3 e8                	shr    %cl,%eax
  800d19:	89 f9                	mov    %edi,%ecx
  800d1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d1f:	89 eb                	mov    %ebp,%ebx
  800d21:	d3 e6                	shl    %cl,%esi
  800d23:	89 d1                	mov    %edx,%ecx
  800d25:	d3 eb                	shr    %cl,%ebx
  800d27:	09 f3                	or     %esi,%ebx
  800d29:	89 c6                	mov    %eax,%esi
  800d2b:	89 f2                	mov    %esi,%edx
  800d2d:	89 d8                	mov    %ebx,%eax
  800d2f:	f7 74 24 08          	divl   0x8(%esp)
  800d33:	89 d6                	mov    %edx,%esi
  800d35:	89 c3                	mov    %eax,%ebx
  800d37:	f7 64 24 0c          	mull   0xc(%esp)
  800d3b:	39 d6                	cmp    %edx,%esi
  800d3d:	72 19                	jb     800d58 <__udivdi3+0x108>
  800d3f:	89 f9                	mov    %edi,%ecx
  800d41:	d3 e5                	shl    %cl,%ebp
  800d43:	39 c5                	cmp    %eax,%ebp
  800d45:	73 04                	jae    800d4b <__udivdi3+0xfb>
  800d47:	39 d6                	cmp    %edx,%esi
  800d49:	74 0d                	je     800d58 <__udivdi3+0x108>
  800d4b:	89 d8                	mov    %ebx,%eax
  800d4d:	31 ff                	xor    %edi,%edi
  800d4f:	e9 3c ff ff ff       	jmp    800c90 <__udivdi3+0x40>
  800d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d5b:	31 ff                	xor    %edi,%edi
  800d5d:	e9 2e ff ff ff       	jmp    800c90 <__udivdi3+0x40>
  800d62:	66 90                	xchg   %ax,%ax
  800d64:	66 90                	xchg   %ax,%ax
  800d66:	66 90                	xchg   %ax,%ax
  800d68:	66 90                	xchg   %ax,%ax
  800d6a:	66 90                	xchg   %ax,%ax
  800d6c:	66 90                	xchg   %ax,%ax
  800d6e:	66 90                	xchg   %ax,%ax

00800d70 <__umoddi3>:
  800d70:	f3 0f 1e fb          	endbr32 
  800d74:	55                   	push   %ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 1c             	sub    $0x1c,%esp
  800d7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d83:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800d87:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800d8b:	89 f0                	mov    %esi,%eax
  800d8d:	89 da                	mov    %ebx,%edx
  800d8f:	85 ff                	test   %edi,%edi
  800d91:	75 15                	jne    800da8 <__umoddi3+0x38>
  800d93:	39 dd                	cmp    %ebx,%ebp
  800d95:	76 39                	jbe    800dd0 <__umoddi3+0x60>
  800d97:	f7 f5                	div    %ebp
  800d99:	89 d0                	mov    %edx,%eax
  800d9b:	31 d2                	xor    %edx,%edx
  800d9d:	83 c4 1c             	add    $0x1c,%esp
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    
  800da5:	8d 76 00             	lea    0x0(%esi),%esi
  800da8:	39 df                	cmp    %ebx,%edi
  800daa:	77 f1                	ja     800d9d <__umoddi3+0x2d>
  800dac:	0f bd cf             	bsr    %edi,%ecx
  800daf:	83 f1 1f             	xor    $0x1f,%ecx
  800db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800db6:	75 40                	jne    800df8 <__umoddi3+0x88>
  800db8:	39 df                	cmp    %ebx,%edi
  800dba:	72 04                	jb     800dc0 <__umoddi3+0x50>
  800dbc:	39 f5                	cmp    %esi,%ebp
  800dbe:	77 dd                	ja     800d9d <__umoddi3+0x2d>
  800dc0:	89 da                	mov    %ebx,%edx
  800dc2:	89 f0                	mov    %esi,%eax
  800dc4:	29 e8                	sub    %ebp,%eax
  800dc6:	19 fa                	sbb    %edi,%edx
  800dc8:	eb d3                	jmp    800d9d <__umoddi3+0x2d>
  800dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800dd0:	89 e9                	mov    %ebp,%ecx
  800dd2:	85 ed                	test   %ebp,%ebp
  800dd4:	75 0b                	jne    800de1 <__umoddi3+0x71>
  800dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ddb:	31 d2                	xor    %edx,%edx
  800ddd:	f7 f5                	div    %ebp
  800ddf:	89 c1                	mov    %eax,%ecx
  800de1:	89 d8                	mov    %ebx,%eax
  800de3:	31 d2                	xor    %edx,%edx
  800de5:	f7 f1                	div    %ecx
  800de7:	89 f0                	mov    %esi,%eax
  800de9:	f7 f1                	div    %ecx
  800deb:	89 d0                	mov    %edx,%eax
  800ded:	31 d2                	xor    %edx,%edx
  800def:	eb ac                	jmp    800d9d <__umoddi3+0x2d>
  800df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800df8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dfc:	ba 20 00 00 00       	mov    $0x20,%edx
  800e01:	29 c2                	sub    %eax,%edx
  800e03:	89 c1                	mov    %eax,%ecx
  800e05:	89 e8                	mov    %ebp,%eax
  800e07:	d3 e7                	shl    %cl,%edi
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e0f:	d3 e8                	shr    %cl,%eax
  800e11:	89 c1                	mov    %eax,%ecx
  800e13:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e17:	09 f9                	or     %edi,%ecx
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e1f:	89 c1                	mov    %eax,%ecx
  800e21:	d3 e5                	shl    %cl,%ebp
  800e23:	89 d1                	mov    %edx,%ecx
  800e25:	d3 ef                	shr    %cl,%edi
  800e27:	89 c1                	mov    %eax,%ecx
  800e29:	89 f0                	mov    %esi,%eax
  800e2b:	d3 e3                	shl    %cl,%ebx
  800e2d:	89 d1                	mov    %edx,%ecx
  800e2f:	89 fa                	mov    %edi,%edx
  800e31:	d3 e8                	shr    %cl,%eax
  800e33:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e38:	09 d8                	or     %ebx,%eax
  800e3a:	f7 74 24 08          	divl   0x8(%esp)
  800e3e:	89 d3                	mov    %edx,%ebx
  800e40:	d3 e6                	shl    %cl,%esi
  800e42:	f7 e5                	mul    %ebp
  800e44:	89 c7                	mov    %eax,%edi
  800e46:	89 d1                	mov    %edx,%ecx
  800e48:	39 d3                	cmp    %edx,%ebx
  800e4a:	72 06                	jb     800e52 <__umoddi3+0xe2>
  800e4c:	75 0e                	jne    800e5c <__umoddi3+0xec>
  800e4e:	39 c6                	cmp    %eax,%esi
  800e50:	73 0a                	jae    800e5c <__umoddi3+0xec>
  800e52:	29 e8                	sub    %ebp,%eax
  800e54:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800e58:	89 d1                	mov    %edx,%ecx
  800e5a:	89 c7                	mov    %eax,%edi
  800e5c:	89 f5                	mov    %esi,%ebp
  800e5e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e62:	29 fd                	sub    %edi,%ebp
  800e64:	19 cb                	sbb    %ecx,%ebx
  800e66:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e6b:	89 d8                	mov    %ebx,%eax
  800e6d:	d3 e0                	shl    %cl,%eax
  800e6f:	89 f1                	mov    %esi,%ecx
  800e71:	d3 ed                	shr    %cl,%ebp
  800e73:	d3 eb                	shr    %cl,%ebx
  800e75:	09 e8                	or     %ebp,%eax
  800e77:	89 da                	mov    %ebx,%edx
  800e79:	83 c4 1c             	add    $0x1c,%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
