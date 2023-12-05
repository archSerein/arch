
obj/user/softint:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	57                   	push   %edi
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 0c             	sub    $0xc,%esp
  80003f:	e8 4e 00 00 00       	call   800092 <__x86.get_pc_thunk.bx>
  800044:	81 c3 bc 1f 00 00    	add    $0x1fbc,%ebx
  80004a:	8b 75 08             	mov    0x8(%ebp),%esi
  80004d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800050:	e8 f4 00 00 00       	call   800149 <sys_getenvid>
  800055:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005a:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80005d:	c1 e0 05             	shl    $0x5,%eax
  800060:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800066:	89 83 2c 00 00 00    	mov    %eax,0x2c(%ebx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 f6                	test   %esi,%esi
  80006e:	7e 08                	jle    800078 <libmain+0x42>
		binaryname = argv[0];
  800070:	8b 07                	mov    (%edi),%eax
  800072:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	57                   	push   %edi
  80007c:	56                   	push   %esi
  80007d:	e8 b1 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800082:	e8 0f 00 00 00       	call   800096 <exit>
}
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5f                   	pop    %edi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    

00800092 <__x86.get_pc_thunk.bx>:
  800092:	8b 1c 24             	mov    (%esp),%ebx
  800095:	c3                   	ret    

00800096 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	53                   	push   %ebx
  80009a:	83 ec 10             	sub    $0x10,%esp
  80009d:	e8 f0 ff ff ff       	call   800092 <__x86.get_pc_thunk.bx>
  8000a2:	81 c3 5e 1f 00 00    	add    $0x1f5e,%ebx
	sys_env_destroy(0);
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 45 00 00 00       	call   8000f4 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c8:	89 c3                	mov    %eax,%ebx
  8000ca:	89 c7                	mov    %eax,%edi
  8000cc:	89 c6                	mov    %eax,%esi
  8000ce:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    

