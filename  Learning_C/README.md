# Miles3103 — C Programming Journey 🚀

> **Goal:** Go from beginner to solid C programmer in 2 months.
> Every file in this repo is written with deep comments — not just *what* the code does, but *why* and *how* it works at a low level.

---

## 📁 Repository Structure

```
Learning_C/
├── 00_Hello/           ← write() syscall, printf, puts — three ways to print
├── 01_Variables/       ← types, scope, lifetime, static, XOR swap
├── 02_DataTypes/       ← sizes, limits, overflow, signed vs unsigned
├── 03_Operators/       ← arithmetic, bitwise, logical, ternary, bit flags
├── 04_Conditionals/    ← if/else, switch, ternary, guard clauses
├── 05_Functions_Intro/ ← syntax, prototypes, return values, void functions
├── 06_Scope/           ← local, global, static, block scope, shadowing
├── 07_Loops/           ← while, for, do-while, Collatz, Fibonacci, primes
├── 08_Arrays/          ← 1D/2D, statistics, bubble sort, pointer equivalence
├── 09_Strings/         ← ALL of string.h reimplemented from scratch
├── 10_Pointers/        ← basics, arithmetic, double ptrs, func ptrs, malloc
├── 11_Functions/       ← prototypes, recursion, pass-by-ref, ft_* functions
├── 12_Memory/          ← stack vs heap, malloc/free, ft_strdup, valgrind
├── 13_Projects/        ← showcase projects combining everything
├── c_exam/             ← 60-level self-grading exam system
├── Learning_c_by_typing/ ← hands-on exercises and scratch files
├── Games_c/            ← snake, random walk — real programs in C
└── C_books/            ← K&R, Modern C, Beej's Guide, and more
```

---

## 🗓️ 2-Month Mastery Roadmap

### WEEK 1–2: Foundations
**Goal:** Understand how C really works — no magic.

| Day | Focus | Files |
|-----|-------|-------|
| 1–2 | write() vs printf vs puts, compilation pipeline | `00_Hello/` |
| 3–4 | Variables, types, addresses, sizeof | `01_Variables/`, `02_DataTypes/` |
| 5–6 | Operators — especially bitwise and ternary | `03_Operators/` |
| 7   | Review + exam levels 0–8 | `c_exam/` |

**End of week 1–2 goal:** You can write any expression, know what every type stores, and understand what `&` and `*` mean.

---

### WEEK 3–4: Control Flow + Functions
**Goal:** Write real programs with logic and reusable functions.

| Day | Focus | Files |
|-----|-------|-------|
| 8–9   | if/else, switch, guard clauses, ternary | `04_Conditionals/` |
| 10–11 | Function syntax, prototypes, return values, void | `05_Functions_Intro/` |
| 12–13 | Scope: local, global, static, shadowing | `06_Scope/` |
| 14    | All loop types, break/continue, Collatz | `07_Loops/` |
| 15    | Exam levels 9–26 | `c_exam/` |

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
| 24    | Exam levels 27–50 | `c_exam/` |

**End of week 5–6 goal:** You can reimplement any function from `<string.h>`. You know why `char *` and `char []` are different.

---

### WEEK 7–8: Pointers + Memory (Master Level)
**Goal:** Become dangerous with pointers. Understand the stack and heap.

| Day | Focus | Files |
|-----|-------|-------|
| 25–26 | Pointer basics, arithmetic, arrays via pointers | `10_Pointers/` |
| 27–28 | Double pointers, pointer to strings | `10_Pointers/` |
| 29–30 | Function pointers, callbacks, dispatch tables | `10_Pointers/` |
| 31–32 | malloc/free, ft_strdup, memory leaks, valgrind | `12_Memory/` |
| 33–34 | Recursion, pass-by-ref, ft_* functions deep dive | `11_Functions/` |
| 35    | Structs + combining everything into a real project | `13_Projects/` |
| 36    | Exam levels 51–59 (FINAL BOSS) | `c_exam/` |

**End of week 7–8 goal:** You can use `malloc`, detect memory leaks with valgrind, write function pointer dispatch tables, and build real programs with structs.

---

## 🧠 Skills Checklist

After completing this roadmap, you should be able to:

- [ ] Explain what a pointer is and draw the memory layout on paper
- [ ] Write `ft_strlen`, `ft_strcpy`, `ft_strcmp` without looking anything up
- [ ] Swap two values without a temporary variable (XOR swap)
- [ ] Implement bubble sort from memory
- [ ] Write a recursive factorial and Fibonacci
- [ ] Explain the difference between stack and heap
- [ ] Use `malloc` and `free` correctly without memory leaks
- [ ] Write a function pointer and use it as a callback
- [ ] Explain why `char arr[]` and `char *arr` behave differently as function params
- [ ] Read and understand a compiler error message
- [ ] Use `valgrind` to detect memory errors

---

## 🔧 How to Compile

```bash
# Basic compilation
gcc -Wall -Wextra -Werror filename.c -o output

# With math library (for sqrt, pow, etc.)
gcc -Wall -Wextra -Werror filename.c -o output -lm

# Run valgrind to check for memory leaks
valgrind --leak-check=full ./output

# Compile and test all .c files in a folder
for f in *.c; do gcc -Wall -Wextra -Werror "$f" -o test && echo "$f: OK" && rm test; done
```

---

## 📚 Resources

- **K&R** — *The C Programming Language* (2nd Ed.) — already in `C_books/`
- **Modern C** — Jens Gustedt — already in `C_books/`
- **Beej's Guide** — beej.us/guide/bgc — best free online C book (also in `C_books/`)
- **man pages** — `man 3 strlen`, `man 2 write`, `man 3 malloc`
- **42 Norm** — use as a style guide even if not at 42
- **cs50.harvard.edu** — free, excellent C course

---

## 🏆 Exam System

The `c_exam/` folder contains a 60-level self-grading exam system built from scratch.

```bash
cd c_exam
chmod +x miles3103_v14.sh
./miles3103_v14.sh
```

Complete all 60 levels = you know C.

---

*"The only way to learn a new programming language is by writing programs in it."*
*— Brian Kernighan, co-author of C*
