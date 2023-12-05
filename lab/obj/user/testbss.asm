
obj/user/testbss:     file format elf32-i386


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
  80002c:	e8 cb 00 00 00       	call   8000fc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
  80003a:	e8 b9 00 00 00       	call   8000f8 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	int i;

	cprintf("Making sure bss works right...\n");
  800045:	8d 83 24 ef ff ff    	lea    -0x10dc(%ebx),%eax
  80004b:	50                   	push   %eax
  80004c:	e8 34 02 00 00       	call   800285 <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800054:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  800059:	83 bc 83 40 00 00 00 	cmpl   $0x0,0x40(%ebx,%eax,4)
  800060:	00 
  800061:	75 69                	jne    8000cc <umain+0x99>
	for (i = 0; i < ARRAYSIZE; i++)
  800063:	83 c0 01             	add    $0x1,%eax
  800066:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80006b:	75 ec                	jne    800059 <umain+0x26>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800072:	89 84 83 40 00 00 00 	mov    %eax,0x40(%ebx,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  800079:	83 c0 01             	add    $0x1,%eax
  80007c:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800081:	75 ef                	jne    800072 <umain+0x3f>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  800088:	39 84 83 40 00 00 00 	cmp    %eax,0x40(%ebx,%eax,4)
  80008f:	75 51                	jne    8000e2 <umain+0xaf>
	for (i = 0; i < ARRAYSIZE; i++)
  800091:	83 c0 01             	add    $0x1,%eax
  800094:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800099:	75 ed                	jne    800088 <umain+0x55>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	8d 83 6c ef ff ff    	lea    -0x1094(%ebx),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 db 01 00 00       	call   800285 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000aa:	c7 83 40 10 40 00 00 	movl   $0x0,0x401040(%ebx)
  8000b1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000b4:	83 c4 0c             	add    $0xc,%esp
  8000b7:	8d 83 cb ef ff ff    	lea    -0x1035(%ebx),%eax
  8000bd:	50                   	push   %eax
  8000be:	6a 1a                	push   $0x1a
  8000c0:	8d 83 bc ef ff ff    	lea    -0x1044(%ebx),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 ad 00 00 00       	call   800179 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000cc:	50                   	push   %eax
  8000cd:	8d 83 9f ef ff ff    	lea    -0x1061(%ebx),%eax
  8000d3:	50                   	push   %eax
  8000d4:	6a 11                	push   $0x11
  8000d6:	8d 83 bc ef ff ff    	lea    -0x1044(%ebx),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 97 00 00 00       	call   800179 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000e2:	50                   	push   %eax
  8000e3:	8d 83 44 ef ff ff    	lea    -0x10bc(%ebx),%eax
  8000e9:	50                   	push   %eax
  8000ea:	6a 16                	push   $0x16
  8000ec:	8d 83 bc ef ff ff    	lea    -0x1044(%ebx),%eax
  8000f2:	50                   	push   %eax
  8000f3:	e8 81 00 00 00       	call   800179 <_panic>

008000f8 <__x86.get_pc_thunk.bx>:
  8000f8:	8b 1c 24             	mov    (%esp),%ebx
  8000fb:	c3                   	ret    

008000fc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	57                   	push   %edi
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	e8 ee ff ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  80010a:	81 c3 f6 1e 00 00    	add    $0x1ef6,%ebx
  800110:	8b 75 08             	mov    0x8(%ebp),%esi
  800113:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800116:	e8 a8 0b 00 00       	call   800cc3 <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800123:	c1 e0 05             	shl    $0x5,%eax
  800126:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80012c:	89 83 40 00 40 00    	mov    %eax,0x400040(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	85 f6                	test   %esi,%esi
  800134:	7e 08                	jle    80013e <libmain+0x42>
		binaryname = argv[0];
  800136:	8b 07                	mov    (%edi),%eax
  800138:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	57                   	push   %edi
  800142:	56                   	push   %esi
  800143:	e8 eb fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800148:	e8 0b 00 00 00       	call   800158 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	53                   	push   %ebx
  80015c:	83 ec 10             	sub    $0x10,%esp
  80015f:	e8 94 ff ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  800164:	81 c3 9c 1e 00 00    	add    $0x1e9c,%ebx
	sys_env_destroy(0);
  80016a:	6a 00                	push   $0x0
  80016c:	e8 fd 0a 00 00       	call   800c6e <sys_env_destroy>
}
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800177:	c9                   	leave  
  800178:	c3                   	ret    

00800179 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	e8 71 ff ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  800187:	81 c3 79 1e 00 00    	add    $0x1e79,%ebx
	va_list ap;

	va_start(ap, fmt);
  80018d:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800190:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800196:	8b 38                	mov    (%eax),%edi
  800198:	e8 26 0b 00 00       	call   800cc3 <sys_getenvid>
  80019d:	83 ec 0c             	sub    $0xc,%esp
  8001a0:	ff 75 0c             	push   0xc(%ebp)
  8001a3:	ff 75 08             	push   0x8(%ebp)
  8001a6:	57                   	push   %edi
  8001a7:	50                   	push   %eax
  8001a8:	8d 83 ec ef ff ff    	lea    -0x1014(%ebx),%eax
  8001ae:	50                   	push   %eax
  8001af:	e8 d1 00 00 00       	call   800285 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b4:	83 c4 18             	add    $0x18,%esp
  8001b7:	56                   	push   %esi
  8001b8:	ff 75 10             	push   0x10(%ebp)
  8001bb:	e8 63 00 00 00       	call   800223 <vcprintf>
	cprintf("\n");
  8001c0:	8d 83 ba ef ff ff    	lea    -0x1046(%ebx),%eax
  8001c6:	89 04 24             	mov    %eax,(%esp)
  8001c9:	e8 b7 00 00 00       	call   800285 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d1:	cc                   	int3   
  8001d2:	eb fd                	jmp    8001d1 <_panic+0x58>

008001d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	e8 1a ff ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  8001de:	81 c3 22 1e 00 00    	add    $0x1e22,%ebx
  8001e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001e7:	8b 16                	mov    (%esi),%edx
  8001e9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ec:	89 06                	mov    %eax,(%esi)
  8001ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f1:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fa:	74 0b                	je     800207 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001fc:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800200:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	68 ff 00 00 00       	push   $0xff
  80020f:	8d 46 08             	lea    0x8(%esi),%eax
  800212:	50                   	push   %eax
  800213:	e8 19 0a 00 00       	call   800c31 <sys_cputs>
		b->idx = 0;
  800218:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb d9                	jmp    8001fc <putch+0x28>

00800223 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	53                   	push   %ebx
  800227:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80022d:	e8 c6 fe ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  800232:	81 c3 ce 1d 00 00    	add    $0x1dce,%ebx
	struct printbuf b;

	b.idx = 0;
  800238:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023f:	00 00 00 
	b.cnt = 0;
  800242:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800249:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024c:	ff 75 0c             	push   0xc(%ebp)
  80024f:	ff 75 08             	push   0x8(%ebp)
  800252:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	8d 83 d4 e1 ff ff    	lea    -0x1e2c(%ebx),%eax
  80025f:	50                   	push   %eax
  800260:	e8 2c 01 00 00       	call   800391 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800265:	83 c4 08             	add    $0x8,%esp
  800268:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80026e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	e8 b7 09 00 00       	call   800c31 <sys_cputs>

	return b.cnt;
}
  80027a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80028e:	50                   	push   %eax
  80028f:	ff 75 08             	push   0x8(%ebp)
  800292:	e8 8c ff ff ff       	call   800223 <vcprintf>
	va_end(ap);

	return cnt;
}
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 2c             	sub    $0x2c,%esp
  8002a2:	e8 0b 06 00 00       	call   8008b2 <__x86.get_pc_thunk.cx>
  8002a7:	81 c1 59 1d 00 00    	add    $0x1d59,%ecx
  8002ad:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002b0:	89 c7                	mov    %eax,%edi
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	89 d1                	mov    %edx,%ecx
  8002bc:	89 c2                	mov    %eax,%edx
  8002be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002d4:	39 c2                	cmp    %eax,%edx
  8002d6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d9:	72 41                	jb     80031c <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	ff 75 18             	push   0x18(%ebp)
  8002e1:	83 eb 01             	sub    $0x1,%ebx
  8002e4:	53                   	push   %ebx
  8002e5:	50                   	push   %eax
  8002e6:	83 ec 08             	sub    $0x8,%esp
  8002e9:	ff 75 e4             	push   -0x1c(%ebp)
  8002ec:	ff 75 e0             	push   -0x20(%ebp)
  8002ef:	ff 75 d4             	push   -0x2c(%ebp)
  8002f2:	ff 75 d0             	push   -0x30(%ebp)
  8002f5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f8:	e8 f3 09 00 00       	call   800cf0 <__udivdi3>
  8002fd:	83 c4 18             	add    $0x18,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	89 f2                	mov    %esi,%edx
  800304:	89 f8                	mov    %edi,%eax
  800306:	e8 8e ff ff ff       	call   800299 <printnum>
  80030b:	83 c4 20             	add    $0x20,%esp
  80030e:	eb 13                	jmp    800323 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	56                   	push   %esi
  800314:	ff 75 18             	push   0x18(%ebp)
  800317:	ff d7                	call   *%edi
  800319:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031c:	83 eb 01             	sub    $0x1,%ebx
  80031f:	85 db                	test   %ebx,%ebx
  800321:	7f ed                	jg     800310 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	56                   	push   %esi
  800327:	83 ec 04             	sub    $0x4,%esp
  80032a:	ff 75 e4             	push   -0x1c(%ebp)
  80032d:	ff 75 e0             	push   -0x20(%ebp)
  800330:	ff 75 d4             	push   -0x2c(%ebp)
  800333:	ff 75 d0             	push   -0x30(%ebp)
  800336:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800339:	e8 d2 0a 00 00       	call   800e10 <__umoddi3>
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	0f be 84 03 0f f0 ff 	movsbl -0xff1(%ebx,%eax,1),%eax
  800348:	ff 
  800349:	50                   	push   %eax
  80034a:	ff d7                	call   *%edi
}
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800352:	5b                   	pop    %ebx
  800353:	5e                   	pop    %esi
  800354:	5f                   	pop    %edi
  800355:	5d                   	pop    %ebp
  800356:	c3                   	ret    

