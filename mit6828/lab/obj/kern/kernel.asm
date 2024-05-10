
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 11 00       	mov    $0x112000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 00 11 f0       	mov    $0xf0110000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 68 00 00 00       	call   f01000a6 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:
#include <kern/console.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	e8 72 01 00 00       	call   f01001bc <__x86.get_pc_thunk.bx>
f010004a:	81 c3 be 12 01 00    	add    $0x112be,%ebx
f0100050:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("entering test_backtrace %d\n", x);
f0100053:	83 ec 08             	sub    $0x8,%esp
f0100056:	56                   	push   %esi
f0100057:	8d 83 38 08 ff ff    	lea    -0xf7c8(%ebx),%eax
f010005d:	50                   	push   %eax
f010005e:	e8 89 0a 00 00       	call   f0100aec <cprintf>
	if (x > 0)
f0100063:	83 c4 10             	add    $0x10,%esp
f0100066:	85 f6                	test   %esi,%esi
f0100068:	7e 29                	jle    f0100093 <test_backtrace+0x53>
		test_backtrace(x-1);
f010006a:	83 ec 0c             	sub    $0xc,%esp
f010006d:	8d 46 ff             	lea    -0x1(%esi),%eax
f0100070:	50                   	push   %eax
f0100071:	e8 ca ff ff ff       	call   f0100040 <test_backtrace>
f0100076:	83 c4 10             	add    $0x10,%esp
	else
		mon_backtrace(0, 0, 0);
	cprintf("leaving test_backtrace %d\n", x);
f0100079:	83 ec 08             	sub    $0x8,%esp
f010007c:	56                   	push   %esi
f010007d:	8d 83 54 08 ff ff    	lea    -0xf7ac(%ebx),%eax
f0100083:	50                   	push   %eax
f0100084:	e8 63 0a 00 00       	call   f0100aec <cprintf>
}
f0100089:	83 c4 10             	add    $0x10,%esp
f010008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010008f:	5b                   	pop    %ebx
f0100090:	5e                   	pop    %esi
f0100091:	5d                   	pop    %ebp
f0100092:	c3                   	ret    
		mon_backtrace(0, 0, 0);
f0100093:	83 ec 04             	sub    $0x4,%esp
f0100096:	6a 00                	push   $0x0
f0100098:	6a 00                	push   $0x0
f010009a:	6a 00                	push   $0x0
f010009c:	e8 ed 07 00 00       	call   f010088e <mon_backtrace>
f01000a1:	83 c4 10             	add    $0x10,%esp
f01000a4:	eb d3                	jmp    f0100079 <test_backtrace+0x39>

f01000a6 <i386_init>:

void
i386_init(void)
{
f01000a6:	55                   	push   %ebp
f01000a7:	89 e5                	mov    %esp,%ebp
f01000a9:	53                   	push   %ebx
f01000aa:	83 ec 08             	sub    $0x8,%esp
f01000ad:	e8 0a 01 00 00       	call   f01001bc <__x86.get_pc_thunk.bx>
f01000b2:	81 c3 56 12 01 00    	add    $0x11256,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000b8:	c7 c2 60 30 11 f0    	mov    $0xf0113060,%edx
f01000be:	c7 c0 c0 36 11 f0    	mov    $0xf01136c0,%eax
f01000c4:	29 d0                	sub    %edx,%eax
f01000c6:	50                   	push   %eax
f01000c7:	6a 00                	push   $0x0
f01000c9:	52                   	push   %edx
f01000ca:	e8 22 16 00 00       	call   f01016f1 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000cf:	e8 3e 05 00 00       	call   f0100612 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000d4:	83 c4 08             	add    $0x8,%esp
f01000d7:	68 ac 1a 00 00       	push   $0x1aac
f01000dc:	8d 83 6f 08 ff ff    	lea    -0xf791(%ebx),%eax
f01000e2:	50                   	push   %eax
f01000e3:	e8 04 0a 00 00       	call   f0100aec <cprintf>
	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f01000e8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000ef:	e8 4c ff ff ff       	call   f0100040 <test_backtrace>
f01000f4:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f01000f7:	83 ec 0c             	sub    $0xc,%esp
f01000fa:	6a 00                	push   $0x0
f01000fc:	e8 1f 08 00 00       	call   f0100920 <monitor>
f0100101:	83 c4 10             	add    $0x10,%esp
f0100104:	eb f1                	jmp    f01000f7 <i386_init+0x51>

f0100106 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100106:	55                   	push   %ebp
f0100107:	89 e5                	mov    %esp,%ebp
f0100109:	56                   	push   %esi
f010010a:	53                   	push   %ebx
f010010b:	e8 ac 00 00 00       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100110:	81 c3 f8 11 01 00    	add    $0x111f8,%ebx
	va_list ap;

	if (panicstr)
f0100116:	83 bb 58 1d 00 00 00 	cmpl   $0x0,0x1d58(%ebx)
f010011d:	74 0f                	je     f010012e <_panic+0x28>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010011f:	83 ec 0c             	sub    $0xc,%esp
f0100122:	6a 00                	push   $0x0
f0100124:	e8 f7 07 00 00       	call   f0100920 <monitor>
f0100129:	83 c4 10             	add    $0x10,%esp
f010012c:	eb f1                	jmp    f010011f <_panic+0x19>
	panicstr = fmt;
f010012e:	8b 45 10             	mov    0x10(%ebp),%eax
f0100131:	89 83 58 1d 00 00    	mov    %eax,0x1d58(%ebx)
	asm volatile("cli; cld");
f0100137:	fa                   	cli    
f0100138:	fc                   	cld    
	va_start(ap, fmt);
f0100139:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f010013c:	83 ec 04             	sub    $0x4,%esp
f010013f:	ff 75 0c             	push   0xc(%ebp)
f0100142:	ff 75 08             	push   0x8(%ebp)
f0100145:	8d 83 8a 08 ff ff    	lea    -0xf776(%ebx),%eax
f010014b:	50                   	push   %eax
f010014c:	e8 9b 09 00 00       	call   f0100aec <cprintf>
	vcprintf(fmt, ap);
f0100151:	83 c4 08             	add    $0x8,%esp
f0100154:	56                   	push   %esi
f0100155:	ff 75 10             	push   0x10(%ebp)
f0100158:	e8 58 09 00 00       	call   f0100ab5 <vcprintf>
	cprintf("\n");
f010015d:	8d 83 c6 08 ff ff    	lea    -0xf73a(%ebx),%eax
f0100163:	89 04 24             	mov    %eax,(%esp)
f0100166:	e8 81 09 00 00       	call   f0100aec <cprintf>
f010016b:	83 c4 10             	add    $0x10,%esp
f010016e:	eb af                	jmp    f010011f <_panic+0x19>

f0100170 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100170:	55                   	push   %ebp
f0100171:	89 e5                	mov    %esp,%ebp
f0100173:	56                   	push   %esi
f0100174:	53                   	push   %ebx
f0100175:	e8 42 00 00 00       	call   f01001bc <__x86.get_pc_thunk.bx>
f010017a:	81 c3 8e 11 01 00    	add    $0x1118e,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100180:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f0100183:	83 ec 04             	sub    $0x4,%esp
f0100186:	ff 75 0c             	push   0xc(%ebp)
f0100189:	ff 75 08             	push   0x8(%ebp)
f010018c:	8d 83 a2 08 ff ff    	lea    -0xf75e(%ebx),%eax
f0100192:	50                   	push   %eax
f0100193:	e8 54 09 00 00       	call   f0100aec <cprintf>
	vcprintf(fmt, ap);
f0100198:	83 c4 08             	add    $0x8,%esp
f010019b:	56                   	push   %esi
f010019c:	ff 75 10             	push   0x10(%ebp)
f010019f:	e8 11 09 00 00       	call   f0100ab5 <vcprintf>
	cprintf("\n");
f01001a4:	8d 83 c6 08 ff ff    	lea    -0xf73a(%ebx),%eax
f01001aa:	89 04 24             	mov    %eax,(%esp)
f01001ad:	e8 3a 09 00 00       	call   f0100aec <cprintf>
	va_end(ap);
}
f01001b2:	83 c4 10             	add    $0x10,%esp
f01001b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01001b8:	5b                   	pop    %ebx
f01001b9:	5e                   	pop    %esi
f01001ba:	5d                   	pop    %ebp
f01001bb:	c3                   	ret    

f01001bc <__x86.get_pc_thunk.bx>:
f01001bc:	8b 1c 24             	mov    (%esp),%ebx
f01001bf:	c3                   	ret    

f01001c0 <serial_proc_data>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001c0:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01001c5:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01001c6:	a8 01                	test   $0x1,%al
f01001c8:	74 0a                	je     f01001d4 <serial_proc_data+0x14>
f01001ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01001cf:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01001d0:	0f b6 c0             	movzbl %al,%eax
f01001d3:	c3                   	ret    
		return -1;
f01001d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01001d9:	c3                   	ret    

f01001da <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01001da:	55                   	push   %ebp
f01001db:	89 e5                	mov    %esp,%ebp
f01001dd:	57                   	push   %edi
f01001de:	56                   	push   %esi
f01001df:	53                   	push   %ebx
f01001e0:	83 ec 1c             	sub    $0x1c,%esp
f01001e3:	e8 6a 05 00 00       	call   f0100752 <__x86.get_pc_thunk.si>
f01001e8:	81 c6 20 11 01 00    	add    $0x11120,%esi
f01001ee:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01001f0:	8d 1d 98 1d 00 00    	lea    0x1d98,%ebx
f01001f6:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01001f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01001fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	while ((c = (*proc)()) != -1) {
f01001ff:	eb 25                	jmp    f0100226 <cons_intr+0x4c>
		cons.buf[cons.wpos++] = c;
f0100201:	8b 8c 1e 04 02 00 00 	mov    0x204(%esi,%ebx,1),%ecx
f0100208:	8d 51 01             	lea    0x1(%ecx),%edx
f010020b:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010020e:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f0100211:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100217:	b8 00 00 00 00       	mov    $0x0,%eax
f010021c:	0f 44 d0             	cmove  %eax,%edx
f010021f:	89 94 1e 04 02 00 00 	mov    %edx,0x204(%esi,%ebx,1)
	while ((c = (*proc)()) != -1) {
f0100226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100229:	ff d0                	call   *%eax
f010022b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010022e:	74 06                	je     f0100236 <cons_intr+0x5c>
		if (c == 0)
f0100230:	85 c0                	test   %eax,%eax
f0100232:	75 cd                	jne    f0100201 <cons_intr+0x27>
f0100234:	eb f0                	jmp    f0100226 <cons_intr+0x4c>
	}
}
f0100236:	83 c4 1c             	add    $0x1c,%esp
f0100239:	5b                   	pop    %ebx
f010023a:	5e                   	pop    %esi
f010023b:	5f                   	pop    %edi
f010023c:	5d                   	pop    %ebp
f010023d:	c3                   	ret    

f010023e <kbd_proc_data>:
{
f010023e:	55                   	push   %ebp
f010023f:	89 e5                	mov    %esp,%ebp
f0100241:	56                   	push   %esi
f0100242:	53                   	push   %ebx
f0100243:	e8 74 ff ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100248:	81 c3 c0 10 01 00    	add    $0x110c0,%ebx
f010024e:	ba 64 00 00 00       	mov    $0x64,%edx
f0100253:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100254:	a8 01                	test   $0x1,%al
f0100256:	0f 84 f7 00 00 00    	je     f0100353 <kbd_proc_data+0x115>
	if (stat & KBS_TERR)
f010025c:	a8 20                	test   $0x20,%al
f010025e:	0f 85 f6 00 00 00    	jne    f010035a <kbd_proc_data+0x11c>
f0100264:	ba 60 00 00 00       	mov    $0x60,%edx
f0100269:	ec                   	in     (%dx),%al
f010026a:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f010026c:	3c e0                	cmp    $0xe0,%al
f010026e:	74 64                	je     f01002d4 <kbd_proc_data+0x96>
	} else if (data & 0x80) {
f0100270:	84 c0                	test   %al,%al
f0100272:	78 75                	js     f01002e9 <kbd_proc_data+0xab>
	} else if (shift & E0ESC) {
f0100274:	8b 8b 78 1d 00 00    	mov    0x1d78(%ebx),%ecx
f010027a:	f6 c1 40             	test   $0x40,%cl
f010027d:	74 0e                	je     f010028d <kbd_proc_data+0x4f>
		data |= 0x80;
f010027f:	83 c8 80             	or     $0xffffff80,%eax
f0100282:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100284:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100287:	89 8b 78 1d 00 00    	mov    %ecx,0x1d78(%ebx)
	shift |= shiftcode[data];
f010028d:	0f b6 d2             	movzbl %dl,%edx
f0100290:	0f b6 84 13 f8 09 ff 	movzbl -0xf608(%ebx,%edx,1),%eax
f0100297:	ff 
f0100298:	0b 83 78 1d 00 00    	or     0x1d78(%ebx),%eax
	shift ^= togglecode[data];
f010029e:	0f b6 8c 13 f8 08 ff 	movzbl -0xf708(%ebx,%edx,1),%ecx
f01002a5:	ff 
f01002a6:	31 c8                	xor    %ecx,%eax
f01002a8:	89 83 78 1d 00 00    	mov    %eax,0x1d78(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f01002ae:	89 c1                	mov    %eax,%ecx
f01002b0:	83 e1 03             	and    $0x3,%ecx
f01002b3:	8b 8c 8b f8 1c 00 00 	mov    0x1cf8(%ebx,%ecx,4),%ecx
f01002ba:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01002be:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f01002c1:	a8 08                	test   $0x8,%al
f01002c3:	74 61                	je     f0100326 <kbd_proc_data+0xe8>
		if ('a' <= c && c <= 'z')
f01002c5:	89 f2                	mov    %esi,%edx
f01002c7:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f01002ca:	83 f9 19             	cmp    $0x19,%ecx
f01002cd:	77 4b                	ja     f010031a <kbd_proc_data+0xdc>
			c += 'A' - 'a';
f01002cf:	83 ee 20             	sub    $0x20,%esi
f01002d2:	eb 0c                	jmp    f01002e0 <kbd_proc_data+0xa2>
		shift |= E0ESC;
f01002d4:	83 8b 78 1d 00 00 40 	orl    $0x40,0x1d78(%ebx)
		return 0;
f01002db:	be 00 00 00 00       	mov    $0x0,%esi
}
f01002e0:	89 f0                	mov    %esi,%eax
f01002e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01002e5:	5b                   	pop    %ebx
f01002e6:	5e                   	pop    %esi
f01002e7:	5d                   	pop    %ebp
f01002e8:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01002e9:	8b 8b 78 1d 00 00    	mov    0x1d78(%ebx),%ecx
f01002ef:	83 e0 7f             	and    $0x7f,%eax
f01002f2:	f6 c1 40             	test   $0x40,%cl
f01002f5:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002f8:	0f b6 d2             	movzbl %dl,%edx
f01002fb:	0f b6 84 13 f8 09 ff 	movzbl -0xf608(%ebx,%edx,1),%eax
f0100302:	ff 
f0100303:	83 c8 40             	or     $0x40,%eax
f0100306:	0f b6 c0             	movzbl %al,%eax
f0100309:	f7 d0                	not    %eax
f010030b:	21 c8                	and    %ecx,%eax
f010030d:	89 83 78 1d 00 00    	mov    %eax,0x1d78(%ebx)
		return 0;
f0100313:	be 00 00 00 00       	mov    $0x0,%esi
f0100318:	eb c6                	jmp    f01002e0 <kbd_proc_data+0xa2>
		else if ('A' <= c && c <= 'Z')
f010031a:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f010031d:	8d 4e 20             	lea    0x20(%esi),%ecx
f0100320:	83 fa 1a             	cmp    $0x1a,%edx
f0100323:	0f 42 f1             	cmovb  %ecx,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100326:	f7 d0                	not    %eax
f0100328:	a8 06                	test   $0x6,%al
f010032a:	75 b4                	jne    f01002e0 <kbd_proc_data+0xa2>
f010032c:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f0100332:	75 ac                	jne    f01002e0 <kbd_proc_data+0xa2>
		cprintf("Rebooting!\n");
f0100334:	83 ec 0c             	sub    $0xc,%esp
f0100337:	8d 83 bc 08 ff ff    	lea    -0xf744(%ebx),%eax
f010033d:	50                   	push   %eax
f010033e:	e8 a9 07 00 00       	call   f0100aec <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100343:	b8 03 00 00 00       	mov    $0x3,%eax
f0100348:	ba 92 00 00 00       	mov    $0x92,%edx
f010034d:	ee                   	out    %al,(%dx)
}
f010034e:	83 c4 10             	add    $0x10,%esp
f0100351:	eb 8d                	jmp    f01002e0 <kbd_proc_data+0xa2>
		return -1;
f0100353:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100358:	eb 86                	jmp    f01002e0 <kbd_proc_data+0xa2>
		return -1;
f010035a:	be ff ff ff ff       	mov    $0xffffffff,%esi
f010035f:	e9 7c ff ff ff       	jmp    f01002e0 <kbd_proc_data+0xa2>

