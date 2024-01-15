// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define BKSIZE  13
#define NBUFSIZE  BKSIZE * NBUF

struct {
  struct buf bucket[BKSIZE];    // 哈希桶
  struct spinlock lock[BKSIZE];    // 为每个哈希桶配置一把锁
  struct buf buf[NBUFSIZE];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  // struct buf head;
} bcache;

void
binit(void)
{
  struct buf *b;

  for(int i = 0; i < BKSIZE; i++)
  {
    initlock(&bcache.lock[i], "bcache");
  }

  for(int i = 0; i < BKSIZE; i++)
  {
    bcache.bucket[i].next = &bcache.bucket[i];
    bcache.bucket[i].prev = &bcache.bucket[i];
    
    for(b = bcache.buf + i * NBUF; b < bcache.buf + (i + 1) * NBUF; b++)
    {
      b->next = bcache.bucket[i].next;
      b->prev = &bcache.bucket[i];
      initsleeplock(&b->lock, "buffer");
      bcache.bucket[i].next->prev = b;
      bcache.bucket[i].next = b;
    }
  }
  /*
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  */
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  int idx = (dev + blockno) % BKSIZE;     // 获取缓存块的索引,即是bcache中定义的哈希桶的索引

  struct buf *b;

  acquire(&bcache.lock[idx]);

  // Is the block already cached?
  for(b = bcache.bucket[idx].next; b != &bcache.bucket[idx]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock[idx]);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.bucket[idx].prev; b != &bcache.bucket[idx]; b = b->prev){
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock[idx]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int idx = (b->dev + b->blockno) % BKSIZE;

  acquire(&bcache.lock[idx]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.bucket[idx].next;
    b->prev = &bcache.bucket[idx];
    bcache.bucket[idx].next->prev = b;
    bcache.bucket[idx].next = b;
  }
  
  release(&bcache.lock[idx]);
}

void
bpin(struct buf *b) {
  int idx = (b->dev + b->blockno) % BKSIZE;

  acquire(&bcache.lock[idx]);
  b->refcnt++;
  release(&bcache.lock[idx]);
}

void
bunpin(struct buf *b) {
  int idx = (b->dev + b->blockno) % BKSIZE;

  acquire(&bcache.lock[idx]);
  b->refcnt--;
  release(&bcache.lock[idx]);
}


