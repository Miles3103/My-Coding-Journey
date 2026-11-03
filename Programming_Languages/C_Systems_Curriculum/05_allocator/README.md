# Project 5: `mymalloc`, a Custom Memory Allocator

**Level:** Advanced | **Estimated time:** 3-4 weeks | **Prev:** [Project 4](../04_http_server/README.md) | **Back to:** [Curriculum Home](../README.md)

---

## 1. Overview

You will implement your own `malloc`, `free`, `calloc`, and `realloc`, and then inject them into **real programs** (`ls`, `python`, your own HTTP server from Project 4) using `LD_PRELOAD`:

```bash
LD_PRELOAD=./libmymalloc.so ls -la /usr
LD_PRELOAD=./libmymalloc.so ./tinyhttpd --port 8080
```

### Why this project matters for a C developer

Every Project so far *used* the heap. Now you build it. Writing an allocator forces you to:

- Understand what a **pointer actually is**: an address in a virtual address space you manage.
- Learn how the OS provides memory: `brk`/`sbrk` and `mmap`.
- Master **alignment**, **pointer arithmetic**, and **type punning** without falling into undefined behavior.
- Weigh classic systems trade-offs: **speed vs. fragmentation vs. metadata overhead vs. safety**.
- Debug bugs where the debugger's own tools (Valgrind/ASan) are *replaced by the thing you are writing*.

After this project, "`malloc` is slow", "heap fragmentation", "use-after-free exploit", and "arena allocator" will be concrete concepts, not buzzwords.

---

## 2. Core C Concepts Learned

- [ ] Virtual memory, the process address space (text/data/heap/mmap/stack)
- [ ] System calls: `sbrk`/`brk`, `mmap`/`munmap`, `getpagesize`/`sysconf(_SC_PAGESIZE)`
- [ ] Pointer arithmetic with `char *` / `uint8_t *` / `uintptr_t`
- [ ] Alignment requirements; `_Alignof`, `max_align_t`; aligned rounding with bit masks
- [ ] Block headers/footers ("boundary tags"), size-and-flag packing in low bits
- [ ] Intrusive linked lists (list nodes stored **inside** free blocks)
- [ ] Allocation policies: first-fit, next-fit, best-fit, segregated lists
- [ ] Splitting and **coalescing** blocks; internal vs. external fragmentation
- [ ] `size_t` overflow in `calloc`; `realloc` edge-case semantics
- [ ] Thread-safety: a global lock vs. per-thread arenas
- [ ] Shared-library interposition (`-shared -fPIC`, `LD_PRELOAD`, `dlsym(RTLD_NEXT)`)
- [ ] Writing a **heap consistency checker** (invariants as code)
- [ ] Why `printf` inside an allocator is dangerous (reentrancy); use `write(2)`
- [ ] Valgrind client requests / poisoning for allocator debugging

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Virtual memory** | Pages (4 KiB), page tables conceptually, demand paging, why `malloc` of 1 GB "succeeds" instantly (overcommit). CS:APP ch. 9 |
| **`brk`/`sbrk`** | The "program break"; heap grows upward; contiguous only; `man 2 brk` |
| **`mmap` anonymous** | `MAP_PRIVATE \| MAP_ANONYMOUS`; returned memory is zeroed; page-granular; can be returned with `munmap` |
| **glibc malloc overview** | Arenas, bins, chunks, `M_MMAP_THRESHOLD`. Skim "Understanding glibc malloc" write-ups |
| **Alignment** | Why `malloc` must return 16-byte aligned memory on x86-64; misaligned SSE access faults |
| **Data structure alignment & padding** | `offsetof`, `sizeof` of structs |
| **Implicit vs. explicit free lists** | CS:APP §9.9 is **required reading** |
| **Fragmentation** | Internal vs. external; why coalescing helps; pathological patterns |
| **Pointer provenance & strict aliasing** | Why you must treat the raw arena as `char` bytes and cast carefully |
| **Bit tricks** | `(n + 15) & ~15`; low bits of aligned sizes are free flag storage |
| **Dynamic linking & `LD_PRELOAD`** | How symbol resolution lets you replace `malloc` |
| **`errno` and `ENOMEM`** | What `malloc` should do on failure |

