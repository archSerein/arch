
obj/user/faultreadkernel:     file format elf32-i386


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
  80002c:	e8 32 00 00 00       	call   800063 <libmain>
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
  80003a:	e8 20 00 00 00       	call   80005f <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800045:	ff 35 00 00 10 f0    	push   0xf0100000
  80004b:	8d 83 84 ee ff ff    	lea    -0x117c(%ebx),%eax
  800051:	50                   	push   %eax
  800052:	e8 3a 01 00 00       	call   800191 <cprintf>
}
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <__x86.get_pc_thunk.bx>:
  80005f:	8b 1c 24             	mov    (%esp),%ebx
  800062:	c3                   	ret    

00800063 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	57                   	push   %edi
  800067:	56                   	push   %esi
  800068:	53                   	push   %ebx
  800069:	83 ec 0c             	sub    $0xc,%esp
  80006c:	e8 ee ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  800071:	81 c3 8f 1f 00 00    	add    $0x1f8f,%ebx
  800077:	8b 75 08             	mov    0x8(%ebp),%esi
  80007a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007d:	e8 4d 0b 00 00       	call   800bcf <sys_getenvid>
  800082:	25 ff 03 00 00       	and    $0x3ff,%eax
  800087:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80008a:	c1 e0 05             	shl    $0x5,%eax
  80008d:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800093:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800099:	85 f6                	test   %esi,%esi
  80009b:	7e 08                	jle    8000a5 <libmain+0x42>
		binaryname = argv[0];
  80009d:	8b 07                	mov    (%edi),%eax
  80009f:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	e8 84 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000af:	e8 0b 00 00 00       	call   8000bf <exit>
}
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ba:	5b                   	pop    %ebx
  8000bb:	5e                   	pop    %esi
  8000bc:	5f                   	pop    %edi
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	53                   	push   %ebx
  8000c3:	83 ec 10             	sub    $0x10,%esp
  8000c6:	e8 94 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  8000cb:	81 c3 35 1f 00 00    	add    $0x1f35,%ebx
	sys_env_destroy(0);
  8000d1:	6a 00                	push   $0x0
  8000d3:	e8 a2 0a 00 00       	call   800b7a <sys_env_destroy>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	e8 75 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  8000ea:	81 c3 16 1f 00 00    	add    $0x1f16,%ebx
  8000f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8000f3:	8b 16                	mov    (%esi),%edx
  8000f5:	8d 42 01             	lea    0x1(%edx),%eax
  8000f8:	89 06                	mov    %eax,(%esi)
  8000fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fd:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800101:	3d ff 00 00 00       	cmp    $0xff,%eax
  800106:	74 0b                	je     800113 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800108:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80010c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	68 ff 00 00 00       	push   $0xff
  80011b:	8d 46 08             	lea    0x8(%esi),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 19 0a 00 00       	call   800b3d <sys_cputs>
		b->idx = 0;
  800124:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	eb d9                	jmp    800108 <putch+0x28>

