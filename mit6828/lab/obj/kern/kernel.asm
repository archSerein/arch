
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
f0100015:	b8 00 30 11 00       	mov    $0x113000,%eax
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
f0100034:	bc 00 10 11 f0       	mov    $0xf0111000,%esp

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
f010004c:	81 c3 bc 22 01 00    	add    $0x122bc,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100052:	c7 c2 60 40 11 f0    	mov    $0xf0114060,%edx
f0100058:	c7 c0 e0 46 11 f0    	mov    $0xf01146e0,%eax
f010005e:	29 d0                	sub    %edx,%eax
f0100060:	50                   	push   %eax
f0100061:	6a 00                	push   $0x0
f0100063:	52                   	push   %edx
f0100064:	e8 e4 17 00 00       	call   f010184d <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100069:	e8 37 05 00 00       	call   f01005a5 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010006e:	83 c4 08             	add    $0x8,%esp
f0100071:	68 ac 1a 00 00       	push   $0x1aac
f0100076:	8d 83 98 f9 fe ff    	lea    -0x10668(%ebx),%eax
f010007c:	50                   	push   %eax
f010007d:	e8 7b 0b 00 00       	call   f0100bfd <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100082:	e8 c7 09 00 00       	call   f0100a4e <mem_init>
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
f01000a3:	81 c3 65 22 01 00    	add    $0x12265,%ebx
	va_list ap;

	if (panicstr)
f01000a9:	83 bb 58 1d 00 00 00 	cmpl   $0x0,0x1d58(%ebx)
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
f01000c4:	89 83 58 1d 00 00    	mov    %eax,0x1d58(%ebx)
	asm volatile("cli; cld");
f01000ca:	fa                   	cli    
f01000cb:	fc                   	cld    
	va_start(ap, fmt);
f01000cc:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000cf:	83 ec 04             	sub    $0x4,%esp
f01000d2:	ff 75 0c             	push   0xc(%ebp)
f01000d5:	ff 75 08             	push   0x8(%ebp)
f01000d8:	8d 83 b3 f9 fe ff    	lea    -0x1064d(%ebx),%eax
f01000de:	50                   	push   %eax
f01000df:	e8 19 0b 00 00       	call   f0100bfd <cprintf>
	vcprintf(fmt, ap);
f01000e4:	83 c4 08             	add    $0x8,%esp
f01000e7:	56                   	push   %esi
f01000e8:	ff 75 10             	push   0x10(%ebp)
f01000eb:	e8 d2 0a 00 00       	call   f0100bc2 <vcprintf>
	cprintf("\n");
f01000f0:	8d 83 ef f9 fe ff    	lea    -0x10611(%ebx),%eax
f01000f6:	89 04 24             	mov    %eax,(%esp)
f01000f9:	e8 ff 0a 00 00       	call   f0100bfd <cprintf>
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
f010010d:	81 c3 fb 21 01 00    	add    $0x121fb,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100113:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f0100116:	83 ec 04             	sub    $0x4,%esp
f0100119:	ff 75 0c             	push   0xc(%ebp)
f010011c:	ff 75 08             	push   0x8(%ebp)
f010011f:	8d 83 cb f9 fe ff    	lea    -0x10635(%ebx),%eax
f0100125:	50                   	push   %eax
f0100126:	e8 d2 0a 00 00       	call   f0100bfd <cprintf>
	vcprintf(fmt, ap);
f010012b:	83 c4 08             	add    $0x8,%esp
f010012e:	56                   	push   %esi
f010012f:	ff 75 10             	push   0x10(%ebp)
f0100132:	e8 8b 0a 00 00       	call   f0100bc2 <vcprintf>
	cprintf("\n");
f0100137:	8d 83 ef f9 fe ff    	lea    -0x10611(%ebx),%eax
f010013d:	89 04 24             	mov    %eax,(%esp)
f0100140:	e8 b8 0a 00 00       	call   f0100bfd <cprintf>
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
f010017b:	81 c6 8d 21 01 00    	add    $0x1218d,%esi
f0100181:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f0100183:	8d 1d 98 1d 00 00    	lea    0x1d98,%ebx
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
f01001db:	81 c3 2d 21 01 00    	add    $0x1212d,%ebx
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
f0100207:	8b 8b 78 1d 00 00    	mov    0x1d78(%ebx),%ecx
f010020d:	f6 c1 40             	test   $0x40,%cl
f0100210:	74 0e                	je     f0100220 <kbd_proc_data+0x4f>
		data |= 0x80;
f0100212:	83 c8 80             	or     $0xffffff80,%eax
f0100215:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100217:	83 e1 bf             	and    $0xffffffbf,%ecx
f010021a:	89 8b 78 1d 00 00    	mov    %ecx,0x1d78(%ebx)
	shift |= shiftcode[data];
f0100220:	0f b6 d2             	movzbl %dl,%edx
f0100223:	0f b6 84 13 18 fb fe 	movzbl -0x104e8(%ebx,%edx,1),%eax
f010022a:	ff 
f010022b:	0b 83 78 1d 00 00    	or     0x1d78(%ebx),%eax
	shift ^= togglecode[data];