008000d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d5:	55                   	push   %ebp
  8000d6:	89 e5                	mov    %esp,%ebp
  8000d8:	57                   	push   %edi
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000db:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e5:	89 d1                	mov    %edx,%ecx
  8000e7:	89 d3                	mov    %edx,%ebx
  8000e9:	89 d7                	mov    %edx,%edi
  8000eb:	89 d6                	mov    %edx,%esi
  8000ed:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 1c             	sub    $0x1c,%esp
  8000fd:	e8 66 00 00 00       	call   800168 <__x86.get_pc_thunk.ax>
  800102:	05 fe 1e 00 00       	add    $0x1efe,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80010a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010f:	8b 55 08             	mov    0x8(%ebp),%edx
  800112:	b8 03 00 00 00       	mov    $0x3,%eax
  800117:	89 cb                	mov    %ecx,%ebx
  800119:	89 cf                	mov    %ecx,%edi
  80011b:	89 ce                	mov    %ecx,%esi
  80011d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011f:	85 c0                	test   %eax,%eax
  800121:	7f 08                	jg     80012b <sys_env_destroy+0x37>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800123:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5f                   	pop    %edi
  800129:	5d                   	pop    %ebp
  80012a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	6a 03                	push   $0x3
  800131:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800134:	8d 83 5e ee ff ff    	lea    -0x11a2(%ebx),%eax
  80013a:	50                   	push   %eax
  80013b:	6a 23                	push   $0x23
  80013d:	8d 83 7b ee ff ff    	lea    -0x1185(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 23 00 00 00       	call   80016c <_panic>

00800149 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014f:	ba 00 00 00 00       	mov    $0x0,%edx
  800154:	b8 02 00 00 00       	mov    $0x2,%eax
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	89 d3                	mov    %edx,%ebx
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	89 d6                	mov    %edx,%esi
  800161:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <__x86.get_pc_thunk.ax>:
  800168:	8b 04 24             	mov    (%esp),%eax
  80016b:	c3                   	ret    

0080016c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	e8 18 ff ff ff       	call   800092 <__x86.get_pc_thunk.bx>
  80017a:	81 c3 86 1e 00 00    	add    $0x1e86,%ebx
	va_list ap;

	va_start(ap, fmt);
  800180:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800183:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800189:	8b 38                	mov    (%eax),%edi
  80018b:	e8 b9 ff ff ff       	call   800149 <sys_getenvid>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	ff 75 0c             	push   0xc(%ebp)
  800196:	ff 75 08             	push   0x8(%ebp)
  800199:	57                   	push   %edi
  80019a:	50                   	push   %eax
  80019b:	8d 83 8c ee ff ff    	lea    -0x1174(%ebx),%eax
  8001a1:	50                   	push   %eax
  8001a2:	e8 d1 00 00 00       	call   800278 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a7:	83 c4 18             	add    $0x18,%esp
  8001aa:	56                   	push   %esi
  8001ab:	ff 75 10             	push   0x10(%ebp)
  8001ae:	e8 63 00 00 00       	call   800216 <vcprintf>
	cprintf("\n");
  8001b3:	8d 83 af ee ff ff    	lea    -0x1151(%ebx),%eax
  8001b9:	89 04 24             	mov    %eax,(%esp)
  8001bc:	e8 b7 00 00 00       	call   800278 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c4:	cc                   	int3   
  8001c5:	eb fd                	jmp    8001c4 <_panic+0x58>

008001c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	56                   	push   %esi
  8001cb:	53                   	push   %ebx
  8001cc:	e8 c1 fe ff ff       	call   800092 <__x86.get_pc_thunk.bx>
  8001d1:	81 c3 2f 1e 00 00    	add    $0x1e2f,%ebx
  8001d7:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001da:	8b 16                	mov    (%esi),%edx
  8001dc:	8d 42 01             	lea    0x1(%edx),%eax
  8001df:	89 06                	mov    %eax,(%esi)
  8001e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e4:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ed:	74 0b                	je     8001fa <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ef:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001f6:	5b                   	pop    %ebx
  8001f7:	5e                   	pop    %esi
  8001f8:	5d                   	pop    %ebp
  8001f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	68 ff 00 00 00       	push   $0xff
  800202:	8d 46 08             	lea    0x8(%esi),%eax
  800205:	50                   	push   %eax
  800206:	e8 ac fe ff ff       	call   8000b7 <sys_cputs>
		b->idx = 0;
  80020b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb d9                	jmp    8001ef <putch+0x28>

00800216 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	53                   	push   %ebx
  80021a:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800220:	e8 6d fe ff ff       	call   800092 <__x86.get_pc_thunk.bx>
  800225:	81 c3 db 1d 00 00    	add    $0x1ddb,%ebx
	struct printbuf b;

	b.idx = 0;
  80022b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800232:	00 00 00 
	b.cnt = 0;
  800235:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80023c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023f:	ff 75 0c             	push   0xc(%ebp)
  800242:	ff 75 08             	push   0x8(%ebp)
  800245:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	8d 83 c7 e1 ff ff    	lea    -0x1e39(%ebx),%eax
  800252:	50                   	push   %eax
  800253:	e8 2c 01 00 00       	call   800384 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800258:	83 c4 08             	add    $0x8,%esp
  80025b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  800261:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800267:	50                   	push   %eax
  800268:	e8 4a fe ff ff       	call   8000b7 <sys_cputs>

	return b.cnt;
}
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800281:	50                   	push   %eax
  800282:	ff 75 08             	push   0x8(%ebp)
  800285:	e8 8c ff ff ff       	call   800216 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 2c             	sub    $0x2c,%esp
  800295:	e8 07 06 00 00       	call   8008a1 <__x86.get_pc_thunk.cx>
  80029a:	81 c1 66 1d 00 00    	add    $0x1d66,%ecx
  8002a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002a3:	89 c7                	mov    %eax,%edi
  8002a5:	89 d6                	mov    %edx,%esi
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ad:	89 d1                	mov    %edx,%ecx
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002b4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002c7:	39 c2                	cmp    %eax,%edx
  8002c9:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002cc:	72 41                	jb     80030f <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 18             	push   0x18(%ebp)
  8002d4:	83 eb 01             	sub    $0x1,%ebx
  8002d7:	53                   	push   %ebx
  8002d8:	50                   	push   %eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	ff 75 e4             	push   -0x1c(%ebp)
  8002df:	ff 75 e0             	push   -0x20(%ebp)
  8002e2:	ff 75 d4             	push   -0x2c(%ebp)
  8002e5:	ff 75 d0             	push   -0x30(%ebp)
  8002e8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002eb:	e8 30 09 00 00       	call   800c20 <__udivdi3>
  8002f0:	83 c4 18             	add    $0x18,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	89 f2                	mov    %esi,%edx
  8002f7:	89 f8                	mov    %edi,%eax
  8002f9:	e8 8e ff ff ff       	call   80028c <printnum>
  8002fe:	83 c4 20             	add    $0x20,%esp
  800301:	eb 13                	jmp    800316 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	ff 75 18             	push   0x18(%ebp)
  80030a:	ff d7                	call   *%edi
  80030c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80030f:	83 eb 01             	sub    $0x1,%ebx
  800312:	85 db                	test   %ebx,%ebx
  800314:	7f ed                	jg     800303 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	56                   	push   %esi
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	ff 75 e4             	push   -0x1c(%ebp)
  800320:	ff 75 e0             	push   -0x20(%ebp)
  800323:	ff 75 d4             	push   -0x2c(%ebp)
  800326:	ff 75 d0             	push   -0x30(%ebp)
  800329:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80032c:	e8 0f 0a 00 00       	call   800d40 <__umoddi3>
  800331:	83 c4 14             	add    $0x14,%esp
  800334:	0f be 84 03 b1 ee ff 	movsbl -0x114f(%ebx,%eax,1),%eax
  80033b:	ff 
  80033c:	50                   	push   %eax
  80033d:	ff d7                	call   *%edi
}
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    