f0100364 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100364:	55                   	push   %ebp
f0100365:	89 e5                	mov    %esp,%ebp
f0100367:	57                   	push   %edi
f0100368:	56                   	push   %esi
f0100369:	53                   	push   %ebx
f010036a:	83 ec 1c             	sub    $0x1c,%esp
f010036d:	e8 4a fe ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100372:	81 c3 96 0f 01 00    	add    $0x10f96,%ebx
f0100378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
f010037b:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100380:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100385:	b9 84 00 00 00       	mov    $0x84,%ecx
f010038a:	89 fa                	mov    %edi,%edx
f010038c:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010038d:	a8 20                	test   $0x20,%al
f010038f:	75 13                	jne    f01003a4 <cons_putc+0x40>
f0100391:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100397:	7f 0b                	jg     f01003a4 <cons_putc+0x40>
f0100399:	89 ca                	mov    %ecx,%edx
f010039b:	ec                   	in     (%dx),%al
f010039c:	ec                   	in     (%dx),%al
f010039d:	ec                   	in     (%dx),%al
f010039e:	ec                   	in     (%dx),%al
	     i++)
f010039f:	83 c6 01             	add    $0x1,%esi
f01003a2:	eb e6                	jmp    f010038a <cons_putc+0x26>
	outb(COM1 + COM_TX, c);
f01003a4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f01003a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003b0:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003b1:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003b6:	bf 79 03 00 00       	mov    $0x379,%edi
f01003bb:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003c0:	89 fa                	mov    %edi,%edx
f01003c2:	ec                   	in     (%dx),%al
f01003c3:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01003c9:	7f 0f                	jg     f01003da <cons_putc+0x76>
f01003cb:	84 c0                	test   %al,%al
f01003cd:	78 0b                	js     f01003da <cons_putc+0x76>
f01003cf:	89 ca                	mov    %ecx,%edx
f01003d1:	ec                   	in     (%dx),%al
f01003d2:	ec                   	in     (%dx),%al
f01003d3:	ec                   	in     (%dx),%al
f01003d4:	ec                   	in     (%dx),%al
f01003d5:	83 c6 01             	add    $0x1,%esi
f01003d8:	eb e6                	jmp    f01003c0 <cons_putc+0x5c>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003da:	ba 78 03 00 00       	mov    $0x378,%edx
f01003df:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f01003e3:	ee                   	out    %al,(%dx)
f01003e4:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01003e9:	b8 0d 00 00 00       	mov    $0xd,%eax
f01003ee:	ee                   	out    %al,(%dx)
f01003ef:	b8 08 00 00 00       	mov    $0x8,%eax
f01003f4:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f01003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01003f8:	89 f8                	mov    %edi,%eax
f01003fa:	80 cc 07             	or     $0x7,%ah
f01003fd:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100403:	0f 45 c7             	cmovne %edi,%eax
f0100406:	89 c7                	mov    %eax,%edi
f0100408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
f010040b:	0f b6 c0             	movzbl %al,%eax
f010040e:	89 f9                	mov    %edi,%ecx
f0100410:	80 f9 0a             	cmp    $0xa,%cl
f0100413:	0f 84 e4 00 00 00    	je     f01004fd <cons_putc+0x199>
f0100419:	83 f8 0a             	cmp    $0xa,%eax
f010041c:	7f 46                	jg     f0100464 <cons_putc+0x100>
f010041e:	83 f8 08             	cmp    $0x8,%eax
f0100421:	0f 84 a8 00 00 00    	je     f01004cf <cons_putc+0x16b>
f0100427:	83 f8 09             	cmp    $0x9,%eax
f010042a:	0f 85 da 00 00 00    	jne    f010050a <cons_putc+0x1a6>
		cons_putc(' ');
f0100430:	b8 20 00 00 00       	mov    $0x20,%eax
f0100435:	e8 2a ff ff ff       	call   f0100364 <cons_putc>
		cons_putc(' ');
f010043a:	b8 20 00 00 00       	mov    $0x20,%eax
f010043f:	e8 20 ff ff ff       	call   f0100364 <cons_putc>
		cons_putc(' ');
f0100444:	b8 20 00 00 00       	mov    $0x20,%eax
f0100449:	e8 16 ff ff ff       	call   f0100364 <cons_putc>
		cons_putc(' ');
f010044e:	b8 20 00 00 00       	mov    $0x20,%eax
f0100453:	e8 0c ff ff ff       	call   f0100364 <cons_putc>
		cons_putc(' ');
f0100458:	b8 20 00 00 00       	mov    $0x20,%eax
f010045d:	e8 02 ff ff ff       	call   f0100364 <cons_putc>
		break;
