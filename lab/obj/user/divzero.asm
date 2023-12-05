
obj/user/divzero:     file format elf32-i386


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
  80002c:	e8 44 00 00 00       	call   800075 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	e8 32 00 00 00       	call   800071 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	zero = 0;
  800045:	c7 83 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
  80004c:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  80004f:	b8 01 00 00 00       	mov    $0x1,%eax
  800054:	b9 00 00 00 00       	mov    $0x0,%ecx
  800059:	99                   	cltd   
  80005a:	f7 f9                	idiv   %ecx
  80005c:	50                   	push   %eax
  80005d:	8d 83 94 ee ff ff    	lea    -0x116c(%ebx),%eax
  800063:	50                   	push   %eax
  800064:	e8 3a 01 00 00       	call   8001a3 <cprintf>
}
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006f:	c9                   	leave  
  800070:	c3                   	ret    

00800071 <__x86.get_pc_thunk.bx>:
  800071:	8b 1c 24             	mov    (%esp),%ebx
  800074:	c3                   	ret    

00800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	57                   	push   %edi
  800079:	56                   	push   %esi
  80007a:	53                   	push   %ebx
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	e8 ee ff ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  800083:	81 c3 7d 1f 00 00    	add    $0x1f7d,%ebx
  800089:	8b 75 08             	mov    0x8(%ebp),%esi
  80008c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008f:	e8 4d 0b 00 00       	call   800be1 <sys_getenvid>
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80009c:	c1 e0 05             	shl    $0x5,%eax
  80009f:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  8000a5:	89 83 30 00 00 00    	mov    %eax,0x30(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ab:	85 f6                	test   %esi,%esi
  8000ad:	7e 08                	jle    8000b7 <libmain+0x42>
		binaryname = argv[0];
  8000af:	8b 07                	mov    (%edi),%eax
  8000b1:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	e8 72 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c1:	e8 0b 00 00 00       	call   8000d1 <exit>
}
  8000c6:	83 c4 10             	add    $0x10,%esp
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    

008000d1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 10             	sub    $0x10,%esp
  8000d8:	e8 94 ff ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  8000dd:	81 c3 23 1f 00 00    	add    $0x1f23,%ebx
	sys_env_destroy(0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	e8 a2 0a 00 00       	call   800b8c <sys_env_destroy>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	e8 75 ff ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  8000fc:	81 c3 04 1f 00 00    	add    $0x1f04,%ebx
  800102:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800105:	8b 16                	mov    (%esi),%edx
  800107:	8d 42 01             	lea    0x1(%edx),%eax
  80010a:	89 06                	mov    %eax,(%esi)
  80010c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010f:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800113:	3d ff 00 00 00       	cmp    $0xff,%eax
  800118:	74 0b                	je     800125 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80011e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	68 ff 00 00 00       	push   $0xff
  80012d:	8d 46 08             	lea    0x8(%esi),%eax
  800130:	50                   	push   %eax
  800131:	e8 19 0a 00 00       	call   800b4f <sys_cputs>
		b->idx = 0;
  800136:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	eb d9                	jmp    80011a <putch+0x28>

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	53                   	push   %ebx
  800145:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80014b:	e8 21 ff ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  800150:	81 c3 b0 1e 00 00    	add    $0x1eb0,%ebx
	struct printbuf b;

	b.idx = 0;
  800156:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015d:	00 00 00 
	b.cnt = 0;
  800160:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800167:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016a:	ff 75 0c             	push   0xc(%ebp)
  80016d:	ff 75 08             	push   0x8(%ebp)
  800170:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800176:	50                   	push   %eax
  800177:	8d 83 f2 e0 ff ff    	lea    -0x1f0e(%ebx),%eax
  80017d:	50                   	push   %eax
  80017e:	e8 2c 01 00 00       	call   8002af <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800183:	83 c4 08             	add    $0x8,%esp
  800186:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80018c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800192:	50                   	push   %eax
  800193:	e8 b7 09 00 00       	call   800b4f <sys_cputs>

	return b.cnt;
}
  800198:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ac:	50                   	push   %eax
  8001ad:	ff 75 08             	push   0x8(%ebp)
  8001b0:	e8 8c ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b5:	c9                   	leave  
  8001b6:	c3                   	ret    

