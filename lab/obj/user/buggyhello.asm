
obj/user/buggyhello:     file format elf32-i386


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
  80002c:	e8 29 00 00 00       	call   80005a <libmain>
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
  80003a:	e8 17 00 00 00       	call   800056 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	sys_cputs((char*)1, 1);
  800045:	6a 01                	push   $0x1
  800047:	6a 01                	push   $0x1
  800049:	e8 89 00 00 00       	call   8000d7 <sys_cputs>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <__x86.get_pc_thunk.bx>:
  800056:	8b 1c 24             	mov    (%esp),%ebx
  800059:	c3                   	ret    

0080005a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005a:	55                   	push   %ebp
  80005b:	89 e5                	mov    %esp,%ebp
  80005d:	57                   	push   %edi
  80005e:	56                   	push   %esi
  80005f:	53                   	push   %ebx
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	e8 ee ff ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  800068:	81 c3 98 1f 00 00    	add    $0x1f98,%ebx
  80006e:	8b 75 08             	mov    0x8(%ebp),%esi
  800071:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800074:	e8 f0 00 00 00       	call   800169 <sys_getenvid>
  800079:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007e:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800081:	c1 e0 05             	shl    $0x5,%eax
  800084:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80008a:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800090:	85 f6                	test   %esi,%esi
  800092:	7e 08                	jle    80009c <libmain+0x42>
		binaryname = argv[0];
  800094:	8b 07                	mov    (%edi),%eax
  800096:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0b 00 00 00       	call   8000b6 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5f                   	pop    %edi
  8000b4:	5d                   	pop    %ebp
  8000b5:	c3                   	ret    

008000b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	53                   	push   %ebx
  8000ba:	83 ec 10             	sub    $0x10,%esp
  8000bd:	e8 94 ff ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  8000c2:	81 c3 3e 1f 00 00    	add    $0x1f3e,%ebx
	sys_env_destroy(0);
  8000c8:	6a 00                	push   $0x0
  8000ca:	e8 45 00 00 00       	call   800114 <sys_env_destroy>
}
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d5:	c9                   	leave  
  8000d6:	c3                   	ret    

008000d7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e8:	89 c3                	mov    %eax,%ebx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 c6                	mov    %eax,%esi
  8000ee:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f0:	5b                   	pop    %ebx
  8000f1:	5e                   	pop    %esi
  8000f2:	5f                   	pop    %edi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    

008000f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	57                   	push   %edi
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800100:	b8 01 00 00 00       	mov    $0x1,%eax
  800105:	89 d1                	mov    %edx,%ecx
  800107:	89 d3                	mov    %edx,%ebx
  800109:	89 d7                	mov    %edx,%edi
  80010b:	89 d6                	mov    %edx,%esi
  80010d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5f                   	pop    %edi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    

00800114 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	57                   	push   %edi
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	83 ec 1c             	sub    $0x1c,%esp
  80011d:	e8 66 00 00 00       	call   800188 <__x86.get_pc_thunk.ax>
  800122:	05 de 1e 00 00       	add    $0x1ede,%eax
  800127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80012a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012f:	8b 55 08             	mov    0x8(%ebp),%edx
  800132:	b8 03 00 00 00       	mov    $0x3,%eax
  800137:	89 cb                	mov    %ecx,%ebx
  800139:	89 cf                	mov    %ecx,%edi
  80013b:	89 ce                	mov    %ecx,%esi
  80013d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80013f:	85 c0                	test   %eax,%eax
  800141:	7f 08                	jg     80014b <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	50                   	push   %eax
  80014f:	6a 03                	push   $0x3
  800151:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800154:	8d 83 7e ee ff ff    	lea    -0x1182(%ebx),%eax
  80015a:	50                   	push   %eax
  80015b:	6a 23                	push   $0x23
  80015d:	8d 83 9b ee ff ff    	lea    -0x1165(%ebx),%eax
  800163:	50                   	push   %eax
  800164:	e8 23 00 00 00       	call   80018c <_panic>

00800169 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016f:	ba 00 00 00 00       	mov    $0x0,%edx
  800174:	b8 02 00 00 00       	mov    $0x2,%eax
  800179:	89 d1                	mov    %edx,%ecx
  80017b:	89 d3                	mov    %edx,%ebx
  80017d:	89 d7                	mov    %edx,%edi
  80017f:	89 d6                	mov    %edx,%esi
  800181:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    

00800188 <__x86.get_pc_thunk.ax>:
  800188:	8b 04 24             	mov    (%esp),%eax
  80018b:	c3                   	ret    

