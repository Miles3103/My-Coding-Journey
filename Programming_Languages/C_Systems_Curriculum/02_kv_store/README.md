# Project 2: `cask`, an In-Memory Key-Value Store with File Persistence

**Level:** Beginner → Intermediate | **Estimated time:** ~2 weeks | **Prev:** [Project 1](../01_cli_tool/README.md) | **Next:** [Project 3](../03_bmp_parser/README.md)

---

## 1. Overview

You will build a small Redis-like database as a **library** plus a **REPL** (interactive shell):

```text
$ ./cask data.db
cask> SET name "Ada Lovelace"
OK
cask> GET name
"Ada Lovelace"
cask> DEL name
(1)
cask> COUNT
0
cask> QUIT
```

Internally: a **hand-written hash table** (separate chaining, dynamic resizing) and a **crash-tolerant append-only log** for persistence.

### Why this project matters for a C developer

C has no built-in dynamic array, map, or string type. Real C programs are built from data structures like this one. Here you learn to:

- Design an **API with clear ownership rules** (who allocates? who frees?), the central discipline of C.
- Manage heap memory across the full lifecycle: create, grow, shrink, destroy.
- Hide implementation details behind **opaque types**, which is C's way of doing encapsulation.
- Think about **durability**: what survives a power cut halfway through a write?

---

## 2. Core C Concepts Learned

- [ ] `malloc`, `calloc`, `realloc`, `free`, and the "realloc into a temp" idiom
- [ ] Linked lists and pointer-to-pointer manipulation (`Entry **`)
- [ ] Opaque structs (`typedef struct HashTable HashTable;` in the header, defined in `.c`)
- [ ] Hash functions, load factor, rehashing
- [ ] Error handling via return codes + `enum`, with out-parameters
- [ ] Binary file I/O: `fread`/`fwrite`, `fflush`, `fsync`, `rename`
- [ ] Fixed-width integers (`uint32_t`) and on-disk formats
- [ ] `size_t` arithmetic and overflow checks
- [ ] `const` correctness and `void *` for generic values
- [ ] Unit testing with assertions (or the Unity framework)
- [ ] Memory ownership: "borrowed" vs. "owned" pointers

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Heap allocation lifecycle** | `malloc` can return `NULL`; `free(NULL)` is safe; double-free is UB |
| **`realloc` semantics** | It may move memory; on failure the original block is still valid |
| **Hash tables** | Collision strategies (chaining vs. open addressing), load factor, why table sizes matter |
| **Hash functions** | FNV-1a, djb2; avalanche behavior; why `hash % size` is cheap if size is a power of 2 (`hash & (size-1)`) |
| **Opaque pointers** | Forward declaration; why callers can't touch struct fields |
| **`fread`/`fwrite` return values** | Short reads/writes; `feof` vs `ferror` |
| **Buffered I/O vs. durability** | `fwrite` → user buffer → `fflush` → kernel cache → `fsync` → disk |
| **Atomic file replacement** | write temp file → `fsync` → `rename()` (atomic on POSIX) |
| **Endianness & fixed-width types** | Why `sizeof(int)` is not portable in a file format |
| **Pointer-to-pointer idiom** | Removing a node from a singly linked list without a special case for the head |

---

## 4. Repository Directory Layout

```text
02_kv_store/
├── README.md
├── Makefile
├── include/
│   ├── hashtable.h      # generic string->bytes table (opaque)
│   ├── kv.h             # public store API (wraps table + persistence)
│   └── log.h            # persistence layer API (internal)
├── src/
│   ├── hashtable.c
│   ├── kv.c
│   ├── persist.c
│   └── repl.c           # main(): command parser loop
├── tests/
│   ├── test_hashtable.c
│   ├── test_persist.c
│   ├── test_fuzz.c      # randomized ops vs. reference model
│   └── crash_test.sh
└── notes.md
```

Build the **library** as `libcask.a` and link both `repl` and the tests against it:

```make
lib: $(LIB_OBJS)
	ar rcs build/libcask.a $^
```

> **Why a library + thin `main`?** Testability. Tests can call your API directly without driving a text shell, and the same design reappears in every serious C project.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Hash table core: create/destroy, put/get/delete (no resize) |
| 2 | Dynamic resizing + load factor + stress tests |
| 3 | REPL command layer (`SET/GET/DEL/COUNT/KEYS`) |
| 4 | Persistence: append-only log, replay on startup |
| 5 | Compaction (atomic snapshot) + crash-recovery hardening |

