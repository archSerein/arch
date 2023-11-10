
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
f0100015:	b8 00 80 11 00       	mov    $0x118000,%eax
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
f0100034:	bc 00 60 11 f0       	mov    $0xf0116000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/kclock.h>


void
i386_init(void)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 08             	sub    $0x8,%esp
f0100047:	e8 03 01 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f010004c:	81 c3 c0 72 01 00    	add    $0x172c0,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100052:	c7 c2 60 90 11 f0    	mov    $0xf0119060,%edx
f0100058:	c7 c0 e0 96 11 f0    	mov    $0xf01196e0,%eax
f010005e:	29 d0                	sub    %edx,%eax
f0100060:	50                   	push   %eax
f0100061:	6a 00                	push   $0x0
f0100063:	52                   	push   %edx
f0100064:	e8 1e 3c 00 00       	call   f0103c87 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100069:	e8 37 05 00 00       	call   f01005a5 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010006e:	83 c4 08             	add    $0x8,%esp
f0100071:	68 ac 1a 00 00       	push   $0x1aac
f0100076:	8d 83 b4 cd fe ff    	lea    -0x1324c(%ebx),%eax
f010007c:	50                   	push   %eax
f010007d:	e8 04 30 00 00       	call   f0103086 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100082:	e8 a2 12 00 00       	call   f0101329 <mem_init>
f0100087:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010008a:	83 ec 0c             	sub    $0xc,%esp
f010008d:	6a 00                	push   $0x0
f010008f:	e8 09 08 00 00       	call   f010089d <monitor>
f0100094:	83 c4 10             	add    $0x10,%esp
f0100097:	eb f1                	jmp    f010008a <i386_init+0x4a>

f0100099 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100099:	55                   	push   %ebp
f010009a:	89 e5                	mov    %esp,%ebp
f010009c:	56                   	push   %esi
f010009d:	53                   	push   %ebx
f010009e:	e8 ac 00 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f01000a3:	81 c3 69 72 01 00    	add    $0x17269,%ebx
	va_list ap;

	if (panicstr)
f01000a9:	83 bb 54 1d 00 00 00 	cmpl   $0x0,0x1d54(%ebx)
f01000b0:	74 0f                	je     f01000c1 <_panic+0x28>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000b2:	83 ec 0c             	sub    $0xc,%esp
f01000b5:	6a 00                	push   $0x0
f01000b7:	e8 e1 07 00 00       	call   f010089d <monitor>
f01000bc:	83 c4 10             	add    $0x10,%esp
f01000bf:	eb f1                	jmp    f01000b2 <_panic+0x19>
	panicstr = fmt;
f01000c1:	8b 45 10             	mov    0x10(%ebp),%eax
f01000c4:	89 83 54 1d 00 00    	mov    %eax,0x1d54(%ebx)
	asm volatile("cli; cld");
f01000ca:	fa                   	cli    
f01000cb:	fc                   	cld    
	va_start(ap, fmt);
f01000cc:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000cf:	83 ec 04             	sub    $0x4,%esp
f01000d2:	ff 75 0c             	push   0xc(%ebp)
f01000d5:	ff 75 08             	push   0x8(%ebp)
f01000d8:	8d 83 cf cd fe ff    	lea    -0x13231(%ebx),%eax
f01000de:	50                   	push   %eax
f01000df:	e8 a2 2f 00 00       	call   f0103086 <cprintf>
	vcprintf(fmt, ap);
f01000e4:	83 c4 08             	add    $0x8,%esp
f01000e7:	56                   	push   %esi
f01000e8:	ff 75 10             	push   0x10(%ebp)
f01000eb:	e8 5f 2f 00 00       	call   f010304f <vcprintf>
	cprintf("\n");
f01000f0:	8d 83 50 d5 fe ff    	lea    -0x12ab0(%ebx),%eax
f01000f6:	89 04 24             	mov    %eax,(%esp)
f01000f9:	e8 88 2f 00 00       	call   f0103086 <cprintf>
f01000fe:	83 c4 10             	add    $0x10,%esp
f0100101:	eb af                	jmp    f01000b2 <_panic+0x19>

f0100103 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100103:	55                   	push   %ebp
f0100104:	89 e5                	mov    %esp,%ebp
f0100106:	56                   	push   %esi
f0100107:	53                   	push   %ebx
f0100108:	e8 42 00 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f010010d:	81 c3 ff 71 01 00    	add    $0x171ff,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100113:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f0100116:	83 ec 04             	sub    $0x4,%esp
f0100119:	ff 75 0c             	push   0xc(%ebp)
f010011c:	ff 75 08             	push   0x8(%ebp)
f010011f:	8d 83 e7 cd fe ff    	lea    -0x13219(%ebx),%eax
f0100125:	50                   	push   %eax
f0100126:	e8 5b 2f 00 00       	call   f0103086 <cprintf>
	vcprintf(fmt, ap);
f010012b:	83 c4 08             	add    $0x8,%esp
f010012e:	56                   	push   %esi
f010012f:	ff 75 10             	push   0x10(%ebp)
f0100132:	e8 18 2f 00 00       	call   f010304f <vcprintf>
	cprintf("\n");
f0100137:	8d 83 50 d5 fe ff    	lea    -0x12ab0(%ebx),%eax
f010013d:	89 04 24             	mov    %eax,(%esp)
f0100140:	e8 41 2f 00 00       	call   f0103086 <cprintf>
	va_end(ap);
}
f0100145:	83 c4 10             	add    $0x10,%esp
f0100148:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010014b:	5b                   	pop    %ebx
f010014c:	5e                   	pop    %esi
f010014d:	5d                   	pop    %ebp
f010014e:	c3                   	ret    

f010014f <__x86.get_pc_thunk.bx>:
f010014f:	8b 1c 24             	mov    (%esp),%ebx
f0100152:	c3                   	ret    

f0100153 <serial_proc_data>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100153:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100158:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100159:	a8 01                	test   $0x1,%al
f010015b:	74 0a                	je     f0100167 <serial_proc_data+0x14>
f010015d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100162:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100163:	0f b6 c0             	movzbl %al,%eax
f0100166:	c3                   	ret    
		return -1;
f0100167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010016c:	c3                   	ret    

f010016d <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010016d:	55                   	push   %ebp
f010016e:	89 e5                	mov    %esp,%ebp
f0100170:	57                   	push   %edi
f0100171:	56                   	push   %esi
f0100172:	53                   	push   %ebx
f0100173:	83 ec 1c             	sub    $0x1c,%esp
f0100176:	e8 6a 05 00 00       	call   f01006e5 <__x86.get_pc_thunk.si>
f010017b:	81 c6 91 71 01 00    	add    $0x17191,%esi
f0100181:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f0100183:	8d 1d 94 1d 00 00    	lea    0x1d94,%ebx
f0100189:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010018c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010018f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	while ((c = (*proc)()) != -1) {
f0100192:	eb 25                	jmp    f01001b9 <cons_intr+0x4c>
		cons.buf[cons.wpos++] = c;
f0100194:	8b 8c 1e 04 02 00 00 	mov    0x204(%esi,%ebx,1),%ecx
f010019b:	8d 51 01             	lea    0x1(%ecx),%edx
f010019e:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01001a1:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f01001a4:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01001aa:	b8 00 00 00 00       	mov    $0x0,%eax
f01001af:	0f 44 d0             	cmove  %eax,%edx
f01001b2:	89 94 1e 04 02 00 00 	mov    %edx,0x204(%esi,%ebx,1)
	while ((c = (*proc)()) != -1) {
f01001b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01001bc:	ff d0                	call   *%eax
f01001be:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001c1:	74 06                	je     f01001c9 <cons_intr+0x5c>
		if (c == 0)
f01001c3:	85 c0                	test   %eax,%eax
f01001c5:	75 cd                	jne    f0100194 <cons_intr+0x27>
f01001c7:	eb f0                	jmp    f01001b9 <cons_intr+0x4c>
	}
}
f01001c9:	83 c4 1c             	add    $0x1c,%esp
f01001cc:	5b                   	pop    %ebx
f01001cd:	5e                   	pop    %esi
f01001ce:	5f                   	pop    %edi
f01001cf:	5d                   	pop    %ebp
f01001d0:	c3                   	ret    

f01001d1 <kbd_proc_data>:
{
f01001d1:	55                   	push   %ebp
f01001d2:	89 e5                	mov    %esp,%ebp
f01001d4:	56                   	push   %esi
f01001d5:	53                   	push   %ebx
f01001d6:	e8 74 ff ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01001db:	81 c3 31 71 01 00    	add    $0x17131,%ebx
f01001e1:	ba 64 00 00 00       	mov    $0x64,%edx
f01001e6:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01001e7:	a8 01                	test   $0x1,%al
f01001e9:	0f 84 f7 00 00 00    	je     f01002e6 <kbd_proc_data+0x115>
	if (stat & KBS_TERR)
f01001ef:	a8 20                	test   $0x20,%al
f01001f1:	0f 85 f6 00 00 00    	jne    f01002ed <kbd_proc_data+0x11c>
f01001f7:	ba 60 00 00 00       	mov    $0x60,%edx
f01001fc:	ec                   	in     (%dx),%al
f01001fd:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01001ff:	3c e0                	cmp    $0xe0,%al
f0100201:	74 64                	je     f0100267 <kbd_proc_data+0x96>
	} else if (data & 0x80) {
f0100203:	84 c0                	test   %al,%al
f0100205:	78 75                	js     f010027c <kbd_proc_data+0xab>
	} else if (shift & E0ESC) {
f0100207:	8b 8b 74 1d 00 00    	mov    0x1d74(%ebx),%ecx
f010020d:	f6 c1 40             	test   $0x40,%cl
f0100210:	74 0e                	je     f0100220 <kbd_proc_data+0x4f>
		data |= 0x80;
f0100212:	83 c8 80             	or     $0xffffff80,%eax
f0100215:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100217:	83 e1 bf             	and    $0xffffffbf,%ecx
f010021a:	89 8b 74 1d 00 00    	mov    %ecx,0x1d74(%ebx)
	shift |= shiftcode[data];
f0100220:	0f b6 d2             	movzbl %dl,%edx
f0100223:	0f b6 84 13 34 cf fe 	movzbl -0x130cc(%ebx,%edx,1),%eax
f010022a:	ff 
f010022b:	0b 83 74 1d 00 00    	or     0x1d74(%ebx),%eax
	shift ^= togglecode[data];
f0100231:	0f b6 8c 13 34 ce fe 	movzbl -0x131cc(%ebx,%edx,1),%ecx
f0100238:	ff 
f0100239:	31 c8                	xor    %ecx,%eax
f010023b:	89 83 74 1d 00 00    	mov    %eax,0x1d74(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100241:	89 c1                	mov    %eax,%ecx
f0100243:	83 e1 03             	and    $0x3,%ecx
f0100246:	8b 8c 8b f4 1c 00 00 	mov    0x1cf4(%ebx,%ecx,4),%ecx
f010024d:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100251:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f0100254:	a8 08                	test   $0x8,%al
f0100256:	74 61                	je     f01002b9 <kbd_proc_data+0xe8>
		if ('a' <= c && c <= 'z')
f0100258:	89 f2                	mov    %esi,%edx
f010025a:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f010025d:	83 f9 19             	cmp    $0x19,%ecx
f0100260:	77 4b                	ja     f01002ad <kbd_proc_data+0xdc>
			c += 'A' - 'a';
f0100262:	83 ee 20             	sub    $0x20,%esi
f0100265:	eb 0c                	jmp    f0100273 <kbd_proc_data+0xa2>
		shift |= E0ESC;
f0100267:	83 8b 74 1d 00 00 40 	orl    $0x40,0x1d74(%ebx)
		return 0;
f010026e:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100273:	89 f0                	mov    %esi,%eax
f0100275:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100278:	5b                   	pop    %ebx
f0100279:	5e                   	pop    %esi
f010027a:	5d                   	pop    %ebp
f010027b:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010027c:	8b 8b 74 1d 00 00    	mov    0x1d74(%ebx),%ecx
f0100282:	83 e0 7f             	and    $0x7f,%eax
f0100285:	f6 c1 40             	test   $0x40,%cl
f0100288:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010028b:	0f b6 d2             	movzbl %dl,%edx
f010028e:	0f b6 84 13 34 cf fe 	movzbl -0x130cc(%ebx,%edx,1),%eax
f0100295:	ff 
f0100296:	83 c8 40             	or     $0x40,%eax
f0100299:	0f b6 c0             	movzbl %al,%eax
f010029c:	f7 d0                	not    %eax
f010029e:	21 c8                	and    %ecx,%eax
f01002a0:	89 83 74 1d 00 00    	mov    %eax,0x1d74(%ebx)
		return 0;
f01002a6:	be 00 00 00 00       	mov    $0x0,%esi
f01002ab:	eb c6                	jmp    f0100273 <kbd_proc_data+0xa2>
		else if ('A' <= c && c <= 'Z')
f01002ad:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002b0:	8d 4e 20             	lea    0x20(%esi),%ecx
f01002b3:	83 fa 1a             	cmp    $0x1a,%edx
f01002b6:	0f 42 f1             	cmovb  %ecx,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01002b9:	f7 d0                	not    %eax
f01002bb:	a8 06                	test   $0x6,%al
f01002bd:	75 b4                	jne    f0100273 <kbd_proc_data+0xa2>
f01002bf:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f01002c5:	75 ac                	jne    f0100273 <kbd_proc_data+0xa2>
		cprintf("Rebooting!\n");
f01002c7:	83 ec 0c             	sub    $0xc,%esp
f01002ca:	8d 83 01 ce fe ff    	lea    -0x131ff(%ebx),%eax
f01002d0:	50                   	push   %eax
f01002d1:	e8 b0 2d 00 00       	call   f0103086 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002d6:	b8 03 00 00 00       	mov    $0x3,%eax
f01002db:	ba 92 00 00 00       	mov    $0x92,%edx
f01002e0:	ee                   	out    %al,(%dx)
}
f01002e1:	83 c4 10             	add    $0x10,%esp
f01002e4:	eb 8d                	jmp    f0100273 <kbd_proc_data+0xa2>
		return -1;
f01002e6:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01002eb:	eb 86                	jmp    f0100273 <kbd_proc_data+0xa2>
		return -1;
f01002ed:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01002f2:	e9 7c ff ff ff       	jmp    f0100273 <kbd_proc_data+0xa2>

f01002f7 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01002f7:	55                   	push   %ebp
f01002f8:	89 e5                	mov    %esp,%ebp
f01002fa:	57                   	push   %edi
f01002fb:	56                   	push   %esi
f01002fc:	53                   	push   %ebx
f01002fd:	83 ec 1c             	sub    $0x1c,%esp
f0100300:	e8 4a fe ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100305:	81 c3 07 70 01 00    	add    $0x17007,%ebx
f010030b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
f010030e:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100313:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100318:	b9 84 00 00 00       	mov    $0x84,%ecx
f010031d:	89 fa                	mov    %edi,%edx
f010031f:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100320:	a8 20                	test   $0x20,%al
f0100322:	75 13                	jne    f0100337 <cons_putc+0x40>
f0100324:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010032a:	7f 0b                	jg     f0100337 <cons_putc+0x40>
f010032c:	89 ca                	mov    %ecx,%edx
f010032e:	ec                   	in     (%dx),%al
f010032f:	ec                   	in     (%dx),%al
f0100330:	ec                   	in     (%dx),%al
f0100331:	ec                   	in     (%dx),%al
	     i++)
f0100332:	83 c6 01             	add    $0x1,%esi
f0100335:	eb e6                	jmp    f010031d <cons_putc+0x26>
	outb(COM1 + COM_TX, c);
f0100337:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f010033b:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010033e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100343:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100344:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100349:	bf 79 03 00 00       	mov    $0x379,%edi
f010034e:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100353:	89 fa                	mov    %edi,%edx
f0100355:	ec                   	in     (%dx),%al
f0100356:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010035c:	7f 0f                	jg     f010036d <cons_putc+0x76>
f010035e:	84 c0                	test   %al,%al
f0100360:	78 0b                	js     f010036d <cons_putc+0x76>
f0100362:	89 ca                	mov    %ecx,%edx
f0100364:	ec                   	in     (%dx),%al
f0100365:	ec                   	in     (%dx),%al
f0100366:	ec                   	in     (%dx),%al
f0100367:	ec                   	in     (%dx),%al
f0100368:	83 c6 01             	add    $0x1,%esi
f010036b:	eb e6                	jmp    f0100353 <cons_putc+0x5c>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010036d:	ba 78 03 00 00       	mov    $0x378,%edx
f0100372:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f0100376:	ee                   	out    %al,(%dx)
f0100377:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010037c:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100381:	ee                   	out    %al,(%dx)
f0100382:	b8 08 00 00 00       	mov    $0x8,%eax
f0100387:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f0100388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010038b:	89 f8                	mov    %edi,%eax
f010038d:	80 cc 07             	or     $0x7,%ah
f0100390:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100396:	0f 45 c7             	cmovne %edi,%eax
f0100399:	89 c7                	mov    %eax,%edi
f010039b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
f010039e:	0f b6 c0             	movzbl %al,%eax
f01003a1:	89 f9                	mov    %edi,%ecx
f01003a3:	80 f9 0a             	cmp    $0xa,%cl
f01003a6:	0f 84 e4 00 00 00    	je     f0100490 <cons_putc+0x199>
f01003ac:	83 f8 0a             	cmp    $0xa,%eax
f01003af:	7f 46                	jg     f01003f7 <cons_putc+0x100>
f01003b1:	83 f8 08             	cmp    $0x8,%eax
f01003b4:	0f 84 a8 00 00 00    	je     f0100462 <cons_putc+0x16b>
f01003ba:	83 f8 09             	cmp    $0x9,%eax
f01003bd:	0f 85 da 00 00 00    	jne    f010049d <cons_putc+0x1a6>
		cons_putc(' ');
f01003c3:	b8 20 00 00 00       	mov    $0x20,%eax
f01003c8:	e8 2a ff ff ff       	call   f01002f7 <cons_putc>
		cons_putc(' ');
f01003cd:	b8 20 00 00 00       	mov    $0x20,%eax
f01003d2:	e8 20 ff ff ff       	call   f01002f7 <cons_putc>
		cons_putc(' ');
f01003d7:	b8 20 00 00 00       	mov    $0x20,%eax
f01003dc:	e8 16 ff ff ff       	call   f01002f7 <cons_putc>
		cons_putc(' ');
f01003e1:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e6:	e8 0c ff ff ff       	call   f01002f7 <cons_putc>
		cons_putc(' ');
f01003eb:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f0:	e8 02 ff ff ff       	call   f01002f7 <cons_putc>
		break;
f01003f5:	eb 26                	jmp    f010041d <cons_putc+0x126>
	switch (c & 0xff) {
f01003f7:	83 f8 0d             	cmp    $0xd,%eax
f01003fa:	0f 85 9d 00 00 00    	jne    f010049d <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
f0100400:	0f b7 83 9c 1f 00 00 	movzwl 0x1f9c(%ebx),%eax
f0100407:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010040d:	c1 e8 16             	shr    $0x16,%eax
f0100410:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100413:	c1 e0 04             	shl    $0x4,%eax
f0100416:	66 89 83 9c 1f 00 00 	mov    %ax,0x1f9c(%ebx)
	if (crt_pos >= CRT_SIZE) {
f010041d:	66 81 bb 9c 1f 00 00 	cmpw   $0x7cf,0x1f9c(%ebx)
f0100424:	cf 07 
f0100426:	0f 87 98 00 00 00    	ja     f01004c4 <cons_putc+0x1cd>
	outb(addr_6845, 14);
f010042c:	8b 8b a4 1f 00 00    	mov    0x1fa4(%ebx),%ecx
f0100432:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100437:	89 ca                	mov    %ecx,%edx
f0100439:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010043a:	0f b7 9b 9c 1f 00 00 	movzwl 0x1f9c(%ebx),%ebx
f0100441:	8d 71 01             	lea    0x1(%ecx),%esi
f0100444:	89 d8                	mov    %ebx,%eax
f0100446:	66 c1 e8 08          	shr    $0x8,%ax
f010044a:	89 f2                	mov    %esi,%edx
f010044c:	ee                   	out    %al,(%dx)
f010044d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100452:	89 ca                	mov    %ecx,%edx
f0100454:	ee                   	out    %al,(%dx)
f0100455:	89 d8                	mov    %ebx,%eax
f0100457:	89 f2                	mov    %esi,%edx
f0100459:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010045a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010045d:	5b                   	pop    %ebx
f010045e:	5e                   	pop    %esi
f010045f:	5f                   	pop    %edi
f0100460:	5d                   	pop    %ebp
f0100461:	c3                   	ret    
		if (crt_pos > 0) {
f0100462:	0f b7 83 9c 1f 00 00 	movzwl 0x1f9c(%ebx),%eax
f0100469:	66 85 c0             	test   %ax,%ax
f010046c:	74 be                	je     f010042c <cons_putc+0x135>
			crt_pos--;
f010046e:	83 e8 01             	sub    $0x1,%eax
f0100471:	66 89 83 9c 1f 00 00 	mov    %ax,0x1f9c(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100478:	0f b7 c0             	movzwl %ax,%eax
f010047b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f010047f:	b2 00                	mov    $0x0,%dl
f0100481:	83 ca 20             	or     $0x20,%edx
f0100484:	8b 8b a0 1f 00 00    	mov    0x1fa0(%ebx),%ecx
f010048a:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f010048e:	eb 8d                	jmp    f010041d <cons_putc+0x126>
		crt_pos += CRT_COLS;
f0100490:	66 83 83 9c 1f 00 00 	addw   $0x50,0x1f9c(%ebx)
f0100497:	50 
f0100498:	e9 63 ff ff ff       	jmp    f0100400 <cons_putc+0x109>
		crt_buf[crt_pos++] = c;		/* write the character */
f010049d:	0f b7 83 9c 1f 00 00 	movzwl 0x1f9c(%ebx),%eax
f01004a4:	8d 50 01             	lea    0x1(%eax),%edx
f01004a7:	66 89 93 9c 1f 00 00 	mov    %dx,0x1f9c(%ebx)
f01004ae:	0f b7 c0             	movzwl %ax,%eax
f01004b1:	8b 93 a0 1f 00 00    	mov    0x1fa0(%ebx),%edx
f01004b7:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01004bb:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f01004bf:	e9 59 ff ff ff       	jmp    f010041d <cons_putc+0x126>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004c4:	8b 83 a0 1f 00 00    	mov    0x1fa0(%ebx),%eax
f01004ca:	83 ec 04             	sub    $0x4,%esp
f01004cd:	68 00 0f 00 00       	push   $0xf00
f01004d2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d8:	52                   	push   %edx
f01004d9:	50                   	push   %eax
f01004da:	e8 ee 37 00 00       	call   f0103ccd <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004df:	8b 93 a0 1f 00 00    	mov    0x1fa0(%ebx),%edx
f01004e5:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004eb:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004f1:	83 c4 10             	add    $0x10,%esp
f01004f4:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004f9:	83 c0 02             	add    $0x2,%eax
f01004fc:	39 d0                	cmp    %edx,%eax
f01004fe:	75 f4                	jne    f01004f4 <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f0100500:	66 83 ab 9c 1f 00 00 	subw   $0x50,0x1f9c(%ebx)
f0100507:	50 
f0100508:	e9 1f ff ff ff       	jmp    f010042c <cons_putc+0x135>

f010050d <serial_intr>:
{
f010050d:	e8 cf 01 00 00       	call   f01006e1 <__x86.get_pc_thunk.ax>
f0100512:	05 fa 6d 01 00       	add    $0x16dfa,%eax
	if (serial_exists)
f0100517:	80 b8 a8 1f 00 00 00 	cmpb   $0x0,0x1fa8(%eax)
f010051e:	75 01                	jne    f0100521 <serial_intr+0x14>
f0100520:	c3                   	ret    
{
f0100521:	55                   	push   %ebp
f0100522:	89 e5                	mov    %esp,%ebp
f0100524:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100527:	8d 80 47 8e fe ff    	lea    -0x171b9(%eax),%eax
f010052d:	e8 3b fc ff ff       	call   f010016d <cons_intr>
}
f0100532:	c9                   	leave  
f0100533:	c3                   	ret    

f0100534 <kbd_intr>:
{
f0100534:	55                   	push   %ebp
f0100535:	89 e5                	mov    %esp,%ebp
f0100537:	83 ec 08             	sub    $0x8,%esp
f010053a:	e8 a2 01 00 00       	call   f01006e1 <__x86.get_pc_thunk.ax>
f010053f:	05 cd 6d 01 00       	add    $0x16dcd,%eax
	cons_intr(kbd_proc_data);
f0100544:	8d 80 c5 8e fe ff    	lea    -0x1713b(%eax),%eax
f010054a:	e8 1e fc ff ff       	call   f010016d <cons_intr>
}
f010054f:	c9                   	leave  
f0100550:	c3                   	ret    

f0100551 <cons_getc>:
{
f0100551:	55                   	push   %ebp
f0100552:	89 e5                	mov    %esp,%ebp
f0100554:	53                   	push   %ebx
f0100555:	83 ec 04             	sub    $0x4,%esp
f0100558:	e8 f2 fb ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010055d:	81 c3 af 6d 01 00    	add    $0x16daf,%ebx
	serial_intr();
f0100563:	e8 a5 ff ff ff       	call   f010050d <serial_intr>
	kbd_intr();
f0100568:	e8 c7 ff ff ff       	call   f0100534 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010056d:	8b 83 94 1f 00 00    	mov    0x1f94(%ebx),%eax
	return 0;
f0100573:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100578:	3b 83 98 1f 00 00    	cmp    0x1f98(%ebx),%eax
f010057e:	74 1e                	je     f010059e <cons_getc+0x4d>
		c = cons.buf[cons.rpos++];
f0100580:	8d 48 01             	lea    0x1(%eax),%ecx
f0100583:	0f b6 94 03 94 1d 00 	movzbl 0x1d94(%ebx,%eax,1),%edx
f010058a:	00 
			cons.rpos = 0;
f010058b:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100590:	b8 00 00 00 00       	mov    $0x0,%eax
f0100595:	0f 45 c1             	cmovne %ecx,%eax
f0100598:	89 83 94 1f 00 00    	mov    %eax,0x1f94(%ebx)
}
f010059e:	89 d0                	mov    %edx,%eax
f01005a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01005a3:	c9                   	leave  
f01005a4:	c3                   	ret    

f01005a5 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005a5:	55                   	push   %ebp
f01005a6:	89 e5                	mov    %esp,%ebp
f01005a8:	57                   	push   %edi
f01005a9:	56                   	push   %esi
f01005aa:	53                   	push   %ebx
f01005ab:	83 ec 1c             	sub    $0x1c,%esp
f01005ae:	e8 9c fb ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01005b3:	81 c3 59 6d 01 00    	add    $0x16d59,%ebx
	was = *cp;
f01005b9:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01005c0:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01005c7:	5a a5 
	if (*cp != 0xA55A) {
f01005c9:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01005d0:	b9 b4 03 00 00       	mov    $0x3b4,%ecx
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01005d5:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
	if (*cp != 0xA55A) {
f01005da:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005de:	0f 84 ac 00 00 00    	je     f0100690 <cons_init+0xeb>
		addr_6845 = MONO_BASE;
f01005e4:	89 8b a4 1f 00 00    	mov    %ecx,0x1fa4(%ebx)
f01005ea:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005ef:	89 ca                	mov    %ecx,%edx
f01005f1:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01005f2:	8d 71 01             	lea    0x1(%ecx),%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005f5:	89 f2                	mov    %esi,%edx
f01005f7:	ec                   	in     (%dx),%al
f01005f8:	0f b6 c0             	movzbl %al,%eax
f01005fb:	c1 e0 08             	shl    $0x8,%eax
f01005fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100601:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100606:	89 ca                	mov    %ecx,%edx
f0100608:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100609:	89 f2                	mov    %esi,%edx
f010060b:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010060c:	89 bb a0 1f 00 00    	mov    %edi,0x1fa0(%ebx)
	pos |= inb(addr_6845 + 1);
f0100612:	0f b6 c0             	movzbl %al,%eax
f0100615:	0b 45 e4             	or     -0x1c(%ebp),%eax
	crt_pos = pos;
f0100618:	66 89 83 9c 1f 00 00 	mov    %ax,0x1f9c(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010061f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100624:	89 c8                	mov    %ecx,%eax
f0100626:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010062b:	ee                   	out    %al,(%dx)
f010062c:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100631:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100636:	89 fa                	mov    %edi,%edx
f0100638:	ee                   	out    %al,(%dx)
f0100639:	b8 0c 00 00 00       	mov    $0xc,%eax
f010063e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100643:	ee                   	out    %al,(%dx)
f0100644:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100649:	89 c8                	mov    %ecx,%eax
f010064b:	89 f2                	mov    %esi,%edx
f010064d:	ee                   	out    %al,(%dx)
f010064e:	b8 03 00 00 00       	mov    $0x3,%eax
f0100653:	89 fa                	mov    %edi,%edx
f0100655:	ee                   	out    %al,(%dx)
f0100656:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010065b:	89 c8                	mov    %ecx,%eax
f010065d:	ee                   	out    %al,(%dx)
f010065e:	b8 01 00 00 00       	mov    $0x1,%eax
f0100663:	89 f2                	mov    %esi,%edx
f0100665:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100666:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010066b:	ec                   	in     (%dx),%al
f010066c:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010066e:	3c ff                	cmp    $0xff,%al
f0100670:	0f 95 83 a8 1f 00 00 	setne  0x1fa8(%ebx)
f0100677:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010067c:	ec                   	in     (%dx),%al
f010067d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100682:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f0100683:	80 f9 ff             	cmp    $0xff,%cl
f0100686:	74 1e                	je     f01006a6 <cons_init+0x101>
		cprintf("Serial port does not exist!\n");
}
f0100688:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010068b:	5b                   	pop    %ebx
f010068c:	5e                   	pop    %esi
f010068d:	5f                   	pop    %edi
f010068e:	5d                   	pop    %ebp
f010068f:	c3                   	ret    
		*cp = was;
f0100690:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f0100697:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010069c:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
f01006a1:	e9 3e ff ff ff       	jmp    f01005e4 <cons_init+0x3f>
		cprintf("Serial port does not exist!\n");
f01006a6:	83 ec 0c             	sub    $0xc,%esp
f01006a9:	8d 83 0d ce fe ff    	lea    -0x131f3(%ebx),%eax
f01006af:	50                   	push   %eax
f01006b0:	e8 d1 29 00 00       	call   f0103086 <cprintf>
f01006b5:	83 c4 10             	add    $0x10,%esp
}
f01006b8:	eb ce                	jmp    f0100688 <cons_init+0xe3>

f01006ba <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006ba:	55                   	push   %ebp
f01006bb:	89 e5                	mov    %esp,%ebp
f01006bd:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01006c0:	8b 45 08             	mov    0x8(%ebp),%eax
f01006c3:	e8 2f fc ff ff       	call   f01002f7 <cons_putc>
}
f01006c8:	c9                   	leave  
f01006c9:	c3                   	ret    

f01006ca <getchar>:

int
getchar(void)
{
f01006ca:	55                   	push   %ebp
f01006cb:	89 e5                	mov    %esp,%ebp
f01006cd:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006d0:	e8 7c fe ff ff       	call   f0100551 <cons_getc>
f01006d5:	85 c0                	test   %eax,%eax
f01006d7:	74 f7                	je     f01006d0 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01006d9:	c9                   	leave  
f01006da:	c3                   	ret    

f01006db <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01006db:	b8 01 00 00 00       	mov    $0x1,%eax
f01006e0:	c3                   	ret    

f01006e1 <__x86.get_pc_thunk.ax>:
f01006e1:	8b 04 24             	mov    (%esp),%eax
f01006e4:	c3                   	ret    

f01006e5 <__x86.get_pc_thunk.si>:
f01006e5:	8b 34 24             	mov    (%esp),%esi
f01006e8:	c3                   	ret    

f01006e9 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01006e9:	55                   	push   %ebp
f01006ea:	89 e5                	mov    %esp,%ebp
f01006ec:	56                   	push   %esi
f01006ed:	53                   	push   %ebx
f01006ee:	e8 5c fa ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01006f3:	81 c3 19 6c 01 00    	add    $0x16c19,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01006f9:	83 ec 04             	sub    $0x4,%esp
f01006fc:	8d 83 34 d0 fe ff    	lea    -0x12fcc(%ebx),%eax
f0100702:	50                   	push   %eax
f0100703:	8d 83 52 d0 fe ff    	lea    -0x12fae(%ebx),%eax
f0100709:	50                   	push   %eax
f010070a:	8d b3 57 d0 fe ff    	lea    -0x12fa9(%ebx),%esi
f0100710:	56                   	push   %esi
f0100711:	e8 70 29 00 00       	call   f0103086 <cprintf>
f0100716:	83 c4 0c             	add    $0xc,%esp
f0100719:	8d 83 04 d1 fe ff    	lea    -0x12efc(%ebx),%eax
f010071f:	50                   	push   %eax
f0100720:	8d 83 60 d0 fe ff    	lea    -0x12fa0(%ebx),%eax
f0100726:	50                   	push   %eax
f0100727:	56                   	push   %esi
f0100728:	e8 59 29 00 00       	call   f0103086 <cprintf>
	return 0;
}
f010072d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100732:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100735:	5b                   	pop    %ebx
f0100736:	5e                   	pop    %esi
f0100737:	5d                   	pop    %ebp
f0100738:	c3                   	ret    

f0100739 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100739:	55                   	push   %ebp
f010073a:	89 e5                	mov    %esp,%ebp
f010073c:	57                   	push   %edi
f010073d:	56                   	push   %esi
f010073e:	53                   	push   %ebx
f010073f:	83 ec 18             	sub    $0x18,%esp
f0100742:	e8 08 fa ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100747:	81 c3 c5 6b 01 00    	add    $0x16bc5,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010074d:	8d 83 69 d0 fe ff    	lea    -0x12f97(%ebx),%eax
f0100753:	50                   	push   %eax
f0100754:	e8 2d 29 00 00       	call   f0103086 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100759:	83 c4 08             	add    $0x8,%esp
f010075c:	ff b3 f4 ff ff ff    	push   -0xc(%ebx)
f0100762:	8d 83 2c d1 fe ff    	lea    -0x12ed4(%ebx),%eax
f0100768:	50                   	push   %eax
f0100769:	e8 18 29 00 00       	call   f0103086 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010076e:	83 c4 0c             	add    $0xc,%esp
f0100771:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f0100777:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f010077d:	50                   	push   %eax
f010077e:	57                   	push   %edi
f010077f:	8d 83 54 d1 fe ff    	lea    -0x12eac(%ebx),%eax
f0100785:	50                   	push   %eax
f0100786:	e8 fb 28 00 00       	call   f0103086 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010078b:	83 c4 0c             	add    $0xc,%esp
f010078e:	c7 c0 b1 40 10 f0    	mov    $0xf01040b1,%eax
f0100794:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010079a:	52                   	push   %edx
f010079b:	50                   	push   %eax
f010079c:	8d 83 78 d1 fe ff    	lea    -0x12e88(%ebx),%eax
f01007a2:	50                   	push   %eax
f01007a3:	e8 de 28 00 00       	call   f0103086 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007a8:	83 c4 0c             	add    $0xc,%esp
f01007ab:	c7 c0 60 90 11 f0    	mov    $0xf0119060,%eax
f01007b1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007b7:	52                   	push   %edx
f01007b8:	50                   	push   %eax
f01007b9:	8d 83 9c d1 fe ff    	lea    -0x12e64(%ebx),%eax
f01007bf:	50                   	push   %eax
f01007c0:	e8 c1 28 00 00       	call   f0103086 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01007c5:	83 c4 0c             	add    $0xc,%esp
f01007c8:	c7 c6 e0 96 11 f0    	mov    $0xf01196e0,%esi
f01007ce:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01007d4:	50                   	push   %eax
f01007d5:	56                   	push   %esi
f01007d6:	8d 83 c0 d1 fe ff    	lea    -0x12e40(%ebx),%eax
f01007dc:	50                   	push   %eax
f01007dd:	e8 a4 28 00 00       	call   f0103086 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007e2:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024); 
f01007e5:	29 fe                	sub    %edi,%esi
f01007e7:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007ed:	c1 fe 0a             	sar    $0xa,%esi
f01007f0:	56                   	push   %esi
f01007f1:	8d 83 e4 d1 fe ff    	lea    -0x12e1c(%ebx),%eax
f01007f7:	50                   	push   %eax
f01007f8:	e8 89 28 00 00       	call   f0103086 <cprintf>
	return 0;
}
f01007fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0100802:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100805:	5b                   	pop    %ebx
f0100806:	5e                   	pop    %esi
f0100807:	5f                   	pop    %edi
f0100808:	5d                   	pop    %ebp
f0100809:	c3                   	ret    

f010080a <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010080a:	55                   	push   %ebp
f010080b:	89 e5                	mov    %esp,%ebp
f010080d:	57                   	push   %edi
f010080e:	56                   	push   %esi
f010080f:	53                   	push   %ebx
f0100810:	83 ec 48             	sub    $0x48,%esp
f0100813:	e8 37 f9 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100818:	81 c3 f4 6a 01 00    	add    $0x16af4,%ebx
	// Your code here.

	cprintf("Stack backtrace:\n");
f010081e:	8d 83 82 d0 fe ff    	lea    -0x12f7e(%ebx),%eax
f0100824:	50                   	push   %eax
f0100825:	e8 5c 28 00 00       	call   f0103086 <cprintf>

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010082a:	89 ee                	mov    %ebp,%esi
	uint32_t ebp,eip;
	struct Eipdebuginfo info;
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f010082c:	83 c4 10             	add    $0x10,%esp
	{
		eip = *((uint32_t *)ebp+1);
		
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",ebp,*((uint32_t *)ebp+1),
f010082f:	8d 83 10 d2 fe ff    	lea    -0x12df0(%ebx),%eax
f0100835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*((uint32_t *)ebp+2),*((uint32_t *)ebp+3),*((uint32_t *)ebp+4),*((uint32_t *)ebp+5),
		*((uint32_t *)ebp+6));

		debuginfo_eip(eip,&info);

		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f0100838:	8d 83 94 d0 fe ff    	lea    -0x12f6c(%ebx),%eax
f010083e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f0100841:	eb 49                	jmp    f010088c <mon_backtrace+0x82>
		eip = *((uint32_t *)ebp+1);
f0100843:	8b 7e 04             	mov    0x4(%esi),%edi
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",ebp,*((uint32_t *)ebp+1),
f0100846:	ff 76 18             	push   0x18(%esi)
f0100849:	ff 76 14             	push   0x14(%esi)
f010084c:	ff 76 10             	push   0x10(%esi)
f010084f:	ff 76 0c             	push   0xc(%esi)
f0100852:	ff 76 08             	push   0x8(%esi)
f0100855:	57                   	push   %edi
f0100856:	56                   	push   %esi
f0100857:	ff 75 c4             	push   -0x3c(%ebp)
f010085a:	e8 27 28 00 00       	call   f0103086 <cprintf>
		debuginfo_eip(eip,&info);
f010085f:	83 c4 18             	add    $0x18,%esp
f0100862:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100865:	50                   	push   %eax
f0100866:	57                   	push   %edi
f0100867:	e8 23 29 00 00       	call   f010318f <debuginfo_eip>
		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f010086c:	83 c4 08             	add    $0x8,%esp
f010086f:	2b 7d e0             	sub    -0x20(%ebp),%edi
f0100872:	57                   	push   %edi
f0100873:	ff 75 d8             	push   -0x28(%ebp)
f0100876:	ff 75 dc             	push   -0x24(%ebp)
f0100879:	ff 75 d4             	push   -0x2c(%ebp)
f010087c:	ff 75 d0             	push   -0x30(%ebp)
f010087f:	ff 75 c0             	push   -0x40(%ebp)
f0100882:	e8 ff 27 00 00       	call   f0103086 <cprintf>
	for(ebp = read_ebp();ebp != 0x0;ebp = *((uint32_t *)ebp)) 
f0100887:	8b 36                	mov    (%esi),%esi
f0100889:	83 c4 20             	add    $0x20,%esp
f010088c:	85 f6                	test   %esi,%esi
f010088e:	75 b3                	jne    f0100843 <mon_backtrace+0x39>
				info.eip_fn_namelen,info.eip_fn_name,eip-info.eip_fn_addr);
	}

	return 0;
}
f0100890:	b8 00 00 00 00       	mov    $0x0,%eax
f0100895:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100898:	5b                   	pop    %ebx
f0100899:	5e                   	pop    %esi
f010089a:	5f                   	pop    %edi
f010089b:	5d                   	pop    %ebp
f010089c:	c3                   	ret    