0080018c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	57                   	push   %edi
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	e8 bc fe ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  80019a:	81 c3 66 1e 00 00    	add    $0x1e66,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001a0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a3:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001a9:	8b 38                	mov    (%eax),%edi
  8001ab:	e8 b9 ff ff ff       	call   800169 <sys_getenvid>
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	ff 75 0c             	push   0xc(%ebp)
  8001b6:	ff 75 08             	push   0x8(%ebp)
  8001b9:	57                   	push   %edi
  8001ba:	50                   	push   %eax
  8001bb:	8d 83 ac ee ff ff    	lea    -0x1154(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 d1 00 00 00       	call   800298 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c7:	83 c4 18             	add    $0x18,%esp
  8001ca:	56                   	push   %esi
  8001cb:	ff 75 10             	push   0x10(%ebp)
  8001ce:	e8 63 00 00 00       	call   800236 <vcprintf>
	cprintf("\n");
  8001d3:	8d 83 cf ee ff ff    	lea    -0x1131(%ebx),%eax
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 b7 00 00 00       	call   800298 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e4:	cc                   	int3   
  8001e5:	eb fd                	jmp    8001e4 <_panic+0x58>

008001e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	e8 65 fe ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  8001f1:	81 c3 0f 1e 00 00    	add    $0x1e0f,%ebx
  8001f7:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001fa:	8b 16                	mov    (%esi),%edx
  8001fc:	8d 42 01             	lea    0x1(%edx),%eax
  8001ff:	89 06                	mov    %eax,(%esi)
  800201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800204:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800208:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020d:	74 0b                	je     80021a <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800213:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021a:	83 ec 08             	sub    $0x8,%esp
  80021d:	68 ff 00 00 00       	push   $0xff
  800222:	8d 46 08             	lea    0x8(%esi),%eax
  800225:	50                   	push   %eax
  800226:	e8 ac fe ff ff       	call   8000d7 <sys_cputs>
		b->idx = 0;
  80022b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	eb d9                	jmp    80020f <putch+0x28>

00800236 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	53                   	push   %ebx
  80023a:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800240:	e8 11 fe ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  800245:	81 c3 bb 1d 00 00    	add    $0x1dbb,%ebx
	struct printbuf b;

	b.idx = 0;
  80024b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800252:	00 00 00 
	b.cnt = 0;
  800255:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025f:	ff 75 0c             	push   0xc(%ebp)
  800262:	ff 75 08             	push   0x8(%ebp)
  800265:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	8d 83 e7 e1 ff ff    	lea    -0x1e19(%ebx),%eax
  800272:	50                   	push   %eax
  800273:	e8 2c 01 00 00       	call   8003a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800278:	83 c4 08             	add    $0x8,%esp
  80027b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800281:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800287:	50                   	push   %eax
  800288:	e8 4a fe ff ff       	call   8000d7 <sys_cputs>

	return b.cnt;
}
  80028d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a1:	50                   	push   %eax
  8002a2:	ff 75 08             	push   0x8(%ebp)
  8002a5:	e8 8c ff ff ff       	call   800236 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	57                   	push   %edi
  8002b0:	56                   	push   %esi
  8002b1:	53                   	push   %ebx
  8002b2:	83 ec 2c             	sub    $0x2c,%esp
  8002b5:	e8 07 06 00 00       	call   8008c1 <__x86.get_pc_thunk.cx>
  8002ba:	81 c1 46 1d 00 00    	add    $0x1d46,%ecx
  8002c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c3:	89 c7                	mov    %eax,%edi
  8002c5:	89 d6                	mov    %edx,%esi
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cd:	89 d1                	mov    %edx,%ecx
  8002cf:	89 c2                	mov    %eax,%edx
  8002d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002e7:	39 c2                	cmp    %eax,%edx
  8002e9:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ec:	72 41                	jb     80032f <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	ff 75 18             	push   0x18(%ebp)
  8002f4:	83 eb 01             	sub    $0x1,%ebx
  8002f7:	53                   	push   %ebx
  8002f8:	50                   	push   %eax
  8002f9:	83 ec 08             	sub    $0x8,%esp
  8002fc:	ff 75 e4             	push   -0x1c(%ebp)
  8002ff:	ff 75 e0             	push   -0x20(%ebp)
  800302:	ff 75 d4             	push   -0x2c(%ebp)
  800305:	ff 75 d0             	push   -0x30(%ebp)
  800308:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80030b:	e8 30 09 00 00       	call   800c40 <__udivdi3>
  800310:	83 c4 18             	add    $0x18,%esp
  800313:	52                   	push   %edx
  800314:	50                   	push   %eax
  800315:	89 f2                	mov    %esi,%edx
  800317:	89 f8                	mov    %edi,%eax
  800319:	e8 8e ff ff ff       	call   8002ac <printnum>
  80031e:	83 c4 20             	add    $0x20,%esp
  800321:	eb 13                	jmp    800336 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	56                   	push   %esi
  800327:	ff 75 18             	push   0x18(%ebp)
  80032a:	ff d7                	call   *%edi
  80032c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80032f:	83 eb 01             	sub    $0x1,%ebx
  800332:	85 db                	test   %ebx,%ebx
  800334:	7f ed                	jg     800323 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	56                   	push   %esi
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	ff 75 e4             	push   -0x1c(%ebp)
  800340:	ff 75 e0             	push   -0x20(%ebp)
  800343:	ff 75 d4             	push   -0x2c(%ebp)
  800346:	ff 75 d0             	push   -0x30(%ebp)
  800349:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80034c:	e8 0f 0a 00 00       	call   800d60 <__umoddi3>
  800351:	83 c4 14             	add    $0x14,%esp
  800354:	0f be 84 03 d1 ee ff 	movsbl -0x112f(%ebx,%eax,1),%eax
  80035b:	ff 
  80035c:	50                   	push   %eax
  80035d:	ff d7                	call   *%edi
}
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800365:	5b                   	pop    %ebx
  800366:	5e                   	pop    %esi
  800367:	5f                   	pop    %edi
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800370:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800374:	8b 10                	mov    (%eax),%edx
  800376:	3b 50 04             	cmp    0x4(%eax),%edx
  800379:	73 0a                	jae    800385 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	88 02                	mov    %al,(%edx)
}
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <printfmt>:
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80038d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800390:	50                   	push   %eax
  800391:	ff 75 10             	push   0x10(%ebp)
  800394:	ff 75 0c             	push   0xc(%ebp)
  800397:	ff 75 08             	push   0x8(%ebp)
  80039a:	e8 05 00 00 00       	call   8003a4 <vprintfmt>
}
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <vprintfmt>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 3c             	sub    $0x3c,%esp
  8003ad:	e8 d6 fd ff ff       	call   800188 <__x86.get_pc_thunk.ax>
  8003b2:	05 4e 1c 00 00       	add    $0x1c4e,%eax
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c3:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003cc:	eb 0a                	jmp    8003d8 <vprintfmt+0x34>
			putch(ch, putdat);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	57                   	push   %edi
  8003d2:	50                   	push   %eax
  8003d3:	ff d6                	call   *%esi
  8003d5:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d8:	83 c3 01             	add    $0x1,%ebx
  8003db:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003df:	83 f8 25             	cmp    $0x25,%eax
  8003e2:	74 0c                	je     8003f0 <vprintfmt+0x4c>
			if (ch == '\0')
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	75 e6                	jne    8003ce <vprintfmt+0x2a>
}
  8003e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003eb:	5b                   	pop    %ebx
  8003ec:	5e                   	pop    %esi
  8003ed:	5f                   	pop    %edi
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    
		padc = ' ';
  8003f0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003f4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800402:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800409:	b9 00 00 00 00       	mov    $0x0,%ecx
  80040e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800411:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8d 43 01             	lea    0x1(%ebx),%eax
  800417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041a:	0f b6 13             	movzbl (%ebx),%edx
  80041d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800420:	3c 55                	cmp    $0x55,%al
  800422:	0f 87 fd 03 00 00    	ja     800825 <.L20>
  800428:	0f b6 c0             	movzbl %al,%eax
  80042b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042e:	89 ce                	mov    %ecx,%esi
  800430:	03 b4 81 60 ef ff ff 	add    -0x10a0(%ecx,%eax,4),%esi
  800437:	ff e6                	jmp    *%esi

