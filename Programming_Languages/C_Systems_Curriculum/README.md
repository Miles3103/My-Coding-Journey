# C Systems Programming: Five Projects from Fundamentals to Allocators

A hands-on curriculum for mastering C by building five progressively harder programs. Each project introduces new language features **and** a new layer of the system underneath them (files, heap, binary formats, sockets, threads, the allocator itself).

> **How to use this repo:** Do the projects in order. Each project folder has its own `README.md` containing the full lesson plan. Do **not** copy the skeleton code blindly. The skeletons are scaffolding; the learning happens when you fill in the gaps and debug your own mistakes.

---

## Projects

| # | Project | Level | Folder | Main Theme |
|---|---------|-------|--------|-----------|
| 1 | **mini-grep**: text-search CLI utility | Beginner | [`01_cli_tool/`](01_cli_tool/README.md) | Strings, pointers, `FILE*`, `argv`, exit codes, directory traversal |
| 2 | **cask**: in-memory key-value store with file persistence | Beginner → Intermediate | [`02_kv_store/`](02_kv_store/README.md) | `malloc`/`free`, hash tables, ownership, binary I/O, durability |
| 3 | **bmpkit**: BMP image parser & manipulator | Intermediate | [`03_bmp_parser/`](03_bmp_parser/README.md) | Struct layout, endianness, bitwise ops, bounds-safe parsing |
| 4 | **tinyhttpd**: multithreaded HTTP server | Intermediate → Advanced | [`04_http_server/`](04_http_server/README.md) | POSIX sockets, pthreads, mutex/condvar, signals, robust I/O |
| 5 | **mymalloc**: `malloc`/`free`/`realloc` clone | Advanced | [`05_allocator/`](05_allocator/README.md) | `sbrk`/`mmap`, alignment, free lists, coalescing, UB-aware design |

Suggested pacing (evenings/weekends): **1-2 weeks**, **2 weeks**, **2 weeks**, **3 weeks**, **3-4 weeks**.

---

## Recommended Repository Layout

```text
c-systems-curriculum/
├── README.md                  # this file
├── common/
│   ├── Makefile.common        # shared compiler flags (see below)
│   └── debug_checklist.md     # your personal "bugs I've hit" log
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
STD      := -std=c11
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

Start here → **[Project 1: mini-grep](01_cli_tool/README.md)**
