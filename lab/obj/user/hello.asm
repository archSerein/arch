
obj/user/hello:     file format elf32-i386


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
  80002c:	e8 47 00 00 00       	call   800078 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
  80003a:	e8 35 00 00 00       	call   800074 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	cprintf("hello, world\n");
  800045:	8d 83 94 ee ff ff    	lea    -0x116c(%ebx),%eax
  80004b:	50                   	push   %eax
  80004c:	e8 55 01 00 00       	call   8001a6 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800051:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800057:	8b 00                	mov    (%eax),%eax
  800059:	8b 40 48             	mov    0x48(%eax),%eax
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	50                   	push   %eax
  800060:	8d 83 a2 ee ff ff    	lea    -0x115e(%ebx),%eax
  800066:	50                   	push   %eax
  800067:	e8 3a 01 00 00       	call   8001a6 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <__x86.get_pc_thunk.bx>:
  800074:	8b 1c 24             	mov    (%esp),%ebx
  800077:	c3                   	ret    

00800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	57                   	push   %edi
  80007c:	56                   	push   %esi
  80007d:	53                   	push   %ebx
  80007e:	83 ec 0c             	sub    $0xc,%esp
  800081:	e8 ee ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800086:	81 c3 7a 1f 00 00    	add    $0x1f7a,%ebx
  80008c:	8b 75 08             	mov    0x8(%ebp),%esi
  80008f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800092:	e8 4d 0b 00 00       	call   800be4 <sys_getenvid>
  800097:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009c:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80009f:	c1 e0 05             	shl    $0x5,%eax
  8000a2:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  8000a8:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 f6                	test   %esi,%esi
  8000b0:	7e 08                	jle    8000ba <libmain+0x42>
		binaryname = argv[0];
  8000b2:	8b 07                	mov    (%edi),%eax
  8000b4:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	e8 6f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c4:	e8 0b 00 00 00       	call   8000d4 <exit>
}
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5f                   	pop    %edi
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 10             	sub    $0x10,%esp
  8000db:	e8 94 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  8000e0:	81 c3 20 1f 00 00    	add    $0x1f20,%ebx
	sys_env_destroy(0);
  8000e6:	6a 00                	push   $0x0
  8000e8:	e8 a2 0a 00 00       	call   800b8f <sys_env_destroy>
}
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    

008000f5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	e8 75 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  8000ff:	81 c3 01 1f 00 00    	add    $0x1f01,%ebx
  800105:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800108:	8b 16                	mov    (%esi),%edx
  80010a:	8d 42 01             	lea    0x1(%edx),%eax
  80010d:	89 06                	mov    %eax,(%esi)
  80010f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800112:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800116:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011b:	74 0b                	je     800128 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011d:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800121:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5d                   	pop    %ebp
  800127:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800128:	83 ec 08             	sub    $0x8,%esp
  80012b:	68 ff 00 00 00       	push   $0xff
  800130:	8d 46 08             	lea    0x8(%esi),%eax
  800133:	50                   	push   %eax
  800134:	e8 19 0a 00 00       	call   800b52 <sys_cputs>
		b->idx = 0;
  800139:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	eb d9                	jmp    80011d <putch+0x28>

00800144 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	53                   	push   %ebx
  800148:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80014e:	e8 21 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800153:	81 c3 ad 1e 00 00    	add    $0x1ead,%ebx
	struct printbuf b;

	b.idx = 0;
  800159:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800160:	00 00 00 
	b.cnt = 0;
  800163:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016d:	ff 75 0c             	push   0xc(%ebp)
  800170:	ff 75 08             	push   0x8(%ebp)
  800173:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	8d 83 f5 e0 ff ff    	lea    -0x1f0b(%ebx),%eax
  800180:	50                   	push   %eax
  800181:	e8 2c 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800186:	83 c4 08             	add    $0x8,%esp
  800189:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80018f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800195:	50                   	push   %eax
  800196:	e8 b7 09 00 00       	call   800b52 <sys_cputs>

	return b.cnt;
}
  80019b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001af:	50                   	push   %eax
  8001b0:	ff 75 08             	push   0x8(%ebp)
  8001b3:	e8 8c ff ff ff       	call   800144 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    

