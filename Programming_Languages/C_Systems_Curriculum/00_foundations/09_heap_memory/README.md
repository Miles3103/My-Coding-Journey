# Lesson 9: The Heap (malloc & free)

**Time:** ~5 h | **Prev:** [Lesson 8](../08_structs_enums_unions/README.md) | **Next:** [Lesson 10](../10_files_and_args/README.md)
**Files:** [`heap.c`](heap.c) and the broken demos [`leak_bug.c`](leak_bug.c), [`uaf_bug.c`](uaf_bug.c), [`overflow_bug.c`](overflow_bug.c), [`double_free_bug.c`](double_free_bug.c)

## You will be able to
- decide between stack and heap memory, and say **who owns** each block
- use `malloc`, `calloc`, `realloc` and `free` safely
- recognise leaks, use-after-free, double-free and overflows, and catch them with AddressSanitizer and valgrind

---

## 1. Concept: two places to keep data

| | **Stack** | **Heap** |
|---|---|---|
| Allocated by | the compiler, automatically | **you**, with `malloc` |
| Freed | automatically on return | **you**, with `free` |
| Size limit | small (~8 MB) | huge (limited by RAM) |
| Speed | very fast | slower (the allocator does work) |
| Lifetime | until the function returns | until you free it |
| Typical use | small, short-lived locals | data of unknown size, data that outlives a function |

Use the heap when (a) you don't know the size until runtime, (b) it's too big for the stack, or (c) it must survive after the function that made it returns.

### The four functions
```c
void *malloc(size_t n);              /* n uninitialized bytes, or NULL */
void *calloc(size_t count, size_t size);  /* zero-filled; checks count*size overflow */
void *realloc(void *p, size_t n);    /* resize; may MOVE the block; returns the new address */
void  free(void *p);                 /* give it back; free(NULL) is safe */
```

### The idioms (memorise these)
```c
int *a = malloc(n * sizeof *a);      /* sizeof *a stays right if the type changes */
if (!a) { /* handle out-of-memory: malloc CAN fail */ }
/* ... use a[0] .. a[n-1] ... */
free(a);
a = NULL;                            /* so later misuse fails loudly, not mysteriously */
```
- **No cast needed in C.** (`int *a = malloc(...)` is fine; casting only hides errors.)
- **Always check for `NULL`.**
- **`realloc` safely:** `tmp = realloc(p, n); if (!tmp) { /* p is STILL valid */ } else p = tmp;`. Writing `p = realloc(p, n)` leaks the old block if it fails.
- **Overflow:** `n * sizeof *a` can overflow for huge `n`. `calloc(n, size)` checks this for you.

### Ownership: the discipline that keeps C programs correct
Every heap block must have **exactly one owner** responsible for freeing it. Write it down in comments:
- "Returns heap memory; **caller must free**." (`dup_string` in the example)
- "The vector **owns** `data`; `vec_free` releases it."
- "Returns a **borrowed** pointer valid until the next modification."

When you can't say who frees something, you've found your bug.

### The dynamic array (the most useful pattern in C)
`heap.c` implements `IntVec`: `data`, `len`, `cap`. When full it **doubles** the capacity via `realloc`. Doubling makes pushes **amortized O(1)**. Growing by a fixed +10 each time would make *n* pushes O(n²). You'll reuse this pattern in Projects 2 and 4.

## 2. The four classic heap bugs (run them!)
```bash
make bugs
./bin/leak_bug          # memory leak
./bin/uaf_bug           # use after free
./bin/overflow_bug      # heap buffer overflow
./bin/double_free_bug   # double free
```
| Bug | What AddressSanitizer says | Cause |
|---|---|---|
| **Leak** | `LeakSanitizer: detected memory leaks`, with the allocation site | Lost the only pointer before `free` |
| **Use after free** | `heap-use-after-free`, with the line of the bad read **and** where it was freed | Using memory after `free` |
| **Heap buffer overflow** | `heap-buffer-overflow … WRITE of size 4` | Wrote past the end (off-by-one) |
| **Double free** | `attempting double-free` | Freed the same pointer twice |

