
obj/user/faultwritekernel:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0xf0100000 = 0;
  800033:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	57                   	push   %edi
  800042:	56                   	push   %esi
  800043:	53                   	push   %ebx
  800044:	83 ec 0c             	sub    $0xc,%esp
  800047:	e8 4e 00 00 00       	call   80009a <__x86.get_pc_thunk.bx>
  80004c:	81 c3 b4 1f 00 00    	add    $0x1fb4,%ebx
  800052:	8b 75 08             	mov    0x8(%ebp),%esi
  800055:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800058:	e8 f4 00 00 00       	call   800151 <sys_getenvid>
  80005d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800062:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800065:	c1 e0 05             	shl    $0x5,%eax
  800068:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80006e:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 f6                	test   %esi,%esi
  800076:	7e 08                	jle    800080 <libmain+0x42>
		binaryname = argv[0];
  800078:	8b 07                	mov    (%edi),%eax
  80007a:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	57                   	push   %edi
  800084:	56                   	push   %esi
  800085:	e8 a9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008a:	e8 0f 00 00 00       	call   80009e <exit>
}
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800095:	5b                   	pop    %ebx
  800096:	5e                   	pop    %esi
  800097:	5f                   	pop    %edi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <__x86.get_pc_thunk.bx>:
  80009a:	8b 1c 24             	mov    (%esp),%ebx
  80009d:	c3                   	ret    

0080009e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	53                   	push   %ebx
  8000a2:	83 ec 10             	sub    $0x10,%esp
  8000a5:	e8 f0 ff ff ff       	call   80009a <__x86.get_pc_thunk.bx>
  8000aa:	81 c3 56 1f 00 00    	add    $0x1f56,%ebx
	sys_env_destroy(0);
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 45 00 00 00       	call   8000fc <sys_env_destroy>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bd:	c9                   	leave  
  8000be:	c3                   	ret    

008000bf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	57                   	push   %edi
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d0:	89 c3                	mov    %eax,%ebx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 c6                	mov    %eax,%esi
  8000d6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d8:	5b                   	pop    %ebx
  8000d9:	5e                   	pop    %esi
  8000da:	5f                   	pop    %edi
  8000db:	5d                   	pop    %ebp
  8000dc:	c3                   	ret    

008000dd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ed:	89 d1                	mov    %edx,%ecx
  8000ef:	89 d3                	mov    %edx,%ebx
  8000f1:	89 d7                	mov    %edx,%edi
  8000f3:	89 d6                	mov    %edx,%esi
  8000f5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    

