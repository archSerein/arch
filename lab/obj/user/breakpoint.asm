
obj/user/breakpoint:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	57                   	push   %edi
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	e8 4e 00 00 00       	call   800091 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
  800049:	8b 75 08             	mov    0x8(%ebp),%esi
  80004c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004f:	e8 f4 00 00 00       	call   800148 <sys_getenvid>
  800054:	25 ff 03 00 00       	and    $0x3ff,%eax
  800059:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80005c:	c1 e0 05             	shl    $0x5,%eax
  80005f:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800065:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006b:	85 f6                	test   %esi,%esi
  80006d:	7e 08                	jle    800077 <libmain+0x42>
		binaryname = argv[0];
  80006f:	8b 07                	mov    (%edi),%eax
  800071:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	57                   	push   %edi
  80007b:	56                   	push   %esi
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0f 00 00 00       	call   800095 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5f                   	pop    %edi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    

00800091 <__x86.get_pc_thunk.bx>:
  800091:	8b 1c 24             	mov    (%esp),%ebx
  800094:	c3                   	ret    

00800095 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	53                   	push   %ebx
  800099:	83 ec 10             	sub    $0x10,%esp
  80009c:	e8 f0 ff ff ff       	call   800091 <__x86.get_pc_thunk.bx>
  8000a1:	81 c3 5f 1f 00 00    	add    $0x1f5f,%ebx
	sys_env_destroy(0);
  8000a7:	6a 00                	push   $0x0
  8000a9:	e8 45 00 00 00       	call   8000f3 <sys_env_destroy>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	57                   	push   %edi
  8000ba:	56                   	push   %esi
  8000bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c7:	89 c3                	mov    %eax,%ebx
  8000c9:	89 c7                	mov    %eax,%edi
  8000cb:	89 c6                	mov    %eax,%esi
  8000cd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5f                   	pop    %edi
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	57                   	push   %edi
  8000d8:	56                   	push   %esi
  8000d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000da:	ba 00 00 00 00       	mov    $0x0,%edx
  8000df:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	89 d3                	mov    %edx,%ebx
  8000e8:	89 d7                	mov    %edx,%edi
  8000ea:	89 d6                	mov    %edx,%esi
  8000ec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 1c             	sub    $0x1c,%esp
  8000fc:	e8 66 00 00 00       	call   800167 <__x86.get_pc_thunk.ax>
  800101:	05 ff 1e 00 00       	add    $0x1eff,%eax
  800106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800109:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010e:	8b 55 08             	mov    0x8(%ebp),%edx
  800111:	b8 03 00 00 00       	mov    $0x3,%eax
  800116:	89 cb                	mov    %ecx,%ebx
  800118:	89 cf                	mov    %ecx,%edi
  80011a:	89 ce                	mov    %ecx,%esi
  80011c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011e:	85 c0                	test   %eax,%eax
  800120:	7f 08                	jg     80012a <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5f                   	pop    %edi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	50                   	push   %eax
  80012e:	6a 03                	push   $0x3
  800130:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800133:	8d 83 5e ee ff ff    	lea    -0x11a2(%ebx),%eax
  800139:	50                   	push   %eax
  80013a:	6a 23                	push   $0x23
  80013c:	8d 83 7b ee ff ff    	lea    -0x1185(%ebx),%eax
  800142:	50                   	push   %eax
  800143:	e8 23 00 00 00       	call   80016b <_panic>

00800148 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	57                   	push   %edi
  80014c:	56                   	push   %esi
  80014d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014e:	ba 00 00 00 00       	mov    $0x0,%edx
  800153:	b8 02 00 00 00       	mov    $0x2,%eax
  800158:	89 d1                	mov    %edx,%ecx
  80015a:	89 d3                	mov    %edx,%ebx
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	89 d6                	mov    %edx,%esi
  800160:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    

00800167 <__x86.get_pc_thunk.ax>:
  800167:	8b 04 24             	mov    (%esp),%eax
  80016a:	c3                   	ret    

0080016b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	e8 18 ff ff ff       	call   800091 <__x86.get_pc_thunk.bx>
  800179:	81 c3 87 1e 00 00    	add    $0x1e87,%ebx
	va_list ap;

	va_start(ap, fmt);
  80017f:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800182:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800188:	8b 38                	mov    (%eax),%edi
  80018a:	e8 b9 ff ff ff       	call   800148 <sys_getenvid>
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 0c             	push   0xc(%ebp)
  800195:	ff 75 08             	push   0x8(%ebp)
  800198:	57                   	push   %edi
  800199:	50                   	push   %eax
  80019a:	8d 83 8c ee ff ff    	lea    -0x1174(%ebx),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 d1 00 00 00       	call   800277 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a6:	83 c4 18             	add    $0x18,%esp
  8001a9:	56                   	push   %esi
  8001aa:	ff 75 10             	push   0x10(%ebp)
  8001ad:	e8 63 00 00 00       	call   800215 <vcprintf>
	cprintf("\n");
  8001b2:	8d 83 af ee ff ff    	lea    -0x1151(%ebx),%eax
  8001b8:	89 04 24             	mov    %eax,(%esp)
  8001bb:	e8 b7 00 00 00       	call   800277 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c3:	cc                   	int3   
  8001c4:	eb fd                	jmp    8001c3 <_panic+0x58>

008001c6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	e8 c1 fe ff ff       	call   800091 <__x86.get_pc_thunk.bx>
  8001d0:	81 c3 30 1e 00 00    	add    $0x1e30,%ebx
  8001d6:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001d9:	8b 16                	mov    (%esi),%edx
  8001db:	8d 42 01             	lea    0x1(%edx),%eax
  8001de:	89 06                	mov    %eax,(%esi)
  8001e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e3:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ec:	74 0b                	je     8001f9 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ee:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001f5:	5b                   	pop    %ebx
  8001f6:	5e                   	pop    %esi
  8001f7:	5d                   	pop    %ebp
  8001f8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	68 ff 00 00 00       	push   $0xff
  800201:	8d 46 08             	lea    0x8(%esi),%eax
  800204:	50                   	push   %eax
  800205:	e8 ac fe ff ff       	call   8000b6 <sys_cputs>
		b->idx = 0;
  80020a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	eb d9                	jmp    8001ee <putch+0x28>