0080034a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800350:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800354:	8b 10                	mov    (%eax),%edx
  800356:	3b 50 04             	cmp    0x4(%eax),%edx
  800359:	73 0a                	jae    800365 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035e:	89 08                	mov    %ecx,(%eax)
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	88 02                	mov    %al,(%edx)
}
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <printfmt>:
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 10             	push   0x10(%ebp)
  800374:	ff 75 0c             	push   0xc(%ebp)
  800377:	ff 75 08             	push   0x8(%ebp)
  80037a:	e8 05 00 00 00       	call   800384 <vprintfmt>
}
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <vprintfmt>:
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 3c             	sub    $0x3c,%esp
  80038d:	e8 d6 fd ff ff       	call   800168 <__x86.get_pc_thunk.ax>
  800392:	05 6e 1c 00 00       	add    $0x1c6e,%eax
  800397:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a3:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ac:	eb 0a                	jmp    8003b8 <vprintfmt+0x34>
			putch(ch, putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	57                   	push   %edi
  8003b2:	50                   	push   %eax
  8003b3:	ff d6                	call   *%esi
  8003b5:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b8:	83 c3 01             	add    $0x1,%ebx
  8003bb:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8003bf:	83 f8 25             	cmp    $0x25,%eax
  8003c2:	74 0c                	je     8003d0 <vprintfmt+0x4c>
			if (ch == '\0')
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	75 e6                	jne    8003ae <vprintfmt+0x2a>
}
  8003c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cb:	5b                   	pop    %ebx
  8003cc:	5e                   	pop    %esi
  8003cd:	5f                   	pop    %edi
  8003ce:	5d                   	pop    %ebp
  8003cf:	c3                   	ret    
		padc = ' ';
  8003d0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003d4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e2:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  8003e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ee:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f1:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8d 43 01             	lea    0x1(%ebx),%eax
  8003f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fa:	0f b6 13             	movzbl (%ebx),%edx
  8003fd:	8d 42 dd             	lea    -0x23(%edx),%eax
  800400:	3c 55                	cmp    $0x55,%al
  800402:	0f 87 fd 03 00 00    	ja     800805 <.L20>
  800408:	0f b6 c0             	movzbl %al,%eax
  80040b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040e:	89 ce                	mov    %ecx,%esi
  800410:	03 b4 81 40 ef ff ff 	add    -0x10c0(%ecx,%eax,4),%esi
  800417:	ff e6                	jmp    *%esi

00800419 <.L68>:
  800419:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80041c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800420:	eb d2                	jmp    8003f4 <vprintfmt+0x70>

00800422 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800425:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800429:	eb c9                	jmp    8003f4 <vprintfmt+0x70>

0080042b <.L31>:
  80042b:	0f b6 d2             	movzbl %dl,%edx
  80042e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800431:	b8 00 00 00 00       	mov    $0x0,%eax
  800436:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800439:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800440:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800443:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800446:	83 f9 09             	cmp    $0x9,%ecx
  800449:	77 58                	ja     8004a3 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80044b:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80044e:	eb e9                	jmp    800439 <.L31+0xe>

00800450 <.L34>:
			precision = va_arg(ap, int);
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8d 40 04             	lea    0x4(%eax),%eax
  80045e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800464:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800468:	79 8a                	jns    8003f4 <vprintfmt+0x70>
				width = precision, precision = -1;
  80046a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800470:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800477:	e9 78 ff ff ff       	jmp    8003f4 <vprintfmt+0x70>

0080047c <.L33>:
  80047c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	0f 49 c2             	cmovns %edx,%eax
  800489:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  80048f:	e9 60 ff ff ff       	jmp    8003f4 <vprintfmt+0x70>

00800494 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  800494:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  800497:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049e:	e9 51 ff ff ff       	jmp    8003f4 <vprintfmt+0x70>
  8004a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a9:	eb b9                	jmp    800464 <.L34+0x14>

008004ab <.L27>:
			lflag++;
  8004ab:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b2:	e9 3d ff ff ff       	jmp    8003f4 <vprintfmt+0x70>

008004b7 <.L30>:
			putch(va_arg(ap, int), putdat);
  8004b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 58 04             	lea    0x4(%eax),%ebx
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	57                   	push   %edi
  8004c4:	ff 30                	push   (%eax)
  8004c6:	ff d6                	call   *%esi
			break;
  8004c8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cb:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004ce:	e9 c8 02 00 00       	jmp    80079b <.L25+0x45>