> **Required reading before Part 2:** CS:APP 3rd ed., **Section 9.9: Dynamic Memory Allocation**, covering implicit free list, placement, splitting, coalescing with boundary tags.

---

## 4. Repository Directory Layout

```text
05_allocator/
├── README.md
├── Makefile
├── include/
│   ├── mymalloc.h         # public API: mm_malloc, mm_free, ... (+ malloc names for preload)
│   ├── block.h            # header layout, flag macros, neighbor navigation
│   ├── freelist.h         # free-list operations
│   └── debug.h            # mm_check(), mm_dump(), tracing macros
├── src/
│   ├── mymalloc.c         # core allocator
│   ├── block.c
│   ├── freelist.c
│   ├── os_mem.c           # sbrk / mmap wrappers (the only OS-touching file)
│   ├── debug.c
│   └── preload.c          # exports malloc/free/calloc/realloc for LD_PRELOAD
├── tests/
│   ├── test_basic.c
│   ├── test_stress.c      # randomized alloc/free/realloc with patterns
│   ├── test_edge.c        # zero size, huge size, NULL, alignment
│   ├── traces/            # recorded alloc/free traces + replay driver
│   ├── bench.c
│   └── run_preload.sh
└── notes.md
```

> **Why isolate `os_mem.c`?** All OS interaction (how we obtain raw memory) lives in one file with a two-function interface (`os_grow(size)` / `os_release`). You can swap `sbrk` for `mmap` (or a static array for testing!) without touching allocator logic. A **static 1 MB array as the backing store** is a great way to debug deterministically before using real syscalls.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Bump allocator: get memory from the OS, alignment, `free` is a no-op |
| 2 | Block headers + free list: real `free`, first-fit reuse |
| 3 | Splitting & coalescing; heap consistency checker |
| 4 | `calloc`, `realloc`, large allocations via `mmap`, optional performance upgrades |
| 5 | Thread safety, debugging features, `LD_PRELOAD` integration, benchmarks |

---

### Part 1: Bump Allocator

#### Tasks

- [ ] Implement `os_grow(size_t n)` using `sbrk` (check for `(void *)-1`). Round request up to page size multiples.
- [ ] Maintain a "current chunk" with `cur` and `end` pointers; allocation = round size up to 16, advance `cur`.
- [ ] If the current chunk is exhausted, request more from the OS.
- [ ] `free()` does nothing (for now). Write a test that exhausts memory in a loop to *prove* why that's insufficient.
- [ ] Verify every returned pointer is 16-byte aligned (assert in tests).
- [ ] Return `NULL` and set `errno = ENOMEM` on failure.

#### Milestone skeleton

```c
#include <stddef.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>

#define ALIGNMENT 16u
#define ALIGN_UP(n)  (((n) + (ALIGNMENT - 1)) & ~(size_t)(ALIGNMENT - 1))

static uint8_t *cur, *end;

static int grow_heap(size_t need)
{
    size_t page = (size_t)sysconf(_SC_PAGESIZE);
    size_t chunk = (need + page - 1) / page * page;
    void *p = sbrk((intptr_t)chunk);
    if (p == (void *)-1) return -1;
    /* NOTE: other code may have moved the break; handle non-contiguous growth */
    if ((uint8_t *)p != end) cur = (uint8_t *)p;   /* new region isn't adjacent */
    end = (uint8_t *)p + chunk;
    return 0;
}

void *mm_malloc(size_t size)
{
    if (size == 0) return NULL;                  /* one allowed behavior */
    if (size > SIZE_MAX - ALIGNMENT) { errno = ENOMEM; return NULL; }  /* overflow */
    size_t need = ALIGN_UP(size);
    if ((size_t)(end - cur) < need && grow_heap(need) != 0) {
        errno = ENOMEM; return NULL;
    }
    void *p = cur;
    cur += need;
    return p;
}
```