00800439 <.L68>:
  800439:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80043c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800440:	eb d2                	jmp    800414 <vprintfmt+0x70>

00800442 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800445:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800449:	eb c9                	jmp    800414 <vprintfmt+0x70>

0080044b <.L31>:
  80044b:	0f b6 d2             	movzbl %dl,%edx
  80044e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
  800456:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800459:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80045c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800460:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800463:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800466:	83 f9 09             	cmp    $0x9,%ecx
  800469:	77 58                	ja     8004c3 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80046b:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80046e:	eb e9                	jmp    800459 <.L31+0xe>

00800470 <.L34>:
			precision = va_arg(ap, int);
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 40 04             	lea    0x4(%eax),%eax
  80047e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800484:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800488:	79 8a                	jns    800414 <vprintfmt+0x70>
				width = precision, precision = -1;
  80048a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800490:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800497:	e9 78 ff ff ff       	jmp    800414 <vprintfmt+0x70>

0080049c <.L33>:
  80049c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049f:	85 d2                	test   %edx,%edx
  8004a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a6:	0f 49 c2             	cmovns %edx,%eax
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004af:	e9 60 ff ff ff       	jmp    800414 <vprintfmt+0x70>

008004b4 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004be:	e9 51 ff ff ff       	jmp    800414 <vprintfmt+0x70>
  8004c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c9:	eb b9                	jmp    800484 <.L34+0x14>

008004cb <.L27>:
			lflag++;
  8004cb:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d2:	e9 3d ff ff ff       	jmp    800414 <vprintfmt+0x70>

008004d7 <.L30>:
			putch(va_arg(ap, int), putdat);
  8004d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	57                   	push   %edi
  8004e4:	ff 30                	push   (%eax)
  8004e6:	ff d6                	call   *%esi
			break;
  8004e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004eb:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004ee:	e9 c8 02 00 00       	jmp    8007bb <.L25+0x45>

008004f3 <.L28>:
			err = va_arg(ap, int);
  8004f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 58 04             	lea    0x4(%eax),%ebx
  8004fc:	8b 10                	mov    (%eax),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	f7 d8                	neg    %eax
  800502:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800505:	83 f8 06             	cmp    $0x6,%eax
  800508:	7f 27                	jg     800531 <.L28+0x3e>
  80050a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80050d:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800510:	85 d2                	test   %edx,%edx
  800512:	74 1d                	je     800531 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  800514:	52                   	push   %edx
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	8d 80 f2 ee ff ff    	lea    -0x110e(%eax),%eax
  80051e:	50                   	push   %eax
  80051f:	57                   	push   %edi
  800520:	56                   	push   %esi
  800521:	e8 61 fe ff ff       	call   800387 <printfmt>
  800526:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800529:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80052c:	e9 8a 02 00 00       	jmp    8007bb <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800531:	50                   	push   %eax
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	8d 80 e9 ee ff ff    	lea    -0x1117(%eax),%eax
  80053b:	50                   	push   %eax
  80053c:	57                   	push   %edi
  80053d:	56                   	push   %esi
  80053e:	e8 44 fe ff ff       	call   800387 <printfmt>
  800543:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800546:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800549:	e9 6d 02 00 00       	jmp    8007bb <.L25+0x45>