008000fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	57                   	push   %edi
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
  800102:	83 ec 1c             	sub    $0x1c,%esp
  800105:	e8 66 00 00 00       	call   800170 <__x86.get_pc_thunk.ax>
  80010a:	05 f6 1e 00 00       	add    $0x1ef6,%eax
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800112:	b9 00 00 00 00       	mov    $0x0,%ecx
  800117:	8b 55 08             	mov    0x8(%ebp),%edx
  80011a:	b8 03 00 00 00       	mov    $0x3,%eax
  80011f:	89 cb                	mov    %ecx,%ebx
  800121:	89 cf                	mov    %ecx,%edi
  800123:	89 ce                	mov    %ecx,%esi
  800125:	cd 30                	int    $0x30
	if(check && ret > 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	7f 08                	jg     800133 <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	6a 03                	push   $0x3
  800139:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80013c:	8d 83 6e ee ff ff    	lea    -0x1192(%ebx),%eax
  800142:	50                   	push   %eax
  800143:	6a 23                	push   $0x23
  800145:	8d 83 8b ee ff ff    	lea    -0x1175(%ebx),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 23 00 00 00       	call   800174 <_panic>

00800151 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
	asm volatile("int %1\n"
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	b8 02 00 00 00       	mov    $0x2,%eax
  800161:	89 d1                	mov    %edx,%ecx
  800163:	89 d3                	mov    %edx,%ebx
  800165:	89 d7                	mov    %edx,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5f                   	pop    %edi
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <__x86.get_pc_thunk.ax>:
  800170:	8b 04 24             	mov    (%esp),%eax
  800173:	c3                   	ret    

00800174 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	57                   	push   %edi
  800178:	56                   	push   %esi
  800179:	53                   	push   %ebx
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	e8 18 ff ff ff       	call   80009a <__x86.get_pc_thunk.bx>
  800182:	81 c3 7e 1e 00 00    	add    $0x1e7e,%ebx
	va_list ap;

	va_start(ap, fmt);
  800188:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80018b:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800191:	8b 38                	mov    (%eax),%edi
  800193:	e8 b9 ff ff ff       	call   800151 <sys_getenvid>
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	ff 75 0c             	push   0xc(%ebp)
  80019e:	ff 75 08             	push   0x8(%ebp)
  8001a1:	57                   	push   %edi
  8001a2:	50                   	push   %eax
  8001a3:	8d 83 9c ee ff ff    	lea    -0x1164(%ebx),%eax
  8001a9:	50                   	push   %eax
  8001aa:	e8 d1 00 00 00       	call   800280 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001af:	83 c4 18             	add    $0x18,%esp
  8001b2:	56                   	push   %esi
  8001b3:	ff 75 10             	push   0x10(%ebp)
  8001b6:	e8 63 00 00 00       	call   80021e <vcprintf>
	cprintf("\n");
  8001bb:	8d 83 bf ee ff ff    	lea    -0x1141(%ebx),%eax
  8001c1:	89 04 24             	mov    %eax,(%esp)
  8001c4:	e8 b7 00 00 00       	call   800280 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cc:	cc                   	int3   
  8001cd:	eb fd                	jmp    8001cc <_panic+0x58>

008001cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	56                   	push   %esi
  8001d3:	53                   	push   %ebx
  8001d4:	e8 c1 fe ff ff       	call   80009a <__x86.get_pc_thunk.bx>
  8001d9:	81 c3 27 1e 00 00    	add    $0x1e27,%ebx
  8001df:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001e2:	8b 16                	mov    (%esi),%edx
  8001e4:	8d 42 01             	lea    0x1(%edx),%eax
  8001e7:	89 06                	mov    %eax,(%esi)
  8001e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ec:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f5:	74 0b                	je     800202 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f7:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001fe:	5b                   	pop    %ebx
  8001ff:	5e                   	pop    %esi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 46 08             	lea    0x8(%esi),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 ac fe ff ff       	call   8000bf <sys_cputs>
		b->idx = 0;
  800213:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb d9                	jmp    8001f7 <putch+0x28>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	53                   	push   %ebx
  800222:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800228:	e8 6d fe ff ff       	call   80009a <__x86.get_pc_thunk.bx>
  80022d:	81 c3 d3 1d 00 00    	add    $0x1dd3,%ebx
	struct printbuf b;

	b.idx = 0;
  800233:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023a:	00 00 00 
	b.cnt = 0;
  80023d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800244:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800247:	ff 75 0c             	push   0xc(%ebp)
  80024a:	ff 75 08             	push   0x8(%ebp)
  80024d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800253:	50                   	push   %eax
  800254:	8d 83 cf e1 ff ff    	lea    -0x1e31(%ebx),%eax
  80025a:	50                   	push   %eax
  80025b:	e8 2c 01 00 00       	call   80038c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800260:	83 c4 08             	add    $0x8,%esp
  800263:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800269:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	e8 4a fe ff ff       	call   8000bf <sys_cputs>

	return b.cnt;
}
  800275:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800286:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 08             	push   0x8(%ebp)
  80028d:	e8 8c ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 2c             	sub    $0x2c,%esp
  80029d:	e8 07 06 00 00       	call   8008a9 <__x86.get_pc_thunk.cx>
  8002a2:	81 c1 5e 1d 00 00    	add    $0x1d5e,%ecx
  8002a8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	89 d6                	mov    %edx,%esi
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002cf:	39 c2                	cmp    %eax,%edx
  8002d1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d4:	72 41                	jb     800317 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	ff 75 18             	push   0x18(%ebp)
  8002dc:	83 eb 01             	sub    $0x1,%ebx
  8002df:	53                   	push   %ebx
  8002e0:	50                   	push   %eax
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	ff 75 e4             	push   -0x1c(%ebp)
  8002e7:	ff 75 e0             	push   -0x20(%ebp)
  8002ea:	ff 75 d4             	push   -0x2c(%ebp)
  8002ed:	ff 75 d0             	push   -0x30(%ebp)
  8002f0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f3:	e8 38 09 00 00       	call   800c30 <__udivdi3>
  8002f8:	83 c4 18             	add    $0x18,%esp
  8002fb:	52                   	push   %edx
  8002fc:	50                   	push   %eax
  8002fd:	89 f2                	mov    %esi,%edx
  8002ff:	89 f8                	mov    %edi,%eax
  800301:	e8 8e ff ff ff       	call   800294 <printnum>
  800306:	83 c4 20             	add    $0x20,%esp
  800309:	eb 13                	jmp    80031e <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	ff 75 18             	push   0x18(%ebp)
  800312:	ff d7                	call   *%edi
  800314:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800317:	83 eb 01             	sub    $0x1,%ebx
  80031a:	85 db                	test   %ebx,%ebx
  80031c:	7f ed                	jg     80030b <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	56                   	push   %esi
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	ff 75 e4             	push   -0x1c(%ebp)
  800328:	ff 75 e0             	push   -0x20(%ebp)
  80032b:	ff 75 d4             	push   -0x2c(%ebp)
  80032e:	ff 75 d0             	push   -0x30(%ebp)
  800331:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800334:	e8 17 0a 00 00       	call   800d50 <__umoddi3>
  800339:	83 c4 14             	add    $0x14,%esp
  80033c:	0f be 84 03 c1 ee ff 	movsbl -0x113f(%ebx,%eax,1),%eax
  800343:	ff 
  800344:	50                   	push   %eax
  800345:	ff d7                	call   *%edi
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800358:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80035c:	8b 10                	mov    (%eax),%edx
  80035e:	3b 50 04             	cmp    0x4(%eax),%edx
  800361:	73 0a                	jae    80036d <sprintputch+0x1b>
		*b->buf++ = ch;
  800363:	8d 4a 01             	lea    0x1(%edx),%ecx
  800366:	89 08                	mov    %ecx,(%eax)
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	88 02                	mov    %al,(%edx)
}
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <printfmt>:
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800375:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800378:	50                   	push   %eax
  800379:	ff 75 10             	push   0x10(%ebp)
  80037c:	ff 75 0c             	push   0xc(%ebp)
  80037f:	ff 75 08             	push   0x8(%ebp)
  800382:	e8 05 00 00 00       	call   80038c <vprintfmt>
}
  800387:	83 c4 10             	add    $0x10,%esp
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <vprintfmt>:
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 3c             	sub    $0x3c,%esp
  800395:	e8 d6 fd ff ff       	call   800170 <__x86.get_pc_thunk.ax>
  80039a:	05 66 1c 00 00       	add    $0x1c66,%eax
  80039f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ab:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003b4:	eb 0a                	jmp    8003c0 <vprintfmt+0x34>
			putch(ch, putdat);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	57                   	push   %edi
  8003ba:	50                   	push   %eax
  8003bb:	ff d6                	call   *%esi
  8003bd:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c0:	83 c3 01             	add    $0x1,%ebx
  8003c3:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003c7:	83 f8 25             	cmp    $0x25,%eax
  8003ca:	74 0c                	je     8003d8 <vprintfmt+0x4c>
			if (ch == '\0')
  8003cc:	85 c0                	test   %eax,%eax
  8003ce:	75 e6                	jne    8003b6 <vprintfmt+0x2a>
}
  8003d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d3:	5b                   	pop    %ebx
  8003d4:	5e                   	pop    %esi
  8003d5:	5f                   	pop    %edi
  8003d6:	5d                   	pop    %ebp
  8003d7:	c3                   	ret    
		padc = ' ';
  8003d8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003dc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003e3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ea:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f9:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fc:	8d 43 01             	lea    0x1(%ebx),%eax
  8003ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800402:	0f b6 13             	movzbl (%ebx),%edx
  800405:	8d 42 dd             	lea    -0x23(%edx),%eax
  800408:	3c 55                	cmp    $0x55,%al
  80040a:	0f 87 fd 03 00 00    	ja     80080d <.L20>
  800410:	0f b6 c0             	movzbl %al,%eax
  800413:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800416:	89 ce                	mov    %ecx,%esi
  800418:	03 b4 81 50 ef ff ff 	add    -0x10b0(%ecx,%eax,4),%esi
  80041f:	ff e6                	jmp    *%esi