---

### Part 1: Hash Table Core

#### Tasks

- [ ] Define the public API in `hashtable.h` with an **opaque** `HashTable` type.
- [ ] Implement FNV-1a 64-bit hash.
- [ ] Use **separate chaining**: each bucket is a singly linked list of `Entry`.
- [ ] `ht_put` **copies** the key and value (the table owns its data). Decide and document: overwrite on duplicate key.
- [ ] `ht_get` returns a **borrowed** pointer into the table. Document that it's invalidated by the next `put`/`delete`.
- [ ] `ht_delete` unlinks and frees the entry; returns whether the key existed.
- [ ] `ht_destroy` frees *everything*, including all keys, values, entries, bucket array, and the table struct.

#### Milestone skeleton: `include/hashtable.h`

```c
#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stddef.h>
#include <stdbool.h>

typedef struct HashTable HashTable;      /* opaque: defined in hashtable.c */

typedef enum {
    HT_OK = 0,
    HT_ERR_NOMEM,
    HT_ERR_INVALID,
    HT_ERR_NOTFOUND
} HtStatus;

/* Creates an empty table. Returns NULL on allocation failure.
 * Caller owns the result; free with ht_destroy(). */
HashTable *ht_create(size_t initial_buckets);

/* Frees the table and everything it owns. Safe on NULL. */
void ht_destroy(HashTable *t);

/* Copies key and value into the table. Overwrites existing value.
 * On failure, the table is unchanged. */
HtStatus ht_put(HashTable *t, const char *key,
                const void *val, size_t val_len);

/* Returns pointer to stored value (borrowed; valid until next mutation)
 * or NULL if absent. Sets *val_len if non-NULL. */
const void *ht_get(const HashTable *t, const char *key, size_t *val_len);

/* Returns HT_OK if removed, HT_ERR_NOTFOUND otherwise. */
HtStatus ht_delete(HashTable *t, const char *key);

size_t ht_count(const HashTable *t);

/* Iteration without exposing internals. */
typedef void (*ht_visit_fn)(const char *key, const void *val,
                            size_t val_len, void *user);
void ht_foreach(const HashTable *t, ht_visit_fn fn, void *user);

#endif
```

#### Milestone skeleton: `src/hashtable.c`

```c
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "hashtable.h"

typedef struct Entry {
    char         *key;       /* owned */
    void         *val;       /* owned */
    size_t        val_len;
    struct Entry *next;
} Entry;

struct HashTable {
    Entry **buckets;         /* array of nbuckets Entry* (each a list head) */
    size_t  nbuckets;        /* always a power of two */
    size_t  count;
};

static uint64_t fnv1a(const char *s)
{
    uint64_t h = 1469598103934665603ULL;           /* FNV offset basis */
    for (; *s; s++) {
        h ^= (unsigned char)*s;
        h *= 1099511628211ULL;                      /* FNV prime */
    }
    return h;
}

static size_t bucket_index(const HashTable *t, const char *key)
{
    return (size_t)(fnv1a(key) & (t->nbuckets - 1));  /* power-of-2 mask */
}

/* The pointer-to-pointer idiom: no special case for removing the head. */
HtStatus ht_delete(HashTable *t, const char *key)
{
    Entry **link = &t->buckets[bucket_index(t, key)];
    while (*link) {
        Entry *e = *link;
        if (strcmp(e->key, key) == 0) {
            *link = e->next;            /* unlink */
            /* TODO: free e->key, e->val, e; t->count--; */
            return HT_OK;
        }
        link = &e->next;
    }
    return HT_ERR_NOTFOUND;
}

/* TODO: ht_create, ht_destroy, ht_put, ht_get, ht_count, ht_foreach */
```

> **Why power-of-two bucket counts?** `hash & (n-1)` is a single AND instruction, whereas `hash % n` is an integer division (an order of magnitude slower). The cost: a weak hash that varies only in the high bits will cluster, which is one reason FNV mixes bits well.

> **Why does the table copy keys/values?** If it stored the caller's pointers, any caller that freed or modified its buffer would corrupt the table (a dangling pointer). Copying gives the table a clear, self-contained **ownership** story. The cost is extra allocations, a trade-off real systems tune (arenas, interning).

#### Checkpoint 1

```c
HashTable *t = ht_create(16);
assert(ht_put(t, "a", "1", 2) == HT_OK);
assert(strcmp(ht_get(t, "a", NULL), "1") == 0);
assert(ht_delete(t, "a") == HT_OK);
assert(ht_get(t, "a", NULL) == NULL);
ht_destroy(t);          // run under valgrind: 0 leaks
```

