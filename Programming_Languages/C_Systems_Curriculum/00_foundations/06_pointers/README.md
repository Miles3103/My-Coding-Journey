# Lesson 6: Pointers

**Time:** ~5 h (take your time here; it's the heart of C) | **Prev:** [Lesson 5](../05_arrays_and_strings/README.md) | **Next:** [Lesson 7](../07_pointers_arrays_const/README.md)
**File:** [`pointers.c`](pointers.c)

## You will be able to
- say what a pointer is, using `&` and `*` correctly
- write functions that modify their caller's variables (out-parameters)
- recognise `NULL`, dangling and wild pointers, and know why they crash

---

## 1. Concept: a pointer is a variable that stores an address

Memory is a giant row of numbered boxes (bytes). Every variable lives at some address. A **pointer** is just a variable whose value is one of those addresses.

> Think of a house and its street address. The house is the variable; the address written on a piece of paper is the pointer. You can hand someone the paper (cheap), and they can walk to the house and repaint it.

```c
int x = 42;
int *p = &x;     /* p holds the address of x */
```
```text
        x                    p
 address 0x1000        address 0x2000
 ┌────────┐            ┌────────────┐
 │   42   │ ◄───────── │   0x1000   │
 └────────┘            └────────────┘
```

Two operators to learn:
| Operator | Name | Meaning | Example |
|---|---|---|---|
| `&` | address-of | "where does this variable live?" | `&x` → `0x1000` |
| `*` | dereference | "go to that address and use what's there" | `*p` → `42`; `*p = 99;` changes `x` |

**Reading declarations:** `int *p` means "`*p` is an `int`", so `p` is a pointer to int. The `*` in a declaration and the `*` in an expression are different jobs that happen to share a symbol.

**The pointer's size** doesn't depend on what it points to: 8 bytes on a 64-bit machine, for every pointer type. The *type* tells the compiler what to do when you dereference (read 4 bytes as an `int`, 1 byte as a `char`…).

### Why pointers exist
1. **Modify caller variables.** C passes by value (Lesson 4), so to let a function change something you pass its address:
```c
void swap(int *a, int *b) { int t = *a; *a = *b; *b = t; }
swap(&x, &y);
```
2. **Return multiple results** through "out-parameters" (`divide(17, 5, &q, &r)` in the example).
3. **Avoid copying big data.** Pass a pointer to a 1 MB struct instead of a copy.
4. **Reach heap memory** (Lesson 9) and build linked data structures (Project 2).

### `NULL`: "points at nothing"
`NULL` is a special pointer value meaning "no object". Use it to signal "not found" or "no value". **Dereferencing NULL crashes** (segmentation fault), which is actually the *good* outcome, because a loud crash beats silent corruption. Always check before you dereference anything that might be NULL.

### The three ways pointers go wrong
| Bug | Cause | Symptom |
|---|---|---|
| **NULL pointer** | dereferencing `NULL` | immediate segfault |
| **Wild pointer** | using an uninitialized pointer | random crash or corruption. **Always initialize: `int *p = NULL;`** |
| **Dangling pointer** | pointing to memory that no longer exists (a returned local, a freed block) | works "by luck", then fails mysteriously |

### Pointer to pointer
`int **pp = &p;` holds the address *of the pointer*. `**pp` is the `int`. You'll use this to let a function change *which thing a pointer points at* (for example, `getline(&line, &cap, fp)` updates your `line` pointer).

## 2. Run it
```bash
make && ./bin/pointers
```
**Predict before running:** after `*p = 99`, what does `x` hold? After `**pp = 7`?

### Draw it
On paper, draw boxes for `x`, `p`, `a`, `b`, `q`, `r`, `pp` with their values at each step. **Do this once**, and it will click.

## 3. Common mistakes
- **Using `*` vs `&` backwards.** `p = x` (an int into a pointer) is a warning; `p = &x` is right.
- **`int *a, b;`** declares one pointer `a` and one plain `int` `b`. Write one declaration per line.
- **Returning `&local`.** Dangling pointer (Lesson 4).
- **Not initializing pointers** (`int *p; *p = 5;`).
- **Printing a pointer with `%d`.** Use `%p` and cast to `(void *)`.
- **Dereferencing without a NULL check** on any function that can fail.

## 4. Exercises
- [ ] **E1.** Write `void swap(int *a, int *b)` yourself, then use it to swap two doubles using a second function (`swap_double`). Notice you can't reuse one function. *(Lesson 7 shows `void *`.)*
- [ ] **E2.** Write `int min_max(const int *a, size_t n, int *min, int *max)` returning `-1` for `n == 0`. Test it with `n = 0`.
- [ ] **E3.** Write `void to_upper(char *s)` that uppercases a string in place (cast to `unsigned char` for `toupper`).
- [ ] **E4.** Write `void set_to_zero(int **pp)` which makes the caller's pointer `NULL` after you "free" something. This is the idiom behind `free_and_null`.
- [ ] **E5.** On paper, trace `int a=1, *p=&a, **q=&p; **q = 5; *q = NULL;` and say what `a`, `p`, `*p` are after each statement.
- [ ] **E6.** Write a bug on purpose: a function that returns a pointer to its local `int`, then print through that pointer. Compile with `-Wall -Wextra` and read the warning (`address of local variable returned`). Run it and notice the output may look "fine", which is exactly why dangling pointers are dangerous.
- [ ] **E7.** Dereference a NULL pointer on purpose and run it under `gdb` (`run`, `bt`) to see where it died. *(Lesson 12 explains gdb.)*

## 5. Self-check
<details><summary>Questions</summary>

1. What are `&x` and `*p`?
2. Why does `swap(int a, int b)` fail but `swap(int *a, int *b)` work?
3. What's the difference between a NULL pointer and a dangling pointer?
4. How big is a pointer, and does it depend on what it points to?

**Answers:** (1) The address of `x`; the object that `p` points to. (2) The first receives copies; the second receives the addresses of the originals. (3) NULL is a deliberate "nothing"; dangling means it points to memory that's no longer valid. (4) 8 bytes on 64-bit; no, always the same size.
</details>

## 6. Where this shows up later
- **Everything.** `getline(&line, &cap, fp)` (Project 1), linked-list `Entry **link` deletion (Project 2), `Slice` pointers (Project 4), `header_of(void *p)` (Project 5).