> **Why 16-byte alignment?** On x86-64 the ABI guarantees `malloc` results are suitably aligned for *any* standard type (`max_align_t` is 16 bytes, for `long double` and SSE types). Code compiled with `-O2` may use aligned vector instructions (`movaps`) on your pointer and **fault** if it's misaligned.

> **Why `ALIGN_UP` via mask instead of `%` and `/`?** `(n + 15) & ~15` is two cheap ALU operations and works because alignment is a power of two. Make sure you can explain *why* adding 15 then clearing the low 4 bits rounds up.

> **Why check `size > SIZE_MAX - ALIGNMENT` first?** Otherwise `size + 15` wraps to a tiny number, you hand back a 16-byte block for a request of ~2^64 bytes, and the caller writes far out of bounds. Integer overflow in allocators is a classic **security vulnerability**.

#### Checkpoint 1

```c
void *a = mm_malloc(1), *b = mm_malloc(17);
assert(((uintptr_t)a % 16) == 0 && ((uintptr_t)b % 16) == 0);
assert((uint8_t *)b - (uint8_t *)a == 16);
```

---

### Part 2: Block Headers & a Free List

#### Design

Each allocation is preceded by a **header** storing its size and whether it's free. `free(p)` finds the header by stepping back from `p`, and marks the block free so `malloc` can reuse it.

```text
          ┌──────── header ────────┐┌──────────── payload ───────────┐
 heap:    │ size │ is_free │ next │ prev ││ user data ...                │
          └─────────────────────────┘└──────────────────────────────────┘
          ▲                          ▲
          block start                pointer returned to caller (16-aligned)
```

You'll first use a simple **doubly-linked list of ALL blocks** in address order (simple, makes coalescing easy). In Part 5 you may upgrade to boundary tags + explicit free list.

#### Tasks

- [ ] Define `BlockHeader` and ensure `sizeof(BlockHeader)` is a **multiple of 16** (so payload stays aligned). Enforce with `_Static_assert`.
- [ ] Implement helpers: `header_of(void *payload)`, `payload_of(Block *b)`.
- [ ] `mm_malloc`: scan the block list for the first free block with `size >= need` (**first-fit**); otherwise extend the heap and append a new block.
- [ ] `mm_free`: `free(NULL)` is a no-op; otherwise mark free. **Detect double free** (header already free → abort with message via `write(2)`).
- [ ] Add a `magic` field or validate that the pointer lies within the heap before trusting the header.

#### Milestone skeleton: `include/block.h`

```c
#include <stddef.h>
#include <stdint.h>

typedef struct Block {
    size_t        size;      /* payload bytes (multiple of 16) */
    size_t        is_free;   /* 0/1 (size_t to keep header 16-multiple) */
    struct Block *next;      /* next block in ADDRESS order */
    struct Block *prev;
} Block;                     /* 32 bytes on LP64 */

_Static_assert(sizeof(Block) % 16 == 0, "header must preserve alignment");

#define HDR_SIZE  (sizeof(Block))

static inline void *payload_of(Block *b)  { return (uint8_t *)b + HDR_SIZE; }
static inline Block *header_of(void *p)   { return (Block *)((uint8_t *)p - HDR_SIZE); }
```

> **Why must the header size be a multiple of 16?** The caller receives `block + HDR_SIZE`. If the block start is 16-aligned and the header is, say, 24 bytes, the payload is only 8-aligned, so you've silently broken the ABI contract.

> **Why `uint8_t *` (or `char *`) arithmetic, never `void *`?** Arithmetic on `void *` is a GNU extension, not standard C. `char`-type pointers also have special aliasing privileges, making byte-level arithmetic well-defined.

> **Metadata overhead:** 32-byte headers on a 16-byte allocation = 200% overhead. Real allocators use 8-16 bytes (and glibc reuses the *footer* space of the previous chunk). In Part 5 you'll measure and reduce this.

---

### Part 3: Splitting, Coalescing & the Heap Checker

#### Tasks