f010089d <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010089d:	55                   	push   %ebp
f010089e:	89 e5                	mov    %esp,%ebp
f01008a0:	57                   	push   %edi
f01008a1:	56                   	push   %esi
f01008a2:	53                   	push   %ebx
f01008a3:	83 ec 60             	sub    $0x60,%esp
f01008a6:	e8 a4 f8 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01008ab:	81 c3 61 6a 01 00    	add    $0x16a61,%ebx
	char *buf;

	cprintf("%u decimal is %o octal!\n", 6828,6828);      
f01008b1:	68 ac 1a 00 00       	push   $0x1aac
f01008b6:	68 ac 1a 00 00       	push   $0x1aac
f01008bb:	8d 83 ad d0 fe ff    	lea    -0x12f53(%ebx),%eax
f01008c1:	50                   	push   %eax
f01008c2:	e8 bf 27 00 00       	call   f0103086 <cprintf>
	cprintf("Welcome to the JOS kernel monitor!\n");
f01008c7:	8d 83 48 d2 fe ff    	lea    -0x12db8(%ebx),%eax
f01008cd:	89 04 24             	mov    %eax,(%esp)
f01008d0:	e8 b1 27 00 00       	call   f0103086 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008d5:	8d 83 6c d2 fe ff    	lea    -0x12d94(%ebx),%eax
f01008db:	89 04 24             	mov    %eax,(%esp)
f01008de:	e8 a3 27 00 00       	call   f0103086 <cprintf>
f01008e3:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f01008e6:	8d bb ca d0 fe ff    	lea    -0x12f36(%ebx),%edi
f01008ec:	eb 4a                	jmp    f0100938 <monitor+0x9b>
f01008ee:	83 ec 08             	sub    $0x8,%esp
f01008f1:	0f be c0             	movsbl %al,%eax
f01008f4:	50                   	push   %eax
f01008f5:	57                   	push   %edi
f01008f6:	e8 4d 33 00 00       	call   f0103c48 <strchr>
f01008fb:	83 c4 10             	add    $0x10,%esp
f01008fe:	85 c0                	test   %eax,%eax
f0100900:	74 08                	je     f010090a <monitor+0x6d>
			*buf++ = 0;
f0100902:	c6 06 00             	movb   $0x0,(%esi)
f0100905:	8d 76 01             	lea    0x1(%esi),%esi
f0100908:	eb 79                	jmp    f0100983 <monitor+0xe6>
		if (*buf == 0)
f010090a:	80 3e 00             	cmpb   $0x0,(%esi)
f010090d:	74 7f                	je     f010098e <monitor+0xf1>
		if (argc == MAXARGS-1) {
f010090f:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
f0100913:	74 0f                	je     f0100924 <monitor+0x87>
		argv[argc++] = buf;
f0100915:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100918:	8d 48 01             	lea    0x1(%eax),%ecx
f010091b:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f010091e:	89 74 85 a8          	mov    %esi,-0x58(%ebp,%eax,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100922:	eb 44                	jmp    f0100968 <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100924:	83 ec 08             	sub    $0x8,%esp
f0100927:	6a 10                	push   $0x10
f0100929:	8d 83 cf d0 fe ff    	lea    -0x12f31(%ebx),%eax
f010092f:	50                   	push   %eax
f0100930:	e8 51 27 00 00       	call   f0103086 <cprintf>
			return 0;
f0100935:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f0100938:	8d 83 c6 d0 fe ff    	lea    -0x12f3a(%ebx),%eax
f010093e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0100941:	83 ec 0c             	sub    $0xc,%esp
f0100944:	ff 75 a4             	push   -0x5c(%ebp)
f0100947:	e8 ab 30 00 00       	call   f01039f7 <readline>
f010094c:	89 c6                	mov    %eax,%esi
		if (buf != NULL)
f010094e:	83 c4 10             	add    $0x10,%esp
f0100951:	85 c0                	test   %eax,%eax
f0100953:	74 ec                	je     f0100941 <monitor+0xa4>
	argv[argc] = 0;
f0100955:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010095c:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0100963:	eb 1e                	jmp    f0100983 <monitor+0xe6>
			buf++;
f0100965:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100968:	0f b6 06             	movzbl (%esi),%eax
f010096b:	84 c0                	test   %al,%al
f010096d:	74 14                	je     f0100983 <monitor+0xe6>
f010096f:	83 ec 08             	sub    $0x8,%esp
f0100972:	0f be c0             	movsbl %al,%eax
f0100975:	50                   	push   %eax
f0100976:	57                   	push   %edi
f0100977:	e8 cc 32 00 00       	call   f0103c48 <strchr>
f010097c:	83 c4 10             	add    $0x10,%esp
f010097f:	85 c0                	test   %eax,%eax
f0100981:	74 e2                	je     f0100965 <monitor+0xc8>
		while (*buf && strchr(WHITESPACE, *buf))
f0100983:	0f b6 06             	movzbl (%esi),%eax
f0100986:	84 c0                	test   %al,%al
f0100988:	0f 85 60 ff ff ff    	jne    f01008ee <monitor+0x51>
	argv[argc] = 0;
f010098e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100991:	c7 44 85 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%eax,4)
f0100998:	00 
	if (argc == 0)
f0100999:	85 c0                	test   %eax,%eax
f010099b:	74 9b                	je     f0100938 <monitor+0x9b>
		if (strcmp(argv[0], commands[i].name) == 0)
f010099d:	83 ec 08             	sub    $0x8,%esp
f01009a0:	8d 83 52 d0 fe ff    	lea    -0x12fae(%ebx),%eax
f01009a6:	50                   	push   %eax
f01009a7:	ff 75 a8             	push   -0x58(%ebp)
f01009aa:	e8 39 32 00 00       	call   f0103be8 <strcmp>
f01009af:	83 c4 10             	add    $0x10,%esp
f01009b2:	85 c0                	test   %eax,%eax
f01009b4:	74 38                	je     f01009ee <monitor+0x151>
f01009b6:	83 ec 08             	sub    $0x8,%esp
f01009b9:	8d 83 60 d0 fe ff    	lea    -0x12fa0(%ebx),%eax
f01009bf:	50                   	push   %eax
f01009c0:	ff 75 a8             	push   -0x58(%ebp)
f01009c3:	e8 20 32 00 00       	call   f0103be8 <strcmp>
f01009c8:	83 c4 10             	add    $0x10,%esp
f01009cb:	85 c0                	test   %eax,%eax
f01009cd:	74 1a                	je     f01009e9 <monitor+0x14c>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009cf:	83 ec 08             	sub    $0x8,%esp
f01009d2:	ff 75 a8             	push   -0x58(%ebp)
f01009d5:	8d 83 ec d0 fe ff    	lea    -0x12f14(%ebx),%eax
f01009db:	50                   	push   %eax
f01009dc:	e8 a5 26 00 00       	call   f0103086 <cprintf>
	return 0;
f01009e1:	83 c4 10             	add    $0x10,%esp
f01009e4:	e9 4f ff ff ff       	jmp    f0100938 <monitor+0x9b>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009e9:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f01009ee:	83 ec 04             	sub    $0x4,%esp
f01009f1:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01009f4:	ff 75 08             	push   0x8(%ebp)
f01009f7:	8d 55 a8             	lea    -0x58(%ebp),%edx
f01009fa:	52                   	push   %edx
f01009fb:	ff 75 a4             	push   -0x5c(%ebp)
f01009fe:	ff 94 83 0c 1d 00 00 	call   *0x1d0c(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a05:	83 c4 10             	add    $0x10,%esp
f0100a08:	85 c0                	test   %eax,%eax
f0100a0a:	0f 89 28 ff ff ff    	jns    f0100938 <monitor+0x9b>
				break;
	}
}
f0100a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a13:	5b                   	pop    %ebx
f0100a14:	5e                   	pop    %esi
f0100a15:	5f                   	pop    %edi
f0100a16:	5d                   	pop    %ebp
f0100a17:	c3                   	ret    

f0100a18 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100a18:	55                   	push   %ebp
f0100a19:	89 e5                	mov    %esp,%ebp
f0100a1b:	57                   	push   %edi
f0100a1c:	56                   	push   %esi
f0100a1d:	53                   	push   %ebx
f0100a1e:	83 ec 18             	sub    $0x18,%esp
f0100a21:	e8 29 f7 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100a26:	81 c3 e6 68 01 00    	add    $0x168e6,%ebx
f0100a2c:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a2e:	50                   	push   %eax
f0100a2f:	e8 cb 25 00 00       	call   f0102fff <mc146818_read>
f0100a34:	89 c7                	mov    %eax,%edi
f0100a36:	83 c6 01             	add    $0x1,%esi
f0100a39:	89 34 24             	mov    %esi,(%esp)
f0100a3c:	e8 be 25 00 00       	call   f0102fff <mc146818_read>
f0100a41:	c1 e0 08             	shl    $0x8,%eax
f0100a44:	09 f8                	or     %edi,%eax
}
f0100a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a49:	5b                   	pop    %ebx
f0100a4a:	5e                   	pop    %esi
f0100a4b:	5f                   	pop    %edi
f0100a4c:	5d                   	pop    %ebp
f0100a4d:	c3                   	ret    

f0100a4e <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100a4e:	55                   	push   %ebp
f0100a4f:	89 e5                	mov    %esp,%ebp
f0100a51:	53                   	push   %ebx
f0100a52:	83 ec 04             	sub    $0x4,%esp
f0100a55:	e8 99 25 00 00       	call   f0102ff3 <__x86.get_pc_thunk.dx>
f0100a5a:	81 c2 b2 68 01 00    	add    $0x168b2,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100a60:	83 ba b8 1f 00 00 00 	cmpl   $0x0,0x1fb8(%edx)
f0100a67:	74 31                	je     f0100a9a <boot_alloc+0x4c>
	{
		panic("OUT OF MEMORY");
	}
	return result;
*/
result = nextfree;
f0100a69:	8b 9a b8 1f 00 00    	mov    0x1fb8(%edx),%ebx
nextfree = ROUNDUP(nextfree+n, PGSIZE);
f0100a6f:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
f0100a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a7b:	89 82 b8 1f 00 00    	mov    %eax,0x1fb8(%edx)
if((uint32_t)nextfree-KERNBASE > (npages*PGSIZE)){
f0100a81:	05 00 00 00 10       	add    $0x10000000,%eax
f0100a86:	8b 8a b4 1f 00 00    	mov    0x1fb4(%edx),%ecx
f0100a8c:	c1 e1 0c             	shl    $0xc,%ecx
f0100a8f:	39 c8                	cmp    %ecx,%eax
f0100a91:	77 21                	ja     f0100ab4 <boot_alloc+0x66>
    panic("OUT OF MEMORY");
}
return result;
}
f0100a93:	89 d8                	mov    %ebx,%eax
f0100a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a98:	c9                   	leave  
f0100a99:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100a9a:	c7 c1 e0 96 11 f0    	mov    $0xf01196e0,%ecx
f0100aa0:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0100aa6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100aac:	89 8a b8 1f 00 00    	mov    %ecx,0x1fb8(%edx)
f0100ab2:	eb b5                	jmp    f0100a69 <boot_alloc+0x1b>
    panic("OUT OF MEMORY");
f0100ab4:	83 ec 04             	sub    $0x4,%esp
f0100ab7:	8d 82 91 d2 fe ff    	lea    -0x12d6f(%edx),%eax
f0100abd:	50                   	push   %eax
f0100abe:	6a 77                	push   $0x77
f0100ac0:	8d 82 9f d2 fe ff    	lea    -0x12d61(%edx),%eax
f0100ac6:	50                   	push   %eax
f0100ac7:	89 d3                	mov    %edx,%ebx
f0100ac9:	e8 cb f5 ff ff       	call   f0100099 <_panic>

f0100ace <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100ace:	55                   	push   %ebp
f0100acf:	89 e5                	mov    %esp,%ebp
f0100ad1:	53                   	push   %ebx
f0100ad2:	83 ec 04             	sub    $0x4,%esp
f0100ad5:	e8 1d 25 00 00       	call   f0102ff7 <__x86.get_pc_thunk.cx>
f0100ada:	81 c1 32 68 01 00    	add    $0x16832,%ecx
f0100ae0:	89 c3                	mov    %eax,%ebx
f0100ae2:	89 d0                	mov    %edx,%eax
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100ae4:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P))
f0100ae7:	8b 14 93             	mov    (%ebx,%edx,4),%edx
f0100aea:	f6 c2 01             	test   $0x1,%dl
f0100aed:	74 54                	je     f0100b43 <check_va2pa+0x75>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100aef:	89 d3                	mov    %edx,%ebx
f0100af1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100af7:	c1 ea 0c             	shr    $0xc,%edx
f0100afa:	3b 91 b4 1f 00 00    	cmp    0x1fb4(%ecx),%edx
f0100b00:	73 26                	jae    f0100b28 <check_va2pa+0x5a>
	if (!(p[PTX(va)] & PTE_P))
f0100b02:	c1 e8 0c             	shr    $0xc,%eax
f0100b05:	25 ff 03 00 00       	and    $0x3ff,%eax
f0100b0a:	8b 94 83 00 00 00 f0 	mov    -0x10000000(%ebx,%eax,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b11:	89 d0                	mov    %edx,%eax
f0100b13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b18:	f6 c2 01             	test   $0x1,%dl
f0100b1b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b20:	0f 44 c2             	cmove  %edx,%eax
}
f0100b23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100b26:	c9                   	leave  
f0100b27:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b28:	53                   	push   %ebx
f0100b29:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f0100b2f:	50                   	push   %eax
f0100b30:	68 40 03 00 00       	push   $0x340
f0100b35:	8d 81 9f d2 fe ff    	lea    -0x12d61(%ecx),%eax
f0100b3b:	50                   	push   %eax
f0100b3c:	89 cb                	mov    %ecx,%ebx
f0100b3e:	e8 56 f5 ff ff       	call   f0100099 <_panic>
		return ~0;
f0100b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100b48:	eb d9                	jmp    f0100b23 <check_va2pa+0x55>

f0100b4a <check_page_free_list>:
{
f0100b4a:	55                   	push   %ebp
f0100b4b:	89 e5                	mov    %esp,%ebp
f0100b4d:	57                   	push   %edi
f0100b4e:	56                   	push   %esi
f0100b4f:	53                   	push   %ebx
f0100b50:	83 ec 2c             	sub    $0x2c,%esp
f0100b53:	e8 a3 24 00 00       	call   f0102ffb <__x86.get_pc_thunk.di>
f0100b58:	81 c7 b4 67 01 00    	add    $0x167b4,%edi
f0100b5e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b61:	84 c0                	test   %al,%al
f0100b63:	0f 85 dc 02 00 00    	jne    f0100e45 <check_page_free_list+0x2fb>
	if (!page_free_list)
f0100b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100b6c:	83 b8 bc 1f 00 00 00 	cmpl   $0x0,0x1fbc(%eax)
f0100b73:	74 0a                	je     f0100b7f <check_page_free_list+0x35>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b75:	bf 00 04 00 00       	mov    $0x400,%edi
f0100b7a:	e9 29 03 00 00       	jmp    f0100ea8 <check_page_free_list+0x35e>
		panic("'page_free_list' is a null pointer!");
f0100b7f:	83 ec 04             	sub    $0x4,%esp
f0100b82:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100b85:	8d 83 a8 d5 fe ff    	lea    -0x12a58(%ebx),%eax
f0100b8b:	50                   	push   %eax
f0100b8c:	68 81 02 00 00       	push   $0x281
f0100b91:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100b97:	50                   	push   %eax
f0100b98:	e8 fc f4 ff ff       	call   f0100099 <_panic>
f0100b9d:	50                   	push   %eax
f0100b9e:	89 cb                	mov    %ecx,%ebx
f0100ba0:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f0100ba6:	50                   	push   %eax
f0100ba7:	6a 52                	push   $0x52
f0100ba9:	8d 81 ab d2 fe ff    	lea    -0x12d55(%ecx),%eax
f0100baf:	50                   	push   %eax
f0100bb0:	e8 e4 f4 ff ff       	call   f0100099 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bb5:	8b 36                	mov    (%esi),%esi
f0100bb7:	85 f6                	test   %esi,%esi
f0100bb9:	74 47                	je     f0100c02 <check_page_free_list+0xb8>
void	tlb_invalidate(pde_t *pgdir, void *va);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bbb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0100bbe:	89 f0                	mov    %esi,%eax
f0100bc0:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f0100bc6:	c1 f8 03             	sar    $0x3,%eax
f0100bc9:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100bcc:	89 c2                	mov    %eax,%edx
f0100bce:	c1 ea 16             	shr    $0x16,%edx
f0100bd1:	39 fa                	cmp    %edi,%edx
f0100bd3:	73 e0                	jae    f0100bb5 <check_page_free_list+0x6b>
	if (PGNUM(pa) >= npages)
f0100bd5:	89 c2                	mov    %eax,%edx
f0100bd7:	c1 ea 0c             	shr    $0xc,%edx
f0100bda:	3b 91 b4 1f 00 00    	cmp    0x1fb4(%ecx),%edx
f0100be0:	73 bb                	jae    f0100b9d <check_page_free_list+0x53>
			memset(page2kva(pp), 0x97, 128);
f0100be2:	83 ec 04             	sub    $0x4,%esp
f0100be5:	68 80 00 00 00       	push   $0x80
f0100bea:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100bef:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100bf4:	50                   	push   %eax
f0100bf5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100bf8:	e8 8a 30 00 00       	call   f0103c87 <memset>
f0100bfd:	83 c4 10             	add    $0x10,%esp
f0100c00:	eb b3                	jmp    f0100bb5 <check_page_free_list+0x6b>
	first_free_page = (char *) boot_alloc(0);
f0100c02:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c07:	e8 42 fe ff ff       	call   f0100a4e <boot_alloc>
f0100c0c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100c12:	8b 90 bc 1f 00 00    	mov    0x1fbc(%eax),%edx
		assert(pp >= pages);
f0100c18:	8b 88 ac 1f 00 00    	mov    0x1fac(%eax),%ecx
		assert(pp < pages + npages);
f0100c1e:	8b 80 b4 1f 00 00    	mov    0x1fb4(%eax),%eax
f0100c24:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100c27:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c2a:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100c34:	89 5d d0             	mov    %ebx,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c37:	e9 07 01 00 00       	jmp    f0100d43 <check_page_free_list+0x1f9>
		assert(pp >= pages);
f0100c3c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c3f:	8d 83 b9 d2 fe ff    	lea    -0x12d47(%ebx),%eax
f0100c45:	50                   	push   %eax
f0100c46:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100c4c:	50                   	push   %eax
f0100c4d:	68 9b 02 00 00       	push   $0x29b
f0100c52:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100c58:	50                   	push   %eax
f0100c59:	e8 3b f4 ff ff       	call   f0100099 <_panic>
		assert(pp < pages + npages);
f0100c5e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c61:	8d 83 da d2 fe ff    	lea    -0x12d26(%ebx),%eax
f0100c67:	50                   	push   %eax
f0100c68:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100c6e:	50                   	push   %eax
f0100c6f:	68 9c 02 00 00       	push   $0x29c
f0100c74:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100c7a:	50                   	push   %eax
f0100c7b:	e8 19 f4 ff ff       	call   f0100099 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c80:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c83:	8d 83 cc d5 fe ff    	lea    -0x12a34(%ebx),%eax
f0100c89:	50                   	push   %eax
f0100c8a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100c90:	50                   	push   %eax
f0100c91:	68 9d 02 00 00       	push   $0x29d
f0100c96:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100c9c:	50                   	push   %eax
f0100c9d:	e8 f7 f3 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != 0);
f0100ca2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ca5:	8d 83 ee d2 fe ff    	lea    -0x12d12(%ebx),%eax
f0100cab:	50                   	push   %eax
f0100cac:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100cb2:	50                   	push   %eax
f0100cb3:	68 a0 02 00 00       	push   $0x2a0
f0100cb8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100cbe:	50                   	push   %eax
f0100cbf:	e8 d5 f3 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cc4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100cc7:	8d 83 ff d2 fe ff    	lea    -0x12d01(%ebx),%eax
f0100ccd:	50                   	push   %eax
f0100cce:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100cd4:	50                   	push   %eax
f0100cd5:	68 a1 02 00 00       	push   $0x2a1
f0100cda:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100ce0:	50                   	push   %eax
f0100ce1:	e8 b3 f3 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ce6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ce9:	8d 83 00 d6 fe ff    	lea    -0x12a00(%ebx),%eax
f0100cef:	50                   	push   %eax
f0100cf0:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100cf6:	50                   	push   %eax
f0100cf7:	68 a2 02 00 00       	push   $0x2a2
f0100cfc:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100d02:	50                   	push   %eax
f0100d03:	e8 91 f3 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d08:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100d0b:	8d 83 18 d3 fe ff    	lea    -0x12ce8(%ebx),%eax
f0100d11:	50                   	push   %eax
f0100d12:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100d18:	50                   	push   %eax
f0100d19:	68 a3 02 00 00       	push   $0x2a3
f0100d1e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100d24:	50                   	push   %eax
f0100d25:	e8 6f f3 ff ff       	call   f0100099 <_panic>
	if (PGNUM(pa) >= npages)
f0100d2a:	89 c3                	mov    %eax,%ebx
f0100d2c:	c1 eb 0c             	shr    $0xc,%ebx
f0100d2f:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0100d32:	76 6d                	jbe    f0100da1 <check_page_free_list+0x257>
	return (void *)(pa + KERNBASE);
f0100d34:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d39:	39 45 c8             	cmp    %eax,-0x38(%ebp)
f0100d3c:	77 7c                	ja     f0100dba <check_page_free_list+0x270>
			++nfree_extmem;
f0100d3e:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d41:	8b 12                	mov    (%edx),%edx
f0100d43:	85 d2                	test   %edx,%edx
f0100d45:	0f 84 91 00 00 00    	je     f0100ddc <check_page_free_list+0x292>
		assert(pp >= pages);
f0100d4b:	39 d1                	cmp    %edx,%ecx
f0100d4d:	0f 87 e9 fe ff ff    	ja     f0100c3c <check_page_free_list+0xf2>
		assert(pp < pages + npages);
f0100d53:	39 d6                	cmp    %edx,%esi
f0100d55:	0f 86 03 ff ff ff    	jbe    f0100c5e <check_page_free_list+0x114>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d5b:	89 d0                	mov    %edx,%eax
f0100d5d:	29 c8                	sub    %ecx,%eax
f0100d5f:	a8 07                	test   $0x7,%al
f0100d61:	0f 85 19 ff ff ff    	jne    f0100c80 <check_page_free_list+0x136>
	return (pp - pages) << PGSHIFT;
f0100d67:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100d6a:	c1 e0 0c             	shl    $0xc,%eax
f0100d6d:	0f 84 2f ff ff ff    	je     f0100ca2 <check_page_free_list+0x158>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d73:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d78:	0f 84 46 ff ff ff    	je     f0100cc4 <check_page_free_list+0x17a>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d7e:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d83:	0f 84 5d ff ff ff    	je     f0100ce6 <check_page_free_list+0x19c>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d89:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d8e:	0f 84 74 ff ff ff    	je     f0100d08 <check_page_free_list+0x1be>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d94:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d99:	77 8f                	ja     f0100d2a <check_page_free_list+0x1e0>
			++nfree_basemem;
f0100d9b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f0100d9f:	eb a0                	jmp    f0100d41 <check_page_free_list+0x1f7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100da1:	50                   	push   %eax
f0100da2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100da5:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f0100dab:	50                   	push   %eax
f0100dac:	6a 52                	push   $0x52
f0100dae:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f0100db4:	50                   	push   %eax
f0100db5:	e8 df f2 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dba:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100dbd:	8d 83 24 d6 fe ff    	lea    -0x129dc(%ebx),%eax
f0100dc3:	50                   	push   %eax
f0100dc4:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100dca:	50                   	push   %eax
f0100dcb:	68 a4 02 00 00       	push   $0x2a4
f0100dd0:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100dd6:	50                   	push   %eax
f0100dd7:	e8 bd f2 ff ff       	call   f0100099 <_panic>
	assert(nfree_basemem > 0);
f0100ddc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0100ddf:	85 db                	test   %ebx,%ebx
f0100de1:	7e 1e                	jle    f0100e01 <check_page_free_list+0x2b7>
	assert(nfree_extmem > 0);
f0100de3:	85 ff                	test   %edi,%edi
f0100de5:	7e 3c                	jle    f0100e23 <check_page_free_list+0x2d9>
	cprintf("check_page_free_list() succeeded!\n");
f0100de7:	83 ec 0c             	sub    $0xc,%esp
f0100dea:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ded:	8d 83 6c d6 fe ff    	lea    -0x12994(%ebx),%eax
f0100df3:	50                   	push   %eax
f0100df4:	e8 8d 22 00 00       	call   f0103086 <cprintf>
}
f0100df9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dfc:	5b                   	pop    %ebx
f0100dfd:	5e                   	pop    %esi
f0100dfe:	5f                   	pop    %edi
f0100dff:	5d                   	pop    %ebp
f0100e00:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e01:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100e04:	8d 83 32 d3 fe ff    	lea    -0x12cce(%ebx),%eax
f0100e0a:	50                   	push   %eax
f0100e0b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100e11:	50                   	push   %eax
f0100e12:	68 ac 02 00 00       	push   $0x2ac
f0100e17:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100e1d:	50                   	push   %eax
f0100e1e:	e8 76 f2 ff ff       	call   f0100099 <_panic>
	assert(nfree_extmem > 0);
f0100e23:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100e26:	8d 83 44 d3 fe ff    	lea    -0x12cbc(%ebx),%eax
f0100e2c:	50                   	push   %eax
f0100e2d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0100e33:	50                   	push   %eax
f0100e34:	68 ad 02 00 00       	push   $0x2ad
f0100e39:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100e3f:	50                   	push   %eax
f0100e40:	e8 54 f2 ff ff       	call   f0100099 <_panic>
	if (!page_free_list)
f0100e45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e48:	8b 80 bc 1f 00 00    	mov    0x1fbc(%eax),%eax
f0100e4e:	85 c0                	test   %eax,%eax
f0100e50:	0f 84 29 fd ff ff    	je     f0100b7f <check_page_free_list+0x35>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e56:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e59:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e5c:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100e62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0100e65:	89 c2                	mov    %eax,%edx
f0100e67:	2b 97 ac 1f 00 00    	sub    0x1fac(%edi),%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e6d:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e73:	0f 95 c2             	setne  %dl
f0100e76:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e79:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e7d:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e7f:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e83:	8b 00                	mov    (%eax),%eax
f0100e85:	85 c0                	test   %eax,%eax
f0100e87:	75 d9                	jne    f0100e62 <check_page_free_list+0x318>
		*tp[1] = 0;
f0100e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e92:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e98:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e9d:	89 87 bc 1f 00 00    	mov    %eax,0x1fbc(%edi)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ea3:	bf 01 00 00 00       	mov    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100eab:	8b b0 bc 1f 00 00    	mov    0x1fbc(%eax),%esi
f0100eb1:	e9 01 fd ff ff       	jmp    f0100bb7 <check_page_free_list+0x6d>