f0100231:	0f b6 8c 13 18 fa fe 	movzbl -0x105e8(%ebx,%edx,1),%ecx
f0100238:	ff 
f0100239:	31 c8                	xor    %ecx,%eax
f010023b:	89 83 78 1d 00 00    	mov    %eax,0x1d78(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100241:	89 c1                	mov    %eax,%ecx
f0100243:	83 e1 03             	and    $0x3,%ecx
f0100246:	8b 8c 8b f8 1c 00 00 	mov    0x1cf8(%ebx,%ecx,4),%ecx
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
f0100267:	83 8b 78 1d 00 00 40 	orl    $0x40,0x1d78(%ebx)
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
f010027c:	8b 8b 78 1d 00 00    	mov    0x1d78(%ebx),%ecx
f0100282:	83 e0 7f             	and    $0x7f,%eax
f0100285:	f6 c1 40             	test   $0x40,%cl
f0100288:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010028b:	0f b6 d2             	movzbl %dl,%edx
f010028e:	0f b6 84 13 18 fb fe 	movzbl -0x104e8(%ebx,%edx,1),%eax
f0100295:	ff 
f0100296:	83 c8 40             	or     $0x40,%eax
f0100299:	0f b6 c0             	movzbl %al,%eax
f010029c:	f7 d0                	not    %eax
f010029e:	21 c8                	and    %ecx,%eax
f01002a0:	89 83 78 1d 00 00    	mov    %eax,0x1d78(%ebx)
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
f01002ca:	8d 83 e5 f9 fe ff    	lea    -0x1061b(%ebx),%eax
f01002d0:	50                   	push   %eax
f01002d1:	e8 27 09 00 00       	call   f0100bfd <cprintf>
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
f0100305:	81 c3 03 20 01 00    	add    $0x12003,%ebx
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
f0100400:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f0100407:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010040d:	c1 e8 16             	shr    $0x16,%eax
f0100410:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100413:	c1 e0 04             	shl    $0x4,%eax
f0100416:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
	if (crt_pos >= CRT_SIZE) {
f010041d:	66 81 bb a0 1f 00 00 	cmpw   $0x7cf,0x1fa0(%ebx)
f0100424:	cf 07 
f0100426:	0f 87 98 00 00 00    	ja     f01004c4 <cons_putc+0x1cd>
	outb(addr_6845, 14);
f010042c:	8b 8b a8 1f 00 00    	mov    0x1fa8(%ebx),%ecx
f0100432:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100437:	89 ca                	mov    %ecx,%edx
f0100439:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010043a:	0f b7 9b a0 1f 00 00 	movzwl 0x1fa0(%ebx),%ebx
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
f0100462:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f0100469:	66 85 c0             	test   %ax,%ax
f010046c:	74 be                	je     f010042c <cons_putc+0x135>
			crt_pos--;
f010046e:	83 e8 01             	sub    $0x1,%eax
f0100471:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100478:	0f b7 c0             	movzwl %ax,%eax
f010047b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f010047f:	b2 00                	mov    $0x0,%dl
f0100481:	83 ca 20             	or     $0x20,%edx
f0100484:	8b 8b a4 1f 00 00    	mov    0x1fa4(%ebx),%ecx
f010048a:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f010048e:	eb 8d                	jmp    f010041d <cons_putc+0x126>
		crt_pos += CRT_COLS;
f0100490:	66 83 83 a0 1f 00 00 	addw   $0x50,0x1fa0(%ebx)
f0100497:	50 
f0100498:	e9 63 ff ff ff       	jmp    f0100400 <cons_putc+0x109>
		crt_buf[crt_pos++] = c;		/* write the character */
f010049d:	0f b7 83 a0 1f 00 00 	movzwl 0x1fa0(%ebx),%eax
f01004a4:	8d 50 01             	lea    0x1(%eax),%edx
f01004a7:	66 89 93 a0 1f 00 00 	mov    %dx,0x1fa0(%ebx)
f01004ae:	0f b7 c0             	movzwl %ax,%eax
f01004b1:	8b 93 a4 1f 00 00    	mov    0x1fa4(%ebx),%edx
f01004b7:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01004bb:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f01004bf:	e9 59 ff ff ff       	jmp    f010041d <cons_putc+0x126>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004c4:	8b 83 a4 1f 00 00    	mov    0x1fa4(%ebx),%eax
f01004ca:	83 ec 04             	sub    $0x4,%esp
f01004cd:	68 00 0f 00 00       	push   $0xf00
f01004d2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d8:	52                   	push   %edx
f01004d9:	50                   	push   %eax
f01004da:	e8 ba 13 00 00       	call   f0101899 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004df:	8b 93 a4 1f 00 00    	mov    0x1fa4(%ebx),%edx
f01004e5:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004eb:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004f1:	83 c4 10             	add    $0x10,%esp
f01004f4:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004f9:	83 c0 02             	add    $0x2,%eax
f01004fc:	39 d0                	cmp    %edx,%eax
f01004fe:	75 f4                	jne    f01004f4 <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f0100500:	66 83 ab a0 1f 00 00 	subw   $0x50,0x1fa0(%ebx)
f0100507:	50 
f0100508:	e9 1f ff ff ff       	jmp    f010042c <cons_putc+0x135>

f010050d <serial_intr>:
{
f010050d:	e8 cf 01 00 00       	call   f01006e1 <__x86.get_pc_thunk.ax>
f0100512:	05 f6 1d 01 00       	add    $0x11df6,%eax
	if (serial_exists)
f0100517:	80 b8 ac 1f 00 00 00 	cmpb   $0x0,0x1fac(%eax)
f010051e:	75 01                	jne    f0100521 <serial_intr+0x14>
f0100520:	c3                   	ret    
{
f0100521:	55                   	push   %ebp
f0100522:	89 e5                	mov    %esp,%ebp
f0100524:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100527:	8d 80 4b de fe ff    	lea    -0x121b5(%eax),%eax
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
f010053f:	05 c9 1d 01 00       	add    $0x11dc9,%eax
	cons_intr(kbd_proc_data);
f0100544:	8d 80 c9 de fe ff    	lea    -0x12137(%eax),%eax
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
f010055d:	81 c3 ab 1d 01 00    	add    $0x11dab,%ebx
	serial_intr();
f0100563:	e8 a5 ff ff ff       	call   f010050d <serial_intr>
	kbd_intr();
f0100568:	e8 c7 ff ff ff       	call   f0100534 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010056d:	8b 83 98 1f 00 00    	mov    0x1f98(%ebx),%eax
	return 0;
f0100573:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100578:	3b 83 9c 1f 00 00    	cmp    0x1f9c(%ebx),%eax
f010057e:	74 1e                	je     f010059e <cons_getc+0x4d>
		c = cons.buf[cons.rpos++];
f0100580:	8d 48 01             	lea    0x1(%eax),%ecx
f0100583:	0f b6 94 03 98 1d 00 	movzbl 0x1d98(%ebx,%eax,1),%edx
f010058a:	00 
			cons.rpos = 0;
f010058b:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100590:	b8 00 00 00 00       	mov    $0x0,%eax
f0100595:	0f 45 c1             	cmovne %ecx,%eax
f0100598:	89 83 98 1f 00 00    	mov    %eax,0x1f98(%ebx)
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
f01005b3:	81 c3 55 1d 01 00    	add    $0x11d55,%ebx
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
f01005e4:	89 8b a8 1f 00 00    	mov    %ecx,0x1fa8(%ebx)
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
f010060c:	89 bb a4 1f 00 00    	mov    %edi,0x1fa4(%ebx)
	pos |= inb(addr_6845 + 1);
f0100612:	0f b6 c0             	movzbl %al,%eax
f0100615:	0b 45 e4             	or     -0x1c(%ebp),%eax
	crt_pos = pos;
f0100618:	66 89 83 a0 1f 00 00 	mov    %ax,0x1fa0(%ebx)
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
f0100670:	0f 95 83 ac 1f 00 00 	setne  0x1fac(%ebx)
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
f01006a9:	8d 83 f1 f9 fe ff    	lea    -0x1060f(%ebx),%eax
f01006af:	50                   	push   %eax
f01006b0:	e8 48 05 00 00       	call   f0100bfd <cprintf>
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
f01006f3:	81 c3 15 1c 01 00    	add    $0x11c15,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01006f9:	83 ec 04             	sub    $0x4,%esp
f01006fc:	8d 83 18 fc fe ff    	lea    -0x103e8(%ebx),%eax
f0100702:	50                   	push   %eax
f0100703:	8d 83 36 fc fe ff    	lea    -0x103ca(%ebx),%eax
f0100709:	50                   	push   %eax
f010070a:	8d b3 3b fc fe ff    	lea    -0x103c5(%ebx),%esi
f0100710:	56                   	push   %esi
f0100711:	e8 e7 04 00 00       	call   f0100bfd <cprintf>
f0100716:	83 c4 0c             	add    $0xc,%esp
f0100719:	8d 83 e8 fc fe ff    	lea    -0x10318(%ebx),%eax
f010071f:	50                   	push   %eax
f0100720:	8d 83 44 fc fe ff    	lea    -0x103bc(%ebx),%eax
f0100726:	50                   	push   %eax
f0100727:	56                   	push   %esi
f0100728:	e8 d0 04 00 00       	call   f0100bfd <cprintf>
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
f0100747:	81 c3 c1 1b 01 00    	add    $0x11bc1,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010074d:	8d 83 4d fc fe ff    	lea    -0x103b3(%ebx),%eax
f0100753:	50                   	push   %eax
f0100754:	e8 a4 04 00 00       	call   f0100bfd <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100759:	83 c4 08             	add    $0x8,%esp
f010075c:	ff b3 f8 ff ff ff    	push   -0x8(%ebx)
f0100762:	8d 83 10 fd fe ff    	lea    -0x102f0(%ebx),%eax
f0100768:	50                   	push   %eax
f0100769:	e8 8f 04 00 00       	call   f0100bfd <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010076e:	83 c4 0c             	add    $0xc,%esp
f0100771:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f0100777:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f010077d:	50                   	push   %eax
f010077e:	57                   	push   %edi
f010077f:	8d 83 38 fd fe ff    	lea    -0x102c8(%ebx),%eax
f0100785:	50                   	push   %eax
f0100786:	e8 72 04 00 00       	call   f0100bfd <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010078b:	83 c4 0c             	add    $0xc,%esp
f010078e:	c7 c0 91 1c 10 f0    	mov    $0xf0101c91,%eax
f0100794:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010079a:	52                   	push   %edx
f010079b:	50                   	push   %eax
f010079c:	8d 83 5c fd fe ff    	lea    -0x102a4(%ebx),%eax
f01007a2:	50                   	push   %eax
f01007a3:	e8 55 04 00 00       	call   f0100bfd <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007a8:	83 c4 0c             	add    $0xc,%esp
f01007ab:	c7 c0 60 40 11 f0    	mov    $0xf0114060,%eax
f01007b1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007b7:	52                   	push   %edx
f01007b8:	50                   	push   %eax
f01007b9:	8d 83 80 fd fe ff    	lea    -0x10280(%ebx),%eax
f01007bf:	50                   	push   %eax
f01007c0:	e8 38 04 00 00       	call   f0100bfd <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01007c5:	83 c4 0c             	add    $0xc,%esp
f01007c8:	c7 c6 e0 46 11 f0    	mov    $0xf01146e0,%esi
f01007ce:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01007d4:	50                   	push   %eax
f01007d5:	56                   	push   %esi
f01007d6:	8d 83 a4 fd fe ff    	lea    -0x1025c(%ebx),%eax
f01007dc:	50                   	push   %eax
f01007dd:	e8 1b 04 00 00       	call   f0100bfd <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007e2:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024); 
f01007e5:	29 fe                	sub    %edi,%esi
f01007e7:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007ed:	c1 fe 0a             	sar    $0xa,%esi
f01007f0:	56                   	push   %esi
f01007f1:	8d 83 c8 fd fe ff    	lea    -0x10238(%ebx),%eax
f01007f7:	50                   	push   %eax
f01007f8:	e8 00 04 00 00       	call   f0100bfd <cprintf>
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
f0100818:	81 c3 f0 1a 01 00    	add    $0x11af0,%ebx
	// Your code here.

	cprintf("Stack backtrace:\n");
f010081e:	8d 83 66 fc fe ff    	lea    -0x1039a(%ebx),%eax
f0100824:	50                   	push   %eax
f0100825:	e8 d3 03 00 00       	call   f0100bfd <cprintf>

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
f010082f:	8d 83 f4 fd fe ff    	lea    -0x1020c(%ebx),%eax
f0100835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*((uint32_t *)ebp+2),*((uint32_t *)ebp+3),*((uint32_t *)ebp+4),*((uint32_t *)ebp+5),
		*((uint32_t *)ebp+6));

		debuginfo_eip(eip,&info);

		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f0100838:	8d 83 78 fc fe ff    	lea    -0x10388(%ebx),%eax
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
f010085a:	e8 9e 03 00 00       	call   f0100bfd <cprintf>
		debuginfo_eip(eip,&info);
f010085f:	83 c4 18             	add    $0x18,%esp
f0100862:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100865:	50                   	push   %eax
f0100866:	57                   	push   %edi
f0100867:	e8 9e 04 00 00       	call   f0100d0a <debuginfo_eip>
		cprintf("         %s:%d: %.*s+%u\n",info.eip_file,info.eip_line,
f010086c:	83 c4 08             	add    $0x8,%esp
f010086f:	2b 7d e0             	sub    -0x20(%ebp),%edi
f0100872:	57                   	push   %edi
f0100873:	ff 75 d8             	push   -0x28(%ebp)
f0100876:	ff 75 dc             	push   -0x24(%ebp)
f0100879:	ff 75 d4             	push   -0x2c(%ebp)
f010087c:	ff 75 d0             	push   -0x30(%ebp)
f010087f:	ff 75 c0             	push   -0x40(%ebp)
f0100882:	e8 76 03 00 00       	call   f0100bfd <cprintf>
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
f01008ab:	81 c3 5d 1a 01 00    	add    $0x11a5d,%ebx
	char *buf;

	cprintf("%u decimal is %o octal!\n", 6828,6828);      
f01008b1:	68 ac 1a 00 00       	push   $0x1aac
f01008b6:	68 ac 1a 00 00       	push   $0x1aac
f01008bb:	8d 83 91 fc fe ff    	lea    -0x1036f(%ebx),%eax
f01008c1:	50                   	push   %eax
f01008c2:	e8 36 03 00 00       	call   f0100bfd <cprintf>
	cprintf("Welcome to the JOS kernel monitor!\n");
f01008c7:	8d 83 2c fe fe ff    	lea    -0x101d4(%ebx),%eax
f01008cd:	89 04 24             	mov    %eax,(%esp)
f01008d0:	e8 28 03 00 00       	call   f0100bfd <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008d5:	8d 83 50 fe fe ff    	lea    -0x101b0(%ebx),%eax
f01008db:	89 04 24             	mov    %eax,(%esp)
f01008de:	e8 1a 03 00 00       	call   f0100bfd <cprintf>
f01008e3:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f01008e6:	8d bb ae fc fe ff    	lea    -0x10352(%ebx),%edi
f01008ec:	eb 4a                	jmp    f0100938 <monitor+0x9b>
f01008ee:	83 ec 08             	sub    $0x8,%esp
f01008f1:	0f be c0             	movsbl %al,%eax
f01008f4:	50                   	push   %eax
f01008f5:	57                   	push   %edi
f01008f6:	e8 0d 0f 00 00       	call   f0101808 <strchr>
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
f0100929:	8d 83 b3 fc fe ff    	lea    -0x1034d(%ebx),%eax
f010092f:	50                   	push   %eax
f0100930:	e8 c8 02 00 00       	call   f0100bfd <cprintf>
			return 0;
f0100935:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f0100938:	8d 83 aa fc fe ff    	lea    -0x10356(%ebx),%eax
f010093e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0100941:	83 ec 0c             	sub    $0xc,%esp
f0100944:	ff 75 a4             	push   -0x5c(%ebp)
f0100947:	e8 4b 0c 00 00       	call   f0101597 <readline>
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
f0100977:	e8 8c 0e 00 00       	call   f0101808 <strchr>
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
f01009a0:	8d 83 36 fc fe ff    	lea    -0x103ca(%ebx),%eax
f01009a6:	50                   	push   %eax
f01009a7:	ff 75 a8             	push   -0x58(%ebp)
f01009aa:	e8 f3 0d 00 00       	call   f01017a2 <strcmp>
f01009af:	83 c4 10             	add    $0x10,%esp
f01009b2:	85 c0                	test   %eax,%eax
f01009b4:	74 38                	je     f01009ee <monitor+0x151>
f01009b6:	83 ec 08             	sub    $0x8,%esp
f01009b9:	8d 83 44 fc fe ff    	lea    -0x103bc(%ebx),%eax
f01009bf:	50                   	push   %eax
f01009c0:	ff 75 a8             	push   -0x58(%ebp)
f01009c3:	e8 da 0d 00 00       	call   f01017a2 <strcmp>
f01009c8:	83 c4 10             	add    $0x10,%esp
f01009cb:	85 c0                	test   %eax,%eax
f01009cd:	74 1a                	je     f01009e9 <monitor+0x14c>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009cf:	83 ec 08             	sub    $0x8,%esp
f01009d2:	ff 75 a8             	push   -0x58(%ebp)
f01009d5:	8d 83 d0 fc fe ff    	lea    -0x10330(%ebx),%eax
f01009db:	50                   	push   %eax
f01009dc:	e8 1c 02 00 00       	call   f0100bfd <cprintf>
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
f01009fe:	ff 94 83 10 1d 00 00 	call   *0x1d10(%ebx,%eax,4)
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
f0100a26:	81 c3 e2 18 01 00    	add    $0x118e2,%ebx
f0100a2c:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a2e:	50                   	push   %eax
f0100a2f:	e8 3a 01 00 00       	call   f0100b6e <mc146818_read>
f0100a34:	89 c7                	mov    %eax,%edi
f0100a36:	83 c6 01             	add    $0x1,%esi
f0100a39:	89 34 24             	mov    %esi,(%esp)
f0100a3c:	e8 2d 01 00 00       	call   f0100b6e <mc146818_read>
f0100a41:	c1 e0 08             	shl    $0x8,%eax
f0100a44:	09 f8                	or     %edi,%eax
}
f0100a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a49:	5b                   	pop    %ebx
f0100a4a:	5e                   	pop    %esi
f0100a4b:	5f                   	pop    %edi
f0100a4c:	5d                   	pop    %ebp
f0100a4d:	c3                   	ret    

f0100a4e <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0100a4e:	55                   	push   %ebp
f0100a4f:	89 e5                	mov    %esp,%ebp
f0100a51:	57                   	push   %edi
f0100a52:	56                   	push   %esi
f0100a53:	53                   	push   %ebx
f0100a54:	83 ec 0c             	sub    $0xc,%esp
f0100a57:	e8 f3 f6 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100a5c:	81 c3 ac 18 01 00    	add    $0x118ac,%ebx
	basemem = nvram_read(NVRAM_BASELO);
f0100a62:	b8 15 00 00 00       	mov    $0x15,%eax
f0100a67:	e8 ac ff ff ff       	call   f0100a18 <nvram_read>
f0100a6c:	89 c6                	mov    %eax,%esi
	extmem = nvram_read(NVRAM_EXTLO);
f0100a6e:	b8 17 00 00 00       	mov    $0x17,%eax
f0100a73:	e8 a0 ff ff ff       	call   f0100a18 <nvram_read>
f0100a78:	89 c7                	mov    %eax,%edi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0100a7a:	b8 34 00 00 00       	mov    $0x34,%eax
f0100a7f:	e8 94 ff ff ff       	call   f0100a18 <nvram_read>
	if (ext16mem)
f0100a84:	c1 e0 06             	shl    $0x6,%eax
f0100a87:	74 3e                	je     f0100ac7 <mem_init+0x79>
		totalmem = 16 * 1024 + ext16mem;
f0100a89:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f0100a8e:	89 c2                	mov    %eax,%edx
f0100a90:	c1 ea 02             	shr    $0x2,%edx
f0100a93:	89 93 b8 1f 00 00    	mov    %edx,0x1fb8(%ebx)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0100a99:	89 c2                	mov    %eax,%edx
f0100a9b:	29 f2                	sub    %esi,%edx
f0100a9d:	52                   	push   %edx
f0100a9e:	56                   	push   %esi
f0100a9f:	50                   	push   %eax
f0100aa0:	8d 83 78 fe fe ff    	lea    -0x10188(%ebx),%eax
f0100aa6:	50                   	push   %eax
f0100aa7:	e8 51 01 00 00       	call   f0100bfd <cprintf>

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();

	// Remove this line when you're ready to test this function.
	panic("mem_init: This function is not finished\n");
f0100aac:	83 c4 0c             	add    $0xc,%esp
f0100aaf:	8d 83 b4 fe fe ff    	lea    -0x1014c(%ebx),%eax
f0100ab5:	50                   	push   %eax
f0100ab6:	68 80 00 00 00       	push   $0x80
f0100abb:	8d 83 dd fe fe ff    	lea    -0x10123(%ebx),%eax
f0100ac1:	50                   	push   %eax
f0100ac2:	e8 d2 f5 ff ff       	call   f0100099 <_panic>
		totalmem = basemem;
f0100ac7:	89 f0                	mov    %esi,%eax
	else if (extmem)
f0100ac9:	85 ff                	test   %edi,%edi
f0100acb:	74 c1                	je     f0100a8e <mem_init+0x40>
		totalmem = 1 * 1024 + extmem;
f0100acd:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
f0100ad3:	eb b9                	jmp    f0100a8e <mem_init+0x40>

f0100ad5 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0100ad5:	55                   	push   %ebp
f0100ad6:	89 e5                	mov    %esp,%ebp
f0100ad8:	57                   	push   %edi
f0100ad9:	56                   	push   %esi
f0100ada:	53                   	push   %ebx
f0100adb:	e8 8a 00 00 00       	call   f0100b6a <__x86.get_pc_thunk.dx>
f0100ae0:	81 c2 28 18 01 00    	add    $0x11828,%edx
f0100ae6:	8b b2 bc 1f 00 00    	mov    0x1fbc(%edx),%esi
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	for (i = 0; i < npages; i++) {
f0100aec:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100af1:	b8 00 00 00 00       	mov    $0x0,%eax
f0100af6:	bf 01 00 00 00       	mov    $0x1,%edi
f0100afb:	eb 24                	jmp    f0100b21 <page_init+0x4c>
f0100afd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
		pages[i].pp_ref = 0;
f0100b04:	89 cb                	mov    %ecx,%ebx
f0100b06:	03 9a b0 1f 00 00    	add    0x1fb0(%edx),%ebx
f0100b0c:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
		pages[i].pp_link = page_free_list;
f0100b12:	89 33                	mov    %esi,(%ebx)
		page_free_list = &pages[i];
f0100b14:	89 ce                	mov    %ecx,%esi
f0100b16:	03 b2 b0 1f 00 00    	add    0x1fb0(%edx),%esi
	for (i = 0; i < npages; i++) {
f0100b1c:	83 c0 01             	add    $0x1,%eax
f0100b1f:	89 f9                	mov    %edi,%ecx
f0100b21:	39 82 b8 1f 00 00    	cmp    %eax,0x1fb8(%edx)
f0100b27:	77 d4                	ja     f0100afd <page_init+0x28>
f0100b29:	84 c9                	test   %cl,%cl
f0100b2b:	74 06                	je     f0100b33 <page_init+0x5e>
f0100b2d:	89 b2 bc 1f 00 00    	mov    %esi,0x1fbc(%edx)
	}
}
f0100b33:	5b                   	pop    %ebx
f0100b34:	5e                   	pop    %esi
f0100b35:	5f                   	pop    %edi
f0100b36:	5d                   	pop    %ebp
f0100b37:	c3                   	ret    

f0100b38 <page_alloc>:
struct PageInfo *
page_alloc(int alloc_flags)
{
	// Fill this function in
	return 0;
}
f0100b38:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b3d:	c3                   	ret    

f0100b3e <page_free>:
page_free(struct PageInfo *pp)
{
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
}
f0100b3e:	c3                   	ret    

f0100b3f <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f0100b3f:	55                   	push   %ebp
f0100b40:	89 e5                	mov    %esp,%ebp
f0100b42:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0100b45:	66 83 68 04 01       	subw   $0x1,0x4(%eax)
		page_free(pp);
}
f0100b4a:	5d                   	pop    %ebp
f0100b4b:	c3                   	ret    

f0100b4c <pgdir_walk>:
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
	return NULL;
}
f0100b4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b51:	c3                   	ret    