- [ ] **Split:** when a free block is much larger than needed (leftover ≥ `HDR_SIZE + 16`), carve it into an allocated part and a **new free remainder** with its own header.
- [ ] **Coalesce on free:** if the next block (by address) is free **and physically adjacent**, merge; same for the previous block. Merge **both directions**.
- [ ] Careful: blocks from separate `sbrk` regions may not be adjacent. Verify `(uint8_t*)b + HDR_SIZE + b->size == (uint8_t*)b->next` before merging.
- [ ] Implement **`mm_check()`**, a heap invariant checker (see below). Call it after *every* operation in tests.
- [ ] Add a `mm_dump()` that prints the heap layout using `write(2)`/`snprintf`, not `printf`.

#### Milestone skeleton

```c
static void split_block(Block *b, size_t need)
{
    if (b->size >= need + HDR_SIZE + ALIGNMENT) {          /* worth splitting? */
        Block *rest = (Block *)((uint8_t *)payload_of(b) + need);
        rest->size    = b->size - need - HDR_SIZE;
        rest->is_free = 1;
        rest->next    = b->next;
        rest->prev    = b;
        if (b->next) b->next->prev = rest;
        b->next = rest;
        b->size = need;
    }
}

static Block *coalesce(Block *b)
{
    /* forward merge */
    if (b->next && b->next->is_free && adjacent(b, b->next)) {
        b->size += HDR_SIZE + b->next->size;
        b->next  = b->next->next;
        if (b->next) b->next->prev = b;
    }
    /* backward merge */
    if (b->prev && b->prev->is_free && adjacent(b->prev, b)) {
        b = b->prev;
        /* TODO: same merge, absorbing the (old) b into b->prev */
    }
    return b;
}
```

#### The heap consistency checker: your most valuable tool

```c
/* Returns 0 if the heap is consistent, else a nonzero code (and prints why). */
int mm_check(void)
{
    for (Block *b = heap_head; b; b = b->next) {
        /* 1. payload pointer is 16-byte aligned                                */
        /* 2. size is a multiple of 16 and >= 16                                */
        /* 3. block lies entirely within [heap_lo, heap_hi)                     */
        /* 4. b->next->prev == b  (list links are mutually consistent)          */
        /* 5. no two ADJACENT blocks are both free (coalescing is complete)     */
        /* 6. if next block is adjacent: b + HDR + size == next                 */
        /* 7. is_free is exactly 0 or 1                                         */
    }
    return 0;
}
```

> **Why write an invariant checker?** Allocator bugs corrupt metadata *silently*, then crash 10,000 operations later in an unrelated place. A checker that runs after every operation converts "random crash much later" into "fails on the exact operation that broke the heap." Professional allocator developers consider this non-optional.

> **Why does the previous block need to be free *and* adjacent before merging?** The list links blocks in address order, but each `sbrk` call can return a **non-contiguous** region (something else moved the break). Merging across a gap would make you "own" memory that isn't yours.

#### Checkpoint 3

```c
void *a = mm_malloc(100), *b = mm_malloc(100), *c = mm_malloc(100);
mm_free(a); mm_free(c); mm_free(b);   /* order matters: tests both merge directions */
assert(mm_check() == 0);
assert(count_blocks() == 1);          /* everything coalesced into one free block */
```

---

### Part 4: `calloc`, `realloc`, and Large Allocations

#### Tasks

- [ ] **`mm_calloc(n, size)`**: check `n * size` for overflow **before** multiplying; zero the memory (fresh `mmap` pages are already zero, so recycled blocks need `memset`).
- [ ] **`mm_realloc(p, new_size)`** with all the edge cases:
  - `p == NULL` → behaves like `malloc(new_size)`
  - `new_size == 0` → behaves like `free(p)` and returns `NULL` (document your choice)
  - shrink → split in place if worthwhile
  - grow → try to **expand in place** by absorbing a free adjacent next block; otherwise `malloc` new + `memcpy(min(old,new))` + `free` old
  - on failure, **the original block must remain valid**