f0100eb6 <page_init>:
{
f0100eb6:	55                   	push   %ebp
f0100eb7:	89 e5                	mov    %esp,%ebp
f0100eb9:	57                   	push   %edi
f0100eba:	56                   	push   %esi
f0100ebb:	53                   	push   %ebx
f0100ebc:	83 ec 0c             	sub    $0xc,%esp
f0100ebf:	e8 8b f2 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100ec4:	81 c3 48 64 01 00    	add    $0x16448,%ebx
	pages[0].pp_ref = 1;
f0100eca:	8b 83 ac 1f 00 00    	mov    0x1fac(%ebx),%eax
f0100ed0:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100ed6:	8b b3 c0 1f 00 00    	mov    0x1fc0(%ebx),%esi
f0100edc:	8b bb bc 1f 00 00    	mov    0x1fbc(%ebx),%edi
f0100ee2:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ee7:	b8 01 00 00 00       	mov    $0x1,%eax
f0100eec:	eb 27                	jmp    f0100f15 <page_init+0x5f>
f0100eee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100ef5:	89 d1                	mov    %edx,%ecx
f0100ef7:	03 8b ac 1f 00 00    	add    0x1fac(%ebx),%ecx
f0100efd:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f03:	89 39                	mov    %edi,(%ecx)
		page_free_list = &pages[i];
f0100f05:	89 d7                	mov    %edx,%edi
f0100f07:	03 bb ac 1f 00 00    	add    0x1fac(%ebx),%edi
	for (i = 1; i < npages_basemem; i++) {
f0100f0d:	83 c0 01             	add    $0x1,%eax
f0100f10:	ba 01 00 00 00       	mov    $0x1,%edx
f0100f15:	39 c6                	cmp    %eax,%esi
f0100f17:	77 d5                	ja     f0100eee <page_init+0x38>
f0100f19:	85 f6                	test   %esi,%esi
f0100f1b:	b9 01 00 00 00       	mov    $0x1,%ecx
f0100f20:	0f 45 ce             	cmovne %esi,%ecx
f0100f23:	84 d2                	test   %dl,%dl
f0100f25:	74 06                	je     f0100f2d <page_init+0x77>
f0100f27:	89 bb bc 1f 00 00    	mov    %edi,0x1fbc(%ebx)
		pages[i].pp_ref = 1;
f0100f2d:	8b 93 ac 1f 00 00    	mov    0x1fac(%ebx),%edx
f0100f33:	89 c8                	mov    %ecx,%eax
f0100f35:	eb 0a                	jmp    f0100f41 <page_init+0x8b>
f0100f37:	66 c7 44 c2 04 01 00 	movw   $0x1,0x4(%edx,%eax,8)
	for(; i < EXTPHYSMEM / PGSIZE; i++)
f0100f3e:	83 c0 01             	add    $0x1,%eax
f0100f41:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100f46:	76 ef                	jbe    f0100f37 <page_init+0x81>
f0100f48:	b8 00 01 00 00       	mov    $0x100,%eax
f0100f4d:	29 c8                	sub    %ecx,%eax
f0100f4f:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
f0100f55:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f5a:	0f 47 c2             	cmova  %edx,%eax
f0100f5d:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
	physaddr_t first_free_addr = PADDR(boot_alloc(0));
f0100f60:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f65:	e8 e4 fa ff ff       	call   f0100a4e <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100f6a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f6f:	76 16                	jbe    f0100f87 <page_init+0xd1>
	return (physaddr_t)kva - KERNBASE;
f0100f71:	05 00 00 00 10       	add    $0x10000000,%eax
	size_t first_free_page = first_free_addr / PGSIZE + 96 + npages_basemem;
f0100f76:	c1 e8 0c             	shr    $0xc,%eax
f0100f79:	8d 54 06 60          	lea    0x60(%esi,%eax,1),%edx
		pages[i].pp_ref = 1;
f0100f7d:	8b 8b ac 1f 00 00    	mov    0x1fac(%ebx),%ecx
	for(; i < first_free_page; i++)
f0100f83:	89 f8                	mov    %edi,%eax
f0100f85:	eb 23                	jmp    f0100faa <page_init+0xf4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f87:	50                   	push   %eax
f0100f88:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f0100f8e:	50                   	push   %eax
f0100f8f:	68 25 01 00 00       	push   $0x125
f0100f94:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0100f9a:	50                   	push   %eax
f0100f9b:	e8 f9 f0 ff ff       	call   f0100099 <_panic>
		pages[i].pp_ref = 1;
f0100fa0:	66 c7 44 c1 04 01 00 	movw   $0x1,0x4(%ecx,%eax,8)
	for(; i < first_free_page; i++)
f0100fa7:	83 c0 01             	add    $0x1,%eax
f0100faa:	39 d0                	cmp    %edx,%eax
f0100fac:	72 f2                	jb     f0100fa0 <page_init+0xea>
f0100fae:	89 d0                	mov    %edx,%eax
f0100fb0:	29 f8                	sub    %edi,%eax
f0100fb2:	39 fa                	cmp    %edi,%edx
f0100fb4:	ba 00 00 00 00       	mov    $0x0,%edx
f0100fb9:	0f 42 c2             	cmovb  %edx,%eax
f0100fbc:	01 f8                	add    %edi,%eax
f0100fbe:	8b b3 bc 1f 00 00    	mov    0x1fbc(%ebx),%esi
	for(;i < npages; i++)
f0100fc4:	bf 01 00 00 00       	mov    $0x1,%edi
f0100fc9:	eb 24                	jmp    f0100fef <page_init+0x139>
f0100fcb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100fd2:	89 d1                	mov    %edx,%ecx
f0100fd4:	03 8b ac 1f 00 00    	add    0x1fac(%ebx),%ecx
f0100fda:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100fe0:	89 31                	mov    %esi,(%ecx)
		page_free_list = &pages[i];
f0100fe2:	89 d6                	mov    %edx,%esi
f0100fe4:	03 b3 ac 1f 00 00    	add    0x1fac(%ebx),%esi
	for(;i < npages; i++)
f0100fea:	83 c0 01             	add    $0x1,%eax
f0100fed:	89 fa                	mov    %edi,%edx
f0100fef:	39 83 b4 1f 00 00    	cmp    %eax,0x1fb4(%ebx)
f0100ff5:	77 d4                	ja     f0100fcb <page_init+0x115>
f0100ff7:	84 d2                	test   %dl,%dl
f0100ff9:	74 06                	je     f0101001 <page_init+0x14b>
f0100ffb:	89 b3 bc 1f 00 00    	mov    %esi,0x1fbc(%ebx)
}
f0101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101004:	5b                   	pop    %ebx
f0101005:	5e                   	pop    %esi
f0101006:	5f                   	pop    %edi
f0101007:	5d                   	pop    %ebp
f0101008:	c3                   	ret    

f0101009 <page_alloc>:
{
f0101009:	55                   	push   %ebp
f010100a:	89 e5                	mov    %esp,%ebp
f010100c:	56                   	push   %esi
f010100d:	53                   	push   %ebx
f010100e:	e8 3c f1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0101013:	81 c3 f9 62 01 00    	add    $0x162f9,%ebx
	if(!page_free_list) {
f0101019:	8b b3 bc 1f 00 00    	mov    0x1fbc(%ebx),%esi
f010101f:	85 f6                	test   %esi,%esi
f0101021:	74 14                	je     f0101037 <page_alloc+0x2e>
	page_free_list = page_free_list->pp_link;
f0101023:	8b 06                	mov    (%esi),%eax
f0101025:	89 83 bc 1f 00 00    	mov    %eax,0x1fbc(%ebx)
	pp->pp_link = NULL;
f010102b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	if(alloc_flags & ALLOC_ZERO) {
f0101031:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101035:	75 09                	jne    f0101040 <page_alloc+0x37>
}
f0101037:	89 f0                	mov    %esi,%eax
f0101039:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010103c:	5b                   	pop    %ebx
f010103d:	5e                   	pop    %esi
f010103e:	5d                   	pop    %ebp
f010103f:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101040:	89 f0                	mov    %esi,%eax
f0101042:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0101048:	c1 f8 03             	sar    $0x3,%eax
f010104b:	89 c2                	mov    %eax,%edx
f010104d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101050:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101055:	3b 83 b4 1f 00 00    	cmp    0x1fb4(%ebx),%eax
f010105b:	73 1b                	jae    f0101078 <page_alloc+0x6f>
		memset(page2kva(pp), 0, PGSIZE);
f010105d:	83 ec 04             	sub    $0x4,%esp
f0101060:	68 00 10 00 00       	push   $0x1000
f0101065:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101067:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010106d:	52                   	push   %edx
f010106e:	e8 14 2c 00 00       	call   f0103c87 <memset>
f0101073:	83 c4 10             	add    $0x10,%esp
f0101076:	eb bf                	jmp    f0101037 <page_alloc+0x2e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101078:	52                   	push   %edx
f0101079:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f010107f:	50                   	push   %eax
f0101080:	6a 52                	push   $0x52
f0101082:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f0101088:	50                   	push   %eax
f0101089:	e8 0b f0 ff ff       	call   f0100099 <_panic>

f010108e <page_free>:
{
f010108e:	55                   	push   %ebp
f010108f:	89 e5                	mov    %esp,%ebp
f0101091:	53                   	push   %ebx
f0101092:	83 ec 04             	sub    $0x4,%esp
f0101095:	e8 b5 f0 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010109a:	81 c3 72 62 01 00    	add    $0x16272,%ebx
f01010a0:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_link != NULL || pp->pp_ref != 0)
f01010a3:	83 38 00             	cmpl   $0x0,(%eax)
f01010a6:	75 1a                	jne    f01010c2 <page_free+0x34>
f01010a8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01010ad:	75 13                	jne    f01010c2 <page_free+0x34>
	pp->pp_link = page_free_list;
f01010af:	8b 8b bc 1f 00 00    	mov    0x1fbc(%ebx),%ecx
f01010b5:	89 08                	mov    %ecx,(%eax)
	page_free_list = pp;
f01010b7:	89 83 bc 1f 00 00    	mov    %eax,0x1fbc(%ebx)
}
f01010bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01010c0:	c9                   	leave  
f01010c1:	c3                   	ret    
		panic("pp->pp_ref is zero or pp->pp_link is not NULL");
f01010c2:	83 ec 04             	sub    $0x4,%esp
f01010c5:	8d 83 b4 d6 fe ff    	lea    -0x1294c(%ebx),%eax
f01010cb:	50                   	push   %eax
f01010cc:	68 61 01 00 00       	push   $0x161
f01010d1:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01010d7:	50                   	push   %eax
f01010d8:	e8 bc ef ff ff       	call   f0100099 <_panic>

f01010dd <page_decref>:
{
f01010dd:	55                   	push   %ebp
f01010de:	89 e5                	mov    %esp,%ebp
f01010e0:	83 ec 08             	sub    $0x8,%esp
f01010e3:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01010e6:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010ea:	83 e8 01             	sub    $0x1,%eax
f01010ed:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010f1:	66 85 c0             	test   %ax,%ax
f01010f4:	74 02                	je     f01010f8 <page_decref+0x1b>
}
f01010f6:	c9                   	leave  
f01010f7:	c3                   	ret    
		page_free(pp);
f01010f8:	83 ec 0c             	sub    $0xc,%esp
f01010fb:	52                   	push   %edx
f01010fc:	e8 8d ff ff ff       	call   f010108e <page_free>
f0101101:	83 c4 10             	add    $0x10,%esp
}
f0101104:	eb f0                	jmp    f01010f6 <page_decref+0x19>

f0101106 <pgdir_walk>:
{
f0101106:	55                   	push   %ebp
f0101107:	89 e5                	mov    %esp,%ebp
f0101109:	57                   	push   %edi
f010110a:	56                   	push   %esi
f010110b:	53                   	push   %ebx
f010110c:	83 ec 0c             	sub    $0xc,%esp
f010110f:	e8 e7 1e 00 00       	call   f0102ffb <__x86.get_pc_thunk.di>
f0101114:	81 c7 f8 61 01 00    	add    $0x161f8,%edi
f010111a:	8b 75 0c             	mov    0xc(%ebp),%esi
    pde_t *pgdir_entry = pgdir + PDX(va);
f010111d:	89 f3                	mov    %esi,%ebx
f010111f:	c1 eb 16             	shr    $0x16,%ebx
f0101122:	c1 e3 02             	shl    $0x2,%ebx
f0101125:	03 5d 08             	add    0x8(%ebp),%ebx
    if (!(*pgdir_entry & PTE_P)) {
f0101128:	f6 03 01             	testb  $0x1,(%ebx)
f010112b:	75 2f                	jne    f010115c <pgdir_walk+0x56>
        if (!create)
f010112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101131:	74 71                	je     f01011a4 <pgdir_walk+0x9e>
            struct PageInfo *new_page = page_alloc(1);
f0101133:	83 ec 0c             	sub    $0xc,%esp
f0101136:	6a 01                	push   $0x1
f0101138:	e8 cc fe ff ff       	call   f0101009 <page_alloc>
            if (!new_page)
f010113d:	83 c4 10             	add    $0x10,%esp
f0101140:	85 c0                	test   %eax,%eax
f0101142:	74 3d                	je     f0101181 <pgdir_walk+0x7b>
	return (pp - pages) << PGSHIFT;
f0101144:	89 c2                	mov    %eax,%edx
f0101146:	2b 97 ac 1f 00 00    	sub    0x1fac(%edi),%edx
f010114c:	c1 fa 03             	sar    $0x3,%edx
f010114f:	c1 e2 0c             	shl    $0xc,%edx
            *pgdir_entry = (page2pa(new_page) | PTE_P | PTE_W | PTE_U);
f0101152:	83 ca 07             	or     $0x7,%edx
f0101155:	89 13                	mov    %edx,(%ebx)
            ++new_page->pp_ref;
f0101157:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    return (pte_t *)(KADDR(PTE_ADDR(*pgdir_entry))) + PTX(va);
f010115c:	8b 03                	mov    (%ebx),%eax
f010115e:	89 c2                	mov    %eax,%edx
f0101160:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101166:	c1 e8 0c             	shr    $0xc,%eax
f0101169:	3b 87 b4 1f 00 00    	cmp    0x1fb4(%edi),%eax
f010116f:	73 18                	jae    f0101189 <pgdir_walk+0x83>
f0101171:	c1 ee 0a             	shr    $0xa,%esi
f0101174:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f010117a:	8d 84 32 00 00 00 f0 	lea    -0x10000000(%edx,%esi,1),%eax
}
f0101181:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101184:	5b                   	pop    %ebx
f0101185:	5e                   	pop    %esi
f0101186:	5f                   	pop    %edi
f0101187:	5d                   	pop    %ebp
f0101188:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101189:	52                   	push   %edx
f010118a:	8d 87 84 d5 fe ff    	lea    -0x12a7c(%edi),%eax
f0101190:	50                   	push   %eax
f0101191:	68 af 01 00 00       	push   $0x1af
f0101196:	8d 87 9f d2 fe ff    	lea    -0x12d61(%edi),%eax
f010119c:	50                   	push   %eax
f010119d:	89 fb                	mov    %edi,%ebx
f010119f:	e8 f5 ee ff ff       	call   f0100099 <_panic>
            return NULL;
f01011a4:	b8 00 00 00 00       	mov    $0x0,%eax
f01011a9:	eb d6                	jmp    f0101181 <pgdir_walk+0x7b>

f01011ab <boot_map_region>:
{
f01011ab:	55                   	push   %ebp
f01011ac:	89 e5                	mov    %esp,%ebp
f01011ae:	57                   	push   %edi
f01011af:	56                   	push   %esi
f01011b0:	53                   	push   %ebx
f01011b1:	83 ec 1c             	sub    $0x1c,%esp
f01011b4:	89 c7                	mov    %eax,%edi
f01011b6:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01011b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE, va += PGSIZE, pa += PGSIZE) {
f01011bc:	be 00 00 00 00       	mov    $0x0,%esi
f01011c1:	eb 22                	jmp    f01011e5 <boot_map_region+0x3a>
        pgtable_entry = pgdir_walk(pgdir, (void *)va, 1);
f01011c3:	83 ec 04             	sub    $0x4,%esp
f01011c6:	6a 01                	push   $0x1
f01011c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011cb:	01 f0                	add    %esi,%eax
f01011cd:	50                   	push   %eax
f01011ce:	57                   	push   %edi
f01011cf:	e8 32 ff ff ff       	call   f0101106 <pgdir_walk>
        *pgtable_entry = (pa | perm | PTE_P);
f01011d4:	0b 5d 0c             	or     0xc(%ebp),%ebx
f01011d7:	83 cb 01             	or     $0x1,%ebx
f01011da:	89 18                	mov    %ebx,(%eax)
    for (offset = 0; offset < size; offset += PGSIZE, va += PGSIZE, pa += PGSIZE) {
f01011dc:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01011e2:	83 c4 10             	add    $0x10,%esp
f01011e5:	89 f3                	mov    %esi,%ebx
f01011e7:	03 5d 08             	add    0x8(%ebp),%ebx
f01011ea:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f01011ed:	77 d4                	ja     f01011c3 <boot_map_region+0x18>
}
f01011ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011f2:	5b                   	pop    %ebx
f01011f3:	5e                   	pop    %esi
f01011f4:	5f                   	pop    %edi
f01011f5:	5d                   	pop    %ebp
f01011f6:	c3                   	ret    

f01011f7 <page_lookup>:
{
f01011f7:	55                   	push   %ebp
f01011f8:	89 e5                	mov    %esp,%ebp
f01011fa:	56                   	push   %esi
f01011fb:	53                   	push   %ebx
f01011fc:	e8 4e ef ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0101201:	81 c3 0b 61 01 00    	add    $0x1610b,%ebx
f0101207:	8b 75 10             	mov    0x10(%ebp),%esi
	pte_t *pgtable_entry = pgdir_walk(pgdir, va, 0);
f010120a:	83 ec 04             	sub    $0x4,%esp
f010120d:	6a 00                	push   $0x0
f010120f:	ff 75 0c             	push   0xc(%ebp)
f0101212:	ff 75 08             	push   0x8(%ebp)
f0101215:	e8 ec fe ff ff       	call   f0101106 <pgdir_walk>
    if (!pgtable_entry || !(*pgtable_entry & PTE_P))
f010121a:	83 c4 10             	add    $0x10,%esp
f010121d:	85 c0                	test   %eax,%eax
f010121f:	74 21                	je     f0101242 <page_lookup+0x4b>
f0101221:	f6 00 01             	testb  $0x1,(%eax)
f0101224:	74 3b                	je     f0101261 <page_lookup+0x6a>
    if (pte_store)
f0101226:	85 f6                	test   %esi,%esi
f0101228:	74 02                	je     f010122c <page_lookup+0x35>
        *pte_store = pgtable_entry;
f010122a:	89 06                	mov    %eax,(%esi)
f010122c:	8b 00                	mov    (%eax),%eax
f010122e:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101231:	39 83 b4 1f 00 00    	cmp    %eax,0x1fb4(%ebx)
f0101237:	76 10                	jbe    f0101249 <page_lookup+0x52>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101239:	8b 93 ac 1f 00 00    	mov    0x1fac(%ebx),%edx
f010123f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101242:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101245:	5b                   	pop    %ebx
f0101246:	5e                   	pop    %esi
f0101247:	5d                   	pop    %ebp
f0101248:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101249:	83 ec 04             	sub    $0x4,%esp
f010124c:	8d 83 e4 d6 fe ff    	lea    -0x1291c(%ebx),%eax
f0101252:	50                   	push   %eax
f0101253:	6a 4b                	push   $0x4b
f0101255:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f010125b:	50                   	push   %eax
f010125c:	e8 38 ee ff ff       	call   f0100099 <_panic>
        return NULL;
f0101261:	b8 00 00 00 00       	mov    $0x0,%eax
f0101266:	eb da                	jmp    f0101242 <page_lookup+0x4b>

f0101268 <page_remove>:
{
f0101268:	55                   	push   %ebp
f0101269:	89 e5                	mov    %esp,%ebp
f010126b:	53                   	push   %ebx
f010126c:	83 ec 18             	sub    $0x18,%esp
f010126f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    struct PageInfo *page = page_lookup(pgdir, va, &pgtable_entry);
f0101272:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101275:	50                   	push   %eax
f0101276:	53                   	push   %ebx
f0101277:	ff 75 08             	push   0x8(%ebp)
f010127a:	e8 78 ff ff ff       	call   f01011f7 <page_lookup>
    if (!page)
f010127f:	83 c4 10             	add    $0x10,%esp
f0101282:	85 c0                	test   %eax,%eax
f0101284:	74 18                	je     f010129e <page_remove+0x36>
    page_decref(page);
f0101286:	83 ec 0c             	sub    $0xc,%esp
f0101289:	50                   	push   %eax
f010128a:	e8 4e fe ff ff       	call   f01010dd <page_decref>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010128f:	0f 01 3b             	invlpg (%ebx)
    *pgtable_entry = 0;
f0101292:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101295:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010129b:	83 c4 10             	add    $0x10,%esp
}
f010129e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012a1:	c9                   	leave  
f01012a2:	c3                   	ret    

f01012a3 <page_insert>:
{
f01012a3:	55                   	push   %ebp
f01012a4:	89 e5                	mov    %esp,%ebp
f01012a6:	57                   	push   %edi
f01012a7:	56                   	push   %esi
f01012a8:	53                   	push   %ebx
f01012a9:	83 ec 10             	sub    $0x10,%esp
f01012ac:	e8 4a 1d 00 00       	call   f0102ffb <__x86.get_pc_thunk.di>
f01012b1:	81 c7 5b 60 01 00    	add    $0x1605b,%edi
f01012b7:	8b 75 08             	mov    0x8(%ebp),%esi
pte_t *pgtable_entry = pgdir_walk(pgdir, va, 1);
f01012ba:	6a 01                	push   $0x1
f01012bc:	ff 75 10             	push   0x10(%ebp)
f01012bf:	56                   	push   %esi
f01012c0:	e8 41 fe ff ff       	call   f0101106 <pgdir_walk>
    if (!pgtable_entry)
f01012c5:	83 c4 10             	add    $0x10,%esp
f01012c8:	85 c0                	test   %eax,%eax
f01012ca:	74 56                	je     f0101322 <page_insert+0x7f>
f01012cc:	89 c3                	mov    %eax,%ebx
    ++pp->pp_ref;
f01012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012d1:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    if ((*pgtable_entry) & PTE_P) {
f01012d6:	f6 03 01             	testb  $0x1,(%ebx)
f01012d9:	75 30                	jne    f010130b <page_insert+0x68>
	return (pp - pages) << PGSHIFT;
f01012db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012de:	2b 87 ac 1f 00 00    	sub    0x1fac(%edi),%eax
f01012e4:	c1 f8 03             	sar    $0x3,%eax
f01012e7:	c1 e0 0c             	shl    $0xc,%eax
    *pgtable_entry = (page2pa(pp) | perm | PTE_P);
f01012ea:	0b 45 14             	or     0x14(%ebp),%eax
f01012ed:	83 c8 01             	or     $0x1,%eax
f01012f0:	89 03                	mov    %eax,(%ebx)
    *(pgdir + PDX(va)) |= perm;
f01012f2:	8b 45 10             	mov    0x10(%ebp),%eax
f01012f5:	c1 e8 16             	shr    $0x16,%eax
f01012f8:	8b 55 14             	mov    0x14(%ebp),%edx
f01012fb:	09 14 86             	or     %edx,(%esi,%eax,4)
    return 0;
f01012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101303:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101306:	5b                   	pop    %ebx
f0101307:	5e                   	pop    %esi
f0101308:	5f                   	pop    %edi
f0101309:	5d                   	pop    %ebp
f010130a:	c3                   	ret    
f010130b:	8b 45 10             	mov    0x10(%ebp),%eax
f010130e:	0f 01 38             	invlpg (%eax)
        page_remove(pgdir, va);
f0101311:	83 ec 08             	sub    $0x8,%esp
f0101314:	ff 75 10             	push   0x10(%ebp)
f0101317:	56                   	push   %esi
f0101318:	e8 4b ff ff ff       	call   f0101268 <page_remove>
f010131d:	83 c4 10             	add    $0x10,%esp
f0101320:	eb b9                	jmp    f01012db <page_insert+0x38>
        return -E_NO_MEM;
f0101322:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101327:	eb da                	jmp    f0101303 <page_insert+0x60>

f0101329 <mem_init>:
{
f0101329:	55                   	push   %ebp
f010132a:	89 e5                	mov    %esp,%ebp
f010132c:	57                   	push   %edi
f010132d:	56                   	push   %esi
f010132e:	53                   	push   %ebx
f010132f:	83 ec 3c             	sub    $0x3c,%esp
f0101332:	e8 aa f3 ff ff       	call   f01006e1 <__x86.get_pc_thunk.ax>
f0101337:	05 d5 5f 01 00       	add    $0x15fd5,%eax
f010133c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	basemem = nvram_read(NVRAM_BASELO);
f010133f:	b8 15 00 00 00       	mov    $0x15,%eax
f0101344:	e8 cf f6 ff ff       	call   f0100a18 <nvram_read>
f0101349:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f010134b:	b8 17 00 00 00       	mov    $0x17,%eax
f0101350:	e8 c3 f6 ff ff       	call   f0100a18 <nvram_read>
f0101355:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101357:	b8 34 00 00 00       	mov    $0x34,%eax
f010135c:	e8 b7 f6 ff ff       	call   f0100a18 <nvram_read>
	if (ext16mem)
f0101361:	c1 e0 06             	shl    $0x6,%eax
f0101364:	0f 84 cb 00 00 00    	je     f0101435 <mem_init+0x10c>
		totalmem = 16 * 1024 + ext16mem;
f010136a:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010136f:	89 c2                	mov    %eax,%edx
f0101371:	c1 ea 02             	shr    $0x2,%edx
f0101374:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101377:	89 91 b4 1f 00 00    	mov    %edx,0x1fb4(%ecx)
	npages_basemem = basemem / (PGSIZE / 1024);
f010137d:	89 da                	mov    %ebx,%edx
f010137f:	c1 ea 02             	shr    $0x2,%edx
f0101382:	89 91 c0 1f 00 00    	mov    %edx,0x1fc0(%ecx)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101388:	89 c2                	mov    %eax,%edx
f010138a:	29 da                	sub    %ebx,%edx
f010138c:	52                   	push   %edx
f010138d:	53                   	push   %ebx
f010138e:	50                   	push   %eax
f010138f:	8d 81 04 d7 fe ff    	lea    -0x128fc(%ecx),%eax
f0101395:	50                   	push   %eax
f0101396:	89 cb                	mov    %ecx,%ebx
f0101398:	e8 e9 1c 00 00       	call   f0103086 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f010139d:	b8 00 10 00 00       	mov    $0x1000,%eax
f01013a2:	e8 a7 f6 ff ff       	call   f0100a4e <boot_alloc>
f01013a7:	89 83 b0 1f 00 00    	mov    %eax,0x1fb0(%ebx)
	memset(kern_pgdir, 0, PGSIZE);
f01013ad:	83 c4 0c             	add    $0xc,%esp
f01013b0:	68 00 10 00 00       	push   $0x1000
f01013b5:	6a 00                	push   $0x0
f01013b7:	50                   	push   %eax
f01013b8:	e8 ca 28 00 00       	call   f0103c87 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01013bd:	8b 83 b0 1f 00 00    	mov    0x1fb0(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01013c3:	83 c4 10             	add    $0x10,%esp
f01013c6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013cb:	76 78                	jbe    f0101445 <mem_init+0x11c>
	return (physaddr_t)kva - KERNBASE;
f01013cd:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01013d3:	83 ca 05             	or     $0x5,%edx
f01013d6:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f01013dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01013df:	8b 87 b4 1f 00 00    	mov    0x1fb4(%edi),%eax
f01013e5:	c1 e0 03             	shl    $0x3,%eax
f01013e8:	e8 61 f6 ff ff       	call   f0100a4e <boot_alloc>
f01013ed:	89 87 ac 1f 00 00    	mov    %eax,0x1fac(%edi)
	memset(pages, 0, npages * sizeof(struct PageInfo));
f01013f3:	83 ec 04             	sub    $0x4,%esp
f01013f6:	8b 97 b4 1f 00 00    	mov    0x1fb4(%edi),%edx
f01013fc:	c1 e2 03             	shl    $0x3,%edx
f01013ff:	52                   	push   %edx
f0101400:	6a 00                	push   $0x0
f0101402:	50                   	push   %eax
f0101403:	89 fb                	mov    %edi,%ebx
f0101405:	e8 7d 28 00 00       	call   f0103c87 <memset>
	page_init();
f010140a:	e8 a7 fa ff ff       	call   f0100eb6 <page_init>
	check_page_free_list(1);
f010140f:	b8 01 00 00 00       	mov    $0x1,%eax
f0101414:	e8 31 f7 ff ff       	call   f0100b4a <check_page_free_list>
	if (!pages)
f0101419:	83 c4 10             	add    $0x10,%esp
f010141c:	83 bf ac 1f 00 00 00 	cmpl   $0x0,0x1fac(%edi)
f0101423:	74 3c                	je     f0101461 <mem_init+0x138>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101425:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101428:	8b 80 bc 1f 00 00    	mov    0x1fbc(%eax),%eax
f010142e:	be 00 00 00 00       	mov    $0x0,%esi
f0101433:	eb 4f                	jmp    f0101484 <mem_init+0x15b>
		totalmem = 1 * 1024 + extmem;
f0101435:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010143b:	85 f6                	test   %esi,%esi
f010143d:	0f 44 c3             	cmove  %ebx,%eax
f0101440:	e9 2a ff ff ff       	jmp    f010136f <mem_init+0x46>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101445:	50                   	push   %eax
f0101446:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101449:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f010144f:	50                   	push   %eax
f0101450:	68 9d 00 00 00       	push   $0x9d
f0101455:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010145b:	50                   	push   %eax
f010145c:	e8 38 ec ff ff       	call   f0100099 <_panic>
		panic("'pages' is a null pointer!");
f0101461:	83 ec 04             	sub    $0x4,%esp
f0101464:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101467:	8d 83 55 d3 fe ff    	lea    -0x12cab(%ebx),%eax
f010146d:	50                   	push   %eax
f010146e:	68 c0 02 00 00       	push   $0x2c0
f0101473:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101479:	50                   	push   %eax
f010147a:	e8 1a ec ff ff       	call   f0100099 <_panic>
		++nfree;
f010147f:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101482:	8b 00                	mov    (%eax),%eax
f0101484:	85 c0                	test   %eax,%eax
f0101486:	75 f7                	jne    f010147f <mem_init+0x156>
	assert((pp0 = page_alloc(0)));
f0101488:	83 ec 0c             	sub    $0xc,%esp
f010148b:	6a 00                	push   $0x0
f010148d:	e8 77 fb ff ff       	call   f0101009 <page_alloc>
f0101492:	89 c3                	mov    %eax,%ebx
f0101494:	83 c4 10             	add    $0x10,%esp
f0101497:	85 c0                	test   %eax,%eax
f0101499:	0f 84 3a 02 00 00    	je     f01016d9 <mem_init+0x3b0>
	assert((pp1 = page_alloc(0)));
f010149f:	83 ec 0c             	sub    $0xc,%esp
f01014a2:	6a 00                	push   $0x0
f01014a4:	e8 60 fb ff ff       	call   f0101009 <page_alloc>
f01014a9:	89 c7                	mov    %eax,%edi
f01014ab:	83 c4 10             	add    $0x10,%esp
f01014ae:	85 c0                	test   %eax,%eax
f01014b0:	0f 84 45 02 00 00    	je     f01016fb <mem_init+0x3d2>
	assert((pp2 = page_alloc(0)));
f01014b6:	83 ec 0c             	sub    $0xc,%esp
f01014b9:	6a 00                	push   $0x0
f01014bb:	e8 49 fb ff ff       	call   f0101009 <page_alloc>
f01014c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01014c3:	83 c4 10             	add    $0x10,%esp
f01014c6:	85 c0                	test   %eax,%eax
f01014c8:	0f 84 4f 02 00 00    	je     f010171d <mem_init+0x3f4>
	assert(pp1 && pp1 != pp0);
f01014ce:	39 fb                	cmp    %edi,%ebx
f01014d0:	0f 84 69 02 00 00    	je     f010173f <mem_init+0x416>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01014d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01014d9:	39 c7                	cmp    %eax,%edi
f01014db:	0f 84 80 02 00 00    	je     f0101761 <mem_init+0x438>
f01014e1:	39 c3                	cmp    %eax,%ebx
f01014e3:	0f 84 78 02 00 00    	je     f0101761 <mem_init+0x438>
	return (pp - pages) << PGSHIFT;
f01014e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014ec:	8b 88 ac 1f 00 00    	mov    0x1fac(%eax),%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01014f2:	8b 90 b4 1f 00 00    	mov    0x1fb4(%eax),%edx
f01014f8:	c1 e2 0c             	shl    $0xc,%edx
f01014fb:	89 d8                	mov    %ebx,%eax
f01014fd:	29 c8                	sub    %ecx,%eax
f01014ff:	c1 f8 03             	sar    $0x3,%eax
f0101502:	c1 e0 0c             	shl    $0xc,%eax
f0101505:	39 d0                	cmp    %edx,%eax
f0101507:	0f 83 76 02 00 00    	jae    f0101783 <mem_init+0x45a>
f010150d:	89 f8                	mov    %edi,%eax
f010150f:	29 c8                	sub    %ecx,%eax
f0101511:	c1 f8 03             	sar    $0x3,%eax
f0101514:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101517:	39 c2                	cmp    %eax,%edx
f0101519:	0f 86 86 02 00 00    	jbe    f01017a5 <mem_init+0x47c>
f010151f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101522:	29 c8                	sub    %ecx,%eax
f0101524:	c1 f8 03             	sar    $0x3,%eax
f0101527:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010152a:	39 c2                	cmp    %eax,%edx
f010152c:	0f 86 95 02 00 00    	jbe    f01017c7 <mem_init+0x49e>
	fl = page_free_list;
f0101532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101535:	8b 88 bc 1f 00 00    	mov    0x1fbc(%eax),%ecx
f010153b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f010153e:	c7 80 bc 1f 00 00 00 	movl   $0x0,0x1fbc(%eax)
f0101545:	00 00 00 
	assert(!page_alloc(0));
f0101548:	83 ec 0c             	sub    $0xc,%esp
f010154b:	6a 00                	push   $0x0
f010154d:	e8 b7 fa ff ff       	call   f0101009 <page_alloc>
f0101552:	83 c4 10             	add    $0x10,%esp
f0101555:	85 c0                	test   %eax,%eax
f0101557:	0f 85 8c 02 00 00    	jne    f01017e9 <mem_init+0x4c0>
	page_free(pp0);
f010155d:	83 ec 0c             	sub    $0xc,%esp
f0101560:	53                   	push   %ebx
f0101561:	e8 28 fb ff ff       	call   f010108e <page_free>
	page_free(pp1);
f0101566:	89 3c 24             	mov    %edi,(%esp)
f0101569:	e8 20 fb ff ff       	call   f010108e <page_free>
	page_free(pp2);
f010156e:	83 c4 04             	add    $0x4,%esp
f0101571:	ff 75 d0             	push   -0x30(%ebp)
f0101574:	e8 15 fb ff ff       	call   f010108e <page_free>
	assert((pp0 = page_alloc(0)));
f0101579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101580:	e8 84 fa ff ff       	call   f0101009 <page_alloc>
f0101585:	89 c7                	mov    %eax,%edi
f0101587:	83 c4 10             	add    $0x10,%esp
f010158a:	85 c0                	test   %eax,%eax
f010158c:	0f 84 79 02 00 00    	je     f010180b <mem_init+0x4e2>
	assert((pp1 = page_alloc(0)));
f0101592:	83 ec 0c             	sub    $0xc,%esp
f0101595:	6a 00                	push   $0x0
f0101597:	e8 6d fa ff ff       	call   f0101009 <page_alloc>
f010159c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010159f:	83 c4 10             	add    $0x10,%esp
f01015a2:	85 c0                	test   %eax,%eax
f01015a4:	0f 84 83 02 00 00    	je     f010182d <mem_init+0x504>
	assert((pp2 = page_alloc(0)));
f01015aa:	83 ec 0c             	sub    $0xc,%esp
f01015ad:	6a 00                	push   $0x0
f01015af:	e8 55 fa ff ff       	call   f0101009 <page_alloc>
f01015b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01015b7:	83 c4 10             	add    $0x10,%esp
f01015ba:	85 c0                	test   %eax,%eax
f01015bc:	0f 84 8d 02 00 00    	je     f010184f <mem_init+0x526>
	assert(pp1 && pp1 != pp0);
f01015c2:	3b 7d d0             	cmp    -0x30(%ebp),%edi
f01015c5:	0f 84 a6 02 00 00    	je     f0101871 <mem_init+0x548>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01015ce:	39 c7                	cmp    %eax,%edi
f01015d0:	0f 84 bd 02 00 00    	je     f0101893 <mem_init+0x56a>
f01015d6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01015d9:	0f 84 b4 02 00 00    	je     f0101893 <mem_init+0x56a>
	assert(!page_alloc(0));
f01015df:	83 ec 0c             	sub    $0xc,%esp
f01015e2:	6a 00                	push   $0x0
f01015e4:	e8 20 fa ff ff       	call   f0101009 <page_alloc>
f01015e9:	83 c4 10             	add    $0x10,%esp
f01015ec:	85 c0                	test   %eax,%eax
f01015ee:	0f 85 c1 02 00 00    	jne    f01018b5 <mem_init+0x58c>
f01015f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01015f7:	89 f8                	mov    %edi,%eax
f01015f9:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f01015ff:	c1 f8 03             	sar    $0x3,%eax
f0101602:	89 c2                	mov    %eax,%edx
f0101604:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101607:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010160c:	3b 81 b4 1f 00 00    	cmp    0x1fb4(%ecx),%eax
f0101612:	0f 83 bf 02 00 00    	jae    f01018d7 <mem_init+0x5ae>
	memset(page2kva(pp0), 1, PGSIZE);
f0101618:	83 ec 04             	sub    $0x4,%esp
f010161b:	68 00 10 00 00       	push   $0x1000
f0101620:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101622:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101628:	52                   	push   %edx
f0101629:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010162c:	e8 56 26 00 00       	call   f0103c87 <memset>
	page_free(pp0);
f0101631:	89 3c 24             	mov    %edi,(%esp)
f0101634:	e8 55 fa ff ff       	call   f010108e <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101639:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101640:	e8 c4 f9 ff ff       	call   f0101009 <page_alloc>
f0101645:	83 c4 10             	add    $0x10,%esp
f0101648:	85 c0                	test   %eax,%eax
f010164a:	0f 84 9f 02 00 00    	je     f01018ef <mem_init+0x5c6>
	assert(pp && pp0 == pp);
f0101650:	39 c7                	cmp    %eax,%edi
f0101652:	0f 85 b9 02 00 00    	jne    f0101911 <mem_init+0x5e8>
	return (pp - pages) << PGSHIFT;
f0101658:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010165b:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f0101661:	c1 f8 03             	sar    $0x3,%eax
f0101664:	89 c2                	mov    %eax,%edx
f0101666:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101669:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010166e:	3b 81 b4 1f 00 00    	cmp    0x1fb4(%ecx),%eax
f0101674:	0f 83 b9 02 00 00    	jae    f0101933 <mem_init+0x60a>
	return (void *)(pa + KERNBASE);
f010167a:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101680:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f0101686:	80 38 00             	cmpb   $0x0,(%eax)
f0101689:	0f 85 bc 02 00 00    	jne    f010194b <mem_init+0x622>
	for (i = 0; i < PGSIZE; i++)
f010168f:	83 c0 01             	add    $0x1,%eax
f0101692:	39 c2                	cmp    %eax,%edx
f0101694:	75 f0                	jne    f0101686 <mem_init+0x35d>
	page_free_list = fl;
f0101696:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101699:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010169c:	89 8b bc 1f 00 00    	mov    %ecx,0x1fbc(%ebx)
	page_free(pp0);
f01016a2:	83 ec 0c             	sub    $0xc,%esp
f01016a5:	57                   	push   %edi
f01016a6:	e8 e3 f9 ff ff       	call   f010108e <page_free>
	page_free(pp1);
f01016ab:	83 c4 04             	add    $0x4,%esp
f01016ae:	ff 75 d0             	push   -0x30(%ebp)
f01016b1:	e8 d8 f9 ff ff       	call   f010108e <page_free>
	page_free(pp2);
f01016b6:	83 c4 04             	add    $0x4,%esp
f01016b9:	ff 75 cc             	push   -0x34(%ebp)
f01016bc:	e8 cd f9 ff ff       	call   f010108e <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01016c1:	8b 83 bc 1f 00 00    	mov    0x1fbc(%ebx),%eax
f01016c7:	83 c4 10             	add    $0x10,%esp
f01016ca:	85 c0                	test   %eax,%eax
f01016cc:	0f 84 9b 02 00 00    	je     f010196d <mem_init+0x644>
		--nfree;
f01016d2:	83 ee 01             	sub    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01016d5:	8b 00                	mov    (%eax),%eax
f01016d7:	eb f1                	jmp    f01016ca <mem_init+0x3a1>
	assert((pp0 = page_alloc(0)));
f01016d9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016dc:	8d 83 70 d3 fe ff    	lea    -0x12c90(%ebx),%eax
f01016e2:	50                   	push   %eax
f01016e3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01016e9:	50                   	push   %eax
f01016ea:	68 c8 02 00 00       	push   $0x2c8
f01016ef:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01016f5:	50                   	push   %eax
f01016f6:	e8 9e e9 ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f01016fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016fe:	8d 83 86 d3 fe ff    	lea    -0x12c7a(%ebx),%eax
f0101704:	50                   	push   %eax
f0101705:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010170b:	50                   	push   %eax
f010170c:	68 c9 02 00 00       	push   $0x2c9
f0101711:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101717:	50                   	push   %eax
f0101718:	e8 7c e9 ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f010171d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101720:	8d 83 9c d3 fe ff    	lea    -0x12c64(%ebx),%eax
f0101726:	50                   	push   %eax
f0101727:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010172d:	50                   	push   %eax
f010172e:	68 ca 02 00 00       	push   $0x2ca
f0101733:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101739:	50                   	push   %eax
f010173a:	e8 5a e9 ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f010173f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101742:	8d 83 b2 d3 fe ff    	lea    -0x12c4e(%ebx),%eax
f0101748:	50                   	push   %eax
f0101749:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010174f:	50                   	push   %eax
f0101750:	68 cd 02 00 00       	push   $0x2cd
f0101755:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010175b:	50                   	push   %eax
f010175c:	e8 38 e9 ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101761:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101764:	8d 83 40 d7 fe ff    	lea    -0x128c0(%ebx),%eax
f010176a:	50                   	push   %eax
f010176b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101771:	50                   	push   %eax
f0101772:	68 ce 02 00 00       	push   $0x2ce
f0101777:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010177d:	50                   	push   %eax
f010177e:	e8 16 e9 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101783:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101786:	8d 83 c4 d3 fe ff    	lea    -0x12c3c(%ebx),%eax
f010178c:	50                   	push   %eax
f010178d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101793:	50                   	push   %eax
f0101794:	68 cf 02 00 00       	push   $0x2cf
f0101799:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010179f:	50                   	push   %eax
f01017a0:	e8 f4 e8 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01017a5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017a8:	8d 83 e1 d3 fe ff    	lea    -0x12c1f(%ebx),%eax
f01017ae:	50                   	push   %eax
f01017af:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01017b5:	50                   	push   %eax
f01017b6:	68 d0 02 00 00       	push   $0x2d0
f01017bb:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01017c1:	50                   	push   %eax
f01017c2:	e8 d2 e8 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f01017c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ca:	8d 83 fe d3 fe ff    	lea    -0x12c02(%ebx),%eax
f01017d0:	50                   	push   %eax
f01017d1:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01017d7:	50                   	push   %eax
f01017d8:	68 d1 02 00 00       	push   $0x2d1
f01017dd:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01017e3:	50                   	push   %eax
f01017e4:	e8 b0 e8 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f01017e9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ec:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f01017f2:	50                   	push   %eax
f01017f3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01017f9:	50                   	push   %eax
f01017fa:	68 d8 02 00 00       	push   $0x2d8
f01017ff:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101805:	50                   	push   %eax
f0101806:	e8 8e e8 ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f010180b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010180e:	8d 83 70 d3 fe ff    	lea    -0x12c90(%ebx),%eax
f0101814:	50                   	push   %eax
f0101815:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010181b:	50                   	push   %eax
f010181c:	68 df 02 00 00       	push   $0x2df
f0101821:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101827:	50                   	push   %eax
f0101828:	e8 6c e8 ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f010182d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101830:	8d 83 86 d3 fe ff    	lea    -0x12c7a(%ebx),%eax
f0101836:	50                   	push   %eax
f0101837:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010183d:	50                   	push   %eax
f010183e:	68 e0 02 00 00       	push   $0x2e0
f0101843:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101849:	50                   	push   %eax
f010184a:	e8 4a e8 ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f010184f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101852:	8d 83 9c d3 fe ff    	lea    -0x12c64(%ebx),%eax
f0101858:	50                   	push   %eax
f0101859:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010185f:	50                   	push   %eax
f0101860:	68 e1 02 00 00       	push   $0x2e1
f0101865:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010186b:	50                   	push   %eax
f010186c:	e8 28 e8 ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f0101871:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101874:	8d 83 b2 d3 fe ff    	lea    -0x12c4e(%ebx),%eax
f010187a:	50                   	push   %eax
f010187b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101881:	50                   	push   %eax
f0101882:	68 e3 02 00 00       	push   $0x2e3
f0101887:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010188d:	50                   	push   %eax
f010188e:	e8 06 e8 ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101893:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101896:	8d 83 40 d7 fe ff    	lea    -0x128c0(%ebx),%eax
f010189c:	50                   	push   %eax
f010189d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01018a3:	50                   	push   %eax
f01018a4:	68 e4 02 00 00       	push   $0x2e4
f01018a9:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01018af:	50                   	push   %eax
f01018b0:	e8 e4 e7 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f01018b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018b8:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f01018be:	50                   	push   %eax
f01018bf:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01018c5:	50                   	push   %eax
f01018c6:	68 e5 02 00 00       	push   $0x2e5
f01018cb:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01018d1:	50                   	push   %eax
f01018d2:	e8 c2 e7 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01018d7:	52                   	push   %edx
f01018d8:	89 cb                	mov    %ecx,%ebx
f01018da:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f01018e0:	50                   	push   %eax
f01018e1:	6a 52                	push   $0x52
f01018e3:	8d 81 ab d2 fe ff    	lea    -0x12d55(%ecx),%eax
f01018e9:	50                   	push   %eax
f01018ea:	e8 aa e7 ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01018ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018f2:	8d 83 2a d4 fe ff    	lea    -0x12bd6(%ebx),%eax
f01018f8:	50                   	push   %eax
f01018f9:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01018ff:	50                   	push   %eax
f0101900:	68 ea 02 00 00       	push   $0x2ea
f0101905:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010190b:	50                   	push   %eax
f010190c:	e8 88 e7 ff ff       	call   f0100099 <_panic>
	assert(pp && pp0 == pp);
f0101911:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101914:	8d 83 48 d4 fe ff    	lea    -0x12bb8(%ebx),%eax
f010191a:	50                   	push   %eax
f010191b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101921:	50                   	push   %eax
f0101922:	68 eb 02 00 00       	push   $0x2eb
f0101927:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010192d:	50                   	push   %eax
f010192e:	e8 66 e7 ff ff       	call   f0100099 <_panic>
f0101933:	52                   	push   %edx
f0101934:	89 cb                	mov    %ecx,%ebx
f0101936:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f010193c:	50                   	push   %eax
f010193d:	6a 52                	push   $0x52
f010193f:	8d 81 ab d2 fe ff    	lea    -0x12d55(%ecx),%eax
f0101945:	50                   	push   %eax
f0101946:	e8 4e e7 ff ff       	call   f0100099 <_panic>
		assert(c[i] == 0);
f010194b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010194e:	8d 83 58 d4 fe ff    	lea    -0x12ba8(%ebx),%eax
f0101954:	50                   	push   %eax
f0101955:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010195b:	50                   	push   %eax
f010195c:	68 ee 02 00 00       	push   $0x2ee
f0101961:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0101967:	50                   	push   %eax
f0101968:	e8 2c e7 ff ff       	call   f0100099 <_panic>
	assert(nfree == 0);
f010196d:	85 f6                	test   %esi,%esi
f010196f:	0f 85 2b 08 00 00    	jne    f01021a0 <mem_init+0xe77>
	cprintf("check_page_alloc() succeeded!\n");
f0101975:	83 ec 0c             	sub    $0xc,%esp
f0101978:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010197b:	8d 83 60 d7 fe ff    	lea    -0x128a0(%ebx),%eax
f0101981:	50                   	push   %eax
f0101982:	e8 ff 16 00 00       	call   f0103086 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101987:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010198e:	e8 76 f6 ff ff       	call   f0101009 <page_alloc>
f0101993:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101996:	83 c4 10             	add    $0x10,%esp
f0101999:	85 c0                	test   %eax,%eax
f010199b:	0f 84 21 08 00 00    	je     f01021c2 <mem_init+0xe99>
	assert((pp1 = page_alloc(0)));
f01019a1:	83 ec 0c             	sub    $0xc,%esp
f01019a4:	6a 00                	push   $0x0
f01019a6:	e8 5e f6 ff ff       	call   f0101009 <page_alloc>
f01019ab:	89 c7                	mov    %eax,%edi
f01019ad:	83 c4 10             	add    $0x10,%esp
f01019b0:	85 c0                	test   %eax,%eax
f01019b2:	0f 84 2c 08 00 00    	je     f01021e4 <mem_init+0xebb>
	assert((pp2 = page_alloc(0)));
f01019b8:	83 ec 0c             	sub    $0xc,%esp
f01019bb:	6a 00                	push   $0x0
f01019bd:	e8 47 f6 ff ff       	call   f0101009 <page_alloc>
f01019c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01019c5:	83 c4 10             	add    $0x10,%esp
f01019c8:	85 c0                	test   %eax,%eax
f01019ca:	0f 84 36 08 00 00    	je     f0102206 <mem_init+0xedd>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01019d0:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f01019d3:	0f 84 4f 08 00 00    	je     f0102228 <mem_init+0xeff>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019dc:	39 c7                	cmp    %eax,%edi
f01019de:	0f 84 66 08 00 00    	je     f010224a <mem_init+0xf21>
f01019e4:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01019e7:	0f 84 5d 08 00 00    	je     f010224a <mem_init+0xf21>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01019ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019f0:	8b 88 bc 1f 00 00    	mov    0x1fbc(%eax),%ecx
f01019f6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f01019f9:	c7 80 bc 1f 00 00 00 	movl   $0x0,0x1fbc(%eax)
f0101a00:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101a03:	83 ec 0c             	sub    $0xc,%esp
f0101a06:	6a 00                	push   $0x0
f0101a08:	e8 fc f5 ff ff       	call   f0101009 <page_alloc>
f0101a0d:	83 c4 10             	add    $0x10,%esp
f0101a10:	85 c0                	test   %eax,%eax
f0101a12:	0f 85 54 08 00 00    	jne    f010226c <mem_init+0xf43>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101a18:	83 ec 04             	sub    $0x4,%esp
f0101a1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a1e:	50                   	push   %eax
f0101a1f:	6a 00                	push   $0x0
f0101a21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a24:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101a2a:	e8 c8 f7 ff ff       	call   f01011f7 <page_lookup>
f0101a2f:	83 c4 10             	add    $0x10,%esp
f0101a32:	85 c0                	test   %eax,%eax
f0101a34:	0f 85 54 08 00 00    	jne    f010228e <mem_init+0xf65>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a3a:	6a 02                	push   $0x2
f0101a3c:	6a 00                	push   $0x0
f0101a3e:	57                   	push   %edi
f0101a3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a42:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101a48:	e8 56 f8 ff ff       	call   f01012a3 <page_insert>
f0101a4d:	83 c4 10             	add    $0x10,%esp
f0101a50:	85 c0                	test   %eax,%eax
f0101a52:	0f 89 58 08 00 00    	jns    f01022b0 <mem_init+0xf87>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a58:	83 ec 0c             	sub    $0xc,%esp
f0101a5b:	ff 75 cc             	push   -0x34(%ebp)
f0101a5e:	e8 2b f6 ff ff       	call   f010108e <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a63:	6a 02                	push   $0x2
f0101a65:	6a 00                	push   $0x0
f0101a67:	57                   	push   %edi
f0101a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a6b:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101a71:	e8 2d f8 ff ff       	call   f01012a3 <page_insert>
f0101a76:	83 c4 20             	add    $0x20,%esp
f0101a79:	85 c0                	test   %eax,%eax
f0101a7b:	0f 85 51 08 00 00    	jne    f01022d2 <mem_init+0xfa9>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101a81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a84:	8b 98 b0 1f 00 00    	mov    0x1fb0(%eax),%ebx
	return (pp - pages) << PGSHIFT;
f0101a8a:	8b b0 ac 1f 00 00    	mov    0x1fac(%eax),%esi
f0101a90:	8b 13                	mov    (%ebx),%edx
f0101a92:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101a98:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101a9b:	29 f0                	sub    %esi,%eax
f0101a9d:	c1 f8 03             	sar    $0x3,%eax
f0101aa0:	c1 e0 0c             	shl    $0xc,%eax
f0101aa3:	39 c2                	cmp    %eax,%edx
f0101aa5:	0f 85 49 08 00 00    	jne    f01022f4 <mem_init+0xfcb>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101aab:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ab0:	89 d8                	mov    %ebx,%eax
f0101ab2:	e8 17 f0 ff ff       	call   f0100ace <check_va2pa>
f0101ab7:	89 c2                	mov    %eax,%edx
f0101ab9:	89 f8                	mov    %edi,%eax
f0101abb:	29 f0                	sub    %esi,%eax
f0101abd:	c1 f8 03             	sar    $0x3,%eax
f0101ac0:	c1 e0 0c             	shl    $0xc,%eax
f0101ac3:	39 c2                	cmp    %eax,%edx
f0101ac5:	0f 85 4b 08 00 00    	jne    f0102316 <mem_init+0xfed>
	assert(pp1->pp_ref == 1);
f0101acb:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101ad0:	0f 85 62 08 00 00    	jne    f0102338 <mem_init+0x100f>
	assert(pp0->pp_ref == 1);
f0101ad6:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101ad9:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ade:	0f 85 76 08 00 00    	jne    f010235a <mem_init+0x1031>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ae4:	6a 02                	push   $0x2
f0101ae6:	68 00 10 00 00       	push   $0x1000
f0101aeb:	ff 75 d0             	push   -0x30(%ebp)
f0101aee:	53                   	push   %ebx
f0101aef:	e8 af f7 ff ff       	call   f01012a3 <page_insert>
f0101af4:	83 c4 10             	add    $0x10,%esp
f0101af7:	85 c0                	test   %eax,%eax
f0101af9:	0f 85 7d 08 00 00    	jne    f010237c <mem_init+0x1053>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101aff:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b04:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101b07:	8b 83 b0 1f 00 00    	mov    0x1fb0(%ebx),%eax
f0101b0d:	e8 bc ef ff ff       	call   f0100ace <check_va2pa>
f0101b12:	89 c2                	mov    %eax,%edx
f0101b14:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b17:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0101b1d:	c1 f8 03             	sar    $0x3,%eax
f0101b20:	c1 e0 0c             	shl    $0xc,%eax
f0101b23:	39 c2                	cmp    %eax,%edx
f0101b25:	0f 85 73 08 00 00    	jne    f010239e <mem_init+0x1075>
	assert(pp2->pp_ref == 1);
f0101b2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b2e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101b33:	0f 85 87 08 00 00    	jne    f01023c0 <mem_init+0x1097>

	// should be no free memory
	assert(!page_alloc(0));
f0101b39:	83 ec 0c             	sub    $0xc,%esp
f0101b3c:	6a 00                	push   $0x0
f0101b3e:	e8 c6 f4 ff ff       	call   f0101009 <page_alloc>
f0101b43:	83 c4 10             	add    $0x10,%esp
f0101b46:	85 c0                	test   %eax,%eax
f0101b48:	0f 85 94 08 00 00    	jne    f01023e2 <mem_init+0x10b9>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b4e:	6a 02                	push   $0x2
f0101b50:	68 00 10 00 00       	push   $0x1000
f0101b55:	ff 75 d0             	push   -0x30(%ebp)
f0101b58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b5b:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101b61:	e8 3d f7 ff ff       	call   f01012a3 <page_insert>
f0101b66:	83 c4 10             	add    $0x10,%esp
f0101b69:	85 c0                	test   %eax,%eax
f0101b6b:	0f 85 93 08 00 00    	jne    f0102404 <mem_init+0x10db>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b71:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b76:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101b79:	8b 83 b0 1f 00 00    	mov    0x1fb0(%ebx),%eax
f0101b7f:	e8 4a ef ff ff       	call   f0100ace <check_va2pa>
f0101b84:	89 c2                	mov    %eax,%edx
f0101b86:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b89:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0101b8f:	c1 f8 03             	sar    $0x3,%eax
f0101b92:	c1 e0 0c             	shl    $0xc,%eax
f0101b95:	39 c2                	cmp    %eax,%edx
f0101b97:	0f 85 89 08 00 00    	jne    f0102426 <mem_init+0x10fd>
	assert(pp2->pp_ref == 1);
f0101b9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ba0:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ba5:	0f 85 9d 08 00 00    	jne    f0102448 <mem_init+0x111f>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101bab:	83 ec 0c             	sub    $0xc,%esp
f0101bae:	6a 00                	push   $0x0
f0101bb0:	e8 54 f4 ff ff       	call   f0101009 <page_alloc>
f0101bb5:	83 c4 10             	add    $0x10,%esp
f0101bb8:	85 c0                	test   %eax,%eax
f0101bba:	0f 85 aa 08 00 00    	jne    f010246a <mem_init+0x1141>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101bc0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101bc3:	8b 91 b0 1f 00 00    	mov    0x1fb0(%ecx),%edx
f0101bc9:	8b 02                	mov    (%edx),%eax
f0101bcb:	89 c3                	mov    %eax,%ebx
f0101bcd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f0101bd3:	c1 e8 0c             	shr    $0xc,%eax
f0101bd6:	3b 81 b4 1f 00 00    	cmp    0x1fb4(%ecx),%eax
f0101bdc:	0f 83 aa 08 00 00    	jae    f010248c <mem_init+0x1163>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101be2:	83 ec 04             	sub    $0x4,%esp
f0101be5:	6a 00                	push   $0x0
f0101be7:	68 00 10 00 00       	push   $0x1000
f0101bec:	52                   	push   %edx
f0101bed:	e8 14 f5 ff ff       	call   f0101106 <pgdir_walk>
f0101bf2:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101bf8:	83 c4 10             	add    $0x10,%esp
f0101bfb:	39 d8                	cmp    %ebx,%eax
f0101bfd:	0f 85 a4 08 00 00    	jne    f01024a7 <mem_init+0x117e>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101c03:	6a 06                	push   $0x6
f0101c05:	68 00 10 00 00       	push   $0x1000
f0101c0a:	ff 75 d0             	push   -0x30(%ebp)
f0101c0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c10:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101c16:	e8 88 f6 ff ff       	call   f01012a3 <page_insert>
f0101c1b:	83 c4 10             	add    $0x10,%esp
f0101c1e:	85 c0                	test   %eax,%eax
f0101c20:	0f 85 a3 08 00 00    	jne    f01024c9 <mem_init+0x11a0>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c26:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101c29:	8b 9e b0 1f 00 00    	mov    0x1fb0(%esi),%ebx
f0101c2f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c34:	89 d8                	mov    %ebx,%eax
f0101c36:	e8 93 ee ff ff       	call   f0100ace <check_va2pa>
f0101c3b:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101c3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c40:	2b 86 ac 1f 00 00    	sub    0x1fac(%esi),%eax
f0101c46:	c1 f8 03             	sar    $0x3,%eax
f0101c49:	c1 e0 0c             	shl    $0xc,%eax
f0101c4c:	39 c2                	cmp    %eax,%edx
f0101c4e:	0f 85 97 08 00 00    	jne    f01024eb <mem_init+0x11c2>
	assert(pp2->pp_ref == 1);
f0101c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c57:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c5c:	0f 85 ab 08 00 00    	jne    f010250d <mem_init+0x11e4>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c62:	83 ec 04             	sub    $0x4,%esp
f0101c65:	6a 00                	push   $0x0
f0101c67:	68 00 10 00 00       	push   $0x1000
f0101c6c:	53                   	push   %ebx
f0101c6d:	e8 94 f4 ff ff       	call   f0101106 <pgdir_walk>
f0101c72:	83 c4 10             	add    $0x10,%esp
f0101c75:	f6 00 04             	testb  $0x4,(%eax)
f0101c78:	0f 84 b1 08 00 00    	je     f010252f <mem_init+0x1206>
	assert(kern_pgdir[0] & PTE_U);
f0101c7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c81:	8b 80 b0 1f 00 00    	mov    0x1fb0(%eax),%eax
f0101c87:	f6 00 04             	testb  $0x4,(%eax)
f0101c8a:	0f 84 c1 08 00 00    	je     f0102551 <mem_init+0x1228>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c90:	6a 02                	push   $0x2
f0101c92:	68 00 10 00 00       	push   $0x1000
f0101c97:	ff 75 d0             	push   -0x30(%ebp)
f0101c9a:	50                   	push   %eax
f0101c9b:	e8 03 f6 ff ff       	call   f01012a3 <page_insert>
f0101ca0:	83 c4 10             	add    $0x10,%esp
f0101ca3:	85 c0                	test   %eax,%eax
f0101ca5:	0f 85 c8 08 00 00    	jne    f0102573 <mem_init+0x124a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101cab:	83 ec 04             	sub    $0x4,%esp
f0101cae:	6a 00                	push   $0x0
f0101cb0:	68 00 10 00 00       	push   $0x1000
f0101cb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101cb8:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101cbe:	e8 43 f4 ff ff       	call   f0101106 <pgdir_walk>
f0101cc3:	83 c4 10             	add    $0x10,%esp
f0101cc6:	f6 00 02             	testb  $0x2,(%eax)
f0101cc9:	0f 84 c6 08 00 00    	je     f0102595 <mem_init+0x126c>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101ccf:	83 ec 04             	sub    $0x4,%esp
f0101cd2:	6a 00                	push   $0x0
f0101cd4:	68 00 10 00 00       	push   $0x1000
f0101cd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101cdc:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101ce2:	e8 1f f4 ff ff       	call   f0101106 <pgdir_walk>
f0101ce7:	83 c4 10             	add    $0x10,%esp
f0101cea:	f6 00 04             	testb  $0x4,(%eax)
f0101ced:	0f 85 c4 08 00 00    	jne    f01025b7 <mem_init+0x128e>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101cf3:	6a 02                	push   $0x2
f0101cf5:	68 00 00 40 00       	push   $0x400000
f0101cfa:	ff 75 cc             	push   -0x34(%ebp)
f0101cfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d00:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101d06:	e8 98 f5 ff ff       	call   f01012a3 <page_insert>
f0101d0b:	83 c4 10             	add    $0x10,%esp
f0101d0e:	85 c0                	test   %eax,%eax
f0101d10:	0f 89 c3 08 00 00    	jns    f01025d9 <mem_init+0x12b0>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101d16:	6a 02                	push   $0x2
f0101d18:	68 00 10 00 00       	push   $0x1000
f0101d1d:	57                   	push   %edi
f0101d1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d21:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101d27:	e8 77 f5 ff ff       	call   f01012a3 <page_insert>
f0101d2c:	83 c4 10             	add    $0x10,%esp
f0101d2f:	85 c0                	test   %eax,%eax
f0101d31:	0f 85 c4 08 00 00    	jne    f01025fb <mem_init+0x12d2>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d37:	83 ec 04             	sub    $0x4,%esp
f0101d3a:	6a 00                	push   $0x0
f0101d3c:	68 00 10 00 00       	push   $0x1000
f0101d41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d44:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0101d4a:	e8 b7 f3 ff ff       	call   f0101106 <pgdir_walk>
f0101d4f:	83 c4 10             	add    $0x10,%esp
f0101d52:	f6 00 04             	testb  $0x4,(%eax)
f0101d55:	0f 85 c2 08 00 00    	jne    f010261d <mem_init+0x12f4>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101d5b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101d5e:	8b b3 b0 1f 00 00    	mov    0x1fb0(%ebx),%esi
f0101d64:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d69:	89 f0                	mov    %esi,%eax
f0101d6b:	e8 5e ed ff ff       	call   f0100ace <check_va2pa>
f0101d70:	89 d9                	mov    %ebx,%ecx
f0101d72:	89 fb                	mov    %edi,%ebx
f0101d74:	2b 99 ac 1f 00 00    	sub    0x1fac(%ecx),%ebx
f0101d7a:	c1 fb 03             	sar    $0x3,%ebx
f0101d7d:	c1 e3 0c             	shl    $0xc,%ebx
f0101d80:	39 d8                	cmp    %ebx,%eax
f0101d82:	0f 85 b7 08 00 00    	jne    f010263f <mem_init+0x1316>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d88:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d8d:	89 f0                	mov    %esi,%eax
f0101d8f:	e8 3a ed ff ff       	call   f0100ace <check_va2pa>
f0101d94:	39 c3                	cmp    %eax,%ebx
f0101d96:	0f 85 c5 08 00 00    	jne    f0102661 <mem_init+0x1338>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d9c:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101da1:	0f 85 dc 08 00 00    	jne    f0102683 <mem_init+0x135a>
	assert(pp2->pp_ref == 0);
f0101da7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101daa:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101daf:	0f 85 f0 08 00 00    	jne    f01026a5 <mem_init+0x137c>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101db5:	83 ec 0c             	sub    $0xc,%esp
f0101db8:	6a 00                	push   $0x0
f0101dba:	e8 4a f2 ff ff       	call   f0101009 <page_alloc>
f0101dbf:	83 c4 10             	add    $0x10,%esp
f0101dc2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101dc5:	0f 85 fc 08 00 00    	jne    f01026c7 <mem_init+0x139e>
f0101dcb:	85 c0                	test   %eax,%eax
f0101dcd:	0f 84 f4 08 00 00    	je     f01026c7 <mem_init+0x139e>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101dd3:	83 ec 08             	sub    $0x8,%esp
f0101dd6:	6a 00                	push   $0x0
f0101dd8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101ddb:	ff b3 b0 1f 00 00    	push   0x1fb0(%ebx)
f0101de1:	e8 82 f4 ff ff       	call   f0101268 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101de6:	8b 9b b0 1f 00 00    	mov    0x1fb0(%ebx),%ebx
f0101dec:	ba 00 00 00 00       	mov    $0x0,%edx
f0101df1:	89 d8                	mov    %ebx,%eax
f0101df3:	e8 d6 ec ff ff       	call   f0100ace <check_va2pa>
f0101df8:	83 c4 10             	add    $0x10,%esp
f0101dfb:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101dfe:	0f 85 e5 08 00 00    	jne    f01026e9 <mem_init+0x13c0>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e04:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e09:	89 d8                	mov    %ebx,%eax
f0101e0b:	e8 be ec ff ff       	call   f0100ace <check_va2pa>
f0101e10:	89 c2                	mov    %eax,%edx
f0101e12:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101e15:	89 f8                	mov    %edi,%eax
f0101e17:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f0101e1d:	c1 f8 03             	sar    $0x3,%eax
f0101e20:	c1 e0 0c             	shl    $0xc,%eax
f0101e23:	39 c2                	cmp    %eax,%edx
f0101e25:	0f 85 e0 08 00 00    	jne    f010270b <mem_init+0x13e2>
	assert(pp1->pp_ref == 1);
f0101e2b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e30:	0f 85 f6 08 00 00    	jne    f010272c <mem_init+0x1403>
	assert(pp2->pp_ref == 0);
f0101e36:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101e39:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101e3e:	0f 85 0a 09 00 00    	jne    f010274e <mem_init+0x1425>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101e44:	6a 00                	push   $0x0
f0101e46:	68 00 10 00 00       	push   $0x1000
f0101e4b:	57                   	push   %edi
f0101e4c:	53                   	push   %ebx
f0101e4d:	e8 51 f4 ff ff       	call   f01012a3 <page_insert>
f0101e52:	83 c4 10             	add    $0x10,%esp
f0101e55:	85 c0                	test   %eax,%eax
f0101e57:	0f 85 13 09 00 00    	jne    f0102770 <mem_init+0x1447>
	assert(pp1->pp_ref);
f0101e5d:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e62:	0f 84 2a 09 00 00    	je     f0102792 <mem_init+0x1469>
	assert(pp1->pp_link == NULL);
f0101e68:	83 3f 00             	cmpl   $0x0,(%edi)
f0101e6b:	0f 85 43 09 00 00    	jne    f01027b4 <mem_init+0x148b>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101e71:	83 ec 08             	sub    $0x8,%esp
f0101e74:	68 00 10 00 00       	push   $0x1000
f0101e79:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101e7c:	ff b3 b0 1f 00 00    	push   0x1fb0(%ebx)
f0101e82:	e8 e1 f3 ff ff       	call   f0101268 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e87:	8b 9b b0 1f 00 00    	mov    0x1fb0(%ebx),%ebx
f0101e8d:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e92:	89 d8                	mov    %ebx,%eax
f0101e94:	e8 35 ec ff ff       	call   f0100ace <check_va2pa>
f0101e99:	83 c4 10             	add    $0x10,%esp
f0101e9c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e9f:	0f 85 31 09 00 00    	jne    f01027d6 <mem_init+0x14ad>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101ea5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101eaa:	89 d8                	mov    %ebx,%eax
f0101eac:	e8 1d ec ff ff       	call   f0100ace <check_va2pa>
f0101eb1:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101eb4:	0f 85 3e 09 00 00    	jne    f01027f8 <mem_init+0x14cf>
	assert(pp1->pp_ref == 0);
f0101eba:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101ebf:	0f 85 55 09 00 00    	jne    f010281a <mem_init+0x14f1>
	assert(pp2->pp_ref == 0);
f0101ec5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ec8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101ecd:	0f 85 69 09 00 00    	jne    f010283c <mem_init+0x1513>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101ed3:	83 ec 0c             	sub    $0xc,%esp
f0101ed6:	6a 00                	push   $0x0
f0101ed8:	e8 2c f1 ff ff       	call   f0101009 <page_alloc>
f0101edd:	83 c4 10             	add    $0x10,%esp
f0101ee0:	85 c0                	test   %eax,%eax
f0101ee2:	0f 84 76 09 00 00    	je     f010285e <mem_init+0x1535>
f0101ee8:	39 c7                	cmp    %eax,%edi
f0101eea:	0f 85 6e 09 00 00    	jne    f010285e <mem_init+0x1535>

	// should be no free memory
	assert(!page_alloc(0));
f0101ef0:	83 ec 0c             	sub    $0xc,%esp
f0101ef3:	6a 00                	push   $0x0
f0101ef5:	e8 0f f1 ff ff       	call   f0101009 <page_alloc>
f0101efa:	83 c4 10             	add    $0x10,%esp
f0101efd:	85 c0                	test   %eax,%eax
f0101eff:	0f 85 7b 09 00 00    	jne    f0102880 <mem_init+0x1557>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f08:	8b 88 b0 1f 00 00    	mov    0x1fb0(%eax),%ecx
f0101f0e:	8b 11                	mov    (%ecx),%edx
f0101f10:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f16:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101f19:	2b 98 ac 1f 00 00    	sub    0x1fac(%eax),%ebx
f0101f1f:	89 d8                	mov    %ebx,%eax
f0101f21:	c1 f8 03             	sar    $0x3,%eax
f0101f24:	c1 e0 0c             	shl    $0xc,%eax
f0101f27:	39 c2                	cmp    %eax,%edx
f0101f29:	0f 85 73 09 00 00    	jne    f01028a2 <mem_init+0x1579>
	kern_pgdir[0] = 0;
f0101f2f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101f38:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f3d:	0f 85 81 09 00 00    	jne    f01028c4 <mem_init+0x159b>
	pp0->pp_ref = 0;
f0101f43:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101f46:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101f4c:	83 ec 0c             	sub    $0xc,%esp
f0101f4f:	50                   	push   %eax
f0101f50:	e8 39 f1 ff ff       	call   f010108e <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101f55:	83 c4 0c             	add    $0xc,%esp
f0101f58:	6a 01                	push   $0x1
f0101f5a:	68 00 10 40 00       	push   $0x401000
f0101f5f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101f62:	ff b3 b0 1f 00 00    	push   0x1fb0(%ebx)
f0101f68:	e8 99 f1 ff ff       	call   f0101106 <pgdir_walk>
f0101f6d:	89 c6                	mov    %eax,%esi
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101f6f:	89 d9                	mov    %ebx,%ecx
f0101f71:	8b 9b b0 1f 00 00    	mov    0x1fb0(%ebx),%ebx
f0101f77:	8b 43 04             	mov    0x4(%ebx),%eax
f0101f7a:	89 c2                	mov    %eax,%edx
f0101f7c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101f82:	8b 89 b4 1f 00 00    	mov    0x1fb4(%ecx),%ecx
f0101f88:	c1 e8 0c             	shr    $0xc,%eax
f0101f8b:	83 c4 10             	add    $0x10,%esp
f0101f8e:	39 c8                	cmp    %ecx,%eax
f0101f90:	0f 83 50 09 00 00    	jae    f01028e6 <mem_init+0x15bd>
	assert(ptep == ptep1 + PTX(va));
f0101f96:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0101f9c:	39 d6                	cmp    %edx,%esi
f0101f9e:	0f 85 5e 09 00 00    	jne    f0102902 <mem_init+0x15d9>
	kern_pgdir[PDX(va)] = 0;
f0101fa4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	pp0->pp_ref = 0;
f0101fab:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101fae:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101fb4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101fb7:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0101fbd:	c1 f8 03             	sar    $0x3,%eax
f0101fc0:	89 c2                	mov    %eax,%edx
f0101fc2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101fc5:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101fca:	39 c1                	cmp    %eax,%ecx
f0101fcc:	0f 86 52 09 00 00    	jbe    f0102924 <mem_init+0x15fb>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101fd2:	83 ec 04             	sub    $0x4,%esp
f0101fd5:	68 00 10 00 00       	push   $0x1000
f0101fda:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101fdf:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101fe5:	52                   	push   %edx
f0101fe6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101fe9:	e8 99 1c 00 00       	call   f0103c87 <memset>
	page_free(pp0);
f0101fee:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0101ff1:	89 34 24             	mov    %esi,(%esp)
f0101ff4:	e8 95 f0 ff ff       	call   f010108e <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101ff9:	83 c4 0c             	add    $0xc,%esp
f0101ffc:	6a 01                	push   $0x1
f0101ffe:	6a 00                	push   $0x0
f0102000:	ff b3 b0 1f 00 00    	push   0x1fb0(%ebx)
f0102006:	e8 fb f0 ff ff       	call   f0101106 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f010200b:	89 f0                	mov    %esi,%eax
f010200d:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0102013:	c1 f8 03             	sar    $0x3,%eax
f0102016:	89 c2                	mov    %eax,%edx
f0102018:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010201b:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102020:	83 c4 10             	add    $0x10,%esp
f0102023:	3b 83 b4 1f 00 00    	cmp    0x1fb4(%ebx),%eax
f0102029:	0f 83 0b 09 00 00    	jae    f010293a <mem_init+0x1611>
	return (void *)(pa + KERNBASE);
f010202f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0102035:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010203b:	8b 30                	mov    (%eax),%esi
f010203d:	83 e6 01             	and    $0x1,%esi
f0102040:	0f 85 0d 09 00 00    	jne    f0102953 <mem_init+0x162a>
	for(i=0; i<NPTENTRIES; i++)
f0102046:	83 c0 04             	add    $0x4,%eax
f0102049:	39 d0                	cmp    %edx,%eax
f010204b:	75 ee                	jne    f010203b <mem_init+0xd12>
	kern_pgdir[0] = 0;
f010204d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102050:	8b 83 b0 1f 00 00    	mov    0x1fb0(%ebx),%eax
f0102056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010205c:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010205f:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102065:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0102068:	89 93 bc 1f 00 00    	mov    %edx,0x1fbc(%ebx)

	// free the pages we took
	page_free(pp0);
f010206e:	83 ec 0c             	sub    $0xc,%esp
f0102071:	50                   	push   %eax
f0102072:	e8 17 f0 ff ff       	call   f010108e <page_free>
	page_free(pp1);
f0102077:	89 3c 24             	mov    %edi,(%esp)
f010207a:	e8 0f f0 ff ff       	call   f010108e <page_free>
	page_free(pp2);
f010207f:	83 c4 04             	add    $0x4,%esp
f0102082:	ff 75 d0             	push   -0x30(%ebp)
f0102085:	e8 04 f0 ff ff       	call   f010108e <page_free>

	cprintf("check_page() succeeded!\n");
f010208a:	8d 83 39 d5 fe ff    	lea    -0x12ac7(%ebx),%eax
f0102090:	89 04 24             	mov    %eax,(%esp)
f0102093:	e8 ee 0f 00 00       	call   f0103086 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102098:	8b 83 ac 1f 00 00    	mov    0x1fac(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010209e:	83 c4 10             	add    $0x10,%esp
f01020a1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020a6:	0f 86 c9 08 00 00    	jbe    f0102975 <mem_init+0x164c>
f01020ac:	83 ec 08             	sub    $0x8,%esp
f01020af:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01020b1:	05 00 00 00 10       	add    $0x10000000,%eax
f01020b6:	50                   	push   %eax
f01020b7:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01020bc:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01020c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01020c4:	8b 87 b0 1f 00 00    	mov    0x1fb0(%edi),%eax
f01020ca:	e8 dc f0 ff ff       	call   f01011ab <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01020cf:	c7 c0 00 e0 10 f0    	mov    $0xf010e000,%eax
f01020d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01020d8:	83 c4 10             	add    $0x10,%esp
f01020db:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020e0:	0f 86 ab 08 00 00    	jbe    f0102991 <mem_init+0x1668>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01020e6:	83 ec 08             	sub    $0x8,%esp
f01020e9:	6a 02                	push   $0x2
	return (physaddr_t)kva - KERNBASE;
f01020eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01020ee:	05 00 00 00 10       	add    $0x10000000,%eax
f01020f3:	50                   	push   %eax
f01020f4:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01020f9:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01020fe:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102101:	8b 87 b0 1f 00 00    	mov    0x1fb0(%edi),%eax
f0102107:	e8 9f f0 ff ff       	call   f01011ab <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE, (physaddr_t)0, PTE_W);
f010210c:	83 c4 08             	add    $0x8,%esp
f010210f:	6a 02                	push   $0x2
f0102111:	6a 00                	push   $0x0
f0102113:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0102118:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010211d:	8b 87 b0 1f 00 00    	mov    0x1fb0(%edi),%eax
f0102123:	e8 83 f0 ff ff       	call   f01011ab <boot_map_region>
	pgdir = kern_pgdir;
f0102128:	89 f9                	mov    %edi,%ecx
f010212a:	8b bf b0 1f 00 00    	mov    0x1fb0(%edi),%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102130:	8b 81 b4 1f 00 00    	mov    0x1fb4(%ecx),%eax
f0102136:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102139:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102140:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102145:	89 c2                	mov    %eax,%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102147:	8b 81 ac 1f 00 00    	mov    0x1fac(%ecx),%eax
f010214d:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102150:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
f0102156:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102159:	83 c4 10             	add    $0x10,%esp
f010215c:	89 f3                	mov    %esi,%ebx
f010215e:	89 7d d0             	mov    %edi,-0x30(%ebp)
f0102161:	89 c7                	mov    %eax,%edi
f0102163:	89 75 c0             	mov    %esi,-0x40(%ebp)
f0102166:	89 d6                	mov    %edx,%esi
f0102168:	39 de                	cmp    %ebx,%esi
f010216a:	0f 86 82 08 00 00    	jbe    f01029f2 <mem_init+0x16c9>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102170:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102176:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102179:	e8 50 e9 ff ff       	call   f0100ace <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010217e:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102184:	0f 86 28 08 00 00    	jbe    f01029b2 <mem_init+0x1689>
f010218a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010218d:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102190:	39 d0                	cmp    %edx,%eax
f0102192:	0f 85 38 08 00 00    	jne    f01029d0 <mem_init+0x16a7>
	for (i = 0; i < n; i += PGSIZE)
f0102198:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010219e:	eb c8                	jmp    f0102168 <mem_init+0xe3f>
	assert(nfree == 0);
f01021a0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021a3:	8d 83 62 d4 fe ff    	lea    -0x12b9e(%ebx),%eax
f01021a9:	50                   	push   %eax
f01021aa:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01021b0:	50                   	push   %eax
f01021b1:	68 fb 02 00 00       	push   $0x2fb
f01021b6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01021bc:	50                   	push   %eax
f01021bd:	e8 d7 de ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f01021c2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021c5:	8d 83 70 d3 fe ff    	lea    -0x12c90(%ebx),%eax
f01021cb:	50                   	push   %eax
f01021cc:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01021d2:	50                   	push   %eax
f01021d3:	68 54 03 00 00       	push   $0x354
f01021d8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01021de:	50                   	push   %eax
f01021df:	e8 b5 de ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f01021e4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021e7:	8d 83 86 d3 fe ff    	lea    -0x12c7a(%ebx),%eax
f01021ed:	50                   	push   %eax
f01021ee:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01021f4:	50                   	push   %eax
f01021f5:	68 55 03 00 00       	push   $0x355
f01021fa:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102200:	50                   	push   %eax
f0102201:	e8 93 de ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f0102206:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102209:	8d 83 9c d3 fe ff    	lea    -0x12c64(%ebx),%eax
f010220f:	50                   	push   %eax
f0102210:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102216:	50                   	push   %eax
f0102217:	68 56 03 00 00       	push   $0x356
f010221c:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102222:	50                   	push   %eax
f0102223:	e8 71 de ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f0102228:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010222b:	8d 83 b2 d3 fe ff    	lea    -0x12c4e(%ebx),%eax
f0102231:	50                   	push   %eax
f0102232:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102238:	50                   	push   %eax
f0102239:	68 59 03 00 00       	push   $0x359
f010223e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102244:	50                   	push   %eax
f0102245:	e8 4f de ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010224a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010224d:	8d 83 40 d7 fe ff    	lea    -0x128c0(%ebx),%eax
f0102253:	50                   	push   %eax
f0102254:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010225a:	50                   	push   %eax
f010225b:	68 5a 03 00 00       	push   $0x35a
f0102260:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102266:	50                   	push   %eax
f0102267:	e8 2d de ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f010226c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010226f:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f0102275:	50                   	push   %eax
f0102276:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010227c:	50                   	push   %eax
f010227d:	68 61 03 00 00       	push   $0x361
f0102282:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102288:	50                   	push   %eax
f0102289:	e8 0b de ff ff       	call   f0100099 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010228e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102291:	8d 83 80 d7 fe ff    	lea    -0x12880(%ebx),%eax
f0102297:	50                   	push   %eax
f0102298:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010229e:	50                   	push   %eax
f010229f:	68 64 03 00 00       	push   $0x364
f01022a4:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01022aa:	50                   	push   %eax
f01022ab:	e8 e9 dd ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01022b0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022b3:	8d 83 b8 d7 fe ff    	lea    -0x12848(%ebx),%eax
f01022b9:	50                   	push   %eax
f01022ba:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01022c0:	50                   	push   %eax
f01022c1:	68 67 03 00 00       	push   $0x367
f01022c6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01022cc:	50                   	push   %eax
f01022cd:	e8 c7 dd ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01022d2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022d5:	8d 83 e8 d7 fe ff    	lea    -0x12818(%ebx),%eax
f01022db:	50                   	push   %eax
f01022dc:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01022e2:	50                   	push   %eax
f01022e3:	68 6b 03 00 00       	push   $0x36b
f01022e8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01022ee:	50                   	push   %eax
f01022ef:	e8 a5 dd ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01022f4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022f7:	8d 83 18 d8 fe ff    	lea    -0x127e8(%ebx),%eax
f01022fd:	50                   	push   %eax
f01022fe:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102304:	50                   	push   %eax
f0102305:	68 6c 03 00 00       	push   $0x36c
f010230a:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102310:	50                   	push   %eax
f0102311:	e8 83 dd ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102316:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102319:	8d 83 40 d8 fe ff    	lea    -0x127c0(%ebx),%eax
f010231f:	50                   	push   %eax
f0102320:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102326:	50                   	push   %eax
f0102327:	68 6d 03 00 00       	push   $0x36d
f010232c:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102332:	50                   	push   %eax
f0102333:	e8 61 dd ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f0102338:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010233b:	8d 83 6d d4 fe ff    	lea    -0x12b93(%ebx),%eax
f0102341:	50                   	push   %eax
f0102342:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102348:	50                   	push   %eax
f0102349:	68 6e 03 00 00       	push   $0x36e
f010234e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102354:	50                   	push   %eax
f0102355:	e8 3f dd ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f010235a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010235d:	8d 83 7e d4 fe ff    	lea    -0x12b82(%ebx),%eax
f0102363:	50                   	push   %eax
f0102364:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010236a:	50                   	push   %eax
f010236b:	68 6f 03 00 00       	push   $0x36f
f0102370:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102376:	50                   	push   %eax
f0102377:	e8 1d dd ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010237c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010237f:	8d 83 70 d8 fe ff    	lea    -0x12790(%ebx),%eax
f0102385:	50                   	push   %eax
f0102386:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010238c:	50                   	push   %eax
f010238d:	68 72 03 00 00       	push   $0x372
f0102392:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102398:	50                   	push   %eax
f0102399:	e8 fb dc ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010239e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023a1:	8d 83 ac d8 fe ff    	lea    -0x12754(%ebx),%eax
f01023a7:	50                   	push   %eax
f01023a8:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01023ae:	50                   	push   %eax
f01023af:	68 73 03 00 00       	push   $0x373
f01023b4:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01023ba:	50                   	push   %eax
f01023bb:	e8 d9 dc ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f01023c0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023c3:	8d 83 8f d4 fe ff    	lea    -0x12b71(%ebx),%eax
f01023c9:	50                   	push   %eax
f01023ca:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01023d0:	50                   	push   %eax
f01023d1:	68 74 03 00 00       	push   $0x374
f01023d6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01023dc:	50                   	push   %eax
f01023dd:	e8 b7 dc ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f01023e2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023e5:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f01023eb:	50                   	push   %eax
f01023ec:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01023f2:	50                   	push   %eax
f01023f3:	68 77 03 00 00       	push   $0x377
f01023f8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01023fe:	50                   	push   %eax
f01023ff:	e8 95 dc ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102404:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102407:	8d 83 70 d8 fe ff    	lea    -0x12790(%ebx),%eax
f010240d:	50                   	push   %eax
f010240e:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102414:	50                   	push   %eax
f0102415:	68 7a 03 00 00       	push   $0x37a
f010241a:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102420:	50                   	push   %eax
f0102421:	e8 73 dc ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102426:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102429:	8d 83 ac d8 fe ff    	lea    -0x12754(%ebx),%eax
f010242f:	50                   	push   %eax
f0102430:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102436:	50                   	push   %eax
f0102437:	68 7b 03 00 00       	push   $0x37b
f010243c:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102442:	50                   	push   %eax
f0102443:	e8 51 dc ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f0102448:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010244b:	8d 83 8f d4 fe ff    	lea    -0x12b71(%ebx),%eax
f0102451:	50                   	push   %eax
f0102452:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102458:	50                   	push   %eax
f0102459:	68 7c 03 00 00       	push   $0x37c
f010245e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102464:	50                   	push   %eax
f0102465:	e8 2f dc ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f010246a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010246d:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f0102473:	50                   	push   %eax
f0102474:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010247a:	50                   	push   %eax
f010247b:	68 80 03 00 00       	push   $0x380
f0102480:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102486:	50                   	push   %eax
f0102487:	e8 0d dc ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010248c:	53                   	push   %ebx
f010248d:	89 cb                	mov    %ecx,%ebx
f010248f:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f0102495:	50                   	push   %eax
f0102496:	68 83 03 00 00       	push   $0x383
f010249b:	8d 81 9f d2 fe ff    	lea    -0x12d61(%ecx),%eax
f01024a1:	50                   	push   %eax
f01024a2:	e8 f2 db ff ff       	call   f0100099 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01024a7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024aa:	8d 83 dc d8 fe ff    	lea    -0x12724(%ebx),%eax
f01024b0:	50                   	push   %eax
f01024b1:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01024b7:	50                   	push   %eax
f01024b8:	68 84 03 00 00       	push   $0x384
f01024bd:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01024c3:	50                   	push   %eax
f01024c4:	e8 d0 db ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01024c9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024cc:	8d 83 1c d9 fe ff    	lea    -0x126e4(%ebx),%eax
f01024d2:	50                   	push   %eax
f01024d3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01024d9:	50                   	push   %eax
f01024da:	68 87 03 00 00       	push   $0x387
f01024df:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01024e5:	50                   	push   %eax
f01024e6:	e8 ae db ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024eb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024ee:	8d 83 ac d8 fe ff    	lea    -0x12754(%ebx),%eax
f01024f4:	50                   	push   %eax
f01024f5:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01024fb:	50                   	push   %eax
f01024fc:	68 88 03 00 00       	push   $0x388
f0102501:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102507:	50                   	push   %eax
f0102508:	e8 8c db ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f010250d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102510:	8d 83 8f d4 fe ff    	lea    -0x12b71(%ebx),%eax
f0102516:	50                   	push   %eax
f0102517:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010251d:	50                   	push   %eax
f010251e:	68 89 03 00 00       	push   $0x389
f0102523:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102529:	50                   	push   %eax
f010252a:	e8 6a db ff ff       	call   f0100099 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010252f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102532:	8d 83 5c d9 fe ff    	lea    -0x126a4(%ebx),%eax
f0102538:	50                   	push   %eax
f0102539:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010253f:	50                   	push   %eax
f0102540:	68 8a 03 00 00       	push   $0x38a
f0102545:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010254b:	50                   	push   %eax
f010254c:	e8 48 db ff ff       	call   f0100099 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102551:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102554:	8d 83 a0 d4 fe ff    	lea    -0x12b60(%ebx),%eax
f010255a:	50                   	push   %eax
f010255b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102561:	50                   	push   %eax
f0102562:	68 8b 03 00 00       	push   $0x38b
f0102567:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010256d:	50                   	push   %eax
f010256e:	e8 26 db ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102573:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102576:	8d 83 70 d8 fe ff    	lea    -0x12790(%ebx),%eax
f010257c:	50                   	push   %eax
f010257d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102583:	50                   	push   %eax
f0102584:	68 8e 03 00 00       	push   $0x38e
f0102589:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010258f:	50                   	push   %eax
f0102590:	e8 04 db ff ff       	call   f0100099 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102595:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102598:	8d 83 90 d9 fe ff    	lea    -0x12670(%ebx),%eax
f010259e:	50                   	push   %eax
f010259f:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01025a5:	50                   	push   %eax
f01025a6:	68 8f 03 00 00       	push   $0x38f
f01025ab:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01025b1:	50                   	push   %eax
f01025b2:	e8 e2 da ff ff       	call   f0100099 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025b7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025ba:	8d 83 c4 d9 fe ff    	lea    -0x1263c(%ebx),%eax
f01025c0:	50                   	push   %eax
f01025c1:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01025c7:	50                   	push   %eax
f01025c8:	68 90 03 00 00       	push   $0x390
f01025cd:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01025d3:	50                   	push   %eax
f01025d4:	e8 c0 da ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01025d9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025dc:	8d 83 fc d9 fe ff    	lea    -0x12604(%ebx),%eax
f01025e2:	50                   	push   %eax
f01025e3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01025e9:	50                   	push   %eax
f01025ea:	68 93 03 00 00       	push   $0x393
f01025ef:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01025f5:	50                   	push   %eax
f01025f6:	e8 9e da ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01025fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025fe:	8d 83 34 da fe ff    	lea    -0x125cc(%ebx),%eax
f0102604:	50                   	push   %eax
f0102605:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010260b:	50                   	push   %eax
f010260c:	68 96 03 00 00       	push   $0x396
f0102611:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102617:	50                   	push   %eax
f0102618:	e8 7c da ff ff       	call   f0100099 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010261d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102620:	8d 83 c4 d9 fe ff    	lea    -0x1263c(%ebx),%eax
f0102626:	50                   	push   %eax
f0102627:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010262d:	50                   	push   %eax
f010262e:	68 97 03 00 00       	push   $0x397
f0102633:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102639:	50                   	push   %eax
f010263a:	e8 5a da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010263f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102642:	8d 83 70 da fe ff    	lea    -0x12590(%ebx),%eax
f0102648:	50                   	push   %eax
f0102649:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010264f:	50                   	push   %eax
f0102650:	68 9a 03 00 00       	push   $0x39a
f0102655:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010265b:	50                   	push   %eax
f010265c:	e8 38 da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102661:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102664:	8d 83 9c da fe ff    	lea    -0x12564(%ebx),%eax
f010266a:	50                   	push   %eax
f010266b:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102671:	50                   	push   %eax
f0102672:	68 9b 03 00 00       	push   $0x39b
f0102677:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010267d:	50                   	push   %eax
f010267e:	e8 16 da ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 2);
f0102683:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102686:	8d 83 b6 d4 fe ff    	lea    -0x12b4a(%ebx),%eax
f010268c:	50                   	push   %eax
f010268d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102693:	50                   	push   %eax
f0102694:	68 9d 03 00 00       	push   $0x39d
f0102699:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010269f:	50                   	push   %eax
f01026a0:	e8 f4 d9 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f01026a5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026a8:	8d 83 c7 d4 fe ff    	lea    -0x12b39(%ebx),%eax
f01026ae:	50                   	push   %eax
f01026af:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01026b5:	50                   	push   %eax
f01026b6:	68 9e 03 00 00       	push   $0x39e
f01026bb:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01026c1:	50                   	push   %eax
f01026c2:	e8 d2 d9 ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01026c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026ca:	8d 83 cc da fe ff    	lea    -0x12534(%ebx),%eax
f01026d0:	50                   	push   %eax
f01026d1:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01026d7:	50                   	push   %eax
f01026d8:	68 a1 03 00 00       	push   $0x3a1
f01026dd:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01026e3:	50                   	push   %eax
f01026e4:	e8 b0 d9 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01026e9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026ec:	8d 83 f0 da fe ff    	lea    -0x12510(%ebx),%eax
f01026f2:	50                   	push   %eax
f01026f3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01026f9:	50                   	push   %eax
f01026fa:	68 a5 03 00 00       	push   $0x3a5
f01026ff:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102705:	50                   	push   %eax
f0102706:	e8 8e d9 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010270b:	89 cb                	mov    %ecx,%ebx
f010270d:	8d 81 9c da fe ff    	lea    -0x12564(%ecx),%eax
f0102713:	50                   	push   %eax
f0102714:	8d 81 c5 d2 fe ff    	lea    -0x12d3b(%ecx),%eax
f010271a:	50                   	push   %eax
f010271b:	68 a6 03 00 00       	push   $0x3a6
f0102720:	8d 81 9f d2 fe ff    	lea    -0x12d61(%ecx),%eax
f0102726:	50                   	push   %eax
f0102727:	e8 6d d9 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f010272c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010272f:	8d 83 6d d4 fe ff    	lea    -0x12b93(%ebx),%eax
f0102735:	50                   	push   %eax
f0102736:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010273c:	50                   	push   %eax
f010273d:	68 a7 03 00 00       	push   $0x3a7
f0102742:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102748:	50                   	push   %eax
f0102749:	e8 4b d9 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f010274e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102751:	8d 83 c7 d4 fe ff    	lea    -0x12b39(%ebx),%eax
f0102757:	50                   	push   %eax
f0102758:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010275e:	50                   	push   %eax
f010275f:	68 a8 03 00 00       	push   $0x3a8
f0102764:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010276a:	50                   	push   %eax
f010276b:	e8 29 d9 ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102770:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102773:	8d 83 14 db fe ff    	lea    -0x124ec(%ebx),%eax
f0102779:	50                   	push   %eax
f010277a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102780:	50                   	push   %eax
f0102781:	68 ab 03 00 00       	push   $0x3ab
f0102786:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010278c:	50                   	push   %eax
f010278d:	e8 07 d9 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref);
f0102792:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102795:	8d 83 d8 d4 fe ff    	lea    -0x12b28(%ebx),%eax
f010279b:	50                   	push   %eax
f010279c:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01027a2:	50                   	push   %eax
f01027a3:	68 ac 03 00 00       	push   $0x3ac
f01027a8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01027ae:	50                   	push   %eax
f01027af:	e8 e5 d8 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_link == NULL);
f01027b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027b7:	8d 83 e4 d4 fe ff    	lea    -0x12b1c(%ebx),%eax
f01027bd:	50                   	push   %eax
f01027be:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01027c4:	50                   	push   %eax
f01027c5:	68 ad 03 00 00       	push   $0x3ad
f01027ca:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01027d0:	50                   	push   %eax
f01027d1:	e8 c3 d8 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027d6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027d9:	8d 83 f0 da fe ff    	lea    -0x12510(%ebx),%eax
f01027df:	50                   	push   %eax
f01027e0:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01027e6:	50                   	push   %eax
f01027e7:	68 b1 03 00 00       	push   $0x3b1
f01027ec:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01027f2:	50                   	push   %eax
f01027f3:	e8 a1 d8 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01027f8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027fb:	8d 83 4c db fe ff    	lea    -0x124b4(%ebx),%eax
f0102801:	50                   	push   %eax
f0102802:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102808:	50                   	push   %eax
f0102809:	68 b2 03 00 00       	push   $0x3b2
f010280e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102814:	50                   	push   %eax
f0102815:	e8 7f d8 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 0);
f010281a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010281d:	8d 83 f9 d4 fe ff    	lea    -0x12b07(%ebx),%eax
f0102823:	50                   	push   %eax
f0102824:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010282a:	50                   	push   %eax
f010282b:	68 b3 03 00 00       	push   $0x3b3
f0102830:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102836:	50                   	push   %eax
f0102837:	e8 5d d8 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f010283c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010283f:	8d 83 c7 d4 fe ff    	lea    -0x12b39(%ebx),%eax
f0102845:	50                   	push   %eax
f0102846:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010284c:	50                   	push   %eax
f010284d:	68 b4 03 00 00       	push   $0x3b4
f0102852:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102858:	50                   	push   %eax
f0102859:	e8 3b d8 ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f010285e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102861:	8d 83 74 db fe ff    	lea    -0x1248c(%ebx),%eax
f0102867:	50                   	push   %eax
f0102868:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f010286e:	50                   	push   %eax
f010286f:	68 b7 03 00 00       	push   $0x3b7
f0102874:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010287a:	50                   	push   %eax
f010287b:	e8 19 d8 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f0102880:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102883:	8d 83 1b d4 fe ff    	lea    -0x12be5(%ebx),%eax
f0102889:	50                   	push   %eax
f010288a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102890:	50                   	push   %eax
f0102891:	68 ba 03 00 00       	push   $0x3ba
f0102896:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010289c:	50                   	push   %eax
f010289d:	e8 f7 d7 ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01028a2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028a5:	8d 83 18 d8 fe ff    	lea    -0x127e8(%ebx),%eax
f01028ab:	50                   	push   %eax
f01028ac:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01028b2:	50                   	push   %eax
f01028b3:	68 bd 03 00 00       	push   $0x3bd
f01028b8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01028be:	50                   	push   %eax
f01028bf:	e8 d5 d7 ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f01028c4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028c7:	8d 83 7e d4 fe ff    	lea    -0x12b82(%ebx),%eax
f01028cd:	50                   	push   %eax
f01028ce:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01028d4:	50                   	push   %eax
f01028d5:	68 bf 03 00 00       	push   $0x3bf
f01028da:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01028e0:	50                   	push   %eax
f01028e1:	e8 b3 d7 ff ff       	call   f0100099 <_panic>
f01028e6:	52                   	push   %edx
f01028e7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028ea:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f01028f0:	50                   	push   %eax
f01028f1:	68 c6 03 00 00       	push   $0x3c6
f01028f6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01028fc:	50                   	push   %eax
f01028fd:	e8 97 d7 ff ff       	call   f0100099 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102902:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102905:	8d 83 0a d5 fe ff    	lea    -0x12af6(%ebx),%eax
f010290b:	50                   	push   %eax
f010290c:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102912:	50                   	push   %eax
f0102913:	68 c7 03 00 00       	push   $0x3c7
f0102918:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010291e:	50                   	push   %eax
f010291f:	e8 75 d7 ff ff       	call   f0100099 <_panic>
f0102924:	52                   	push   %edx
f0102925:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f010292b:	50                   	push   %eax
f010292c:	6a 52                	push   $0x52
f010292e:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f0102934:	50                   	push   %eax
f0102935:	e8 5f d7 ff ff       	call   f0100099 <_panic>
f010293a:	52                   	push   %edx
f010293b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010293e:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f0102944:	50                   	push   %eax
f0102945:	6a 52                	push   $0x52
f0102947:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f010294d:	50                   	push   %eax
f010294e:	e8 46 d7 ff ff       	call   f0100099 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102953:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102956:	8d 83 22 d5 fe ff    	lea    -0x12ade(%ebx),%eax
f010295c:	50                   	push   %eax
f010295d:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102963:	50                   	push   %eax
f0102964:	68 d1 03 00 00       	push   $0x3d1
f0102969:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010296f:	50                   	push   %eax
f0102970:	e8 24 d7 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102975:	50                   	push   %eax
f0102976:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102979:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f010297f:	50                   	push   %eax
f0102980:	68 c3 00 00 00       	push   $0xc3
f0102985:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f010298b:	50                   	push   %eax
f010298c:	e8 08 d7 ff ff       	call   f0100099 <_panic>
f0102991:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102994:	ff b3 fc ff ff ff    	push   -0x4(%ebx)
f010299a:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f01029a0:	50                   	push   %eax
f01029a1:	68 cf 00 00 00       	push   $0xcf
f01029a6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01029ac:	50                   	push   %eax
f01029ad:	e8 e7 d6 ff ff       	call   f0100099 <_panic>
f01029b2:	ff 75 bc             	push   -0x44(%ebp)
f01029b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029b8:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f01029be:	50                   	push   %eax
f01029bf:	68 13 03 00 00       	push   $0x313
f01029c4:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01029ca:	50                   	push   %eax
f01029cb:	e8 c9 d6 ff ff       	call   f0100099 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01029d0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029d3:	8d 83 98 db fe ff    	lea    -0x12468(%ebx),%eax
f01029d9:	50                   	push   %eax
f01029da:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01029e0:	50                   	push   %eax
f01029e1:	68 13 03 00 00       	push   $0x313
f01029e6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f01029ec:	50                   	push   %eax
f01029ed:	e8 a7 d6 ff ff       	call   f0100099 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029f2:	8b 7d d0             	mov    -0x30(%ebp),%edi
f01029f5:	8b 75 c0             	mov    -0x40(%ebp),%esi
f01029f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01029fb:	c1 e0 0c             	shl    $0xc,%eax
f01029fe:	89 f3                	mov    %esi,%ebx
f0102a00:	89 75 d0             	mov    %esi,-0x30(%ebp)
f0102a03:	89 c6                	mov    %eax,%esi
f0102a05:	39 f3                	cmp    %esi,%ebx
f0102a07:	73 3b                	jae    f0102a44 <mem_init+0x171b>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a09:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102a0f:	89 f8                	mov    %edi,%eax
f0102a11:	e8 b8 e0 ff ff       	call   f0100ace <check_va2pa>
f0102a16:	39 c3                	cmp    %eax,%ebx
f0102a18:	75 08                	jne    f0102a22 <mem_init+0x16f9>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a20:	eb e3                	jmp    f0102a05 <mem_init+0x16dc>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a22:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a25:	8d 83 cc db fe ff    	lea    -0x12434(%ebx),%eax
f0102a2b:	50                   	push   %eax
f0102a2c:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102a32:	50                   	push   %eax
f0102a33:	68 18 03 00 00       	push   $0x318
f0102a38:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102a3e:	50                   	push   %eax
f0102a3f:	e8 55 d6 ff ff       	call   f0100099 <_panic>
f0102a44:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102a49:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102a4c:	05 00 80 00 20       	add    $0x20008000,%eax
f0102a51:	89 c6                	mov    %eax,%esi
f0102a53:	89 da                	mov    %ebx,%edx
f0102a55:	89 f8                	mov    %edi,%eax
f0102a57:	e8 72 e0 ff ff       	call   f0100ace <check_va2pa>
f0102a5c:	89 c2                	mov    %eax,%edx
f0102a5e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0102a61:	39 c2                	cmp    %eax,%edx
f0102a63:	75 44                	jne    f0102aa9 <mem_init+0x1780>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a65:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a6b:	81 fb 00 00 00 f0    	cmp    $0xf0000000,%ebx
f0102a71:	75 e0                	jne    f0102a53 <mem_init+0x172a>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102a73:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0102a76:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102a7b:	89 f8                	mov    %edi,%eax
f0102a7d:	e8 4c e0 ff ff       	call   f0100ace <check_va2pa>
f0102a82:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a85:	74 71                	je     f0102af8 <mem_init+0x17cf>
f0102a87:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a8a:	8d 83 3c dc fe ff    	lea    -0x123c4(%ebx),%eax
f0102a90:	50                   	push   %eax
f0102a91:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102a97:	50                   	push   %eax
f0102a98:	68 1d 03 00 00       	push   $0x31d
f0102a9d:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102aa3:	50                   	push   %eax
f0102aa4:	e8 f0 d5 ff ff       	call   f0100099 <_panic>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102aa9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102aac:	8d 83 f4 db fe ff    	lea    -0x1240c(%ebx),%eax
f0102ab2:	50                   	push   %eax
f0102ab3:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102ab9:	50                   	push   %eax
f0102aba:	68 1c 03 00 00       	push   $0x31c
f0102abf:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102ac5:	50                   	push   %eax
f0102ac6:	e8 ce d5 ff ff       	call   f0100099 <_panic>
		switch (i) {
f0102acb:	81 fe bf 03 00 00    	cmp    $0x3bf,%esi
f0102ad1:	75 25                	jne    f0102af8 <mem_init+0x17cf>
			assert(pgdir[i] & PTE_P);
f0102ad3:	f6 04 b7 01          	testb  $0x1,(%edi,%esi,4)
f0102ad7:	74 4f                	je     f0102b28 <mem_init+0x17ff>
	for (i = 0; i < NPDENTRIES; i++) {
f0102ad9:	83 c6 01             	add    $0x1,%esi
f0102adc:	81 fe ff 03 00 00    	cmp    $0x3ff,%esi
f0102ae2:	0f 87 b1 00 00 00    	ja     f0102b99 <mem_init+0x1870>
		switch (i) {
f0102ae8:	81 fe bd 03 00 00    	cmp    $0x3bd,%esi
f0102aee:	77 db                	ja     f0102acb <mem_init+0x17a2>
f0102af0:	81 fe bb 03 00 00    	cmp    $0x3bb,%esi
f0102af6:	77 db                	ja     f0102ad3 <mem_init+0x17aa>
			if (i >= PDX(KERNBASE)) {
f0102af8:	81 fe bf 03 00 00    	cmp    $0x3bf,%esi
f0102afe:	77 4a                	ja     f0102b4a <mem_init+0x1821>
				assert(pgdir[i] == 0);
f0102b00:	83 3c b7 00          	cmpl   $0x0,(%edi,%esi,4)
f0102b04:	74 d3                	je     f0102ad9 <mem_init+0x17b0>
f0102b06:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b09:	8d 83 74 d5 fe ff    	lea    -0x12a8c(%ebx),%eax
f0102b0f:	50                   	push   %eax
f0102b10:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102b16:	50                   	push   %eax
f0102b17:	68 2c 03 00 00       	push   $0x32c
f0102b1c:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102b22:	50                   	push   %eax
f0102b23:	e8 71 d5 ff ff       	call   f0100099 <_panic>
			assert(pgdir[i] & PTE_P);
f0102b28:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b2b:	8d 83 52 d5 fe ff    	lea    -0x12aae(%ebx),%eax
f0102b31:	50                   	push   %eax
f0102b32:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102b38:	50                   	push   %eax
f0102b39:	68 25 03 00 00       	push   $0x325
f0102b3e:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102b44:	50                   	push   %eax
f0102b45:	e8 4f d5 ff ff       	call   f0100099 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b4a:	8b 04 b7             	mov    (%edi,%esi,4),%eax
f0102b4d:	a8 01                	test   $0x1,%al
f0102b4f:	74 26                	je     f0102b77 <mem_init+0x184e>
				assert(pgdir[i] & PTE_W);
f0102b51:	a8 02                	test   $0x2,%al
f0102b53:	75 84                	jne    f0102ad9 <mem_init+0x17b0>
f0102b55:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b58:	8d 83 63 d5 fe ff    	lea    -0x12a9d(%ebx),%eax
f0102b5e:	50                   	push   %eax
f0102b5f:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102b65:	50                   	push   %eax
f0102b66:	68 2a 03 00 00       	push   $0x32a
f0102b6b:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102b71:	50                   	push   %eax
f0102b72:	e8 22 d5 ff ff       	call   f0100099 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b77:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b7a:	8d 83 52 d5 fe ff    	lea    -0x12aae(%ebx),%eax
f0102b80:	50                   	push   %eax
f0102b81:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102b87:	50                   	push   %eax
f0102b88:	68 29 03 00 00       	push   $0x329
f0102b8d:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102b93:	50                   	push   %eax
f0102b94:	e8 00 d5 ff ff       	call   f0100099 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b99:	83 ec 0c             	sub    $0xc,%esp
f0102b9c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b9f:	8d 83 6c dc fe ff    	lea    -0x12394(%ebx),%eax
f0102ba5:	50                   	push   %eax
f0102ba6:	e8 db 04 00 00       	call   f0103086 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102bab:	8b 83 b0 1f 00 00    	mov    0x1fb0(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0102bb1:	83 c4 10             	add    $0x10,%esp
f0102bb4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102bb9:	0f 86 2c 02 00 00    	jbe    f0102deb <mem_init+0x1ac2>
	return (physaddr_t)kva - KERNBASE;
f0102bbf:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102bc4:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102bc7:	b8 00 00 00 00       	mov    $0x0,%eax
f0102bcc:	e8 79 df ff ff       	call   f0100b4a <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102bd1:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102bd4:	83 e0 f3             	and    $0xfffffff3,%eax
f0102bd7:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102bdc:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102bdf:	83 ec 0c             	sub    $0xc,%esp
f0102be2:	6a 00                	push   $0x0
f0102be4:	e8 20 e4 ff ff       	call   f0101009 <page_alloc>
f0102be9:	89 c6                	mov    %eax,%esi
f0102beb:	83 c4 10             	add    $0x10,%esp
f0102bee:	85 c0                	test   %eax,%eax
f0102bf0:	0f 84 11 02 00 00    	je     f0102e07 <mem_init+0x1ade>
	assert((pp1 = page_alloc(0)));
f0102bf6:	83 ec 0c             	sub    $0xc,%esp
f0102bf9:	6a 00                	push   $0x0
f0102bfb:	e8 09 e4 ff ff       	call   f0101009 <page_alloc>
f0102c00:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102c03:	83 c4 10             	add    $0x10,%esp
f0102c06:	85 c0                	test   %eax,%eax
f0102c08:	0f 84 1b 02 00 00    	je     f0102e29 <mem_init+0x1b00>
	assert((pp2 = page_alloc(0)));
f0102c0e:	83 ec 0c             	sub    $0xc,%esp
f0102c11:	6a 00                	push   $0x0
f0102c13:	e8 f1 e3 ff ff       	call   f0101009 <page_alloc>
f0102c18:	89 c7                	mov    %eax,%edi
f0102c1a:	83 c4 10             	add    $0x10,%esp
f0102c1d:	85 c0                	test   %eax,%eax
f0102c1f:	0f 84 26 02 00 00    	je     f0102e4b <mem_init+0x1b22>
	page_free(pp0);
f0102c25:	83 ec 0c             	sub    $0xc,%esp
f0102c28:	56                   	push   %esi
f0102c29:	e8 60 e4 ff ff       	call   f010108e <page_free>
	return (pp - pages) << PGSHIFT;
f0102c2e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102c31:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102c34:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f0102c3a:	c1 f8 03             	sar    $0x3,%eax
f0102c3d:	89 c2                	mov    %eax,%edx
f0102c3f:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c42:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c47:	83 c4 10             	add    $0x10,%esp
f0102c4a:	3b 81 b4 1f 00 00    	cmp    0x1fb4(%ecx),%eax
f0102c50:	0f 83 17 02 00 00    	jae    f0102e6d <mem_init+0x1b44>
	memset(page2kva(pp1), 1, PGSIZE);
f0102c56:	83 ec 04             	sub    $0x4,%esp
f0102c59:	68 00 10 00 00       	push   $0x1000
f0102c5e:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102c60:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102c66:	52                   	push   %edx
f0102c67:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c6a:	e8 18 10 00 00       	call   f0103c87 <memset>
	return (pp - pages) << PGSHIFT;
f0102c6f:	89 f8                	mov    %edi,%eax
f0102c71:	2b 83 ac 1f 00 00    	sub    0x1fac(%ebx),%eax
f0102c77:	c1 f8 03             	sar    $0x3,%eax
f0102c7a:	89 c2                	mov    %eax,%edx
f0102c7c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c7f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c84:	83 c4 10             	add    $0x10,%esp
f0102c87:	3b 83 b4 1f 00 00    	cmp    0x1fb4(%ebx),%eax
f0102c8d:	0f 83 f2 01 00 00    	jae    f0102e85 <mem_init+0x1b5c>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c93:	83 ec 04             	sub    $0x4,%esp
f0102c96:	68 00 10 00 00       	push   $0x1000
f0102c9b:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102c9d:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102ca3:	52                   	push   %edx
f0102ca4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ca7:	e8 db 0f 00 00       	call   f0103c87 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102cac:	6a 02                	push   $0x2
f0102cae:	68 00 10 00 00       	push   $0x1000
f0102cb3:	ff 75 d0             	push   -0x30(%ebp)
f0102cb6:	ff b3 b0 1f 00 00    	push   0x1fb0(%ebx)
f0102cbc:	e8 e2 e5 ff ff       	call   f01012a3 <page_insert>
	assert(pp1->pp_ref == 1);
f0102cc1:	83 c4 20             	add    $0x20,%esp
f0102cc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102cc7:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102ccc:	0f 85 cc 01 00 00    	jne    f0102e9e <mem_init+0x1b75>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102cd2:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102cd9:	01 01 01 
f0102cdc:	0f 85 de 01 00 00    	jne    f0102ec0 <mem_init+0x1b97>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102ce2:	6a 02                	push   $0x2
f0102ce4:	68 00 10 00 00       	push   $0x1000
f0102ce9:	57                   	push   %edi
f0102cea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ced:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0102cf3:	e8 ab e5 ff ff       	call   f01012a3 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102cf8:	83 c4 10             	add    $0x10,%esp
f0102cfb:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102d02:	02 02 02 
f0102d05:	0f 85 d7 01 00 00    	jne    f0102ee2 <mem_init+0x1bb9>
	assert(pp2->pp_ref == 1);
f0102d0b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102d10:	0f 85 ee 01 00 00    	jne    f0102f04 <mem_init+0x1bdb>
	assert(pp1->pp_ref == 0);
f0102d16:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102d19:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102d1e:	0f 85 02 02 00 00    	jne    f0102f26 <mem_init+0x1bfd>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102d24:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102d2b:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102d2e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102d31:	89 f8                	mov    %edi,%eax
f0102d33:	2b 81 ac 1f 00 00    	sub    0x1fac(%ecx),%eax
f0102d39:	c1 f8 03             	sar    $0x3,%eax
f0102d3c:	89 c2                	mov    %eax,%edx
f0102d3e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d41:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d46:	3b 81 b4 1f 00 00    	cmp    0x1fb4(%ecx),%eax
f0102d4c:	0f 83 f6 01 00 00    	jae    f0102f48 <mem_init+0x1c1f>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102d52:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102d59:	03 03 03 
f0102d5c:	0f 85 fe 01 00 00    	jne    f0102f60 <mem_init+0x1c37>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102d62:	83 ec 08             	sub    $0x8,%esp
f0102d65:	68 00 10 00 00       	push   $0x1000
f0102d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d6d:	ff b0 b0 1f 00 00    	push   0x1fb0(%eax)
f0102d73:	e8 f0 e4 ff ff       	call   f0101268 <page_remove>
	assert(pp2->pp_ref == 0);
f0102d78:	83 c4 10             	add    $0x10,%esp
f0102d7b:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102d80:	0f 85 fc 01 00 00    	jne    f0102f82 <mem_init+0x1c59>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d89:	8b 88 b0 1f 00 00    	mov    0x1fb0(%eax),%ecx
f0102d8f:	8b 11                	mov    (%ecx),%edx
f0102d91:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102d97:	89 f7                	mov    %esi,%edi
f0102d99:	2b b8 ac 1f 00 00    	sub    0x1fac(%eax),%edi
f0102d9f:	89 f8                	mov    %edi,%eax
f0102da1:	c1 f8 03             	sar    $0x3,%eax
f0102da4:	c1 e0 0c             	shl    $0xc,%eax
f0102da7:	39 c2                	cmp    %eax,%edx
f0102da9:	0f 85 f5 01 00 00    	jne    f0102fa4 <mem_init+0x1c7b>
	kern_pgdir[0] = 0;
f0102daf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102db5:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102dba:	0f 85 06 02 00 00    	jne    f0102fc6 <mem_init+0x1c9d>
	pp0->pp_ref = 0;
f0102dc0:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102dc6:	83 ec 0c             	sub    $0xc,%esp
f0102dc9:	56                   	push   %esi
f0102dca:	e8 bf e2 ff ff       	call   f010108e <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102dcf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102dd2:	8d 83 00 dd fe ff    	lea    -0x12300(%ebx),%eax
f0102dd8:	89 04 24             	mov    %eax,(%esp)
f0102ddb:	e8 a6 02 00 00       	call   f0103086 <cprintf>
}
f0102de0:	83 c4 10             	add    $0x10,%esp
f0102de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102de6:	5b                   	pop    %ebx
f0102de7:	5e                   	pop    %esi
f0102de8:	5f                   	pop    %edi
f0102de9:	5d                   	pop    %ebp
f0102dea:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102deb:	50                   	push   %eax
f0102dec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102def:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f0102df5:	50                   	push   %eax
f0102df6:	68 e3 00 00 00       	push   $0xe3
f0102dfb:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102e01:	50                   	push   %eax
f0102e02:	e8 92 d2 ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f0102e07:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e0a:	8d 83 70 d3 fe ff    	lea    -0x12c90(%ebx),%eax
f0102e10:	50                   	push   %eax
f0102e11:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102e17:	50                   	push   %eax
f0102e18:	68 ec 03 00 00       	push   $0x3ec
f0102e1d:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102e23:	50                   	push   %eax
f0102e24:	e8 70 d2 ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f0102e29:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e2c:	8d 83 86 d3 fe ff    	lea    -0x12c7a(%ebx),%eax
f0102e32:	50                   	push   %eax
f0102e33:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102e39:	50                   	push   %eax
f0102e3a:	68 ed 03 00 00       	push   $0x3ed
f0102e3f:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102e45:	50                   	push   %eax
f0102e46:	e8 4e d2 ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f0102e4b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e4e:	8d 83 9c d3 fe ff    	lea    -0x12c64(%ebx),%eax
f0102e54:	50                   	push   %eax
f0102e55:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102e5b:	50                   	push   %eax
f0102e5c:	68 ee 03 00 00       	push   $0x3ee
f0102e61:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102e67:	50                   	push   %eax
f0102e68:	e8 2c d2 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e6d:	52                   	push   %edx
f0102e6e:	89 cb                	mov    %ecx,%ebx
f0102e70:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f0102e76:	50                   	push   %eax
f0102e77:	6a 52                	push   $0x52
f0102e79:	8d 81 ab d2 fe ff    	lea    -0x12d55(%ecx),%eax
f0102e7f:	50                   	push   %eax
f0102e80:	e8 14 d2 ff ff       	call   f0100099 <_panic>
f0102e85:	52                   	push   %edx
f0102e86:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e89:	8d 83 84 d5 fe ff    	lea    -0x12a7c(%ebx),%eax
f0102e8f:	50                   	push   %eax
f0102e90:	6a 52                	push   $0x52
f0102e92:	8d 83 ab d2 fe ff    	lea    -0x12d55(%ebx),%eax
f0102e98:	50                   	push   %eax
f0102e99:	e8 fb d1 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f0102e9e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ea1:	8d 83 6d d4 fe ff    	lea    -0x12b93(%ebx),%eax
f0102ea7:	50                   	push   %eax
f0102ea8:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102eae:	50                   	push   %eax
f0102eaf:	68 f3 03 00 00       	push   $0x3f3
f0102eb4:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102eba:	50                   	push   %eax
f0102ebb:	e8 d9 d1 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102ec0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ec3:	8d 83 8c dc fe ff    	lea    -0x12374(%ebx),%eax
f0102ec9:	50                   	push   %eax
f0102eca:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102ed0:	50                   	push   %eax
f0102ed1:	68 f4 03 00 00       	push   $0x3f4
f0102ed6:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102edc:	50                   	push   %eax
f0102edd:	e8 b7 d1 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102ee2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ee5:	8d 83 b0 dc fe ff    	lea    -0x12350(%ebx),%eax
f0102eeb:	50                   	push   %eax
f0102eec:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102ef2:	50                   	push   %eax
f0102ef3:	68 f6 03 00 00       	push   $0x3f6
f0102ef8:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102efe:	50                   	push   %eax
f0102eff:	e8 95 d1 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f0102f04:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f07:	8d 83 8f d4 fe ff    	lea    -0x12b71(%ebx),%eax
f0102f0d:	50                   	push   %eax
f0102f0e:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102f14:	50                   	push   %eax
f0102f15:	68 f7 03 00 00       	push   $0x3f7
f0102f1a:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102f20:	50                   	push   %eax
f0102f21:	e8 73 d1 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 0);
f0102f26:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f29:	8d 83 f9 d4 fe ff    	lea    -0x12b07(%ebx),%eax
f0102f2f:	50                   	push   %eax
f0102f30:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102f36:	50                   	push   %eax
f0102f37:	68 f8 03 00 00       	push   $0x3f8
f0102f3c:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102f42:	50                   	push   %eax
f0102f43:	e8 51 d1 ff ff       	call   f0100099 <_panic>
f0102f48:	52                   	push   %edx
f0102f49:	89 cb                	mov    %ecx,%ebx
f0102f4b:	8d 81 84 d5 fe ff    	lea    -0x12a7c(%ecx),%eax
f0102f51:	50                   	push   %eax
f0102f52:	6a 52                	push   $0x52
f0102f54:	8d 81 ab d2 fe ff    	lea    -0x12d55(%ecx),%eax
f0102f5a:	50                   	push   %eax
f0102f5b:	e8 39 d1 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102f60:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f63:	8d 83 d4 dc fe ff    	lea    -0x1232c(%ebx),%eax
f0102f69:	50                   	push   %eax
f0102f6a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102f70:	50                   	push   %eax
f0102f71:	68 fa 03 00 00       	push   $0x3fa
f0102f76:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102f7c:	50                   	push   %eax
f0102f7d:	e8 17 d1 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f0102f82:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f85:	8d 83 c7 d4 fe ff    	lea    -0x12b39(%ebx),%eax
f0102f8b:	50                   	push   %eax
f0102f8c:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102f92:	50                   	push   %eax
f0102f93:	68 fc 03 00 00       	push   $0x3fc
f0102f98:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102f9e:	50                   	push   %eax
f0102f9f:	e8 f5 d0 ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102fa4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102fa7:	8d 83 18 d8 fe ff    	lea    -0x127e8(%ebx),%eax
f0102fad:	50                   	push   %eax
f0102fae:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102fb4:	50                   	push   %eax
f0102fb5:	68 ff 03 00 00       	push   $0x3ff
f0102fba:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102fc0:	50                   	push   %eax
f0102fc1:	e8 d3 d0 ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f0102fc6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102fc9:	8d 83 7e d4 fe ff    	lea    -0x12b82(%ebx),%eax
f0102fcf:	50                   	push   %eax
f0102fd0:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102fd6:	50                   	push   %eax
f0102fd7:	68 01 04 00 00       	push   $0x401
f0102fdc:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
f0102fe2:	50                   	push   %eax
f0102fe3:	e8 b1 d0 ff ff       	call   f0100099 <_panic>

f0102fe8 <tlb_invalidate>:
{
f0102fe8:	55                   	push   %ebp
f0102fe9:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0102feb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102fee:	0f 01 38             	invlpg (%eax)
}
f0102ff1:	5d                   	pop    %ebp
f0102ff2:	c3                   	ret    

f0102ff3 <__x86.get_pc_thunk.dx>:
f0102ff3:	8b 14 24             	mov    (%esp),%edx
f0102ff6:	c3                   	ret    

f0102ff7 <__x86.get_pc_thunk.cx>:
f0102ff7:	8b 0c 24             	mov    (%esp),%ecx
f0102ffa:	c3                   	ret    

f0102ffb <__x86.get_pc_thunk.di>:
f0102ffb:	8b 3c 24             	mov    (%esp),%edi
f0102ffe:	c3                   	ret    

f0102fff <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0102fff:	55                   	push   %ebp
f0103000:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103002:	8b 45 08             	mov    0x8(%ebp),%eax
f0103005:	ba 70 00 00 00       	mov    $0x70,%edx
f010300a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010300b:	ba 71 00 00 00       	mov    $0x71,%edx
f0103010:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103011:	0f b6 c0             	movzbl %al,%eax
}
f0103014:	5d                   	pop    %ebp
f0103015:	c3                   	ret    

f0103016 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103016:	55                   	push   %ebp
f0103017:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103019:	8b 45 08             	mov    0x8(%ebp),%eax
f010301c:	ba 70 00 00 00       	mov    $0x70,%edx
f0103021:	ee                   	out    %al,(%dx)
f0103022:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103025:	ba 71 00 00 00       	mov    $0x71,%edx
f010302a:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f010302b:	5d                   	pop    %ebp
f010302c:	c3                   	ret    

f010302d <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f010302d:	55                   	push   %ebp
f010302e:	89 e5                	mov    %esp,%ebp
f0103030:	53                   	push   %ebx
f0103031:	83 ec 10             	sub    $0x10,%esp
f0103034:	e8 16 d1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0103039:	81 c3 d3 42 01 00    	add    $0x142d3,%ebx
	cputchar(ch);
f010303f:	ff 75 08             	push   0x8(%ebp)
f0103042:	e8 73 d6 ff ff       	call   f01006ba <cputchar>
	*cnt++;
}
f0103047:	83 c4 10             	add    $0x10,%esp
f010304a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010304d:	c9                   	leave  
f010304e:	c3                   	ret    

f010304f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010304f:	55                   	push   %ebp
f0103050:	89 e5                	mov    %esp,%ebp
f0103052:	53                   	push   %ebx
f0103053:	83 ec 14             	sub    $0x14,%esp
f0103056:	e8 f4 d0 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010305b:	81 c3 b1 42 01 00    	add    $0x142b1,%ebx
	int cnt = 0;
f0103061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103068:	ff 75 0c             	push   0xc(%ebp)
f010306b:	ff 75 08             	push   0x8(%ebp)
f010306e:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103071:	50                   	push   %eax
f0103072:	8d 83 21 bd fe ff    	lea    -0x142df(%ebx),%eax
f0103078:	50                   	push   %eax
f0103079:	e8 5c 04 00 00       	call   f01034da <vprintfmt>
	return cnt;
}
f010307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103084:	c9                   	leave  
f0103085:	c3                   	ret    

f0103086 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103086:	55                   	push   %ebp
f0103087:	89 e5                	mov    %esp,%ebp
f0103089:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f010308c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010308f:	50                   	push   %eax
f0103090:	ff 75 08             	push   0x8(%ebp)
f0103093:	e8 b7 ff ff ff       	call   f010304f <vcprintf>
	va_end(ap);

	return cnt;
}
f0103098:	c9                   	leave  
f0103099:	c3                   	ret    

f010309a <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010309a:	55                   	push   %ebp
f010309b:	89 e5                	mov    %esp,%ebp
f010309d:	57                   	push   %edi
f010309e:	56                   	push   %esi
f010309f:	53                   	push   %ebx
f01030a0:	83 ec 14             	sub    $0x14,%esp
f01030a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01030a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01030a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01030ac:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01030af:	8b 1a                	mov    (%edx),%ebx
f01030b1:	8b 01                	mov    (%ecx),%eax
f01030b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01030b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01030bd:	eb 2f                	jmp    f01030ee <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f01030bf:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f01030c2:	39 c3                	cmp    %eax,%ebx
f01030c4:	7f 4e                	jg     f0103114 <stab_binsearch+0x7a>
f01030c6:	0f b6 0a             	movzbl (%edx),%ecx
f01030c9:	83 ea 0c             	sub    $0xc,%edx
f01030cc:	39 f1                	cmp    %esi,%ecx
f01030ce:	75 ef                	jne    f01030bf <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01030d0:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01030d3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01030d6:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01030da:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01030dd:	73 3a                	jae    f0103119 <stab_binsearch+0x7f>
			*region_left = m;
f01030df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01030e2:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01030e4:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01030e7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01030ee:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01030f1:	7f 53                	jg     f0103146 <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f01030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01030f6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f01030f9:	89 d0                	mov    %edx,%eax
f01030fb:	c1 e8 1f             	shr    $0x1f,%eax
f01030fe:	01 d0                	add    %edx,%eax
f0103100:	89 c7                	mov    %eax,%edi
f0103102:	d1 ff                	sar    %edi
f0103104:	83 e0 fe             	and    $0xfffffffe,%eax
f0103107:	01 f8                	add    %edi,%eax
f0103109:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010310c:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0103110:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0103112:	eb ae                	jmp    f01030c2 <stab_binsearch+0x28>
			l = true_m + 1;
f0103114:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0103117:	eb d5                	jmp    f01030ee <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0103119:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010311c:	76 14                	jbe    f0103132 <stab_binsearch+0x98>
			*region_right = m - 1;
f010311e:	83 e8 01             	sub    $0x1,%eax
f0103121:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0103124:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103127:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0103129:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0103130:	eb bc                	jmp    f01030ee <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0103132:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103135:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0103137:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f010313b:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f010313d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0103144:	eb a8                	jmp    f01030ee <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0103146:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f010314a:	75 15                	jne    f0103161 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f010314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010314f:	8b 00                	mov    (%eax),%eax
f0103151:	83 e8 01             	sub    $0x1,%eax
f0103154:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103157:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0103159:	83 c4 14             	add    $0x14,%esp
f010315c:	5b                   	pop    %ebx
f010315d:	5e                   	pop    %esi
f010315e:	5f                   	pop    %edi
f010315f:	5d                   	pop    %ebp
f0103160:	c3                   	ret    
		for (l = *region_right;
f0103161:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103164:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0103166:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103169:	8b 0f                	mov    (%edi),%ecx
f010316b:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010316e:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0103171:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0103175:	39 c1                	cmp    %eax,%ecx
f0103177:	7d 0f                	jge    f0103188 <stab_binsearch+0xee>
f0103179:	0f b6 1a             	movzbl (%edx),%ebx
f010317c:	83 ea 0c             	sub    $0xc,%edx
f010317f:	39 f3                	cmp    %esi,%ebx
f0103181:	74 05                	je     f0103188 <stab_binsearch+0xee>
		     l--)
f0103183:	83 e8 01             	sub    $0x1,%eax
f0103186:	eb ed                	jmp    f0103175 <stab_binsearch+0xdb>
		*region_left = l;
f0103188:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010318b:	89 07                	mov    %eax,(%edi)
}
f010318d:	eb ca                	jmp    f0103159 <stab_binsearch+0xbf>

f010318f <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010318f:	55                   	push   %ebp
f0103190:	89 e5                	mov    %esp,%ebp
f0103192:	57                   	push   %edi
f0103193:	56                   	push   %esi
f0103194:	53                   	push   %ebx
f0103195:	83 ec 3c             	sub    $0x3c,%esp
f0103198:	e8 b2 cf ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010319d:	81 c3 6f 41 01 00    	add    $0x1416f,%ebx
f01031a3:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01031a6:	8d 83 29 dd fe ff    	lea    -0x122d7(%ebx),%eax
f01031ac:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f01031ae:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f01031b5:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f01031b8:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f01031bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01031c2:	89 46 10             	mov    %eax,0x10(%esi)
	info->eip_fn_narg = 0;
f01031c5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01031cc:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f01031d1:	0f 86 3e 01 00 00    	jbe    f0103315 <debuginfo_eip+0x186>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01031d7:	c7 c0 75 b7 10 f0    	mov    $0xf010b775,%eax
f01031dd:	39 83 f8 ff ff ff    	cmp    %eax,-0x8(%ebx)
f01031e3:	0f 86 d0 01 00 00    	jbe    f01033b9 <debuginfo_eip+0x22a>
f01031e9:	c7 c0 cf d4 10 f0    	mov    $0xf010d4cf,%eax
f01031ef:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01031f3:	0f 85 c7 01 00 00    	jne    f01033c0 <debuginfo_eip+0x231>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01031f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0103200:	c7 c0 4c 52 10 f0    	mov    $0xf010524c,%eax
f0103206:	c7 c2 74 b7 10 f0    	mov    $0xf010b774,%edx
f010320c:	29 c2                	sub    %eax,%edx
f010320e:	c1 fa 02             	sar    $0x2,%edx
f0103211:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0103217:	83 ea 01             	sub    $0x1,%edx
f010321a:	89 55 e0             	mov    %edx,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010321d:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0103220:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0103223:	83 ec 08             	sub    $0x8,%esp
f0103226:	ff 75 08             	push   0x8(%ebp)
f0103229:	6a 64                	push   $0x64
f010322b:	e8 6a fe ff ff       	call   f010309a <stab_binsearch>
	if (lfile == 0)
f0103230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103233:	83 c4 10             	add    $0x10,%esp
f0103236:	85 ff                	test   %edi,%edi
f0103238:	0f 84 89 01 00 00    	je     f01033c7 <debuginfo_eip+0x238>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f010323e:	89 7d dc             	mov    %edi,-0x24(%ebp)
	rfun = rfile;
f0103241:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103244:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0103247:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010324a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010324d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0103250:	83 ec 08             	sub    $0x8,%esp
f0103253:	ff 75 08             	push   0x8(%ebp)
f0103256:	6a 24                	push   $0x24
f0103258:	c7 c0 4c 52 10 f0    	mov    $0xf010524c,%eax
f010325e:	e8 37 fe ff ff       	call   f010309a <stab_binsearch>

	if (lfun <= rfun) {
f0103263:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103266:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0103269:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010326c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f010326f:	83 c4 10             	add    $0x10,%esp
f0103272:	89 f8                	mov    %edi,%eax
f0103274:	39 d1                	cmp    %edx,%ecx
f0103276:	7f 39                	jg     f01032b1 <debuginfo_eip+0x122>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0103278:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f010327b:	c7 c2 4c 52 10 f0    	mov    $0xf010524c,%edx
f0103281:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
f0103284:	8b 11                	mov    (%ecx),%edx
f0103286:	c7 c0 cf d4 10 f0    	mov    $0xf010d4cf,%eax
f010328c:	81 e8 75 b7 10 f0    	sub    $0xf010b775,%eax
f0103292:	39 c2                	cmp    %eax,%edx
f0103294:	73 09                	jae    f010329f <debuginfo_eip+0x110>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0103296:	81 c2 75 b7 10 f0    	add    $0xf010b775,%edx
f010329c:	89 56 08             	mov    %edx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f010329f:	8b 41 08             	mov    0x8(%ecx),%eax
f01032a2:	89 46 10             	mov    %eax,0x10(%esi)
		addr -= info->eip_fn_addr;
f01032a5:	29 45 08             	sub    %eax,0x8(%ebp)
f01032a8:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01032ab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01032ae:	89 4d c0             	mov    %ecx,-0x40(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f01032b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01032b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
f01032b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01032ba:	83 ec 08             	sub    $0x8,%esp
f01032bd:	6a 3a                	push   $0x3a
f01032bf:	ff 76 08             	push   0x8(%esi)
f01032c2:	e8 a4 09 00 00       	call   f0103c6b <strfind>
f01032c7:	2b 46 08             	sub    0x8(%esi),%eax
f01032ca:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs,&lline,&rline,N_SLINE,addr);
f01032cd:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01032d0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01032d3:	83 c4 08             	add    $0x8,%esp
f01032d6:	ff 75 08             	push   0x8(%ebp)
f01032d9:	6a 44                	push   $0x44
f01032db:	c7 c0 4c 52 10 f0    	mov    $0xf010524c,%eax
f01032e1:	e8 b4 fd ff ff       	call   f010309a <stab_binsearch>
	if(rline >= lline)
f01032e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01032e9:	83 c4 10             	add    $0x10,%esp
f01032ec:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01032ef:	0f 8c d9 00 00 00    	jl     f01033ce <debuginfo_eip+0x23f>
	{
		info->eip_line = stabs[lline].n_desc;
f01032f5:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01032f8:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f01032fb:	c7 c0 4c 52 10 f0    	mov    $0xf010524c,%eax
f0103301:	0f b7 54 88 06       	movzwl 0x6(%eax,%ecx,4),%edx
f0103306:	89 56 04             	mov    %edx,0x4(%esi)
f0103309:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
f010330d:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0103310:	89 75 0c             	mov    %esi,0xc(%ebp)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0103313:	eb 1e                	jmp    f0103333 <debuginfo_eip+0x1a4>
  	        panic("User address");
f0103315:	83 ec 04             	sub    $0x4,%esp
f0103318:	8d 83 33 dd fe ff    	lea    -0x122cd(%ebx),%eax
f010331e:	50                   	push   %eax
f010331f:	6a 7f                	push   $0x7f
f0103321:	8d 83 40 dd fe ff    	lea    -0x122c0(%ebx),%eax
f0103327:	50                   	push   %eax
f0103328:	e8 6c cd ff ff       	call   f0100099 <_panic>
f010332d:	83 ea 01             	sub    $0x1,%edx
f0103330:	83 e8 0c             	sub    $0xc,%eax
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0103333:	39 d7                	cmp    %edx,%edi
f0103335:	7f 3c                	jg     f0103373 <debuginfo_eip+0x1e4>
	       && stabs[lline].n_type != N_SOL
f0103337:	0f b6 08             	movzbl (%eax),%ecx
f010333a:	80 f9 84             	cmp    $0x84,%cl
f010333d:	74 0b                	je     f010334a <debuginfo_eip+0x1bb>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f010333f:	80 f9 64             	cmp    $0x64,%cl
f0103342:	75 e9                	jne    f010332d <debuginfo_eip+0x19e>
f0103344:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0103348:	74 e3                	je     f010332d <debuginfo_eip+0x19e>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010334a:	8b 75 0c             	mov    0xc(%ebp),%esi
f010334d:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0103350:	c7 c0 4c 52 10 f0    	mov    $0xf010524c,%eax
f0103356:	8b 14 90             	mov    (%eax,%edx,4),%edx
f0103359:	c7 c0 cf d4 10 f0    	mov    $0xf010d4cf,%eax
f010335f:	81 e8 75 b7 10 f0    	sub    $0xf010b775,%eax
f0103365:	39 c2                	cmp    %eax,%edx
f0103367:	73 0d                	jae    f0103376 <debuginfo_eip+0x1e7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0103369:	81 c2 75 b7 10 f0    	add    $0xf010b775,%edx
f010336f:	89 16                	mov    %edx,(%esi)
f0103371:	eb 03                	jmp    f0103376 <debuginfo_eip+0x1e7>
f0103373:	8b 75 0c             	mov    0xc(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0103376:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f010337b:	8b 7d bc             	mov    -0x44(%ebp),%edi
f010337e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0103381:	39 cf                	cmp    %ecx,%edi
f0103383:	7d 55                	jge    f01033da <debuginfo_eip+0x24b>
		for (lline = lfun + 1;
f0103385:	83 c7 01             	add    $0x1,%edi
f0103388:	89 f8                	mov    %edi,%eax
f010338a:	8d 0c 7f             	lea    (%edi,%edi,2),%ecx
f010338d:	c7 c2 4c 52 10 f0    	mov    $0xf010524c,%edx
f0103393:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0103397:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f010339a:	eb 04                	jmp    f01033a0 <debuginfo_eip+0x211>
			info->eip_fn_narg++;
f010339c:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01033a0:	39 c3                	cmp    %eax,%ebx
f01033a2:	7e 31                	jle    f01033d5 <debuginfo_eip+0x246>
f01033a4:	0f b6 0a             	movzbl (%edx),%ecx
f01033a7:	83 c0 01             	add    $0x1,%eax
f01033aa:	83 c2 0c             	add    $0xc,%edx
f01033ad:	80 f9 a0             	cmp    $0xa0,%cl
f01033b0:	74 ea                	je     f010339c <debuginfo_eip+0x20d>
	return 0;
f01033b2:	b8 00 00 00 00       	mov    $0x0,%eax
f01033b7:	eb 21                	jmp    f01033da <debuginfo_eip+0x24b>
		return -1;
f01033b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033be:	eb 1a                	jmp    f01033da <debuginfo_eip+0x24b>
f01033c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033c5:	eb 13                	jmp    f01033da <debuginfo_eip+0x24b>
		return -1;
f01033c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033cc:	eb 0c                	jmp    f01033da <debuginfo_eip+0x24b>
		return -1;
f01033ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033d3:	eb 05                	jmp    f01033da <debuginfo_eip+0x24b>
	return 0;
f01033d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033da:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01033dd:	5b                   	pop    %ebx
f01033de:	5e                   	pop    %esi
f01033df:	5f                   	pop    %edi
f01033e0:	5d                   	pop    %ebp
f01033e1:	c3                   	ret    

f01033e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01033e2:	55                   	push   %ebp
f01033e3:	89 e5                	mov    %esp,%ebp
f01033e5:	57                   	push   %edi
f01033e6:	56                   	push   %esi
f01033e7:	53                   	push   %ebx
f01033e8:	83 ec 2c             	sub    $0x2c,%esp
f01033eb:	e8 07 fc ff ff       	call   f0102ff7 <__x86.get_pc_thunk.cx>
f01033f0:	81 c1 1c 3f 01 00    	add    $0x13f1c,%ecx
f01033f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01033f9:	89 c7                	mov    %eax,%edi
f01033fb:	89 d6                	mov    %edx,%esi
f01033fd:	8b 45 08             	mov    0x8(%ebp),%eax
f0103400:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103403:	89 d1                	mov    %edx,%ecx
f0103405:	89 c2                	mov    %eax,%edx
f0103407:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010340a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010340d:	8b 45 10             	mov    0x10(%ebp),%eax
f0103410:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0103413:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103416:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f010341d:	39 c2                	cmp    %eax,%edx
f010341f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0103422:	72 41                	jb     f0103465 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0103424:	83 ec 0c             	sub    $0xc,%esp
f0103427:	ff 75 18             	push   0x18(%ebp)
f010342a:	83 eb 01             	sub    $0x1,%ebx
f010342d:	53                   	push   %ebx
f010342e:	50                   	push   %eax
f010342f:	83 ec 08             	sub    $0x8,%esp
f0103432:	ff 75 e4             	push   -0x1c(%ebp)
f0103435:	ff 75 e0             	push   -0x20(%ebp)
f0103438:	ff 75 d4             	push   -0x2c(%ebp)
f010343b:	ff 75 d0             	push   -0x30(%ebp)
f010343e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0103441:	e8 3a 0a 00 00       	call   f0103e80 <__udivdi3>
f0103446:	83 c4 18             	add    $0x18,%esp
f0103449:	52                   	push   %edx
f010344a:	50                   	push   %eax
f010344b:	89 f2                	mov    %esi,%edx
f010344d:	89 f8                	mov    %edi,%eax
f010344f:	e8 8e ff ff ff       	call   f01033e2 <printnum>
f0103454:	83 c4 20             	add    $0x20,%esp
f0103457:	eb 13                	jmp    f010346c <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0103459:	83 ec 08             	sub    $0x8,%esp
f010345c:	56                   	push   %esi
f010345d:	ff 75 18             	push   0x18(%ebp)
f0103460:	ff d7                	call   *%edi
f0103462:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0103465:	83 eb 01             	sub    $0x1,%ebx
f0103468:	85 db                	test   %ebx,%ebx
f010346a:	7f ed                	jg     f0103459 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010346c:	83 ec 08             	sub    $0x8,%esp
f010346f:	56                   	push   %esi
f0103470:	83 ec 04             	sub    $0x4,%esp
f0103473:	ff 75 e4             	push   -0x1c(%ebp)
f0103476:	ff 75 e0             	push   -0x20(%ebp)
f0103479:	ff 75 d4             	push   -0x2c(%ebp)
f010347c:	ff 75 d0             	push   -0x30(%ebp)
f010347f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0103482:	e8 19 0b 00 00       	call   f0103fa0 <__umoddi3>
f0103487:	83 c4 14             	add    $0x14,%esp
f010348a:	0f be 84 03 4e dd fe 	movsbl -0x122b2(%ebx,%eax,1),%eax
f0103491:	ff 
f0103492:	50                   	push   %eax
f0103493:	ff d7                	call   *%edi
}
f0103495:	83 c4 10             	add    $0x10,%esp
f0103498:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010349b:	5b                   	pop    %ebx
f010349c:	5e                   	pop    %esi
f010349d:	5f                   	pop    %edi
f010349e:	5d                   	pop    %ebp
f010349f:	c3                   	ret    

f01034a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01034a0:	55                   	push   %ebp
f01034a1:	89 e5                	mov    %esp,%ebp
f01034a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01034a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01034aa:	8b 10                	mov    (%eax),%edx
f01034ac:	3b 50 04             	cmp    0x4(%eax),%edx
f01034af:	73 0a                	jae    f01034bb <sprintputch+0x1b>
		*b->buf++ = ch;
f01034b1:	8d 4a 01             	lea    0x1(%edx),%ecx
f01034b4:	89 08                	mov    %ecx,(%eax)
f01034b6:	8b 45 08             	mov    0x8(%ebp),%eax
f01034b9:	88 02                	mov    %al,(%edx)
}
f01034bb:	5d                   	pop    %ebp
f01034bc:	c3                   	ret    

f01034bd <printfmt>:
{
f01034bd:	55                   	push   %ebp
f01034be:	89 e5                	mov    %esp,%ebp
f01034c0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01034c3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01034c6:	50                   	push   %eax
f01034c7:	ff 75 10             	push   0x10(%ebp)
f01034ca:	ff 75 0c             	push   0xc(%ebp)
f01034cd:	ff 75 08             	push   0x8(%ebp)
f01034d0:	e8 05 00 00 00       	call   f01034da <vprintfmt>
}
f01034d5:	83 c4 10             	add    $0x10,%esp
f01034d8:	c9                   	leave  
f01034d9:	c3                   	ret    

f01034da <vprintfmt>:
{
f01034da:	55                   	push   %ebp
f01034db:	89 e5                	mov    %esp,%ebp
f01034dd:	57                   	push   %edi
f01034de:	56                   	push   %esi
f01034df:	53                   	push   %ebx
f01034e0:	83 ec 3c             	sub    $0x3c,%esp
f01034e3:	e8 f9 d1 ff ff       	call   f01006e1 <__x86.get_pc_thunk.ax>
f01034e8:	05 24 3e 01 00       	add    $0x13e24,%eax
f01034ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01034f0:	8b 75 08             	mov    0x8(%ebp),%esi
f01034f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01034f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01034f9:	8d 80 1c 1d 00 00    	lea    0x1d1c(%eax),%eax
f01034ff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0103502:	eb 0a                	jmp    f010350e <vprintfmt+0x34>
			putch(ch, putdat);
f0103504:	83 ec 08             	sub    $0x8,%esp
f0103507:	57                   	push   %edi
f0103508:	50                   	push   %eax
f0103509:	ff d6                	call   *%esi
f010350b:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010350e:	83 c3 01             	add    $0x1,%ebx
f0103511:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0103515:	83 f8 25             	cmp    $0x25,%eax
f0103518:	74 0c                	je     f0103526 <vprintfmt+0x4c>
			if (ch == '\0')
f010351a:	85 c0                	test   %eax,%eax
f010351c:	75 e6                	jne    f0103504 <vprintfmt+0x2a>
}
f010351e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103521:	5b                   	pop    %ebx
f0103522:	5e                   	pop    %esi
f0103523:	5f                   	pop    %edi
f0103524:	5d                   	pop    %ebp
f0103525:	c3                   	ret    
		padc = ' ';
f0103526:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f010352a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0103531:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0103538:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f010353f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103544:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0103547:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010354a:	8d 43 01             	lea    0x1(%ebx),%eax
f010354d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103550:	0f b6 13             	movzbl (%ebx),%edx
f0103553:	8d 42 dd             	lea    -0x23(%edx),%eax
f0103556:	3c 55                	cmp    $0x55,%al
f0103558:	0f 87 fd 03 00 00    	ja     f010395b <.L20>
f010355e:	0f b6 c0             	movzbl %al,%eax
f0103561:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103564:	89 ce                	mov    %ecx,%esi
f0103566:	03 b4 81 d8 dd fe ff 	add    -0x12228(%ecx,%eax,4),%esi
f010356d:	ff e6                	jmp    *%esi

f010356f <.L68>:
f010356f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f0103572:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0103576:	eb d2                	jmp    f010354a <vprintfmt+0x70>

f0103578 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f0103578:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010357b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f010357f:	eb c9                	jmp    f010354a <vprintfmt+0x70>

f0103581 <.L31>:
f0103581:	0f b6 d2             	movzbl %dl,%edx
f0103584:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f0103587:	b8 00 00 00 00       	mov    $0x0,%eax
f010358c:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f010358f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0103592:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0103596:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0103599:	8d 4a d0             	lea    -0x30(%edx),%ecx
f010359c:	83 f9 09             	cmp    $0x9,%ecx
f010359f:	77 58                	ja     f01035f9 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f01035a1:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f01035a4:	eb e9                	jmp    f010358f <.L31+0xe>

f01035a6 <.L34>:
			precision = va_arg(ap, int);
f01035a6:	8b 45 14             	mov    0x14(%ebp),%eax
f01035a9:	8b 00                	mov    (%eax),%eax
f01035ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01035ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01035b1:	8d 40 04             	lea    0x4(%eax),%eax
f01035b4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01035b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f01035ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01035be:	79 8a                	jns    f010354a <vprintfmt+0x70>
				width = precision, precision = -1;
f01035c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01035c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01035c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01035cd:	e9 78 ff ff ff       	jmp    f010354a <vprintfmt+0x70>

f01035d2 <.L33>:
f01035d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01035d5:	85 d2                	test   %edx,%edx
f01035d7:	b8 00 00 00 00       	mov    $0x0,%eax
f01035dc:	0f 49 c2             	cmovns %edx,%eax
f01035df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01035e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f01035e5:	e9 60 ff ff ff       	jmp    f010354a <vprintfmt+0x70>

f01035ea <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f01035ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f01035ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f01035f4:	e9 51 ff ff ff       	jmp    f010354a <vprintfmt+0x70>
f01035f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01035fc:	89 75 08             	mov    %esi,0x8(%ebp)
f01035ff:	eb b9                	jmp    f01035ba <.L34+0x14>

f0103601 <.L27>:
			lflag++;
f0103601:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0103605:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0103608:	e9 3d ff ff ff       	jmp    f010354a <vprintfmt+0x70>

f010360d <.L30>:
			putch(va_arg(ap, int), putdat);
f010360d:	8b 75 08             	mov    0x8(%ebp),%esi
f0103610:	8b 45 14             	mov    0x14(%ebp),%eax
f0103613:	8d 58 04             	lea    0x4(%eax),%ebx
f0103616:	83 ec 08             	sub    $0x8,%esp
f0103619:	57                   	push   %edi
f010361a:	ff 30                	push   (%eax)
f010361c:	ff d6                	call   *%esi
			break;
f010361e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0103621:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f0103624:	e9 c8 02 00 00       	jmp    f01038f1 <.L25+0x45>

f0103629 <.L28>:
			err = va_arg(ap, int);
f0103629:	8b 75 08             	mov    0x8(%ebp),%esi
f010362c:	8b 45 14             	mov    0x14(%ebp),%eax
f010362f:	8d 58 04             	lea    0x4(%eax),%ebx
f0103632:	8b 10                	mov    (%eax),%edx
f0103634:	89 d0                	mov    %edx,%eax
f0103636:	f7 d8                	neg    %eax
f0103638:	0f 48 c2             	cmovs  %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010363b:	83 f8 06             	cmp    $0x6,%eax
f010363e:	7f 27                	jg     f0103667 <.L28+0x3e>
f0103640:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0103643:	8b 14 82             	mov    (%edx,%eax,4),%edx
f0103646:	85 d2                	test   %edx,%edx
f0103648:	74 1d                	je     f0103667 <.L28+0x3e>
				printfmt(putch, putdat, "%s", p);
f010364a:	52                   	push   %edx
f010364b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010364e:	8d 80 d7 d2 fe ff    	lea    -0x12d29(%eax),%eax
f0103654:	50                   	push   %eax
f0103655:	57                   	push   %edi
f0103656:	56                   	push   %esi
f0103657:	e8 61 fe ff ff       	call   f01034bd <printfmt>
f010365c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010365f:	89 5d 14             	mov    %ebx,0x14(%ebp)
f0103662:	e9 8a 02 00 00       	jmp    f01038f1 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f0103667:	50                   	push   %eax
f0103668:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010366b:	8d 80 66 dd fe ff    	lea    -0x1229a(%eax),%eax
f0103671:	50                   	push   %eax
f0103672:	57                   	push   %edi
f0103673:	56                   	push   %esi
f0103674:	e8 44 fe ff ff       	call   f01034bd <printfmt>
f0103679:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010367c:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f010367f:	e9 6d 02 00 00       	jmp    f01038f1 <.L25+0x45>

f0103684 <.L24>:
			if ((p = va_arg(ap, char *)) == NULL)
f0103684:	8b 75 08             	mov    0x8(%ebp),%esi
f0103687:	8b 45 14             	mov    0x14(%ebp),%eax
f010368a:	83 c0 04             	add    $0x4,%eax
f010368d:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0103690:	8b 45 14             	mov    0x14(%ebp),%eax
f0103693:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0103695:	85 d2                	test   %edx,%edx
f0103697:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010369a:	8d 80 5f dd fe ff    	lea    -0x122a1(%eax),%eax
f01036a0:	0f 45 c2             	cmovne %edx,%eax
f01036a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f01036a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01036aa:	7e 06                	jle    f01036b2 <.L24+0x2e>
f01036ac:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f01036b0:	75 0d                	jne    f01036bf <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f01036b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01036b5:	89 c3                	mov    %eax,%ebx
f01036b7:	03 45 d4             	add    -0x2c(%ebp),%eax
f01036ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01036bd:	eb 58                	jmp    f0103717 <.L24+0x93>
f01036bf:	83 ec 08             	sub    $0x8,%esp
f01036c2:	ff 75 d8             	push   -0x28(%ebp)
f01036c5:	ff 75 c8             	push   -0x38(%ebp)
f01036c8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01036cb:	e8 44 04 00 00       	call   f0103b14 <strnlen>
f01036d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01036d3:	29 c2                	sub    %eax,%edx
f01036d5:	89 55 bc             	mov    %edx,-0x44(%ebp)
f01036d8:	83 c4 10             	add    $0x10,%esp
f01036db:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f01036dd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f01036e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01036e4:	eb 0f                	jmp    f01036f5 <.L24+0x71>
					putch(padc, putdat);
f01036e6:	83 ec 08             	sub    $0x8,%esp
f01036e9:	57                   	push   %edi
f01036ea:	ff 75 d4             	push   -0x2c(%ebp)
f01036ed:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01036ef:	83 eb 01             	sub    $0x1,%ebx
f01036f2:	83 c4 10             	add    $0x10,%esp
f01036f5:	85 db                	test   %ebx,%ebx
f01036f7:	7f ed                	jg     f01036e6 <.L24+0x62>
f01036f9:	8b 55 bc             	mov    -0x44(%ebp),%edx
f01036fc:	85 d2                	test   %edx,%edx
f01036fe:	b8 00 00 00 00       	mov    $0x0,%eax
f0103703:	0f 49 c2             	cmovns %edx,%eax
f0103706:	29 c2                	sub    %eax,%edx
f0103708:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010370b:	eb a5                	jmp    f01036b2 <.L24+0x2e>
					putch(ch, putdat);
f010370d:	83 ec 08             	sub    $0x8,%esp
f0103710:	57                   	push   %edi
f0103711:	52                   	push   %edx
f0103712:	ff d6                	call   *%esi
f0103714:	83 c4 10             	add    $0x10,%esp
f0103717:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010371a:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010371c:	83 c3 01             	add    $0x1,%ebx
f010371f:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0103723:	0f be d0             	movsbl %al,%edx
f0103726:	85 d2                	test   %edx,%edx
f0103728:	74 4b                	je     f0103775 <.L24+0xf1>
f010372a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010372e:	78 06                	js     f0103736 <.L24+0xb2>
f0103730:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0103734:	78 1e                	js     f0103754 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f0103736:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f010373a:	74 d1                	je     f010370d <.L24+0x89>
f010373c:	0f be c0             	movsbl %al,%eax
f010373f:	83 e8 20             	sub    $0x20,%eax
f0103742:	83 f8 5e             	cmp    $0x5e,%eax
f0103745:	76 c6                	jbe    f010370d <.L24+0x89>
					putch('?', putdat);
f0103747:	83 ec 08             	sub    $0x8,%esp
f010374a:	57                   	push   %edi
f010374b:	6a 3f                	push   $0x3f
f010374d:	ff d6                	call   *%esi
f010374f:	83 c4 10             	add    $0x10,%esp
f0103752:	eb c3                	jmp    f0103717 <.L24+0x93>
f0103754:	89 cb                	mov    %ecx,%ebx
f0103756:	eb 0e                	jmp    f0103766 <.L24+0xe2>
				putch(' ', putdat);
f0103758:	83 ec 08             	sub    $0x8,%esp
f010375b:	57                   	push   %edi
f010375c:	6a 20                	push   $0x20
f010375e:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0103760:	83 eb 01             	sub    $0x1,%ebx
f0103763:	83 c4 10             	add    $0x10,%esp
f0103766:	85 db                	test   %ebx,%ebx
f0103768:	7f ee                	jg     f0103758 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f010376a:	8b 45 c0             	mov    -0x40(%ebp),%eax
f010376d:	89 45 14             	mov    %eax,0x14(%ebp)
f0103770:	e9 7c 01 00 00       	jmp    f01038f1 <.L25+0x45>
f0103775:	89 cb                	mov    %ecx,%ebx
f0103777:	eb ed                	jmp    f0103766 <.L24+0xe2>

f0103779 <.L29>:
	if (lflag >= 2)
f0103779:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010377c:	8b 75 08             	mov    0x8(%ebp),%esi
f010377f:	83 f9 01             	cmp    $0x1,%ecx
f0103782:	7f 1b                	jg     f010379f <.L29+0x26>
	else if (lflag)
f0103784:	85 c9                	test   %ecx,%ecx
f0103786:	74 63                	je     f01037eb <.L29+0x72>
		return va_arg(*ap, long);
f0103788:	8b 45 14             	mov    0x14(%ebp),%eax
f010378b:	8b 00                	mov    (%eax),%eax
f010378d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103790:	99                   	cltd   
f0103791:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103794:	8b 45 14             	mov    0x14(%ebp),%eax
f0103797:	8d 40 04             	lea    0x4(%eax),%eax
f010379a:	89 45 14             	mov    %eax,0x14(%ebp)
f010379d:	eb 17                	jmp    f01037b6 <.L29+0x3d>
		return va_arg(*ap, long long);
f010379f:	8b 45 14             	mov    0x14(%ebp),%eax
f01037a2:	8b 50 04             	mov    0x4(%eax),%edx
f01037a5:	8b 00                	mov    (%eax),%eax
f01037a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01037aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01037ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01037b0:	8d 40 08             	lea    0x8(%eax),%eax
f01037b3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01037b6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01037b9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
			base = 10;
f01037bc:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f01037c1:	85 db                	test   %ebx,%ebx
f01037c3:	0f 89 0e 01 00 00    	jns    f01038d7 <.L25+0x2b>
				putch('-', putdat);
f01037c9:	83 ec 08             	sub    $0x8,%esp
f01037cc:	57                   	push   %edi
f01037cd:	6a 2d                	push   $0x2d
f01037cf:	ff d6                	call   *%esi
				num = -(long long) num;
f01037d1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01037d4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01037d7:	f7 d9                	neg    %ecx
f01037d9:	83 d3 00             	adc    $0x0,%ebx
f01037dc:	f7 db                	neg    %ebx
f01037de:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01037e1:	ba 0a 00 00 00       	mov    $0xa,%edx
f01037e6:	e9 ec 00 00 00       	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, int);
f01037eb:	8b 45 14             	mov    0x14(%ebp),%eax
f01037ee:	8b 00                	mov    (%eax),%eax
f01037f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01037f3:	99                   	cltd   
f01037f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01037f7:	8b 45 14             	mov    0x14(%ebp),%eax
f01037fa:	8d 40 04             	lea    0x4(%eax),%eax
f01037fd:	89 45 14             	mov    %eax,0x14(%ebp)
f0103800:	eb b4                	jmp    f01037b6 <.L29+0x3d>

f0103802 <.L23>:
	if (lflag >= 2)
f0103802:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103805:	8b 75 08             	mov    0x8(%ebp),%esi
f0103808:	83 f9 01             	cmp    $0x1,%ecx
f010380b:	7f 1e                	jg     f010382b <.L23+0x29>
	else if (lflag)
f010380d:	85 c9                	test   %ecx,%ecx
f010380f:	74 32                	je     f0103843 <.L23+0x41>
		return va_arg(*ap, unsigned long);
f0103811:	8b 45 14             	mov    0x14(%ebp),%eax
f0103814:	8b 08                	mov    (%eax),%ecx
f0103816:	bb 00 00 00 00       	mov    $0x0,%ebx
f010381b:	8d 40 04             	lea    0x4(%eax),%eax
f010381e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0103821:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long);
f0103826:	e9 ac 00 00 00       	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f010382b:	8b 45 14             	mov    0x14(%ebp),%eax
f010382e:	8b 08                	mov    (%eax),%ecx
f0103830:	8b 58 04             	mov    0x4(%eax),%ebx
f0103833:	8d 40 08             	lea    0x8(%eax),%eax
f0103836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0103839:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned long long);
f010383e:	e9 94 00 00 00       	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0103843:	8b 45 14             	mov    0x14(%ebp),%eax
f0103846:	8b 08                	mov    (%eax),%ecx
f0103848:	bb 00 00 00 00       	mov    $0x0,%ebx
f010384d:	8d 40 04             	lea    0x4(%eax),%eax
f0103850:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0103853:	ba 0a 00 00 00       	mov    $0xa,%edx
		return va_arg(*ap, unsigned int);
f0103858:	eb 7d                	jmp    f01038d7 <.L25+0x2b>

f010385a <.L26>:
	if (lflag >= 2)
f010385a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010385d:	8b 75 08             	mov    0x8(%ebp),%esi
f0103860:	83 f9 01             	cmp    $0x1,%ecx
f0103863:	7f 1b                	jg     f0103880 <.L26+0x26>
	else if (lflag)
f0103865:	85 c9                	test   %ecx,%ecx
f0103867:	74 2c                	je     f0103895 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f0103869:	8b 45 14             	mov    0x14(%ebp),%eax
f010386c:	8b 08                	mov    (%eax),%ecx
f010386e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103873:	8d 40 04             	lea    0x4(%eax),%eax
f0103876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0103879:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long);
f010387e:	eb 57                	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0103880:	8b 45 14             	mov    0x14(%ebp),%eax
f0103883:	8b 08                	mov    (%eax),%ecx
f0103885:	8b 58 04             	mov    0x4(%eax),%ebx
f0103888:	8d 40 08             	lea    0x8(%eax),%eax
f010388b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010388e:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned long long);
f0103893:	eb 42                	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0103895:	8b 45 14             	mov    0x14(%ebp),%eax
f0103898:	8b 08                	mov    (%eax),%ecx
f010389a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010389f:	8d 40 04             	lea    0x4(%eax),%eax
f01038a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01038a5:	ba 08 00 00 00       	mov    $0x8,%edx
		return va_arg(*ap, unsigned int);