f0100b52 <page_insert>:
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	// Fill this function in
	return 0;
}
f0100b52:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b57:	c3                   	ret    

f0100b58 <page_lookup>:
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	// Fill this function in
	return NULL;
}
f0100b58:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b5d:	c3                   	ret    

f0100b5e <page_remove>:
//
void
page_remove(pde_t *pgdir, void *va)
{
	// Fill this function in
}
f0100b5e:	c3                   	ret    

f0100b5f <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0100b5f:	55                   	push   %ebp
f0100b60:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100b65:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
f0100b68:	5d                   	pop    %ebp
f0100b69:	c3                   	ret    

f0100b6a <__x86.get_pc_thunk.dx>:
f0100b6a:	8b 14 24             	mov    (%esp),%edx
f0100b6d:	c3                   	ret    

f0100b6e <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0100b6e:	55                   	push   %ebp
f0100b6f:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100b71:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b74:	ba 70 00 00 00       	mov    $0x70,%edx
f0100b79:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100b7a:	ba 71 00 00 00       	mov    $0x71,%edx
f0100b7f:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0100b80:	0f b6 c0             	movzbl %al,%eax
}
f0100b83:	5d                   	pop    %ebp
f0100b84:	c3                   	ret    

f0100b85 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0100b85:	55                   	push   %ebp
f0100b86:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100b88:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b8b:	ba 70 00 00 00       	mov    $0x70,%edx
f0100b90:	ee                   	out    %al,(%dx)
f0100b91:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100b94:	ba 71 00 00 00       	mov    $0x71,%edx
f0100b99:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0100b9a:	5d                   	pop    %ebp
f0100b9b:	c3                   	ret    

f0100b9c <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100b9c:	f3 0f 1e fb          	endbr32 
f0100ba0:	55                   	push   %ebp
f0100ba1:	89 e5                	mov    %esp,%ebp
f0100ba3:	53                   	push   %ebx
f0100ba4:	83 ec 10             	sub    $0x10,%esp
f0100ba7:	e8 a3 f5 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100bac:	81 c3 5c 17 01 00    	add    $0x1175c,%ebx
	cputchar(ch);
f0100bb2:	ff 75 08             	push   0x8(%ebp)
f0100bb5:	e8 00 fb ff ff       	call   f01006ba <cputchar>
	*cnt++;
}
f0100bba:	83 c4 10             	add    $0x10,%esp
f0100bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bc0:	c9                   	leave  
f0100bc1:	c3                   	ret    

f0100bc2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0100bc2:	f3 0f 1e fb          	endbr32 
f0100bc6:	55                   	push   %ebp
f0100bc7:	89 e5                	mov    %esp,%ebp
f0100bc9:	53                   	push   %ebx
f0100bca:	83 ec 14             	sub    $0x14,%esp
f0100bcd:	e8 7d f5 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100bd2:	81 c3 36 17 01 00    	add    $0x11736,%ebx
	int cnt = 0;
f0100bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0100bdf:	ff 75 0c             	push   0xc(%ebp)
f0100be2:	ff 75 08             	push   0x8(%ebp)
f0100be5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100be8:	50                   	push   %eax
f0100be9:	8d 83 94 e8 fe ff    	lea    -0x1176c(%ebx),%eax
f0100bef:	50                   	push   %eax
f0100bf0:	e8 68 04 00 00       	call   f010105d <vprintfmt>
	return cnt;
}
f0100bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100bf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bfb:	c9                   	leave  
f0100bfc:	c3                   	ret    

f0100bfd <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100bfd:	f3 0f 1e fb          	endbr32 
f0100c01:	55                   	push   %ebp
f0100c02:	89 e5                	mov    %esp,%ebp
f0100c04:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0100c07:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0100c0a:	50                   	push   %eax
f0100c0b:	ff 75 08             	push   0x8(%ebp)
f0100c0e:	e8 af ff ff ff       	call   f0100bc2 <vcprintf>
	va_end(ap);

	return cnt;
}
f0100c13:	c9                   	leave  
f0100c14:	c3                   	ret    

f0100c15 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100c15:	55                   	push   %ebp
f0100c16:	89 e5                	mov    %esp,%ebp
f0100c18:	57                   	push   %edi
f0100c19:	56                   	push   %esi
f0100c1a:	53                   	push   %ebx
f0100c1b:	83 ec 14             	sub    $0x14,%esp
f0100c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100c21:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100c24:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100c27:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100c2a:	8b 1a                	mov    (%edx),%ebx
f0100c2c:	8b 01                	mov    (%ecx),%eax
f0100c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100c31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0100c38:	eb 2f                	jmp    f0100c69 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0100c3a:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0100c3d:	39 c3                	cmp    %eax,%ebx
f0100c3f:	7f 4e                	jg     f0100c8f <stab_binsearch+0x7a>
f0100c41:	0f b6 0a             	movzbl (%edx),%ecx
f0100c44:	83 ea 0c             	sub    $0xc,%edx
f0100c47:	39 f1                	cmp    %esi,%ecx
f0100c49:	75 ef                	jne    f0100c3a <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100c4b:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100c4e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100c51:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100c55:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100c58:	73 3a                	jae    f0100c94 <stab_binsearch+0x7f>
			*region_left = m;
f0100c5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100c5d:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0100c5f:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0100c62:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0100c69:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0100c6c:	7f 53                	jg     f0100cc1 <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0100c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c71:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0100c74:	89 d0                	mov    %edx,%eax
f0100c76:	c1 e8 1f             	shr    $0x1f,%eax
f0100c79:	01 d0                	add    %edx,%eax
f0100c7b:	89 c7                	mov    %eax,%edi
f0100c7d:	d1 ff                	sar    %edi
f0100c7f:	83 e0 fe             	and    $0xfffffffe,%eax
f0100c82:	01 f8                	add    %edi,%eax
f0100c84:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100c87:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0100c8b:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0100c8d:	eb ae                	jmp    f0100c3d <stab_binsearch+0x28>
			l = true_m + 1;
f0100c8f:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100c92:	eb d5                	jmp    f0100c69 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0100c94:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100c97:	76 14                	jbe    f0100cad <stab_binsearch+0x98>
			*region_right = m - 1;
f0100c99:	83 e8 01             	sub    $0x1,%eax
f0100c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100c9f:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100ca2:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0100ca4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100cab:	eb bc                	jmp    f0100c69 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100cad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100cb0:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0100cb2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100cb6:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0100cb8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100cbf:	eb a8                	jmp    f0100c69 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0100cc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0100cc5:	75 15                	jne    f0100cdc <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0100cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100cca:	8b 00                	mov    (%eax),%eax
f0100ccc:	83 e8 01             	sub    $0x1,%eax
f0100ccf:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100cd2:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100cd4:	83 c4 14             	add    $0x14,%esp
f0100cd7:	5b                   	pop    %ebx
f0100cd8:	5e                   	pop    %esi
f0100cd9:	5f                   	pop    %edi
f0100cda:	5d                   	pop    %ebp
f0100cdb:	c3                   	ret    
		for (l = *region_right;
f0100cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100cdf:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100ce1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100ce4:	8b 0f                	mov    (%edi),%ecx
f0100ce6:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100ce9:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0100cec:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0100cf0:	39 c1                	cmp    %eax,%ecx
f0100cf2:	7d 0f                	jge    f0100d03 <stab_binsearch+0xee>
f0100cf4:	0f b6 1a             	movzbl (%edx),%ebx
f0100cf7:	83 ea 0c             	sub    $0xc,%edx
f0100cfa:	39 f3                	cmp    %esi,%ebx
f0100cfc:	74 05                	je     f0100d03 <stab_binsearch+0xee>
		     l--)
f0100cfe:	83 e8 01             	sub    $0x1,%eax
f0100d01:	eb ed                	jmp    f0100cf0 <stab_binsearch+0xdb>
		*region_left = l;
f0100d03:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100d06:	89 07                	mov    %eax,(%edi)
}
f0100d08:	eb ca                	jmp    f0100cd4 <stab_binsearch+0xbf>

f0100d0a <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100d0a:	55                   	push   %ebp
f0100d0b:	89 e5                	mov    %esp,%ebp
f0100d0d:	57                   	push   %edi
f0100d0e:	56                   	push   %esi
f0100d0f:	53                   	push   %ebx
f0100d10:	83 ec 3c             	sub    $0x3c,%esp
f0100d13:	e8 37 f4 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100d18:	81 c3 f0 15 01 00    	add    $0x115f0,%ebx
f0100d1e:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100d21:	8d 83 e9 fe fe ff    	lea    -0x10117(%ebx),%eax
f0100d27:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f0100d29:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0100d30:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f0100d33:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
f0100d3d:	89 46 10             	mov    %eax,0x10(%esi)
	info->eip_fn_narg = 0;
f0100d40:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100d47:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f0100d4c:	0f 86 3e 01 00 00    	jbe    f0100e90 <debuginfo_eip+0x186>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100d52:	c7 c0 e1 67 10 f0    	mov    $0xf01067e1,%eax
f0100d58:	39 83 fc ff ff ff    	cmp    %eax,-0x4(%ebx)
f0100d5e:	0f 86 d0 01 00 00    	jbe    f0100f34 <debuginfo_eip+0x22a>
f0100d64:	c7 c0 07 84 10 f0    	mov    $0xf0108407,%eax
f0100d6a:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0100d6e:	0f 85 c7 01 00 00    	jne    f0100f3b <debuginfo_eip+0x231>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100d74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100d7b:	c7 c0 0c 24 10 f0    	mov    $0xf010240c,%eax
f0100d81:	c7 c2 e0 67 10 f0    	mov    $0xf01067e0,%edx
f0100d87:	29 c2                	sub    %eax,%edx
f0100d89:	c1 fa 02             	sar    $0x2,%edx
f0100d8c:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0100d92:	83 ea 01             	sub    $0x1,%edx
f0100d95:	89 55 e0             	mov    %edx,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100d98:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100d9b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100d9e:	83 ec 08             	sub    $0x8,%esp
f0100da1:	ff 75 08             	push   0x8(%ebp)
f0100da4:	6a 64                	push   $0x64
f0100da6:	e8 6a fe ff ff       	call   f0100c15 <stab_binsearch>
	if (lfile == 0)
f0100dab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100dae:	83 c4 10             	add    $0x10,%esp
f0100db1:	85 ff                	test   %edi,%edi
f0100db3:	0f 84 89 01 00 00    	je     f0100f42 <debuginfo_eip+0x238>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100db9:	89 7d dc             	mov    %edi,-0x24(%ebp)
	rfun = rfile;