- [ ] **Large allocations via `mmap`**: if `size ≥ 128 KiB` (tune it), `mmap` a dedicated region (header + payload, page-rounded), mark it `is_mmapped`, and `munmap` on free. This avoids fragmenting the main heap and returns memory to the OS.
- [ ] *(Performance, optional)* **Segregated free lists** (size classes 16, 32, 48, ..., 512, then powers of two) for O(1) typical allocation, or **best-fit** to reduce fragmentation. Benchmark each policy.
- [ ] *(Optional)* Shrink the heap by `sbrk(-n)` when the top block is free and large.

#### Milestone skeleton

```c
void *mm_calloc(size_t n, size_t size)
{
    if (size != 0 && n > SIZE_MAX / size) { errno = ENOMEM; return NULL; }
    size_t total = n * size;
    void *p = mm_malloc(total);
    if (p) memset(p, 0, total);       /* skip for fresh mmap'd blocks (already zero) */
    return p;
}

void *mm_realloc(void *p, size_t new_size)
{
    if (!p)            return mm_malloc(new_size);
    if (new_size == 0) { mm_free(p); return NULL; }

    Block *b = header_of(p);
    size_t need = ALIGN_UP(new_size);
    if (b->size >= need) { /* TODO: shrink via split_block */ return p; }

    /* TODO: try to absorb b->next if free, adjacent, and big enough */

    void *q = mm_malloc(new_size);
    if (!q) return NULL;              /* original untouched, still valid */
    memcpy(q, p, b->size < new_size ? b->size : new_size);
    mm_free(p);
    return q;
}
```

#### Upgrade path: boundary tags (reduce overhead from 32 → 8-16 bytes)

Replace the all-blocks linked list with **header + footer** words:

```text
   [ hdr: size|alloc ][ payload ... ][ ftr: size|alloc ]
```

- Pack `alloc` into bit 0 of `size` (sizes are multiples of 16, so the low 4 bits are always zero, **free metadata space**).
- The *next* block is at `(char*)b + size`; the *previous* block's size lives in the word just before your header.
- Free blocks reuse their (otherwise unused) payload to store `next_free`/`prev_free` pointers → an **explicit free list** of only free blocks, so `malloc` doesn't walk allocated blocks.

```c
#define PACK(size, alloc)  ((size) | (alloc))
#define GET_SIZE(w)        ((w) & ~(size_t)0xF)
#define GET_ALLOC(w)       ((w) & 0x1)
```

> **Why `memcpy` and not `memmove` in `realloc`?** The old and new blocks are guaranteed distinct, non-overlapping allocations, so `memcpy` is correct and potentially faster. If you had **in-place expansion**, you'd skip the copy altogether. Know *when* each is legal.

> **Why must `realloc` leave the original intact on failure?** Callers write `tmp = realloc(p, n); if (!tmp) { handle; free(p); }`. If you freed `p` before failing, you'd create a double-free in correct client code. (This is exactly the bug from Project 2's pitfalls table, now seen from the *other side*.)

---

### Part 5: Thread Safety, Debug Features, Preload & Benchmarks

#### Tasks

**Thread safety**
- [ ] Protect all allocator state with one global `pthread_mutex_t` (simplest correct design).
- [ ] Measure contention using your Project 4 server or a multi-threaded benchmark.
- [ ] *(Stretch)* Per-thread caches (`__thread` storage) that grab batches from the global heap, the idea behind tcmalloc/jemalloc.

**Debug features** (compile-time switch `-DMM_DEBUG`)
- [ ] **Canaries:** write a known pattern (`0xDEADBEEF...`) after each payload; verify on `free` to detect heap overflows.
- [ ] **Poison on free:** `memset(p, 0xDD, size)` to make use-after-free visible fast.
- [ ] **Poison on alloc:** fill new blocks with `0xAA` so reading uninitialized memory yields obviously wrong values.
- [ ] **Double-free and invalid-free detection** (pointer not in heap / bad magic).
- [ ] Allocation counters and `mm_stats()`: bytes in use, peak usage, fragmentation ratio.