0080012f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	53                   	push   %ebx
  800133:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800139:	e8 21 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  80013e:	81 c3 c2 1e 00 00    	add    $0x1ec2,%ebx
	struct printbuf b;

	b.idx = 0;
  800144:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014b:	00 00 00 
	b.cnt = 0;
  80014e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800155:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800158:	ff 75 0c             	push   0xc(%ebp)
  80015b:	ff 75 08             	push   0x8(%ebp)
  80015e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	8d 83 e0 e0 ff ff    	lea    -0x1f20(%ebx),%eax
  80016b:	50                   	push   %eax
  80016c:	e8 2c 01 00 00       	call   80029d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  80017a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800180:	50                   	push   %eax
  800181:	e8 b7 09 00 00       	call   800b3d <sys_cputs>

	return b.cnt;
}
  800186:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	push   0x8(%ebp)
  80019e:	e8 8c ff ff ff       	call   80012f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 2c             	sub    $0x2c,%esp
  8001ae:	e8 0b 06 00 00       	call   8007be <__x86.get_pc_thunk.cx>
  8001b3:	81 c1 4d 1e 00 00    	add    $0x1e4d,%ecx
  8001b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	89 d6                	mov    %edx,%esi
  8001c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	89 c2                	mov    %eax,%edx
  8001ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e0:	39 c2                	cmp    %eax,%edx
  8001e2:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001e5:	72 41                	jb     800228 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 18             	push   0x18(%ebp)
  8001ed:	83 eb 01             	sub    $0x1,%ebx
  8001f0:	53                   	push   %ebx
  8001f1:	50                   	push   %eax
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 e4             	push   -0x1c(%ebp)
  8001f8:	ff 75 e0             	push   -0x20(%ebp)
  8001fb:	ff 75 d4             	push   -0x2c(%ebp)
  8001fe:	ff 75 d0             	push   -0x30(%ebp)
  800201:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800204:	e8 47 0a 00 00       	call   800c50 <__udivdi3>
  800209:	83 c4 18             	add    $0x18,%esp
  80020c:	52                   	push   %edx
  80020d:	50                   	push   %eax
  80020e:	89 f2                	mov    %esi,%edx
  800210:	89 f8                	mov    %edi,%eax
  800212:	e8 8e ff ff ff       	call   8001a5 <printnum>
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	eb 13                	jmp    80022f <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	56                   	push   %esi
  800220:	ff 75 18             	push   0x18(%ebp)
  800223:	ff d7                	call   *%edi
  800225:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800228:	83 eb 01             	sub    $0x1,%ebx
  80022b:	85 db                	test   %ebx,%ebx
  80022d:	7f ed                	jg     80021c <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	56                   	push   %esi
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	ff 75 e4             	push   -0x1c(%ebp)
  800239:	ff 75 e0             	push   -0x20(%ebp)
  80023c:	ff 75 d4             	push   -0x2c(%ebp)
  80023f:	ff 75 d0             	push   -0x30(%ebp)
  800242:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800245:	e8 26 0b 00 00       	call   800d70 <__umoddi3>
  80024a:	83 c4 14             	add    $0x14,%esp
  80024d:	0f be 84 03 b5 ee ff 	movsbl -0x114b(%ebx,%eax,1),%eax
  800254:	ff 
  800255:	50                   	push   %eax
  800256:	ff d7                	call   *%edi
}
  800258:	83 c4 10             	add    $0x10,%esp
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800269:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026d:	8b 10                	mov    (%eax),%edx
  80026f:	3b 50 04             	cmp    0x4(%eax),%edx
  800272:	73 0a                	jae    80027e <sprintputch+0x1b>
		*b->buf++ = ch;
  800274:	8d 4a 01             	lea    0x1(%edx),%ecx
  800277:	89 08                	mov    %ecx,(%eax)
  800279:	8b 45 08             	mov    0x8(%ebp),%eax
  80027c:	88 02                	mov    %al,(%edx)
}
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <printfmt>:
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800286:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 10             	push   0x10(%ebp)
  80028d:	ff 75 0c             	push   0xc(%ebp)
  800290:	ff 75 08             	push   0x8(%ebp)
  800293:	e8 05 00 00 00       	call   80029d <vprintfmt>
}
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <vprintfmt>:
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 3c             	sub    $0x3c,%esp
  8002a6:	e8 0f 05 00 00       	call   8007ba <__x86.get_pc_thunk.ax>
  8002ab:	05 55 1d 00 00       	add    $0x1d55,%eax
  8002b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002bc:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8002c5:	eb 0a                	jmp    8002d1 <vprintfmt+0x34>
			putch(ch, putdat);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	57                   	push   %edi
  8002cb:	50                   	push   %eax
  8002cc:	ff d6                	call   *%esi
  8002ce:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002d1:	83 c3 01             	add    $0x1,%ebx
  8002d4:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8002d8:	83 f8 25             	cmp    $0x25,%eax
  8002db:	74 0c                	je     8002e9 <vprintfmt+0x4c>
			if (ch == '\0')
  8002dd:	85 c0                	test   %eax,%eax
  8002df:	75 e6                	jne    8002c7 <vprintfmt+0x2a>
}
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
		padc = ' ';
  8002e9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8002ed:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fb:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80030a:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8d 43 01             	lea    0x1(%ebx),%eax
  800310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800313:	0f b6 13             	movzbl (%ebx),%edx
  800316:	8d 42 dd             	lea    -0x23(%edx),%eax
  800319:	3c 55                	cmp    $0x55,%al
  80031b:	0f 87 fd 03 00 00    	ja     80071e <.L20>
  800321:	0f b6 c0             	movzbl %al,%eax
  800324:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800327:	89 ce                	mov    %ecx,%esi
  800329:	03 b4 81 44 ef ff ff 	add    -0x10bc(%ecx,%eax,4),%esi
  800330:	ff e6                	jmp    *%esi

00800332 <.L68>:
  800332:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800335:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800339:	eb d2                	jmp    80030d <vprintfmt+0x70>

0080033b <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80033b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80033e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800342:	eb c9                	jmp    80030d <vprintfmt+0x70>

00800344 <.L31>:
  800344:	0f b6 d2             	movzbl %dl,%edx
  800347:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80034a:	b8 00 00 00 00       	mov    $0x0,%eax
  80034f:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800352:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800355:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800359:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80035c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80035f:	83 f9 09             	cmp    $0x9,%ecx
  800362:	77 58                	ja     8003bc <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800364:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800367:	eb e9                	jmp    800352 <.L31+0xe>

00800369 <.L34>:
			precision = va_arg(ap, int);
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	8b 00                	mov    (%eax),%eax
  80036e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800371:	8b 45 14             	mov    0x14(%ebp),%eax
  800374:	8d 40 04             	lea    0x4(%eax),%eax
  800377:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  80037d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800381:	79 8a                	jns    80030d <vprintfmt+0x70>
				width = precision, precision = -1;
  800383:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800386:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800389:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800390:	e9 78 ff ff ff       	jmp    80030d <vprintfmt+0x70>

00800395 <.L33>:
  800395:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800398:	85 d2                	test   %edx,%edx
  80039a:	b8 00 00 00 00       	mov    $0x0,%eax
  80039f:	0f 49 c2             	cmovns %edx,%eax
  8003a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003a8:	e9 60 ff ff ff       	jmp    80030d <vprintfmt+0x70>