00800357 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800361:	8b 10                	mov    (%eax),%edx
  800363:	3b 50 04             	cmp    0x4(%eax),%edx
  800366:	73 0a                	jae    800372 <sprintputch+0x1b>
		*b->buf++ = ch;
  800368:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036b:	89 08                	mov    %ecx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	88 02                	mov    %al,(%edx)
}
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <printfmt>:
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 10             	push   0x10(%ebp)
  800381:	ff 75 0c             	push   0xc(%ebp)
  800384:	ff 75 08             	push   0x8(%ebp)
  800387:	e8 05 00 00 00       	call   800391 <vprintfmt>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <vprintfmt>:
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 3c             	sub    $0x3c,%esp
  80039a:	e8 0f 05 00 00       	call   8008ae <__x86.get_pc_thunk.ax>
  80039f:	05 61 1c 00 00       	add    $0x1c61,%eax
  8003a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b0:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003b9:	eb 0a                	jmp    8003c5 <vprintfmt+0x34>
			putch(ch, putdat);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	57                   	push   %edi
  8003bf:	50                   	push   %eax
  8003c0:	ff d6                	call   *%esi
  8003c2:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c5:	83 c3 01             	add    $0x1,%ebx
  8003c8:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003cc:	83 f8 25             	cmp    $0x25,%eax
  8003cf:	74 0c                	je     8003dd <vprintfmt+0x4c>
			if (ch == '\0')
  8003d1:	85 c0                	test   %eax,%eax
  8003d3:	75 e6                	jne    8003bb <vprintfmt+0x2a>
}
  8003d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d8:	5b                   	pop    %ebx
  8003d9:	5e                   	pop    %esi
  8003da:	5f                   	pop    %edi
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    
		padc = ' ';
  8003dd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003e1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ef:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003fb:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003fe:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8d 43 01             	lea    0x1(%ebx),%eax
  800404:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800407:	0f b6 13             	movzbl (%ebx),%edx
  80040a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040d:	3c 55                	cmp    $0x55,%al
  80040f:	0f 87 fd 03 00 00    	ja     800812 <.L20>
  800415:	0f b6 c0             	movzbl %al,%eax
  800418:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041b:	89 ce                	mov    %ecx,%esi
  80041d:	03 b4 81 9c f0 ff ff 	add    -0xf64(%ecx,%eax,4),%esi
  800424:	ff e6                	jmp    *%esi

00800426 <.L68>:
  800426:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800429:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80042d:	eb d2                	jmp    800401 <vprintfmt+0x70>

0080042f <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800432:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800436:	eb c9                	jmp    800401 <vprintfmt+0x70>

