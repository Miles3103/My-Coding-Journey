<div align="center">

# My Coding Journey

**C · C++ · Python — built from the ground up**

[![Language](https://img.shields.io/badge/primary-C-00599C?style=flat&logo=c&logoColor=white)]()
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat)]()
[![Exam](https://img.shields.io/badge/exam-60%20levels-blueviolet?style=flat)]()
[![42 Style](https://img.shields.io/badge/style-42%20Norm-black?style=flat)]()
[![Piscine](https://img.shields.io/badge/piscine-reloaded-orange?style=flat)]()
[![Libft](https://img.shields.io/badge/libft-43%20functions-informational?style=flat)]()
[![Piscine 2026](https://img.shields.io/badge/C%20Piscine-2026-yellow?style=flat)]()

> Every file in this repo is written with deep comments —  
> not just *what* the code does, but *why* and *how* it works at a low level.

</div>

---

## 📁 Repository Structure

```
My-Coding-Journey/
│
├── Piscine_2026/           ← 42 C Piscine — Shell00/01 + C00–C14
│   ├── Shell00/ Shell01/   ← shell basics → scripting
│   └── C00/ – C14/         ← output, pointers, strings, recursion, argv, ...
│
├── Learning_C/
│   ├── 00_Hello/           ← write() syscall, printf, puts
│   ├── 01_Variables/       ← types, scope, lifetime, static, XOR swap
│   ├── 02_DataTypes/       ← sizes, limits, overflow, signed vs unsigned
│   ├── 03_Operators/       ← arithmetic, bitwise, logical, ternary, bit flags
│   ├── 04_Conditionals/    ← if/else, switch, ternary, guard clauses
│   ├── 05_Functions_Intro/ ← syntax, prototypes, return values, void
│   ├── 06_Scope/           ← local, global, static, shadowing
│   ├── 07_Loops/           ← while, for, do-while, Collatz, Fibonacci
│   ├── 08_Arrays/          ← 1D/2D, statistics, bubble sort
│   ├── 09_Strings/         ← all of string.h reimplemented from scratch
│   ├── 10_Pointers/        ← basics, arithmetic, double ptrs, func ptrs
│   ├── 11_Functions/       ← recursion, pass-by-ref, ft_* functions
│   ├── 12_Memory/          ← stack vs heap, malloc/free, valgrind
│   ├── 13_Projects/        ← showcase projects combining everything
│   ├── c_exam/             ← 60-level self-grading exam system
│   ├── Games_c/            ← snake, random walk — real programs in C
│   └── C_books/            ← K&R, Modern C, Beej's Guide
│
├── Piscine_Reloaded/       ← 42 Piscine Reloaded — 28 exercises (ex00–ex27)
│   ├── ex00/ – ex05/       ← Shell 01: permissions, links, timestamps, one-liners
│   └── ex06/ – ex27/       ← C Module: loops, pointers, recursion, arrays,
│                              function pointers, macros, headers, Makefile
│
├── Libft/                  ← 42's first real C library project — 43 hand-built
│                              functions (libc reimplementations, string/array
│                              utilities, and a singly linked list toolkit)
│
├── Learning_C++/           ← OOP, classes, templates (coming soon)
├── Learning_Python/        ← scripts, automation, algorithms
└── Discovery_Pscin/        ← 42 piscine discovery exercises
```

---

## 🧪 Piscine 2026 (C Piscine)

The `Piscine_2026/` folder tracks the **42 C Piscine** itself — the intro
Shell and C modules that come before Piscine Reloaded and Libft.

| Module | Status | Notes |
|--------|--------|-------|
| `Shell00` | 🟡 In progress | ex00, ex01, ex02, ex04 |
| `Shell01` | ⬜ Not started | — |
| `C00` | ✅ Complete | Output basics — `ft_putchar`, alphabet, digits, combinations |
| `C01` | ✅ Complete | Pointers — `ft_ft`, `ft_swap`, div/mod, `ft_putstr`, array reverse/sort |
| `C02` | 🟡 In progress | String basics — `ft_strcpy`, `ft_strncpy`, `ft_str_is_alpha` |
| `C03` | ✅ Complete | `ft_strcmp`, `ft_strncmp`, `ft_strcat`, `ft_strstr`, `ft_strlcat` |
| `C04` | ✅ Complete | `ft_atoi`, `ft_putnbr`, base conversion |
| `C05` | ✅ Complete | Recursion & math — factorial, power, Fibonacci, `ft_sqrt` |
| `C06` | ✅ Complete | `argv` handling — print, reverse, sort |
| `C07` – `C14` | ⬜ Not started | Subjects only, no exercises yet |

> See `Piscine_2026/README.md` for the full per-module breakdown and a
> cleanup checklist (stray binaries, editor swap files, a couple of
> filename typos) to resolve before submission.

---

## 🌊 Piscine Reloaded

The `Piscine_Reloaded/` folder contains the **42 Piscine Reloaded** — a full re-run of the classic 42 shell and C fundamentals, done from scratch to solidify the basics before Libft.

28 exercises across two tracks:

| Range | Track | Topics |
|-------|-------|--------|
| ex00 – ex05 | Shell 01 | File types/permissions/links from `ls -l`, single-command scripts (`clean`, `find_sh.sh`, `MAC.sh`), shell-escaping tricky filenames |
| ex06 – ex08 | C 00 | Output basics — alphabet, digits, sign checking |
| ex09 – ex11 | C 01 | Pointers — dereferencing, swap, div/mod via pointers |
| ex12 – ex14 | C Module | Recursion vs iteration, factorial, integer square root |
| ex15 – ex20 | C Module | `ft_putstr`, `ft_strlen`, `ft_strcmp`, argument printing/sorting, `ft_strdup` |
| ex21 – ex23 | C Module | Dynamic ranges, macros (`ABS`), custom structs (`t_point`) |
| ex24 | C Module | First hand-written `Makefile` (builds `libft.a` from `srcs/`/`includes/`) |
| ex25 – ex27 | C Module | Function pointers as callbacks (`ft_foreach`, `ft_count_if`), file display |

> All exercises written in strict **42 Norm** style: no `for` where disallowed, no forbidden functions, proper header comments, `cc -Wall -Wextra -Werror`.

---

## 📚 Libft

The `Libft/` folder is the first "real" 42 project: a personal C library of 43
functions, split into three parts, built to be reused across every later
project in the curriculum.

| Part | Count | Contents |
|------|-------|----------|
| Part 1 — Libc reimplementations | 23 | `ft_isalpha` → `ft_strdup`: char classification, memory ops, string ops, `ft_atoi` |
| Part 2 — Additional utilities | 11 | `ft_substr`, `ft_split`, `ft_itoa`, `ft_strmapi`, `ft_putnbr_fd`, and more |
| Part 3 — Linked list | 9 | `t_list`-based singly linked list: create, add, size, map, iterate, clear |

```bash
cd Libft
make            # builds libft.a
make clean      # removes .o files
make fclean     # removes .o files + libft.a
make re         # full rebuild
```

Every function is covered by a personal (non-submitted) numbered test harness
comparing behavior against the real libc where applicable, plus manual edge
cases for the Part 2/3 functions that have no libc equivalent.

---

## 🗓️ 2-Month C Mastery Roadmap

### Week 1–2 — Foundations
> Understand how C really works — no magic.

| Days | Focus | Folder |
|------|-------|--------|
| 1–2 | `write()` vs `printf` vs `puts`, compilation pipeline | `00_Hello/` |
| 3–4 | Variables, types, addresses, `sizeof` | `01_Variables/` `02_DataTypes/` |
| 5–6 | Operators — bitwise, ternary, bit flags | `03_Operators/` |
| 7 | Review + exam levels 0–8 | `c_exam/` |

**Goal:** Write any expression, know what every type stores, understand `&` and `*`.

---

### Week 3–4 — Control Flow + Functions
> Write real programs with logic and reusable functions.

| Days | Focus | Folder |
|------|-------|--------|
| 8–9 | if/else, switch, guard clauses | `04_Conditionals/` |
| 10–11 | Function syntax, prototypes, return values | `05_Functions_Intro/` |
| 12–13 | Scope: local, global, static, shadowing | `06_Scope/` |
| 14 | All loop types, break/continue, Collatz | `07_Loops/` |
| 15 | Exam levels 9–26 | `c_exam/` |

**Goal:** Write any algorithm — FizzBuzz, Fibonacci, Collatz, factorial — without looking anything up.

---

### Week 5–6 — Arrays + Strings
> Master memory layout. Implement `string.h` from scratch.

| Days | Focus | Folder |
|------|-------|--------|
| 16–19 | 1D/2D arrays, bubble sort, pointer equivalence | `08_Arrays/` |
| 20–23 | Strings, null terminator, `ft_strlen` → `ft_atoi` | `09_Strings/` |
| 24 | Exam levels 27–50 | `c_exam/` |

**Goal:** Reimplement any function from `<string.h>`. Know why `char *` and `char []` differ.

---

### Week 7–8 — Pointers + Memory
> Become dangerous with pointers. Understand the stack and heap.

| Days | Focus | Folder |
|------|-------|--------|
| 25–30 | Pointer basics, arithmetic, double ptrs, func ptrs | `10_Pointers/` |
| 31–32 | `malloc`/`free`, `ft_strdup`, valgrind | `12_Memory/` |
| 33–34 | Recursion, pass-by-ref, `ft_*` functions | `11_Functions/` |
| 35–36 | Structs + real projects + exam final boss | `13_Projects/` `c_exam/` |

**Goal:** Use `malloc`, detect leaks with valgrind, write function pointer dispatch tables, build real programs with structs.

---

## 🧠 Skills Checklist

- [ ] Explain what a pointer is and draw the memory layout on paper
- [ ] Write `ft_strlen`, `ft_strcpy`, `ft_strcmp` without looking anything up
- [ ] Swap two values without a temporary variable (XOR swap)
- [ ] Implement bubble sort from memory
- [ ] Write a recursive factorial and Fibonacci
- [ ] Explain the difference between stack and heap
- [ ] Use `malloc` and `free` correctly without memory leaks
- [ ] Write a function pointer and use it as a callback
- [ ] Explain why `char arr[]` and `char *arr` differ as function params
- [ ] Read and understand a compiler error message
- [ ] Run `valgrind` and fix every leak
- [ ] Finish the C Piscine (`C07`–`C14`, `Shell01`)
- [x] Complete all 28 Piscine Reloaded exercises from scratch
- [x] Build and pass a full 43-function Libft test suite

---

## 🏆 Exam System

The `c_exam/` folder contains a **60-level self-grading exam** built from scratch in Bash.
It compiles your code, checks your output line-by-line, shows a diff on failure, tracks your score and streak, and saves progress between sessions.

```bash
cd Learning_C/c_exam
chmod +x miles3103_v15.sh
./miles3103_v15.sh
```

| Levels | Topic |
|--------|-------|
| 0–8 | C Intro, Syntax, Output, Comments |
| 9–17 | Variables, Data Types, Type Conversion |
| 18–26 | Constants, Operators, Booleans |
| 27–35 | If/Else, Switch, While Loop |
| 36–44 | For Loop, Break/Continue, Arrays |
| 45–53 | Strings, User Input, Memory Addresses |
| 54–59 | **Pointers — Final Boss** |

---

## 🔧 How to Compile

```bash
# Basic
gcc -Wall -Wextra -Werror filename.c -o output

# With math library
gcc -Wall -Wextra -Werror filename.c -o output -lm

# Against Libft
gcc -Wall -Wextra -Werror filename.c Libft/libft.a -I Libft -o output

# Memory check
valgrind --leak-check=full ./output

# Test all files in a folder
for f in *.c; do gcc -Wall -Wextra -Werror "$f" -o test && echo "$f: OK" && rm test; done
```

---

## 📚 Resources

| Book | Location |
|------|----------|
| *The C Programming Language* — K&R (2nd Ed.) | `C_books/` |
| *Modern C* — Jens Gustedt | `C_books/` |
| *Beej's Guide to C* — beej.us/guide/bgc | `C_books/` |
| man pages — `man 2 write`, `man 3 malloc` | terminal |
| cs50.harvard.edu | online, free |

---

<div align="center">

*"The only way to learn a new programming language is by writing programs in it."*
**— Brian Kernighan, co-author of C**

</div>