f0100dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100dbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0100dc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100dc5:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100dc8:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100dcb:	83 ec 08             	sub    $0x8,%esp
f0100dce:	ff 75 08             	push   0x8(%ebp)
f0100dd1:	6a 24                	push   $0x24
f0100dd3:	c7 c0 0c 24 10 f0    	mov    $0xf010240c,%eax
f0100dd9:	e8 37 fe ff ff       	call   f0100c15 <stab_binsearch>

	if (lfun <= rfun) {
f0100dde:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100de1:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0100de4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100de7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0100dea:	83 c4 10             	add    $0x10,%esp
f0100ded:	89 f8                	mov    %edi,%eax
f0100def:	39 d1                	cmp    %edx,%ecx
f0100df1:	7f 39                	jg     f0100e2c <debuginfo_eip+0x122>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100df3:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0100df6:	c7 c2 0c 24 10 f0    	mov    $0xf010240c,%edx
f0100dfc:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
f0100dff:	8b 11                	mov    (%ecx),%edx
f0100e01:	c7 c0 07 84 10 f0    	mov    $0xf0108407,%eax
f0100e07:	81 e8 e1 67 10 f0    	sub    $0xf01067e1,%eax
f0100e0d:	39 c2                	cmp    %eax,%edx
f0100e0f:	73 09                	jae    f0100e1a <debuginfo_eip+0x110>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100e11:	81 c2 e1 67 10 f0    	add    $0xf01067e1,%edx
f0100e17:	89 56 08             	mov    %edx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100e1a:	8b 41 08             	mov    0x8(%ecx),%eax
f0100e1d:	89 46 10             	mov    %eax,0x10(%esi)
		addr -= info->eip_fn_addr;
f0100e20:	29 45 08             	sub    %eax,0x8(%ebp)
f0100e23:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100e26:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0100e29:	89 4d c0             	mov    %ecx,-0x40(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0100e2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100e2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100e32:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100e35:	83 ec 08             	sub    $0x8,%esp
f0100e38:	6a 3a                	push   $0x3a
f0100e3a:	ff 76 08             	push   0x8(%esi)
f0100e3d:	e8 eb 09 00 00       	call   f010182d <strfind>
f0100e42:	2b 46 08             	sub    0x8(%esi),%eax
f0100e45:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs,&lline,&rline,N_SLINE,addr);
f0100e48:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100e4b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100e4e:	83 c4 08             	add    $0x8,%esp
f0100e51:	ff 75 08             	push   0x8(%ebp)
f0100e54:	6a 44                	push   $0x44
f0100e56:	c7 c0 0c 24 10 f0    	mov    $0xf010240c,%eax
f0100e5c:	e8 b4 fd ff ff       	call   f0100c15 <stab_binsearch>
	if(rline >= lline)
f0100e61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e64:	83 c4 10             	add    $0x10,%esp
f0100e67:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0100e6a:	0f 8c d9 00 00 00    	jl     f0100f49 <debuginfo_eip+0x23f>
	{
		info->eip_line = stabs[lline].n_desc;
f0100e70:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0100e73:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0100e76:	c7 c0 0c 24 10 f0    	mov    $0xf010240c,%eax
f0100e7c:	0f b7 54 88 06       	movzwl 0x6(%eax,%ecx,4),%edx
f0100e81:	89 56 04             	mov    %edx,0x4(%esi)
f0100e84:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
f0100e88:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0100e8b:	89 75 0c             	mov    %esi,0xc(%ebp)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100e8e:	eb 1e                	jmp    f0100eae <debuginfo_eip+0x1a4>
  	        panic("User address");
f0100e90:	83 ec 04             	sub    $0x4,%esp
f0100e93:	8d 83 f3 fe fe ff    	lea    -0x1010d(%ebx),%eax
f0100e99:	50                   	push   %eax
f0100e9a:	6a 7f                	push   $0x7f
f0100e9c:	8d 83 00 ff fe ff    	lea    -0x10100(%ebx),%eax
f0100ea2:	50                   	push   %eax
f0100ea3:	e8 f1 f1 ff ff       	call   f0100099 <_panic>
f0100ea8:	83 ea 01             	sub    $0x1,%edx
f0100eab:	83 e8 0c             	sub    $0xc,%eax
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100eae:	39 d7                	cmp    %edx,%edi
f0100eb0:	7f 3c                	jg     f0100eee <debuginfo_eip+0x1e4>
	       && stabs[lline].n_type != N_SOL
f0100eb2:	0f b6 08             	movzbl (%eax),%ecx
f0100eb5:	80 f9 84             	cmp    $0x84,%cl
f0100eb8:	74 0b                	je     f0100ec5 <debuginfo_eip+0x1bb>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100eba:	80 f9 64             	cmp    $0x64,%cl
f0100ebd:	75 e9                	jne    f0100ea8 <debuginfo_eip+0x19e>
f0100ebf:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0100ec3:	74 e3                	je     f0100ea8 <debuginfo_eip+0x19e>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
f0100ec8:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0100ecb:	c7 c0 0c 24 10 f0    	mov    $0xf010240c,%eax
f0100ed1:	8b 14 90             	mov    (%eax,%edx,4),%edx
f0100ed4:	c7 c0 07 84 10 f0    	mov    $0xf0108407,%eax
f0100eda:	81 e8 e1 67 10 f0    	sub    $0xf01067e1,%eax
f0100ee0:	39 c2                	cmp    %eax,%edx
f0100ee2:	73 0d                	jae    f0100ef1 <debuginfo_eip+0x1e7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100ee4:	81 c2 e1 67 10 f0    	add    $0xf01067e1,%edx
f0100eea:	89 16                	mov    %edx,(%esi)
f0100eec:	eb 03                	jmp    f0100ef1 <debuginfo_eip+0x1e7>
f0100eee:	8b 75 0c             	mov    0xc(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0100ef1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0100ef6:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0100ef9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0100efc:	39 cf                	cmp    %ecx,%edi
f0100efe:	7d 55                	jge    f0100f55 <debuginfo_eip+0x24b>
		for (lline = lfun + 1;
f0100f00:	83 c7 01             	add    $0x1,%edi
f0100f03:	89 f8                	mov    %edi,%eax
f0100f05:	8d 0c 7f             	lea    (%edi,%edi,2),%ecx
f0100f08:	c7 c2 0c 24 10 f0    	mov    $0xf010240c,%edx
f0100f0e:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0100f12:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f15:	eb 04                	jmp    f0100f1b <debuginfo_eip+0x211>
			info->eip_fn_narg++;
f0100f17:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100f1b:	39 c3                	cmp    %eax,%ebx
f0100f1d:	7e 31                	jle    f0100f50 <debuginfo_eip+0x246>
f0100f1f:	0f b6 0a             	movzbl (%edx),%ecx
f0100f22:	83 c0 01             	add    $0x1,%eax
f0100f25:	83 c2 0c             	add    $0xc,%edx
f0100f28:	80 f9 a0             	cmp    $0xa0,%cl
f0100f2b:	74 ea                	je     f0100f17 <debuginfo_eip+0x20d>
	return 0;
f0100f2d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f32:	eb 21                	jmp    f0100f55 <debuginfo_eip+0x24b>
		return -1;
f0100f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100f39:	eb 1a                	jmp    f0100f55 <debuginfo_eip+0x24b>
f0100f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100f40:	eb 13                	jmp    f0100f55 <debuginfo_eip+0x24b>
		return -1;
f0100f42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100f47:	eb 0c                	jmp    f0100f55 <debuginfo_eip+0x24b>
		return -1;
f0100f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100f4e:	eb 05                	jmp    f0100f55 <debuginfo_eip+0x24b>
	return 0;
f0100f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f58:	5b                   	pop    %ebx
f0100f59:	5e                   	pop    %esi
f0100f5a:	5f                   	pop    %edi
f0100f5b:	5d                   	pop    %ebp
f0100f5c:	c3                   	ret    

f0100f5d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100f5d:	55                   	push   %ebp
f0100f5e:	89 e5                	mov    %esp,%ebp
f0100f60:	57                   	push   %edi
f0100f61:	56                   	push   %esi
f0100f62:	53                   	push   %ebx
f0100f63:	83 ec 2c             	sub    $0x2c,%esp
f0100f66:	e8 28 06 00 00       	call   f0101593 <__x86.get_pc_thunk.cx>
f0100f6b:	81 c1 9d 13 01 00    	add    $0x1139d,%ecx
f0100f71:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0100f74:	89 c7                	mov    %eax,%edi
f0100f76:	89 d6                	mov    %edx,%esi
f0100f78:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100f7e:	89 d1                	mov    %edx,%ecx
f0100f80:	89 c2                	mov    %eax,%edx
f0100f82:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f85:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0100f88:	8b 45 10             	mov    0x10(%ebp),%eax
f0100f8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100f8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100f91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100f98:	39 c2                	cmp    %eax,%edx
f0100f9a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0100f9d:	72 41                	jb     f0100fe0 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100f9f:	83 ec 0c             	sub    $0xc,%esp
f0100fa2:	ff 75 18             	push   0x18(%ebp)
f0100fa5:	83 eb 01             	sub    $0x1,%ebx
f0100fa8:	53                   	push   %ebx
f0100fa9:	50                   	push   %eax
f0100faa:	83 ec 08             	sub    $0x8,%esp
f0100fad:	ff 75 e4             	push   -0x1c(%ebp)
f0100fb0:	ff 75 e0             	push   -0x20(%ebp)
f0100fb3:	ff 75 d4             	push   -0x2c(%ebp)
f0100fb6:	ff 75 d0             	push   -0x30(%ebp)
f0100fb9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100fbc:	e8 9f 0a 00 00       	call   f0101a60 <__udivdi3>
f0100fc1:	83 c4 18             	add    $0x18,%esp
f0100fc4:	52                   	push   %edx
f0100fc5:	50                   	push   %eax
f0100fc6:	89 f2                	mov    %esi,%edx
f0100fc8:	89 f8                	mov    %edi,%eax
f0100fca:	e8 8e ff ff ff       	call   f0100f5d <printnum>
f0100fcf:	83 c4 20             	add    $0x20,%esp
f0100fd2:	eb 13                	jmp    f0100fe7 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0100fd4:	83 ec 08             	sub    $0x8,%esp
f0100fd7:	56                   	push   %esi
f0100fd8:	ff 75 18             	push   0x18(%ebp)
f0100fdb:	ff d7                	call   *%edi
f0100fdd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0100fe0:	83 eb 01             	sub    $0x1,%ebx
f0100fe3:	85 db                	test   %ebx,%ebx
f0100fe5:	7f ed                	jg     f0100fd4 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0100fe7:	83 ec 08             	sub    $0x8,%esp
f0100fea:	56                   	push   %esi
f0100feb:	83 ec 04             	sub    $0x4,%esp
f0100fee:	ff 75 e4             	push   -0x1c(%ebp)
f0100ff1:	ff 75 e0             	push   -0x20(%ebp)
f0100ff4:	ff 75 d4             	push   -0x2c(%ebp)
f0100ff7:	ff 75 d0             	push   -0x30(%ebp)
f0100ffa:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100ffd:	e8 7e 0b 00 00       	call   f0101b80 <__umoddi3>
f0101002:	83 c4 14             	add    $0x14,%esp
f0101005:	0f be 84 03 0e ff fe 	movsbl -0x100f2(%ebx,%eax,1),%eax
f010100c:	ff 
f010100d:	50                   	push   %eax
f010100e:	ff d7                	call   *%edi
}
f0101010:	83 c4 10             	add    $0x10,%esp
f0101013:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101016:	5b                   	pop    %ebx
f0101017:	5e                   	pop    %esi
f0101018:	5f                   	pop    %edi
f0101019:	5d                   	pop    %ebp
f010101a:	c3                   	ret    

f010101b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010101b:	f3 0f 1e fb          	endbr32 
f010101f:	55                   	push   %ebp
f0101020:	89 e5                	mov    %esp,%ebp
f0101022:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0101025:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0101029:	8b 10                	mov    (%eax),%edx
f010102b:	3b 50 04             	cmp    0x4(%eax),%edx
f010102e:	73 0a                	jae    f010103a <sprintputch+0x1f>
		*b->buf++ = ch;
f0101030:	8d 4a 01             	lea    0x1(%edx),%ecx
f0101033:	89 08                	mov    %ecx,(%eax)
f0101035:	8b 45 08             	mov    0x8(%ebp),%eax
f0101038:	88 02                	mov    %al,(%edx)
}
f010103a:	5d                   	pop    %ebp
f010103b:	c3                   	ret    

f010103c <printfmt>:
{
f010103c:	f3 0f 1e fb          	endbr32 
f0101040:	55                   	push   %ebp
f0101041:	89 e5                	mov    %esp,%ebp
f0101043:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0101046:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0101049:	50                   	push   %eax
f010104a:	ff 75 10             	push   0x10(%ebp)
f010104d:	ff 75 0c             	push   0xc(%ebp)
f0101050:	ff 75 08             	push   0x8(%ebp)
f0101053:	e8 05 00 00 00       	call   f010105d <vprintfmt>
}
f0101058:	83 c4 10             	add    $0x10,%esp
f010105b:	c9                   	leave  
f010105c:	c3                   	ret    

f010105d <vprintfmt>:
{
f010105d:	f3 0f 1e fb          	endbr32 
f0101061:	55                   	push   %ebp
f0101062:	89 e5                	mov    %esp,%ebp
f0101064:	57                   	push   %edi
f0101065:	56                   	push   %esi
f0101066:	53                   	push   %ebx
f0101067:	83 ec 3c             	sub    $0x3c,%esp
f010106a:	e8 72 f6 ff ff       	call   f01006e1 <__x86.get_pc_thunk.ax>
f010106f:	05 99 12 01 00       	add    $0x11299,%eax
f0101074:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101077:	8b 75 08             	mov    0x8(%ebp),%esi
f010107a:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010107d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0101080:	8d 80 20 1d 00 00    	lea    0x1d20(%eax),%eax
f0101086:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0101089:	e9 cd 03 00 00       	jmp    f010145b <.L25+0x48>
		padc = ' ';
f010108e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f0101092:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0101099:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f01010a0:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f01010a7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01010ac:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01010af:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01010b2:	8d 43 01             	lea    0x1(%ebx),%eax
f01010b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01010b8:	0f b6 13             	movzbl (%ebx),%edx
f01010bb:	8d 42 dd             	lea    -0x23(%edx),%eax
f01010be:	3c 55                	cmp    $0x55,%al
f01010c0:	0f 87 21 04 00 00    	ja     f01014e7 <.L20>
f01010c6:	0f b6 c0             	movzbl %al,%eax
f01010c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01010cc:	89 ce                	mov    %ecx,%esi
f01010ce:	03 b4 81 9c ff fe ff 	add    -0x10064(%ecx,%eax,4),%esi
f01010d5:	3e ff e6             	notrack jmp *%esi

f01010d8 <.L68>:
f01010d8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f01010db:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f01010df:	eb d1                	jmp    f01010b2 <vprintfmt+0x55>

f01010e1 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f01010e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01010e4:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f01010e8:	eb c8                	jmp    f01010b2 <vprintfmt+0x55>

f01010ea <.L31>:
f01010ea:	0f b6 d2             	movzbl %dl,%edx
f01010ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f01010f0:	b8 00 00 00 00       	mov    $0x0,%eax
f01010f5:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f01010f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01010fb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01010ff:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0101102:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0101105:	83 f9 09             	cmp    $0x9,%ecx
f0101108:	77 58                	ja     f0101162 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f010110a:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f010110d:	eb e9                	jmp    f01010f8 <.L31+0xe>

f010110f <.L34>:
			precision = va_arg(ap, int);
f010110f:	8b 45 14             	mov    0x14(%ebp),%eax
f0101112:	8b 00                	mov    (%eax),%eax
f0101114:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101117:	8b 45 14             	mov    0x14(%ebp),%eax
f010111a:	8d 40 04             	lea    0x4(%eax),%eax
f010111d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0101120:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f0101123:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101127:	79 89                	jns    f01010b2 <vprintfmt+0x55>
				width = precision, precision = -1;
f0101129:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010112c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010112f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0101136:	e9 77 ff ff ff       	jmp    f01010b2 <vprintfmt+0x55>

f010113b <.L33>:
f010113b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010113e:	85 c0                	test   %eax,%eax
f0101140:	ba 00 00 00 00       	mov    $0x0,%edx
f0101145:	0f 49 d0             	cmovns %eax,%edx
f0101148:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010114b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f010114e:	e9 5f ff ff ff       	jmp    f01010b2 <vprintfmt+0x55>

f0101153 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f0101153:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f0101156:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f010115d:	e9 50 ff ff ff       	jmp    f01010b2 <vprintfmt+0x55>
f0101162:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101165:	89 75 08             	mov    %esi,0x8(%ebp)
f0101168:	eb b9                	jmp    f0101123 <.L34+0x14>

f010116a <.L27>:
			lflag++;
f010116a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010116e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0101171:	e9 3c ff ff ff       	jmp    f01010b2 <vprintfmt+0x55>

f0101176 <.L30>:
f0101176:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
f0101179:	8b 45 14             	mov    0x14(%ebp),%eax
f010117c:	8d 58 04             	lea    0x4(%eax),%ebx
f010117f:	83 ec 08             	sub    $0x8,%esp
f0101182:	57                   	push   %edi
f0101183:	ff 30                	push   (%eax)
f0101185:	ff d6                	call   *%esi
			break;
f0101187:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010118a:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f010118d:	e9 c6 02 00 00       	jmp    f0101458 <.L25+0x45>

f0101192 <.L28>:
f0101192:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
f0101195:	8b 45 14             	mov    0x14(%ebp),%eax
f0101198:	8d 58 04             	lea    0x4(%eax),%ebx
f010119b:	8b 00                	mov    (%eax),%eax
f010119d:	99                   	cltd   
f010119e:	31 d0                	xor    %edx,%eax
f01011a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01011a2:	83 f8 06             	cmp    $0x6,%eax
f01011a5:	7f 27                	jg     f01011ce <.L28+0x3c>
f01011a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01011aa:	8b 14 82             	mov    (%edx,%eax,4),%edx
f01011ad:	85 d2                	test   %edx,%edx
f01011af:	74 1d                	je     f01011ce <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
f01011b1:	52                   	push   %edx
f01011b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011b5:	8d 80 2f ff fe ff    	lea    -0x100d1(%eax),%eax
f01011bb:	50                   	push   %eax
f01011bc:	57                   	push   %edi
f01011bd:	56                   	push   %esi
f01011be:	e8 79 fe ff ff       	call   f010103c <printfmt>
f01011c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01011c6:	89 5d 14             	mov    %ebx,0x14(%ebp)
f01011c9:	e9 8a 02 00 00       	jmp    f0101458 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f01011ce:	50                   	push   %eax
f01011cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011d2:	8d 80 26 ff fe ff    	lea    -0x100da(%eax),%eax
f01011d8:	50                   	push   %eax
f01011d9:	57                   	push   %edi
f01011da:	56                   	push   %esi
f01011db:	e8 5c fe ff ff       	call   f010103c <printfmt>
f01011e0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01011e3:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01011e6:	e9 6d 02 00 00       	jmp    f0101458 <.L25+0x45>

f01011eb <.L24>:
f01011eb:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
f01011ee:	8b 45 14             	mov    0x14(%ebp),%eax
f01011f1:	83 c0 04             	add    $0x4,%eax
f01011f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01011f7:	8b 45 14             	mov    0x14(%ebp),%eax
f01011fa:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01011fc:	85 d2                	test   %edx,%edx
f01011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101201:	8d 80 1f ff fe ff    	lea    -0x100e1(%eax),%eax
f0101207:	0f 45 c2             	cmovne %edx,%eax
f010120a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f010120d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101211:	7e 06                	jle    f0101219 <.L24+0x2e>
f0101213:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0101217:	75 0d                	jne    f0101226 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f0101219:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010121c:	89 c3                	mov    %eax,%ebx
f010121e:	03 45 d4             	add    -0x2c(%ebp),%eax
f0101221:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101224:	eb 58                	jmp    f010127e <.L24+0x93>
f0101226:	83 ec 08             	sub    $0x8,%esp
f0101229:	ff 75 d8             	push   -0x28(%ebp)
f010122c:	ff 75 c8             	push   -0x38(%ebp)
f010122f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0101232:	e8 85 04 00 00       	call   f01016bc <strnlen>
f0101237:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010123a:	29 c2                	sub    %eax,%edx
f010123c:	89 55 bc             	mov    %edx,-0x44(%ebp)
f010123f:	83 c4 10             	add    $0x10,%esp
f0101242:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f0101244:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0101248:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010124b:	85 db                	test   %ebx,%ebx
f010124d:	7e 11                	jle    f0101260 <.L24+0x75>
					putch(padc, putdat);
f010124f:	83 ec 08             	sub    $0x8,%esp
f0101252:	57                   	push   %edi
f0101253:	ff 75 d4             	push   -0x2c(%ebp)
f0101256:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0101258:	83 eb 01             	sub    $0x1,%ebx
f010125b:	83 c4 10             	add    $0x10,%esp
f010125e:	eb eb                	jmp    f010124b <.L24+0x60>
f0101260:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0101263:	85 d2                	test   %edx,%edx
f0101265:	b8 00 00 00 00       	mov    $0x0,%eax
f010126a:	0f 49 c2             	cmovns %edx,%eax
f010126d:	29 c2                	sub    %eax,%edx
f010126f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0101272:	eb a5                	jmp    f0101219 <.L24+0x2e>
					putch(ch, putdat);
f0101274:	83 ec 08             	sub    $0x8,%esp
f0101277:	57                   	push   %edi
f0101278:	52                   	push   %edx
f0101279:	ff d6                	call   *%esi
f010127b:	83 c4 10             	add    $0x10,%esp
f010127e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101281:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101283:	83 c3 01             	add    $0x1,%ebx
f0101286:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f010128a:	0f be d0             	movsbl %al,%edx
f010128d:	85 d2                	test   %edx,%edx
f010128f:	74 4b                	je     f01012dc <.L24+0xf1>
f0101291:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101295:	78 06                	js     f010129d <.L24+0xb2>
f0101297:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f010129b:	78 1e                	js     f01012bb <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f010129d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01012a1:	74 d1                	je     f0101274 <.L24+0x89>
f01012a3:	0f be c0             	movsbl %al,%eax
f01012a6:	83 e8 20             	sub    $0x20,%eax
f01012a9:	83 f8 5e             	cmp    $0x5e,%eax
f01012ac:	76 c6                	jbe    f0101274 <.L24+0x89>
					putch('?', putdat);
f01012ae:	83 ec 08             	sub    $0x8,%esp
f01012b1:	57                   	push   %edi
f01012b2:	6a 3f                	push   $0x3f
f01012b4:	ff d6                	call   *%esi
f01012b6:	83 c4 10             	add    $0x10,%esp
f01012b9:	eb c3                	jmp    f010127e <.L24+0x93>
f01012bb:	89 cb                	mov    %ecx,%ebx
f01012bd:	eb 0e                	jmp    f01012cd <.L24+0xe2>
				putch(' ', putdat);
f01012bf:	83 ec 08             	sub    $0x8,%esp
f01012c2:	57                   	push   %edi
f01012c3:	6a 20                	push   $0x20
f01012c5:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01012c7:	83 eb 01             	sub    $0x1,%ebx
f01012ca:	83 c4 10             	add    $0x10,%esp
f01012cd:	85 db                	test   %ebx,%ebx
f01012cf:	7f ee                	jg     f01012bf <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f01012d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
f01012d4:	89 45 14             	mov    %eax,0x14(%ebp)
f01012d7:	e9 7c 01 00 00       	jmp    f0101458 <.L25+0x45>
f01012dc:	89 cb                	mov    %ecx,%ebx
f01012de:	eb ed                	jmp    f01012cd <.L24+0xe2>

f01012e0 <.L29>:
f01012e0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01012e3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f01012e6:	83 f9 01             	cmp    $0x1,%ecx
f01012e9:	7f 1b                	jg     f0101306 <.L29+0x26>
	else if (lflag)
f01012eb:	85 c9                	test   %ecx,%ecx
f01012ed:	74 63                	je     f0101352 <.L29+0x72>
		return va_arg(*ap, long);
f01012ef:	8b 45 14             	mov    0x14(%ebp),%eax
f01012f2:	8b 00                	mov    (%eax),%eax
f01012f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01012f7:	99                   	cltd   
f01012f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01012fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01012fe:	8d 40 04             	lea    0x4(%eax),%eax
f0101301:	89 45 14             	mov    %eax,0x14(%ebp)
f0101304:	eb 17                	jmp    f010131d <.L29+0x3d>
		return va_arg(*ap, long long);
f0101306:	8b 45 14             	mov    0x14(%ebp),%eax
f0101309:	8b 50 04             	mov    0x4(%eax),%edx
f010130c:	8b 00                	mov    (%eax),%eax
f010130e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101311:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101314:	8b 45 14             	mov    0x14(%ebp),%eax
f0101317:	8d 40 08             	lea    0x8(%eax),%eax
f010131a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f010131d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101320:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0101323:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0101328:	85 c9                	test   %ecx,%ecx
f010132a:	0f 89 0e 01 00 00    	jns    f010143e <.L25+0x2b>
				putch('-', putdat);
f0101330:	83 ec 08             	sub    $0x8,%esp
f0101333:	57                   	push   %edi
f0101334:	6a 2d                	push   $0x2d
f0101336:	ff d6                	call   *%esi
				num = -(long long) num;
f0101338:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010133b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010133e:	f7 da                	neg    %edx
f0101340:	83 d1 00             	adc    $0x0,%ecx
f0101343:	f7 d9                	neg    %ecx
f0101345:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0101348:	b8 0a 00 00 00       	mov    $0xa,%eax
f010134d:	e9 ec 00 00 00       	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, int);
f0101352:	8b 45 14             	mov    0x14(%ebp),%eax
f0101355:	8b 00                	mov    (%eax),%eax
f0101357:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010135a:	99                   	cltd   
f010135b:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010135e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101361:	8d 40 04             	lea    0x4(%eax),%eax
f0101364:	89 45 14             	mov    %eax,0x14(%ebp)
f0101367:	eb b4                	jmp    f010131d <.L29+0x3d>

f0101369 <.L23>:
f0101369:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010136c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f010136f:	83 f9 01             	cmp    $0x1,%ecx
f0101372:	7f 1e                	jg     f0101392 <.L23+0x29>
	else if (lflag)
f0101374:	85 c9                	test   %ecx,%ecx
f0101376:	74 32                	je     f01013aa <.L23+0x41>
		return va_arg(*ap, unsigned long);
f0101378:	8b 45 14             	mov    0x14(%ebp),%eax
f010137b:	8b 10                	mov    (%eax),%edx
f010137d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101382:	8d 40 04             	lea    0x4(%eax),%eax
f0101385:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101388:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f010138d:	e9 ac 00 00 00       	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0101392:	8b 45 14             	mov    0x14(%ebp),%eax
f0101395:	8b 10                	mov    (%eax),%edx
f0101397:	8b 48 04             	mov    0x4(%eax),%ecx
f010139a:	8d 40 08             	lea    0x8(%eax),%eax
f010139d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01013a0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f01013a5:	e9 94 00 00 00       	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f01013aa:	8b 45 14             	mov    0x14(%ebp),%eax
f01013ad:	8b 10                	mov    (%eax),%edx
f01013af:	b9 00 00 00 00       	mov    $0x0,%ecx
f01013b4:	8d 40 04             	lea    0x4(%eax),%eax
f01013b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01013ba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f01013bf:	eb 7d                	jmp    f010143e <.L25+0x2b>

f01013c1 <.L26>:
f01013c1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01013c4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f01013c7:	83 f9 01             	cmp    $0x1,%ecx
f01013ca:	7f 1b                	jg     f01013e7 <.L26+0x26>
	else if (lflag)
f01013cc:	85 c9                	test   %ecx,%ecx
f01013ce:	74 2c                	je     f01013fc <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f01013d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01013d3:	8b 10                	mov    (%eax),%edx
f01013d5:	b9 00 00 00 00       	mov    $0x0,%ecx
f01013da:	8d 40 04             	lea    0x4(%eax),%eax
f01013dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01013e0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f01013e5:	eb 57                	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f01013e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01013ea:	8b 10                	mov    (%eax),%edx
f01013ec:	8b 48 04             	mov    0x4(%eax),%ecx
f01013ef:	8d 40 08             	lea    0x8(%eax),%eax
f01013f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01013f5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f01013fa:	eb 42                	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f01013fc:	8b 45 14             	mov    0x14(%ebp),%eax
f01013ff:	8b 10                	mov    (%eax),%edx
f0101401:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101406:	8d 40 04             	lea    0x4(%eax),%eax
f0101409:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010140c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f0101411:	eb 2b                	jmp    f010143e <.L25+0x2b>

f0101413 <.L25>:
f0101413:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
f0101416:	83 ec 08             	sub    $0x8,%esp
f0101419:	57                   	push   %edi
f010141a:	6a 30                	push   $0x30
f010141c:	ff d6                	call   *%esi
			putch('x', putdat);
f010141e:	83 c4 08             	add    $0x8,%esp
f0101421:	57                   	push   %edi
f0101422:	6a 78                	push   $0x78
f0101424:	ff d6                	call   *%esi
			num = (unsigned long long)
f0101426:	8b 45 14             	mov    0x14(%ebp),%eax
f0101429:	8b 10                	mov    (%eax),%edx
f010142b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f0101430:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0101433:	8d 40 04             	lea    0x4(%eax),%eax
f0101436:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101439:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010143e:	83 ec 0c             	sub    $0xc,%esp
f0101441:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
f0101445:	53                   	push   %ebx
f0101446:	ff 75 d4             	push   -0x2c(%ebp)
f0101449:	50                   	push   %eax
f010144a:	51                   	push   %ecx
f010144b:	52                   	push   %edx
f010144c:	89 fa                	mov    %edi,%edx
f010144e:	89 f0                	mov    %esi,%eax
f0101450:	e8 08 fb ff ff       	call   f0100f5d <printnum>
			break;
f0101455:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0101458:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010145b:	83 c3 01             	add    $0x1,%ebx
f010145e:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0101462:	83 f8 25             	cmp    $0x25,%eax
f0101465:	0f 84 23 fc ff ff    	je     f010108e <vprintfmt+0x31>
			if (ch == '\0')
f010146b:	85 c0                	test   %eax,%eax
f010146d:	0f 84 97 00 00 00    	je     f010150a <.L20+0x23>
			putch(ch, putdat);
f0101473:	83 ec 08             	sub    $0x8,%esp
f0101476:	57                   	push   %edi
f0101477:	50                   	push   %eax
f0101478:	ff d6                	call   *%esi
f010147a:	83 c4 10             	add    $0x10,%esp
f010147d:	eb dc                	jmp    f010145b <.L25+0x48>

f010147f <.L21>:
f010147f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0101482:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0101485:	83 f9 01             	cmp    $0x1,%ecx
f0101488:	7f 1b                	jg     f01014a5 <.L21+0x26>
	else if (lflag)
f010148a:	85 c9                	test   %ecx,%ecx
f010148c:	74 2c                	je     f01014ba <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f010148e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101491:	8b 10                	mov    (%eax),%edx
f0101493:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101498:	8d 40 04             	lea    0x4(%eax),%eax
f010149b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010149e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f01014a3:	eb 99                	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f01014a5:	8b 45 14             	mov    0x14(%ebp),%eax
f01014a8:	8b 10                	mov    (%eax),%edx
f01014aa:	8b 48 04             	mov    0x4(%eax),%ecx
f01014ad:	8d 40 08             	lea    0x8(%eax),%eax
f01014b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01014b3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f01014b8:	eb 84                	jmp    f010143e <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f01014ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01014bd:	8b 10                	mov    (%eax),%edx
f01014bf:	b9 00 00 00 00       	mov    $0x0,%ecx
f01014c4:	8d 40 04             	lea    0x4(%eax),%eax
f01014c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01014ca:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f01014cf:	e9 6a ff ff ff       	jmp    f010143e <.L25+0x2b>

f01014d4 <.L35>:
f01014d4:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
f01014d7:	83 ec 08             	sub    $0x8,%esp
f01014da:	57                   	push   %edi
f01014db:	6a 25                	push   $0x25
f01014dd:	ff d6                	call   *%esi
			break;
f01014df:	83 c4 10             	add    $0x10,%esp
f01014e2:	e9 71 ff ff ff       	jmp    f0101458 <.L25+0x45>

f01014e7 <.L20>:
f01014e7:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
f01014ea:	83 ec 08             	sub    $0x8,%esp
f01014ed:	57                   	push   %edi
f01014ee:	6a 25                	push   $0x25
f01014f0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01014f2:	83 c4 10             	add    $0x10,%esp
f01014f5:	89 d8                	mov    %ebx,%eax
f01014f7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01014fb:	74 05                	je     f0101502 <.L20+0x1b>
f01014fd:	83 e8 01             	sub    $0x1,%eax
f0101500:	eb f5                	jmp    f01014f7 <.L20+0x10>
f0101502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101505:	e9 4e ff ff ff       	jmp    f0101458 <.L25+0x45>
}
f010150a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010150d:	5b                   	pop    %ebx
f010150e:	5e                   	pop    %esi
f010150f:	5f                   	pop    %edi
f0101510:	5d                   	pop    %ebp
f0101511:	c3                   	ret    

f0101512 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0101512:	f3 0f 1e fb          	endbr32 
f0101516:	55                   	push   %ebp
f0101517:	89 e5                	mov    %esp,%ebp
f0101519:	53                   	push   %ebx
f010151a:	83 ec 14             	sub    $0x14,%esp
f010151d:	e8 2d ec ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0101522:	81 c3 e6 0d 01 00    	add    $0x10de6,%ebx
f0101528:	8b 45 08             	mov    0x8(%ebp),%eax
f010152b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010152e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101531:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0101535:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010153f:	85 c0                	test   %eax,%eax
f0101541:	74 2b                	je     f010156e <vsnprintf+0x5c>
f0101543:	85 d2                	test   %edx,%edx
f0101545:	7e 27                	jle    f010156e <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101547:	ff 75 14             	push   0x14(%ebp)
f010154a:	ff 75 10             	push   0x10(%ebp)
f010154d:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0101550:	50                   	push   %eax
f0101551:	8d 83 13 ed fe ff    	lea    -0x112ed(%ebx),%eax
f0101557:	50                   	push   %eax
f0101558:	e8 00 fb ff ff       	call   f010105d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010155d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101560:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0101563:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101566:	83 c4 10             	add    $0x10,%esp
}
f0101569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010156c:	c9                   	leave  
f010156d:	c3                   	ret    
		return -E_INVAL;