f01038aa:	eb 2b                	jmp    f01038d7 <.L25+0x2b>

f01038ac <.L25>:
			putch('0', putdat);
f01038ac:	8b 75 08             	mov    0x8(%ebp),%esi
f01038af:	83 ec 08             	sub    $0x8,%esp
f01038b2:	57                   	push   %edi
f01038b3:	6a 30                	push   $0x30
f01038b5:	ff d6                	call   *%esi
			putch('x', putdat);
f01038b7:	83 c4 08             	add    $0x8,%esp
f01038ba:	57                   	push   %edi
f01038bb:	6a 78                	push   $0x78
f01038bd:	ff d6                	call   *%esi
			num = (unsigned long long)
f01038bf:	8b 45 14             	mov    0x14(%ebp),%eax
f01038c2:	8b 08                	mov    (%eax),%ecx
f01038c4:	bb 00 00 00 00       	mov    $0x0,%ebx
			goto number;
f01038c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01038cc:	8d 40 04             	lea    0x4(%eax),%eax
f01038cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01038d2:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
f01038d7:	83 ec 0c             	sub    $0xc,%esp
f01038da:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f01038de:	50                   	push   %eax
f01038df:	ff 75 d4             	push   -0x2c(%ebp)
f01038e2:	52                   	push   %edx
f01038e3:	53                   	push   %ebx
f01038e4:	51                   	push   %ecx
f01038e5:	89 fa                	mov    %edi,%edx
f01038e7:	89 f0                	mov    %esi,%eax
f01038e9:	e8 f4 fa ff ff       	call   f01033e2 <printnum>
			break;
