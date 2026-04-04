# Miles3103 — C Programming Journey 🚀

> **Goal:** Go from beginner to solid C programmer in 2 months.
> Every file in this repo is written with deep comments — not just *what* the code does, but *why* and *how* it works at a low level.

---

## 📁 Repository Structure

```
c-programming/
├── 00_Hello/           ← write() syscall, ft_putnbr without printf
├── 01_Variables/       ← types, scope, lifetime, static, XOR swap
├── 02_DataTypes/       ← sizes, limits, overflow, signed vs unsigned
├── 03_Operators/       ← arithmetic, bitwise, logical, ternary, flags
├── 04_Booleans/        ← stdbool, short-circuit evaluation
├── 05_IfElse/          ← conditions, nested, leap year
├── 06_Switch/          ← switch, fall-through, state machines
├── 07_Loops/           ← while, for, do-while, Collatz, Fibonacci
├── 08_Arrays/          ← 1D/2D, statistics, bubble sort, pointer access
├── 09_Strings/         ← ALL of string.h reimplemented from scratch
├── 10_Pointers/        ← basics, arithmetic, double ptrs, func ptrs, malloc
├── 11_Functions/       ← prototypes, recursion, pass-by-ref, ft_* functions
├── 12_Memory/          ← stack vs heap, malloc/free, memory leaks
├── 13_Projects/        ← showcase projects combining everything
└── c_exam/             ← 60-level exam system to test your knowledge
```

---

## 🗓️ 2-Month Mastery Roadmap

### WEEK 1–2: Foundations
**Goal:** Understand how C really works — no magic.

| Day | Focus | Files |
|-----|-------|-------|
| 1–2 | write() vs printf, compilation pipeline | `00_Hello/` |
| 3–4 | Variables, types, addresses, sizeof | `01_Variables/`, `02_DataTypes/` |
| 5–6 | Operators — especially bitwise and ternary | `03_Operators/` |
| 7   | Review + exam levels 0–8 | `c_exam/` |

**End of week 1–2 goal:** You can write any expression, know what every type stores, and understand what `&` and `*` mean.

---

### WEEK 3–4: Control Flow + Functions
**Goal:** Write real programs with logic and reusable functions.

| Day | Focus | Files |
|-----|-------|-------|
| 8–9  | Booleans, if/else, nested conditions | `04_Booleans/`, `05_IfElse/` |
| 10–11 | Switch, fall-through, state machines | `06_Switch/` |
| 12–13 | All loop types, break/continue | `07_Loops/` |
| 14   | Functions: prototypes, scope, recursion | `11_Functions/` |
| 15   | Exam levels 9–26 | `c_exam/` |

**End of week 3–4 goal:** You can write any algorithm. FizzBuzz, Fibonacci, Collatz, factorial — without looking anything up.

---

### WEEK 5–6: Arrays + Strings (The Hard Part)
**Goal:** Master memory layout. Implement string.h from scratch.

| Day | Focus | Files |
|-----|-------|-------|
| 16–17 | Arrays: indexing, sizeof, pointer equivalence | `08_Arrays/` |
| 18–19 | Bubble sort, 2D arrays, matrix operations | `08_Arrays/` |
| 20–21 | Strings: what they really are, null terminator | `09_Strings/` |
| 22–23 | ft_strlen, ft_strcpy, ft_strcmp, ft_atoi | `09_Strings/` |
| 24   | Exam levels 27–50 | `c_exam/` |

**End of week 5–6 goal:** You can reimplement any function from `<string.h>`. You know why `char *` and `char []` are different.

---

### WEEK 7–8: Pointers + Memory (Master Level)
**Goal:** Become dangerous with pointers. Understand the stack and heap.

| Day | Focus | Files |
|-----|-------|-------|
| 25–26 | Pointer basics, arithmetic, arrays via pointers | `10_Pointers/` |
| 27–28 | Double pointers, pointer to strings | `10_Pointers/` |
| 29–30 | Function pointers, callbacks | `10_Pointers/` |
| 31–32 | malloc/free, memory leaks, valgrind | `12_Memory/` |
| 33–34 | Structs + combining everything | `13_Projects/` |
| 35   | Exam levels 51–59 (FINAL BOSS) | `c_exam/` |

**End of week 7–8 goal:** You can use `malloc`, detect memory leaks with valgrind, write function pointer dispatch tables, and build real programs with structs.

---

## 🧠 Skills Checklist

After completing this roadmap, you should be able to:

- [ ] Explain what a pointer is and draw the memory layout
- [ ] Write `ft_strlen`, `ft_strcpy`, `ft_strcmp` without looking anything up
- [ ] Swap two values without a temporary variable (XOR swap)
- [ ] Implement bubble sort from memory
- [ ] Write a recursive factorial and Fibonacci
- [ ] Explain the difference between stack and heap
- [ ] Use `malloc` and `free` correctly without memory leaks
- [ ] Write a function pointer and use it as a callback
- [ ] Explain why `char arr[]` and `char *arr` are different as function params
- [ ] Read and understand a compiler error message
- [ ] Use `valgrind` to detect memory errors

---

## 🔧 How to Compile

```bash
# Basic compilation
gcc -Wall -Wextra -Werror filename.c -o output

# With math library (for sqrt, etc.)
gcc -Wall -Wextra -Werror filename.c -o output -lm

# Run valgrind to check for memory leaks
valgrind --leak-check=full ./output

# Check all files in a folder
for f in *.c; do gcc -Wall -Wextra -Werror "$f" -o test && echo "$f: OK" && rm test; done
```

---

## 📚 Resources

- **K&R** — *The C Programming Language* (2nd Ed.) — already in this repo
- **man pages** — `man 3 strlen`, `man 2 write`, `man 3 malloc`
- **42 Norm** — use as style guide even if not at 42
- **cs50.harvard.edu** — free, excellent C course
- **beej.us/guide/bgc** — Beej's Guide to C — best free online C book

---

## 🏆 Exam System

The `c_exam/` folder contains a 60-level self-grading exam.
```bash
cd c_exam
chmod +x miles3103_exam.sh
./miles3103_exam.sh
```

Complete all 60 levels = you know C.

---

*"The only way to learn a new programming language is by writing programs in it."*
*— Brian Kernighan, co-author of C*