f010156e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101573:	eb f4                	jmp    f0101569 <vsnprintf+0x57>

f0101575 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0101575:	f3 0f 1e fb          	endbr32 
f0101579:	55                   	push   %ebp
f010157a:	89 e5                	mov    %esp,%ebp
f010157c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010157f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0101582:	50                   	push   %eax
f0101583:	ff 75 10             	push   0x10(%ebp)
f0101586:	ff 75 0c             	push   0xc(%ebp)
f0101589:	ff 75 08             	push   0x8(%ebp)
f010158c:	e8 81 ff ff ff       	call   f0101512 <vsnprintf>
	va_end(ap);

	return rc;
}
f0101591:	c9                   	leave  
f0101592:	c3                   	ret    

f0101593 <__x86.get_pc_thunk.cx>:
f0101593:	8b 0c 24             	mov    (%esp),%ecx
f0101596:	c3                   	ret    

f0101597 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101597:	f3 0f 1e fb          	endbr32 
f010159b:	55                   	push   %ebp
f010159c:	89 e5                	mov    %esp,%ebp
f010159e:	57                   	push   %edi
f010159f:	56                   	push   %esi
f01015a0:	53                   	push   %ebx
f01015a1:	83 ec 1c             	sub    $0x1c,%esp
f01015a4:	e8 a6 eb ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01015a9:	81 c3 5f 0d 01 00    	add    $0x10d5f,%ebx
f01015af:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01015b2:	85 c0                	test   %eax,%eax
f01015b4:	74 13                	je     f01015c9 <readline+0x32>
		cprintf("%s", prompt);