008001ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	57                   	push   %edi
  8001be:	56                   	push   %esi
  8001bf:	53                   	push   %ebx
  8001c0:	83 ec 2c             	sub    $0x2c,%esp
  8001c3:	e8 0b 06 00 00       	call   8007d3 <__x86.get_pc_thunk.cx>
  8001c8:	81 c1 38 1e 00 00    	add    $0x1e38,%ecx
  8001ce:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d1:	89 c7                	mov    %eax,%edi
  8001d3:	89 d6                	mov    %edx,%esi
  8001d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	89 d1                	mov    %edx,%ecx
  8001dd:	89 c2                	mov    %eax,%edx
  8001df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001e2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001fa:	72 41                	jb     80023d <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff 75 18             	push   0x18(%ebp)
  800202:	83 eb 01             	sub    $0x1,%ebx
  800205:	53                   	push   %ebx
  800206:	50                   	push   %eax
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 e4             	push   -0x1c(%ebp)
  80020d:	ff 75 e0             	push   -0x20(%ebp)
  800210:	ff 75 d4             	push   -0x2c(%ebp)
  800213:	ff 75 d0             	push   -0x30(%ebp)
  800216:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800219:	e8 42 0a 00 00       	call   800c60 <__udivdi3>
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	89 f2                	mov    %esi,%edx
  800225:	89 f8                	mov    %edi,%eax
  800227:	e8 8e ff ff ff       	call   8001ba <printnum>
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	eb 13                	jmp    800244 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	ff 75 18             	push   0x18(%ebp)
  800238:	ff d7                	call   *%edi
  80023a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023d:	83 eb 01             	sub    $0x1,%ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ed                	jg     800231 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	56                   	push   %esi
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	ff 75 e4             	push   -0x1c(%ebp)
  80024e:	ff 75 e0             	push   -0x20(%ebp)
  800251:	ff 75 d4             	push   -0x2c(%ebp)
  800254:	ff 75 d0             	push   -0x30(%ebp)
  800257:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80025a:	e8 21 0b 00 00       	call   800d80 <__umoddi3>
  80025f:	83 c4 14             	add    $0x14,%esp
  800262:	0f be 84 03 c3 ee ff 	movsbl -0x113d(%ebx,%eax,1),%eax
  800269:	ff 
  80026a:	50                   	push   %eax
  80026b:	ff d7                	call   *%edi
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1b>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	push   0x10(%ebp)
  8002a2:	ff 75 0c             	push   0xc(%ebp)
  8002a5:	ff 75 08             	push   0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 3c             	sub    $0x3c,%esp
  8002bb:	e8 0f 05 00 00       	call   8007cf <__x86.get_pc_thunk.ax>
  8002c0:	05 40 1d 00 00       	add    $0x1d40,%eax
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002d1:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8002da:	eb 0a                	jmp    8002e6 <vprintfmt+0x34>
			putch(ch, putdat);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	57                   	push   %edi
  8002e0:	50                   	push   %eax
  8002e1:	ff d6                	call   *%esi
  8002e3:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e6:	83 c3 01             	add    $0x1,%ebx
  8002e9:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8002ed:	83 f8 25             	cmp    $0x25,%eax
  8002f0:	74 0c                	je     8002fe <vprintfmt+0x4c>
			if (ch == '\0')
  8002f2:	85 c0                	test   %eax,%eax
  8002f4:	75 e6                	jne    8002dc <vprintfmt+0x2a>
}
  8002f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f9:	5b                   	pop    %ebx
  8002fa:	5e                   	pop    %esi
  8002fb:	5f                   	pop    %edi
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    
		padc = ' ';
  8002fe:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  800302:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800309:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800310:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80031f:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 43 01             	lea    0x1(%ebx),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 13             	movzbl (%ebx),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 fd 03 00 00    	ja     800733 <.L20>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80033c:	89 ce                	mov    %ecx,%esi
  80033e:	03 b4 81 50 ef ff ff 	add    -0x10b0(%ecx,%eax,4),%esi
  800345:	ff e6                	jmp    *%esi

00800347 <.L68>:
  800347:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80034a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80034e:	eb d2                	jmp    800322 <vprintfmt+0x70>

00800350 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800353:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800357:	eb c9                	jmp    800322 <vprintfmt+0x70>

00800359 <.L31>:
  800359:	0f b6 d2             	movzbl %dl,%edx
  80035c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800367:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036e:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800371:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800374:	83 f9 09             	cmp    $0x9,%ecx
  800377:	77 58                	ja     8003d1 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800379:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80037c:	eb e9                	jmp    800367 <.L31+0xe>

0080037e <.L34>:
			precision = va_arg(ap, int);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 40 04             	lea    0x4(%eax),%eax
  80038c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800392:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800396:	79 8a                	jns    800322 <vprintfmt+0x70>
				width = precision, precision = -1;
  800398:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80039e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a5:	e9 78 ff ff ff       	jmp    800322 <vprintfmt+0x70>

008003aa <.L33>:
  8003aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003ad:	85 d2                	test   %edx,%edx
  8003af:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b4:	0f 49 c2             	cmovns %edx,%eax
  8003b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003bd:	e9 60 ff ff ff       	jmp    800322 <vprintfmt+0x70>

008003c2 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003c5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003cc:	e9 51 ff ff ff       	jmp    800322 <vprintfmt+0x70>
  8003d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d4:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d7:	eb b9                	jmp    800392 <.L34+0x14>

008003d9 <.L27>:
			lflag++;
  8003d9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003e0:	e9 3d ff ff ff       	jmp    800322 <vprintfmt+0x70>

008003e5 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8d 58 04             	lea    0x4(%eax),%ebx
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	57                   	push   %edi
  8003f2:	ff 30                	push   (%eax)
  8003f4:	ff d6                	call   *%esi
			break;
  8003f6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f9:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8003fc:	e9 c8 02 00 00       	jmp    8006c9 <.L25+0x45>

00800401 <.L28>:
			err = va_arg(ap, int);
  800401:	8b 75 08             	mov    0x8(%ebp),%esi
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	8d 58 04             	lea    0x4(%eax),%ebx
  80040a:	8b 10                	mov    (%eax),%edx
  80040c:	89 d0                	mov    %edx,%eax
  80040e:	f7 d8                	neg    %eax
  800410:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800413:	83 f8 06             	cmp    $0x6,%eax
  800416:	7f 27                	jg     80043f <.L28+0x3e>
  800418:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80041b:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80041e:	85 d2                	test   %edx,%edx
  800420:	74 1d                	je     80043f <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  800422:	52                   	push   %edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	8d 80 e4 ee ff ff    	lea    -0x111c(%eax),%eax
  80042c:	50                   	push   %eax
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	e8 61 fe ff ff       	call   800295 <printfmt>
  800434:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800437:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80043a:	e9 8a 02 00 00       	jmp    8006c9 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80043f:	50                   	push   %eax
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	8d 80 db ee ff ff    	lea    -0x1125(%eax),%eax
  800449:	50                   	push   %eax
  80044a:	57                   	push   %edi
  80044b:	56                   	push   %esi
  80044c:	e8 44 fe ff ff       	call   800295 <printfmt>
  800451:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800454:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800457:	e9 6d 02 00 00       	jmp    8006c9 <.L25+0x45>