**Read each report top to bottom.** The first frame shows *where the bad access happened*; the "freed by" and "allocated by" stacks show *how it got there*. That is the whole debugging story in one output.

### Valgrind (the alternative, no recompiling)
```bash
gcc -g -O0 -o leak leak_bug.c           # no sanitizer flags
valgrind --leak-check=full --show-leak-kinds=all ./leak
```
Look for `definitely lost`, `Invalid read/write`, `Invalid free`. Aim for: `All heap blocks were freed -- no leaks are possible` and `0 errors`. Valgrind is slower (~20×) but also catches *uninitialized reads* (Lesson 12), which ASan does not.

> **Don't use both at once.** Build with `-fsanitize=address` **or** run under valgrind, not both.

## 3. Common mistakes
- **Forgetting to free** (leaks) or **freeing twice.**
- **Using memory after free.**
- **`sizeof(ptr)` instead of `sizeof(*ptr)`:** `malloc(sizeof p)` allocates 8 bytes, not an int array.
- **Not allocating room for the `'\0'`:** `malloc(strlen(s))` is one byte too small. Use `strlen(s) + 1`.
- **Assuming `malloc` zeros memory.** It doesn't. Use `calloc` or `memset`.
- **`free`-ing a pointer that wasn't `malloc`'d** (a stack address or a pointer into the middle of a block).
- **Losing the pointer**: `p = p + 1` then `free(p)` frees the wrong address.
- **Leaking on error paths:** the second `malloc` fails and you return without freeing the first. Use the `goto cleanup` idiom (Project 2).

## 4. Exercises
- [ ] **E1.** Write `int *make_range(int n)` returning a heap array `0..n-1`. In `main`, use it, then free it. Document who owns the memory in a comment above the function.
- [ ] **E2.** Write `char *join(const char *a, const char *b)` that returns a newly allocated concatenation. Check every `malloc`. Test with empty strings.
- [ ] **E3.** Add `vec_pop`, `vec_get` (with bounds check), and `vec_insert(v, index, value)` to `IntVec`. Test each with ASan on.
- [ ] **E4.** Fix each of the four `*_bug.c` files, run again, and confirm a clean exit.
- [ ] **E5.** Build a singly linked list on the heap: `push_front`, `push_back`, `remove_value`, `free_list`. Run under ASan with 1,000 random operations. *(Use the pointer-to-pointer idiom: `Node **link`.)*
- [ ] **E6.** Write a function that fails halfway (the second allocation fails, simulated with a counter) and make it clean up the first with `goto cleanup`.
- [ ] **E7 (stretch).** Wrap `malloc` and `free` in your own counting wrappers, printing "N allocations, M frees" at exit. A leak shows as N ≠ M. *(A preview of Project 5.)*

## 5. Self-check
<details><summary>Questions</summary>

1. Why write `p = NULL;` after `free(p)`?
2. What's wrong with `buf = realloc(buf, n)`?
3. Why does the vector double its capacity instead of adding a constant?
4. Which tool catches an *uninitialized read*, ASan or valgrind?

**Answers:** (1) A later use then crashes immediately and obviously, instead of silently corrupting memory; `free(NULL)` is also harmless. (2) If `realloc` fails it returns NULL and you overwrote your only pointer to the old block, leaking it. (3) Doubling makes appends amortized O(1); a constant increment makes it O(n²). (4) Valgrind (or MemorySanitizer in clang).
</details>

## 6. Where this shows up later
- **Project 2:** the hash table owns every key, value and entry, and `destroy` must free them all.
- **Project 3:** the pixel buffer; overflow-checked `width * height * 3`.
- **Project 5:** you write `malloc` itself and see what's *under* these calls.