0080054e <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  80054e:	8b 75 08             	mov    0x8(%ebp),%esi
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 c0 04             	add    $0x4,%eax
  800557:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80055f:	85 d2                	test   %edx,%edx
  800561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800564:	8d 80 e2 ee ff ff    	lea    -0x111e(%eax),%eax
  80056a:	0f 45 c2             	cmovne %edx,%eax
  80056d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800570:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800574:	7e 06                	jle    80057c <.L24+0x2e>
  800576:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057a:	75 0d                	jne    800589 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80057f:	89 c3                	mov    %eax,%ebx
  800581:	03 45 d4             	add    -0x2c(%ebp),%eax
  800584:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800587:	eb 58                	jmp    8005e1 <.L24+0x93>
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 d8             	push   -0x28(%ebp)
  80058f:	ff 75 c8             	push   -0x38(%ebp)
  800592:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800595:	e8 43 03 00 00       	call   8008dd <strnlen>
  80059a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059d:	29 c2                	sub    %eax,%edx
  80059f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ae:	eb 0f                	jmp    8005bf <.L24+0x71>
					putch(padc, putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	57                   	push   %edi
  8005b4:	ff 75 d4             	push   -0x2c(%ebp)
  8005b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	83 eb 01             	sub    $0x1,%ebx
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	85 db                	test   %ebx,%ebx
  8005c1:	7f ed                	jg     8005b0 <.L24+0x62>
  8005c3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	0f 49 c2             	cmovns %edx,%eax
  8005d0:	29 c2                	sub    %eax,%edx
  8005d2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d5:	eb a5                	jmp    80057c <.L24+0x2e>
					putch(ch, putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	57                   	push   %edi
  8005db:	52                   	push   %edx
  8005dc:	ff d6                	call   *%esi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e4:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e6:	83 c3 01             	add    $0x1,%ebx
  8005e9:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005ed:	0f be d0             	movsbl %al,%edx
  8005f0:	85 d2                	test   %edx,%edx
  8005f2:	74 4b                	je     80063f <.L24+0xf1>
  8005f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f8:	78 06                	js     800600 <.L24+0xb2>
  8005fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005fe:	78 1e                	js     80061e <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800600:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800604:	74 d1                	je     8005d7 <.L24+0x89>
  800606:	0f be c0             	movsbl %al,%eax
  800609:	83 e8 20             	sub    $0x20,%eax
  80060c:	83 f8 5e             	cmp    $0x5e,%eax
  80060f:	76 c6                	jbe    8005d7 <.L24+0x89>
					putch('?', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	57                   	push   %edi
  800615:	6a 3f                	push   $0x3f
  800617:	ff d6                	call   *%esi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	eb c3                	jmp    8005e1 <.L24+0x93>
  80061e:	89 cb                	mov    %ecx,%ebx
  800620:	eb 0e                	jmp    800630 <.L24+0xe2>
				putch(' ', putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	57                   	push   %edi
  800626:	6a 20                	push   $0x20
  800628:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062a:	83 eb 01             	sub    $0x1,%ebx
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	85 db                	test   %ebx,%ebx
  800632:	7f ee                	jg     800622 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800634:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
  80063a:	e9 7c 01 00 00       	jmp    8007bb <.L25+0x45>
  80063f:	89 cb                	mov    %ecx,%ebx
  800641:	eb ed                	jmp    800630 <.L24+0xe2>

00800643 <.L29>:
	if (lflag >= 2)
  800643:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800646:	8b 75 08             	mov    0x8(%ebp),%esi
  800649:	83 f9 01             	cmp    $0x1,%ecx
  80064c:	7f 1b                	jg     800669 <.L29+0x26>
	else if (lflag)
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	74 63                	je     8006b5 <.L29+0x72>
		return va_arg(*ap, long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	99                   	cltd   
  80065b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 40 04             	lea    0x4(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	eb 17                	jmp    800680 <.L29+0x3d>
		return va_arg(*ap, long long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 40 08             	lea    0x8(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800680:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800683:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800686:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  80068b:	85 db                	test   %ebx,%ebx
  80068d:	0f 89 0e 01 00 00    	jns    8007a1 <.L25+0x2b>
				putch('-', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	57                   	push   %edi
  800697:	6a 2d                	push   $0x2d
  800699:	ff d6                	call   *%esi
				num = -(long long) num;
  80069b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80069e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a1:	f7 d9                	neg    %ecx
  8006a3:	83 d3 00             	adc    $0x0,%ebx
  8006a6:	f7 db                	neg    %ebx
  8006a8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ab:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b0:	e9 ec 00 00 00       	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, int);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	99                   	cltd   
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ca:	eb b4                	jmp    800680 <.L29+0x3d>

008006cc <.L23>:
	if (lflag >= 2)
  8006cc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d2:	83 f9 01             	cmp    $0x1,%ecx
  8006d5:	7f 1e                	jg     8006f5 <.L23+0x29>
	else if (lflag)
  8006d7:	85 c9                	test   %ecx,%ecx
  8006d9:	74 32                	je     80070d <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 08                	mov    (%eax),%ecx
  8006e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006eb:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006f0:	e9 ac 00 00 00       	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 08                	mov    (%eax),%ecx
  8006fa:	8b 58 04             	mov    0x4(%eax),%ebx
  8006fd:	8d 40 08             	lea    0x8(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800703:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  800708:	e9 94 00 00 00       	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 08                	mov    (%eax),%ecx
  800712:	bb 00 00 00 00       	mov    $0x0,%ebx
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800722:	eb 7d                	jmp    8007a1 <.L25+0x2b>

00800724 <.L26>:
	if (lflag >= 2)
  800724:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800727:	8b 75 08             	mov    0x8(%ebp),%esi
  80072a:	83 f9 01             	cmp    $0x1,%ecx
  80072d:	7f 1b                	jg     80074a <.L26+0x26>
	else if (lflag)
  80072f:	85 c9                	test   %ecx,%ecx
  800731:	74 2c                	je     80075f <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 08                	mov    (%eax),%ecx
  800738:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800743:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800748:	eb 57                	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 08                	mov    (%eax),%ecx
  80074f:	8b 58 04             	mov    0x4(%eax),%ebx
  800752:	8d 40 08             	lea    0x8(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800758:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  80075d:	eb 42                	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 08                	mov    (%eax),%ecx
  800764:	bb 00 00 00 00       	mov    $0x0,%ebx
  800769:	8d 40 04             	lea    0x4(%eax),%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076f:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800774:	eb 2b                	jmp    8007a1 <.L25+0x2b>

00800776 <.L25>:
			putch('0', putdat);
  800776:	8b 75 08             	mov    0x8(%ebp),%esi
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	57                   	push   %edi
  80077d:	6a 30                	push   $0x30
  80077f:	ff d6                	call   *%esi
			putch('x', putdat);
  800781:	83 c4 08             	add    $0x8,%esp
  800784:	57                   	push   %edi
  800785:	6a 78                	push   $0x78
  800787:	ff d6                	call   *%esi
			num = (unsigned long long)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 08                	mov    (%eax),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800793:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8007a1:	83 ec 0c             	sub    $0xc,%esp
  8007a4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a8:	50                   	push   %eax
  8007a9:	ff 75 d4             	push   -0x2c(%ebp)
  8007ac:	52                   	push   %edx
  8007ad:	53                   	push   %ebx
  8007ae:	51                   	push   %ecx
  8007af:	89 fa                	mov    %edi,%edx
  8007b1:	89 f0                	mov    %esi,%eax
  8007b3:	e8 f4 fa ff ff       	call   8002ac <printnum>
			break;
  8007b8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007bb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007be:	e9 15 fc ff ff       	jmp    8003d8 <vprintfmt+0x34>

008007c3 <.L21>:
	if (lflag >= 2)
  8007c3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c9:	83 f9 01             	cmp    $0x1,%ecx
  8007cc:	7f 1b                	jg     8007e9 <.L21+0x26>
	else if (lflag)
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	74 2c                	je     8007fe <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 08                	mov    (%eax),%ecx
  8007d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007e7:	eb b8                	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 08                	mov    (%eax),%ecx
  8007ee:	8b 58 04             	mov    0x4(%eax),%ebx
  8007f1:	8d 40 08             	lea    0x8(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f7:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007fc:	eb a3                	jmp    8007a1 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8b 08                	mov    (%eax),%ecx
  800803:	bb 00 00 00 00       	mov    $0x0,%ebx
  800808:	8d 40 04             	lea    0x4(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080e:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  800813:	eb 8c                	jmp    8007a1 <.L25+0x2b>

00800815 <.L35>:
			putch(ch, putdat);
  800815:	8b 75 08             	mov    0x8(%ebp),%esi
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	57                   	push   %edi
  80081c:	6a 25                	push   $0x25
  80081e:	ff d6                	call   *%esi
			break;
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	eb 96                	jmp    8007bb <.L25+0x45>

00800825 <.L20>:
			putch('%', putdat);
  800825:	8b 75 08             	mov    0x8(%ebp),%esi
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	57                   	push   %edi
  80082c:	6a 25                	push   $0x25
  80082e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	89 d8                	mov    %ebx,%eax
  800835:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800839:	74 05                	je     800840 <.L20+0x1b>
  80083b:	83 e8 01             	sub    $0x1,%eax
  80083e:	eb f5                	jmp    800835 <.L20+0x10>
  800840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800843:	e9 73 ff ff ff       	jmp    8007bb <.L25+0x45>

00800848 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	53                   	push   %ebx
  80084c:	83 ec 14             	sub    $0x14,%esp
  80084f:	e8 02 f8 ff ff       	call   800056 <__x86.get_pc_thunk.bx>
  800854:	81 c3 ac 17 00 00    	add    $0x17ac,%ebx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800860:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800863:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800867:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800871:	85 c0                	test   %eax,%eax
  800873:	74 2b                	je     8008a0 <vsnprintf+0x58>
  800875:	85 d2                	test   %edx,%edx
  800877:	7e 27                	jle    8008a0 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800879:	ff 75 14             	push   0x14(%ebp)
  80087c:	ff 75 10             	push   0x10(%ebp)
  80087f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800882:	50                   	push   %eax
  800883:	8d 83 6a e3 ff ff    	lea    -0x1c96(%ebx),%eax
  800889:	50                   	push   %eax
  80088a:	e8 15 fb ff ff       	call   8003a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800892:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800898:	83 c4 10             	add    $0x10,%esp
}
  80089b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    
		return -E_INVAL;
  8008a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a5:	eb f4                	jmp    80089b <vsnprintf+0x53>

008008a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ad:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 10             	push   0x10(%ebp)
  8008b4:	ff 75 0c             	push   0xc(%ebp)
  8008b7:	ff 75 08             	push   0x8(%ebp)
  8008ba:	e8 89 ff ff ff       	call   800848 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <__x86.get_pc_thunk.cx>:
  8008c1:	8b 0c 24             	mov    (%esp),%ecx
  8008c4:	c3                   	ret    

008008c5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	eb 03                	jmp    8008d5 <strlen+0x10>
		n++;
  8008d2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d9:	75 f7                	jne    8008d2 <strlen+0xd>
	return n;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb 03                	jmp    8008f0 <strnlen+0x13>
		n++;
  8008ed:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f0:	39 d0                	cmp    %edx,%eax
  8008f2:	74 08                	je     8008fc <strnlen+0x1f>
  8008f4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008f8:	75 f3                	jne    8008ed <strnlen+0x10>
  8008fa:	89 c2                	mov    %eax,%edx
	return n;
}
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	53                   	push   %ebx
  800904:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800913:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	84 d2                	test   %dl,%dl
  80091b:	75 f2                	jne    80090f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80091d:	89 c8                	mov    %ecx,%eax
  80091f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	53                   	push   %ebx
  800928:	83 ec 10             	sub    $0x10,%esp
  80092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092e:	53                   	push   %ebx
  80092f:	e8 91 ff ff ff       	call   8008c5 <strlen>
  800934:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800937:	ff 75 0c             	push   0xc(%ebp)
  80093a:	01 d8                	add    %ebx,%eax
  80093c:	50                   	push   %eax
  80093d:	e8 be ff ff ff       	call   800900 <strcpy>
	return dst;
}
  800942:	89 d8                	mov    %ebx,%eax
  800944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	8b 75 08             	mov    0x8(%ebp),%esi
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	89 f3                	mov    %esi,%ebx
  800956:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800959:	89 f0                	mov    %esi,%eax
  80095b:	eb 0f                	jmp    80096c <strncpy+0x23>
		*dst++ = *src;
  80095d:	83 c0 01             	add    $0x1,%eax
  800960:	0f b6 0a             	movzbl (%edx),%ecx
  800963:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800966:	80 f9 01             	cmp    $0x1,%cl
  800969:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80096c:	39 d8                	cmp    %ebx,%eax
  80096e:	75 ed                	jne    80095d <strncpy+0x14>
	}
	return ret;
}
  800970:	89 f0                	mov    %esi,%eax
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800981:	8b 55 10             	mov    0x10(%ebp),%edx
  800984:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800986:	85 d2                	test   %edx,%edx
  800988:	74 21                	je     8009ab <strlcpy+0x35>
  80098a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80098e:	89 f2                	mov    %esi,%edx
  800990:	eb 09                	jmp    80099b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800992:	83 c1 01             	add    $0x1,%ecx
  800995:	83 c2 01             	add    $0x1,%edx
  800998:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80099b:	39 c2                	cmp    %eax,%edx
  80099d:	74 09                	je     8009a8 <strlcpy+0x32>
  80099f:	0f b6 19             	movzbl (%ecx),%ebx
  8009a2:	84 db                	test   %bl,%bl
  8009a4:	75 ec                	jne    800992 <strlcpy+0x1c>
  8009a6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ab:	29 f0                	sub    %esi,%eax
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ba:	eb 06                	jmp    8009c2 <strcmp+0x11>
		p++, q++;
  8009bc:	83 c1 01             	add    $0x1,%ecx
  8009bf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009c2:	0f b6 01             	movzbl (%ecx),%eax
  8009c5:	84 c0                	test   %al,%al
  8009c7:	74 04                	je     8009cd <strcmp+0x1c>
  8009c9:	3a 02                	cmp    (%edx),%al
  8009cb:	74 ef                	je     8009bc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 c0             	movzbl %al,%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	53                   	push   %ebx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e1:	89 c3                	mov    %eax,%ebx
  8009e3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e6:	eb 06                	jmp    8009ee <strncmp+0x17>
		n--, p++, q++;
  8009e8:	83 c0 01             	add    $0x1,%eax
  8009eb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ee:	39 d8                	cmp    %ebx,%eax
  8009f0:	74 18                	je     800a0a <strncmp+0x33>
  8009f2:	0f b6 08             	movzbl (%eax),%ecx
  8009f5:	84 c9                	test   %cl,%cl
  8009f7:	74 04                	je     8009fd <strncmp+0x26>
  8009f9:	3a 0a                	cmp    (%edx),%cl
  8009fb:	74 eb                	je     8009e8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fd:	0f b6 00             	movzbl (%eax),%eax
  800a00:	0f b6 12             	movzbl (%edx),%edx
  800a03:	29 d0                	sub    %edx,%eax
}
  800a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    
		return 0;
  800a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0f:	eb f4                	jmp    800a05 <strncmp+0x2e>

00800a11 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1b:	eb 03                	jmp    800a20 <strchr+0xf>
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	0f b6 10             	movzbl (%eax),%edx
  800a23:	84 d2                	test   %dl,%dl
  800a25:	74 06                	je     800a2d <strchr+0x1c>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	75 f2                	jne    800a1d <strchr+0xc>
  800a2b:	eb 05                	jmp    800a32 <strchr+0x21>
			return (char *) s;
	return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a41:	38 ca                	cmp    %cl,%dl
  800a43:	74 09                	je     800a4e <strfind+0x1a>
  800a45:	84 d2                	test   %dl,%dl
  800a47:	74 05                	je     800a4e <strfind+0x1a>
	for (; *s; s++)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	eb f0                	jmp    800a3e <strfind+0xa>
			break;
	return (char *) s;
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5c:	85 c9                	test   %ecx,%ecx
  800a5e:	74 2f                	je     800a8f <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 c8                	or     %ecx,%eax
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 21                	jne    800a89 <memset+0x39>
		c &= 0xFF;
  800a68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6c:	89 d0                	mov    %edx,%eax
  800a6e:	c1 e0 08             	shl    $0x8,%eax
  800a71:	89 d3                	mov    %edx,%ebx
  800a73:	c1 e3 18             	shl    $0x18,%ebx
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	c1 e6 10             	shl    $0x10,%esi
  800a7b:	09 f3                	or     %esi,%ebx
  800a7d:	09 da                	or     %ebx,%edx
  800a7f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a84:	fc                   	cld    
  800a85:	f3 ab                	rep stos %eax,%es:(%edi)
  800a87:	eb 06                	jmp    800a8f <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	fc                   	cld    
  800a8d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a8f:	89 f8                	mov    %edi,%eax
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5f                   	pop    %edi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa4:	39 c6                	cmp    %eax,%esi
  800aa6:	73 32                	jae    800ada <memmove+0x44>
  800aa8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aab:	39 c2                	cmp    %eax,%edx
  800aad:	76 2b                	jbe    800ada <memmove+0x44>
		s += n;
		d += n;
  800aaf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab2:	89 d6                	mov    %edx,%esi
  800ab4:	09 fe                	or     %edi,%esi
  800ab6:	09 ce                	or     %ecx,%esi
  800ab8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800abe:	75 0e                	jne    800ace <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac0:	83 ef 04             	sub    $0x4,%edi
  800ac3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac9:	fd                   	std    
  800aca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acc:	eb 09                	jmp    800ad7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ace:	83 ef 01             	sub    $0x1,%edi
  800ad1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad4:	fd                   	std    
  800ad5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad7:	fc                   	cld    
  800ad8:	eb 1a                	jmp    800af4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ada:	89 f2                	mov    %esi,%edx
  800adc:	09 c2                	or     %eax,%edx
  800ade:	09 ca                	or     %ecx,%edx
  800ae0:	f6 c2 03             	test   $0x3,%dl
  800ae3:	75 0a                	jne    800aef <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae8:	89 c7                	mov    %eax,%edi
  800aea:	fc                   	cld    
  800aeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aed:	eb 05                	jmp    800af4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aef:	89 c7                	mov    %eax,%edi
  800af1:	fc                   	cld    
  800af2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af4:	5e                   	pop    %esi
  800af5:	5f                   	pop    %edi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800afe:	ff 75 10             	push   0x10(%ebp)
  800b01:	ff 75 0c             	push   0xc(%ebp)
  800b04:	ff 75 08             	push   0x8(%ebp)
  800b07:	e8 8a ff ff ff       	call   800a96 <memmove>
}
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	56                   	push   %esi
  800b12:	53                   	push   %ebx
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	89 c6                	mov    %eax,%esi
  800b1b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1e:	eb 06                	jmp    800b26 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b26:	39 f0                	cmp    %esi,%eax
  800b28:	74 14                	je     800b3e <memcmp+0x30>
		if (*s1 != *s2)
  800b2a:	0f b6 08             	movzbl (%eax),%ecx
  800b2d:	0f b6 1a             	movzbl (%edx),%ebx
  800b30:	38 d9                	cmp    %bl,%cl
  800b32:	74 ec                	je     800b20 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b34:	0f b6 c1             	movzbl %cl,%eax
  800b37:	0f b6 db             	movzbl %bl,%ebx
  800b3a:	29 d8                	sub    %ebx,%eax
  800b3c:	eb 05                	jmp    800b43 <memcmp+0x35>
	}

	return 0;
  800b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b55:	eb 03                	jmp    800b5a <memfind+0x13>
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	39 d0                	cmp    %edx,%eax
  800b5c:	73 04                	jae    800b62 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5e:	38 08                	cmp    %cl,(%eax)
  800b60:	75 f5                	jne    800b57 <memfind+0x10>
			break;
	return (void *) s;
}
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
  800b6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b70:	eb 03                	jmp    800b75 <strtol+0x11>
		s++;
  800b72:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b75:	0f b6 02             	movzbl (%edx),%eax
  800b78:	3c 20                	cmp    $0x20,%al
  800b7a:	74 f6                	je     800b72 <strtol+0xe>
  800b7c:	3c 09                	cmp    $0x9,%al
  800b7e:	74 f2                	je     800b72 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b80:	3c 2b                	cmp    $0x2b,%al
  800b82:	74 2a                	je     800bae <strtol+0x4a>
	int neg = 0;
  800b84:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b89:	3c 2d                	cmp    $0x2d,%al
  800b8b:	74 2b                	je     800bb8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b93:	75 0f                	jne    800ba4 <strtol+0x40>
  800b95:	80 3a 30             	cmpb   $0x30,(%edx)
  800b98:	74 28                	je     800bc2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9a:	85 db                	test   %ebx,%ebx
  800b9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba1:	0f 44 d8             	cmove  %eax,%ebx
  800ba4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bac:	eb 46                	jmp    800bf4 <strtol+0x90>
		s++;
  800bae:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb6:	eb d5                	jmp    800b8d <strtol+0x29>
		s++, neg = 1;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc0:	eb cb                	jmp    800b8d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc2:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bc6:	74 0e                	je     800bd6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bc8:	85 db                	test   %ebx,%ebx
  800bca:	75 d8                	jne    800ba4 <strtol+0x40>
		s++, base = 8;
  800bcc:	83 c2 01             	add    $0x1,%edx
  800bcf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd4:	eb ce                	jmp    800ba4 <strtol+0x40>
		s += 2, base = 16;
  800bd6:	83 c2 02             	add    $0x2,%edx
  800bd9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bde:	eb c4                	jmp    800ba4 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800be0:	0f be c0             	movsbl %al,%eax
  800be3:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800be9:	7d 3a                	jge    800c25 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800beb:	83 c2 01             	add    $0x1,%edx
  800bee:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bf2:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bf4:	0f b6 02             	movzbl (%edx),%eax
  800bf7:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bfa:	89 f3                	mov    %esi,%ebx
  800bfc:	80 fb 09             	cmp    $0x9,%bl
  800bff:	76 df                	jbe    800be0 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800c01:	8d 70 9f             	lea    -0x61(%eax),%esi
  800c04:	89 f3                	mov    %esi,%ebx
  800c06:	80 fb 19             	cmp    $0x19,%bl
  800c09:	77 08                	ja     800c13 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c0b:	0f be c0             	movsbl %al,%eax
  800c0e:	83 e8 57             	sub    $0x57,%eax
  800c11:	eb d3                	jmp    800be6 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800c13:	8d 70 bf             	lea    -0x41(%eax),%esi
  800c16:	89 f3                	mov    %esi,%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 08                	ja     800c25 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c1d:	0f be c0             	movsbl %al,%eax
  800c20:	83 e8 37             	sub    $0x37,%eax
  800c23:	eb c1                	jmp    800be6 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c29:	74 05                	je     800c30 <strtol+0xcc>
		*endptr = (char *) s;
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c30:	89 c8                	mov    %ecx,%eax
  800c32:	f7 d8                	neg    %eax
  800c34:	85 ff                	test   %edi,%edi
  800c36:	0f 45 c8             	cmovne %eax,%ecx
}
  800c39:	89 c8                	mov    %ecx,%eax
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <__udivdi3>:
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	83 ec 1c             	sub    $0x1c,%esp
  800c4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800c4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c53:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	75 19                	jne    800c78 <__udivdi3+0x38>
  800c5f:	39 f3                	cmp    %esi,%ebx
  800c61:	76 4d                	jbe    800cb0 <__udivdi3+0x70>
  800c63:	31 ff                	xor    %edi,%edi
  800c65:	89 e8                	mov    %ebp,%eax
  800c67:	89 f2                	mov    %esi,%edx
  800c69:	f7 f3                	div    %ebx
  800c6b:	89 fa                	mov    %edi,%edx
  800c6d:	83 c4 1c             	add    $0x1c,%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    
  800c75:	8d 76 00             	lea    0x0(%esi),%esi
  800c78:	39 f0                	cmp    %esi,%eax
  800c7a:	76 14                	jbe    800c90 <__udivdi3+0x50>
  800c7c:	31 ff                	xor    %edi,%edi
  800c7e:	31 c0                	xor    %eax,%eax
  800c80:	89 fa                	mov    %edi,%edx
  800c82:	83 c4 1c             	add    $0x1c,%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    
  800c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c90:	0f bd f8             	bsr    %eax,%edi
  800c93:	83 f7 1f             	xor    $0x1f,%edi
  800c96:	75 48                	jne    800ce0 <__udivdi3+0xa0>
  800c98:	39 f0                	cmp    %esi,%eax
  800c9a:	72 06                	jb     800ca2 <__udivdi3+0x62>
  800c9c:	31 c0                	xor    %eax,%eax
  800c9e:	39 eb                	cmp    %ebp,%ebx
  800ca0:	77 de                	ja     800c80 <__udivdi3+0x40>
  800ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca7:	eb d7                	jmp    800c80 <__udivdi3+0x40>
  800ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800cb0:	89 d9                	mov    %ebx,%ecx
  800cb2:	85 db                	test   %ebx,%ebx
  800cb4:	75 0b                	jne    800cc1 <__udivdi3+0x81>
  800cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800cbb:	31 d2                	xor    %edx,%edx
  800cbd:	f7 f3                	div    %ebx
  800cbf:	89 c1                	mov    %eax,%ecx
  800cc1:	31 d2                	xor    %edx,%edx
  800cc3:	89 f0                	mov    %esi,%eax
  800cc5:	f7 f1                	div    %ecx
  800cc7:	89 c6                	mov    %eax,%esi
  800cc9:	89 e8                	mov    %ebp,%eax
  800ccb:	89 f7                	mov    %esi,%edi
  800ccd:	f7 f1                	div    %ecx
  800ccf:	89 fa                	mov    %edi,%edx
  800cd1:	83 c4 1c             	add    $0x1c,%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
  800cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ce0:	89 f9                	mov    %edi,%ecx
  800ce2:	ba 20 00 00 00       	mov    $0x20,%edx
  800ce7:	29 fa                	sub    %edi,%edx
  800ce9:	d3 e0                	shl    %cl,%eax
  800ceb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cef:	89 d1                	mov    %edx,%ecx
  800cf1:	89 d8                	mov    %ebx,%eax
  800cf3:	d3 e8                	shr    %cl,%eax
  800cf5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cf9:	09 c1                	or     %eax,%ecx
  800cfb:	89 f0                	mov    %esi,%eax
  800cfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d01:	89 f9                	mov    %edi,%ecx
  800d03:	d3 e3                	shl    %cl,%ebx
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	d3 e8                	shr    %cl,%eax
  800d09:	89 f9                	mov    %edi,%ecx
  800d0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d0f:	89 eb                	mov    %ebp,%ebx
  800d11:	d3 e6                	shl    %cl,%esi
  800d13:	89 d1                	mov    %edx,%ecx
  800d15:	d3 eb                	shr    %cl,%ebx
  800d17:	09 f3                	or     %esi,%ebx
  800d19:	89 c6                	mov    %eax,%esi
  800d1b:	89 f2                	mov    %esi,%edx
  800d1d:	89 d8                	mov    %ebx,%eax
  800d1f:	f7 74 24 08          	divl   0x8(%esp)
  800d23:	89 d6                	mov    %edx,%esi
  800d25:	89 c3                	mov    %eax,%ebx
  800d27:	f7 64 24 0c          	mull   0xc(%esp)
  800d2b:	39 d6                	cmp    %edx,%esi
  800d2d:	72 19                	jb     800d48 <__udivdi3+0x108>
  800d2f:	89 f9                	mov    %edi,%ecx
  800d31:	d3 e5                	shl    %cl,%ebp
  800d33:	39 c5                	cmp    %eax,%ebp
  800d35:	73 04                	jae    800d3b <__udivdi3+0xfb>
  800d37:	39 d6                	cmp    %edx,%esi
  800d39:	74 0d                	je     800d48 <__udivdi3+0x108>
  800d3b:	89 d8                	mov    %ebx,%eax
  800d3d:	31 ff                	xor    %edi,%edi
  800d3f:	e9 3c ff ff ff       	jmp    800c80 <__udivdi3+0x40>
  800d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d4b:	31 ff                	xor    %edi,%edi
  800d4d:	e9 2e ff ff ff       	jmp    800c80 <__udivdi3+0x40>
  800d52:	66 90                	xchg   %ax,%ax
  800d54:	66 90                	xchg   %ax,%ax
  800d56:	66 90                	xchg   %ax,%ax
  800d58:	66 90                	xchg   %ax,%ax
  800d5a:	66 90                	xchg   %ax,%ax
  800d5c:	66 90                	xchg   %ax,%ax
  800d5e:	66 90                	xchg   %ax,%ax

00800d60 <__umoddi3>:
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 1c             	sub    $0x1c,%esp
  800d6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d73:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  800d77:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  800d7b:	89 f0                	mov    %esi,%eax
  800d7d:	89 da                	mov    %ebx,%edx
  800d7f:	85 ff                	test   %edi,%edi
  800d81:	75 15                	jne    800d98 <__umoddi3+0x38>
  800d83:	39 dd                	cmp    %ebx,%ebp
  800d85:	76 39                	jbe    800dc0 <__umoddi3+0x60>
  800d87:	f7 f5                	div    %ebp
  800d89:	89 d0                	mov    %edx,%eax
  800d8b:	31 d2                	xor    %edx,%edx
  800d8d:	83 c4 1c             	add    $0x1c,%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
  800d95:	8d 76 00             	lea    0x0(%esi),%esi
  800d98:	39 df                	cmp    %ebx,%edi
  800d9a:	77 f1                	ja     800d8d <__umoddi3+0x2d>
  800d9c:	0f bd cf             	bsr    %edi,%ecx
  800d9f:	83 f1 1f             	xor    $0x1f,%ecx
  800da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800da6:	75 40                	jne    800de8 <__umoddi3+0x88>
  800da8:	39 df                	cmp    %ebx,%edi
  800daa:	72 04                	jb     800db0 <__umoddi3+0x50>
  800dac:	39 f5                	cmp    %esi,%ebp
  800dae:	77 dd                	ja     800d8d <__umoddi3+0x2d>
  800db0:	89 da                	mov    %ebx,%edx
  800db2:	89 f0                	mov    %esi,%eax
  800db4:	29 e8                	sub    %ebp,%eax
  800db6:	19 fa                	sbb    %edi,%edx
  800db8:	eb d3                	jmp    800d8d <__umoddi3+0x2d>
  800dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800dc0:	89 e9                	mov    %ebp,%ecx
  800dc2:	85 ed                	test   %ebp,%ebp
  800dc4:	75 0b                	jne    800dd1 <__umoddi3+0x71>
  800dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dcb:	31 d2                	xor    %edx,%edx
  800dcd:	f7 f5                	div    %ebp
  800dcf:	89 c1                	mov    %eax,%ecx
  800dd1:	89 d8                	mov    %ebx,%eax
  800dd3:	31 d2                	xor    %edx,%edx
  800dd5:	f7 f1                	div    %ecx
  800dd7:	89 f0                	mov    %esi,%eax
  800dd9:	f7 f1                	div    %ecx
  800ddb:	89 d0                	mov    %edx,%eax
  800ddd:	31 d2                	xor    %edx,%edx
  800ddf:	eb ac                	jmp    800d8d <__umoddi3+0x2d>
  800de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800de8:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dec:	ba 20 00 00 00       	mov    $0x20,%edx
  800df1:	29 c2                	sub    %eax,%edx
  800df3:	89 c1                	mov    %eax,%ecx
  800df5:	89 e8                	mov    %ebp,%eax
  800df7:	d3 e7                	shl    %cl,%edi
  800df9:	89 d1                	mov    %edx,%ecx
  800dfb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dff:	d3 e8                	shr    %cl,%eax
  800e01:	89 c1                	mov    %eax,%ecx
  800e03:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e07:	09 f9                	or     %edi,%ecx
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e0f:	89 c1                	mov    %eax,%ecx
  800e11:	d3 e5                	shl    %cl,%ebp
  800e13:	89 d1                	mov    %edx,%ecx
  800e15:	d3 ef                	shr    %cl,%edi
  800e17:	89 c1                	mov    %eax,%ecx
  800e19:	89 f0                	mov    %esi,%eax
  800e1b:	d3 e3                	shl    %cl,%ebx
  800e1d:	89 d1                	mov    %edx,%ecx
  800e1f:	89 fa                	mov    %edi,%edx
  800e21:	d3 e8                	shr    %cl,%eax
  800e23:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e28:	09 d8                	or     %ebx,%eax
  800e2a:	f7 74 24 08          	divl   0x8(%esp)
  800e2e:	89 d3                	mov    %edx,%ebx
  800e30:	d3 e6                	shl    %cl,%esi
  800e32:	f7 e5                	mul    %ebp
  800e34:	89 c7                	mov    %eax,%edi
  800e36:	89 d1                	mov    %edx,%ecx
  800e38:	39 d3                	cmp    %edx,%ebx
  800e3a:	72 06                	jb     800e42 <__umoddi3+0xe2>
  800e3c:	75 0e                	jne    800e4c <__umoddi3+0xec>
  800e3e:	39 c6                	cmp    %eax,%esi
  800e40:	73 0a                	jae    800e4c <__umoddi3+0xec>
  800e42:	29 e8                	sub    %ebp,%eax
  800e44:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800e48:	89 d1                	mov    %edx,%ecx
  800e4a:	89 c7                	mov    %eax,%edi
  800e4c:	89 f5                	mov    %esi,%ebp
  800e4e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e52:	29 fd                	sub    %edi,%ebp
  800e54:	19 cb                	sbb    %ecx,%ebx
  800e56:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e5b:	89 d8                	mov    %ebx,%eax
  800e5d:	d3 e0                	shl    %cl,%eax
  800e5f:	89 f1                	mov    %esi,%ecx
  800e61:	d3 ed                	shr    %cl,%ebp
  800e63:	d3 eb                	shr    %cl,%ebx
  800e65:	09 e8                	or     %ebp,%eax
  800e67:	89 da                	mov    %ebx,%edx
  800e69:	83 c4 1c             	add    $0x1c,%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