008003ad <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003b0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b7:	e9 51 ff ff ff       	jmp    80030d <vprintfmt+0x70>
  8003bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bf:	89 75 08             	mov    %esi,0x8(%ebp)
  8003c2:	eb b9                	jmp    80037d <.L34+0x14>

008003c4 <.L27>:
			lflag++;
  8003c4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003cb:	e9 3d ff ff ff       	jmp    80030d <vprintfmt+0x70>

008003d0 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8d 58 04             	lea    0x4(%eax),%ebx
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	57                   	push   %edi
  8003dd:	ff 30                	push   (%eax)
  8003df:	ff d6                	call   *%esi
			break;
  8003e1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e4:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8003e7:	e9 c8 02 00 00       	jmp    8006b4 <.L25+0x45>

008003ec <.L28>:
			err = va_arg(ap, int);
  8003ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 58 04             	lea    0x4(%eax),%ebx
  8003f5:	8b 10                	mov    (%eax),%edx
  8003f7:	89 d0                	mov    %edx,%eax
  8003f9:	f7 d8                	neg    %eax
  8003fb:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fe:	83 f8 06             	cmp    $0x6,%eax
  800401:	7f 27                	jg     80042a <.L28+0x3e>
  800403:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800406:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800409:	85 d2                	test   %edx,%edx
  80040b:	74 1d                	je     80042a <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  80040d:	52                   	push   %edx
  80040e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800411:	8d 80 d6 ee ff ff    	lea    -0x112a(%eax),%eax
  800417:	50                   	push   %eax
  800418:	57                   	push   %edi
  800419:	56                   	push   %esi
  80041a:	e8 61 fe ff ff       	call   800280 <printfmt>
  80041f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800422:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800425:	e9 8a 02 00 00       	jmp    8006b4 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80042a:	50                   	push   %eax
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	8d 80 cd ee ff ff    	lea    -0x1133(%eax),%eax
  800434:	50                   	push   %eax
  800435:	57                   	push   %edi
  800436:	56                   	push   %esi
  800437:	e8 44 fe ff ff       	call   800280 <printfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043f:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800442:	e9 6d 02 00 00       	jmp    8006b4 <.L25+0x45>

