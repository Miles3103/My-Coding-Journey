# Lesson 8: Structs, Enums & Unions

**Time:** ~3 h | **Prev:** [Lesson 7](../07_pointers_arrays_const/README.md) | **Next:** [Lesson 9: The heap](../09_heap_memory/README.md)
**File:** [`structs.c`](structs.c)

## You will be able to
- group related data with `struct` and use `typedef` to simplify names
- explain **padding** and **alignment** and predict a struct's size
- use `enum` for named constants and `union` to view the same memory two ways

---

## 1. Concept: a struct is a bundle of named fields

```c
typedef struct { double x, y; } Point;
Point p = { .x = 1.0, .y = 2.0 };    /* designated initializers: clear and order-independent */
p.x = 5;                              /* '.' for a variable */
Point *q = &p;
q->x = 5;                             /* '->' for a pointer; same as (*q).x */
```

Structs are values: assigning one copies **every field**. When you pass a struct to a function, the whole thing is copied (Lesson 4), so for anything bigger than a few bytes, pass a pointer, and `const Point *` if the function only reads.

### Padding and alignment: why `sizeof` surprises you
CPUs read memory fastest when a 4-byte `int` sits at an address divisible by 4 (**alignment**). So the compiler inserts invisible **padding** bytes.

```text
struct { char a; int b; char c; }          struct { int b; char a; char c; }
offset 0: a   [1 byte]                     offset 0: b   [4 bytes]
offset 1-3:   [3 bytes PADDING]            offset 4: a   [1 byte]
offset 4: b   [4 bytes]                    offset 5: c   [1 byte]
offset 8: c   [1 byte]                     offset 6-7:   [2 bytes PADDING]
offset 9-11:  [3 bytes PADDING]            total = 8 bytes
total = 12 bytes
```
Same data, 12 vs 8 bytes. **Rule of thumb: order fields from largest to smallest.** Use `offsetof(Type, field)` from `<stddef.h>` to see the layout (the example prints it).

**Why this matters:** you can't write a struct to a file with `fwrite` and expect it to be portable. Padding and endianness differ between machines and compilers. For file formats (Projects 2, 3) read and write fields one by one.

### `typedef`
`typedef struct {...} Point;` lets you write `Point` instead of `struct Point`. For types that refer to themselves (linked lists), give the struct a name too: `typedef struct Node { int v; struct Node *next; } Node;`.

### `enum`: named integer constants
```c
typedef enum { RED, GREEN, BLUE } Color;     /* 0, 1, 2 */
```
Better than magic numbers like `if (c == 2)`. A `switch` on an enum makes the compiler warn if you miss a case.

### `union`: one slot of memory, several interpretations
All members **share the same memory**; its size is the largest member. Writing one and reading another reinterprets the bytes. The example stores `0x01020304` in a `uint32_t` and reads the bytes, which reveals your machine's **endianness** (little-endian prints `4 3 2 1`). Unions show up in tagged variants (a type field plus a union of payloads), protocol parsers and interpreters.

### Arrays of structs and `qsort`
Sorting people by age takes a comparator that casts the `void *` arguments to `const Person *`. The example does exactly this.

## 2. Run it
```bash
make && ./bin/structs
```
Predict `sizeof(Wasteful)` and `sizeof(Reordered)` before you look.

## 3. Common mistakes
- **Comparing structs with `==`**: not allowed. Compare field by field (padding bytes make `memcmp` unreliable too).
- **Assuming `sizeof(struct)` = sum of its fields.**
- **Writing a struct to disk with `fwrite`** and expecting it to be portable.
- **Forgetting `->` vs `.`**: use `.` on a struct, `->` on a pointer to one.
- **Returning a pointer to a local struct.** (Dangling, as in Lesson 4.)
- **Switching over an enum without handling all values**: enable `-Wswitch`, which is on in `-Wall`.

## 4. Exercises
- [ ] **E1.** Define `typedef struct { char name[32]; int age; double gpa; } Student;`, make an array of 5, fill it, print it, and sort it by GPA (descending) with `qsort`.
- [ ] **E2.** Write `Point midpoint(Point a, Point b)` (pass/return by value) and `void scale(Point *p, double k)` (by pointer). When is each style better?
- [ ] **E3.** Predict `sizeof` of: `{char,char,int}`, `{char,double,char}`, `{double,char,char}`. Check with `sizeof` and `offsetof`, then reorder to minimise padding.
- [ ] **E4.** Write an `enum Day { MON, TUE, ... }` and a function `const char *day_name(enum Day d)` with a `switch`. Remove one case and read the warning.
- [ ] **E5.** Build a singly linked list node `typedef struct Node {...} Node;` and print a 3-node list built from **stack** variables (heap comes in Lesson 9).
- [ ] **E6.** Using a `union`, print the bits of a `float` as a `uint32_t`. Identify the sign, exponent and mantissa fields.
- [ ] **E7 (stretch).** Create a "tagged union": `struct Value { enum {INT, DOUBLE, STR} kind; union { int i; double d; const char *s; } as; };` and a `print_value` function.

## 5. Self-check
<details><summary>Questions</summary>

1. Why can `struct { char; int; char; }` be bigger than 6 bytes?
2. When do you use `.` and when `->`?
3. What do all members of a `union` share?
4. Why shouldn't you `fwrite` a whole struct to a file meant for other machines?

**Answers:** (1) Alignment padding inserted by the compiler. (2) `.` for a struct value, `->` for a pointer to a struct. (3) The same memory; its size is the largest member's. (4) Padding, alignment and byte order differ between systems, so the bytes aren't portable.
</details>

## 6. Where this shows up later
- **Project 1:** the `Options` struct groups all the flags.
- **Project 2:** `Entry` nodes, the `HashTable` struct, and opaque types.
- **Project 3:** the packed BMP header structs and the `_Static_assert` on their sizes.
- **Project 5:** the `Block` header struct, whose size must be a multiple of 16.