**`LD_PRELOAD` integration** (`src/preload.c`)
- [ ] Export `malloc`, `free`, `calloc`, `realloc` (and ideally `posix_memalign`, `aligned_alloc`, `memalign`) with the standard names.
- [ ] Build `libmymalloc.so` (`-shared -fPIC`).
- [ ] Test with real programs: `ls`, `cat`, `sort`, `python3 -c "print(sum(range(10**6)))"`, `gcc`, and your Project 4 server.
- [ ] Handle **reentrancy during startup**: libc/`dlsym` may call `malloc` before your allocator initializes. Use lazy init guarded by the mutex, and a tiny static bootstrap buffer if needed.
- [ ] **Never call `printf`, `fprintf`, or anything that mallocs from inside the allocator**; it recurses infinitely or deadlocks on your own mutex. Use `write(2, ...)` and a hand-rolled integer-to-string.

#### Milestone skeleton: `src/preload.c`

```c
#include <stddef.h>
#include "mymalloc.h"

void *malloc(size_t n)               { return mm_malloc(n); }
void  free(void *p)                  { mm_free(p); }
void *calloc(size_t n, size_t s)     { return mm_calloc(n, s); }
void *realloc(void *p, size_t n)     { return mm_realloc(p, n); }

/* TODO: posix_memalign, aligned_alloc, memalign, malloc_usable_size */
```

```bash
gcc -shared -fPIC -O2 -o libmymalloc.so src/*.c -pthread
LD_PRELOAD=./libmymalloc.so ls -l /
```

#### Milestone skeleton: async-safe debug printing

```c
#include <unistd.h>
static void dbg_write_hex(int fd, uintptr_t v)
{
    char buf[2 + sizeof v * 2];
    size_t i = sizeof buf;
    do { buf[--i] = "0123456789abcdef"[v & 0xF]; v >>= 4; } while (v);
    buf[--i] = 'x'; buf[--i] = '0';
    (void)!write(fd, buf + i, sizeof buf - i);
}
```

> **Why can't valgrind/ASan verify your allocator?** They *intercept* `malloc`/`free` themselves. When you replace them, the tools either bypass your code or are confused by your heap games. Use your own `mm_check()`, canaries, and poison patterns, and optionally the Valgrind **client-request macros** (`VALGRIND_MALLOCLIKE_BLOCK`, `VALGRIND_FREELIKE_BLOCK`) to teach Valgrind about your blocks.

---

## 6. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Header not a multiple of 16** | Crashes in SSE/AVX code (`movaps`), only at `-O2` | `_Static_assert(sizeof(Block) % 16 == 0)` |
| **`size + ALIGNMENT - 1` overflow** | Tiny block for a gigantic request → heap overflow | Check against `SIZE_MAX` first |
| **`n * size` overflow in `calloc`** | Same, via the classic CVE pattern | `n > SIZE_MAX / size` check |
| **Forgetting header size when splitting** | Overlapping blocks, corrupted neighbors | Draw the memory diagram; verify with `mm_check()` |
| **Coalescing non-adjacent blocks** | Memory "owned" that isn't yours | Compare addresses before merging |
| **Merging then using the stale pointer** | Use-after-free of *your own* metadata | Return the merged block pointer from `coalesce()` |
| **Not updating `prev`/`next` of neighbors** | List corruption → infinite loops | Update both directions; run `mm_check()` each step |
| **`realloc` freeing before failing** | Double-free in callers | Only free the old block after the new copy succeeds |
| **`realloc(p, 0)` / `realloc(NULL, n)`** | Wrong semantics → leaks or crashes | Implement and test the documented behavior |
| **`free(NULL)` crashes** | Segfault in common client code | Early return |
| **No double-free detection** | Silent heap corruption | Check `is_free`/magic; abort loudly |
| **Using `printf` in the allocator** | Infinite recursion / deadlock under `LD_PRELOAD` | `write(2)` + manual formatting |
| **Initialization race** | Crash in multithreaded programs at startup | Lock-protected lazy init (or `pthread_once`) |
| **Assuming `sbrk` regions are contiguous** | Corruption when other code calls `sbrk` or `mmap` | Track region boundaries; handle gaps |
| **Misaligned `mmap` payload** | Faults | Header size multiple of 16; `mmap` is page-aligned |
| **Wrong `munmap` size** | `EINVAL` / leak | Store total mapping length in the header |
| **Returning memory with stale data from `calloc`** | Non-zero "zeroed" memory | `memset` recycled blocks |
| **Type-punning via incompatible pointer casts** | Optimizer-dependent breakage | Keep raw heap as `uint8_t *`; cast only to your `Block` type at well-defined offsets |
| **Holding the lock during `mmap`/`munmap`** | Contention hot spot | Do syscalls outside the critical section where possible |
| **Fragmentation blow-up** | RSS grows though live data doesn't | Coalesce; consider best-fit / size classes; measure it |

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests (`tests/test_basic.c`, `tests/test_edge.c`)