---

### Part 2: Dynamic Resizing

#### Tasks

- [ ] After each `put`, if `count / nbuckets > 0.75`, **double** the bucket array.
- [ ] Implement `rehash()` by **relinking existing entries**, not reallocating them.
- [ ] Handle allocation failure during resize: the table must remain valid (skip the resize and keep working with longer chains).
- [ ] Add a stress test inserting 1,000,000 keys; verify all are retrievable.
- [ ] *(Optional)* Shrink when the load factor drops below 0.15, with hysteresis to avoid thrashing.

#### Milestone skeleton

```c
static HtStatus ht_resize(HashTable *t, size_t new_n)
{
    Entry **nb = calloc(new_n, sizeof *nb);     /* zeroed => all lists empty */
    if (!nb) return HT_ERR_NOMEM;               /* old table still intact */

    for (size_t i = 0; i < t->nbuckets; i++) {
        Entry *e = t->buckets[i];
        while (e) {
            Entry *next = e->next;              /* save BEFORE relinking */
            size_t j = (size_t)(fnv1a(e->key) & (new_n - 1));
            e->next = nb[j];                    /* push-front into new bucket */
            nb[j]   = e;
            e = next;
        }
    }
    free(t->buckets);
    t->buckets  = nb;
    t->nbuckets = new_n;
    return HT_OK;
}
```

> **Why double rather than grow by a constant?** Doubling gives **amortized O(1)** inserts: total work for n inserts is ~2n copies. Growing by +10 each time would make n inserts O(n²). This is the same reasoning behind `std::vector` and Python lists.

> **Why `calloc(new_n, sizeof *nb)`?** It zero-fills (NULL pointers = empty lists) *and* checks the multiplication `new_n * sizeof` for overflow, whereas `malloc(new_n * sizeof ...)` can silently wrap. Also note `sizeof *nb` instead of `sizeof(Entry *)`: it stays correct if the type changes.

---

### Part 3: REPL Command Layer

#### Tasks

- [ ] Read a line with `getline`, tokenize into command + args (handle double-quoted values with spaces).
- [ ] Implement `SET key value`, `GET key`, `DEL key`, `COUNT`, `KEYS`, `QUIT`.
- [ ] Case-insensitive command names.
- [ ] Use a **dispatch table of function pointers** instead of an `if/else if` chain:

```c
typedef int (*cmd_fn)(Store *s, int argc, char **argv);

typedef struct {
    const char *name;
    int         min_args, max_args;
    cmd_fn      handler;
} Command;

static const Command COMMANDS[] = {
    { "SET",   2, 2, cmd_set   },
    { "GET",   1, 1, cmd_get   },
    { "DEL",   1, 1, cmd_del   },
    { "COUNT", 0, 0, cmd_count },
    { "KEYS",  0, 0, cmd_keys  },
};
```

> **Why function pointers?** Adding a command becomes a one-line table entry, not a change to control flow. This pattern appears in every C codebase (kernel `file_operations`, driver tables, interpreters), so it's worth internalizing now.

**Careful with tokenizing:** if you use `strtok`, remember it **modifies** the buffer and is **not thread-safe**. Writing your own tokenizer that records `(start, len)` pairs is a good pointer exercise.

---

### Part 4: Persistence with an Append-Only Log

#### Design

Every mutation is appended to a log file **before** being applied in memory. On startup, replay the log to rebuild the table. This is how Redis AOF, Bitcask, and many databases work.

##### On-disk record format (little-endian)

```text
┌──────────┬──────┬─────────┬──────────┬─────────┬───────┬──────────┐
│ magic u32│ op u8│ klen u32│ vlen  u32│ key ... │ val...│ crc32 u32│
└──────────┴──────┴─────────┴──────────┴─────────┴───────┴──────────┘
  op: 1 = SET, 2 = DEL (vlen = 0 for DEL)
```

The CRC covers everything before it. On replay, a record with a bad CRC or truncated body means **the tail was torn by a crash**: stop replaying there and **truncate the file** to the last good offset.

#### Tasks

