# Lesson 5: Arrays & Strings

**Time:** ~4 h | **Prev:** [Lesson 4](../04_functions_and_scope/README.md) | **Next:** [Lesson 6: Pointers](../06_pointers/README.md)
**Files:** [`arrays.c`](arrays.c), [`strings.c`](strings.c)

## You will be able to
- explain how an array sits in memory and why C never checks its bounds
- explain what a C string is (a `'\0'`-terminated `char` array) and compute buffer sizes correctly
- avoid the classic overflow bugs with `strcpy` / `gets` and use `snprintf` safely

---

## 1. Concept: an array is N identical items side by side in memory

```c
int nums[6] = {4, 8, 15, 16, 23, 42};
```
```text
address:  1000  1004  1008  1012  1016  1020
value:     [4]   [8]  [15]  [16]  [23]  [42]
index:      0     1     2     3     4     5
```
`nums[i]` is found by arithmetic: `start + i * sizeof(int)`. That's why indexing is so fast, and also why **C does not check bounds**: `nums[6]` or `nums[-1]` just reads whatever is next to the array. That is **undefined behavior**, and the root of most security holes in C code.

### Facts to memorise
- Valid indexes are `0` to `n - 1`. (An array of 5 has no `a[5]`.)
- `sizeof nums / sizeof nums[0]` gives the element count, but **only where the array was declared**.
- **Decay:** when you pass an array to a function, it turns into a pointer to the first element. The length is lost, so **always pass the length as a separate `size_t` parameter**. The example proves it: `sizeof` is 24 in `main` and 8 inside the function.
- `int a[5] = {0};` zero-fills everything. An uninitialized local array contains garbage.
- A 2D array `grid[2][3]` is **one flat block**, stored row after row. Rows are contiguous.

### Strings: just a char array that ends in `'\0'`
C has no string type. A "string" is an array of `char` whose last element is the byte `0` (the **NUL terminator**). All string functions (`strlen`, `printf("%s")`, `strcmp`) walk until they find that `0`.

```text
char word[] = "hello";     6 bytes:   h   e   l   l   o  \0
                                     104 101 108 108 111  0
```
- `strlen(word)` = 5 (counts up to, not including, the `'\0'`). `sizeof(word)` = 6 (the whole array).
- **Always allocate length + 1** for the terminator.
- If the terminator is missing, functions run off the end of your buffer into other memory.

#### `char s[] = "hi"` vs `const char *s = "hi"`
| | `char s[] = "hi";` | `const char *s = "hi";` |
|---|---|---|
| What it is | an array holding a **copy** | a pointer to a **string literal** in read-only memory |
| Can you modify the text? | Yes | **No** (crashes) |
| `sizeof` | 3 | 8 (pointer size) |

Always declare literal pointers as `const char *` so the compiler stops you writing to them.

### The dangerous functions, and the safe ones
| Dangerous | Why | Use instead |
|---|---|---|
| `gets()` | cannot limit input; removed from C11 | `fgets` / `getline` |
| `strcpy(dst, src)` | no length check; overflows `dst` | `snprintf(dst, sizeof dst, "%s", src)` |
| `strcat` | same | `snprintf` into the right offset |
| `strncpy` | may **not** add the `'\0'` | `snprintf`, or `memcpy` + manual terminator |
| `sprintf` | no limit | `snprintf` |

`snprintf` returns how many characters it **wanted** to write. If that is `>= sizeof buffer`, the output was truncated. The example shows this. The compiler even warns about it, and we silenced the warning with a `#pragma` only because truncation is the demo.

## 2. Run it
```bash
make && ./bin/arrays && ./bin/strings
```
Predict: what does `sizeof(word)` print for `char word[] = "hello"`?

## 3. Common mistakes
- **Off-by-one:** `for (i = 0; i <= n; i++)` writes `a[n]`. Use `<`.
- **No room for `'\0'`:** `char s[5] = "hello";` has no terminator.
- **Comparing strings with `==`:** that compares *addresses*. Use `strcmp(a, b) == 0`.
- **Modifying a string literal:** `char *s = "abc"; s[0] = 'X';` crashes. Use `char s[] = "abc";` or a `const char *`.
- **`sizeof` on a parameter:** it's the pointer's size, not the array's.
- **Returning a local array** from a function (it vanishes on return).

## 4. Exercises
- [ ] **E1.** Write `int max_of(const int *a, size_t n)`, `double average(const int *a, size_t n)` (watch integer division!) and `void reverse(int *a, size_t n)`.
- [ ] **E2.** Write your own `my_strlen`, `my_strcmp`, and `my_strcat` (the last taking the buffer capacity and refusing to overflow).
- [ ] **E3.** Write `int is_palindrome(const char *s)`. Test "racecar", "abba", "abc", "" (empty!), and a single character.
- [ ] **E4.** Count the words in a string (split on spaces, handle repeated spaces and leading/trailing spaces).
- [ ] **E5.** Read a line with `fgets(buf, sizeof buf, stdin)`. Remove the trailing newline safely (hint: `strcspn(buf, "\n")`). What if the line is longer than the buffer?
- [ ] **E6.** On purpose, write past the end of a local array and compile with `-fsanitize=address`. Read the report and find the line number it points to.
- [ ] **E7 (stretch).** Implement Caesar cipher encryption/decryption on a string. (This is a mini version of the "file cryptor" idea.)

## 5. Self-check
<details><summary>Questions</summary>

1. What does a C string end with, and how many bytes does `"abc"` occupy?
2. Why does `sizeof(arr)` inside a function give 8?
3. Why is `if (s1 == s2)` wrong for comparing strings?
4. What does `snprintf` return, and how do you detect truncation?

**Answers:** (1) The byte `'\0'`; 4 bytes. (2) The array decayed into a pointer, and `sizeof` of a pointer is 8 on 64-bit. (3) It compares addresses, not contents; use `strcmp`. (4) The length it *would* have written; truncation happened if it's `>= buffer size`.
</details>

## 6. Where this shows up later
- **Project 1:** every line you search is a `char` buffer; `strstr` and your own case-insensitive search walk until `'\0'`.
- **Project 4:** HTTP parsing in a fixed buffer, where bounds discipline is a security issue.