- [ ] `malloc(1)`, `malloc(15)`, `malloc(16)`, `malloc(17)`: all 16-aligned, all distinct, writable end-to-end
- [ ] `malloc(0)` and `free(NULL)` behave sanely
- [ ] `malloc(SIZE_MAX)` and `malloc(SIZE_MAX - 8)` return `NULL` with `ENOMEM` (no crash, no wraparound)
- [ ] `calloc(SIZE_MAX / 2, 4)` fails cleanly; `calloc(100, 8)` returns all zeros even on a reused (dirtied) block
- [ ] Free-then-malloc same size reuses the same address (first-fit determinism)
- [ ] Coalescing in all orders: free A,B,C; C,B,A; A,C,B (6 permutations)
- [ ] `realloc` grow/shrink preserves contents (fill with a pattern, check after)
- [ ] `realloc(NULL, n)`, `realloc(p, 0)`, `realloc` failure leaves `p` valid
- [ ] Large allocation (1 MB) uses `mmap` path; `free` returns it (check `/proc/self/maps` before/after)

### 7.2 Randomized stress test with data integrity checking

```c
#define SLOTS 1000
struct { void *p; size_t n; uint8_t tag; } live[SLOTS] = {0};

for (long iter = 0; iter < 5000000; iter++) {
    int i = rand() % SLOTS;
    if (live[i].p) {
        /* verify EVERY byte still equals tag → detects overlap/corruption */
        for (size_t k = 0; k < live[i].n; k++)
            assert(((uint8_t *)live[i].p)[k] == live[i].tag);
        if (rand() % 3 == 0) { /* realloc: verify min(old,new) bytes preserved */ }
        else { mm_free(live[i].p); live[i].p = NULL; }
    } else {
        live[i].n = 1 + (size_t)(rand() % 4096);
        live[i].tag = (uint8_t)rand();
        live[i].p = mm_malloc(live[i].n);
        assert(live[i].p && ((uintptr_t)live[i].p % 16) == 0);
        memset(live[i].p, live[i].tag, live[i].n);
    }
    if (iter % 1000 == 0) assert(mm_check() == 0);
}
```

Seed `srand` with a printed value so any failure is **reproducible**. Run with several seeds.

### 7.3 Real-program validation

```bash
LD_PRELOAD=$PWD/libmymalloc.so ls -R /usr/share | wc -l
LD_PRELOAD=$PWD/libmymalloc.so python3 -c "import json; print(len(json.dumps(list(range(10**6)))))"
LD_PRELOAD=$PWD/libmymalloc.so gcc -O2 -c ../01_cli_tool/src/search.c -I../01_cli_tool/include -o /tmp/x.o
LD_PRELOAD=$PWD/libmymalloc.so ../04_http_server/tinyhttpd --port 8080 &
ab -n 20000 -c 50 http://localhost:8080/index.html
```

Note: if the program crashes, run under GDB with `LD_PRELOAD` set via `(gdb) set environment LD_PRELOAD=./libmymalloc.so`, enable `-DMM_DEBUG`, and see which invariant fires first.

### 7.4 Trace-driven benchmarks

Record `(op, size, id)` traces from a real run (via a logging shim), then replay on glibc malloc vs. `mymalloc`. Report in `notes.md`:

