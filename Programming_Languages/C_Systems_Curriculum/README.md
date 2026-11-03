# C Programming: From Zero to Hero

**A complete path in two phases:** 12 foundation lessons that teach C from nothing, then 5 progressively harder projects that turn it into real systems-programming skill.

A hands-on curriculum for mastering C by building five progressively harder programs. Each project introduces new language features **and** a new layer of the system underneath them (files, heap, binary formats, sockets, threads, the allocator itself).

> **How to use this repo:** Start at **Phase 0** unless you already write C comfortably. Then do the projects in order. Every lesson and project has a `README.md` with the explanation, tasks, pitfalls and tests. Do **not** copy skeleton code blindly: the learning happens when you fill in the gaps and debug your own mistakes.

## Start here
1. Check your tools: `bash tools/doctor.sh`
2. Read [`docs/PROGRESS.md`](docs/PROGRESS.md) for the study plan and skill ladder.
3. Begin [`00_foundations/`](00_foundations/README.md), Lesson 1.
4. Keep [`docs/CHEATSHEET.md`](docs/CHEATSHEET.md), [`docs/GLOSSARY.md`](docs/GLOSSARY.md) and [`docs/DEBUGGING.md`](docs/DEBUGGING.md) open while you work.

---

## Phase 0: Foundations (start here if you're new)

| # | Lesson | Key idea |
|---|---|---|
| 1 | [Hello, World & the compiler](00_foundations/01_hello_world/README.md) | what compiling does; exit codes |
| 2 | [Types & operators](00_foundations/02_types_and_operators/README.md) | sizes, overflow, bits |
| 3 | [Control flow](00_foundations/03_control_flow/README.md) | truthiness, loops, short-circuit |
| 4 | [Functions & scope](00_foundations/04_functions_and_scope/README.md) | pass-by-value, the stack |
| 5 | [Arrays & strings](00_foundations/05_arrays_and_strings/README.md) | no bounds checks, `'\0'` |
| 6 | [Pointers](00_foundations/06_pointers/README.md) | addresses, `&` and `*` |
| 7 | [Pointers, arrays & const](00_foundations/07_pointers_arrays_const/README.md) | arithmetic, function pointers |
| 8 | [Structs, enums, unions](00_foundations/08_structs_enums_unions/README.md) | padding and layout |
| 9 | [The heap](00_foundations/09_heap_memory/README.md) | `malloc`/`free`, ownership |
| 10 | [Files & arguments](00_foundations/10_files_and_args/README.md) | `FILE *`, `errno`, `argv` |
| 11 | [Modules & Make](00_foundations/11_modules_and_make/README.md) | headers, linking, Makefiles |
| 12 | [Debugging & UB](00_foundations/12_debugging_and_ub/README.md) | gdb, sanitizers, valgrind |
| ★ | [Capstone: contacts book](00_foundations/capstone/README.md) | everything combined |

## Phase 1: The Five Projects

| # | Project | Level | Folder | Main Theme |
|---|---------|-------|--------|-----------|
| 1 | **mini-grep**: text-search CLI utility | Beginner | [`01_cli_tool/`](01_cli_tool/README.md) | Strings, pointers, `FILE*`, `argv`, exit codes, directory traversal |
| 2 | **cask**: in-memory key-value store with file persistence | Beginner → Intermediate | [`02_kv_store/`](02_kv_store/README.md) | `malloc`/`free`, hash tables, ownership, binary I/O, durability |
| 3 | **bmpkit**: BMP image parser & manipulator | Intermediate | [`03_bmp_parser/`](03_bmp_parser/README.md) | Struct layout, endianness, bitwise ops, bounds-safe parsing |
| 4 | **tinyhttpd**: multithreaded HTTP server | Intermediate → Advanced | [`04_http_server/`](04_http_server/README.md) | POSIX sockets, pthreads, mutex/condvar, signals, robust I/O |
| 5 | **mymalloc**: `malloc`/`free`/`realloc` clone | Advanced | [`05_allocator/`](05_allocator/README.md) | `sbrk`/`mmap`, alignment, free lists, coalescing, UB-aware design |