f0100462:	eb 26                	jmp    f010048a <cons_putc+0x126>
	switch (c & 0xff) {
f0100464:	83 f8 0d             	cmp    $0xd,%eax
f0100467:	0f 85 9d 00 00 00    	jne    f010050a <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
f010046d:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f0100474:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010047a:	c1 e8 16             	shr    $0x16,%eax
f010047d:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100480:	c1 e0 04             	shl    $0x4,%eax
f0100483:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
	if (crt_pos >= CRT_SIZE) {
f010048a:	66 81 bb a0 1f 00 00 	cmpw   $0x7cf,0x1fa0(%ebx)
f0100491:	cf 07 
f0100493:	0f 87 98 00 00 00    	ja     f0100531 <cons_putc+0x1cd>
	outb(addr_6845, 14);
f0100499:	8b 8b a8 1f 00 00    	mov    0x1fa8(%ebx),%ecx
f010049f:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004a4:	89 ca                	mov    %ecx,%edx
f01004a6:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004a7:	0f b7 9b a0 1f 00 00 	movzwl 0x1fa0(%ebx),%ebx
f01004ae:	8d 71 01             	lea    0x1(%ecx),%esi
f01004b1:	89 d8                	mov    %ebx,%eax
f01004b3:	66 c1 e8 08          	shr    $0x8,%ax
f01004b7:	89 f2                	mov    %esi,%edx
f01004b9:	ee                   	out    %al,(%dx)
f01004ba:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004bf:	89 ca                	mov    %ecx,%edx
f01004c1:	ee                   	out    %al,(%dx)
f01004c2:	89 d8                	mov    %ebx,%eax
f01004c4:	89 f2                	mov    %esi,%edx
f01004c6:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004ca:	5b                   	pop    %ebx
f01004cb:	5e                   	pop    %esi
f01004cc:	5f                   	pop    %edi
f01004cd:	5d                   	pop    %ebp
f01004ce:	c3                   	ret    
		if (crt_pos > 0) {
f01004cf:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f01004d6:	66 85 c0             	test   %ax,%ax
f01004d9:	74 be                	je     f0100499 <cons_putc+0x135>
			crt_pos--;
f01004db:	83 e8 01             	sub    $0x1,%eax
f01004de:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01004e5:	0f b7 c0             	movzwl %ax,%eax
f01004e8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f01004ec:	b2 00                	mov    $0x0,%dl
f01004ee:	83 ca 20             	or     $0x20,%edx
f01004f1:	8b 8b a4 1f 00 00    	mov    0x1fa4(%ebx),%ecx
f01004f7:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f01004fb:	eb 8d                	jmp    f010048a <cons_putc+0x126>
		crt_pos += CRT_COLS;
f01004fd:	66 83 83 a0 1f 00 00 	addw   $0x50,0x1fa0(%ebx)
f0100504:	50 
f0100505:	e9 63 ff ff ff       	jmp    f010046d <cons_putc+0x109>
		crt_buf[crt_pos++] = c;		/* write the character */
f010050a:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f0100511:	8d 50 01             	lea    0x1(%eax),%edx
f0100514:	66 89 93 a0 1f 00 00 	mov    %dx,0x1fa0(%ebx)
f010051b:	0f b7 c0             	movzwl %ax,%eax
f010051e:	8b 93 a4 1f 00 00    	mov    0x1fa4(%ebx),%edx
f0100524:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f0100528:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f010052c:	e9 59 ff ff ff       	jmp    f010048a <cons_putc+0x126>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100531:	8b 83 a4 1f 00 00    	mov    0x1fa4(%ebx),%eax
f0100537:	83 ec 04             	sub    $0x4,%esp
f010053a:	68 00 0f 00 00       	push   $0xf00
f010053f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100545:	52                   	push   %edx
f0100546:	50                   	push   %eax
f0100547:	e8 eb 11 00 00       	call   f0101737 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010054c:	8b 93 a4 1f 00 00    	mov    0x1fa4(%ebx),%edx
f0100552:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100558:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010055e:	83 c4 10             	add    $0x10,%esp
f0100561:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100566:	83 c0 02             	add    $0x2,%eax
f0100569:	39 d0                	cmp    %edx,%eax
f010056b:	75 f4                	jne    f0100561 <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f010056d:	66 83 ab a0 1f 00 00 	subw   $0x50,0x1fa0(%ebx)
f0100574:	50 
f0100575:	e9 1f ff ff ff       	jmp    f0100499 <cons_putc+0x135>

f010057a <serial_intr>:
{
f010057a:	e8 cf 01 00 00       	call   f010074e <__x86.get_pc_thunk.ax>
f010057f:	05 89 0d 01 00       	add    $0x10d89,%eax
	if (serial_exists)
f0100584:	80 b8 ac 1f 00 00 00 	cmpb   $0x0,0x1fac(%eax)
f010058b:	75 01                	jne    f010058e <serial_intr+0x14>
f010058d:	c3                   	ret    
{
f010058e:	55                   	push   %ebp
f010058f:	89 e5                	mov    %esp,%ebp
f0100591:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100594:	8d 80 b8 ee fe ff    	lea    -0x11148(%eax),%eax
f010059a:	e8 3b fc ff ff       	call   f01001da <cons_intr>
}
f010059f:	c9                   	leave  
f01005a0:	c3                   	ret    

f01005a1 <kbd_intr>:
{
f01005a1:	55                   	push   %ebp
f01005a2:	89 e5                	mov    %esp,%ebp
f01005a4:	83 ec 08             	sub    $0x8,%esp
f01005a7:	e8 a2 01 00 00       	call   f010074e <__x86.get_pc_thunk.ax>
f01005ac:	05 5c 0d 01 00       	add    $0x10d5c,%eax
	cons_intr(kbd_proc_data);
f01005b1:	8d 80 36 ef fe ff    	lea    -0x110ca(%eax),%eax
f01005b7:	e8 1e fc ff ff       	call   f01001da <cons_intr>
}
f01005bc:	c9                   	leave  
f01005bd:	c3                   	ret    

f01005be <cons_getc>:
{
f01005be:	55                   	push   %ebp
f01005bf:	89 e5                	mov    %esp,%ebp
f01005c1:	53                   	push   %ebx
f01005c2:	83 ec 04             	sub    $0x4,%esp
f01005c5:	e8 f2 fb ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f01005ca:	81 c3 3e 0d 01 00    	add    $0x10d3e,%ebx
	serial_intr();
f01005d0:	e8 a5 ff ff ff       	call   f010057a <serial_intr>
	kbd_intr();
f01005d5:	e8 c7 ff ff ff       	call   f01005a1 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01005da:	8b 83 98 1f 00 00    	mov    0x1f98(%ebx),%eax
	return 0;
f01005e0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f01005e5:	3b 83 9c 1f 00 00    	cmp    0x1f9c(%ebx),%eax
f01005eb:	74 1e                	je     f010060b <cons_getc+0x4d>
		c = cons.buf[cons.rpos++];
f01005ed:	8d 48 01             	lea    0x1(%eax),%ecx
f01005f0:	0f b6 94 03 98 1d 00 	movzbl 0x1d98(%ebx,%eax,1),%edx
f01005f7:	00 
			cons.rpos = 0;
f01005f8:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f01005fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0100602:	0f 45 c1             	cmovne %ecx,%eax
f0100605:	89 83 98 1f 00 00    	mov    %eax,0x1f98(%ebx)
}
f010060b:	89 d0                	mov    %edx,%eax
f010060d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100610:	c9                   	leave  
f0100611:	c3                   	ret    

f0100612 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100612:	55                   	push   %ebp
f0100613:	89 e5                	mov    %esp,%ebp
f0100615:	57                   	push   %edi
f0100616:	56                   	push   %esi
f0100617:	53                   	push   %ebx
f0100618:	83 ec 1c             	sub    $0x1c,%esp
f010061b:	e8 9c fb ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100620:	81 c3 e8 0c 01 00    	add    $0x10ce8,%ebx
	was = *cp;
f0100626:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010062d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100634:	5a a5 
	if (*cp != 0xA55A) {
f0100636:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010063d:	b9 b4 03 00 00       	mov    $0x3b4,%ecx
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100642:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
	if (*cp != 0xA55A) {
f0100647:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010064b:	0f 84 ac 00 00 00    	je     f01006fd <cons_init+0xeb>
		addr_6845 = MONO_BASE;
f0100651:	89 8b a8 1f 00 00    	mov    %ecx,0x1fa8(%ebx)
f0100657:	b8 0e 00 00 00       	mov    $0xe,%eax
f010065c:	89 ca                	mov    %ecx,%edx
f010065e:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010065f:	8d 71 01             	lea    0x1(%ecx),%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100662:	89 f2                	mov    %esi,%edx
f0100664:	ec                   	in     (%dx),%al
f0100665:	0f b6 c0             	movzbl %al,%eax
f0100668:	c1 e0 08             	shl    $0x8,%eax
f010066b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010066e:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100673:	89 ca                	mov    %ecx,%edx
f0100675:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100676:	89 f2                	mov    %esi,%edx
f0100678:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100679:	89 bb a4 1f 00 00    	mov    %edi,0x1fa4(%ebx)
	pos |= inb(addr_6845 + 1);
f010067f:	0f b6 c0             	movzbl %al,%eax
f0100682:	0b 45 e4             	or     -0x1c(%ebp),%eax
	crt_pos = pos;
f0100685:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010068c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100691:	89 c8                	mov    %ecx,%eax
f0100693:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100698:	ee                   	out    %al,(%dx)
f0100699:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010069e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006a3:	89 fa                	mov    %edi,%edx
f01006a5:	ee                   	out    %al,(%dx)
f01006a6:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006b0:	ee                   	out    %al,(%dx)
f01006b1:	be f9 03 00 00       	mov    $0x3f9,%esi
f01006b6:	89 c8                	mov    %ecx,%eax
f01006b8:	89 f2                	mov    %esi,%edx
f01006ba:	ee                   	out    %al,(%dx)
f01006bb:	b8 03 00 00 00       	mov    $0x3,%eax
f01006c0:	89 fa                	mov    %edi,%edx
f01006c2:	ee                   	out    %al,(%dx)
f01006c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01006c8:	89 c8                	mov    %ecx,%eax
f01006ca:	ee                   	out    %al,(%dx)
f01006cb:	b8 01 00 00 00       	mov    $0x1,%eax
f01006d0:	89 f2                	mov    %esi,%edx
f01006d2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006d8:	ec                   	in     (%dx),%al
f01006d9:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01006db:	3c ff                	cmp    $0xff,%al
f01006dd:	0f 95 83 ac 1f 00 00 	setne  0x1fac(%ebx)
f01006e4:	ba fa 03 00 00       	mov    $0x3fa,%edx
f01006e9:	ec                   	in     (%dx),%al
f01006ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006ef:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01006f0:	80 f9 ff             	cmp    $0xff,%cl
f01006f3:	74 1e                	je     f0100713 <cons_init+0x101>
		cprintf("Serial port does not exist!\n");
}
f01006f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01006f8:	5b                   	pop    %ebx
f01006f9:	5e                   	pop    %esi
f01006fa:	5f                   	pop    %edi
f01006fb:	5d                   	pop    %ebp
f01006fc:	c3                   	ret    
		*cp = was;
f01006fd:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f0100704:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100709:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
f010070e:	e9 3e ff ff ff       	jmp    f0100651 <cons_init+0x3f>
		cprintf("Serial port does not exist!\n");
f0100713:	83 ec 0c             	sub    $0xc,%esp
f0100716:	8d 83 c8 08 ff ff    	lea    -0xf738(%ebx),%eax
f010071c:	50                   	push   %eax
f010071d:	e8 ca 03 00 00       	call   f0100aec <cprintf>
f0100722:	83 c4 10             	add    $0x10,%esp
}
f0100725:	eb ce                	jmp    f01006f5 <cons_init+0xe3>

f0100727 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100727:	55                   	push   %ebp
f0100728:	89 e5                	mov    %esp,%ebp
f010072a:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010072d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100730:	e8 2f fc ff ff       	call   f0100364 <cons_putc>
}
f0100735:	c9                   	leave  
f0100736:	c3                   	ret    

f0100737 <getchar>:

int
getchar(void)
{
f0100737:	55                   	push   %ebp
f0100738:	89 e5                	mov    %esp,%ebp
f010073a:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010073d:	e8 7c fe ff ff       	call   f01005be <cons_getc>
f0100742:	85 c0                	test   %eax,%eax
f0100744:	74 f7                	je     f010073d <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100746:	c9                   	leave  
f0100747:	c3                   	ret    

f0100748 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100748:	b8 01 00 00 00       	mov    $0x1,%eax
f010074d:	c3                   	ret    

f010074e <__x86.get_pc_thunk.ax>:
f010074e:	8b 04 24             	mov    (%esp),%eax
f0100751:	c3                   	ret    

f0100752 <__x86.get_pc_thunk.si>:
f0100752:	8b 34 24             	mov    (%esp),%esi
f0100755:	c3                   	ret    

f0100756 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100756:	55                   	push   %ebp
f0100757:	89 e5                	mov    %esp,%ebp
f0100759:	56                   	push   %esi
f010075a:	53                   	push   %ebx
f010075b:	e8 5c fa ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100760:	81 c3 a8 0b 01 00    	add    $0x10ba8,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100766:	83 ec 04             	sub    $0x4,%esp
f0100769:	8d 83 f8 0a ff ff    	lea    -0xf508(%ebx),%eax
f010076f:	50                   	push   %eax
f0100770:	8d 83 16 0b ff ff    	lea    -0xf4ea(%ebx),%eax
f0100776:	50                   	push   %eax
f0100777:	8d b3 1b 0b ff ff    	lea    -0xf4e5(%ebx),%esi
f010077d:	56                   	push   %esi
f010077e:	e8 69 03 00 00       	call   f0100aec <cprintf>
f0100783:	83 c4 0c             	add    $0xc,%esp
f0100786:	8d 83 b8 0b ff ff    	lea    -0xf448(%ebx),%eax
f010078c:	50                   	push   %eax
f010078d:	8d 83 24 0b ff ff    	lea    -0xf4dc(%ebx),%eax
f0100793:	50                   	push   %eax
f0100794:	56                   	push   %esi
f0100795:	e8 52 03 00 00       	call   f0100aec <cprintf>
f010079a:	83 c4 0c             	add    $0xc,%esp
f010079d:	8d 83 e0 0b ff ff    	lea    -0xf420(%ebx),%eax
f01007a3:	50                   	push   %eax
f01007a4:	8d 83 2d 0b ff ff    	lea    -0xf4d3(%ebx),%eax
f01007aa:	50                   	push   %eax
f01007ab:	56                   	push   %esi
f01007ac:	e8 3b 03 00 00       	call   f0100aec <cprintf>
	return 0;
}
f01007b1:	b8 00 00 00 00       	mov    $0x0,%eax
f01007b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01007b9:	5b                   	pop    %ebx
f01007ba:	5e                   	pop    %esi
f01007bb:	5d                   	pop    %ebp
f01007bc:	c3                   	ret    

f01007bd <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007bd:	55                   	push   %ebp
f01007be:	89 e5                	mov    %esp,%ebp
f01007c0:	57                   	push   %edi
f01007c1:	56                   	push   %esi
f01007c2:	53                   	push   %ebx
f01007c3:	83 ec 18             	sub    $0x18,%esp
f01007c6:	e8 f1 f9 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f01007cb:	81 c3 3d 0b 01 00    	add    $0x10b3d,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007d1:	8d 83 37 0b ff ff    	lea    -0xf4c9(%ebx),%eax
f01007d7:	50                   	push   %eax
f01007d8:	e8 0f 03 00 00       	call   f0100aec <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01007dd:	83 c4 08             	add    $0x8,%esp
f01007e0:	ff b3 f8 ff ff ff    	push   -0x8(%ebx)
f01007e6:	8d 83 14 0c ff ff    	lea    -0xf3ec(%ebx),%eax
f01007ec:	50                   	push   %eax
f01007ed:	e8 fa 02 00 00       	call   f0100aec <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007f2:	83 c4 0c             	add    $0xc,%esp
f01007f5:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f01007fb:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f0100801:	50                   	push   %eax
f0100802:	57                   	push   %edi
f0100803:	8d 83 3c 0c ff ff    	lea    -0xf3c4(%ebx),%eax
f0100809:	50                   	push   %eax
f010080a:	e8 dd 02 00 00       	call   f0100aec <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010080f:	83 c4 0c             	add    $0xc,%esp
f0100812:	c7 c0 21 1b 10 f0    	mov    $0xf0101b21,%eax
f0100818:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010081e:	52                   	push   %edx
f010081f:	50                   	push   %eax
f0100820:	8d 83 60 0c ff ff    	lea    -0xf3a0(%ebx),%eax
f0100826:	50                   	push   %eax
f0100827:	e8 c0 02 00 00       	call   f0100aec <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010082c:	83 c4 0c             	add    $0xc,%esp
f010082f:	c7 c0 60 30 11 f0    	mov    $0xf0113060,%eax
f0100835:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010083b:	52                   	push   %edx
f010083c:	50                   	push   %eax
f010083d:	8d 83 84 0c ff ff    	lea    -0xf37c(%ebx),%eax
f0100843:	50                   	push   %eax
f0100844:	e8 a3 02 00 00       	call   f0100aec <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100849:	83 c4 0c             	add    $0xc,%esp
f010084c:	c7 c6 c0 36 11 f0    	mov    $0xf01136c0,%esi
f0100852:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0100858:	50                   	push   %eax
f0100859:	56                   	push   %esi
f010085a:	8d 83 a8 0c ff ff    	lea    -0xf358(%ebx),%eax
f0100860:	50                   	push   %eax
f0100861:	e8 86 02 00 00       	call   f0100aec <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100866:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100869:	29 fe                	sub    %edi,%esi
f010086b:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100871:	c1 fe 0a             	sar    $0xa,%esi
f0100874:	56                   	push   %esi
f0100875:	8d 83 cc 0c ff ff    	lea    -0xf334(%ebx),%eax
f010087b:	50                   	push   %eax
f010087c:	e8 6b 02 00 00       	call   f0100aec <cprintf>
	return 0;
}
f0100881:	b8 00 00 00 00       	mov    $0x0,%eax
f0100886:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100889:	5b                   	pop    %ebx
f010088a:	5e                   	pop    %esi
f010088b:	5f                   	pop    %edi
f010088c:	5d                   	pop    %ebp
f010088d:	c3                   	ret    

f010088e <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010088e:	55                   	push   %ebp
f010088f:	89 e5                	mov    %esp,%ebp
f0100891:	57                   	push   %edi
f0100892:	56                   	push   %esi
f0100893:	53                   	push   %ebx
f0100894:	83 ec 48             	sub    $0x48,%esp
f0100897:	e8 20 f9 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f010089c:	81 c3 6c 0a 01 00    	add    $0x10a6c,%ebx

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008a2:	89 ee                	mov    %ebp,%esi
	// Your code here.
	uint32_t *ebp = (uint32_t *)read_ebp();
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");
f01008a4:	8d 83 50 0b ff ff    	lea    -0xf4b0(%ebx),%eax
f01008aa:	50                   	push   %eax
f01008ab:	e8 3c 02 00 00       	call   f0100aec <cprintf>
	while(ebp != 0) {
f01008b0:	83 c4 10             	add    $0x10,%esp
		debuginfo_eip(*(ebp+1), &info);
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, \
f01008b3:	8d bb f8 0c ff ff    	lea    -0xf308(%ebx),%edi
				*(ebp + 1), *(ebp + 2), *(ebp + 3), *(ebp + 4), *(ebp + 5), *(ebp + 6));
		
		cprintf("         %s:%d:  %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, \
f01008b9:	8d 83 62 0b ff ff    	lea    -0xf49e(%ebx),%eax
f01008bf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	while(ebp != 0) {
f01008c2:	eb 4b                	jmp    f010090f <mon_backtrace+0x81>
		debuginfo_eip(*(ebp+1), &info);
f01008c4:	83 ec 08             	sub    $0x8,%esp
f01008c7:	8d 45 d0             	lea    -0x30(%ebp),%eax
f01008ca:	50                   	push   %eax
f01008cb:	ff 76 04             	push   0x4(%esi)
f01008ce:	e8 22 03 00 00       	call   f0100bf5 <debuginfo_eip>
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, \
f01008d3:	ff 76 18             	push   0x18(%esi)
f01008d6:	ff 76 14             	push   0x14(%esi)
f01008d9:	ff 76 10             	push   0x10(%esi)
f01008dc:	ff 76 0c             	push   0xc(%esi)
f01008df:	ff 76 08             	push   0x8(%esi)
f01008e2:	ff 76 04             	push   0x4(%esi)
f01008e5:	56                   	push   %esi
f01008e6:	57                   	push   %edi
f01008e7:	e8 00 02 00 00       	call   f0100aec <cprintf>
		cprintf("         %s:%d:  %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, \
f01008ec:	83 c4 28             	add    $0x28,%esp
f01008ef:	8b 46 04             	mov    0x4(%esi),%eax
f01008f2:	2b 45 e0             	sub    -0x20(%ebp),%eax
f01008f5:	50                   	push   %eax
f01008f6:	ff 75 d8             	push   -0x28(%ebp)
f01008f9:	ff 75 dc             	push   -0x24(%ebp)
f01008fc:	ff 75 d4             	push   -0x2c(%ebp)
f01008ff:	ff 75 d0             	push   -0x30(%ebp)
f0100902:	ff 75 c4             	push   -0x3c(%ebp)
f0100905:	e8 e2 01 00 00       	call   f0100aec <cprintf>
					info.eip_fn_name, *(ebp+1) - info.eip_fn_addr);
		ebp = (uint32_t *)(*ebp);
f010090a:	8b 36                	mov    (%esi),%esi
f010090c:	83 c4 20             	add    $0x20,%esp
	while(ebp != 0) {
f010090f:	85 f6                	test   %esi,%esi
f0100911:	75 b1                	jne    f01008c4 <mon_backtrace+0x36>
	}
	return 0;
}
f0100913:	b8 00 00 00 00       	mov    $0x0,%eax
f0100918:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010091b:	5b                   	pop    %ebx
f010091c:	5e                   	pop    %esi
f010091d:	5f                   	pop    %edi
f010091e:	5d                   	pop    %ebp
f010091f:	c3                   	ret    

f0100920 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100920:	55                   	push   %ebp
f0100921:	89 e5                	mov    %esp,%ebp
f0100923:	57                   	push   %edi
f0100924:	56                   	push   %esi
f0100925:	53                   	push   %ebx
f0100926:	83 ec 64             	sub    $0x64,%esp
f0100929:	e8 8e f8 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f010092e:	81 c3 da 09 01 00    	add    $0x109da,%ebx
	char *buf;

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100934:	68 ac 1a 00 00       	push   $0x1aac
f0100939:	8d 83 6f 08 ff ff    	lea    -0xf791(%ebx),%eax
f010093f:	50                   	push   %eax
f0100940:	e8 a7 01 00 00       	call   f0100aec <cprintf>
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100945:	8d 83 2c 0d ff ff    	lea    -0xf2d4(%ebx),%eax
f010094b:	89 04 24             	mov    %eax,(%esp)
f010094e:	e8 99 01 00 00       	call   f0100aec <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100953:	8d 83 50 0d ff ff    	lea    -0xf2b0(%ebx),%eax
f0100959:	89 04 24             	mov    %eax,(%esp)
f010095c:	e8 8b 01 00 00       	call   f0100aec <cprintf>
f0100961:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f0100964:	8d bb 80 0b ff ff    	lea    -0xf480(%ebx),%edi
f010096a:	eb 4a                	jmp    f01009b6 <monitor+0x96>
f010096c:	83 ec 08             	sub    $0x8,%esp
f010096f:	0f be c0             	movsbl %al,%eax
f0100972:	50                   	push   %eax
f0100973:	57                   	push   %edi
f0100974:	e8 39 0d 00 00       	call   f01016b2 <strchr>
f0100979:	83 c4 10             	add    $0x10,%esp
f010097c:	85 c0                	test   %eax,%eax
f010097e:	74 08                	je     f0100988 <monitor+0x68>
			*buf++ = 0;
f0100980:	c6 06 00             	movb   $0x0,(%esi)
f0100983:	8d 76 01             	lea    0x1(%esi),%esi
f0100986:	eb 76                	jmp    f01009fe <monitor+0xde>
		if (*buf == 0)
f0100988:	80 3e 00             	cmpb   $0x0,(%esi)
f010098b:	74 7c                	je     f0100a09 <monitor+0xe9>
		if (argc == MAXARGS-1) {
f010098d:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
f0100991:	74 0f                	je     f01009a2 <monitor+0x82>
		argv[argc++] = buf;
f0100993:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100996:	8d 48 01             	lea    0x1(%eax),%ecx
f0100999:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f010099c:	89 74 85 a8          	mov    %esi,-0x58(%ebp,%eax,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f01009a0:	eb 41                	jmp    f01009e3 <monitor+0xc3>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01009a2:	83 ec 08             	sub    $0x8,%esp
f01009a5:	6a 10                	push   $0x10
f01009a7:	8d 83 85 0b ff ff    	lea    -0xf47b(%ebx),%eax
f01009ad:	50                   	push   %eax
f01009ae:	e8 39 01 00 00       	call   f0100aec <cprintf>
			return 0;
f01009b3:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f01009b6:	8d 83 7c 0b ff ff    	lea    -0xf484(%ebx),%eax
f01009bc:	89 c6                	mov    %eax,%esi
f01009be:	83 ec 0c             	sub    $0xc,%esp
f01009c1:	56                   	push   %esi
f01009c2:	e8 9a 0a 00 00       	call   f0101461 <readline>
		if (buf != NULL)
f01009c7:	83 c4 10             	add    $0x10,%esp
f01009ca:	85 c0                	test   %eax,%eax
f01009cc:	74 f0                	je     f01009be <monitor+0x9e>
	argv[argc] = 0;
f01009ce:	89 c6                	mov    %eax,%esi
f01009d0:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f01009d7:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01009de:	eb 1e                	jmp    f01009fe <monitor+0xde>
			buf++;
f01009e0:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01009e3:	0f b6 06             	movzbl (%esi),%eax
f01009e6:	84 c0                	test   %al,%al
f01009e8:	74 14                	je     f01009fe <monitor+0xde>
f01009ea:	83 ec 08             	sub    $0x8,%esp
f01009ed:	0f be c0             	movsbl %al,%eax
f01009f0:	50                   	push   %eax
f01009f1:	57                   	push   %edi
f01009f2:	e8 bb 0c 00 00       	call   f01016b2 <strchr>
f01009f7:	83 c4 10             	add    $0x10,%esp
f01009fa:	85 c0                	test   %eax,%eax
f01009fc:	74 e2                	je     f01009e0 <monitor+0xc0>
		while (*buf && strchr(WHITESPACE, *buf))
f01009fe:	0f b6 06             	movzbl (%esi),%eax
f0100a01:	84 c0                	test   %al,%al
f0100a03:	0f 85 63 ff ff ff    	jne    f010096c <monitor+0x4c>
	argv[argc] = 0;
f0100a09:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100a0c:	c7 44 85 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%eax,4)
f0100a13:	00 
	if (argc == 0)
f0100a14:	85 c0                	test   %eax,%eax
f0100a16:	74 9e                	je     f01009b6 <monitor+0x96>
f0100a18:	8d b3 18 1d 00 00    	lea    0x1d18(%ebx),%esi
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a1e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a23:	89 7d a0             	mov    %edi,-0x60(%ebp)
f0100a26:	89 c7                	mov    %eax,%edi
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a28:	83 ec 08             	sub    $0x8,%esp
f0100a2b:	ff 36                	push   (%esi)
f0100a2d:	ff 75 a8             	push   -0x58(%ebp)
f0100a30:	e8 1d 0c 00 00       	call   f0101652 <strcmp>
f0100a35:	83 c4 10             	add    $0x10,%esp
f0100a38:	85 c0                	test   %eax,%eax
f0100a3a:	74 28                	je     f0100a64 <monitor+0x144>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a3c:	83 c7 01             	add    $0x1,%edi
f0100a3f:	83 c6 0c             	add    $0xc,%esi
f0100a42:	83 ff 03             	cmp    $0x3,%edi
f0100a45:	75 e1                	jne    f0100a28 <monitor+0x108>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a47:	8b 7d a0             	mov    -0x60(%ebp),%edi
f0100a4a:	83 ec 08             	sub    $0x8,%esp
f0100a4d:	ff 75 a8             	push   -0x58(%ebp)
f0100a50:	8d 83 a2 0b ff ff    	lea    -0xf45e(%ebx),%eax
f0100a56:	50                   	push   %eax
f0100a57:	e8 90 00 00 00       	call   f0100aec <cprintf>
	return 0;
f0100a5c:	83 c4 10             	add    $0x10,%esp
f0100a5f:	e9 52 ff ff ff       	jmp    f01009b6 <monitor+0x96>
			return commands[i].func(argc, argv, tf);
f0100a64:	89 f8                	mov    %edi,%eax
f0100a66:	8b 7d a0             	mov    -0x60(%ebp),%edi
f0100a69:	83 ec 04             	sub    $0x4,%esp
f0100a6c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100a6f:	ff 75 08             	push   0x8(%ebp)
f0100a72:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a75:	52                   	push   %edx
f0100a76:	ff 75 a4             	push   -0x5c(%ebp)
f0100a79:	ff 94 83 20 1d 00 00 	call   *0x1d20(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a80:	83 c4 10             	add    $0x10,%esp
f0100a83:	85 c0                	test   %eax,%eax
f0100a85:	0f 89 2b ff ff ff    	jns    f01009b6 <monitor+0x96>
				break;
	}
}
f0100a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a8e:	5b                   	pop    %ebx
f0100a8f:	5e                   	pop    %esi
f0100a90:	5f                   	pop    %edi
f0100a91:	5d                   	pop    %ebp
f0100a92:	c3                   	ret    

f0100a93 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100a93:	55                   	push   %ebp
f0100a94:	89 e5                	mov    %esp,%ebp
f0100a96:	53                   	push   %ebx
f0100a97:	83 ec 10             	sub    $0x10,%esp
f0100a9a:	e8 1d f7 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100a9f:	81 c3 69 08 01 00    	add    $0x10869,%ebx
	cputchar(ch);
f0100aa5:	ff 75 08             	push   0x8(%ebp)
f0100aa8:	e8 7a fc ff ff       	call   f0100727 <cputchar>
	*cnt++;
}
f0100aad:	83 c4 10             	add    $0x10,%esp
f0100ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ab3:	c9                   	leave  
f0100ab4:	c3                   	ret    

f0100ab5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0100ab5:	55                   	push   %ebp
f0100ab6:	89 e5                	mov    %esp,%ebp
f0100ab8:	53                   	push   %ebx
f0100ab9:	83 ec 14             	sub    $0x14,%esp
f0100abc:	e8 fb f6 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100ac1:	81 c3 47 08 01 00    	add    $0x10847,%ebx
	int cnt = 0;
f0100ac7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0100ace:	ff 75 0c             	push   0xc(%ebp)
f0100ad1:	ff 75 08             	push   0x8(%ebp)
f0100ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100ad7:	50                   	push   %eax
f0100ad8:	8d 83 8b f7 fe ff    	lea    -0x10875(%ebx),%eax
f0100ade:	50                   	push   %eax
f0100adf:	e8 5c 04 00 00       	call   f0100f40 <vprintfmt>
	return cnt;
}
f0100ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100aea:	c9                   	leave  
f0100aeb:	c3                   	ret    

f0100aec <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100aec:	55                   	push   %ebp
f0100aed:	89 e5                	mov    %esp,%ebp
f0100aef:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0100af2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0100af5:	50                   	push   %eax
f0100af6:	ff 75 08             	push   0x8(%ebp)
f0100af9:	e8 b7 ff ff ff       	call   f0100ab5 <vcprintf>
	va_end(ap);

	return cnt;
}
f0100afe:	c9                   	leave  
f0100aff:	c3                   	ret    