00800421 <.L68>:
  800421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800424:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800428:	eb d2                	jmp    8003fc <vprintfmt+0x70>

0080042a <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80042d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800431:	eb c9                	jmp    8003fc <vprintfmt+0x70>

00800433 <.L31>:
  800433:	0f b6 d2             	movzbl %dl,%edx
  800436:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800441:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800444:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800448:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80044b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044e:	83 f9 09             	cmp    $0x9,%ecx
  800451:	77 58                	ja     8004ab <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800453:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800456:	eb e9                	jmp    800441 <.L31+0xe>

00800458 <.L34>:
			precision = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8d 40 04             	lea    0x4(%eax),%eax
  800466:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  80046c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800470:	79 8a                	jns    8003fc <vprintfmt+0x70>
				width = precision, precision = -1;
  800472:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800475:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800478:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047f:	e9 78 ff ff ff       	jmp    8003fc <vprintfmt+0x70>

00800484 <.L33>:
  800484:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c2             	cmovns %edx,%eax
  800491:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800494:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  800497:	e9 60 ff ff ff       	jmp    8003fc <vprintfmt+0x70>

0080049c <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  80049c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  80049f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004a6:	e9 51 ff ff ff       	jmp    8003fc <vprintfmt+0x70>
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b1:	eb b9                	jmp    80046c <.L34+0x14>

008004b3 <.L27>:
			lflag++;
  8004b3:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004ba:	e9 3d ff ff ff       	jmp    8003fc <vprintfmt+0x70>

008004bf <.L30>:
			putch(va_arg(ap, int), putdat);
  8004bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 58 04             	lea    0x4(%eax),%ebx
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	57                   	push   %edi
  8004cc:	ff 30                	push   (%eax)
  8004ce:	ff d6                	call   *%esi
			break;
  8004d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d3:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004d6:	e9 c8 02 00 00       	jmp    8007a3 <.L25+0x45>