008004d3 <.L28>:
			err = va_arg(ap, int);
  8004d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d9:	8d 58 04             	lea    0x4(%eax),%ebx
  8004dc:	8b 10                	mov    (%eax),%edx
  8004de:	89 d0                	mov    %edx,%eax
  8004e0:	f7 d8                	neg    %eax
  8004e2:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e5:	83 f8 06             	cmp    $0x6,%eax
  8004e8:	7f 27                	jg     800511 <.L28+0x3e>
  8004ea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ed:	8b 14 82             	mov    (%edx,%eax,4),%edx
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	74 1d                	je     800511 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
  8004f4:	52                   	push   %edx
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	8d 80 d2 ee ff ff    	lea    -0x112e(%eax),%eax
  8004fe:	50                   	push   %eax
  8004ff:	57                   	push   %edi
  800500:	56                   	push   %esi
  800501:	e8 61 fe ff ff       	call   800367 <printfmt>
  800506:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800509:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80050c:	e9 8a 02 00 00       	jmp    80079b <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800511:	50                   	push   %eax
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	8d 80 c9 ee ff ff    	lea    -0x1137(%eax),%eax
  80051b:	50                   	push   %eax
  80051c:	57                   	push   %edi
  80051d:	56                   	push   %esi
  80051e:	e8 44 fe ff ff       	call   800367 <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800529:	e9 6d 02 00 00       	jmp    80079b <.L25+0x45>