f0100b00 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100b00:	55                   	push   %ebp
f0100b01:	89 e5                	mov    %esp,%ebp
f0100b03:	57                   	push   %edi
f0100b04:	56                   	push   %esi
f0100b05:	53                   	push   %ebx
f0100b06:	83 ec 14             	sub    $0x14,%esp
f0100b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100b0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100b0f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100b12:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100b15:	8b 1a                	mov    (%edx),%ebx
f0100b17:	8b 01                	mov    (%ecx),%eax
f0100b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100b1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0100b23:	eb 2f                	jmp    f0100b54 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0100b25:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0100b28:	39 c3                	cmp    %eax,%ebx
f0100b2a:	7f 4e                	jg     f0100b7a <stab_binsearch+0x7a>
f0100b2c:	0f b6 0a             	movzbl (%edx),%ecx
f0100b2f:	83 ea 0c             	sub    $0xc,%edx
f0100b32:	39 f1                	cmp    %esi,%ecx
f0100b34:	75 ef                	jne    f0100b25 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100b36:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100b39:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100b3c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100b40:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100b43:	73 3a                	jae    f0100b7f <stab_binsearch+0x7f>
			*region_left = m;
f0100b45:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100b48:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0100b4a:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0100b4d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0100b54:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0100b57:	7f 53                	jg     f0100bac <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0100b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100b5c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0100b5f:	89 d0                	mov    %edx,%eax
f0100b61:	c1 e8 1f             	shr    $0x1f,%eax
f0100b64:	01 d0                	add    %edx,%eax
f0100b66:	89 c7                	mov    %eax,%edi
f0100b68:	d1 ff                	sar    %edi
f0100b6a:	83 e0 fe             	and    $0xfffffffe,%eax
f0100b6d:	01 f8                	add    %edi,%eax
f0100b6f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100b72:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0100b76:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0100b78:	eb ae                	jmp    f0100b28 <stab_binsearch+0x28>
			l = true_m + 1;
f0100b7a:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100b7d:	eb d5                	jmp    f0100b54 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0100b7f:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100b82:	76 14                	jbe    f0100b98 <stab_binsearch+0x98>
			*region_right = m - 1;
f0100b84:	83 e8 01             	sub    $0x1,%eax
f0100b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100b8a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100b8d:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0100b8f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100b96:	eb bc                	jmp    f0100b54 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100b98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100b9b:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0100b9d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100ba1:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0100ba3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100baa:	eb a8                	jmp    f0100b54 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0100bac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0100bb0:	75 15                	jne    f0100bc7 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0100bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100bb5:	8b 00                	mov    (%eax),%eax
f0100bb7:	83 e8 01             	sub    $0x1,%eax
f0100bba:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100bbd:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100bbf:	83 c4 14             	add    $0x14,%esp
f0100bc2:	5b                   	pop    %ebx
f0100bc3:	5e                   	pop    %esi
f0100bc4:	5f                   	pop    %edi
f0100bc5:	5d                   	pop    %ebp
f0100bc6:	c3                   	ret    
		for (l = *region_right;
f0100bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bca:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100bcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100bcf:	8b 0f                	mov    (%edi),%ecx
f0100bd1:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100bd4:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0100bd7:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0100bdb:	39 c1                	cmp    %eax,%ecx
f0100bdd:	7d 0f                	jge    f0100bee <stab_binsearch+0xee>
f0100bdf:	0f b6 1a             	movzbl (%edx),%ebx
f0100be2:	83 ea 0c             	sub    $0xc,%edx
f0100be5:	39 f3                	cmp    %esi,%ebx
f0100be7:	74 05                	je     f0100bee <stab_binsearch+0xee>
		     l--)
f0100be9:	83 e8 01             	sub    $0x1,%eax
f0100bec:	eb ed                	jmp    f0100bdb <stab_binsearch+0xdb>
		*region_left = l;
f0100bee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100bf1:	89 07                	mov    %eax,(%edi)
}
f0100bf3:	eb ca                	jmp    f0100bbf <stab_binsearch+0xbf>

f0100bf5 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100bf5:	55                   	push   %ebp
f0100bf6:	89 e5                	mov    %esp,%ebp
f0100bf8:	57                   	push   %edi
f0100bf9:	56                   	push   %esi
f0100bfa:	53                   	push   %ebx
f0100bfb:	83 ec 3c             	sub    $0x3c,%esp
f0100bfe:	e8 b9 f5 ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f0100c03:	81 c3 05 07 01 00    	add    $0x10705,%ebx
f0100c09:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100c0c:	8d 83 75 0d ff ff    	lea    -0xf28b(%ebx),%eax
f0100c12:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f0100c14:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0100c1b:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f0100c1e:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0100c25:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c28:	89 46 10             	mov    %eax,0x10(%esi)
	info->eip_fn_narg = 0;
f0100c2b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100c32:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f0100c37:	0f 86 3e 01 00 00    	jbe    f0100d7b <debuginfo_eip+0x186>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100c3d:	c7 c0 51 5b 10 f0    	mov    $0xf0105b51,%eax
f0100c43:	39 83 fc ff ff ff    	cmp    %eax,-0x4(%ebx)
f0100c49:	0f 86 d0 01 00 00    	jbe    f0100e1f <debuginfo_eip+0x22a>
f0100c4f:	c7 c0 79 71 10 f0    	mov    $0xf0107179,%eax
f0100c55:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0100c59:	0f 85 c7 01 00 00    	jne    f0100e26 <debuginfo_eip+0x231>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100c5f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100c66:	c7 c0 98 22 10 f0    	mov    $0xf0102298,%eax
f0100c6c:	c7 c2 50 5b 10 f0    	mov    $0xf0105b50,%edx
f0100c72:	29 c2                	sub    %eax,%edx
f0100c74:	c1 fa 02             	sar    $0x2,%edx
f0100c77:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0100c7d:	83 ea 01             	sub    $0x1,%edx
f0100c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100c83:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100c86:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100c89:	83 ec 08             	sub    $0x8,%esp
f0100c8c:	ff 75 08             	push   0x8(%ebp)
f0100c8f:	6a 64                	push   $0x64
f0100c91:	e8 6a fe ff ff       	call   f0100b00 <stab_binsearch>
	if (lfile == 0)
f0100c96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100c99:	83 c4 10             	add    $0x10,%esp
f0100c9c:	85 ff                	test   %edi,%edi
f0100c9e:	0f 84 89 01 00 00    	je     f0100e2d <debuginfo_eip+0x238>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100ca4:	89 7d dc             	mov    %edi,-0x24(%ebp)
	rfun = rfile;