008001b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 2c             	sub    $0x2c,%esp
  8001c0:	e8 0b 06 00 00       	call   8007d0 <__x86.get_pc_thunk.cx>
  8001c5:	81 c1 3b 1e 00 00    	add    $0x1e3b,%ecx
  8001cb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 d6                	mov    %edx,%esi
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d8:	89 d1                	mov    %edx,%ecx
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001f2:	39 c2                	cmp    %eax,%edx
  8001f4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f7:	72 41                	jb     80023a <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	push   0x18(%ebp)
  8001ff:	83 eb 01             	sub    $0x1,%ebx
  800202:	53                   	push   %ebx
  800203:	50                   	push   %eax
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	ff 75 e4             	push   -0x1c(%ebp)
  80020a:	ff 75 e0             	push   -0x20(%ebp)
  80020d:	ff 75 d4             	push   -0x2c(%ebp)
  800210:	ff 75 d0             	push   -0x30(%ebp)
  800213:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800216:	e8 45 0a 00 00       	call   800c60 <__udivdi3>
  80021b:	83 c4 18             	add    $0x18,%esp
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	89 f2                	mov    %esi,%edx
  800222:	89 f8                	mov    %edi,%eax
  800224:	e8 8e ff ff ff       	call   8001b7 <printnum>
  800229:	83 c4 20             	add    $0x20,%esp
  80022c:	eb 13                	jmp    800241 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	56                   	push   %esi
  800232:	ff 75 18             	push   0x18(%ebp)
  800235:	ff d7                	call   *%edi
  800237:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023a:	83 eb 01             	sub    $0x1,%ebx
  80023d:	85 db                	test   %ebx,%ebx
  80023f:	7f ed                	jg     80022e <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800241:	83 ec 08             	sub    $0x8,%esp
  800244:	56                   	push   %esi
  800245:	83 ec 04             	sub    $0x4,%esp
  800248:	ff 75 e4             	push   -0x1c(%ebp)
  80024b:	ff 75 e0             	push   -0x20(%ebp)
  80024e:	ff 75 d4             	push   -0x2c(%ebp)
  800251:	ff 75 d0             	push   -0x30(%ebp)
  800254:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800257:	e8 24 0b 00 00       	call   800d80 <__umoddi3>
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	0f be 84 03 ac ee ff 	movsbl -0x1154(%ebx,%eax,1),%eax
  800266:	ff 
  800267:	50                   	push   %eax
  800268:	ff d7                	call   *%edi
}
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800270:	5b                   	pop    %ebx
  800271:	5e                   	pop    %esi
  800272:	5f                   	pop    %edi
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    

00800275 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027f:	8b 10                	mov    (%eax),%edx
  800281:	3b 50 04             	cmp    0x4(%eax),%edx
  800284:	73 0a                	jae    800290 <sprintputch+0x1b>
		*b->buf++ = ch;
  800286:	8d 4a 01             	lea    0x1(%edx),%ecx
  800289:	89 08                	mov    %ecx,(%eax)
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	88 02                	mov    %al,(%edx)
}
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    

00800292 <printfmt>:
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800298:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029b:	50                   	push   %eax
  80029c:	ff 75 10             	push   0x10(%ebp)
  80029f:	ff 75 0c             	push   0xc(%ebp)
  8002a2:	ff 75 08             	push   0x8(%ebp)
  8002a5:	e8 05 00 00 00       	call   8002af <vprintfmt>
}
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <vprintfmt>:
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	57                   	push   %edi
  8002b3:	56                   	push   %esi
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 3c             	sub    $0x3c,%esp
  8002b8:	e8 0f 05 00 00       	call   8007cc <__x86.get_pc_thunk.ax>
  8002bd:	05 43 1d 00 00       	add    $0x1d43,%eax
  8002c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002ce:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8002d7:	eb 0a                	jmp    8002e3 <vprintfmt+0x34>
			putch(ch, putdat);
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	57                   	push   %edi
  8002dd:	50                   	push   %eax
  8002de:	ff d6                	call   *%esi
  8002e0:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e3:	83 c3 01             	add    $0x1,%ebx
  8002e6:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8002ea:	83 f8 25             	cmp    $0x25,%eax
  8002ed:	74 0c                	je     8002fb <vprintfmt+0x4c>
			if (ch == '\0')
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 e6                	jne    8002d9 <vprintfmt+0x2a>
}
  8002f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f6:	5b                   	pop    %ebx
  8002f7:	5e                   	pop    %esi
  8002f8:	5f                   	pop    %edi
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    
		padc = ' ';
  8002fb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8002ff:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800306:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800314:	b9 00 00 00 00       	mov    $0x0,%ecx
  800319:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80031c:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8d 43 01             	lea    0x1(%ebx),%eax
  800322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800325:	0f b6 13             	movzbl (%ebx),%edx
  800328:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032b:	3c 55                	cmp    $0x55,%al
  80032d:	0f 87 fd 03 00 00    	ja     800730 <.L20>
  800333:	0f b6 c0             	movzbl %al,%eax
  800336:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800339:	89 ce                	mov    %ecx,%esi
  80033b:	03 b4 81 3c ef ff ff 	add    -0x10c4(%ecx,%eax,4),%esi
  800342:	ff e6                	jmp    *%esi

00800344 <.L68>:
  800344:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800347:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80034b:	eb d2                	jmp    80031f <vprintfmt+0x70>

0080034d <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800350:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800354:	eb c9                	jmp    80031f <vprintfmt+0x70>

00800356 <.L31>:
  800356:	0f b6 d2             	movzbl %dl,%edx
  800359:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80035c:	b8 00 00 00 00       	mov    $0x0,%eax
  800361:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800364:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800367:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036b:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80036e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800371:	83 f9 09             	cmp    $0x9,%ecx
  800374:	77 58                	ja     8003ce <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800376:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800379:	eb e9                	jmp    800364 <.L31+0xe>