f01038ee:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01038f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01038f4:	e9 15 fc ff ff       	jmp    f010350e <vprintfmt+0x34>

f01038f9 <.L21>:
	if (lflag >= 2)
f01038f9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01038fc:	8b 75 08             	mov    0x8(%ebp),%esi
f01038ff:	83 f9 01             	cmp    $0x1,%ecx
f0103902:	7f 1b                	jg     f010391f <.L21+0x26>
	else if (lflag)
f0103904:	85 c9                	test   %ecx,%ecx
f0103906:	74 2c                	je     f0103934 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f0103908:	8b 45 14             	mov    0x14(%ebp),%eax
f010390b:	8b 08                	mov    (%eax),%ecx
f010390d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103912:	8d 40 04             	lea    0x4(%eax),%eax
f0103915:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103918:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long);
f010391d:	eb b8                	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f010391f:	8b 45 14             	mov    0x14(%ebp),%eax
f0103922:	8b 08                	mov    (%eax),%ecx
f0103924:	8b 58 04             	mov    0x4(%eax),%ebx
f0103927:	8d 40 08             	lea    0x8(%eax),%eax
f010392a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010392d:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned long long);
f0103932:	eb a3                	jmp    f01038d7 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0103934:	8b 45 14             	mov    0x14(%ebp),%eax
f0103937:	8b 08                	mov    (%eax),%ecx
f0103939:	bb 00 00 00 00       	mov    $0x0,%ebx
f010393e:	8d 40 04             	lea    0x4(%eax),%eax
f0103941:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103944:	ba 10 00 00 00       	mov    $0x10,%edx
		return va_arg(*ap, unsigned int);