008004db <.L28>:
			err = va_arg(ap, int);
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e4:	8b 10                	mov    (%eax),%edx
  8004e6:	89 d0                	mov    %edx,%eax
  8004e8:	f7 d8                	neg    %eax
  8004ea:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ed:	83 f8 06             	cmp    $0x6,%eax
  8004f0:	7f 27                	jg     800519 <.L28+0x3e>
  8004f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f5:	8b 14 82             	mov    (%edx,%eax,4),%edx
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	74 1d                	je     800519 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  8004fc:	52                   	push   %edx
  8004fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800500:	8d 80 e2 ee ff ff    	lea    -0x111e(%eax),%eax
  800506:	50                   	push   %eax
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	e8 61 fe ff ff       	call   80036f <printfmt>
  80050e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800511:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800514:	e9 8a 02 00 00       	jmp    8007a3 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800519:	50                   	push   %eax
  80051a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051d:	8d 80 d9 ee ff ff    	lea    -0x1127(%eax),%eax
  800523:	50                   	push   %eax
  800524:	57                   	push   %edi
  800525:	56                   	push   %esi
  800526:	e8 44 fe ff ff       	call   80036f <printfmt>
  80052b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052e:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800531:	e9 6d 02 00 00       	jmp    8007a3 <.L25+0x45>