0080037b <.L34>:
			precision = va_arg(ap, int);
  80037b:	8b 45 14             	mov    0x14(%ebp),%eax
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800383:	8b 45 14             	mov    0x14(%ebp),%eax
  800386:	8d 40 04             	lea    0x4(%eax),%eax
  800389:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  80038f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800393:	79 8a                	jns    80031f <vprintfmt+0x70>
				width = precision, precision = -1;
  800395:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800398:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80039b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a2:	e9 78 ff ff ff       	jmp    80031f <vprintfmt+0x70>

008003a7 <.L33>:
  8003a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003aa:	85 d2                	test   %edx,%edx
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b1:	0f 49 c2             	cmovns %edx,%eax
  8003b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003ba:	e9 60 ff ff ff       	jmp    80031f <vprintfmt+0x70>

008003bf <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c9:	e9 51 ff ff ff       	jmp    80031f <vprintfmt+0x70>
  8003ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d1:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d4:	eb b9                	jmp    80038f <.L34+0x14>

008003d6 <.L27>:
			lflag++;
  8003d6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003dd:	e9 3d ff ff ff       	jmp    80031f <vprintfmt+0x70>

008003e2 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8d 58 04             	lea    0x4(%eax),%ebx
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	57                   	push   %edi
  8003ef:	ff 30                	push   (%eax)
  8003f1:	ff d6                	call   *%esi
			break;
  8003f3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f6:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8003f9:	e9 c8 02 00 00       	jmp    8006c6 <.L25+0x45>

008003fe <.L28>:
			err = va_arg(ap, int);
  8003fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 58 04             	lea    0x4(%eax),%ebx
  800407:	8b 10                	mov    (%eax),%edx
  800409:	89 d0                	mov    %edx,%eax
  80040b:	f7 d8                	neg    %eax
  80040d:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800410:	83 f8 06             	cmp    $0x6,%eax
  800413:	7f 27                	jg     80043c <.L28+0x3e>
  800415:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800418:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 1d                	je     80043c <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800423:	8d 80 cd ee ff ff    	lea    -0x1133(%eax),%eax
  800429:	50                   	push   %eax
  80042a:	57                   	push   %edi
  80042b:	56                   	push   %esi
  80042c:	e8 61 fe ff ff       	call   800292 <printfmt>
  800431:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800434:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800437:	e9 8a 02 00 00       	jmp    8006c6 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80043c:	50                   	push   %eax
  80043d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800440:	8d 80 c4 ee ff ff    	lea    -0x113c(%eax),%eax
  800446:	50                   	push   %eax
  800447:	57                   	push   %edi
  800448:	56                   	push   %esi
  800449:	e8 44 fe ff ff       	call   800292 <printfmt>
  80044e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800451:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800454:	e9 6d 02 00 00       	jmp    8006c6 <.L25+0x45>