f0100ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100caa:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0100cad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100cb0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100cb3:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100cb6:	83 ec 08             	sub    $0x8,%esp
f0100cb9:	ff 75 08             	push   0x8(%ebp)
f0100cbc:	6a 24                	push   $0x24
f0100cbe:	c7 c0 98 22 10 f0    	mov    $0xf0102298,%eax
f0100cc4:	e8 37 fe ff ff       	call   f0100b00 <stab_binsearch>

	if (lfun <= rfun) {
f0100cc9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100ccc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0100ccf:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100cd2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0100cd5:	83 c4 10             	add    $0x10,%esp
f0100cd8:	89 f8                	mov    %edi,%eax
f0100cda:	39 d1                	cmp    %edx,%ecx
f0100cdc:	7f 39                	jg     f0100d17 <debuginfo_eip+0x122>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100cde:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0100ce1:	c7 c2 98 22 10 f0    	mov    $0xf0102298,%edx
f0100ce7:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
f0100cea:	8b 11                	mov    (%ecx),%edx
f0100cec:	c7 c0 79 71 10 f0    	mov    $0xf0107179,%eax
f0100cf2:	81 e8 51 5b 10 f0    	sub    $0xf0105b51,%eax
f0100cf8:	39 c2                	cmp    %eax,%edx
f0100cfa:	73 09                	jae    f0100d05 <debuginfo_eip+0x110>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100cfc:	81 c2 51 5b 10 f0    	add    $0xf0105b51,%edx
f0100d02:	89 56 08             	mov    %edx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100d05:	8b 41 08             	mov    0x8(%ecx),%eax
f0100d08:	89 46 10             	mov    %eax,0x10(%esi)
		addr -= info->eip_fn_addr;
f0100d0b:	29 45 08             	sub    %eax,0x8(%ebp)
f0100d0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100d11:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0100d14:	89 4d c0             	mov    %ecx,-0x40(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0100d17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100d1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100d1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100d20:	83 ec 08             	sub    $0x8,%esp
f0100d23:	6a 3a                	push   $0x3a
f0100d25:	ff 76 08             	push   0x8(%esi)
f0100d28:	e8 a8 09 00 00       	call   f01016d5 <strfind>
f0100d2d:	2b 46 08             	sub    0x8(%esi),%eax
f0100d30:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0100d33:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100d36:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100d39:	83 c4 08             	add    $0x8,%esp
f0100d3c:	ff 75 08             	push   0x8(%ebp)
f0100d3f:	6a 44                	push   $0x44
f0100d41:	c7 c0 98 22 10 f0    	mov    $0xf0102298,%eax
f0100d47:	e8 b4 fd ff ff       	call   f0100b00 <stab_binsearch>
	if (lline <= rline) {
f0100d4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100d4f:	83 c4 10             	add    $0x10,%esp
f0100d52:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0100d55:	0f 8f d9 00 00 00    	jg     f0100e34 <debuginfo_eip+0x23f>
		info->eip_line = stabs[lline].n_desc;
f0100d5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0100d5e:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0100d61:	c7 c0 98 22 10 f0    	mov    $0xf0102298,%eax
f0100d67:	0f b7 54 88 06       	movzwl 0x6(%eax,%ecx,4),%edx
f0100d6c:	89 56 04             	mov    %edx,0x4(%esi)
f0100d6f:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
f0100d73:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0100d76:	89 75 0c             	mov    %esi,0xc(%ebp)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d79:	eb 1e                	jmp    f0100d99 <debuginfo_eip+0x1a4>
  	        panic("User address");
f0100d7b:	83 ec 04             	sub    $0x4,%esp
f0100d7e:	8d 83 7f 0d ff ff    	lea    -0xf281(%ebx),%eax
f0100d84:	50                   	push   %eax
f0100d85:	6a 7f                	push   $0x7f
f0100d87:	8d 83 8c 0d ff ff    	lea    -0xf274(%ebx),%eax
f0100d8d:	50                   	push   %eax
f0100d8e:	e8 73 f3 ff ff       	call   f0100106 <_panic>
f0100d93:	83 ea 01             	sub    $0x1,%edx
f0100d96:	83 e8 0c             	sub    $0xc,%eax
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100d99:	39 d7                	cmp    %edx,%edi
f0100d9b:	7f 3c                	jg     f0100dd9 <debuginfo_eip+0x1e4>
	       && stabs[lline].n_type != N_SOL
f0100d9d:	0f b6 08             	movzbl (%eax),%ecx
f0100da0:	80 f9 84             	cmp    $0x84,%cl
f0100da3:	74 0b                	je     f0100db0 <debuginfo_eip+0x1bb>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100da5:	80 f9 64             	cmp    $0x64,%cl
f0100da8:	75 e9                	jne    f0100d93 <debuginfo_eip+0x19e>
f0100daa:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0100dae:	74 e3                	je     f0100d93 <debuginfo_eip+0x19e>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100db0:	8b 75 0c             	mov    0xc(%ebp),%esi
f0100db3:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0100db6:	c7 c0 98 22 10 f0    	mov    $0xf0102298,%eax
f0100dbc:	8b 14 90             	mov    (%eax,%edx,4),%edx
f0100dbf:	c7 c0 79 71 10 f0    	mov    $0xf0107179,%eax
f0100dc5:	81 e8 51 5b 10 f0    	sub    $0xf0105b51,%eax
f0100dcb:	39 c2                	cmp    %eax,%edx
f0100dcd:	73 0d                	jae    f0100ddc <debuginfo_eip+0x1e7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100dcf:	81 c2 51 5b 10 f0    	add    $0xf0105b51,%edx
f0100dd5:	89 16                	mov    %edx,(%esi)
f0100dd7:	eb 03                	jmp    f0100ddc <debuginfo_eip+0x1e7>
f0100dd9:	8b 75 0c             	mov    0xc(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0100de1:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0100de4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0100de7:	39 cf                	cmp    %ecx,%edi
f0100de9:	7d 55                	jge    f0100e40 <debuginfo_eip+0x24b>
		for (lline = lfun + 1;
f0100deb:	83 c7 01             	add    $0x1,%edi
f0100dee:	89 f8                	mov    %edi,%eax
f0100df0:	8d 0c 7f             	lea    (%edi,%edi,2),%ecx
f0100df3:	c7 c2 98 22 10 f0    	mov    $0xf0102298,%edx
f0100df9:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0100dfd:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100e00:	eb 04                	jmp    f0100e06 <debuginfo_eip+0x211>
			info->eip_fn_narg++;
f0100e02:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100e06:	39 c3                	cmp    %eax,%ebx
f0100e08:	7e 31                	jle    f0100e3b <debuginfo_eip+0x246>
f0100e0a:	0f b6 0a             	movzbl (%edx),%ecx
f0100e0d:	83 c0 01             	add    $0x1,%eax
f0100e10:	83 c2 0c             	add    $0xc,%edx
f0100e13:	80 f9 a0             	cmp    $0xa0,%cl
f0100e16:	74 ea                	je     f0100e02 <debuginfo_eip+0x20d>
	return 0;
f0100e18:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e1d:	eb 21                	jmp    f0100e40 <debuginfo_eip+0x24b>
		return -1;
f0100e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100e24:	eb 1a                	jmp    f0100e40 <debuginfo_eip+0x24b>
f0100e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100e2b:	eb 13                	jmp    f0100e40 <debuginfo_eip+0x24b>
		return -1;
f0100e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100e32:	eb 0c                	jmp    f0100e40 <debuginfo_eip+0x24b>
		return -1;
f0100e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100e39:	eb 05                	jmp    f0100e40 <debuginfo_eip+0x24b>
	return 0;
f0100e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e43:	5b                   	pop    %ebx
f0100e44:	5e                   	pop    %esi
f0100e45:	5f                   	pop    %edi
f0100e46:	5d                   	pop    %ebp
f0100e47:	c3                   	ret    

f0100e48 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100e48:	55                   	push   %ebp
f0100e49:	89 e5                	mov    %esp,%ebp
f0100e4b:	57                   	push   %edi
f0100e4c:	56                   	push   %esi
f0100e4d:	53                   	push   %ebx
f0100e4e:	83 ec 2c             	sub    $0x2c,%esp
f0100e51:	e8 07 06 00 00       	call   f010145d <__x86.get_pc_thunk.cx>
f0100e56:	81 c1 b2 04 01 00    	add    $0x104b2,%ecx
f0100e5c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0100e5f:	89 c7                	mov    %eax,%edi
f0100e61:	89 d6                	mov    %edx,%esi
f0100e63:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e66:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100e69:	89 d1                	mov    %edx,%ecx
f0100e6b:	89 c2                	mov    %eax,%edx
f0100e6d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100e70:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0100e73:	8b 45 10             	mov    0x10(%ebp),%eax
f0100e76:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100e79:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100e7c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100e83:	39 c2                	cmp    %eax,%edx
f0100e85:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0100e88:	72 41                	jb     f0100ecb <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100e8a:	83 ec 0c             	sub    $0xc,%esp
f0100e8d:	ff 75 18             	push   0x18(%ebp)
f0100e90:	83 eb 01             	sub    $0x1,%ebx
f0100e93:	53                   	push   %ebx
f0100e94:	50                   	push   %eax
f0100e95:	83 ec 08             	sub    $0x8,%esp
f0100e98:	ff 75 e4             	push   -0x1c(%ebp)
f0100e9b:	ff 75 e0             	push   -0x20(%ebp)
f0100e9e:	ff 75 d4             	push   -0x2c(%ebp)
f0100ea1:	ff 75 d0             	push   -0x30(%ebp)
f0100ea4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100ea7:	e8 44 0a 00 00       	call   f01018f0 <__udivdi3>
f0100eac:	83 c4 18             	add    $0x18,%esp
f0100eaf:	52                   	push   %edx
f0100eb0:	50                   	push   %eax
f0100eb1:	89 f2                	mov    %esi,%edx
f0100eb3:	89 f8                	mov    %edi,%eax
f0100eb5:	e8 8e ff ff ff       	call   f0100e48 <printnum>
f0100eba:	83 c4 20             	add    $0x20,%esp
f0100ebd:	eb 13                	jmp    f0100ed2 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0100ebf:	83 ec 08             	sub    $0x8,%esp
f0100ec2:	56                   	push   %esi
f0100ec3:	ff 75 18             	push   0x18(%ebp)
f0100ec6:	ff d7                	call   *%edi
f0100ec8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0100ecb:	83 eb 01             	sub    $0x1,%ebx
f0100ece:	85 db                	test   %ebx,%ebx
f0100ed0:	7f ed                	jg     f0100ebf <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0100ed2:	83 ec 08             	sub    $0x8,%esp
f0100ed5:	56                   	push   %esi
f0100ed6:	83 ec 04             	sub    $0x4,%esp
f0100ed9:	ff 75 e4             	push   -0x1c(%ebp)
f0100edc:	ff 75 e0             	push   -0x20(%ebp)
f0100edf:	ff 75 d4             	push   -0x2c(%ebp)
f0100ee2:	ff 75 d0             	push   -0x30(%ebp)
f0100ee5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100ee8:	e8 23 0b 00 00       	call   f0101a10 <__umoddi3>
f0100eed:	83 c4 14             	add    $0x14,%esp
f0100ef0:	0f be 84 03 9a 0d ff 	movsbl -0xf266(%ebx,%eax,1),%eax
f0100ef7:	ff 
f0100ef8:	50                   	push   %eax
f0100ef9:	ff d7                	call   *%edi
}
f0100efb:	83 c4 10             	add    $0x10,%esp
f0100efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f01:	5b                   	pop    %ebx
f0100f02:	5e                   	pop    %esi
f0100f03:	5f                   	pop    %edi
f0100f04:	5d                   	pop    %ebp
f0100f05:	c3                   	ret    

f0100f06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100f06:	55                   	push   %ebp
f0100f07:	89 e5                	mov    %esp,%ebp
f0100f09:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0100f0c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100f10:	8b 10                	mov    (%eax),%edx
f0100f12:	3b 50 04             	cmp    0x4(%eax),%edx
f0100f15:	73 0a                	jae    f0100f21 <sprintputch+0x1b>
		*b->buf++ = ch;
f0100f17:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100f1a:	89 08                	mov    %ecx,(%eax)
f0100f1c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f1f:	88 02                	mov    %al,(%edx)
}
f0100f21:	5d                   	pop    %ebp
f0100f22:	c3                   	ret    

f0100f23 <printfmt>:
{
f0100f23:	55                   	push   %ebp
f0100f24:	89 e5                	mov    %esp,%ebp
f0100f26:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0100f29:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0100f2c:	50                   	push   %eax
f0100f2d:	ff 75 10             	push   0x10(%ebp)
f0100f30:	ff 75 0c             	push   0xc(%ebp)
f0100f33:	ff 75 08             	push   0x8(%ebp)
f0100f36:	e8 05 00 00 00       	call   f0100f40 <vprintfmt>
}
f0100f3b:	83 c4 10             	add    $0x10,%esp
f0100f3e:	c9                   	leave  
f0100f3f:	c3                   	ret    

f0100f40 <vprintfmt>:
{
f0100f40:	55                   	push   %ebp
f0100f41:	89 e5                	mov    %esp,%ebp
f0100f43:	57                   	push   %edi
f0100f44:	56                   	push   %esi
f0100f45:	53                   	push   %ebx
f0100f46:	83 ec 3c             	sub    $0x3c,%esp
f0100f49:	e8 00 f8 ff ff       	call   f010074e <__x86.get_pc_thunk.ax>
f0100f4e:	05 ba 03 01 00       	add    $0x103ba,%eax
f0100f53:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100f56:	8b 75 08             	mov    0x8(%ebp),%esi
f0100f59:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0100f5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0100f5f:	8d 80 3c 1d 00 00    	lea    0x1d3c(%eax),%eax
f0100f65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0100f68:	eb 0a                	jmp    f0100f74 <vprintfmt+0x34>
			putch(ch, putdat);
f0100f6a:	83 ec 08             	sub    $0x8,%esp
f0100f6d:	57                   	push   %edi
f0100f6e:	50                   	push   %eax
f0100f6f:	ff d6                	call   *%esi
f0100f71:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100f74:	83 c3 01             	add    $0x1,%ebx
f0100f77:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0100f7b:	83 f8 25             	cmp    $0x25,%eax
f0100f7e:	74 0c                	je     f0100f8c <vprintfmt+0x4c>
			if (ch == '\0')
f0100f80:	85 c0                	test   %eax,%eax
f0100f82:	75 e6                	jne    f0100f6a <vprintfmt+0x2a>
}
f0100f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f87:	5b                   	pop    %ebx
f0100f88:	5e                   	pop    %esi
f0100f89:	5f                   	pop    %edi
f0100f8a:	5d                   	pop    %ebp
f0100f8b:	c3                   	ret    
		padc = ' ';
f0100f8c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f0100f90:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0100f97:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0100f9e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f0100fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100faa:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0100fad:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0100fb0:	8d 43 01             	lea    0x1(%ebx),%eax
f0100fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100fb6:	0f b6 13             	movzbl (%ebx),%edx
f0100fb9:	8d 42 dd             	lea    -0x23(%edx),%eax
f0100fbc:	3c 55                	cmp    $0x55,%al
f0100fbe:	0f 87 fd 03 00 00    	ja     f01013c1 <.L20>
f0100fc4:	0f b6 c0             	movzbl %al,%eax
f0100fc7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100fca:	89 ce                	mov    %ecx,%esi
f0100fcc:	03 b4 81 28 0e ff ff 	add    -0xf1d8(%ecx,%eax,4),%esi
f0100fd3:	ff e6                	jmp    *%esi

f0100fd5 <.L68>:
f0100fd5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f0100fd8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0100fdc:	eb d2                	jmp    f0100fb0 <vprintfmt+0x70>

f0100fde <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f0100fde:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100fe1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0100fe5:	eb c9                	jmp    f0100fb0 <vprintfmt+0x70>

f0100fe7 <.L31>:
f0100fe7:	0f b6 d2             	movzbl %dl,%edx
f0100fea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f0100fed:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ff2:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f0100ff5:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100ff8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0100ffc:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0100fff:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0101002:	83 f9 09             	cmp    $0x9,%ecx
f0101005:	77 58                	ja     f010105f <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f0101007:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f010100a:	eb e9                	jmp    f0100ff5 <.L31+0xe>

f010100c <.L34>:
			precision = va_arg(ap, int);
f010100c:	8b 45 14             	mov    0x14(%ebp),%eax
f010100f:	8b 00                	mov    (%eax),%eax
f0101011:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101014:	8b 45 14             	mov    0x14(%ebp),%eax
f0101017:	8d 40 04             	lea    0x4(%eax),%eax
f010101a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010101d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f0101020:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101024:	79 8a                	jns    f0100fb0 <vprintfmt+0x70>
				width = precision, precision = -1;
f0101026:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101029:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010102c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0101033:	e9 78 ff ff ff       	jmp    f0100fb0 <vprintfmt+0x70>

f0101038 <.L33>:
f0101038:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010103b:	85 d2                	test   %edx,%edx
f010103d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101042:	0f 49 c2             	cmovns %edx,%eax
f0101045:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0101048:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f010104b:	e9 60 ff ff ff       	jmp    f0100fb0 <vprintfmt+0x70>

f0101050 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f0101050:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f0101053:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f010105a:	e9 51 ff ff ff       	jmp    f0100fb0 <vprintfmt+0x70>
f010105f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101062:	89 75 08             	mov    %esi,0x8(%ebp)
f0101065:	eb b9                	jmp    f0101020 <.L34+0x14>

f0101067 <.L27>:
			lflag++;
f0101067:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010106b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f010106e:	e9 3d ff ff ff       	jmp    f0100fb0 <vprintfmt+0x70>

f0101073 <.L30>:
			putch(va_arg(ap, int), putdat);
f0101073:	8b 75 08             	mov    0x8(%ebp),%esi
f0101076:	8b 45 14             	mov    0x14(%ebp),%eax
f0101079:	8d 58 04             	lea    0x4(%eax),%ebx
f010107c:	83 ec 08             	sub    $0x8,%esp
f010107f:	57                   	push   %edi
f0101080:	ff 30                	push   (%eax)
f0101082:	ff d6                	call   *%esi
			break;
f0101084:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0101087:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f010108a:	e9 c8 02 00 00       	jmp    f0101357 <.L25+0x45>

f010108f <.L28>:
			err = va_arg(ap, int);
f010108f:	8b 75 08             	mov    0x8(%ebp),%esi
f0101092:	8b 45 14             	mov    0x14(%ebp),%eax
f0101095:	8d 58 04             	lea    0x4(%eax),%ebx
f0101098:	8b 10                	mov    (%eax),%edx
f010109a:	89 d0                	mov    %edx,%eax
f010109c:	f7 d8                	neg    %eax
f010109e:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01010a1:	83 f8 06             	cmp    $0x6,%eax
f01010a4:	7f 27                	jg     f01010cd <.L28+0x3e>
f01010a6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01010a9:	8b 14 82             	mov    (%edx,%eax,4),%edx
f01010ac:	85 d2                	test   %edx,%edx
f01010ae:	74 1d                	je     f01010cd <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
f01010b0:	52                   	push   %edx
f01010b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01010b4:	8d 80 bb 0d ff ff    	lea    -0xf245(%eax),%eax
f01010ba:	50                   	push   %eax
f01010bb:	57                   	push   %edi
f01010bc:	56                   	push   %esi
f01010bd:	e8 61 fe ff ff       	call   f0100f23 <printfmt>
f01010c2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01010c5:	89 5d 14             	mov    %ebx,0x14(%ebp)
f01010c8:	e9 8a 02 00 00       	jmp    f0101357 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f01010cd:	50                   	push   %eax
f01010ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01010d1:	8d 80 b2 0d ff ff    	lea    -0xf24e(%eax),%eax
f01010d7:	50                   	push   %eax
f01010d8:	57                   	push   %edi
f01010d9:	56                   	push   %esi
f01010da:	e8 44 fe ff ff       	call   f0100f23 <printfmt>
f01010df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01010e2:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01010e5:	e9 6d 02 00 00       	jmp    f0101357 <.L25+0x45>

f01010ea <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
f01010ea:	8b 75 08             	mov    0x8(%ebp),%esi
f01010ed:	8b 45 14             	mov    0x14(%ebp),%eax
f01010f0:	83 c0 04             	add    $0x4,%eax
f01010f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01010f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01010f9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01010fb:	85 d2                	test   %edx,%edx
f01010fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101100:	8d 80 ab 0d ff ff    	lea    -0xf255(%eax),%eax
f0101106:	0f 45 c2             	cmovne %edx,%eax
f0101109:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f010110c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101110:	7e 06                	jle    f0101118 <.L24+0x2e>
f0101112:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0101116:	75 0d                	jne    f0101125 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f0101118:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010111b:	89 c3                	mov    %eax,%ebx
f010111d:	03 45 d4             	add    -0x2c(%ebp),%eax
f0101120:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101123:	eb 58                	jmp    f010117d <.L24+0x93>
f0101125:	83 ec 08             	sub    $0x8,%esp
f0101128:	ff 75 d8             	push   -0x28(%ebp)
f010112b:	ff 75 c8             	push   -0x38(%ebp)
f010112e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0101131:	e8 48 04 00 00       	call   f010157e <strnlen>
f0101136:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101139:	29 c2                	sub    %eax,%edx
f010113b:	89 55 bc             	mov    %edx,-0x44(%ebp)
f010113e:	83 c4 10             	add    $0x10,%esp
f0101141:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f0101143:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0101147:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010114a:	eb 0f                	jmp    f010115b <.L24+0x71>
					putch(padc, putdat);
f010114c:	83 ec 08             	sub    $0x8,%esp
f010114f:	57                   	push   %edi
f0101150:	ff 75 d4             	push   -0x2c(%ebp)
f0101153:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0101155:	83 eb 01             	sub    $0x1,%ebx
f0101158:	83 c4 10             	add    $0x10,%esp
f010115b:	85 db                	test   %ebx,%ebx
f010115d:	7f ed                	jg     f010114c <.L24+0x62>
f010115f:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0101162:	85 d2                	test   %edx,%edx
f0101164:	b8 00 00 00 00       	mov    $0x0,%eax
f0101169:	0f 49 c2             	cmovns %edx,%eax
f010116c:	29 c2                	sub    %eax,%edx
f010116e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0101171:	eb a5                	jmp    f0101118 <.L24+0x2e>
					putch(ch, putdat);
f0101173:	83 ec 08             	sub    $0x8,%esp
f0101176:	57                   	push   %edi
f0101177:	52                   	push   %edx
f0101178:	ff d6                	call   *%esi
f010117a:	83 c4 10             	add    $0x10,%esp
f010117d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101180:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101182:	83 c3 01             	add    $0x1,%ebx
f0101185:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0101189:	0f be d0             	movsbl %al,%edx
f010118c:	85 d2                	test   %edx,%edx
f010118e:	74 4b                	je     f01011db <.L24+0xf1>
f0101190:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101194:	78 06                	js     f010119c <.L24+0xb2>
f0101196:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f010119a:	78 1e                	js     f01011ba <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f010119c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01011a0:	74 d1                	je     f0101173 <.L24+0x89>
f01011a2:	0f be c0             	movsbl %al,%eax
f01011a5:	83 e8 20             	sub    $0x20,%eax
f01011a8:	83 f8 5e             	cmp    $0x5e,%eax
f01011ab:	76 c6                	jbe    f0101173 <.L24+0x89>
					putch('?', putdat);
f01011ad:	83 ec 08             	sub    $0x8,%esp
f01011b0:	57                   	push   %edi
f01011b1:	6a 3f                	push   $0x3f
f01011b3:	ff d6                	call   *%esi
f01011b5:	83 c4 10             	add    $0x10,%esp
f01011b8:	eb c3                	jmp    f010117d <.L24+0x93>
f01011ba:	89 cb                	mov    %ecx,%ebx
f01011bc:	eb 0e                	jmp    f01011cc <.L24+0xe2>
				putch(' ', putdat);
f01011be:	83 ec 08             	sub    $0x8,%esp
f01011c1:	57                   	push   %edi
f01011c2:	6a 20                	push   $0x20
f01011c4:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01011c6:	83 eb 01             	sub    $0x1,%ebx
f01011c9:	83 c4 10             	add    $0x10,%esp
f01011cc:	85 db                	test   %ebx,%ebx
f01011ce:	7f ee                	jg     f01011be <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f01011d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
f01011d3:	89 45 14             	mov    %eax,0x14(%ebp)
f01011d6:	e9 7c 01 00 00       	jmp    f0101357 <.L25+0x45>
f01011db:	89 cb                	mov    %ecx,%ebx
f01011dd:	eb ed                	jmp    f01011cc <.L24+0xe2>

f01011df <.L29>:
	if (lflag >= 2)
f01011df:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01011e2:	8b 75 08             	mov    0x8(%ebp),%esi
f01011e5:	83 f9 01             	cmp    $0x1,%ecx
f01011e8:	7f 1b                	jg     f0101205 <.L29+0x26>
	else if (lflag)
f01011ea:	85 c9                	test   %ecx,%ecx
f01011ec:	74 63                	je     f0101251 <.L29+0x72>
		return va_arg(*ap, long);
f01011ee:	8b 45 14             	mov    0x14(%ebp),%eax
f01011f1:	8b 00                	mov    (%eax),%eax
f01011f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01011f6:	99                   	cltd   
f01011f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01011fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01011fd:	8d 40 04             	lea    0x4(%eax),%eax
f0101200:	89 45 14             	mov    %eax,0x14(%ebp)
f0101203:	eb 17                	jmp    f010121c <.L29+0x3d>
		return va_arg(*ap, long long);
f0101205:	8b 45 14             	mov    0x14(%ebp),%eax
f0101208:	8b 50 04             	mov    0x4(%eax),%edx
f010120b:	8b 00                	mov    (%eax),%eax
f010120d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101210:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101213:	8b 45 14             	mov    0x14(%ebp),%eax
f0101216:	8d 40 08             	lea    0x8(%eax),%eax
f0101219:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f010121c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010121f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
f0101222:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0101227:	85 db                	test   %ebx,%ebx
f0101229:	0f 89 0e 01 00 00    	jns    f010133d <.L25+0x2b>
				putch('-', putdat);
f010122f:	83 ec 08             	sub    $0x8,%esp
f0101232:	57                   	push   %edi
f0101233:	6a 2d                	push   $0x2d
f0101235:	ff d6                	call   *%esi
				num = -(long long) num;
f0101237:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010123a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f010123d:	f7 d9                	neg    %ecx
f010123f:	83 d3 00             	adc    $0x0,%ebx
f0101242:	f7 db                	neg    %ebx
f0101244:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0101247:	ba 0a 00 00 00       	mov    $0xa,%edx
f010124c:	e9 ec 00 00 00       	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, int);
f0101251:	8b 45 14             	mov    0x14(%ebp),%eax
f0101254:	8b 00                	mov    (%eax),%eax
f0101256:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101259:	99                   	cltd   
f010125a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010125d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101260:	8d 40 04             	lea    0x4(%eax),%eax
f0101263:	89 45 14             	mov    %eax,0x14(%ebp)
f0101266:	eb b4                	jmp    f010121c <.L29+0x3d>

f0101268 <.L23>:
	if (lflag >= 2)
f0101268:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010126b:	8b 75 08             	mov    0x8(%ebp),%esi
f010126e:	83 f9 01             	cmp    $0x1,%ecx
f0101271:	7f 1e                	jg     f0101291 <.L23+0x29>
	else if (lflag)
f0101273:	85 c9                	test   %ecx,%ecx
f0101275:	74 32                	je     f01012a9 <.L23+0x41>
		return va_arg(*ap, unsigned long);
f0101277:	8b 45 14             	mov    0x14(%ebp),%eax
f010127a:	8b 08                	mov    (%eax),%ecx
f010127c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101281:	8d 40 04             	lea    0x4(%eax),%eax
f0101284:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101287:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
f010128c:	e9 ac 00 00 00       	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0101291:	8b 45 14             	mov    0x14(%ebp),%eax
f0101294:	8b 08                	mov    (%eax),%ecx
f0101296:	8b 58 04             	mov    0x4(%eax),%ebx
f0101299:	8d 40 08             	lea    0x8(%eax),%eax
f010129c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010129f:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
f01012a4:	e9 94 00 00 00       	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f01012a9:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ac:	8b 08                	mov    (%eax),%ecx
f01012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
f01012b3:	8d 40 04             	lea    0x4(%eax),%eax
f01012b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01012b9:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
f01012be:	eb 7d                	jmp    f010133d <.L25+0x2b>

f01012c0 <.L26>:
	if (lflag >= 2)
f01012c0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01012c3:	8b 75 08             	mov    0x8(%ebp),%esi
f01012c6:	83 f9 01             	cmp    $0x1,%ecx
f01012c9:	7f 1b                	jg     f01012e6 <.L26+0x26>
	else if (lflag)
f01012cb:	85 c9                	test   %ecx,%ecx
f01012cd:	74 2c                	je     f01012fb <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f01012cf:	8b 45 14             	mov    0x14(%ebp),%eax
f01012d2:	8b 08                	mov    (%eax),%ecx
f01012d4:	bb 00 00 00 00       	mov    $0x0,%ebx
f01012d9:	8d 40 04             	lea    0x4(%eax),%eax
f01012dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01012df:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
f01012e4:	eb 57                	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f01012e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01012e9:	8b 08                	mov    (%eax),%ecx
f01012eb:	8b 58 04             	mov    0x4(%eax),%ebx
f01012ee:	8d 40 08             	lea    0x8(%eax),%eax
f01012f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01012f4:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
f01012f9:	eb 42                	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f01012fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01012fe:	8b 08                	mov    (%eax),%ecx
f0101300:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101305:	8d 40 04             	lea    0x4(%eax),%eax
f0101308:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010130b:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
f0101310:	eb 2b                	jmp    f010133d <.L25+0x2b>

f0101312 <.L25>:
			putch('0', putdat);
f0101312:	8b 75 08             	mov    0x8(%ebp),%esi
f0101315:	83 ec 08             	sub    $0x8,%esp
f0101318:	57                   	push   %edi
f0101319:	6a 30                	push   $0x30
f010131b:	ff d6                	call   *%esi
			putch('x', putdat);
f010131d:	83 c4 08             	add    $0x8,%esp
f0101320:	57                   	push   %edi
f0101321:	6a 78                	push   $0x78
f0101323:	ff d6                	call   *%esi
			num = (unsigned long long)
f0101325:	8b 45 14             	mov    0x14(%ebp),%eax
f0101328:	8b 08                	mov    (%eax),%ecx
f010132a:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
f010132f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0101332:	8d 40 04             	lea    0x4(%eax),%eax
f0101335:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101338:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
f010133d:	83 ec 0c             	sub    $0xc,%esp
f0101340:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0101344:	50                   	push   %eax
f0101345:	ff 75 d4             	push   -0x2c(%ebp)
f0101348:	52                   	push   %edx
f0101349:	53                   	push   %ebx
f010134a:	51                   	push   %ecx
f010134b:	89 fa                	mov    %edi,%edx
f010134d:	89 f0                	mov    %esi,%eax
f010134f:	e8 f4 fa ff ff       	call   f0100e48 <printnum>
			break;
f0101354:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0101357:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010135a:	e9 15 fc ff ff       	jmp    f0100f74 <vprintfmt+0x34>

f010135f <.L21>:
	if (lflag >= 2)
f010135f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0101362:	8b 75 08             	mov    0x8(%ebp),%esi
f0101365:	83 f9 01             	cmp    $0x1,%ecx
f0101368:	7f 1b                	jg     f0101385 <.L21+0x26>
	else if (lflag)
f010136a:	85 c9                	test   %ecx,%ecx
f010136c:	74 2c                	je     f010139a <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f010136e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101371:	8b 08                	mov    (%eax),%ecx
f0101373:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101378:	8d 40 04             	lea    0x4(%eax),%eax
f010137b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010137e:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
f0101383:	eb b8                	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0101385:	8b 45 14             	mov    0x14(%ebp),%eax
f0101388:	8b 08                	mov    (%eax),%ecx
f010138a:	8b 58 04             	mov    0x4(%eax),%ebx
f010138d:	8d 40 08             	lea    0x8(%eax),%eax
f0101390:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101393:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
f0101398:	eb a3                	jmp    f010133d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f010139a:	8b 45 14             	mov    0x14(%ebp),%eax
f010139d:	8b 08                	mov    (%eax),%ecx
f010139f:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013a4:	8d 40 04             	lea    0x4(%eax),%eax
f01013a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01013aa:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
f01013af:	eb 8c                	jmp    f010133d <.L25+0x2b>

f01013b1 <.L35>:
			putch(ch, putdat);
f01013b1:	8b 75 08             	mov    0x8(%ebp),%esi
f01013b4:	83 ec 08             	sub    $0x8,%esp
f01013b7:	57                   	push   %edi
f01013b8:	6a 25                	push   $0x25
f01013ba:	ff d6                	call   *%esi
			break;
f01013bc:	83 c4 10             	add    $0x10,%esp
f01013bf:	eb 96                	jmp    f0101357 <.L25+0x45>

f01013c1 <.L20>:
			putch('%', putdat);
f01013c1:	8b 75 08             	mov    0x8(%ebp),%esi
f01013c4:	83 ec 08             	sub    $0x8,%esp
f01013c7:	57                   	push   %edi
f01013c8:	6a 25                	push   $0x25
f01013ca:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01013cc:	83 c4 10             	add    $0x10,%esp
f01013cf:	89 d8                	mov    %ebx,%eax
f01013d1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01013d5:	74 05                	je     f01013dc <.L20+0x1b>
f01013d7:	83 e8 01             	sub    $0x1,%eax
f01013da:	eb f5                	jmp    f01013d1 <.L20+0x10>
f01013dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01013df:	e9 73 ff ff ff       	jmp    f0101357 <.L25+0x45>

f01013e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01013e4:	55                   	push   %ebp
f01013e5:	89 e5                	mov    %esp,%ebp
f01013e7:	53                   	push   %ebx
f01013e8:	83 ec 14             	sub    $0x14,%esp
f01013eb:	e8 cc ed ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f01013f0:	81 c3 18 ff 00 00    	add    $0xff18,%ebx
f01013f6:	8b 45 08             	mov    0x8(%ebp),%eax
f01013f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01013fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01013ff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0101403:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010140d:	85 c0                	test   %eax,%eax
f010140f:	74 2b                	je     f010143c <vsnprintf+0x58>
f0101411:	85 d2                	test   %edx,%edx
f0101413:	7e 27                	jle    f010143c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101415:	ff 75 14             	push   0x14(%ebp)
f0101418:	ff 75 10             	push   0x10(%ebp)
f010141b:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010141e:	50                   	push   %eax
f010141f:	8d 83 fe fb fe ff    	lea    -0x10402(%ebx),%eax
f0101425:	50                   	push   %eax
f0101426:	e8 15 fb ff ff       	call   f0100f40 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010142b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010142e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0101431:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101434:	83 c4 10             	add    $0x10,%esp
}
f0101437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010143a:	c9                   	leave  
f010143b:	c3                   	ret    
		return -E_INVAL;
f010143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101441:	eb f4                	jmp    f0101437 <vsnprintf+0x53>

f0101443 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0101443:	55                   	push   %ebp
f0101444:	89 e5                	mov    %esp,%ebp
f0101446:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0101449:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010144c:	50                   	push   %eax
f010144d:	ff 75 10             	push   0x10(%ebp)
f0101450:	ff 75 0c             	push   0xc(%ebp)
f0101453:	ff 75 08             	push   0x8(%ebp)
f0101456:	e8 89 ff ff ff       	call   f01013e4 <vsnprintf>
	va_end(ap);

	return rc;
}
f010145b:	c9                   	leave  
f010145c:	c3                   	ret    