- [ ] Write a **file header** (magic + version) so you can reject unrelated files.
- [ ] Serialize records field-by-field with explicit-width ints (never `fwrite(&struct, ...)`: padding and endianness make it non-portable).
- [ ] Implement `log_append_set`, `log_append_del`, `log_replay`.
- [ ] After each write: `fflush(fp)` then `fsync(fileno(fp))`. Add a `sync` policy option (`always` / `never`) and measure the performance difference.
- [ ] Validate lengths on replay (`klen`, `vlen` ≤ sane limits such as 1 MB) **before** allocating.
- [ ] Implement CRC32 yourself (table-driven).

#### Milestone skeleton: `include/log.h`

```c
#include <stdint.h>
#include <stdio.h>

typedef enum { LOG_OP_SET = 1, LOG_OP_DEL = 2 } LogOp;

typedef struct Log Log;          /* opaque */

Log *log_open(const char *path);                 /* creates header if new */
int  log_append(Log *l, LogOp op, const char *key,
                const void *val, uint32_t vlen); /* 0 ok, -1 error */
void log_close(Log *l);

/* Calls cb for each valid record, in order. On a torn tail it truncates
 * the file at the last good offset. Returns #records, or -1 on I/O error. */
typedef int (*log_replay_cb)(LogOp op, const char *key,
                             const void *val, uint32_t vlen, void *user);
long log_replay(Log *l, log_replay_cb cb, void *user);
```

#### Milestone skeleton: serializing integers safely

```c
static void put_u32le(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v);        p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);  p[3] = (uint8_t)(v >> 24);
}
static uint32_t get_u32le(const uint8_t *p)
{
    return (uint32_t)p[0] | (uint32_t)p[1] << 8 |
           (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}
```

> **Why byte-by-byte instead of casting a pointer to `uint32_t *`?** Casting a `uint8_t *` buffer to `uint32_t *` can trigger **misaligned access** (UB; crashes on some CPUs) and **strict-aliasing violations**. Shifts are portable, endian-independent, and compilers turn them into a single load where legal.

> **Why `fflush` *and* `fsync`?** `fwrite` only copies into libc's user-space buffer. `fflush` hands the bytes to the kernel, which still caches them in RAM. Only `fsync` asks the kernel to push them to the device. Without it, power loss can discard writes you *thought* were saved.

---

### Part 5: Compaction & Crash Recovery

The log grows forever (every overwrite and delete adds records). **Compaction** rewrites a minimal log containing only live keys.

#### Tasks

- [ ] `kv_compact()`: write all live entries to `data.db.tmp`, `fsync` it, `rename("data.db.tmp", "data.db")`, then reopen.
- [ ] Understand why `rename` makes this **atomic**: readers see either the old file or the new one, never half of each.
- [ ] `fsync` the *directory* after rename for full durability (look up why).
- [ ] Trigger compaction automatically when `log_size > 4 × live_size`.
- [ ] Write the crash test: kill the process mid-write and verify recovery.

```bash
# tests/crash_test.sh (sketch)
for i in $(seq 1 200); do
    ./cask_bench data.db --writes 10000 &   # writes continuously
    pid=$!
    sleep 0.0$((RANDOM % 9))
    kill -9 $pid
    ./cask_verify data.db || { echo "CORRUPT after crash $i"; exit 1; }
done
```

---

## 6. Common Bugs & Pitfalls

| Bug | How it bites | Fix |
|-----|-------------|-----|
| **`p = realloc(p, n)`** | On failure returns NULL and **leaks** the original | `tmp = realloc(p, n); if (!tmp) {...} p = tmp;` |
| **Storing the caller's `key` pointer** | Dangling pointer when caller frees/reuses buffer | `strdup` (or `malloc`+`memcpy`) into the entry |
| **Use-after-free in `delete`** | Reading `e->next` after `free(e)` | Save `next` first (or unlink before freeing) |
| **Leaking on partial failure in `put`** | `strdup(key)` succeeds, `malloc(val)` fails → key leaked | Free in reverse order on each error path (`goto cleanup` idiom) |
| **Double free in `destroy`** | Freed value and also table-level pointer | Draw an ownership diagram before coding |
| **Resize: iterating a list while relinking** | Infinite loop / lost nodes | Save `next` before changing `e->next` |
| **`hash % nbuckets` with signed ints** | Negative index → memory corruption | Use `uint64_t`/`size_t` throughout |
| **`fwrite(&struct)`** | Padding bytes and endianness leak into file format | Serialize fields explicitly |
| **Trusting `klen`/`vlen` from disk** | Giant `malloc` → crash or DoS | Cap lengths; check `klen + vlen` for overflow |
| **Treating short `fread` as success** | Partially read record accepted | Compare return value to requested count |
| **`strncpy` misuse** | No terminating `\0` | Prefer `memcpy` + explicit terminator |
| **Binary values treated as C strings** | Embedded `\0` truncates values | Store `(ptr, len)`, not `char *` |
| **Not handling `SET key ""`** | `malloc(0)` may return NULL or unique ptr | Decide: store `NULL`+`len 0` consistently |