00800459 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  800459:	8b 75 08             	mov    0x8(%ebp),%esi
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	83 c0 04             	add    $0x4,%eax
  800462:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80046a:	85 d2                	test   %edx,%edx
  80046c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046f:	8d 80 bd ee ff ff    	lea    -0x1143(%eax),%eax
  800475:	0f 45 c2             	cmovne %edx,%eax
  800478:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80047f:	7e 06                	jle    800487 <.L24+0x2e>
  800481:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800485:	75 0d                	jne    800494 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048a:	89 c3                	mov    %eax,%ebx
  80048c:	03 45 d4             	add    -0x2c(%ebp),%eax
  80048f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800492:	eb 58                	jmp    8004ec <.L24+0x93>
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	ff 75 d8             	push   -0x28(%ebp)
  80049a:	ff 75 c8             	push   -0x38(%ebp)
  80049d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a0:	e8 47 03 00 00       	call   8007ec <strnlen>
  8004a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004a8:	29 c2                	sub    %eax,%edx
  8004aa:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004b2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	eb 0f                	jmp    8004ca <.L24+0x71>
					putch(padc, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	57                   	push   %edi
  8004bf:	ff 75 d4             	push   -0x2c(%ebp)
  8004c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	83 eb 01             	sub    $0x1,%ebx
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	7f ed                	jg     8004bb <.L24+0x62>
  8004ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004d1:	85 d2                	test   %edx,%edx
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	0f 49 c2             	cmovns %edx,%eax
  8004db:	29 c2                	sub    %eax,%edx
  8004dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e0:	eb a5                	jmp    800487 <.L24+0x2e>
					putch(ch, putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	57                   	push   %edi
  8004e6:	52                   	push   %edx
  8004e7:	ff d6                	call   *%esi
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ef:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f1:	83 c3 01             	add    $0x1,%ebx
  8004f4:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8004f8:	0f be d0             	movsbl %al,%edx
  8004fb:	85 d2                	test   %edx,%edx
  8004fd:	74 4b                	je     80054a <.L24+0xf1>
  8004ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800503:	78 06                	js     80050b <.L24+0xb2>
  800505:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800509:	78 1e                	js     800529 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  80050b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80050f:	74 d1                	je     8004e2 <.L24+0x89>
  800511:	0f be c0             	movsbl %al,%eax
  800514:	83 e8 20             	sub    $0x20,%eax
  800517:	83 f8 5e             	cmp    $0x5e,%eax
  80051a:	76 c6                	jbe    8004e2 <.L24+0x89>
					putch('?', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	57                   	push   %edi
  800520:	6a 3f                	push   $0x3f
  800522:	ff d6                	call   *%esi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	eb c3                	jmp    8004ec <.L24+0x93>
  800529:	89 cb                	mov    %ecx,%ebx
  80052b:	eb 0e                	jmp    80053b <.L24+0xe2>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	57                   	push   %edi
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 eb 01             	sub    $0x1,%ebx
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 db                	test   %ebx,%ebx
  80053d:	7f ee                	jg     80052d <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 7c 01 00 00       	jmp    8006c6 <.L25+0x45>
  80054a:	89 cb                	mov    %ecx,%ebx
  80054c:	eb ed                	jmp    80053b <.L24+0xe2>

0080054e <.L29>:
	if (lflag >= 2)
  80054e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800551:	8b 75 08             	mov    0x8(%ebp),%esi
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7f 1b                	jg     800574 <.L29+0x26>
	else if (lflag)
  800559:	85 c9                	test   %ecx,%ecx
  80055b:	74 63                	je     8005c0 <.L29+0x72>
		return va_arg(*ap, long);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	99                   	cltd   
  800566:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb 17                	jmp    80058b <.L29+0x3d>
		return va_arg(*ap, long long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 50 04             	mov    0x4(%eax),%edx
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8d 40 08             	lea    0x8(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80058b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80058e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800591:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  800596:	85 db                	test   %ebx,%ebx
  800598:	0f 89 0e 01 00 00    	jns    8006ac <.L25+0x2b>
				putch('-', putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	57                   	push   %edi
  8005a2:	6a 2d                	push   $0x2d
  8005a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005a9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005ac:	f7 d9                	neg    %ecx
  8005ae:	83 d3 00             	adc    $0x0,%ebx
  8005b1:	f7 db                	neg    %ebx
  8005b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005bb:	e9 ec 00 00 00       	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, int);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c8:	99                   	cltd   
  8005c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8d 40 04             	lea    0x4(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d5:	eb b4                	jmp    80058b <.L29+0x3d>

008005d7 <.L23>:
	if (lflag >= 2)
  8005d7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005da:	8b 75 08             	mov    0x8(%ebp),%esi
  8005dd:	83 f9 01             	cmp    $0x1,%ecx
  8005e0:	7f 1e                	jg     800600 <.L23+0x29>
	else if (lflag)
  8005e2:	85 c9                	test   %ecx,%ecx
  8005e4:	74 32                	je     800618 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8b 08                	mov    (%eax),%ecx
  8005eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f6:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8005fb:	e9 ac 00 00 00       	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 08                	mov    (%eax),%ecx
  800605:	8b 58 04             	mov    0x4(%eax),%ebx
  800608:	8d 40 08             	lea    0x8(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060e:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  800613:	e9 94 00 00 00       	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 08                	mov    (%eax),%ecx
  80061d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  80062d:	eb 7d                	jmp    8006ac <.L25+0x2b>

0080062f <.L26>:
	if (lflag >= 2)
  80062f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800632:	8b 75 08             	mov    0x8(%ebp),%esi
  800635:	83 f9 01             	cmp    $0x1,%ecx
  800638:	7f 1b                	jg     800655 <.L26+0x26>
	else if (lflag)
  80063a:	85 c9                	test   %ecx,%ecx
  80063c:	74 2c                	je     80066a <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 08                	mov    (%eax),%ecx
  800643:	bb 00 00 00 00       	mov    $0x0,%ebx
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064e:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800653:	eb 57                	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 08                	mov    (%eax),%ecx
  80065a:	8b 58 04             	mov    0x4(%eax),%ebx
  80065d:	8d 40 08             	lea    0x8(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800663:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  800668:	eb 42                	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 08                	mov    (%eax),%ecx
  80066f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067a:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  80067f:	eb 2b                	jmp    8006ac <.L25+0x2b>

00800681 <.L25>:
			putch('0', putdat);
  800681:	8b 75 08             	mov    0x8(%ebp),%esi
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	57                   	push   %edi
  800688:	6a 30                	push   $0x30
  80068a:	ff d6                	call   *%esi
			putch('x', putdat);
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	57                   	push   %edi
  800690:	6a 78                	push   $0x78
  800692:	ff d6                	call   *%esi
			num = (unsigned long long)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 08                	mov    (%eax),%ecx
  800699:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  80069e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a7:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006ac:	83 ec 0c             	sub    $0xc,%esp
  8006af:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006b3:	50                   	push   %eax
  8006b4:	ff 75 d4             	push   -0x2c(%ebp)
  8006b7:	52                   	push   %edx
  8006b8:	53                   	push   %ebx
  8006b9:	51                   	push   %ecx
  8006ba:	89 fa                	mov    %edi,%edx
  8006bc:	89 f0                	mov    %esi,%eax
  8006be:	e8 f4 fa ff ff       	call   8001b7 <printnum>
			break;
  8006c3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c9:	e9 15 fc ff ff       	jmp    8002e3 <vprintfmt+0x34>

008006ce <.L21>:
	if (lflag >= 2)
  8006ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7f 1b                	jg     8006f4 <.L21+0x26>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	74 2c                	je     800709 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 08                	mov    (%eax),%ecx
  8006e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8006f2:	eb b8                	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 08                	mov    (%eax),%ecx
  8006f9:	8b 58 04             	mov    0x4(%eax),%ebx
  8006fc:	8d 40 08             	lea    0x8(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  800707:	eb a3                	jmp    8006ac <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 08                	mov    (%eax),%ecx
  80070e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800719:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  80071e:	eb 8c                	jmp    8006ac <.L25+0x2b>

00800720 <.L35>:
			putch(ch, putdat);
  800720:	8b 75 08             	mov    0x8(%ebp),%esi
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	57                   	push   %edi
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			break;
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	eb 96                	jmp    8006c6 <.L25+0x45>

00800730 <.L20>:
			putch('%', putdat);
  800730:	8b 75 08             	mov    0x8(%ebp),%esi
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	57                   	push   %edi
  800737:	6a 25                	push   $0x25
  800739:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	89 d8                	mov    %ebx,%eax
  800740:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800744:	74 05                	je     80074b <.L20+0x1b>
  800746:	83 e8 01             	sub    $0x1,%eax
  800749:	eb f5                	jmp    800740 <.L20+0x10>
  80074b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074e:	e9 73 ff ff ff       	jmp    8006c6 <.L25+0x45>

00800753 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	53                   	push   %ebx
  800757:	83 ec 14             	sub    $0x14,%esp
  80075a:	e8 12 f9 ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  80075f:	81 c3 a1 18 00 00    	add    $0x18a1,%ebx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80076e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800772:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800775:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077c:	85 c0                	test   %eax,%eax
  80077e:	74 2b                	je     8007ab <vsnprintf+0x58>
  800780:	85 d2                	test   %edx,%edx
  800782:	7e 27                	jle    8007ab <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800784:	ff 75 14             	push   0x14(%ebp)
  800787:	ff 75 10             	push   0x10(%ebp)
  80078a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078d:	50                   	push   %eax
  80078e:	8d 83 75 e2 ff ff    	lea    -0x1d8b(%ebx),%eax
  800794:	50                   	push   %eax
  800795:	e8 15 fb ff ff       	call   8002af <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
}
  8007a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    
		return -E_INVAL;
  8007ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b0:	eb f4                	jmp    8007a6 <vsnprintf+0x53>

008007b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007bb:	50                   	push   %eax
  8007bc:	ff 75 10             	push   0x10(%ebp)
  8007bf:	ff 75 0c             	push   0xc(%ebp)
  8007c2:	ff 75 08             	push   0x8(%ebp)
  8007c5:	e8 89 ff ff ff       	call   800753 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <__x86.get_pc_thunk.ax>:
  8007cc:	8b 04 24             	mov    (%esp),%eax
  8007cf:	c3                   	ret    

008007d0 <__x86.get_pc_thunk.cx>:
  8007d0:	8b 0c 24             	mov    (%esp),%ecx
  8007d3:	c3                   	ret    

008007d4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 03                	jmp    8007e4 <strlen+0x10>
		n++;
  8007e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e8:	75 f7                	jne    8007e1 <strlen+0xd>
	return n;
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fa:	eb 03                	jmp    8007ff <strnlen+0x13>
		n++;
  8007fc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ff:	39 d0                	cmp    %edx,%eax
  800801:	74 08                	je     80080b <strnlen+0x1f>
  800803:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800807:	75 f3                	jne    8007fc <strnlen+0x10>
  800809:	89 c2                	mov    %eax,%edx
	return n;
}
  80080b:	89 d0                	mov    %edx,%eax
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	53                   	push   %ebx
  800813:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800816:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800819:	b8 00 00 00 00       	mov    $0x0,%eax
  80081e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800822:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800825:	83 c0 01             	add    $0x1,%eax
  800828:	84 d2                	test   %dl,%dl
  80082a:	75 f2                	jne    80081e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80082c:	89 c8                	mov    %ecx,%eax
  80082e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800831:	c9                   	leave  
  800832:	c3                   	ret    

00800833 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	83 ec 10             	sub    $0x10,%esp
  80083a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80083d:	53                   	push   %ebx
  80083e:	e8 91 ff ff ff       	call   8007d4 <strlen>
  800843:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800846:	ff 75 0c             	push   0xc(%ebp)
  800849:	01 d8                	add    %ebx,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 be ff ff ff       	call   80080f <strcpy>
	return dst;
}
  800851:	89 d8                	mov    %ebx,%eax
  800853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800856:	c9                   	leave  
  800857:	c3                   	ret    

00800858 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	56                   	push   %esi
  80085c:	53                   	push   %ebx
  80085d:	8b 75 08             	mov    0x8(%ebp),%esi
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
  800863:	89 f3                	mov    %esi,%ebx
  800865:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800868:	89 f0                	mov    %esi,%eax
  80086a:	eb 0f                	jmp    80087b <strncpy+0x23>
		*dst++ = *src;
  80086c:	83 c0 01             	add    $0x1,%eax
  80086f:	0f b6 0a             	movzbl (%edx),%ecx
  800872:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800875:	80 f9 01             	cmp    $0x1,%cl
  800878:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80087b:	39 d8                	cmp    %ebx,%eax
  80087d:	75 ed                	jne    80086c <strncpy+0x14>
	}
	return ret;
}
  80087f:	89 f0                	mov    %esi,%eax
  800881:	5b                   	pop    %ebx
  800882:	5e                   	pop    %esi
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	56                   	push   %esi
  800889:	53                   	push   %ebx
  80088a:	8b 75 08             	mov    0x8(%ebp),%esi
  80088d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800890:	8b 55 10             	mov    0x10(%ebp),%edx
  800893:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800895:	85 d2                	test   %edx,%edx
  800897:	74 21                	je     8008ba <strlcpy+0x35>
  800899:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80089d:	89 f2                	mov    %esi,%edx
  80089f:	eb 09                	jmp    8008aa <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
  8008a7:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 09                	je     8008b7 <strlcpy+0x32>
  8008ae:	0f b6 19             	movzbl (%ecx),%ebx
  8008b1:	84 db                	test   %bl,%bl
  8008b3:	75 ec                	jne    8008a1 <strlcpy+0x1c>
  8008b5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ba:	29 f0                	sub    %esi,%eax
}
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c9:	eb 06                	jmp    8008d1 <strcmp+0x11>
		p++, q++;
  8008cb:	83 c1 01             	add    $0x1,%ecx
  8008ce:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d1:	0f b6 01             	movzbl (%ecx),%eax
  8008d4:	84 c0                	test   %al,%al
  8008d6:	74 04                	je     8008dc <strcmp+0x1c>
  8008d8:	3a 02                	cmp    (%edx),%al
  8008da:	74 ef                	je     8008cb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dc:	0f b6 c0             	movzbl %al,%eax
  8008df:	0f b6 12             	movzbl (%edx),%edx
  8008e2:	29 d0                	sub    %edx,%eax
}
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	53                   	push   %ebx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f0:	89 c3                	mov    %eax,%ebx
  8008f2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f5:	eb 06                	jmp    8008fd <strncmp+0x17>
		n--, p++, q++;
  8008f7:	83 c0 01             	add    $0x1,%eax
  8008fa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008fd:	39 d8                	cmp    %ebx,%eax
  8008ff:	74 18                	je     800919 <strncmp+0x33>
  800901:	0f b6 08             	movzbl (%eax),%ecx
  800904:	84 c9                	test   %cl,%cl
  800906:	74 04                	je     80090c <strncmp+0x26>
  800908:	3a 0a                	cmp    (%edx),%cl
  80090a:	74 eb                	je     8008f7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090c:	0f b6 00             	movzbl (%eax),%eax
  80090f:	0f b6 12             	movzbl (%edx),%edx
  800912:	29 d0                	sub    %edx,%eax
}
  800914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800917:	c9                   	leave  
  800918:	c3                   	ret    
		return 0;
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
  80091e:	eb f4                	jmp    800914 <strncmp+0x2e>

00800920 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092a:	eb 03                	jmp    80092f <strchr+0xf>
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	0f b6 10             	movzbl (%eax),%edx
  800932:	84 d2                	test   %dl,%dl
  800934:	74 06                	je     80093c <strchr+0x1c>
		if (*s == c)
  800936:	38 ca                	cmp    %cl,%dl
  800938:	75 f2                	jne    80092c <strchr+0xc>
  80093a:	eb 05                	jmp    800941 <strchr+0x21>
			return (char *) s;
	return 0;
  80093c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 09                	je     80095d <strfind+0x1a>
  800954:	84 d2                	test   %dl,%dl
  800956:	74 05                	je     80095d <strfind+0x1a>
	for (; *s; s++)
  800958:	83 c0 01             	add    $0x1,%eax
  80095b:	eb f0                	jmp    80094d <strfind+0xa>
			break;
	return (char *) s;
}
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	57                   	push   %edi
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	8b 7d 08             	mov    0x8(%ebp),%edi
  800968:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096b:	85 c9                	test   %ecx,%ecx
  80096d:	74 2f                	je     80099e <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096f:	89 f8                	mov    %edi,%eax
  800971:	09 c8                	or     %ecx,%eax
  800973:	a8 03                	test   $0x3,%al
  800975:	75 21                	jne    800998 <memset+0x39>
		c &= 0xFF;
  800977:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097b:	89 d0                	mov    %edx,%eax
  80097d:	c1 e0 08             	shl    $0x8,%eax
  800980:	89 d3                	mov    %edx,%ebx
  800982:	c1 e3 18             	shl    $0x18,%ebx
  800985:	89 d6                	mov    %edx,%esi
  800987:	c1 e6 10             	shl    $0x10,%esi
  80098a:	09 f3                	or     %esi,%ebx
  80098c:	09 da                	or     %ebx,%edx
  80098e:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800990:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800993:	fc                   	cld    
  800994:	f3 ab                	rep stos %eax,%es:(%edi)
  800996:	eb 06                	jmp    80099e <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	fc                   	cld    
  80099c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099e:	89 f8                	mov    %edi,%eax
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5f                   	pop    %edi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	57                   	push   %edi
  8009a9:	56                   	push   %esi
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b3:	39 c6                	cmp    %eax,%esi
  8009b5:	73 32                	jae    8009e9 <memmove+0x44>
  8009b7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ba:	39 c2                	cmp    %eax,%edx
  8009bc:	76 2b                	jbe    8009e9 <memmove+0x44>
		s += n;
		d += n;
  8009be:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c1:	89 d6                	mov    %edx,%esi
  8009c3:	09 fe                	or     %edi,%esi
  8009c5:	09 ce                	or     %ecx,%esi
  8009c7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009cd:	75 0e                	jne    8009dd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009cf:	83 ef 04             	sub    $0x4,%edi
  8009d2:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009d8:	fd                   	std    
  8009d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009db:	eb 09                	jmp    8009e6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009dd:	83 ef 01             	sub    $0x1,%edi
  8009e0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e3:	fd                   	std    
  8009e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e6:	fc                   	cld    
  8009e7:	eb 1a                	jmp    800a03 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e9:	89 f2                	mov    %esi,%edx
  8009eb:	09 c2                	or     %eax,%edx
  8009ed:	09 ca                	or     %ecx,%edx
  8009ef:	f6 c2 03             	test   $0x3,%dl
  8009f2:	75 0a                	jne    8009fe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009f7:	89 c7                	mov    %eax,%edi
  8009f9:	fc                   	cld    
  8009fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fc:	eb 05                	jmp    800a03 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009fe:	89 c7                	mov    %eax,%edi
  800a00:	fc                   	cld    
  800a01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a03:	5e                   	pop    %esi
  800a04:	5f                   	pop    %edi
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a0d:	ff 75 10             	push   0x10(%ebp)
  800a10:	ff 75 0c             	push   0xc(%ebp)
  800a13:	ff 75 08             	push   0x8(%ebp)
  800a16:	e8 8a ff ff ff       	call   8009a5 <memmove>
}
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	89 c6                	mov    %eax,%esi
  800a2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2d:	eb 06                	jmp    800a35 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a2f:	83 c0 01             	add    $0x1,%eax
  800a32:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a35:	39 f0                	cmp    %esi,%eax
  800a37:	74 14                	je     800a4d <memcmp+0x30>
		if (*s1 != *s2)
  800a39:	0f b6 08             	movzbl (%eax),%ecx
  800a3c:	0f b6 1a             	movzbl (%edx),%ebx
  800a3f:	38 d9                	cmp    %bl,%cl
  800a41:	74 ec                	je     800a2f <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a43:	0f b6 c1             	movzbl %cl,%eax
  800a46:	0f b6 db             	movzbl %bl,%ebx
  800a49:	29 d8                	sub    %ebx,%eax
  800a4b:	eb 05                	jmp    800a52 <memcmp+0x35>
	}

	return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5f:	89 c2                	mov    %eax,%edx
  800a61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a64:	eb 03                	jmp    800a69 <memfind+0x13>
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	39 d0                	cmp    %edx,%eax
  800a6b:	73 04                	jae    800a71 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a6d:	38 08                	cmp    %cl,(%eax)
  800a6f:	75 f5                	jne    800a66 <memfind+0x10>
			break;
	return (void *) s;
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7f:	eb 03                	jmp    800a84 <strtol+0x11>
		s++;
  800a81:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a84:	0f b6 02             	movzbl (%edx),%eax
  800a87:	3c 20                	cmp    $0x20,%al
  800a89:	74 f6                	je     800a81 <strtol+0xe>
  800a8b:	3c 09                	cmp    $0x9,%al
  800a8d:	74 f2                	je     800a81 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a8f:	3c 2b                	cmp    $0x2b,%al
  800a91:	74 2a                	je     800abd <strtol+0x4a>
	int neg = 0;
  800a93:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a98:	3c 2d                	cmp    $0x2d,%al
  800a9a:	74 2b                	je     800ac7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa2:	75 0f                	jne    800ab3 <strtol+0x40>
  800aa4:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa7:	74 28                	je     800ad1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa9:	85 db                	test   %ebx,%ebx
  800aab:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab0:	0f 44 d8             	cmove  %eax,%ebx
  800ab3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abb:	eb 46                	jmp    800b03 <strtol+0x90>
		s++;
  800abd:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac5:	eb d5                	jmp    800a9c <strtol+0x29>
		s++, neg = 1;
  800ac7:	83 c2 01             	add    $0x1,%edx
  800aca:	bf 01 00 00 00       	mov    $0x1,%edi
  800acf:	eb cb                	jmp    800a9c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad1:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ad5:	74 0e                	je     800ae5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	75 d8                	jne    800ab3 <strtol+0x40>
		s++, base = 8;
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae3:	eb ce                	jmp    800ab3 <strtol+0x40>
		s += 2, base = 16;
  800ae5:	83 c2 02             	add    $0x2,%edx
  800ae8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aed:	eb c4                	jmp    800ab3 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aef:	0f be c0             	movsbl %al,%eax
  800af2:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800af8:	7d 3a                	jge    800b34 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800afa:	83 c2 01             	add    $0x1,%edx
  800afd:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800b01:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800b03:	0f b6 02             	movzbl (%edx),%eax
  800b06:	8d 70 d0             	lea    -0x30(%eax),%esi
  800b09:	89 f3                	mov    %esi,%ebx
  800b0b:	80 fb 09             	cmp    $0x9,%bl
  800b0e:	76 df                	jbe    800aef <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800b10:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b13:	89 f3                	mov    %esi,%ebx
  800b15:	80 fb 19             	cmp    $0x19,%bl
  800b18:	77 08                	ja     800b22 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b1a:	0f be c0             	movsbl %al,%eax
  800b1d:	83 e8 57             	sub    $0x57,%eax
  800b20:	eb d3                	jmp    800af5 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b22:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b25:	89 f3                	mov    %esi,%ebx
  800b27:	80 fb 19             	cmp    $0x19,%bl
  800b2a:	77 08                	ja     800b34 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b2c:	0f be c0             	movsbl %al,%eax
  800b2f:	83 e8 37             	sub    $0x37,%eax
  800b32:	eb c1                	jmp    800af5 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b38:	74 05                	je     800b3f <strtol+0xcc>
		*endptr = (char *) s;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b3f:	89 c8                	mov    %ecx,%eax
  800b41:	f7 d8                	neg    %eax
  800b43:	85 ff                	test   %edi,%edi
  800b45:	0f 45 c8             	cmovne %eax,%ecx
}
  800b48:	89 c8                	mov    %ecx,%eax
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	89 c3                	mov    %eax,%ebx
  800b62:	89 c7                	mov    %eax,%edi
  800b64:	89 c6                	mov    %eax,%esi
  800b66:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7d:	89 d1                	mov    %edx,%ecx
  800b7f:	89 d3                	mov    %edx,%ebx
  800b81:	89 d7                	mov    %edx,%edi
  800b83:	89 d6                	mov    %edx,%esi
  800b85:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b87:	5b                   	pop    %ebx
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	83 ec 1c             	sub    $0x1c,%esp
  800b95:	e8 32 fc ff ff       	call   8007cc <__x86.get_pc_thunk.ax>
  800b9a:	05 66 14 00 00       	add    $0x1466,%eax
  800b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800ba2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  800baa:	b8 03 00 00 00       	mov    $0x3,%eax
  800baf:	89 cb                	mov    %ecx,%ebx
  800bb1:	89 cf                	mov    %ecx,%edi
  800bb3:	89 ce                	mov    %ecx,%esi
  800bb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb7:	85 c0                	test   %eax,%eax
  800bb9:	7f 08                	jg     800bc3 <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc3:	83 ec 0c             	sub    $0xc,%esp
  800bc6:	50                   	push   %eax
  800bc7:	6a 03                	push   $0x3
  800bc9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800bcc:	8d 83 94 f0 ff ff    	lea    -0xf6c(%ebx),%eax
  800bd2:	50                   	push   %eax
  800bd3:	6a 23                	push   $0x23
  800bd5:	8d 83 b1 f0 ff ff    	lea    -0xf4f(%ebx),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 1f 00 00 00       	call   800c00 <_panic>