f010145d <__x86.get_pc_thunk.cx>:
f010145d:	8b 0c 24             	mov    (%esp),%ecx
f0101460:	c3                   	ret    

f0101461 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101461:	55                   	push   %ebp
f0101462:	89 e5                	mov    %esp,%ebp
f0101464:	57                   	push   %edi
f0101465:	56                   	push   %esi
f0101466:	53                   	push   %ebx
f0101467:	83 ec 1c             	sub    $0x1c,%esp
f010146a:	e8 4d ed ff ff       	call   f01001bc <__x86.get_pc_thunk.bx>
f010146f:	81 c3 99 fe 00 00    	add    $0xfe99,%ebx
f0101475:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0101478:	85 c0                	test   %eax,%eax
f010147a:	74 13                	je     f010148f <readline+0x2e>
		cprintf("%s", prompt);
f010147c:	83 ec 08             	sub    $0x8,%esp
f010147f:	50                   	push   %eax
f0101480:	8d 83 bb 0d ff ff    	lea    -0xf245(%ebx),%eax
f0101486:	50                   	push   %eax
f0101487:	e8 60 f6 ff ff       	call   f0100aec <cprintf>
f010148c:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f010148f:	83 ec 0c             	sub    $0xc,%esp
f0101492:	6a 00                	push   $0x0
f0101494:	e8 af f2 ff ff       	call   f0100748 <iscons>
f0101499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010149c:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010149f:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f01014a4:	8d 83 b8 1f 00 00    	lea    0x1fb8(%ebx),%eax
f01014aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01014ad:	eb 45                	jmp    f01014f4 <readline+0x93>
			cprintf("read error: %e\n", c);
f01014af:	83 ec 08             	sub    $0x8,%esp
f01014b2:	50                   	push   %eax
f01014b3:	8d 83 80 0f ff ff    	lea    -0xf080(%ebx),%eax
f01014b9:	50                   	push   %eax
f01014ba:	e8 2d f6 ff ff       	call   f0100aec <cprintf>
			return NULL;
f01014bf:	83 c4 10             	add    $0x10,%esp
f01014c2:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01014c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01014ca:	5b                   	pop    %ebx
f01014cb:	5e                   	pop    %esi
f01014cc:	5f                   	pop    %edi
f01014cd:	5d                   	pop    %ebp
f01014ce:	c3                   	ret    
			if (echoing)
f01014cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01014d3:	75 05                	jne    f01014da <readline+0x79>
			i--;
f01014d5:	83 ef 01             	sub    $0x1,%edi
f01014d8:	eb 1a                	jmp    f01014f4 <readline+0x93>
				cputchar('\b');
f01014da:	83 ec 0c             	sub    $0xc,%esp
f01014dd:	6a 08                	push   $0x8
f01014df:	e8 43 f2 ff ff       	call   f0100727 <cputchar>
f01014e4:	83 c4 10             	add    $0x10,%esp
f01014e7:	eb ec                	jmp    f01014d5 <readline+0x74>
			buf[i++] = c;
f01014e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01014ec:	89 f0                	mov    %esi,%eax
f01014ee:	88 04 39             	mov    %al,(%ecx,%edi,1)
f01014f1:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f01014f4:	e8 3e f2 ff ff       	call   f0100737 <getchar>
f01014f9:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f01014fb:	85 c0                	test   %eax,%eax
f01014fd:	78 b0                	js     f01014af <readline+0x4e>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01014ff:	83 f8 08             	cmp    $0x8,%eax
f0101502:	0f 94 c0             	sete   %al
f0101505:	83 fe 7f             	cmp    $0x7f,%esi
f0101508:	0f 94 c2             	sete   %dl
f010150b:	08 d0                	or     %dl,%al
f010150d:	74 04                	je     f0101513 <readline+0xb2>
f010150f:	85 ff                	test   %edi,%edi
f0101511:	7f bc                	jg     f01014cf <readline+0x6e>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0101513:	83 fe 1f             	cmp    $0x1f,%esi
f0101516:	7e 1c                	jle    f0101534 <readline+0xd3>
f0101518:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f010151e:	7f 14                	jg     f0101534 <readline+0xd3>
			if (echoing)
f0101520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101524:	74 c3                	je     f01014e9 <readline+0x88>
				cputchar(c);
f0101526:	83 ec 0c             	sub    $0xc,%esp
f0101529:	56                   	push   %esi
f010152a:	e8 f8 f1 ff ff       	call   f0100727 <cputchar>
f010152f:	83 c4 10             	add    $0x10,%esp
f0101532:	eb b5                	jmp    f01014e9 <readline+0x88>
		} else if (c == '\n' || c == '\r') {
f0101534:	83 fe 0a             	cmp    $0xa,%esi
f0101537:	74 05                	je     f010153e <readline+0xdd>
f0101539:	83 fe 0d             	cmp    $0xd,%esi
f010153c:	75 b6                	jne    f01014f4 <readline+0x93>
			if (echoing)
f010153e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101542:	75 13                	jne    f0101557 <readline+0xf6>
			buf[i] = 0;
f0101544:	c6 84 3b b8 1f 00 00 	movb   $0x0,0x1fb8(%ebx,%edi,1)
f010154b:	00 
			return buf;
f010154c:	8d 83 b8 1f 00 00    	lea    0x1fb8(%ebx),%eax
f0101552:	e9 70 ff ff ff       	jmp    f01014c7 <readline+0x66>
				cputchar('\n');
f0101557:	83 ec 0c             	sub    $0xc,%esp
f010155a:	6a 0a                	push   $0xa
f010155c:	e8 c6 f1 ff ff       	call   f0100727 <cputchar>
f0101561:	83 c4 10             	add    $0x10,%esp
f0101564:	eb de                	jmp    f0101544 <readline+0xe3>

f0101566 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0101566:	55                   	push   %ebp
f0101567:	89 e5                	mov    %esp,%ebp
f0101569:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010156c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101571:	eb 03                	jmp    f0101576 <strlen+0x10>
		n++;
f0101573:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0101576:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010157a:	75 f7                	jne    f0101573 <strlen+0xd>
	return n;
}
f010157c:	5d                   	pop    %ebp
f010157d:	c3                   	ret    

