
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
f0100015:	b8 00 00 18 00       	mov    $0x180000,%eax
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
f0100034:	bc 00 b0 11 f0       	mov    $0xf011b000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/trap.h>


void
i386_init(void)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 08             	sub    $0x8,%esp
f0100047:	e8 1b 01 00 00       	call   f0100167 <__x86.get_pc_thunk.bx>
f010004c:	81 c3 1c f8 07 00    	add    $0x7f81c,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100052:	c7 c0 20 20 18 f0    	mov    $0xf0182020,%eax
f0100058:	c7 c2 00 11 18 f0    	mov    $0xf0181100,%edx
f010005e:	29 d0                	sub    %edx,%eax
f0100060:	50                   	push   %eax
f0100061:	6a 00                	push   $0x0
f0100063:	52                   	push   %edx
f0100064:	e8 59 50 00 00       	call   f01050c2 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100069:	e8 4f 05 00 00       	call   f01005bd <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010006e:	83 c4 08             	add    $0x8,%esp
f0100071:	68 ac 1a 00 00       	push   $0x1aac
f0100076:	8d 83 98 5c f8 ff    	lea    -0x7a368(%ebx),%eax
f010007c:	50                   	push   %eax
f010007d:	e8 a3 39 00 00       	call   f0103a25 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100082:	e8 e2 12 00 00       	call   f0101369 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f0100087:	e8 f6 32 00 00       	call   f0103382 <env_init>
	trap_init();
f010008c:	e8 47 3a 00 00       	call   f0103ad8 <trap_init>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100091:	83 c4 08             	add    $0x8,%esp
f0100094:	6a 00                	push   $0x0
f0100096:	ff b3 f4 ff ff ff    	push   -0xc(%ebx)
f010009c:	e8 b5 34 00 00       	call   f0103556 <env_create>
	// Touch all you want.
	ENV_CREATE(user_hello, ENV_TYPE_USER);
#endif // TEST*

	// We only have one user environment for now, so just run it.
	env_run(&envs[0]);
f01000a1:	83 c4 04             	add    $0x4,%esp
f01000a4:	c7 c0 78 13 18 f0    	mov    $0xf0181378,%eax
f01000aa:	ff 30                	push   (%eax)
f01000ac:	e8 78 38 00 00       	call   f0103929 <env_run>

f01000b1 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f01000b1:	55                   	push   %ebp
f01000b2:	89 e5                	mov    %esp,%ebp
f01000b4:	56                   	push   %esi
f01000b5:	53                   	push   %ebx
f01000b6:	e8 ac 00 00 00       	call   f0100167 <__x86.get_pc_thunk.bx>
f01000bb:	81 c3 ad f7 07 00    	add    $0x7f7ad,%ebx
	va_list ap;

	if (panicstr)
f01000c1:	83 bb 98 18 00 00 00 	cmpl   $0x0,0x1898(%ebx)
f01000c8:	74 0f                	je     f01000d9 <_panic+0x28>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000ca:	83 ec 0c             	sub    $0xc,%esp
f01000cd:	6a 00                	push   $0x0
f01000cf:	e8 f8 07 00 00       	call   f01008cc <monitor>
f01000d4:	83 c4 10             	add    $0x10,%esp
f01000d7:	eb f1                	jmp    f01000ca <_panic+0x19>
	panicstr = fmt;
f01000d9:	8b 45 10             	mov    0x10(%ebp),%eax
f01000dc:	89 83 98 18 00 00    	mov    %eax,0x1898(%ebx)
	asm volatile("cli; cld");
f01000e2:	fa                   	cli    
f01000e3:	fc                   	cld    
	va_start(ap, fmt);
f01000e4:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000e7:	83 ec 04             	sub    $0x4,%esp
f01000ea:	ff 75 0c             	push   0xc(%ebp)
f01000ed:	ff 75 08             	push   0x8(%ebp)
f01000f0:	8d 83 b3 5c f8 ff    	lea    -0x7a34d(%ebx),%eax
f01000f6:	50                   	push   %eax
f01000f7:	e8 29 39 00 00       	call   f0103a25 <cprintf>
	vcprintf(fmt, ap);
f01000fc:	83 c4 08             	add    $0x8,%esp
f01000ff:	56                   	push   %esi
f0100100:	ff 75 10             	push   0x10(%ebp)
f0100103:	e8 e6 38 00 00       	call   f01039ee <vcprintf>
	cprintf("\n");
f0100108:	8d 83 60 64 f8 ff    	lea    -0x79ba0(%ebx),%eax
f010010e:	89 04 24             	mov    %eax,(%esp)
f0100111:	e8 0f 39 00 00       	call   f0103a25 <cprintf>
f0100116:	83 c4 10             	add    $0x10,%esp
f0100119:	eb af                	jmp    f01000ca <_panic+0x19>

f010011b <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010011b:	55                   	push   %ebp
f010011c:	89 e5                	mov    %esp,%ebp
f010011e:	56                   	push   %esi
f010011f:	53                   	push   %ebx
f0100120:	e8 42 00 00 00       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100125:	81 c3 43 f7 07 00    	add    $0x7f743,%ebx
	va_list ap;

	va_start(ap, fmt);
f010012b:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f010012e:	83 ec 04             	sub    $0x4,%esp
f0100131:	ff 75 0c             	push   0xc(%ebp)
f0100134:	ff 75 08             	push   0x8(%ebp)
f0100137:	8d 83 cb 5c f8 ff    	lea    -0x7a335(%ebx),%eax
f010013d:	50                   	push   %eax
f010013e:	e8 e2 38 00 00       	call   f0103a25 <cprintf>
	vcprintf(fmt, ap);
f0100143:	83 c4 08             	add    $0x8,%esp
f0100146:	56                   	push   %esi
f0100147:	ff 75 10             	push   0x10(%ebp)
f010014a:	e8 9f 38 00 00       	call   f01039ee <vcprintf>
	cprintf("\n");
f010014f:	8d 83 60 64 f8 ff    	lea    -0x79ba0(%ebx),%eax
f0100155:	89 04 24             	mov    %eax,(%esp)
f0100158:	e8 c8 38 00 00       	call   f0103a25 <cprintf>
	va_end(ap);
}
f010015d:	83 c4 10             	add    $0x10,%esp
f0100160:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100163:	5b                   	pop    %ebx
f0100164:	5e                   	pop    %esi
f0100165:	5d                   	pop    %ebp
f0100166:	c3                   	ret    

f0100167 <__x86.get_pc_thunk.bx>:
f0100167:	8b 1c 24             	mov    (%esp),%ebx
f010016a:	c3                   	ret    

f010016b <serial_proc_data>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010016b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100170:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100171:	a8 01                	test   $0x1,%al
f0100173:	74 0a                	je     f010017f <serial_proc_data+0x14>
f0100175:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010017a:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010017b:	0f b6 c0             	movzbl %al,%eax
f010017e:	c3                   	ret    
		return -1;
f010017f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100184:	c3                   	ret    

f0100185 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100185:	55                   	push   %ebp
f0100186:	89 e5                	mov    %esp,%ebp
f0100188:	57                   	push   %edi
f0100189:	56                   	push   %esi
f010018a:	53                   	push   %ebx
f010018b:	83 ec 1c             	sub    $0x1c,%esp
f010018e:	e8 6a 05 00 00       	call   f01006fd <__x86.get_pc_thunk.si>
f0100193:	81 c6 d5 f6 07 00    	add    $0x7f6d5,%esi
f0100199:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f010019b:	8d 1d d8 18 00 00    	lea    0x18d8,%ebx
f01001a1:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01001a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	while ((c = (*proc)()) != -1) {
f01001aa:	eb 25                	jmp    f01001d1 <cons_intr+0x4c>
		cons.buf[cons.wpos++] = c;
f01001ac:	8b 8c 1e 04 02 00 00 	mov    0x204(%esi,%ebx,1),%ecx
f01001b3:	8d 51 01             	lea    0x1(%ecx),%edx
f01001b6:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01001b9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f01001bc:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01001c2:	b8 00 00 00 00       	mov    $0x0,%eax
f01001c7:	0f 44 d0             	cmove  %eax,%edx
f01001ca:	89 94 1e 04 02 00 00 	mov    %edx,0x204(%esi,%ebx,1)
	while ((c = (*proc)()) != -1) {
f01001d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01001d4:	ff d0                	call   *%eax
f01001d6:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001d9:	74 06                	je     f01001e1 <cons_intr+0x5c>
		if (c == 0)
f01001db:	85 c0                	test   %eax,%eax
f01001dd:	75 cd                	jne    f01001ac <cons_intr+0x27>
f01001df:	eb f0                	jmp    f01001d1 <cons_intr+0x4c>
	}
}
f01001e1:	83 c4 1c             	add    $0x1c,%esp
f01001e4:	5b                   	pop    %ebx
f01001e5:	5e                   	pop    %esi
f01001e6:	5f                   	pop    %edi
f01001e7:	5d                   	pop    %ebp
f01001e8:	c3                   	ret    

f01001e9 <kbd_proc_data>:
{
f01001e9:	55                   	push   %ebp
f01001ea:	89 e5                	mov    %esp,%ebp
f01001ec:	56                   	push   %esi
f01001ed:	53                   	push   %ebx
f01001ee:	e8 74 ff ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01001f3:	81 c3 75 f6 07 00    	add    $0x7f675,%ebx
f01001f9:	ba 64 00 00 00       	mov    $0x64,%edx
f01001fe:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01001ff:	a8 01                	test   $0x1,%al
f0100201:	0f 84 f7 00 00 00    	je     f01002fe <kbd_proc_data+0x115>
	if (stat & KBS_TERR)
f0100207:	a8 20                	test   $0x20,%al
f0100209:	0f 85 f6 00 00 00    	jne    f0100305 <kbd_proc_data+0x11c>
f010020f:	ba 60 00 00 00       	mov    $0x60,%edx
f0100214:	ec                   	in     (%dx),%al
f0100215:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100217:	3c e0                	cmp    $0xe0,%al
f0100219:	74 64                	je     f010027f <kbd_proc_data+0x96>
	} else if (data & 0x80) {
f010021b:	84 c0                	test   %al,%al
f010021d:	78 75                	js     f0100294 <kbd_proc_data+0xab>
	} else if (shift & E0ESC) {
f010021f:	8b 8b b8 18 00 00    	mov    0x18b8(%ebx),%ecx
f0100225:	f6 c1 40             	test   $0x40,%cl
f0100228:	74 0e                	je     f0100238 <kbd_proc_data+0x4f>
		data |= 0x80;
f010022a:	83 c8 80             	or     $0xffffff80,%eax
f010022d:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010022f:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100232:	89 8b b8 18 00 00    	mov    %ecx,0x18b8(%ebx)
	shift |= shiftcode[data];
f0100238:	0f b6 d2             	movzbl %dl,%edx
f010023b:	0f b6 84 13 18 5e f8 	movzbl -0x7a1e8(%ebx,%edx,1),%eax
f0100242:	ff 
f0100243:	0b 83 b8 18 00 00    	or     0x18b8(%ebx),%eax
	shift ^= togglecode[data];
f0100249:	0f b6 8c 13 18 5d f8 	movzbl -0x7a2e8(%ebx,%edx,1),%ecx
f0100250:	ff 
f0100251:	31 c8                	xor    %ecx,%eax
f0100253:	89 83 b8 18 00 00    	mov    %eax,0x18b8(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100259:	89 c1                	mov    %eax,%ecx
f010025b:	83 e1 03             	and    $0x3,%ecx
f010025e:	8b 8c 8b b8 17 00 00 	mov    0x17b8(%ebx,%ecx,4),%ecx
f0100265:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100269:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f010026c:	a8 08                	test   $0x8,%al
f010026e:	74 61                	je     f01002d1 <kbd_proc_data+0xe8>
		if ('a' <= c && c <= 'z')
f0100270:	89 f2                	mov    %esi,%edx
f0100272:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f0100275:	83 f9 19             	cmp    $0x19,%ecx
f0100278:	77 4b                	ja     f01002c5 <kbd_proc_data+0xdc>
			c += 'A' - 'a';
f010027a:	83 ee 20             	sub    $0x20,%esi
f010027d:	eb 0c                	jmp    f010028b <kbd_proc_data+0xa2>
		shift |= E0ESC;
f010027f:	83 8b b8 18 00 00 40 	orl    $0x40,0x18b8(%ebx)
		return 0;
f0100286:	be 00 00 00 00       	mov    $0x0,%esi
}
f010028b:	89 f0                	mov    %esi,%eax
f010028d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100290:	5b                   	pop    %ebx
f0100291:	5e                   	pop    %esi
f0100292:	5d                   	pop    %ebp
f0100293:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100294:	8b 8b b8 18 00 00    	mov    0x18b8(%ebx),%ecx
f010029a:	83 e0 7f             	and    $0x7f,%eax
f010029d:	f6 c1 40             	test   $0x40,%cl
f01002a0:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002a3:	0f b6 d2             	movzbl %dl,%edx
f01002a6:	0f b6 84 13 18 5e f8 	movzbl -0x7a1e8(%ebx,%edx,1),%eax
f01002ad:	ff 
f01002ae:	83 c8 40             	or     $0x40,%eax
f01002b1:	0f b6 c0             	movzbl %al,%eax
f01002b4:	f7 d0                	not    %eax
f01002b6:	21 c8                	and    %ecx,%eax
f01002b8:	89 83 b8 18 00 00    	mov    %eax,0x18b8(%ebx)
		return 0;
f01002be:	be 00 00 00 00       	mov    $0x0,%esi
f01002c3:	eb c6                	jmp    f010028b <kbd_proc_data+0xa2>
		else if ('A' <= c && c <= 'Z')
f01002c5:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002c8:	8d 4e 20             	lea    0x20(%esi),%ecx
f01002cb:	83 fa 1a             	cmp    $0x1a,%edx
f01002ce:	0f 42 f1             	cmovb  %ecx,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01002d1:	f7 d0                	not    %eax
f01002d3:	a8 06                	test   $0x6,%al
f01002d5:	75 b4                	jne    f010028b <kbd_proc_data+0xa2>
f01002d7:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f01002dd:	75 ac                	jne    f010028b <kbd_proc_data+0xa2>
		cprintf("Rebooting!\n");
f01002df:	83 ec 0c             	sub    $0xc,%esp
f01002e2:	8d 83 e5 5c f8 ff    	lea    -0x7a31b(%ebx),%eax
f01002e8:	50                   	push   %eax
f01002e9:	e8 37 37 00 00       	call   f0103a25 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002ee:	b8 03 00 00 00       	mov    $0x3,%eax
f01002f3:	ba 92 00 00 00       	mov    $0x92,%edx
f01002f8:	ee                   	out    %al,(%dx)
}
f01002f9:	83 c4 10             	add    $0x10,%esp
f01002fc:	eb 8d                	jmp    f010028b <kbd_proc_data+0xa2>
		return -1;
f01002fe:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100303:	eb 86                	jmp    f010028b <kbd_proc_data+0xa2>
		return -1;
f0100305:	be ff ff ff ff       	mov    $0xffffffff,%esi
f010030a:	e9 7c ff ff ff       	jmp    f010028b <kbd_proc_data+0xa2>

f010030f <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010030f:	55                   	push   %ebp
f0100310:	89 e5                	mov    %esp,%ebp
f0100312:	57                   	push   %edi
f0100313:	56                   	push   %esi
f0100314:	53                   	push   %ebx
f0100315:	83 ec 1c             	sub    $0x1c,%esp
f0100318:	e8 4a fe ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f010031d:	81 c3 4b f5 07 00    	add    $0x7f54b,%ebx
f0100323:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
f0100326:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010032b:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100330:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100335:	89 fa                	mov    %edi,%edx
f0100337:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100338:	a8 20                	test   $0x20,%al
f010033a:	75 13                	jne    f010034f <cons_putc+0x40>
f010033c:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100342:	7f 0b                	jg     f010034f <cons_putc+0x40>
f0100344:	89 ca                	mov    %ecx,%edx
f0100346:	ec                   	in     (%dx),%al
f0100347:	ec                   	in     (%dx),%al
f0100348:	ec                   	in     (%dx),%al
f0100349:	ec                   	in     (%dx),%al
	     i++)
f010034a:	83 c6 01             	add    $0x1,%esi
f010034d:	eb e6                	jmp    f0100335 <cons_putc+0x26>
	outb(COM1 + COM_TX, c);
f010034f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f0100353:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100356:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010035b:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010035c:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100361:	bf 79 03 00 00       	mov    $0x379,%edi
f0100366:	b9 84 00 00 00       	mov    $0x84,%ecx
f010036b:	89 fa                	mov    %edi,%edx
f010036d:	ec                   	in     (%dx),%al
f010036e:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100374:	7f 0f                	jg     f0100385 <cons_putc+0x76>
f0100376:	84 c0                	test   %al,%al
f0100378:	78 0b                	js     f0100385 <cons_putc+0x76>
f010037a:	89 ca                	mov    %ecx,%edx
f010037c:	ec                   	in     (%dx),%al
f010037d:	ec                   	in     (%dx),%al
f010037e:	ec                   	in     (%dx),%al
f010037f:	ec                   	in     (%dx),%al
f0100380:	83 c6 01             	add    $0x1,%esi
f0100383:	eb e6                	jmp    f010036b <cons_putc+0x5c>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100385:	ba 78 03 00 00       	mov    $0x378,%edx
f010038a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f010038e:	ee                   	out    %al,(%dx)
f010038f:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100394:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100399:	ee                   	out    %al,(%dx)
f010039a:	b8 08 00 00 00       	mov    $0x8,%eax
f010039f:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f01003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01003a3:	89 f8                	mov    %edi,%eax
f01003a5:	80 cc 07             	or     $0x7,%ah
f01003a8:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f01003ae:	0f 45 c7             	cmovne %edi,%eax
f01003b1:	89 c7                	mov    %eax,%edi
f01003b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
f01003b6:	0f b6 c0             	movzbl %al,%eax
f01003b9:	89 f9                	mov    %edi,%ecx
f01003bb:	80 f9 0a             	cmp    $0xa,%cl
f01003be:	0f 84 e4 00 00 00    	je     f01004a8 <cons_putc+0x199>
f01003c4:	83 f8 0a             	cmp    $0xa,%eax
f01003c7:	7f 46                	jg     f010040f <cons_putc+0x100>
f01003c9:	83 f8 08             	cmp    $0x8,%eax
f01003cc:	0f 84 a8 00 00 00    	je     f010047a <cons_putc+0x16b>
f01003d2:	83 f8 09             	cmp    $0x9,%eax
f01003d5:	0f 85 da 00 00 00    	jne    f01004b5 <cons_putc+0x1a6>
		cons_putc(' ');
f01003db:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e0:	e8 2a ff ff ff       	call   f010030f <cons_putc>
		cons_putc(' ');
f01003e5:	b8 20 00 00 00       	mov    $0x20,%eax
f01003ea:	e8 20 ff ff ff       	call   f010030f <cons_putc>
		cons_putc(' ');
f01003ef:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f4:	e8 16 ff ff ff       	call   f010030f <cons_putc>
		cons_putc(' ');
f01003f9:	b8 20 00 00 00       	mov    $0x20,%eax
f01003fe:	e8 0c ff ff ff       	call   f010030f <cons_putc>
		cons_putc(' ');
f0100403:	b8 20 00 00 00       	mov    $0x20,%eax
f0100408:	e8 02 ff ff ff       	call   f010030f <cons_putc>
		break;
f010040d:	eb 26                	jmp    f0100435 <cons_putc+0x126>
	switch (c & 0xff) {
f010040f:	83 f8 0d             	cmp    $0xd,%eax
f0100412:	0f 85 9d 00 00 00    	jne    f01004b5 <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
f0100418:	0f b7 83 e0 1a 00 00 	movzwl 0x1ae0(%ebx),%eax
f010041f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100425:	c1 e8 16             	shr    $0x16,%eax
f0100428:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010042b:	c1 e0 04             	shl    $0x4,%eax
f010042e:	66 89 83 e0 1a 00 00 	mov    %ax,0x1ae0(%ebx)
	if (crt_pos >= CRT_SIZE) {
f0100435:	66 81 bb e0 1a 00 00 	cmpw   $0x7cf,0x1ae0(%ebx)
f010043c:	cf 07 
f010043e:	0f 87 98 00 00 00    	ja     f01004dc <cons_putc+0x1cd>
	outb(addr_6845, 14);
f0100444:	8b 8b e8 1a 00 00    	mov    0x1ae8(%ebx),%ecx
f010044a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010044f:	89 ca                	mov    %ecx,%edx
f0100451:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100452:	0f b7 9b e0 1a 00 00 	movzwl 0x1ae0(%ebx),%ebx
f0100459:	8d 71 01             	lea    0x1(%ecx),%esi
f010045c:	89 d8                	mov    %ebx,%eax
f010045e:	66 c1 e8 08          	shr    $0x8,%ax
f0100462:	89 f2                	mov    %esi,%edx
f0100464:	ee                   	out    %al,(%dx)
f0100465:	b8 0f 00 00 00       	mov    $0xf,%eax
f010046a:	89 ca                	mov    %ecx,%edx
f010046c:	ee                   	out    %al,(%dx)
f010046d:	89 d8                	mov    %ebx,%eax
f010046f:	89 f2                	mov    %esi,%edx
f0100471:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100472:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100475:	5b                   	pop    %ebx
f0100476:	5e                   	pop    %esi
f0100477:	5f                   	pop    %edi
f0100478:	5d                   	pop    %ebp
f0100479:	c3                   	ret    
		if (crt_pos > 0) {
f010047a:	0f b7 83 e0 1a 00 00 	movzwl 0x1ae0(%ebx),%eax
f0100481:	66 85 c0             	test   %ax,%ax
f0100484:	74 be                	je     f0100444 <cons_putc+0x135>
			crt_pos--;
f0100486:	83 e8 01             	sub    $0x1,%eax
f0100489:	66 89 83 e0 1a 00 00 	mov    %ax,0x1ae0(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100490:	0f b7 c0             	movzwl %ax,%eax
f0100493:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f0100497:	b2 00                	mov    $0x0,%dl
f0100499:	83 ca 20             	or     $0x20,%edx
f010049c:	8b 8b e4 1a 00 00    	mov    0x1ae4(%ebx),%ecx
f01004a2:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f01004a6:	eb 8d                	jmp    f0100435 <cons_putc+0x126>
		crt_pos += CRT_COLS;
f01004a8:	66 83 83 e0 1a 00 00 	addw   $0x50,0x1ae0(%ebx)
f01004af:	50 
f01004b0:	e9 63 ff ff ff       	jmp    f0100418 <cons_putc+0x109>
		crt_buf[crt_pos++] = c;		/* write the character */
f01004b5:	0f b7 83 e0 1a 00 00 	movzwl 0x1ae0(%ebx),%eax
f01004bc:	8d 50 01             	lea    0x1(%eax),%edx
f01004bf:	66 89 93 e0 1a 00 00 	mov    %dx,0x1ae0(%ebx)
f01004c6:	0f b7 c0             	movzwl %ax,%eax
f01004c9:	8b 93 e4 1a 00 00    	mov    0x1ae4(%ebx),%edx
f01004cf:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01004d3:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f01004d7:	e9 59 ff ff ff       	jmp    f0100435 <cons_putc+0x126>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004dc:	8b 83 e4 1a 00 00    	mov    0x1ae4(%ebx),%eax
f01004e2:	83 ec 04             	sub    $0x4,%esp
f01004e5:	68 00 0f 00 00       	push   $0xf00
f01004ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004f0:	52                   	push   %edx
f01004f1:	50                   	push   %eax
f01004f2:	e8 11 4c 00 00       	call   f0105108 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004f7:	8b 93 e4 1a 00 00    	mov    0x1ae4(%ebx),%edx
f01004fd:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100503:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100509:	83 c4 10             	add    $0x10,%esp
f010050c:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100511:	83 c0 02             	add    $0x2,%eax
f0100514:	39 d0                	cmp    %edx,%eax
f0100516:	75 f4                	jne    f010050c <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f0100518:	66 83 ab e0 1a 00 00 	subw   $0x50,0x1ae0(%ebx)
f010051f:	50 
f0100520:	e9 1f ff ff ff       	jmp    f0100444 <cons_putc+0x135>

f0100525 <serial_intr>:
{
f0100525:	e8 cf 01 00 00       	call   f01006f9 <__x86.get_pc_thunk.ax>
f010052a:	05 3e f3 07 00       	add    $0x7f33e,%eax
	if (serial_exists)
f010052f:	80 b8 ec 1a 00 00 00 	cmpb   $0x0,0x1aec(%eax)
f0100536:	75 01                	jne    f0100539 <serial_intr+0x14>
f0100538:	c3                   	ret    
{
f0100539:	55                   	push   %ebp
f010053a:	89 e5                	mov    %esp,%ebp
f010053c:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010053f:	8d 80 03 09 f8 ff    	lea    -0x7f6fd(%eax),%eax
f0100545:	e8 3b fc ff ff       	call   f0100185 <cons_intr>
}
f010054a:	c9                   	leave  
f010054b:	c3                   	ret    

f010054c <kbd_intr>:
{
f010054c:	55                   	push   %ebp
f010054d:	89 e5                	mov    %esp,%ebp
f010054f:	83 ec 08             	sub    $0x8,%esp
f0100552:	e8 a2 01 00 00       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0100557:	05 11 f3 07 00       	add    $0x7f311,%eax
	cons_intr(kbd_proc_data);
f010055c:	8d 80 81 09 f8 ff    	lea    -0x7f67f(%eax),%eax
f0100562:	e8 1e fc ff ff       	call   f0100185 <cons_intr>
}
f0100567:	c9                   	leave  
f0100568:	c3                   	ret    

f0100569 <cons_getc>:
{
f0100569:	55                   	push   %ebp
f010056a:	89 e5                	mov    %esp,%ebp
f010056c:	53                   	push   %ebx
f010056d:	83 ec 04             	sub    $0x4,%esp
f0100570:	e8 f2 fb ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100575:	81 c3 f3 f2 07 00    	add    $0x7f2f3,%ebx
	serial_intr();
f010057b:	e8 a5 ff ff ff       	call   f0100525 <serial_intr>
	kbd_intr();
f0100580:	e8 c7 ff ff ff       	call   f010054c <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100585:	8b 83 d8 1a 00 00    	mov    0x1ad8(%ebx),%eax
	return 0;
f010058b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100590:	3b 83 dc 1a 00 00    	cmp    0x1adc(%ebx),%eax
f0100596:	74 1e                	je     f01005b6 <cons_getc+0x4d>
		c = cons.buf[cons.rpos++];
f0100598:	8d 48 01             	lea    0x1(%eax),%ecx
f010059b:	0f b6 94 03 d8 18 00 	movzbl 0x18d8(%ebx,%eax,1),%edx
f01005a2:	00 
			cons.rpos = 0;
f01005a3:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f01005a8:	b8 00 00 00 00       	mov    $0x0,%eax
f01005ad:	0f 45 c1             	cmovne %ecx,%eax
f01005b0:	89 83 d8 1a 00 00    	mov    %eax,0x1ad8(%ebx)
}
f01005b6:	89 d0                	mov    %edx,%eax
f01005b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01005bb:	c9                   	leave  
f01005bc:	c3                   	ret    

f01005bd <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005bd:	55                   	push   %ebp
f01005be:	89 e5                	mov    %esp,%ebp
f01005c0:	57                   	push   %edi
f01005c1:	56                   	push   %esi
f01005c2:	53                   	push   %ebx
f01005c3:	83 ec 1c             	sub    $0x1c,%esp
f01005c6:	e8 9c fb ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01005cb:	81 c3 9d f2 07 00    	add    $0x7f29d,%ebx
	was = *cp;
f01005d1:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01005d8:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01005df:	5a a5 
	if (*cp != 0xA55A) {
f01005e1:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01005e8:	b9 b4 03 00 00       	mov    $0x3b4,%ecx
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01005ed:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
	if (*cp != 0xA55A) {
f01005f2:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005f6:	0f 84 ac 00 00 00    	je     f01006a8 <cons_init+0xeb>
		addr_6845 = MONO_BASE;
f01005fc:	89 8b e8 1a 00 00    	mov    %ecx,0x1ae8(%ebx)
f0100602:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100607:	89 ca                	mov    %ecx,%edx
f0100609:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010060a:	8d 71 01             	lea    0x1(%ecx),%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010060d:	89 f2                	mov    %esi,%edx
f010060f:	ec                   	in     (%dx),%al
f0100610:	0f b6 c0             	movzbl %al,%eax
f0100613:	c1 e0 08             	shl    $0x8,%eax
f0100616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100619:	b8 0f 00 00 00       	mov    $0xf,%eax
f010061e:	89 ca                	mov    %ecx,%edx
f0100620:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100621:	89 f2                	mov    %esi,%edx
f0100623:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100624:	89 bb e4 1a 00 00    	mov    %edi,0x1ae4(%ebx)
	pos |= inb(addr_6845 + 1);
f010062a:	0f b6 c0             	movzbl %al,%eax
f010062d:	0b 45 e4             	or     -0x1c(%ebp),%eax
	crt_pos = pos;
f0100630:	66 89 83 e0 1a 00 00 	mov    %ax,0x1ae0(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100637:	b9 00 00 00 00       	mov    $0x0,%ecx
f010063c:	89 c8                	mov    %ecx,%eax
f010063e:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100643:	ee                   	out    %al,(%dx)
f0100644:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100649:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010064e:	89 fa                	mov    %edi,%edx
f0100650:	ee                   	out    %al,(%dx)
f0100651:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100656:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010065b:	ee                   	out    %al,(%dx)
f010065c:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100661:	89 c8                	mov    %ecx,%eax
f0100663:	89 f2                	mov    %esi,%edx
f0100665:	ee                   	out    %al,(%dx)
f0100666:	b8 03 00 00 00       	mov    $0x3,%eax
f010066b:	89 fa                	mov    %edi,%edx
f010066d:	ee                   	out    %al,(%dx)
f010066e:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100673:	89 c8                	mov    %ecx,%eax
f0100675:	ee                   	out    %al,(%dx)
f0100676:	b8 01 00 00 00       	mov    $0x1,%eax
f010067b:	89 f2                	mov    %esi,%edx
f010067d:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010067e:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100683:	ec                   	in     (%dx),%al
f0100684:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100686:	3c ff                	cmp    $0xff,%al
f0100688:	0f 95 83 ec 1a 00 00 	setne  0x1aec(%ebx)
f010068f:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100694:	ec                   	in     (%dx),%al
f0100695:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010069a:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010069b:	80 f9 ff             	cmp    $0xff,%cl
f010069e:	74 1e                	je     f01006be <cons_init+0x101>
		cprintf("Serial port does not exist!\n");
}
f01006a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01006a3:	5b                   	pop    %ebx
f01006a4:	5e                   	pop    %esi
f01006a5:	5f                   	pop    %edi
f01006a6:	5d                   	pop    %ebp
f01006a7:	c3                   	ret    
		*cp = was;
f01006a8:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f01006af:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006b4:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
f01006b9:	e9 3e ff ff ff       	jmp    f01005fc <cons_init+0x3f>
		cprintf("Serial port does not exist!\n");
f01006be:	83 ec 0c             	sub    $0xc,%esp
f01006c1:	8d 83 f1 5c f8 ff    	lea    -0x7a30f(%ebx),%eax
f01006c7:	50                   	push   %eax
f01006c8:	e8 58 33 00 00       	call   f0103a25 <cprintf>
f01006cd:	83 c4 10             	add    $0x10,%esp
}
f01006d0:	eb ce                	jmp    f01006a0 <cons_init+0xe3>

f01006d2 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006d2:	55                   	push   %ebp
f01006d3:	89 e5                	mov    %esp,%ebp
f01006d5:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01006d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01006db:	e8 2f fc ff ff       	call   f010030f <cons_putc>
}
f01006e0:	c9                   	leave  
f01006e1:	c3                   	ret    

f01006e2 <getchar>:

int
getchar(void)
{
f01006e2:	55                   	push   %ebp
f01006e3:	89 e5                	mov    %esp,%ebp
f01006e5:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006e8:	e8 7c fe ff ff       	call   f0100569 <cons_getc>
f01006ed:	85 c0                	test   %eax,%eax
f01006ef:	74 f7                	je     f01006e8 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01006f1:	c9                   	leave  
f01006f2:	c3                   	ret    

f01006f3 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01006f3:	b8 01 00 00 00       	mov    $0x1,%eax
f01006f8:	c3                   	ret    

f01006f9 <__x86.get_pc_thunk.ax>:
f01006f9:	8b 04 24             	mov    (%esp),%eax
f01006fc:	c3                   	ret    

f01006fd <__x86.get_pc_thunk.si>:
f01006fd:	8b 34 24             	mov    (%esp),%esi
f0100700:	c3                   	ret    

f0100701 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100701:	55                   	push   %ebp
f0100702:	89 e5                	mov    %esp,%ebp
f0100704:	56                   	push   %esi
f0100705:	53                   	push   %ebx
f0100706:	e8 5c fa ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f010070b:	81 c3 5d f1 07 00    	add    $0x7f15d,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100711:	83 ec 04             	sub    $0x4,%esp
f0100714:	8d 83 18 5f f8 ff    	lea    -0x7a0e8(%ebx),%eax
f010071a:	50                   	push   %eax
f010071b:	8d 83 36 5f f8 ff    	lea    -0x7a0ca(%ebx),%eax
f0100721:	50                   	push   %eax
f0100722:	8d b3 3b 5f f8 ff    	lea    -0x7a0c5(%ebx),%esi
f0100728:	56                   	push   %esi
f0100729:	e8 f7 32 00 00       	call   f0103a25 <cprintf>
f010072e:	83 c4 0c             	add    $0xc,%esp
f0100731:	8d 83 14 60 f8 ff    	lea    -0x79fec(%ebx),%eax
f0100737:	50                   	push   %eax
f0100738:	8d 83 44 5f f8 ff    	lea    -0x7a0bc(%ebx),%eax
f010073e:	50                   	push   %eax
f010073f:	56                   	push   %esi
f0100740:	e8 e0 32 00 00       	call   f0103a25 <cprintf>
f0100745:	83 c4 0c             	add    $0xc,%esp
f0100748:	8d 83 4d 5f f8 ff    	lea    -0x7a0b3(%ebx),%eax
f010074e:	50                   	push   %eax
f010074f:	8d 83 6a 5f f8 ff    	lea    -0x7a096(%ebx),%eax
f0100755:	50                   	push   %eax
f0100756:	56                   	push   %esi
f0100757:	e8 c9 32 00 00       	call   f0103a25 <cprintf>
	return 0;
}
f010075c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100761:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100764:	5b                   	pop    %ebx
f0100765:	5e                   	pop    %esi
f0100766:	5d                   	pop    %ebp
f0100767:	c3                   	ret    

f0100768 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100768:	55                   	push   %ebp
f0100769:	89 e5                	mov    %esp,%ebp
f010076b:	57                   	push   %edi
f010076c:	56                   	push   %esi
f010076d:	53                   	push   %ebx
f010076e:	83 ec 18             	sub    $0x18,%esp
f0100771:	e8 f1 f9 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100776:	81 c3 f2 f0 07 00    	add    $0x7f0f2,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010077c:	8d 83 78 5f f8 ff    	lea    -0x7a088(%ebx),%eax
f0100782:	50                   	push   %eax
f0100783:	e8 9d 32 00 00       	call   f0103a25 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100788:	83 c4 08             	add    $0x8,%esp
f010078b:	ff b3 f8 ff ff ff    	push   -0x8(%ebx)
f0100791:	8d 83 3c 60 f8 ff    	lea    -0x79fc4(%ebx),%eax
f0100797:	50                   	push   %eax
f0100798:	e8 88 32 00 00       	call   f0103a25 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010079d:	83 c4 0c             	add    $0xc,%esp
f01007a0:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f01007a6:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f01007ac:	50                   	push   %eax
f01007ad:	57                   	push   %edi
f01007ae:	8d 83 64 60 f8 ff    	lea    -0x79f9c(%ebx),%eax
f01007b4:	50                   	push   %eax
f01007b5:	e8 6b 32 00 00       	call   f0103a25 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007ba:	83 c4 0c             	add    $0xc,%esp
f01007bd:	c7 c0 f1 54 10 f0    	mov    $0xf01054f1,%eax
f01007c3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007c9:	52                   	push   %edx
f01007ca:	50                   	push   %eax
f01007cb:	8d 83 88 60 f8 ff    	lea    -0x79f78(%ebx),%eax
f01007d1:	50                   	push   %eax
f01007d2:	e8 4e 32 00 00       	call   f0103a25 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007d7:	83 c4 0c             	add    $0xc,%esp
f01007da:	c7 c0 00 11 18 f0    	mov    $0xf0181100,%eax
f01007e0:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007e6:	52                   	push   %edx
f01007e7:	50                   	push   %eax
f01007e8:	8d 83 ac 60 f8 ff    	lea    -0x79f54(%ebx),%eax
f01007ee:	50                   	push   %eax
f01007ef:	e8 31 32 00 00       	call   f0103a25 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01007f4:	83 c4 0c             	add    $0xc,%esp
f01007f7:	c7 c6 20 20 18 f0    	mov    $0xf0182020,%esi
f01007fd:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0100803:	50                   	push   %eax
f0100804:	56                   	push   %esi
f0100805:	8d 83 d0 60 f8 ff    	lea    -0x79f30(%ebx),%eax
f010080b:	50                   	push   %eax
f010080c:	e8 14 32 00 00       	call   f0103a25 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100811:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024); 
f0100814:	29 fe                	sub    %edi,%esi
f0100816:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f010081c:	c1 fe 0a             	sar    $0xa,%esi
f010081f:	56                   	push   %esi
f0100820:	8d 83 f4 60 f8 ff    	lea    -0x79f0c(%ebx),%eax
f0100826:	50                   	push   %eax
f0100827:	e8 f9 31 00 00       	call   f0103a25 <cprintf>
	return 0;
}
f010082c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100831:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100834:	5b                   	pop    %ebx
f0100835:	5e                   	pop    %esi
f0100836:	5f                   	pop    %edi
f0100837:	5d                   	pop    %ebp
f0100838:	c3                   	ret    

f0100839 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100839:	55                   	push   %ebp
f010083a:	89 e5                	mov    %esp,%ebp
f010083c:	57                   	push   %edi
f010083d:	56                   	push   %esi
f010083e:	53                   	push   %ebx
f010083f:	83 ec 48             	sub    $0x48,%esp
f0100842:	e8 20 f9 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100847:	81 c3 21 f0 07 00    	add    $0x7f021,%ebx
	// Your code here.

	cprintf("Stack backtrace:\n");
f010084d:	8d 83 91 5f f8 ff    	lea    -0x7a06f(%ebx),%eax
f0100853:	50                   	push   %eax
f0100854:	e8 cc 31 00 00       	call   f0103a25 <cprintf>

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100859:	89 ee                	mov    %ebp,%esi
	uint32_t ebp,eip;
	struct Eipdebuginfo info;
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f010085b:	83 c4 10             	add    $0x10,%esp
	{
		eip = *((uint32_t *)ebp+1);
		
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",ebp,*((uint32_t *)ebp+1),
f010085e:	8d 83 20 61 f8 ff    	lea    -0x79ee0(%ebx),%eax
f0100864:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*((uint32_t *)ebp+2),*((uint32_t *)ebp+3),*((uint32_t *)ebp+4),*((uint32_t *)ebp+5),
		*((uint32_t *)ebp+6));

		debuginfo_eip(eip,&info);

		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f0100867:	8d 83 a3 5f f8 ff    	lea    -0x7a05d(%ebx),%eax
f010086d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f0100870:	eb 49                	jmp    f01008bb <mon_backtrace+0x82>
		eip = *((uint32_t *)ebp+1);
f0100872:	8b 7e 04             	mov    0x4(%esi),%edi
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",ebp,*((uint32_t *)ebp+1),
f0100875:	ff 76 18             	push   0x18(%esi)
f0100878:	ff 76 14             	push   0x14(%esi)
f010087b:	ff 76 10             	push   0x10(%esi)
f010087e:	ff 76 0c             	push   0xc(%esi)
f0100881:	ff 76 08             	push   0x8(%esi)
f0100884:	57                   	push   %edi
f0100885:	56                   	push   %esi
f0100886:	ff 75 c4             	push   -0x3c(%ebp)
f0100889:	e8 97 31 00 00       	call   f0103a25 <cprintf>
		debuginfo_eip(eip,&info);
f010088e:	83 c4 18             	add    $0x18,%esp
f0100891:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100894:	50                   	push   %eax
f0100895:	57                   	push   %edi
f0100896:	e8 c8 3c 00 00       	call   f0104563 <debuginfo_eip>
		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f010089b:	83 c4 08             	add    $0x8,%esp
f010089e:	2b 7d e0             	sub    -0x20(%ebp),%edi
f01008a1:	57                   	push   %edi
f01008a2:	ff 75 d8             	push   -0x28(%ebp)
f01008a5:	ff 75 dc             	push   -0x24(%ebp)
f01008a8:	ff 75 d4             	push   -0x2c(%ebp)
f01008ab:	ff 75 d0             	push   -0x30(%ebp)
f01008ae:	ff 75 c0             	push   -0x40(%ebp)
f01008b1:	e8 6f 31 00 00       	call   f0103a25 <cprintf>
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f01008b6:	8b 36                	mov    (%esi),%esi
f01008b8:	83 c4 20             	add    $0x20,%esp
f01008bb:	85 f6                	test   %esi,%esi
f01008bd:	75 b3                	jne    f0100872 <mon_backtrace+0x39>
				info.eip_fn_namelen,info.eip_fn_name,eip-info.eip_fn_addr);
	}

	return 0;
}
f01008bf:	b8 00 00 00 00       	mov    $0x0,%eax
f01008c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01008c7:	5b                   	pop    %ebx
f01008c8:	5e                   	pop    %esi
f01008c9:	5f                   	pop    %edi
f01008ca:	5d                   	pop    %ebp
f01008cb:	c3                   	ret    

f01008cc <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008cc:	55                   	push   %ebp
f01008cd:	89 e5                	mov    %esp,%ebp
f01008cf:	57                   	push   %edi
f01008d0:	56                   	push   %esi
f01008d1:	53                   	push   %ebx
f01008d2:	83 ec 60             	sub    $0x60,%esp
f01008d5:	e8 8d f8 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01008da:	81 c3 8e ef 07 00    	add    $0x7ef8e,%ebx
	char *buf;

	cprintf("%u decimal is %o octal!\n", 6828,6828);      
f01008e0:	68 ac 1a 00 00       	push   $0x1aac
f01008e5:	68 ac 1a 00 00       	push   $0x1aac
f01008ea:	8d 83 bc 5f f8 ff    	lea    -0x7a044(%ebx),%eax
f01008f0:	50                   	push   %eax
f01008f1:	e8 2f 31 00 00       	call   f0103a25 <cprintf>
	cprintf("Welcome to the JOS kernel monitor!\n");
f01008f6:	8d 83 58 61 f8 ff    	lea    -0x79ea8(%ebx),%eax
f01008fc:	89 04 24             	mov    %eax,(%esp)
f01008ff:	e8 21 31 00 00       	call   f0103a25 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100904:	8d 83 7c 61 f8 ff    	lea    -0x79e84(%ebx),%eax
f010090a:	89 04 24             	mov    %eax,(%esp)
f010090d:	e8 13 31 00 00       	call   f0103a25 <cprintf>

	if (tf != NULL)
f0100912:	83 c4 10             	add    $0x10,%esp
f0100915:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100919:	74 0e                	je     f0100929 <monitor+0x5d>
		print_trapframe(tf);
f010091b:	83 ec 0c             	sub    $0xc,%esp
f010091e:	ff 75 08             	push   0x8(%ebp)
f0100921:	e8 0a 36 00 00       	call   f0103f30 <print_trapframe>
f0100926:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f0100929:	8d bb d9 5f f8 ff    	lea    -0x7a027(%ebx),%edi
f010092f:	eb 4a                	jmp    f010097b <monitor+0xaf>
f0100931:	83 ec 08             	sub    $0x8,%esp
f0100934:	0f be c0             	movsbl %al,%eax
f0100937:	50                   	push   %eax
f0100938:	57                   	push   %edi
f0100939:	e8 45 47 00 00       	call   f0105083 <strchr>
f010093e:	83 c4 10             	add    $0x10,%esp
f0100941:	85 c0                	test   %eax,%eax
f0100943:	74 08                	je     f010094d <monitor+0x81>
			*buf++ = 0;
f0100945:	c6 06 00             	movb   $0x0,(%esi)
f0100948:	8d 76 01             	lea    0x1(%esi),%esi
f010094b:	eb 76                	jmp    f01009c3 <monitor+0xf7>
		if (*buf == 0)
f010094d:	80 3e 00             	cmpb   $0x0,(%esi)
f0100950:	74 7c                	je     f01009ce <monitor+0x102>
		if (argc == MAXARGS-1) {
f0100952:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
f0100956:	74 0f                	je     f0100967 <monitor+0x9b>
		argv[argc++] = buf;
f0100958:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010095b:	8d 48 01             	lea    0x1(%eax),%ecx
f010095e:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f0100961:	89 74 85 a8          	mov    %esi,-0x58(%ebp,%eax,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100965:	eb 41                	jmp    f01009a8 <monitor+0xdc>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100967:	83 ec 08             	sub    $0x8,%esp
f010096a:	6a 10                	push   $0x10
f010096c:	8d 83 de 5f f8 ff    	lea    -0x7a022(%ebx),%eax
f0100972:	50                   	push   %eax
f0100973:	e8 ad 30 00 00       	call   f0103a25 <cprintf>
			return 0;
f0100978:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f010097b:	8d 83 d5 5f f8 ff    	lea    -0x7a02b(%ebx),%eax
f0100981:	89 c6                	mov    %eax,%esi
f0100983:	83 ec 0c             	sub    $0xc,%esp
f0100986:	56                   	push   %esi
f0100987:	e8 a6 44 00 00       	call   f0104e32 <readline>
		if (buf != NULL)
f010098c:	83 c4 10             	add    $0x10,%esp
f010098f:	85 c0                	test   %eax,%eax
f0100991:	74 f0                	je     f0100983 <monitor+0xb7>
	argv[argc] = 0;
f0100993:	89 c6                	mov    %eax,%esi
f0100995:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010099c:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01009a3:	eb 1e                	jmp    f01009c3 <monitor+0xf7>
			buf++;
f01009a5:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01009a8:	0f b6 06             	movzbl (%esi),%eax
f01009ab:	84 c0                	test   %al,%al
f01009ad:	74 14                	je     f01009c3 <monitor+0xf7>
f01009af:	83 ec 08             	sub    $0x8,%esp
f01009b2:	0f be c0             	movsbl %al,%eax
f01009b5:	50                   	push   %eax
f01009b6:	57                   	push   %edi
f01009b7:	e8 c7 46 00 00       	call   f0105083 <strchr>
f01009bc:	83 c4 10             	add    $0x10,%esp
f01009bf:	85 c0                	test   %eax,%eax
f01009c1:	74 e2                	je     f01009a5 <monitor+0xd9>
		while (*buf && strchr(WHITESPACE, *buf))
f01009c3:	0f b6 06             	movzbl (%esi),%eax
f01009c6:	84 c0                	test   %al,%al
f01009c8:	0f 85 63 ff ff ff    	jne    f0100931 <monitor+0x65>
	argv[argc] = 0;
f01009ce:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01009d1:	c7 44 85 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%eax,4)
f01009d8:	00 
	if (argc == 0)
f01009d9:	85 c0                	test   %eax,%eax
f01009db:	74 9e                	je     f010097b <monitor+0xaf>
f01009dd:	8d b3 d8 17 00 00    	lea    0x17d8(%ebx),%esi
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009e3:	b8 00 00 00 00       	mov    $0x0,%eax
f01009e8:	89 7d a0             	mov    %edi,-0x60(%ebp)
f01009eb:	89 c7                	mov    %eax,%edi
		if (strcmp(argv[0], commands[i].name) == 0)
f01009ed:	83 ec 08             	sub    $0x8,%esp
f01009f0:	ff 36                	push   (%esi)
f01009f2:	ff 75 a8             	push   -0x58(%ebp)
f01009f5:	e8 29 46 00 00       	call   f0105023 <strcmp>
f01009fa:	83 c4 10             	add    $0x10,%esp
f01009fd:	85 c0                	test   %eax,%eax
f01009ff:	74 28                	je     f0100a29 <monitor+0x15d>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a01:	83 c7 01             	add    $0x1,%edi
f0100a04:	83 c6 0c             	add    $0xc,%esi
f0100a07:	83 ff 03             	cmp    $0x3,%edi
f0100a0a:	75 e1                	jne    f01009ed <monitor+0x121>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a0c:	8b 7d a0             	mov    -0x60(%ebp),%edi
f0100a0f:	83 ec 08             	sub    $0x8,%esp
f0100a12:	ff 75 a8             	push   -0x58(%ebp)
f0100a15:	8d 83 fb 5f f8 ff    	lea    -0x7a005(%ebx),%eax
f0100a1b:	50                   	push   %eax
f0100a1c:	e8 04 30 00 00       	call   f0103a25 <cprintf>
	return 0;
f0100a21:	83 c4 10             	add    $0x10,%esp
f0100a24:	e9 52 ff ff ff       	jmp    f010097b <monitor+0xaf>
			return commands[i].func(argc, argv, tf);
f0100a29:	89 f8                	mov    %edi,%eax
f0100a2b:	8b 7d a0             	mov    -0x60(%ebp),%edi
f0100a2e:	83 ec 04             	sub    $0x4,%esp
f0100a31:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100a34:	ff 75 08             	push   0x8(%ebp)
f0100a37:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a3a:	52                   	push   %edx
f0100a3b:	ff 75 a4             	push   -0x5c(%ebp)
f0100a3e:	ff 94 83 e0 17 00 00 	call   *0x17e0(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a45:	83 c4 10             	add    $0x10,%esp
f0100a48:	85 c0                	test   %eax,%eax
f0100a4a:	0f 89 2b ff ff ff    	jns    f010097b <monitor+0xaf>
				break;
	}
}
f0100a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a53:	5b                   	pop    %ebx
f0100a54:	5e                   	pop    %esi
f0100a55:	5f                   	pop    %edi
f0100a56:	5d                   	pop    %ebp
f0100a57:	c3                   	ret    

f0100a58 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100a58:	55                   	push   %ebp
f0100a59:	89 e5                	mov    %esp,%ebp
f0100a5b:	57                   	push   %edi
f0100a5c:	56                   	push   %esi
f0100a5d:	53                   	push   %ebx
f0100a5e:	83 ec 18             	sub    $0x18,%esp
f0100a61:	e8 01 f7 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100a66:	81 c3 02 ee 07 00    	add    $0x7ee02,%ebx
f0100a6c:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a6e:	50                   	push   %eax
f0100a6f:	e8 2a 2f 00 00       	call   f010399e <mc146818_read>
f0100a74:	89 c7                	mov    %eax,%edi
f0100a76:	83 c6 01             	add    $0x1,%esi
f0100a79:	89 34 24             	mov    %esi,(%esp)
f0100a7c:	e8 1d 2f 00 00       	call   f010399e <mc146818_read>
f0100a81:	c1 e0 08             	shl    $0x8,%eax
f0100a84:	09 f8                	or     %edi,%eax
}
f0100a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a89:	5b                   	pop    %ebx
f0100a8a:	5e                   	pop    %esi
f0100a8b:	5f                   	pop    %edi
f0100a8c:	5d                   	pop    %ebp
f0100a8d:	c3                   	ret    

f0100a8e <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100a8e:	55                   	push   %ebp
f0100a8f:	89 e5                	mov    %esp,%ebp
f0100a91:	53                   	push   %ebx
f0100a92:	83 ec 04             	sub    $0x4,%esp
f0100a95:	e8 7c 27 00 00       	call   f0103216 <__x86.get_pc_thunk.dx>
f0100a9a:	81 c2 ce ed 07 00    	add    $0x7edce,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100aa0:	83 ba fc 1a 00 00 00 	cmpl   $0x0,0x1afc(%edx)
f0100aa7:	74 31                	je     f0100ada <boot_alloc+0x4c>
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.

	result = nextfree;
f0100aa9:	8b 9a fc 1a 00 00    	mov    0x1afc(%edx),%ebx

	nextfree = ROUNDUP(nextfree + n, PGSIZE);
f0100aaf:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
f0100ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100abb:	89 82 fc 1a 00 00    	mov    %eax,0x1afc(%edx)

	if((uint32_t)nextfree - KERNBASE > PGSIZE * npages)
f0100ac1:	05 00 00 00 10       	add    $0x10000000,%eax
f0100ac6:	8b 8a f8 1a 00 00    	mov    0x1af8(%edx),%ecx
f0100acc:	c1 e1 0c             	shl    $0xc,%ecx
f0100acf:	39 c8                	cmp    %ecx,%eax
f0100ad1:	77 21                	ja     f0100af4 <boot_alloc+0x66>
	{
		panic("OUT OF MEMORY");
	}
	return result;
}
f0100ad3:	89 d8                	mov    %ebx,%eax
f0100ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ad8:	c9                   	leave  
f0100ad9:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ada:	c7 c1 20 20 18 f0    	mov    $0xf0182020,%ecx
f0100ae0:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0100ae6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100aec:	89 8a fc 1a 00 00    	mov    %ecx,0x1afc(%edx)
f0100af2:	eb b5                	jmp    f0100aa9 <boot_alloc+0x1b>
		panic("OUT OF MEMORY");
f0100af4:	83 ec 04             	sub    $0x4,%esp
f0100af7:	8d 82 a1 61 f8 ff    	lea    -0x79e5f(%edx),%eax
f0100afd:	50                   	push   %eax
f0100afe:	6a 71                	push   $0x71
f0100b00:	8d 82 af 61 f8 ff    	lea    -0x79e51(%edx),%eax
f0100b06:	50                   	push   %eax
f0100b07:	89 d3                	mov    %edx,%ebx
f0100b09:	e8 a3 f5 ff ff       	call   f01000b1 <_panic>

f0100b0e <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100b0e:	55                   	push   %ebp
f0100b0f:	89 e5                	mov    %esp,%ebp
f0100b11:	53                   	push   %ebx
f0100b12:	83 ec 04             	sub    $0x4,%esp
f0100b15:	e8 00 27 00 00       	call   f010321a <__x86.get_pc_thunk.cx>
f0100b1a:	81 c1 4e ed 07 00    	add    $0x7ed4e,%ecx
f0100b20:	89 c3                	mov    %eax,%ebx
f0100b22:	89 d0                	mov    %edx,%eax
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b24:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P))
f0100b27:	8b 14 93             	mov    (%ebx,%edx,4),%edx
f0100b2a:	f6 c2 01             	test   $0x1,%dl
f0100b2d:	74 54                	je     f0100b83 <check_va2pa+0x75>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b2f:	89 d3                	mov    %edx,%ebx
f0100b31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100b37:	c1 ea 0c             	shr    $0xc,%edx
f0100b3a:	3b 91 f8 1a 00 00    	cmp    0x1af8(%ecx),%edx
f0100b40:	73 26                	jae    f0100b68 <check_va2pa+0x5a>
	if (!(p[PTX(va)] & PTE_P))
f0100b42:	c1 e8 0c             	shr    $0xc,%eax
f0100b45:	25 ff 03 00 00       	and    $0x3ff,%eax
f0100b4a:	8b 94 83 00 00 00 f0 	mov    -0x10000000(%ebx,%eax,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b51:	89 d0                	mov    %edx,%eax
f0100b53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b58:	f6 c2 01             	test   $0x1,%dl
f0100b5b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b60:	0f 44 c2             	cmove  %edx,%eax
}
f0100b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100b66:	c9                   	leave  
f0100b67:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b68:	53                   	push   %ebx
f0100b69:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0100b6f:	50                   	push   %eax
f0100b70:	68 2c 03 00 00       	push   $0x32c
f0100b75:	8d 81 af 61 f8 ff    	lea    -0x79e51(%ecx),%eax
f0100b7b:	50                   	push   %eax
f0100b7c:	89 cb                	mov    %ecx,%ebx
f0100b7e:	e8 2e f5 ff ff       	call   f01000b1 <_panic>
		return ~0;
f0100b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100b88:	eb d9                	jmp    f0100b63 <check_va2pa+0x55>

f0100b8a <check_page_free_list>:
{
f0100b8a:	55                   	push   %ebp
f0100b8b:	89 e5                	mov    %esp,%ebp
f0100b8d:	57                   	push   %edi
f0100b8e:	56                   	push   %esi
f0100b8f:	53                   	push   %ebx
f0100b90:	83 ec 2c             	sub    $0x2c,%esp
f0100b93:	e8 86 26 00 00       	call   f010321e <__x86.get_pc_thunk.di>
f0100b98:	81 c7 d0 ec 07 00    	add    $0x7ecd0,%edi
f0100b9e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ba1:	84 c0                	test   %al,%al
f0100ba3:	0f 85 dc 02 00 00    	jne    f0100e85 <check_page_free_list+0x2fb>
	if (!page_free_list)
f0100ba9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100bac:	83 b8 04 1b 00 00 00 	cmpl   $0x0,0x1b04(%eax)
f0100bb3:	74 0a                	je     f0100bbf <check_page_free_list+0x35>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bb5:	bf 00 04 00 00       	mov    $0x400,%edi
f0100bba:	e9 29 03 00 00       	jmp    f0100ee8 <check_page_free_list+0x35e>
		panic("'page_free_list' is a null pointer!");
f0100bbf:	83 ec 04             	sub    $0x4,%esp
f0100bc2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100bc5:	8d 83 b8 64 f8 ff    	lea    -0x79b48(%ebx),%eax
f0100bcb:	50                   	push   %eax
f0100bcc:	68 68 02 00 00       	push   $0x268
f0100bd1:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100bd7:	50                   	push   %eax
f0100bd8:	e8 d4 f4 ff ff       	call   f01000b1 <_panic>
f0100bdd:	50                   	push   %eax
f0100bde:	89 cb                	mov    %ecx,%ebx
f0100be0:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0100be6:	50                   	push   %eax
f0100be7:	6a 56                	push   $0x56
f0100be9:	8d 81 bb 61 f8 ff    	lea    -0x79e45(%ecx),%eax
f0100bef:	50                   	push   %eax
f0100bf0:	e8 bc f4 ff ff       	call   f01000b1 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bf5:	8b 36                	mov    (%esi),%esi
f0100bf7:	85 f6                	test   %esi,%esi
f0100bf9:	74 47                	je     f0100c42 <check_page_free_list+0xb8>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bfb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0100bfe:	89 f0                	mov    %esi,%eax
f0100c00:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f0100c06:	c1 f8 03             	sar    $0x3,%eax
f0100c09:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c0c:	89 c2                	mov    %eax,%edx
f0100c0e:	c1 ea 16             	shr    $0x16,%edx
f0100c11:	39 fa                	cmp    %edi,%edx
f0100c13:	73 e0                	jae    f0100bf5 <check_page_free_list+0x6b>
	if (PGNUM(pa) >= npages)
f0100c15:	89 c2                	mov    %eax,%edx
f0100c17:	c1 ea 0c             	shr    $0xc,%edx
f0100c1a:	3b 91 f8 1a 00 00    	cmp    0x1af8(%ecx),%edx
f0100c20:	73 bb                	jae    f0100bdd <check_page_free_list+0x53>
			memset(page2kva(pp), 0x97, 128);
f0100c22:	83 ec 04             	sub    $0x4,%esp
f0100c25:	68 80 00 00 00       	push   $0x80
f0100c2a:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c2f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c34:	50                   	push   %eax
f0100c35:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c38:	e8 85 44 00 00       	call   f01050c2 <memset>
f0100c3d:	83 c4 10             	add    $0x10,%esp
f0100c40:	eb b3                	jmp    f0100bf5 <check_page_free_list+0x6b>
	first_free_page = (char *) boot_alloc(0);
f0100c42:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c47:	e8 42 fe ff ff       	call   f0100a8e <boot_alloc>
f0100c4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100c52:	8b 90 04 1b 00 00    	mov    0x1b04(%eax),%edx
		assert(pp >= pages);
f0100c58:	8b 88 f0 1a 00 00    	mov    0x1af0(%eax),%ecx
		assert(pp < pages + npages);
f0100c5e:	8b 80 f8 1a 00 00    	mov    0x1af8(%eax),%eax
f0100c64:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100c67:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c6a:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c6f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100c74:	89 5d d0             	mov    %ebx,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c77:	e9 07 01 00 00       	jmp    f0100d83 <check_page_free_list+0x1f9>
		assert(pp >= pages);
f0100c7c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c7f:	8d 83 c9 61 f8 ff    	lea    -0x79e37(%ebx),%eax
f0100c85:	50                   	push   %eax
f0100c86:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100c8c:	50                   	push   %eax
f0100c8d:	68 82 02 00 00       	push   $0x282
f0100c92:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100c98:	50                   	push   %eax
f0100c99:	e8 13 f4 ff ff       	call   f01000b1 <_panic>
		assert(pp < pages + npages);
f0100c9e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ca1:	8d 83 ea 61 f8 ff    	lea    -0x79e16(%ebx),%eax
f0100ca7:	50                   	push   %eax
f0100ca8:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100cae:	50                   	push   %eax
f0100caf:	68 83 02 00 00       	push   $0x283
f0100cb4:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100cba:	50                   	push   %eax
f0100cbb:	e8 f1 f3 ff ff       	call   f01000b1 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100cc0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100cc3:	8d 83 dc 64 f8 ff    	lea    -0x79b24(%ebx),%eax
f0100cc9:	50                   	push   %eax
f0100cca:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100cd0:	50                   	push   %eax
f0100cd1:	68 84 02 00 00       	push   $0x284
f0100cd6:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100cdc:	50                   	push   %eax
f0100cdd:	e8 cf f3 ff ff       	call   f01000b1 <_panic>
		assert(page2pa(pp) != 0);
f0100ce2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ce5:	8d 83 fe 61 f8 ff    	lea    -0x79e02(%ebx),%eax
f0100ceb:	50                   	push   %eax
f0100cec:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100cf2:	50                   	push   %eax
f0100cf3:	68 87 02 00 00       	push   $0x287
f0100cf8:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100cfe:	50                   	push   %eax
f0100cff:	e8 ad f3 ff ff       	call   f01000b1 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d04:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100d07:	8d 83 0f 62 f8 ff    	lea    -0x79df1(%ebx),%eax
f0100d0d:	50                   	push   %eax
f0100d0e:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100d14:	50                   	push   %eax
f0100d15:	68 88 02 00 00       	push   $0x288
f0100d1a:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100d20:	50                   	push   %eax
f0100d21:	e8 8b f3 ff ff       	call   f01000b1 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d26:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100d29:	8d 83 10 65 f8 ff    	lea    -0x79af0(%ebx),%eax
f0100d2f:	50                   	push   %eax
f0100d30:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100d36:	50                   	push   %eax
f0100d37:	68 89 02 00 00       	push   $0x289
f0100d3c:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100d42:	50                   	push   %eax
f0100d43:	e8 69 f3 ff ff       	call   f01000b1 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d48:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100d4b:	8d 83 28 62 f8 ff    	lea    -0x79dd8(%ebx),%eax
f0100d51:	50                   	push   %eax
f0100d52:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100d58:	50                   	push   %eax
f0100d59:	68 8a 02 00 00       	push   $0x28a
f0100d5e:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100d64:	50                   	push   %eax
f0100d65:	e8 47 f3 ff ff       	call   f01000b1 <_panic>
	if (PGNUM(pa) >= npages)
f0100d6a:	89 c3                	mov    %eax,%ebx
f0100d6c:	c1 eb 0c             	shr    $0xc,%ebx
f0100d6f:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0100d72:	76 6d                	jbe    f0100de1 <check_page_free_list+0x257>
	return (void *)(pa + KERNBASE);
f0100d74:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d79:	39 45 c8             	cmp    %eax,-0x38(%ebp)
f0100d7c:	77 7c                	ja     f0100dfa <check_page_free_list+0x270>
			++nfree_extmem;
f0100d7e:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d81:	8b 12                	mov    (%edx),%edx
f0100d83:	85 d2                	test   %edx,%edx
f0100d85:	0f 84 91 00 00 00    	je     f0100e1c <check_page_free_list+0x292>
		assert(pp >= pages);
f0100d8b:	39 d1                	cmp    %edx,%ecx
f0100d8d:	0f 87 e9 fe ff ff    	ja     f0100c7c <check_page_free_list+0xf2>
		assert(pp < pages + npages);
f0100d93:	39 d6                	cmp    %edx,%esi
f0100d95:	0f 86 03 ff ff ff    	jbe    f0100c9e <check_page_free_list+0x114>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d9b:	89 d0                	mov    %edx,%eax
f0100d9d:	29 c8                	sub    %ecx,%eax
f0100d9f:	a8 07                	test   $0x7,%al
f0100da1:	0f 85 19 ff ff ff    	jne    f0100cc0 <check_page_free_list+0x136>
	return (pp - pages) << PGSHIFT;
f0100da7:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100daa:	c1 e0 0c             	shl    $0xc,%eax
f0100dad:	0f 84 2f ff ff ff    	je     f0100ce2 <check_page_free_list+0x158>
		assert(page2pa(pp) != IOPHYSMEM);
f0100db3:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100db8:	0f 84 46 ff ff ff    	je     f0100d04 <check_page_free_list+0x17a>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100dbe:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dc3:	0f 84 5d ff ff ff    	je     f0100d26 <check_page_free_list+0x19c>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100dc9:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100dce:	0f 84 74 ff ff ff    	je     f0100d48 <check_page_free_list+0x1be>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dd4:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dd9:	77 8f                	ja     f0100d6a <check_page_free_list+0x1e0>
			++nfree_basemem;
f0100ddb:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f0100ddf:	eb a0                	jmp    f0100d81 <check_page_free_list+0x1f7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100de1:	50                   	push   %eax
f0100de2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100de5:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f0100deb:	50                   	push   %eax
f0100dec:	6a 56                	push   $0x56
f0100dee:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f0100df4:	50                   	push   %eax
f0100df5:	e8 b7 f2 ff ff       	call   f01000b1 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dfa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100dfd:	8d 83 34 65 f8 ff    	lea    -0x79acc(%ebx),%eax
f0100e03:	50                   	push   %eax
f0100e04:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100e0a:	50                   	push   %eax
f0100e0b:	68 8b 02 00 00       	push   $0x28b
f0100e10:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100e16:	50                   	push   %eax
f0100e17:	e8 95 f2 ff ff       	call   f01000b1 <_panic>
	assert(nfree_basemem > 0);
f0100e1c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0100e1f:	85 db                	test   %ebx,%ebx
f0100e21:	7e 1e                	jle    f0100e41 <check_page_free_list+0x2b7>
	assert(nfree_extmem > 0);
f0100e23:	85 ff                	test   %edi,%edi
f0100e25:	7e 3c                	jle    f0100e63 <check_page_free_list+0x2d9>
	cprintf("check_page_free_list() succeeded!\n");
f0100e27:	83 ec 0c             	sub    $0xc,%esp
f0100e2a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100e2d:	8d 83 7c 65 f8 ff    	lea    -0x79a84(%ebx),%eax
f0100e33:	50                   	push   %eax
f0100e34:	e8 ec 2b 00 00       	call   f0103a25 <cprintf>
}
f0100e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e3c:	5b                   	pop    %ebx
f0100e3d:	5e                   	pop    %esi
f0100e3e:	5f                   	pop    %edi
f0100e3f:	5d                   	pop    %ebp
f0100e40:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e41:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100e44:	8d 83 42 62 f8 ff    	lea    -0x79dbe(%ebx),%eax
f0100e4a:	50                   	push   %eax
f0100e4b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100e51:	50                   	push   %eax
f0100e52:	68 93 02 00 00       	push   $0x293
f0100e57:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100e5d:	50                   	push   %eax
f0100e5e:	e8 4e f2 ff ff       	call   f01000b1 <_panic>
	assert(nfree_extmem > 0);
f0100e63:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100e66:	8d 83 54 62 f8 ff    	lea    -0x79dac(%ebx),%eax
f0100e6c:	50                   	push   %eax
f0100e6d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0100e73:	50                   	push   %eax
f0100e74:	68 94 02 00 00       	push   $0x294
f0100e79:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100e7f:	50                   	push   %eax
f0100e80:	e8 2c f2 ff ff       	call   f01000b1 <_panic>
	if (!page_free_list)
f0100e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e88:	8b 80 04 1b 00 00    	mov    0x1b04(%eax),%eax
f0100e8e:	85 c0                	test   %eax,%eax
f0100e90:	0f 84 29 fd ff ff    	je     f0100bbf <check_page_free_list+0x35>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e96:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e99:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e9c:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100ea2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0100ea5:	89 c2                	mov    %eax,%edx
f0100ea7:	2b 97 f0 1a 00 00    	sub    0x1af0(%edi),%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100ead:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100eb3:	0f 95 c2             	setne  %dl
f0100eb6:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100eb9:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100ebd:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100ebf:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ec3:	8b 00                	mov    (%eax),%eax
f0100ec5:	85 c0                	test   %eax,%eax
f0100ec7:	75 d9                	jne    f0100ea2 <check_page_free_list+0x318>
		*tp[1] = 0;
f0100ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ecc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100ed2:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ed8:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100eda:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100edd:	89 87 04 1b 00 00    	mov    %eax,0x1b04(%edi)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ee3:	bf 01 00 00 00       	mov    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ee8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100eeb:	8b b0 04 1b 00 00    	mov    0x1b04(%eax),%esi
f0100ef1:	e9 01 fd ff ff       	jmp    f0100bf7 <check_page_free_list+0x6d>

f0100ef6 <page_init>:
{
f0100ef6:	55                   	push   %ebp
f0100ef7:	89 e5                	mov    %esp,%ebp
f0100ef9:	57                   	push   %edi
f0100efa:	56                   	push   %esi
f0100efb:	53                   	push   %ebx
f0100efc:	83 ec 0c             	sub    $0xc,%esp
f0100eff:	e8 63 f2 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0100f04:	81 c3 64 e9 07 00    	add    $0x7e964,%ebx
	pages[0].pp_ref = 1;
f0100f0a:	8b 83 f0 1a 00 00    	mov    0x1af0(%ebx),%eax
f0100f10:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100f16:	8b b3 08 1b 00 00    	mov    0x1b08(%ebx),%esi
f0100f1c:	8b bb 04 1b 00 00    	mov    0x1b04(%ebx),%edi
f0100f22:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f27:	b8 01 00 00 00       	mov    $0x1,%eax
f0100f2c:	eb 27                	jmp    f0100f55 <page_init+0x5f>
f0100f2e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f35:	89 d1                	mov    %edx,%ecx
f0100f37:	03 8b f0 1a 00 00    	add    0x1af0(%ebx),%ecx
f0100f3d:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f43:	89 39                	mov    %edi,(%ecx)
		page_free_list = &pages[i];
f0100f45:	89 d7                	mov    %edx,%edi
f0100f47:	03 bb f0 1a 00 00    	add    0x1af0(%ebx),%edi
	for (i = 1; i < npages_basemem; i++) {
f0100f4d:	83 c0 01             	add    $0x1,%eax
f0100f50:	ba 01 00 00 00       	mov    $0x1,%edx
f0100f55:	39 c6                	cmp    %eax,%esi
f0100f57:	77 d5                	ja     f0100f2e <page_init+0x38>
f0100f59:	85 f6                	test   %esi,%esi
f0100f5b:	b9 01 00 00 00       	mov    $0x1,%ecx
f0100f60:	0f 45 ce             	cmovne %esi,%ecx
f0100f63:	84 d2                	test   %dl,%dl
f0100f65:	74 06                	je     f0100f6d <page_init+0x77>
f0100f67:	89 bb 04 1b 00 00    	mov    %edi,0x1b04(%ebx)
		pages[i].pp_ref = 1;
f0100f6d:	8b 93 f0 1a 00 00    	mov    0x1af0(%ebx),%edx
f0100f73:	89 c8                	mov    %ecx,%eax
f0100f75:	eb 0a                	jmp    f0100f81 <page_init+0x8b>
f0100f77:	66 c7 44 c2 04 01 00 	movw   $0x1,0x4(%edx,%eax,8)
	for(; i < EXTPHYSMEM / PGSIZE; i++)
f0100f7e:	83 c0 01             	add    $0x1,%eax
f0100f81:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100f86:	76 ef                	jbe    f0100f77 <page_init+0x81>
f0100f88:	b8 00 01 00 00       	mov    $0x100,%eax
f0100f8d:	29 c8                	sub    %ecx,%eax
f0100f8f:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
f0100f95:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f9a:	0f 47 c2             	cmova  %edx,%eax
f0100f9d:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
	physaddr_t first_free_addr = PADDR(boot_alloc(0));
f0100fa0:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fa5:	e8 e4 fa ff ff       	call   f0100a8e <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100faa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100faf:	76 16                	jbe    f0100fc7 <page_init+0xd1>
	return (physaddr_t)kva - KERNBASE;
f0100fb1:	05 00 00 00 10       	add    $0x10000000,%eax
	size_t first_free_page = first_free_addr / PGSIZE + 96 + npages_basemem;
f0100fb6:	c1 e8 0c             	shr    $0xc,%eax
f0100fb9:	8d 54 06 60          	lea    0x60(%esi,%eax,1),%edx
		pages[i].pp_ref = 1;
f0100fbd:	8b 8b f0 1a 00 00    	mov    0x1af0(%ebx),%ecx
	for(; i < first_free_page; i++)
f0100fc3:	89 f8                	mov    %edi,%eax
f0100fc5:	eb 23                	jmp    f0100fea <page_init+0xf4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100fc7:	50                   	push   %eax
f0100fc8:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0100fce:	50                   	push   %eax
f0100fcf:	68 28 01 00 00       	push   $0x128
f0100fd4:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0100fda:	50                   	push   %eax
f0100fdb:	e8 d1 f0 ff ff       	call   f01000b1 <_panic>
		pages[i].pp_ref = 1;
f0100fe0:	66 c7 44 c1 04 01 00 	movw   $0x1,0x4(%ecx,%eax,8)
	for(; i < first_free_page; i++)
f0100fe7:	83 c0 01             	add    $0x1,%eax
f0100fea:	39 d0                	cmp    %edx,%eax
f0100fec:	72 f2                	jb     f0100fe0 <page_init+0xea>
f0100fee:	89 d0                	mov    %edx,%eax
f0100ff0:	29 f8                	sub    %edi,%eax
f0100ff2:	39 fa                	cmp    %edi,%edx
f0100ff4:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ff9:	0f 42 c2             	cmovb  %edx,%eax
f0100ffc:	01 f8                	add    %edi,%eax
f0100ffe:	8b b3 04 1b 00 00    	mov    0x1b04(%ebx),%esi
	for(;i < npages; i++)
f0101004:	bf 01 00 00 00       	mov    $0x1,%edi
f0101009:	eb 24                	jmp    f010102f <page_init+0x139>
f010100b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0101012:	89 d1                	mov    %edx,%ecx
f0101014:	03 8b f0 1a 00 00    	add    0x1af0(%ebx),%ecx
f010101a:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101020:	89 31                	mov    %esi,(%ecx)
		page_free_list = &pages[i];
f0101022:	89 d6                	mov    %edx,%esi
f0101024:	03 b3 f0 1a 00 00    	add    0x1af0(%ebx),%esi
	for(;i < npages; i++)
f010102a:	83 c0 01             	add    $0x1,%eax
f010102d:	89 fa                	mov    %edi,%edx
f010102f:	39 83 f8 1a 00 00    	cmp    %eax,0x1af8(%ebx)
f0101035:	77 d4                	ja     f010100b <page_init+0x115>
f0101037:	84 d2                	test   %dl,%dl
f0101039:	74 06                	je     f0101041 <page_init+0x14b>
f010103b:	89 b3 04 1b 00 00    	mov    %esi,0x1b04(%ebx)
}
f0101041:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101044:	5b                   	pop    %ebx
f0101045:	5e                   	pop    %esi
f0101046:	5f                   	pop    %edi
f0101047:	5d                   	pop    %ebp
f0101048:	c3                   	ret    

f0101049 <page_alloc>:
{
f0101049:	55                   	push   %ebp
f010104a:	89 e5                	mov    %esp,%ebp
f010104c:	56                   	push   %esi
f010104d:	53                   	push   %ebx
f010104e:	e8 14 f1 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0101053:	81 c3 15 e8 07 00    	add    $0x7e815,%ebx
	if(!page_free_list) {
f0101059:	8b b3 04 1b 00 00    	mov    0x1b04(%ebx),%esi
f010105f:	85 f6                	test   %esi,%esi
f0101061:	74 14                	je     f0101077 <page_alloc+0x2e>
	page_free_list = page_free_list->pp_link;
f0101063:	8b 06                	mov    (%esi),%eax
f0101065:	89 83 04 1b 00 00    	mov    %eax,0x1b04(%ebx)
	pp->pp_link = NULL;
f010106b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	if(alloc_flags & ALLOC_ZERO) {
f0101071:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101075:	75 09                	jne    f0101080 <page_alloc+0x37>
}
f0101077:	89 f0                	mov    %esi,%eax
f0101079:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010107c:	5b                   	pop    %ebx
f010107d:	5e                   	pop    %esi
f010107e:	5d                   	pop    %ebp
f010107f:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101080:	89 f0                	mov    %esi,%eax
f0101082:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0101088:	c1 f8 03             	sar    $0x3,%eax
f010108b:	89 c2                	mov    %eax,%edx
f010108d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101090:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101095:	3b 83 f8 1a 00 00    	cmp    0x1af8(%ebx),%eax
f010109b:	73 1b                	jae    f01010b8 <page_alloc+0x6f>
		memset(page2kva(pp), 0, PGSIZE);
f010109d:	83 ec 04             	sub    $0x4,%esp
f01010a0:	68 00 10 00 00       	push   $0x1000
f01010a5:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01010a7:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01010ad:	52                   	push   %edx
f01010ae:	e8 0f 40 00 00       	call   f01050c2 <memset>
f01010b3:	83 c4 10             	add    $0x10,%esp
f01010b6:	eb bf                	jmp    f0101077 <page_alloc+0x2e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010b8:	52                   	push   %edx
f01010b9:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f01010bf:	50                   	push   %eax
f01010c0:	6a 56                	push   $0x56
f01010c2:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f01010c8:	50                   	push   %eax
f01010c9:	e8 e3 ef ff ff       	call   f01000b1 <_panic>

f01010ce <page_free>:
{
f01010ce:	55                   	push   %ebp
f01010cf:	89 e5                	mov    %esp,%ebp
f01010d1:	53                   	push   %ebx
f01010d2:	83 ec 04             	sub    $0x4,%esp
f01010d5:	e8 8d f0 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01010da:	81 c3 8e e7 07 00    	add    $0x7e78e,%ebx
f01010e0:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_link != NULL || pp->pp_ref != 0)
f01010e3:	83 38 00             	cmpl   $0x0,(%eax)
f01010e6:	75 1a                	jne    f0101102 <page_free+0x34>
f01010e8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01010ed:	75 13                	jne    f0101102 <page_free+0x34>
	pp->pp_link = page_free_list;
f01010ef:	8b 8b 04 1b 00 00    	mov    0x1b04(%ebx),%ecx
f01010f5:	89 08                	mov    %ecx,(%eax)
	page_free_list = pp;
f01010f7:	89 83 04 1b 00 00    	mov    %eax,0x1b04(%ebx)
}
f01010fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101100:	c9                   	leave  
f0101101:	c3                   	ret    
		panic("pp->pp_ref is zero or pp->pp_link is not NULL");
f0101102:	83 ec 04             	sub    $0x4,%esp
f0101105:	8d 83 c4 65 f8 ff    	lea    -0x79a3c(%ebx),%eax
f010110b:	50                   	push   %eax
f010110c:	68 64 01 00 00       	push   $0x164
f0101111:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101117:	50                   	push   %eax
f0101118:	e8 94 ef ff ff       	call   f01000b1 <_panic>

f010111d <page_decref>:
{
f010111d:	55                   	push   %ebp
f010111e:	89 e5                	mov    %esp,%ebp
f0101120:	83 ec 08             	sub    $0x8,%esp
f0101123:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101126:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010112a:	83 e8 01             	sub    $0x1,%eax
f010112d:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101131:	66 85 c0             	test   %ax,%ax
f0101134:	74 02                	je     f0101138 <page_decref+0x1b>
}
f0101136:	c9                   	leave  
f0101137:	c3                   	ret    
		page_free(pp);
f0101138:	83 ec 0c             	sub    $0xc,%esp
f010113b:	52                   	push   %edx
f010113c:	e8 8d ff ff ff       	call   f01010ce <page_free>
f0101141:	83 c4 10             	add    $0x10,%esp
}
f0101144:	eb f0                	jmp    f0101136 <page_decref+0x19>

f0101146 <pgdir_walk>:
{
f0101146:	55                   	push   %ebp
f0101147:	89 e5                	mov    %esp,%ebp
f0101149:	57                   	push   %edi
f010114a:	56                   	push   %esi
f010114b:	53                   	push   %ebx
f010114c:	83 ec 0c             	sub    $0xc,%esp
f010114f:	e8 ca 20 00 00       	call   f010321e <__x86.get_pc_thunk.di>
f0101154:	81 c7 14 e7 07 00    	add    $0x7e714,%edi
f010115a:	8b 75 0c             	mov    0xc(%ebp),%esi
    pde_t *pgdir_entry = pgdir + PDX(va);
f010115d:	89 f3                	mov    %esi,%ebx
f010115f:	c1 eb 16             	shr    $0x16,%ebx
f0101162:	c1 e3 02             	shl    $0x2,%ebx
f0101165:	03 5d 08             	add    0x8(%ebp),%ebx
    if (!(*pgdir_entry & PTE_P)) {
f0101168:	f6 03 01             	testb  $0x1,(%ebx)
f010116b:	75 2f                	jne    f010119c <pgdir_walk+0x56>
        if (!create)
f010116d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101171:	74 71                	je     f01011e4 <pgdir_walk+0x9e>
            struct PageInfo *new_page = page_alloc(1);
f0101173:	83 ec 0c             	sub    $0xc,%esp
f0101176:	6a 01                	push   $0x1
f0101178:	e8 cc fe ff ff       	call   f0101049 <page_alloc>
            if (!new_page)
f010117d:	83 c4 10             	add    $0x10,%esp
f0101180:	85 c0                	test   %eax,%eax
f0101182:	74 3d                	je     f01011c1 <pgdir_walk+0x7b>
	return (pp - pages) << PGSHIFT;
f0101184:	89 c2                	mov    %eax,%edx
f0101186:	2b 97 f0 1a 00 00    	sub    0x1af0(%edi),%edx
f010118c:	c1 fa 03             	sar    $0x3,%edx
f010118f:	c1 e2 0c             	shl    $0xc,%edx
            *pgdir_entry = (page2pa(new_page) | PTE_P | PTE_W | PTE_U);
f0101192:	83 ca 07             	or     $0x7,%edx
f0101195:	89 13                	mov    %edx,(%ebx)
            ++new_page->pp_ref;
f0101197:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    return (pte_t *)(KADDR(PTE_ADDR(*pgdir_entry))) + PTX(va);
f010119c:	8b 03                	mov    (%ebx),%eax
f010119e:	89 c2                	mov    %eax,%edx
f01011a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01011a6:	c1 e8 0c             	shr    $0xc,%eax
f01011a9:	3b 87 f8 1a 00 00    	cmp    0x1af8(%edi),%eax
f01011af:	73 18                	jae    f01011c9 <pgdir_walk+0x83>
f01011b1:	c1 ee 0a             	shr    $0xa,%esi
f01011b4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01011ba:	8d 84 32 00 00 00 f0 	lea    -0x10000000(%edx,%esi,1),%eax
}
f01011c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011c4:	5b                   	pop    %ebx
f01011c5:	5e                   	pop    %esi
f01011c6:	5f                   	pop    %edi
f01011c7:	5d                   	pop    %ebp
f01011c8:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01011c9:	52                   	push   %edx
f01011ca:	8d 87 94 64 f8 ff    	lea    -0x79b6c(%edi),%eax
f01011d0:	50                   	push   %eax
f01011d1:	68 9b 01 00 00       	push   $0x19b
f01011d6:	8d 87 af 61 f8 ff    	lea    -0x79e51(%edi),%eax
f01011dc:	50                   	push   %eax
f01011dd:	89 fb                	mov    %edi,%ebx
f01011df:	e8 cd ee ff ff       	call   f01000b1 <_panic>
            return NULL;
f01011e4:	b8 00 00 00 00       	mov    $0x0,%eax
f01011e9:	eb d6                	jmp    f01011c1 <pgdir_walk+0x7b>

f01011eb <boot_map_region>:
{
f01011eb:	55                   	push   %ebp
f01011ec:	89 e5                	mov    %esp,%ebp
f01011ee:	57                   	push   %edi
f01011ef:	56                   	push   %esi
f01011f0:	53                   	push   %ebx
f01011f1:	83 ec 1c             	sub    $0x1c,%esp
f01011f4:	89 c7                	mov    %eax,%edi
f01011f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01011f9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE, va += PGSIZE, pa += PGSIZE) {
f01011fc:	be 00 00 00 00       	mov    $0x0,%esi
f0101201:	eb 22                	jmp    f0101225 <boot_map_region+0x3a>
        pgtable_entry = pgdir_walk(pgdir, (void *)va, 1);
f0101203:	83 ec 04             	sub    $0x4,%esp
f0101206:	6a 01                	push   $0x1
f0101208:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010120b:	01 f0                	add    %esi,%eax
f010120d:	50                   	push   %eax
f010120e:	57                   	push   %edi
f010120f:	e8 32 ff ff ff       	call   f0101146 <pgdir_walk>
        *pgtable_entry = (pa | perm | PTE_P);
f0101214:	0b 5d 0c             	or     0xc(%ebp),%ebx
f0101217:	83 cb 01             	or     $0x1,%ebx
f010121a:	89 18                	mov    %ebx,(%eax)
    for (offset = 0; offset < size; offset += PGSIZE, va += PGSIZE, pa += PGSIZE) {
f010121c:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0101222:	83 c4 10             	add    $0x10,%esp
f0101225:	89 f3                	mov    %esi,%ebx
f0101227:	03 5d 08             	add    0x8(%ebp),%ebx
f010122a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f010122d:	77 d4                	ja     f0101203 <boot_map_region+0x18>
}
f010122f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101232:	5b                   	pop    %ebx
f0101233:	5e                   	pop    %esi
f0101234:	5f                   	pop    %edi
f0101235:	5d                   	pop    %ebp
f0101236:	c3                   	ret    

f0101237 <page_lookup>:
{
f0101237:	55                   	push   %ebp
f0101238:	89 e5                	mov    %esp,%ebp
f010123a:	56                   	push   %esi
f010123b:	53                   	push   %ebx
f010123c:	e8 26 ef ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0101241:	81 c3 27 e6 07 00    	add    $0x7e627,%ebx
f0101247:	8b 75 10             	mov    0x10(%ebp),%esi
	pte_t *pgtable_entry = pgdir_walk(pgdir, va, 0);
f010124a:	83 ec 04             	sub    $0x4,%esp
f010124d:	6a 00                	push   $0x0
f010124f:	ff 75 0c             	push   0xc(%ebp)
f0101252:	ff 75 08             	push   0x8(%ebp)
f0101255:	e8 ec fe ff ff       	call   f0101146 <pgdir_walk>
    if (!pgtable_entry || !(*pgtable_entry & PTE_P))
f010125a:	83 c4 10             	add    $0x10,%esp
f010125d:	85 c0                	test   %eax,%eax
f010125f:	74 21                	je     f0101282 <page_lookup+0x4b>
f0101261:	f6 00 01             	testb  $0x1,(%eax)
f0101264:	74 3b                	je     f01012a1 <page_lookup+0x6a>
    if (pte_store)
f0101266:	85 f6                	test   %esi,%esi
f0101268:	74 02                	je     f010126c <page_lookup+0x35>
        *pte_store = pgtable_entry;
f010126a:	89 06                	mov    %eax,(%esi)
f010126c:	8b 00                	mov    (%eax),%eax
f010126e:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101271:	39 83 f8 1a 00 00    	cmp    %eax,0x1af8(%ebx)
f0101277:	76 10                	jbe    f0101289 <page_lookup+0x52>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101279:	8b 93 f0 1a 00 00    	mov    0x1af0(%ebx),%edx
f010127f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101282:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101285:	5b                   	pop    %ebx
f0101286:	5e                   	pop    %esi
f0101287:	5d                   	pop    %ebp
f0101288:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101289:	83 ec 04             	sub    $0x4,%esp
f010128c:	8d 83 f4 65 f8 ff    	lea    -0x79a0c(%ebx),%eax
f0101292:	50                   	push   %eax
f0101293:	6a 4f                	push   $0x4f
f0101295:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f010129b:	50                   	push   %eax
f010129c:	e8 10 ee ff ff       	call   f01000b1 <_panic>
        return NULL;
f01012a1:	b8 00 00 00 00       	mov    $0x0,%eax
f01012a6:	eb da                	jmp    f0101282 <page_lookup+0x4b>

f01012a8 <page_remove>:
{
f01012a8:	55                   	push   %ebp
f01012a9:	89 e5                	mov    %esp,%ebp
f01012ab:	53                   	push   %ebx
f01012ac:	83 ec 18             	sub    $0x18,%esp
f01012af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    struct PageInfo *page = page_lookup(pgdir, va, &pgtable_entry);
f01012b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01012b5:	50                   	push   %eax
f01012b6:	53                   	push   %ebx
f01012b7:	ff 75 08             	push   0x8(%ebp)
f01012ba:	e8 78 ff ff ff       	call   f0101237 <page_lookup>
    if (!page)
f01012bf:	83 c4 10             	add    $0x10,%esp
f01012c2:	85 c0                	test   %eax,%eax
f01012c4:	74 18                	je     f01012de <page_remove+0x36>
    page_decref(page);
f01012c6:	83 ec 0c             	sub    $0xc,%esp
f01012c9:	50                   	push   %eax
f01012ca:	e8 4e fe ff ff       	call   f010111d <page_decref>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012cf:	0f 01 3b             	invlpg (%ebx)
    *pgtable_entry = 0;
f01012d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01012db:	83 c4 10             	add    $0x10,%esp
}
f01012de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012e1:	c9                   	leave  
f01012e2:	c3                   	ret    

f01012e3 <page_insert>:
{
f01012e3:	55                   	push   %ebp
f01012e4:	89 e5                	mov    %esp,%ebp
f01012e6:	57                   	push   %edi
f01012e7:	56                   	push   %esi
f01012e8:	53                   	push   %ebx
f01012e9:	83 ec 10             	sub    $0x10,%esp
f01012ec:	e8 2d 1f 00 00       	call   f010321e <__x86.get_pc_thunk.di>
f01012f1:	81 c7 77 e5 07 00    	add    $0x7e577,%edi
f01012f7:	8b 75 08             	mov    0x8(%ebp),%esi
	pte_t *pgtable_entry = pgdir_walk(pgdir, va, 1);
f01012fa:	6a 01                	push   $0x1
f01012fc:	ff 75 10             	push   0x10(%ebp)
f01012ff:	56                   	push   %esi
f0101300:	e8 41 fe ff ff       	call   f0101146 <pgdir_walk>
    if (!pgtable_entry)
f0101305:	83 c4 10             	add    $0x10,%esp
f0101308:	85 c0                	test   %eax,%eax
f010130a:	74 56                	je     f0101362 <page_insert+0x7f>
f010130c:	89 c3                	mov    %eax,%ebx
    ++pp->pp_ref;
f010130e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101311:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    if ((*pgtable_entry) & PTE_P) {
f0101316:	f6 03 01             	testb  $0x1,(%ebx)
f0101319:	75 30                	jne    f010134b <page_insert+0x68>
	return (pp - pages) << PGSHIFT;
f010131b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010131e:	2b 87 f0 1a 00 00    	sub    0x1af0(%edi),%eax
f0101324:	c1 f8 03             	sar    $0x3,%eax
f0101327:	c1 e0 0c             	shl    $0xc,%eax
    *pgtable_entry = (page2pa(pp) | perm | PTE_P);
f010132a:	0b 45 14             	or     0x14(%ebp),%eax
f010132d:	83 c8 01             	or     $0x1,%eax
f0101330:	89 03                	mov    %eax,(%ebx)
    *(pgdir + PDX(va)) |= perm;
f0101332:	8b 45 10             	mov    0x10(%ebp),%eax
f0101335:	c1 e8 16             	shr    $0x16,%eax
f0101338:	8b 55 14             	mov    0x14(%ebp),%edx
f010133b:	09 14 86             	or     %edx,(%esi,%eax,4)
    return 0;
f010133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101343:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101346:	5b                   	pop    %ebx
f0101347:	5e                   	pop    %esi
f0101348:	5f                   	pop    %edi
f0101349:	5d                   	pop    %ebp
f010134a:	c3                   	ret    
f010134b:	8b 45 10             	mov    0x10(%ebp),%eax
f010134e:	0f 01 38             	invlpg (%eax)
        page_remove(pgdir, va);
f0101351:	83 ec 08             	sub    $0x8,%esp
f0101354:	ff 75 10             	push   0x10(%ebp)
f0101357:	56                   	push   %esi
f0101358:	e8 4b ff ff ff       	call   f01012a8 <page_remove>
f010135d:	83 c4 10             	add    $0x10,%esp
f0101360:	eb b9                	jmp    f010131b <page_insert+0x38>
        return -E_NO_MEM;
f0101362:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101367:	eb da                	jmp    f0101343 <page_insert+0x60>

f0101369 <mem_init>:
{
f0101369:	55                   	push   %ebp
f010136a:	89 e5                	mov    %esp,%ebp
f010136c:	57                   	push   %edi
f010136d:	56                   	push   %esi
f010136e:	53                   	push   %ebx
f010136f:	83 ec 3c             	sub    $0x3c,%esp
f0101372:	e8 82 f3 ff ff       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0101377:	05 f1 e4 07 00       	add    $0x7e4f1,%eax
f010137c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	basemem = nvram_read(NVRAM_BASELO);
f010137f:	b8 15 00 00 00       	mov    $0x15,%eax
f0101384:	e8 cf f6 ff ff       	call   f0100a58 <nvram_read>
f0101389:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f010138b:	b8 17 00 00 00       	mov    $0x17,%eax
f0101390:	e8 c3 f6 ff ff       	call   f0100a58 <nvram_read>
f0101395:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101397:	b8 34 00 00 00       	mov    $0x34,%eax
f010139c:	e8 b7 f6 ff ff       	call   f0100a58 <nvram_read>
	if (ext16mem)
f01013a1:	c1 e0 06             	shl    $0x6,%eax
f01013a4:	0f 84 f1 00 00 00    	je     f010149b <mem_init+0x132>
		totalmem = 16 * 1024 + ext16mem;
f01013aa:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01013af:	89 c2                	mov    %eax,%edx
f01013b1:	c1 ea 02             	shr    $0x2,%edx
f01013b4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01013b7:	89 91 f8 1a 00 00    	mov    %edx,0x1af8(%ecx)
	npages_basemem = basemem / (PGSIZE / 1024);
f01013bd:	89 da                	mov    %ebx,%edx
f01013bf:	c1 ea 02             	shr    $0x2,%edx
f01013c2:	89 91 08 1b 00 00    	mov    %edx,0x1b08(%ecx)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01013c8:	89 c2                	mov    %eax,%edx
f01013ca:	29 da                	sub    %ebx,%edx
f01013cc:	52                   	push   %edx
f01013cd:	53                   	push   %ebx
f01013ce:	50                   	push   %eax
f01013cf:	8d 81 14 66 f8 ff    	lea    -0x799ec(%ecx),%eax
f01013d5:	50                   	push   %eax
f01013d6:	89 cb                	mov    %ecx,%ebx
f01013d8:	e8 48 26 00 00       	call   f0103a25 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01013dd:	b8 00 10 00 00       	mov    $0x1000,%eax
f01013e2:	e8 a7 f6 ff ff       	call   f0100a8e <boot_alloc>
f01013e7:	89 83 f4 1a 00 00    	mov    %eax,0x1af4(%ebx)
	memset(kern_pgdir, 0, PGSIZE);
f01013ed:	83 c4 0c             	add    $0xc,%esp
f01013f0:	68 00 10 00 00       	push   $0x1000
f01013f5:	6a 00                	push   $0x0
f01013f7:	50                   	push   %eax
f01013f8:	e8 c5 3c 00 00       	call   f01050c2 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01013fd:	8b 83 f4 1a 00 00    	mov    0x1af4(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0101403:	83 c4 10             	add    $0x10,%esp
f0101406:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010140b:	0f 86 9a 00 00 00    	jbe    f01014ab <mem_init+0x142>
	return (physaddr_t)kva - KERNBASE;
f0101411:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101417:	83 ca 05             	or     $0x5,%edx
f010141a:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f0101420:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101423:	8b 87 f8 1a 00 00    	mov    0x1af8(%edi),%eax
f0101429:	c1 e0 03             	shl    $0x3,%eax
f010142c:	e8 5d f6 ff ff       	call   f0100a8e <boot_alloc>
f0101431:	89 87 f0 1a 00 00    	mov    %eax,0x1af0(%edi)
	memset(pages, 0, npages * sizeof(struct PageInfo));
f0101437:	83 ec 04             	sub    $0x4,%esp
f010143a:	8b 97 f8 1a 00 00    	mov    0x1af8(%edi),%edx
f0101440:	c1 e2 03             	shl    $0x3,%edx
f0101443:	52                   	push   %edx
f0101444:	6a 00                	push   $0x0
f0101446:	50                   	push   %eax
f0101447:	89 fb                	mov    %edi,%ebx
f0101449:	e8 74 3c 00 00       	call   f01050c2 <memset>
	envs = (struct Env *)boot_alloc(NENV * sizeof(struct Env));
f010144e:	b8 00 80 01 00       	mov    $0x18000,%eax
f0101453:	e8 36 f6 ff ff       	call   f0100a8e <boot_alloc>
f0101458:	c7 c2 78 13 18 f0    	mov    $0xf0181378,%edx
f010145e:	89 02                	mov    %eax,(%edx)
	memset(envs, 0, NENV * sizeof(struct Env));
f0101460:	83 c4 0c             	add    $0xc,%esp
f0101463:	68 00 80 01 00       	push   $0x18000
f0101468:	6a 00                	push   $0x0
f010146a:	50                   	push   %eax
f010146b:	e8 52 3c 00 00       	call   f01050c2 <memset>
	page_init();
f0101470:	e8 81 fa ff ff       	call   f0100ef6 <page_init>
	check_page_free_list(1);
f0101475:	b8 01 00 00 00       	mov    $0x1,%eax
f010147a:	e8 0b f7 ff ff       	call   f0100b8a <check_page_free_list>
	if (!pages)
f010147f:	83 c4 10             	add    $0x10,%esp
f0101482:	83 bf f0 1a 00 00 00 	cmpl   $0x0,0x1af0(%edi)
f0101489:	74 3c                	je     f01014c7 <mem_init+0x15e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010148b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010148e:	8b 80 04 1b 00 00    	mov    0x1b04(%eax),%eax
f0101494:	be 00 00 00 00       	mov    $0x0,%esi
f0101499:	eb 4f                	jmp    f01014ea <mem_init+0x181>
		totalmem = 1 * 1024 + extmem;
f010149b:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01014a1:	85 f6                	test   %esi,%esi
f01014a3:	0f 44 c3             	cmove  %ebx,%eax
f01014a6:	e9 04 ff ff ff       	jmp    f01013af <mem_init+0x46>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01014ab:	50                   	push   %eax
f01014ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01014af:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f01014b5:	50                   	push   %eax
f01014b6:	68 97 00 00 00       	push   $0x97
f01014bb:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01014c1:	50                   	push   %eax
f01014c2:	e8 ea eb ff ff       	call   f01000b1 <_panic>
		panic("'pages' is a null pointer!");
f01014c7:	83 ec 04             	sub    $0x4,%esp
f01014ca:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01014cd:	8d 83 65 62 f8 ff    	lea    -0x79d9b(%ebx),%eax
f01014d3:	50                   	push   %eax
f01014d4:	68 a7 02 00 00       	push   $0x2a7
f01014d9:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01014df:	50                   	push   %eax
f01014e0:	e8 cc eb ff ff       	call   f01000b1 <_panic>
		++nfree;
f01014e5:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014e8:	8b 00                	mov    (%eax),%eax
f01014ea:	85 c0                	test   %eax,%eax
f01014ec:	75 f7                	jne    f01014e5 <mem_init+0x17c>
	assert((pp0 = page_alloc(0)));
f01014ee:	83 ec 0c             	sub    $0xc,%esp
f01014f1:	6a 00                	push   $0x0
f01014f3:	e8 51 fb ff ff       	call   f0101049 <page_alloc>
f01014f8:	89 c3                	mov    %eax,%ebx
f01014fa:	83 c4 10             	add    $0x10,%esp
f01014fd:	85 c0                	test   %eax,%eax
f01014ff:	0f 84 3a 02 00 00    	je     f010173f <mem_init+0x3d6>
	assert((pp1 = page_alloc(0)));
f0101505:	83 ec 0c             	sub    $0xc,%esp
f0101508:	6a 00                	push   $0x0
f010150a:	e8 3a fb ff ff       	call   f0101049 <page_alloc>
f010150f:	89 c7                	mov    %eax,%edi
f0101511:	83 c4 10             	add    $0x10,%esp
f0101514:	85 c0                	test   %eax,%eax
f0101516:	0f 84 45 02 00 00    	je     f0101761 <mem_init+0x3f8>
	assert((pp2 = page_alloc(0)));
f010151c:	83 ec 0c             	sub    $0xc,%esp
f010151f:	6a 00                	push   $0x0
f0101521:	e8 23 fb ff ff       	call   f0101049 <page_alloc>
f0101526:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101529:	83 c4 10             	add    $0x10,%esp
f010152c:	85 c0                	test   %eax,%eax
f010152e:	0f 84 4f 02 00 00    	je     f0101783 <mem_init+0x41a>
	assert(pp1 && pp1 != pp0);
f0101534:	39 fb                	cmp    %edi,%ebx
f0101536:	0f 84 69 02 00 00    	je     f01017a5 <mem_init+0x43c>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010153c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010153f:	39 c7                	cmp    %eax,%edi
f0101541:	0f 84 80 02 00 00    	je     f01017c7 <mem_init+0x45e>
f0101547:	39 c3                	cmp    %eax,%ebx
f0101549:	0f 84 78 02 00 00    	je     f01017c7 <mem_init+0x45e>
	return (pp - pages) << PGSHIFT;
f010154f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101552:	8b 88 f0 1a 00 00    	mov    0x1af0(%eax),%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101558:	8b 90 f8 1a 00 00    	mov    0x1af8(%eax),%edx
f010155e:	c1 e2 0c             	shl    $0xc,%edx
f0101561:	89 d8                	mov    %ebx,%eax
f0101563:	29 c8                	sub    %ecx,%eax
f0101565:	c1 f8 03             	sar    $0x3,%eax
f0101568:	c1 e0 0c             	shl    $0xc,%eax
f010156b:	39 d0                	cmp    %edx,%eax
f010156d:	0f 83 76 02 00 00    	jae    f01017e9 <mem_init+0x480>
f0101573:	89 f8                	mov    %edi,%eax
f0101575:	29 c8                	sub    %ecx,%eax
f0101577:	c1 f8 03             	sar    $0x3,%eax
f010157a:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010157d:	39 c2                	cmp    %eax,%edx
f010157f:	0f 86 86 02 00 00    	jbe    f010180b <mem_init+0x4a2>
f0101585:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101588:	29 c8                	sub    %ecx,%eax
f010158a:	c1 f8 03             	sar    $0x3,%eax
f010158d:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101590:	39 c2                	cmp    %eax,%edx
f0101592:	0f 86 95 02 00 00    	jbe    f010182d <mem_init+0x4c4>
	fl = page_free_list;
f0101598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010159b:	8b 88 04 1b 00 00    	mov    0x1b04(%eax),%ecx
f01015a1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f01015a4:	c7 80 04 1b 00 00 00 	movl   $0x0,0x1b04(%eax)
f01015ab:	00 00 00 
	assert(!page_alloc(0));
f01015ae:	83 ec 0c             	sub    $0xc,%esp
f01015b1:	6a 00                	push   $0x0
f01015b3:	e8 91 fa ff ff       	call   f0101049 <page_alloc>
f01015b8:	83 c4 10             	add    $0x10,%esp
f01015bb:	85 c0                	test   %eax,%eax
f01015bd:	0f 85 8c 02 00 00    	jne    f010184f <mem_init+0x4e6>
	page_free(pp0);
f01015c3:	83 ec 0c             	sub    $0xc,%esp
f01015c6:	53                   	push   %ebx
f01015c7:	e8 02 fb ff ff       	call   f01010ce <page_free>
	page_free(pp1);
f01015cc:	89 3c 24             	mov    %edi,(%esp)
f01015cf:	e8 fa fa ff ff       	call   f01010ce <page_free>
	page_free(pp2);
f01015d4:	83 c4 04             	add    $0x4,%esp
f01015d7:	ff 75 d0             	push   -0x30(%ebp)
f01015da:	e8 ef fa ff ff       	call   f01010ce <page_free>
	assert((pp0 = page_alloc(0)));
f01015df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01015e6:	e8 5e fa ff ff       	call   f0101049 <page_alloc>
f01015eb:	89 c7                	mov    %eax,%edi
f01015ed:	83 c4 10             	add    $0x10,%esp
f01015f0:	85 c0                	test   %eax,%eax
f01015f2:	0f 84 79 02 00 00    	je     f0101871 <mem_init+0x508>
	assert((pp1 = page_alloc(0)));
f01015f8:	83 ec 0c             	sub    $0xc,%esp
f01015fb:	6a 00                	push   $0x0
f01015fd:	e8 47 fa ff ff       	call   f0101049 <page_alloc>
f0101602:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101605:	83 c4 10             	add    $0x10,%esp
f0101608:	85 c0                	test   %eax,%eax
f010160a:	0f 84 83 02 00 00    	je     f0101893 <mem_init+0x52a>
	assert((pp2 = page_alloc(0)));
f0101610:	83 ec 0c             	sub    $0xc,%esp
f0101613:	6a 00                	push   $0x0
f0101615:	e8 2f fa ff ff       	call   f0101049 <page_alloc>
f010161a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010161d:	83 c4 10             	add    $0x10,%esp
f0101620:	85 c0                	test   %eax,%eax
f0101622:	0f 84 8d 02 00 00    	je     f01018b5 <mem_init+0x54c>
	assert(pp1 && pp1 != pp0);
f0101628:	3b 7d d0             	cmp    -0x30(%ebp),%edi
f010162b:	0f 84 a6 02 00 00    	je     f01018d7 <mem_init+0x56e>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101631:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101634:	39 c7                	cmp    %eax,%edi
f0101636:	0f 84 bd 02 00 00    	je     f01018f9 <mem_init+0x590>
f010163c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f010163f:	0f 84 b4 02 00 00    	je     f01018f9 <mem_init+0x590>
	assert(!page_alloc(0));
f0101645:	83 ec 0c             	sub    $0xc,%esp
f0101648:	6a 00                	push   $0x0
f010164a:	e8 fa f9 ff ff       	call   f0101049 <page_alloc>
f010164f:	83 c4 10             	add    $0x10,%esp
f0101652:	85 c0                	test   %eax,%eax
f0101654:	0f 85 c1 02 00 00    	jne    f010191b <mem_init+0x5b2>
f010165a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010165d:	89 f8                	mov    %edi,%eax
f010165f:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f0101665:	c1 f8 03             	sar    $0x3,%eax
f0101668:	89 c2                	mov    %eax,%edx
f010166a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010166d:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101672:	3b 81 f8 1a 00 00    	cmp    0x1af8(%ecx),%eax
f0101678:	0f 83 bf 02 00 00    	jae    f010193d <mem_init+0x5d4>
	memset(page2kva(pp0), 1, PGSIZE);
f010167e:	83 ec 04             	sub    $0x4,%esp
f0101681:	68 00 10 00 00       	push   $0x1000
f0101686:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101688:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010168e:	52                   	push   %edx
f010168f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101692:	e8 2b 3a 00 00       	call   f01050c2 <memset>
	page_free(pp0);
f0101697:	89 3c 24             	mov    %edi,(%esp)
f010169a:	e8 2f fa ff ff       	call   f01010ce <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010169f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01016a6:	e8 9e f9 ff ff       	call   f0101049 <page_alloc>
f01016ab:	83 c4 10             	add    $0x10,%esp
f01016ae:	85 c0                	test   %eax,%eax
f01016b0:	0f 84 9f 02 00 00    	je     f0101955 <mem_init+0x5ec>
	assert(pp && pp0 == pp);
f01016b6:	39 c7                	cmp    %eax,%edi
f01016b8:	0f 85 b9 02 00 00    	jne    f0101977 <mem_init+0x60e>
	return (pp - pages) << PGSHIFT;
f01016be:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01016c1:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f01016c7:	c1 f8 03             	sar    $0x3,%eax
f01016ca:	89 c2                	mov    %eax,%edx
f01016cc:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01016cf:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01016d4:	3b 81 f8 1a 00 00    	cmp    0x1af8(%ecx),%eax
f01016da:	0f 83 b9 02 00 00    	jae    f0101999 <mem_init+0x630>
	return (void *)(pa + KERNBASE);
f01016e0:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01016e6:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01016ec:	80 38 00             	cmpb   $0x0,(%eax)
f01016ef:	0f 85 bc 02 00 00    	jne    f01019b1 <mem_init+0x648>
	for (i = 0; i < PGSIZE; i++)
f01016f5:	83 c0 01             	add    $0x1,%eax
f01016f8:	39 d0                	cmp    %edx,%eax
f01016fa:	75 f0                	jne    f01016ec <mem_init+0x383>
	page_free_list = fl;
f01016fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016ff:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0101702:	89 8b 04 1b 00 00    	mov    %ecx,0x1b04(%ebx)
	page_free(pp0);
f0101708:	83 ec 0c             	sub    $0xc,%esp
f010170b:	57                   	push   %edi
f010170c:	e8 bd f9 ff ff       	call   f01010ce <page_free>
	page_free(pp1);
f0101711:	83 c4 04             	add    $0x4,%esp
f0101714:	ff 75 d0             	push   -0x30(%ebp)
f0101717:	e8 b2 f9 ff ff       	call   f01010ce <page_free>
	page_free(pp2);
f010171c:	83 c4 04             	add    $0x4,%esp
f010171f:	ff 75 cc             	push   -0x34(%ebp)
f0101722:	e8 a7 f9 ff ff       	call   f01010ce <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101727:	8b 83 04 1b 00 00    	mov    0x1b04(%ebx),%eax
f010172d:	83 c4 10             	add    $0x10,%esp
f0101730:	85 c0                	test   %eax,%eax
f0101732:	0f 84 9b 02 00 00    	je     f01019d3 <mem_init+0x66a>
		--nfree;
f0101738:	83 ee 01             	sub    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010173b:	8b 00                	mov    (%eax),%eax
f010173d:	eb f1                	jmp    f0101730 <mem_init+0x3c7>
	assert((pp0 = page_alloc(0)));
f010173f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101742:	8d 83 80 62 f8 ff    	lea    -0x79d80(%ebx),%eax
f0101748:	50                   	push   %eax
f0101749:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010174f:	50                   	push   %eax
f0101750:	68 af 02 00 00       	push   $0x2af
f0101755:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010175b:	50                   	push   %eax
f010175c:	e8 50 e9 ff ff       	call   f01000b1 <_panic>
	assert((pp1 = page_alloc(0)));
f0101761:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101764:	8d 83 96 62 f8 ff    	lea    -0x79d6a(%ebx),%eax
f010176a:	50                   	push   %eax
f010176b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101771:	50                   	push   %eax
f0101772:	68 b0 02 00 00       	push   $0x2b0
f0101777:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010177d:	50                   	push   %eax
f010177e:	e8 2e e9 ff ff       	call   f01000b1 <_panic>
	assert((pp2 = page_alloc(0)));
f0101783:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101786:	8d 83 ac 62 f8 ff    	lea    -0x79d54(%ebx),%eax
f010178c:	50                   	push   %eax
f010178d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101793:	50                   	push   %eax
f0101794:	68 b1 02 00 00       	push   $0x2b1
f0101799:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010179f:	50                   	push   %eax
f01017a0:	e8 0c e9 ff ff       	call   f01000b1 <_panic>
	assert(pp1 && pp1 != pp0);
f01017a5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017a8:	8d 83 c2 62 f8 ff    	lea    -0x79d3e(%ebx),%eax
f01017ae:	50                   	push   %eax
f01017af:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01017b5:	50                   	push   %eax
f01017b6:	68 b4 02 00 00       	push   $0x2b4
f01017bb:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01017c1:	50                   	push   %eax
f01017c2:	e8 ea e8 ff ff       	call   f01000b1 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ca:	8d 83 50 66 f8 ff    	lea    -0x799b0(%ebx),%eax
f01017d0:	50                   	push   %eax
f01017d1:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01017d7:	50                   	push   %eax
f01017d8:	68 b5 02 00 00       	push   $0x2b5
f01017dd:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01017e3:	50                   	push   %eax
f01017e4:	e8 c8 e8 ff ff       	call   f01000b1 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01017e9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ec:	8d 83 d4 62 f8 ff    	lea    -0x79d2c(%ebx),%eax
f01017f2:	50                   	push   %eax
f01017f3:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01017f9:	50                   	push   %eax
f01017fa:	68 b6 02 00 00       	push   $0x2b6
f01017ff:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101805:	50                   	push   %eax
f0101806:	e8 a6 e8 ff ff       	call   f01000b1 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f010180b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010180e:	8d 83 f1 62 f8 ff    	lea    -0x79d0f(%ebx),%eax
f0101814:	50                   	push   %eax
f0101815:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010181b:	50                   	push   %eax
f010181c:	68 b7 02 00 00       	push   $0x2b7
f0101821:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101827:	50                   	push   %eax
f0101828:	e8 84 e8 ff ff       	call   f01000b1 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f010182d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101830:	8d 83 0e 63 f8 ff    	lea    -0x79cf2(%ebx),%eax
f0101836:	50                   	push   %eax
f0101837:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010183d:	50                   	push   %eax
f010183e:	68 b8 02 00 00       	push   $0x2b8
f0101843:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101849:	50                   	push   %eax
f010184a:	e8 62 e8 ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f010184f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101852:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f0101858:	50                   	push   %eax
f0101859:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010185f:	50                   	push   %eax
f0101860:	68 bf 02 00 00       	push   $0x2bf
f0101865:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010186b:	50                   	push   %eax
f010186c:	e8 40 e8 ff ff       	call   f01000b1 <_panic>
	assert((pp0 = page_alloc(0)));
f0101871:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101874:	8d 83 80 62 f8 ff    	lea    -0x79d80(%ebx),%eax
f010187a:	50                   	push   %eax
f010187b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101881:	50                   	push   %eax
f0101882:	68 c6 02 00 00       	push   $0x2c6
f0101887:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010188d:	50                   	push   %eax
f010188e:	e8 1e e8 ff ff       	call   f01000b1 <_panic>
	assert((pp1 = page_alloc(0)));
f0101893:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101896:	8d 83 96 62 f8 ff    	lea    -0x79d6a(%ebx),%eax
f010189c:	50                   	push   %eax
f010189d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01018a3:	50                   	push   %eax
f01018a4:	68 c7 02 00 00       	push   $0x2c7
f01018a9:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01018af:	50                   	push   %eax
f01018b0:	e8 fc e7 ff ff       	call   f01000b1 <_panic>
	assert((pp2 = page_alloc(0)));
f01018b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018b8:	8d 83 ac 62 f8 ff    	lea    -0x79d54(%ebx),%eax
f01018be:	50                   	push   %eax
f01018bf:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01018c5:	50                   	push   %eax
f01018c6:	68 c8 02 00 00       	push   $0x2c8
f01018cb:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01018d1:	50                   	push   %eax
f01018d2:	e8 da e7 ff ff       	call   f01000b1 <_panic>
	assert(pp1 && pp1 != pp0);
f01018d7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018da:	8d 83 c2 62 f8 ff    	lea    -0x79d3e(%ebx),%eax
f01018e0:	50                   	push   %eax
f01018e1:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01018e7:	50                   	push   %eax
f01018e8:	68 ca 02 00 00       	push   $0x2ca
f01018ed:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01018f3:	50                   	push   %eax
f01018f4:	e8 b8 e7 ff ff       	call   f01000b1 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018f9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018fc:	8d 83 50 66 f8 ff    	lea    -0x799b0(%ebx),%eax
f0101902:	50                   	push   %eax
f0101903:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101909:	50                   	push   %eax
f010190a:	68 cb 02 00 00       	push   $0x2cb
f010190f:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101915:	50                   	push   %eax
f0101916:	e8 96 e7 ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f010191b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010191e:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f0101924:	50                   	push   %eax
f0101925:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010192b:	50                   	push   %eax
f010192c:	68 cc 02 00 00       	push   $0x2cc
f0101931:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101937:	50                   	push   %eax
f0101938:	e8 74 e7 ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010193d:	52                   	push   %edx
f010193e:	89 cb                	mov    %ecx,%ebx
f0101940:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0101946:	50                   	push   %eax
f0101947:	6a 56                	push   $0x56
f0101949:	8d 81 bb 61 f8 ff    	lea    -0x79e45(%ecx),%eax
f010194f:	50                   	push   %eax
f0101950:	e8 5c e7 ff ff       	call   f01000b1 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101955:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101958:	8d 83 3a 63 f8 ff    	lea    -0x79cc6(%ebx),%eax
f010195e:	50                   	push   %eax
f010195f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101965:	50                   	push   %eax
f0101966:	68 d1 02 00 00       	push   $0x2d1
f010196b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101971:	50                   	push   %eax
f0101972:	e8 3a e7 ff ff       	call   f01000b1 <_panic>
	assert(pp && pp0 == pp);
f0101977:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010197a:	8d 83 58 63 f8 ff    	lea    -0x79ca8(%ebx),%eax
f0101980:	50                   	push   %eax
f0101981:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0101987:	50                   	push   %eax
f0101988:	68 d2 02 00 00       	push   $0x2d2
f010198d:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0101993:	50                   	push   %eax
f0101994:	e8 18 e7 ff ff       	call   f01000b1 <_panic>
f0101999:	52                   	push   %edx
f010199a:	89 cb                	mov    %ecx,%ebx
f010199c:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f01019a2:	50                   	push   %eax
f01019a3:	6a 56                	push   $0x56
f01019a5:	8d 81 bb 61 f8 ff    	lea    -0x79e45(%ecx),%eax
f01019ab:	50                   	push   %eax
f01019ac:	e8 00 e7 ff ff       	call   f01000b1 <_panic>
		assert(c[i] == 0);
f01019b1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01019b4:	8d 83 68 63 f8 ff    	lea    -0x79c98(%ebx),%eax
f01019ba:	50                   	push   %eax
f01019bb:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01019c1:	50                   	push   %eax
f01019c2:	68 d5 02 00 00       	push   $0x2d5
f01019c7:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01019cd:	50                   	push   %eax
f01019ce:	e8 de e6 ff ff       	call   f01000b1 <_panic>
	assert(nfree == 0);
f01019d3:	85 f6                	test   %esi,%esi
f01019d5:	0f 85 31 08 00 00    	jne    f010220c <mem_init+0xea3>
	cprintf("check_page_alloc() succeeded!\n");
f01019db:	83 ec 0c             	sub    $0xc,%esp
f01019de:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01019e1:	8d 83 70 66 f8 ff    	lea    -0x79990(%ebx),%eax
f01019e7:	50                   	push   %eax
f01019e8:	e8 38 20 00 00       	call   f0103a25 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01019ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019f4:	e8 50 f6 ff ff       	call   f0101049 <page_alloc>
f01019f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01019fc:	83 c4 10             	add    $0x10,%esp
f01019ff:	85 c0                	test   %eax,%eax
f0101a01:	0f 84 27 08 00 00    	je     f010222e <mem_init+0xec5>
	assert((pp1 = page_alloc(0)));
f0101a07:	83 ec 0c             	sub    $0xc,%esp
f0101a0a:	6a 00                	push   $0x0
f0101a0c:	e8 38 f6 ff ff       	call   f0101049 <page_alloc>
f0101a11:	89 c7                	mov    %eax,%edi
f0101a13:	83 c4 10             	add    $0x10,%esp
f0101a16:	85 c0                	test   %eax,%eax
f0101a18:	0f 84 32 08 00 00    	je     f0102250 <mem_init+0xee7>
	assert((pp2 = page_alloc(0)));
f0101a1e:	83 ec 0c             	sub    $0xc,%esp
f0101a21:	6a 00                	push   $0x0
f0101a23:	e8 21 f6 ff ff       	call   f0101049 <page_alloc>
f0101a28:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101a2b:	83 c4 10             	add    $0x10,%esp
f0101a2e:	85 c0                	test   %eax,%eax
f0101a30:	0f 84 3c 08 00 00    	je     f0102272 <mem_init+0xf09>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101a36:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0101a39:	0f 84 55 08 00 00    	je     f0102294 <mem_init+0xf2b>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a42:	39 c7                	cmp    %eax,%edi
f0101a44:	0f 84 6c 08 00 00    	je     f01022b6 <mem_init+0xf4d>
f0101a4a:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0101a4d:	0f 84 63 08 00 00    	je     f01022b6 <mem_init+0xf4d>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101a53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a56:	8b 88 04 1b 00 00    	mov    0x1b04(%eax),%ecx
f0101a5c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f0101a5f:	c7 80 04 1b 00 00 00 	movl   $0x0,0x1b04(%eax)
f0101a66:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101a69:	83 ec 0c             	sub    $0xc,%esp
f0101a6c:	6a 00                	push   $0x0
f0101a6e:	e8 d6 f5 ff ff       	call   f0101049 <page_alloc>
f0101a73:	83 c4 10             	add    $0x10,%esp
f0101a76:	85 c0                	test   %eax,%eax
f0101a78:	0f 85 5a 08 00 00    	jne    f01022d8 <mem_init+0xf6f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101a7e:	83 ec 04             	sub    $0x4,%esp
f0101a81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a84:	50                   	push   %eax
f0101a85:	6a 00                	push   $0x0
f0101a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a8a:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101a90:	e8 a2 f7 ff ff       	call   f0101237 <page_lookup>
f0101a95:	83 c4 10             	add    $0x10,%esp
f0101a98:	85 c0                	test   %eax,%eax
f0101a9a:	0f 85 5a 08 00 00    	jne    f01022fa <mem_init+0xf91>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101aa0:	6a 02                	push   $0x2
f0101aa2:	6a 00                	push   $0x0
f0101aa4:	57                   	push   %edi
f0101aa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101aa8:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101aae:	e8 30 f8 ff ff       	call   f01012e3 <page_insert>
f0101ab3:	83 c4 10             	add    $0x10,%esp
f0101ab6:	85 c0                	test   %eax,%eax
f0101ab8:	0f 89 5e 08 00 00    	jns    f010231c <mem_init+0xfb3>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101abe:	83 ec 0c             	sub    $0xc,%esp
f0101ac1:	ff 75 cc             	push   -0x34(%ebp)
f0101ac4:	e8 05 f6 ff ff       	call   f01010ce <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101ac9:	6a 02                	push   $0x2
f0101acb:	6a 00                	push   $0x0
f0101acd:	57                   	push   %edi
f0101ace:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ad1:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101ad7:	e8 07 f8 ff ff       	call   f01012e3 <page_insert>
f0101adc:	83 c4 20             	add    $0x20,%esp
f0101adf:	85 c0                	test   %eax,%eax
f0101ae1:	0f 85 57 08 00 00    	jne    f010233e <mem_init+0xfd5>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101ae7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101aea:	8b 98 f4 1a 00 00    	mov    0x1af4(%eax),%ebx
	return (pp - pages) << PGSHIFT;
f0101af0:	8b b0 f0 1a 00 00    	mov    0x1af0(%eax),%esi
f0101af6:	8b 13                	mov    (%ebx),%edx
f0101af8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101b01:	29 f0                	sub    %esi,%eax
f0101b03:	c1 f8 03             	sar    $0x3,%eax
f0101b06:	c1 e0 0c             	shl    $0xc,%eax
f0101b09:	39 c2                	cmp    %eax,%edx
f0101b0b:	0f 85 4f 08 00 00    	jne    f0102360 <mem_init+0xff7>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101b11:	ba 00 00 00 00       	mov    $0x0,%edx
f0101b16:	89 d8                	mov    %ebx,%eax
f0101b18:	e8 f1 ef ff ff       	call   f0100b0e <check_va2pa>
f0101b1d:	89 c2                	mov    %eax,%edx
f0101b1f:	89 f8                	mov    %edi,%eax
f0101b21:	29 f0                	sub    %esi,%eax
f0101b23:	c1 f8 03             	sar    $0x3,%eax
f0101b26:	c1 e0 0c             	shl    $0xc,%eax
f0101b29:	39 c2                	cmp    %eax,%edx
f0101b2b:	0f 85 51 08 00 00    	jne    f0102382 <mem_init+0x1019>
	assert(pp1->pp_ref == 1);
f0101b31:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101b36:	0f 85 68 08 00 00    	jne    f01023a4 <mem_init+0x103b>
	assert(pp0->pp_ref == 1);
f0101b3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101b3f:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101b44:	0f 85 7c 08 00 00    	jne    f01023c6 <mem_init+0x105d>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b4a:	6a 02                	push   $0x2
f0101b4c:	68 00 10 00 00       	push   $0x1000
f0101b51:	ff 75 d0             	push   -0x30(%ebp)
f0101b54:	53                   	push   %ebx
f0101b55:	e8 89 f7 ff ff       	call   f01012e3 <page_insert>
f0101b5a:	83 c4 10             	add    $0x10,%esp
f0101b5d:	85 c0                	test   %eax,%eax
f0101b5f:	0f 85 83 08 00 00    	jne    f01023e8 <mem_init+0x107f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b65:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b6a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101b6d:	8b 83 f4 1a 00 00    	mov    0x1af4(%ebx),%eax
f0101b73:	e8 96 ef ff ff       	call   f0100b0e <check_va2pa>
f0101b78:	89 c2                	mov    %eax,%edx
f0101b7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b7d:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0101b83:	c1 f8 03             	sar    $0x3,%eax
f0101b86:	c1 e0 0c             	shl    $0xc,%eax
f0101b89:	39 c2                	cmp    %eax,%edx
f0101b8b:	0f 85 79 08 00 00    	jne    f010240a <mem_init+0x10a1>
	assert(pp2->pp_ref == 1);
f0101b91:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b94:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101b99:	0f 85 8d 08 00 00    	jne    f010242c <mem_init+0x10c3>

	// should be no free memory
	assert(!page_alloc(0));
f0101b9f:	83 ec 0c             	sub    $0xc,%esp
f0101ba2:	6a 00                	push   $0x0
f0101ba4:	e8 a0 f4 ff ff       	call   f0101049 <page_alloc>
f0101ba9:	83 c4 10             	add    $0x10,%esp
f0101bac:	85 c0                	test   %eax,%eax
f0101bae:	0f 85 9a 08 00 00    	jne    f010244e <mem_init+0x10e5>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101bb4:	6a 02                	push   $0x2
f0101bb6:	68 00 10 00 00       	push   $0x1000
f0101bbb:	ff 75 d0             	push   -0x30(%ebp)
f0101bbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101bc1:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101bc7:	e8 17 f7 ff ff       	call   f01012e3 <page_insert>
f0101bcc:	83 c4 10             	add    $0x10,%esp
f0101bcf:	85 c0                	test   %eax,%eax
f0101bd1:	0f 85 99 08 00 00    	jne    f0102470 <mem_init+0x1107>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101bd7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101bdc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101bdf:	8b 83 f4 1a 00 00    	mov    0x1af4(%ebx),%eax
f0101be5:	e8 24 ef ff ff       	call   f0100b0e <check_va2pa>
f0101bea:	89 c2                	mov    %eax,%edx
f0101bec:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101bef:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0101bf5:	c1 f8 03             	sar    $0x3,%eax
f0101bf8:	c1 e0 0c             	shl    $0xc,%eax
f0101bfb:	39 c2                	cmp    %eax,%edx
f0101bfd:	0f 85 8f 08 00 00    	jne    f0102492 <mem_init+0x1129>
	assert(pp2->pp_ref == 1);
f0101c03:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c06:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c0b:	0f 85 a3 08 00 00    	jne    f01024b4 <mem_init+0x114b>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101c11:	83 ec 0c             	sub    $0xc,%esp
f0101c14:	6a 00                	push   $0x0
f0101c16:	e8 2e f4 ff ff       	call   f0101049 <page_alloc>
f0101c1b:	83 c4 10             	add    $0x10,%esp
f0101c1e:	85 c0                	test   %eax,%eax
f0101c20:	0f 85 b0 08 00 00    	jne    f01024d6 <mem_init+0x116d>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101c26:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101c29:	8b 91 f4 1a 00 00    	mov    0x1af4(%ecx),%edx
f0101c2f:	8b 02                	mov    (%edx),%eax
f0101c31:	89 c3                	mov    %eax,%ebx
f0101c33:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f0101c39:	c1 e8 0c             	shr    $0xc,%eax
f0101c3c:	3b 81 f8 1a 00 00    	cmp    0x1af8(%ecx),%eax
f0101c42:	0f 83 b0 08 00 00    	jae    f01024f8 <mem_init+0x118f>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101c48:	83 ec 04             	sub    $0x4,%esp
f0101c4b:	6a 00                	push   $0x0
f0101c4d:	68 00 10 00 00       	push   $0x1000
f0101c52:	52                   	push   %edx
f0101c53:	e8 ee f4 ff ff       	call   f0101146 <pgdir_walk>
f0101c58:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101c5e:	83 c4 10             	add    $0x10,%esp
f0101c61:	39 d8                	cmp    %ebx,%eax
f0101c63:	0f 85 aa 08 00 00    	jne    f0102513 <mem_init+0x11aa>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101c69:	6a 06                	push   $0x6
f0101c6b:	68 00 10 00 00       	push   $0x1000
f0101c70:	ff 75 d0             	push   -0x30(%ebp)
f0101c73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c76:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101c7c:	e8 62 f6 ff ff       	call   f01012e3 <page_insert>
f0101c81:	83 c4 10             	add    $0x10,%esp
f0101c84:	85 c0                	test   %eax,%eax
f0101c86:	0f 85 a9 08 00 00    	jne    f0102535 <mem_init+0x11cc>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c8c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101c8f:	8b 9e f4 1a 00 00    	mov    0x1af4(%esi),%ebx
f0101c95:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c9a:	89 d8                	mov    %ebx,%eax
f0101c9c:	e8 6d ee ff ff       	call   f0100b0e <check_va2pa>
f0101ca1:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101ca3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ca6:	2b 86 f0 1a 00 00    	sub    0x1af0(%esi),%eax
f0101cac:	c1 f8 03             	sar    $0x3,%eax
f0101caf:	c1 e0 0c             	shl    $0xc,%eax
f0101cb2:	39 c2                	cmp    %eax,%edx
f0101cb4:	0f 85 9d 08 00 00    	jne    f0102557 <mem_init+0x11ee>
	assert(pp2->pp_ref == 1);
f0101cba:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101cbd:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101cc2:	0f 85 b1 08 00 00    	jne    f0102579 <mem_init+0x1210>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101cc8:	83 ec 04             	sub    $0x4,%esp
f0101ccb:	6a 00                	push   $0x0
f0101ccd:	68 00 10 00 00       	push   $0x1000
f0101cd2:	53                   	push   %ebx
f0101cd3:	e8 6e f4 ff ff       	call   f0101146 <pgdir_walk>
f0101cd8:	83 c4 10             	add    $0x10,%esp
f0101cdb:	f6 00 04             	testb  $0x4,(%eax)
f0101cde:	0f 84 b7 08 00 00    	je     f010259b <mem_init+0x1232>
	assert(kern_pgdir[0] & PTE_U);
f0101ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ce7:	8b 80 f4 1a 00 00    	mov    0x1af4(%eax),%eax
f0101ced:	f6 00 04             	testb  $0x4,(%eax)
f0101cf0:	0f 84 c7 08 00 00    	je     f01025bd <mem_init+0x1254>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101cf6:	6a 02                	push   $0x2
f0101cf8:	68 00 10 00 00       	push   $0x1000
f0101cfd:	ff 75 d0             	push   -0x30(%ebp)
f0101d00:	50                   	push   %eax
f0101d01:	e8 dd f5 ff ff       	call   f01012e3 <page_insert>
f0101d06:	83 c4 10             	add    $0x10,%esp
f0101d09:	85 c0                	test   %eax,%eax
f0101d0b:	0f 85 ce 08 00 00    	jne    f01025df <mem_init+0x1276>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101d11:	83 ec 04             	sub    $0x4,%esp
f0101d14:	6a 00                	push   $0x0
f0101d16:	68 00 10 00 00       	push   $0x1000
f0101d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d1e:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101d24:	e8 1d f4 ff ff       	call   f0101146 <pgdir_walk>
f0101d29:	83 c4 10             	add    $0x10,%esp
f0101d2c:	f6 00 02             	testb  $0x2,(%eax)
f0101d2f:	0f 84 cc 08 00 00    	je     f0102601 <mem_init+0x1298>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d35:	83 ec 04             	sub    $0x4,%esp
f0101d38:	6a 00                	push   $0x0
f0101d3a:	68 00 10 00 00       	push   $0x1000
f0101d3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d42:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101d48:	e8 f9 f3 ff ff       	call   f0101146 <pgdir_walk>
f0101d4d:	83 c4 10             	add    $0x10,%esp
f0101d50:	f6 00 04             	testb  $0x4,(%eax)
f0101d53:	0f 85 ca 08 00 00    	jne    f0102623 <mem_init+0x12ba>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101d59:	6a 02                	push   $0x2
f0101d5b:	68 00 00 40 00       	push   $0x400000
f0101d60:	ff 75 cc             	push   -0x34(%ebp)
f0101d63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d66:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101d6c:	e8 72 f5 ff ff       	call   f01012e3 <page_insert>
f0101d71:	83 c4 10             	add    $0x10,%esp
f0101d74:	85 c0                	test   %eax,%eax
f0101d76:	0f 89 c9 08 00 00    	jns    f0102645 <mem_init+0x12dc>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101d7c:	6a 02                	push   $0x2
f0101d7e:	68 00 10 00 00       	push   $0x1000
f0101d83:	57                   	push   %edi
f0101d84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d87:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101d8d:	e8 51 f5 ff ff       	call   f01012e3 <page_insert>
f0101d92:	83 c4 10             	add    $0x10,%esp
f0101d95:	85 c0                	test   %eax,%eax
f0101d97:	0f 85 ca 08 00 00    	jne    f0102667 <mem_init+0x12fe>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d9d:	83 ec 04             	sub    $0x4,%esp
f0101da0:	6a 00                	push   $0x0
f0101da2:	68 00 10 00 00       	push   $0x1000
f0101da7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101daa:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0101db0:	e8 91 f3 ff ff       	call   f0101146 <pgdir_walk>
f0101db5:	83 c4 10             	add    $0x10,%esp
f0101db8:	f6 00 04             	testb  $0x4,(%eax)
f0101dbb:	0f 85 c8 08 00 00    	jne    f0102689 <mem_init+0x1320>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101dc1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101dc4:	8b b3 f4 1a 00 00    	mov    0x1af4(%ebx),%esi
f0101dca:	ba 00 00 00 00       	mov    $0x0,%edx
f0101dcf:	89 f0                	mov    %esi,%eax
f0101dd1:	e8 38 ed ff ff       	call   f0100b0e <check_va2pa>
f0101dd6:	89 d9                	mov    %ebx,%ecx
f0101dd8:	89 fb                	mov    %edi,%ebx
f0101dda:	2b 99 f0 1a 00 00    	sub    0x1af0(%ecx),%ebx
f0101de0:	c1 fb 03             	sar    $0x3,%ebx
f0101de3:	c1 e3 0c             	shl    $0xc,%ebx
f0101de6:	39 d8                	cmp    %ebx,%eax
f0101de8:	0f 85 bd 08 00 00    	jne    f01026ab <mem_init+0x1342>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101dee:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101df3:	89 f0                	mov    %esi,%eax
f0101df5:	e8 14 ed ff ff       	call   f0100b0e <check_va2pa>
f0101dfa:	39 c3                	cmp    %eax,%ebx
f0101dfc:	0f 85 cb 08 00 00    	jne    f01026cd <mem_init+0x1364>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101e02:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101e07:	0f 85 e2 08 00 00    	jne    f01026ef <mem_init+0x1386>
	assert(pp2->pp_ref == 0);
f0101e0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101e10:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101e15:	0f 85 f6 08 00 00    	jne    f0102711 <mem_init+0x13a8>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101e1b:	83 ec 0c             	sub    $0xc,%esp
f0101e1e:	6a 00                	push   $0x0
f0101e20:	e8 24 f2 ff ff       	call   f0101049 <page_alloc>
f0101e25:	83 c4 10             	add    $0x10,%esp
f0101e28:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101e2b:	0f 85 02 09 00 00    	jne    f0102733 <mem_init+0x13ca>
f0101e31:	85 c0                	test   %eax,%eax
f0101e33:	0f 84 fa 08 00 00    	je     f0102733 <mem_init+0x13ca>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101e39:	83 ec 08             	sub    $0x8,%esp
f0101e3c:	6a 00                	push   $0x0
f0101e3e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101e41:	ff b3 f4 1a 00 00    	push   0x1af4(%ebx)
f0101e47:	e8 5c f4 ff ff       	call   f01012a8 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e4c:	8b 9b f4 1a 00 00    	mov    0x1af4(%ebx),%ebx
f0101e52:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e57:	89 d8                	mov    %ebx,%eax
f0101e59:	e8 b0 ec ff ff       	call   f0100b0e <check_va2pa>
f0101e5e:	83 c4 10             	add    $0x10,%esp
f0101e61:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e64:	0f 85 eb 08 00 00    	jne    f0102755 <mem_init+0x13ec>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e6a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e6f:	89 d8                	mov    %ebx,%eax
f0101e71:	e8 98 ec ff ff       	call   f0100b0e <check_va2pa>
f0101e76:	89 c2                	mov    %eax,%edx
f0101e78:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101e7b:	89 f8                	mov    %edi,%eax
f0101e7d:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f0101e83:	c1 f8 03             	sar    $0x3,%eax
f0101e86:	c1 e0 0c             	shl    $0xc,%eax
f0101e89:	39 c2                	cmp    %eax,%edx
f0101e8b:	0f 85 e6 08 00 00    	jne    f0102777 <mem_init+0x140e>
	assert(pp1->pp_ref == 1);
f0101e91:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e96:	0f 85 fc 08 00 00    	jne    f0102798 <mem_init+0x142f>
	assert(pp2->pp_ref == 0);
f0101e9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101e9f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101ea4:	0f 85 10 09 00 00    	jne    f01027ba <mem_init+0x1451>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101eaa:	6a 00                	push   $0x0
f0101eac:	68 00 10 00 00       	push   $0x1000
f0101eb1:	57                   	push   %edi
f0101eb2:	53                   	push   %ebx
f0101eb3:	e8 2b f4 ff ff       	call   f01012e3 <page_insert>
f0101eb8:	83 c4 10             	add    $0x10,%esp
f0101ebb:	85 c0                	test   %eax,%eax
f0101ebd:	0f 85 19 09 00 00    	jne    f01027dc <mem_init+0x1473>
	assert(pp1->pp_ref);
f0101ec3:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101ec8:	0f 84 30 09 00 00    	je     f01027fe <mem_init+0x1495>
	assert(pp1->pp_link == NULL);
f0101ece:	83 3f 00             	cmpl   $0x0,(%edi)
f0101ed1:	0f 85 49 09 00 00    	jne    f0102820 <mem_init+0x14b7>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101ed7:	83 ec 08             	sub    $0x8,%esp
f0101eda:	68 00 10 00 00       	push   $0x1000
f0101edf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101ee2:	ff b3 f4 1a 00 00    	push   0x1af4(%ebx)
f0101ee8:	e8 bb f3 ff ff       	call   f01012a8 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101eed:	8b 9b f4 1a 00 00    	mov    0x1af4(%ebx),%ebx
f0101ef3:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ef8:	89 d8                	mov    %ebx,%eax
f0101efa:	e8 0f ec ff ff       	call   f0100b0e <check_va2pa>
f0101eff:	83 c4 10             	add    $0x10,%esp
f0101f02:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f05:	0f 85 37 09 00 00    	jne    f0102842 <mem_init+0x14d9>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101f0b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f10:	89 d8                	mov    %ebx,%eax
f0101f12:	e8 f7 eb ff ff       	call   f0100b0e <check_va2pa>
f0101f17:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f1a:	0f 85 44 09 00 00    	jne    f0102864 <mem_init+0x14fb>
	assert(pp1->pp_ref == 0);
f0101f20:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101f25:	0f 85 5b 09 00 00    	jne    f0102886 <mem_init+0x151d>
	assert(pp2->pp_ref == 0);
f0101f2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f2e:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101f33:	0f 85 6f 09 00 00    	jne    f01028a8 <mem_init+0x153f>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101f39:	83 ec 0c             	sub    $0xc,%esp
f0101f3c:	6a 00                	push   $0x0
f0101f3e:	e8 06 f1 ff ff       	call   f0101049 <page_alloc>
f0101f43:	83 c4 10             	add    $0x10,%esp
f0101f46:	85 c0                	test   %eax,%eax
f0101f48:	0f 84 7c 09 00 00    	je     f01028ca <mem_init+0x1561>
f0101f4e:	39 c7                	cmp    %eax,%edi
f0101f50:	0f 85 74 09 00 00    	jne    f01028ca <mem_init+0x1561>

	// should be no free memory
	assert(!page_alloc(0));
f0101f56:	83 ec 0c             	sub    $0xc,%esp
f0101f59:	6a 00                	push   $0x0
f0101f5b:	e8 e9 f0 ff ff       	call   f0101049 <page_alloc>
f0101f60:	83 c4 10             	add    $0x10,%esp
f0101f63:	85 c0                	test   %eax,%eax
f0101f65:	0f 85 81 09 00 00    	jne    f01028ec <mem_init+0x1583>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f6e:	8b 88 f4 1a 00 00    	mov    0x1af4(%eax),%ecx
f0101f74:	8b 11                	mov    (%ecx),%edx
f0101f76:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f7c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101f7f:	2b 98 f0 1a 00 00    	sub    0x1af0(%eax),%ebx
f0101f85:	89 d8                	mov    %ebx,%eax
f0101f87:	c1 f8 03             	sar    $0x3,%eax
f0101f8a:	c1 e0 0c             	shl    $0xc,%eax
f0101f8d:	39 c2                	cmp    %eax,%edx
f0101f8f:	0f 85 79 09 00 00    	jne    f010290e <mem_init+0x15a5>
	kern_pgdir[0] = 0;
f0101f95:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101f9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101f9e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101fa3:	0f 85 87 09 00 00    	jne    f0102930 <mem_init+0x15c7>
	pp0->pp_ref = 0;
f0101fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101fac:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101fb2:	83 ec 0c             	sub    $0xc,%esp
f0101fb5:	50                   	push   %eax
f0101fb6:	e8 13 f1 ff ff       	call   f01010ce <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101fbb:	83 c4 0c             	add    $0xc,%esp
f0101fbe:	6a 01                	push   $0x1
f0101fc0:	68 00 10 40 00       	push   $0x401000
f0101fc5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101fc8:	ff b3 f4 1a 00 00    	push   0x1af4(%ebx)
f0101fce:	e8 73 f1 ff ff       	call   f0101146 <pgdir_walk>
f0101fd3:	89 c6                	mov    %eax,%esi
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101fd5:	89 d9                	mov    %ebx,%ecx
f0101fd7:	8b 9b f4 1a 00 00    	mov    0x1af4(%ebx),%ebx
f0101fdd:	8b 43 04             	mov    0x4(%ebx),%eax
f0101fe0:	89 c2                	mov    %eax,%edx
f0101fe2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101fe8:	8b 89 f8 1a 00 00    	mov    0x1af8(%ecx),%ecx
f0101fee:	c1 e8 0c             	shr    $0xc,%eax
f0101ff1:	83 c4 10             	add    $0x10,%esp
f0101ff4:	39 c8                	cmp    %ecx,%eax
f0101ff6:	0f 83 56 09 00 00    	jae    f0102952 <mem_init+0x15e9>
	assert(ptep == ptep1 + PTX(va));
f0101ffc:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0102002:	39 d6                	cmp    %edx,%esi
f0102004:	0f 85 64 09 00 00    	jne    f010296e <mem_init+0x1605>
	kern_pgdir[PDX(va)] = 0;
f010200a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	pp0->pp_ref = 0;
f0102011:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102014:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010201a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010201d:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0102023:	c1 f8 03             	sar    $0x3,%eax
f0102026:	89 c2                	mov    %eax,%edx
f0102028:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010202b:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102030:	39 c1                	cmp    %eax,%ecx
f0102032:	0f 86 58 09 00 00    	jbe    f0102990 <mem_init+0x1627>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102038:	83 ec 04             	sub    $0x4,%esp
f010203b:	68 00 10 00 00       	push   $0x1000
f0102040:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0102045:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010204b:	52                   	push   %edx
f010204c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010204f:	e8 6e 30 00 00       	call   f01050c2 <memset>
	page_free(pp0);
f0102054:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0102057:	89 34 24             	mov    %esi,(%esp)
f010205a:	e8 6f f0 ff ff       	call   f01010ce <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f010205f:	83 c4 0c             	add    $0xc,%esp
f0102062:	6a 01                	push   $0x1
f0102064:	6a 00                	push   $0x0
f0102066:	ff b3 f4 1a 00 00    	push   0x1af4(%ebx)
f010206c:	e8 d5 f0 ff ff       	call   f0101146 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102071:	89 f0                	mov    %esi,%eax
f0102073:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0102079:	c1 f8 03             	sar    $0x3,%eax
f010207c:	89 c2                	mov    %eax,%edx
f010207e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102081:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102086:	83 c4 10             	add    $0x10,%esp
f0102089:	3b 83 f8 1a 00 00    	cmp    0x1af8(%ebx),%eax
f010208f:	0f 83 11 09 00 00    	jae    f01029a6 <mem_init+0x163d>
	return (void *)(pa + KERNBASE);
f0102095:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010209b:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01020a1:	8b 30                	mov    (%eax),%esi
f01020a3:	83 e6 01             	and    $0x1,%esi
f01020a6:	0f 85 13 09 00 00    	jne    f01029bf <mem_init+0x1656>
	for(i=0; i<NPTENTRIES; i++)
f01020ac:	83 c0 04             	add    $0x4,%eax
f01020af:	39 c2                	cmp    %eax,%edx
f01020b1:	75 ee                	jne    f01020a1 <mem_init+0xd38>
	kern_pgdir[0] = 0;
f01020b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01020b6:	8b 83 f4 1a 00 00    	mov    0x1af4(%ebx),%eax
f01020bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01020c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01020c5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f01020cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
f01020ce:	89 93 04 1b 00 00    	mov    %edx,0x1b04(%ebx)

	// free the pages we took
	page_free(pp0);
f01020d4:	83 ec 0c             	sub    $0xc,%esp
f01020d7:	50                   	push   %eax
f01020d8:	e8 f1 ef ff ff       	call   f01010ce <page_free>
	page_free(pp1);
f01020dd:	89 3c 24             	mov    %edi,(%esp)
f01020e0:	e8 e9 ef ff ff       	call   f01010ce <page_free>
	page_free(pp2);
f01020e5:	83 c4 04             	add    $0x4,%esp
f01020e8:	ff 75 d0             	push   -0x30(%ebp)
f01020eb:	e8 de ef ff ff       	call   f01010ce <page_free>

	cprintf("check_page() succeeded!\n");
f01020f0:	8d 83 49 64 f8 ff    	lea    -0x79bb7(%ebx),%eax
f01020f6:	89 04 24             	mov    %eax,(%esp)
f01020f9:	e8 27 19 00 00       	call   f0103a25 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01020fe:	8b 83 f0 1a 00 00    	mov    0x1af0(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0102104:	83 c4 10             	add    $0x10,%esp
f0102107:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010210c:	0f 86 cf 08 00 00    	jbe    f01029e1 <mem_init+0x1678>
f0102112:	83 ec 08             	sub    $0x8,%esp
f0102115:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102117:	05 00 00 00 10       	add    $0x10000000,%eax
f010211c:	50                   	push   %eax
f010211d:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102122:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102127:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010212a:	8b 87 f4 1a 00 00    	mov    0x1af4(%edi),%eax
f0102130:	e8 b6 f0 ff ff       	call   f01011eb <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U | PTE_P);
f0102135:	c7 c0 78 13 18 f0    	mov    $0xf0181378,%eax
f010213b:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010213d:	83 c4 10             	add    $0x10,%esp
f0102140:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102145:	0f 86 b2 08 00 00    	jbe    f01029fd <mem_init+0x1694>
f010214b:	83 ec 08             	sub    $0x8,%esp
f010214e:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102150:	05 00 00 00 10       	add    $0x10000000,%eax
f0102155:	50                   	push   %eax
f0102156:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010215b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102160:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102163:	8b 87 f4 1a 00 00    	mov    0x1af4(%edi),%eax
f0102169:	e8 7d f0 ff ff       	call   f01011eb <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010216e:	c7 c0 00 30 11 f0    	mov    $0xf0113000,%eax
f0102174:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102177:	83 c4 10             	add    $0x10,%esp
f010217a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010217f:	0f 86 94 08 00 00    	jbe    f0102a19 <mem_init+0x16b0>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102185:	83 ec 08             	sub    $0x8,%esp
f0102188:	6a 02                	push   $0x2
	return (physaddr_t)kva - KERNBASE;
f010218a:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010218d:	05 00 00 00 10       	add    $0x10000000,%eax
f0102192:	50                   	push   %eax
f0102193:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102198:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010219d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01021a0:	8b 87 f4 1a 00 00    	mov    0x1af4(%edi),%eax
f01021a6:	e8 40 f0 ff ff       	call   f01011eb <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE, (physaddr_t)0, PTE_W);
f01021ab:	83 c4 08             	add    $0x8,%esp
f01021ae:	6a 02                	push   $0x2
f01021b0:	6a 00                	push   $0x0
f01021b2:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01021b7:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01021bc:	8b 87 f4 1a 00 00    	mov    0x1af4(%edi),%eax
f01021c2:	e8 24 f0 ff ff       	call   f01011eb <boot_map_region>
	pgdir = kern_pgdir;
f01021c7:	89 f9                	mov    %edi,%ecx
f01021c9:	8b bf f4 1a 00 00    	mov    0x1af4(%edi),%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01021cf:	8b 81 f8 1a 00 00    	mov    0x1af8(%ecx),%eax
f01021d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01021d8:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01021df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01021e4:	89 c2                	mov    %eax,%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01021e6:	8b 81 f0 1a 00 00    	mov    0x1af0(%ecx),%eax
f01021ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
f01021ef:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
f01021f5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01021f8:	83 c4 10             	add    $0x10,%esp
f01021fb:	89 f3                	mov    %esi,%ebx
f01021fd:	89 7d d0             	mov    %edi,-0x30(%ebp)
f0102200:	89 c7                	mov    %eax,%edi
f0102202:	89 75 c0             	mov    %esi,-0x40(%ebp)
f0102205:	89 d6                	mov    %edx,%esi
f0102207:	e9 52 08 00 00       	jmp    f0102a5e <mem_init+0x16f5>
	assert(nfree == 0);
f010220c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010220f:	8d 83 72 63 f8 ff    	lea    -0x79c8e(%ebx),%eax
f0102215:	50                   	push   %eax
f0102216:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010221c:	50                   	push   %eax
f010221d:	68 e2 02 00 00       	push   $0x2e2
f0102222:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102228:	50                   	push   %eax
f0102229:	e8 83 de ff ff       	call   f01000b1 <_panic>
	assert((pp0 = page_alloc(0)));
f010222e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102231:	8d 83 80 62 f8 ff    	lea    -0x79d80(%ebx),%eax
f0102237:	50                   	push   %eax
f0102238:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010223e:	50                   	push   %eax
f010223f:	68 40 03 00 00       	push   $0x340
f0102244:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010224a:	50                   	push   %eax
f010224b:	e8 61 de ff ff       	call   f01000b1 <_panic>
	assert((pp1 = page_alloc(0)));
f0102250:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102253:	8d 83 96 62 f8 ff    	lea    -0x79d6a(%ebx),%eax
f0102259:	50                   	push   %eax
f010225a:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102260:	50                   	push   %eax
f0102261:	68 41 03 00 00       	push   $0x341
f0102266:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010226c:	50                   	push   %eax
f010226d:	e8 3f de ff ff       	call   f01000b1 <_panic>
	assert((pp2 = page_alloc(0)));
f0102272:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102275:	8d 83 ac 62 f8 ff    	lea    -0x79d54(%ebx),%eax
f010227b:	50                   	push   %eax
f010227c:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102282:	50                   	push   %eax
f0102283:	68 42 03 00 00       	push   $0x342
f0102288:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010228e:	50                   	push   %eax
f010228f:	e8 1d de ff ff       	call   f01000b1 <_panic>
	assert(pp1 && pp1 != pp0);
f0102294:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102297:	8d 83 c2 62 f8 ff    	lea    -0x79d3e(%ebx),%eax
f010229d:	50                   	push   %eax
f010229e:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01022a4:	50                   	push   %eax
f01022a5:	68 45 03 00 00       	push   $0x345
f01022aa:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01022b0:	50                   	push   %eax
f01022b1:	e8 fb dd ff ff       	call   f01000b1 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01022b6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022b9:	8d 83 50 66 f8 ff    	lea    -0x799b0(%ebx),%eax
f01022bf:	50                   	push   %eax
f01022c0:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01022c6:	50                   	push   %eax
f01022c7:	68 46 03 00 00       	push   $0x346
f01022cc:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01022d2:	50                   	push   %eax
f01022d3:	e8 d9 dd ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f01022d8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022db:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f01022e1:	50                   	push   %eax
f01022e2:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01022e8:	50                   	push   %eax
f01022e9:	68 4d 03 00 00       	push   $0x34d
f01022ee:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01022f4:	50                   	push   %eax
f01022f5:	e8 b7 dd ff ff       	call   f01000b1 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01022fa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022fd:	8d 83 90 66 f8 ff    	lea    -0x79970(%ebx),%eax
f0102303:	50                   	push   %eax
f0102304:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010230a:	50                   	push   %eax
f010230b:	68 50 03 00 00       	push   $0x350
f0102310:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102316:	50                   	push   %eax
f0102317:	e8 95 dd ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010231c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010231f:	8d 83 c8 66 f8 ff    	lea    -0x79938(%ebx),%eax
f0102325:	50                   	push   %eax
f0102326:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010232c:	50                   	push   %eax
f010232d:	68 53 03 00 00       	push   $0x353
f0102332:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102338:	50                   	push   %eax
f0102339:	e8 73 dd ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010233e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102341:	8d 83 f8 66 f8 ff    	lea    -0x79908(%ebx),%eax
f0102347:	50                   	push   %eax
f0102348:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010234e:	50                   	push   %eax
f010234f:	68 57 03 00 00       	push   $0x357
f0102354:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010235a:	50                   	push   %eax
f010235b:	e8 51 dd ff ff       	call   f01000b1 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102360:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102363:	8d 83 28 67 f8 ff    	lea    -0x798d8(%ebx),%eax
f0102369:	50                   	push   %eax
f010236a:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102370:	50                   	push   %eax
f0102371:	68 58 03 00 00       	push   $0x358
f0102376:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010237c:	50                   	push   %eax
f010237d:	e8 2f dd ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102382:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102385:	8d 83 50 67 f8 ff    	lea    -0x798b0(%ebx),%eax
f010238b:	50                   	push   %eax
f010238c:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102392:	50                   	push   %eax
f0102393:	68 59 03 00 00       	push   $0x359
f0102398:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010239e:	50                   	push   %eax
f010239f:	e8 0d dd ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 1);
f01023a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023a7:	8d 83 7d 63 f8 ff    	lea    -0x79c83(%ebx),%eax
f01023ad:	50                   	push   %eax
f01023ae:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01023b4:	50                   	push   %eax
f01023b5:	68 5a 03 00 00       	push   $0x35a
f01023ba:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01023c0:	50                   	push   %eax
f01023c1:	e8 eb dc ff ff       	call   f01000b1 <_panic>
	assert(pp0->pp_ref == 1);
f01023c6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023c9:	8d 83 8e 63 f8 ff    	lea    -0x79c72(%ebx),%eax
f01023cf:	50                   	push   %eax
f01023d0:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01023d6:	50                   	push   %eax
f01023d7:	68 5b 03 00 00       	push   $0x35b
f01023dc:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01023e2:	50                   	push   %eax
f01023e3:	e8 c9 dc ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01023e8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023eb:	8d 83 80 67 f8 ff    	lea    -0x79880(%ebx),%eax
f01023f1:	50                   	push   %eax
f01023f2:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01023f8:	50                   	push   %eax
f01023f9:	68 5e 03 00 00       	push   $0x35e
f01023fe:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102404:	50                   	push   %eax
f0102405:	e8 a7 dc ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010240a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010240d:	8d 83 bc 67 f8 ff    	lea    -0x79844(%ebx),%eax
f0102413:	50                   	push   %eax
f0102414:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010241a:	50                   	push   %eax
f010241b:	68 5f 03 00 00       	push   $0x35f
f0102420:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102426:	50                   	push   %eax
f0102427:	e8 85 dc ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 1);
f010242c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010242f:	8d 83 9f 63 f8 ff    	lea    -0x79c61(%ebx),%eax
f0102435:	50                   	push   %eax
f0102436:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010243c:	50                   	push   %eax
f010243d:	68 60 03 00 00       	push   $0x360
f0102442:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102448:	50                   	push   %eax
f0102449:	e8 63 dc ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f010244e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102451:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f0102457:	50                   	push   %eax
f0102458:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010245e:	50                   	push   %eax
f010245f:	68 63 03 00 00       	push   $0x363
f0102464:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010246a:	50                   	push   %eax
f010246b:	e8 41 dc ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102470:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102473:	8d 83 80 67 f8 ff    	lea    -0x79880(%ebx),%eax
f0102479:	50                   	push   %eax
f010247a:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102480:	50                   	push   %eax
f0102481:	68 66 03 00 00       	push   $0x366
f0102486:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010248c:	50                   	push   %eax
f010248d:	e8 1f dc ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102492:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102495:	8d 83 bc 67 f8 ff    	lea    -0x79844(%ebx),%eax
f010249b:	50                   	push   %eax
f010249c:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01024a2:	50                   	push   %eax
f01024a3:	68 67 03 00 00       	push   $0x367
f01024a8:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01024ae:	50                   	push   %eax
f01024af:	e8 fd db ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 1);
f01024b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024b7:	8d 83 9f 63 f8 ff    	lea    -0x79c61(%ebx),%eax
f01024bd:	50                   	push   %eax
f01024be:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01024c4:	50                   	push   %eax
f01024c5:	68 68 03 00 00       	push   $0x368
f01024ca:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01024d0:	50                   	push   %eax
f01024d1:	e8 db db ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f01024d6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024d9:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f01024df:	50                   	push   %eax
f01024e0:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01024e6:	50                   	push   %eax
f01024e7:	68 6c 03 00 00       	push   $0x36c
f01024ec:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01024f2:	50                   	push   %eax
f01024f3:	e8 b9 db ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01024f8:	53                   	push   %ebx
f01024f9:	89 cb                	mov    %ecx,%ebx
f01024fb:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0102501:	50                   	push   %eax
f0102502:	68 6f 03 00 00       	push   $0x36f
f0102507:	8d 81 af 61 f8 ff    	lea    -0x79e51(%ecx),%eax
f010250d:	50                   	push   %eax
f010250e:	e8 9e db ff ff       	call   f01000b1 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102513:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102516:	8d 83 ec 67 f8 ff    	lea    -0x79814(%ebx),%eax
f010251c:	50                   	push   %eax
f010251d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102523:	50                   	push   %eax
f0102524:	68 70 03 00 00       	push   $0x370
f0102529:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010252f:	50                   	push   %eax
f0102530:	e8 7c db ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102535:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102538:	8d 83 2c 68 f8 ff    	lea    -0x797d4(%ebx),%eax
f010253e:	50                   	push   %eax
f010253f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102545:	50                   	push   %eax
f0102546:	68 73 03 00 00       	push   $0x373
f010254b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102551:	50                   	push   %eax
f0102552:	e8 5a db ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102557:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010255a:	8d 83 bc 67 f8 ff    	lea    -0x79844(%ebx),%eax
f0102560:	50                   	push   %eax
f0102561:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102567:	50                   	push   %eax
f0102568:	68 74 03 00 00       	push   $0x374
f010256d:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102573:	50                   	push   %eax
f0102574:	e8 38 db ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 1);
f0102579:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010257c:	8d 83 9f 63 f8 ff    	lea    -0x79c61(%ebx),%eax
f0102582:	50                   	push   %eax
f0102583:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102589:	50                   	push   %eax
f010258a:	68 75 03 00 00       	push   $0x375
f010258f:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102595:	50                   	push   %eax
f0102596:	e8 16 db ff ff       	call   f01000b1 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010259b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010259e:	8d 83 6c 68 f8 ff    	lea    -0x79794(%ebx),%eax
f01025a4:	50                   	push   %eax
f01025a5:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01025ab:	50                   	push   %eax
f01025ac:	68 76 03 00 00       	push   $0x376
f01025b1:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01025b7:	50                   	push   %eax
f01025b8:	e8 f4 da ff ff       	call   f01000b1 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01025bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025c0:	8d 83 b0 63 f8 ff    	lea    -0x79c50(%ebx),%eax
f01025c6:	50                   	push   %eax
f01025c7:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01025cd:	50                   	push   %eax
f01025ce:	68 77 03 00 00       	push   $0x377
f01025d3:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01025d9:	50                   	push   %eax
f01025da:	e8 d2 da ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025e2:	8d 83 80 67 f8 ff    	lea    -0x79880(%ebx),%eax
f01025e8:	50                   	push   %eax
f01025e9:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01025ef:	50                   	push   %eax
f01025f0:	68 7a 03 00 00       	push   $0x37a
f01025f5:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01025fb:	50                   	push   %eax
f01025fc:	e8 b0 da ff ff       	call   f01000b1 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102601:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102604:	8d 83 a0 68 f8 ff    	lea    -0x79760(%ebx),%eax
f010260a:	50                   	push   %eax
f010260b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102611:	50                   	push   %eax
f0102612:	68 7b 03 00 00       	push   $0x37b
f0102617:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010261d:	50                   	push   %eax
f010261e:	e8 8e da ff ff       	call   f01000b1 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102623:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102626:	8d 83 d4 68 f8 ff    	lea    -0x7972c(%ebx),%eax
f010262c:	50                   	push   %eax
f010262d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102633:	50                   	push   %eax
f0102634:	68 7c 03 00 00       	push   $0x37c
f0102639:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010263f:	50                   	push   %eax
f0102640:	e8 6c da ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102645:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102648:	8d 83 0c 69 f8 ff    	lea    -0x796f4(%ebx),%eax
f010264e:	50                   	push   %eax
f010264f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102655:	50                   	push   %eax
f0102656:	68 7f 03 00 00       	push   $0x37f
f010265b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102661:	50                   	push   %eax
f0102662:	e8 4a da ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102667:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010266a:	8d 83 44 69 f8 ff    	lea    -0x796bc(%ebx),%eax
f0102670:	50                   	push   %eax
f0102671:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102677:	50                   	push   %eax
f0102678:	68 82 03 00 00       	push   $0x382
f010267d:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102683:	50                   	push   %eax
f0102684:	e8 28 da ff ff       	call   f01000b1 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102689:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010268c:	8d 83 d4 68 f8 ff    	lea    -0x7972c(%ebx),%eax
f0102692:	50                   	push   %eax
f0102693:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102699:	50                   	push   %eax
f010269a:	68 83 03 00 00       	push   $0x383
f010269f:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01026a5:	50                   	push   %eax
f01026a6:	e8 06 da ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01026ab:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026ae:	8d 83 80 69 f8 ff    	lea    -0x79680(%ebx),%eax
f01026b4:	50                   	push   %eax
f01026b5:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01026bb:	50                   	push   %eax
f01026bc:	68 86 03 00 00       	push   $0x386
f01026c1:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01026c7:	50                   	push   %eax
f01026c8:	e8 e4 d9 ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026cd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026d0:	8d 83 ac 69 f8 ff    	lea    -0x79654(%ebx),%eax
f01026d6:	50                   	push   %eax
f01026d7:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01026dd:	50                   	push   %eax
f01026de:	68 87 03 00 00       	push   $0x387
f01026e3:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01026e9:	50                   	push   %eax
f01026ea:	e8 c2 d9 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 2);
f01026ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026f2:	8d 83 c6 63 f8 ff    	lea    -0x79c3a(%ebx),%eax
f01026f8:	50                   	push   %eax
f01026f9:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01026ff:	50                   	push   %eax
f0102700:	68 89 03 00 00       	push   $0x389
f0102705:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010270b:	50                   	push   %eax
f010270c:	e8 a0 d9 ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 0);
f0102711:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102714:	8d 83 d7 63 f8 ff    	lea    -0x79c29(%ebx),%eax
f010271a:	50                   	push   %eax
f010271b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102721:	50                   	push   %eax
f0102722:	68 8a 03 00 00       	push   $0x38a
f0102727:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010272d:	50                   	push   %eax
f010272e:	e8 7e d9 ff ff       	call   f01000b1 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102733:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102736:	8d 83 dc 69 f8 ff    	lea    -0x79624(%ebx),%eax
f010273c:	50                   	push   %eax
f010273d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102743:	50                   	push   %eax
f0102744:	68 8d 03 00 00       	push   $0x38d
f0102749:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010274f:	50                   	push   %eax
f0102750:	e8 5c d9 ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102755:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102758:	8d 83 00 6a f8 ff    	lea    -0x79600(%ebx),%eax
f010275e:	50                   	push   %eax
f010275f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102765:	50                   	push   %eax
f0102766:	68 91 03 00 00       	push   $0x391
f010276b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102771:	50                   	push   %eax
f0102772:	e8 3a d9 ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102777:	89 cb                	mov    %ecx,%ebx
f0102779:	8d 81 ac 69 f8 ff    	lea    -0x79654(%ecx),%eax
f010277f:	50                   	push   %eax
f0102780:	8d 81 d5 61 f8 ff    	lea    -0x79e2b(%ecx),%eax
f0102786:	50                   	push   %eax
f0102787:	68 92 03 00 00       	push   $0x392
f010278c:	8d 81 af 61 f8 ff    	lea    -0x79e51(%ecx),%eax
f0102792:	50                   	push   %eax
f0102793:	e8 19 d9 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 1);
f0102798:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010279b:	8d 83 7d 63 f8 ff    	lea    -0x79c83(%ebx),%eax
f01027a1:	50                   	push   %eax
f01027a2:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01027a8:	50                   	push   %eax
f01027a9:	68 93 03 00 00       	push   $0x393
f01027ae:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01027b4:	50                   	push   %eax
f01027b5:	e8 f7 d8 ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 0);
f01027ba:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027bd:	8d 83 d7 63 f8 ff    	lea    -0x79c29(%ebx),%eax
f01027c3:	50                   	push   %eax
f01027c4:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01027ca:	50                   	push   %eax
f01027cb:	68 94 03 00 00       	push   $0x394
f01027d0:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01027d6:	50                   	push   %eax
f01027d7:	e8 d5 d8 ff ff       	call   f01000b1 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01027dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027df:	8d 83 24 6a f8 ff    	lea    -0x795dc(%ebx),%eax
f01027e5:	50                   	push   %eax
f01027e6:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01027ec:	50                   	push   %eax
f01027ed:	68 97 03 00 00       	push   $0x397
f01027f2:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01027f8:	50                   	push   %eax
f01027f9:	e8 b3 d8 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref);
f01027fe:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102801:	8d 83 e8 63 f8 ff    	lea    -0x79c18(%ebx),%eax
f0102807:	50                   	push   %eax
f0102808:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010280e:	50                   	push   %eax
f010280f:	68 98 03 00 00       	push   $0x398
f0102814:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010281a:	50                   	push   %eax
f010281b:	e8 91 d8 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_link == NULL);
f0102820:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102823:	8d 83 f4 63 f8 ff    	lea    -0x79c0c(%ebx),%eax
f0102829:	50                   	push   %eax
f010282a:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102830:	50                   	push   %eax
f0102831:	68 99 03 00 00       	push   $0x399
f0102836:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010283c:	50                   	push   %eax
f010283d:	e8 6f d8 ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102842:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102845:	8d 83 00 6a f8 ff    	lea    -0x79600(%ebx),%eax
f010284b:	50                   	push   %eax
f010284c:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102852:	50                   	push   %eax
f0102853:	68 9d 03 00 00       	push   $0x39d
f0102858:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010285e:	50                   	push   %eax
f010285f:	e8 4d d8 ff ff       	call   f01000b1 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102864:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102867:	8d 83 5c 6a f8 ff    	lea    -0x795a4(%ebx),%eax
f010286d:	50                   	push   %eax
f010286e:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102874:	50                   	push   %eax
f0102875:	68 9e 03 00 00       	push   $0x39e
f010287a:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102880:	50                   	push   %eax
f0102881:	e8 2b d8 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 0);
f0102886:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102889:	8d 83 09 64 f8 ff    	lea    -0x79bf7(%ebx),%eax
f010288f:	50                   	push   %eax
f0102890:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102896:	50                   	push   %eax
f0102897:	68 9f 03 00 00       	push   $0x39f
f010289c:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01028a2:	50                   	push   %eax
f01028a3:	e8 09 d8 ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 0);
f01028a8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028ab:	8d 83 d7 63 f8 ff    	lea    -0x79c29(%ebx),%eax
f01028b1:	50                   	push   %eax
f01028b2:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01028b8:	50                   	push   %eax
f01028b9:	68 a0 03 00 00       	push   $0x3a0
f01028be:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01028c4:	50                   	push   %eax
f01028c5:	e8 e7 d7 ff ff       	call   f01000b1 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01028ca:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028cd:	8d 83 84 6a f8 ff    	lea    -0x7957c(%ebx),%eax
f01028d3:	50                   	push   %eax
f01028d4:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01028da:	50                   	push   %eax
f01028db:	68 a3 03 00 00       	push   $0x3a3
f01028e0:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01028e6:	50                   	push   %eax
f01028e7:	e8 c5 d7 ff ff       	call   f01000b1 <_panic>
	assert(!page_alloc(0));
f01028ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028ef:	8d 83 2b 63 f8 ff    	lea    -0x79cd5(%ebx),%eax
f01028f5:	50                   	push   %eax
f01028f6:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01028fc:	50                   	push   %eax
f01028fd:	68 a6 03 00 00       	push   $0x3a6
f0102902:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102908:	50                   	push   %eax
f0102909:	e8 a3 d7 ff ff       	call   f01000b1 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010290e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102911:	8d 83 28 67 f8 ff    	lea    -0x798d8(%ebx),%eax
f0102917:	50                   	push   %eax
f0102918:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010291e:	50                   	push   %eax
f010291f:	68 a9 03 00 00       	push   $0x3a9
f0102924:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010292a:	50                   	push   %eax
f010292b:	e8 81 d7 ff ff       	call   f01000b1 <_panic>
	assert(pp0->pp_ref == 1);
f0102930:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102933:	8d 83 8e 63 f8 ff    	lea    -0x79c72(%ebx),%eax
f0102939:	50                   	push   %eax
f010293a:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102940:	50                   	push   %eax
f0102941:	68 ab 03 00 00       	push   $0x3ab
f0102946:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010294c:	50                   	push   %eax
f010294d:	e8 5f d7 ff ff       	call   f01000b1 <_panic>
f0102952:	52                   	push   %edx
f0102953:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102956:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f010295c:	50                   	push   %eax
f010295d:	68 b2 03 00 00       	push   $0x3b2
f0102962:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102968:	50                   	push   %eax
f0102969:	e8 43 d7 ff ff       	call   f01000b1 <_panic>
	assert(ptep == ptep1 + PTX(va));
f010296e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102971:	8d 83 1a 64 f8 ff    	lea    -0x79be6(%ebx),%eax
f0102977:	50                   	push   %eax
f0102978:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010297e:	50                   	push   %eax
f010297f:	68 b3 03 00 00       	push   $0x3b3
f0102984:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010298a:	50                   	push   %eax
f010298b:	e8 21 d7 ff ff       	call   f01000b1 <_panic>
f0102990:	52                   	push   %edx
f0102991:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f0102997:	50                   	push   %eax
f0102998:	6a 56                	push   $0x56
f010299a:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f01029a0:	50                   	push   %eax
f01029a1:	e8 0b d7 ff ff       	call   f01000b1 <_panic>
f01029a6:	52                   	push   %edx
f01029a7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029aa:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f01029b0:	50                   	push   %eax
f01029b1:	6a 56                	push   $0x56
f01029b3:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f01029b9:	50                   	push   %eax
f01029ba:	e8 f2 d6 ff ff       	call   f01000b1 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01029bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029c2:	8d 83 32 64 f8 ff    	lea    -0x79bce(%ebx),%eax
f01029c8:	50                   	push   %eax
f01029c9:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01029cf:	50                   	push   %eax
f01029d0:	68 bd 03 00 00       	push   $0x3bd
f01029d5:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01029db:	50                   	push   %eax
f01029dc:	e8 d0 d6 ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029e1:	50                   	push   %eax
f01029e2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029e5:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f01029eb:	50                   	push   %eax
f01029ec:	68 be 00 00 00       	push   $0xbe
f01029f1:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01029f7:	50                   	push   %eax
f01029f8:	e8 b4 d6 ff ff       	call   f01000b1 <_panic>
f01029fd:	50                   	push   %eax
f01029fe:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a01:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0102a07:	50                   	push   %eax
f0102a08:	68 c6 00 00 00       	push   $0xc6
f0102a0d:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102a13:	50                   	push   %eax
f0102a14:	e8 98 d6 ff ff       	call   f01000b1 <_panic>
f0102a19:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a1c:	ff b3 fc ff ff ff    	push   -0x4(%ebx)
f0102a22:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0102a28:	50                   	push   %eax
f0102a29:	68 d2 00 00 00       	push   $0xd2
f0102a2e:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102a34:	50                   	push   %eax
f0102a35:	e8 77 d6 ff ff       	call   f01000b1 <_panic>
f0102a3a:	ff 75 bc             	push   -0x44(%ebp)
f0102a3d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a40:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0102a46:	50                   	push   %eax
f0102a47:	68 fa 02 00 00       	push   $0x2fa
f0102a4c:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102a52:	50                   	push   %eax
f0102a53:	e8 59 d6 ff ff       	call   f01000b1 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102a58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a5e:	39 de                	cmp    %ebx,%esi
f0102a60:	76 42                	jbe    f0102aa4 <mem_init+0x173b>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a62:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102a68:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102a6b:	e8 9e e0 ff ff       	call   f0100b0e <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102a70:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102a76:	76 c2                	jbe    f0102a3a <mem_init+0x16d1>
f0102a78:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102a7b:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102a7e:	39 c2                	cmp    %eax,%edx
f0102a80:	74 d6                	je     f0102a58 <mem_init+0x16ef>
f0102a82:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a85:	8d 83 a8 6a f8 ff    	lea    -0x79558(%ebx),%eax
f0102a8b:	50                   	push   %eax
f0102a8c:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102a92:	50                   	push   %eax
f0102a93:	68 fa 02 00 00       	push   $0x2fa
f0102a98:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102a9e:	50                   	push   %eax
f0102a9f:	e8 0d d6 ff ff       	call   f01000b1 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102aa4:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0102aa7:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102aad:	c7 c0 78 13 18 f0    	mov    $0xf0181378,%eax
f0102ab3:	8b 00                	mov    (%eax),%eax
f0102ab5:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102ab8:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102abd:	8d 88 00 00 40 21    	lea    0x21400000(%eax),%ecx
f0102ac3:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0102ac6:	89 75 cc             	mov    %esi,-0x34(%ebp)
f0102ac9:	89 c6                	mov    %eax,%esi
f0102acb:	89 da                	mov    %ebx,%edx
f0102acd:	89 f8                	mov    %edi,%eax
f0102acf:	e8 3a e0 ff ff       	call   f0100b0e <check_va2pa>
f0102ad4:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f0102ada:	76 45                	jbe    f0102b21 <mem_init+0x17b8>
f0102adc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102adf:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102ae2:	39 c2                	cmp    %eax,%edx
f0102ae4:	75 59                	jne    f0102b3f <mem_init+0x17d6>
	for (i = 0; i < n; i += PGSIZE)
f0102ae6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102aec:	81 fb 00 80 c1 ee    	cmp    $0xeec18000,%ebx
f0102af2:	75 d7                	jne    f0102acb <mem_init+0x1762>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102af4:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0102af7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0102afa:	c1 e0 0c             	shl    $0xc,%eax
f0102afd:	89 f3                	mov    %esi,%ebx
f0102aff:	89 75 d0             	mov    %esi,-0x30(%ebp)
f0102b02:	89 c6                	mov    %eax,%esi
f0102b04:	39 f3                	cmp    %esi,%ebx
f0102b06:	73 7b                	jae    f0102b83 <mem_init+0x181a>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b08:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102b0e:	89 f8                	mov    %edi,%eax
f0102b10:	e8 f9 df ff ff       	call   f0100b0e <check_va2pa>
f0102b15:	39 c3                	cmp    %eax,%ebx
f0102b17:	75 48                	jne    f0102b61 <mem_init+0x17f8>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102b1f:	eb e3                	jmp    f0102b04 <mem_init+0x179b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b21:	ff 75 c0             	push   -0x40(%ebp)
f0102b24:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b27:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0102b2d:	50                   	push   %eax
f0102b2e:	68 ff 02 00 00       	push   $0x2ff
f0102b33:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102b39:	50                   	push   %eax
f0102b3a:	e8 72 d5 ff ff       	call   f01000b1 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b3f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b42:	8d 83 dc 6a f8 ff    	lea    -0x79524(%ebx),%eax
f0102b48:	50                   	push   %eax
f0102b49:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102b4f:	50                   	push   %eax
f0102b50:	68 ff 02 00 00       	push   $0x2ff
f0102b55:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102b5b:	50                   	push   %eax
f0102b5c:	e8 50 d5 ff ff       	call   f01000b1 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b61:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b64:	8d 83 10 6b f8 ff    	lea    -0x794f0(%ebx),%eax
f0102b6a:	50                   	push   %eax
f0102b6b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102b71:	50                   	push   %eax
f0102b72:	68 03 03 00 00       	push   $0x303
f0102b77:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102b7d:	50                   	push   %eax
f0102b7e:	e8 2e d5 ff ff       	call   f01000b1 <_panic>
f0102b83:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102b88:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102b8b:	05 00 80 00 20       	add    $0x20008000,%eax
f0102b90:	89 c6                	mov    %eax,%esi
f0102b92:	89 da                	mov    %ebx,%edx
f0102b94:	89 f8                	mov    %edi,%eax
f0102b96:	e8 73 df ff ff       	call   f0100b0e <check_va2pa>
f0102b9b:	89 c2                	mov    %eax,%edx
f0102b9d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0102ba0:	39 c2                	cmp    %eax,%edx
f0102ba2:	75 44                	jne    f0102be8 <mem_init+0x187f>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102ba4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102baa:	81 fb 00 00 00 f0    	cmp    $0xf0000000,%ebx
f0102bb0:	75 e0                	jne    f0102b92 <mem_init+0x1829>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102bb2:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0102bb5:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102bba:	89 f8                	mov    %edi,%eax
f0102bbc:	e8 4d df ff ff       	call   f0100b0e <check_va2pa>
f0102bc1:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102bc4:	74 71                	je     f0102c37 <mem_init+0x18ce>
f0102bc6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102bc9:	8d 83 80 6b f8 ff    	lea    -0x79480(%ebx),%eax
f0102bcf:	50                   	push   %eax
f0102bd0:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102bd6:	50                   	push   %eax
f0102bd7:	68 08 03 00 00       	push   $0x308
f0102bdc:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102be2:	50                   	push   %eax
f0102be3:	e8 c9 d4 ff ff       	call   f01000b1 <_panic>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102be8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102beb:	8d 83 38 6b f8 ff    	lea    -0x794c8(%ebx),%eax
f0102bf1:	50                   	push   %eax
f0102bf2:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102bf8:	50                   	push   %eax
f0102bf9:	68 07 03 00 00       	push   $0x307
f0102bfe:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102c04:	50                   	push   %eax
f0102c05:	e8 a7 d4 ff ff       	call   f01000b1 <_panic>
		switch (i) {
f0102c0a:	81 fe bf 03 00 00    	cmp    $0x3bf,%esi
f0102c10:	75 25                	jne    f0102c37 <mem_init+0x18ce>
			assert(pgdir[i] & PTE_P);
f0102c12:	f6 04 b7 01          	testb  $0x1,(%edi,%esi,4)
f0102c16:	74 4f                	je     f0102c67 <mem_init+0x18fe>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c18:	83 c6 01             	add    $0x1,%esi
f0102c1b:	81 fe ff 03 00 00    	cmp    $0x3ff,%esi
f0102c21:	0f 87 b1 00 00 00    	ja     f0102cd8 <mem_init+0x196f>
		switch (i) {
f0102c27:	81 fe bd 03 00 00    	cmp    $0x3bd,%esi
f0102c2d:	77 db                	ja     f0102c0a <mem_init+0x18a1>
f0102c2f:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
f0102c35:	77 db                	ja     f0102c12 <mem_init+0x18a9>
			if (i >= PDX(KERNBASE)) {
f0102c37:	81 fe bf 03 00 00    	cmp    $0x3bf,%esi
f0102c3d:	77 4a                	ja     f0102c89 <mem_init+0x1920>
				assert(pgdir[i] == 0);
f0102c3f:	83 3c b7 00          	cmpl   $0x0,(%edi,%esi,4)
f0102c43:	74 d3                	je     f0102c18 <mem_init+0x18af>
f0102c45:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c48:	8d 83 84 64 f8 ff    	lea    -0x79b7c(%ebx),%eax
f0102c4e:	50                   	push   %eax
f0102c4f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102c55:	50                   	push   %eax
f0102c56:	68 18 03 00 00       	push   $0x318
f0102c5b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102c61:	50                   	push   %eax
f0102c62:	e8 4a d4 ff ff       	call   f01000b1 <_panic>
			assert(pgdir[i] & PTE_P);
f0102c67:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c6a:	8d 83 62 64 f8 ff    	lea    -0x79b9e(%ebx),%eax
f0102c70:	50                   	push   %eax
f0102c71:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102c77:	50                   	push   %eax
f0102c78:	68 11 03 00 00       	push   $0x311
f0102c7d:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102c83:	50                   	push   %eax
f0102c84:	e8 28 d4 ff ff       	call   f01000b1 <_panic>
				assert(pgdir[i] & PTE_P);
f0102c89:	8b 04 b7             	mov    (%edi,%esi,4),%eax
f0102c8c:	a8 01                	test   $0x1,%al
f0102c8e:	74 26                	je     f0102cb6 <mem_init+0x194d>
				assert(pgdir[i] & PTE_W);
f0102c90:	a8 02                	test   $0x2,%al
f0102c92:	75 84                	jne    f0102c18 <mem_init+0x18af>
f0102c94:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c97:	8d 83 73 64 f8 ff    	lea    -0x79b8d(%ebx),%eax
f0102c9d:	50                   	push   %eax
f0102c9e:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102ca4:	50                   	push   %eax
f0102ca5:	68 16 03 00 00       	push   $0x316
f0102caa:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102cb0:	50                   	push   %eax
f0102cb1:	e8 fb d3 ff ff       	call   f01000b1 <_panic>
				assert(pgdir[i] & PTE_P);
f0102cb6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102cb9:	8d 83 62 64 f8 ff    	lea    -0x79b9e(%ebx),%eax
f0102cbf:	50                   	push   %eax
f0102cc0:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102cc6:	50                   	push   %eax
f0102cc7:	68 15 03 00 00       	push   $0x315
f0102ccc:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102cd2:	50                   	push   %eax
f0102cd3:	e8 d9 d3 ff ff       	call   f01000b1 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102cd8:	83 ec 0c             	sub    $0xc,%esp
f0102cdb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102cde:	8d 83 b0 6b f8 ff    	lea    -0x79450(%ebx),%eax
f0102ce4:	50                   	push   %eax
f0102ce5:	e8 3b 0d 00 00       	call   f0103a25 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102cea:	8b 83 f4 1a 00 00    	mov    0x1af4(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0102cf0:	83 c4 10             	add    $0x10,%esp
f0102cf3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102cf8:	0f 86 2c 02 00 00    	jbe    f0102f2a <mem_init+0x1bc1>
	return (physaddr_t)kva - KERNBASE;
f0102cfe:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102d03:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102d06:	b8 00 00 00 00       	mov    $0x0,%eax
f0102d0b:	e8 7a de ff ff       	call   f0100b8a <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102d10:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102d13:	83 e0 f3             	and    $0xfffffff3,%eax
f0102d16:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102d1b:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102d1e:	83 ec 0c             	sub    $0xc,%esp
f0102d21:	6a 00                	push   $0x0
f0102d23:	e8 21 e3 ff ff       	call   f0101049 <page_alloc>
f0102d28:	89 c6                	mov    %eax,%esi
f0102d2a:	83 c4 10             	add    $0x10,%esp
f0102d2d:	85 c0                	test   %eax,%eax
f0102d2f:	0f 84 11 02 00 00    	je     f0102f46 <mem_init+0x1bdd>
	assert((pp1 = page_alloc(0)));
f0102d35:	83 ec 0c             	sub    $0xc,%esp
f0102d38:	6a 00                	push   $0x0
f0102d3a:	e8 0a e3 ff ff       	call   f0101049 <page_alloc>
f0102d3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102d42:	83 c4 10             	add    $0x10,%esp
f0102d45:	85 c0                	test   %eax,%eax
f0102d47:	0f 84 1b 02 00 00    	je     f0102f68 <mem_init+0x1bff>
	assert((pp2 = page_alloc(0)));
f0102d4d:	83 ec 0c             	sub    $0xc,%esp
f0102d50:	6a 00                	push   $0x0
f0102d52:	e8 f2 e2 ff ff       	call   f0101049 <page_alloc>
f0102d57:	89 c7                	mov    %eax,%edi
f0102d59:	83 c4 10             	add    $0x10,%esp
f0102d5c:	85 c0                	test   %eax,%eax
f0102d5e:	0f 84 26 02 00 00    	je     f0102f8a <mem_init+0x1c21>
	page_free(pp0);
f0102d64:	83 ec 0c             	sub    $0xc,%esp
f0102d67:	56                   	push   %esi
f0102d68:	e8 61 e3 ff ff       	call   f01010ce <page_free>
	return (pp - pages) << PGSHIFT;
f0102d6d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102d70:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102d73:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f0102d79:	c1 f8 03             	sar    $0x3,%eax
f0102d7c:	89 c2                	mov    %eax,%edx
f0102d7e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d81:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d86:	83 c4 10             	add    $0x10,%esp
f0102d89:	3b 81 f8 1a 00 00    	cmp    0x1af8(%ecx),%eax
f0102d8f:	0f 83 17 02 00 00    	jae    f0102fac <mem_init+0x1c43>
	memset(page2kva(pp1), 1, PGSIZE);
f0102d95:	83 ec 04             	sub    $0x4,%esp
f0102d98:	68 00 10 00 00       	push   $0x1000
f0102d9d:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d9f:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102da5:	52                   	push   %edx
f0102da6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102da9:	e8 14 23 00 00       	call   f01050c2 <memset>
	return (pp - pages) << PGSHIFT;
f0102dae:	89 f8                	mov    %edi,%eax
f0102db0:	2b 83 f0 1a 00 00    	sub    0x1af0(%ebx),%eax
f0102db6:	c1 f8 03             	sar    $0x3,%eax
f0102db9:	89 c2                	mov    %eax,%edx
f0102dbb:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102dbe:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102dc3:	83 c4 10             	add    $0x10,%esp
f0102dc6:	3b 83 f8 1a 00 00    	cmp    0x1af8(%ebx),%eax
f0102dcc:	0f 83 f2 01 00 00    	jae    f0102fc4 <mem_init+0x1c5b>
	memset(page2kva(pp2), 2, PGSIZE);
f0102dd2:	83 ec 04             	sub    $0x4,%esp
f0102dd5:	68 00 10 00 00       	push   $0x1000
f0102dda:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102ddc:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102de2:	52                   	push   %edx
f0102de3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102de6:	e8 d7 22 00 00       	call   f01050c2 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102deb:	6a 02                	push   $0x2
f0102ded:	68 00 10 00 00       	push   $0x1000
f0102df2:	ff 75 d0             	push   -0x30(%ebp)
f0102df5:	ff b3 f4 1a 00 00    	push   0x1af4(%ebx)
f0102dfb:	e8 e3 e4 ff ff       	call   f01012e3 <page_insert>
	assert(pp1->pp_ref == 1);
f0102e00:	83 c4 20             	add    $0x20,%esp
f0102e03:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e06:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102e0b:	0f 85 cc 01 00 00    	jne    f0102fdd <mem_init+0x1c74>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e11:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102e18:	01 01 01 
f0102e1b:	0f 85 de 01 00 00    	jne    f0102fff <mem_init+0x1c96>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102e21:	6a 02                	push   $0x2
f0102e23:	68 00 10 00 00       	push   $0x1000
f0102e28:	57                   	push   %edi
f0102e29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e2c:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0102e32:	e8 ac e4 ff ff       	call   f01012e3 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e37:	83 c4 10             	add    $0x10,%esp
f0102e3a:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102e41:	02 02 02 
f0102e44:	0f 85 d7 01 00 00    	jne    f0103021 <mem_init+0x1cb8>
	assert(pp2->pp_ref == 1);
f0102e4a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102e4f:	0f 85 ee 01 00 00    	jne    f0103043 <mem_init+0x1cda>
	assert(pp1->pp_ref == 0);
f0102e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e58:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102e5d:	0f 85 02 02 00 00    	jne    f0103065 <mem_init+0x1cfc>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102e63:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102e6a:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102e6d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102e70:	89 f8                	mov    %edi,%eax
f0102e72:	2b 81 f0 1a 00 00    	sub    0x1af0(%ecx),%eax
f0102e78:	c1 f8 03             	sar    $0x3,%eax
f0102e7b:	89 c2                	mov    %eax,%edx
f0102e7d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102e80:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102e85:	3b 81 f8 1a 00 00    	cmp    0x1af8(%ecx),%eax
f0102e8b:	0f 83 f6 01 00 00    	jae    f0103087 <mem_init+0x1d1e>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e91:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102e98:	03 03 03 
f0102e9b:	0f 85 fe 01 00 00    	jne    f010309f <mem_init+0x1d36>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102ea1:	83 ec 08             	sub    $0x8,%esp
f0102ea4:	68 00 10 00 00       	push   $0x1000
f0102ea9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102eac:	ff b0 f4 1a 00 00    	push   0x1af4(%eax)
f0102eb2:	e8 f1 e3 ff ff       	call   f01012a8 <page_remove>
	assert(pp2->pp_ref == 0);
f0102eb7:	83 c4 10             	add    $0x10,%esp
f0102eba:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102ebf:	0f 85 fc 01 00 00    	jne    f01030c1 <mem_init+0x1d58>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ec5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ec8:	8b 88 f4 1a 00 00    	mov    0x1af4(%eax),%ecx
f0102ece:	8b 11                	mov    (%ecx),%edx
f0102ed0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102ed6:	89 f7                	mov    %esi,%edi
f0102ed8:	2b b8 f0 1a 00 00    	sub    0x1af0(%eax),%edi
f0102ede:	89 f8                	mov    %edi,%eax
f0102ee0:	c1 f8 03             	sar    $0x3,%eax
f0102ee3:	c1 e0 0c             	shl    $0xc,%eax
f0102ee6:	39 c2                	cmp    %eax,%edx
f0102ee8:	0f 85 f5 01 00 00    	jne    f01030e3 <mem_init+0x1d7a>
	kern_pgdir[0] = 0;
f0102eee:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102ef4:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102ef9:	0f 85 06 02 00 00    	jne    f0103105 <mem_init+0x1d9c>
	pp0->pp_ref = 0;
f0102eff:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102f05:	83 ec 0c             	sub    $0xc,%esp
f0102f08:	56                   	push   %esi
f0102f09:	e8 c0 e1 ff ff       	call   f01010ce <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102f0e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f11:	8d 83 44 6c f8 ff    	lea    -0x793bc(%ebx),%eax
f0102f17:	89 04 24             	mov    %eax,(%esp)
f0102f1a:	e8 06 0b 00 00       	call   f0103a25 <cprintf>
}
f0102f1f:	83 c4 10             	add    $0x10,%esp
f0102f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f25:	5b                   	pop    %ebx
f0102f26:	5e                   	pop    %esi
f0102f27:	5f                   	pop    %edi
f0102f28:	5d                   	pop    %ebp
f0102f29:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f2a:	50                   	push   %eax
f0102f2b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f2e:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0102f34:	50                   	push   %eax
f0102f35:	68 e6 00 00 00       	push   $0xe6
f0102f3a:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102f40:	50                   	push   %eax
f0102f41:	e8 6b d1 ff ff       	call   f01000b1 <_panic>
	assert((pp0 = page_alloc(0)));
f0102f46:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f49:	8d 83 80 62 f8 ff    	lea    -0x79d80(%ebx),%eax
f0102f4f:	50                   	push   %eax
f0102f50:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102f56:	50                   	push   %eax
f0102f57:	68 d8 03 00 00       	push   $0x3d8
f0102f5c:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102f62:	50                   	push   %eax
f0102f63:	e8 49 d1 ff ff       	call   f01000b1 <_panic>
	assert((pp1 = page_alloc(0)));
f0102f68:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f6b:	8d 83 96 62 f8 ff    	lea    -0x79d6a(%ebx),%eax
f0102f71:	50                   	push   %eax
f0102f72:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102f78:	50                   	push   %eax
f0102f79:	68 d9 03 00 00       	push   $0x3d9
f0102f7e:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102f84:	50                   	push   %eax
f0102f85:	e8 27 d1 ff ff       	call   f01000b1 <_panic>
	assert((pp2 = page_alloc(0)));
f0102f8a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f8d:	8d 83 ac 62 f8 ff    	lea    -0x79d54(%ebx),%eax
f0102f93:	50                   	push   %eax
f0102f94:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102f9a:	50                   	push   %eax
f0102f9b:	68 da 03 00 00       	push   $0x3da
f0102fa0:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102fa6:	50                   	push   %eax
f0102fa7:	e8 05 d1 ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102fac:	52                   	push   %edx
f0102fad:	89 cb                	mov    %ecx,%ebx
f0102faf:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0102fb5:	50                   	push   %eax
f0102fb6:	6a 56                	push   $0x56
f0102fb8:	8d 81 bb 61 f8 ff    	lea    -0x79e45(%ecx),%eax
f0102fbe:	50                   	push   %eax
f0102fbf:	e8 ed d0 ff ff       	call   f01000b1 <_panic>
f0102fc4:	52                   	push   %edx
f0102fc5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102fc8:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f0102fce:	50                   	push   %eax
f0102fcf:	6a 56                	push   $0x56
f0102fd1:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f0102fd7:	50                   	push   %eax
f0102fd8:	e8 d4 d0 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 1);
f0102fdd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102fe0:	8d 83 7d 63 f8 ff    	lea    -0x79c83(%ebx),%eax
f0102fe6:	50                   	push   %eax
f0102fe7:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0102fed:	50                   	push   %eax
f0102fee:	68 df 03 00 00       	push   $0x3df
f0102ff3:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0102ff9:	50                   	push   %eax
f0102ffa:	e8 b2 d0 ff ff       	call   f01000b1 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102fff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103002:	8d 83 d0 6b f8 ff    	lea    -0x79430(%ebx),%eax
f0103008:	50                   	push   %eax
f0103009:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010300f:	50                   	push   %eax
f0103010:	68 e0 03 00 00       	push   $0x3e0
f0103015:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010301b:	50                   	push   %eax
f010301c:	e8 90 d0 ff ff       	call   f01000b1 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103021:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103024:	8d 83 f4 6b f8 ff    	lea    -0x7940c(%ebx),%eax
f010302a:	50                   	push   %eax
f010302b:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0103031:	50                   	push   %eax
f0103032:	68 e2 03 00 00       	push   $0x3e2
f0103037:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010303d:	50                   	push   %eax
f010303e:	e8 6e d0 ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 1);
f0103043:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103046:	8d 83 9f 63 f8 ff    	lea    -0x79c61(%ebx),%eax
f010304c:	50                   	push   %eax
f010304d:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0103053:	50                   	push   %eax
f0103054:	68 e3 03 00 00       	push   $0x3e3
f0103059:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f010305f:	50                   	push   %eax
f0103060:	e8 4c d0 ff ff       	call   f01000b1 <_panic>
	assert(pp1->pp_ref == 0);
f0103065:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103068:	8d 83 09 64 f8 ff    	lea    -0x79bf7(%ebx),%eax
f010306e:	50                   	push   %eax
f010306f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0103075:	50                   	push   %eax
f0103076:	68 e4 03 00 00       	push   $0x3e4
f010307b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0103081:	50                   	push   %eax
f0103082:	e8 2a d0 ff ff       	call   f01000b1 <_panic>
f0103087:	52                   	push   %edx
f0103088:	89 cb                	mov    %ecx,%ebx
f010308a:	8d 81 94 64 f8 ff    	lea    -0x79b6c(%ecx),%eax
f0103090:	50                   	push   %eax
f0103091:	6a 56                	push   $0x56
f0103093:	8d 81 bb 61 f8 ff    	lea    -0x79e45(%ecx),%eax
f0103099:	50                   	push   %eax
f010309a:	e8 12 d0 ff ff       	call   f01000b1 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010309f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01030a2:	8d 83 18 6c f8 ff    	lea    -0x793e8(%ebx),%eax
f01030a8:	50                   	push   %eax
f01030a9:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01030af:	50                   	push   %eax
f01030b0:	68 e6 03 00 00       	push   $0x3e6
f01030b5:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01030bb:	50                   	push   %eax
f01030bc:	e8 f0 cf ff ff       	call   f01000b1 <_panic>
	assert(pp2->pp_ref == 0);
f01030c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01030c4:	8d 83 d7 63 f8 ff    	lea    -0x79c29(%ebx),%eax
f01030ca:	50                   	push   %eax
f01030cb:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01030d1:	50                   	push   %eax
f01030d2:	68 e8 03 00 00       	push   $0x3e8
f01030d7:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01030dd:	50                   	push   %eax
f01030de:	e8 ce cf ff ff       	call   f01000b1 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01030e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01030e6:	8d 83 28 67 f8 ff    	lea    -0x798d8(%ebx),%eax
f01030ec:	50                   	push   %eax
f01030ed:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f01030f3:	50                   	push   %eax
f01030f4:	68 eb 03 00 00       	push   $0x3eb
f01030f9:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f01030ff:	50                   	push   %eax
f0103100:	e8 ac cf ff ff       	call   f01000b1 <_panic>
	assert(pp0->pp_ref == 1);
f0103105:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103108:	8d 83 8e 63 f8 ff    	lea    -0x79c72(%ebx),%eax
f010310e:	50                   	push   %eax
f010310f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0103115:	50                   	push   %eax
f0103116:	68 ed 03 00 00       	push   $0x3ed
f010311b:	8d 83 af 61 f8 ff    	lea    -0x79e51(%ebx),%eax
f0103121:	50                   	push   %eax
f0103122:	e8 8a cf ff ff       	call   f01000b1 <_panic>

f0103127 <tlb_invalidate>:
{
f0103127:	55                   	push   %ebp
f0103128:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010312a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010312d:	0f 01 38             	invlpg (%eax)
}
f0103130:	5d                   	pop    %ebp
f0103131:	c3                   	ret    

f0103132 <user_mem_check>:
{
f0103132:	55                   	push   %ebp
f0103133:	89 e5                	mov    %esp,%ebp
f0103135:	57                   	push   %edi
f0103136:	56                   	push   %esi
f0103137:	53                   	push   %ebx
f0103138:	83 ec 1c             	sub    $0x1c,%esp
f010313b:	e8 b9 d5 ff ff       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0103140:	05 28 c7 07 00       	add    $0x7c728,%eax
f0103145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103148:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint32_t start = (uint32_t)ROUNDDOWN((char *)va, PGSIZE);
f010314b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010314e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = (uint32_t)ROUNDDOWN((char *)va + len, PGSIZE);
f0103154:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103157:	03 75 10             	add    0x10(%ebp),%esi
f010315a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; start <= end; start += PGSIZE)
f0103160:	39 de                	cmp    %ebx,%esi
f0103162:	72 52                	jb     f01031b6 <user_mem_check+0x84>
		pte_t* pte = pgdir_walk(env->env_pgdir, (void *)start, 0);
f0103164:	83 ec 04             	sub    $0x4,%esp
f0103167:	6a 00                	push   $0x0
f0103169:	53                   	push   %ebx
f010316a:	ff 77 5c             	push   0x5c(%edi)
f010316d:	e8 d4 df ff ff       	call   f0101146 <pgdir_walk>
		if((start >= ULIM) || (pte == NULL) || !(*pte & PTE_U) || ((*pte & perm) != perm))
f0103172:	83 c4 10             	add    $0x10,%esp
f0103175:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010317b:	77 1a                	ja     f0103197 <user_mem_check+0x65>
f010317d:	85 c0                	test   %eax,%eax
f010317f:	74 16                	je     f0103197 <user_mem_check+0x65>
f0103181:	8b 00                	mov    (%eax),%eax
f0103183:	a8 04                	test   $0x4,%al
f0103185:	74 10                	je     f0103197 <user_mem_check+0x65>
f0103187:	23 45 14             	and    0x14(%ebp),%eax
f010318a:	39 45 14             	cmp    %eax,0x14(%ebp)
f010318d:	75 08                	jne    f0103197 <user_mem_check+0x65>
	for(; start <= end; start += PGSIZE)
f010318f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103195:	eb c9                	jmp    f0103160 <user_mem_check+0x2e>
			user_mem_check_addr = start < (uint32_t)va ? (uint32_t)va : start;
f0103197:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
f010319a:	89 d8                	mov    %ebx,%eax
f010319c:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f01031a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01031a3:	89 82 00 1b 00 00    	mov    %eax,0x1b00(%edx)
			return -E_FAULT;
f01031a9:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01031ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01031b1:	5b                   	pop    %ebx
f01031b2:	5e                   	pop    %esi
f01031b3:	5f                   	pop    %edi
f01031b4:	5d                   	pop    %ebp
f01031b5:	c3                   	ret    
	return 0;
f01031b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01031bb:	eb f1                	jmp    f01031ae <user_mem_check+0x7c>

f01031bd <user_mem_assert>:
{
f01031bd:	55                   	push   %ebp
f01031be:	89 e5                	mov    %esp,%ebp
f01031c0:	56                   	push   %esi
f01031c1:	53                   	push   %ebx
f01031c2:	e8 a0 cf ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01031c7:	81 c3 a1 c6 07 00    	add    $0x7c6a1,%ebx
f01031cd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01031d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01031d3:	83 c8 04             	or     $0x4,%eax
f01031d6:	50                   	push   %eax
f01031d7:	ff 75 10             	push   0x10(%ebp)
f01031da:	ff 75 0c             	push   0xc(%ebp)
f01031dd:	56                   	push   %esi
f01031de:	e8 4f ff ff ff       	call   f0103132 <user_mem_check>
f01031e3:	83 c4 10             	add    $0x10,%esp
f01031e6:	85 c0                	test   %eax,%eax
f01031e8:	78 07                	js     f01031f1 <user_mem_assert+0x34>
}
f01031ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01031ed:	5b                   	pop    %ebx
f01031ee:	5e                   	pop    %esi
f01031ef:	5d                   	pop    %ebp
f01031f0:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01031f1:	83 ec 04             	sub    $0x4,%esp
f01031f4:	ff b3 00 1b 00 00    	push   0x1b00(%ebx)
f01031fa:	ff 76 48             	push   0x48(%esi)
f01031fd:	8d 83 70 6c f8 ff    	lea    -0x79390(%ebx),%eax
f0103203:	50                   	push   %eax
f0103204:	e8 1c 08 00 00       	call   f0103a25 <cprintf>
		env_destroy(env);	// may not return
f0103209:	89 34 24             	mov    %esi,(%esp)
f010320c:	e8 aa 06 00 00       	call   f01038bb <env_destroy>
f0103211:	83 c4 10             	add    $0x10,%esp
}
f0103214:	eb d4                	jmp    f01031ea <user_mem_assert+0x2d>

f0103216 <__x86.get_pc_thunk.dx>:
f0103216:	8b 14 24             	mov    (%esp),%edx
f0103219:	c3                   	ret    

f010321a <__x86.get_pc_thunk.cx>:
f010321a:	8b 0c 24             	mov    (%esp),%ecx
f010321d:	c3                   	ret    

f010321e <__x86.get_pc_thunk.di>:
f010321e:	8b 3c 24             	mov    (%esp),%edi
f0103221:	c3                   	ret    

f0103222 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103222:	55                   	push   %ebp
f0103223:	89 e5                	mov    %esp,%ebp
f0103225:	57                   	push   %edi
f0103226:	56                   	push   %esi
f0103227:	53                   	push   %ebx
f0103228:	83 ec 1c             	sub    $0x1c,%esp
f010322b:	e8 37 cf ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103230:	81 c3 38 c6 07 00    	add    $0x7c638,%ebx
f0103236:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	void *start = ROUNDDOWN(va, PGSIZE);
f0103238:	89 d6                	mov    %edx,%esi
f010323a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi

	void *end = ROUNDUP(va+len, PGSIZE);
f0103240:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103247:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010324c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(; start < end; start += PGSIZE)
f010324f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0103252:	73 62                	jae    f01032b6 <region_alloc+0x94>
	{
		struct PageInfo *pp;
		pp = page_alloc(ALLOC_ZERO);
f0103254:	83 ec 0c             	sub    $0xc,%esp
f0103257:	6a 01                	push   $0x1
f0103259:	e8 eb dd ff ff       	call   f0101049 <page_alloc>
		if(!pp)
f010325e:	83 c4 10             	add    $0x10,%esp
f0103261:	85 c0                	test   %eax,%eax
f0103263:	74 1b                	je     f0103280 <region_alloc+0x5e>
		{
			panic("region alloc failed\n");
		}
		if(page_insert(e->env_pgdir, pp, start, PTE_U | PTE_W))
f0103265:	6a 06                	push   $0x6
f0103267:	56                   	push   %esi
f0103268:	50                   	push   %eax
f0103269:	ff 77 5c             	push   0x5c(%edi)
f010326c:	e8 72 e0 ff ff       	call   f01012e3 <page_insert>
f0103271:	83 c4 10             	add    $0x10,%esp
f0103274:	85 c0                	test   %eax,%eax
f0103276:	75 23                	jne    f010329b <region_alloc+0x79>
	for(; start < end; start += PGSIZE)
f0103278:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010327e:	eb cf                	jmp    f010324f <region_alloc+0x2d>
			panic("region alloc failed\n");
f0103280:	83 ec 04             	sub    $0x4,%esp
f0103283:	8d 83 a5 6c f8 ff    	lea    -0x7935b(%ebx),%eax
f0103289:	50                   	push   %eax
f010328a:	68 35 01 00 00       	push   $0x135
f010328f:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f0103295:	50                   	push   %eax
f0103296:	e8 16 ce ff ff       	call   f01000b1 <_panic>
		{
			panic("page insert failed\n");
f010329b:	83 ec 04             	sub    $0x4,%esp
f010329e:	8d 83 c5 6c f8 ff    	lea    -0x7933b(%ebx),%eax
f01032a4:	50                   	push   %eax
f01032a5:	68 39 01 00 00       	push   $0x139
f01032aa:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f01032b0:	50                   	push   %eax
f01032b1:	e8 fb cd ff ff       	call   f01000b1 <_panic>
		}
	}
}
f01032b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01032b9:	5b                   	pop    %ebx
f01032ba:	5e                   	pop    %esi
f01032bb:	5f                   	pop    %edi
f01032bc:	5d                   	pop    %ebp
f01032bd:	c3                   	ret    

f01032be <envid2env>:
{
f01032be:	55                   	push   %ebp
f01032bf:	89 e5                	mov    %esp,%ebp
f01032c1:	53                   	push   %ebx
f01032c2:	e8 53 ff ff ff       	call   f010321a <__x86.get_pc_thunk.cx>
f01032c7:	81 c1 a1 c5 07 00    	add    $0x7c5a1,%ecx
f01032cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01032d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	if (envid == 0) {
f01032d3:	85 c0                	test   %eax,%eax
f01032d5:	74 4c                	je     f0103323 <envid2env+0x65>
	e = &envs[ENVX(envid)];
f01032d7:	89 c2                	mov    %eax,%edx
f01032d9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01032df:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01032e2:	c1 e2 05             	shl    $0x5,%edx
f01032e5:	03 91 10 1b 00 00    	add    0x1b10(%ecx),%edx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01032eb:	83 7a 54 00          	cmpl   $0x0,0x54(%edx)
f01032ef:	74 42                	je     f0103333 <envid2env+0x75>
f01032f1:	39 42 48             	cmp    %eax,0x48(%edx)
f01032f4:	75 49                	jne    f010333f <envid2env+0x81>
	return 0;
f01032f6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01032fb:	84 db                	test   %bl,%bl
f01032fd:	74 2a                	je     f0103329 <envid2env+0x6b>
f01032ff:	8b 89 0c 1b 00 00    	mov    0x1b0c(%ecx),%ecx
f0103305:	39 d1                	cmp    %edx,%ecx
f0103307:	74 20                	je     f0103329 <envid2env+0x6b>
f0103309:	8b 42 4c             	mov    0x4c(%edx),%eax
f010330c:	3b 41 48             	cmp    0x48(%ecx),%eax
f010330f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103314:	0f 45 d3             	cmovne %ebx,%edx
f0103317:	0f 94 c0             	sete   %al
f010331a:	0f b6 c0             	movzbl %al,%eax
f010331d:	8d 44 00 fe          	lea    -0x2(%eax,%eax,1),%eax
f0103321:	eb 06                	jmp    f0103329 <envid2env+0x6b>
		*env_store = curenv;
f0103323:	8b 91 0c 1b 00 00    	mov    0x1b0c(%ecx),%edx
f0103329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010332c:	89 11                	mov    %edx,(%ecx)
}
f010332e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103331:	c9                   	leave  
f0103332:	c3                   	ret    
f0103333:	ba 00 00 00 00       	mov    $0x0,%edx
		return -E_BAD_ENV;
f0103338:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010333d:	eb ea                	jmp    f0103329 <envid2env+0x6b>
f010333f:	ba 00 00 00 00       	mov    $0x0,%edx
f0103344:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103349:	eb de                	jmp    f0103329 <envid2env+0x6b>

f010334b <env_init_percpu>:
{
f010334b:	e8 a9 d3 ff ff       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0103350:	05 18 c5 07 00       	add    $0x7c518,%eax
	asm volatile("lgdt (%0)" : : "r" (p));
f0103355:	8d 80 98 17 00 00    	lea    0x1798(%eax),%eax
f010335b:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f010335e:	b8 23 00 00 00       	mov    $0x23,%eax
f0103363:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103365:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103367:	b8 10 00 00 00       	mov    $0x10,%eax
f010336c:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010336e:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103370:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103372:	ea 79 33 10 f0 08 00 	ljmp   $0x8,$0xf0103379
	asm volatile("lldt %0" : : "r" (sel));
f0103379:	b8 00 00 00 00       	mov    $0x0,%eax
f010337e:	0f 00 d0             	lldt   %ax
}
f0103381:	c3                   	ret    

f0103382 <env_init>:
{
f0103382:	55                   	push   %ebp
f0103383:	89 e5                	mov    %esp,%ebp
f0103385:	56                   	push   %esi
f0103386:	53                   	push   %ebx
f0103387:	e8 71 d3 ff ff       	call   f01006fd <__x86.get_pc_thunk.si>
f010338c:	81 c6 dc c4 07 00    	add    $0x7c4dc,%esi
		envs[i].env_id = 0;
f0103392:	8b 9e 10 1b 00 00    	mov    0x1b10(%esi),%ebx
f0103398:	8d 83 a0 7f 01 00    	lea    0x17fa0(%ebx),%eax
f010339e:	ba 00 00 00 00       	mov    $0x0,%edx
f01033a3:	89 d1                	mov    %edx,%ecx
f01033a5:	89 c2                	mov    %eax,%edx
f01033a7:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f01033ae:	89 48 44             	mov    %ecx,0x44(%eax)
	for(i = NENV-1; i >= 0; i--)
f01033b1:	83 e8 60             	sub    $0x60,%eax
f01033b4:	39 da                	cmp    %ebx,%edx
f01033b6:	75 eb                	jne    f01033a3 <env_init+0x21>
f01033b8:	89 9e 14 1b 00 00    	mov    %ebx,0x1b14(%esi)
	env_init_percpu();
f01033be:	e8 88 ff ff ff       	call   f010334b <env_init_percpu>
}
f01033c3:	5b                   	pop    %ebx
f01033c4:	5e                   	pop    %esi
f01033c5:	5d                   	pop    %ebp
f01033c6:	c3                   	ret    

f01033c7 <env_alloc>:
{
f01033c7:	55                   	push   %ebp
f01033c8:	89 e5                	mov    %esp,%ebp
f01033ca:	56                   	push   %esi
f01033cb:	53                   	push   %ebx
f01033cc:	e8 96 cd ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01033d1:	81 c3 97 c4 07 00    	add    $0x7c497,%ebx
	if (!(e = env_free_list))
f01033d7:	8b b3 14 1b 00 00    	mov    0x1b14(%ebx),%esi
f01033dd:	85 f6                	test   %esi,%esi
f01033df:	0f 84 63 01 00 00    	je     f0103548 <env_alloc+0x181>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01033e5:	83 ec 0c             	sub    $0xc,%esp
f01033e8:	6a 01                	push   $0x1
f01033ea:	e8 5a dc ff ff       	call   f0101049 <page_alloc>
f01033ef:	83 c4 10             	add    $0x10,%esp
f01033f2:	85 c0                	test   %eax,%eax
f01033f4:	0f 84 55 01 00 00    	je     f010354f <env_alloc+0x188>
	p->pp_ref += 1;
f01033fa:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01033ff:	c7 c2 58 13 18 f0    	mov    $0xf0181358,%edx
f0103405:	2b 02                	sub    (%edx),%eax
f0103407:	c1 f8 03             	sar    $0x3,%eax
f010340a:	89 c2                	mov    %eax,%edx
f010340c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010340f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0103414:	c7 c1 60 13 18 f0    	mov    $0xf0181360,%ecx
f010341a:	3b 01                	cmp    (%ecx),%eax
f010341c:	0f 83 f7 00 00 00    	jae    f0103519 <env_alloc+0x152>
	return (void *)(pa + KERNBASE);
f0103422:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	e->env_pgdir = (pte_t *)page2kva(p);
f0103428:	89 46 5c             	mov    %eax,0x5c(%esi)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f010342b:	83 ec 04             	sub    $0x4,%esp
f010342e:	68 00 10 00 00       	push   $0x1000
f0103433:	c7 c2 5c 13 18 f0    	mov    $0xf018135c,%edx
f0103439:	ff 32                	push   (%edx)
f010343b:	50                   	push   %eax
f010343c:	e8 29 1d 00 00       	call   f010516a <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103441:	8b 46 5c             	mov    0x5c(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103444:	83 c4 10             	add    $0x10,%esp
f0103447:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010344c:	0f 86 dd 00 00 00    	jbe    f010352f <env_alloc+0x168>
	return (physaddr_t)kva - KERNBASE;
f0103452:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103458:	83 ca 05             	or     $0x5,%edx
f010345b:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103461:	8b 46 48             	mov    0x48(%esi),%eax
f0103464:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f0103469:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f010346e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103473:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103476:	89 f2                	mov    %esi,%edx
f0103478:	2b 93 10 1b 00 00    	sub    0x1b10(%ebx),%edx
f010347e:	c1 fa 05             	sar    $0x5,%edx
f0103481:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0103487:	09 d0                	or     %edx,%eax
f0103489:	89 46 48             	mov    %eax,0x48(%esi)
	e->env_parent_id = parent_id;
f010348c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010348f:	89 46 4c             	mov    %eax,0x4c(%esi)
	e->env_type = ENV_TYPE_USER;
f0103492:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
	e->env_status = ENV_RUNNABLE;
f0103499:	c7 46 54 02 00 00 00 	movl   $0x2,0x54(%esi)
	e->env_runs = 0;
f01034a0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01034a7:	83 ec 04             	sub    $0x4,%esp
f01034aa:	6a 44                	push   $0x44
f01034ac:	6a 00                	push   $0x0
f01034ae:	56                   	push   %esi
f01034af:	e8 0e 1c 00 00       	call   f01050c2 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01034b4:	66 c7 46 24 23 00    	movw   $0x23,0x24(%esi)
	e->env_tf.tf_es = GD_UD | 3;
f01034ba:	66 c7 46 20 23 00    	movw   $0x23,0x20(%esi)
	e->env_tf.tf_ss = GD_UD | 3;
f01034c0:	66 c7 46 40 23 00    	movw   $0x23,0x40(%esi)
	e->env_tf.tf_esp = USTACKTOP;
f01034c6:	c7 46 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%esi)
	e->env_tf.tf_cs = GD_UT | 3;
f01034cd:	66 c7 46 34 1b 00    	movw   $0x1b,0x34(%esi)
	env_free_list = e->env_link;
f01034d3:	8b 46 44             	mov    0x44(%esi),%eax
f01034d6:	89 83 14 1b 00 00    	mov    %eax,0x1b14(%ebx)
	*newenv_store = e;
f01034dc:	8b 45 08             	mov    0x8(%ebp),%eax
f01034df:	89 30                	mov    %esi,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01034e1:	8b 4e 48             	mov    0x48(%esi),%ecx
f01034e4:	8b 83 0c 1b 00 00    	mov    0x1b0c(%ebx),%eax
f01034ea:	83 c4 10             	add    $0x10,%esp
f01034ed:	ba 00 00 00 00       	mov    $0x0,%edx
f01034f2:	85 c0                	test   %eax,%eax
f01034f4:	74 03                	je     f01034f9 <env_alloc+0x132>
f01034f6:	8b 50 48             	mov    0x48(%eax),%edx
f01034f9:	83 ec 04             	sub    $0x4,%esp
f01034fc:	51                   	push   %ecx
f01034fd:	52                   	push   %edx
f01034fe:	8d 83 d9 6c f8 ff    	lea    -0x79327(%ebx),%eax
f0103504:	50                   	push   %eax
f0103505:	e8 1b 05 00 00       	call   f0103a25 <cprintf>
	return 0;
f010350a:	83 c4 10             	add    $0x10,%esp
f010350d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103512:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103515:	5b                   	pop    %ebx
f0103516:	5e                   	pop    %esi
f0103517:	5d                   	pop    %ebp
f0103518:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103519:	52                   	push   %edx
f010351a:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f0103520:	50                   	push   %eax
f0103521:	6a 56                	push   $0x56
f0103523:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f0103529:	50                   	push   %eax
f010352a:	e8 82 cb ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010352f:	50                   	push   %eax
f0103530:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0103536:	50                   	push   %eax
f0103537:	68 d6 00 00 00       	push   $0xd6
f010353c:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f0103542:	50                   	push   %eax
f0103543:	e8 69 cb ff ff       	call   f01000b1 <_panic>
		return -E_NO_FREE_ENV;
f0103548:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f010354d:	eb c3                	jmp    f0103512 <env_alloc+0x14b>
		return -E_NO_MEM;
f010354f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103554:	eb bc                	jmp    f0103512 <env_alloc+0x14b>

f0103556 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103556:	55                   	push   %ebp
f0103557:	89 e5                	mov    %esp,%ebp
f0103559:	57                   	push   %edi
f010355a:	56                   	push   %esi
f010355b:	53                   	push   %ebx
f010355c:	83 ec 34             	sub    $0x34,%esp
f010355f:	e8 03 cc ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103564:	81 c3 04 c3 07 00    	add    $0x7c304,%ebx
	// LAB 3: Your code here.
	struct Env *env;
	if(env_alloc(&env, 0))
f010356a:	6a 00                	push   $0x0
f010356c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010356f:	50                   	push   %eax
f0103570:	e8 52 fe ff ff       	call   f01033c7 <env_alloc>
f0103575:	83 c4 10             	add    $0x10,%esp
f0103578:	85 c0                	test   %eax,%eax
f010357a:	75 39                	jne    f01035b5 <env_create+0x5f>
f010357c:	89 c7                	mov    %eax,%edi
	{
		panic("env alloc failed\n");
	}
//	env->env_link = NULL;
	load_icode(env, binary);
f010357e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103581:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if(ELFHDR->e_magic != ELF_MAGIC)
f0103584:	8b 45 08             	mov    0x8(%ebp),%eax
f0103587:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f010358d:	75 41                	jne    f01035d0 <env_create+0x7a>
	ph = (struct Proghdr*)((uint32_t)ELFHDR + ELFHDR->e_phoff);
f010358f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103592:	89 c6                	mov    %eax,%esi
f0103594:	03 70 1c             	add    0x1c(%eax),%esi
	ph_num = ELFHDR->e_phnum;
f0103597:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f010359b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	lcr3(PADDR(e->env_pgdir));
f010359e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01035a1:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035a4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035a9:	76 40                	jbe    f01035eb <env_create+0x95>
	return (physaddr_t)kva - KERNBASE;
f01035ab:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01035b0:	0f 22 d8             	mov    %eax,%cr3
	for(i = 0; i < ph_num; i++)
f01035b3:	eb 55                	jmp    f010360a <env_create+0xb4>
		panic("env alloc failed\n");
f01035b5:	83 ec 04             	sub    $0x4,%esp
f01035b8:	8d 83 ee 6c f8 ff    	lea    -0x79312(%ebx),%eax
f01035be:	50                   	push   %eax
f01035bf:	68 a6 01 00 00       	push   $0x1a6
f01035c4:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f01035ca:	50                   	push   %eax
f01035cb:	e8 e1 ca ff ff       	call   f01000b1 <_panic>
		panic("ELFHDR->e_magic not equal ELF_MAGIC");
f01035d0:	83 ec 04             	sub    $0x4,%esp
f01035d3:	8d 83 24 6d f8 ff    	lea    -0x792dc(%ebx),%eax
f01035d9:	50                   	push   %eax
f01035da:	68 7b 01 00 00       	push   $0x17b
f01035df:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f01035e5:	50                   	push   %eax
f01035e6:	e8 c6 ca ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035eb:	50                   	push   %eax
f01035ec:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f01035f2:	50                   	push   %eax
f01035f3:	68 82 01 00 00       	push   $0x182
f01035f8:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f01035fe:	50                   	push   %eax
f01035ff:	e8 ad ca ff ff       	call   f01000b1 <_panic>
	for(i = 0; i < ph_num; i++)
f0103604:	83 c7 01             	add    $0x1,%edi
f0103607:	83 c6 20             	add    $0x20,%esi
f010360a:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f010360d:	74 3d                	je     f010364c <env_create+0xf6>
		if(ph[i].p_type == ELF_PROG_LOAD)
f010360f:	83 3e 01             	cmpl   $0x1,(%esi)
f0103612:	75 f0                	jne    f0103604 <env_create+0xae>
			region_alloc(e, (void *)ph[i].p_va, ph[i].p_memsz);
f0103614:	8b 4e 14             	mov    0x14(%esi),%ecx
f0103617:	8b 56 08             	mov    0x8(%esi),%edx
f010361a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010361d:	e8 00 fc ff ff       	call   f0103222 <region_alloc>
			memset((void *)ph[i].p_va, 0, (size_t)ph[i].p_memsz);
f0103622:	83 ec 04             	sub    $0x4,%esp
f0103625:	ff 76 14             	push   0x14(%esi)
f0103628:	6a 00                	push   $0x0
f010362a:	ff 76 08             	push   0x8(%esi)
f010362d:	e8 90 1a 00 00       	call   f01050c2 <memset>
			memcpy((void *)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f0103632:	83 c4 0c             	add    $0xc,%esp
f0103635:	ff 76 10             	push   0x10(%esi)
f0103638:	8b 45 08             	mov    0x8(%ebp),%eax
f010363b:	03 46 04             	add    0x4(%esi),%eax
f010363e:	50                   	push   %eax
f010363f:	ff 76 08             	push   0x8(%esi)
f0103642:	e8 23 1b 00 00       	call   f010516a <memcpy>
f0103647:	83 c4 10             	add    $0x10,%esp
f010364a:	eb b8                	jmp    f0103604 <env_create+0xae>
	lcr3(PADDR(kern_pgdir));
f010364c:	c7 c0 5c 13 18 f0    	mov    $0xf018135c,%eax
f0103652:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103654:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103659:	76 33                	jbe    f010368e <env_create+0x138>
	return (physaddr_t)kva - KERNBASE;
f010365b:	05 00 00 00 10       	add    $0x10000000,%eax
f0103660:	0f 22 d8             	mov    %eax,%cr3
	e->env_tf.tf_eip = ELFHDR->e_entry;
f0103663:	8b 45 08             	mov    0x8(%ebp),%eax
f0103666:	8b 40 18             	mov    0x18(%eax),%eax
f0103669:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f010366c:	89 43 30             	mov    %eax,0x30(%ebx)
	region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f010366f:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103674:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103679:	89 d8                	mov    %ebx,%eax
f010367b:	e8 a2 fb ff ff       	call   f0103222 <region_alloc>
	env->env_type = type;
f0103680:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103683:	89 43 50             	mov    %eax,0x50(%ebx)
//	envs->env_link = env;
//	envs = env;
}
f0103686:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103689:	5b                   	pop    %ebx
f010368a:	5e                   	pop    %esi
f010368b:	5f                   	pop    %edi
f010368c:	5d                   	pop    %ebp
f010368d:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010368e:	50                   	push   %eax
f010368f:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0103695:	50                   	push   %eax
f0103696:	68 8e 01 00 00       	push   $0x18e
f010369b:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f01036a1:	50                   	push   %eax
f01036a2:	e8 0a ca ff ff       	call   f01000b1 <_panic>

f01036a7 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01036a7:	55                   	push   %ebp
f01036a8:	89 e5                	mov    %esp,%ebp
f01036aa:	57                   	push   %edi
f01036ab:	56                   	push   %esi
f01036ac:	53                   	push   %ebx
f01036ad:	83 ec 2c             	sub    $0x2c,%esp
f01036b0:	e8 b2 ca ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01036b5:	81 c3 b3 c1 07 00    	add    $0x7c1b3,%ebx
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01036bb:	8b 93 0c 1b 00 00    	mov    0x1b0c(%ebx),%edx
f01036c1:	3b 55 08             	cmp    0x8(%ebp),%edx
f01036c4:	74 47                	je     f010370d <env_free+0x66>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01036c6:	8b 45 08             	mov    0x8(%ebp),%eax
f01036c9:	8b 48 48             	mov    0x48(%eax),%ecx
f01036cc:	b8 00 00 00 00       	mov    $0x0,%eax
f01036d1:	85 d2                	test   %edx,%edx
f01036d3:	74 03                	je     f01036d8 <env_free+0x31>
f01036d5:	8b 42 48             	mov    0x48(%edx),%eax
f01036d8:	83 ec 04             	sub    $0x4,%esp
f01036db:	51                   	push   %ecx
f01036dc:	50                   	push   %eax
f01036dd:	8d 83 00 6d f8 ff    	lea    -0x79300(%ebx),%eax
f01036e3:	50                   	push   %eax
f01036e4:	e8 3c 03 00 00       	call   f0103a25 <cprintf>
f01036e9:	83 c4 10             	add    $0x10,%esp
f01036ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if (PGNUM(pa) >= npages)
f01036f3:	c7 c0 60 13 18 f0    	mov    $0xf0181360,%eax
f01036f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (PGNUM(pa) >= npages)
f01036fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	return &pages[PGNUM(pa)];
f01036ff:	c7 c0 58 13 18 f0    	mov    $0xf0181358,%eax
f0103705:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103708:	e9 bf 00 00 00       	jmp    f01037cc <env_free+0x125>
		lcr3(PADDR(kern_pgdir));
f010370d:	c7 c0 5c 13 18 f0    	mov    $0xf018135c,%eax
f0103713:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103715:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010371a:	76 10                	jbe    f010372c <env_free+0x85>
	return (physaddr_t)kva - KERNBASE;
f010371c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103721:	0f 22 d8             	mov    %eax,%cr3
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103724:	8b 45 08             	mov    0x8(%ebp),%eax
f0103727:	8b 48 48             	mov    0x48(%eax),%ecx
f010372a:	eb a9                	jmp    f01036d5 <env_free+0x2e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010372c:	50                   	push   %eax
f010372d:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0103733:	50                   	push   %eax
f0103734:	68 bd 01 00 00       	push   $0x1bd
f0103739:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f010373f:	50                   	push   %eax
f0103740:	e8 6c c9 ff ff       	call   f01000b1 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103745:	57                   	push   %edi
f0103746:	8d 83 94 64 f8 ff    	lea    -0x79b6c(%ebx),%eax
f010374c:	50                   	push   %eax
f010374d:	68 cc 01 00 00       	push   $0x1cc
f0103752:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f0103758:	50                   	push   %eax
f0103759:	e8 53 c9 ff ff       	call   f01000b1 <_panic>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010375e:	83 c7 04             	add    $0x4,%edi
f0103761:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103767:	81 fe 00 00 40 00    	cmp    $0x400000,%esi
f010376d:	74 1e                	je     f010378d <env_free+0xe6>
			if (pt[pteno] & PTE_P)
f010376f:	f6 07 01             	testb  $0x1,(%edi)
f0103772:	74 ea                	je     f010375e <env_free+0xb7>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103774:	83 ec 08             	sub    $0x8,%esp
f0103777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010377a:	09 f0                	or     %esi,%eax
f010377c:	50                   	push   %eax
f010377d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103780:	ff 70 5c             	push   0x5c(%eax)
f0103783:	e8 20 db ff ff       	call   f01012a8 <page_remove>
f0103788:	83 c4 10             	add    $0x10,%esp
f010378b:	eb d1                	jmp    f010375e <env_free+0xb7>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010378d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103790:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103793:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103796:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010379d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01037a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037a3:	3b 10                	cmp    (%eax),%edx
f01037a5:	73 67                	jae    f010380e <env_free+0x167>
		page_decref(pa2page(pa));
f01037a7:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01037aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01037ad:	8b 00                	mov    (%eax),%eax
f01037af:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037b2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01037b5:	50                   	push   %eax
f01037b6:	e8 62 d9 ff ff       	call   f010111d <page_decref>
f01037bb:	83 c4 10             	add    $0x10,%esp
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01037be:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f01037c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01037c5:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01037ca:	74 5a                	je     f0103826 <env_free+0x17f>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01037cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01037cf:	8b 40 5c             	mov    0x5c(%eax),%eax
f01037d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01037d5:	8b 04 08             	mov    (%eax,%ecx,1),%eax
f01037d8:	a8 01                	test   $0x1,%al
f01037da:	74 e2                	je     f01037be <env_free+0x117>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01037dc:	89 c7                	mov    %eax,%edi
f01037de:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if (PGNUM(pa) >= npages)
f01037e4:	c1 e8 0c             	shr    $0xc,%eax
f01037e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01037ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037ed:	3b 02                	cmp    (%edx),%eax
f01037ef:	0f 83 50 ff ff ff    	jae    f0103745 <env_free+0x9e>
	return (void *)(pa + KERNBASE);
f01037f5:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
f01037fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01037fe:	c1 e0 14             	shl    $0x14,%eax
f0103801:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103804:	be 00 00 00 00       	mov    $0x0,%esi
f0103809:	e9 61 ff ff ff       	jmp    f010376f <env_free+0xc8>
		panic("pa2page called with invalid pa");
f010380e:	83 ec 04             	sub    $0x4,%esp
f0103811:	8d 83 f4 65 f8 ff    	lea    -0x79a0c(%ebx),%eax
f0103817:	50                   	push   %eax
f0103818:	6a 4f                	push   $0x4f
f010381a:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f0103820:	50                   	push   %eax
f0103821:	e8 8b c8 ff ff       	call   f01000b1 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103826:	8b 45 08             	mov    0x8(%ebp),%eax
f0103829:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010382c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103831:	76 57                	jbe    f010388a <env_free+0x1e3>
	e->env_pgdir = 0;
f0103833:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103836:	c7 41 5c 00 00 00 00 	movl   $0x0,0x5c(%ecx)
	return (physaddr_t)kva - KERNBASE;
f010383d:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103842:	c1 e8 0c             	shr    $0xc,%eax
f0103845:	c7 c2 60 13 18 f0    	mov    $0xf0181360,%edx
f010384b:	3b 02                	cmp    (%edx),%eax
f010384d:	73 54                	jae    f01038a3 <env_free+0x1fc>
	page_decref(pa2page(pa));
f010384f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103852:	c7 c2 58 13 18 f0    	mov    $0xf0181358,%edx
f0103858:	8b 12                	mov    (%edx),%edx
f010385a:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f010385d:	50                   	push   %eax
f010385e:	e8 ba d8 ff ff       	call   f010111d <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103863:	8b 45 08             	mov    0x8(%ebp),%eax
f0103866:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f010386d:	8b 83 14 1b 00 00    	mov    0x1b14(%ebx),%eax
f0103873:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103876:	89 41 44             	mov    %eax,0x44(%ecx)
	env_free_list = e;
f0103879:	89 8b 14 1b 00 00    	mov    %ecx,0x1b14(%ebx)
}
f010387f:	83 c4 10             	add    $0x10,%esp
f0103882:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103885:	5b                   	pop    %ebx
f0103886:	5e                   	pop    %esi
f0103887:	5f                   	pop    %edi
f0103888:	5d                   	pop    %ebp
f0103889:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010388a:	50                   	push   %eax
f010388b:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f0103891:	50                   	push   %eax
f0103892:	68 da 01 00 00       	push   $0x1da
f0103897:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f010389d:	50                   	push   %eax
f010389e:	e8 0e c8 ff ff       	call   f01000b1 <_panic>
		panic("pa2page called with invalid pa");
f01038a3:	83 ec 04             	sub    $0x4,%esp
f01038a6:	8d 83 f4 65 f8 ff    	lea    -0x79a0c(%ebx),%eax
f01038ac:	50                   	push   %eax
f01038ad:	6a 4f                	push   $0x4f
f01038af:	8d 83 bb 61 f8 ff    	lea    -0x79e45(%ebx),%eax
f01038b5:	50                   	push   %eax
f01038b6:	e8 f6 c7 ff ff       	call   f01000b1 <_panic>

f01038bb <env_destroy>:
//
// Frees environment e.
//
void
env_destroy(struct Env *e)
{
f01038bb:	55                   	push   %ebp
f01038bc:	89 e5                	mov    %esp,%ebp
f01038be:	53                   	push   %ebx
f01038bf:	83 ec 10             	sub    $0x10,%esp
f01038c2:	e8 a0 c8 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01038c7:	81 c3 a1 bf 07 00    	add    $0x7bfa1,%ebx
	env_free(e);
f01038cd:	ff 75 08             	push   0x8(%ebp)
f01038d0:	e8 d2 fd ff ff       	call   f01036a7 <env_free>

	cprintf("Destroyed the only environment - nothing more to do!\n");
f01038d5:	8d 83 48 6d f8 ff    	lea    -0x792b8(%ebx),%eax
f01038db:	89 04 24             	mov    %eax,(%esp)
f01038de:	e8 42 01 00 00       	call   f0103a25 <cprintf>
f01038e3:	83 c4 10             	add    $0x10,%esp
	while (1)
		monitor(NULL);
f01038e6:	83 ec 0c             	sub    $0xc,%esp
f01038e9:	6a 00                	push   $0x0
f01038eb:	e8 dc cf ff ff       	call   f01008cc <monitor>
f01038f0:	83 c4 10             	add    $0x10,%esp
f01038f3:	eb f1                	jmp    f01038e6 <env_destroy+0x2b>

f01038f5 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01038f5:	55                   	push   %ebp
f01038f6:	89 e5                	mov    %esp,%ebp
f01038f8:	53                   	push   %ebx
f01038f9:	83 ec 08             	sub    $0x8,%esp
f01038fc:	e8 66 c8 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103901:	81 c3 67 bf 07 00    	add    $0x7bf67,%ebx
	asm volatile(
f0103907:	8b 65 08             	mov    0x8(%ebp),%esp
f010390a:	61                   	popa   
f010390b:	07                   	pop    %es
f010390c:	1f                   	pop    %ds
f010390d:	83 c4 08             	add    $0x8,%esp
f0103910:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103911:	8d 83 16 6d f8 ff    	lea    -0x792ea(%ebx),%eax
f0103917:	50                   	push   %eax
f0103918:	68 03 02 00 00       	push   $0x203
f010391d:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f0103923:	50                   	push   %eax
f0103924:	e8 88 c7 ff ff       	call   f01000b1 <_panic>

f0103929 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103929:	55                   	push   %ebp
f010392a:	89 e5                	mov    %esp,%ebp
f010392c:	53                   	push   %ebx
f010392d:	83 ec 04             	sub    $0x4,%esp
f0103930:	e8 32 c8 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103935:	81 c3 33 bf 07 00    	add    $0x7bf33,%ebx
f010393b:	8b 45 08             	mov    0x8(%ebp),%eax
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != NULL && curenv->env_status == ENV_RUNNING)
f010393e:	8b 93 0c 1b 00 00    	mov    0x1b0c(%ebx),%edx
f0103944:	85 d2                	test   %edx,%edx
f0103946:	74 06                	je     f010394e <env_run+0x25>
f0103948:	83 7a 54 03          	cmpl   $0x3,0x54(%edx)
f010394c:	74 2e                	je     f010397c <env_run+0x53>
	{
		curenv->env_status = ENV_RUNNABLE;
	}

	curenv = e;
f010394e:	89 83 0c 1b 00 00    	mov    %eax,0x1b0c(%ebx)

	curenv->env_status = ENV_RUNNING;
f0103954:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		
	++curenv->env_runs;
f010395b:	83 40 58 01          	addl   $0x1,0x58(%eax)

	lcr3(PADDR(curenv->env_pgdir));
f010395f:	8b 50 5c             	mov    0x5c(%eax),%edx
	if ((uint32_t)kva < KERNBASE)
f0103962:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103968:	76 1b                	jbe    f0103985 <env_run+0x5c>
	return (physaddr_t)kva - KERNBASE;
f010396a:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0103970:	0f 22 da             	mov    %edx,%cr3

	env_pop_tf(&e->env_tf);
f0103973:	83 ec 0c             	sub    $0xc,%esp
f0103976:	50                   	push   %eax
f0103977:	e8 79 ff ff ff       	call   f01038f5 <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f010397c:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
f0103983:	eb c9                	jmp    f010394e <env_run+0x25>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103985:	52                   	push   %edx
f0103986:	8d 83 a0 65 f8 ff    	lea    -0x79a60(%ebx),%eax
f010398c:	50                   	push   %eax
f010398d:	68 2c 02 00 00       	push   $0x22c
f0103992:	8d 83 ba 6c f8 ff    	lea    -0x79346(%ebx),%eax
f0103998:	50                   	push   %eax
f0103999:	e8 13 c7 ff ff       	call   f01000b1 <_panic>

f010399e <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010399e:	55                   	push   %ebp
f010399f:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01039a1:	8b 45 08             	mov    0x8(%ebp),%eax
f01039a4:	ba 70 00 00 00       	mov    $0x70,%edx
f01039a9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01039aa:	ba 71 00 00 00       	mov    $0x71,%edx
f01039af:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01039b0:	0f b6 c0             	movzbl %al,%eax
}
f01039b3:	5d                   	pop    %ebp
f01039b4:	c3                   	ret    

f01039b5 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01039b5:	55                   	push   %ebp
f01039b6:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01039b8:	8b 45 08             	mov    0x8(%ebp),%eax
f01039bb:	ba 70 00 00 00       	mov    $0x70,%edx
f01039c0:	ee                   	out    %al,(%dx)
f01039c1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01039c4:	ba 71 00 00 00       	mov    $0x71,%edx
f01039c9:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01039ca:	5d                   	pop    %ebp
f01039cb:	c3                   	ret    

f01039cc <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01039cc:	55                   	push   %ebp
f01039cd:	89 e5                	mov    %esp,%ebp
f01039cf:	53                   	push   %ebx
f01039d0:	83 ec 10             	sub    $0x10,%esp
f01039d3:	e8 8f c7 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01039d8:	81 c3 90 be 07 00    	add    $0x7be90,%ebx
	cputchar(ch);
f01039de:	ff 75 08             	push   0x8(%ebp)
f01039e1:	e8 ec cc ff ff       	call   f01006d2 <cputchar>
	*cnt++;
}
f01039e6:	83 c4 10             	add    $0x10,%esp
f01039e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01039ec:	c9                   	leave  
f01039ed:	c3                   	ret    

f01039ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01039ee:	55                   	push   %ebp
f01039ef:	89 e5                	mov    %esp,%ebp
f01039f1:	53                   	push   %ebx
f01039f2:	83 ec 14             	sub    $0x14,%esp
f01039f5:	e8 6d c7 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01039fa:	81 c3 6e be 07 00    	add    $0x7be6e,%ebx
	int cnt = 0;
f0103a00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103a07:	ff 75 0c             	push   0xc(%ebp)
f0103a0a:	ff 75 08             	push   0x8(%ebp)
f0103a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103a10:	50                   	push   %eax
f0103a11:	8d 83 64 41 f8 ff    	lea    -0x7be9c(%ebx),%eax
f0103a17:	50                   	push   %eax
f0103a18:	e8 f8 0e 00 00       	call   f0104915 <vprintfmt>
	return cnt;
}
f0103a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a23:	c9                   	leave  
f0103a24:	c3                   	ret    

f0103a25 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103a25:	55                   	push   %ebp
f0103a26:	89 e5                	mov    %esp,%ebp
f0103a28:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103a2b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103a2e:	50                   	push   %eax
f0103a2f:	ff 75 08             	push   0x8(%ebp)
f0103a32:	e8 b7 ff ff ff       	call   f01039ee <vcprintf>
	va_end(ap);

	return cnt;
}
f0103a37:	c9                   	leave  
f0103a38:	c3                   	ret    

f0103a39 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103a39:	55                   	push   %ebp
f0103a3a:	89 e5                	mov    %esp,%ebp
f0103a3c:	57                   	push   %edi
f0103a3d:	56                   	push   %esi
f0103a3e:	53                   	push   %ebx
f0103a3f:	83 ec 04             	sub    $0x4,%esp
f0103a42:	e8 20 c7 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103a47:	81 c3 21 be 07 00    	add    $0x7be21,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0103a4d:	c7 83 3c 23 00 00 00 	movl   $0xf0000000,0x233c(%ebx)
f0103a54:	00 00 f0 
	ts.ts_ss0 = GD_KD;
f0103a57:	66 c7 83 40 23 00 00 	movw   $0x10,0x2340(%ebx)
f0103a5e:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
f0103a60:	66 c7 83 9e 23 00 00 	movw   $0x68,0x239e(%ebx)
f0103a67:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103a69:	c7 c0 00 c3 11 f0    	mov    $0xf011c300,%eax
f0103a6f:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
f0103a75:	8d b3 38 23 00 00    	lea    0x2338(%ebx),%esi
f0103a7b:	66 89 70 2a          	mov    %si,0x2a(%eax)
f0103a7f:	89 f2                	mov    %esi,%edx
f0103a81:	c1 ea 10             	shr    $0x10,%edx
f0103a84:	88 50 2c             	mov    %dl,0x2c(%eax)
f0103a87:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f0103a8b:	83 e2 f0             	and    $0xfffffff0,%edx
f0103a8e:	83 ca 09             	or     $0x9,%edx
f0103a91:	83 e2 9f             	and    $0xffffff9f,%edx
f0103a94:	83 ca 80             	or     $0xffffff80,%edx
f0103a97:	88 55 f3             	mov    %dl,-0xd(%ebp)
f0103a9a:	88 50 2d             	mov    %dl,0x2d(%eax)
f0103a9d:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
f0103aa1:	83 e1 c0             	and    $0xffffffc0,%ecx
f0103aa4:	83 c9 40             	or     $0x40,%ecx
f0103aa7:	83 e1 7f             	and    $0x7f,%ecx
f0103aaa:	88 48 2e             	mov    %cl,0x2e(%eax)
f0103aad:	c1 ee 18             	shr    $0x18,%esi
f0103ab0:	89 f1                	mov    %esi,%ecx
f0103ab2:	88 48 2f             	mov    %cl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0103ab5:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
f0103ab9:	83 e2 ef             	and    $0xffffffef,%edx
f0103abc:	88 50 2d             	mov    %dl,0x2d(%eax)
	asm volatile("ltr %0" : : "r" (sel));
f0103abf:	b8 28 00 00 00       	mov    $0x28,%eax
f0103ac4:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103ac7:	8d 83 a0 17 00 00    	lea    0x17a0(%ebx),%eax
f0103acd:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
f0103ad0:	83 c4 04             	add    $0x4,%esp
f0103ad3:	5b                   	pop    %ebx
f0103ad4:	5e                   	pop    %esi
f0103ad5:	5f                   	pop    %edi
f0103ad6:	5d                   	pop    %ebp
f0103ad7:	c3                   	ret    

f0103ad8 <trap_init>:
{
f0103ad8:	55                   	push   %ebp
f0103ad9:	89 e5                	mov    %esp,%ebp
f0103adb:	e8 19 cc ff ff       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0103ae0:	05 88 bd 07 00       	add    $0x7bd88,%eax
	SETGATE(idt[T_DIVIDE], 0, GD_KT, T_DIVIDE_handle, 0);	// DEVICE -> DIVIDE 🤡
f0103ae5:	c7 c2 b6 42 10 f0    	mov    $0xf01042b6,%edx
f0103aeb:	66 89 90 18 1b 00 00 	mov    %dx,0x1b18(%eax)
f0103af2:	66 c7 80 1a 1b 00 00 	movw   $0x8,0x1b1a(%eax)
f0103af9:	08 00 
f0103afb:	c6 80 1c 1b 00 00 00 	movb   $0x0,0x1b1c(%eax)
f0103b02:	c6 80 1d 1b 00 00 8e 	movb   $0x8e,0x1b1d(%eax)
f0103b09:	c1 ea 10             	shr    $0x10,%edx
f0103b0c:	66 89 90 1e 1b 00 00 	mov    %dx,0x1b1e(%eax)
	SETGATE(idt[T_DEBUG], 0, GD_KT, T_DEBUG_handle, 0);
f0103b13:	c7 c2 bc 42 10 f0    	mov    $0xf01042bc,%edx
f0103b19:	66 89 90 20 1b 00 00 	mov    %dx,0x1b20(%eax)
f0103b20:	66 c7 80 22 1b 00 00 	movw   $0x8,0x1b22(%eax)
f0103b27:	08 00 
f0103b29:	c6 80 24 1b 00 00 00 	movb   $0x0,0x1b24(%eax)
f0103b30:	c6 80 25 1b 00 00 8e 	movb   $0x8e,0x1b25(%eax)
f0103b37:	c1 ea 10             	shr    $0x10,%edx
f0103b3a:	66 89 90 26 1b 00 00 	mov    %dx,0x1b26(%eax)
	SETGATE(idt[T_NMI], 0, GD_KT, T_NMI_handle, 0);
f0103b41:	c7 c2 c2 42 10 f0    	mov    $0xf01042c2,%edx
f0103b47:	66 89 90 28 1b 00 00 	mov    %dx,0x1b28(%eax)
f0103b4e:	66 c7 80 2a 1b 00 00 	movw   $0x8,0x1b2a(%eax)
f0103b55:	08 00 
f0103b57:	c6 80 2c 1b 00 00 00 	movb   $0x0,0x1b2c(%eax)
f0103b5e:	c6 80 2d 1b 00 00 8e 	movb   $0x8e,0x1b2d(%eax)
f0103b65:	c1 ea 10             	shr    $0x10,%edx
f0103b68:	66 89 90 2e 1b 00 00 	mov    %dx,0x1b2e(%eax)
	SETGATE(idt[T_BRKPT], 1, GD_KT, T_BRKPT_handle, 3);
f0103b6f:	c7 c2 c8 42 10 f0    	mov    $0xf01042c8,%edx
f0103b75:	66 89 90 30 1b 00 00 	mov    %dx,0x1b30(%eax)
f0103b7c:	66 c7 80 32 1b 00 00 	movw   $0x8,0x1b32(%eax)
f0103b83:	08 00 
f0103b85:	c6 80 34 1b 00 00 00 	movb   $0x0,0x1b34(%eax)
f0103b8c:	c6 80 35 1b 00 00 ef 	movb   $0xef,0x1b35(%eax)
f0103b93:	c1 ea 10             	shr    $0x10,%edx
f0103b96:	66 89 90 36 1b 00 00 	mov    %dx,0x1b36(%eax)
	SETGATE(idt[T_OFLOW], 0, GD_KT, T_OFLOW_handle, 0);
f0103b9d:	c7 c2 ce 42 10 f0    	mov    $0xf01042ce,%edx
f0103ba3:	66 89 90 38 1b 00 00 	mov    %dx,0x1b38(%eax)
f0103baa:	66 c7 80 3a 1b 00 00 	movw   $0x8,0x1b3a(%eax)
f0103bb1:	08 00 
f0103bb3:	c6 80 3c 1b 00 00 00 	movb   $0x0,0x1b3c(%eax)
f0103bba:	c6 80 3d 1b 00 00 8e 	movb   $0x8e,0x1b3d(%eax)
f0103bc1:	c1 ea 10             	shr    $0x10,%edx
f0103bc4:	66 89 90 3e 1b 00 00 	mov    %dx,0x1b3e(%eax)
	SETGATE(idt[T_BOUND], 0, GD_KT, T_BOUND_handle, 0);
f0103bcb:	c7 c2 d4 42 10 f0    	mov    $0xf01042d4,%edx
f0103bd1:	66 89 90 40 1b 00 00 	mov    %dx,0x1b40(%eax)
f0103bd8:	66 c7 80 42 1b 00 00 	movw   $0x8,0x1b42(%eax)
f0103bdf:	08 00 
f0103be1:	c6 80 44 1b 00 00 00 	movb   $0x0,0x1b44(%eax)
f0103be8:	c6 80 45 1b 00 00 8e 	movb   $0x8e,0x1b45(%eax)
f0103bef:	c1 ea 10             	shr    $0x10,%edx
f0103bf2:	66 89 90 46 1b 00 00 	mov    %dx,0x1b46(%eax)
	SETGATE(idt[T_ILLOP], 0, GD_KT, T_ILLOP_handle, 0);
f0103bf9:	c7 c2 da 42 10 f0    	mov    $0xf01042da,%edx
f0103bff:	66 89 90 48 1b 00 00 	mov    %dx,0x1b48(%eax)
f0103c06:	66 c7 80 4a 1b 00 00 	movw   $0x8,0x1b4a(%eax)
f0103c0d:	08 00 
f0103c0f:	c6 80 4c 1b 00 00 00 	movb   $0x0,0x1b4c(%eax)
f0103c16:	c6 80 4d 1b 00 00 8e 	movb   $0x8e,0x1b4d(%eax)
f0103c1d:	c1 ea 10             	shr    $0x10,%edx
f0103c20:	66 89 90 4e 1b 00 00 	mov    %dx,0x1b4e(%eax)
	SETGATE(idt[T_DEVICE], 0, GD_KT, T_DEVICE_handle, 0);
f0103c27:	c7 c2 e0 42 10 f0    	mov    $0xf01042e0,%edx
f0103c2d:	66 89 90 50 1b 00 00 	mov    %dx,0x1b50(%eax)
f0103c34:	66 c7 80 52 1b 00 00 	movw   $0x8,0x1b52(%eax)
f0103c3b:	08 00 
f0103c3d:	c6 80 54 1b 00 00 00 	movb   $0x0,0x1b54(%eax)
f0103c44:	c6 80 55 1b 00 00 8e 	movb   $0x8e,0x1b55(%eax)
f0103c4b:	c1 ea 10             	shr    $0x10,%edx
f0103c4e:	66 89 90 56 1b 00 00 	mov    %dx,0x1b56(%eax)
	SETGATE(idt[T_DBLFLT], 0, GD_KT, T_DBLFLT_handle, 0);
f0103c55:	c7 c2 e6 42 10 f0    	mov    $0xf01042e6,%edx
f0103c5b:	66 89 90 58 1b 00 00 	mov    %dx,0x1b58(%eax)
f0103c62:	66 c7 80 5a 1b 00 00 	movw   $0x8,0x1b5a(%eax)
f0103c69:	08 00 
f0103c6b:	c6 80 5c 1b 00 00 00 	movb   $0x0,0x1b5c(%eax)
f0103c72:	c6 80 5d 1b 00 00 8e 	movb   $0x8e,0x1b5d(%eax)
f0103c79:	c1 ea 10             	shr    $0x10,%edx
f0103c7c:	66 89 90 5e 1b 00 00 	mov    %dx,0x1b5e(%eax)
	SETGATE(idt[T_TSS], 0, GD_KT, T_TSS_handle, 0);
f0103c83:	c7 c2 ea 42 10 f0    	mov    $0xf01042ea,%edx
f0103c89:	66 89 90 68 1b 00 00 	mov    %dx,0x1b68(%eax)
f0103c90:	66 c7 80 6a 1b 00 00 	movw   $0x8,0x1b6a(%eax)
f0103c97:	08 00 
f0103c99:	c6 80 6c 1b 00 00 00 	movb   $0x0,0x1b6c(%eax)
f0103ca0:	c6 80 6d 1b 00 00 8e 	movb   $0x8e,0x1b6d(%eax)
f0103ca7:	c1 ea 10             	shr    $0x10,%edx
f0103caa:	66 89 90 6e 1b 00 00 	mov    %dx,0x1b6e(%eax)
	SETGATE(idt[T_SEGNP], 0, GD_KT, T_SEGNP_handle, 0);
f0103cb1:	c7 c2 ee 42 10 f0    	mov    $0xf01042ee,%edx
f0103cb7:	66 89 90 70 1b 00 00 	mov    %dx,0x1b70(%eax)
f0103cbe:	66 c7 80 72 1b 00 00 	movw   $0x8,0x1b72(%eax)
f0103cc5:	08 00 
f0103cc7:	c6 80 74 1b 00 00 00 	movb   $0x0,0x1b74(%eax)
f0103cce:	c6 80 75 1b 00 00 8e 	movb   $0x8e,0x1b75(%eax)
f0103cd5:	c1 ea 10             	shr    $0x10,%edx
f0103cd8:	66 89 90 76 1b 00 00 	mov    %dx,0x1b76(%eax)
	SETGATE(idt[T_STACK], 0, GD_KT, T_STACK_handle, 0);
f0103cdf:	c7 c2 f2 42 10 f0    	mov    $0xf01042f2,%edx
f0103ce5:	66 89 90 78 1b 00 00 	mov    %dx,0x1b78(%eax)
f0103cec:	66 c7 80 7a 1b 00 00 	movw   $0x8,0x1b7a(%eax)
f0103cf3:	08 00 
f0103cf5:	c6 80 7c 1b 00 00 00 	movb   $0x0,0x1b7c(%eax)
f0103cfc:	c6 80 7d 1b 00 00 8e 	movb   $0x8e,0x1b7d(%eax)
f0103d03:	c1 ea 10             	shr    $0x10,%edx
f0103d06:	66 89 90 7e 1b 00 00 	mov    %dx,0x1b7e(%eax)
	SETGATE(idt[T_GPFLT], 0, GD_KT, T_GPFLT_handle, 0);
f0103d0d:	c7 c2 f6 42 10 f0    	mov    $0xf01042f6,%edx
f0103d13:	66 89 90 80 1b 00 00 	mov    %dx,0x1b80(%eax)
f0103d1a:	66 c7 80 82 1b 00 00 	movw   $0x8,0x1b82(%eax)
f0103d21:	08 00 
f0103d23:	c6 80 84 1b 00 00 00 	movb   $0x0,0x1b84(%eax)
f0103d2a:	c6 80 85 1b 00 00 8e 	movb   $0x8e,0x1b85(%eax)
f0103d31:	c1 ea 10             	shr    $0x10,%edx
f0103d34:	66 89 90 86 1b 00 00 	mov    %dx,0x1b86(%eax)
	SETGATE(idt[T_PGFLT], 0, GD_KT, T_PGFLT_handle, 0);		//GPFLT -> PGFLT 🤡
f0103d3b:	c7 c2 fa 42 10 f0    	mov    $0xf01042fa,%edx
f0103d41:	66 89 90 88 1b 00 00 	mov    %dx,0x1b88(%eax)
f0103d48:	66 c7 80 8a 1b 00 00 	movw   $0x8,0x1b8a(%eax)
f0103d4f:	08 00 
f0103d51:	c6 80 8c 1b 00 00 00 	movb   $0x0,0x1b8c(%eax)
f0103d58:	c6 80 8d 1b 00 00 8e 	movb   $0x8e,0x1b8d(%eax)
f0103d5f:	c1 ea 10             	shr    $0x10,%edx
f0103d62:	66 89 90 8e 1b 00 00 	mov    %dx,0x1b8e(%eax)
	SETGATE(idt[T_FPERR], 0, GD_KT, T_FPERR_handle, 0);
f0103d69:	c7 c2 fe 42 10 f0    	mov    $0xf01042fe,%edx
f0103d6f:	66 89 90 98 1b 00 00 	mov    %dx,0x1b98(%eax)
f0103d76:	66 c7 80 9a 1b 00 00 	movw   $0x8,0x1b9a(%eax)
f0103d7d:	08 00 
f0103d7f:	c6 80 9c 1b 00 00 00 	movb   $0x0,0x1b9c(%eax)
f0103d86:	c6 80 9d 1b 00 00 8e 	movb   $0x8e,0x1b9d(%eax)
f0103d8d:	c1 ea 10             	shr    $0x10,%edx
f0103d90:	66 89 90 9e 1b 00 00 	mov    %dx,0x1b9e(%eax)
	SETGATE(idt[T_ALIGN], 0, GD_KT, T_ALIGN_handle, 0);
f0103d97:	c7 c2 04 43 10 f0    	mov    $0xf0104304,%edx
f0103d9d:	66 89 90 a0 1b 00 00 	mov    %dx,0x1ba0(%eax)
f0103da4:	66 c7 80 a2 1b 00 00 	movw   $0x8,0x1ba2(%eax)
f0103dab:	08 00 
f0103dad:	c6 80 a4 1b 00 00 00 	movb   $0x0,0x1ba4(%eax)
f0103db4:	c6 80 a5 1b 00 00 8e 	movb   $0x8e,0x1ba5(%eax)
f0103dbb:	c1 ea 10             	shr    $0x10,%edx
f0103dbe:	66 89 90 a6 1b 00 00 	mov    %dx,0x1ba6(%eax)
	SETGATE(idt[T_MCHK], 0, GD_KT, T_MCHK_handle, 0);
f0103dc5:	c7 c2 08 43 10 f0    	mov    $0xf0104308,%edx
f0103dcb:	66 89 90 a8 1b 00 00 	mov    %dx,0x1ba8(%eax)
f0103dd2:	66 c7 80 aa 1b 00 00 	movw   $0x8,0x1baa(%eax)
f0103dd9:	08 00 
f0103ddb:	c6 80 ac 1b 00 00 00 	movb   $0x0,0x1bac(%eax)
f0103de2:	c6 80 ad 1b 00 00 8e 	movb   $0x8e,0x1bad(%eax)
f0103de9:	c1 ea 10             	shr    $0x10,%edx
f0103dec:	66 89 90 ae 1b 00 00 	mov    %dx,0x1bae(%eax)
	SETGATE(idt[T_SIMDERR], 0, GD_KT, T_SIMDERR_handle, 0);
f0103df3:	c7 c2 0e 43 10 f0    	mov    $0xf010430e,%edx
f0103df9:	66 89 90 b0 1b 00 00 	mov    %dx,0x1bb0(%eax)
f0103e00:	66 c7 80 b2 1b 00 00 	movw   $0x8,0x1bb2(%eax)
f0103e07:	08 00 
f0103e09:	c6 80 b4 1b 00 00 00 	movb   $0x0,0x1bb4(%eax)
f0103e10:	c6 80 b5 1b 00 00 8e 	movb   $0x8e,0x1bb5(%eax)
f0103e17:	c1 ea 10             	shr    $0x10,%edx
f0103e1a:	66 89 90 b6 1b 00 00 	mov    %dx,0x1bb6(%eax)
	SETGATE(idt[T_SYSCALL], 1, GD_KT, T_SYSCALL_handle, 3);
f0103e21:	c7 c2 14 43 10 f0    	mov    $0xf0104314,%edx
f0103e27:	66 89 90 98 1c 00 00 	mov    %dx,0x1c98(%eax)
f0103e2e:	66 c7 80 9a 1c 00 00 	movw   $0x8,0x1c9a(%eax)
f0103e35:	08 00 
f0103e37:	c6 80 9c 1c 00 00 00 	movb   $0x0,0x1c9c(%eax)
f0103e3e:	c6 80 9d 1c 00 00 ef 	movb   $0xef,0x1c9d(%eax)
f0103e45:	c1 ea 10             	shr    $0x10,%edx
f0103e48:	66 89 90 9e 1c 00 00 	mov    %dx,0x1c9e(%eax)
	SETGATE(idt[T_DEFAULT], 0, GD_KT, T_DEFAULT_handle, 0);
f0103e4f:	c7 c2 1a 43 10 f0    	mov    $0xf010431a,%edx
f0103e55:	66 89 90 b8 2a 00 00 	mov    %dx,0x2ab8(%eax)
f0103e5c:	66 c7 80 ba 2a 00 00 	movw   $0x8,0x2aba(%eax)
f0103e63:	08 00 
f0103e65:	c6 80 bc 2a 00 00 00 	movb   $0x0,0x2abc(%eax)
f0103e6c:	c6 80 bd 2a 00 00 8e 	movb   $0x8e,0x2abd(%eax)
f0103e73:	c1 ea 10             	shr    $0x10,%edx
f0103e76:	66 89 90 be 2a 00 00 	mov    %dx,0x2abe(%eax)
	trap_init_percpu();
f0103e7d:	e8 b7 fb ff ff       	call   f0103a39 <trap_init_percpu>
}
f0103e82:	5d                   	pop    %ebp
f0103e83:	c3                   	ret    

f0103e84 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103e84:	55                   	push   %ebp
f0103e85:	89 e5                	mov    %esp,%ebp
f0103e87:	56                   	push   %esi
f0103e88:	53                   	push   %ebx
f0103e89:	e8 d9 c2 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103e8e:	81 c3 da b9 07 00    	add    $0x7b9da,%ebx
f0103e94:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103e97:	83 ec 08             	sub    $0x8,%esp
f0103e9a:	ff 36                	push   (%esi)
f0103e9c:	8d 83 7e 6d f8 ff    	lea    -0x79282(%ebx),%eax
f0103ea2:	50                   	push   %eax
f0103ea3:	e8 7d fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103ea8:	83 c4 08             	add    $0x8,%esp
f0103eab:	ff 76 04             	push   0x4(%esi)
f0103eae:	8d 83 8d 6d f8 ff    	lea    -0x79273(%ebx),%eax
f0103eb4:	50                   	push   %eax
f0103eb5:	e8 6b fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103eba:	83 c4 08             	add    $0x8,%esp
f0103ebd:	ff 76 08             	push   0x8(%esi)
f0103ec0:	8d 83 9c 6d f8 ff    	lea    -0x79264(%ebx),%eax
f0103ec6:	50                   	push   %eax
f0103ec7:	e8 59 fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103ecc:	83 c4 08             	add    $0x8,%esp
f0103ecf:	ff 76 0c             	push   0xc(%esi)
f0103ed2:	8d 83 ab 6d f8 ff    	lea    -0x79255(%ebx),%eax
f0103ed8:	50                   	push   %eax
f0103ed9:	e8 47 fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103ede:	83 c4 08             	add    $0x8,%esp
f0103ee1:	ff 76 10             	push   0x10(%esi)
f0103ee4:	8d 83 ba 6d f8 ff    	lea    -0x79246(%ebx),%eax
f0103eea:	50                   	push   %eax
f0103eeb:	e8 35 fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103ef0:	83 c4 08             	add    $0x8,%esp
f0103ef3:	ff 76 14             	push   0x14(%esi)
f0103ef6:	8d 83 c9 6d f8 ff    	lea    -0x79237(%ebx),%eax
f0103efc:	50                   	push   %eax
f0103efd:	e8 23 fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103f02:	83 c4 08             	add    $0x8,%esp
f0103f05:	ff 76 18             	push   0x18(%esi)
f0103f08:	8d 83 d8 6d f8 ff    	lea    -0x79228(%ebx),%eax
f0103f0e:	50                   	push   %eax
f0103f0f:	e8 11 fb ff ff       	call   f0103a25 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103f14:	83 c4 08             	add    $0x8,%esp
f0103f17:	ff 76 1c             	push   0x1c(%esi)
f0103f1a:	8d 83 e7 6d f8 ff    	lea    -0x79219(%ebx),%eax
f0103f20:	50                   	push   %eax
f0103f21:	e8 ff fa ff ff       	call   f0103a25 <cprintf>
}
f0103f26:	83 c4 10             	add    $0x10,%esp
f0103f29:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103f2c:	5b                   	pop    %ebx
f0103f2d:	5e                   	pop    %esi
f0103f2e:	5d                   	pop    %ebp
f0103f2f:	c3                   	ret    

f0103f30 <print_trapframe>:
{
f0103f30:	55                   	push   %ebp
f0103f31:	89 e5                	mov    %esp,%ebp
f0103f33:	57                   	push   %edi
f0103f34:	56                   	push   %esi
f0103f35:	53                   	push   %ebx
f0103f36:	83 ec 14             	sub    $0x14,%esp
f0103f39:	e8 29 c2 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0103f3e:	81 c3 2a b9 07 00    	add    $0x7b92a,%ebx
f0103f44:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("TRAP frame at %p\n", tf);
f0103f47:	56                   	push   %esi
f0103f48:	8d 83 1d 6f f8 ff    	lea    -0x790e3(%ebx),%eax
f0103f4e:	50                   	push   %eax
f0103f4f:	e8 d1 fa ff ff       	call   f0103a25 <cprintf>
	print_regs(&tf->tf_regs);
f0103f54:	89 34 24             	mov    %esi,(%esp)
f0103f57:	e8 28 ff ff ff       	call   f0103e84 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103f5c:	83 c4 08             	add    $0x8,%esp
f0103f5f:	0f b7 46 20          	movzwl 0x20(%esi),%eax
f0103f63:	50                   	push   %eax
f0103f64:	8d 83 38 6e f8 ff    	lea    -0x791c8(%ebx),%eax
f0103f6a:	50                   	push   %eax
f0103f6b:	e8 b5 fa ff ff       	call   f0103a25 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103f70:	83 c4 08             	add    $0x8,%esp
f0103f73:	0f b7 46 24          	movzwl 0x24(%esi),%eax
f0103f77:	50                   	push   %eax
f0103f78:	8d 83 4b 6e f8 ff    	lea    -0x791b5(%ebx),%eax
f0103f7e:	50                   	push   %eax
f0103f7f:	e8 a1 fa ff ff       	call   f0103a25 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f84:	8b 56 28             	mov    0x28(%esi),%edx
	if (trapno < ARRAY_SIZE(excnames))
f0103f87:	83 c4 10             	add    $0x10,%esp
f0103f8a:	83 fa 13             	cmp    $0x13,%edx
f0103f8d:	0f 86 e2 00 00 00    	jbe    f0104075 <print_trapframe+0x145>
		return "System call";
f0103f93:	83 fa 30             	cmp    $0x30,%edx
f0103f96:	8d 83 f6 6d f8 ff    	lea    -0x7920a(%ebx),%eax
f0103f9c:	8d 8b 05 6e f8 ff    	lea    -0x791fb(%ebx),%ecx
f0103fa2:	0f 44 c1             	cmove  %ecx,%eax
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103fa5:	83 ec 04             	sub    $0x4,%esp
f0103fa8:	50                   	push   %eax
f0103fa9:	52                   	push   %edx
f0103faa:	8d 83 5e 6e f8 ff    	lea    -0x791a2(%ebx),%eax
f0103fb0:	50                   	push   %eax
f0103fb1:	e8 6f fa ff ff       	call   f0103a25 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103fb6:	83 c4 10             	add    $0x10,%esp
f0103fb9:	39 b3 18 23 00 00    	cmp    %esi,0x2318(%ebx)
f0103fbf:	0f 84 bc 00 00 00    	je     f0104081 <print_trapframe+0x151>
	cprintf("  err  0x%08x", tf->tf_err);
f0103fc5:	83 ec 08             	sub    $0x8,%esp
f0103fc8:	ff 76 2c             	push   0x2c(%esi)
f0103fcb:	8d 83 7f 6e f8 ff    	lea    -0x79181(%ebx),%eax
f0103fd1:	50                   	push   %eax
f0103fd2:	e8 4e fa ff ff       	call   f0103a25 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103fd7:	83 c4 10             	add    $0x10,%esp
f0103fda:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0103fde:	0f 85 c2 00 00 00    	jne    f01040a6 <print_trapframe+0x176>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103fe4:	8b 46 2c             	mov    0x2c(%esi),%eax
		cprintf(" [%s, %s, %s]\n",
f0103fe7:	a8 01                	test   $0x1,%al
f0103fe9:	8d 8b 11 6e f8 ff    	lea    -0x791ef(%ebx),%ecx
f0103fef:	8d 93 1c 6e f8 ff    	lea    -0x791e4(%ebx),%edx
f0103ff5:	0f 44 ca             	cmove  %edx,%ecx
f0103ff8:	a8 02                	test   $0x2,%al
f0103ffa:	8d 93 28 6e f8 ff    	lea    -0x791d8(%ebx),%edx
f0104000:	8d bb 2e 6e f8 ff    	lea    -0x791d2(%ebx),%edi
f0104006:	0f 44 d7             	cmove  %edi,%edx
f0104009:	a8 04                	test   $0x4,%al
f010400b:	8d 83 33 6e f8 ff    	lea    -0x791cd(%ebx),%eax
f0104011:	8d bb 48 6f f8 ff    	lea    -0x790b8(%ebx),%edi
f0104017:	0f 44 c7             	cmove  %edi,%eax
f010401a:	51                   	push   %ecx
f010401b:	52                   	push   %edx
f010401c:	50                   	push   %eax
f010401d:	8d 83 8d 6e f8 ff    	lea    -0x79173(%ebx),%eax
f0104023:	50                   	push   %eax
f0104024:	e8 fc f9 ff ff       	call   f0103a25 <cprintf>
f0104029:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010402c:	83 ec 08             	sub    $0x8,%esp
f010402f:	ff 76 30             	push   0x30(%esi)
f0104032:	8d 83 9c 6e f8 ff    	lea    -0x79164(%ebx),%eax
f0104038:	50                   	push   %eax
f0104039:	e8 e7 f9 ff ff       	call   f0103a25 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010403e:	83 c4 08             	add    $0x8,%esp
f0104041:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104045:	50                   	push   %eax
f0104046:	8d 83 ab 6e f8 ff    	lea    -0x79155(%ebx),%eax
f010404c:	50                   	push   %eax
f010404d:	e8 d3 f9 ff ff       	call   f0103a25 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104052:	83 c4 08             	add    $0x8,%esp
f0104055:	ff 76 38             	push   0x38(%esi)
f0104058:	8d 83 be 6e f8 ff    	lea    -0x79142(%ebx),%eax
f010405e:	50                   	push   %eax
f010405f:	e8 c1 f9 ff ff       	call   f0103a25 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104064:	83 c4 10             	add    $0x10,%esp
f0104067:	f6 46 34 03          	testb  $0x3,0x34(%esi)
f010406b:	75 50                	jne    f01040bd <print_trapframe+0x18d>
}
f010406d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104070:	5b                   	pop    %ebx
f0104071:	5e                   	pop    %esi
f0104072:	5f                   	pop    %edi
f0104073:	5d                   	pop    %ebp
f0104074:	c3                   	ret    
		return excnames[trapno];
f0104075:	8b 84 93 18 18 00 00 	mov    0x1818(%ebx,%edx,4),%eax
f010407c:	e9 24 ff ff ff       	jmp    f0103fa5 <print_trapframe+0x75>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104081:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0104085:	0f 85 3a ff ff ff    	jne    f0103fc5 <print_trapframe+0x95>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f010408b:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010408e:	83 ec 08             	sub    $0x8,%esp
f0104091:	50                   	push   %eax
f0104092:	8d 83 70 6e f8 ff    	lea    -0x79190(%ebx),%eax
f0104098:	50                   	push   %eax
f0104099:	e8 87 f9 ff ff       	call   f0103a25 <cprintf>
f010409e:	83 c4 10             	add    $0x10,%esp
f01040a1:	e9 1f ff ff ff       	jmp    f0103fc5 <print_trapframe+0x95>
		cprintf("\n");
f01040a6:	83 ec 0c             	sub    $0xc,%esp
f01040a9:	8d 83 60 64 f8 ff    	lea    -0x79ba0(%ebx),%eax
f01040af:	50                   	push   %eax
f01040b0:	e8 70 f9 ff ff       	call   f0103a25 <cprintf>
f01040b5:	83 c4 10             	add    $0x10,%esp
f01040b8:	e9 6f ff ff ff       	jmp    f010402c <print_trapframe+0xfc>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01040bd:	83 ec 08             	sub    $0x8,%esp
f01040c0:	ff 76 3c             	push   0x3c(%esi)
f01040c3:	8d 83 cd 6e f8 ff    	lea    -0x79133(%ebx),%eax
f01040c9:	50                   	push   %eax
f01040ca:	e8 56 f9 ff ff       	call   f0103a25 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01040cf:	83 c4 08             	add    $0x8,%esp
f01040d2:	0f b7 46 40          	movzwl 0x40(%esi),%eax
f01040d6:	50                   	push   %eax
f01040d7:	8d 83 dc 6e f8 ff    	lea    -0x79124(%ebx),%eax
f01040dd:	50                   	push   %eax
f01040de:	e8 42 f9 ff ff       	call   f0103a25 <cprintf>
f01040e3:	83 c4 10             	add    $0x10,%esp
}
f01040e6:	eb 85                	jmp    f010406d <print_trapframe+0x13d>

f01040e8 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01040e8:	55                   	push   %ebp
f01040e9:	89 e5                	mov    %esp,%ebp
f01040eb:	57                   	push   %edi
f01040ec:	56                   	push   %esi
f01040ed:	53                   	push   %ebx
f01040ee:	83 ec 0c             	sub    $0xc,%esp
f01040f1:	e8 71 c0 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f01040f6:	81 c3 72 b7 07 00    	add    $0x7b772,%ebx
f01040fc:	8b 7d 08             	mov    0x8(%ebp),%edi
f01040ff:	0f 20 d0             	mov    %cr2,%eax
    }
	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104102:	ff 77 30             	push   0x30(%edi)
f0104105:	50                   	push   %eax
f0104106:	c7 c6 74 13 18 f0    	mov    $0xf0181374,%esi
f010410c:	8b 06                	mov    (%esi),%eax
f010410e:	ff 70 48             	push   0x48(%eax)
f0104111:	8d 83 94 70 f8 ff    	lea    -0x78f6c(%ebx),%eax
f0104117:	50                   	push   %eax
f0104118:	e8 08 f9 ff ff       	call   f0103a25 <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f010411d:	89 3c 24             	mov    %edi,(%esp)
f0104120:	e8 0b fe ff ff       	call   f0103f30 <print_trapframe>
	env_destroy(curenv);
f0104125:	83 c4 04             	add    $0x4,%esp
f0104128:	ff 36                	push   (%esi)
f010412a:	e8 8c f7 ff ff       	call   f01038bb <env_destroy>
}
f010412f:	83 c4 10             	add    $0x10,%esp
f0104132:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104135:	5b                   	pop    %ebx
f0104136:	5e                   	pop    %esi
f0104137:	5f                   	pop    %edi
f0104138:	5d                   	pop    %ebp
f0104139:	c3                   	ret    

f010413a <trap>:
{
f010413a:	55                   	push   %ebp
f010413b:	89 e5                	mov    %esp,%ebp
f010413d:	57                   	push   %edi
f010413e:	56                   	push   %esi
f010413f:	53                   	push   %ebx
f0104140:	83 ec 0c             	sub    $0xc,%esp
f0104143:	e8 1f c0 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0104148:	81 c3 20 b7 07 00    	add    $0x7b720,%ebx
f010414e:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104151:	fc                   	cld    
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104152:	9c                   	pushf  
f0104153:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104154:	f6 c4 02             	test   $0x2,%ah
f0104157:	74 1f                	je     f0104178 <trap+0x3e>
f0104159:	8d 83 ef 6e f8 ff    	lea    -0x79111(%ebx),%eax
f010415f:	50                   	push   %eax
f0104160:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0104166:	50                   	push   %eax
f0104167:	68 ed 00 00 00       	push   $0xed
f010416c:	8d 83 08 6f f8 ff    	lea    -0x790f8(%ebx),%eax
f0104172:	50                   	push   %eax
f0104173:	e8 39 bf ff ff       	call   f01000b1 <_panic>
	cprintf("Incoming TRAP frame at %p\n", tf);
f0104178:	83 ec 08             	sub    $0x8,%esp
f010417b:	56                   	push   %esi
f010417c:	8d 83 14 6f f8 ff    	lea    -0x790ec(%ebx),%eax
f0104182:	50                   	push   %eax
f0104183:	e8 9d f8 ff ff       	call   f0103a25 <cprintf>
	if ((tf->tf_cs & 3) == 3) {
f0104188:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010418c:	83 e0 03             	and    $0x3,%eax
f010418f:	83 c4 10             	add    $0x10,%esp
f0104192:	66 83 f8 03          	cmp    $0x3,%ax
f0104196:	75 1d                	jne    f01041b5 <trap+0x7b>
		assert(curenv);
f0104198:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010419e:	8b 00                	mov    (%eax),%eax
f01041a0:	85 c0                	test   %eax,%eax
f01041a2:	74 5d                	je     f0104201 <trap+0xc7>
		curenv->env_tf = *tf;
f01041a4:	b9 11 00 00 00       	mov    $0x11,%ecx
f01041a9:	89 c7                	mov    %eax,%edi
f01041ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01041ad:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f01041b3:	8b 30                	mov    (%eax),%esi
	last_tf = tf;
f01041b5:	89 b3 18 23 00 00    	mov    %esi,0x2318(%ebx)
	switch (tf->tf_trapno)
f01041bb:	8b 46 28             	mov    0x28(%esi),%eax
f01041be:	83 f8 0e             	cmp    $0xe,%eax
f01041c1:	74 5d                	je     f0104220 <trap+0xe6>
f01041c3:	83 f8 30             	cmp    $0x30,%eax
f01041c6:	0f 84 9f 00 00 00    	je     f010426b <trap+0x131>
f01041cc:	83 f8 03             	cmp    $0x3,%eax
f01041cf:	0f 84 88 00 00 00    	je     f010425d <trap+0x123>
	print_trapframe(tf);
f01041d5:	83 ec 0c             	sub    $0xc,%esp
f01041d8:	56                   	push   %esi
f01041d9:	e8 52 fd ff ff       	call   f0103f30 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01041de:	83 c4 10             	add    $0x10,%esp
f01041e1:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01041e6:	0f 84 a6 00 00 00    	je     f0104292 <trap+0x158>
		env_destroy(curenv);
f01041ec:	83 ec 0c             	sub    $0xc,%esp
f01041ef:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f01041f5:	ff 30                	push   (%eax)
f01041f7:	e8 bf f6 ff ff       	call   f01038bb <env_destroy>
		return;
f01041fc:	83 c4 10             	add    $0x10,%esp
f01041ff:	eb 2b                	jmp    f010422c <trap+0xf2>
		assert(curenv);
f0104201:	8d 83 2f 6f f8 ff    	lea    -0x790d1(%ebx),%eax
f0104207:	50                   	push   %eax
f0104208:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010420e:	50                   	push   %eax
f010420f:	68 f3 00 00 00       	push   $0xf3
f0104214:	8d 83 08 6f f8 ff    	lea    -0x790f8(%ebx),%eax
f010421a:	50                   	push   %eax
f010421b:	e8 91 be ff ff       	call   f01000b1 <_panic>
		page_fault_handler(tf);
f0104220:	83 ec 0c             	sub    $0xc,%esp
f0104223:	56                   	push   %esi
f0104224:	e8 bf fe ff ff       	call   f01040e8 <page_fault_handler>
		return;
f0104229:	83 c4 10             	add    $0x10,%esp
	assert(curenv && curenv->env_status == ENV_RUNNING);
f010422c:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f0104232:	8b 00                	mov    (%eax),%eax
f0104234:	85 c0                	test   %eax,%eax
f0104236:	74 06                	je     f010423e <trap+0x104>
f0104238:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010423c:	74 6f                	je     f01042ad <trap+0x173>
f010423e:	8d 83 b8 70 f8 ff    	lea    -0x78f48(%ebx),%eax
f0104244:	50                   	push   %eax
f0104245:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f010424b:	50                   	push   %eax
f010424c:	68 05 01 00 00       	push   $0x105
f0104251:	8d 83 08 6f f8 ff    	lea    -0x790f8(%ebx),%eax
f0104257:	50                   	push   %eax
f0104258:	e8 54 be ff ff       	call   f01000b1 <_panic>
		monitor(tf);
f010425d:	83 ec 0c             	sub    $0xc,%esp
f0104260:	56                   	push   %esi
f0104261:	e8 66 c6 ff ff       	call   f01008cc <monitor>
		return;
f0104266:	83 c4 10             	add    $0x10,%esp
f0104269:	eb c1                	jmp    f010422c <trap+0xf2>
		if(tf->tf_regs.reg_eax >= NSYSCALLS) return;
f010426b:	8b 46 1c             	mov    0x1c(%esi),%eax
f010426e:	83 f8 03             	cmp    $0x3,%eax
f0104271:	77 b9                	ja     f010422c <trap+0xf2>
		tf->tf_regs.reg_eax = syscall(
f0104273:	83 ec 08             	sub    $0x8,%esp
f0104276:	ff 76 04             	push   0x4(%esi)
f0104279:	ff 36                	push   (%esi)
f010427b:	ff 76 10             	push   0x10(%esi)
f010427e:	ff 76 18             	push   0x18(%esi)
f0104281:	ff 76 14             	push   0x14(%esi)
f0104284:	50                   	push   %eax
f0104285:	e8 aa 00 00 00       	call   f0104334 <syscall>
f010428a:	89 46 1c             	mov    %eax,0x1c(%esi)
		return;
f010428d:	83 c4 20             	add    $0x20,%esp
f0104290:	eb 9a                	jmp    f010422c <trap+0xf2>
		panic("unhandled trap in kernel");
f0104292:	83 ec 04             	sub    $0x4,%esp
f0104295:	8d 83 36 6f f8 ff    	lea    -0x790ca(%ebx),%eax
f010429b:	50                   	push   %eax
f010429c:	68 dc 00 00 00       	push   $0xdc
f01042a1:	8d 83 08 6f f8 ff    	lea    -0x790f8(%ebx),%eax
f01042a7:	50                   	push   %eax
f01042a8:	e8 04 be ff ff       	call   f01000b1 <_panic>
	env_run(curenv);
f01042ad:	83 ec 0c             	sub    $0xc,%esp
f01042b0:	50                   	push   %eax
f01042b1:	e8 73 f6 ff ff       	call   f0103929 <env_run>

f01042b6 <T_DIVIDE_handle>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(T_DIVIDE_handle, T_DIVIDE);
f01042b6:	6a 00                	push   $0x0
f01042b8:	6a 00                	push   $0x0
f01042ba:	eb 67                	jmp    f0104323 <_alltraps>

f01042bc <T_DEBUG_handle>:
TRAPHANDLER_NOEC(T_DEBUG_handle, T_DEBUG);
f01042bc:	6a 00                	push   $0x0
f01042be:	6a 01                	push   $0x1
f01042c0:	eb 61                	jmp    f0104323 <_alltraps>

f01042c2 <T_NMI_handle>:
TRAPHANDLER_NOEC(T_NMI_handle, T_NMI);
f01042c2:	6a 00                	push   $0x0
f01042c4:	6a 02                	push   $0x2
f01042c6:	eb 5b                	jmp    f0104323 <_alltraps>

f01042c8 <T_BRKPT_handle>:
TRAPHANDLER_NOEC(T_BRKPT_handle, T_BRKPT);
f01042c8:	6a 00                	push   $0x0
f01042ca:	6a 03                	push   $0x3
f01042cc:	eb 55                	jmp    f0104323 <_alltraps>

f01042ce <T_OFLOW_handle>:
TRAPHANDLER_NOEC(T_OFLOW_handle, T_OFLOW);
f01042ce:	6a 00                	push   $0x0
f01042d0:	6a 04                	push   $0x4
f01042d2:	eb 4f                	jmp    f0104323 <_alltraps>

f01042d4 <T_BOUND_handle>:
TRAPHANDLER_NOEC(T_BOUND_handle, T_BOUND);
f01042d4:	6a 00                	push   $0x0
f01042d6:	6a 05                	push   $0x5
f01042d8:	eb 49                	jmp    f0104323 <_alltraps>

f01042da <T_ILLOP_handle>:
TRAPHANDLER_NOEC(T_ILLOP_handle, T_ILLOP);
f01042da:	6a 00                	push   $0x0
f01042dc:	6a 06                	push   $0x6
f01042de:	eb 43                	jmp    f0104323 <_alltraps>

f01042e0 <T_DEVICE_handle>:
TRAPHANDLER_NOEC(T_DEVICE_handle, T_DEVICE);
f01042e0:	6a 00                	push   $0x0
f01042e2:	6a 07                	push   $0x7
f01042e4:	eb 3d                	jmp    f0104323 <_alltraps>

f01042e6 <T_DBLFLT_handle>:
TRAPHANDLER(T_DBLFLT_handle, T_DBLFLT);
f01042e6:	6a 08                	push   $0x8
f01042e8:	eb 39                	jmp    f0104323 <_alltraps>

f01042ea <T_TSS_handle>:
TRAPHANDLER(T_TSS_handle, T_TSS);
f01042ea:	6a 0a                	push   $0xa
f01042ec:	eb 35                	jmp    f0104323 <_alltraps>

f01042ee <T_SEGNP_handle>:
TRAPHANDLER(T_SEGNP_handle, T_SEGNP);
f01042ee:	6a 0b                	push   $0xb
f01042f0:	eb 31                	jmp    f0104323 <_alltraps>

f01042f2 <T_STACK_handle>:
TRAPHANDLER(T_STACK_handle, T_STACK);
f01042f2:	6a 0c                	push   $0xc
f01042f4:	eb 2d                	jmp    f0104323 <_alltraps>

f01042f6 <T_GPFLT_handle>:
TRAPHANDLER(T_GPFLT_handle, T_GPFLT);
f01042f6:	6a 0d                	push   $0xd
f01042f8:	eb 29                	jmp    f0104323 <_alltraps>

f01042fa <T_PGFLT_handle>:
TRAPHANDLER(T_PGFLT_handle, T_PGFLT);
f01042fa:	6a 0e                	push   $0xe
f01042fc:	eb 25                	jmp    f0104323 <_alltraps>

f01042fe <T_FPERR_handle>:
TRAPHANDLER_NOEC(T_FPERR_handle, T_FPERR);
f01042fe:	6a 00                	push   $0x0
f0104300:	6a 10                	push   $0x10
f0104302:	eb 1f                	jmp    f0104323 <_alltraps>

f0104304 <T_ALIGN_handle>:
TRAPHANDLER(T_ALIGN_handle, T_ALIGN);
f0104304:	6a 11                	push   $0x11
f0104306:	eb 1b                	jmp    f0104323 <_alltraps>

f0104308 <T_MCHK_handle>:
TRAPHANDLER_NOEC(T_MCHK_handle, T_MCHK);
f0104308:	6a 00                	push   $0x0
f010430a:	6a 12                	push   $0x12
f010430c:	eb 15                	jmp    f0104323 <_alltraps>

f010430e <T_SIMDERR_handle>:
TRAPHANDLER_NOEC(T_SIMDERR_handle, T_SIMDERR);
f010430e:	6a 00                	push   $0x0
f0104310:	6a 13                	push   $0x13
f0104312:	eb 0f                	jmp    f0104323 <_alltraps>

f0104314 <T_SYSCALL_handle>:
TRAPHANDLER_NOEC(T_SYSCALL_handle, T_SYSCALL);
f0104314:	6a 00                	push   $0x0
f0104316:	6a 30                	push   $0x30
f0104318:	eb 09                	jmp    f0104323 <_alltraps>

f010431a <T_DEFAULT_handle>:
TRAPHANDLER_NOEC(T_DEFAULT_handle, T_DEFAULT);
f010431a:	6a 00                	push   $0x0
f010431c:	68 f4 01 00 00       	push   $0x1f4
f0104321:	eb 00                	jmp    f0104323 <_alltraps>

f0104323 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
# build trapframes
	pushl %ds
f0104323:	1e                   	push   %ds
	pushl %es
f0104324:	06                   	push   %es
	pushal
f0104325:	60                   	pusha  

# set up data segments
	movw $GD_KT, %ax
f0104326:	66 b8 08 00          	mov    $0x8,%ax
	movw %ax, %ds
f010432a:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f010432c:	8e c0                	mov    %eax,%es

# call trap(tf), where tf = %esp
	pushl %esp
f010432e:	54                   	push   %esp
	call trap
f010432f:	e8 06 fe ff ff       	call   f010413a <trap>

f0104334 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104334:	55                   	push   %ebp
f0104335:	89 e5                	mov    %esp,%ebp
f0104337:	53                   	push   %ebx
f0104338:	83 ec 14             	sub    $0x14,%esp
f010433b:	e8 27 be ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0104340:	81 c3 28 b5 07 00    	add    $0x7b528,%ebx
f0104346:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	switch (syscallno)
f0104349:	83 f8 02             	cmp    $0x2,%eax
f010434c:	0f 84 b6 00 00 00    	je     f0104408 <syscall+0xd4>
f0104352:	77 0e                	ja     f0104362 <syscall+0x2e>
f0104354:	85 c0                	test   %eax,%eax
f0104356:	74 7e                	je     f01043d6 <syscall+0xa2>
	return cons_getc();
f0104358:	e8 0c c2 ff ff       	call   f0100569 <cons_getc>
		return sys_env_destroy(sys_getenvid());
	default:
		return -E_INVAL;
	}
	panic("syscall not implemented");
}
f010435d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104360:	c9                   	leave  
f0104361:	c3                   	ret    
	switch (syscallno)
f0104362:	83 f8 03             	cmp    $0x3,%eax
f0104365:	75 68                	jne    f01043cf <syscall+0x9b>
		assert(curenv);
f0104367:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010436d:	8b 00                	mov    (%eax),%eax
f010436f:	85 c0                	test   %eax,%eax
f0104371:	0f 84 c1 00 00 00    	je     f0104438 <syscall+0x104>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104377:	83 ec 04             	sub    $0x4,%esp
f010437a:	6a 01                	push   $0x1
f010437c:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010437f:	52                   	push   %edx
f0104380:	ff 70 48             	push   0x48(%eax)
f0104383:	e8 36 ef ff ff       	call   f01032be <envid2env>
f0104388:	83 c4 10             	add    $0x10,%esp
f010438b:	85 c0                	test   %eax,%eax
f010438d:	78 ce                	js     f010435d <syscall+0x29>
	if (e == curenv)
f010438f:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104392:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f0104398:	8b 00                	mov    (%eax),%eax
f010439a:	39 c2                	cmp    %eax,%edx
f010439c:	0f 84 b2 00 00 00    	je     f0104454 <syscall+0x120>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01043a2:	83 ec 04             	sub    $0x4,%esp
f01043a5:	ff 72 48             	push   0x48(%edx)
f01043a8:	ff 70 48             	push   0x48(%eax)
f01043ab:	8d 83 13 71 f8 ff    	lea    -0x78eed(%ebx),%eax
f01043b1:	50                   	push   %eax
f01043b2:	e8 6e f6 ff ff       	call   f0103a25 <cprintf>
f01043b7:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01043ba:	83 ec 0c             	sub    $0xc,%esp
f01043bd:	ff 75 f4             	push   -0xc(%ebp)
f01043c0:	e8 f6 f4 ff ff       	call   f01038bb <env_destroy>
	return 0;
f01043c5:	83 c4 10             	add    $0x10,%esp
f01043c8:	b8 00 00 00 00       	mov    $0x0,%eax
		return sys_env_destroy(sys_getenvid());
f01043cd:	eb 8e                	jmp    f010435d <syscall+0x29>
	switch (syscallno)
f01043cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01043d4:	eb 87                	jmp    f010435d <syscall+0x29>
	user_mem_assert(curenv, s, len, PTE_U|PTE_P);
f01043d6:	6a 05                	push   $0x5
f01043d8:	ff 75 10             	push   0x10(%ebp)
f01043db:	ff 75 0c             	push   0xc(%ebp)
f01043de:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f01043e4:	ff 30                	push   (%eax)
f01043e6:	e8 d2 ed ff ff       	call   f01031bd <user_mem_assert>
	cprintf("%.*s", len, s);
f01043eb:	83 c4 0c             	add    $0xc,%esp
f01043ee:	ff 75 0c             	push   0xc(%ebp)
f01043f1:	ff 75 10             	push   0x10(%ebp)
f01043f4:	8d 83 e4 70 f8 ff    	lea    -0x78f1c(%ebx),%eax
f01043fa:	50                   	push   %eax
f01043fb:	e8 25 f6 ff ff       	call   f0103a25 <cprintf>
}
f0104400:	83 c4 10             	add    $0x10,%esp
f0104403:	e9 50 ff ff ff       	jmp    f0104358 <syscall+0x24>
		assert(curenv);
f0104408:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010440e:	8b 00                	mov    (%eax),%eax
f0104410:	85 c0                	test   %eax,%eax
f0104412:	74 08                	je     f010441c <syscall+0xe8>
	return curenv->env_id;
f0104414:	8b 40 48             	mov    0x48(%eax),%eax
		return sys_getenvid();
f0104417:	e9 41 ff ff ff       	jmp    f010435d <syscall+0x29>
		assert(curenv);
f010441c:	8d 83 2f 6f f8 ff    	lea    -0x790d1(%ebx),%eax
f0104422:	50                   	push   %eax
f0104423:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0104429:	50                   	push   %eax
f010442a:	6a 4f                	push   $0x4f
f010442c:	8d 83 e9 70 f8 ff    	lea    -0x78f17(%ebx),%eax
f0104432:	50                   	push   %eax
f0104433:	e8 79 bc ff ff       	call   f01000b1 <_panic>
		assert(curenv);
f0104438:	8d 83 2f 6f f8 ff    	lea    -0x790d1(%ebx),%eax
f010443e:	50                   	push   %eax
f010443f:	8d 83 d5 61 f8 ff    	lea    -0x79e2b(%ebx),%eax
f0104445:	50                   	push   %eax
f0104446:	6a 52                	push   $0x52
f0104448:	8d 83 e9 70 f8 ff    	lea    -0x78f17(%ebx),%eax
f010444e:	50                   	push   %eax
f010444f:	e8 5d bc ff ff       	call   f01000b1 <_panic>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104454:	83 ec 08             	sub    $0x8,%esp
f0104457:	ff 70 48             	push   0x48(%eax)
f010445a:	8d 83 f8 70 f8 ff    	lea    -0x78f08(%ebx),%eax
f0104460:	50                   	push   %eax
f0104461:	e8 bf f5 ff ff       	call   f0103a25 <cprintf>
f0104466:	83 c4 10             	add    $0x10,%esp
f0104469:	e9 4c ff ff ff       	jmp    f01043ba <syscall+0x86>

f010446e <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010446e:	55                   	push   %ebp
f010446f:	89 e5                	mov    %esp,%ebp
f0104471:	57                   	push   %edi
f0104472:	56                   	push   %esi
f0104473:	53                   	push   %ebx
f0104474:	83 ec 14             	sub    $0x14,%esp
f0104477:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010447a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010447d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104480:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104483:	8b 1a                	mov    (%edx),%ebx
f0104485:	8b 01                	mov    (%ecx),%eax
f0104487:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010448a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104491:	eb 2f                	jmp    f01044c2 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104493:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0104496:	39 c3                	cmp    %eax,%ebx
f0104498:	7f 4e                	jg     f01044e8 <stab_binsearch+0x7a>
f010449a:	0f b6 0a             	movzbl (%edx),%ecx
f010449d:	83 ea 0c             	sub    $0xc,%edx
f01044a0:	39 f1                	cmp    %esi,%ecx
f01044a2:	75 ef                	jne    f0104493 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01044a4:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01044a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01044aa:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01044ae:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01044b1:	73 3a                	jae    f01044ed <stab_binsearch+0x7f>
			*region_left = m;
f01044b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01044b6:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01044b8:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01044bb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01044c2:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01044c5:	7f 53                	jg     f010451a <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f01044c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01044ca:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f01044cd:	89 d0                	mov    %edx,%eax
f01044cf:	c1 e8 1f             	shr    $0x1f,%eax
f01044d2:	01 d0                	add    %edx,%eax
f01044d4:	89 c7                	mov    %eax,%edi
f01044d6:	d1 ff                	sar    %edi
f01044d8:	83 e0 fe             	and    $0xfffffffe,%eax
f01044db:	01 f8                	add    %edi,%eax
f01044dd:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01044e0:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01044e4:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01044e6:	eb ae                	jmp    f0104496 <stab_binsearch+0x28>
			l = true_m + 1;
f01044e8:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01044eb:	eb d5                	jmp    f01044c2 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f01044ed:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01044f0:	76 14                	jbe    f0104506 <stab_binsearch+0x98>
			*region_right = m - 1;
f01044f2:	83 e8 01             	sub    $0x1,%eax
f01044f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01044f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01044fb:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f01044fd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104504:	eb bc                	jmp    f01044c2 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104509:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f010450b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f010450f:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104511:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104518:	eb a8                	jmp    f01044c2 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f010451a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f010451e:	75 15                	jne    f0104535 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104523:	8b 00                	mov    (%eax),%eax
f0104525:	83 e8 01             	sub    $0x1,%eax
f0104528:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010452b:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f010452d:	83 c4 14             	add    $0x14,%esp
f0104530:	5b                   	pop    %ebx
f0104531:	5e                   	pop    %esi
f0104532:	5f                   	pop    %edi
f0104533:	5d                   	pop    %ebp
f0104534:	c3                   	ret    
		for (l = *region_right;
f0104535:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104538:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010453a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010453d:	8b 0f                	mov    (%edi),%ecx
f010453f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104542:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104545:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104549:	39 c1                	cmp    %eax,%ecx
f010454b:	7d 0f                	jge    f010455c <stab_binsearch+0xee>
f010454d:	0f b6 1a             	movzbl (%edx),%ebx
f0104550:	83 ea 0c             	sub    $0xc,%edx
f0104553:	39 f3                	cmp    %esi,%ebx
f0104555:	74 05                	je     f010455c <stab_binsearch+0xee>
		     l--)
f0104557:	83 e8 01             	sub    $0x1,%eax
f010455a:	eb ed                	jmp    f0104549 <stab_binsearch+0xdb>
		*region_left = l;
f010455c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010455f:	89 07                	mov    %eax,(%edi)
}
f0104561:	eb ca                	jmp    f010452d <stab_binsearch+0xbf>

f0104563 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104563:	55                   	push   %ebp
f0104564:	89 e5                	mov    %esp,%ebp
f0104566:	57                   	push   %edi
f0104567:	56                   	push   %esi
f0104568:	53                   	push   %ebx
f0104569:	83 ec 4c             	sub    $0x4c,%esp
f010456c:	e8 f6 bb ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0104571:	81 c3 f7 b2 07 00    	add    $0x7b2f7,%ebx
f0104577:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010457a:	8d 83 2b 71 f8 ff    	lea    -0x78ed5(%ebx),%eax
f0104580:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f0104582:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0104589:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f010458c:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0104593:	8b 45 08             	mov    0x8(%ebp),%eax
f0104596:	89 46 10             	mov    %eax,0x10(%esi)
	info->eip_fn_narg = 0;
f0104599:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01045a0:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f01045a5:	0f 86 33 01 00 00    	jbe    f01046de <debuginfo_eip+0x17b>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01045ab:	c7 c0 f7 2d 11 f0    	mov    $0xf0112df7,%eax
f01045b1:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01045b4:	c7 c0 1d f1 10 f0    	mov    $0xf010f11d,%eax
f01045ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
		stab_end = __STAB_END__;
f01045bd:	c7 c7 1c f1 10 f0    	mov    $0xf010f11c,%edi
		stabs = __STAB_BEGIN__;
f01045c3:	c7 c0 90 6b 10 f0    	mov    $0xf0106b90,%eax
f01045c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if(user_mem_check(curenv, stabstr, sizeof(stabstr), PTE_U))
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01045cc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f01045cf:	39 4d bc             	cmp    %ecx,-0x44(%ebp)
f01045d2:	0f 83 1c 02 00 00    	jae    f01047f4 <debuginfo_eip+0x291>
f01045d8:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f01045dc:	0f 85 19 02 00 00    	jne    f01047fb <debuginfo_eip+0x298>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01045e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01045e9:	2b 7d c4             	sub    -0x3c(%ebp),%edi
f01045ec:	c1 ff 02             	sar    $0x2,%edi
f01045ef:	69 c7 ab aa aa aa    	imul   $0xaaaaaaab,%edi,%eax
f01045f5:	83 e8 01             	sub    $0x1,%eax
f01045f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01045fb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01045fe:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104601:	83 ec 08             	sub    $0x8,%esp
f0104604:	ff 75 08             	push   0x8(%ebp)
f0104607:	6a 64                	push   $0x64
f0104609:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010460c:	e8 5d fe ff ff       	call   f010446e <stab_binsearch>
	if (lfile == 0)
f0104611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104614:	83 c4 10             	add    $0x10,%esp
f0104617:	85 ff                	test   %edi,%edi
f0104619:	0f 84 e3 01 00 00    	je     f0104802 <debuginfo_eip+0x29f>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f010461f:	89 7d dc             	mov    %edi,-0x24(%ebp)
	rfun = rfile;
f0104622:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104625:	89 55 b8             	mov    %edx,-0x48(%ebp)
f0104628:	89 55 d8             	mov    %edx,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010462b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010462e:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104631:	83 ec 08             	sub    $0x8,%esp
f0104634:	ff 75 08             	push   0x8(%ebp)
f0104637:	6a 24                	push   $0x24
f0104639:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010463c:	e8 2d fe ff ff       	call   f010446e <stab_binsearch>

	if (lfun <= rfun) {
f0104641:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104644:	89 55 b4             	mov    %edx,-0x4c(%ebp)
f0104647:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010464a:	89 45 b0             	mov    %eax,-0x50(%ebp)
f010464d:	83 c4 10             	add    $0x10,%esp
f0104650:	39 c2                	cmp    %eax,%edx
f0104652:	0f 8f 0f 01 00 00    	jg     f0104767 <debuginfo_eip+0x204>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104658:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010465b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010465e:	8d 14 82             	lea    (%edx,%eax,4),%edx
f0104661:	8b 02                	mov    (%edx),%eax
f0104663:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0104666:	2b 4d bc             	sub    -0x44(%ebp),%ecx
f0104669:	39 c8                	cmp    %ecx,%eax
f010466b:	73 06                	jae    f0104673 <debuginfo_eip+0x110>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010466d:	03 45 bc             	add    -0x44(%ebp),%eax
f0104670:	89 46 08             	mov    %eax,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104673:	8b 42 08             	mov    0x8(%edx),%eax
		addr -= info->eip_fn_addr;
f0104676:	29 45 08             	sub    %eax,0x8(%ebp)
f0104679:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f010467c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
f010467f:	89 4d b8             	mov    %ecx,-0x48(%ebp)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104682:	89 46 10             	mov    %eax,0x10(%esi)
		// Search within the function definition for the line number.
		lline = lfun;
f0104685:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		rline = rfun;
f0104688:	8b 45 b8             	mov    -0x48(%ebp),%eax
f010468b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f010468e:	83 ec 08             	sub    $0x8,%esp
f0104691:	6a 3a                	push   $0x3a
f0104693:	ff 76 08             	push   0x8(%esi)
f0104696:	e8 0b 0a 00 00       	call   f01050a6 <strfind>
f010469b:	2b 46 08             	sub    0x8(%esi),%eax
f010469e:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs,&lline,&rline,N_SLINE,addr);
f01046a1:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01046a4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01046a7:	83 c4 08             	add    $0x8,%esp
f01046aa:	ff 75 08             	push   0x8(%ebp)
f01046ad:	6a 44                	push   $0x44
f01046af:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f01046b2:	89 d8                	mov    %ebx,%eax
f01046b4:	e8 b5 fd ff ff       	call   f010446e <stab_binsearch>
	if(rline >= lline)
f01046b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01046bc:	83 c4 10             	add    $0x10,%esp
f01046bf:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01046c2:	0f 8c 41 01 00 00    	jl     f0104809 <debuginfo_eip+0x2a6>
	{
		info->eip_line = stabs[lline].n_desc;
f01046c8:	89 c2                	mov    %eax,%edx
f01046ca:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01046cd:	0f b7 4c 83 06       	movzwl 0x6(%ebx,%eax,4),%ecx
f01046d2:	89 4e 04             	mov    %ecx,0x4(%esi)
f01046d5:	8d 44 83 04          	lea    0x4(%ebx,%eax,4),%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01046d9:	e9 99 00 00 00       	jmp    f0104777 <debuginfo_eip+0x214>
		stabs = usd->stabs;
f01046de:	a1 00 00 20 00       	mov    0x200000,%eax
f01046e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stab_end = usd->stab_end;
f01046e6:	8b 3d 04 00 20 00    	mov    0x200004,%edi
		stabstr = usd->stabstr;
f01046ec:	8b 0d 08 00 20 00    	mov    0x200008,%ecx
f01046f2:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stabstr_end = usd->stabstr_end;
f01046f5:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f01046fb:	89 55 c0             	mov    %edx,-0x40(%ebp)
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U))
f01046fe:	6a 04                	push   $0x4
f0104700:	6a 10                	push   $0x10
f0104702:	68 00 00 20 00       	push   $0x200000
f0104707:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010470d:	ff 30                	push   (%eax)
f010470f:	e8 1e ea ff ff       	call   f0103132 <user_mem_check>
f0104714:	83 c4 10             	add    $0x10,%esp
f0104717:	85 c0                	test   %eax,%eax
f0104719:	0f 85 c7 00 00 00    	jne    f01047e6 <debuginfo_eip+0x283>
		if(user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_U))
f010471f:	6a 04                	push   $0x4
f0104721:	6a 0c                	push   $0xc
f0104723:	ff 75 c4             	push   -0x3c(%ebp)
f0104726:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010472c:	ff 30                	push   (%eax)
f010472e:	e8 ff e9 ff ff       	call   f0103132 <user_mem_check>
f0104733:	83 c4 10             	add    $0x10,%esp
f0104736:	85 c0                	test   %eax,%eax
f0104738:	0f 85 af 00 00 00    	jne    f01047ed <debuginfo_eip+0x28a>
		if(user_mem_check(curenv, stabstr, sizeof(stabstr), PTE_U))
f010473e:	6a 04                	push   $0x4
f0104740:	6a 04                	push   $0x4
f0104742:	ff 75 bc             	push   -0x44(%ebp)
f0104745:	c7 c0 74 13 18 f0    	mov    $0xf0181374,%eax
f010474b:	ff 30                	push   (%eax)
f010474d:	e8 e0 e9 ff ff       	call   f0103132 <user_mem_check>
f0104752:	83 c4 10             	add    $0x10,%esp
f0104755:	85 c0                	test   %eax,%eax
f0104757:	0f 84 6f fe ff ff    	je     f01045cc <debuginfo_eip+0x69>
			return -1;
f010475d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104762:	e9 ae 00 00 00       	jmp    f0104815 <debuginfo_eip+0x2b2>
f0104767:	8b 45 08             	mov    0x8(%ebp),%eax
f010476a:	89 fa                	mov    %edi,%edx
f010476c:	e9 11 ff ff ff       	jmp    f0104682 <debuginfo_eip+0x11f>
f0104771:	83 ea 01             	sub    $0x1,%edx
f0104774:	83 e8 0c             	sub    $0xc,%eax
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104777:	39 d7                	cmp    %edx,%edi
f0104779:	7f 2e                	jg     f01047a9 <debuginfo_eip+0x246>
	       && stabs[lline].n_type != N_SOL
f010477b:	0f b6 08             	movzbl (%eax),%ecx
f010477e:	80 f9 84             	cmp    $0x84,%cl
f0104781:	74 0b                	je     f010478e <debuginfo_eip+0x22b>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104783:	80 f9 64             	cmp    $0x64,%cl
f0104786:	75 e9                	jne    f0104771 <debuginfo_eip+0x20e>
f0104788:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f010478c:	74 e3                	je     f0104771 <debuginfo_eip+0x20e>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010478e:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104791:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104794:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104797:	8b 45 c0             	mov    -0x40(%ebp),%eax
f010479a:	8b 7d bc             	mov    -0x44(%ebp),%edi
f010479d:	29 f8                	sub    %edi,%eax
f010479f:	39 c2                	cmp    %eax,%edx
f01047a1:	73 06                	jae    f01047a9 <debuginfo_eip+0x246>
		info->eip_file = stabstr + stabs[lline].n_strx;
f01047a3:	89 f8                	mov    %edi,%eax
f01047a5:	01 d0                	add    %edx,%eax
f01047a7:	89 06                	mov    %eax,(%esi)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01047a9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f01047ae:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f01047b1:	8b 5d b0             	mov    -0x50(%ebp),%ebx
f01047b4:	39 df                	cmp    %ebx,%edi
f01047b6:	7d 5d                	jge    f0104815 <debuginfo_eip+0x2b2>
		for (lline = lfun + 1;
f01047b8:	83 c7 01             	add    $0x1,%edi
f01047bb:	89 f8                	mov    %edi,%eax
f01047bd:	8d 14 7f             	lea    (%edi,%edi,2),%edx
f01047c0:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f01047c3:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f01047c7:	eb 04                	jmp    f01047cd <debuginfo_eip+0x26a>
			info->eip_fn_narg++;
f01047c9:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01047cd:	39 c3                	cmp    %eax,%ebx
f01047cf:	7e 3f                	jle    f0104810 <debuginfo_eip+0x2ad>
f01047d1:	0f b6 0a             	movzbl (%edx),%ecx
f01047d4:	83 c0 01             	add    $0x1,%eax
f01047d7:	83 c2 0c             	add    $0xc,%edx
f01047da:	80 f9 a0             	cmp    $0xa0,%cl
f01047dd:	74 ea                	je     f01047c9 <debuginfo_eip+0x266>
	return 0;
f01047df:	b8 00 00 00 00       	mov    $0x0,%eax
f01047e4:	eb 2f                	jmp    f0104815 <debuginfo_eip+0x2b2>
			return -1;
f01047e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01047eb:	eb 28                	jmp    f0104815 <debuginfo_eip+0x2b2>
			return -1;
f01047ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01047f2:	eb 21                	jmp    f0104815 <debuginfo_eip+0x2b2>
		return -1;
f01047f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01047f9:	eb 1a                	jmp    f0104815 <debuginfo_eip+0x2b2>
f01047fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104800:	eb 13                	jmp    f0104815 <debuginfo_eip+0x2b2>
		return -1;
f0104802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104807:	eb 0c                	jmp    f0104815 <debuginfo_eip+0x2b2>
		return -1;
f0104809:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010480e:	eb 05                	jmp    f0104815 <debuginfo_eip+0x2b2>
	return 0;
f0104810:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104815:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104818:	5b                   	pop    %ebx
f0104819:	5e                   	pop    %esi
f010481a:	5f                   	pop    %edi
f010481b:	5d                   	pop    %ebp
f010481c:	c3                   	ret    

f010481d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010481d:	55                   	push   %ebp
f010481e:	89 e5                	mov    %esp,%ebp
f0104820:	57                   	push   %edi
f0104821:	56                   	push   %esi
f0104822:	53                   	push   %ebx
f0104823:	83 ec 2c             	sub    $0x2c,%esp
f0104826:	e8 ef e9 ff ff       	call   f010321a <__x86.get_pc_thunk.cx>
f010482b:	81 c1 3d b0 07 00    	add    $0x7b03d,%ecx
f0104831:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104834:	89 c7                	mov    %eax,%edi
f0104836:	89 d6                	mov    %edx,%esi
f0104838:	8b 45 08             	mov    0x8(%ebp),%eax
f010483b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010483e:	89 d1                	mov    %edx,%ecx
f0104840:	89 c2                	mov    %eax,%edx
f0104842:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104845:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0104848:	8b 45 10             	mov    0x10(%ebp),%eax
f010484b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010484e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104851:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0104858:	39 c2                	cmp    %eax,%edx
f010485a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f010485d:	72 41                	jb     f01048a0 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010485f:	83 ec 0c             	sub    $0xc,%esp
f0104862:	ff 75 18             	push   0x18(%ebp)
f0104865:	83 eb 01             	sub    $0x1,%ebx
f0104868:	53                   	push   %ebx
f0104869:	50                   	push   %eax
f010486a:	83 ec 08             	sub    $0x8,%esp
f010486d:	ff 75 e4             	push   -0x1c(%ebp)
f0104870:	ff 75 e0             	push   -0x20(%ebp)
f0104873:	ff 75 d4             	push   -0x2c(%ebp)
f0104876:	ff 75 d0             	push   -0x30(%ebp)
f0104879:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f010487c:	e8 3f 0a 00 00       	call   f01052c0 <__udivdi3>
f0104881:	83 c4 18             	add    $0x18,%esp
f0104884:	52                   	push   %edx
f0104885:	50                   	push   %eax
f0104886:	89 f2                	mov    %esi,%edx
f0104888:	89 f8                	mov    %edi,%eax
f010488a:	e8 8e ff ff ff       	call   f010481d <printnum>
f010488f:	83 c4 20             	add    $0x20,%esp
f0104892:	eb 13                	jmp    f01048a7 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104894:	83 ec 08             	sub    $0x8,%esp
f0104897:	56                   	push   %esi
f0104898:	ff 75 18             	push   0x18(%ebp)
f010489b:	ff d7                	call   *%edi
f010489d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01048a0:	83 eb 01             	sub    $0x1,%ebx
f01048a3:	85 db                	test   %ebx,%ebx
f01048a5:	7f ed                	jg     f0104894 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01048a7:	83 ec 08             	sub    $0x8,%esp
f01048aa:	56                   	push   %esi
f01048ab:	83 ec 04             	sub    $0x4,%esp
f01048ae:	ff 75 e4             	push   -0x1c(%ebp)
f01048b1:	ff 75 e0             	push   -0x20(%ebp)
f01048b4:	ff 75 d4             	push   -0x2c(%ebp)
f01048b7:	ff 75 d0             	push   -0x30(%ebp)
f01048ba:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01048bd:	e8 1e 0b 00 00       	call   f01053e0 <__umoddi3>
f01048c2:	83 c4 14             	add    $0x14,%esp
f01048c5:	0f be 84 03 35 71 f8 	movsbl -0x78ecb(%ebx,%eax,1),%eax
f01048cc:	ff 
f01048cd:	50                   	push   %eax
f01048ce:	ff d7                	call   *%edi
}
f01048d0:	83 c4 10             	add    $0x10,%esp
f01048d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01048d6:	5b                   	pop    %ebx
f01048d7:	5e                   	pop    %esi
f01048d8:	5f                   	pop    %edi
f01048d9:	5d                   	pop    %ebp
f01048da:	c3                   	ret    

f01048db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01048db:	55                   	push   %ebp
f01048dc:	89 e5                	mov    %esp,%ebp
f01048de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01048e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01048e5:	8b 10                	mov    (%eax),%edx
f01048e7:	3b 50 04             	cmp    0x4(%eax),%edx
f01048ea:	73 0a                	jae    f01048f6 <sprintputch+0x1b>
		*b->buf++ = ch;
f01048ec:	8d 4a 01             	lea    0x1(%edx),%ecx
f01048ef:	89 08                	mov    %ecx,(%eax)
f01048f1:	8b 45 08             	mov    0x8(%ebp),%eax
f01048f4:	88 02                	mov    %al,(%edx)
}
f01048f6:	5d                   	pop    %ebp
f01048f7:	c3                   	ret    

f01048f8 <printfmt>:
{
f01048f8:	55                   	push   %ebp
f01048f9:	89 e5                	mov    %esp,%ebp
f01048fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01048fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104901:	50                   	push   %eax
f0104902:	ff 75 10             	push   0x10(%ebp)
f0104905:	ff 75 0c             	push   0xc(%ebp)
f0104908:	ff 75 08             	push   0x8(%ebp)
f010490b:	e8 05 00 00 00       	call   f0104915 <vprintfmt>
}
f0104910:	83 c4 10             	add    $0x10,%esp
f0104913:	c9                   	leave  
f0104914:	c3                   	ret    

f0104915 <vprintfmt>:
{
f0104915:	55                   	push   %ebp
f0104916:	89 e5                	mov    %esp,%ebp
f0104918:	57                   	push   %edi
f0104919:	56                   	push   %esi
f010491a:	53                   	push   %ebx
f010491b:	83 ec 3c             	sub    $0x3c,%esp
f010491e:	e8 d6 bd ff ff       	call   f01006f9 <__x86.get_pc_thunk.ax>
f0104923:	05 45 af 07 00       	add    $0x7af45,%eax
f0104928:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010492b:	8b 75 08             	mov    0x8(%ebp),%esi
f010492e:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104931:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104934:	8d 80 68 18 00 00    	lea    0x1868(%eax),%eax
f010493a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010493d:	eb 0a                	jmp    f0104949 <vprintfmt+0x34>
			putch(ch, putdat);
f010493f:	83 ec 08             	sub    $0x8,%esp
f0104942:	57                   	push   %edi
f0104943:	50                   	push   %eax
f0104944:	ff d6                	call   *%esi
f0104946:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104949:	83 c3 01             	add    $0x1,%ebx
f010494c:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0104950:	83 f8 25             	cmp    $0x25,%eax
f0104953:	74 0c                	je     f0104961 <vprintfmt+0x4c>
			if (ch == '\0')
f0104955:	85 c0                	test   %eax,%eax
f0104957:	75 e6                	jne    f010493f <vprintfmt+0x2a>
}
f0104959:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010495c:	5b                   	pop    %ebx
f010495d:	5e                   	pop    %esi
f010495e:	5f                   	pop    %edi
f010495f:	5d                   	pop    %ebp
f0104960:	c3                   	ret    
		padc = ' ';
f0104961:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f0104965:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f010496c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0104973:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f010497a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010497f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0104982:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104985:	8d 43 01             	lea    0x1(%ebx),%eax
f0104988:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010498b:	0f b6 13             	movzbl (%ebx),%edx
f010498e:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104991:	3c 55                	cmp    $0x55,%al
f0104993:	0f 87 fd 03 00 00    	ja     f0104d96 <.L20>
f0104999:	0f b6 c0             	movzbl %al,%eax
f010499c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010499f:	89 ce                	mov    %ecx,%esi
f01049a1:	03 b4 81 c0 71 f8 ff 	add    -0x78e40(%ecx,%eax,4),%esi
f01049a8:	ff e6                	jmp    *%esi

f01049aa <.L68>:
f01049aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f01049ad:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f01049b1:	eb d2                	jmp    f0104985 <vprintfmt+0x70>

f01049b3 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f01049b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01049b6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f01049ba:	eb c9                	jmp    f0104985 <vprintfmt+0x70>

f01049bc <.L31>:
f01049bc:	0f b6 d2             	movzbl %dl,%edx
f01049bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f01049c2:	b8 00 00 00 00       	mov    $0x0,%eax
f01049c7:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f01049ca:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01049cd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01049d1:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f01049d4:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01049d7:	83 f9 09             	cmp    $0x9,%ecx
f01049da:	77 58                	ja     f0104a34 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f01049dc:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f01049df:	eb e9                	jmp    f01049ca <.L31+0xe>

f01049e1 <.L34>:
			precision = va_arg(ap, int);
f01049e1:	8b 45 14             	mov    0x14(%ebp),%eax
f01049e4:	8b 00                	mov    (%eax),%eax
f01049e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01049e9:	8b 45 14             	mov    0x14(%ebp),%eax
f01049ec:	8d 40 04             	lea    0x4(%eax),%eax
f01049ef:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01049f2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f01049f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01049f9:	79 8a                	jns    f0104985 <vprintfmt+0x70>
				width = precision, precision = -1;
f01049fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01049fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104a01:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0104a08:	e9 78 ff ff ff       	jmp    f0104985 <vprintfmt+0x70>

f0104a0d <.L33>:
f0104a0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104a10:	85 d2                	test   %edx,%edx
f0104a12:	b8 00 00 00 00       	mov    $0x0,%eax
f0104a17:	0f 49 c2             	cmovns %edx,%eax
f0104a1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104a1d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0104a20:	e9 60 ff ff ff       	jmp    f0104985 <vprintfmt+0x70>

f0104a25 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f0104a25:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f0104a28:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0104a2f:	e9 51 ff ff ff       	jmp    f0104985 <vprintfmt+0x70>
f0104a34:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104a37:	89 75 08             	mov    %esi,0x8(%ebp)
f0104a3a:	eb b9                	jmp    f01049f5 <.L34+0x14>

f0104a3c <.L27>:
			lflag++;
f0104a3c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104a40:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0104a43:	e9 3d ff ff ff       	jmp    f0104985 <vprintfmt+0x70>

f0104a48 <.L30>:
			putch(va_arg(ap, int), putdat);
f0104a48:	8b 75 08             	mov    0x8(%ebp),%esi
f0104a4b:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a4e:	8d 58 04             	lea    0x4(%eax),%ebx
f0104a51:	83 ec 08             	sub    $0x8,%esp
f0104a54:	57                   	push   %edi
f0104a55:	ff 30                	push   (%eax)
f0104a57:	ff d6                	call   *%esi
			break;
f0104a59:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104a5c:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f0104a5f:	e9 c8 02 00 00       	jmp    f0104d2c <.L25+0x45>

f0104a64 <.L28>:
			err = va_arg(ap, int);
f0104a64:	8b 75 08             	mov    0x8(%ebp),%esi
f0104a67:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a6a:	8d 58 04             	lea    0x4(%eax),%ebx
f0104a6d:	8b 10                	mov    (%eax),%edx
f0104a6f:	89 d0                	mov    %edx,%eax
f0104a71:	f7 d8                	neg    %eax
f0104a73:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104a76:	83 f8 06             	cmp    $0x6,%eax
f0104a79:	7f 27                	jg     f0104aa2 <.L28+0x3e>
f0104a7b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104a7e:	8b 14 82             	mov    (%edx,%eax,4),%edx
f0104a81:	85 d2                	test   %edx,%edx
f0104a83:	74 1d                	je     f0104aa2 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
f0104a85:	52                   	push   %edx
f0104a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a89:	8d 80 e7 61 f8 ff    	lea    -0x79e19(%eax),%eax
f0104a8f:	50                   	push   %eax
f0104a90:	57                   	push   %edi
f0104a91:	56                   	push   %esi
f0104a92:	e8 61 fe ff ff       	call   f01048f8 <printfmt>
f0104a97:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104a9a:	89 5d 14             	mov    %ebx,0x14(%ebp)
f0104a9d:	e9 8a 02 00 00       	jmp    f0104d2c <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f0104aa2:	50                   	push   %eax
f0104aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aa6:	8d 80 4d 71 f8 ff    	lea    -0x78eb3(%eax),%eax
f0104aac:	50                   	push   %eax
f0104aad:	57                   	push   %edi
f0104aae:	56                   	push   %esi
f0104aaf:	e8 44 fe ff ff       	call   f01048f8 <printfmt>
f0104ab4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104ab7:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104aba:	e9 6d 02 00 00       	jmp    f0104d2c <.L25+0x45>

f0104abf <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
f0104abf:	8b 75 08             	mov    0x8(%ebp),%esi
f0104ac2:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ac5:	83 c0 04             	add    $0x4,%eax
f0104ac8:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0104acb:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ace:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0104ad0:	85 d2                	test   %edx,%edx
f0104ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ad5:	8d 80 46 71 f8 ff    	lea    -0x78eba(%eax),%eax
f0104adb:	0f 45 c2             	cmovne %edx,%eax
f0104ade:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0104ae1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104ae5:	7e 06                	jle    f0104aed <.L24+0x2e>
f0104ae7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0104aeb:	75 0d                	jne    f0104afa <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104aed:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0104af0:	89 c3                	mov    %eax,%ebx
f0104af2:	03 45 d4             	add    -0x2c(%ebp),%eax
f0104af5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104af8:	eb 58                	jmp    f0104b52 <.L24+0x93>
f0104afa:	83 ec 08             	sub    $0x8,%esp
f0104afd:	ff 75 d8             	push   -0x28(%ebp)
f0104b00:	ff 75 c8             	push   -0x38(%ebp)
f0104b03:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104b06:	e8 44 04 00 00       	call   f0104f4f <strnlen>
f0104b0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104b0e:	29 c2                	sub    %eax,%edx
f0104b10:	89 55 bc             	mov    %edx,-0x44(%ebp)
f0104b13:	83 c4 10             	add    $0x10,%esp
f0104b16:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f0104b18:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0104b1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0104b1f:	eb 0f                	jmp    f0104b30 <.L24+0x71>
					putch(padc, putdat);
f0104b21:	83 ec 08             	sub    $0x8,%esp
f0104b24:	57                   	push   %edi
f0104b25:	ff 75 d4             	push   -0x2c(%ebp)
f0104b28:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104b2a:	83 eb 01             	sub    $0x1,%ebx
f0104b2d:	83 c4 10             	add    $0x10,%esp
f0104b30:	85 db                	test   %ebx,%ebx
f0104b32:	7f ed                	jg     f0104b21 <.L24+0x62>
f0104b34:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0104b37:	85 d2                	test   %edx,%edx
f0104b39:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b3e:	0f 49 c2             	cmovns %edx,%eax
f0104b41:	29 c2                	sub    %eax,%edx
f0104b43:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104b46:	eb a5                	jmp    f0104aed <.L24+0x2e>
					putch(ch, putdat);
f0104b48:	83 ec 08             	sub    $0x8,%esp
f0104b4b:	57                   	push   %edi
f0104b4c:	52                   	push   %edx
f0104b4d:	ff d6                	call   *%esi
f0104b4f:	83 c4 10             	add    $0x10,%esp
f0104b52:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104b55:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104b57:	83 c3 01             	add    $0x1,%ebx
f0104b5a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0104b5e:	0f be d0             	movsbl %al,%edx
f0104b61:	85 d2                	test   %edx,%edx
f0104b63:	74 4b                	je     f0104bb0 <.L24+0xf1>
f0104b65:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0104b69:	78 06                	js     f0104b71 <.L24+0xb2>
f0104b6b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0104b6f:	78 1e                	js     f0104b8f <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f0104b71:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0104b75:	74 d1                	je     f0104b48 <.L24+0x89>
f0104b77:	0f be c0             	movsbl %al,%eax
f0104b7a:	83 e8 20             	sub    $0x20,%eax
f0104b7d:	83 f8 5e             	cmp    $0x5e,%eax
f0104b80:	76 c6                	jbe    f0104b48 <.L24+0x89>
					putch('?', putdat);
f0104b82:	83 ec 08             	sub    $0x8,%esp
f0104b85:	57                   	push   %edi
f0104b86:	6a 3f                	push   $0x3f
f0104b88:	ff d6                	call   *%esi
f0104b8a:	83 c4 10             	add    $0x10,%esp
f0104b8d:	eb c3                	jmp    f0104b52 <.L24+0x93>
f0104b8f:	89 cb                	mov    %ecx,%ebx
f0104b91:	eb 0e                	jmp    f0104ba1 <.L24+0xe2>
				putch(' ', putdat);
f0104b93:	83 ec 08             	sub    $0x8,%esp
f0104b96:	57                   	push   %edi
f0104b97:	6a 20                	push   $0x20
f0104b99:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0104b9b:	83 eb 01             	sub    $0x1,%ebx
f0104b9e:	83 c4 10             	add    $0x10,%esp
f0104ba1:	85 db                	test   %ebx,%ebx
f0104ba3:	7f ee                	jg     f0104b93 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f0104ba5:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104ba8:	89 45 14             	mov    %eax,0x14(%ebp)
f0104bab:	e9 7c 01 00 00       	jmp    f0104d2c <.L25+0x45>
f0104bb0:	89 cb                	mov    %ecx,%ebx
f0104bb2:	eb ed                	jmp    f0104ba1 <.L24+0xe2>

f0104bb4 <.L29>:
	if (lflag >= 2)
f0104bb4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104bb7:	8b 75 08             	mov    0x8(%ebp),%esi
f0104bba:	83 f9 01             	cmp    $0x1,%ecx
f0104bbd:	7f 1b                	jg     f0104bda <.L29+0x26>
	else if (lflag)
f0104bbf:	85 c9                	test   %ecx,%ecx
f0104bc1:	74 63                	je     f0104c26 <.L29+0x72>
		return va_arg(*ap, long);
f0104bc3:	8b 45 14             	mov    0x14(%ebp),%eax
f0104bc6:	8b 00                	mov    (%eax),%eax
f0104bc8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104bcb:	99                   	cltd   
f0104bcc:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104bcf:	8b 45 14             	mov    0x14(%ebp),%eax
f0104bd2:	8d 40 04             	lea    0x4(%eax),%eax
f0104bd5:	89 45 14             	mov    %eax,0x14(%ebp)
f0104bd8:	eb 17                	jmp    f0104bf1 <.L29+0x3d>
		return va_arg(*ap, long long);
f0104bda:	8b 45 14             	mov    0x14(%ebp),%eax
f0104bdd:	8b 50 04             	mov    0x4(%eax),%edx
f0104be0:	8b 00                	mov    (%eax),%eax
f0104be2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104be5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104be8:	8b 45 14             	mov    0x14(%ebp),%eax
f0104beb:	8d 40 08             	lea    0x8(%eax),%eax
f0104bee:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0104bf1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104bf4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
f0104bf7:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0104bfc:	85 db                	test   %ebx,%ebx
f0104bfe:	0f 89 0e 01 00 00    	jns    f0104d12 <.L25+0x2b>
				putch('-', putdat);
f0104c04:	83 ec 08             	sub    $0x8,%esp
f0104c07:	57                   	push   %edi
f0104c08:	6a 2d                	push   $0x2d
f0104c0a:	ff d6                	call   *%esi
				num = -(long long) num;
f0104c0c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104c0f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104c12:	f7 d9                	neg    %ecx
f0104c14:	83 d3 00             	adc    $0x0,%ebx
f0104c17:	f7 db                	neg    %ebx
f0104c19:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0104c1c:	ba 0a 00 00 00       	mov    $0xa,%edx
f0104c21:	e9 ec 00 00 00       	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, int);
f0104c26:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c29:	8b 00                	mov    (%eax),%eax
f0104c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104c2e:	99                   	cltd   
f0104c2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104c32:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c35:	8d 40 04             	lea    0x4(%eax),%eax
f0104c38:	89 45 14             	mov    %eax,0x14(%ebp)
f0104c3b:	eb b4                	jmp    f0104bf1 <.L29+0x3d>

f0104c3d <.L23>:
	if (lflag >= 2)
f0104c3d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104c40:	8b 75 08             	mov    0x8(%ebp),%esi
f0104c43:	83 f9 01             	cmp    $0x1,%ecx
f0104c46:	7f 1e                	jg     f0104c66 <.L23+0x29>
	else if (lflag)
f0104c48:	85 c9                	test   %ecx,%ecx
f0104c4a:	74 32                	je     f0104c7e <.L23+0x41>
		return va_arg(*ap, unsigned long);
f0104c4c:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c4f:	8b 08                	mov    (%eax),%ecx
f0104c51:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104c56:	8d 40 04             	lea    0x4(%eax),%eax
f0104c59:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104c5c:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
f0104c61:	e9 ac 00 00 00       	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104c66:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c69:	8b 08                	mov    (%eax),%ecx
f0104c6b:	8b 58 04             	mov    0x4(%eax),%ebx
f0104c6e:	8d 40 08             	lea    0x8(%eax),%eax
f0104c71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104c74:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
f0104c79:	e9 94 00 00 00       	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104c7e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c81:	8b 08                	mov    (%eax),%ecx
f0104c83:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104c88:	8d 40 04             	lea    0x4(%eax),%eax
f0104c8b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104c8e:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
f0104c93:	eb 7d                	jmp    f0104d12 <.L25+0x2b>

f0104c95 <.L26>:
	if (lflag >= 2)
f0104c95:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104c98:	8b 75 08             	mov    0x8(%ebp),%esi
f0104c9b:	83 f9 01             	cmp    $0x1,%ecx
f0104c9e:	7f 1b                	jg     f0104cbb <.L26+0x26>
	else if (lflag)
f0104ca0:	85 c9                	test   %ecx,%ecx
f0104ca2:	74 2c                	je     f0104cd0 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f0104ca4:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ca7:	8b 08                	mov    (%eax),%ecx
f0104ca9:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104cae:	8d 40 04             	lea    0x4(%eax),%eax
f0104cb1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104cb4:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
f0104cb9:	eb 57                	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104cbb:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cbe:	8b 08                	mov    (%eax),%ecx
f0104cc0:	8b 58 04             	mov    0x4(%eax),%ebx
f0104cc3:	8d 40 08             	lea    0x8(%eax),%eax
f0104cc6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104cc9:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
f0104cce:	eb 42                	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104cd0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cd3:	8b 08                	mov    (%eax),%ecx
f0104cd5:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104cda:	8d 40 04             	lea    0x4(%eax),%eax
f0104cdd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104ce0:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
f0104ce5:	eb 2b                	jmp    f0104d12 <.L25+0x2b>

f0104ce7 <.L25>:
			putch('0', putdat);
f0104ce7:	8b 75 08             	mov    0x8(%ebp),%esi
f0104cea:	83 ec 08             	sub    $0x8,%esp
f0104ced:	57                   	push   %edi
f0104cee:	6a 30                	push   $0x30
f0104cf0:	ff d6                	call   *%esi
			putch('x', putdat);
f0104cf2:	83 c4 08             	add    $0x8,%esp
f0104cf5:	57                   	push   %edi
f0104cf6:	6a 78                	push   $0x78
f0104cf8:	ff d6                	call   *%esi
			num = (unsigned long long)
f0104cfa:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cfd:	8b 08                	mov    (%eax),%ecx
f0104cff:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
f0104d04:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0104d07:	8d 40 04             	lea    0x4(%eax),%eax
f0104d0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104d0d:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
f0104d12:	83 ec 0c             	sub    $0xc,%esp
f0104d15:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0104d19:	50                   	push   %eax
f0104d1a:	ff 75 d4             	push   -0x2c(%ebp)
f0104d1d:	52                   	push   %edx
f0104d1e:	53                   	push   %ebx
f0104d1f:	51                   	push   %ecx
f0104d20:	89 fa                	mov    %edi,%edx
f0104d22:	89 f0                	mov    %esi,%eax
f0104d24:	e8 f4 fa ff ff       	call   f010481d <printnum>
			break;
f0104d29:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0104d2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104d2f:	e9 15 fc ff ff       	jmp    f0104949 <vprintfmt+0x34>

f0104d34 <.L21>:
	if (lflag >= 2)
f0104d34:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104d37:	8b 75 08             	mov    0x8(%ebp),%esi
f0104d3a:	83 f9 01             	cmp    $0x1,%ecx
f0104d3d:	7f 1b                	jg     f0104d5a <.L21+0x26>
	else if (lflag)
f0104d3f:	85 c9                	test   %ecx,%ecx
f0104d41:	74 2c                	je     f0104d6f <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f0104d43:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d46:	8b 08                	mov    (%eax),%ecx
f0104d48:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d4d:	8d 40 04             	lea    0x4(%eax),%eax
f0104d50:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104d53:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
f0104d58:	eb b8                	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104d5a:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d5d:	8b 08                	mov    (%eax),%ecx
f0104d5f:	8b 58 04             	mov    0x4(%eax),%ebx
f0104d62:	8d 40 08             	lea    0x8(%eax),%eax
f0104d65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104d68:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
f0104d6d:	eb a3                	jmp    f0104d12 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104d6f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d72:	8b 08                	mov    (%eax),%ecx
f0104d74:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d79:	8d 40 04             	lea    0x4(%eax),%eax
f0104d7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104d7f:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
f0104d84:	eb 8c                	jmp    f0104d12 <.L25+0x2b>

f0104d86 <.L35>:
			putch(ch, putdat);
f0104d86:	8b 75 08             	mov    0x8(%ebp),%esi
f0104d89:	83 ec 08             	sub    $0x8,%esp
f0104d8c:	57                   	push   %edi
f0104d8d:	6a 25                	push   $0x25
f0104d8f:	ff d6                	call   *%esi
			break;
f0104d91:	83 c4 10             	add    $0x10,%esp
f0104d94:	eb 96                	jmp    f0104d2c <.L25+0x45>

f0104d96 <.L20>:
			putch('%', putdat);
f0104d96:	8b 75 08             	mov    0x8(%ebp),%esi
f0104d99:	83 ec 08             	sub    $0x8,%esp
f0104d9c:	57                   	push   %edi
f0104d9d:	6a 25                	push   $0x25
f0104d9f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0104da1:	83 c4 10             	add    $0x10,%esp
f0104da4:	89 d8                	mov    %ebx,%eax
f0104da6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0104daa:	74 05                	je     f0104db1 <.L20+0x1b>
f0104dac:	83 e8 01             	sub    $0x1,%eax
f0104daf:	eb f5                	jmp    f0104da6 <.L20+0x10>
f0104db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104db4:	e9 73 ff ff ff       	jmp    f0104d2c <.L25+0x45>

f0104db9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0104db9:	55                   	push   %ebp
f0104dba:	89 e5                	mov    %esp,%ebp
f0104dbc:	53                   	push   %ebx
f0104dbd:	83 ec 14             	sub    $0x14,%esp
f0104dc0:	e8 a2 b3 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0104dc5:	81 c3 a3 aa 07 00    	add    $0x7aaa3,%ebx
f0104dcb:	8b 45 08             	mov    0x8(%ebp),%eax
f0104dce:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0104dd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104dd4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0104dd8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0104ddb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0104de2:	85 c0                	test   %eax,%eax
f0104de4:	74 2b                	je     f0104e11 <vsnprintf+0x58>
f0104de6:	85 d2                	test   %edx,%edx
f0104de8:	7e 27                	jle    f0104e11 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104dea:	ff 75 14             	push   0x14(%ebp)
f0104ded:	ff 75 10             	push   0x10(%ebp)
f0104df0:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104df3:	50                   	push   %eax
f0104df4:	8d 83 73 50 f8 ff    	lea    -0x7af8d(%ebx),%eax
f0104dfa:	50                   	push   %eax
f0104dfb:	e8 15 fb ff ff       	call   f0104915 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104e03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104e09:	83 c4 10             	add    $0x10,%esp
}
f0104e0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104e0f:	c9                   	leave  
f0104e10:	c3                   	ret    
		return -E_INVAL;
f0104e11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e16:	eb f4                	jmp    f0104e0c <vsnprintf+0x53>

f0104e18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104e18:	55                   	push   %ebp
f0104e19:	89 e5                	mov    %esp,%ebp
f0104e1b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0104e1e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0104e21:	50                   	push   %eax
f0104e22:	ff 75 10             	push   0x10(%ebp)
f0104e25:	ff 75 0c             	push   0xc(%ebp)
f0104e28:	ff 75 08             	push   0x8(%ebp)
f0104e2b:	e8 89 ff ff ff       	call   f0104db9 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104e30:	c9                   	leave  
f0104e31:	c3                   	ret    

f0104e32 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104e32:	55                   	push   %ebp
f0104e33:	89 e5                	mov    %esp,%ebp
f0104e35:	57                   	push   %edi
f0104e36:	56                   	push   %esi
f0104e37:	53                   	push   %ebx
f0104e38:	83 ec 1c             	sub    $0x1c,%esp
f0104e3b:	e8 27 b3 ff ff       	call   f0100167 <__x86.get_pc_thunk.bx>
f0104e40:	81 c3 28 aa 07 00    	add    $0x7aa28,%ebx
f0104e46:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0104e49:	85 c0                	test   %eax,%eax
f0104e4b:	74 13                	je     f0104e60 <readline+0x2e>
		cprintf("%s", prompt);
f0104e4d:	83 ec 08             	sub    $0x8,%esp
f0104e50:	50                   	push   %eax
f0104e51:	8d 83 e7 61 f8 ff    	lea    -0x79e19(%ebx),%eax
f0104e57:	50                   	push   %eax
f0104e58:	e8 c8 eb ff ff       	call   f0103a25 <cprintf>
f0104e5d:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0104e60:	83 ec 0c             	sub    $0xc,%esp
f0104e63:	6a 00                	push   $0x0
f0104e65:	e8 89 b8 ff ff       	call   f01006f3 <iscons>
f0104e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104e6d:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0104e70:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f0104e75:	8d 83 b8 23 00 00    	lea    0x23b8(%ebx),%eax
f0104e7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104e7e:	eb 45                	jmp    f0104ec5 <readline+0x93>
			cprintf("read error: %e\n", c);
f0104e80:	83 ec 08             	sub    $0x8,%esp
f0104e83:	50                   	push   %eax
f0104e84:	8d 83 18 73 f8 ff    	lea    -0x78ce8(%ebx),%eax
f0104e8a:	50                   	push   %eax
f0104e8b:	e8 95 eb ff ff       	call   f0103a25 <cprintf>
			return NULL;
f0104e90:	83 c4 10             	add    $0x10,%esp
f0104e93:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0104e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e9b:	5b                   	pop    %ebx
f0104e9c:	5e                   	pop    %esi
f0104e9d:	5f                   	pop    %edi
f0104e9e:	5d                   	pop    %ebp
f0104e9f:	c3                   	ret    
			if (echoing)
f0104ea0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104ea4:	75 05                	jne    f0104eab <readline+0x79>
			i--;
f0104ea6:	83 ef 01             	sub    $0x1,%edi
f0104ea9:	eb 1a                	jmp    f0104ec5 <readline+0x93>
				cputchar('\b');
f0104eab:	83 ec 0c             	sub    $0xc,%esp
f0104eae:	6a 08                	push   $0x8
f0104eb0:	e8 1d b8 ff ff       	call   f01006d2 <cputchar>
f0104eb5:	83 c4 10             	add    $0x10,%esp
f0104eb8:	eb ec                	jmp    f0104ea6 <readline+0x74>
			buf[i++] = c;
f0104eba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104ebd:	89 f0                	mov    %esi,%eax
f0104ebf:	88 04 39             	mov    %al,(%ecx,%edi,1)
f0104ec2:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0104ec5:	e8 18 b8 ff ff       	call   f01006e2 <getchar>
f0104eca:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0104ecc:	85 c0                	test   %eax,%eax
f0104ece:	78 b0                	js     f0104e80 <readline+0x4e>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104ed0:	83 f8 08             	cmp    $0x8,%eax
f0104ed3:	0f 94 c0             	sete   %al
f0104ed6:	83 fe 7f             	cmp    $0x7f,%esi
f0104ed9:	0f 94 c2             	sete   %dl
f0104edc:	08 d0                	or     %dl,%al
f0104ede:	74 04                	je     f0104ee4 <readline+0xb2>
f0104ee0:	85 ff                	test   %edi,%edi
f0104ee2:	7f bc                	jg     f0104ea0 <readline+0x6e>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0104ee4:	83 fe 1f             	cmp    $0x1f,%esi
f0104ee7:	7e 1c                	jle    f0104f05 <readline+0xd3>
f0104ee9:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0104eef:	7f 14                	jg     f0104f05 <readline+0xd3>
			if (echoing)
f0104ef1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104ef5:	74 c3                	je     f0104eba <readline+0x88>
				cputchar(c);
f0104ef7:	83 ec 0c             	sub    $0xc,%esp
f0104efa:	56                   	push   %esi
f0104efb:	e8 d2 b7 ff ff       	call   f01006d2 <cputchar>
f0104f00:	83 c4 10             	add    $0x10,%esp
f0104f03:	eb b5                	jmp    f0104eba <readline+0x88>
		} else if (c == '\n' || c == '\r') {
f0104f05:	83 fe 0a             	cmp    $0xa,%esi
f0104f08:	74 05                	je     f0104f0f <readline+0xdd>
f0104f0a:	83 fe 0d             	cmp    $0xd,%esi
f0104f0d:	75 b6                	jne    f0104ec5 <readline+0x93>
			if (echoing)
f0104f0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104f13:	75 13                	jne    f0104f28 <readline+0xf6>
			buf[i] = 0;
f0104f15:	c6 84 3b b8 23 00 00 	movb   $0x0,0x23b8(%ebx,%edi,1)
f0104f1c:	00 
			return buf;
f0104f1d:	8d 83 b8 23 00 00    	lea    0x23b8(%ebx),%eax
f0104f23:	e9 70 ff ff ff       	jmp    f0104e98 <readline+0x66>
				cputchar('\n');
f0104f28:	83 ec 0c             	sub    $0xc,%esp
f0104f2b:	6a 0a                	push   $0xa
f0104f2d:	e8 a0 b7 ff ff       	call   f01006d2 <cputchar>
f0104f32:	83 c4 10             	add    $0x10,%esp
f0104f35:	eb de                	jmp    f0104f15 <readline+0xe3>

f0104f37 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104f37:	55                   	push   %ebp
f0104f38:	89 e5                	mov    %esp,%ebp
f0104f3a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104f3d:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f42:	eb 03                	jmp    f0104f47 <strlen+0x10>
		n++;
f0104f44:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0104f47:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0104f4b:	75 f7                	jne    f0104f44 <strlen+0xd>
	return n;
}
f0104f4d:	5d                   	pop    %ebp
f0104f4e:	c3                   	ret    

f0104f4f <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104f4f:	55                   	push   %ebp
f0104f50:	89 e5                	mov    %esp,%ebp
f0104f52:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104f55:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104f58:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f5d:	eb 03                	jmp    f0104f62 <strnlen+0x13>
		n++;
f0104f5f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104f62:	39 d0                	cmp    %edx,%eax
f0104f64:	74 08                	je     f0104f6e <strnlen+0x1f>
f0104f66:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0104f6a:	75 f3                	jne    f0104f5f <strnlen+0x10>
f0104f6c:	89 c2                	mov    %eax,%edx
	return n;
}
f0104f6e:	89 d0                	mov    %edx,%eax
f0104f70:	5d                   	pop    %ebp
f0104f71:	c3                   	ret    

f0104f72 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0104f72:	55                   	push   %ebp
f0104f73:	89 e5                	mov    %esp,%ebp
f0104f75:	53                   	push   %ebx
f0104f76:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104f79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0104f7c:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f81:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0104f85:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0104f88:	83 c0 01             	add    $0x1,%eax
f0104f8b:	84 d2                	test   %dl,%dl
f0104f8d:	75 f2                	jne    f0104f81 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0104f8f:	89 c8                	mov    %ecx,%eax
f0104f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104f94:	c9                   	leave  
f0104f95:	c3                   	ret    

f0104f96 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0104f96:	55                   	push   %ebp
f0104f97:	89 e5                	mov    %esp,%ebp
f0104f99:	53                   	push   %ebx
f0104f9a:	83 ec 10             	sub    $0x10,%esp
f0104f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0104fa0:	53                   	push   %ebx
f0104fa1:	e8 91 ff ff ff       	call   f0104f37 <strlen>
f0104fa6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0104fa9:	ff 75 0c             	push   0xc(%ebp)
f0104fac:	01 d8                	add    %ebx,%eax
f0104fae:	50                   	push   %eax
f0104faf:	e8 be ff ff ff       	call   f0104f72 <strcpy>
	return dst;
}
f0104fb4:	89 d8                	mov    %ebx,%eax
f0104fb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104fb9:	c9                   	leave  
f0104fba:	c3                   	ret    

f0104fbb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0104fbb:	55                   	push   %ebp
f0104fbc:	89 e5                	mov    %esp,%ebp
f0104fbe:	56                   	push   %esi
f0104fbf:	53                   	push   %ebx
f0104fc0:	8b 75 08             	mov    0x8(%ebp),%esi
f0104fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104fc6:	89 f3                	mov    %esi,%ebx
f0104fc8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0104fcb:	89 f0                	mov    %esi,%eax
f0104fcd:	eb 0f                	jmp    f0104fde <strncpy+0x23>
		*dst++ = *src;
f0104fcf:	83 c0 01             	add    $0x1,%eax
f0104fd2:	0f b6 0a             	movzbl (%edx),%ecx
f0104fd5:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104fd8:	80 f9 01             	cmp    $0x1,%cl
f0104fdb:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
f0104fde:	39 d8                	cmp    %ebx,%eax
f0104fe0:	75 ed                	jne    f0104fcf <strncpy+0x14>
	}
	return ret;
}
f0104fe2:	89 f0                	mov    %esi,%eax
f0104fe4:	5b                   	pop    %ebx
f0104fe5:	5e                   	pop    %esi
f0104fe6:	5d                   	pop    %ebp
f0104fe7:	c3                   	ret    

f0104fe8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104fe8:	55                   	push   %ebp
f0104fe9:	89 e5                	mov    %esp,%ebp
f0104feb:	56                   	push   %esi
f0104fec:	53                   	push   %ebx
f0104fed:	8b 75 08             	mov    0x8(%ebp),%esi
f0104ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104ff3:	8b 55 10             	mov    0x10(%ebp),%edx
f0104ff6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0104ff8:	85 d2                	test   %edx,%edx
f0104ffa:	74 21                	je     f010501d <strlcpy+0x35>
f0104ffc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0105000:	89 f2                	mov    %esi,%edx
f0105002:	eb 09                	jmp    f010500d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0105004:	83 c1 01             	add    $0x1,%ecx
f0105007:	83 c2 01             	add    $0x1,%edx
f010500a:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
f010500d:	39 c2                	cmp    %eax,%edx
f010500f:	74 09                	je     f010501a <strlcpy+0x32>
f0105011:	0f b6 19             	movzbl (%ecx),%ebx
f0105014:	84 db                	test   %bl,%bl
f0105016:	75 ec                	jne    f0105004 <strlcpy+0x1c>
f0105018:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f010501a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010501d:	29 f0                	sub    %esi,%eax
}
f010501f:	5b                   	pop    %ebx
f0105020:	5e                   	pop    %esi
f0105021:	5d                   	pop    %ebp
f0105022:	c3                   	ret    

f0105023 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105023:	55                   	push   %ebp
f0105024:	89 e5                	mov    %esp,%ebp
f0105026:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105029:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010502c:	eb 06                	jmp    f0105034 <strcmp+0x11>
		p++, q++;
f010502e:	83 c1 01             	add    $0x1,%ecx
f0105031:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0105034:	0f b6 01             	movzbl (%ecx),%eax
f0105037:	84 c0                	test   %al,%al
f0105039:	74 04                	je     f010503f <strcmp+0x1c>
f010503b:	3a 02                	cmp    (%edx),%al
f010503d:	74 ef                	je     f010502e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010503f:	0f b6 c0             	movzbl %al,%eax
f0105042:	0f b6 12             	movzbl (%edx),%edx
f0105045:	29 d0                	sub    %edx,%eax
}
f0105047:	5d                   	pop    %ebp
f0105048:	c3                   	ret    

f0105049 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105049:	55                   	push   %ebp
f010504a:	89 e5                	mov    %esp,%ebp
f010504c:	53                   	push   %ebx
f010504d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105050:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105053:	89 c3                	mov    %eax,%ebx
f0105055:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105058:	eb 06                	jmp    f0105060 <strncmp+0x17>
		n--, p++, q++;
f010505a:	83 c0 01             	add    $0x1,%eax
f010505d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105060:	39 d8                	cmp    %ebx,%eax
f0105062:	74 18                	je     f010507c <strncmp+0x33>
f0105064:	0f b6 08             	movzbl (%eax),%ecx
f0105067:	84 c9                	test   %cl,%cl
f0105069:	74 04                	je     f010506f <strncmp+0x26>
f010506b:	3a 0a                	cmp    (%edx),%cl
f010506d:	74 eb                	je     f010505a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010506f:	0f b6 00             	movzbl (%eax),%eax
f0105072:	0f b6 12             	movzbl (%edx),%edx
f0105075:	29 d0                	sub    %edx,%eax
}
f0105077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010507a:	c9                   	leave  
f010507b:	c3                   	ret    
		return 0;
f010507c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105081:	eb f4                	jmp    f0105077 <strncmp+0x2e>

f0105083 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105083:	55                   	push   %ebp
f0105084:	89 e5                	mov    %esp,%ebp
f0105086:	8b 45 08             	mov    0x8(%ebp),%eax
f0105089:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010508d:	eb 03                	jmp    f0105092 <strchr+0xf>
f010508f:	83 c0 01             	add    $0x1,%eax
f0105092:	0f b6 10             	movzbl (%eax),%edx
f0105095:	84 d2                	test   %dl,%dl
f0105097:	74 06                	je     f010509f <strchr+0x1c>
		if (*s == c)
f0105099:	38 ca                	cmp    %cl,%dl
f010509b:	75 f2                	jne    f010508f <strchr+0xc>
f010509d:	eb 05                	jmp    f01050a4 <strchr+0x21>
			return (char *) s;
	return 0;
f010509f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01050a4:	5d                   	pop    %ebp
f01050a5:	c3                   	ret    

f01050a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01050a6:	55                   	push   %ebp
f01050a7:	89 e5                	mov    %esp,%ebp
f01050a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01050ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01050b0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01050b3:	38 ca                	cmp    %cl,%dl
f01050b5:	74 09                	je     f01050c0 <strfind+0x1a>
f01050b7:	84 d2                	test   %dl,%dl
f01050b9:	74 05                	je     f01050c0 <strfind+0x1a>
	for (; *s; s++)
f01050bb:	83 c0 01             	add    $0x1,%eax
f01050be:	eb f0                	jmp    f01050b0 <strfind+0xa>
			break;
	return (char *) s;
}
f01050c0:	5d                   	pop    %ebp
f01050c1:	c3                   	ret    

f01050c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01050c2:	55                   	push   %ebp
f01050c3:	89 e5                	mov    %esp,%ebp
f01050c5:	57                   	push   %edi
f01050c6:	56                   	push   %esi
f01050c7:	53                   	push   %ebx
f01050c8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01050cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01050ce:	85 c9                	test   %ecx,%ecx
f01050d0:	74 2f                	je     f0105101 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01050d2:	89 f8                	mov    %edi,%eax
f01050d4:	09 c8                	or     %ecx,%eax
f01050d6:	a8 03                	test   $0x3,%al
f01050d8:	75 21                	jne    f01050fb <memset+0x39>
		c &= 0xFF;
f01050da:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01050de:	89 d0                	mov    %edx,%eax
f01050e0:	c1 e0 08             	shl    $0x8,%eax
f01050e3:	89 d3                	mov    %edx,%ebx
f01050e5:	c1 e3 18             	shl    $0x18,%ebx
f01050e8:	89 d6                	mov    %edx,%esi
f01050ea:	c1 e6 10             	shl    $0x10,%esi
f01050ed:	09 f3                	or     %esi,%ebx
f01050ef:	09 da                	or     %ebx,%edx
f01050f1:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01050f3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01050f6:	fc                   	cld    
f01050f7:	f3 ab                	rep stos %eax,%es:(%edi)
f01050f9:	eb 06                	jmp    f0105101 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01050fb:	8b 45 0c             	mov    0xc(%ebp),%eax
f01050fe:	fc                   	cld    
f01050ff:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105101:	89 f8                	mov    %edi,%eax
f0105103:	5b                   	pop    %ebx
f0105104:	5e                   	pop    %esi
f0105105:	5f                   	pop    %edi
f0105106:	5d                   	pop    %ebp
f0105107:	c3                   	ret    

f0105108 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105108:	55                   	push   %ebp
f0105109:	89 e5                	mov    %esp,%ebp
f010510b:	57                   	push   %edi
f010510c:	56                   	push   %esi
f010510d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105110:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105113:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105116:	39 c6                	cmp    %eax,%esi
f0105118:	73 32                	jae    f010514c <memmove+0x44>
f010511a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010511d:	39 c2                	cmp    %eax,%edx
f010511f:	76 2b                	jbe    f010514c <memmove+0x44>
		s += n;
		d += n;
f0105121:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105124:	89 d6                	mov    %edx,%esi
f0105126:	09 fe                	or     %edi,%esi
f0105128:	09 ce                	or     %ecx,%esi
f010512a:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105130:	75 0e                	jne    f0105140 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105132:	83 ef 04             	sub    $0x4,%edi
f0105135:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105138:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010513b:	fd                   	std    
f010513c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010513e:	eb 09                	jmp    f0105149 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105140:	83 ef 01             	sub    $0x1,%edi
f0105143:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105146:	fd                   	std    
f0105147:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105149:	fc                   	cld    
f010514a:	eb 1a                	jmp    f0105166 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010514c:	89 f2                	mov    %esi,%edx
f010514e:	09 c2                	or     %eax,%edx
f0105150:	09 ca                	or     %ecx,%edx
f0105152:	f6 c2 03             	test   $0x3,%dl
f0105155:	75 0a                	jne    f0105161 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105157:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010515a:	89 c7                	mov    %eax,%edi
f010515c:	fc                   	cld    
f010515d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010515f:	eb 05                	jmp    f0105166 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0105161:	89 c7                	mov    %eax,%edi
f0105163:	fc                   	cld    
f0105164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105166:	5e                   	pop    %esi
f0105167:	5f                   	pop    %edi
f0105168:	5d                   	pop    %ebp
f0105169:	c3                   	ret    

f010516a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010516a:	55                   	push   %ebp
f010516b:	89 e5                	mov    %esp,%ebp
f010516d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105170:	ff 75 10             	push   0x10(%ebp)
f0105173:	ff 75 0c             	push   0xc(%ebp)
f0105176:	ff 75 08             	push   0x8(%ebp)
f0105179:	e8 8a ff ff ff       	call   f0105108 <memmove>
}
f010517e:	c9                   	leave  
f010517f:	c3                   	ret    

f0105180 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105180:	55                   	push   %ebp
f0105181:	89 e5                	mov    %esp,%ebp
f0105183:	56                   	push   %esi
f0105184:	53                   	push   %ebx
f0105185:	8b 45 08             	mov    0x8(%ebp),%eax
f0105188:	8b 55 0c             	mov    0xc(%ebp),%edx
f010518b:	89 c6                	mov    %eax,%esi
f010518d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105190:	eb 06                	jmp    f0105198 <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105192:	83 c0 01             	add    $0x1,%eax
f0105195:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
f0105198:	39 f0                	cmp    %esi,%eax
f010519a:	74 14                	je     f01051b0 <memcmp+0x30>
		if (*s1 != *s2)
f010519c:	0f b6 08             	movzbl (%eax),%ecx
f010519f:	0f b6 1a             	movzbl (%edx),%ebx
f01051a2:	38 d9                	cmp    %bl,%cl
f01051a4:	74 ec                	je     f0105192 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
f01051a6:	0f b6 c1             	movzbl %cl,%eax
f01051a9:	0f b6 db             	movzbl %bl,%ebx
f01051ac:	29 d8                	sub    %ebx,%eax
f01051ae:	eb 05                	jmp    f01051b5 <memcmp+0x35>
	}

	return 0;
f01051b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01051b5:	5b                   	pop    %ebx
f01051b6:	5e                   	pop    %esi
f01051b7:	5d                   	pop    %ebp
f01051b8:	c3                   	ret    

f01051b9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01051b9:	55                   	push   %ebp
f01051ba:	89 e5                	mov    %esp,%ebp
f01051bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01051bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01051c2:	89 c2                	mov    %eax,%edx
f01051c4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01051c7:	eb 03                	jmp    f01051cc <memfind+0x13>
f01051c9:	83 c0 01             	add    $0x1,%eax
f01051cc:	39 d0                	cmp    %edx,%eax
f01051ce:	73 04                	jae    f01051d4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01051d0:	38 08                	cmp    %cl,(%eax)
f01051d2:	75 f5                	jne    f01051c9 <memfind+0x10>
			break;
	return (void *) s;
}
f01051d4:	5d                   	pop    %ebp
f01051d5:	c3                   	ret    

f01051d6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01051d6:	55                   	push   %ebp
f01051d7:	89 e5                	mov    %esp,%ebp
f01051d9:	57                   	push   %edi
f01051da:	56                   	push   %esi
f01051db:	53                   	push   %ebx
f01051dc:	8b 55 08             	mov    0x8(%ebp),%edx
f01051df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01051e2:	eb 03                	jmp    f01051e7 <strtol+0x11>
		s++;
f01051e4:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
f01051e7:	0f b6 02             	movzbl (%edx),%eax
f01051ea:	3c 20                	cmp    $0x20,%al
f01051ec:	74 f6                	je     f01051e4 <strtol+0xe>
f01051ee:	3c 09                	cmp    $0x9,%al
f01051f0:	74 f2                	je     f01051e4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01051f2:	3c 2b                	cmp    $0x2b,%al
f01051f4:	74 2a                	je     f0105220 <strtol+0x4a>
	int neg = 0;
f01051f6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01051fb:	3c 2d                	cmp    $0x2d,%al
f01051fd:	74 2b                	je     f010522a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01051ff:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105205:	75 0f                	jne    f0105216 <strtol+0x40>
f0105207:	80 3a 30             	cmpb   $0x30,(%edx)
f010520a:	74 28                	je     f0105234 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010520c:	85 db                	test   %ebx,%ebx
f010520e:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105213:	0f 44 d8             	cmove  %eax,%ebx
f0105216:	b9 00 00 00 00       	mov    $0x0,%ecx
f010521b:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010521e:	eb 46                	jmp    f0105266 <strtol+0x90>
		s++;
f0105220:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
f0105223:	bf 00 00 00 00       	mov    $0x0,%edi
f0105228:	eb d5                	jmp    f01051ff <strtol+0x29>
		s++, neg = 1;
f010522a:	83 c2 01             	add    $0x1,%edx
f010522d:	bf 01 00 00 00       	mov    $0x1,%edi
f0105232:	eb cb                	jmp    f01051ff <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105234:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0105238:	74 0e                	je     f0105248 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010523a:	85 db                	test   %ebx,%ebx
f010523c:	75 d8                	jne    f0105216 <strtol+0x40>
		s++, base = 8;
f010523e:	83 c2 01             	add    $0x1,%edx
f0105241:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105246:	eb ce                	jmp    f0105216 <strtol+0x40>
		s += 2, base = 16;
f0105248:	83 c2 02             	add    $0x2,%edx
f010524b:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105250:	eb c4                	jmp    f0105216 <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105252:	0f be c0             	movsbl %al,%eax
f0105255:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105258:	3b 45 10             	cmp    0x10(%ebp),%eax
f010525b:	7d 3a                	jge    f0105297 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010525d:	83 c2 01             	add    $0x1,%edx
f0105260:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0105264:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
f0105266:	0f b6 02             	movzbl (%edx),%eax
f0105269:	8d 70 d0             	lea    -0x30(%eax),%esi
f010526c:	89 f3                	mov    %esi,%ebx
f010526e:	80 fb 09             	cmp    $0x9,%bl
f0105271:	76 df                	jbe    f0105252 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
f0105273:	8d 70 9f             	lea    -0x61(%eax),%esi
f0105276:	89 f3                	mov    %esi,%ebx
f0105278:	80 fb 19             	cmp    $0x19,%bl
f010527b:	77 08                	ja     f0105285 <strtol+0xaf>
			dig = *s - 'a' + 10;
f010527d:	0f be c0             	movsbl %al,%eax
f0105280:	83 e8 57             	sub    $0x57,%eax
f0105283:	eb d3                	jmp    f0105258 <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
f0105285:	8d 70 bf             	lea    -0x41(%eax),%esi
f0105288:	89 f3                	mov    %esi,%ebx
f010528a:	80 fb 19             	cmp    $0x19,%bl
f010528d:	77 08                	ja     f0105297 <strtol+0xc1>
			dig = *s - 'A' + 10;
f010528f:	0f be c0             	movsbl %al,%eax
f0105292:	83 e8 37             	sub    $0x37,%eax
f0105295:	eb c1                	jmp    f0105258 <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105297:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010529b:	74 05                	je     f01052a2 <strtol+0xcc>
		*endptr = (char *) s;
f010529d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01052a0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f01052a2:	89 c8                	mov    %ecx,%eax
f01052a4:	f7 d8                	neg    %eax
f01052a6:	85 ff                	test   %edi,%edi
f01052a8:	0f 45 c8             	cmovne %eax,%ecx
}
f01052ab:	89 c8                	mov    %ecx,%eax
f01052ad:	5b                   	pop    %ebx
f01052ae:	5e                   	pop    %esi
f01052af:	5f                   	pop    %edi
f01052b0:	5d                   	pop    %ebp
f01052b1:	c3                   	ret    
f01052b2:	66 90                	xchg   %ax,%ax
f01052b4:	66 90                	xchg   %ax,%ax
f01052b6:	66 90                	xchg   %ax,%ax
f01052b8:	66 90                	xchg   %ax,%ax
f01052ba:	66 90                	xchg   %ax,%ax
f01052bc:	66 90                	xchg   %ax,%ax
f01052be:	66 90                	xchg   %ax,%ax

f01052c0 <__udivdi3>:
f01052c0:	f3 0f 1e fb          	endbr32 
f01052c4:	55                   	push   %ebp
f01052c5:	57                   	push   %edi
f01052c6:	56                   	push   %esi
f01052c7:	53                   	push   %ebx
f01052c8:	83 ec 1c             	sub    $0x1c,%esp
f01052cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01052cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01052d3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01052d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01052db:	85 c0                	test   %eax,%eax
f01052dd:	75 19                	jne    f01052f8 <__udivdi3+0x38>
f01052df:	39 f3                	cmp    %esi,%ebx
f01052e1:	76 4d                	jbe    f0105330 <__udivdi3+0x70>
f01052e3:	31 ff                	xor    %edi,%edi
f01052e5:	89 e8                	mov    %ebp,%eax
f01052e7:	89 f2                	mov    %esi,%edx
f01052e9:	f7 f3                	div    %ebx
f01052eb:	89 fa                	mov    %edi,%edx
f01052ed:	83 c4 1c             	add    $0x1c,%esp
f01052f0:	5b                   	pop    %ebx
f01052f1:	5e                   	pop    %esi
f01052f2:	5f                   	pop    %edi
f01052f3:	5d                   	pop    %ebp
f01052f4:	c3                   	ret    
f01052f5:	8d 76 00             	lea    0x0(%esi),%esi
f01052f8:	39 f0                	cmp    %esi,%eax
f01052fa:	76 14                	jbe    f0105310 <__udivdi3+0x50>
f01052fc:	31 ff                	xor    %edi,%edi
f01052fe:	31 c0                	xor    %eax,%eax
f0105300:	89 fa                	mov    %edi,%edx
f0105302:	83 c4 1c             	add    $0x1c,%esp
f0105305:	5b                   	pop    %ebx
f0105306:	5e                   	pop    %esi
f0105307:	5f                   	pop    %edi
f0105308:	5d                   	pop    %ebp
f0105309:	c3                   	ret    
f010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105310:	0f bd f8             	bsr    %eax,%edi
f0105313:	83 f7 1f             	xor    $0x1f,%edi
f0105316:	75 48                	jne    f0105360 <__udivdi3+0xa0>
f0105318:	39 f0                	cmp    %esi,%eax
f010531a:	72 06                	jb     f0105322 <__udivdi3+0x62>
f010531c:	31 c0                	xor    %eax,%eax
f010531e:	39 eb                	cmp    %ebp,%ebx
f0105320:	77 de                	ja     f0105300 <__udivdi3+0x40>
f0105322:	b8 01 00 00 00       	mov    $0x1,%eax
f0105327:	eb d7                	jmp    f0105300 <__udivdi3+0x40>
f0105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105330:	89 d9                	mov    %ebx,%ecx
f0105332:	85 db                	test   %ebx,%ebx
f0105334:	75 0b                	jne    f0105341 <__udivdi3+0x81>
f0105336:	b8 01 00 00 00       	mov    $0x1,%eax
f010533b:	31 d2                	xor    %edx,%edx
f010533d:	f7 f3                	div    %ebx
f010533f:	89 c1                	mov    %eax,%ecx
f0105341:	31 d2                	xor    %edx,%edx
f0105343:	89 f0                	mov    %esi,%eax
f0105345:	f7 f1                	div    %ecx
f0105347:	89 c6                	mov    %eax,%esi
f0105349:	89 e8                	mov    %ebp,%eax
f010534b:	89 f7                	mov    %esi,%edi
f010534d:	f7 f1                	div    %ecx
f010534f:	89 fa                	mov    %edi,%edx
f0105351:	83 c4 1c             	add    $0x1c,%esp
f0105354:	5b                   	pop    %ebx
f0105355:	5e                   	pop    %esi
f0105356:	5f                   	pop    %edi
f0105357:	5d                   	pop    %ebp
f0105358:	c3                   	ret    
f0105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105360:	89 f9                	mov    %edi,%ecx
f0105362:	ba 20 00 00 00       	mov    $0x20,%edx
f0105367:	29 fa                	sub    %edi,%edx
f0105369:	d3 e0                	shl    %cl,%eax
f010536b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010536f:	89 d1                	mov    %edx,%ecx
f0105371:	89 d8                	mov    %ebx,%eax
f0105373:	d3 e8                	shr    %cl,%eax
f0105375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105379:	09 c1                	or     %eax,%ecx
f010537b:	89 f0                	mov    %esi,%eax
f010537d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105381:	89 f9                	mov    %edi,%ecx
f0105383:	d3 e3                	shl    %cl,%ebx
f0105385:	89 d1                	mov    %edx,%ecx
f0105387:	d3 e8                	shr    %cl,%eax
f0105389:	89 f9                	mov    %edi,%ecx
f010538b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010538f:	89 eb                	mov    %ebp,%ebx
f0105391:	d3 e6                	shl    %cl,%esi
f0105393:	89 d1                	mov    %edx,%ecx
f0105395:	d3 eb                	shr    %cl,%ebx
f0105397:	09 f3                	or     %esi,%ebx
f0105399:	89 c6                	mov    %eax,%esi
f010539b:	89 f2                	mov    %esi,%edx
f010539d:	89 d8                	mov    %ebx,%eax
f010539f:	f7 74 24 08          	divl   0x8(%esp)
f01053a3:	89 d6                	mov    %edx,%esi
f01053a5:	89 c3                	mov    %eax,%ebx
f01053a7:	f7 64 24 0c          	mull   0xc(%esp)
f01053ab:	39 d6                	cmp    %edx,%esi
f01053ad:	72 19                	jb     f01053c8 <__udivdi3+0x108>
f01053af:	89 f9                	mov    %edi,%ecx
f01053b1:	d3 e5                	shl    %cl,%ebp
f01053b3:	39 c5                	cmp    %eax,%ebp
f01053b5:	73 04                	jae    f01053bb <__udivdi3+0xfb>
f01053b7:	39 d6                	cmp    %edx,%esi
f01053b9:	74 0d                	je     f01053c8 <__udivdi3+0x108>
f01053bb:	89 d8                	mov    %ebx,%eax
f01053bd:	31 ff                	xor    %edi,%edi
f01053bf:	e9 3c ff ff ff       	jmp    f0105300 <__udivdi3+0x40>
f01053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01053c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01053cb:	31 ff                	xor    %edi,%edi
f01053cd:	e9 2e ff ff ff       	jmp    f0105300 <__udivdi3+0x40>
f01053d2:	66 90                	xchg   %ax,%ax
f01053d4:	66 90                	xchg   %ax,%ax
f01053d6:	66 90                	xchg   %ax,%ax
f01053d8:	66 90                	xchg   %ax,%ax
f01053da:	66 90                	xchg   %ax,%ax
f01053dc:	66 90                	xchg   %ax,%ax
f01053de:	66 90                	xchg   %ax,%ax

f01053e0 <__umoddi3>:
f01053e0:	f3 0f 1e fb          	endbr32 
f01053e4:	55                   	push   %ebp
f01053e5:	57                   	push   %edi
f01053e6:	56                   	push   %esi
f01053e7:	53                   	push   %ebx
f01053e8:	83 ec 1c             	sub    $0x1c,%esp
f01053eb:	8b 74 24 30          	mov    0x30(%esp),%esi
f01053ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01053f3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
f01053f7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
f01053fb:	89 f0                	mov    %esi,%eax
f01053fd:	89 da                	mov    %ebx,%edx
f01053ff:	85 ff                	test   %edi,%edi
f0105401:	75 15                	jne    f0105418 <__umoddi3+0x38>
f0105403:	39 dd                	cmp    %ebx,%ebp
f0105405:	76 39                	jbe    f0105440 <__umoddi3+0x60>
f0105407:	f7 f5                	div    %ebp
f0105409:	89 d0                	mov    %edx,%eax
f010540b:	31 d2                	xor    %edx,%edx
f010540d:	83 c4 1c             	add    $0x1c,%esp
f0105410:	5b                   	pop    %ebx
f0105411:	5e                   	pop    %esi
f0105412:	5f                   	pop    %edi
f0105413:	5d                   	pop    %ebp
f0105414:	c3                   	ret    
f0105415:	8d 76 00             	lea    0x0(%esi),%esi
f0105418:	39 df                	cmp    %ebx,%edi
f010541a:	77 f1                	ja     f010540d <__umoddi3+0x2d>
f010541c:	0f bd cf             	bsr    %edi,%ecx
f010541f:	83 f1 1f             	xor    $0x1f,%ecx
f0105422:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105426:	75 40                	jne    f0105468 <__umoddi3+0x88>
f0105428:	39 df                	cmp    %ebx,%edi
f010542a:	72 04                	jb     f0105430 <__umoddi3+0x50>
f010542c:	39 f5                	cmp    %esi,%ebp
f010542e:	77 dd                	ja     f010540d <__umoddi3+0x2d>
f0105430:	89 da                	mov    %ebx,%edx
f0105432:	89 f0                	mov    %esi,%eax
f0105434:	29 e8                	sub    %ebp,%eax
f0105436:	19 fa                	sbb    %edi,%edx
f0105438:	eb d3                	jmp    f010540d <__umoddi3+0x2d>
f010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105440:	89 e9                	mov    %ebp,%ecx
f0105442:	85 ed                	test   %ebp,%ebp
f0105444:	75 0b                	jne    f0105451 <__umoddi3+0x71>
f0105446:	b8 01 00 00 00       	mov    $0x1,%eax
f010544b:	31 d2                	xor    %edx,%edx
f010544d:	f7 f5                	div    %ebp
f010544f:	89 c1                	mov    %eax,%ecx
f0105451:	89 d8                	mov    %ebx,%eax
f0105453:	31 d2                	xor    %edx,%edx
f0105455:	f7 f1                	div    %ecx
f0105457:	89 f0                	mov    %esi,%eax
f0105459:	f7 f1                	div    %ecx
f010545b:	89 d0                	mov    %edx,%eax
f010545d:	31 d2                	xor    %edx,%edx
f010545f:	eb ac                	jmp    f010540d <__umoddi3+0x2d>
f0105461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105468:	8b 44 24 04          	mov    0x4(%esp),%eax
f010546c:	ba 20 00 00 00       	mov    $0x20,%edx
f0105471:	29 c2                	sub    %eax,%edx
f0105473:	89 c1                	mov    %eax,%ecx
f0105475:	89 e8                	mov    %ebp,%eax
f0105477:	d3 e7                	shl    %cl,%edi
f0105479:	89 d1                	mov    %edx,%ecx
f010547b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010547f:	d3 e8                	shr    %cl,%eax
f0105481:	89 c1                	mov    %eax,%ecx
f0105483:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105487:	09 f9                	or     %edi,%ecx
f0105489:	89 df                	mov    %ebx,%edi
f010548b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010548f:	89 c1                	mov    %eax,%ecx
f0105491:	d3 e5                	shl    %cl,%ebp
f0105493:	89 d1                	mov    %edx,%ecx
f0105495:	d3 ef                	shr    %cl,%edi
f0105497:	89 c1                	mov    %eax,%ecx
f0105499:	89 f0                	mov    %esi,%eax
f010549b:	d3 e3                	shl    %cl,%ebx
f010549d:	89 d1                	mov    %edx,%ecx
f010549f:	89 fa                	mov    %edi,%edx
f01054a1:	d3 e8                	shr    %cl,%eax
f01054a3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01054a8:	09 d8                	or     %ebx,%eax
f01054aa:	f7 74 24 08          	divl   0x8(%esp)
f01054ae:	89 d3                	mov    %edx,%ebx
f01054b0:	d3 e6                	shl    %cl,%esi
f01054b2:	f7 e5                	mul    %ebp
f01054b4:	89 c7                	mov    %eax,%edi
f01054b6:	89 d1                	mov    %edx,%ecx
f01054b8:	39 d3                	cmp    %edx,%ebx
f01054ba:	72 06                	jb     f01054c2 <__umoddi3+0xe2>
f01054bc:	75 0e                	jne    f01054cc <__umoddi3+0xec>
f01054be:	39 c6                	cmp    %eax,%esi
f01054c0:	73 0a                	jae    f01054cc <__umoddi3+0xec>
f01054c2:	29 e8                	sub    %ebp,%eax
f01054c4:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01054c8:	89 d1                	mov    %edx,%ecx
f01054ca:	89 c7                	mov    %eax,%edi
f01054cc:	89 f5                	mov    %esi,%ebp
f01054ce:	8b 74 24 04          	mov    0x4(%esp),%esi
f01054d2:	29 fd                	sub    %edi,%ebp
f01054d4:	19 cb                	sbb    %ecx,%ebx
f01054d6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f01054db:	89 d8                	mov    %ebx,%eax
f01054dd:	d3 e0                	shl    %cl,%eax
f01054df:	89 f1                	mov    %esi,%ecx
f01054e1:	d3 ed                	shr    %cl,%ebp
f01054e3:	d3 eb                	shr    %cl,%ebx
f01054e5:	09 e8                	or     %ebp,%eax
f01054e7:	89 da                	mov    %ebx,%edx
f01054e9:	83 c4 1c             	add    $0x1c,%esp
f01054ec:	5b                   	pop    %ebx
f01054ed:	5e                   	pop    %esi
f01054ee:	5f                   	pop    %edi
f01054ef:	5d                   	pop    %ebp
f01054f0:	c3                   	ret    