Suggested pacing (evenings/weekends): Phase 0 **4 to 6 weeks**, then **1-2**, **2**, **2**, **3**, **3-4 weeks** for the projects. See [`docs/PROGRESS.md`](docs/PROGRESS.md) for a 20-week plan.

### Which Phase 0 lessons each project needs
| Project | Make sure you've done |
|---|---|
| 1 mini-grep | Lessons 1 to 12 and the capstone |
| 2 cask | 8 (structs), 9 (heap), 11 (headers), 10 (binary files) |
| 3 bmpkit | 2 (bits, overflow), 8 (padding), 10 (`fread`) |
| 4 tinyhttpd | 6 to 7 (pointers), 10 (errors), 12 (debugging) |
| 5 mymalloc | 7 (pointer arithmetic), 8 (alignment), 9 (heap) |

---

## Recommended Repository Layout

```text
c-systems-curriculum/
├── README.md                  # this file
├── docs/                      # GLOSSARY, CHEATSHEET, DEBUGGING, PROGRESS
├── tools/doctor.sh            # checks your toolchain
├── common/
│   ├── Makefile.common        # shared compiler flags (see below)
│   └── debug_checklist.md     # your personal "bugs I've hit" log
├── 00_foundations/            # 12 lessons + capstone (runnable examples, bug demos)
├── 01_cli_tool/
├── 02_kv_store/
├── 03_bmp_parser/
├── 04_http_server/
└── 05_allocator/
```

Each project folder follows the same convention:

```text
NN_project/
├── README.md        # lesson plan (provided)
├── Makefile
├── include/         # public headers (.h)
├── src/             # implementation (.c)
├── tests/           # unit + integration tests
└── notes.md         # YOUR notes: what confused you, what you learned
```

> **Why `include/` vs `src/`?** Headers define *interfaces*, `.c` files define *implementations*. Keeping them apart forces you to think about what is public. It is the main tool C gives you for encapsulation, since the language has no `private` keyword.

---

## Toolchain Setup (do this once)

Linux or macOS is strongly recommended (Windows: use WSL2).

```bash
# Debian/Ubuntu
sudo apt install build-essential gdb valgrind clang clang-tools cppcheck \
                 apache2-utils netcat-openbsd curl imagemagick

# macOS (valgrind support is limited; rely on sanitizers instead)
xcode-select --install
brew install gdb cppcheck wget curl imagemagick
```

### Shared Makefile flags: `common/Makefile.common`

```make
CC       ?= gcc
STD      := -std=gnu11
WARN     := -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes
DEBUG    := -g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer
RELEASE  := -O2 -DNDEBUG

# Pick: make            -> debug build (default, sanitizers ON)
#       make BUILD=release
BUILD    ?= debug
ifeq ($(BUILD),release)
  CFLAGS := $(STD) $(WARN) $(RELEASE)
else
  CFLAGS := $(STD) $(WARN) $(DEBUG)
  LDFLAGS += -fsanitize=address,undefined
endif
```

**Why `-std=gnu11` and not `-std=c11`?** Strict `c11` hides POSIX functions such as `getopt`, `getline` and the socket calls, giving `implicit declaration` errors. `gnu11` is C11 plus the usual Unix declarations.

**Why these flags?**

- `-Wall -Wextra -Wpedantic`: the compiler is your cheapest code reviewer. Treat every warning as a bug.
- `-Wshadow`: catches inner variables silently hiding outer ones.
- `-Wconversion`: catches implicit narrowing (`size_t` → `int`), the root of many security bugs.
- `-fsanitize=address,undefined`: AddressSanitizer catches heap/stack overflows and use-after-free at runtime; UBSan catches signed overflow, misaligned access, bad shifts. **Run your tests with these on by default.**
- `-O0 -g` for debugging: with optimization, variables get optimized away and GDB becomes confusing.