00800438 <.L31>:
  800438:	0f b6 d2             	movzbl %dl,%edx
  80043b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80043e:	b8 00 00 00 00       	mov    $0x0,%eax
  800443:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800446:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800449:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80044d:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800450:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800453:	83 f9 09             	cmp    $0x9,%ecx
  800456:	77 58                	ja     8004b0 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800458:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80045b:	eb e9                	jmp    800446 <.L31+0xe>

0080045d <.L34>:
			precision = va_arg(ap, int);
  80045d:	8b 45 14             	mov    0x14(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8d 40 04             	lea    0x4(%eax),%eax
  80046b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800471:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800475:	79 8a                	jns    800401 <vprintfmt+0x70>
				width = precision, precision = -1;
  800477:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80047d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800484:	e9 78 ff ff ff       	jmp    800401 <vprintfmt+0x70>

00800489 <.L33>:
  800489:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80048c:	85 d2                	test   %edx,%edx
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	0f 49 c2             	cmovns %edx,%eax
  800496:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800499:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  80049c:	e9 60 ff ff ff       	jmp    800401 <vprintfmt+0x70>

008004a1 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004ab:	e9 51 ff ff ff       	jmp    800401 <vprintfmt+0x70>
  8004b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b6:	eb b9                	jmp    800471 <.L34+0x14>

008004b8 <.L27>:
			lflag++;
  8004b8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004bf:	e9 3d ff ff ff       	jmp    800401 <vprintfmt+0x70>

008004c4 <.L30>:
			putch(va_arg(ap, int), putdat);
  8004c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 58 04             	lea    0x4(%eax),%ebx
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	57                   	push   %edi
  8004d1:	ff 30                	push   (%eax)
  8004d3:	ff d6                	call   *%esi
			break;
  8004d5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d8:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004db:	e9 c8 02 00 00       	jmp    8007a8 <.L25+0x45>

008004e0 <.L28>:
			err = va_arg(ap, int);
  8004e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e9:	8b 10                	mov    (%eax),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	f7 d8                	neg    %eax
  8004ef:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f2:	83 f8 06             	cmp    $0x6,%eax
  8004f5:	7f 27                	jg     80051e <.L28+0x3e>
  8004f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004fa:	8b 14 82             	mov    (%edx,%eax,4),%edx
  8004fd:	85 d2                	test   %edx,%edx
  8004ff:	74 1d                	je     80051e <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  800501:	52                   	push   %edx
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	8d 80 30 f0 ff ff    	lea    -0xfd0(%eax),%eax
  80050b:	50                   	push   %eax
  80050c:	57                   	push   %edi
  80050d:	56                   	push   %esi
  80050e:	e8 61 fe ff ff       	call   800374 <printfmt>
  800513:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800516:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800519:	e9 8a 02 00 00       	jmp    8007a8 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80051e:	50                   	push   %eax
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	8d 80 27 f0 ff ff    	lea    -0xfd9(%eax),%eax
  800528:	50                   	push   %eax
  800529:	57                   	push   %edi
  80052a:	56                   	push   %esi
  80052b:	e8 44 fe ff ff       	call   800374 <printfmt>
  800530:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800533:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800536:	e9 6d 02 00 00       	jmp    8007a8 <.L25+0x45>

0080053b <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	83 c0 04             	add    $0x4,%eax
  800544:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80054c:	85 d2                	test   %edx,%edx
  80054e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800551:	8d 80 20 f0 ff ff    	lea    -0xfe0(%eax),%eax
  800557:	0f 45 c2             	cmovne %edx,%eax
  80055a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80055d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800561:	7e 06                	jle    800569 <.L24+0x2e>
  800563:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800567:	75 0d                	jne    800576 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056c:	89 c3                	mov    %eax,%ebx
  80056e:	03 45 d4             	add    -0x2c(%ebp),%eax
  800571:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800574:	eb 58                	jmp    8005ce <.L24+0x93>
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 d8             	push   -0x28(%ebp)
  80057c:	ff 75 c8             	push   -0x38(%ebp)
  80057f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800582:	e8 47 03 00 00       	call   8008ce <strnlen>
  800587:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80058a:	29 c2                	sub    %eax,%edx
  80058c:	89 55 bc             	mov    %edx,-0x44(%ebp)
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  800594:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80059b:	eb 0f                	jmp    8005ac <.L24+0x71>
					putch(padc, putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	57                   	push   %edi
  8005a1:	ff 75 d4             	push   -0x2c(%ebp)
  8005a4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a6:	83 eb 01             	sub    $0x1,%ebx
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	85 db                	test   %ebx,%ebx
  8005ae:	7f ed                	jg     80059d <.L24+0x62>
  8005b0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005b3:	85 d2                	test   %edx,%edx
  8005b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ba:	0f 49 c2             	cmovns %edx,%eax
  8005bd:	29 c2                	sub    %eax,%edx
  8005bf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c2:	eb a5                	jmp    800569 <.L24+0x2e>
					putch(ch, putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	57                   	push   %edi
  8005c8:	52                   	push   %edx
  8005c9:	ff d6                	call   *%esi
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005d1:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d3:	83 c3 01             	add    $0x1,%ebx
  8005d6:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005da:	0f be d0             	movsbl %al,%edx
  8005dd:	85 d2                	test   %edx,%edx
  8005df:	74 4b                	je     80062c <.L24+0xf1>
  8005e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e5:	78 06                	js     8005ed <.L24+0xb2>
  8005e7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005eb:	78 1e                	js     80060b <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005f1:	74 d1                	je     8005c4 <.L24+0x89>
  8005f3:	0f be c0             	movsbl %al,%eax
  8005f6:	83 e8 20             	sub    $0x20,%eax
  8005f9:	83 f8 5e             	cmp    $0x5e,%eax
  8005fc:	76 c6                	jbe    8005c4 <.L24+0x89>
					putch('?', putdat);
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	57                   	push   %edi
  800602:	6a 3f                	push   $0x3f
  800604:	ff d6                	call   *%esi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	eb c3                	jmp    8005ce <.L24+0x93>
  80060b:	89 cb                	mov    %ecx,%ebx
  80060d:	eb 0e                	jmp    80061d <.L24+0xe2>
				putch(' ', putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	57                   	push   %edi
  800613:	6a 20                	push   $0x20
  800615:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800617:	83 eb 01             	sub    $0x1,%ebx
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	85 db                	test   %ebx,%ebx
  80061f:	7f ee                	jg     80060f <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800621:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
  800627:	e9 7c 01 00 00       	jmp    8007a8 <.L25+0x45>
  80062c:	89 cb                	mov    %ecx,%ebx
  80062e:	eb ed                	jmp    80061d <.L24+0xe2>

00800630 <.L29>:
	if (lflag >= 2)
  800630:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800633:	8b 75 08             	mov    0x8(%ebp),%esi
  800636:	83 f9 01             	cmp    $0x1,%ecx
  800639:	7f 1b                	jg     800656 <.L29+0x26>
	else if (lflag)
  80063b:	85 c9                	test   %ecx,%ecx
  80063d:	74 63                	je     8006a2 <.L29+0x72>
		return va_arg(*ap, long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	99                   	cltd   
  800648:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
  800654:	eb 17                	jmp    80066d <.L29+0x3d>
		return va_arg(*ap, long long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 50 04             	mov    0x4(%eax),%edx
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 08             	lea    0x8(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80066d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800670:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800673:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  800678:	85 db                	test   %ebx,%ebx
  80067a:	0f 89 0e 01 00 00    	jns    80078e <.L25+0x2b>
				putch('-', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	57                   	push   %edi
  800684:	6a 2d                	push   $0x2d
  800686:	ff d6                	call   *%esi
				num = -(long long) num;
  800688:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80068b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80068e:	f7 d9                	neg    %ecx
  800690:	83 d3 00             	adc    $0x0,%ebx
  800693:	f7 db                	neg    %ebx
  800695:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800698:	ba 0a 00 00 00       	mov    $0xa,%edx
  80069d:	e9 ec 00 00 00       	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, int);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	99                   	cltd   
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	eb b4                	jmp    80066d <.L29+0x3d>

008006b9 <.L23>:
	if (lflag >= 2)
  8006b9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006bf:	83 f9 01             	cmp    $0x1,%ecx
  8006c2:	7f 1e                	jg     8006e2 <.L23+0x29>
	else if (lflag)
  8006c4:	85 c9                	test   %ecx,%ecx
  8006c6:	74 32                	je     8006fa <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 08                	mov    (%eax),%ecx
  8006cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d2:	8d 40 04             	lea    0x4(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d8:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006dd:	e9 ac 00 00 00       	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 08                	mov    (%eax),%ecx
  8006e7:	8b 58 04             	mov    0x4(%eax),%ebx
  8006ea:	8d 40 08             	lea    0x8(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f0:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  8006f5:	e9 94 00 00 00       	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 08                	mov    (%eax),%ecx
  8006ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070a:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  80070f:	eb 7d                	jmp    80078e <.L25+0x2b>

00800711 <.L26>:
	if (lflag >= 2)
  800711:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800714:	8b 75 08             	mov    0x8(%ebp),%esi
  800717:	83 f9 01             	cmp    $0x1,%ecx
  80071a:	7f 1b                	jg     800737 <.L26+0x26>
	else if (lflag)
  80071c:	85 c9                	test   %ecx,%ecx
  80071e:	74 2c                	je     80074c <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 08                	mov    (%eax),%ecx
  800725:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800730:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800735:	eb 57                	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 08                	mov    (%eax),%ecx
  80073c:	8b 58 04             	mov    0x4(%eax),%ebx
  80073f:	8d 40 08             	lea    0x8(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800745:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  80074a:	eb 42                	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 08                	mov    (%eax),%ecx
  800751:	bb 00 00 00 00       	mov    $0x0,%ebx
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075c:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800761:	eb 2b                	jmp    80078e <.L25+0x2b>

00800763 <.L25>:
			putch('0', putdat);
  800763:	8b 75 08             	mov    0x8(%ebp),%esi
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	57                   	push   %edi
  80076a:	6a 30                	push   $0x30
  80076c:	ff d6                	call   *%esi
			putch('x', putdat);
  80076e:	83 c4 08             	add    $0x8,%esp
  800771:	57                   	push   %edi
  800772:	6a 78                	push   $0x78
  800774:	ff d6                	call   *%esi
			num = (unsigned long long)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 08                	mov    (%eax),%ecx
  80077b:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800780:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800789:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80078e:	83 ec 0c             	sub    $0xc,%esp
  800791:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	ff 75 d4             	push   -0x2c(%ebp)
  800799:	52                   	push   %edx
  80079a:	53                   	push   %ebx
  80079b:	51                   	push   %ecx
  80079c:	89 fa                	mov    %edi,%edx
  80079e:	89 f0                	mov    %esi,%eax
  8007a0:	e8 f4 fa ff ff       	call   800299 <printnum>
			break;
  8007a5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	e9 15 fc ff ff       	jmp    8003c5 <vprintfmt+0x34>

008007b0 <.L21>:
	if (lflag >= 2)
  8007b0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b6:	83 f9 01             	cmp    $0x1,%ecx
  8007b9:	7f 1b                	jg     8007d6 <.L21+0x26>
	else if (lflag)
  8007bb:	85 c9                	test   %ecx,%ecx
  8007bd:	74 2c                	je     8007eb <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 08                	mov    (%eax),%ecx
  8007c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c9:	8d 40 04             	lea    0x4(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cf:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007d4:	eb b8                	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 08                	mov    (%eax),%ecx
  8007db:	8b 58 04             	mov    0x4(%eax),%ebx
  8007de:	8d 40 08             	lea    0x8(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007e9:	eb a3                	jmp    80078e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 08                	mov    (%eax),%ecx
  8007f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fb:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  800800:	eb 8c                	jmp    80078e <.L25+0x2b>

00800802 <.L35>:
			putch(ch, putdat);
  800802:	8b 75 08             	mov    0x8(%ebp),%esi
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	57                   	push   %edi
  800809:	6a 25                	push   $0x25
  80080b:	ff d6                	call   *%esi
			break;
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	eb 96                	jmp    8007a8 <.L25+0x45>

00800812 <.L20>:
			putch('%', putdat);
  800812:	8b 75 08             	mov    0x8(%ebp),%esi
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	57                   	push   %edi
  800819:	6a 25                	push   $0x25
  80081b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	89 d8                	mov    %ebx,%eax
  800822:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800826:	74 05                	je     80082d <.L20+0x1b>
  800828:	83 e8 01             	sub    $0x1,%eax
  80082b:	eb f5                	jmp    800822 <.L20+0x10>
  80082d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800830:	e9 73 ff ff ff       	jmp    8007a8 <.L25+0x45>

00800835 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	53                   	push   %ebx
  800839:	83 ec 14             	sub    $0x14,%esp
  80083c:	e8 b7 f8 ff ff       	call   8000f8 <__x86.get_pc_thunk.bx>
  800841:	81 c3 bf 17 00 00    	add    $0x17bf,%ebx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800850:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800854:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085e:	85 c0                	test   %eax,%eax
  800860:	74 2b                	je     80088d <vsnprintf+0x58>
  800862:	85 d2                	test   %edx,%edx
  800864:	7e 27                	jle    80088d <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800866:	ff 75 14             	push   0x14(%ebp)
  800869:	ff 75 10             	push   0x10(%ebp)
  80086c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	8d 83 57 e3 ff ff    	lea    -0x1ca9(%ebx),%eax
  800876:	50                   	push   %eax
  800877:	e8 15 fb ff ff       	call   800391 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800885:	83 c4 10             	add    $0x10,%esp
}
  800888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb f4                	jmp    800888 <vsnprintf+0x53>

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089d:	50                   	push   %eax
  80089e:	ff 75 10             	push   0x10(%ebp)
  8008a1:	ff 75 0c             	push   0xc(%ebp)
  8008a4:	ff 75 08             	push   0x8(%ebp)
  8008a7:	e8 89 ff ff ff       	call   800835 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <__x86.get_pc_thunk.ax>:
  8008ae:	8b 04 24             	mov    (%esp),%eax
  8008b1:	c3                   	ret    

008008b2 <__x86.get_pc_thunk.cx>:
  8008b2:	8b 0c 24             	mov    (%esp),%ecx
  8008b5:	c3                   	ret    

008008b6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	eb 03                	jmp    8008c6 <strlen+0x10>
		n++;
  8008c3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008c6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ca:	75 f7                	jne    8008c3 <strlen+0xd>
	return n;
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	eb 03                	jmp    8008e1 <strnlen+0x13>
		n++;
  8008de:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	39 d0                	cmp    %edx,%eax
  8008e3:	74 08                	je     8008ed <strnlen+0x1f>
  8008e5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e9:	75 f3                	jne    8008de <strnlen+0x10>
  8008eb:	89 c2                	mov    %eax,%edx
	return n;
}
  8008ed:	89 d0                	mov    %edx,%eax
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800900:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800904:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800907:	83 c0 01             	add    $0x1,%eax
  80090a:	84 d2                	test   %dl,%dl
  80090c:	75 f2                	jne    800900 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80090e:	89 c8                	mov    %ecx,%eax
  800910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	83 ec 10             	sub    $0x10,%esp
  80091c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80091f:	53                   	push   %ebx
  800920:	e8 91 ff ff ff       	call   8008b6 <strlen>
  800925:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800928:	ff 75 0c             	push   0xc(%ebp)
  80092b:	01 d8                	add    %ebx,%eax
  80092d:	50                   	push   %eax
  80092e:	e8 be ff ff ff       	call   8008f1 <strcpy>
	return dst;
}
  800933:	89 d8                	mov    %ebx,%eax
  800935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
  80093f:	8b 75 08             	mov    0x8(%ebp),%esi
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	89 f3                	mov    %esi,%ebx
  800947:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094a:	89 f0                	mov    %esi,%eax
  80094c:	eb 0f                	jmp    80095d <strncpy+0x23>
		*dst++ = *src;
  80094e:	83 c0 01             	add    $0x1,%eax
  800951:	0f b6 0a             	movzbl (%edx),%ecx
  800954:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800957:	80 f9 01             	cmp    $0x1,%cl
  80095a:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80095d:	39 d8                	cmp    %ebx,%eax
  80095f:	75 ed                	jne    80094e <strncpy+0x14>
	}
	return ret;
}
  800961:	89 f0                	mov    %esi,%eax
  800963:	5b                   	pop    %ebx
  800964:	5e                   	pop    %esi
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	56                   	push   %esi
  80096b:	53                   	push   %ebx
  80096c:	8b 75 08             	mov    0x8(%ebp),%esi
  80096f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800972:	8b 55 10             	mov    0x10(%ebp),%edx
  800975:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800977:	85 d2                	test   %edx,%edx
  800979:	74 21                	je     80099c <strlcpy+0x35>
  80097b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097f:	89 f2                	mov    %esi,%edx
  800981:	eb 09                	jmp    80098c <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800983:	83 c1 01             	add    $0x1,%ecx
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80098c:	39 c2                	cmp    %eax,%edx
  80098e:	74 09                	je     800999 <strlcpy+0x32>
  800990:	0f b6 19             	movzbl (%ecx),%ebx
  800993:	84 db                	test   %bl,%bl
  800995:	75 ec                	jne    800983 <strlcpy+0x1c>
  800997:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800999:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099c:	29 f0                	sub    %esi,%eax
}
  80099e:	5b                   	pop    %ebx
  80099f:	5e                   	pop    %esi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ab:	eb 06                	jmp    8009b3 <strcmp+0x11>
		p++, q++;
  8009ad:	83 c1 01             	add    $0x1,%ecx
  8009b0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009b3:	0f b6 01             	movzbl (%ecx),%eax
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 04                	je     8009be <strcmp+0x1c>
  8009ba:	3a 02                	cmp    (%edx),%al
  8009bc:	74 ef                	je     8009ad <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009be:	0f b6 c0             	movzbl %al,%eax
  8009c1:	0f b6 12             	movzbl (%edx),%edx
  8009c4:	29 d0                	sub    %edx,%eax
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	89 c3                	mov    %eax,%ebx
  8009d4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d7:	eb 06                	jmp    8009df <strncmp+0x17>
		n--, p++, q++;
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009df:	39 d8                	cmp    %ebx,%eax
  8009e1:	74 18                	je     8009fb <strncmp+0x33>
  8009e3:	0f b6 08             	movzbl (%eax),%ecx
  8009e6:	84 c9                	test   %cl,%cl
  8009e8:	74 04                	je     8009ee <strncmp+0x26>
  8009ea:	3a 0a                	cmp    (%edx),%cl
  8009ec:	74 eb                	je     8009d9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ee:	0f b6 00             	movzbl (%eax),%eax
  8009f1:	0f b6 12             	movzbl (%edx),%edx
  8009f4:	29 d0                	sub    %edx,%eax
}
  8009f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    
		return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800a00:	eb f4                	jmp    8009f6 <strncmp+0x2e>

00800a02 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0c:	eb 03                	jmp    800a11 <strchr+0xf>
  800a0e:	83 c0 01             	add    $0x1,%eax
  800a11:	0f b6 10             	movzbl (%eax),%edx
  800a14:	84 d2                	test   %dl,%dl
  800a16:	74 06                	je     800a1e <strchr+0x1c>
		if (*s == c)
  800a18:	38 ca                	cmp    %cl,%dl
  800a1a:	75 f2                	jne    800a0e <strchr+0xc>
  800a1c:	eb 05                	jmp    800a23 <strchr+0x21>
			return (char *) s;
	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a32:	38 ca                	cmp    %cl,%dl
  800a34:	74 09                	je     800a3f <strfind+0x1a>
  800a36:	84 d2                	test   %dl,%dl
  800a38:	74 05                	je     800a3f <strfind+0x1a>
	for (; *s; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	eb f0                	jmp    800a2f <strfind+0xa>
			break;
	return (char *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4d:	85 c9                	test   %ecx,%ecx
  800a4f:	74 2f                	je     800a80 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a51:	89 f8                	mov    %edi,%eax
  800a53:	09 c8                	or     %ecx,%eax
  800a55:	a8 03                	test   $0x3,%al
  800a57:	75 21                	jne    800a7a <memset+0x39>
		c &= 0xFF;
  800a59:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5d:	89 d0                	mov    %edx,%eax
  800a5f:	c1 e0 08             	shl    $0x8,%eax
  800a62:	89 d3                	mov    %edx,%ebx
  800a64:	c1 e3 18             	shl    $0x18,%ebx
  800a67:	89 d6                	mov    %edx,%esi
  800a69:	c1 e6 10             	shl    $0x10,%esi
  800a6c:	09 f3                	or     %esi,%ebx
  800a6e:	09 da                	or     %ebx,%edx
  800a70:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a72:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a75:	fc                   	cld    
  800a76:	f3 ab                	rep stos %eax,%es:(%edi)
  800a78:	eb 06                	jmp    800a80 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	fc                   	cld    
  800a7e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a80:	89 f8                	mov    %edi,%eax
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a95:	39 c6                	cmp    %eax,%esi
  800a97:	73 32                	jae    800acb <memmove+0x44>
  800a99:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	76 2b                	jbe    800acb <memmove+0x44>
		s += n;
		d += n;
  800aa0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 d6                	mov    %edx,%esi
  800aa5:	09 fe                	or     %edi,%esi
  800aa7:	09 ce                	or     %ecx,%esi
  800aa9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaf:	75 0e                	jne    800abf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1a                	jmp    800ae5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
  800acf:	09 ca                	or     %ecx,%edx
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0a                	jne    800ae0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb 05                	jmp    800ae5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae5:	5e                   	pop    %esi
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aef:	ff 75 10             	push   0x10(%ebp)
  800af2:	ff 75 0c             	push   0xc(%ebp)
  800af5:	ff 75 08             	push   0x8(%ebp)
  800af8:	e8 8a ff ff ff       	call   800a87 <memmove>
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c6                	mov    %eax,%esi
  800b0c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0f:	eb 06                	jmp    800b17 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b11:	83 c0 01             	add    $0x1,%eax
  800b14:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b17:	39 f0                	cmp    %esi,%eax
  800b19:	74 14                	je     800b2f <memcmp+0x30>
		if (*s1 != *s2)
  800b1b:	0f b6 08             	movzbl (%eax),%ecx
  800b1e:	0f b6 1a             	movzbl (%edx),%ebx
  800b21:	38 d9                	cmp    %bl,%cl
  800b23:	74 ec                	je     800b11 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b25:	0f b6 c1             	movzbl %cl,%eax
  800b28:	0f b6 db             	movzbl %bl,%ebx
  800b2b:	29 d8                	sub    %ebx,%eax
  800b2d:	eb 05                	jmp    800b34 <memcmp+0x35>
	}

	return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b46:	eb 03                	jmp    800b4b <memfind+0x13>
  800b48:	83 c0 01             	add    $0x1,%eax
  800b4b:	39 d0                	cmp    %edx,%eax
  800b4d:	73 04                	jae    800b53 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4f:	38 08                	cmp    %cl,(%eax)
  800b51:	75 f5                	jne    800b48 <memfind+0x10>
			break;
	return (void *) s;
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b61:	eb 03                	jmp    800b66 <strtol+0x11>
		s++;
  800b63:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b66:	0f b6 02             	movzbl (%edx),%eax
  800b69:	3c 20                	cmp    $0x20,%al
  800b6b:	74 f6                	je     800b63 <strtol+0xe>
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	74 f2                	je     800b63 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b71:	3c 2b                	cmp    $0x2b,%al
  800b73:	74 2a                	je     800b9f <strtol+0x4a>
	int neg = 0;
  800b75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7a:	3c 2d                	cmp    $0x2d,%al
  800b7c:	74 2b                	je     800ba9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b84:	75 0f                	jne    800b95 <strtol+0x40>
  800b86:	80 3a 30             	cmpb   $0x30,(%edx)
  800b89:	74 28                	je     800bb3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b92:	0f 44 d8             	cmove  %eax,%ebx
  800b95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9d:	eb 46                	jmp    800be5 <strtol+0x90>
		s++;
  800b9f:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba7:	eb d5                	jmp    800b7e <strtol+0x29>
		s++, neg = 1;
  800ba9:	83 c2 01             	add    $0x1,%edx
  800bac:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb1:	eb cb                	jmp    800b7e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb7:	74 0e                	je     800bc7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	75 d8                	jne    800b95 <strtol+0x40>
		s++, base = 8;
  800bbd:	83 c2 01             	add    $0x1,%edx
  800bc0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc5:	eb ce                	jmp    800b95 <strtol+0x40>
		s += 2, base = 16;
  800bc7:	83 c2 02             	add    $0x2,%edx
  800bca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcf:	eb c4                	jmp    800b95 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bd1:	0f be c0             	movsbl %al,%eax
  800bd4:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bda:	7d 3a                	jge    800c16 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bdc:	83 c2 01             	add    $0x1,%edx
  800bdf:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800be3:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800be5:	0f b6 02             	movzbl (%edx),%eax
  800be8:	8d 70 d0             	lea    -0x30(%eax),%esi
  800beb:	89 f3                	mov    %esi,%ebx
  800bed:	80 fb 09             	cmp    $0x9,%bl
  800bf0:	76 df                	jbe    800bd1 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800bf2:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 19             	cmp    $0x19,%bl
  800bfa:	77 08                	ja     800c04 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bfc:	0f be c0             	movsbl %al,%eax
  800bff:	83 e8 57             	sub    $0x57,%eax
  800c02:	eb d3                	jmp    800bd7 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c04:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 08                	ja     800c16 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0e:	0f be c0             	movsbl %al,%eax
  800c11:	83 e8 37             	sub    $0x37,%eax
  800c14:	eb c1                	jmp    800bd7 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	74 05                	je     800c21 <strtol+0xcc>
		*endptr = (char *) s;
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c21:	89 c8                	mov    %ecx,%eax
  800c23:	f7 d8                	neg    %eax
  800c25:	85 ff                	test   %edi,%edi
  800c27:	0f 45 c8             	cmovne %eax,%ecx
}
  800c2a:	89 c8                	mov    %ecx,%eax
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5f                   	pop    %edi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	89 c3                	mov    %eax,%ebx
  800c44:	89 c7                	mov    %eax,%edi
  800c46:	89 c6                	mov    %eax,%esi
  800c48:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 1c             	sub    $0x1c,%esp
  800c77:	e8 32 fc ff ff       	call   8008ae <__x86.get_pc_thunk.ax>
  800c7c:	05 84 13 00 00       	add    $0x1384,%eax
  800c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800c84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c91:	89 cb                	mov    %ecx,%ebx
  800c93:	89 cf                	mov    %ecx,%edi
  800c95:	89 ce                	mov    %ecx,%esi
  800c97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	7f 08                	jg     800ca5 <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	50                   	push   %eax
  800ca9:	6a 03                	push   $0x3
  800cab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800cae:	8d 83 f4 f1 ff ff    	lea    -0xe0c(%ebx),%eax
  800cb4:	50                   	push   %eax
  800cb5:	6a 23                	push   $0x23
  800cb7:	8d 83 11 f2 ff ff    	lea    -0xdef(%ebx),%eax
  800cbd:	50                   	push   %eax
  800cbe:	e8 b6 f4 ff ff       	call   800179 <_panic>

00800cc3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd3:	89 d1                	mov    %edx,%ecx
  800cd5:	89 d3                	mov    %edx,%ebx
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    
  800ce2:	66 90                	xchg   %ax,%ax
  800ce4:	66 90                	xchg   %ax,%ax
  800ce6:	66 90                	xchg   %ax,%ax
  800ce8:	66 90                	xchg   %ax,%ax
  800cea:	66 90                	xchg   %ax,%ax
  800cec:	66 90                	xchg   %ax,%ax
  800cee:	66 90                	xchg   %ax,%ax

00800cf0 <__udivdi3>:
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 1c             	sub    $0x1c,%esp
  800cfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800cff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d03:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	75 19                	jne    800d28 <__udivdi3+0x38>
  800d0f:	39 f3                	cmp    %esi,%ebx
  800d11:	76 4d                	jbe    800d60 <__udivdi3+0x70>
  800d13:	31 ff                	xor    %edi,%edi
  800d15:	89 e8                	mov    %ebp,%eax
  800d17:	89 f2                	mov    %esi,%edx
  800d19:	f7 f3                	div    %ebx
  800d1b:	89 fa                	mov    %edi,%edx
  800d1d:	83 c4 1c             	add    $0x1c,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
  800d25:	8d 76 00             	lea    0x0(%esi),%esi
  800d28:	39 f0                	cmp    %esi,%eax
  800d2a:	76 14                	jbe    800d40 <__udivdi3+0x50>
  800d2c:	31 ff                	xor    %edi,%edi
  800d2e:	31 c0                	xor    %eax,%eax
  800d30:	89 fa                	mov    %edi,%edx
  800d32:	83 c4 1c             	add    $0x1c,%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
  800d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d40:	0f bd f8             	bsr    %eax,%edi
  800d43:	83 f7 1f             	xor    $0x1f,%edi
  800d46:	75 48                	jne    800d90 <__udivdi3+0xa0>
  800d48:	39 f0                	cmp    %esi,%eax
  800d4a:	72 06                	jb     800d52 <__udivdi3+0x62>
  800d4c:	31 c0                	xor    %eax,%eax
  800d4e:	39 eb                	cmp    %ebp,%ebx
  800d50:	77 de                	ja     800d30 <__udivdi3+0x40>
  800d52:	b8 01 00 00 00       	mov    $0x1,%eax
  800d57:	eb d7                	jmp    800d30 <__udivdi3+0x40>
  800d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d60:	89 d9                	mov    %ebx,%ecx
  800d62:	85 db                	test   %ebx,%ebx
  800d64:	75 0b                	jne    800d71 <__udivdi3+0x81>
  800d66:	b8 01 00 00 00       	mov    $0x1,%eax
  800d6b:	31 d2                	xor    %edx,%edx
  800d6d:	f7 f3                	div    %ebx
  800d6f:	89 c1                	mov    %eax,%ecx
  800d71:	31 d2                	xor    %edx,%edx
  800d73:	89 f0                	mov    %esi,%eax
  800d75:	f7 f1                	div    %ecx
  800d77:	89 c6                	mov    %eax,%esi
  800d79:	89 e8                	mov    %ebp,%eax
  800d7b:	89 f7                	mov    %esi,%edi
  800d7d:	f7 f1                	div    %ecx
  800d7f:	89 fa                	mov    %edi,%edx
  800d81:	83 c4 1c             	add    $0x1c,%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
  800d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d90:	89 f9                	mov    %edi,%ecx
  800d92:	ba 20 00 00 00       	mov    $0x20,%edx
  800d97:	29 fa                	sub    %edi,%edx
  800d99:	d3 e0                	shl    %cl,%eax
  800d9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d9f:	89 d1                	mov    %edx,%ecx
  800da1:	89 d8                	mov    %ebx,%eax
  800da3:	d3 e8                	shr    %cl,%eax
  800da5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800da9:	09 c1                	or     %eax,%ecx
  800dab:	89 f0                	mov    %esi,%eax
  800dad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800db1:	89 f9                	mov    %edi,%ecx
  800db3:	d3 e3                	shl    %cl,%ebx
  800db5:	89 d1                	mov    %edx,%ecx
  800db7:	d3 e8                	shr    %cl,%eax
  800db9:	89 f9                	mov    %edi,%ecx
  800dbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800dbf:	89 eb                	mov    %ebp,%ebx
  800dc1:	d3 e6                	shl    %cl,%esi
  800dc3:	89 d1                	mov    %edx,%ecx
  800dc5:	d3 eb                	shr    %cl,%ebx
  800dc7:	09 f3                	or     %esi,%ebx
  800dc9:	89 c6                	mov    %eax,%esi
  800dcb:	89 f2                	mov    %esi,%edx
  800dcd:	89 d8                	mov    %ebx,%eax
  800dcf:	f7 74 24 08          	divl   0x8(%esp)
  800dd3:	89 d6                	mov    %edx,%esi
  800dd5:	89 c3                	mov    %eax,%ebx
  800dd7:	f7 64 24 0c          	mull   0xc(%esp)
  800ddb:	39 d6                	cmp    %edx,%esi
  800ddd:	72 19                	jb     800df8 <__udivdi3+0x108>
  800ddf:	89 f9                	mov    %edi,%ecx
  800de1:	d3 e5                	shl    %cl,%ebp
  800de3:	39 c5                	cmp    %eax,%ebp
  800de5:	73 04                	jae    800deb <__udivdi3+0xfb>
  800de7:	39 d6                	cmp    %edx,%esi
  800de9:	74 0d                	je     800df8 <__udivdi3+0x108>
  800deb:	89 d8                	mov    %ebx,%eax
  800ded:	31 ff                	xor    %edi,%edi
  800def:	e9 3c ff ff ff       	jmp    800d30 <__udivdi3+0x40>
  800df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800df8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800dfb:	31 ff                	xor    %edi,%edi
  800dfd:	e9 2e ff ff ff       	jmp    800d30 <__udivdi3+0x40>
  800e02:	66 90                	xchg   %ax,%ax
  800e04:	66 90                	xchg   %ax,%ax
  800e06:	66 90                	xchg   %ax,%ax
  800e08:	66 90                	xchg   %ax,%ax
  800e0a:	66 90                	xchg   %ax,%ax
  800e0c:	66 90                	xchg   %ax,%ax
  800e0e:	66 90                	xchg   %ax,%ax

00800e10 <__umoddi3>:
  800e10:	f3 0f 1e fb          	endbr32 
  800e14:	55                   	push   %ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 1c             	sub    $0x1c,%esp
  800e1b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800e1f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800e23:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800e27:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800e2b:	89 f0                	mov    %esi,%eax
  800e2d:	89 da                	mov    %ebx,%edx
  800e2f:	85 ff                	test   %edi,%edi
  800e31:	75 15                	jne    800e48 <__umoddi3+0x38>
  800e33:	39 dd                	cmp    %ebx,%ebp
  800e35:	76 39                	jbe    800e70 <__umoddi3+0x60>
  800e37:	f7 f5                	div    %ebp
  800e39:	89 d0                	mov    %edx,%eax
  800e3b:	31 d2                	xor    %edx,%edx
  800e3d:	83 c4 1c             	add    $0x1c,%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
  800e45:	8d 76 00             	lea    0x0(%esi),%esi
  800e48:	39 df                	cmp    %ebx,%edi
  800e4a:	77 f1                	ja     800e3d <__umoddi3+0x2d>
  800e4c:	0f bd cf             	bsr    %edi,%ecx
  800e4f:	83 f1 1f             	xor    $0x1f,%ecx
  800e52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e56:	75 40                	jne    800e98 <__umoddi3+0x88>
  800e58:	39 df                	cmp    %ebx,%edi
  800e5a:	72 04                	jb     800e60 <__umoddi3+0x50>
  800e5c:	39 f5                	cmp    %esi,%ebp
  800e5e:	77 dd                	ja     800e3d <__umoddi3+0x2d>
  800e60:	89 da                	mov    %ebx,%edx
  800e62:	89 f0                	mov    %esi,%eax
  800e64:	29 e8                	sub    %ebp,%eax
  800e66:	19 fa                	sbb    %edi,%edx
  800e68:	eb d3                	jmp    800e3d <__umoddi3+0x2d>
  800e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e70:	89 e9                	mov    %ebp,%ecx
  800e72:	85 ed                	test   %ebp,%ebp
  800e74:	75 0b                	jne    800e81 <__umoddi3+0x71>
  800e76:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7b:	31 d2                	xor    %edx,%edx
  800e7d:	f7 f5                	div    %ebp
  800e7f:	89 c1                	mov    %eax,%ecx
  800e81:	89 d8                	mov    %ebx,%eax
  800e83:	31 d2                	xor    %edx,%edx
  800e85:	f7 f1                	div    %ecx
  800e87:	89 f0                	mov    %esi,%eax
  800e89:	f7 f1                	div    %ecx
  800e8b:	89 d0                	mov    %edx,%eax
  800e8d:	31 d2                	xor    %edx,%edx
  800e8f:	eb ac                	jmp    800e3d <__umoddi3+0x2d>
  800e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e98:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e9c:	ba 20 00 00 00       	mov    $0x20,%edx
  800ea1:	29 c2                	sub    %eax,%edx
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	89 e8                	mov    %ebp,%eax
  800ea7:	d3 e7                	shl    %cl,%edi
  800ea9:	89 d1                	mov    %edx,%ecx
  800eab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800eaf:	d3 e8                	shr    %cl,%eax
  800eb1:	89 c1                	mov    %eax,%ecx
  800eb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800eb7:	09 f9                	or     %edi,%ecx
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	d3 e5                	shl    %cl,%ebp
  800ec3:	89 d1                	mov    %edx,%ecx
  800ec5:	d3 ef                	shr    %cl,%edi
  800ec7:	89 c1                	mov    %eax,%ecx
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	d3 e3                	shl    %cl,%ebx
  800ecd:	89 d1                	mov    %edx,%ecx
  800ecf:	89 fa                	mov    %edi,%edx
  800ed1:	d3 e8                	shr    %cl,%eax
  800ed3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800ed8:	09 d8                	or     %ebx,%eax
  800eda:	f7 74 24 08          	divl   0x8(%esp)
  800ede:	89 d3                	mov    %edx,%ebx
  800ee0:	d3 e6                	shl    %cl,%esi
  800ee2:	f7 e5                	mul    %ebp
  800ee4:	89 c7                	mov    %eax,%edi
  800ee6:	89 d1                	mov    %edx,%ecx
  800ee8:	39 d3                	cmp    %edx,%ebx
  800eea:	72 06                	jb     800ef2 <__umoddi3+0xe2>
  800eec:	75 0e                	jne    800efc <__umoddi3+0xec>
  800eee:	39 c6                	cmp    %eax,%esi
  800ef0:	73 0a                	jae    800efc <__umoddi3+0xec>
  800ef2:	29 e8                	sub    %ebp,%eax
  800ef4:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800ef8:	89 d1                	mov    %edx,%ecx
  800efa:	89 c7                	mov    %eax,%edi
  800efc:	89 f5                	mov    %esi,%ebp
  800efe:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f02:	29 fd                	sub    %edi,%ebp
  800f04:	19 cb                	sbb    %ecx,%ebx
  800f06:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f0b:	89 d8                	mov    %ebx,%eax
  800f0d:	d3 e0                	shl    %cl,%eax
  800f0f:	89 f1                	mov    %esi,%ecx
  800f11:	d3 ed                	shr    %cl,%ebp
  800f13:	d3 eb                	shr    %cl,%ebx
  800f15:	09 e8                	or     %ebp,%eax
  800f17:	89 da                	mov    %ebx,%edx
  800f19:	83 c4 1c             	add    $0x1c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