f01015b6:	83 ec 08             	sub    $0x8,%esp
f01015b9:	50                   	push   %eax
f01015ba:	8d 83 2f ff fe ff    	lea    -0x100d1(%ebx),%eax
f01015c0:	50                   	push   %eax
f01015c1:	e8 37 f6 ff ff       	call   f0100bfd <cprintf>
f01015c6:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f01015c9:	83 ec 0c             	sub    $0xc,%esp
f01015cc:	6a 00                	push   $0x0
f01015ce:	e8 08 f1 ff ff       	call   f01006db <iscons>
f01015d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01015d6:	83 c4 10             	add    $0x10,%esp
	i = 0;
f01015d9:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f01015de:	8d 83 d8 1f 00 00    	lea    0x1fd8(%ebx),%eax
f01015e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01015e7:	eb 51                	jmp    f010163a <readline+0xa3>
			cprintf("read error: %e\n", c);
f01015e9:	83 ec 08             	sub    $0x8,%esp
f01015ec:	50                   	push   %eax
f01015ed:	8d 83 f4 00 ff ff    	lea    -0xff0c(%ebx),%eax
f01015f3:	50                   	push   %eax
f01015f4:	e8 04 f6 ff ff       	call   f0100bfd <cprintf>
			return NULL;
f01015f9:	83 c4 10             	add    $0x10,%esp
f01015fc:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0101601:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101604:	5b                   	pop    %ebx
f0101605:	5e                   	pop    %esi
f0101606:	5f                   	pop    %edi
f0101607:	5d                   	pop    %ebp
f0101608:	c3                   	ret    
			if (echoing)
f0101609:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010160d:	75 05                	jne    f0101614 <readline+0x7d>
			i--;
f010160f:	83 ef 01             	sub    $0x1,%edi
f0101612:	eb 26                	jmp    f010163a <readline+0xa3>
				cputchar('\b');
f0101614:	83 ec 0c             	sub    $0xc,%esp
f0101617:	6a 08                	push   $0x8
f0101619:	e8 9c f0 ff ff       	call   f01006ba <cputchar>
f010161e:	83 c4 10             	add    $0x10,%esp
f0101621:	eb ec                	jmp    f010160f <readline+0x78>
				cputchar(c);
f0101623:	83 ec 0c             	sub    $0xc,%esp
f0101626:	56                   	push   %esi
f0101627:	e8 8e f0 ff ff       	call   f01006ba <cputchar>
f010162c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010162f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101632:	89 f0                	mov    %esi,%eax
f0101634:	88 04 39             	mov    %al,(%ecx,%edi,1)
f0101637:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f010163a:	e8 8b f0 ff ff       	call   f01006ca <getchar>
f010163f:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0101641:	85 c0                	test   %eax,%eax
f0101643:	78 a4                	js     f01015e9 <readline+0x52>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101645:	83 f8 08             	cmp    $0x8,%eax
f0101648:	0f 94 c2             	sete   %dl
f010164b:	83 f8 7f             	cmp    $0x7f,%eax
f010164e:	0f 94 c0             	sete   %al
f0101651:	08 c2                	or     %al,%dl
f0101653:	74 04                	je     f0101659 <readline+0xc2>
f0101655:	85 ff                	test   %edi,%edi
f0101657:	7f b0                	jg     f0101609 <readline+0x72>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0101659:	83 fe 1f             	cmp    $0x1f,%esi
f010165c:	7e 10                	jle    f010166e <readline+0xd7>
f010165e:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0101664:	7f 08                	jg     f010166e <readline+0xd7>
			if (echoing)
f0101666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010166a:	74 c3                	je     f010162f <readline+0x98>
f010166c:	eb b5                	jmp    f0101623 <readline+0x8c>
		} else if (c == '\n' || c == '\r') {
f010166e:	83 fe 0a             	cmp    $0xa,%esi
f0101671:	74 05                	je     f0101678 <readline+0xe1>
f0101673:	83 fe 0d             	cmp    $0xd,%esi
f0101676:	75 c2                	jne    f010163a <readline+0xa3>
			if (echoing)
f0101678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010167c:	75 13                	jne    f0101691 <readline+0xfa>
			buf[i] = 0;
f010167e:	c6 84 3b d8 1f 00 00 	movb   $0x0,0x1fd8(%ebx,%edi,1)
f0101685:	00 
			return buf;
f0101686:	8d 83 d8 1f 00 00    	lea    0x1fd8(%ebx),%eax
f010168c:	e9 70 ff ff ff       	jmp    f0101601 <readline+0x6a>
				cputchar('\n');
f0101691:	83 ec 0c             	sub    $0xc,%esp
f0101694:	6a 0a                	push   $0xa
f0101696:	e8 1f f0 ff ff       	call   f01006ba <cputchar>
f010169b:	83 c4 10             	add    $0x10,%esp
f010169e:	eb de                	jmp    f010167e <readline+0xe7>

f01016a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01016a0:	f3 0f 1e fb          	endbr32 
f01016a4:	55                   	push   %ebp
f01016a5:	89 e5                	mov    %esp,%ebp
f01016a7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01016aa:	b8 00 00 00 00       	mov    $0x0,%eax
f01016af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01016b3:	74 05                	je     f01016ba <strlen+0x1a>
		n++;
f01016b5:	83 c0 01             	add    $0x1,%eax
f01016b8:	eb f5                	jmp    f01016af <strlen+0xf>
	return n;
}
f01016ba:	5d                   	pop    %ebp
f01016bb:	c3                   	ret    

f01016bc <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01016bc:	f3 0f 1e fb          	endbr32 
f01016c0:	55                   	push   %ebp
f01016c1:	89 e5                	mov    %esp,%ebp
f01016c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01016c9:	b8 00 00 00 00       	mov    $0x0,%eax
f01016ce:	39 d0                	cmp    %edx,%eax
f01016d0:	74 0d                	je     f01016df <strnlen+0x23>
f01016d2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01016d6:	74 05                	je     f01016dd <strnlen+0x21>
		n++;
f01016d8:	83 c0 01             	add    $0x1,%eax
f01016db:	eb f1                	jmp    f01016ce <strnlen+0x12>
f01016dd:	89 c2                	mov    %eax,%edx
	return n;
}
f01016df:	89 d0                	mov    %edx,%eax
f01016e1:	5d                   	pop    %ebp
f01016e2:	c3                   	ret    

f01016e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01016e3:	f3 0f 1e fb          	endbr32 
f01016e7:	55                   	push   %ebp
f01016e8:	89 e5                	mov    %esp,%ebp
f01016ea:	53                   	push   %ebx
f01016eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01016ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01016f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01016f6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f01016fa:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f01016fd:	83 c0 01             	add    $0x1,%eax
f0101700:	84 d2                	test   %dl,%dl
f0101702:	75 f2                	jne    f01016f6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0101704:	89 c8                	mov    %ecx,%eax
f0101706:	5b                   	pop    %ebx
f0101707:	5d                   	pop    %ebp
f0101708:	c3                   	ret    

f0101709 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0101709:	f3 0f 1e fb          	endbr32 
f010170d:	55                   	push   %ebp
f010170e:	89 e5                	mov    %esp,%ebp
f0101710:	53                   	push   %ebx
f0101711:	83 ec 10             	sub    $0x10,%esp
f0101714:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0101717:	53                   	push   %ebx
f0101718:	e8 83 ff ff ff       	call   f01016a0 <strlen>
f010171d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0101720:	ff 75 0c             	push   0xc(%ebp)
f0101723:	01 d8                	add    %ebx,%eax
f0101725:	50                   	push   %eax
f0101726:	e8 b8 ff ff ff       	call   f01016e3 <strcpy>
	return dst;
}
f010172b:	89 d8                	mov    %ebx,%eax
f010172d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101730:	c9                   	leave  
f0101731:	c3                   	ret    

f0101732 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0101732:	f3 0f 1e fb          	endbr32 
f0101736:	55                   	push   %ebp
f0101737:	89 e5                	mov    %esp,%ebp
f0101739:	56                   	push   %esi
f010173a:	53                   	push   %ebx
f010173b:	8b 75 08             	mov    0x8(%ebp),%esi
f010173e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101741:	89 f3                	mov    %esi,%ebx
f0101743:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101746:	89 f0                	mov    %esi,%eax
f0101748:	39 d8                	cmp    %ebx,%eax
f010174a:	74 11                	je     f010175d <strncpy+0x2b>
		*dst++ = *src;
f010174c:	83 c0 01             	add    $0x1,%eax
f010174f:	0f b6 0a             	movzbl (%edx),%ecx
f0101752:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101755:	80 f9 01             	cmp    $0x1,%cl
f0101758:	83 da ff             	sbb    $0xffffffff,%edx
f010175b:	eb eb                	jmp    f0101748 <strncpy+0x16>
	}
	return ret;
}
f010175d:	89 f0                	mov    %esi,%eax
f010175f:	5b                   	pop    %ebx
f0101760:	5e                   	pop    %esi
f0101761:	5d                   	pop    %ebp
f0101762:	c3                   	ret    

f0101763 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101763:	f3 0f 1e fb          	endbr32 
f0101767:	55                   	push   %ebp
f0101768:	89 e5                	mov    %esp,%ebp
f010176a:	56                   	push   %esi
f010176b:	53                   	push   %ebx
f010176c:	8b 75 08             	mov    0x8(%ebp),%esi
f010176f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101772:	8b 55 10             	mov    0x10(%ebp),%edx
f0101775:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101777:	85 d2                	test   %edx,%edx
f0101779:	74 21                	je     f010179c <strlcpy+0x39>
f010177b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010177f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0101781:	39 c2                	cmp    %eax,%edx
f0101783:	74 14                	je     f0101799 <strlcpy+0x36>
f0101785:	0f b6 19             	movzbl (%ecx),%ebx
f0101788:	84 db                	test   %bl,%bl
f010178a:	74 0b                	je     f0101797 <strlcpy+0x34>
			*dst++ = *src++;
f010178c:	83 c1 01             	add    $0x1,%ecx
f010178f:	83 c2 01             	add    $0x1,%edx
f0101792:	88 5a ff             	mov    %bl,-0x1(%edx)
f0101795:	eb ea                	jmp    f0101781 <strlcpy+0x1e>
f0101797:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0101799:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010179c:	29 f0                	sub    %esi,%eax
}
f010179e:	5b                   	pop    %ebx
f010179f:	5e                   	pop    %esi
f01017a0:	5d                   	pop    %ebp
f01017a1:	c3                   	ret    

f01017a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01017a2:	f3 0f 1e fb          	endbr32 
f01017a6:	55                   	push   %ebp
f01017a7:	89 e5                	mov    %esp,%ebp
f01017a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01017ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01017af:	0f b6 01             	movzbl (%ecx),%eax
f01017b2:	84 c0                	test   %al,%al
f01017b4:	74 0c                	je     f01017c2 <strcmp+0x20>
f01017b6:	3a 02                	cmp    (%edx),%al
f01017b8:	75 08                	jne    f01017c2 <strcmp+0x20>
		p++, q++;
f01017ba:	83 c1 01             	add    $0x1,%ecx
f01017bd:	83 c2 01             	add    $0x1,%edx
f01017c0:	eb ed                	jmp    f01017af <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01017c2:	0f b6 c0             	movzbl %al,%eax
f01017c5:	0f b6 12             	movzbl (%edx),%edx
f01017c8:	29 d0                	sub    %edx,%eax
}
f01017ca:	5d                   	pop    %ebp
f01017cb:	c3                   	ret    