00800447 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  800447:	8b 75 08             	mov    0x8(%ebp),%esi
  80044a:	8b 45 14             	mov    0x14(%ebp),%eax
  80044d:	83 c0 04             	add    $0x4,%eax
  800450:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800458:	85 d2                	test   %edx,%edx
  80045a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045d:	8d 80 c6 ee ff ff    	lea    -0x113a(%eax),%eax
  800463:	0f 45 c2             	cmovne %edx,%eax
  800466:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800469:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046d:	7e 06                	jle    800475 <.L24+0x2e>
  80046f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800473:	75 0d                	jne    800482 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800478:	89 c3                	mov    %eax,%ebx
  80047a:	03 45 d4             	add    -0x2c(%ebp),%eax
  80047d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800480:	eb 58                	jmp    8004da <.L24+0x93>
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	ff 75 d8             	push   -0x28(%ebp)
  800488:	ff 75 c8             	push   -0x38(%ebp)
  80048b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048e:	e8 47 03 00 00       	call   8007da <strnlen>
  800493:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800496:	29 c2                	sub    %eax,%edx
  800498:	89 55 bc             	mov    %edx,-0x44(%ebp)
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004a0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a7:	eb 0f                	jmp    8004b8 <.L24+0x71>
					putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	57                   	push   %edi
  8004ad:	ff 75 d4             	push   -0x2c(%ebp)
  8004b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	83 eb 01             	sub    $0x1,%ebx
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	85 db                	test   %ebx,%ebx
  8004ba:	7f ed                	jg     8004a9 <.L24+0x62>
  8004bc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004bf:	85 d2                	test   %edx,%edx
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	0f 49 c2             	cmovns %edx,%eax
  8004c9:	29 c2                	sub    %eax,%edx
  8004cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004ce:	eb a5                	jmp    800475 <.L24+0x2e>
					putch(ch, putdat);
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	57                   	push   %edi
  8004d4:	52                   	push   %edx
  8004d5:	ff d6                	call   *%esi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004dd:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004df:	83 c3 01             	add    $0x1,%ebx
  8004e2:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8004e6:	0f be d0             	movsbl %al,%edx
  8004e9:	85 d2                	test   %edx,%edx
  8004eb:	74 4b                	je     800538 <.L24+0xf1>
  8004ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f1:	78 06                	js     8004f9 <.L24+0xb2>
  8004f3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f7:	78 1e                	js     800517 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004fd:	74 d1                	je     8004d0 <.L24+0x89>
  8004ff:	0f be c0             	movsbl %al,%eax
  800502:	83 e8 20             	sub    $0x20,%eax
  800505:	83 f8 5e             	cmp    $0x5e,%eax
  800508:	76 c6                	jbe    8004d0 <.L24+0x89>
					putch('?', putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	57                   	push   %edi
  80050e:	6a 3f                	push   $0x3f
  800510:	ff d6                	call   *%esi
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	eb c3                	jmp    8004da <.L24+0x93>
  800517:	89 cb                	mov    %ecx,%ebx
  800519:	eb 0e                	jmp    800529 <.L24+0xe2>
				putch(' ', putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	57                   	push   %edi
  80051f:	6a 20                	push   $0x20
  800521:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800523:	83 eb 01             	sub    $0x1,%ebx
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	85 db                	test   %ebx,%ebx
  80052b:	7f ee                	jg     80051b <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80052d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800530:	89 45 14             	mov    %eax,0x14(%ebp)
  800533:	e9 7c 01 00 00       	jmp    8006b4 <.L25+0x45>
  800538:	89 cb                	mov    %ecx,%ebx
  80053a:	eb ed                	jmp    800529 <.L24+0xe2>

0080053c <.L29>:
	if (lflag >= 2)
  80053c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80053f:	8b 75 08             	mov    0x8(%ebp),%esi
  800542:	83 f9 01             	cmp    $0x1,%ecx
  800545:	7f 1b                	jg     800562 <.L29+0x26>
	else if (lflag)
  800547:	85 c9                	test   %ecx,%ecx
  800549:	74 63                	je     8005ae <.L29+0x72>
		return va_arg(*ap, long);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800553:	99                   	cltd   
  800554:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
  800560:	eb 17                	jmp    800579 <.L29+0x3d>
		return va_arg(*ap, long long);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 50 04             	mov    0x4(%eax),%edx
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 40 08             	lea    0x8(%eax),%eax
  800576:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800579:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80057c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  80057f:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  800584:	85 db                	test   %ebx,%ebx
  800586:	0f 89 0e 01 00 00    	jns    80069a <.L25+0x2b>
				putch('-', putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	57                   	push   %edi
  800590:	6a 2d                	push   $0x2d
  800592:	ff d6                	call   *%esi
				num = -(long long) num;
  800594:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800597:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80059a:	f7 d9                	neg    %ecx
  80059c:	83 d3 00             	adc    $0x0,%ebx
  80059f:	f7 db                	neg    %ebx
  8005a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a9:	e9 ec 00 00 00       	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	99                   	cltd   
  8005b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	eb b4                	jmp    800579 <.L29+0x3d>

008005c5 <.L23>:
	if (lflag >= 2)
  8005c5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cb:	83 f9 01             	cmp    $0x1,%ecx
  8005ce:	7f 1e                	jg     8005ee <.L23+0x29>
	else if (lflag)
  8005d0:	85 c9                	test   %ecx,%ecx
  8005d2:	74 32                	je     800606 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 08                	mov    (%eax),%ecx
  8005d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005de:	8d 40 04             	lea    0x4(%eax),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e4:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8005e9:	e9 ac 00 00 00       	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 08                	mov    (%eax),%ecx
  8005f3:	8b 58 04             	mov    0x4(%eax),%ebx
  8005f6:	8d 40 08             	lea    0x8(%eax),%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fc:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  800601:	e9 94 00 00 00       	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 08                	mov    (%eax),%ecx
  80060b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800610:	8d 40 04             	lea    0x4(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800616:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  80061b:	eb 7d                	jmp    80069a <.L25+0x2b>

0080061d <.L26>:
	if (lflag >= 2)
  80061d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800620:	8b 75 08             	mov    0x8(%ebp),%esi
  800623:	83 f9 01             	cmp    $0x1,%ecx
  800626:	7f 1b                	jg     800643 <.L26+0x26>
	else if (lflag)
  800628:	85 c9                	test   %ecx,%ecx
  80062a:	74 2c                	je     800658 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 08                	mov    (%eax),%ecx
  800631:	bb 00 00 00 00       	mov    $0x0,%ebx
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063c:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800641:	eb 57                	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 08                	mov    (%eax),%ecx
  800648:	8b 58 04             	mov    0x4(%eax),%ebx
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800651:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  800656:	eb 42                	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 08                	mov    (%eax),%ecx
  80065d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800668:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  80066d:	eb 2b                	jmp    80069a <.L25+0x2b>

0080066f <.L25>:
			putch('0', putdat);
  80066f:	8b 75 08             	mov    0x8(%ebp),%esi
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	57                   	push   %edi
  800676:	6a 30                	push   $0x30
  800678:	ff d6                	call   *%esi
			putch('x', putdat);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	57                   	push   %edi
  80067e:	6a 78                	push   $0x78
  800680:	ff d6                	call   *%esi
			num = (unsigned long long)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 08                	mov    (%eax),%ecx
  800687:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  80068c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800695:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80069a:	83 ec 0c             	sub    $0xc,%esp
  80069d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006a1:	50                   	push   %eax
  8006a2:	ff 75 d4             	push   -0x2c(%ebp)
  8006a5:	52                   	push   %edx
  8006a6:	53                   	push   %ebx
  8006a7:	51                   	push   %ecx
  8006a8:	89 fa                	mov    %edi,%edx
  8006aa:	89 f0                	mov    %esi,%eax
  8006ac:	e8 f4 fa ff ff       	call   8001a5 <printnum>
			break;
  8006b1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b7:	e9 15 fc ff ff       	jmp    8002d1 <vprintfmt+0x34>

008006bc <.L21>:
	if (lflag >= 2)
  8006bc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c2:	83 f9 01             	cmp    $0x1,%ecx
  8006c5:	7f 1b                	jg     8006e2 <.L21+0x26>
	else if (lflag)
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	74 2c                	je     8006f7 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 08                	mov    (%eax),%ecx
  8006d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006db:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8006e0:	eb b8                	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 08                	mov    (%eax),%ecx
  8006e7:	8b 58 04             	mov    0x4(%eax),%ebx
  8006ea:	8d 40 08             	lea    0x8(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f0:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8006f5:	eb a3                	jmp    80069a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 08                	mov    (%eax),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800707:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  80070c:	eb 8c                	jmp    80069a <.L25+0x2b>

0080070e <.L35>:
			putch(ch, putdat);
  80070e:	8b 75 08             	mov    0x8(%ebp),%esi
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	57                   	push   %edi
  800715:	6a 25                	push   $0x25
  800717:	ff d6                	call   *%esi
			break;
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	eb 96                	jmp    8006b4 <.L25+0x45>

0080071e <.L20>:
			putch('%', putdat);
  80071e:	8b 75 08             	mov    0x8(%ebp),%esi
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	57                   	push   %edi
  800725:	6a 25                	push   $0x25
  800727:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	89 d8                	mov    %ebx,%eax
  80072e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800732:	74 05                	je     800739 <.L20+0x1b>
  800734:	83 e8 01             	sub    $0x1,%eax
  800737:	eb f5                	jmp    80072e <.L20+0x10>
  800739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073c:	e9 73 ff ff ff       	jmp    8006b4 <.L25+0x45>

00800741 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	53                   	push   %ebx
  800745:	83 ec 14             	sub    $0x14,%esp
  800748:	e8 12 f9 ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  80074d:	81 c3 b3 18 00 00    	add    $0x18b3,%ebx
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800760:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076a:	85 c0                	test   %eax,%eax
  80076c:	74 2b                	je     800799 <vsnprintf+0x58>
  80076e:	85 d2                	test   %edx,%edx
  800770:	7e 27                	jle    800799 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800772:	ff 75 14             	push   0x14(%ebp)
  800775:	ff 75 10             	push   0x10(%ebp)
  800778:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077b:	50                   	push   %eax
  80077c:	8d 83 63 e2 ff ff    	lea    -0x1d9d(%ebx),%eax
  800782:	50                   	push   %eax
  800783:	e8 15 fb ff ff       	call   80029d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800797:	c9                   	leave  
  800798:	c3                   	ret    
		return -E_INVAL;
  800799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079e:	eb f4                	jmp    800794 <vsnprintf+0x53>

008007a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a9:	50                   	push   %eax
  8007aa:	ff 75 10             	push   0x10(%ebp)
  8007ad:	ff 75 0c             	push   0xc(%ebp)
  8007b0:	ff 75 08             	push   0x8(%ebp)
  8007b3:	e8 89 ff ff ff       	call   800741 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <__x86.get_pc_thunk.ax>:
  8007ba:	8b 04 24             	mov    (%esp),%eax
  8007bd:	c3                   	ret    

008007be <__x86.get_pc_thunk.cx>:
  8007be:	8b 0c 24             	mov    (%esp),%ecx
  8007c1:	c3                   	ret    

008007c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cd:	eb 03                	jmp    8007d2 <strlen+0x10>
		n++;
  8007cf:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007d2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d6:	75 f7                	jne    8007cf <strlen+0xd>
	return n;
}
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e8:	eb 03                	jmp    8007ed <strnlen+0x13>
		n++;
  8007ea:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ed:	39 d0                	cmp    %edx,%eax
  8007ef:	74 08                	je     8007f9 <strnlen+0x1f>
  8007f1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f5:	75 f3                	jne    8007ea <strnlen+0x10>
  8007f7:	89 c2                	mov    %eax,%edx
	return n;
}
  8007f9:	89 d0                	mov    %edx,%eax
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	53                   	push   %ebx
  800801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800804:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800810:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800813:	83 c0 01             	add    $0x1,%eax
  800816:	84 d2                	test   %dl,%dl
  800818:	75 f2                	jne    80080c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80081a:	89 c8                	mov    %ecx,%eax
  80081c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	83 ec 10             	sub    $0x10,%esp
  800828:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80082b:	53                   	push   %ebx
  80082c:	e8 91 ff ff ff       	call   8007c2 <strlen>
  800831:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800834:	ff 75 0c             	push   0xc(%ebp)
  800837:	01 d8                	add    %ebx,%eax
  800839:	50                   	push   %eax
  80083a:	e8 be ff ff ff       	call   8007fd <strcpy>
	return dst;
}
  80083f:	89 d8                	mov    %ebx,%eax
  800841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800844:	c9                   	leave  
  800845:	c3                   	ret    

00800846 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	56                   	push   %esi
  80084a:	53                   	push   %ebx
  80084b:	8b 75 08             	mov    0x8(%ebp),%esi
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800851:	89 f3                	mov    %esi,%ebx
  800853:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800856:	89 f0                	mov    %esi,%eax
  800858:	eb 0f                	jmp    800869 <strncpy+0x23>
		*dst++ = *src;
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	0f b6 0a             	movzbl (%edx),%ecx
  800860:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800863:	80 f9 01             	cmp    $0x1,%cl
  800866:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800869:	39 d8                	cmp    %ebx,%eax
  80086b:	75 ed                	jne    80085a <strncpy+0x14>
	}
	return ret;
}
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	56                   	push   %esi
  800877:	53                   	push   %ebx
  800878:	8b 75 08             	mov    0x8(%ebp),%esi
  80087b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087e:	8b 55 10             	mov    0x10(%ebp),%edx
  800881:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800883:	85 d2                	test   %edx,%edx
  800885:	74 21                	je     8008a8 <strlcpy+0x35>
  800887:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80088b:	89 f2                	mov    %esi,%edx
  80088d:	eb 09                	jmp    800898 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80088f:	83 c1 01             	add    $0x1,%ecx
  800892:	83 c2 01             	add    $0x1,%edx
  800895:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	74 09                	je     8008a5 <strlcpy+0x32>
  80089c:	0f b6 19             	movzbl (%ecx),%ebx
  80089f:	84 db                	test   %bl,%bl
  8008a1:	75 ec                	jne    80088f <strlcpy+0x1c>
  8008a3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008a5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008a8:	29 f0                	sub    %esi,%eax
}
  8008aa:	5b                   	pop    %ebx
  8008ab:	5e                   	pop    %esi
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b7:	eb 06                	jmp    8008bf <strcmp+0x11>
		p++, q++;
  8008b9:	83 c1 01             	add    $0x1,%ecx
  8008bc:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008bf:	0f b6 01             	movzbl (%ecx),%eax
  8008c2:	84 c0                	test   %al,%al
  8008c4:	74 04                	je     8008ca <strcmp+0x1c>
  8008c6:	3a 02                	cmp    (%edx),%al
  8008c8:	74 ef                	je     8008b9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ca:	0f b6 c0             	movzbl %al,%eax
  8008cd:	0f b6 12             	movzbl (%edx),%edx
  8008d0:	29 d0                	sub    %edx,%eax
}
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	53                   	push   %ebx
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008de:	89 c3                	mov    %eax,%ebx
  8008e0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e3:	eb 06                	jmp    8008eb <strncmp+0x17>
		n--, p++, q++;
  8008e5:	83 c0 01             	add    $0x1,%eax
  8008e8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008eb:	39 d8                	cmp    %ebx,%eax
  8008ed:	74 18                	je     800907 <strncmp+0x33>
  8008ef:	0f b6 08             	movzbl (%eax),%ecx
  8008f2:	84 c9                	test   %cl,%cl
  8008f4:	74 04                	je     8008fa <strncmp+0x26>
  8008f6:	3a 0a                	cmp    (%edx),%cl
  8008f8:	74 eb                	je     8008e5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fa:	0f b6 00             	movzbl (%eax),%eax
  8008fd:	0f b6 12             	movzbl (%edx),%edx
  800900:	29 d0                	sub    %edx,%eax
}
  800902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800905:	c9                   	leave  
  800906:	c3                   	ret    
		return 0;
  800907:	b8 00 00 00 00       	mov    $0x0,%eax
  80090c:	eb f4                	jmp    800902 <strncmp+0x2e>

