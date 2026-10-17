<div align="center">

# My Coding Journey

**C · C++ · Python · Assembly — built from the ground up**

[![Primary language](https://img.shields.io/badge/primary-C-00599C?style=flat&logo=c&logoColor=white)](#-learning-tracks)
[![42 Norm](https://img.shields.io/badge/style-42%20Norm-black?style=flat)](#-42-school)
[![Libft](https://img.shields.io/badge/libft-43%20functions-informational?style=flat)](42-school/libft)
[![Tests](https://img.shields.io/badge/libft%20tests-86%20passing-brightgreen?style=flat)](42-school/libft/tests)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat)](LICENSE)

> Every file is written with deep comments — not just *what* the code does,
> but *why* and *how* it works at a low level.

</div>

---

## Table of contents

- [What is this?](#what-is-this)
- [Repository layout](#-repository-layout)
- [Requirements](#-requirements)
- [Build and run](#-build-and-run)
- [42 School](#-42-school)
- [Learning tracks](#-learning-tracks)
- [Exam system](#-exam-system)
- [Roadmap and skills checklist](#-2-month-c-mastery-roadmap)
- [Repository hygiene](#-repository-hygiene)
- [License](#license)

## What is this?

A monorepo documenting my path through programming: the **42 School**
curriculum (Piscine, Libft, exams) and my own structured **learning tracks**
for C, C++, Python and x86-64 assembly — lessons, small projects, and a
self-grading exam written in Bash.

## 📁 Repository layout

```text
My-Coding-Journey/
├── 42-school/
│   ├── libft/               # 43-function C library: include/ src/ tests/ docs/ Makefile
│   ├── piscine-2026/        # C Piscine: Shell00/01 + C00–C13 (subjects + exercises)
│   ├── piscine-reloaded/    # 28 exercises (ex00–ex27), one README each
│   ├── discovery-python/    # Python Discovery Piscine (modules 1–9)
│   └── exams/               # exam submissions (rendu/)
├── learning/
│   ├── c/                   # 00_Hello … 13_Projects, games/, exam/, exam-py/, practice/
│   ├── cpp/                 # 00_Intro … 11_Projects (OOP, templates, STL, modern C++)
│   ├── python/              # 00_Basics … 10_Projects (OOP, decorators, task manager)
│   └── assembly/            # x86-64 NASM: hello, input, number game, small game
├── docs/                    # git-notes.md and other reference notes
├── resources/               # local-only books/PDFs — git-ignored, never committed
├── .editorconfig  .gitignore  LICENSE  README.md
```

## 🧰 Requirements

| Tool | Needed for |
|------|-----------|
| `cc` / `gcc` or `clang`, `make` | everything in C |
| `g++` (C++17) | `learning/cpp` |
| `python3` (3.8+) | `learning/python`, `42-school/discovery-python` |
| `nasm`, `ld` | `learning/assembly` (Linux x86-64) |
| `libsdl2-dev`, `libsdl2-mixer-dev` | the SDL games in `learning/c/games` |
| `valgrind` *(optional)* | leak checks on Linux |

## 🔧 Build and run

**Libft**

```bash
cd 42-school/libft
make            # builds libft.a (objects in build/)
make test       # runs the 86-check test suite under ASan + UBSan
make fclean     # remove build output
```

**A single exercise or lesson file** (most files contain their own `main`)

```bash
cc -Wall -Wextra -Werror 42-school/piscine-2026/C05/ex00/ft_iterative_factorial.c -o /tmp/demo
/tmp/demo
```

**Against Libft**

```bash
cc -Wall -Wextra -Werror -I42-school/libft/include my_file.c \
   -L42-school/libft -lft -o my_program
```

**C++ lessons**

```bash
g++ -std=c++17 -Wall -Wextra learning/cpp/03_OOP_Classes/classes_complete.cpp -o /tmp/demo && /tmp/demo
```

**Python lessons**

```bash
python3 learning/python/10_Projects/task_manager.py          # demo
python3 learning/python/10_Projects/task_manager.py --help   # CLI options
```

**SDL games** (Linux; needs the SDL2 packages above)

```bash
cd learning/c/games/snake_c
cc -Wall -Wextra snake.c $(sdl2-config --cflags --libs) -lSDL2_mixer -lm -o snake && ./snake

cd ../random_walk
cc -Wall -Wextra random-walk.c $(sdl2-config --cflags --libs) -lm -o random-walk && ./random-walk
```

**Check everything compiles (what CI would do)**

```bash
find . -name '*.c' -not -path './learning/c/games/*' -not -path './42-school/libft/*' -not -path './resources/*' \
  -exec sh -c 'cc -Wall -Wextra -Werror -fsyntax-only "$1" || echo "FAILED: $1"' _ {} \;
```

**Memory check**

```bash
cc -g -fsanitize=address,undefined my_file.c -o /tmp/demo && /tmp/demo
valgrind --leak-check=full /tmp/demo        # Linux
```

## 🏫 42 School

| Project | Status | Notes |
|---------|--------|-------|
| [`libft`](42-school/libft) | ✅ Complete | 43 functions in 3 parts (libc, utilities, linked list) with a sanitizer-backed test suite |
| [`piscine-reloaded`](42-school/piscine-reloaded) | ✅ Complete | 28 exercises: shell tricks → pointers → recursion → function pointers → a first `Makefile` |
| [`piscine-2026`](42-school/piscine-2026) | 🟡 In progress | Shell00 and C00–C06 done; C07+ have subjects only |
| [`discovery-python`](42-school/discovery-python) | 🟡 In progress | Python Discovery Piscine: modules 1 and 4–9 present |
| [`exams`](42-school/exams) | 🟡 In progress | exam `rendu/` submissions |

Per-project details live in each folder's own `README.md`.

## 📚 Learning tracks

| Track | Contents |
|-------|----------|
| [`learning/c`](learning/c) | `00_Hello` → `13_Projects`: write/printf, types, operators, control flow, functions, scope, loops, arrays, strings from scratch, pointers, memory (`malloc`/`free`), projects, SDL games |
| [`learning/cpp`](learning/cpp) | classes, inheritance, polymorphism, templates, STL, memory, exceptions, modern C++, an RPG-inventory project |
| [`learning/python`](learning/python) | control flow, functions, data structures, OOP, modules/files, comprehensions, decorators/generators, libraries, a CLI task manager |
| [`learning/assembly`](learning/assembly) | x86-64 NASM programs: hello, input, random-number game, a small game |

## 🏆 Exam system

`learning/c/exam/` holds a **60-level self-grading exam** written in Bash. It
compiles your code, compares output line by line, shows a diff on failure, and
tracks score, streak and progress between sessions (progress files are
git-ignored).

```bash
cd learning/c/exam
./miles3103_v15.sh
```

| Levels | Topic |
|--------|-------|
| 0–8 | C intro, syntax, output, comments |
| 9–17 | Variables, data types, type conversion |
| 18–26 | Constants, operators, booleans |
| 27–35 | if/else, switch, while loop |
| 36–44 | for loop, break/continue, arrays |
| 45–53 | Strings, user input, memory addresses |
| 54–59 | **Pointers — final boss** |

Companion exams: `learning/c/exam-py/miles3103.py` (Python port) and
`learning/cpp/miles3103_cpp_exam.sh` (C++).

## 🗓️ 2-Month C Mastery Roadmap

### Week 1–2 — Foundations
> Understand how C really works — no magic.

| Days | Focus | Folder |
|------|-------|--------|
| 1–2 | `write()` vs `printf` vs `puts`, compilation pipeline | `00_Hello/` |
| 3–4 | Variables, types, addresses, `sizeof` | `01_Variables/` `02_DataTypes/` |
| 5–6 | Operators — bitwise, ternary, bit flags | `03_Operators/` |
| 7 | Review + exam levels 0–8 | `exam/` |

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
| 15 | Exam levels 9–26 | `exam/` |

**Goal:** Write any algorithm — FizzBuzz, Fibonacci, Collatz, factorial — without looking anything up.

---

### Week 5–6 — Arrays + Strings
> Master memory layout. Implement `string.h` from scratch.

| Days | Focus | Folder |
|------|-------|--------|
| 16–19 | 1D/2D arrays, bubble sort, pointer equivalence | `08_Arrays/` |
| 20–23 | Strings, null terminator, `ft_strlen` → `ft_atoi` | `09_Strings/` |
| 24 | Exam levels 27–50 | `exam/` |

**Goal:** Reimplement any function from `<string.h>`. Know why `char *` and `char []` differ.

---

### Week 7–8 — Pointers + Memory
> Become dangerous with pointers. Understand the stack and heap.

| Days | Focus | Folder |
|------|-------|--------|
| 25–30 | Pointer basics, arithmetic, double ptrs, func ptrs | `10_Pointers/` |
| 31–32 | `malloc`/`free`, `ft_strdup`, valgrind | `12_Memory/` |
| 33–34 | Recursion, pass-by-ref, `ft_*` functions | `11_Functions/` |
| 35–36 | Structs + real projects + exam final boss | `13_Projects/` `exam/` |

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

---

## 🧹 Repository hygiene

- **Build output is never tracked.** `.gitignore` covers objects, archives,
  extension-less binaries, `__pycache__`, editor swap/backup files and the
  exam's runtime save files.
- **Third-party books/PDFs are not tracked.** Keep them in `resources/`
  (git-ignored). Publishing copyrighted books in a public repo is a
  take-down risk.
- **Style:** C follows the 42 Norm (tabs); see `.editorconfig`. Python is
  checked with `flake8 --select=E9,F`.
- **Large history?** Earlier commits contain ~150 MB of PDFs and binaries. To
  shrink the repository, rewrite history with
  [`git filter-repo`](https://github.com/newren/git-filter-repo) (coordinate
  first, it changes commit hashes).

## License

Released under the [MIT License](LICENSE).

<div align="center">

*"The only way to learn a new programming language is by writing programs in it."*
— Brian Kernighan

</div>