### The `goto cleanup` idiom (idiomatic C error handling)

```c
HtStatus ht_put(HashTable *t, const char *key, const void *val, size_t len)
{
    HtStatus rc = HT_ERR_NOMEM;
    Entry *e   = calloc(1, sizeof *e);
    if (!e) goto fail;
    e->key = strdup(key);          /* POSIX; or malloc+memcpy */
    if (!e->key) goto fail;
    e->val = malloc(len ? len : 1);
    if (!e->val) goto fail;
    memcpy(e->val, val, len);
    e->val_len = len;
    /* ... link into bucket, count++ ... */
    return HT_OK;
fail:
    if (e) { free(e->key); free(e->val); free(e); }   /* free(NULL) is fine */
    return rc;
}
```

> **Why `goto`?** C has no exceptions or destructors. A single cleanup label avoids duplicated free-chains, which are the #1 source of leaks on error paths. This is endorsed by the Linux kernel style guide.

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests

- [ ] put/get/overwrite/delete; delete-missing; get-missing
- [ ] Empty key, empty value, long key (10 KB), binary value with `\0`
- [ ] Insert 10,000 keys that all collide in a tiny table (`ht_create(1)`) to test chains
- [ ] Resize preserves every entry
- [ ] Destroy on empty and on large tables

### 7.2 Differential / property test

Maintain a trivial reference model (a plain array of `(key, val)` pairs with linear search). Apply 1 million random operations to both and compare after each step:

```c
for (int i = 0; i < 1000000; i++) {
    switch (rand() % 3) {
    case 0: /* PUT random key (small keyspace → many overwrites) */ break;
    case 1: /* DELETE random key */ break;
    case 2: /* GET random key, compare with model */ break;
    }
}
```

### 7.3 Valgrind and sanitizers

```bash
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes \
         --error-exitcode=1 ./build/test_hashtable
# or simply run the ASan/UBSan build; any report fails CI
```

Verify **bytes in use returns to 0** at exit. Deliberately break `ht_destroy` to see what a leak report looks like.

### 7.4 Persistence tests

- [ ] Write 1,000 keys, quit, restart: all present
- [ ] Delete keys, restart: still deleted (tombstones replayed correctly)
- [ ] Manually corrupt one byte in the middle (`printf '\xff' | dd of=data.db bs=1 seek=100 conv=notrunc`): replay stops at the bad record without crashing
- [ ] Truncate the file mid-record (`truncate -s -5 data.db`): torn-tail recovery
- [ ] Run the `kill -9` loop; confirm data is always a **prefix** of the operation history
- [ ] Hex-dump the file (`xxd data.db | head`) and verify it matches your format spec by eye

### 7.5 Performance experiments (record in `notes.md`)

| Experiment | Question |
|-----------|---------|
| Initial buckets 16 vs 1,000,000 | How much does resizing cost? |
| `fsync` on every write vs. never | How many ops/sec in each mode? |
| Replace FNV with a bad hash (`return len`) | How does chain length affect GET latency? |
| Print max/avg chain length | Is your hash distributing well? |

---

## 8. Stretch Goals

- [ ] TTL / key expiry with a min-heap
- [ ] Replace chaining with **open addressing** (linear probing + tombstones) and compare cache behavior
- [ ] Add an **arena allocator** for entries to cut `malloc` overhead and speed up `destroy`
- [ ] Fuzz the log parser with **libFuzzer** or **AFL++**
- [ ] Add a transaction batch (`BEGIN`/`COMMIT`) written as one atomic log record
- [ ] Reader/writer lock (preview of Project 4)

## 9. Definition of Done

- [ ] Library API documented in headers (ownership, lifetime, error behavior for each function)
- [ ] 1M-key stress test passes; zero leaks; zero sanitizer errors
- [ ] Data survives clean restarts **and** `kill -9` crashes
- [ ] Corrupted/truncated logs never crash the process
- [ ] `notes.md` includes an **ownership diagram** and benchmark table

➡️ **Next:** [Project 3: BMP Parser](../03_bmp_parser/README.md)