0080090e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800918:	eb 03                	jmp    80091d <strchr+0xf>
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	74 06                	je     80092a <strchr+0x1c>
		if (*s == c)
  800924:	38 ca                	cmp    %cl,%dl
  800926:	75 f2                	jne    80091a <strchr+0xc>
  800928:	eb 05                	jmp    80092f <strchr+0x21>
			return (char *) s;
	return 0;
  80092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80093e:	38 ca                	cmp    %cl,%dl
  800940:	74 09                	je     80094b <strfind+0x1a>
  800942:	84 d2                	test   %dl,%dl
  800944:	74 05                	je     80094b <strfind+0x1a>
	for (; *s; s++)
  800946:	83 c0 01             	add    $0x1,%eax
  800949:	eb f0                	jmp    80093b <strfind+0xa>
			break;
	return (char *) s;
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	57                   	push   %edi
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	8b 7d 08             	mov    0x8(%ebp),%edi
  800956:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800959:	85 c9                	test   %ecx,%ecx
  80095b:	74 2f                	je     80098c <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	09 c8                	or     %ecx,%eax
  800961:	a8 03                	test   $0x3,%al
  800963:	75 21                	jne    800986 <memset+0x39>
		c &= 0xFF;
  800965:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800969:	89 d0                	mov    %edx,%eax
  80096b:	c1 e0 08             	shl    $0x8,%eax
  80096e:	89 d3                	mov    %edx,%ebx
  800970:	c1 e3 18             	shl    $0x18,%ebx
  800973:	89 d6                	mov    %edx,%esi
  800975:	c1 e6 10             	shl    $0x10,%esi
  800978:	09 f3                	or     %esi,%ebx
  80097a:	09 da                	or     %ebx,%edx
  80097c:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80097e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800981:	fc                   	cld    
  800982:	f3 ab                	rep stos %eax,%es:(%edi)
  800984:	eb 06                	jmp    80098c <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	fc                   	cld    
  80098a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098c:	89 f8                	mov    %edi,%eax
  80098e:	5b                   	pop    %ebx
  80098f:	5e                   	pop    %esi
  800990:	5f                   	pop    %edi
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	57                   	push   %edi
  800997:	56                   	push   %esi
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a1:	39 c6                	cmp    %eax,%esi
  8009a3:	73 32                	jae    8009d7 <memmove+0x44>
  8009a5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a8:	39 c2                	cmp    %eax,%edx
  8009aa:	76 2b                	jbe    8009d7 <memmove+0x44>
		s += n;
		d += n;
  8009ac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	89 d6                	mov    %edx,%esi
  8009b1:	09 fe                	or     %edi,%esi
  8009b3:	09 ce                	or     %ecx,%esi
  8009b5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009bb:	75 0e                	jne    8009cb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009bd:	83 ef 04             	sub    $0x4,%edi
  8009c0:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c6:	fd                   	std    
  8009c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c9:	eb 09                	jmp    8009d4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cb:	83 ef 01             	sub    $0x1,%edi
  8009ce:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d1:	fd                   	std    
  8009d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d4:	fc                   	cld    
  8009d5:	eb 1a                	jmp    8009f1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d7:	89 f2                	mov    %esi,%edx
  8009d9:	09 c2                	or     %eax,%edx
  8009db:	09 ca                	or     %ecx,%edx
  8009dd:	f6 c2 03             	test   $0x3,%dl
  8009e0:	75 0a                	jne    8009ec <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e5:	89 c7                	mov    %eax,%edi
  8009e7:	fc                   	cld    
  8009e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ea:	eb 05                	jmp    8009f1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009ec:	89 c7                	mov    %eax,%edi
  8009ee:	fc                   	cld    
  8009ef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f1:	5e                   	pop    %esi
  8009f2:	5f                   	pop    %edi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009fb:	ff 75 10             	push   0x10(%ebp)
  8009fe:	ff 75 0c             	push   0xc(%ebp)
  800a01:	ff 75 08             	push   0x8(%ebp)
  800a04:	e8 8a ff ff ff       	call   800993 <memmove>
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a16:	89 c6                	mov    %eax,%esi
  800a18:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1b:	eb 06                	jmp    800a23 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800a23:	39 f0                	cmp    %esi,%eax
  800a25:	74 14                	je     800a3b <memcmp+0x30>
		if (*s1 != *s2)
  800a27:	0f b6 08             	movzbl (%eax),%ecx
  800a2a:	0f b6 1a             	movzbl (%edx),%ebx
  800a2d:	38 d9                	cmp    %bl,%cl
  800a2f:	74 ec                	je     800a1d <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800a31:	0f b6 c1             	movzbl %cl,%eax
  800a34:	0f b6 db             	movzbl %bl,%ebx
  800a37:	29 d8                	sub    %ebx,%eax
  800a39:	eb 05                	jmp    800a40 <memcmp+0x35>
	}

	return 0;
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a40:	5b                   	pop    %ebx
  800a41:	5e                   	pop    %esi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a52:	eb 03                	jmp    800a57 <memfind+0x13>
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	39 d0                	cmp    %edx,%eax
  800a59:	73 04                	jae    800a5f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5b:	38 08                	cmp    %cl,(%eax)
  800a5d:	75 f5                	jne    800a54 <memfind+0x10>
			break;
	return (void *) s;
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	57                   	push   %edi
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6d:	eb 03                	jmp    800a72 <strtol+0x11>
		s++;
  800a6f:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800a72:	0f b6 02             	movzbl (%edx),%eax
  800a75:	3c 20                	cmp    $0x20,%al
  800a77:	74 f6                	je     800a6f <strtol+0xe>
  800a79:	3c 09                	cmp    $0x9,%al
  800a7b:	74 f2                	je     800a6f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a7d:	3c 2b                	cmp    $0x2b,%al
  800a7f:	74 2a                	je     800aab <strtol+0x4a>
	int neg = 0;
  800a81:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a86:	3c 2d                	cmp    $0x2d,%al
  800a88:	74 2b                	je     800ab5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a90:	75 0f                	jne    800aa1 <strtol+0x40>
  800a92:	80 3a 30             	cmpb   $0x30,(%edx)
  800a95:	74 28                	je     800abf <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a97:	85 db                	test   %ebx,%ebx
  800a99:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9e:	0f 44 d8             	cmove  %eax,%ebx
  800aa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aa6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa9:	eb 46                	jmp    800af1 <strtol+0x90>
		s++;
  800aab:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800aae:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab3:	eb d5                	jmp    800a8a <strtol+0x29>
		s++, neg = 1;
  800ab5:	83 c2 01             	add    $0x1,%edx
  800ab8:	bf 01 00 00 00       	mov    $0x1,%edi
  800abd:	eb cb                	jmp    800a8a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ac3:	74 0e                	je     800ad3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ac5:	85 db                	test   %ebx,%ebx
  800ac7:	75 d8                	jne    800aa1 <strtol+0x40>
		s++, base = 8;
  800ac9:	83 c2 01             	add    $0x1,%edx
  800acc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad1:	eb ce                	jmp    800aa1 <strtol+0x40>
		s += 2, base = 16;
  800ad3:	83 c2 02             	add    $0x2,%edx
  800ad6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800adb:	eb c4                	jmp    800aa1 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800add:	0f be c0             	movsbl %al,%eax
  800ae0:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ae6:	7d 3a                	jge    800b22 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800aef:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800af1:	0f b6 02             	movzbl (%edx),%eax
  800af4:	8d 70 d0             	lea    -0x30(%eax),%esi
  800af7:	89 f3                	mov    %esi,%ebx
  800af9:	80 fb 09             	cmp    $0x9,%bl
  800afc:	76 df                	jbe    800add <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800afe:	8d 70 9f             	lea    -0x61(%eax),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 19             	cmp    $0x19,%bl
  800b06:	77 08                	ja     800b10 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b08:	0f be c0             	movsbl %al,%eax
  800b0b:	83 e8 57             	sub    $0x57,%eax
  800b0e:	eb d3                	jmp    800ae3 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800b10:	8d 70 bf             	lea    -0x41(%eax),%esi
  800b13:	89 f3                	mov    %esi,%ebx
  800b15:	80 fb 19             	cmp    $0x19,%bl
  800b18:	77 08                	ja     800b22 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b1a:	0f be c0             	movsbl %al,%eax
  800b1d:	83 e8 37             	sub    $0x37,%eax
  800b20:	eb c1                	jmp    800ae3 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b26:	74 05                	je     800b2d <strtol+0xcc>
		*endptr = (char *) s;
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800b2d:	89 c8                	mov    %ecx,%eax
  800b2f:	f7 d8                	neg    %eax
  800b31:	85 ff                	test   %edi,%edi
  800b33:	0f 45 c8             	cmovne %eax,%ecx
}
  800b36:	89 c8                	mov    %ecx,%eax
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4e:	89 c3                	mov    %eax,%ebx
  800b50:	89 c7                	mov    %eax,%edi
  800b52:	89 c6                	mov    %eax,%esi
  800b54:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b61:	ba 00 00 00 00       	mov    $0x0,%edx
  800b66:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6b:	89 d1                	mov    %edx,%ecx
  800b6d:	89 d3                	mov    %edx,%ebx
  800b6f:	89 d7                	mov    %edx,%edi
  800b71:	89 d6                	mov    %edx,%esi
  800b73:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	83 ec 1c             	sub    $0x1c,%esp
  800b83:	e8 32 fc ff ff       	call   8007ba <__x86.get_pc_thunk.ax>
  800b88:	05 78 14 00 00       	add    $0x1478,%eax
  800b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800b90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9d:	89 cb                	mov    %ecx,%ebx
  800b9f:	89 cf                	mov    %ecx,%edi
  800ba1:	89 ce                	mov    %ecx,%esi
  800ba3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	7f 08                	jg     800bb1 <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb1:	83 ec 0c             	sub    $0xc,%esp
  800bb4:	50                   	push   %eax
  800bb5:	6a 03                	push   $0x3
  800bb7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800bba:	8d 83 9c f0 ff ff    	lea    -0xf64(%ebx),%eax
  800bc0:	50                   	push   %eax
  800bc1:	6a 23                	push   $0x23
  800bc3:	8d 83 b9 f0 ff ff    	lea    -0xf47(%ebx),%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 1f 00 00 00       	call   800bee <_panic>