| Metric | How to measure |
|--------|---------------|
| **Throughput** | ops/sec (`clock_gettime`) |
| **Peak memory** | max `heap_size` vs. max live bytes |
| **Utilization** | `peak_live_bytes / peak_heap_bytes` (higher = less fragmentation) |
| **Latency tail** | worst-case single `malloc` time (first-fit list walks can be slow) |
| **Per-allocation overhead** | header bytes ÷ average size |

Compare policies: first-fit vs. next-fit vs. best-fit vs. segregated lists.

### 7.5 Debugging toolkit

```bash
gdb ./test_stress
(gdb) break mm_check if heap_corrupt_flag    # or break on abort
(gdb) x/16gx b                                # examine a header: raw 8-byte words
(gdb) x/64xb payload                          # bytes of payload (see canary patterns)
(gdb) watch *(size_t *)0x...                  # hardware watchpoint on a header word
(gdb) p *(Block *)0x...                       # interpret memory as your struct

strace -e trace=brk,mmap,munmap ./test_stress # confirm you ask the OS for memory sparingly
ltrace -e malloc+free ./test_basic            # see calls (if not preloaded)
```

**Exercise:** corrupt a header on purpose (`((size_t *)p)[-4] = 0;`), then use `mm_check()` + GDB `x/` commands to track down which invariant fails and where.

### 7.6 Sanitizers for *your own* allocator code

Compile **allocator internals** with UBSan (`-fsanitize=undefined`) to catch shifts, misalignment, and signed overflow in your arithmetic. (Skip ASan for the allocator itself since it intercepts `malloc`, but you *can* run client tests that use `mm_malloc` directly, as a library with a different name, under ASan to check the **clients** don't misuse memory.)

---

## 8. Stretch Goals

- [ ] **Slab/pool allocator** for fixed-size objects: O(1) alloc/free, zero fragmentation
- [ ] **Arena (region) allocator** with bulk free, which is ideal for request-scoped memory in Project 4
- [ ] **Per-thread arenas** to eliminate lock contention (see tcmalloc/jemalloc design docs)
- [ ] **Red-black tree or buddy system** allocator and comparison of fragmentation behavior
- [ ] Implement `posix_memalign`/`aligned_alloc` with arbitrary power-of-two alignment
- [ ] Use `madvise(MADV_DONTNEED)` to return free pages to the OS without `munmap`
- [ ] **Simple mark-and-sweep garbage collector** on top: conservative stack scan + heap scan using your block headers to validate "is this word a pointer into a live block?"
- [ ] Write a **toy VM** (Project 5 alternative): bytecode interpreter, stack machine, using your allocator for its heap

## 9. Definition of Done

- [ ] `malloc/free/calloc/realloc` pass all unit tests and the randomized integrity stress (5M ops, multiple seeds, `mm_check()` clean)
- [ ] Overflow-safe on every size computation; returns 16-byte-aligned pointers always
- [ ] Coalescing correct in both directions; large blocks use `mmap`
- [ ] Thread-safe: passes a multithreaded stress test under ThreadSanitizer (for client code) and heap checker
- [ ] `LD_PRELOAD` runs `ls`, `python3`, `gcc`, and `tinyhttpd` without crashing
- [ ] Benchmark table in `notes.md` comparing your allocator with glibc, with an honest explanation of where and why you win/lose
- [ ] `notes.md` includes: memory diagram of your block layout, invariants list, and 3 bugs `mm_check()` caught

---

## 🎓 Curriculum Complete

You've now built a CLI tool, a database engine, a binary parser, a concurrent network server, and the allocator beneath them all. Natural next steps:

- **Read real code:** `redis` (data structures, event loop), `sqlite` (storage engine), `musl libc` (clean libc), Linux kernel `mm/slab.c`
- **Go deeper on I/O:** `epoll`/`io_uring`, lock-free queues, memory-ordering and `<stdatomic.h>`
- **Security:** write an exploit for a deliberately vulnerable program (pwnable.kr, CTFs) to see why every pitfall in these READMEs matters
- **Compilers/runtimes:** write a small language interpreter or JIT on top of Projects 2 and 5

⬅️ **Back to:** [Curriculum Home](../README.md)