0080045c <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  80045c:	8b 75 08             	mov    0x8(%ebp),%esi
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80046d:	85 d2                	test   %edx,%edx
  80046f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800472:	8d 80 d4 ee ff ff    	lea    -0x112c(%eax),%eax
  800478:	0f 45 c2             	cmovne %edx,%eax
  80047b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800482:	7e 06                	jle    80048a <.L24+0x2e>
  800484:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800488:	75 0d                	jne    800497 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048d:	89 c3                	mov    %eax,%ebx
  80048f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800492:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800495:	eb 58                	jmp    8004ef <.L24+0x93>
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	ff 75 d8             	push   -0x28(%ebp)
  80049d:	ff 75 c8             	push   -0x38(%ebp)
  8004a0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a3:	e8 47 03 00 00       	call   8007ef <strnlen>
  8004a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ab:	29 c2                	sub    %eax,%edx
  8004ad:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004b5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bc:	eb 0f                	jmp    8004cd <.L24+0x71>
					putch(padc, putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	57                   	push   %edi
  8004c2:	ff 75 d4             	push   -0x2c(%ebp)
  8004c5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c7:	83 eb 01             	sub    $0x1,%ebx
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	85 db                	test   %ebx,%ebx
  8004cf:	7f ed                	jg     8004be <.L24+0x62>
  8004d1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004db:	0f 49 c2             	cmovns %edx,%eax
  8004de:	29 c2                	sub    %eax,%edx
  8004e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e3:	eb a5                	jmp    80048a <.L24+0x2e>
					putch(ch, putdat);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	57                   	push   %edi
  8004e9:	52                   	push   %edx
  8004ea:	ff d6                	call   *%esi
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004f2:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f4:	83 c3 01             	add    $0x1,%ebx
  8004f7:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8004fb:	0f be d0             	movsbl %al,%edx
  8004fe:	85 d2                	test   %edx,%edx
  800500:	74 4b                	je     80054d <.L24+0xf1>
  800502:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800506:	78 06                	js     80050e <.L24+0xb2>
  800508:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050c:	78 1e                	js     80052c <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  80050e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800512:	74 d1                	je     8004e5 <.L24+0x89>
  800514:	0f be c0             	movsbl %al,%eax
  800517:	83 e8 20             	sub    $0x20,%eax
  80051a:	83 f8 5e             	cmp    $0x5e,%eax
  80051d:	76 c6                	jbe    8004e5 <.L24+0x89>
					putch('?', putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	57                   	push   %edi
  800523:	6a 3f                	push   $0x3f
  800525:	ff d6                	call   *%esi
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	eb c3                	jmp    8004ef <.L24+0x93>
  80052c:	89 cb                	mov    %ecx,%ebx
  80052e:	eb 0e                	jmp    80053e <.L24+0xe2>
				putch(' ', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	57                   	push   %edi
  800534:	6a 20                	push   $0x20
  800536:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800538:	83 eb 01             	sub    $0x1,%ebx
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	85 db                	test   %ebx,%ebx
  800540:	7f ee                	jg     800530 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800542:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800545:	89 45 14             	mov    %eax,0x14(%ebp)
  800548:	e9 7c 01 00 00       	jmp    8006c9 <.L25+0x45>
  80054d:	89 cb                	mov    %ecx,%ebx
  80054f:	eb ed                	jmp    80053e <.L24+0xe2>

00800551 <.L29>:
	if (lflag >= 2)
  800551:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800554:	8b 75 08             	mov    0x8(%ebp),%esi
  800557:	83 f9 01             	cmp    $0x1,%ecx
  80055a:	7f 1b                	jg     800577 <.L29+0x26>
	else if (lflag)
  80055c:	85 c9                	test   %ecx,%ecx
  80055e:	74 63                	je     8005c3 <.L29+0x72>
		return va_arg(*ap, long);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800568:	99                   	cltd   
  800569:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8d 40 04             	lea    0x4(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	eb 17                	jmp    80058e <.L29+0x3d>
		return va_arg(*ap, long long);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 50 04             	mov    0x4(%eax),%edx
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 08             	lea    0x8(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80058e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800591:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800594:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  800599:	85 db                	test   %ebx,%ebx
  80059b:	0f 89 0e 01 00 00    	jns    8006af <.L25+0x2b>
				putch('-', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	57                   	push   %edi
  8005a5:	6a 2d                	push   $0x2d
  8005a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a9:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005ac:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 d3 00             	adc    $0x0,%ebx
  8005b4:	f7 db                	neg    %ebx
  8005b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005be:	e9 ec 00 00 00       	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, int);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cb:	99                   	cltd   
  8005cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	eb b4                	jmp    80058e <.L29+0x3d>

008005da <.L23>:
	if (lflag >= 2)
  8005da:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e0:	83 f9 01             	cmp    $0x1,%ecx
  8005e3:	7f 1e                	jg     800603 <.L23+0x29>
	else if (lflag)
  8005e5:	85 c9                	test   %ecx,%ecx
  8005e7:	74 32                	je     80061b <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 08                	mov    (%eax),%ecx
  8005ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f3:	8d 40 04             	lea    0x4(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f9:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8005fe:	e9 ac 00 00 00       	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 08                	mov    (%eax),%ecx
  800608:	8b 58 04             	mov    0x4(%eax),%ebx
  80060b:	8d 40 08             	lea    0x8(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800611:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  800616:	e9 94 00 00 00       	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 08                	mov    (%eax),%ecx
  800620:	bb 00 00 00 00       	mov    $0x0,%ebx
  800625:	8d 40 04             	lea    0x4(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062b:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800630:	eb 7d                	jmp    8006af <.L25+0x2b>

00800632 <.L26>:
	if (lflag >= 2)
  800632:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800635:	8b 75 08             	mov    0x8(%ebp),%esi
  800638:	83 f9 01             	cmp    $0x1,%ecx
  80063b:	7f 1b                	jg     800658 <.L26+0x26>
	else if (lflag)
  80063d:	85 c9                	test   %ecx,%ecx
  80063f:	74 2c                	je     80066d <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 08                	mov    (%eax),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800651:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800656:	eb 57                	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 08                	mov    (%eax),%ecx
  80065d:	8b 58 04             	mov    0x4(%eax),%ebx
  800660:	8d 40 08             	lea    0x8(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800666:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  80066b:	eb 42                	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	bb 00 00 00 00       	mov    $0x0,%ebx
  800677:	8d 40 04             	lea    0x4(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067d:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800682:	eb 2b                	jmp    8006af <.L25+0x2b>

00800684 <.L25>:
			putch('0', putdat);
  800684:	8b 75 08             	mov    0x8(%ebp),%esi
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	57                   	push   %edi
  80068b:	6a 30                	push   $0x30
  80068d:	ff d6                	call   *%esi
			putch('x', putdat);
  80068f:	83 c4 08             	add    $0x8,%esp
  800692:	57                   	push   %edi
  800693:	6a 78                	push   $0x78
  800695:	ff d6                	call   *%esi
			num = (unsigned long long)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 08                	mov    (%eax),%ecx
  80069c:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  8006a1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006aa:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006af:	83 ec 0c             	sub    $0xc,%esp
  8006b2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006b6:	50                   	push   %eax
  8006b7:	ff 75 d4             	push   -0x2c(%ebp)
  8006ba:	52                   	push   %edx
  8006bb:	53                   	push   %ebx
  8006bc:	51                   	push   %ecx
  8006bd:	89 fa                	mov    %edi,%edx
  8006bf:	89 f0                	mov    %esi,%eax
  8006c1:	e8 f4 fa ff ff       	call   8001ba <printnum>
			break;
  8006c6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cc:	e9 15 fc ff ff       	jmp    8002e6 <vprintfmt+0x34>

008006d1 <.L21>:
	if (lflag >= 2)
  8006d1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d7:	83 f9 01             	cmp    $0x1,%ecx
  8006da:	7f 1b                	jg     8006f7 <.L21+0x26>
	else if (lflag)
  8006dc:	85 c9                	test   %ecx,%ecx
  8006de:	74 2c                	je     80070c <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 08                	mov    (%eax),%ecx
  8006e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f0:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8006f5:	eb b8                	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 08                	mov    (%eax),%ecx
  8006fc:	8b 58 04             	mov    0x4(%eax),%ebx
  8006ff:	8d 40 08             	lea    0x8(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800705:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  80070a:	eb a3                	jmp    8006af <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 08                	mov    (%eax),%ecx
  800711:	bb 00 00 00 00       	mov    $0x0,%ebx
  800716:	8d 40 04             	lea    0x4(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071c:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  800721:	eb 8c                	jmp    8006af <.L25+0x2b>

00800723 <.L35>:
			putch(ch, putdat);
  800723:	8b 75 08             	mov    0x8(%ebp),%esi
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	57                   	push   %edi
  80072a:	6a 25                	push   $0x25
  80072c:	ff d6                	call   *%esi
			break;
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	eb 96                	jmp    8006c9 <.L25+0x45>

00800733 <.L20>:
			putch('%', putdat);
  800733:	8b 75 08             	mov    0x8(%ebp),%esi
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	57                   	push   %edi
  80073a:	6a 25                	push   $0x25
  80073c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	89 d8                	mov    %ebx,%eax
  800743:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800747:	74 05                	je     80074e <.L20+0x1b>
  800749:	83 e8 01             	sub    $0x1,%eax
  80074c:	eb f5                	jmp    800743 <.L20+0x10>
  80074e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800751:	e9 73 ff ff ff       	jmp    8006c9 <.L25+0x45>

00800756 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	53                   	push   %ebx
  80075a:	83 ec 14             	sub    $0x14,%esp
  80075d:	e8 12 f9 ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800762:	81 c3 9e 18 00 00    	add    $0x189e,%ebx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 2b                	je     8007ae <vsnprintf+0x58>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 27                	jle    8007ae <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	ff 75 14             	push   0x14(%ebp)
  80078a:	ff 75 10             	push   0x10(%ebp)
  80078d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	8d 83 78 e2 ff ff    	lea    -0x1d88(%ebx),%eax
  800797:	50                   	push   %eax
  800798:	e8 15 fb ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
}
  8007a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b3:	eb f4                	jmp    8007a9 <vsnprintf+0x53>

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007be:	50                   	push   %eax
  8007bf:	ff 75 10             	push   0x10(%ebp)
  8007c2:	ff 75 0c             	push   0xc(%ebp)
  8007c5:	ff 75 08             	push   0x8(%ebp)
  8007c8:	e8 89 ff ff ff       	call   800756 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <__x86.get_pc_thunk.ax>:
  8007cf:	8b 04 24             	mov    (%esp),%eax
  8007d2:	c3                   	ret    

008007d3 <__x86.get_pc_thunk.cx>:
  8007d3:	8b 0c 24             	mov    (%esp),%ecx
  8007d6:	c3                   	ret    

008007d7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	eb 03                	jmp    8007e7 <strlen+0x10>
		n++;
  8007e4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007eb:	75 f7                	jne    8007e4 <strlen+0xd>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	eb 03                	jmp    800802 <strnlen+0x13>
		n++;
  8007ff:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800802:	39 d0                	cmp    %edx,%eax
  800804:	74 08                	je     80080e <strnlen+0x1f>
  800806:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080a:	75 f3                	jne    8007ff <strnlen+0x10>
  80080c:	89 c2                	mov    %eax,%edx
	return n;
}
  80080e:	89 d0                	mov    %edx,%eax
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800819:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800825:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800828:	83 c0 01             	add    $0x1,%eax
  80082b:	84 d2                	test   %dl,%dl
  80082d:	75 f2                	jne    800821 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80082f:	89 c8                	mov    %ecx,%eax
  800831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	53                   	push   %ebx
  80083a:	83 ec 10             	sub    $0x10,%esp
  80083d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800840:	53                   	push   %ebx
  800841:	e8 91 ff ff ff       	call   8007d7 <strlen>
  800846:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800849:	ff 75 0c             	push   0xc(%ebp)
  80084c:	01 d8                	add    %ebx,%eax
  80084e:	50                   	push   %eax
  80084f:	e8 be ff ff ff       	call   800812 <strcpy>
	return dst;
}
  800854:	89 d8                	mov    %ebx,%eax
  800856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	56                   	push   %esi
  80085f:	53                   	push   %ebx
  800860:	8b 75 08             	mov    0x8(%ebp),%esi
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
  800866:	89 f3                	mov    %esi,%ebx
  800868:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80086b:	89 f0                	mov    %esi,%eax
  80086d:	eb 0f                	jmp    80087e <strncpy+0x23>
		*dst++ = *src;
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	0f b6 0a             	movzbl (%edx),%ecx
  800875:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800878:	80 f9 01             	cmp    $0x1,%cl
  80087b:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	75 ed                	jne    80086f <strncpy+0x14>
	}
	return ret;
}
  800882:	89 f0                	mov    %esi,%eax
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800893:	8b 55 10             	mov    0x10(%ebp),%edx
  800896:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800898:	85 d2                	test   %edx,%edx
  80089a:	74 21                	je     8008bd <strlcpy+0x35>
  80089c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008a0:	89 f2                	mov    %esi,%edx
  8008a2:	eb 09                	jmp    8008ad <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a4:	83 c1 01             	add    $0x1,%ecx
  8008a7:	83 c2 01             	add    $0x1,%edx
  8008aa:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	74 09                	je     8008ba <strlcpy+0x32>
  8008b1:	0f b6 19             	movzbl (%ecx),%ebx
  8008b4:	84 db                	test   %bl,%bl
  8008b6:	75 ec                	jne    8008a4 <strlcpy+0x1c>
  8008b8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008bd:	29 f0                	sub    %esi,%eax
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cc:	eb 06                	jmp    8008d4 <strcmp+0x11>
		p++, q++;
  8008ce:	83 c1 01             	add    $0x1,%ecx
  8008d1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d4:	0f b6 01             	movzbl (%ecx),%eax
  8008d7:	84 c0                	test   %al,%al
  8008d9:	74 04                	je     8008df <strcmp+0x1c>
  8008db:	3a 02                	cmp    (%edx),%al
  8008dd:	74 ef                	je     8008ce <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	0f b6 12             	movzbl (%edx),%edx
  8008e5:	29 d0                	sub    %edx,%eax
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 c3                	mov    %eax,%ebx
  8008f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f8:	eb 06                	jmp    800900 <strncmp+0x17>
		n--, p++, q++;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800900:	39 d8                	cmp    %ebx,%eax
  800902:	74 18                	je     80091c <strncmp+0x33>
  800904:	0f b6 08             	movzbl (%eax),%ecx
  800907:	84 c9                	test   %cl,%cl
  800909:	74 04                	je     80090f <strncmp+0x26>
  80090b:	3a 0a                	cmp    (%edx),%cl
  80090d:	74 eb                	je     8008fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090f:	0f b6 00             	movzbl (%eax),%eax
  800912:	0f b6 12             	movzbl (%edx),%edx
  800915:	29 d0                	sub    %edx,%eax
}
  800917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb f4                	jmp    800917 <strncmp+0x2e>

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092d:	eb 03                	jmp    800932 <strchr+0xf>
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	0f b6 10             	movzbl (%eax),%edx
  800935:	84 d2                	test   %dl,%dl
  800937:	74 06                	je     80093f <strchr+0x1c>
		if (*s == c)
  800939:	38 ca                	cmp    %cl,%dl
  80093b:	75 f2                	jne    80092f <strchr+0xc>
  80093d:	eb 05                	jmp    800944 <strchr+0x21>
			return (char *) s;
	return 0;
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800950:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800953:	38 ca                	cmp    %cl,%dl
  800955:	74 09                	je     800960 <strfind+0x1a>
  800957:	84 d2                	test   %dl,%dl
  800959:	74 05                	je     800960 <strfind+0x1a>
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	eb f0                	jmp    800950 <strfind+0xa>
			break;
	return (char *) s;
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	57                   	push   %edi
  800966:	56                   	push   %esi
  800967:	53                   	push   %ebx
  800968:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096e:	85 c9                	test   %ecx,%ecx
  800970:	74 2f                	je     8009a1 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800972:	89 f8                	mov    %edi,%eax
  800974:	09 c8                	or     %ecx,%eax
  800976:	a8 03                	test   $0x3,%al
  800978:	75 21                	jne    80099b <memset+0x39>
		c &= 0xFF;
  80097a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097e:	89 d0                	mov    %edx,%eax
  800980:	c1 e0 08             	shl    $0x8,%eax
  800983:	89 d3                	mov    %edx,%ebx
  800985:	c1 e3 18             	shl    $0x18,%ebx
  800988:	89 d6                	mov    %edx,%esi
  80098a:	c1 e6 10             	shl    $0x10,%esi
  80098d:	09 f3                	or     %esi,%ebx
  80098f:	09 da                	or     %ebx,%edx
  800991:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800993:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800996:	fc                   	cld    
  800997:	f3 ab                	rep stos %eax,%es:(%edi)
  800999:	eb 06                	jmp    8009a1 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099e:	fc                   	cld    
  80099f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a1:	89 f8                	mov    %edi,%eax
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5f                   	pop    %edi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	57                   	push   %edi
  8009ac:	56                   	push   %esi
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b6:	39 c6                	cmp    %eax,%esi
  8009b8:	73 32                	jae    8009ec <memmove+0x44>
  8009ba:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009bd:	39 c2                	cmp    %eax,%edx
  8009bf:	76 2b                	jbe    8009ec <memmove+0x44>
		s += n;
		d += n;
  8009c1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c4:	89 d6                	mov    %edx,%esi
  8009c6:	09 fe                	or     %edi,%esi
  8009c8:	09 ce                	or     %ecx,%esi
  8009ca:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d0:	75 0e                	jne    8009e0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d2:	83 ef 04             	sub    $0x4,%edi
  8009d5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009db:	fd                   	std    
  8009dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009de:	eb 09                	jmp    8009e9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e0:	83 ef 01             	sub    $0x1,%edi
  8009e3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e6:	fd                   	std    
  8009e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e9:	fc                   	cld    
  8009ea:	eb 1a                	jmp    800a06 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 f2                	mov    %esi,%edx
  8009ee:	09 c2                	or     %eax,%edx
  8009f0:	09 ca                	or     %ecx,%edx
  8009f2:	f6 c2 03             	test   $0x3,%dl
  8009f5:	75 0a                	jne    800a01 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fa:	89 c7                	mov    %eax,%edi
  8009fc:	fc                   	cld    
  8009fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ff:	eb 05                	jmp    800a06 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a01:	89 c7                	mov    %eax,%edi
  800a03:	fc                   	cld    
  800a04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a06:	5e                   	pop    %esi
  800a07:	5f                   	pop    %edi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a10:	ff 75 10             	push   0x10(%ebp)
  800a13:	ff 75 0c             	push   0xc(%ebp)
  800a16:	ff 75 08             	push   0x8(%ebp)
  800a19:	e8 8a ff ff ff       	call   8009a8 <memmove>
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c6                	mov    %eax,%esi
  800a2d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a30:	eb 06                	jmp    800a38 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a38:	39 f0                	cmp    %esi,%eax
  800a3a:	74 14                	je     800a50 <memcmp+0x30>
		if (*s1 != *s2)
  800a3c:	0f b6 08             	movzbl (%eax),%ecx
  800a3f:	0f b6 1a             	movzbl (%edx),%ebx
  800a42:	38 d9                	cmp    %bl,%cl
  800a44:	74 ec                	je     800a32 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a46:	0f b6 c1             	movzbl %cl,%eax
  800a49:	0f b6 db             	movzbl %bl,%ebx
  800a4c:	29 d8                	sub    %ebx,%eax
  800a4e:	eb 05                	jmp    800a55 <memcmp+0x35>
	}

	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a62:	89 c2                	mov    %eax,%edx
  800a64:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a67:	eb 03                	jmp    800a6c <memfind+0x13>
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	39 d0                	cmp    %edx,%eax
  800a6e:	73 04                	jae    800a74 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a70:	38 08                	cmp    %cl,(%eax)
  800a72:	75 f5                	jne    800a69 <memfind+0x10>
			break;
	return (void *) s;
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a82:	eb 03                	jmp    800a87 <strtol+0x11>
		s++;
  800a84:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a87:	0f b6 02             	movzbl (%edx),%eax
  800a8a:	3c 20                	cmp    $0x20,%al
  800a8c:	74 f6                	je     800a84 <strtol+0xe>
  800a8e:	3c 09                	cmp    $0x9,%al
  800a90:	74 f2                	je     800a84 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a92:	3c 2b                	cmp    $0x2b,%al
  800a94:	74 2a                	je     800ac0 <strtol+0x4a>
	int neg = 0;
  800a96:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a9b:	3c 2d                	cmp    $0x2d,%al
  800a9d:	74 2b                	je     800aca <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa5:	75 0f                	jne    800ab6 <strtol+0x40>
  800aa7:	80 3a 30             	cmpb   $0x30,(%edx)
  800aaa:	74 28                	je     800ad4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aac:	85 db                	test   %ebx,%ebx
  800aae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab3:	0f 44 d8             	cmove  %eax,%ebx
  800ab6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abe:	eb 46                	jmp    800b06 <strtol+0x90>
		s++;
  800ac0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ac3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac8:	eb d5                	jmp    800a9f <strtol+0x29>
		s++, neg = 1;
  800aca:	83 c2 01             	add    $0x1,%edx
  800acd:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad2:	eb cb                	jmp    800a9f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad4:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ad8:	74 0e                	je     800ae8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ada:	85 db                	test   %ebx,%ebx
  800adc:	75 d8                	jne    800ab6 <strtol+0x40>
		s++, base = 8;
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae6:	eb ce                	jmp    800ab6 <strtol+0x40>
		s += 2, base = 16;
  800ae8:	83 c2 02             	add    $0x2,%edx
  800aeb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af0:	eb c4                	jmp    800ab6 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800af2:	0f be c0             	movsbl %al,%eax
  800af5:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800afb:	7d 3a                	jge    800b37 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800afd:	83 c2 01             	add    $0x1,%edx
  800b00:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b04:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b06:	0f b6 02             	movzbl (%edx),%eax
  800b09:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b0c:	89 f3                	mov    %esi,%ebx
  800b0e:	80 fb 09             	cmp    $0x9,%bl
  800b11:	76 df                	jbe    800af2 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b13:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b16:	89 f3                	mov    %esi,%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b1d:	0f be c0             	movsbl %al,%eax
  800b20:	83 e8 57             	sub    $0x57,%eax
  800b23:	eb d3                	jmp    800af8 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b25:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b28:	89 f3                	mov    %esi,%ebx
  800b2a:	80 fb 19             	cmp    $0x19,%bl
  800b2d:	77 08                	ja     800b37 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b2f:	0f be c0             	movsbl %al,%eax
  800b32:	83 e8 37             	sub    $0x37,%eax
  800b35:	eb c1                	jmp    800af8 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3b:	74 05                	je     800b42 <strtol+0xcc>
		*endptr = (char *) s;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b42:	89 c8                	mov    %ecx,%eax
  800b44:	f7 d8                	neg    %eax
  800b46:	85 ff                	test   %edi,%edi
  800b48:	0f 45 c8             	cmovne %eax,%ecx
}
  800b4b:	89 c8                	mov    %ecx,%eax
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b63:	89 c3                	mov    %eax,%ebx
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	89 c6                	mov    %eax,%esi
  800b69:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 1c             	sub    $0x1c,%esp
  800b98:	e8 32 fc ff ff       	call   8007cf <__x86.get_pc_thunk.ax>
  800b9d:	05 63 14 00 00       	add    $0x1463,%eax
  800ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800ba5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800baa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bad:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb2:	89 cb                	mov    %ecx,%ebx
  800bb4:	89 cf                	mov    %ecx,%edi
  800bb6:	89 ce                	mov    %ecx,%esi
  800bb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	7f 08                	jg     800bc6 <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 03                	push   $0x3
  800bcc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800bcf:	8d 83 a8 f0 ff ff    	lea    -0xf58(%ebx),%eax
  800bd5:	50                   	push   %eax
  800bd6:	6a 23                	push   $0x23
  800bd8:	8d 83 c5 f0 ff ff    	lea    -0xf3b(%ebx),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 1f 00 00 00       	call   800c03 <_panic>

00800be4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	e8 63 f4 ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800c11:	81 c3 ef 13 00 00    	add    $0x13ef,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c17:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c1a:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c20:	8b 38                	mov    (%eax),%edi
  800c22:	e8 bd ff ff ff       	call   800be4 <sys_getenvid>
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	ff 75 0c             	push   0xc(%ebp)
  800c2d:	ff 75 08             	push   0x8(%ebp)
  800c30:	57                   	push   %edi
  800c31:	50                   	push   %eax
  800c32:	8d 83 d4 f0 ff ff    	lea    -0xf2c(%ebx),%eax
  800c38:	50                   	push   %eax
  800c39:	e8 68 f5 ff ff       	call   8001a6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c3e:	83 c4 18             	add    $0x18,%esp
  800c41:	56                   	push   %esi
  800c42:	ff 75 10             	push   0x10(%ebp)
  800c45:	e8 fa f4 ff ff       	call   800144 <vcprintf>
	cprintf("\n");
  800c4a:	8d 83 a0 ee ff ff    	lea    -0x1160(%ebx),%eax
  800c50:	89 04 24             	mov    %eax,(%esp)
  800c53:	e8 4e f5 ff ff       	call   8001a6 <cprintf>
  800c58:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c5b:	cc                   	int3   
  800c5c:	eb fd                	jmp    800c5b <_panic+0x58>
  800c5e:	66 90                	xchg   %ax,%ax

00800c60 <__udivdi3>:
  800c60:	f3 0f 1e fb          	endbr32 
  800c64:	55                   	push   %ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 1c             	sub    $0x1c,%esp
  800c6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800c6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c73:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	75 19                	jne    800c98 <__udivdi3+0x38>
  800c7f:	39 f3                	cmp    %esi,%ebx
  800c81:	76 4d                	jbe    800cd0 <__udivdi3+0x70>
  800c83:	31 ff                	xor    %edi,%edi
  800c85:	89 e8                	mov    %ebp,%eax
  800c87:	89 f2                	mov    %esi,%edx
  800c89:	f7 f3                	div    %ebx
  800c8b:	89 fa                	mov    %edi,%edx
  800c8d:	83 c4 1c             	add    $0x1c,%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
  800c95:	8d 76 00             	lea    0x0(%esi),%esi
  800c98:	39 f0                	cmp    %esi,%eax
  800c9a:	76 14                	jbe    800cb0 <__udivdi3+0x50>
  800c9c:	31 ff                	xor    %edi,%edi
  800c9e:	31 c0                	xor    %eax,%eax
  800ca0:	89 fa                	mov    %edi,%edx
  800ca2:	83 c4 1c             	add    $0x1c,%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
  800caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800cb0:	0f bd f8             	bsr    %eax,%edi
  800cb3:	83 f7 1f             	xor    $0x1f,%edi
  800cb6:	75 48                	jne    800d00 <__udivdi3+0xa0>
  800cb8:	39 f0                	cmp    %esi,%eax
  800cba:	72 06                	jb     800cc2 <__udivdi3+0x62>
  800cbc:	31 c0                	xor    %eax,%eax
  800cbe:	39 eb                	cmp    %ebp,%ebx
  800cc0:	77 de                	ja     800ca0 <__udivdi3+0x40>
  800cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc7:	eb d7                	jmp    800ca0 <__udivdi3+0x40>
  800cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cd0:	89 d9                	mov    %ebx,%ecx
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	75 0b                	jne    800ce1 <__udivdi3+0x81>
  800cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdb:	31 d2                	xor    %edx,%edx
  800cdd:	f7 f3                	div    %ebx
  800cdf:	89 c1                	mov    %eax,%ecx
  800ce1:	31 d2                	xor    %edx,%edx
  800ce3:	89 f0                	mov    %esi,%eax
  800ce5:	f7 f1                	div    %ecx
  800ce7:	89 c6                	mov    %eax,%esi
  800ce9:	89 e8                	mov    %ebp,%eax
  800ceb:	89 f7                	mov    %esi,%edi
  800ced:	f7 f1                	div    %ecx
  800cef:	89 fa                	mov    %edi,%edx
  800cf1:	83 c4 1c             	add    $0x1c,%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
  800cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d00:	89 f9                	mov    %edi,%ecx
  800d02:	ba 20 00 00 00       	mov    $0x20,%edx
  800d07:	29 fa                	sub    %edi,%edx
  800d09:	d3 e0                	shl    %cl,%eax
  800d0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d8                	mov    %ebx,%eax
  800d13:	d3 e8                	shr    %cl,%eax
  800d15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d19:	09 c1                	or     %eax,%ecx
  800d1b:	89 f0                	mov    %esi,%eax
  800d1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d21:	89 f9                	mov    %edi,%ecx
  800d23:	d3 e3                	shl    %cl,%ebx
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	d3 e8                	shr    %cl,%eax
  800d29:	89 f9                	mov    %edi,%ecx
  800d2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d2f:	89 eb                	mov    %ebp,%ebx
  800d31:	d3 e6                	shl    %cl,%esi
  800d33:	89 d1                	mov    %edx,%ecx
  800d35:	d3 eb                	shr    %cl,%ebx
  800d37:	09 f3                	or     %esi,%ebx
  800d39:	89 c6                	mov    %eax,%esi
  800d3b:	89 f2                	mov    %esi,%edx
  800d3d:	89 d8                	mov    %ebx,%eax
  800d3f:	f7 74 24 08          	divl   0x8(%esp)
  800d43:	89 d6                	mov    %edx,%esi
  800d45:	89 c3                	mov    %eax,%ebx
  800d47:	f7 64 24 0c          	mull   0xc(%esp)
  800d4b:	39 d6                	cmp    %edx,%esi
  800d4d:	72 19                	jb     800d68 <__udivdi3+0x108>
  800d4f:	89 f9                	mov    %edi,%ecx
  800d51:	d3 e5                	shl    %cl,%ebp
  800d53:	39 c5                	cmp    %eax,%ebp
  800d55:	73 04                	jae    800d5b <__udivdi3+0xfb>
  800d57:	39 d6                	cmp    %edx,%esi
  800d59:	74 0d                	je     800d68 <__udivdi3+0x108>
  800d5b:	89 d8                	mov    %ebx,%eax
  800d5d:	31 ff                	xor    %edi,%edi
  800d5f:	e9 3c ff ff ff       	jmp    800ca0 <__udivdi3+0x40>
  800d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d6b:	31 ff                	xor    %edi,%edi
  800d6d:	e9 2e ff ff ff       	jmp    800ca0 <__udivdi3+0x40>
  800d72:	66 90                	xchg   %ax,%ax
  800d74:	66 90                	xchg   %ax,%ax
  800d76:	66 90                	xchg   %ax,%ax
  800d78:	66 90                	xchg   %ax,%ax
  800d7a:	66 90                	xchg   %ax,%ax
  800d7c:	66 90                	xchg   %ax,%ax
  800d7e:	66 90                	xchg   %ax,%ax

00800d80 <__umoddi3>:
  800d80:	f3 0f 1e fb          	endbr32 
  800d84:	55                   	push   %ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 1c             	sub    $0x1c,%esp
  800d8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d93:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800d97:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800d9b:	89 f0                	mov    %esi,%eax
  800d9d:	89 da                	mov    %ebx,%edx
  800d9f:	85 ff                	test   %edi,%edi
  800da1:	75 15                	jne    800db8 <__umoddi3+0x38>
  800da3:	39 dd                	cmp    %ebx,%ebp
  800da5:	76 39                	jbe    800de0 <__umoddi3+0x60>
  800da7:	f7 f5                	div    %ebp
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	31 d2                	xor    %edx,%edx
  800dad:	83 c4 1c             	add    $0x1c,%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
  800db5:	8d 76 00             	lea    0x0(%esi),%esi
  800db8:	39 df                	cmp    %ebx,%edi
  800dba:	77 f1                	ja     800dad <__umoddi3+0x2d>
  800dbc:	0f bd cf             	bsr    %edi,%ecx
  800dbf:	83 f1 1f             	xor    $0x1f,%ecx
  800dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800dc6:	75 40                	jne    800e08 <__umoddi3+0x88>
  800dc8:	39 df                	cmp    %ebx,%edi
  800dca:	72 04                	jb     800dd0 <__umoddi3+0x50>
  800dcc:	39 f5                	cmp    %esi,%ebp
  800dce:	77 dd                	ja     800dad <__umoddi3+0x2d>
  800dd0:	89 da                	mov    %ebx,%edx
  800dd2:	89 f0                	mov    %esi,%eax
  800dd4:	29 e8                	sub    %ebp,%eax
  800dd6:	19 fa                	sbb    %edi,%edx
  800dd8:	eb d3                	jmp    800dad <__umoddi3+0x2d>
  800dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800de0:	89 e9                	mov    %ebp,%ecx
  800de2:	85 ed                	test   %ebp,%ebp
  800de4:	75 0b                	jne    800df1 <__umoddi3+0x71>
  800de6:	b8 01 00 00 00       	mov    $0x1,%eax
  800deb:	31 d2                	xor    %edx,%edx
  800ded:	f7 f5                	div    %ebp
  800def:	89 c1                	mov    %eax,%ecx
  800df1:	89 d8                	mov    %ebx,%eax
  800df3:	31 d2                	xor    %edx,%edx
  800df5:	f7 f1                	div    %ecx
  800df7:	89 f0                	mov    %esi,%eax
  800df9:	f7 f1                	div    %ecx
  800dfb:	89 d0                	mov    %edx,%eax
  800dfd:	31 d2                	xor    %edx,%edx
  800dff:	eb ac                	jmp    800dad <__umoddi3+0x2d>
  800e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e08:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e0c:	ba 20 00 00 00       	mov    $0x20,%edx
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 c1                	mov    %eax,%ecx
  800e15:	89 e8                	mov    %ebp,%eax
  800e17:	d3 e7                	shl    %cl,%edi
  800e19:	89 d1                	mov    %edx,%ecx
  800e1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e1f:	d3 e8                	shr    %cl,%eax
  800e21:	89 c1                	mov    %eax,%ecx
  800e23:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e27:	09 f9                	or     %edi,%ecx
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	d3 e5                	shl    %cl,%ebp
  800e33:	89 d1                	mov    %edx,%ecx
  800e35:	d3 ef                	shr    %cl,%edi
  800e37:	89 c1                	mov    %eax,%ecx
  800e39:	89 f0                	mov    %esi,%eax
  800e3b:	d3 e3                	shl    %cl,%ebx
  800e3d:	89 d1                	mov    %edx,%ecx
  800e3f:	89 fa                	mov    %edi,%edx
  800e41:	d3 e8                	shr    %cl,%eax
  800e43:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e48:	09 d8                	or     %ebx,%eax
  800e4a:	f7 74 24 08          	divl   0x8(%esp)
  800e4e:	89 d3                	mov    %edx,%ebx
  800e50:	d3 e6                	shl    %cl,%esi
  800e52:	f7 e5                	mul    %ebp
  800e54:	89 c7                	mov    %eax,%edi
  800e56:	89 d1                	mov    %edx,%ecx
  800e58:	39 d3                	cmp    %edx,%ebx
  800e5a:	72 06                	jb     800e62 <__umoddi3+0xe2>
  800e5c:	75 0e                	jne    800e6c <__umoddi3+0xec>
  800e5e:	39 c6                	cmp    %eax,%esi
  800e60:	73 0a                	jae    800e6c <__umoddi3+0xec>
  800e62:	29 e8                	sub    %ebp,%eax
  800e64:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800e68:	89 d1                	mov    %edx,%ecx
  800e6a:	89 c7                	mov    %eax,%edi
  800e6c:	89 f5                	mov    %esi,%ebp
  800e6e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e72:	29 fd                	sub    %edi,%ebp
  800e74:	19 cb                	sbb    %ecx,%ebx
  800e76:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e7b:	89 d8                	mov    %ebx,%eax
  800e7d:	d3 e0                	shl    %cl,%eax
  800e7f:	89 f1                	mov    %esi,%ecx
  800e81:	d3 ed                	shr    %cl,%ebp
  800e83:	d3 eb                	shr    %cl,%ebx
  800e85:	09 e8                	or     %ebp,%eax
  800e87:	89 da                	mov    %ebx,%edx
  800e89:	83 c4 1c             	add    $0x1c,%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