f010157e <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010157e:	55                   	push   %ebp
f010157f:	89 e5                	mov    %esp,%ebp
f0101581:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101584:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101587:	b8 00 00 00 00       	mov    $0x0,%eax
f010158c:	eb 03                	jmp    f0101591 <strnlen+0x13>
		n++;
f010158e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101591:	39 d0                	cmp    %edx,%eax
f0101593:	74 08                	je     f010159d <strnlen+0x1f>
f0101595:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0101599:	75 f3                	jne    f010158e <strnlen+0x10>
f010159b:	89 c2                	mov    %eax,%edx
	return n;
}
f010159d:	89 d0                	mov    %edx,%eax
f010159f:	5d                   	pop    %ebp
f01015a0:	c3                   	ret    

f01015a1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01015a1:	55                   	push   %ebp
f01015a2:	89 e5                	mov    %esp,%ebp
f01015a4:	53                   	push   %ebx
f01015a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01015a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01015ab:	b8 00 00 00 00       	mov    $0x0,%eax
f01015b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f01015b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f01015b7:	83 c0 01             	add    $0x1,%eax
f01015ba:	84 d2                	test   %dl,%dl
f01015bc:	75 f2                	jne    f01015b0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01015be:	89 c8                	mov    %ecx,%eax
f01015c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01015c3:	c9                   	leave  
f01015c4:	c3                   	ret    

f01015c5 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01015c5:	55                   	push   %ebp
f01015c6:	89 e5                	mov    %esp,%ebp
f01015c8:	53                   	push   %ebx
f01015c9:	83 ec 10             	sub    $0x10,%esp
f01015cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01015cf:	53                   	push   %ebx
f01015d0:	e8 91 ff ff ff       	call   f0101566 <strlen>
f01015d5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01015d8:	ff 75 0c             	push   0xc(%ebp)
f01015db:	01 d8                	add    %ebx,%eax
f01015dd:	50                   	push   %eax
f01015de:	e8 be ff ff ff       	call   f01015a1 <strcpy>
	return dst;
}
f01015e3:	89 d8                	mov    %ebx,%eax
f01015e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01015e8:	c9                   	leave  
f01015e9:	c3                   	ret    

f01015ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01015ea:	55                   	push   %ebp
f01015eb:	89 e5                	mov    %esp,%ebp
f01015ed:	56                   	push   %esi
f01015ee:	53                   	push   %ebx
f01015ef:	8b 75 08             	mov    0x8(%ebp),%esi
f01015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01015f5:	89 f3                	mov    %esi,%ebx
f01015f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01015fa:	89 f0                	mov    %esi,%eax
f01015fc:	eb 0f                	jmp    f010160d <strncpy+0x23>
		*dst++ = *src;
f01015fe:	83 c0 01             	add    $0x1,%eax
f0101601:	0f b6 0a             	movzbl (%edx),%ecx
f0101604:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101607:	80 f9 01             	cmp    $0x1,%cl
f010160a:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
f010160d:	39 d8                	cmp    %ebx,%eax
f010160f:	75 ed                	jne    f01015fe <strncpy+0x14>
	}
	return ret;
}
f0101611:	89 f0                	mov    %esi,%eax
f0101613:	5b                   	pop    %ebx
f0101614:	5e                   	pop    %esi
f0101615:	5d                   	pop    %ebp
f0101616:	c3                   	ret    

f0101617 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101617:	55                   	push   %ebp
f0101618:	89 e5                	mov    %esp,%ebp
f010161a:	56                   	push   %esi
f010161b:	53                   	push   %ebx
f010161c:	8b 75 08             	mov    0x8(%ebp),%esi
f010161f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101622:	8b 55 10             	mov    0x10(%ebp),%edx
f0101625:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101627:	85 d2                	test   %edx,%edx
f0101629:	74 21                	je     f010164c <strlcpy+0x35>
f010162b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010162f:	89 f2                	mov    %esi,%edx
f0101631:	eb 09                	jmp    f010163c <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0101633:	83 c1 01             	add    $0x1,%ecx
f0101636:	83 c2 01             	add    $0x1,%edx
f0101639:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
f010163c:	39 c2                	cmp    %eax,%edx
f010163e:	74 09                	je     f0101649 <strlcpy+0x32>
f0101640:	0f b6 19             	movzbl (%ecx),%ebx
f0101643:	84 db                	test   %bl,%bl
f0101645:	75 ec                	jne    f0101633 <strlcpy+0x1c>
f0101647:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0101649:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010164c:	29 f0                	sub    %esi,%eax
}
f010164e:	5b                   	pop    %ebx
f010164f:	5e                   	pop    %esi
f0101650:	5d                   	pop    %ebp
f0101651:	c3                   	ret    

f0101652 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0101652:	55                   	push   %ebp
f0101653:	89 e5                	mov    %esp,%ebp
f0101655:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101658:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010165b:	eb 06                	jmp    f0101663 <strcmp+0x11>
		p++, q++;
f010165d:	83 c1 01             	add    $0x1,%ecx
f0101660:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0101663:	0f b6 01             	movzbl (%ecx),%eax
f0101666:	84 c0                	test   %al,%al
f0101668:	74 04                	je     f010166e <strcmp+0x1c>
f010166a:	3a 02                	cmp    (%edx),%al
f010166c:	74 ef                	je     f010165d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010166e:	0f b6 c0             	movzbl %al,%eax
f0101671:	0f b6 12             	movzbl (%edx),%edx
f0101674:	29 d0                	sub    %edx,%eax
}
f0101676:	5d                   	pop    %ebp
f0101677:	c3                   	ret    

f0101678 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0101678:	55                   	push   %ebp
f0101679:	89 e5                	mov    %esp,%ebp
f010167b:	53                   	push   %ebx
f010167c:	8b 45 08             	mov    0x8(%ebp),%eax
f010167f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101682:	89 c3                	mov    %eax,%ebx
f0101684:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0101687:	eb 06                	jmp    f010168f <strncmp+0x17>
		n--, p++, q++;
f0101689:	83 c0 01             	add    $0x1,%eax
f010168c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010168f:	39 d8                	cmp    %ebx,%eax
f0101691:	74 18                	je     f01016ab <strncmp+0x33>
f0101693:	0f b6 08             	movzbl (%eax),%ecx
f0101696:	84 c9                	test   %cl,%cl
f0101698:	74 04                	je     f010169e <strncmp+0x26>
f010169a:	3a 0a                	cmp    (%edx),%cl
f010169c:	74 eb                	je     f0101689 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010169e:	0f b6 00             	movzbl (%eax),%eax
f01016a1:	0f b6 12             	movzbl (%edx),%edx
f01016a4:	29 d0                	sub    %edx,%eax
}
f01016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01016a9:	c9                   	leave  
f01016aa:	c3                   	ret    
		return 0;
f01016ab:	b8 00 00 00 00       	mov    $0x0,%eax
f01016b0:	eb f4                	jmp    f01016a6 <strncmp+0x2e>

f01016b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01016b2:	55                   	push   %ebp
f01016b3:	89 e5                	mov    %esp,%ebp
f01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
f01016b8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01016bc:	eb 03                	jmp    f01016c1 <strchr+0xf>
f01016be:	83 c0 01             	add    $0x1,%eax
f01016c1:	0f b6 10             	movzbl (%eax),%edx
f01016c4:	84 d2                	test   %dl,%dl
f01016c6:	74 06                	je     f01016ce <strchr+0x1c>
		if (*s == c)
f01016c8:	38 ca                	cmp    %cl,%dl
f01016ca:	75 f2                	jne    f01016be <strchr+0xc>
f01016cc:	eb 05                	jmp    f01016d3 <strchr+0x21>
			return (char *) s;
	return 0;
f01016ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01016d3:	5d                   	pop    %ebp
f01016d4:	c3                   	ret    

f01016d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01016d5:	55                   	push   %ebp
f01016d6:	89 e5                	mov    %esp,%ebp
f01016d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01016db:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01016df:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01016e2:	38 ca                	cmp    %cl,%dl
f01016e4:	74 09                	je     f01016ef <strfind+0x1a>
f01016e6:	84 d2                	test   %dl,%dl
f01016e8:	74 05                	je     f01016ef <strfind+0x1a>
	for (; *s; s++)
f01016ea:	83 c0 01             	add    $0x1,%eax
f01016ed:	eb f0                	jmp    f01016df <strfind+0xa>
			break;
	return (char *) s;
}
f01016ef:	5d                   	pop    %ebp
f01016f0:	c3                   	ret    

f01016f1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01016f1:	55                   	push   %ebp
f01016f2:	89 e5                	mov    %esp,%ebp
f01016f4:	57                   	push   %edi
f01016f5:	56                   	push   %esi
f01016f6:	53                   	push   %ebx
f01016f7:	8b 7d 08             	mov    0x8(%ebp),%edi
f01016fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01016fd:	85 c9                	test   %ecx,%ecx
f01016ff:	74 2f                	je     f0101730 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101701:	89 f8                	mov    %edi,%eax
f0101703:	09 c8                	or     %ecx,%eax
f0101705:	a8 03                	test   $0x3,%al
f0101707:	75 21                	jne    f010172a <memset+0x39>
		c &= 0xFF;
f0101709:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f010170d:	89 d0                	mov    %edx,%eax
f010170f:	c1 e0 08             	shl    $0x8,%eax
f0101712:	89 d3                	mov    %edx,%ebx
f0101714:	c1 e3 18             	shl    $0x18,%ebx
f0101717:	89 d6                	mov    %edx,%esi
f0101719:	c1 e6 10             	shl    $0x10,%esi
f010171c:	09 f3                	or     %esi,%ebx
f010171e:	09 da                	or     %ebx,%edx
f0101720:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0101722:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0101725:	fc                   	cld    
f0101726:	f3 ab                	rep stos %eax,%es:(%edi)
f0101728:	eb 06                	jmp    f0101730 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010172a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010172d:	fc                   	cld    
f010172e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0101730:	89 f8                	mov    %edi,%eax
f0101732:	5b                   	pop    %ebx
f0101733:	5e                   	pop    %esi
f0101734:	5f                   	pop    %edi
f0101735:	5d                   	pop    %ebp
f0101736:	c3                   	ret    

f0101737 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101737:	55                   	push   %ebp
f0101738:	89 e5                	mov    %esp,%ebp
f010173a:	57                   	push   %edi
f010173b:	56                   	push   %esi
f010173c:	8b 45 08             	mov    0x8(%ebp),%eax
f010173f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101742:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101745:	39 c6                	cmp    %eax,%esi
f0101747:	73 32                	jae    f010177b <memmove+0x44>
f0101749:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010174c:	39 c2                	cmp    %eax,%edx
f010174e:	76 2b                	jbe    f010177b <memmove+0x44>
		s += n;
		d += n;
f0101750:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101753:	89 d6                	mov    %edx,%esi
f0101755:	09 fe                	or     %edi,%esi
f0101757:	09 ce                	or     %ecx,%esi
f0101759:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010175f:	75 0e                	jne    f010176f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0101761:	83 ef 04             	sub    $0x4,%edi
f0101764:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101767:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010176a:	fd                   	std    
f010176b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010176d:	eb 09                	jmp    f0101778 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010176f:	83 ef 01             	sub    $0x1,%edi
f0101772:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0101775:	fd                   	std    
f0101776:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101778:	fc                   	cld    
f0101779:	eb 1a                	jmp    f0101795 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010177b:	89 f2                	mov    %esi,%edx
f010177d:	09 c2                	or     %eax,%edx
f010177f:	09 ca                	or     %ecx,%edx
f0101781:	f6 c2 03             	test   $0x3,%dl
f0101784:	75 0a                	jne    f0101790 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0101786:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0101789:	89 c7                	mov    %eax,%edi
f010178b:	fc                   	cld    
f010178c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010178e:	eb 05                	jmp    f0101795 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0101790:	89 c7                	mov    %eax,%edi
f0101792:	fc                   	cld    
f0101793:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101795:	5e                   	pop    %esi
f0101796:	5f                   	pop    %edi
f0101797:	5d                   	pop    %ebp
f0101798:	c3                   	ret    

f0101799 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0101799:	55                   	push   %ebp
f010179a:	89 e5                	mov    %esp,%ebp
f010179c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f010179f:	ff 75 10             	push   0x10(%ebp)
f01017a2:	ff 75 0c             	push   0xc(%ebp)
f01017a5:	ff 75 08             	push   0x8(%ebp)
f01017a8:	e8 8a ff ff ff       	call   f0101737 <memmove>
}
f01017ad:	c9                   	leave  
f01017ae:	c3                   	ret    

f01017af <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01017af:	55                   	push   %ebp
f01017b0:	89 e5                	mov    %esp,%ebp
f01017b2:	56                   	push   %esi
f01017b3:	53                   	push   %ebx
f01017b4:	8b 45 08             	mov    0x8(%ebp),%eax
f01017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
f01017ba:	89 c6                	mov    %eax,%esi
f01017bc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01017bf:	eb 06                	jmp    f01017c7 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01017c1:	83 c0 01             	add    $0x1,%eax
f01017c4:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
f01017c7:	39 f0                	cmp    %esi,%eax
f01017c9:	74 14                	je     f01017df <memcmp+0x30>
		if (*s1 != *s2)
f01017cb:	0f b6 08             	movzbl (%eax),%ecx
f01017ce:	0f b6 1a             	movzbl (%edx),%ebx
f01017d1:	38 d9                	cmp    %bl,%cl
f01017d3:	74 ec                	je     f01017c1 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
f01017d5:	0f b6 c1             	movzbl %cl,%eax
f01017d8:	0f b6 db             	movzbl %bl,%ebx
f01017db:	29 d8                	sub    %ebx,%eax
f01017dd:	eb 05                	jmp    f01017e4 <memcmp+0x35>
	}

	return 0;
f01017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01017e4:	5b                   	pop    %ebx
f01017e5:	5e                   	pop    %esi
f01017e6:	5d                   	pop    %ebp
f01017e7:	c3                   	ret    

f01017e8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01017e8:	55                   	push   %ebp
f01017e9:	89 e5                	mov    %esp,%ebp
f01017eb:	8b 45 08             	mov    0x8(%ebp),%eax
f01017ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01017f1:	89 c2                	mov    %eax,%edx
f01017f3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01017f6:	eb 03                	jmp    f01017fb <memfind+0x13>
f01017f8:	83 c0 01             	add    $0x1,%eax
f01017fb:	39 d0                	cmp    %edx,%eax
f01017fd:	73 04                	jae    f0101803 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01017ff:	38 08                	cmp    %cl,(%eax)
f0101801:	75 f5                	jne    f01017f8 <memfind+0x10>
			break;
	return (void *) s;
}
f0101803:	5d                   	pop    %ebp
f0101804:	c3                   	ret    

f0101805 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101805:	55                   	push   %ebp
f0101806:	89 e5                	mov    %esp,%ebp
f0101808:	57                   	push   %edi
f0101809:	56                   	push   %esi
f010180a:	53                   	push   %ebx
f010180b:	8b 55 08             	mov    0x8(%ebp),%edx
f010180e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101811:	eb 03                	jmp    f0101816 <strtol+0x11>
		s++;
f0101813:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
f0101816:	0f b6 02             	movzbl (%edx),%eax
f0101819:	3c 20                	cmp    $0x20,%al
f010181b:	74 f6                	je     f0101813 <strtol+0xe>
f010181d:	3c 09                	cmp    $0x9,%al
f010181f:	74 f2                	je     f0101813 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0101821:	3c 2b                	cmp    $0x2b,%al
f0101823:	74 2a                	je     f010184f <strtol+0x4a>
	int neg = 0;
f0101825:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f010182a:	3c 2d                	cmp    $0x2d,%al
f010182c:	74 2b                	je     f0101859 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010182e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0101834:	75 0f                	jne    f0101845 <strtol+0x40>
f0101836:	80 3a 30             	cmpb   $0x30,(%edx)
f0101839:	74 28                	je     f0101863 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010183b:	85 db                	test   %ebx,%ebx
f010183d:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101842:	0f 44 d8             	cmove  %eax,%ebx
f0101845:	b9 00 00 00 00       	mov    $0x0,%ecx
f010184a:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010184d:	eb 46                	jmp    f0101895 <strtol+0x90>
		s++;
f010184f:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
f0101852:	bf 00 00 00 00       	mov    $0x0,%edi
f0101857:	eb d5                	jmp    f010182e <strtol+0x29>
		s++, neg = 1;
f0101859:	83 c2 01             	add    $0x1,%edx
f010185c:	bf 01 00 00 00       	mov    $0x1,%edi
f0101861:	eb cb                	jmp    f010182e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101863:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101867:	74 0e                	je     f0101877 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0101869:	85 db                	test   %ebx,%ebx
f010186b:	75 d8                	jne    f0101845 <strtol+0x40>
		s++, base = 8;