---

## Rules of Engagement (habits that separate C pros from beginners)

1. **Every `malloc` has an owner and a matching `free`.** Write the ownership in a comment next to the function: *"returns heap memory; caller must free."*
2. **Check every return value** that can fail: `malloc`, `fopen`, `fread`, `fwrite`, `read`, `write`, `close`, `pthread_*`, `socket`, etc.
3. **Never trust input.** Lengths from files and sockets are attacker-controlled. Validate before using them as sizes or indices.
4. **Prefer `size_t` for sizes/indices, fixed-width types (`uint32_t`) for binary formats.**
5. **Use `const` aggressively.** It documents intent, and the compiler enforces it.
6. **Make bugs reproducible** before you try to fix them. A failing test beats a hunch.
7. **Run Valgrind/ASan before declaring a milestone done.** "It prints the right output" is not the same as "it's correct."
8. **Commit at every checkpoint** with a message such as `P2: hash table resize works, tests pass`.

---

## Core Reading List (use throughout)

| Resource | Why |
|----------|-----|
| *The C Programming Language* (K&R, 2nd ed.) | Concise, idiomatic C. Read chapters as needed |
| *Modern C* by Jens Gustedt (free online) | C11-era best practices, the "why" behind the rules |
| *Computer Systems: A Programmer's Perspective* (CS:APP) | Memory, linking, I/O, concurrency. Essential for P3-P5 |
| *The Linux Programming Interface* (Kerrisk) | Authoritative reference for syscalls, sockets, threads, signals |
| `man 2 <syscall>` / `man 3 <libcfn>` | Learn to read man pages; they are the real documentation |
| [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/) | Best sockets tutorial (P4) |
| [SEI CERT C Coding Standard](https://wiki.sei.cmu.edu/confluence/display/c) | Catalog of C pitfalls |
| [cppreference: C](https://en.cppreference.com/w/c) | Language/library reference |

---

## Master Progress Checklist

- [ ] **Phase 0: lessons 1 to 12 + capstone** (see [`docs/PROGRESS.md`](docs/PROGRESS.md))
- [ ] **Project 1: mini-grep**: all milestones done, Valgrind clean
- [ ] **Project 2: cask KV store**: all milestones done, survives crash-recovery test
- [ ] **Project 3: bmpkit**: all milestones done, fuzz-tested with corrupted files
- [ ] **Project 4: tinyhttpd**: all milestones done, ThreadSanitizer clean, survives load test
- [ ] **Project 5: mymalloc**: all milestones done, runs real programs via `LD_PRELOAD`

---

## How Each Project README Is Organized

1. Overview & why it matters
2. Core C concepts learned
3. Prerequisites to study first
4. Directory layout
5. Step-by-step parts (3-5), each with concrete tasks
6. Milestone code skeletons & checkpoints
7. Common bugs & pitfalls
8. Testing & verification exercises
9. Stretch goals & definition of done

## Troubleshooting
| Problem | Fix |
|---|---|
| `implicit declaration of function 'getopt'` | Use `-std=gnu11` (already set in `common/Makefile.common`) |
| `make: *** No makefile found` | You're in the wrong folder; `cd` to the one containing the `Makefile` |
| `undefined reference to 'main'` | `src/main.c` is empty or missing |
| `ISO C forbids an empty translation unit` | A `.c` file has no code yet (warning only) |
| Sanitizer says `LeakSanitizer ... not supported` | Run in a normal terminal (not a restricted container), or use valgrind |

More in [`docs/DEBUGGING.md`](docs/DEBUGGING.md).

---

Start here → **[Phase 0, Lesson 1](00_foundations/01_hello_world/README.md)** (or, if you already know C, **[Project 1: mini-grep](01_cli_tool/README.md)**)