00800bcf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bda:	b8 02 00 00 00       	mov    $0x2,%eax
  800bdf:	89 d1                	mov    %edx,%ecx
  800be1:	89 d3                	mov    %edx,%ebx
  800be3:	89 d7                	mov    %edx,%edi
  800be5:	89 d6                	mov    %edx,%esi
  800be7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5f                   	pop    %edi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	83 ec 0c             	sub    $0xc,%esp
  800bf7:	e8 63 f4 ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  800bfc:	81 c3 04 14 00 00    	add    $0x1404,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c02:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c05:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c0b:	8b 38                	mov    (%eax),%edi
  800c0d:	e8 bd ff ff ff       	call   800bcf <sys_getenvid>
  800c12:	83 ec 0c             	sub    $0xc,%esp
  800c15:	ff 75 0c             	push   0xc(%ebp)
  800c18:	ff 75 08             	push   0x8(%ebp)
  800c1b:	57                   	push   %edi
  800c1c:	50                   	push   %eax
  800c1d:	8d 83 c8 f0 ff ff    	lea    -0xf38(%ebx),%eax
  800c23:	50                   	push   %eax
  800c24:	e8 68 f5 ff ff       	call   800191 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c29:	83 c4 18             	add    $0x18,%esp
  800c2c:	56                   	push   %esi
  800c2d:	ff 75 10             	push   0x10(%ebp)
  800c30:	e8 fa f4 ff ff       	call   80012f <vcprintf>
	cprintf("\n");
  800c35:	8d 83 eb f0 ff ff    	lea    -0xf15(%ebx),%eax
  800c3b:	89 04 24             	mov    %eax,(%esp)
  800c3e:	e8 4e f5 ff ff       	call   800191 <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c46:	cc                   	int3   
  800c47:	eb fd                	jmp    800c46 <_panic+0x58>
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