00800be1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bec:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf1:	89 d1                	mov    %edx,%ecx
  800bf3:	89 d3                	mov    %edx,%ebx
  800bf5:	89 d7                	mov    %edx,%edi
  800bf7:	89 d6                	mov    %edx,%esi
  800bf9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	83 ec 0c             	sub    $0xc,%esp
  800c09:	e8 63 f4 ff ff       	call   800071 <__x86.get_pc_thunk.bx>
  800c0e:	81 c3 f2 13 00 00    	add    $0x13f2,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c14:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c17:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c1d:	8b 38                	mov    (%eax),%edi
  800c1f:	e8 bd ff ff ff       	call   800be1 <sys_getenvid>
  800c24:	83 ec 0c             	sub    $0xc,%esp
  800c27:	ff 75 0c             	push   0xc(%ebp)
  800c2a:	ff 75 08             	push   0x8(%ebp)
  800c2d:	57                   	push   %edi
  800c2e:	50                   	push   %eax
  800c2f:	8d 83 c0 f0 ff ff    	lea    -0xf40(%ebx),%eax
  800c35:	50                   	push   %eax
  800c36:	e8 68 f5 ff ff       	call   8001a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c3b:	83 c4 18             	add    $0x18,%esp
  800c3e:	56                   	push   %esi
  800c3f:	ff 75 10             	push   0x10(%ebp)
  800c42:	e8 fa f4 ff ff       	call   800141 <vcprintf>
	cprintf("\n");
  800c47:	8d 83 a0 ee ff ff    	lea    -0x1160(%ebx),%eax
  800c4d:	89 04 24             	mov    %eax,(%esp)
  800c50:	e8 4e f5 ff ff       	call   8001a3 <cprintf>
  800c55:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c58:	cc                   	int3   
  800c59:	eb fd                	jmp    800c58 <_panic+0x58>
  800c5b:	66 90                	xchg   %ax,%ax
  800c5d:	66 90                	xchg   %ax,%ax
  800c5f:	90                   	nop

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