00800536 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  800536:	8b 75 08             	mov    0x8(%ebp),%esi
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	83 c0 04             	add    $0x4,%eax
  80053f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800547:	85 d2                	test   %edx,%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	8d 80 d2 ee ff ff    	lea    -0x112e(%eax),%eax
  800552:	0f 45 c2             	cmovne %edx,%eax
  800555:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800558:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80055c:	7e 06                	jle    800564 <.L24+0x2e>
  80055e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800562:	75 0d                	jne    800571 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800564:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	03 45 d4             	add    -0x2c(%ebp),%eax
  80056c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80056f:	eb 58                	jmp    8005c9 <.L24+0x93>
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	ff 75 d8             	push   -0x28(%ebp)
  800577:	ff 75 c8             	push   -0x38(%ebp)
  80057a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80057d:	e8 43 03 00 00       	call   8008c5 <strnlen>
  800582:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800585:	29 c2                	sub    %eax,%edx
  800587:	89 55 bc             	mov    %edx,-0x44(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  80058f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800593:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	eb 0f                	jmp    8005a7 <.L24+0x71>
					putch(padc, putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	57                   	push   %edi
  80059c:	ff 75 d4             	push   -0x2c(%ebp)
  80059f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	85 db                	test   %ebx,%ebx
  8005a9:	7f ed                	jg     800598 <.L24+0x62>
  8005ab:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c2             	cmovns %edx,%eax
  8005b8:	29 c2                	sub    %eax,%edx
  8005ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005bd:	eb a5                	jmp    800564 <.L24+0x2e>
					putch(ch, putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	57                   	push   %edi
  8005c3:	52                   	push   %edx
  8005c4:	ff d6                	call   *%esi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005cc:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ce:	83 c3 01             	add    $0x1,%ebx
  8005d1:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005d5:	0f be d0             	movsbl %al,%edx
  8005d8:	85 d2                	test   %edx,%edx
  8005da:	74 4b                	je     800627 <.L24+0xf1>
  8005dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e0:	78 06                	js     8005e8 <.L24+0xb2>
  8005e2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e6:	78 1e                	js     800606 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ec:	74 d1                	je     8005bf <.L24+0x89>
  8005ee:	0f be c0             	movsbl %al,%eax
  8005f1:	83 e8 20             	sub    $0x20,%eax
  8005f4:	83 f8 5e             	cmp    $0x5e,%eax
  8005f7:	76 c6                	jbe    8005bf <.L24+0x89>
					putch('?', putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	57                   	push   %edi
  8005fd:	6a 3f                	push   $0x3f
  8005ff:	ff d6                	call   *%esi
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	eb c3                	jmp    8005c9 <.L24+0x93>
  800606:	89 cb                	mov    %ecx,%ebx
  800608:	eb 0e                	jmp    800618 <.L24+0xe2>
				putch(' ', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	57                   	push   %edi
  80060e:	6a 20                	push   $0x20
  800610:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800612:	83 eb 01             	sub    $0x1,%ebx
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	85 db                	test   %ebx,%ebx
  80061a:	7f ee                	jg     80060a <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80061c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
  800622:	e9 7c 01 00 00       	jmp    8007a3 <.L25+0x45>
  800627:	89 cb                	mov    %ecx,%ebx
  800629:	eb ed                	jmp    800618 <.L24+0xe2>

0080062b <.L29>:
	if (lflag >= 2)
  80062b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80062e:	8b 75 08             	mov    0x8(%ebp),%esi
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1b                	jg     800651 <.L29+0x26>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 63                	je     80069d <.L29+0x72>
		return va_arg(*ap, long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	99                   	cltd   
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 17                	jmp    800668 <.L29+0x3d>
		return va_arg(*ap, long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800668:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80066b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  80066e:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  800673:	85 db                	test   %ebx,%ebx
  800675:	0f 89 0e 01 00 00    	jns    800789 <.L25+0x2b>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	57                   	push   %edi
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800686:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800689:	f7 d9                	neg    %ecx
  80068b:	83 d3 00             	adc    $0x0,%ebx
  80068e:	f7 db                	neg    %ebx
  800690:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800693:	ba 0a 00 00 00       	mov    $0xa,%edx
  800698:	e9 ec 00 00 00       	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	99                   	cltd   
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb b4                	jmp    800668 <.L29+0x3d>

008006b4 <.L23>:
	if (lflag >= 2)
  8006b4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ba:	83 f9 01             	cmp    $0x1,%ecx
  8006bd:	7f 1e                	jg     8006dd <.L23+0x29>
	else if (lflag)
  8006bf:	85 c9                	test   %ecx,%ecx
  8006c1:	74 32                	je     8006f5 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 08                	mov    (%eax),%ecx
  8006c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d3:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006d8:	e9 ac 00 00 00       	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 08                	mov    (%eax),%ecx
  8006e2:	8b 58 04             	mov    0x4(%eax),%ebx
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006eb:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  8006f0:	e9 94 00 00 00       	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 08                	mov    (%eax),%ecx
  8006fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  80070a:	eb 7d                	jmp    800789 <.L25+0x2b>

0080070c <.L26>:
	if (lflag >= 2)
  80070c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80070f:	8b 75 08             	mov    0x8(%ebp),%esi
  800712:	83 f9 01             	cmp    $0x1,%ecx
  800715:	7f 1b                	jg     800732 <.L26+0x26>
	else if (lflag)
  800717:	85 c9                	test   %ecx,%ecx
  800719:	74 2c                	je     800747 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 08                	mov    (%eax),%ecx
  800720:	bb 00 00 00 00       	mov    $0x0,%ebx
  800725:	8d 40 04             	lea    0x4(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072b:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800730:	eb 57                	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 08                	mov    (%eax),%ecx
  800737:	8b 58 04             	mov    0x4(%eax),%ebx
  80073a:	8d 40 08             	lea    0x8(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800740:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  800745:	eb 42                	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 08                	mov    (%eax),%ecx
  80074c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800757:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  80075c:	eb 2b                	jmp    800789 <.L25+0x2b>

0080075e <.L25>:
			putch('0', putdat);
  80075e:	8b 75 08             	mov    0x8(%ebp),%esi
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	57                   	push   %edi
  800765:	6a 30                	push   $0x30
  800767:	ff d6                	call   *%esi
			putch('x', putdat);
  800769:	83 c4 08             	add    $0x8,%esp
  80076c:	57                   	push   %edi
  80076d:	6a 78                	push   $0x78
  80076f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 08                	mov    (%eax),%ecx
  800776:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  80077b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800784:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800789:	83 ec 0c             	sub    $0xc,%esp
  80078c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	ff 75 d4             	push   -0x2c(%ebp)
  800794:	52                   	push   %edx
  800795:	53                   	push   %ebx
  800796:	51                   	push   %ecx
  800797:	89 fa                	mov    %edi,%edx
  800799:	89 f0                	mov    %esi,%eax
  80079b:	e8 f4 fa ff ff       	call   800294 <printnum>
			break;
  8007a0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a6:	e9 15 fc ff ff       	jmp    8003c0 <vprintfmt+0x34>

008007ab <.L21>:
	if (lflag >= 2)
  8007ab:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b1:	83 f9 01             	cmp    $0x1,%ecx
  8007b4:	7f 1b                	jg     8007d1 <.L21+0x26>
	else if (lflag)
  8007b6:	85 c9                	test   %ecx,%ecx
  8007b8:	74 2c                	je     8007e6 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 08                	mov    (%eax),%ecx
  8007bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c4:	8d 40 04             	lea    0x4(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ca:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007cf:	eb b8                	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 08                	mov    (%eax),%ecx
  8007d6:	8b 58 04             	mov    0x4(%eax),%ebx
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007df:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007e4:	eb a3                	jmp    800789 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8b 08                	mov    (%eax),%ecx
  8007eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f0:	8d 40 04             	lea    0x4(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f6:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  8007fb:	eb 8c                	jmp    800789 <.L25+0x2b>

008007fd <.L35>:
			putch(ch, putdat);
  8007fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	57                   	push   %edi
  800804:	6a 25                	push   $0x25
  800806:	ff d6                	call   *%esi
			break;
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	eb 96                	jmp    8007a3 <.L25+0x45>

0080080d <.L20>:
			putch('%', putdat);
  80080d:	8b 75 08             	mov    0x8(%ebp),%esi
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	57                   	push   %edi
  800814:	6a 25                	push   $0x25
  800816:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800821:	74 05                	je     800828 <.L20+0x1b>
  800823:	83 e8 01             	sub    $0x1,%eax
  800826:	eb f5                	jmp    80081d <.L20+0x10>
  800828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80082b:	e9 73 ff ff ff       	jmp    8007a3 <.L25+0x45>

00800830 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	53                   	push   %ebx
  800834:	83 ec 14             	sub    $0x14,%esp
  800837:	e8 5e f8 ff ff       	call   80009a <__x86.get_pc_thunk.bx>
  80083c:	81 c3 c4 17 00 00    	add    $0x17c4,%ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800848:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80084f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800859:	85 c0                	test   %eax,%eax
  80085b:	74 2b                	je     800888 <vsnprintf+0x58>
  80085d:	85 d2                	test   %edx,%edx
  80085f:	7e 27                	jle    800888 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800861:	ff 75 14             	push   0x14(%ebp)
  800864:	ff 75 10             	push   0x10(%ebp)
  800867:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086a:	50                   	push   %eax
  80086b:	8d 83 52 e3 ff ff    	lea    -0x1cae(%ebx),%eax
  800871:	50                   	push   %eax
  800872:	e8 15 fb ff ff       	call   80038c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    
		return -E_INVAL;
  800888:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088d:	eb f4                	jmp    800883 <vsnprintf+0x53>

0080088f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800895:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800898:	50                   	push   %eax
  800899:	ff 75 10             	push   0x10(%ebp)
  80089c:	ff 75 0c             	push   0xc(%ebp)
  80089f:	ff 75 08             	push   0x8(%ebp)
  8008a2:	e8 89 ff ff ff       	call   800830 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <__x86.get_pc_thunk.cx>:
  8008a9:	8b 0c 24             	mov    (%esp),%ecx
  8008ac:	c3                   	ret    

008008ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	eb 03                	jmp    8008bd <strlen+0x10>
		n++;
  8008ba:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008bd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c1:	75 f7                	jne    8008ba <strlen+0xd>
	return n;
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d3:	eb 03                	jmp    8008d8 <strnlen+0x13>
		n++;
  8008d5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d8:	39 d0                	cmp    %edx,%eax
  8008da:	74 08                	je     8008e4 <strnlen+0x1f>
  8008dc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e0:	75 f3                	jne    8008d5 <strnlen+0x10>
  8008e2:	89 c2                	mov    %eax,%edx
	return n;
}
  8008e4:	89 d0                	mov    %edx,%eax
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	53                   	push   %ebx
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008fb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	84 d2                	test   %dl,%dl
  800903:	75 f2                	jne    8008f7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800905:	89 c8                	mov    %ecx,%eax
  800907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	83 ec 10             	sub    $0x10,%esp
  800913:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800916:	53                   	push   %ebx
  800917:	e8 91 ff ff ff       	call   8008ad <strlen>
  80091c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091f:	ff 75 0c             	push   0xc(%ebp)
  800922:	01 d8                	add    %ebx,%eax
  800924:	50                   	push   %eax
  800925:	e8 be ff ff ff       	call   8008e8 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	56                   	push   %esi
  800935:	53                   	push   %ebx
  800936:	8b 75 08             	mov    0x8(%ebp),%esi
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	89 f3                	mov    %esi,%ebx
  80093e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800941:	89 f0                	mov    %esi,%eax
  800943:	eb 0f                	jmp    800954 <strncpy+0x23>
		*dst++ = *src;
  800945:	83 c0 01             	add    $0x1,%eax
  800948:	0f b6 0a             	movzbl (%edx),%ecx
  80094b:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094e:	80 f9 01             	cmp    $0x1,%cl
  800951:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  800954:	39 d8                	cmp    %ebx,%eax
  800956:	75 ed                	jne    800945 <strncpy+0x14>
	}
	return ret;
}
  800958:	89 f0                	mov    %esi,%eax
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	56                   	push   %esi
  800962:	53                   	push   %ebx
  800963:	8b 75 08             	mov    0x8(%ebp),%esi
  800966:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800969:	8b 55 10             	mov    0x10(%ebp),%edx
  80096c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096e:	85 d2                	test   %edx,%edx
  800970:	74 21                	je     800993 <strlcpy+0x35>
  800972:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800976:	89 f2                	mov    %esi,%edx
  800978:	eb 09                	jmp    800983 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80097a:	83 c1 01             	add    $0x1,%ecx
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  800983:	39 c2                	cmp    %eax,%edx
  800985:	74 09                	je     800990 <strlcpy+0x32>
  800987:	0f b6 19             	movzbl (%ecx),%ebx
  80098a:	84 db                	test   %bl,%bl
  80098c:	75 ec                	jne    80097a <strlcpy+0x1c>
  80098e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800990:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800993:	29 f0                	sub    %esi,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a2:	eb 06                	jmp    8009aa <strcmp+0x11>
		p++, q++;
  8009a4:	83 c1 01             	add    $0x1,%ecx
  8009a7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009aa:	0f b6 01             	movzbl (%ecx),%eax
  8009ad:	84 c0                	test   %al,%al
  8009af:	74 04                	je     8009b5 <strcmp+0x1c>
  8009b1:	3a 02                	cmp    (%edx),%al
  8009b3:	74 ef                	je     8009a4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b5:	0f b6 c0             	movzbl %al,%eax
  8009b8:	0f b6 12             	movzbl (%edx),%edx
  8009bb:	29 d0                	sub    %edx,%eax
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c9:	89 c3                	mov    %eax,%ebx
  8009cb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ce:	eb 06                	jmp    8009d6 <strncmp+0x17>
		n--, p++, q++;
  8009d0:	83 c0 01             	add    $0x1,%eax
  8009d3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d6:	39 d8                	cmp    %ebx,%eax
  8009d8:	74 18                	je     8009f2 <strncmp+0x33>
  8009da:	0f b6 08             	movzbl (%eax),%ecx
  8009dd:	84 c9                	test   %cl,%cl
  8009df:	74 04                	je     8009e5 <strncmp+0x26>
  8009e1:	3a 0a                	cmp    (%edx),%cl
  8009e3:	74 eb                	je     8009d0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e5:	0f b6 00             	movzbl (%eax),%eax
  8009e8:	0f b6 12             	movzbl (%edx),%edx
  8009eb:	29 d0                	sub    %edx,%eax
}
  8009ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f7:	eb f4                	jmp    8009ed <strncmp+0x2e>

008009f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a03:	eb 03                	jmp    800a08 <strchr+0xf>
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	0f b6 10             	movzbl (%eax),%edx
  800a0b:	84 d2                	test   %dl,%dl
  800a0d:	74 06                	je     800a15 <strchr+0x1c>
		if (*s == c)
  800a0f:	38 ca                	cmp    %cl,%dl
  800a11:	75 f2                	jne    800a05 <strchr+0xc>
  800a13:	eb 05                	jmp    800a1a <strchr+0x21>
			return (char *) s;
	return 0;
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a26:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a29:	38 ca                	cmp    %cl,%dl
  800a2b:	74 09                	je     800a36 <strfind+0x1a>
  800a2d:	84 d2                	test   %dl,%dl
  800a2f:	74 05                	je     800a36 <strfind+0x1a>
	for (; *s; s++)
  800a31:	83 c0 01             	add    $0x1,%eax
  800a34:	eb f0                	jmp    800a26 <strfind+0xa>
			break;
	return (char *) s;
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	57                   	push   %edi
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a44:	85 c9                	test   %ecx,%ecx
  800a46:	74 2f                	je     800a77 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a48:	89 f8                	mov    %edi,%eax
  800a4a:	09 c8                	or     %ecx,%eax
  800a4c:	a8 03                	test   $0x3,%al
  800a4e:	75 21                	jne    800a71 <memset+0x39>
		c &= 0xFF;
  800a50:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a54:	89 d0                	mov    %edx,%eax
  800a56:	c1 e0 08             	shl    $0x8,%eax
  800a59:	89 d3                	mov    %edx,%ebx
  800a5b:	c1 e3 18             	shl    $0x18,%ebx
  800a5e:	89 d6                	mov    %edx,%esi
  800a60:	c1 e6 10             	shl    $0x10,%esi
  800a63:	09 f3                	or     %esi,%ebx
  800a65:	09 da                	or     %ebx,%edx
  800a67:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a69:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a6c:	fc                   	cld    
  800a6d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a6f:	eb 06                	jmp    800a77 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	fc                   	cld    
  800a75:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a77:	89 f8                	mov    %edi,%eax
  800a79:	5b                   	pop    %ebx
  800a7a:	5e                   	pop    %esi
  800a7b:	5f                   	pop    %edi
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	57                   	push   %edi
  800a82:	56                   	push   %esi
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a8c:	39 c6                	cmp    %eax,%esi
  800a8e:	73 32                	jae    800ac2 <memmove+0x44>
  800a90:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a93:	39 c2                	cmp    %eax,%edx
  800a95:	76 2b                	jbe    800ac2 <memmove+0x44>
		s += n;
		d += n;
  800a97:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9a:	89 d6                	mov    %edx,%esi
  800a9c:	09 fe                	or     %edi,%esi
  800a9e:	09 ce                	or     %ecx,%esi
  800aa0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa6:	75 0e                	jne    800ab6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa8:	83 ef 04             	sub    $0x4,%edi
  800aab:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ab1:	fd                   	std    
  800ab2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab4:	eb 09                	jmp    800abf <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab6:	83 ef 01             	sub    $0x1,%edi
  800ab9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800abc:	fd                   	std    
  800abd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abf:	fc                   	cld    
  800ac0:	eb 1a                	jmp    800adc <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac2:	89 f2                	mov    %esi,%edx
  800ac4:	09 c2                	or     %eax,%edx
  800ac6:	09 ca                	or     %ecx,%edx
  800ac8:	f6 c2 03             	test   $0x3,%dl
  800acb:	75 0a                	jne    800ad7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800acd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad0:	89 c7                	mov    %eax,%edi
  800ad2:	fc                   	cld    
  800ad3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad5:	eb 05                	jmp    800adc <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad7:	89 c7                	mov    %eax,%edi
  800ad9:	fc                   	cld    
  800ada:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800adc:	5e                   	pop    %esi
  800add:	5f                   	pop    %edi
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae6:	ff 75 10             	push   0x10(%ebp)
  800ae9:	ff 75 0c             	push   0xc(%ebp)
  800aec:	ff 75 08             	push   0x8(%ebp)
  800aef:	e8 8a ff ff ff       	call   800a7e <memmove>
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	56                   	push   %esi
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	89 c6                	mov    %eax,%esi
  800b03:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b06:	eb 06                	jmp    800b0e <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b08:	83 c0 01             	add    $0x1,%eax
  800b0b:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b0e:	39 f0                	cmp    %esi,%eax
  800b10:	74 14                	je     800b26 <memcmp+0x30>
		if (*s1 != *s2)
  800b12:	0f b6 08             	movzbl (%eax),%ecx
  800b15:	0f b6 1a             	movzbl (%edx),%ebx
  800b18:	38 d9                	cmp    %bl,%cl
  800b1a:	74 ec                	je     800b08 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b1c:	0f b6 c1             	movzbl %cl,%eax
  800b1f:	0f b6 db             	movzbl %bl,%ebx
  800b22:	29 d8                	sub    %ebx,%eax
  800b24:	eb 05                	jmp    800b2b <memcmp+0x35>
	}

	return 0;
  800b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3d:	eb 03                	jmp    800b42 <memfind+0x13>
  800b3f:	83 c0 01             	add    $0x1,%eax
  800b42:	39 d0                	cmp    %edx,%eax
  800b44:	73 04                	jae    800b4a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b46:	38 08                	cmp    %cl,(%eax)
  800b48:	75 f5                	jne    800b3f <memfind+0x10>
			break;
	return (void *) s;
}
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	8b 55 08             	mov    0x8(%ebp),%edx
  800b55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b58:	eb 03                	jmp    800b5d <strtol+0x11>
		s++;
  800b5a:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b5d:	0f b6 02             	movzbl (%edx),%eax
  800b60:	3c 20                	cmp    $0x20,%al
  800b62:	74 f6                	je     800b5a <strtol+0xe>
  800b64:	3c 09                	cmp    $0x9,%al
  800b66:	74 f2                	je     800b5a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b68:	3c 2b                	cmp    $0x2b,%al
  800b6a:	74 2a                	je     800b96 <strtol+0x4a>
	int neg = 0;
  800b6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b71:	3c 2d                	cmp    $0x2d,%al
  800b73:	74 2b                	je     800ba0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7b:	75 0f                	jne    800b8c <strtol+0x40>
  800b7d:	80 3a 30             	cmpb   $0x30,(%edx)
  800b80:	74 28                	je     800baa <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b82:	85 db                	test   %ebx,%ebx
  800b84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b89:	0f 44 d8             	cmove  %eax,%ebx
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b94:	eb 46                	jmp    800bdc <strtol+0x90>
		s++;
  800b96:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b99:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9e:	eb d5                	jmp    800b75 <strtol+0x29>
		s++, neg = 1;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba8:	eb cb                	jmp    800b75 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800baa:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bae:	74 0e                	je     800bbe <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	75 d8                	jne    800b8c <strtol+0x40>
		s++, base = 8;
  800bb4:	83 c2 01             	add    $0x1,%edx
  800bb7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbc:	eb ce                	jmp    800b8c <strtol+0x40>
		s += 2, base = 16;
  800bbe:	83 c2 02             	add    $0x2,%edx
  800bc1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc6:	eb c4                	jmp    800b8c <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bc8:	0f be c0             	movsbl %al,%eax
  800bcb:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bce:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bd1:	7d 3a                	jge    800c0d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd3:	83 c2 01             	add    $0x1,%edx
  800bd6:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bda:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bdc:	0f b6 02             	movzbl (%edx),%eax
  800bdf:	8d 70 d0             	lea    -0x30(%eax),%esi
  800be2:	89 f3                	mov    %esi,%ebx
  800be4:	80 fb 09             	cmp    $0x9,%bl
  800be7:	76 df                	jbe    800bc8 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 70 9f             	lea    -0x61(%eax),%esi
  800bec:	89 f3                	mov    %esi,%ebx
  800bee:	80 fb 19             	cmp    $0x19,%bl
  800bf1:	77 08                	ja     800bfb <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf3:	0f be c0             	movsbl %al,%eax
  800bf6:	83 e8 57             	sub    $0x57,%eax
  800bf9:	eb d3                	jmp    800bce <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bfb:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bfe:	89 f3                	mov    %esi,%ebx
  800c00:	80 fb 19             	cmp    $0x19,%bl
  800c03:	77 08                	ja     800c0d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c05:	0f be c0             	movsbl %al,%eax
  800c08:	83 e8 37             	sub    $0x37,%eax
  800c0b:	eb c1                	jmp    800bce <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c11:	74 05                	je     800c18 <strtol+0xcc>
		*endptr = (char *) s;
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c18:	89 c8                	mov    %ecx,%eax
  800c1a:	f7 d8                	neg    %eax
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	0f 45 c8             	cmovne %eax,%ecx
}
  800c21:	89 c8                	mov    %ecx,%eax
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
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