00800215 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	53                   	push   %ebx
  800219:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80021f:	e8 6d fe ff ff       	call   800091 <__x86.get_pc_thunk.bx>
  800224:	81 c3 dc 1d 00 00    	add    $0x1ddc,%ebx
	struct printbuf b;

	b.idx = 0;
  80022a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800231:	00 00 00 
	b.cnt = 0;
  800234:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80023b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023e:	ff 75 0c             	push   0xc(%ebp)
  800241:	ff 75 08             	push   0x8(%ebp)
  800244:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024a:	50                   	push   %eax
  80024b:	8d 83 c6 e1 ff ff    	lea    -0x1e3a(%ebx),%eax
  800251:	50                   	push   %eax
  800252:	e8 2c 01 00 00       	call   800383 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800257:	83 c4 08             	add    $0x8,%esp
  80025a:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800260:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 4a fe ff ff       	call   8000b6 <sys_cputs>

	return b.cnt;
}
  80026c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800280:	50                   	push   %eax
  800281:	ff 75 08             	push   0x8(%ebp)
  800284:	e8 8c ff ff ff       	call   800215 <vcprintf>
	va_end(ap);

	return cnt;
}
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	83 ec 2c             	sub    $0x2c,%esp
  800294:	e8 07 06 00 00       	call   8008a0 <__x86.get_pc_thunk.cx>
  800299:	81 c1 67 1d 00 00    	add    $0x1d67,%ecx
  80029f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002a2:	89 c7                	mov    %eax,%edi
  8002a4:	89 d6                	mov    %edx,%esi
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002b3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002cb:	72 41                	jb     80030e <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	ff 75 18             	push   0x18(%ebp)
  8002d3:	83 eb 01             	sub    $0x1,%ebx
  8002d6:	53                   	push   %ebx
  8002d7:	50                   	push   %eax
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	ff 75 e4             	push   -0x1c(%ebp)
  8002de:	ff 75 e0             	push   -0x20(%ebp)
  8002e1:	ff 75 d4             	push   -0x2c(%ebp)
  8002e4:	ff 75 d0             	push   -0x30(%ebp)
  8002e7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002ea:	e8 31 09 00 00       	call   800c20 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 f2                	mov    %esi,%edx
  8002f6:	89 f8                	mov    %edi,%eax
  8002f8:	e8 8e ff ff ff       	call   80028b <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
  800300:	eb 13                	jmp    800315 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	ff 75 18             	push   0x18(%ebp)
  800309:	ff d7                	call   *%edi
  80030b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80030e:	83 eb 01             	sub    $0x1,%ebx
  800311:	85 db                	test   %ebx,%ebx
  800313:	7f ed                	jg     800302 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	56                   	push   %esi
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	ff 75 e4             	push   -0x1c(%ebp)
  80031f:	ff 75 e0             	push   -0x20(%ebp)
  800322:	ff 75 d4             	push   -0x2c(%ebp)
  800325:	ff 75 d0             	push   -0x30(%ebp)
  800328:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80032b:	e8 10 0a 00 00       	call   800d40 <__umoddi3>
  800330:	83 c4 14             	add    $0x14,%esp
  800333:	0f be 84 03 b1 ee ff 	movsbl -0x114f(%ebx,%eax,1),%eax
  80033a:	ff 
  80033b:	50                   	push   %eax
  80033c:	ff d7                	call   *%edi
}
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800344:	5b                   	pop    %ebx
  800345:	5e                   	pop    %esi
  800346:	5f                   	pop    %edi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036f:	50                   	push   %eax
  800370:	ff 75 10             	push   0x10(%ebp)
  800373:	ff 75 0c             	push   0xc(%ebp)
  800376:	ff 75 08             	push   0x8(%ebp)
  800379:	e8 05 00 00 00       	call   800383 <vprintfmt>
}
  80037e:	83 c4 10             	add    $0x10,%esp
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <vprintfmt>:
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	57                   	push   %edi
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	83 ec 3c             	sub    $0x3c,%esp
  80038c:	e8 d6 fd ff ff       	call   800167 <__x86.get_pc_thunk.ax>
  800391:	05 6f 1c 00 00       	add    $0x1c6f,%eax
  800396:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800399:	8b 75 08             	mov    0x8(%ebp),%esi
  80039c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80039f:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a2:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ab:	eb 0a                	jmp    8003b7 <vprintfmt+0x34>
			putch(ch, putdat);
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	57                   	push   %edi
  8003b1:	50                   	push   %eax
  8003b2:	ff d6                	call   *%esi
  8003b4:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b7:	83 c3 01             	add    $0x1,%ebx
  8003ba:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003be:	83 f8 25             	cmp    $0x25,%eax
  8003c1:	74 0c                	je     8003cf <vprintfmt+0x4c>
			if (ch == '\0')
  8003c3:	85 c0                	test   %eax,%eax
  8003c5:	75 e6                	jne    8003ad <vprintfmt+0x2a>
}
  8003c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    
		padc = ' ';
  8003cf:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e1:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ed:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f0:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8d 43 01             	lea    0x1(%ebx),%eax
  8003f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f9:	0f b6 13             	movzbl (%ebx),%edx
  8003fc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ff:	3c 55                	cmp    $0x55,%al
  800401:	0f 87 fd 03 00 00    	ja     800804 <.L20>
  800407:	0f b6 c0             	movzbl %al,%eax
  80040a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040d:	89 ce                	mov    %ecx,%esi
  80040f:	03 b4 81 40 ef ff ff 	add    -0x10c0(%ecx,%eax,4),%esi
  800416:	ff e6                	jmp    *%esi

00800418 <.L68>:
  800418:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80041b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041f:	eb d2                	jmp    8003f3 <vprintfmt+0x70>

00800421 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800424:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800428:	eb c9                	jmp    8003f3 <vprintfmt+0x70>

0080042a <.L31>:
  80042a:	0f b6 d2             	movzbl %dl,%edx
  80042d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800438:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80043f:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800442:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800445:	83 f9 09             	cmp    $0x9,%ecx
  800448:	77 58                	ja     8004a2 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80044a:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80044d:	eb e9                	jmp    800438 <.L31+0xe>