0080052e <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
  80052e:	8b 75 08             	mov    0x8(%ebp),%esi
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	83 c0 04             	add    $0x4,%eax
  800537:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80053f:	85 d2                	test   %edx,%edx
  800541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800544:	8d 80 c2 ee ff ff    	lea    -0x113e(%eax),%eax
  80054a:	0f 45 c2             	cmovne %edx,%eax
  80054d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800550:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800554:	7e 06                	jle    80055c <.L24+0x2e>
  800556:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80055a:	75 0d                	jne    800569 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055f:	89 c3                	mov    %eax,%ebx
  800561:	03 45 d4             	add    -0x2c(%ebp),%eax
  800564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800567:	eb 58                	jmp    8005c1 <.L24+0x93>
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	ff 75 d8             	push   -0x28(%ebp)
  80056f:	ff 75 c8             	push   -0x38(%ebp)
  800572:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800575:	e8 43 03 00 00       	call   8008bd <strnlen>
  80057a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057d:	29 c2                	sub    %eax,%edx
  80057f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  800587:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80058b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80058e:	eb 0f                	jmp    80059f <.L24+0x71>
					putch(padc, putdat);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	57                   	push   %edi
  800594:	ff 75 d4             	push   -0x2c(%ebp)
  800597:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800599:	83 eb 01             	sub    $0x1,%ebx
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	85 db                	test   %ebx,%ebx
  8005a1:	7f ed                	jg     800590 <.L24+0x62>
  8005a3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005a6:	85 d2                	test   %edx,%edx
  8005a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ad:	0f 49 c2             	cmovns %edx,%eax
  8005b0:	29 c2                	sub    %eax,%edx
  8005b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b5:	eb a5                	jmp    80055c <.L24+0x2e>
					putch(ch, putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	57                   	push   %edi
  8005bb:	52                   	push   %edx
  8005bc:	ff d6                	call   *%esi
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005c4:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c6:	83 c3 01             	add    $0x1,%ebx
  8005c9:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005cd:	0f be d0             	movsbl %al,%edx
  8005d0:	85 d2                	test   %edx,%edx
  8005d2:	74 4b                	je     80061f <.L24+0xf1>
  8005d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d8:	78 06                	js     8005e0 <.L24+0xb2>
  8005da:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005de:	78 1e                	js     8005fe <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e4:	74 d1                	je     8005b7 <.L24+0x89>
  8005e6:	0f be c0             	movsbl %al,%eax
  8005e9:	83 e8 20             	sub    $0x20,%eax
  8005ec:	83 f8 5e             	cmp    $0x5e,%eax
  8005ef:	76 c6                	jbe    8005b7 <.L24+0x89>
					putch('?', putdat);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	57                   	push   %edi
  8005f5:	6a 3f                	push   $0x3f
  8005f7:	ff d6                	call   *%esi
  8005f9:	83 c4 10             	add    $0x10,%esp
  8005fc:	eb c3                	jmp    8005c1 <.L24+0x93>
  8005fe:	89 cb                	mov    %ecx,%ebx
  800600:	eb 0e                	jmp    800610 <.L24+0xe2>
				putch(' ', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	57                   	push   %edi
  800606:	6a 20                	push   $0x20
  800608:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80060a:	83 eb 01             	sub    $0x1,%ebx
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	85 db                	test   %ebx,%ebx
  800612:	7f ee                	jg     800602 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800614:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
  80061a:	e9 7c 01 00 00       	jmp    80079b <.L25+0x45>
  80061f:	89 cb                	mov    %ecx,%ebx
  800621:	eb ed                	jmp    800610 <.L24+0xe2>

00800623 <.L29>:
	if (lflag >= 2)
  800623:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800626:	8b 75 08             	mov    0x8(%ebp),%esi
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <.L29+0x26>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 63                	je     800695 <.L29+0x72>
		return va_arg(*ap, long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063a:	99                   	cltd   
  80063b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb 17                	jmp    800660 <.L29+0x3d>
		return va_arg(*ap, long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 08             	lea    0x8(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800660:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800663:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
  800666:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
  80066b:	85 db                	test   %ebx,%ebx
  80066d:	0f 89 0e 01 00 00    	jns    800781 <.L25+0x2b>
				putch('-', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	57                   	push   %edi
  800677:	6a 2d                	push   $0x2d
  800679:	ff d6                	call   *%esi
				num = -(long long) num;
  80067b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80067e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800681:	f7 d9                	neg    %ecx
  800683:	83 d3 00             	adc    $0x0,%ebx
  800686:	f7 db                	neg    %ebx
  800688:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800690:	e9 ec 00 00 00       	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	99                   	cltd   
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	eb b4                	jmp    800660 <.L29+0x3d>

008006ac <.L23>:
	if (lflag >= 2)
  8006ac:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006af:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b2:	83 f9 01             	cmp    $0x1,%ecx
  8006b5:	7f 1e                	jg     8006d5 <.L23+0x29>
	else if (lflag)
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	74 32                	je     8006ed <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 08                	mov    (%eax),%ecx
  8006c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cb:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
  8006d0:	e9 ac 00 00 00       	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 08                	mov    (%eax),%ecx
  8006da:	8b 58 04             	mov    0x4(%eax),%ebx
  8006dd:	8d 40 08             	lea    0x8(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e3:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
  8006e8:	e9 94 00 00 00       	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 08                	mov    (%eax),%ecx
  8006f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fd:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
  800702:	eb 7d                	jmp    800781 <.L25+0x2b>

00800704 <.L26>:
	if (lflag >= 2)
  800704:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800707:	8b 75 08             	mov    0x8(%ebp),%esi
  80070a:	83 f9 01             	cmp    $0x1,%ecx
  80070d:	7f 1b                	jg     80072a <.L26+0x26>
	else if (lflag)
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	74 2c                	je     80073f <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 08                	mov    (%eax),%ecx
  800718:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800723:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
  800728:	eb 57                	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 08                	mov    (%eax),%ecx
  80072f:	8b 58 04             	mov    0x4(%eax),%ebx
  800732:	8d 40 08             	lea    0x8(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800738:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
  80073d:	eb 42                	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 08                	mov    (%eax),%ecx
  800744:	bb 00 00 00 00       	mov    $0x0,%ebx
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074f:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
  800754:	eb 2b                	jmp    800781 <.L25+0x2b>

00800756 <.L25>:
			putch('0', putdat);
  800756:	8b 75 08             	mov    0x8(%ebp),%esi
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	57                   	push   %edi
  80075d:	6a 30                	push   $0x30
  80075f:	ff d6                	call   *%esi
			putch('x', putdat);
  800761:	83 c4 08             	add    $0x8,%esp
  800764:	57                   	push   %edi
  800765:	6a 78                	push   $0x78
  800767:	ff d6                	call   *%esi
			num = (unsigned long long)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 08                	mov    (%eax),%ecx
  80076e:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
  800773:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800781:	83 ec 0c             	sub    $0xc,%esp
  800784:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	ff 75 d4             	push   -0x2c(%ebp)
  80078c:	52                   	push   %edx
  80078d:	53                   	push   %ebx
  80078e:	51                   	push   %ecx
  80078f:	89 fa                	mov    %edi,%edx
  800791:	89 f0                	mov    %esi,%eax
  800793:	e8 f4 fa ff ff       	call   80028c <printnum>
			break;
  800798:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079e:	e9 15 fc ff ff       	jmp    8003b8 <vprintfmt+0x34>

008007a3 <.L21>:
	if (lflag >= 2)
  8007a3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a9:	83 f9 01             	cmp    $0x1,%ecx
  8007ac:	7f 1b                	jg     8007c9 <.L21+0x26>
	else if (lflag)
  8007ae:	85 c9                	test   %ecx,%ecx
  8007b0:	74 2c                	je     8007de <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 08                	mov    (%eax),%ecx
  8007b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
  8007c7:	eb b8                	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 08                	mov    (%eax),%ecx
  8007ce:	8b 58 04             	mov    0x4(%eax),%ebx
  8007d1:	8d 40 08             	lea    0x8(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
  8007dc:	eb a3                	jmp    800781 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 08                	mov    (%eax),%ecx
  8007e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
  8007f3:	eb 8c                	jmp    800781 <.L25+0x2b>

008007f5 <.L35>:
			putch(ch, putdat);
  8007f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	57                   	push   %edi
  8007fc:	6a 25                	push   $0x25
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	eb 96                	jmp    80079b <.L25+0x45>

00800805 <.L20>:
			putch('%', putdat);
  800805:	8b 75 08             	mov    0x8(%ebp),%esi
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	57                   	push   %edi
  80080c:	6a 25                	push   $0x25
  80080e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 d8                	mov    %ebx,%eax
  800815:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800819:	74 05                	je     800820 <.L20+0x1b>
  80081b:	83 e8 01             	sub    $0x1,%eax
  80081e:	eb f5                	jmp    800815 <.L20+0x10>
  800820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800823:	e9 73 ff ff ff       	jmp    80079b <.L25+0x45>

00800828 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	83 ec 14             	sub    $0x14,%esp
  80082f:	e8 5e f8 ff ff       	call   800092 <__x86.get_pc_thunk.bx>
  800834:	81 c3 cc 17 00 00    	add    $0x17cc,%ebx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800840:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800843:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800847:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800851:	85 c0                	test   %eax,%eax
  800853:	74 2b                	je     800880 <vsnprintf+0x58>
  800855:	85 d2                	test   %edx,%edx
  800857:	7e 27                	jle    800880 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800859:	ff 75 14             	push   0x14(%ebp)
  80085c:	ff 75 10             	push   0x10(%ebp)
  80085f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800862:	50                   	push   %eax
  800863:	8d 83 4a e3 ff ff    	lea    -0x1cb6(%ebx),%eax
  800869:	50                   	push   %eax
  80086a:	e8 15 fb ff ff       	call   800384 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800872:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800878:	83 c4 10             	add    $0x10,%esp
}
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    
		return -E_INVAL;
  800880:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800885:	eb f4                	jmp    80087b <vsnprintf+0x53>

00800887 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800890:	50                   	push   %eax
  800891:	ff 75 10             	push   0x10(%ebp)
  800894:	ff 75 0c             	push   0xc(%ebp)
  800897:	ff 75 08             	push   0x8(%ebp)
  80089a:	e8 89 ff ff ff       	call   800828 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <__x86.get_pc_thunk.cx>:
  8008a1:	8b 0c 24             	mov    (%esp),%ecx
  8008a4:	c3                   	ret    

008008a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	eb 03                	jmp    8008b5 <strlen+0x10>
		n++;
  8008b2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b9:	75 f7                	jne    8008b2 <strlen+0xd>
	return n;
}
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	eb 03                	jmp    8008d0 <strnlen+0x13>
		n++;
  8008cd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d0:	39 d0                	cmp    %edx,%eax
  8008d2:	74 08                	je     8008dc <strnlen+0x1f>
  8008d4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d8:	75 f3                	jne    8008cd <strnlen+0x10>
  8008da:	89 c2                	mov    %eax,%edx
	return n;
}
  8008dc:	89 d0                	mov    %edx,%eax
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	53                   	push   %ebx
  8008e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ef:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008f3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008f6:	83 c0 01             	add    $0x1,%eax
  8008f9:	84 d2                	test   %dl,%dl
  8008fb:	75 f2                	jne    8008ef <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008fd:	89 c8                	mov    %ecx,%eax
  8008ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	53                   	push   %ebx
  800908:	83 ec 10             	sub    $0x10,%esp
  80090b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090e:	53                   	push   %ebx
  80090f:	e8 91 ff ff ff       	call   8008a5 <strlen>
  800914:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800917:	ff 75 0c             	push   0xc(%ebp)
  80091a:	01 d8                	add    %ebx,%eax
  80091c:	50                   	push   %eax
  80091d:	e8 be ff ff ff       	call   8008e0 <strcpy>
	return dst;
}
  800922:	89 d8                	mov    %ebx,%eax
  800924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	8b 75 08             	mov    0x8(%ebp),%esi
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	89 f3                	mov    %esi,%ebx
  800936:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800939:	89 f0                	mov    %esi,%eax
  80093b:	eb 0f                	jmp    80094c <strncpy+0x23>
		*dst++ = *src;
  80093d:	83 c0 01             	add    $0x1,%eax
  800940:	0f b6 0a             	movzbl (%edx),%ecx
  800943:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800946:	80 f9 01             	cmp    $0x1,%cl
  800949:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
  80094c:	39 d8                	cmp    %ebx,%eax
  80094e:	75 ed                	jne    80093d <strncpy+0x14>
	}
	return ret;
}
  800950:	89 f0                	mov    %esi,%eax
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800961:	8b 55 10             	mov    0x10(%ebp),%edx
  800964:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800966:	85 d2                	test   %edx,%edx
  800968:	74 21                	je     80098b <strlcpy+0x35>
  80096a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096e:	89 f2                	mov    %esi,%edx
  800970:	eb 09                	jmp    80097b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800972:	83 c1 01             	add    $0x1,%ecx
  800975:	83 c2 01             	add    $0x1,%edx
  800978:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	74 09                	je     800988 <strlcpy+0x32>
  80097f:	0f b6 19             	movzbl (%ecx),%ebx
  800982:	84 db                	test   %bl,%bl
  800984:	75 ec                	jne    800972 <strlcpy+0x1c>
  800986:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800988:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098b:	29 f0                	sub    %esi,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099a:	eb 06                	jmp    8009a2 <strcmp+0x11>
		p++, q++;
  80099c:	83 c1 01             	add    $0x1,%ecx
  80099f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a2:	0f b6 01             	movzbl (%ecx),%eax
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 04                	je     8009ad <strcmp+0x1c>
  8009a9:	3a 02                	cmp    (%edx),%al
  8009ab:	74 ef                	je     80099c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ad:	0f b6 c0             	movzbl %al,%eax
  8009b0:	0f b6 12             	movzbl (%edx),%edx
  8009b3:	29 d0                	sub    %edx,%eax
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 c3                	mov    %eax,%ebx
  8009c3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c6:	eb 06                	jmp    8009ce <strncmp+0x17>
		n--, p++, q++;
  8009c8:	83 c0 01             	add    $0x1,%eax
  8009cb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ce:	39 d8                	cmp    %ebx,%eax
  8009d0:	74 18                	je     8009ea <strncmp+0x33>
  8009d2:	0f b6 08             	movzbl (%eax),%ecx
  8009d5:	84 c9                	test   %cl,%cl
  8009d7:	74 04                	je     8009dd <strncmp+0x26>
  8009d9:	3a 0a                	cmp    (%edx),%cl
  8009db:	74 eb                	je     8009c8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dd:	0f b6 00             	movzbl (%eax),%eax
  8009e0:	0f b6 12             	movzbl (%edx),%edx
  8009e3:	29 d0                	sub    %edx,%eax
}
  8009e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    
		return 0;
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ef:	eb f4                	jmp    8009e5 <strncmp+0x2e>

008009f1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fb:	eb 03                	jmp    800a00 <strchr+0xf>
  8009fd:	83 c0 01             	add    $0x1,%eax
  800a00:	0f b6 10             	movzbl (%eax),%edx
  800a03:	84 d2                	test   %dl,%dl
  800a05:	74 06                	je     800a0d <strchr+0x1c>
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	75 f2                	jne    8009fd <strchr+0xc>
  800a0b:	eb 05                	jmp    800a12 <strchr+0x21>
			return (char *) s;
	return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a21:	38 ca                	cmp    %cl,%dl
  800a23:	74 09                	je     800a2e <strfind+0x1a>
  800a25:	84 d2                	test   %dl,%dl
  800a27:	74 05                	je     800a2e <strfind+0x1a>
	for (; *s; s++)
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	eb f0                	jmp    800a1e <strfind+0xa>
			break;
	return (char *) s;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	57                   	push   %edi
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3c:	85 c9                	test   %ecx,%ecx
  800a3e:	74 2f                	je     800a6f <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	09 c8                	or     %ecx,%eax
  800a44:	a8 03                	test   $0x3,%al
  800a46:	75 21                	jne    800a69 <memset+0x39>
		c &= 0xFF;
  800a48:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4c:	89 d0                	mov    %edx,%eax
  800a4e:	c1 e0 08             	shl    $0x8,%eax
  800a51:	89 d3                	mov    %edx,%ebx
  800a53:	c1 e3 18             	shl    $0x18,%ebx
  800a56:	89 d6                	mov    %edx,%esi
  800a58:	c1 e6 10             	shl    $0x10,%esi
  800a5b:	09 f3                	or     %esi,%ebx
  800a5d:	09 da                	or     %ebx,%edx
  800a5f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a61:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a64:	fc                   	cld    
  800a65:	f3 ab                	rep stos %eax,%es:(%edi)
  800a67:	eb 06                	jmp    800a6f <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	fc                   	cld    
  800a6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6f:	89 f8                	mov    %edi,%eax
  800a71:	5b                   	pop    %ebx
  800a72:	5e                   	pop    %esi
  800a73:	5f                   	pop    %edi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a84:	39 c6                	cmp    %eax,%esi
  800a86:	73 32                	jae    800aba <memmove+0x44>
  800a88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8b:	39 c2                	cmp    %eax,%edx
  800a8d:	76 2b                	jbe    800aba <memmove+0x44>
		s += n;
		d += n;
  800a8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a92:	89 d6                	mov    %edx,%esi
  800a94:	09 fe                	or     %edi,%esi
  800a96:	09 ce                	or     %ecx,%esi
  800a98:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9e:	75 0e                	jne    800aae <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa0:	83 ef 04             	sub    $0x4,%edi
  800aa3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa9:	fd                   	std    
  800aaa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aac:	eb 09                	jmp    800ab7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aae:	83 ef 01             	sub    $0x1,%edi
  800ab1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab4:	fd                   	std    
  800ab5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab7:	fc                   	cld    
  800ab8:	eb 1a                	jmp    800ad4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aba:	89 f2                	mov    %esi,%edx
  800abc:	09 c2                	or     %eax,%edx
  800abe:	09 ca                	or     %ecx,%edx
  800ac0:	f6 c2 03             	test   $0x3,%dl
  800ac3:	75 0a                	jne    800acf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac8:	89 c7                	mov    %eax,%edi
  800aca:	fc                   	cld    
  800acb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acd:	eb 05                	jmp    800ad4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800acf:	89 c7                	mov    %eax,%edi
  800ad1:	fc                   	cld    
  800ad2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad4:	5e                   	pop    %esi
  800ad5:	5f                   	pop    %edi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ade:	ff 75 10             	push   0x10(%ebp)
  800ae1:	ff 75 0c             	push   0xc(%ebp)
  800ae4:	ff 75 08             	push   0x8(%ebp)
  800ae7:	e8 8a ff ff ff       	call   800a76 <memmove>
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af9:	89 c6                	mov    %eax,%esi
  800afb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afe:	eb 06                	jmp    800b06 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
  800b06:	39 f0                	cmp    %esi,%eax
  800b08:	74 14                	je     800b1e <memcmp+0x30>
		if (*s1 != *s2)
  800b0a:	0f b6 08             	movzbl (%eax),%ecx
  800b0d:	0f b6 1a             	movzbl (%edx),%ebx
  800b10:	38 d9                	cmp    %bl,%cl
  800b12:	74 ec                	je     800b00 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
  800b14:	0f b6 c1             	movzbl %cl,%eax
  800b17:	0f b6 db             	movzbl %bl,%ebx
  800b1a:	29 d8                	sub    %ebx,%eax
  800b1c:	eb 05                	jmp    800b23 <memcmp+0x35>
	}

	return 0;
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b35:	eb 03                	jmp    800b3a <memfind+0x13>
  800b37:	83 c0 01             	add    $0x1,%eax
  800b3a:	39 d0                	cmp    %edx,%eax
  800b3c:	73 04                	jae    800b42 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3e:	38 08                	cmp    %cl,(%eax)
  800b40:	75 f5                	jne    800b37 <memfind+0x10>
			break;
	return (void *) s;
}
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
  800b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b50:	eb 03                	jmp    800b55 <strtol+0x11>
		s++;
  800b52:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800b55:	0f b6 02             	movzbl (%edx),%eax
  800b58:	3c 20                	cmp    $0x20,%al
  800b5a:	74 f6                	je     800b52 <strtol+0xe>
  800b5c:	3c 09                	cmp    $0x9,%al
  800b5e:	74 f2                	je     800b52 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b60:	3c 2b                	cmp    $0x2b,%al
  800b62:	74 2a                	je     800b8e <strtol+0x4a>
	int neg = 0;
  800b64:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b69:	3c 2d                	cmp    $0x2d,%al
  800b6b:	74 2b                	je     800b98 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b73:	75 0f                	jne    800b84 <strtol+0x40>
  800b75:	80 3a 30             	cmpb   $0x30,(%edx)
  800b78:	74 28                	je     800ba2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7a:	85 db                	test   %ebx,%ebx
  800b7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b81:	0f 44 d8             	cmove  %eax,%ebx
  800b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b89:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8c:	eb 46                	jmp    800bd4 <strtol+0x90>
		s++;
  800b8e:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b91:	bf 00 00 00 00       	mov    $0x0,%edi
  800b96:	eb d5                	jmp    800b6d <strtol+0x29>
		s++, neg = 1;
  800b98:	83 c2 01             	add    $0x1,%edx
  800b9b:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba0:	eb cb                	jmp    800b6d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba2:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba6:	74 0e                	je     800bb6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba8:	85 db                	test   %ebx,%ebx
  800baa:	75 d8                	jne    800b84 <strtol+0x40>
		s++, base = 8;
  800bac:	83 c2 01             	add    $0x1,%edx
  800baf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb4:	eb ce                	jmp    800b84 <strtol+0x40>
		s += 2, base = 16;
  800bb6:	83 c2 02             	add    $0x2,%edx
  800bb9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbe:	eb c4                	jmp    800b84 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bc0:	0f be c0             	movsbl %al,%eax
  800bc3:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bc9:	7d 3a                	jge    800c05 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bcb:	83 c2 01             	add    $0x1,%edx
  800bce:	0f af 4d 10          	imul   0x10(%ebp),%ecx
  800bd2:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
  800bd4:	0f b6 02             	movzbl (%edx),%eax
  800bd7:	8d 70 d0             	lea    -0x30(%eax),%esi
  800bda:	89 f3                	mov    %esi,%ebx
  800bdc:	80 fb 09             	cmp    $0x9,%bl
  800bdf:	76 df                	jbe    800bc0 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
  800be1:	8d 70 9f             	lea    -0x61(%eax),%esi
  800be4:	89 f3                	mov    %esi,%ebx
  800be6:	80 fb 19             	cmp    $0x19,%bl
  800be9:	77 08                	ja     800bf3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800beb:	0f be c0             	movsbl %al,%eax
  800bee:	83 e8 57             	sub    $0x57,%eax
  800bf1:	eb d3                	jmp    800bc6 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
  800bf3:	8d 70 bf             	lea    -0x41(%eax),%esi
  800bf6:	89 f3                	mov    %esi,%ebx
  800bf8:	80 fb 19             	cmp    $0x19,%bl
  800bfb:	77 08                	ja     800c05 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfd:	0f be c0             	movsbl %al,%eax
  800c00:	83 e8 37             	sub    $0x37,%eax
  800c03:	eb c1                	jmp    800bc6 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c09:	74 05                	je     800c10 <strtol+0xcc>
		*endptr = (char *) s;
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800c10:	89 c8                	mov    %ecx,%eax
  800c12:	f7 d8                	neg    %eax
  800c14:	85 ff                	test   %edi,%edi
  800c16:	0f 45 c8             	cmovne %eax,%ecx
}
  800c19:	89 c8                	mov    %ecx,%eax
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

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