f0103949:	eb 8c                	jmp    f01038d7 <.L25+0x2b>

f010394b <.L35>:
			putch(ch, putdat);
f010394b:	8b 75 08             	mov    0x8(%ebp),%esi
f010394e:	83 ec 08             	sub    $0x8,%esp
f0103951:	57                   	push   %edi
f0103952:	6a 25                	push   $0x25
f0103954:	ff d6                	call   *%esi
			break;
f0103956:	83 c4 10             	add    $0x10,%esp
f0103959:	eb 96                	jmp    f01038f1 <.L25+0x45>

f010395b <.L20>:
			putch('%', putdat);
f010395b:	8b 75 08             	mov    0x8(%ebp),%esi
f010395e:	83 ec 08             	sub    $0x8,%esp
f0103961:	57                   	push   %edi
f0103962:	6a 25                	push   $0x25
f0103964:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0103966:	83 c4 10             	add    $0x10,%esp
f0103969:	89 d8                	mov    %ebx,%eax
f010396b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010396f:	74 05                	je     f0103976 <.L20+0x1b>
f0103971:	83 e8 01             	sub    $0x1,%eax
f0103974:	eb f5                	jmp    f010396b <.L20+0x10>
f0103976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103979:	e9 73 ff ff ff       	jmp    f01038f1 <.L25+0x45>