f01017cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01017cc:	f3 0f 1e fb          	endbr32 
f01017d0:	55                   	push   %ebp
f01017d1:	89 e5                	mov    %esp,%ebp
f01017d3:	53                   	push   %ebx
f01017d4:	8b 45 08             	mov    0x8(%ebp),%eax
f01017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
f01017da:	89 c3                	mov    %eax,%ebx
f01017dc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01017df:	eb 06                	jmp    f01017e7 <strncmp+0x1b>
		n--, p++, q++;
f01017e1:	83 c0 01             	add    $0x1,%eax
f01017e4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f01017e7:	39 d8                	cmp    %ebx,%eax
f01017e9:	74 16                	je     f0101801 <strncmp+0x35>
f01017eb:	0f b6 08             	movzbl (%eax),%ecx
f01017ee:	84 c9                	test   %cl,%cl
f01017f0:	74 04                	je     f01017f6 <strncmp+0x2a>
f01017f2:	3a 0a                	cmp    (%edx),%cl
f01017f4:	74 eb                	je     f01017e1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01017f6:	0f b6 00             	movzbl (%eax),%eax
f01017f9:	0f b6 12             	movzbl (%edx),%edx
f01017fc:	29 d0                	sub    %edx,%eax
}
f01017fe:	5b                   	pop    %ebx
f01017ff:	5d                   	pop    %ebp
f0101800:	c3                   	ret    
		return 0;
f0101801:	b8 00 00 00 00       	mov    $0x0,%eax
f0101806:	eb f6                	jmp    f01017fe <strncmp+0x32>

f0101808 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0101808:	f3 0f 1e fb          	endbr32 
f010180c:	55                   	push   %ebp
f010180d:	89 e5                	mov    %esp,%ebp
f010180f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101812:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101816:	0f b6 10             	movzbl (%eax),%edx
f0101819:	84 d2                	test   %dl,%dl
f010181b:	74 09                	je     f0101826 <strchr+0x1e>
		if (*s == c)
f010181d:	38 ca                	cmp    %cl,%dl
f010181f:	74 0a                	je     f010182b <strchr+0x23>
	for (; *s; s++)
f0101821:	83 c0 01             	add    $0x1,%eax
f0101824:	eb f0                	jmp    f0101816 <strchr+0xe>
			return (char *) s;
	return 0;
f0101826:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010182b:	5d                   	pop    %ebp
f010182c:	c3                   	ret    

f010182d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010182d:	f3 0f 1e fb          	endbr32 
f0101831:	55                   	push   %ebp
f0101832:	89 e5                	mov    %esp,%ebp
f0101834:	8b 45 08             	mov    0x8(%ebp),%eax
f0101837:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010183b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010183e:	38 ca                	cmp    %cl,%dl
f0101840:	74 09                	je     f010184b <strfind+0x1e>
f0101842:	84 d2                	test   %dl,%dl
f0101844:	74 05                	je     f010184b <strfind+0x1e>
	for (; *s; s++)
f0101846:	83 c0 01             	add    $0x1,%eax
f0101849:	eb f0                	jmp    f010183b <strfind+0xe>
			break;
	return (char *) s;
}
f010184b:	5d                   	pop    %ebp
f010184c:	c3                   	ret    

f010184d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f010184d:	f3 0f 1e fb          	endbr32 
f0101851:	55                   	push   %ebp
f0101852:	89 e5                	mov    %esp,%ebp
f0101854:	57                   	push   %edi
f0101855:	56                   	push   %esi
f0101856:	53                   	push   %ebx
f0101857:	8b 7d 08             	mov    0x8(%ebp),%edi
f010185a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f010185d:	85 c9                	test   %ecx,%ecx
f010185f:	74 31                	je     f0101892 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101861:	89 f8                	mov    %edi,%eax
f0101863:	09 c8                	or     %ecx,%eax
f0101865:	a8 03                	test   $0x3,%al
f0101867:	75 23                	jne    f010188c <memset+0x3f>
		c &= 0xFF;
f0101869:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f010186d:	89 d3                	mov    %edx,%ebx
f010186f:	c1 e3 08             	shl    $0x8,%ebx
f0101872:	89 d0                	mov    %edx,%eax
f0101874:	c1 e0 18             	shl    $0x18,%eax
f0101877:	89 d6                	mov    %edx,%esi
f0101879:	c1 e6 10             	shl    $0x10,%esi
f010187c:	09 f0                	or     %esi,%eax
f010187e:	09 c2                	or     %eax,%edx
f0101880:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0101882:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0101885:	89 d0                	mov    %edx,%eax
f0101887:	fc                   	cld    
f0101888:	f3 ab                	rep stos %eax,%es:(%edi)
f010188a:	eb 06                	jmp    f0101892 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010188c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010188f:	fc                   	cld    
f0101890:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0101892:	89 f8                	mov    %edi,%eax
f0101894:	5b                   	pop    %ebx
f0101895:	5e                   	pop    %esi
f0101896:	5f                   	pop    %edi
f0101897:	5d                   	pop    %ebp
f0101898:	c3                   	ret    

f0101899 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101899:	f3 0f 1e fb          	endbr32 
f010189d:	55                   	push   %ebp
f010189e:	89 e5                	mov    %esp,%ebp
f01018a0:	57                   	push   %edi
f01018a1:	56                   	push   %esi
f01018a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01018a5:	8b 75 0c             	mov    0xc(%ebp),%esi
f01018a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01018ab:	39 c6                	cmp    %eax,%esi
f01018ad:	73 32                	jae    f01018e1 <memmove+0x48>
f01018af:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01018b2:	39 c2                	cmp    %eax,%edx
f01018b4:	76 2b                	jbe    f01018e1 <memmove+0x48>
		s += n;
		d += n;
f01018b6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01018b9:	89 fe                	mov    %edi,%esi
f01018bb:	09 ce                	or     %ecx,%esi
f01018bd:	09 d6                	or     %edx,%esi
f01018bf:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01018c5:	75 0e                	jne    f01018d5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01018c7:	83 ef 04             	sub    $0x4,%edi
f01018ca:	8d 72 fc             	lea    -0x4(%edx),%esi
f01018cd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f01018d0:	fd                   	std    
f01018d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01018d3:	eb 09                	jmp    f01018de <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01018d5:	83 ef 01             	sub    $0x1,%edi
f01018d8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f01018db:	fd                   	std    
f01018dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01018de:	fc                   	cld    
f01018df:	eb 1a                	jmp    f01018fb <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01018e1:	89 c2                	mov    %eax,%edx
f01018e3:	09 ca                	or     %ecx,%edx
f01018e5:	09 f2                	or     %esi,%edx
f01018e7:	f6 c2 03             	test   $0x3,%dl
f01018ea:	75 0a                	jne    f01018f6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01018ec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f01018ef:	89 c7                	mov    %eax,%edi
f01018f1:	fc                   	cld    
f01018f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01018f4:	eb 05                	jmp    f01018fb <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f01018f6:	89 c7                	mov    %eax,%edi
f01018f8:	fc                   	cld    
f01018f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01018fb:	5e                   	pop    %esi
f01018fc:	5f                   	pop    %edi
f01018fd:	5d                   	pop    %ebp
f01018fe:	c3                   	ret    

f01018ff <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01018ff:	f3 0f 1e fb          	endbr32 
f0101903:	55                   	push   %ebp
f0101904:	89 e5                	mov    %esp,%ebp
f0101906:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101909:	ff 75 10             	push   0x10(%ebp)
f010190c:	ff 75 0c             	push   0xc(%ebp)
f010190f:	ff 75 08             	push   0x8(%ebp)
f0101912:	e8 82 ff ff ff       	call   f0101899 <memmove>
}
f0101917:	c9                   	leave  
f0101918:	c3                   	ret    

f0101919 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101919:	f3 0f 1e fb          	endbr32 
f010191d:	55                   	push   %ebp
f010191e:	89 e5                	mov    %esp,%ebp
f0101920:	56                   	push   %esi
f0101921:	53                   	push   %ebx
f0101922:	8b 45 08             	mov    0x8(%ebp),%eax
f0101925:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101928:	89 c6                	mov    %eax,%esi
f010192a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010192d:	39 f0                	cmp    %esi,%eax
f010192f:	74 1c                	je     f010194d <memcmp+0x34>
		if (*s1 != *s2)
f0101931:	0f b6 08             	movzbl (%eax),%ecx
f0101934:	0f b6 1a             	movzbl (%edx),%ebx
f0101937:	38 d9                	cmp    %bl,%cl
f0101939:	75 08                	jne    f0101943 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f010193b:	83 c0 01             	add    $0x1,%eax
f010193e:	83 c2 01             	add    $0x1,%edx
f0101941:	eb ea                	jmp    f010192d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0101943:	0f b6 c1             	movzbl %cl,%eax
f0101946:	0f b6 db             	movzbl %bl,%ebx
f0101949:	29 d8                	sub    %ebx,%eax
f010194b:	eb 05                	jmp    f0101952 <memcmp+0x39>
	}

	return 0;
f010194d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101952:	5b                   	pop    %ebx
f0101953:	5e                   	pop    %esi
f0101954:	5d                   	pop    %ebp
f0101955:	c3                   	ret    

f0101956 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101956:	f3 0f 1e fb          	endbr32 
f010195a:	55                   	push   %ebp
f010195b:	89 e5                	mov    %esp,%ebp
f010195d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0101963:	89 c2                	mov    %eax,%edx
f0101965:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0101968:	39 d0                	cmp    %edx,%eax
f010196a:	73 09                	jae    f0101975 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f010196c:	38 08                	cmp    %cl,(%eax)
f010196e:	74 05                	je     f0101975 <memfind+0x1f>
	for (; s < ends; s++)
f0101970:	83 c0 01             	add    $0x1,%eax
f0101973:	eb f3                	jmp    f0101968 <memfind+0x12>
			break;
	return (void *) s;
}
f0101975:	5d                   	pop    %ebp
f0101976:	c3                   	ret    

f0101977 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101977:	f3 0f 1e fb          	endbr32 
f010197b:	55                   	push   %ebp
f010197c:	89 e5                	mov    %esp,%ebp
f010197e:	57                   	push   %edi
f010197f:	56                   	push   %esi
f0101980:	53                   	push   %ebx
f0101981:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101984:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101987:	eb 03                	jmp    f010198c <strtol+0x15>
		s++;
f0101989:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f010198c:	0f b6 01             	movzbl (%ecx),%eax
f010198f:	3c 20                	cmp    $0x20,%al
f0101991:	74 f6                	je     f0101989 <strtol+0x12>
f0101993:	3c 09                	cmp    $0x9,%al
f0101995:	74 f2                	je     f0101989 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0101997:	3c 2b                	cmp    $0x2b,%al
f0101999:	74 2a                	je     f01019c5 <strtol+0x4e>
	int neg = 0;
f010199b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01019a0:	3c 2d                	cmp    $0x2d,%al
f01019a2:	74 2b                	je     f01019cf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01019a4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01019aa:	75 0f                	jne    f01019bb <strtol+0x44>
f01019ac:	80 39 30             	cmpb   $0x30,(%ecx)
f01019af:	74 28                	je     f01019d9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01019b1:	85 db                	test   %ebx,%ebx
f01019b3:	b8 0a 00 00 00       	mov    $0xa,%eax
f01019b8:	0f 44 d8             	cmove  %eax,%ebx
f01019bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01019c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01019c3:	eb 46                	jmp    f0101a0b <strtol+0x94>
		s++;
f01019c5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01019c8:	bf 00 00 00 00       	mov    $0x0,%edi
f01019cd:	eb d5                	jmp    f01019a4 <strtol+0x2d>
		s++, neg = 1;
f01019cf:	83 c1 01             	add    $0x1,%ecx
f01019d2:	bf 01 00 00 00       	mov    $0x1,%edi
f01019d7:	eb cb                	jmp    f01019a4 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01019d9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01019dd:	74 0e                	je     f01019ed <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f01019df:	85 db                	test   %ebx,%ebx
f01019e1:	75 d8                	jne    f01019bb <strtol+0x44>
		s++, base = 8;
f01019e3:	83 c1 01             	add    $0x1,%ecx
f01019e6:	bb 08 00 00 00       	mov    $0x8,%ebx
f01019eb:	eb ce                	jmp    f01019bb <strtol+0x44>
		s += 2, base = 16;
f01019ed:	83 c1 02             	add    $0x2,%ecx
f01019f0:	bb 10 00 00 00       	mov    $0x10,%ebx
f01019f5:	eb c4                	jmp    f01019bb <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f01019f7:	0f be d2             	movsbl %dl,%edx
f01019fa:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f01019fd:	3b 55 10             	cmp    0x10(%ebp),%edx
f0101a00:	7d 3a                	jge    f0101a3c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0101a02:	83 c1 01             	add    $0x1,%ecx
f0101a05:	0f af 45 10          	imul   0x10(%ebp),%eax
f0101a09:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0101a0b:	0f b6 11             	movzbl (%ecx),%edx
f0101a0e:	8d 72 d0             	lea    -0x30(%edx),%esi
f0101a11:	89 f3                	mov    %esi,%ebx
f0101a13:	80 fb 09             	cmp    $0x9,%bl
f0101a16:	76 df                	jbe    f01019f7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0101a18:	8d 72 9f             	lea    -0x61(%edx),%esi
f0101a1b:	89 f3                	mov    %esi,%ebx
f0101a1d:	80 fb 19             	cmp    $0x19,%bl
f0101a20:	77 08                	ja     f0101a2a <strtol+0xb3>
			dig = *s - 'a' + 10;
f0101a22:	0f be d2             	movsbl %dl,%edx
f0101a25:	83 ea 57             	sub    $0x57,%edx
f0101a28:	eb d3                	jmp    f01019fd <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0101a2a:	8d 72 bf             	lea    -0x41(%edx),%esi
f0101a2d:	89 f3                	mov    %esi,%ebx
f0101a2f:	80 fb 19             	cmp    $0x19,%bl
f0101a32:	77 08                	ja     f0101a3c <strtol+0xc5>
			dig = *s - 'A' + 10;
f0101a34:	0f be d2             	movsbl %dl,%edx
f0101a37:	83 ea 37             	sub    $0x37,%edx
f0101a3a:	eb c1                	jmp    f01019fd <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0101a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101a40:	74 05                	je     f0101a47 <strtol+0xd0>
		*endptr = (char *) s;
