# Lesson 7: Pointers, Arrays & `const`

**Time:** ~5 h | **Prev:** [Lesson 6](../06_pointers/README.md) | **Next:** [Lesson 8](../08_structs_enums_unions/README.md)
**File:** [`ptrarith.c`](ptrarith.c)

## You will be able to
- explain why `a[i]` and `*(a + i)` are the same thing
- do pointer arithmetic and pointer subtraction
- read `const` declarations, and use function pointers and `void *`

---

## 1. Concept: arrays and pointers are close cousins

An array name, in most expressions, **becomes a pointer to its first element**. And indexing is defined in terms of pointer arithmetic:

```c
a[i]   ≡   *(a + i)
```

### Pointer arithmetic is scaled by the element size
If `p` is an `int *` and an `int` is 4 bytes, then `p + 1` is **4 bytes** further on, not 1. The compiler multiplies by `sizeof(*p)` for you.

```text
int a[4];           a        a+1      a+2      a+3
                  [ 10 ]   [ 20 ]   [ 30 ]   [ 40 ]
                  0x1000   0x1004   0x1008   0x100C
```

| Expression | Meaning |
|---|---|
| `p + n` / `p - n` | move *n elements* forward/back |
| `p++` | advance to the next element |
| `p2 - p1` | **number of elements** between two pointers (type `ptrdiff_t`, print with `%td`) |
| `p1 < p2` | compare positions (only meaningful inside the same array) |

Rules: only form pointers **inside** an array (or one past its end). Going further is undefined behavior, even if you don't dereference.

### Walking a string with a pointer
```c
size_t my_strlen(const char *s) {
    const char *p = s;
    while (*p) p++;          /* stop at '\0' (zero = false) */
    return (size_t)(p - s);  /* elements between the two pointers */
}
```
This is the idiom behind much of the C standard library. Practise reading it until it feels natural.

### `const`: promises the compiler enforces
Read declarations **right to left**:

| Declaration | Reads as | You can't… | You can… |
|---|---|---|---|
| `const char *p` | p is a pointer to const char | change `*p` | repoint `p` |
| `char *const p` | p is a const pointer to char | repoint `p` | change `*p` |
| `const char *const p` | const pointer to const char | either | neither |

**Why use `const` everywhere you can?** It documents intent ("this function only reads your data"), lets the compiler catch accidental writes, and places literals in read-only memory. Use `const` on pointer parameters that you only read.

### `void *`: a pointer to "something"
`void *` holds any object address, but you can't dereference it or do arithmetic on it without casting to a concrete type. It's how generic code works in C: `memcpy(void *dst, const void *src, size_t n)` or `qsort`.

### Function pointers: store and pass code
```c
int (*f)(int);          /* f is a pointer to a function taking int, returning int */
f = twice;              /* function names decay to their address */
int r = f(7);           /* call through the pointer */
```
`qsort(array, count, element_size, compare)` takes a **comparator** function pointer, making one sort work for any type. You'll use function pointers for the REPL command table (Project 2).

The comparator returns negative / zero / positive. Writing `return (x > y) - (x < y);` is safer than `return x - y;`, which can overflow.

## 2. Run it
```bash
make && ./bin/ptrarith
```

## 3. Common mistakes
- **Arithmetic on `void *`** (a GNU extension, not standard C). Cast to `char *` / `uint8_t *` for byte math.
- **Reading one past the end** while walking with a pointer: check your loop condition.
- **Comparator overflow:** `return a - b;` with big ints.
- **Casting away `const`** to "make the warning go away". Instead, fix the declaration.
- Mixing up `p++` (move the pointer) and `(*p)++` (increment the value it points to).
- Subtracting pointers from *different* arrays: undefined.

## 4. Exercises
- [ ] **E1.** Rewrite `sum(const int *a, size_t n)` using a moving pointer instead of an index (`for (const int *p = a; p < a + n; p++)`).
- [ ] **E2.** Implement `my_strcmp`, `my_strchr` (returns pointer to the first match or NULL), and `my_memcpy` using pointers only.
- [ ] **E3.** Write `void reverse_bytes(void *data, size_t n)` that reverses any block of memory in place. Use it on an `int` and on a string.
- [ ] **E4.** Sort an array of strings (`const char *names[]`) with `qsort`. Hint: the comparator receives `const char **`, a pointer to an array *element*.
- [ ] **E5.** Make a table of function pointers `{"add", add}, {"sub", sub}, ...` and look up an operation by name, as the Project 2 command table will.
- [ ] **E6.** Predict which lines fail to compile, then try them: `const char *p = "a"; *p = 'b';`, `char *const q = buf; q = other;`, `const int x = 1; int *y = &x;`.
- [ ] **E7 (stretch).** Print the 8 bytes of a `double` using `unsigned char *`. Why is accessing any object through an `unsigned char *` always allowed?

## 5. Self-check
<details><summary>Questions</summary>

1. What does `p + 3` mean if `p` is an `int *`?
2. What's the difference between `const char *p` and `char *const p`?
3. What does subtracting two pointers return?
4. Why is `void *` useful and what can't you do with it?

**Answers:** (1) The address 3 `int`s (12 bytes) past `p`. (2) The first forbids changing the pointed-to char; the second forbids changing the pointer. (3) The count of *elements* between them, as a `ptrdiff_t`. (4) It holds any address for generic code; you can't dereference it or do arithmetic until you cast to a real type.
</details>

## 6. Where this shows up later
- **Project 1:** the pointer-walking substring search in `match.c`.
- **Project 3:** `uint8_t *` byte decoding of headers.
- **Project 5:** all block navigation (`(uint8_t *)b + HDR_SIZE`) is this lesson.