f010397e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010397e:	55                   	push   %ebp
f010397f:	89 e5                	mov    %esp,%ebp
f0103981:	53                   	push   %ebx
f0103982:	83 ec 14             	sub    $0x14,%esp
f0103985:	e8 c5 c7 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010398a:	81 c3 82 39 01 00    	add    $0x13982,%ebx
f0103990:	8b 45 08             	mov    0x8(%ebp),%eax
f0103993:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0103996:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103999:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f010399d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01039a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01039a7:	85 c0                	test   %eax,%eax
f01039a9:	74 2b                	je     f01039d6 <vsnprintf+0x58>
f01039ab:	85 d2                	test   %edx,%edx
f01039ad:	7e 27                	jle    f01039d6 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01039af:	ff 75 14             	push   0x14(%ebp)
f01039b2:	ff 75 10             	push   0x10(%ebp)
f01039b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01039b8:	50                   	push   %eax
f01039b9:	8d 83 94 c1 fe ff    	lea    -0x13e6c(%ebx),%eax
f01039bf:	50                   	push   %eax
f01039c0:	e8 15 fb ff ff       	call   f01034da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01039c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01039c8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01039ce:	83 c4 10             	add    $0x10,%esp
}
f01039d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01039d4:	c9                   	leave  
f01039d5:	c3                   	ret    
		return -E_INVAL;
f01039d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01039db:	eb f4                	jmp    f01039d1 <vsnprintf+0x53>

f01039dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01039dd:	55                   	push   %ebp
f01039de:	89 e5                	mov    %esp,%ebp
f01039e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01039e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01039e6:	50                   	push   %eax
f01039e7:	ff 75 10             	push   0x10(%ebp)
f01039ea:	ff 75 0c             	push   0xc(%ebp)
f01039ed:	ff 75 08             	push   0x8(%ebp)
f01039f0:	e8 89 ff ff ff       	call   f010397e <vsnprintf>
	va_end(ap);

	return rc;
}
f01039f5:	c9                   	leave  
f01039f6:	c3                   	ret    

f01039f7 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01039f7:	55                   	push   %ebp
f01039f8:	89 e5                	mov    %esp,%ebp
f01039fa:	57                   	push   %edi
f01039fb:	56                   	push   %esi
f01039fc:	53                   	push   %ebx
f01039fd:	83 ec 1c             	sub    $0x1c,%esp
f0103a00:	e8 4a c7 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0103a05:	81 c3 07 39 01 00    	add    $0x13907,%ebx
f0103a0b:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0103a0e:	85 c0                	test   %eax,%eax
f0103a10:	74 13                	je     f0103a25 <readline+0x2e>
		cprintf("%s", prompt);
f0103a12:	83 ec 08             	sub    $0x8,%esp
f0103a15:	50                   	push   %eax
f0103a16:	8d 83 d7 d2 fe ff    	lea    -0x12d29(%ebx),%eax
f0103a1c:	50                   	push   %eax
f0103a1d:	e8 64 f6 ff ff       	call   f0103086 <cprintf>
f0103a22:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0103a25:	83 ec 0c             	sub    $0xc,%esp
f0103a28:	6a 00                	push   $0x0
f0103a2a:	e8 ac cc ff ff       	call   f01006db <iscons>
f0103a2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103a32:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0103a35:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f0103a3a:	8d 83 d4 1f 00 00    	lea    0x1fd4(%ebx),%eax
f0103a40:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103a43:	eb 45                	jmp    f0103a8a <readline+0x93>
			cprintf("read error: %e\n", c);
f0103a45:	83 ec 08             	sub    $0x8,%esp
f0103a48:	50                   	push   %eax
f0103a49:	8d 83 30 df fe ff    	lea    -0x120d0(%ebx),%eax
f0103a4f:	50                   	push   %eax
f0103a50:	e8 31 f6 ff ff       	call   f0103086 <cprintf>
			return NULL;
f0103a55:	83 c4 10             	add    $0x10,%esp
f0103a58:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0103a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a60:	5b                   	pop    %ebx
f0103a61:	5e                   	pop    %esi
f0103a62:	5f                   	pop    %edi
f0103a63:	5d                   	pop    %ebp
f0103a64:	c3                   	ret    
			if (echoing)
f0103a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103a69:	75 05                	jne    f0103a70 <readline+0x79>
			i--;
f0103a6b:	83 ef 01             	sub    $0x1,%edi
f0103a6e:	eb 1a                	jmp    f0103a8a <readline+0x93>
				cputchar('\b');
f0103a70:	83 ec 0c             	sub    $0xc,%esp
f0103a73:	6a 08                	push   $0x8
f0103a75:	e8 40 cc ff ff       	call   f01006ba <cputchar>
f0103a7a:	83 c4 10             	add    $0x10,%esp
f0103a7d:	eb ec                	jmp    f0103a6b <readline+0x74>
			buf[i++] = c;
f0103a7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103a82:	89 f0                	mov    %esi,%eax
f0103a84:	88 04 39             	mov    %al,(%ecx,%edi,1)
f0103a87:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0103a8a:	e8 3b cc ff ff       	call   f01006ca <getchar>
f0103a8f:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0103a91:	85 c0                	test   %eax,%eax
f0103a93:	78 b0                	js     f0103a45 <readline+0x4e>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0103a95:	83 f8 08             	cmp    $0x8,%eax
f0103a98:	0f 94 c0             	sete   %al
f0103a9b:	83 fe 7f             	cmp    $0x7f,%esi
f0103a9e:	0f 94 c2             	sete   %dl
f0103aa1:	08 d0                	or     %dl,%al
f0103aa3:	74 04                	je     f0103aa9 <readline+0xb2>
f0103aa5:	85 ff                	test   %edi,%edi
f0103aa7:	7f bc                	jg     f0103a65 <readline+0x6e>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0103aa9:	83 fe 1f             	cmp    $0x1f,%esi
f0103aac:	7e 1c                	jle    f0103aca <readline+0xd3>
f0103aae:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0103ab4:	7f 14                	jg     f0103aca <readline+0xd3>
			if (echoing)
f0103ab6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103aba:	74 c3                	je     f0103a7f <readline+0x88>
				cputchar(c);
f0103abc:	83 ec 0c             	sub    $0xc,%esp
f0103abf:	56                   	push   %esi
f0103ac0:	e8 f5 cb ff ff       	call   f01006ba <cputchar>
f0103ac5:	83 c4 10             	add    $0x10,%esp
f0103ac8:	eb b5                	jmp    f0103a7f <readline+0x88>
		} else if (c == '\n' || c == '\r') {
f0103aca:	83 fe 0a             	cmp    $0xa,%esi
f0103acd:	74 05                	je     f0103ad4 <readline+0xdd>
f0103acf:	83 fe 0d             	cmp    $0xd,%esi
f0103ad2:	75 b6                	jne    f0103a8a <readline+0x93>
			if (echoing)
f0103ad4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103ad8:	75 13                	jne    f0103aed <readline+0xf6>
			buf[i] = 0;
f0103ada:	c6 84 3b d4 1f 00 00 	movb   $0x0,0x1fd4(%ebx,%edi,1)
f0103ae1:	00 
			return buf;
f0103ae2:	8d 83 d4 1f 00 00    	lea    0x1fd4(%ebx),%eax
f0103ae8:	e9 70 ff ff ff       	jmp    f0103a5d <readline+0x66>
				cputchar('\n');
f0103aed:	83 ec 0c             	sub    $0xc,%esp
f0103af0:	6a 0a                	push   $0xa
f0103af2:	e8 c3 cb ff ff       	call   f01006ba <cputchar>
f0103af7:	83 c4 10             	add    $0x10,%esp
f0103afa:	eb de                	jmp    f0103ada <readline+0xe3>

f0103afc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0103afc:	55                   	push   %ebp
f0103afd:	89 e5                	mov    %esp,%ebp
f0103aff:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0103b02:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b07:	eb 03                	jmp    f0103b0c <strlen+0x10>
		n++;
f0103b09:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0103b0c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0103b10:	75 f7                	jne    f0103b09 <strlen+0xd>
	return n;
}
f0103b12:	5d                   	pop    %ebp
f0103b13:	c3                   	ret    