f0101a42:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101a45:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0101a47:	89 c2                	mov    %eax,%edx
f0101a49:	f7 da                	neg    %edx
f0101a4b:	85 ff                	test   %edi,%edi
f0101a4d:	0f 45 c2             	cmovne %edx,%eax
}
f0101a50:	5b                   	pop    %ebx
f0101a51:	5e                   	pop    %esi
f0101a52:	5f                   	pop    %edi
f0101a53:	5d                   	pop    %ebp
f0101a54:	c3                   	ret    
f0101a55:	66 90                	xchg   %ax,%ax
f0101a57:	66 90                	xchg   %ax,%ax
f0101a59:	66 90                	xchg   %ax,%ax
f0101a5b:	66 90                	xchg   %ax,%ax
f0101a5d:	66 90                	xchg   %ax,%ax
f0101a5f:	90                   	nop

f0101a60 <__udivdi3>:
f0101a60:	f3 0f 1e fb          	endbr32 
f0101a64:	55                   	push   %ebp
f0101a65:	57                   	push   %edi
f0101a66:	56                   	push   %esi
f0101a67:	53                   	push   %ebx
f0101a68:	83 ec 1c             	sub    $0x1c,%esp
f0101a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0101a6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0101a73:	8b 74 24 34          	mov    0x34(%esp),%esi
f0101a77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0101a7b:	85 c0                	test   %eax,%eax
f0101a7d:	75 19                	jne    f0101a98 <__udivdi3+0x38>
f0101a7f:	39 f3                	cmp    %esi,%ebx
f0101a81:	76 4d                	jbe    f0101ad0 <__udivdi3+0x70>
f0101a83:	31 ff                	xor    %edi,%edi
f0101a85:	89 e8                	mov    %ebp,%eax
f0101a87:	89 f2                	mov    %esi,%edx
f0101a89:	f7 f3                	div    %ebx
f0101a8b:	89 fa                	mov    %edi,%edx
f0101a8d:	83 c4 1c             	add    $0x1c,%esp
f0101a90:	5b                   	pop    %ebx
f0101a91:	5e                   	pop    %esi
f0101a92:	5f                   	pop    %edi
f0101a93:	5d                   	pop    %ebp
f0101a94:	c3                   	ret    
f0101a95:	8d 76 00             	lea    0x0(%esi),%esi
f0101a98:	39 f0                	cmp    %esi,%eax
f0101a9a:	76 14                	jbe    f0101ab0 <__udivdi3+0x50>
f0101a9c:	31 ff                	xor    %edi,%edi
f0101a9e:	31 c0                	xor    %eax,%eax
f0101aa0:	89 fa                	mov    %edi,%edx
f0101aa2:	83 c4 1c             	add    $0x1c,%esp
f0101aa5:	5b                   	pop    %ebx
f0101aa6:	5e                   	pop    %esi
f0101aa7:	5f                   	pop    %edi
f0101aa8:	5d                   	pop    %ebp
f0101aa9:	c3                   	ret    
f0101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101ab0:	0f bd f8             	bsr    %eax,%edi
f0101ab3:	83 f7 1f             	xor    $0x1f,%edi
f0101ab6:	75 48                	jne    f0101b00 <__udivdi3+0xa0>
f0101ab8:	39 f0                	cmp    %esi,%eax
f0101aba:	72 06                	jb     f0101ac2 <__udivdi3+0x62>
f0101abc:	31 c0                	xor    %eax,%eax
f0101abe:	39 eb                	cmp    %ebp,%ebx
f0101ac0:	77 de                	ja     f0101aa0 <__udivdi3+0x40>
f0101ac2:	b8 01 00 00 00       	mov    $0x1,%eax
f0101ac7:	eb d7                	jmp    f0101aa0 <__udivdi3+0x40>
f0101ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101ad0:	89 d9                	mov    %ebx,%ecx
f0101ad2:	85 db                	test   %ebx,%ebx
f0101ad4:	75 0b                	jne    f0101ae1 <__udivdi3+0x81>
f0101ad6:	b8 01 00 00 00       	mov    $0x1,%eax
f0101adb:	31 d2                	xor    %edx,%edx
f0101add:	f7 f3                	div    %ebx
f0101adf:	89 c1                	mov    %eax,%ecx
f0101ae1:	31 d2                	xor    %edx,%edx
f0101ae3:	89 f0                	mov    %esi,%eax
f0101ae5:	f7 f1                	div    %ecx
f0101ae7:	89 c6                	mov    %eax,%esi
f0101ae9:	89 e8                	mov    %ebp,%eax
f0101aeb:	89 f7                	mov    %esi,%edi
f0101aed:	f7 f1                	div    %ecx
f0101aef:	89 fa                	mov    %edi,%edx
f0101af1:	83 c4 1c             	add    $0x1c,%esp
f0101af4:	5b                   	pop    %ebx
f0101af5:	5e                   	pop    %esi
f0101af6:	5f                   	pop    %edi
f0101af7:	5d                   	pop    %ebp
f0101af8:	c3                   	ret    
f0101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101b00:	89 f9                	mov    %edi,%ecx
f0101b02:	ba 20 00 00 00       	mov    $0x20,%edx
f0101b07:	29 fa                	sub    %edi,%edx
f0101b09:	d3 e0                	shl    %cl,%eax
f0101b0b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101b0f:	89 d1                	mov    %edx,%ecx
f0101b11:	89 d8                	mov    %ebx,%eax
f0101b13:	d3 e8                	shr    %cl,%eax
f0101b15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0101b19:	09 c1                	or     %eax,%ecx
f0101b1b:	89 f0                	mov    %esi,%eax
f0101b1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101b21:	89 f9                	mov    %edi,%ecx
f0101b23:	d3 e3                	shl    %cl,%ebx
f0101b25:	89 d1                	mov    %edx,%ecx
f0101b27:	d3 e8                	shr    %cl,%eax
f0101b29:	89 f9                	mov    %edi,%ecx
f0101b2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101b2f:	89 eb                	mov    %ebp,%ebx
f0101b31:	d3 e6                	shl    %cl,%esi
f0101b33:	89 d1                	mov    %edx,%ecx
f0101b35:	d3 eb                	shr    %cl,%ebx
f0101b37:	09 f3                	or     %esi,%ebx
f0101b39:	89 c6                	mov    %eax,%esi
f0101b3b:	89 f2                	mov    %esi,%edx
f0101b3d:	89 d8                	mov    %ebx,%eax
f0101b3f:	f7 74 24 08          	divl   0x8(%esp)
f0101b43:	89 d6                	mov    %edx,%esi
f0101b45:	89 c3                	mov    %eax,%ebx
f0101b47:	f7 64 24 0c          	mull   0xc(%esp)
f0101b4b:	39 d6                	cmp    %edx,%esi
f0101b4d:	72 19                	jb     f0101b68 <__udivdi3+0x108>
f0101b4f:	89 f9                	mov    %edi,%ecx
f0101b51:	d3 e5                	shl    %cl,%ebp
f0101b53:	39 c5                	cmp    %eax,%ebp
f0101b55:	73 04                	jae    f0101b5b <__udivdi3+0xfb>
f0101b57:	39 d6                	cmp    %edx,%esi
f0101b59:	74 0d                	je     f0101b68 <__udivdi3+0x108>
f0101b5b:	89 d8                	mov    %ebx,%eax
f0101b5d:	31 ff                	xor    %edi,%edi
f0101b5f:	e9 3c ff ff ff       	jmp    f0101aa0 <__udivdi3+0x40>
f0101b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101b68:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101b6b:	31 ff                	xor    %edi,%edi
f0101b6d:	e9 2e ff ff ff       	jmp    f0101aa0 <__udivdi3+0x40>
f0101b72:	66 90                	xchg   %ax,%ax
f0101b74:	66 90                	xchg   %ax,%ax
f0101b76:	66 90                	xchg   %ax,%ax
f0101b78:	66 90                	xchg   %ax,%ax
f0101b7a:	66 90                	xchg   %ax,%ax
f0101b7c:	66 90                	xchg   %ax,%ax
f0101b7e:	66 90                	xchg   %ax,%ax

f0101b80 <__umoddi3>:
f0101b80:	f3 0f 1e fb          	endbr32 
f0101b84:	55                   	push   %ebp
f0101b85:	57                   	push   %edi
f0101b86:	56                   	push   %esi
f0101b87:	53                   	push   %ebx
f0101b88:	83 ec 1c             	sub    $0x1c,%esp
f0101b8b:	8b 74 24 30          	mov    0x30(%esp),%esi
f0101b8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0101b93:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
f0101b97:	8b 6c 24 38          	mov    0x38(%esp),%ebp
f0101b9b:	89 f0                	mov    %esi,%eax
f0101b9d:	89 da                	mov    %ebx,%edx
f0101b9f:	85 ff                	test   %edi,%edi
f0101ba1:	75 15                	jne    f0101bb8 <__umoddi3+0x38>
f0101ba3:	39 dd                	cmp    %ebx,%ebp
f0101ba5:	76 39                	jbe    f0101be0 <__umoddi3+0x60>
f0101ba7:	f7 f5                	div    %ebp
f0101ba9:	89 d0                	mov    %edx,%eax
f0101bab:	31 d2                	xor    %edx,%edx
f0101bad:	83 c4 1c             	add    $0x1c,%esp
f0101bb0:	5b                   	pop    %ebx
f0101bb1:	5e                   	pop    %esi
f0101bb2:	5f                   	pop    %edi
f0101bb3:	5d                   	pop    %ebp
f0101bb4:	c3                   	ret    
f0101bb5:	8d 76 00             	lea    0x0(%esi),%esi
f0101bb8:	39 df                	cmp    %ebx,%edi
f0101bba:	77 f1                	ja     f0101bad <__umoddi3+0x2d>
f0101bbc:	0f bd cf             	bsr    %edi,%ecx
f0101bbf:	83 f1 1f             	xor    $0x1f,%ecx
f0101bc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101bc6:	75 40                	jne    f0101c08 <__umoddi3+0x88>
f0101bc8:	39 df                	cmp    %ebx,%edi
f0101bca:	72 04                	jb     f0101bd0 <__umoddi3+0x50>
f0101bcc:	39 f5                	cmp    %esi,%ebp
f0101bce:	77 dd                	ja     f0101bad <__umoddi3+0x2d>
f0101bd0:	89 da                	mov    %ebx,%edx
f0101bd2:	89 f0                	mov    %esi,%eax
f0101bd4:	29 e8                	sub    %ebp,%eax
f0101bd6:	19 fa                	sbb    %edi,%edx
f0101bd8:	eb d3                	jmp    f0101bad <__umoddi3+0x2d>
f0101bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101be0:	89 e9                	mov    %ebp,%ecx
f0101be2:	85 ed                	test   %ebp,%ebp
f0101be4:	75 0b                	jne    f0101bf1 <__umoddi3+0x71>
f0101be6:	b8 01 00 00 00       	mov    $0x1,%eax
f0101beb:	31 d2                	xor    %edx,%edx
f0101bed:	f7 f5                	div    %ebp
f0101bef:	89 c1                	mov    %eax,%ecx
f0101bf1:	89 d8                	mov    %ebx,%eax
f0101bf3:	31 d2                	xor    %edx,%edx
f0101bf5:	f7 f1                	div    %ecx
f0101bf7:	89 f0                	mov    %esi,%eax
f0101bf9:	f7 f1                	div    %ecx
f0101bfb:	89 d0                	mov    %edx,%eax
f0101bfd:	31 d2                	xor    %edx,%edx
f0101bff:	eb ac                	jmp    f0101bad <__umoddi3+0x2d>
f0101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101c08:	8b 44 24 04          	mov    0x4(%esp),%eax
f0101c0c:	ba 20 00 00 00       	mov    $0x20,%edx
f0101c11:	29 c2                	sub    %eax,%edx
f0101c13:	89 c1                	mov    %eax,%ecx
f0101c15:	89 e8                	mov    %ebp,%eax
f0101c17:	d3 e7                	shl    %cl,%edi
f0101c19:	89 d1                	mov    %edx,%ecx
f0101c1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101c1f:	d3 e8                	shr    %cl,%eax
f0101c21:	89 c1                	mov    %eax,%ecx
f0101c23:	8b 44 24 04          	mov    0x4(%esp),%eax
f0101c27:	09 f9                	or     %edi,%ecx
f0101c29:	89 df                	mov    %ebx,%edi
f0101c2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101c2f:	89 c1                	mov    %eax,%ecx
f0101c31:	d3 e5                	shl    %cl,%ebp
f0101c33:	89 d1                	mov    %edx,%ecx
f0101c35:	d3 ef                	shr    %cl,%edi
f0101c37:	89 c1                	mov    %eax,%ecx
f0101c39:	89 f0                	mov    %esi,%eax
f0101c3b:	d3 e3                	shl    %cl,%ebx
f0101c3d:	89 d1                	mov    %edx,%ecx
f0101c3f:	89 fa                	mov    %edi,%edx
f0101c41:	d3 e8                	shr    %cl,%eax
f0101c43:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0101c48:	09 d8                	or     %ebx,%eax
f0101c4a:	f7 74 24 08          	divl   0x8(%esp)
f0101c4e:	89 d3                	mov    %edx,%ebx
f0101c50:	d3 e6                	shl    %cl,%esi
f0101c52:	f7 e5                	mul    %ebp
f0101c54:	89 c7                	mov    %eax,%edi
f0101c56:	89 d1                	mov    %edx,%ecx
f0101c58:	39 d3                	cmp    %edx,%ebx
f0101c5a:	72 06                	jb     f0101c62 <__umoddi3+0xe2>
f0101c5c:	75 0e                	jne    f0101c6c <__umoddi3+0xec>
f0101c5e:	39 c6                	cmp    %eax,%esi
f0101c60:	73 0a                	jae    f0101c6c <__umoddi3+0xec>
f0101c62:	29 e8                	sub    %ebp,%eax
f0101c64:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0101c68:	89 d1                	mov    %edx,%ecx
f0101c6a:	89 c7                	mov    %eax,%edi
f0101c6c:	89 f5                	mov    %esi,%ebp
f0101c6e:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101c72:	29 fd                	sub    %edi,%ebp
f0101c74:	19 cb                	sbb    %ecx,%ebx
f0101c76:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0101c7b:	89 d8                	mov    %ebx,%eax
f0101c7d:	d3 e0                	shl    %cl,%eax
f0101c7f:	89 f1                	mov    %esi,%ecx
f0101c81:	d3 ed                	shr    %cl,%ebp
f0101c83:	d3 eb                	shr    %cl,%ebx
f0101c85:	09 e8                	or     %ebp,%eax
f0101c87:	89 da                	mov    %ebx,%edx
f0101c89:	83 c4 1c             	add    $0x1c,%esp
f0101c8c:	5b                   	pop    %ebx
f0101c8d:	5e                   	pop    %esi
f0101c8e:	5f                   	pop    %edi
f0101c8f:	5d                   	pop    %ebp
f0101c90:	c3                   	ret    