0080044f <.L34>:
			precision = va_arg(ap, int);
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8d 40 04             	lea    0x4(%eax),%eax
  80045d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800460:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800463:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800467:	79 8a                	jns    8003f3 <vprintfmt+0x70>
				width = precision, precision = -1;
  800469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80046f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800476:	e9 78 ff ff ff       	jmp    8003f3 <vprintfmt+0x70>

0080047b <.L33>:
  80047b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80047e:	85 d2                	test   %edx,%edx
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	0f 49 c2             	cmovns %edx,%eax
  800488:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  80048e:	e9 60 ff ff ff       	jmp    8003f3 <vprintfmt+0x70>

00800493 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  800496:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049d:	e9 51 ff ff ff       	jmp    8003f3 <vprintfmt+0x70>
  8004a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a8:	eb b9                	jmp    800463 <.L34+0x14>

008004aa <.L27>:
			lflag++;
  8004aa:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b1:	e9 3d ff ff ff       	jmp    8003f3 <vprintfmt+0x70>

008004b6 <.L30>:
			putch(va_arg(ap, int), putdat);
  8004b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8d 58 04             	lea    0x4(%eax),%ebx
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	57                   	push   %edi
  8004c3:	ff 30                	push   (%eax)
  8004c5:	ff d6                	call   *%esi
			break;
  8004c7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ca:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004cd:	e9 c8 02 00 00       	jmp    80079a <.L25+0x45>

008004d2 <.L28>:
			err = va_arg(ap, int);
  8004d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8d 58 04             	lea    0x4(%eax),%ebx
  8004db:	8b 10                	mov    (%eax),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	f7 d8                	neg    %eax
  8004e1:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e4:	83 f8 06             	cmp    $0x6,%eax
  8004e7:	7f 27                	jg     800510 <.L28+0x3e>
  8004e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ec:	8b 14 82             	mov    (%edx,%eax,4),%edx
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	74 1d                	je     800510 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  8004f3:	52                   	push   %edx
  8004f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f7:	8d 80 d2 ee ff ff    	lea    -0x112e(%eax),%eax
  8004fd:	50                   	push   %eax
  8004fe:	57                   	push   %edi
  8004ff:	56                   	push   %esi
  800500:	e8 61 fe ff ff       	call   800366 <printfmt>
  800505:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800508:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80050b:	e9 8a 02 00 00       	jmp    80079a <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800510:	50                   	push   %eax
  800511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800514:	8d 80 c9 ee ff ff    	lea    -0x1137(%eax),%eax
  80051a:	50                   	push   %eax
  80051b:	57                   	push   %edi
  80051c:	56                   	push   %esi
  80051d:	e8 44 fe ff ff       	call   800366 <printfmt>
  800522:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800525:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800528:	e9 6d 02 00 00       	jmp    80079a <.L25+0x45>