f0103b14 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0103b14:	55                   	push   %ebp
f0103b15:	89 e5                	mov    %esp,%ebp
f0103b17:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0103b1d:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b22:	eb 03                	jmp    f0103b27 <strnlen+0x13>
		n++;
f0103b24:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0103b27:	39 d0                	cmp    %edx,%eax
f0103b29:	74 08                	je     f0103b33 <strnlen+0x1f>
f0103b2b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0103b2f:	75 f3                	jne    f0103b24 <strnlen+0x10>
f0103b31:	89 c2                	mov    %eax,%edx
	return n;
}
f0103b33:	89 d0                	mov    %edx,%eax
f0103b35:	5d                   	pop    %ebp
f0103b36:	c3                   	ret    

f0103b37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0103b37:	55                   	push   %ebp
f0103b38:	89 e5                	mov    %esp,%ebp
f0103b3a:	53                   	push   %ebx
f0103b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103b3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0103b41:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b46:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0103b4a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0103b4d:	83 c0 01             	add    $0x1,%eax
f0103b50:	84 d2                	test   %dl,%dl
f0103b52:	75 f2                	jne    f0103b46 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0103b54:	89 c8                	mov    %ecx,%eax
f0103b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b59:	c9                   	leave  
f0103b5a:	c3                   	ret    

f0103b5b <strcat>:

char *
strcat(char *dst, const char *src)
{
f0103b5b:	55                   	push   %ebp
f0103b5c:	89 e5                	mov    %esp,%ebp
f0103b5e:	53                   	push   %ebx
f0103b5f:	83 ec 10             	sub    $0x10,%esp
f0103b62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0103b65:	53                   	push   %ebx
f0103b66:	e8 91 ff ff ff       	call   f0103afc <strlen>
f0103b6b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0103b6e:	ff 75 0c             	push   0xc(%ebp)
f0103b71:	01 d8                	add    %ebx,%eax
f0103b73:	50                   	push   %eax
f0103b74:	e8 be ff ff ff       	call   f0103b37 <strcpy>
	return dst;
}
f0103b79:	89 d8                	mov    %ebx,%eax
f0103b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b7e:	c9                   	leave  
f0103b7f:	c3                   	ret    

f0103b80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0103b80:	55                   	push   %ebp
f0103b81:	89 e5                	mov    %esp,%ebp
f0103b83:	56                   	push   %esi
f0103b84:	53                   	push   %ebx
f0103b85:	8b 75 08             	mov    0x8(%ebp),%esi
f0103b88:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103b8b:	89 f3                	mov    %esi,%ebx
f0103b8d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0103b90:	89 f0                	mov    %esi,%eax
f0103b92:	eb 0f                	jmp    f0103ba3 <strncpy+0x23>
		*dst++ = *src;
f0103b94:	83 c0 01             	add    $0x1,%eax
f0103b97:	0f b6 0a             	movzbl (%edx),%ecx
f0103b9a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0103b9d:	80 f9 01             	cmp    $0x1,%cl
f0103ba0:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
f0103ba3:	39 d8                	cmp    %ebx,%eax
f0103ba5:	75 ed                	jne    f0103b94 <strncpy+0x14>
	}
	return ret;
}
f0103ba7:	89 f0                	mov    %esi,%eax
f0103ba9:	5b                   	pop    %ebx
f0103baa:	5e                   	pop    %esi
f0103bab:	5d                   	pop    %ebp
f0103bac:	c3                   	ret    

f0103bad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0103bad:	55                   	push   %ebp
f0103bae:	89 e5                	mov    %esp,%ebp
f0103bb0:	56                   	push   %esi
f0103bb1:	53                   	push   %ebx
f0103bb2:	8b 75 08             	mov    0x8(%ebp),%esi
f0103bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103bb8:	8b 55 10             	mov    0x10(%ebp),%edx
f0103bbb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0103bbd:	85 d2                	test   %edx,%edx
f0103bbf:	74 21                	je     f0103be2 <strlcpy+0x35>
f0103bc1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0103bc5:	89 f2                	mov    %esi,%edx
f0103bc7:	eb 09                	jmp    f0103bd2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0103bc9:	83 c1 01             	add    $0x1,%ecx
f0103bcc:	83 c2 01             	add    $0x1,%edx
f0103bcf:	88 5a ff             	mov    %bl,-0x1(%edx)
		while (--size > 0 && *src != '\0')
f0103bd2:	39 c2                	cmp    %eax,%edx
f0103bd4:	74 09                	je     f0103bdf <strlcpy+0x32>
f0103bd6:	0f b6 19             	movzbl (%ecx),%ebx
f0103bd9:	84 db                	test   %bl,%bl
f0103bdb:	75 ec                	jne    f0103bc9 <strlcpy+0x1c>
f0103bdd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0103bdf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0103be2:	29 f0                	sub    %esi,%eax
}
f0103be4:	5b                   	pop    %ebx
f0103be5:	5e                   	pop    %esi
f0103be6:	5d                   	pop    %ebp
f0103be7:	c3                   	ret    

f0103be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0103be8:	55                   	push   %ebp
f0103be9:	89 e5                	mov    %esp,%ebp
f0103beb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103bee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0103bf1:	eb 06                	jmp    f0103bf9 <strcmp+0x11>
		p++, q++;
f0103bf3:	83 c1 01             	add    $0x1,%ecx
f0103bf6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0103bf9:	0f b6 01             	movzbl (%ecx),%eax
f0103bfc:	84 c0                	test   %al,%al
f0103bfe:	74 04                	je     f0103c04 <strcmp+0x1c>
f0103c00:	3a 02                	cmp    (%edx),%al
f0103c02:	74 ef                	je     f0103bf3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0103c04:	0f b6 c0             	movzbl %al,%eax
f0103c07:	0f b6 12             	movzbl (%edx),%edx
f0103c0a:	29 d0                	sub    %edx,%eax
}
f0103c0c:	5d                   	pop    %ebp
f0103c0d:	c3                   	ret    

f0103c0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0103c0e:	55                   	push   %ebp
f0103c0f:	89 e5                	mov    %esp,%ebp
f0103c11:	53                   	push   %ebx
f0103c12:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c15:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103c18:	89 c3                	mov    %eax,%ebx
f0103c1a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0103c1d:	eb 06                	jmp    f0103c25 <strncmp+0x17>
		n--, p++, q++;
f0103c1f:	83 c0 01             	add    $0x1,%eax
f0103c22:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0103c25:	39 d8                	cmp    %ebx,%eax
f0103c27:	74 18                	je     f0103c41 <strncmp+0x33>
f0103c29:	0f b6 08             	movzbl (%eax),%ecx
f0103c2c:	84 c9                	test   %cl,%cl
f0103c2e:	74 04                	je     f0103c34 <strncmp+0x26>
f0103c30:	3a 0a                	cmp    (%edx),%cl
f0103c32:	74 eb                	je     f0103c1f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0103c34:	0f b6 00             	movzbl (%eax),%eax
f0103c37:	0f b6 12             	movzbl (%edx),%edx
f0103c3a:	29 d0                	sub    %edx,%eax
}
f0103c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103c3f:	c9                   	leave  
f0103c40:	c3                   	ret    
		return 0;
f0103c41:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c46:	eb f4                	jmp    f0103c3c <strncmp+0x2e>

f0103c48 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0103c48:	55                   	push   %ebp
f0103c49:	89 e5                	mov    %esp,%ebp
f0103c4b:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c4e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103c52:	eb 03                	jmp    f0103c57 <strchr+0xf>
f0103c54:	83 c0 01             	add    $0x1,%eax
f0103c57:	0f b6 10             	movzbl (%eax),%edx
f0103c5a:	84 d2                	test   %dl,%dl
f0103c5c:	74 06                	je     f0103c64 <strchr+0x1c>
		if (*s == c)
f0103c5e:	38 ca                	cmp    %cl,%dl
f0103c60:	75 f2                	jne    f0103c54 <strchr+0xc>
f0103c62:	eb 05                	jmp    f0103c69 <strchr+0x21>
			return (char *) s;
	return 0;
f0103c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103c69:	5d                   	pop    %ebp
f0103c6a:	c3                   	ret    

f0103c6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0103c6b:	55                   	push   %ebp
f0103c6c:	89 e5                	mov    %esp,%ebp
f0103c6e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103c75:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0103c78:	38 ca                	cmp    %cl,%dl
f0103c7a:	74 09                	je     f0103c85 <strfind+0x1a>
f0103c7c:	84 d2                	test   %dl,%dl
f0103c7e:	74 05                	je     f0103c85 <strfind+0x1a>
	for (; *s; s++)
f0103c80:	83 c0 01             	add    $0x1,%eax
f0103c83:	eb f0                	jmp    f0103c75 <strfind+0xa>
			break;
	return (char *) s;
}
f0103c85:	5d                   	pop    %ebp
f0103c86:	c3                   	ret    

f0103c87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0103c87:	55                   	push   %ebp
f0103c88:	89 e5                	mov    %esp,%ebp
f0103c8a:	57                   	push   %edi
f0103c8b:	56                   	push   %esi
f0103c8c:	53                   	push   %ebx
f0103c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0103c93:	85 c9                	test   %ecx,%ecx
f0103c95:	74 2f                	je     f0103cc6 <memset+0x3f>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0103c97:	89 f8                	mov    %edi,%eax
f0103c99:	09 c8                	or     %ecx,%eax
f0103c9b:	a8 03                	test   $0x3,%al
f0103c9d:	75 21                	jne    f0103cc0 <memset+0x39>
		c &= 0xFF;
f0103c9f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0103ca3:	89 d0                	mov    %edx,%eax
f0103ca5:	c1 e0 08             	shl    $0x8,%eax
f0103ca8:	89 d3                	mov    %edx,%ebx
f0103caa:	c1 e3 18             	shl    $0x18,%ebx
f0103cad:	89 d6                	mov    %edx,%esi
f0103caf:	c1 e6 10             	shl    $0x10,%esi
f0103cb2:	09 f3                	or     %esi,%ebx
f0103cb4:	09 da                	or     %ebx,%edx
f0103cb6:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0103cb8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0103cbb:	fc                   	cld    
f0103cbc:	f3 ab                	rep stos %eax,%es:(%edi)
f0103cbe:	eb 06                	jmp    f0103cc6 <memset+0x3f>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0103cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103cc3:	fc                   	cld    
f0103cc4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0103cc6:	89 f8                	mov    %edi,%eax
f0103cc8:	5b                   	pop    %ebx
f0103cc9:	5e                   	pop    %esi
f0103cca:	5f                   	pop    %edi
f0103ccb:	5d                   	pop    %ebp
f0103ccc:	c3                   	ret    

f0103ccd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0103ccd:	55                   	push   %ebp
f0103cce:	89 e5                	mov    %esp,%ebp
f0103cd0:	57                   	push   %edi
f0103cd1:	56                   	push   %esi
f0103cd2:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cd5:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103cd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0103cdb:	39 c6                	cmp    %eax,%esi
f0103cdd:	73 32                	jae    f0103d11 <memmove+0x44>
f0103cdf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0103ce2:	39 c2                	cmp    %eax,%edx
f0103ce4:	76 2b                	jbe    f0103d11 <memmove+0x44>
		s += n;
		d += n;
f0103ce6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103ce9:	89 d6                	mov    %edx,%esi
f0103ceb:	09 fe                	or     %edi,%esi
f0103ced:	09 ce                	or     %ecx,%esi
f0103cef:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0103cf5:	75 0e                	jne    f0103d05 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0103cf7:	83 ef 04             	sub    $0x4,%edi
f0103cfa:	8d 72 fc             	lea    -0x4(%edx),%esi
f0103cfd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0103d00:	fd                   	std    
f0103d01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103d03:	eb 09                	jmp    f0103d0e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0103d05:	83 ef 01             	sub    $0x1,%edi
f0103d08:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0103d0b:	fd                   	std    
f0103d0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0103d0e:	fc                   	cld    
f0103d0f:	eb 1a                	jmp    f0103d2b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103d11:	89 f2                	mov    %esi,%edx
f0103d13:	09 c2                	or     %eax,%edx
f0103d15:	09 ca                	or     %ecx,%edx
f0103d17:	f6 c2 03             	test   $0x3,%dl
f0103d1a:	75 0a                	jne    f0103d26 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0103d1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0103d1f:	89 c7                	mov    %eax,%edi
f0103d21:	fc                   	cld    
f0103d22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103d24:	eb 05                	jmp    f0103d2b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0103d26:	89 c7                	mov    %eax,%edi
f0103d28:	fc                   	cld    
f0103d29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0103d2b:	5e                   	pop    %esi
f0103d2c:	5f                   	pop    %edi
f0103d2d:	5d                   	pop    %ebp
f0103d2e:	c3                   	ret    

f0103d2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0103d2f:	55                   	push   %ebp
f0103d30:	89 e5                	mov    %esp,%ebp
f0103d32:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0103d35:	ff 75 10             	push   0x10(%ebp)
f0103d38:	ff 75 0c             	push   0xc(%ebp)
f0103d3b:	ff 75 08             	push   0x8(%ebp)
f0103d3e:	e8 8a ff ff ff       	call   f0103ccd <memmove>
}
f0103d43:	c9                   	leave  
f0103d44:	c3                   	ret    

f0103d45 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0103d45:	55                   	push   %ebp
f0103d46:	89 e5                	mov    %esp,%ebp
f0103d48:	56                   	push   %esi
f0103d49:	53                   	push   %ebx
f0103d4a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103d50:	89 c6                	mov    %eax,%esi
f0103d52:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0103d55:	eb 06                	jmp    f0103d5d <memcmp+0x18>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0103d57:	83 c0 01             	add    $0x1,%eax
f0103d5a:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
f0103d5d:	39 f0                	cmp    %esi,%eax
f0103d5f:	74 14                	je     f0103d75 <memcmp+0x30>
		if (*s1 != *s2)
f0103d61:	0f b6 08             	movzbl (%eax),%ecx
f0103d64:	0f b6 1a             	movzbl (%edx),%ebx
f0103d67:	38 d9                	cmp    %bl,%cl
f0103d69:	74 ec                	je     f0103d57 <memcmp+0x12>
			return (int) *s1 - (int) *s2;
f0103d6b:	0f b6 c1             	movzbl %cl,%eax
f0103d6e:	0f b6 db             	movzbl %bl,%ebx
f0103d71:	29 d8                	sub    %ebx,%eax
f0103d73:	eb 05                	jmp    f0103d7a <memcmp+0x35>
	}

	return 0;
f0103d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103d7a:	5b                   	pop    %ebx
f0103d7b:	5e                   	pop    %esi
f0103d7c:	5d                   	pop    %ebp
f0103d7d:	c3                   	ret    

f0103d7e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0103d7e:	55                   	push   %ebp
f0103d7f:	89 e5                	mov    %esp,%ebp
f0103d81:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0103d87:	89 c2                	mov    %eax,%edx
f0103d89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0103d8c:	eb 03                	jmp    f0103d91 <memfind+0x13>
f0103d8e:	83 c0 01             	add    $0x1,%eax
f0103d91:	39 d0                	cmp    %edx,%eax
f0103d93:	73 04                	jae    f0103d99 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0103d95:	38 08                	cmp    %cl,(%eax)
f0103d97:	75 f5                	jne    f0103d8e <memfind+0x10>
			break;
	return (void *) s;
}
f0103d99:	5d                   	pop    %ebp
f0103d9a:	c3                   	ret    

f0103d9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0103d9b:	55                   	push   %ebp
f0103d9c:	89 e5                	mov    %esp,%ebp
f0103d9e:	57                   	push   %edi
f0103d9f:	56                   	push   %esi
f0103da0:	53                   	push   %ebx
f0103da1:	8b 55 08             	mov    0x8(%ebp),%edx
f0103da4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0103da7:	eb 03                	jmp    f0103dac <strtol+0x11>
		s++;
f0103da9:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
f0103dac:	0f b6 02             	movzbl (%edx),%eax
f0103daf:	3c 20                	cmp    $0x20,%al
f0103db1:	74 f6                	je     f0103da9 <strtol+0xe>
f0103db3:	3c 09                	cmp    $0x9,%al
f0103db5:	74 f2                	je     f0103da9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0103db7:	3c 2b                	cmp    $0x2b,%al
f0103db9:	74 2a                	je     f0103de5 <strtol+0x4a>
	int neg = 0;
f0103dbb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0103dc0:	3c 2d                	cmp    $0x2d,%al
f0103dc2:	74 2b                	je     f0103def <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103dc4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0103dca:	75 0f                	jne    f0103ddb <strtol+0x40>
f0103dcc:	80 3a 30             	cmpb   $0x30,(%edx)
f0103dcf:	74 28                	je     f0103df9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0103dd1:	85 db                	test   %ebx,%ebx
f0103dd3:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103dd8:	0f 44 d8             	cmove  %eax,%ebx
f0103ddb:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103de0:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0103de3:	eb 46                	jmp    f0103e2b <strtol+0x90>
		s++;
f0103de5:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
f0103de8:	bf 00 00 00 00       	mov    $0x0,%edi
f0103ded:	eb d5                	jmp    f0103dc4 <strtol+0x29>
		s++, neg = 1;
f0103def:	83 c2 01             	add    $0x1,%edx
f0103df2:	bf 01 00 00 00       	mov    $0x1,%edi
f0103df7:	eb cb                	jmp    f0103dc4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103df9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0103dfd:	74 0e                	je     f0103e0d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0103dff:	85 db                	test   %ebx,%ebx
f0103e01:	75 d8                	jne    f0103ddb <strtol+0x40>
		s++, base = 8;
f0103e03:	83 c2 01             	add    $0x1,%edx
f0103e06:	bb 08 00 00 00       	mov    $0x8,%ebx
f0103e0b:	eb ce                	jmp    f0103ddb <strtol+0x40>
		s += 2, base = 16;
f0103e0d:	83 c2 02             	add    $0x2,%edx
f0103e10:	bb 10 00 00 00       	mov    $0x10,%ebx
f0103e15:	eb c4                	jmp    f0103ddb <strtol+0x40>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0103e17:	0f be c0             	movsbl %al,%eax
f0103e1a:	83 e8 30             	sub    $0x30,%eax
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0103e1d:	3b 45 10             	cmp    0x10(%ebp),%eax
f0103e20:	7d 3a                	jge    f0103e5c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0103e22:	83 c2 01             	add    $0x1,%edx
f0103e25:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0103e29:	01 c1                	add    %eax,%ecx
		if (*s >= '0' && *s <= '9')
f0103e2b:	0f b6 02             	movzbl (%edx),%eax
f0103e2e:	8d 70 d0             	lea    -0x30(%eax),%esi
f0103e31:	89 f3                	mov    %esi,%ebx
f0103e33:	80 fb 09             	cmp    $0x9,%bl
f0103e36:	76 df                	jbe    f0103e17 <strtol+0x7c>
		else if (*s >= 'a' && *s <= 'z')
f0103e38:	8d 70 9f             	lea    -0x61(%eax),%esi
f0103e3b:	89 f3                	mov    %esi,%ebx
f0103e3d:	80 fb 19             	cmp    $0x19,%bl
f0103e40:	77 08                	ja     f0103e4a <strtol+0xaf>
			dig = *s - 'a' + 10;
f0103e42:	0f be c0             	movsbl %al,%eax
f0103e45:	83 e8 57             	sub    $0x57,%eax
f0103e48:	eb d3                	jmp    f0103e1d <strtol+0x82>
		else if (*s >= 'A' && *s <= 'Z')
f0103e4a:	8d 70 bf             	lea    -0x41(%eax),%esi
f0103e4d:	89 f3                	mov    %esi,%ebx
f0103e4f:	80 fb 19             	cmp    $0x19,%bl
f0103e52:	77 08                	ja     f0103e5c <strtol+0xc1>
			dig = *s - 'A' + 10;
f0103e54:	0f be c0             	movsbl %al,%eax
f0103e57:	83 e8 37             	sub    $0x37,%eax
f0103e5a:	eb c1                	jmp    f0103e1d <strtol+0x82>
		// we don't properly detect overflow!
	}

	if (endptr)
f0103e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103e60:	74 05                	je     f0103e67 <strtol+0xcc>
		*endptr = (char *) s;
f0103e62:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103e65:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f0103e67:	89 c8                	mov    %ecx,%eax
f0103e69:	f7 d8                	neg    %eax
f0103e6b:	85 ff                	test   %edi,%edi
f0103e6d:	0f 45 c8             	cmovne %eax,%ecx
}
f0103e70:	89 c8                	mov    %ecx,%eax
f0103e72:	5b                   	pop    %ebx
f0103e73:	5e                   	pop    %esi
f0103e74:	5f                   	pop    %edi
f0103e75:	5d                   	pop    %ebp
f0103e76:	c3                   	ret    
f0103e77:	66 90                	xchg   %ax,%ax
f0103e79:	66 90                	xchg   %ax,%ax
f0103e7b:	66 90                	xchg   %ax,%ax
f0103e7d:	66 90                	xchg   %ax,%ax
f0103e7f:	90                   	nop

f0103e80 <__udivdi3>:
f0103e80:	f3 0f 1e fb          	endbr32 
f0103e84:	55                   	push   %ebp
f0103e85:	57                   	push   %edi
f0103e86:	56                   	push   %esi
f0103e87:	53                   	push   %ebx
f0103e88:	83 ec 1c             	sub    $0x1c,%esp
f0103e8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0103e8f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0103e93:	8b 74 24 34          	mov    0x34(%esp),%esi
f0103e97:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0103e9b:	85 c0                	test   %eax,%eax
f0103e9d:	75 19                	jne    f0103eb8 <__udivdi3+0x38>
f0103e9f:	39 f3                	cmp    %esi,%ebx
f0103ea1:	76 4d                	jbe    f0103ef0 <__udivdi3+0x70>
f0103ea3:	31 ff                	xor    %edi,%edi
f0103ea5:	89 e8                	mov    %ebp,%eax
f0103ea7:	89 f2                	mov    %esi,%edx
f0103ea9:	f7 f3                	div    %ebx
f0103eab:	89 fa                	mov    %edi,%edx
f0103ead:	83 c4 1c             	add    $0x1c,%esp
f0103eb0:	5b                   	pop    %ebx
f0103eb1:	5e                   	pop    %esi
f0103eb2:	5f                   	pop    %edi
f0103eb3:	5d                   	pop    %ebp
f0103eb4:	c3                   	ret    
f0103eb5:	8d 76 00             	lea    0x0(%esi),%esi
f0103eb8:	39 f0                	cmp    %esi,%eax
f0103eba:	76 14                	jbe    f0103ed0 <__udivdi3+0x50>
f0103ebc:	31 ff                	xor    %edi,%edi
f0103ebe:	31 c0                	xor    %eax,%eax
f0103ec0:	89 fa                	mov    %edi,%edx
f0103ec2:	83 c4 1c             	add    $0x1c,%esp
f0103ec5:	5b                   	pop    %ebx
f0103ec6:	5e                   	pop    %esi
f0103ec7:	5f                   	pop    %edi
f0103ec8:	5d                   	pop    %ebp
f0103ec9:	c3                   	ret    
f0103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103ed0:	0f bd f8             	bsr    %eax,%edi
f0103ed3:	83 f7 1f             	xor    $0x1f,%edi
f0103ed6:	75 48                	jne    f0103f20 <__udivdi3+0xa0>
f0103ed8:	39 f0                	cmp    %esi,%eax
f0103eda:	72 06                	jb     f0103ee2 <__udivdi3+0x62>
f0103edc:	31 c0                	xor    %eax,%eax
f0103ede:	39 eb                	cmp    %ebp,%ebx
f0103ee0:	77 de                	ja     f0103ec0 <__udivdi3+0x40>
f0103ee2:	b8 01 00 00 00       	mov    $0x1,%eax
f0103ee7:	eb d7                	jmp    f0103ec0 <__udivdi3+0x40>
f0103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103ef0:	89 d9                	mov    %ebx,%ecx
f0103ef2:	85 db                	test   %ebx,%ebx
f0103ef4:	75 0b                	jne    f0103f01 <__udivdi3+0x81>
f0103ef6:	b8 01 00 00 00       	mov    $0x1,%eax
f0103efb:	31 d2                	xor    %edx,%edx
f0103efd:	f7 f3                	div    %ebx
f0103eff:	89 c1                	mov    %eax,%ecx
f0103f01:	31 d2                	xor    %edx,%edx
f0103f03:	89 f0                	mov    %esi,%eax
f0103f05:	f7 f1                	div    %ecx
f0103f07:	89 c6                	mov    %eax,%esi
f0103f09:	89 e8                	mov    %ebp,%eax
f0103f0b:	89 f7                	mov    %esi,%edi
f0103f0d:	f7 f1                	div    %ecx
f0103f0f:	89 fa                	mov    %edi,%edx
f0103f11:	83 c4 1c             	add    $0x1c,%esp
f0103f14:	5b                   	pop    %ebx
f0103f15:	5e                   	pop    %esi
f0103f16:	5f                   	pop    %edi
f0103f17:	5d                   	pop    %ebp
f0103f18:	c3                   	ret    
f0103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103f20:	89 f9                	mov    %edi,%ecx
f0103f22:	ba 20 00 00 00       	mov    $0x20,%edx
f0103f27:	29 fa                	sub    %edi,%edx
f0103f29:	d3 e0                	shl    %cl,%eax
f0103f2b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103f2f:	89 d1                	mov    %edx,%ecx
f0103f31:	89 d8                	mov    %ebx,%eax
f0103f33:	d3 e8                	shr    %cl,%eax
f0103f35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0103f39:	09 c1                	or     %eax,%ecx
f0103f3b:	89 f0                	mov    %esi,%eax
f0103f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103f41:	89 f9                	mov    %edi,%ecx
f0103f43:	d3 e3                	shl    %cl,%ebx
f0103f45:	89 d1                	mov    %edx,%ecx
f0103f47:	d3 e8                	shr    %cl,%eax
f0103f49:	89 f9                	mov    %edi,%ecx
f0103f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103f4f:	89 eb                	mov    %ebp,%ebx
f0103f51:	d3 e6                	shl    %cl,%esi
f0103f53:	89 d1                	mov    %edx,%ecx
f0103f55:	d3 eb                	shr    %cl,%ebx
f0103f57:	09 f3                	or     %esi,%ebx
f0103f59:	89 c6                	mov    %eax,%esi
f0103f5b:	89 f2                	mov    %esi,%edx
f0103f5d:	89 d8                	mov    %ebx,%eax
f0103f5f:	f7 74 24 08          	divl   0x8(%esp)
f0103f63:	89 d6                	mov    %edx,%esi
f0103f65:	89 c3                	mov    %eax,%ebx
f0103f67:	f7 64 24 0c          	mull   0xc(%esp)
f0103f6b:	39 d6                	cmp    %edx,%esi
f0103f6d:	72 19                	jb     f0103f88 <__udivdi3+0x108>
f0103f6f:	89 f9                	mov    %edi,%ecx
f0103f71:	d3 e5                	shl    %cl,%ebp
f0103f73:	39 c5                	cmp    %eax,%ebp
f0103f75:	73 04                	jae    f0103f7b <__udivdi3+0xfb>
f0103f77:	39 d6                	cmp    %edx,%esi
f0103f79:	74 0d                	je     f0103f88 <__udivdi3+0x108>
f0103f7b:	89 d8                	mov    %ebx,%eax
f0103f7d:	31 ff                	xor    %edi,%edi
f0103f7f:	e9 3c ff ff ff       	jmp    f0103ec0 <__udivdi3+0x40>
f0103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103f88:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0103f8b:	31 ff                	xor    %edi,%edi
f0103f8d:	e9 2e ff ff ff       	jmp    f0103ec0 <__udivdi3+0x40>
f0103f92:	66 90                	xchg   %ax,%ax
f0103f94:	66 90                	xchg   %ax,%ax
f0103f96:	66 90                	xchg   %ax,%ax
f0103f98:	66 90                	xchg   %ax,%ax
f0103f9a:	66 90                	xchg   %ax,%ax
f0103f9c:	66 90                	xchg   %ax,%ax
f0103f9e:	66 90                	xchg   %ax,%ax

f0103fa0 <__umoddi3>:
f0103fa0:	f3 0f 1e fb          	endbr32 
f0103fa4:	55                   	push   %ebp
f0103fa5:	57                   	push   %edi
f0103fa6:	56                   	push   %esi
f0103fa7:	53                   	push   %ebx
f0103fa8:	83 ec 1c             	sub    $0x1c,%esp
f0103fab:	8b 74 24 30          	mov    0x30(%esp),%esi
f0103faf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0103fb3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
f0103fb7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
f0103fbb:	89 f0                	mov    %esi,%eax
f0103fbd:	89 da                	mov    %ebx,%edx
f0103fbf:	85 ff                	test   %edi,%edi
f0103fc1:	75 15                	jne    f0103fd8 <__umoddi3+0x38>
f0103fc3:	39 dd                	cmp    %ebx,%ebp
f0103fc5:	76 39                	jbe    f0104000 <__umoddi3+0x60>
f0103fc7:	f7 f5                	div    %ebp
f0103fc9:	89 d0                	mov    %edx,%eax
f0103fcb:	31 d2                	xor    %edx,%edx
f0103fcd:	83 c4 1c             	add    $0x1c,%esp
f0103fd0:	5b                   	pop    %ebx
f0103fd1:	5e                   	pop    %esi
f0103fd2:	5f                   	pop    %edi
f0103fd3:	5d                   	pop    %ebp
f0103fd4:	c3                   	ret    
f0103fd5:	8d 76 00             	lea    0x0(%esi),%esi
f0103fd8:	39 df                	cmp    %ebx,%edi
f0103fda:	77 f1                	ja     f0103fcd <__umoddi3+0x2d>
f0103fdc:	0f bd cf             	bsr    %edi,%ecx
f0103fdf:	83 f1 1f             	xor    $0x1f,%ecx
f0103fe2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0103fe6:	75 40                	jne    f0104028 <__umoddi3+0x88>
f0103fe8:	39 df                	cmp    %ebx,%edi
f0103fea:	72 04                	jb     f0103ff0 <__umoddi3+0x50>
f0103fec:	39 f5                	cmp    %esi,%ebp
f0103fee:	77 dd                	ja     f0103fcd <__umoddi3+0x2d>
f0103ff0:	89 da                	mov    %ebx,%edx
f0103ff2:	89 f0                	mov    %esi,%eax
f0103ff4:	29 e8                	sub    %ebp,%eax
f0103ff6:	19 fa                	sbb    %edi,%edx
f0103ff8:	eb d3                	jmp    f0103fcd <__umoddi3+0x2d>
f0103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0104000:	89 e9                	mov    %ebp,%ecx
f0104002:	85 ed                	test   %ebp,%ebp
f0104004:	75 0b                	jne    f0104011 <__umoddi3+0x71>
f0104006:	b8 01 00 00 00       	mov    $0x1,%eax
f010400b:	31 d2                	xor    %edx,%edx
f010400d:	f7 f5                	div    %ebp
f010400f:	89 c1                	mov    %eax,%ecx
f0104011:	89 d8                	mov    %ebx,%eax
f0104013:	31 d2                	xor    %edx,%edx
f0104015:	f7 f1                	div    %ecx
f0104017:	89 f0                	mov    %esi,%eax
f0104019:	f7 f1                	div    %ecx
f010401b:	89 d0                	mov    %edx,%eax
f010401d:	31 d2                	xor    %edx,%edx
f010401f:	eb ac                	jmp    f0103fcd <__umoddi3+0x2d>
f0104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0104028:	8b 44 24 04          	mov    0x4(%esp),%eax
f010402c:	ba 20 00 00 00       	mov    $0x20,%edx
f0104031:	29 c2                	sub    %eax,%edx
f0104033:	89 c1                	mov    %eax,%ecx
f0104035:	89 e8                	mov    %ebp,%eax
f0104037:	d3 e7                	shl    %cl,%edi
f0104039:	89 d1                	mov    %edx,%ecx
f010403b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010403f:	d3 e8                	shr    %cl,%eax
f0104041:	89 c1                	mov    %eax,%ecx
f0104043:	8b 44 24 04          	mov    0x4(%esp),%eax
f0104047:	09 f9                	or     %edi,%ecx
f0104049:	89 df                	mov    %ebx,%edi
f010404b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010404f:	89 c1                	mov    %eax,%ecx
f0104051:	d3 e5                	shl    %cl,%ebp
f0104053:	89 d1                	mov    %edx,%ecx
f0104055:	d3 ef                	shr    %cl,%edi
f0104057:	89 c1                	mov    %eax,%ecx
f0104059:	89 f0                	mov    %esi,%eax
f010405b:	d3 e3                	shl    %cl,%ebx
f010405d:	89 d1                	mov    %edx,%ecx
f010405f:	89 fa                	mov    %edi,%edx
f0104061:	d3 e8                	shr    %cl,%eax
f0104063:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0104068:	09 d8                	or     %ebx,%eax
f010406a:	f7 74 24 08          	divl   0x8(%esp)
f010406e:	89 d3                	mov    %edx,%ebx
f0104070:	d3 e6                	shl    %cl,%esi
f0104072:	f7 e5                	mul    %ebp
f0104074:	89 c7                	mov    %eax,%edi
f0104076:	89 d1                	mov    %edx,%ecx
f0104078:	39 d3                	cmp    %edx,%ebx
f010407a:	72 06                	jb     f0104082 <__umoddi3+0xe2>
f010407c:	75 0e                	jne    f010408c <__umoddi3+0xec>
f010407e:	39 c6                	cmp    %eax,%esi
f0104080:	73 0a                	jae    f010408c <__umoddi3+0xec>
f0104082:	29 e8                	sub    %ebp,%eax
f0104084:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0104088:	89 d1                	mov    %edx,%ecx
f010408a:	89 c7                	mov    %eax,%edi
f010408c:	89 f5                	mov    %esi,%ebp
f010408e:	8b 74 24 04          	mov    0x4(%esp),%esi
f0104092:	29 fd                	sub    %edi,%ebp
f0104094:	19 cb                	sbb    %ecx,%ebx
f0104096:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f010409b:	89 d8                	mov    %ebx,%eax
f010409d:	d3 e0                	shl    %cl,%eax
f010409f:	89 f1                	mov    %esi,%ecx
f01040a1:	d3 ed                	shr    %cl,%ebp
f01040a3:	d3 eb                	shr    %cl,%ebx
f01040a5:	09 e8                	or     %ebp,%eax
f01040a7:	89 da                	mov    %ebx,%edx
f01040a9:	83 c4 1c             	add    $0x1c,%esp
f01040ac:	5b                   	pop    %ebx
f01040ad:	5e                   	pop    %esi
f01040ae:	5f                   	pop    %edi
f01040af:	5d                   	pop    %ebp
f01040b0:	c3                   	ret    