f010186d:	83 c2 01             	add    $0x1,%edx
f0101870:	bb 08 00 00 00       	mov    $0x8,%ebx
f0101875:	eb ce                	jmp    f0101845 <strtol+0x40>
		s += 2, base = 16;
f0101877:	83 c2 02             	add    $0x2,%edx
f010187a:	bb 10 00 00 00       	mov    $0x10,%ebx
f010187f:	eb c4                	jmp    f0101845 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0101881:	0f be c0             	movsbl %al,%eax
f0101884:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0101887:	3b 45 10             	cmp    0x10(%ebp),%eax
f010188a:	7d 3a                	jge    f01018c6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010188c:	83 c2 01             	add    $0x1,%edx
f010188f:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0101893:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
f0101895:	0f b6 02             	movzbl (%edx),%eax
f0101898:	8d 70 d0             	lea    -0x30(%eax),%esi
f010189b:	89 f3                	mov    %esi,%ebx
f010189d:	80 fb 09             	cmp    $0x9,%bl
f01018a0:	76 df                	jbe    f0101881 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
f01018a2:	8d 70 9f             	lea    -0x61(%eax),%esi
f01018a5:	89 f3                	mov    %esi,%ebx
f01018a7:	80 fb 19             	cmp    $0x19,%bl
f01018aa:	77 08                	ja     f01018b4 <strtol+0xaf>
			dig = *s - 'a' + 10;
f01018ac:	0f be c0             	movsbl %al,%eax
f01018af:	83 e8 57             	sub    $0x57,%eax
f01018b2:	eb d3                	jmp    f0101887 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
f01018b4:	8d 70 bf             	lea    -0x41(%eax),%esi
f01018b7:	89 f3                	mov    %esi,%ebx
f01018b9:	80 fb 19             	cmp    $0x19,%bl
f01018bc:	77 08                	ja     f01018c6 <strtol+0xc1>
			dig = *s - 'A' + 10;
f01018be:	0f be c0             	movsbl %al,%eax
f01018c1:	83 e8 37             	sub    $0x37,%eax
f01018c4:	eb c1                	jmp    f0101887 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
f01018c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01018ca:	74 05                	je     f01018d1 <strtol+0xcc>
		*endptr = (char *) s;
f01018cc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f01018d1:	89 c8                	mov    %ecx,%eax
f01018d3:	f7 d8                	neg    %eax
f01018d5:	85 ff                	test   %edi,%edi
f01018d7:	0f 45 c8             	cmovne %eax,%ecx
}
f01018da:	89 c8                	mov    %ecx,%eax
f01018dc:	5b                   	pop    %ebx
f01018dd:	5e                   	pop    %esi
f01018de:	5f                   	pop    %edi
f01018df:	5d                   	pop    %ebp
f01018e0:	c3                   	ret    
f01018e1:	66 90                	xchg   %ax,%ax
f01018e3:	66 90                	xchg   %ax,%ax
f01018e5:	66 90                	xchg   %ax,%ax
f01018e7:	66 90                	xchg   %ax,%ax
f01018e9:	66 90                	xchg   %ax,%ax
f01018eb:	66 90                	xchg   %ax,%ax
f01018ed:	66 90                	xchg   %ax,%ax
f01018ef:	90                   	nop

f01018f0 <__udivdi3>:
f01018f0:	f3 0f 1e fb          	endbr32 
f01018f4:	55                   	push   %ebp
f01018f5:	57                   	push   %edi
f01018f6:	56                   	push   %esi
f01018f7:	53                   	push   %ebx
f01018f8:	83 ec 1c             	sub    $0x1c,%esp
f01018fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01018ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0101903:	8b 74 24 34          	mov    0x34(%esp),%esi
f0101907:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f010190b:	85 c0                	test   %eax,%eax
f010190d:	75 19                	jne    f0101928 <__udivdi3+0x38>
f010190f:	39 f3                	cmp    %esi,%ebx
f0101911:	76 4d                	jbe    f0101960 <__udivdi3+0x70>
f0101913:	31 ff                	xor    %edi,%edi
f0101915:	89 e8                	mov    %ebp,%eax
f0101917:	89 f2                	mov    %esi,%edx
f0101919:	f7 f3                	div    %ebx
f010191b:	89 fa                	mov    %edi,%edx
f010191d:	83 c4 1c             	add    $0x1c,%esp
f0101920:	5b                   	pop    %ebx
f0101921:	5e                   	pop    %esi
f0101922:	5f                   	pop    %edi
f0101923:	5d                   	pop    %ebp
f0101924:	c3                   	ret    
f0101925:	8d 76 00             	lea    0x0(%esi),%esi
f0101928:	39 f0                	cmp    %esi,%eax
f010192a:	76 14                	jbe    f0101940 <__udivdi3+0x50>
f010192c:	31 ff                	xor    %edi,%edi
f010192e:	31 c0                	xor    %eax,%eax
f0101930:	89 fa                	mov    %edi,%edx
f0101932:	83 c4 1c             	add    $0x1c,%esp
f0101935:	5b                   	pop    %ebx
f0101936:	5e                   	pop    %esi
f0101937:	5f                   	pop    %edi
f0101938:	5d                   	pop    %ebp
f0101939:	c3                   	ret    
f010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101940:	0f bd f8             	bsr    %eax,%edi
f0101943:	83 f7 1f             	xor    $0x1f,%edi
f0101946:	75 48                	jne    f0101990 <__udivdi3+0xa0>
f0101948:	39 f0                	cmp    %esi,%eax
f010194a:	72 06                	jb     f0101952 <__udivdi3+0x62>
f010194c:	31 c0                	xor    %eax,%eax
f010194e:	39 eb                	cmp    %ebp,%ebx
f0101950:	77 de                	ja     f0101930 <__udivdi3+0x40>
f0101952:	b8 01 00 00 00       	mov    $0x1,%eax
f0101957:	eb d7                	jmp    f0101930 <__udivdi3+0x40>
f0101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101960:	89 d9                	mov    %ebx,%ecx
f0101962:	85 db                	test   %ebx,%ebx
f0101964:	75 0b                	jne    f0101971 <__udivdi3+0x81>
f0101966:	b8 01 00 00 00       	mov    $0x1,%eax
f010196b:	31 d2                	xor    %edx,%edx
f010196d:	f7 f3                	div    %ebx
f010196f:	89 c1                	mov    %eax,%ecx
f0101971:	31 d2                	xor    %edx,%edx
f0101973:	89 f0                	mov    %esi,%eax
f0101975:	f7 f1                	div    %ecx
f0101977:	89 c6                	mov    %eax,%esi
f0101979:	89 e8                	mov    %ebp,%eax
f010197b:	89 f7                	mov    %esi,%edi
f010197d:	f7 f1                	div    %ecx
f010197f:	89 fa                	mov    %edi,%edx
f0101981:	83 c4 1c             	add    $0x1c,%esp
f0101984:	5b                   	pop    %ebx
f0101985:	5e                   	pop    %esi
f0101986:	5f                   	pop    %edi
f0101987:	5d                   	pop    %ebp
f0101988:	c3                   	ret    
f0101989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101990:	89 f9                	mov    %edi,%ecx
f0101992:	ba 20 00 00 00       	mov    $0x20,%edx
f0101997:	29 fa                	sub    %edi,%edx
f0101999:	d3 e0                	shl    %cl,%eax
f010199b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010199f:	89 d1                	mov    %edx,%ecx
f01019a1:	89 d8                	mov    %ebx,%eax
f01019a3:	d3 e8                	shr    %cl,%eax
f01019a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01019a9:	09 c1                	or     %eax,%ecx
f01019ab:	89 f0                	mov    %esi,%eax
f01019ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01019b1:	89 f9                	mov    %edi,%ecx
f01019b3:	d3 e3                	shl    %cl,%ebx
f01019b5:	89 d1                	mov    %edx,%ecx
f01019b7:	d3 e8                	shr    %cl,%eax
f01019b9:	89 f9                	mov    %edi,%ecx
f01019bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01019bf:	89 eb                	mov    %ebp,%ebx
f01019c1:	d3 e6                	shl    %cl,%esi
f01019c3:	89 d1                	mov    %edx,%ecx
f01019c5:	d3 eb                	shr    %cl,%ebx
f01019c7:	09 f3                	or     %esi,%ebx
f01019c9:	89 c6                	mov    %eax,%esi
f01019cb:	89 f2                	mov    %esi,%edx
f01019cd:	89 d8                	mov    %ebx,%eax
f01019cf:	f7 74 24 08          	divl   0x8(%esp)
f01019d3:	89 d6                	mov    %edx,%esi
f01019d5:	89 c3                	mov    %eax,%ebx
f01019d7:	f7 64 24 0c          	mull   0xc(%esp)
f01019db:	39 d6                	cmp    %edx,%esi
f01019dd:	72 19                	jb     f01019f8 <__udivdi3+0x108>
f01019df:	89 f9                	mov    %edi,%ecx
f01019e1:	d3 e5                	shl    %cl,%ebp
f01019e3:	39 c5                	cmp    %eax,%ebp
f01019e5:	73 04                	jae    f01019eb <__udivdi3+0xfb>
f01019e7:	39 d6                	cmp    %edx,%esi
f01019e9:	74 0d                	je     f01019f8 <__udivdi3+0x108>
f01019eb:	89 d8                	mov    %ebx,%eax
f01019ed:	31 ff                	xor    %edi,%edi
f01019ef:	e9 3c ff ff ff       	jmp    f0101930 <__udivdi3+0x40>
f01019f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01019f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01019fb:	31 ff                	xor    %edi,%edi
f01019fd:	e9 2e ff ff ff       	jmp    f0101930 <__udivdi3+0x40>
f0101a02:	66 90                	xchg   %ax,%ax
f0101a04:	66 90                	xchg   %ax,%ax
f0101a06:	66 90                	xchg   %ax,%ax
f0101a08:	66 90                	xchg   %ax,%ax
f0101a0a:	66 90                	xchg   %ax,%ax
f0101a0c:	66 90                	xchg   %ax,%ax
f0101a0e:	66 90                	xchg   %ax,%ax

f0101a10 <__umoddi3>:
f0101a10:	f3 0f 1e fb          	endbr32 
f0101a14:	55                   	push   %ebp
f0101a15:	57                   	push   %edi
f0101a16:	56                   	push   %esi
f0101a17:	53                   	push   %ebx
f0101a18:	83 ec 1c             	sub    $0x1c,%esp
f0101a1b:	8b 74 24 30          	mov    0x30(%esp),%esi
f0101a1f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0101a23:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
f0101a27:	8b 6c 24 38          	mov    0x38(%esp),%ebp
f0101a2b:	89 f0                	mov    %esi,%eax
f0101a2d:	89 da                	mov    %ebx,%edx
f0101a2f:	85 ff                	test   %edi,%edi
f0101a31:	75 15                	jne    f0101a48 <__umoddi3+0x38>
f0101a33:	39 dd                	cmp    %ebx,%ebp
f0101a35:	76 39                	jbe    f0101a70 <__umoddi3+0x60>
f0101a37:	f7 f5                	div    %ebp
f0101a39:	89 d0                	mov    %edx,%eax
f0101a3b:	31 d2                	xor    %edx,%edx
f0101a3d:	83 c4 1c             	add    $0x1c,%esp
f0101a40:	5b                   	pop    %ebx
f0101a41:	5e                   	pop    %esi
f0101a42:	5f                   	pop    %edi
f0101a43:	5d                   	pop    %ebp
f0101a44:	c3                   	ret    
f0101a45:	8d 76 00             	lea    0x0(%esi),%esi
f0101a48:	39 df                	cmp    %ebx,%edi
f0101a4a:	77 f1                	ja     f0101a3d <__umoddi3+0x2d>
f0101a4c:	0f bd cf             	bsr    %edi,%ecx
f0101a4f:	83 f1 1f             	xor    $0x1f,%ecx
f0101a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101a56:	75 40                	jne    f0101a98 <__umoddi3+0x88>
f0101a58:	39 df                	cmp    %ebx,%edi
f0101a5a:	72 04                	jb     f0101a60 <__umoddi3+0x50>
f0101a5c:	39 f5                	cmp    %esi,%ebp
f0101a5e:	77 dd                	ja     f0101a3d <__umoddi3+0x2d>
f0101a60:	89 da                	mov    %ebx,%edx
f0101a62:	89 f0                	mov    %esi,%eax
f0101a64:	29 e8                	sub    %ebp,%eax
f0101a66:	19 fa                	sbb    %edi,%edx
f0101a68:	eb d3                	jmp    f0101a3d <__umoddi3+0x2d>
f0101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101a70:	89 e9                	mov    %ebp,%ecx
f0101a72:	85 ed                	test   %ebp,%ebp
f0101a74:	75 0b                	jne    f0101a81 <__umoddi3+0x71>
f0101a76:	b8 01 00 00 00       	mov    $0x1,%eax
f0101a7b:	31 d2                	xor    %edx,%edx
f0101a7d:	f7 f5                	div    %ebp
f0101a7f:	89 c1                	mov    %eax,%ecx
f0101a81:	89 d8                	mov    %ebx,%eax
f0101a83:	31 d2                	xor    %edx,%edx
f0101a85:	f7 f1                	div    %ecx
f0101a87:	89 f0                	mov    %esi,%eax
f0101a89:	f7 f1                	div    %ecx
f0101a8b:	89 d0                	mov    %edx,%eax
f0101a8d:	31 d2                	xor    %edx,%edx
f0101a8f:	eb ac                	jmp    f0101a3d <__umoddi3+0x2d>
f0101a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101a98:	8b 44 24 04          	mov    0x4(%esp),%eax
f0101a9c:	ba 20 00 00 00       	mov    $0x20,%edx
f0101aa1:	29 c2                	sub    %eax,%edx
f0101aa3:	89 c1                	mov    %eax,%ecx
f0101aa5:	89 e8                	mov    %ebp,%eax
f0101aa7:	d3 e7                	shl    %cl,%edi
f0101aa9:	89 d1                	mov    %edx,%ecx
f0101aab:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101aaf:	d3 e8                	shr    %cl,%eax
f0101ab1:	89 c1                	mov    %eax,%ecx
f0101ab3:	8b 44 24 04          	mov    0x4(%esp),%eax
f0101ab7:	09 f9                	or     %edi,%ecx
f0101ab9:	89 df                	mov    %ebx,%edi
f0101abb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101abf:	89 c1                	mov    %eax,%ecx
f0101ac1:	d3 e5                	shl    %cl,%ebp
f0101ac3:	89 d1                	mov    %edx,%ecx
f0101ac5:	d3 ef                	shr    %cl,%edi
f0101ac7:	89 c1                	mov    %eax,%ecx
f0101ac9:	89 f0                	mov    %esi,%eax
f0101acb:	d3 e3                	shl    %cl,%ebx
f0101acd:	89 d1                	mov    %edx,%ecx
f0101acf:	89 fa                	mov    %edi,%edx
f0101ad1:	d3 e8                	shr    %cl,%eax
f0101ad3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0101ad8:	09 d8                	or     %ebx,%eax
f0101ada:	f7 74 24 08          	divl   0x8(%esp)
f0101ade:	89 d3                	mov    %edx,%ebx
f0101ae0:	d3 e6                	shl    %cl,%esi
f0101ae2:	f7 e5                	mul    %ebp
f0101ae4:	89 c7                	mov    %eax,%edi
f0101ae6:	89 d1                	mov    %edx,%ecx
f0101ae8:	39 d3                	cmp    %edx,%ebx
f0101aea:	72 06                	jb     f0101af2 <__umoddi3+0xe2>
f0101aec:	75 0e                	jne    f0101afc <__umoddi3+0xec>
f0101aee:	39 c6                	cmp    %eax,%esi
f0101af0:	73 0a                	jae    f0101afc <__umoddi3+0xec>
f0101af2:	29 e8                	sub    %ebp,%eax
f0101af4:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0101af8:	89 d1                	mov    %edx,%ecx
f0101afa:	89 c7                	mov    %eax,%edi
f0101afc:	89 f5                	mov    %esi,%ebp
f0101afe:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101b02:	29 fd                	sub    %edi,%ebp
f0101b04:	19 cb                	sbb    %ecx,%ebx
f0101b06:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0101b0b:	89 d8                	mov    %ebx,%eax
f0101b0d:	d3 e0                	shl    %cl,%eax
f0101b0f:	89 f1                	mov    %esi,%ecx
f0101b11:	d3 ed                	shr    %cl,%ebp
f0101b13:	d3 eb                	shr    %cl,%ebx
f0101b15:	09 e8                	or     %ebp,%eax
f0101b17:	89 da                	mov    %ebx,%edx
f0101b19:	83 c4 1c             	add    $0x1c,%esp
f0101b1c:	5b                   	pop    %ebx
f0101b1d:	5e                   	pop    %esi
f0101b1e:	5f                   	pop    %edi
f0101b1f:	5d                   	pop    %ebp
f0101b20:	c3                   	ret    