0080052d <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  80052d:	8b 75 08             	mov    0x8(%ebp),%esi
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	83 c0 04             	add    $0x4,%eax
  800536:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80053e:	85 d2                	test   %edx,%edx
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	8d 80 c2 ee ff ff    	lea    -0x113e(%eax),%eax
  800549:	0f 45 c2             	cmovne %edx,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80054f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800553:	7e 06                	jle    80055b <.L24+0x2e>
  800555:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800559:	75 0d                	jne    800568 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055e:	89 c3                	mov    %eax,%ebx
  800560:	03 45 d4             	add    -0x2c(%ebp),%eax
  800563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800566:	eb 58                	jmp    8005c0 <.L24+0x93>
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 d8             	push   -0x28(%ebp)
  80056e:	ff 75 c8             	push   -0x38(%ebp)
  800571:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800574:	e8 43 03 00 00       	call   8008bc <strnlen>
  800579:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 bc             	mov    %edx,-0x44(%ebp)
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  800586:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80058a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	eb 0f                	jmp    80059e <.L24+0x71>
					putch(padc, putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	57                   	push   %edi
  800593:	ff 75 d4             	push   -0x2c(%ebp)
  800596:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800598:	83 eb 01             	sub    $0x1,%ebx
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	85 db                	test   %ebx,%ebx
  8005a0:	7f ed                	jg     80058f <.L24+0x62>
  8005a2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005a5:	85 d2                	test   %edx,%edx
  8005a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ac:	0f 49 c2             	cmovns %edx,%eax
  8005af:	29 c2                	sub    %eax,%edx
  8005b1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b4:	eb a5                	jmp    80055b <.L24+0x2e>
					putch(ch, putdat);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	57                   	push   %edi
  8005ba:	52                   	push   %edx
  8005bb:	ff d6                	call   *%esi
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005c3:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c5:	83 c3 01             	add    $0x1,%ebx
  8005c8:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005cc:	0f be d0             	movsbl %al,%edx
  8005cf:	85 d2                	test   %edx,%edx
  8005d1:	74 4b                	je     80061e <.L24+0xf1>
  8005d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d7:	78 06                	js     8005df <.L24+0xb2>
  8005d9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005dd:	78 1e                	js     8005fd <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005df:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e3:	74 d1                	je     8005b6 <.L24+0x89>
  8005e5:	0f be c0             	movsbl %al,%eax
  8005e8:	83 e8 20             	sub    $0x20,%eax
  8005eb:	83 f8 5e             	cmp    $0x5e,%eax
  8005ee:	76 c6                	jbe    8005b6 <.L24+0x89>
					putch('?', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	57                   	push   %edi
  8005f4:	6a 3f                	push   $0x3f
  8005f6:	ff d6                	call   *%esi
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	eb c3                	jmp    8005c0 <.L24+0x93>
  8005fd:	89 cb                	mov    %ecx,%ebx
  8005ff:	eb 0e                	jmp    80060f <.L24+0xe2>
				putch(' ', putdat);
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	57                   	push   %edi
  800605:	6a 20                	push   $0x20
  800607:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800609:	83 eb 01             	sub    $0x1,%ebx
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7f ee                	jg     800601 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800613:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
  800619:	e9 7c 01 00 00       	jmp    80079a <.L25+0x45>
  80061e:	89 cb                	mov    %ecx,%ebx
  800620:	eb ed                	jmp    80060f <.L24+0xe2>

00800622 <.L29>:
	if (lflag >= 2)
  800622:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800625:	8b 75 08             	mov    0x8(%ebp),%esi
  800628:	83 f9 01             	cmp    $0x1,%ecx
  80062b:	7f 1b                	jg     800648 <.L29+0x26>
	else if (lflag)
  80062d:	85 c9                	test   %ecx,%ecx
  80062f:	74 63                	je     800694 <.L29+0x72>
		return va_arg(*ap, long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	99                   	cltd   
  80063a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
  800646:	eb 17                	jmp    80065f <.L29+0x3d>
		return va_arg(*ap, long long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 50 04             	mov    0x4(%eax),%edx
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 08             	lea    0x8(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80065f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800662:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800665:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	0f 89 0e 01 00 00    	jns    800780 <.L25+0x2b>
				putch('-', putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	57                   	push   %edi
  800676:	6a 2d                	push   $0x2d
  800678:	ff d6                	call   *%esi
				num = -(long long) num;
  80067a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80067d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800680:	f7 d9                	neg    %ecx
  800682:	83 d3 00             	adc    $0x0,%ebx
  800685:	f7 db                	neg    %ebx
  800687:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80068f:	e9 ec 00 00 00       	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, int);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	99                   	cltd   
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	eb b4                	jmp    80065f <.L29+0x3d>

008006ab <.L23>:
	if (lflag >= 2)
  8006ab:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b1:	83 f9 01             	cmp    $0x1,%ecx
  8006b4:	7f 1e                	jg     8006d4 <.L23+0x29>
	else if (lflag)
  8006b6:	85 c9                	test   %ecx,%ecx
  8006b8:	74 32                	je     8006ec <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 08                	mov    (%eax),%ecx
  8006bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ca:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006cf:	e9 ac 00 00 00       	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 08                	mov    (%eax),%ecx
  8006d9:	8b 58 04             	mov    0x4(%eax),%ebx
  8006dc:	8d 40 08             	lea    0x8(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e2:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  8006e7:	e9 94 00 00 00       	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 08                	mov    (%eax),%ecx
  8006f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fc:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800701:	eb 7d                	jmp    800780 <.L25+0x2b>

00800703 <.L26>:
	if (lflag >= 2)
  800703:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800706:	8b 75 08             	mov    0x8(%ebp),%esi
  800709:	83 f9 01             	cmp    $0x1,%ecx
  80070c:	7f 1b                	jg     800729 <.L26+0x26>
	else if (lflag)
  80070e:	85 c9                	test   %ecx,%ecx
  800710:	74 2c                	je     80073e <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 08                	mov    (%eax),%ecx
  800717:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800722:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800727:	eb 57                	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 08                	mov    (%eax),%ecx
  80072e:	8b 58 04             	mov    0x4(%eax),%ebx
  800731:	8d 40 08             	lea    0x8(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800737:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  80073c:	eb 42                	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 08                	mov    (%eax),%ecx
  800743:	bb 00 00 00 00       	mov    $0x0,%ebx
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074e:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800753:	eb 2b                	jmp    800780 <.L25+0x2b>

00800755 <.L25>:
			putch('0', putdat);
  800755:	8b 75 08             	mov    0x8(%ebp),%esi
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	57                   	push   %edi
  80075c:	6a 30                	push   $0x30
  80075e:	ff d6                	call   *%esi
			putch('x', putdat);
  800760:	83 c4 08             	add    $0x8,%esp
  800763:	57                   	push   %edi
  800764:	6a 78                	push   $0x78
  800766:	ff d6                	call   *%esi
			num = (unsigned long long)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 08                	mov    (%eax),%ecx
  80076d:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800772:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800775:	8d 40 04             	lea    0x4(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077b:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800780:	83 ec 0c             	sub    $0xc,%esp
  800783:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800787:	50                   	push   %eax
  800788:	ff 75 d4             	push   -0x2c(%ebp)
  80078b:	52                   	push   %edx
  80078c:	53                   	push   %ebx
  80078d:	51                   	push   %ecx
  80078e:	89 fa                	mov    %edi,%edx
  800790:	89 f0                	mov    %esi,%eax
  800792:	e8 f4 fa ff ff       	call   80028b <printnum>
			break;
  800797:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079d:	e9 15 fc ff ff       	jmp    8003b7 <vprintfmt+0x34>

008007a2 <.L21>:
	if (lflag >= 2)
  8007a2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a8:	83 f9 01             	cmp    $0x1,%ecx
  8007ab:	7f 1b                	jg     8007c8 <.L21+0x26>
	else if (lflag)
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	74 2c                	je     8007dd <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 08                	mov    (%eax),%ecx
  8007b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007c6:	eb b8                	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 08                	mov    (%eax),%ecx
  8007cd:	8b 58 04             	mov    0x4(%eax),%ebx
  8007d0:	8d 40 08             	lea    0x8(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007db:	eb a3                	jmp    800780 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 08                	mov    (%eax),%ecx
  8007e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ed:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  8007f2:	eb 8c                	jmp    800780 <.L25+0x2b>

008007f4 <.L35>:
			putch(ch, putdat);
  8007f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	57                   	push   %edi
  8007fb:	6a 25                	push   $0x25
  8007fd:	ff d6                	call   *%esi
			break;
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	eb 96                	jmp    80079a <.L25+0x45>

00800804 <.L20>:
			putch('%', putdat);
  800804:	8b 75 08             	mov    0x8(%ebp),%esi
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	57                   	push   %edi
  80080b:	6a 25                	push   $0x25
  80080d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	89 d8                	mov    %ebx,%eax
  800814:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800818:	74 05                	je     80081f <.L20+0x1b>
  80081a:	83 e8 01             	sub    $0x1,%eax
  80081d:	eb f5                	jmp    800814 <.L20+0x10>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800822:	e9 73 ff ff ff       	jmp    80079a <.L25+0x45>

00800827 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	83 ec 14             	sub    $0x14,%esp
  80082e:	e8 5e f8 ff ff       	call   800091 <__x86.get_pc_thunk.bx>
  800833:	81 c3 cd 17 00 00    	add    $0x17cd,%ebx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800842:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800846:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800850:	85 c0                	test   %eax,%eax
  800852:	74 2b                	je     80087f <vsnprintf+0x58>
  800854:	85 d2                	test   %edx,%edx
  800856:	7e 27                	jle    80087f <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800858:	ff 75 14             	push   0x14(%ebp)
  80085b:	ff 75 10             	push   0x10(%ebp)
  80085e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	8d 83 49 e3 ff ff    	lea    -0x1cb7(%ebx),%eax
  800868:	50                   	push   %eax
  800869:	e8 15 fb ff ff       	call   800383 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800871:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087d:	c9                   	leave  
  80087e:	c3                   	ret    
		return -E_INVAL;
  80087f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800884:	eb f4                	jmp    80087a <vsnprintf+0x53>

00800886 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088f:	50                   	push   %eax
  800890:	ff 75 10             	push   0x10(%ebp)
  800893:	ff 75 0c             	push   0xc(%ebp)
  800896:	ff 75 08             	push   0x8(%ebp)
  800899:	e8 89 ff ff ff       	call   800827 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <__x86.get_pc_thunk.cx>:
  8008a0:	8b 0c 24             	mov    (%esp),%ecx
  8008a3:	c3                   	ret    

008008a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008af:	eb 03                	jmp    8008b4 <strlen+0x10>
		n++;
  8008b1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b8:	75 f7                	jne    8008b1 <strlen+0xd>
	return n;
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	eb 03                	jmp    8008cf <strnlen+0x13>
		n++;
  8008cc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cf:	39 d0                	cmp    %edx,%eax
  8008d1:	74 08                	je     8008db <strnlen+0x1f>
  8008d3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d7:	75 f3                	jne    8008cc <strnlen+0x10>
  8008d9:	89 c2                	mov    %eax,%edx
	return n;
}
  8008db:	89 d0                	mov    %edx,%eax
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	53                   	push   %ebx
  8008e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ee:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008f2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008f5:	83 c0 01             	add    $0x1,%eax
  8008f8:	84 d2                	test   %dl,%dl
  8008fa:	75 f2                	jne    8008ee <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008fc:	89 c8                	mov    %ecx,%eax
  8008fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800901:	c9                   	leave  
  800902:	c3                   	ret    

00800903 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	83 ec 10             	sub    $0x10,%esp
  80090a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090d:	53                   	push   %ebx
  80090e:	e8 91 ff ff ff       	call   8008a4 <strlen>
  800913:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800916:	ff 75 0c             	push   0xc(%ebp)
  800919:	01 d8                	add    %ebx,%eax
  80091b:	50                   	push   %eax
  80091c:	e8 be ff ff ff       	call   8008df <strcpy>
	return dst;
}
  800921:	89 d8                	mov    %ebx,%eax
  800923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800926:	c9                   	leave  
  800927:	c3                   	ret    

00800928 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 75 08             	mov    0x8(%ebp),%esi
  800930:	8b 55 0c             	mov    0xc(%ebp),%edx
  800933:	89 f3                	mov    %esi,%ebx
  800935:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800938:	89 f0                	mov    %esi,%eax
  80093a:	eb 0f                	jmp    80094b <strncpy+0x23>
		*dst++ = *src;
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	0f b6 0a             	movzbl (%edx),%ecx
  800942:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800945:	80 f9 01             	cmp    $0x1,%cl
  800948:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80094b:	39 d8                	cmp    %ebx,%eax
  80094d:	75 ed                	jne    80093c <strncpy+0x14>
	}
	return ret;
}
  80094f:	89 f0                	mov    %esi,%eax
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	8b 75 08             	mov    0x8(%ebp),%esi
  80095d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800960:	8b 55 10             	mov    0x10(%ebp),%edx
  800963:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800965:	85 d2                	test   %edx,%edx
  800967:	74 21                	je     80098a <strlcpy+0x35>
  800969:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096d:	89 f2                	mov    %esi,%edx
  80096f:	eb 09                	jmp    80097a <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800971:	83 c1 01             	add    $0x1,%ecx
  800974:	83 c2 01             	add    $0x1,%edx
  800977:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80097a:	39 c2                	cmp    %eax,%edx
  80097c:	74 09                	je     800987 <strlcpy+0x32>
  80097e:	0f b6 19             	movzbl (%ecx),%ebx
  800981:	84 db                	test   %bl,%bl
  800983:	75 ec                	jne    800971 <strlcpy+0x1c>
  800985:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800987:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098a:	29 f0                	sub    %esi,%eax
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800999:	eb 06                	jmp    8009a1 <strcmp+0x11>
		p++, q++;
  80099b:	83 c1 01             	add    $0x1,%ecx
  80099e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a1:	0f b6 01             	movzbl (%ecx),%eax
  8009a4:	84 c0                	test   %al,%al
  8009a6:	74 04                	je     8009ac <strcmp+0x1c>
  8009a8:	3a 02                	cmp    (%edx),%al
  8009aa:	74 ef                	je     80099b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ac:	0f b6 c0             	movzbl %al,%eax
  8009af:	0f b6 12             	movzbl (%edx),%edx
  8009b2:	29 d0                	sub    %edx,%eax
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c0:	89 c3                	mov    %eax,%ebx
  8009c2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c5:	eb 06                	jmp    8009cd <strncmp+0x17>
		n--, p++, q++;
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009cd:	39 d8                	cmp    %ebx,%eax
  8009cf:	74 18                	je     8009e9 <strncmp+0x33>
  8009d1:	0f b6 08             	movzbl (%eax),%ecx
  8009d4:	84 c9                	test   %cl,%cl
  8009d6:	74 04                	je     8009dc <strncmp+0x26>
  8009d8:	3a 0a                	cmp    (%edx),%cl
  8009da:	74 eb                	je     8009c7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dc:	0f b6 00             	movzbl (%eax),%eax
  8009df:	0f b6 12             	movzbl (%edx),%edx
  8009e2:	29 d0                	sub    %edx,%eax
}
  8009e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    
		return 0;
  8009e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ee:	eb f4                	jmp    8009e4 <strncmp+0x2e>

008009f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fa:	eb 03                	jmp    8009ff <strchr+0xf>
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	0f b6 10             	movzbl (%eax),%edx
  800a02:	84 d2                	test   %dl,%dl
  800a04:	74 06                	je     800a0c <strchr+0x1c>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	75 f2                	jne    8009fc <strchr+0xc>
  800a0a:	eb 05                	jmp    800a11 <strchr+0x21>
			return (char *) s;
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a20:	38 ca                	cmp    %cl,%dl
  800a22:	74 09                	je     800a2d <strfind+0x1a>
  800a24:	84 d2                	test   %dl,%dl
  800a26:	74 05                	je     800a2d <strfind+0x1a>
	for (; *s; s++)
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f0                	jmp    800a1d <strfind+0xa>
			break;
	return (char *) s;
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3b:	85 c9                	test   %ecx,%ecx
  800a3d:	74 2f                	je     800a6e <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	09 c8                	or     %ecx,%eax
  800a43:	a8 03                	test   $0x3,%al
  800a45:	75 21                	jne    800a68 <memset+0x39>
		c &= 0xFF;
  800a47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	c1 e0 08             	shl    $0x8,%eax
  800a50:	89 d3                	mov    %edx,%ebx
  800a52:	c1 e3 18             	shl    $0x18,%ebx
  800a55:	89 d6                	mov    %edx,%esi
  800a57:	c1 e6 10             	shl    $0x10,%esi
  800a5a:	09 f3                	or     %esi,%ebx
  800a5c:	09 da                	or     %ebx,%edx
  800a5e:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a63:	fc                   	cld    
  800a64:	f3 ab                	rep stos %eax,%es:(%edi)
  800a66:	eb 06                	jmp    800a6e <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	fc                   	cld    
  800a6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	57                   	push   %edi
  800a79:	56                   	push   %esi
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a83:	39 c6                	cmp    %eax,%esi
  800a85:	73 32                	jae    800ab9 <memmove+0x44>
  800a87:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8a:	39 c2                	cmp    %eax,%edx
  800a8c:	76 2b                	jbe    800ab9 <memmove+0x44>
		s += n;
		d += n;
  800a8e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	89 d6                	mov    %edx,%esi
  800a93:	09 fe                	or     %edi,%esi
  800a95:	09 ce                	or     %ecx,%esi
  800a97:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9d:	75 0e                	jne    800aad <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9f:	83 ef 04             	sub    $0x4,%edi
  800aa2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa8:	fd                   	std    
  800aa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aab:	eb 09                	jmp    800ab6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aad:	83 ef 01             	sub    $0x1,%edi
  800ab0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab3:	fd                   	std    
  800ab4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab6:	fc                   	cld    
  800ab7:	eb 1a                	jmp    800ad3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab9:	89 f2                	mov    %esi,%edx
  800abb:	09 c2                	or     %eax,%edx
  800abd:	09 ca                	or     %ecx,%edx
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0a                	jne    800ace <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac7:	89 c7                	mov    %eax,%edi
  800ac9:	fc                   	cld    
  800aca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acc:	eb 05                	jmp    800ad3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	fc                   	cld    
  800ad1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad3:	5e                   	pop    %esi
  800ad4:	5f                   	pop    %edi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800add:	ff 75 10             	push   0x10(%ebp)
  800ae0:	ff 75 0c             	push   0xc(%ebp)
  800ae3:	ff 75 08             	push   0x8(%ebp)
  800ae6:	e8 8a ff ff ff       	call   800a75 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af8:	89 c6                	mov    %eax,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	eb 06                	jmp    800b05 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aff:	83 c0 01             	add    $0x1,%eax
  800b02:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b05:	39 f0                	cmp    %esi,%eax
  800b07:	74 14                	je     800b1d <memcmp+0x30>
		if (*s1 != *s2)
  800b09:	0f b6 08             	movzbl (%eax),%ecx
  800b0c:	0f b6 1a             	movzbl (%edx),%ebx
  800b0f:	38 d9                	cmp    %bl,%cl
  800b11:	74 ec                	je     800aff <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b13:	0f b6 c1             	movzbl %cl,%eax
  800b16:	0f b6 db             	movzbl %bl,%ebx
  800b19:	29 d8                	sub    %ebx,%eax
  800b1b:	eb 05                	jmp    800b22 <memcmp+0x35>
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	eb 03                	jmp    800b39 <memfind+0x13>
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	39 d0                	cmp    %edx,%eax
  800b3b:	73 04                	jae    800b41 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3d:	38 08                	cmp    %cl,(%eax)
  800b3f:	75 f5                	jne    800b36 <memfind+0x10>
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 02             	movzbl (%edx),%eax
  800b57:	3c 20                	cmp    $0x20,%al
  800b59:	74 f6                	je     800b51 <strtol+0xe>
  800b5b:	3c 09                	cmp    $0x9,%al
  800b5d:	74 f2                	je     800b51 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5f:	3c 2b                	cmp    $0x2b,%al
  800b61:	74 2a                	je     800b8d <strtol+0x4a>
	int neg = 0;
  800b63:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b68:	3c 2d                	cmp    $0x2d,%al
  800b6a:	74 2b                	je     800b97 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b72:	75 0f                	jne    800b83 <strtol+0x40>
  800b74:	80 3a 30             	cmpb   $0x30,(%edx)
  800b77:	74 28                	je     800ba1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b80:	0f 44 d8             	cmove  %eax,%ebx
  800b83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b88:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8b:	eb 46                	jmp    800bd3 <strtol+0x90>
		s++;
  800b8d:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
  800b95:	eb d5                	jmp    800b6c <strtol+0x29>
		s++, neg = 1;
  800b97:	83 c2 01             	add    $0x1,%edx
  800b9a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9f:	eb cb                	jmp    800b6c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba5:	74 0e                	je     800bb5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	75 d8                	jne    800b83 <strtol+0x40>
		s++, base = 8;
  800bab:	83 c2 01             	add    $0x1,%edx
  800bae:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb3:	eb ce                	jmp    800b83 <strtol+0x40>
		s += 2, base = 16;
  800bb5:	83 c2 02             	add    $0x2,%edx
  800bb8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbd:	eb c4                	jmp    800b83 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bbf:	0f be c0             	movsbl %al,%eax
  800bc2:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bc8:	7d 3a                	jge    800c04 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bca:	83 c2 01             	add    $0x1,%edx
  800bcd:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bd1:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bd3:	0f b6 02             	movzbl (%edx),%eax
  800bd6:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bd9:	89 f3                	mov    %esi,%ebx
  800bdb:	80 fb 09             	cmp    $0x9,%bl
  800bde:	76 df                	jbe    800bbf <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800be0:	8d 70 9f             	lea    -0x61(%eax),%esi
  800be3:	89 f3                	mov    %esi,%ebx
  800be5:	80 fb 19             	cmp    $0x19,%bl
  800be8:	77 08                	ja     800bf2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bea:	0f be c0             	movsbl %al,%eax
  800bed:	83 e8 57             	sub    $0x57,%eax
  800bf0:	eb d3                	jmp    800bc5 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bf2:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 19             	cmp    $0x19,%bl
  800bfa:	77 08                	ja     800c04 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfc:	0f be c0             	movsbl %al,%eax
  800bff:	83 e8 37             	sub    $0x37,%eax
  800c02:	eb c1                	jmp    800bc5 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c08:	74 05                	je     800c0f <strtol+0xcc>
		*endptr = (char *) s;
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c0f:	89 c8                	mov    %ecx,%eax
  800c11:	f7 d8                	neg    %eax
  800c13:	85 ff                	test   %edi,%edi
  800c15:	0f 45 c8             	cmovne %eax,%ecx
}
  800c18:	89 c8                	mov    %ecx,%eax
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    
  800c1f:	90                   	nop

00800c20 <__udivdi3>:
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	83 ec 1c             	sub    $0x1c,%esp
  800c2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800c2f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c33:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c37:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	75 19                	jne    800c58 <__udivdi3+0x38>
  800c3f:	39 f3                	cmp    %esi,%ebx
  800c41:	76 4d                	jbe    800c90 <__udivdi3+0x70>
  800c43:	31 ff                	xor    %edi,%edi
  800c45:	89 e8                	mov    %ebp,%eax
  800c47:	89 f2                	mov    %esi,%edx
  800c49:	f7 f3                	div    %ebx
  800c4b:	89 fa                	mov    %edi,%edx
  800c4d:	83 c4 1c             	add    $0x1c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    
  800c55:	8d 76 00             	lea    0x0(%esi),%esi
  800c58:	39 f0                	cmp    %esi,%eax
  800c5a:	76 14                	jbe    800c70 <__udivdi3+0x50>
  800c5c:	31 ff                	xor    %edi,%edi
  800c5e:	31 c0                	xor    %eax,%eax
  800c60:	89 fa                	mov    %edi,%edx
  800c62:	83 c4 1c             	add    $0x1c,%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
  800c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c70:	0f bd f8             	bsr    %eax,%edi
  800c73:	83 f7 1f             	xor    $0x1f,%edi
  800c76:	75 48                	jne    800cc0 <__udivdi3+0xa0>
  800c78:	39 f0                	cmp    %esi,%eax
  800c7a:	72 06                	jb     800c82 <__udivdi3+0x62>
  800c7c:	31 c0                	xor    %eax,%eax
  800c7e:	39 eb                	cmp    %ebp,%ebx
  800c80:	77 de                	ja     800c60 <__udivdi3+0x40>
  800c82:	b8 01 00 00 00       	mov    $0x1,%eax
  800c87:	eb d7                	jmp    800c60 <__udivdi3+0x40>
  800c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800c90:	89 d9                	mov    %ebx,%ecx
  800c92:	85 db                	test   %ebx,%ebx
  800c94:	75 0b                	jne    800ca1 <__udivdi3+0x81>
  800c96:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9b:	31 d2                	xor    %edx,%edx
  800c9d:	f7 f3                	div    %ebx
  800c9f:	89 c1                	mov    %eax,%ecx
  800ca1:	31 d2                	xor    %edx,%edx
  800ca3:	89 f0                	mov    %esi,%eax
  800ca5:	f7 f1                	div    %ecx
  800ca7:	89 c6                	mov    %eax,%esi
  800ca9:	89 e8                	mov    %ebp,%eax
  800cab:	89 f7                	mov    %esi,%edi
  800cad:	f7 f1                	div    %ecx
  800caf:	89 fa                	mov    %edi,%edx
  800cb1:	83 c4 1c             	add    $0x1c,%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    
  800cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cc0:	89 f9                	mov    %edi,%ecx
  800cc2:	ba 20 00 00 00       	mov    $0x20,%edx
  800cc7:	29 fa                	sub    %edi,%edx
  800cc9:	d3 e0                	shl    %cl,%eax
  800ccb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d8                	mov    %ebx,%eax
  800cd3:	d3 e8                	shr    %cl,%eax
  800cd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cd9:	09 c1                	or     %eax,%ecx
  800cdb:	89 f0                	mov    %esi,%eax
  800cdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ce1:	89 f9                	mov    %edi,%ecx
  800ce3:	d3 e3                	shl    %cl,%ebx
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	d3 e8                	shr    %cl,%eax
  800ce9:	89 f9                	mov    %edi,%ecx
  800ceb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cef:	89 eb                	mov    %ebp,%ebx
  800cf1:	d3 e6                	shl    %cl,%esi
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	d3 eb                	shr    %cl,%ebx
  800cf7:	09 f3                	or     %esi,%ebx
  800cf9:	89 c6                	mov    %eax,%esi
  800cfb:	89 f2                	mov    %esi,%edx
  800cfd:	89 d8                	mov    %ebx,%eax
  800cff:	f7 74 24 08          	divl   0x8(%esp)
  800d03:	89 d6                	mov    %edx,%esi
  800d05:	89 c3                	mov    %eax,%ebx
  800d07:	f7 64 24 0c          	mull   0xc(%esp)
  800d0b:	39 d6                	cmp    %edx,%esi
  800d0d:	72 19                	jb     800d28 <__udivdi3+0x108>
  800d0f:	89 f9                	mov    %edi,%ecx
  800d11:	d3 e5                	shl    %cl,%ebp
  800d13:	39 c5                	cmp    %eax,%ebp
  800d15:	73 04                	jae    800d1b <__udivdi3+0xfb>
  800d17:	39 d6                	cmp    %edx,%esi
  800d19:	74 0d                	je     800d28 <__udivdi3+0x108>
  800d1b:	89 d8                	mov    %ebx,%eax
  800d1d:	31 ff                	xor    %edi,%edi
  800d1f:	e9 3c ff ff ff       	jmp    800c60 <__udivdi3+0x40>
  800d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d2b:	31 ff                	xor    %edi,%edi
  800d2d:	e9 2e ff ff ff       	jmp    800c60 <__udivdi3+0x40>
  800d32:	66 90                	xchg   %ax,%ax
  800d34:	66 90                	xchg   %ax,%ax
  800d36:	66 90                	xchg   %ax,%ax
  800d38:	66 90                	xchg   %ax,%ax
  800d3a:	66 90                	xchg   %ax,%ax
  800d3c:	66 90                	xchg   %ax,%ax
  800d3e:	66 90                	xchg   %ax,%ax

00800d40 <__umoddi3>:
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
  800d48:	83 ec 1c             	sub    $0x1c,%esp
  800d4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d53:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800d57:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800d5b:	89 f0                	mov    %esi,%eax
  800d5d:	89 da                	mov    %ebx,%edx
  800d5f:	85 ff                	test   %edi,%edi
  800d61:	75 15                	jne    800d78 <__umoddi3+0x38>
  800d63:	39 dd                	cmp    %ebx,%ebp
  800d65:	76 39                	jbe    800da0 <__umoddi3+0x60>
  800d67:	f7 f5                	div    %ebp
  800d69:	89 d0                	mov    %edx,%eax
  800d6b:	31 d2                	xor    %edx,%edx
  800d6d:	83 c4 1c             	add    $0x1c,%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
  800d75:	8d 76 00             	lea    0x0(%esi),%esi
  800d78:	39 df                	cmp    %ebx,%edi
  800d7a:	77 f1                	ja     800d6d <__umoddi3+0x2d>
  800d7c:	0f bd cf             	bsr    %edi,%ecx
  800d7f:	83 f1 1f             	xor    $0x1f,%ecx
  800d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d86:	75 40                	jne    800dc8 <__umoddi3+0x88>
  800d88:	39 df                	cmp    %ebx,%edi
  800d8a:	72 04                	jb     800d90 <__umoddi3+0x50>
  800d8c:	39 f5                	cmp    %esi,%ebp
  800d8e:	77 dd                	ja     800d6d <__umoddi3+0x2d>
  800d90:	89 da                	mov    %ebx,%edx
  800d92:	89 f0                	mov    %esi,%eax
  800d94:	29 e8                	sub    %ebp,%eax
  800d96:	19 fa                	sbb    %edi,%edx
  800d98:	eb d3                	jmp    800d6d <__umoddi3+0x2d>
  800d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800da0:	89 e9                	mov    %ebp,%ecx
  800da2:	85 ed                	test   %ebp,%ebp
  800da4:	75 0b                	jne    800db1 <__umoddi3+0x71>
  800da6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dab:	31 d2                	xor    %edx,%edx
  800dad:	f7 f5                	div    %ebp
  800daf:	89 c1                	mov    %eax,%ecx
  800db1:	89 d8                	mov    %ebx,%eax
  800db3:	31 d2                	xor    %edx,%edx
  800db5:	f7 f1                	div    %ecx
  800db7:	89 f0                	mov    %esi,%eax
  800db9:	f7 f1                	div    %ecx
  800dbb:	89 d0                	mov    %edx,%eax
  800dbd:	31 d2                	xor    %edx,%edx
  800dbf:	eb ac                	jmp    800d6d <__umoddi3+0x2d>
  800dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800dc8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dcc:	ba 20 00 00 00       	mov    $0x20,%edx
  800dd1:	29 c2                	sub    %eax,%edx
  800dd3:	89 c1                	mov    %eax,%ecx
  800dd5:	89 e8                	mov    %ebp,%eax
  800dd7:	d3 e7                	shl    %cl,%edi
  800dd9:	89 d1                	mov    %edx,%ecx
  800ddb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ddf:	d3 e8                	shr    %cl,%eax
  800de1:	89 c1                	mov    %eax,%ecx
  800de3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800de7:	09 f9                	or     %edi,%ecx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800def:	89 c1                	mov    %eax,%ecx
  800df1:	d3 e5                	shl    %cl,%ebp
  800df3:	89 d1                	mov    %edx,%ecx
  800df5:	d3 ef                	shr    %cl,%edi
  800df7:	89 c1                	mov    %eax,%ecx
  800df9:	89 f0                	mov    %esi,%eax
  800dfb:	d3 e3                	shl    %cl,%ebx
  800dfd:	89 d1                	mov    %edx,%ecx
  800dff:	89 fa                	mov    %edi,%edx
  800e01:	d3 e8                	shr    %cl,%eax
  800e03:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e08:	09 d8                	or     %ebx,%eax
  800e0a:	f7 74 24 08          	divl   0x8(%esp)
  800e0e:	89 d3                	mov    %edx,%ebx
  800e10:	d3 e6                	shl    %cl,%esi
  800e12:	f7 e5                	mul    %ebp
  800e14:	89 c7                	mov    %eax,%edi
  800e16:	89 d1                	mov    %edx,%ecx
  800e18:	39 d3                	cmp    %edx,%ebx
  800e1a:	72 06                	jb     800e22 <__umoddi3+0xe2>
  800e1c:	75 0e                	jne    800e2c <__umoddi3+0xec>
  800e1e:	39 c6                	cmp    %eax,%esi
  800e20:	73 0a                	jae    800e2c <__umoddi3+0xec>
  800e22:	29 e8                	sub    %ebp,%eax
  800e24:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800e28:	89 d1                	mov    %edx,%ecx
  800e2a:	89 c7                	mov    %eax,%edi
  800e2c:	89 f5                	mov    %esi,%ebp
  800e2e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e32:	29 fd                	sub    %edi,%ebp
  800e34:	19 cb                	sbb    %ecx,%ebx
  800e36:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e3b:	89 d8                	mov    %ebx,%eax
  800e3d:	d3 e0                	shl    %cl,%eax
  800e3f:	89 f1                	mov    %esi,%ecx
  800e41:	d3 ed                	shr    %cl,%ebp
  800e43:	d3 eb                	shr    %cl,%ebx
  800e45:	09 e8                	or     %ebp,%eax
  800e47:	89 da                	mov    %ebx,%edx
  800e49:	83 c4 1c             	add    $0x1c,%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
