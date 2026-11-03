#!/usr/bin/env bash
# Adds the C systems curriculum into an EXISTING repo as a subfolder.
# Run it from inside your repo (e.g. Programming_Languages/).
# Usage: bash install_into_repo.sh [target_folder]     (default: C_Systems_Curriculum)
set -euo pipefail
ROOT="${1:-C_Systems_Curriculum}"
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then echo "Note: not inside a git repo; files will still be created in ./$ROOT"; fi
if [ -e "$ROOT" ]; then echo "Error: ./$ROOT already exists. Move it or delete it first." >&2; exit 1; fi
mkdir -p "$ROOT"/common
for d in 01_cli_tool:mgrep 02_kv_store:cask 03_bmp_parser:bmpkit 04_http_server:tinyhttpd 05_allocator:mymalloc; do
  dir="${d%%:*}"
  mkdir -p "$ROOT/$dir"/{src,include,tests}
  touch "$ROOT/$dir"/{src,include,tests}/.gitkeep "$ROOT/$dir/notes.md"
done

cat > "$ROOT/common/Makefile.common" <<'EOF'
CC       ?= gcc
STD      := -std=c11
WARN     := -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes
DEBUG    := -g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer
RELEASE  := -O2 -DNDEBUG
BUILD    ?= debug
ifeq ($(BUILD),release)
  CFLAGS := $(STD) $(WARN) $(RELEASE)
else
  CFLAGS := $(STD) $(WARN) $(DEBUG)
  LDFLAGS += -fsanitize=address,undefined
endif
EOF
touch "$ROOT/common/debug_checklist.md"

# Starter Makefiles (one per project)
mk() { # dir target extra_flags
cat > "$ROOT/$1/Makefile" <<EOF
include ../common/Makefile.common
TARGET := $2
SRCS   := \$(wildcard src/*.c)
OBJS   := \$(SRCS:src/%.c=build/%.o)
CFLAGS += -Iinclude $3
LDFLAGS += $3

all: \$(TARGET)
\$(TARGET): \$(OBJS)
	\$(CC) \$(OBJS) -o \$@ \$(LDFLAGS)
build/%.o: src/%.c | build
	\$(CC) \$(CFLAGS) -c \$< -o \$@
build:
	mkdir -p build
clean:
	rm -rf build \$(TARGET)
.PHONY: all clean
EOF
}
mk 01_cli_tool mgrep ""
mk 02_kv_store cask ""
mk 03_bmp_parser bmpkit ""
mk 04_http_server tinyhttpd "-pthread"
mk 05_allocator mymalloc "-pthread"

cat > "$ROOT/README.md" <<'CURRICULUM_EOF_7f3a'
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
CURRICULUM_EOF_7f3a
cat > "$ROOT/01_cli_tool/README.md" <<'CURRICULUM_EOF_7f3a'
# Project 1: `mini-grep`, a Text Search CLI Utility

**Level:** Beginner | **Estimated time:** 1-2 weeks | **Next:** [Project 2: KV Store](../02_kv_store/README.md)

---

## 1. Overview

You will build `mgrep`, a simplified clone of Unix `grep`:

```bash
mgrep [OPTIONS] PATTERN [FILE...]
mgrep -inc "error" server.log
mgrep -r "TODO" ./src
cat access.log | mgrep -v "200 OK"
```

### Why this project matters for a C developer

C is the language of the Unix toolchain. A grep clone forces you to confront the "everyday" skills of C in a small, testable package:

- How a C program receives input (`argc`/`argv`, `stdin`, files) and communicates results (stdout, stderr, **exit codes**).
- How **strings really work**: null-terminated `char` arrays, with no length attached and no bounds checking.
- How to read lines of **unknown length** without buffer overflows.
- How to design a program that cleanly separates *parsing options* from *doing work*.

If you can build `mgrep` robustly, you have the foundation for everything that follows.

---

## 2. Core C Concepts Learned

- [ ] `int main(int argc, char *argv[])` and the shape of `argv`
- [ ] Pointers, `char *`, pointer arithmetic over strings
- [ ] Null-terminated strings and `<string.h>` (`strlen`, `strstr`, `strcmp`, `memcmp`)
- [ ] `FILE *`, `fopen`/`fclose`, `stdin`/`stdout`/`stderr`
- [ ] `getline()` and dynamically-grown buffers (`malloc`/`realloc`/`free`)
- [ ] `getopt()` for command-line parsing
- [ ] `struct` for grouping options; passing `const struct *`
- [ ] `<ctype.h>` and the `unsigned char` cast rule
- [ ] `errno`, `perror`, `strerror`
- [ ] Exit-code conventions (`0` match, `1` no match, `2` error)
- [ ] Directory traversal: `opendir`, `readdir`, `lstat`, `S_ISDIR`
- [ ] Multi-file compilation, headers, `Makefile`, `static` functions

---

## 3. Prerequisites & Lessons to Study First

Study these **before** writing code. Skim, take notes in `notes.md`, then return when stuck.

| Topic | What to be able to explain |
|-------|---------------------------|
| **Compilation pipeline** | preprocess → compile → assemble → link; what a `.o` file is |
| **Arrays vs. pointers** | Why `sizeof(arr)` ≠ `sizeof(ptr)`; array-to-pointer decay |
| **C strings** | Why `'\0'` terminates; why `char s[5] = "hello"` is a bug |
| **Stack vs. heap** | Where locals live vs. `malloc`'d memory; lifetimes |
| **`man 3 getline`** | How it uses `*lineptr`/`*n`; who frees the buffer |
| **`man 3 getopt`** | `optarg`, `optind`, option strings like `"incvr"` |
| **Return values & `errno`** | Which functions set `errno`, and when it's valid to read it |
| **Exit statuses** | Why shells and scripts depend on them (`grep -q ... && ...`) |
| **`unsigned char` and `<ctype.h>`** | Why `tolower((unsigned char)c)` is required |

> **Why `unsigned char` for ctype?** `isalpha(int c)` requires a value representable as `unsigned char` or `EOF`. On platforms where `char` is signed, bytes ≥ 128 become negative and invoke **undefined behavior**. This is a classic real-world bug.

---

## 4. Repository Directory Layout

```text
01_cli_tool/
├── README.md
├── Makefile
├── include/
│   ├── options.h        # Options struct + parse function
│   ├── search.h         # search_stream(), search_path()
│   └── match.h          # substring matching helpers
├── src/
│   ├── main.c           # glue: parse → dispatch → exit code
│   ├── options.c
│   ├── search.c
│   └── match.c
├── tests/
│   ├── run_tests.sh     # integration tests comparing against real grep
│   └── fixtures/
│       ├── small.txt
│       ├── empty.txt
│       ├── long_line.txt
│       └── tree/...     # nested dirs for -r
└── notes.md
```

### Starter `Makefile`

```make
include ../common/Makefile.common

TARGET := mgrep
SRCS   := $(wildcard src/*.c)
OBJS   := $(SRCS:src/%.c=build/%.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

build/%.o: src/%.c | build
	$(CC) $(CFLAGS) -Iinclude -c $< -o $@

build:
	mkdir -p build

test: all
	./tests/run_tests.sh

clean:
	rm -rf build $(TARGET)

.PHONY: all test clean
```

---

## 5. Step-by-Step Parts

| Part | Goal | Est. |
|------|------|------|
| 1 | Skeleton: argument parsing & stdin/file reading | 2-3 days |
| 2 | Core search: substring match, line numbers, invert, count | 2-3 days |
| 3 | Case-insensitive matching & multi-file output formatting | 1-2 days |
| 4 | Recursive directory search | 2 days |
| 5 | *(Optional)* Tiny regex engine (`.`, `*`, `^`, `$`) | 3-4 days |

---

### Part 1: Skeleton: Arguments & Reading Input

#### Tasks

- [ ] Create `Options` struct and `parse_args()` using `getopt`.
- [ ] Support flags: `-i` (ignore case), `-n` (line numbers), `-v` (invert), `-c` (count only), `-r` (recursive).
- [ ] First non-option argument is the PATTERN; remaining are files. No files → read `stdin`.
- [ ] Print a usage message to **stderr** and exit `2` on bad input.
- [ ] Open each file with `fopen`; on failure, `perror(path)`, remember the error, and **continue** with the next file.
- [ ] Read lines with `getline()` and print every line unchanged (placeholder for now).

#### Milestone skeleton: `include/options.h`

```c
#ifndef OPTIONS_H
#define OPTIONS_H

#include <stdbool.h>

typedef struct {
    bool ignore_case;   /* -i */
    bool line_numbers;  /* -n */
    bool invert;        /* -v */
    bool count_only;    /* -c */
    bool recursive;     /* -r */
} Options;

/* Parses argv. On success returns 0 and fills outputs:
 *   *pattern    -> points INTO argv (not owned, do not free)
 *   *first_file -> index in argv of first file operand (== argc if none)
 * On failure prints usage to stderr and returns -1. */
int parse_args(int argc, char **argv, Options *opts,
               const char **pattern, int *first_file);

#endif
```

#### Milestone skeleton: `src/options.c`

```c
#include <stdio.h>
#include <unistd.h>   /* getopt, optind */
#include "options.h"

int parse_args(int argc, char **argv, Options *opts,
               const char **pattern, int *first_file)
{
    *opts = (Options){0};       /* zero-initialise every field */
    int c;
    while ((c = getopt(argc, argv, "invcr")) != -1) {
        switch (c) {
        case 'i': opts->ignore_case  = true; break;
        /* TODO: remaining flags */
        default:  /* '?' */
            fprintf(stderr, "usage: %s [-invcr] PATTERN [FILE...]\n", argv[0]);
            return -1;
        }
    }
    /* TODO: ensure optind < argc, set *pattern = argv[optind], advance */
    return 0;
}
```

#### Checkpoint 1

```bash
./mgrep -n foo tests/fixtures/small.txt     # prints every line (for now)
echo "hi" | ./mgrep x                       # reads stdin
./mgrep x nonexistent.txt; echo $?          # perror message, exit status != 0
```

> **Why `*opts = (Options){0};`?** Uninitialized stack structs contain garbage. Zero-initialising makes "flag not set" the default and removes an entire class of nondeterministic bugs.

> **Why `getline` over `fgets`?** `fgets` needs a fixed buffer, so long lines get silently split, which is a correctness bug. `getline` grows a heap buffer as needed. The trade-off: you must `free` the buffer.

---

### Part 2: Core Search

#### Tasks

- [ ] Implement `search_stream(FILE *fp, const char *label, const char *pattern, const Options *o)`; it returns the number of matching lines (or a negative value on I/O error).
- [ ] A line "matches" if it contains the pattern (`strstr` for now).
- [ ] `-v` prints only **non**-matching lines.
- [ ] `-n` prefixes `LINENO:`.
- [ ] `-c` prints only the count, not the lines.
- [ ] Set exit status: `0` if any line matched, `1` if none, `2` on any error.
- [ ] Check `ferror(fp)` after the loop, since `getline` returning `-1` means EOF **or** error.

#### Milestone skeleton: `src/search.c`

```c
#define _POSIX_C_SOURCE 200809L   /* expose getline() */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "search.h"
#include "match.h"

/* Returns #matching lines, or -1 on read error.
 * Does not close fp. Ownership of fp stays with the caller. */
long search_stream(FILE *fp, const char *label,
                   const char *pattern, const Options *o)
{
    char   *line = NULL;     /* getline allocates/grows this */
    size_t  cap  = 0;
    ssize_t len;
    long    lineno = 0, matches = 0;

    while ((len = getline(&line, &cap, fp)) != -1) {
        lineno++;
        bool hit = line_matches(line, pattern, o->ignore_case);
        if (hit != o->invert) {          /* XOR logic: why does this work? */
            matches++;
            if (!o->count_only) {
                /* TODO: print [label:][lineno:]line  (line includes '\n') */
            }
        }
    }
    free(line);                          /* ALWAYS free, even on error path */
    if (ferror(fp)) { perror(label); return -1; }
    return matches;
}
```

> **Why free the `getline` buffer once, outside the loop?** `getline` reuses the buffer across calls and only reallocates when a line is longer than the current capacity. One `free` at the end is correct; freeing inside the loop would be a bug.

> **Edge cases you must handle:** last line without a trailing `\n`; empty file; empty pattern (grep matches every line); binary data / embedded `\0` (decide: document your behavior).

#### Checkpoint 2: compare with the real thing

```bash
diff <(./mgrep -n error tests/fixtures/small.txt) \
     <(grep  -n error tests/fixtures/small.txt) && echo OK
```

---

### Part 3: Case-Insensitive Matching & Multi-File Output

#### Tasks

- [ ] Implement `line_matches()` in `match.c`.
- [ ] For `-i`, write your own `strcasestr`-style function using `tolower((unsigned char)c)`. Don't call a non-standard function.
- [ ] When more than one file is given, prefix output with `filename:` (like grep).
- [ ] With `-c` and multiple files, print `filename:count` per file.

#### Milestone skeleton: `src/match.c`

```c
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include "match.h"

/* Naive O(n*m) search; fine for this project. */
static bool contains_ci(const char *hay, const char *needle)
{
    size_t nlen = strlen(needle);
    if (nlen == 0) return true;
    for (; *hay; hay++) {
        size_t i = 0;
        while (i < nlen && hay[i] &&
               tolower((unsigned char)hay[i]) ==
               tolower((unsigned char)needle[i]))
            i++;
        if (i == nlen) return true;
    }
    return false;
}

bool line_matches(const char *line, const char *pat, bool icase)
{
    return icase ? contains_ci(line, pat) : strstr(line, pat) != NULL;
}
```

**Think about:** What happens in the inner loop if `hay` is shorter than `needle`? (The `hay[i] &&` guard stops you reading past the `'\0'`. This is exactly the sort of out-of-bounds read C will not warn you about.)

**Optimization exercise:** Precompute a lowercase copy of the pattern once instead of calling `tolower` on it each iteration. Measure with `time` on a 100 MB file.

---

### Part 4: Recursive Search (`-r`)

#### Tasks

- [ ] If `-r` and the operand is a directory, walk it with `opendir`/`readdir`.
- [ ] Skip `.` and `..`.
- [ ] Use `lstat` (not `stat`) so symlinks are **not** followed, which avoids infinite loops.
- [ ] Build child paths with `snprintf` into a buffer; check for truncation (return value ≥ buffer size).
- [ ] Always `closedir`, including on early-return paths.
- [ ] Without `-r`, a directory operand prints `mgrep: dir: Is a directory` and sets the error status.

#### Milestone skeleton

```c
#include <dirent.h>
#include <sys/stat.h>
#include <limits.h>   /* PATH_MAX */

/* Returns number of matching lines in the tree, or -1 on any error. */
long search_path(const char *path, const char *pattern, const Options *o)
{
    struct stat st;
    if (lstat(path, &st) != 0) { perror(path); return -1; }

    if (S_ISDIR(st.st_mode)) {
        if (!o->recursive) { /* TODO: report error */ return -1; }
        DIR *d = opendir(path);
        if (!d) { perror(path); return -1; }

        long total = 0;
        struct dirent *e;
        while ((e = readdir(d)) != NULL) {
            if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0)
                continue;
            char child[PATH_MAX];
            int n = snprintf(child, sizeof child, "%s/%s", path, e->d_name);
            if (n < 0 || (size_t)n >= sizeof child) { /* TODO: truncated */ continue; }
            /* TODO: recurse, accumulate total, track errors */
        }
        closedir(d);
        return total;
    }
    if (S_ISREG(st.st_mode)) {
        /* TODO: fopen, search_stream, fclose */
    }
    return 0;   /* skip sockets, FIFOs, devices: why? (try `grep x /dev/zero`) */
}
```

> **Why `lstat` and `S_ISREG`?** Following symlinks can create cycles (`a/loop -> ..`). Opening a FIFO or `/dev/zero` can block forever or read infinitely. Real tools restrict to regular files for exactly these reasons.

> **Why a stack buffer for paths and a stack-depth concern?** Recursion uses stack space per directory level (`PATH_MAX` is typically 4096 bytes per frame). Deep trees are the reason production tools use iterative traversal (`nftw`, `fts`). Consider this trade-off in `notes.md`.

---

### Part 5 *(Optional)*: Tiny Regex Matcher

Implement the classic Kernighan-Pike matcher supporting `c`, `.`, `^`, `$`, `*`. It's ~30 lines of recursion and a great pointer-manipulation workout.

```c
/* match: does regexp match anywhere in text? */
int match(const char *regexp, const char *text);

/* matchhere: does regexp match at beginning of text? */
static int matchhere(const char *regexp, const char *text);

/* matchstar: c*regexp at beginning of text? */
static int matchstar(int c, const char *regexp, const char *text);
```

Add a `-E` flag to switch between literal and regex modes. Compare against `grep -E` using the same test fixtures.

---

## 6. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Using `gets()` or unbounded `scanf("%s")`** | Buffer overflow | Never use them. Use `getline`. |
| **`sizeof(argv[1])`** | Returns pointer size (8), not string length | Use `strlen`. |
| **Forgetting `free(line)`** | Leak (Valgrind: "definitely lost") | Free after loop, on all exit paths |
| **Freeing `*pattern`** | Crash / "free(): invalid pointer" | `pattern` points into `argv`; you don't own it |
| **`tolower(c)` with signed `char`** | UB on non-ASCII bytes | Cast: `tolower((unsigned char)c)` |
| **Off-by-one on `\0`** | Reads/writes past buffer | Remember a `char buf[N]` holds N-1 chars + `\0` |
| **Ignoring `fopen` failure** | NULL deref → segfault | Always check; `perror(path)` |
| **Using `strcpy`/`strcat`** | Overflows | Use `snprintf`, or `strlcpy` where available |
| **Not closing `DIR*` / `FILE*`** | File-descriptor leak (breaks on big trees) | Pair every open with a close on every path |
| **Printing to stdout what belongs on stderr** | Breaks pipelines | Errors → `stderr`, results → `stdout` |
| **Confusing EOF vs. error from `getline`** | Silent data loss | Check `ferror(fp)` after the loop |
| **Mixing `stat` & `lstat`** | Infinite recursion on symlink cycles | Use `lstat` for traversal |

---

## 7. Testing & Verification Exercises

### 7.1 Differential testing against real `grep`

Create `tests/run_tests.sh`:

```bash
#!/usr/bin/env bash
set -u
pass=0; fail=0
check() {   # check "description" "args..."
    desc=$1; shift
    exp=$(grep "$@" 2>&1); exp_rc=$?
    got=$(./mgrep "$@" 2>&1); got_rc=$?
    if [[ "$exp" == "$got" && $exp_rc -eq $got_rc ]]; then
        ((pass++))
    else
        ((fail++)); echo "FAIL: $desc"; diff <(echo "$exp") <(echo "$got") | head
    fi
}
check "basic"        foo   tests/fixtures/small.txt
check "line numbers" -n foo tests/fixtures/small.txt
check "invert"       -v foo tests/fixtures/small.txt
check "ignore case"  -i FOO tests/fixtures/small.txt
check "count"        -c foo tests/fixtures/small.txt
check "multi-file"   foo tests/fixtures/small.txt tests/fixtures/empty.txt
check "recursive"    -rn TODO tests/fixtures/tree
echo "pass=$pass fail=$fail"; exit $((fail != 0))
```

### 7.2 Memory checking

```bash
make                                     # ASan+UBSan build
./mgrep -rn TODO tests/fixtures/tree     # sanitizers report on error

# Or with Valgrind (build with BUILD=release plus -g, without ASan):
valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=1 \
         ./mgrep -in error tests/fixtures/small.txt
```

**Goal:** `All heap blocks were freed -- no leaks are possible`, and **0 errors**.

### 7.3 Nasty-input fixtures to create

- [ ] Empty file
- [ ] File with a single 10 MB line (no newline). Does memory stay reasonable?
- [ ] File with no trailing newline
- [ ] File containing `\0` bytes
- [ ] File with non-UTF-8 / high-bit bytes (tests the `unsigned char` fix)
- [ ] Directory with a symlink loop (`ln -s .. tree/loop`)
- [ ] Unreadable file (`chmod 000`)

### 7.4 GDB practice (do this deliberately once)

```bash
gdb --args ./mgrep -n foo tests/fixtures/small.txt
(gdb) break search_stream
(gdb) run
(gdb) next                  # step over
(gdb) print line            # inspect the buffer
(gdb) print *o              # print the options struct
(gdb) watch matches         # break when the variable changes
(gdb) bt                    # backtrace after a crash
```

**Exercise:** Introduce a bug on purpose (e.g. write `line[len+1] = 'x'`) and use ASan's report **and** GDB to find it from scratch.

---

## 8. Stretch Goals

- [ ] `-w` (whole-word match), `-l` (list matching filenames only), `-A/-B/-C` context lines
- [ ] Coloured output (`\033[1;31m` around the match) only if `isatty(STDOUT_FILENO)`
- [ ] Replace naive search with **Boyer-Moore-Horspool** and benchmark it
- [ ] Use `mmap` to read large files and compare performance against `getline`
- [ ] Parallel directory search with `fork` (preview of Project 4)

## 9. Definition of Done

- [ ] All flags work and match real `grep` output on fixtures
- [ ] Correct exit codes (0/1/2)
- [ ] **Zero** warnings with `-Wall -Wextra -Wpedantic -Wconversion`
- [ ] **Zero** ASan/UBSan/Valgrind reports
- [ ] `notes.md` explains: stack vs. heap in your program, who owns each pointer, and 3 bugs you hit

➡️ **Next:** [Project 2: KV Store](../02_kv_store/README.md)
CURRICULUM_EOF_7f3a
cat > "$ROOT/02_kv_store/README.md" <<'CURRICULUM_EOF_7f3a'
# Project 2: `cask`, an In-Memory Key-Value Store with File Persistence

**Level:** Beginner → Intermediate | **Estimated time:** ~2 weeks | **Prev:** [Project 1](../01_cli_tool/README.md) | **Next:** [Project 3](../03_bmp_parser/README.md)

---

## 1. Overview

You will build a small Redis-like database as a **library** plus a **REPL** (interactive shell):

```text
$ ./cask data.db
cask> SET name "Ada Lovelace"
OK
cask> GET name
"Ada Lovelace"
cask> DEL name
(1)
cask> COUNT
0
cask> QUIT
```

Internally: a **hand-written hash table** (separate chaining, dynamic resizing) and a **crash-tolerant append-only log** for persistence.

### Why this project matters for a C developer

C has no built-in dynamic array, map, or string type. Real C programs are built from data structures like this one. Here you learn to:

- Design an **API with clear ownership rules** (who allocates? who frees?), the central discipline of C.
- Manage heap memory across the full lifecycle: create, grow, shrink, destroy.
- Hide implementation details behind **opaque types**, which is C's way of doing encapsulation.
- Think about **durability**: what survives a power cut halfway through a write?

---

## 2. Core C Concepts Learned

- [ ] `malloc`, `calloc`, `realloc`, `free`, and the "realloc into a temp" idiom
- [ ] Linked lists and pointer-to-pointer manipulation (`Entry **`)
- [ ] Opaque structs (`typedef struct HashTable HashTable;` in the header, defined in `.c`)
- [ ] Hash functions, load factor, rehashing
- [ ] Error handling via return codes + `enum`, with out-parameters
- [ ] Binary file I/O: `fread`/`fwrite`, `fflush`, `fsync`, `rename`
- [ ] Fixed-width integers (`uint32_t`) and on-disk formats
- [ ] `size_t` arithmetic and overflow checks
- [ ] `const` correctness and `void *` for generic values
- [ ] Unit testing with assertions (or the Unity framework)
- [ ] Memory ownership: "borrowed" vs. "owned" pointers

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Heap allocation lifecycle** | `malloc` can return `NULL`; `free(NULL)` is safe; double-free is UB |
| **`realloc` semantics** | It may move memory; on failure the original block is still valid |
| **Hash tables** | Collision strategies (chaining vs. open addressing), load factor, why table sizes matter |
| **Hash functions** | FNV-1a, djb2; avalanche behavior; why `hash % size` is cheap if size is a power of 2 (`hash & (size-1)`) |
| **Opaque pointers** | Forward declaration; why callers can't touch struct fields |
| **`fread`/`fwrite` return values** | Short reads/writes; `feof` vs `ferror` |
| **Buffered I/O vs. durability** | `fwrite` → user buffer → `fflush` → kernel cache → `fsync` → disk |
| **Atomic file replacement** | write temp file → `fsync` → `rename()` (atomic on POSIX) |
| **Endianness & fixed-width types** | Why `sizeof(int)` is not portable in a file format |
| **Pointer-to-pointer idiom** | Removing a node from a singly linked list without a special case for the head |

---

## 4. Repository Directory Layout

```text
02_kv_store/
├── README.md
├── Makefile
├── include/
│   ├── hashtable.h      # generic string->bytes table (opaque)
│   ├── kv.h             # public store API (wraps table + persistence)
│   └── log.h            # persistence layer API (internal)
├── src/
│   ├── hashtable.c
│   ├── kv.c
│   ├── persist.c
│   └── repl.c           # main(): command parser loop
├── tests/
│   ├── test_hashtable.c
│   ├── test_persist.c
│   ├── test_fuzz.c      # randomized ops vs. reference model
│   └── crash_test.sh
└── notes.md
```

Build the **library** as `libcask.a` and link both `repl` and the tests against it:

```make
lib: $(LIB_OBJS)
	ar rcs build/libcask.a $^
```

> **Why a library + thin `main`?** Testability. Tests can call your API directly without driving a text shell, and the same design reappears in every serious C project.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Hash table core: create/destroy, put/get/delete (no resize) |
| 2 | Dynamic resizing + load factor + stress tests |
| 3 | REPL command layer (`SET/GET/DEL/COUNT/KEYS`) |
| 4 | Persistence: append-only log, replay on startup |
| 5 | Compaction (atomic snapshot) + crash-recovery hardening |

---

### Part 1: Hash Table Core

#### Tasks

- [ ] Define the public API in `hashtable.h` with an **opaque** `HashTable` type.
- [ ] Implement FNV-1a 64-bit hash.
- [ ] Use **separate chaining**: each bucket is a singly linked list of `Entry`.
- [ ] `ht_put` **copies** the key and value (the table owns its data). Decide and document: overwrite on duplicate key.
- [ ] `ht_get` returns a **borrowed** pointer into the table. Document that it's invalidated by the next `put`/`delete`.
- [ ] `ht_delete` unlinks and frees the entry; returns whether the key existed.
- [ ] `ht_destroy` frees *everything*, including all keys, values, entries, bucket array, and the table struct.

#### Milestone skeleton: `include/hashtable.h`

```c
#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stddef.h>
#include <stdbool.h>

typedef struct HashTable HashTable;      /* opaque: defined in hashtable.c */

typedef enum {
    HT_OK = 0,
    HT_ERR_NOMEM,
    HT_ERR_INVALID,
    HT_ERR_NOTFOUND
} HtStatus;

/* Creates an empty table. Returns NULL on allocation failure.
 * Caller owns the result; free with ht_destroy(). */
HashTable *ht_create(size_t initial_buckets);

/* Frees the table and everything it owns. Safe on NULL. */
void ht_destroy(HashTable *t);

/* Copies key and value into the table. Overwrites existing value.
 * On failure, the table is unchanged. */
HtStatus ht_put(HashTable *t, const char *key,
                const void *val, size_t val_len);

/* Returns pointer to stored value (borrowed; valid until next mutation)
 * or NULL if absent. Sets *val_len if non-NULL. */
const void *ht_get(const HashTable *t, const char *key, size_t *val_len);

/* Returns HT_OK if removed, HT_ERR_NOTFOUND otherwise. */
HtStatus ht_delete(HashTable *t, const char *key);

size_t ht_count(const HashTable *t);

/* Iteration without exposing internals. */
typedef void (*ht_visit_fn)(const char *key, const void *val,
                            size_t val_len, void *user);
void ht_foreach(const HashTable *t, ht_visit_fn fn, void *user);

#endif
```

#### Milestone skeleton: `src/hashtable.c`

```c
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "hashtable.h"

typedef struct Entry {
    char         *key;       /* owned */
    void         *val;       /* owned */
    size_t        val_len;
    struct Entry *next;
} Entry;

struct HashTable {
    Entry **buckets;         /* array of nbuckets Entry* (each a list head) */
    size_t  nbuckets;        /* always a power of two */
    size_t  count;
};

static uint64_t fnv1a(const char *s)
{
    uint64_t h = 1469598103934665603ULL;           /* FNV offset basis */
    for (; *s; s++) {
        h ^= (unsigned char)*s;
        h *= 1099511628211ULL;                      /* FNV prime */
    }
    return h;
}

static size_t bucket_index(const HashTable *t, const char *key)
{
    return (size_t)(fnv1a(key) & (t->nbuckets - 1));  /* power-of-2 mask */
}

/* The pointer-to-pointer idiom: no special case for removing the head. */
HtStatus ht_delete(HashTable *t, const char *key)
{
    Entry **link = &t->buckets[bucket_index(t, key)];
    while (*link) {
        Entry *e = *link;
        if (strcmp(e->key, key) == 0) {
            *link = e->next;            /* unlink */
            /* TODO: free e->key, e->val, e; t->count--; */
            return HT_OK;
        }
        link = &e->next;
    }
    return HT_ERR_NOTFOUND;
}

/* TODO: ht_create, ht_destroy, ht_put, ht_get, ht_count, ht_foreach */
```

> **Why power-of-two bucket counts?** `hash & (n-1)` is a single AND instruction, whereas `hash % n` is an integer division (an order of magnitude slower). The cost: a weak hash that varies only in the high bits will cluster, which is one reason FNV mixes bits well.

> **Why does the table copy keys/values?** If it stored the caller's pointers, any caller that freed or modified its buffer would corrupt the table (a dangling pointer). Copying gives the table a clear, self-contained **ownership** story. The cost is extra allocations, a trade-off real systems tune (arenas, interning).

#### Checkpoint 1

```c
HashTable *t = ht_create(16);
assert(ht_put(t, "a", "1", 2) == HT_OK);
assert(strcmp(ht_get(t, "a", NULL), "1") == 0);
assert(ht_delete(t, "a") == HT_OK);
assert(ht_get(t, "a", NULL) == NULL);
ht_destroy(t);          // run under valgrind: 0 leaks
```

---

### Part 2: Dynamic Resizing

#### Tasks

- [ ] After each `put`, if `count / nbuckets > 0.75`, **double** the bucket array.
- [ ] Implement `rehash()` by **relinking existing entries**, not reallocating them.
- [ ] Handle allocation failure during resize: the table must remain valid (skip the resize and keep working with longer chains).
- [ ] Add a stress test inserting 1,000,000 keys; verify all are retrievable.
- [ ] *(Optional)* Shrink when the load factor drops below 0.15, with hysteresis to avoid thrashing.

#### Milestone skeleton

```c
static HtStatus ht_resize(HashTable *t, size_t new_n)
{
    Entry **nb = calloc(new_n, sizeof *nb);     /* zeroed => all lists empty */
    if (!nb) return HT_ERR_NOMEM;               /* old table still intact */

    for (size_t i = 0; i < t->nbuckets; i++) {
        Entry *e = t->buckets[i];
        while (e) {
            Entry *next = e->next;              /* save BEFORE relinking */
            size_t j = (size_t)(fnv1a(e->key) & (new_n - 1));
            e->next = nb[j];                    /* push-front into new bucket */
            nb[j]   = e;
            e = next;
        }
    }
    free(t->buckets);
    t->buckets  = nb;
    t->nbuckets = new_n;
    return HT_OK;
}
```

> **Why double rather than grow by a constant?** Doubling gives **amortized O(1)** inserts: total work for n inserts is ~2n copies. Growing by +10 each time would make n inserts O(n²). This is the same reasoning behind `std::vector` and Python lists.

> **Why `calloc(new_n, sizeof *nb)`?** It zero-fills (NULL pointers = empty lists) *and* checks the multiplication `new_n * sizeof` for overflow, whereas `malloc(new_n * sizeof ...)` can silently wrap. Also note `sizeof *nb` instead of `sizeof(Entry *)`: it stays correct if the type changes.

---

### Part 3: REPL Command Layer

#### Tasks

- [ ] Read a line with `getline`, tokenize into command + args (handle double-quoted values with spaces).
- [ ] Implement `SET key value`, `GET key`, `DEL key`, `COUNT`, `KEYS`, `QUIT`.
- [ ] Case-insensitive command names.
- [ ] Use a **dispatch table of function pointers** instead of an `if/else if` chain:

```c
typedef int (*cmd_fn)(Store *s, int argc, char **argv);

typedef struct {
    const char *name;
    int         min_args, max_args;
    cmd_fn      handler;
} Command;

static const Command COMMANDS[] = {
    { "SET",   2, 2, cmd_set   },
    { "GET",   1, 1, cmd_get   },
    { "DEL",   1, 1, cmd_del   },
    { "COUNT", 0, 0, cmd_count },
    { "KEYS",  0, 0, cmd_keys  },
};
```

> **Why function pointers?** Adding a command becomes a one-line table entry, not a change to control flow. This pattern appears in every C codebase (kernel `file_operations`, driver tables, interpreters), so it's worth internalizing now.

**Careful with tokenizing:** if you use `strtok`, remember it **modifies** the buffer and is **not thread-safe**. Writing your own tokenizer that records `(start, len)` pairs is a good pointer exercise.

---

### Part 4: Persistence with an Append-Only Log

#### Design

Every mutation is appended to a log file **before** being applied in memory. On startup, replay the log to rebuild the table. This is how Redis AOF, Bitcask, and many databases work.

##### On-disk record format (little-endian)

```text
┌──────────┬──────┬─────────┬──────────┬─────────┬───────┬──────────┐
│ magic u32│ op u8│ klen u32│ vlen  u32│ key ... │ val...│ crc32 u32│
└──────────┴──────┴─────────┴──────────┴─────────┴───────┴──────────┘
  op: 1 = SET, 2 = DEL (vlen = 0 for DEL)
```

The CRC covers everything before it. On replay, a record with a bad CRC or truncated body means **the tail was torn by a crash**: stop replaying there and **truncate the file** to the last good offset.

#### Tasks

- [ ] Write a **file header** (magic + version) so you can reject unrelated files.
- [ ] Serialize records field-by-field with explicit-width ints (never `fwrite(&struct, ...)`: padding and endianness make it non-portable).
- [ ] Implement `log_append_set`, `log_append_del`, `log_replay`.
- [ ] After each write: `fflush(fp)` then `fsync(fileno(fp))`. Add a `sync` policy option (`always` / `never`) and measure the performance difference.
- [ ] Validate lengths on replay (`klen`, `vlen` ≤ sane limits such as 1 MB) **before** allocating.
- [ ] Implement CRC32 yourself (table-driven).

#### Milestone skeleton: `include/log.h`

```c
#include <stdint.h>
#include <stdio.h>

typedef enum { LOG_OP_SET = 1, LOG_OP_DEL = 2 } LogOp;

typedef struct Log Log;          /* opaque */

Log *log_open(const char *path);                 /* creates header if new */
int  log_append(Log *l, LogOp op, const char *key,
                const void *val, uint32_t vlen); /* 0 ok, -1 error */
void log_close(Log *l);

/* Calls cb for each valid record, in order. On a torn tail it truncates
 * the file at the last good offset. Returns #records, or -1 on I/O error. */
typedef int (*log_replay_cb)(LogOp op, const char *key,
                             const void *val, uint32_t vlen, void *user);
long log_replay(Log *l, log_replay_cb cb, void *user);
```

#### Milestone skeleton: serializing integers safely

```c
static void put_u32le(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v);        p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);  p[3] = (uint8_t)(v >> 24);
}
static uint32_t get_u32le(const uint8_t *p)
{
    return (uint32_t)p[0] | (uint32_t)p[1] << 8 |
           (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}
```

> **Why byte-by-byte instead of casting a pointer to `uint32_t *`?** Casting a `uint8_t *` buffer to `uint32_t *` can trigger **misaligned access** (UB; crashes on some CPUs) and **strict-aliasing violations**. Shifts are portable, endian-independent, and compilers turn them into a single load where legal.

> **Why `fflush` *and* `fsync`?** `fwrite` only copies into libc's user-space buffer. `fflush` hands the bytes to the kernel, which still caches them in RAM. Only `fsync` asks the kernel to push them to the device. Without it, power loss can discard writes you *thought* were saved.

---

### Part 5: Compaction & Crash Recovery

The log grows forever (every overwrite and delete adds records). **Compaction** rewrites a minimal log containing only live keys.

#### Tasks

- [ ] `kv_compact()`: write all live entries to `data.db.tmp`, `fsync` it, `rename("data.db.tmp", "data.db")`, then reopen.
- [ ] Understand why `rename` makes this **atomic**: readers see either the old file or the new one, never half of each.
- [ ] `fsync` the *directory* after rename for full durability (look up why).
- [ ] Trigger compaction automatically when `log_size > 4 × live_size`.
- [ ] Write the crash test: kill the process mid-write and verify recovery.

```bash
# tests/crash_test.sh (sketch)
for i in $(seq 1 200); do
    ./cask_bench data.db --writes 10000 &   # writes continuously
    pid=$!
    sleep 0.0$((RANDOM % 9))
    kill -9 $pid
    ./cask_verify data.db || { echo "CORRUPT after crash $i"; exit 1; }
done
```

---

## 6. Common Bugs & Pitfalls

| Bug | How it bites | Fix |
|-----|-------------|-----|
| **`p = realloc(p, n)`** | On failure returns NULL and **leaks** the original | `tmp = realloc(p, n); if (!tmp) {...} p = tmp;` |
| **Storing the caller's `key` pointer** | Dangling pointer when caller frees/reuses buffer | `strdup` (or `malloc`+`memcpy`) into the entry |
| **Use-after-free in `delete`** | Reading `e->next` after `free(e)` | Save `next` first (or unlink before freeing) |
| **Leaking on partial failure in `put`** | `strdup(key)` succeeds, `malloc(val)` fails → key leaked | Free in reverse order on each error path (`goto cleanup` idiom) |
| **Double free in `destroy`** | Freed value and also table-level pointer | Draw an ownership diagram before coding |
| **Resize: iterating a list while relinking** | Infinite loop / lost nodes | Save `next` before changing `e->next` |
| **`hash % nbuckets` with signed ints** | Negative index → memory corruption | Use `uint64_t`/`size_t` throughout |
| **`fwrite(&struct)`** | Padding bytes and endianness leak into file format | Serialize fields explicitly |
| **Trusting `klen`/`vlen` from disk** | Giant `malloc` → crash or DoS | Cap lengths; check `klen + vlen` for overflow |
| **Treating short `fread` as success** | Partially read record accepted | Compare return value to requested count |
| **`strncpy` misuse** | No terminating `\0` | Prefer `memcpy` + explicit terminator |
| **Binary values treated as C strings** | Embedded `\0` truncates values | Store `(ptr, len)`, not `char *` |
| **Not handling `SET key ""`** | `malloc(0)` may return NULL or unique ptr | Decide: store `NULL`+`len 0` consistently |

### The `goto cleanup` idiom (idiomatic C error handling)

```c
HtStatus ht_put(HashTable *t, const char *key, const void *val, size_t len)
{
    HtStatus rc = HT_ERR_NOMEM;
    Entry *e   = calloc(1, sizeof *e);
    if (!e) goto fail;
    e->key = strdup(key);          /* POSIX; or malloc+memcpy */
    if (!e->key) goto fail;
    e->val = malloc(len ? len : 1);
    if (!e->val) goto fail;
    memcpy(e->val, val, len);
    e->val_len = len;
    /* ... link into bucket, count++ ... */
    return HT_OK;
fail:
    if (e) { free(e->key); free(e->val); free(e); }   /* free(NULL) is fine */
    return rc;
}
```

> **Why `goto`?** C has no exceptions or destructors. A single cleanup label avoids duplicated free-chains, which are the #1 source of leaks on error paths. This is endorsed by the Linux kernel style guide.

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests

- [ ] put/get/overwrite/delete; delete-missing; get-missing
- [ ] Empty key, empty value, long key (10 KB), binary value with `\0`
- [ ] Insert 10,000 keys that all collide in a tiny table (`ht_create(1)`) to test chains
- [ ] Resize preserves every entry
- [ ] Destroy on empty and on large tables

### 7.2 Differential / property test

Maintain a trivial reference model (a plain array of `(key, val)` pairs with linear search). Apply 1 million random operations to both and compare after each step:

```c
for (int i = 0; i < 1000000; i++) {
    switch (rand() % 3) {
    case 0: /* PUT random key (small keyspace → many overwrites) */ break;
    case 1: /* DELETE random key */ break;
    case 2: /* GET random key, compare with model */ break;
    }
}
```

### 7.3 Valgrind and sanitizers

```bash
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes \
         --error-exitcode=1 ./build/test_hashtable
# or simply run the ASan/UBSan build; any report fails CI
```

Verify **bytes in use returns to 0** at exit. Deliberately break `ht_destroy` to see what a leak report looks like.

### 7.4 Persistence tests

- [ ] Write 1,000 keys, quit, restart: all present
- [ ] Delete keys, restart: still deleted (tombstones replayed correctly)
- [ ] Manually corrupt one byte in the middle (`printf '\xff' | dd of=data.db bs=1 seek=100 conv=notrunc`): replay stops at the bad record without crashing
- [ ] Truncate the file mid-record (`truncate -s -5 data.db`): torn-tail recovery
- [ ] Run the `kill -9` loop; confirm data is always a **prefix** of the operation history
- [ ] Hex-dump the file (`xxd data.db | head`) and verify it matches your format spec by eye

### 7.5 Performance experiments (record in `notes.md`)

| Experiment | Question |
|-----------|---------|
| Initial buckets 16 vs 1,000,000 | How much does resizing cost? |
| `fsync` on every write vs. never | How many ops/sec in each mode? |
| Replace FNV with a bad hash (`return len`) | How does chain length affect GET latency? |
| Print max/avg chain length | Is your hash distributing well? |

---

## 8. Stretch Goals

- [ ] TTL / key expiry with a min-heap
- [ ] Replace chaining with **open addressing** (linear probing + tombstones) and compare cache behavior
- [ ] Add an **arena allocator** for entries to cut `malloc` overhead and speed up `destroy`
- [ ] Fuzz the log parser with **libFuzzer** or **AFL++**
- [ ] Add a transaction batch (`BEGIN`/`COMMIT`) written as one atomic log record
- [ ] Reader/writer lock (preview of Project 4)

## 9. Definition of Done

- [ ] Library API documented in headers (ownership, lifetime, error behavior for each function)
- [ ] 1M-key stress test passes; zero leaks; zero sanitizer errors
- [ ] Data survives clean restarts **and** `kill -9` crashes
- [ ] Corrupted/truncated logs never crash the process
- [ ] `notes.md` includes an **ownership diagram** and benchmark table

➡️ **Next:** [Project 3: BMP Parser](../03_bmp_parser/README.md)
CURRICULUM_EOF_7f3a
cat > "$ROOT/03_bmp_parser/README.md" <<'CURRICULUM_EOF_7f3a'
# Project 3: `bmpkit`, a BMP Image Parser & Manipulator

**Level:** Intermediate | **Estimated time:** ~2 weeks | **Prev:** [Project 2](../02_kv_store/README.md) | **Next:** [Project 4](../04_http_server/README.md)

---

## 1. Overview

You will write a library and CLI that **reads, validates, transforms, and writes** uncompressed 24-bit BMP images **from raw bytes**, with no image libraries.

```bash
bmpkit info   photo.bmp
bmpkit gray   photo.bmp  out.bmp
bmpkit invert photo.bmp  out.bmp
bmpkit flip   photo.bmp  out.bmp --horizontal
bmpkit blur   photo.bmp  out.bmp --radius 2
bmpkit crop   photo.bmp  out.bmp 10 10 200 150
```

### Why this project matters for a C developer

Parsing binary formats is where C shines, and where C bites hardest. Every network protocol, file format, executable (ELF/PE), and device driver involves interpreting bytes with a precise layout. This project teaches you:

- How data is **physically laid out** in memory: padding, alignment, endianness.
- How to **safely parse untrusted input**: the root of most real-world CVEs.
- **Bitwise operations** and fixed-width integer types.
- How an image is "just" a `uint8_t` array indexed by arithmetic you design.

---

## 2. Core C Concepts Learned

- [ ] `<stdint.h>` fixed-width types (`uint8_t`, `uint16_t`, `uint32_t`, `int32_t`)
- [ ] Struct layout, **padding**, `#pragma pack` / `__attribute__((packed))`, `_Static_assert(sizeof...)`
- [ ] Endianness: reading little-endian data portably
- [ ] Bitwise operators `& | ^ ~ << >>`, masks, and shifts
- [ ] Binary file I/O: `fopen(..., "rb"/"wb")`, `fread`, `fwrite`, `fseek`, `ftell`
- [ ] Two-dimensional data in 1-D buffers: stride and index arithmetic
- [ ] Integer overflow and checked arithmetic with `size_t`
- [ ] Integer promotion and the usual arithmetic conversions
- [ ] Defensive parsing: validate-then-use
- [ ] Function pointers for pluggable image filters
- [ ] `memcpy` for type punning (instead of illegal pointer casts)
- [ ] Hex-dump tooling (`xxd`, `hexdump -C`) for debugging file formats

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Number representation** | Two's complement; why `int32_t height` can be negative |
| **Endianness** | Little vs. big endian; how to check yours; why BMP is little-endian |
| **Struct padding & alignment** | Why `sizeof(struct {uint8_t a; uint32_t b;})` is 8, not 5 |
| **Strict aliasing & unaligned access** | Why `*(uint32_t *)buf` can be UB; the `memcpy` workaround |
| **BMP format spec** | File header (14 B), DIB/Info header (40 B), pixel array, row padding, bottom-up storage, BGR byte order |
| **Pixel basics** | RGB, grayscale luminance (`0.299R + 0.587G + 0.114B`), 8-bit channels |
| **Integer promotion** | What happens when you add two `uint8_t` values |
| **Safe size arithmetic** | Multiplication overflow checks before `malloc(w * h * 3)` |
| **2D convolution** | Box blur and sliding windows (for the blur filter) |
| **`xxd` / `hexdump`** | Reading bytes by eye. Do this on a real `.bmp` first |

#### Create a test image and look at the bytes

```bash
convert -size 4x2 xc:red tests/fixtures/red_4x2.bmp   # ImageMagick
# Force 24-bit uncompressed BMP3:
convert -size 4x2 xc:red BMP3:tests/fixtures/red_4x2.bmp
xxd tests/fixtures/red_4x2.bmp
```

Annotate the hex dump by hand in `notes.md`: find the `42 4D` ("BM") signature, the offset to pixel data, the width/height, and the row padding bytes. **Do this before writing any code.**

---

## 4. BMP Format Cheat Sheet

```text
Offset  Size  Field                   Notes
------  ----  ----------------------  ------------------------------------
FILE HEADER (14 bytes)
0       2     signature               'B','M' (0x42 0x4D)
2       4     file_size               total bytes
6       2     reserved1               0
8       2     reserved2               0
10      4     data_offset             where pixel array begins

INFO HEADER / BITMAPINFOHEADER (40 bytes)
14      4     header_size             40
18      4     width                   int32; pixels
22      4     height                  int32; >0 = bottom-up, <0 = top-down
26      2     planes                  must be 1
28      2     bits_per_pixel          24 for this project
30      4     compression             0 = BI_RGB (none)
34      4     image_size              may be 0 for BI_RGB
38      4     x_pixels_per_meter
42      4     y_pixels_per_meter
46      4     colors_used
50      4     colors_important

PIXEL ARRAY (at data_offset)
  row stride = ((width * bpp + 31) / 32) * 4    ← each row padded to 4 bytes
  pixels are stored B, G, R (NOT R, G, B)
  rows are stored bottom-to-top when height > 0
```

---

## 5. Repository Directory Layout

```text
03_bmp_parser/
├── README.md
├── Makefile
├── include/
│   ├── bmp.h            # structs, Image type, load/save API
│   ├── endian_io.h      # le16/le32 read/write helpers
│   └── filters.h        # grayscale, invert, flip, blur, crop
├── src/
│   ├── bmp.c            # parse + serialize
│   ├── filters.c
│   └── main.c           # CLI dispatcher
├── tests/
│   ├── test_bmp.c
│   ├── test_filters.c
│   ├── gen_fixtures.sh  # builds fixtures with ImageMagick
│   ├── fuzz_corrupt.sh  # byte-flip fuzzing
│   └── fixtures/
│       ├── red_4x2.bmp  ├── gradient_5x3.bmp   # odd width → padding!
│       ├── 1x1.bmp      ├── topdown.bmp        # negative height
│       └── truncated.bmp  └── bad_magic.bmp
└── notes.md
```

---

## 6. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Read & validate headers; implement `bmpkit info` |
| 2 | Load pixel data into a heap `Image`; implement save; round-trip test |
| 3 | Pixel-wise filters: grayscale, invert, brightness |
| 4 | Geometric transforms: flip, rotate 90°, crop |
| 5 | Neighborhood filter: box blur (+ performance & bit-tricks) |
| *Bonus* | ELF header reader using the same techniques |

---

### Part 1: Parse & Validate Headers

#### Tasks

- [ ] Read the whole file size via `fseek(END)`/`ftell`, then `rewind`.
- [ ] Read the 14-byte and 40-byte headers **into byte buffers** and decode each field with explicit little-endian helpers (the portable approach), **or** use packed structs plus `_Static_assert` (the pragmatic approach). Implement both and note the trade-offs.
- [ ] Validate **every** field before trusting it: signature, header_size, planes == 1, bpp == 24, compression == 0, width > 0, height ≠ 0, `data_offset >= 54`, `data_offset <= file_size`.
- [ ] Compute row stride and total pixel bytes with **overflow checks**; confirm `data_offset + pixel_bytes <= file_size`.
- [ ] Implement `bmpkit info` to print dimensions, bpp, orientation, stride, and padding bytes per row.

#### Milestone skeleton: `include/bmp.h`

```c
#ifndef BMP_H
#define BMP_H

#include <stdint.h>
#include <stddef.h>

typedef struct {
    uint32_t width;       /* always positive after parsing */
    uint32_t height;      /* always positive; orientation normalized */
    uint8_t *pixels;      /* top-down, tightly packed B,G,R rows (no padding) */
                          /* owned by Image; freed by image_free() */
} Image;

typedef enum {
    BMP_OK = 0,
    BMP_ERR_IO,
    BMP_ERR_NOMEM,
    BMP_ERR_BAD_SIGNATURE,
    BMP_ERR_UNSUPPORTED,   /* bpp != 24, compression, etc. */
    BMP_ERR_CORRUPT,       /* sizes/offsets inconsistent, truncated */
    BMP_ERR_TOO_LARGE
} BmpStatus;

BmpStatus   bmp_load(const char *path, Image *out);   /* out zeroed on failure */
BmpStatus   bmp_save(const char *path, const Image *img);
void        image_free(Image *img);                   /* safe on zeroed Image */
const char *bmp_strerror(BmpStatus s);

#endif
```

> **Design decision, explained:** The in-memory `Image` is **normalized** to top-down, padding-free rows. The messy format details (bottom-up order, row padding) live *only* in `bmp_load`/`bmp_save`. Filters then deal with simple `pixels[(y*w + x)*3 + c]` indexing. Isolating the ugly parts of a format at the boundary is a core systems-design principle.

#### Milestone skeleton: packed headers (pragmatic approach)

```c
#include <assert.h>

#pragma pack(push, 1)                       /* no padding between fields */
typedef struct {
    uint16_t signature;                     /* 0x4D42 when read as LE */
    uint32_t file_size;
    uint16_t reserved1, reserved2;
    uint32_t data_offset;
} BmpFileHeader;

typedef struct {
    uint32_t header_size;
    int32_t  width, height;                 /* SIGNED */
    uint16_t planes, bpp;
    uint32_t compression, image_size;
    int32_t  x_ppm, y_ppm;
    uint32_t colors_used, colors_important;
} BmpInfoHeader;
#pragma pack(pop)

static_assert(sizeof(BmpFileHeader) == 14, "file header must be 14 bytes");
static_assert(sizeof(BmpInfoHeader) == 40, "info header must be 40 bytes");
```

> **Why packed structs are risky:** (1) They assume a little-endian host; on big-endian you must byte-swap. (2) Taking a pointer to a packed member (`&hdr.width`) can produce a misaligned pointer, which is UB on some CPUs. (3) Compilers differ on `#pragma pack`. The portable alternative is `get_u32le(buf + 18)`-style decoding. **Use `_Static_assert` either way**: it turns silent layout bugs into compile errors.

#### Milestone skeleton: `include/endian_io.h`

```c
static inline uint16_t rd_u16le(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}
static inline uint32_t rd_u32le(const uint8_t *p)
{
    return  (uint32_t)p[0]        | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static inline int32_t rd_i32le(const uint8_t *p)
{
    uint32_t u = rd_u32le(p);
    int32_t  s;
    memcpy(&s, &u, sizeof s);   /* well-defined reinterpretation */
    return s;
}
/* TODO: wr_u16le / wr_u32le for bmp_save */
```

> **Why cast to `uint32_t` *before* shifting?** `p[3]` is a `uint8_t`, which is promoted to `int`. `p[3] << 24` can shift into the sign bit of a 32-bit `int`: **signed overflow = undefined behavior**. UBSan will flag it. Casting first keeps the arithmetic unsigned and well-defined.

#### Checkpoint 1

```bash
./bmpkit info tests/fixtures/gradient_5x3.bmp
# Size: 5x3   BPP: 24   Orientation: bottom-up
# Row stride: 16 bytes (15 pixel bytes + 1 padding)
./bmpkit info tests/fixtures/bad_magic.bmp   # clear error, exit code != 0, no crash
```

---

### Part 2: Load Pixels & Round-Trip Save

#### Tasks

- [ ] Allocate `width * height * 3` bytes with **checked multiplication**.
- [ ] Read each row from the file using the **padded stride**, copying only the real pixel bytes into your tight buffer; skip padding with `fseek` or read into a scratch row.
- [ ] If `height > 0` (bottom-up), place file row `i` at `img.height - 1 - i`.
- [ ] Implement `bmp_save`: write headers (with computed `file_size`, `data_offset = 54`), then rows **bottom-up with zeroed padding**.
- [ ] **Round-trip test:** `load → save → load → compare pixels` is identical; `cmp` the files for canonical inputs.

#### Milestone skeleton

```c
/* Checked size computation: returns 0 on overflow, 1 on success. */
static int checked_mul_size(size_t a, size_t b, size_t *out)
{
    if (a != 0 && b > SIZE_MAX / a) return 0;
    *out = a * b;
    return 1;
}

static size_t row_stride(uint32_t width)       /* bpp fixed at 24 */
{
    return ((size_t)width * 24 + 31) / 32 * 4;
}

BmpStatus bmp_load(const char *path, Image *out)
{
    *out = (Image){0};
    FILE *fp = fopen(path, "rb");
    if (!fp) return BMP_ERR_IO;

    BmpStatus rc = BMP_ERR_CORRUPT;
    uint8_t  *row = NULL;

    /* 1. read + decode + validate headers (Part 1)
     * 2. compute stride, tight_size = w*h*3 with overflow check
     * 3. enforce a sanity cap, e.g. w,h <= 20000 and tight_size <= 1 GiB
     * 4. fseek(fp, data_offset, SEEK_SET)
     * 5. allocate img.pixels and a stride-sized scratch `row`
     * 6. for each file row: fread(row, 1, stride, fp) == stride ? else truncated
     *      memcpy into correct destination row
     */
    /* ... */
    free(row);
    fclose(fp);
    return rc;
}
```

> **Why cap dimensions even if arithmetic doesn't overflow?** A 40-byte header claiming `65535 x 65535` is valid arithmetic but requests ~12 GB. Untrusted input must never directly control allocation size without a policy limit. That is how decompression-bomb-style denial of service works.

#### Checkpoint 2

```bash
./bmpkit copy in.bmp out.bmp && cmp in.bmp out.bmp && echo "byte-identical"
```

(If the original has non-zero padding or extra header fields, compare via pixel data instead. Explain why in `notes.md`.)

---

### Part 3: Pixel Filters

#### Tasks

- [ ] Define a filter signature and apply it generically:

```c
typedef void (*PixelOp)(uint8_t *b, uint8_t *g, uint8_t *r, void *ctx);

void image_map(Image *img, PixelOp op, void *ctx)
{
    size_t n = (size_t)img->width * img->height;
    uint8_t *p = img->pixels;
    for (size_t i = 0; i < n; i++, p += 3)
        op(&p[0], &p[1], &p[2], ctx);
}
```

- [ ] **Invert:** `255 - v`, or equivalently `~v` (why does `~v` work for `uint8_t`? And what's the integer-promotion catch?)
- [ ] **Grayscale** using integer math, **no floating point**:

```c
/* Rec. 601 luma, scaled by 256: 0.299≈77/256, 0.587≈150/256, 0.114≈29/256 */
uint8_t y = (uint8_t)((77u * r + 150u * g + 29u * b) >> 8);
```

- [ ] **Brightness** with **saturating** add/subtract (clamp to 0-255).
- [ ] **Channel isolate** (`--only red`) and **channel swap** (swap R/B).
- [ ] **Threshold** (black/white) using a comparison and bitmask.

> **Why integer fixed-point instead of `float`?** It's faster on cores without strong FPUs, deterministic across platforms, and teaches you the scaled-integer technique used in codecs and embedded systems. The `>> 8` is a divide-by-256 that costs one instruction.

> **Why saturating arithmetic?** `uint8_t` arithmetic wraps: `250 + 10 == 4`, so a "brighter" pixel turns dark. Clamp explicitly: `int v = a + delta; v = v < 0 ? 0 : v > 255 ? 255 : v;`

---

### Part 4: Geometric Transforms

#### Tasks

- [ ] **Flip horizontal/vertical:** vertical swaps whole rows with `memcpy` through a temp row; horizontal swaps 3-byte pixels within each row.
- [ ] **Rotate 90° clockwise:** needs a **new buffer** of size `h x w` (why can't it be done in-place for non-square images?). Derive the mapping: `dst(x', y') = src(y, h-1-x')`-style, and *prove it on paper* with a 3x2 example.
- [ ] **Crop:** validate the rectangle is entirely inside the image before copying; use `memcpy` per row.
- [ ] **Resize (nearest-neighbor)** as a stretch.

#### Milestone skeleton

```c
static inline uint8_t *px(const Image *img, uint32_t x, uint32_t y)
{
    return img->pixels + ((size_t)y * img->width + x) * 3;
}

BmpStatus image_crop(const Image *src, uint32_t x, uint32_t y,
                     uint32_t w, uint32_t h, Image *dst)
{
    /* Careful: x + w can overflow uint32_t. Compare as: w <= src->width - x */
    if (x >= src->width || y >= src->height) return BMP_ERR_CORRUPT;
    if (w > src->width - x || h > src->height - y) return BMP_ERR_CORRUPT;
    /* TODO: allocate dst, copy h rows of w*3 bytes each */
    return BMP_OK;
}
```

> **Why `w > src->width - x` instead of `x + w > src->width`?** The latter can wrap around for huge `w` and pass the check wrongly. Rearranging so only a *safe subtraction* occurs (after verifying `x < width`) is the standard overflow-safe bounds-check pattern.

---

### Part 5: Box Blur & Performance

#### Tasks

- [ ] Implement an NxN box blur (radius r, window `(2r+1)²`) on a **separate output buffer**.
- [ ] Handle borders by clamping coordinates to the nearest edge.
- [ ] Write the naive O(w·h·r²) version first, verify visually, then optimize to **separable** two-pass O(w·h·r) (horizontal blur then vertical blur).
- [ ] Time with `clock_gettime(CLOCK_MONOTONIC)` and compare naive vs. separable.
- [ ] Build with `BUILD=release` for timing (sanitizers distort performance).

#### Milestone skeleton

```c
static inline int clampi(int v, int lo, int hi)
{
    return v < lo ? lo : (v > hi ? hi : v);
}

/* dst must be a distinct buffer from src, same size. */
void blur_naive(const Image *src, Image *dst, int radius)
{
    int w = (int)src->width, h = (int)src->height;
    int window = (2 * radius + 1) * (2 * radius + 1);
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++)
            for (int c = 0; c < 3; c++) {
                unsigned sum = 0;
                for (int dy = -radius; dy <= radius; dy++)
                    for (int dx = -radius; dx <= radius; dx++) {
                        int sx = clampi(x + dx, 0, w - 1);
                        int sy = clampi(y + dy, 0, h - 1);
                        sum += src->pixels[((size_t)sy * w + sx) * 3 + c];
                    }
                dst->pixels[((size_t)y * w + x) * 3 + c] = (uint8_t)(sum / window);
            }
}
```

> **Why a separate destination buffer?** Blurring in place would read pixels you've *already overwritten* in this pass, so results would depend on traversal order. Neighborhood operations need an immutable source.

> **Cache awareness:** The loops iterate `y` outer, `x` inner, matching row-major memory layout, so memory access is sequential. Swap the loop order and measure: for large images you will see a significant slowdown from cache misses. Record the numbers in `notes.md`.

---

### Bonus: ELF Header Reader

Apply the same discipline to `/bin/ls`. Read `Elf64_Ehdr` manually (don't include `<elf.h>` at first), print: class (32/64-bit), endianness (`e_ident[EI_DATA]`), type, machine, entry point, number of program/section headers. Compare to `readelf -h /bin/ls`.

---

## 7. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Ignoring row padding** | Image appears skewed / diagonal stripes | Always use `stride`, never `width*3`, when reading the *file* |
| **Rows in wrong order** | Image upside down | Remember bottom-up unless height < 0 |
| **Treating pixels as RGB** | Reds and blues swapped | BMP is **BGR** |
| **`height` as unsigned** | Top-down images rejected or huge allocation | Read as `int32_t`; normalize with `abs` carefully (`INT32_MIN`!) |
| **`abs(INT32_MIN)`** | UB / still negative | Reject `INT32_MIN` explicitly |
| **`fread` short count ignored** | Garbage pixels on truncated files | Compare to expected count; treat as `BMP_ERR_CORRUPT` |
| **`width * height * 3` in `int`** | Overflow → tiny malloc → heap overflow | Use `size_t` + `checked_mul_size` |
| **Trusting `file_size` field** | Lies in header | Compare to real size from `ftell` |
| **Trusting `data_offset`** | Reads outside file or into headers | Validate range |
| **Struct `fread` on packed header w/out `static_assert`** | Silent wrong offsets | `static_assert(sizeof(...) == N)` |
| **Signed shift overflow** | UBSan "left shift of ... cannot be represented" | Cast to `uint32_t` before shifting |
| **uint8_t arithmetic wraparound** | Dark pixels in bright areas | Widen to `int`, clamp, narrow |
| **In-place neighborhood filter** | Smeared / directional artifacts | Separate output buffer |
| **Leaking on error paths** | Valgrind loss in fuzz runs | `goto cleanup` pattern from Project 2 |
| **Using `ftell` result as `int`** | Fails on >2 GB files | Store in `long`/`off_t`, check for -1 |

---

## 8. Testing & Verification Exercises

### 8.1 Fixtures

Generate with ImageMagick in `tests/gen_fixtures.sh`:

```bash
convert -size 1x1   xc:red                    BMP3:fixtures/1x1.bmp
convert -size 5x3   gradient:red-blue         BMP3:fixtures/gradient_5x3.bmp   # padding case
convert -size 4x4   pattern:checkerboard      BMP3:fixtures/checker_4x4.bmp
convert -size 1000x800 plasma:fractal         BMP3:fixtures/big.bmp
```

Include **widths 1, 2, 3, 4, 5** to exercise all four padding amounts (0-3 bytes).

### 8.2 Unit tests

- [ ] `rd_u32le` on known byte patterns, including `0xFF FF FF FF` and `0x00 00 00 80`
- [ ] Stride calculation for widths 1..16: compare with a brute-force formula
- [ ] Round-trip for every fixture
- [ ] Each filter on a 2x2 image with hand-computed expected output (invert twice == identity; flip twice == identity; rotate 4x == identity)
- [ ] Crop boundaries: full-image crop, 1x1 crop at the corner, off-by-one-outside (must fail)

### 8.3 Malformed-input tests: required

Hand-craft or generate and assert **graceful errors, never crashes**:

- [ ] Empty file, 1-byte file, 13-byte file (shorter than the header)
- [ ] Wrong signature
- [ ] `data_offset` beyond EOF; `data_offset` < 54
- [ ] `width = 0`, `width = -5`, `height = INT32_MIN`, `width = 0x7FFFFFFF`
- [ ] Truncated pixel data (header OK, half the rows missing)
- [ ] `bpp = 8` or `32` (unsupported → clean error)
- [ ] `compression != 0`

### 8.4 Byte-flip fuzzing (simple but effective)

```bash
# tests/fuzz_corrupt.sh
for i in $(seq 1 2000); do
    cp fixtures/gradient_5x3.bmp /tmp/fz.bmp
    off=$((RANDOM % 80))                          # focus on header region
    printf "\\x$(printf %02x $((RANDOM % 256)))" | \
        dd of=/tmp/fz.bmp bs=1 seek=$off conv=notrunc 2>/dev/null
    ./bmpkit info /tmp/fz.bmp >/dev/null 2>&1
    rc=$?
    # 0 or 1 is acceptable. 139 (SIGSEGV) or 134 (abort/ASan) is a BUG.
    if [ $rc -ge 128 ]; then cp /tmp/fz.bmp crash_$i.bmp; echo "CRASH $i"; fi
done
```

Under ASan/UBSan, any report fails the run. Fix every crash and keep the file as a regression fixture.

### 8.5 Valgrind & visual verification

```bash
valgrind --leak-check=full --error-exitcode=1 ./bmpkit gray tests/fixtures/big.bmp /tmp/o.bmp
xxd /tmp/o.bmp | head -5                         # inspect headers by eye
compare -metric AE ours.bmp magick_out.bmp diff.png    # compare against ImageMagick's own result
```

For grayscale, allow a tiny tolerance (`-fuzz 2%`) because ImageMagick's coefficients differ slightly.

---

## 9. Stretch Goals

- [ ] Support **32-bit** (BGRA) and **8-bit palettized** BMPs
- [ ] Support the **V4/V5 headers** (`header_size` 108/124)
- [ ] Write a PPM/PGM exporter, then a simple **PNG writer** (stored deflate blocks + CRC32/Adler32)
- [ ] Sobel edge detection (3x3 convolution with signed kernels)
- [ ] Process rows in parallel with `pthread` (preview of Project 4) and measure speedup
- [ ] SIMD-friendly layout and `-O3 -march=native` benchmarks
- [ ] Complete the ELF reader: list section names from `.shstrtab`

## 10. Definition of Done

- [ ] `info`, `gray`, `invert`, `flip`, `rotate`, `crop`, `blur` all work and match expected outputs
- [ ] Parser rejects every malformed fixture cleanly: no crashes, no leaks, no sanitizer reports
- [ ] 2000-iteration byte-flip fuzz run finds no crashes
- [ ] No filter depends on host endianness
- [ ] `notes.md` documents: padding math, why each header field is validated, and benchmark of naive vs. separable blur

➡️ **Next:** [Project 4: Multithreaded HTTP Server](../04_http_server/README.md)
CURRICULUM_EOF_7f3a
cat > "$ROOT/04_http_server/README.md" <<'CURRICULUM_EOF_7f3a'
# Project 4: `tinyhttpd`, a Multithreaded HTTP Web Server

**Level:** Intermediate → Advanced | **Estimated time:** 3 weeks | **Prev:** [Project 3](../03_bmp_parser/README.md) | **Next:** [Project 5](../05_allocator/README.md)

---

## 1. Overview

You will build a static-file HTTP/1.1 server using only POSIX APIs: raw sockets, `pthread`, and a **thread pool** fed by a bounded work queue.

```bash
./tinyhttpd --port 8080 --root ./www --threads 8
curl -i http://localhost:8080/index.html
curl -i http://localhost:8080/../../etc/passwd     # must be refused (403/404)
ab -n 20000 -c 100 http://localhost:8080/index.html
```

### Why this project matters for a C developer

Servers combine *every* hard problem in systems programming at once:

- **Networking:** byte streams, partial reads/writes, protocol parsing.
- **Concurrency:** shared state, races, deadlocks, memory visibility.
- **Resource management:** file descriptors are finite; leaks kill servers.
- **Security:** every byte arriving on a socket is hostile until proven otherwise.
- **Signals and lifecycle:** graceful shutdown without losing in-flight work.

You will also see why C remains the language of choice for network infrastructure (nginx, Redis, memcached) and why it needs discipline.

---

## 2. Core C Concepts Learned

- [ ] POSIX sockets: `socket`, `setsockopt`, `bind`, `listen`, `accept`, `recv`, `send`, `close`, `shutdown`
- [ ] `getaddrinfo`, `struct sockaddr`, `sockaddr_in`, `htons`/`ntohs`, IPv4/IPv6 basics
- [ ] TCP as a **byte stream** (no message boundaries!)
- [ ] `pthread_create`, `pthread_join`, `pthread_mutex_t`, `pthread_cond_t`
- [ ] Bounded producer/consumer queue (ring buffer)
- [ ] Signal handling: `sigaction`, `volatile sig_atomic_t`, `SIGPIPE`, `SIGINT`
- [ ] Robust I/O helpers: handling `EINTR`, short reads/writes
- [ ] HTTP/1.x request parsing in a fixed-size buffer
- [ ] Filesystem safety: `realpath`, `open`, `fstat`, `O_RDONLY`, path-traversal defense
- [ ] Thread-safe programming: reentrant functions (`localtime_r`, `strerror_r`)
- [ ] Timeouts: `SO_RCVTIMEO`, `poll`
- [ ] Atomics (`<stdatomic.h>`) for counters
- [ ] ThreadSanitizer and Helgrind

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **TCP vs UDP** | Streams vs. datagrams; 3-way handshake; `TIME_WAIT` and why `SO_REUSEADDR` matters |
| **Client/server socket lifecycle** | The exact call order on each side. Read **Beej's Guide** chapters 1-7 |
| **Network byte order** | Big-endian on the wire; `htons`/`htonl` |
| **HTTP/1.1 basics (RFC 9112)** | Request line, headers, CRLF, blank line terminator, status codes, `Content-Length`, `Connection: close` vs. keep-alive |
| **File descriptors** | Per-process table, limits (`ulimit -n`), what `accept` returns |
| **`read`/`write` semantics** | Returning fewer bytes than requested is **normal** |
| **Threads vs. processes** | Shared address space; what's shared, what's per-thread (stack, `errno`) |
| **Mutexes & condition variables** | Why `pthread_cond_wait` needs a **loop**; spurious wakeups; lost wakeups |
| **Data races & memory model** | Why "it's just an int" is not safe; what a race is formally |
| **Deadlock** | Four Coffman conditions; lock ordering |
| **Signals** | Async-signal-safe functions only; why handlers should just set a flag |
| **Path traversal attacks** | `../`, URL-encoding (`%2e%2e`), symlinks, absolute paths |

---

## 4. Repository Directory Layout

```text
04_http_server/
├── README.md
├── Makefile
├── include/
│   ├── net.h            # listen_socket(), read_request(), write_all()
│   ├── http.h           # Request/Response types, parse, status text
│   ├── queue.h          # bounded blocking queue
│   ├── pool.h           # thread pool
│   ├── files.h          # path resolution + MIME types
│   └── log.h            # thread-safe logging
├── src/
│   ├── main.c           # config, signals, accept loop
│   ├── net.c
│   ├── http.c
│   ├── queue.c
│   ├── pool.c
│   ├── files.c
│   └── log.c
├── www/                 # sample site: index.html, style.css, image.png, big.bin
├── tests/
│   ├── test_queue.c     # multi-threaded queue stress test
│   ├── test_http_parse.c
│   ├── test_paths.c
│   └── smoke.sh         # curl/nc-based integration tests
└── notes.md
```

Link with `-pthread` (not just `-lpthread`): it sets both compile and link flags correctly.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Single-threaded echo/"hello" server: sockets from scratch |
| 2 | HTTP request parser (robust to partial reads and garbage) |
| 3 | Static file serving, MIME types, directory-traversal protection |
| 4 | Thread pool + bounded blocking queue |
| 5 | Hardening: signals, graceful shutdown, timeouts, limits, logging |

---

### Part 1: Single-Threaded Server

#### Tasks

- [ ] Create a listening TCP socket on a configurable port.
- [ ] `setsockopt(SO_REUSEADDR)` **before** `bind`.
- [ ] Accept connections in a loop; for each, read some bytes and reply with a fixed `200 OK` response containing "hello"; close the connection.
- [ ] Handle every error return with `perror` and appropriate cleanup.
- [ ] Ignore `SIGPIPE` (or use `MSG_NOSIGNAL`). Understand *why* a write to a closed socket kills your process by default.
- [ ] Write `write_all()` that loops until all bytes are sent.

#### Milestone skeleton: `src/net.c`

```c
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* Returns listening fd, or -1 (errno set). */
int listen_socket(uint16_t port, int backlog)
{
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;

    int yes = 1;
    if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes) < 0)
        goto fail;

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);          /* zero padding bytes too */
    addr.sin_family      = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port        = htons(port);     /* HOST → NETWORK byte order */

    if (bind(fd, (struct sockaddr *)&addr, sizeof addr) < 0) goto fail;
    if (listen(fd, backlog) < 0) goto fail;
    return fd;
fail: {
        int saved = errno;                  /* close() may clobber errno */
        close(fd);
        errno = saved;
        return -1;
    }
}

/* Writes exactly len bytes unless an error occurs. 0 = ok, -1 = error. */
int write_all(int fd, const void *buf, size_t len)
{
    const char *p = buf;
    while (len > 0) {
        ssize_t n = send(fd, p, len, MSG_NOSIGNAL);
        if (n < 0) {
            if (errno == EINTR) continue;   /* interrupted by signal: retry */
            return -1;
        }
        p   += n;                           /* partial write is NORMAL */
        len -= (size_t)n;
    }
    return 0;
}
```

> **Why `SO_REUSEADDR`?** After you kill the server, the kernel keeps the port in `TIME_WAIT` for up to ~60 s. Without this option, restarting gives `Address already in use`, and every beginner hits this.

> **Why `htons`?** Network byte order is big-endian; your CPU is probably little-endian. Forgetting `htons(8080)` binds you to port 36895 (`0x1F90` byte-swapped). `htons` is a no-op on big-endian machines, so you can't "test" for it only on your own computer, which is why it's in your muscle memory.

> **Why the `errno` save in `fail`?** `close()` can overwrite `errno` with its own result, so the caller would see a misleading error. Preserving the first error is idiomatic C error handling.

#### Checkpoint 1

```bash
./tinyhttpd --port 8080 &
curl -v http://localhost:8080/        # sees "hello"
ss -tlnp | grep 8080                   # confirm it's listening
echo "hi" | nc localhost 8080
```

---

### Part 2: HTTP Request Parser

#### Tasks

- [ ] Read from the socket **until** you find `\r\n\r\n` (end of headers) into a fixed buffer (e.g., 8 KB). Because TCP is a stream, a single `recv` may return half a request, or two pipelined ones.
- [ ] If the buffer fills before the terminator arrives → respond `431`/`400` and close.
- [ ] Parse the **request line**: `METHOD SP TARGET SP VERSION`. Support `GET` and `HEAD`; reply `405` for others, `400` for malformed, `505` for unsupported versions.
- [ ] Parse headers into a small array of `(name, value)` slices (pointers into the buffer plus lengths). Header names are case-insensitive.
- [ ] Reject: NUL bytes, bare `\n`, over-long lines, too many headers.
- [ ] Parse as **slices** (pointer + length) rather than copying strings. Zero allocations per request.

#### Milestone skeleton: `include/http.h`

```c
#include <stddef.h>

#define MAX_HEADER_BYTES 8192
#define MAX_HEADERS      32

typedef struct { const char *ptr; size_t len; } Slice;   /* NOT NUL-terminated */

typedef struct {
    Slice method, target, version;
    struct { Slice name, value; } headers[MAX_HEADERS];
    size_t nheaders;
} HttpRequest;          /* all Slices point INTO the raw request buffer */

typedef enum {
    PARSE_OK, PARSE_INCOMPLETE, PARSE_BAD_REQUEST,
    PARSE_TOO_LARGE, PARSE_BAD_VERSION
} ParseResult;

/* buf[0..len) holds bytes received so far. Does not modify buf. */
ParseResult http_parse_request(const char *buf, size_t len, HttpRequest *out);
```

#### Milestone skeleton: reading until headers complete

```c
/* Returns total bytes read (headers complete), 0 on clean close, -1 on error,
 * -2 if the header section exceeded cap. */
ssize_t read_request(int fd, char *buf, size_t cap)
{
    size_t used = 0;
    while (used < cap) {
        ssize_t n = recv(fd, buf + used, cap - used, 0);
        if (n == 0)  return used ? -1 : 0;          /* peer closed */
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;                              /* incl. EAGAIN on timeout */
        }
        used += (size_t)n;
        /* search for "\r\n\r\n" (only needs to scan the last n+3 bytes) */
        if (find_header_end(buf, used)) return (ssize_t)used;
    }
    return -2;
}
```

> **Why slices instead of `strdup`'d strings?** The request buffer already contains the bytes. Pointing into it avoids a `malloc`/`free` per field, which is faster, has no leak surface, and a *lifetime* rule that's easy to state: "slices are valid as long as the buffer is." The cost is that you must carry lengths, since these aren't NUL-terminated and `strlen`/`strcmp` don't work on them. Use `memcmp` and `strncasecmp` with explicit lengths.

> **Security note:** HTTP request smuggling, header injection, and buffer overflows all begin with sloppy parsers. Be **strict**: when in doubt, reject with 400.

---

### Part 3: Serving Static Files Safely

#### Tasks

- [ ] Map `GET /path` → `<root>/path`; `/` → `/index.html`.
- [ ] **URL-decode** `%XX` and **then** validate. Reject `%00`, and reject `..` segments after decoding.
- [ ] Resolve with `realpath()` and verify the result begins with `<root_realpath>/`. This also defeats symlink escapes.
- [ ] `open()` the file, `fstat()` the **fd** (not the path), and reject non-regular files (directories → 403/404).
- [ ] Send headers: `Content-Type` (by extension), `Content-Length` (from `st_size`), `Connection: close`, `Date`.
- [ ] Stream the body with a fixed-size buffer (64 KB) via `read` + `write_all`. **Do not** load whole files into memory.
- [ ] `HEAD` returns headers only.
- [ ] Optional: `sendfile(2)` for zero-copy transfer; measure the difference.

#### Milestone skeleton: path safety

```c
#include <limits.h>
#include <stdlib.h>
#include <string.h>

/* Returns 0 and fills out_path (resolved, inside root) or -1 on rejection.
 * root_real must itself be the realpath() of the document root, computed once
 * at startup. */
int resolve_path(const char *root_real, const char *decoded_target,
                 char *out_path, size_t out_cap)
{
    char joined[PATH_MAX];
    int n = snprintf(joined, sizeof joined, "%s%s", root_real, decoded_target);
    if (n < 0 || (size_t)n >= sizeof joined) return -1;      /* truncated */

    char *real = realpath(joined, NULL);       /* malloc'd result (POSIX.1-2008) */
    if (!real) return -1;                      /* nonexistent or unreadable */

    size_t rl = strlen(root_real);
    int ok = strncmp(real, root_real, rl) == 0 &&
             (real[rl] == '/' || real[rl] == '\0');   /* "/www" vs "/www-secret"! */
    if (ok && strlen(real) < out_cap) strcpy(out_path, real); else ok = 0;
    free(real);
    return ok ? 0 : -1;
}
```

> **Why the `real[rl] == '/'` check?** A naive prefix test would let `/srv/www-secret/key` pass for a root of `/srv/www`. Always compare **path components**, not raw string prefixes.

> **Why `fstat` on the open fd rather than `stat` on the path?** Between `stat(path)` and `open(path)` an attacker can swap the file for a symlink. This is a **TOCTOU** (time-of-check-to-time-of-use) race. Opening first, then checking the *descriptor*, closes the window. (`O_NOFOLLOW` and `openat2` give stronger options. Research them.)

---

### Part 4: Thread Pool & Bounded Queue

#### Architecture

```text
            ┌────────────┐   fd   ┌──────────────────┐   fd   ┌──────────────┐
 clients ──▶│ accept loop│──push─▶│ bounded FD queue │──pop──▶│ worker 1..N  │
            │ (main thd) │        │ mutex + 2 condvars│        │ handle(fd)   │
            └────────────┘        └──────────────────┘        └──────────────┘
```

**Why a pool, not thread-per-connection?** Thread creation costs time and stack memory (≈8 MB virtual each). Unbounded threads let an attacker exhaust memory or hit `RLIMIT_NPROC`. A fixed pool bounds resources; the **bounded queue** gives you *backpressure* (when the queue is full, you can reject with `503` instead of dying).

#### Tasks

- [ ] Implement a fixed-capacity ring-buffer queue of `int` fds with `mutex`, `not_empty`, `not_full`.
- [ ] `queue_push` blocks when full (or provide `queue_try_push` for the 503 path). `queue_pop` blocks when empty.
- [ ] Support **shutdown**: after `queue_close()`, pops drain remaining items then return "closed"; pushes fail. Wake all waiters with `pthread_cond_broadcast`.
- [ ] Create N worker threads at startup; each loops `pop → handle_connection → close`.
- [ ] Make logging thread-safe (a mutex around `fprintf`, or one `write` call per log line).
- [ ] Keep a global `atomic_ulong requests_served`; expose via `/status`.

#### Milestone skeleton: `include/queue.h` and `src/queue.c`

```c
#include <pthread.h>
#include <stdbool.h>
#include <stddef.h>

typedef struct {
    int             *items;      /* ring buffer, capacity slots */
    size_t           cap, head, tail, count;
    bool             closed;
    pthread_mutex_t  mu;
    pthread_cond_t   not_empty;
    pthread_cond_t   not_full;
} FdQueue;

int  fdq_init(FdQueue *q, size_t cap);
void fdq_destroy(FdQueue *q);
int  fdq_push(FdQueue *q, int fd);   /* 0 ok; -1 if closed */
int  fdq_pop (FdQueue *q, int *fd);  /* 0 ok; -1 if closed AND empty */
void fdq_close(FdQueue *q);
```

```c
int fdq_push(FdQueue *q, int fd)
{
    pthread_mutex_lock(&q->mu);
    while (q->count == q->cap && !q->closed)          /* WHILE, not IF */
        pthread_cond_wait(&q->not_full, &q->mu);
    if (q->closed) { pthread_mutex_unlock(&q->mu); return -1; }

    q->items[q->tail] = fd;
    q->tail = (q->tail + 1) % q->cap;
    q->count++;
    pthread_cond_signal(&q->not_empty);
    pthread_mutex_unlock(&q->mu);
    return 0;
}

int fdq_pop(FdQueue *q, int *fd)
{
    pthread_mutex_lock(&q->mu);
    while (q->count == 0 && !q->closed)
        pthread_cond_wait(&q->not_empty, &q->mu);
    if (q->count == 0) { pthread_mutex_unlock(&q->mu); return -1; }  /* closed+empty */
    /* TODO: take items[head], advance head, count--, signal not_full */
    pthread_mutex_unlock(&q->mu);
    return 0;
}
```

> **Why `while` and not `if` around `pthread_cond_wait`?** Condition variables can wake **spuriously**, and another thread may have consumed the item between the signal and your wakeup. The predicate must be **re-checked under the lock**. `if` here is the most common concurrency bug in beginner C code.

> **Why does `pthread_cond_wait` take the mutex?** It atomically *releases* the mutex and sleeps, then *re-acquires* it on wake. If those steps weren't atomic, a signal sent between "unlock" and "sleep" would be lost forever (a *lost wakeup*).

> **Who owns the fd?** Document it: the accept loop owns it until `push` succeeds; then the worker owns it and **must** `close` it on every path. An fd leak under load shows up as `accept: Too many open files`. Test with `ls /proc/$(pidof tinyhttpd)/fd | wc -l` before/after a load test.

#### Checkpoint 4

```bash
ab -n 20000 -c 100 http://localhost:8080/index.html      # 0 failed requests
ls /proc/$(pidof tinyhttpd)/fd | wc -l                   # roughly constant, not growing
```

---

### Part 5: Hardening & Graceful Shutdown

#### Tasks

- [ ] **Signals:** install `SIGINT`/`SIGTERM` handlers with `sigaction` (no `SA_RESTART`, so `accept` returns `EINTR`) that only set a `volatile sig_atomic_t stop` flag.
- [ ] On shutdown: stop accepting → `fdq_close` → `pthread_join` all workers (they finish in-flight requests) → free resources → exit `0`.
- [ ] **Timeouts:** `setsockopt(SO_RCVTIMEO/SO_SNDTIMEO)` ~5 s so a client who connects and sends nothing (**Slowloris**) can't pin a worker forever.
- [ ] **Limits:** max header bytes, max headers, max URL length; reject with proper status codes.
- [ ] **Backpressure:** if queue is full → `503 Service Unavailable` immediately and close.
- [ ] **Logging:** one line per request: time (`localtime_r`/`gmtime_r`), peer IP (`inet_ntop`), method, path, status, bytes, thread id.
- [ ] *(Stretch)* HTTP/1.1 keep-alive with an idle timeout.

#### Milestone skeleton: signals & accept loop

```c
static volatile sig_atomic_t g_stop = 0;

static void on_signal(int sig) { (void)sig; g_stop = 1; }   /* nothing else! */

static void install_signals(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_signal;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;                       /* no SA_RESTART: let accept() see EINTR */
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    signal(SIGPIPE, SIG_IGN);              /* or use MSG_NOSIGNAL everywhere */
}

/* accept loop */
while (!g_stop) {
    struct sockaddr_storage peer; socklen_t plen = sizeof peer;
    int cfd = accept(lfd, (struct sockaddr *)&peer, &plen);
    if (cfd < 0) {
        if (errno == EINTR) continue;                    /* re-check g_stop */
        if (errno == EMFILE || errno == ENFILE) { /* out of fds: back off briefly */ }
        perror("accept"); continue;
    }
    set_socket_timeouts(cfd, 5);
    if (fdq_push(&queue, cfd) < 0) { close(cfd); break; }
}
```

> **Why can a signal handler only set a flag?** Handlers interrupt your program at an arbitrary instruction, possibly *inside* `malloc` or `printf`. Calling those again from the handler can deadlock or corrupt state. Only **async-signal-safe** functions (see `man 7 signal-safety`) are allowed, and a `volatile sig_atomic_t` write is the canonical safe action.

> **Why `volatile sig_atomic_t`?** `volatile` stops the compiler from caching `g_stop` in a register so the loop never sees the update; `sig_atomic_t` guarantees the write/read isn't torn. (`volatile` is **not** a substitute for atomics or locks between *threads*. Use `<stdatomic.h>` there.)

---

## 6. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Assuming one `recv` = one request** | Works on localhost, fails over a real network | Loop until `\r\n\r\n` |
| **Assuming `send` writes everything** | Truncated big files | `write_all` loop |
| **Forgetting `SIGPIPE`** | Server dies when a client disconnects mid-response | `signal(SIGPIPE, SIG_IGN)` / `MSG_NOSIGNAL` |
| **`if` instead of `while` with condvar** | Rare crashes/hangs under load | Always re-check predicate in a loop |
| **Signal without holding lock / wrong order** | Lost wakeups, hangs | Pattern: lock → modify state → signal → unlock |
| **Not closing fds on error paths** | `EMFILE` after hours | One owner; `close` in a single exit path |
| **Passing pointer to a stack `int` to `pthread_create`** | Threads see changed/garbage value | Pass heap-allocated arg, or an index into a long-lived array |
| **Using `strtok`, `localtime`, `strerror`, `inet_ntoa`** | Races between threads, garbled logs | `_r` variants (`strtok_r`, `localtime_r`, `strerror_r`, `inet_ntop`) |
| **Unsynchronized shared counter (`count++`)** | Lost updates (data race = UB) | `atomic_fetch_add` or mutex |
| **Locking order inversion** | Deadlock | Document lock order; avoid holding two locks |
| **Holding the queue lock while doing I/O** | Serializes the whole server | Hold locks for the shortest time possible |
| **Path traversal (`../`, `%2e%2e`, symlinks)** | Arbitrary file disclosure | Decode → `realpath` → prefix + separator check |
| **Header buffer overflow** | Memory corruption | Track `used`/`cap` rigorously; never `strcpy` request data |
| **Using `Content-Length` from a request blindly** | Memory exhaustion | Cap it (even if you only support GET) |
| **Using `volatile` for thread sync** | Still racy | Use mutexes/atomics |
| **Forgetting `pthread_join`** | Use-after-free at shutdown | Join all workers before freeing shared structs |
| **Logging with unbounded `%s` of attacker input** | Log injection (`\r\n` forges lines) | Escape control characters |
| **`accept` loop spinning on `EMFILE`** | 100% CPU | Brief sleep / shed load |

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests (no network needed)

- [ ] **Queue stress test:** 4 producers push 1M integers total; 4 consumers pop; verify sum and count match (nothing lost/duplicated). Run for several seconds under TSan.
- [ ] **Parser tests:** valid GET/HEAD; missing version; lowercase method; header with no colon; 9 KB header; `\n`-only line endings; embedded NUL; tab/space edge cases.
- [ ] **Path tests:** `/`, `/a/../b`, `/%2e%2e/etc/passwd`, `/%00`, `//etc/passwd`, `/symlink-to-/etc`, a very long path.

### 7.2 Integration tests with `curl` & `nc`

```bash
curl -i  http://localhost:8080/index.html                  # 200 + correct Content-Length
curl -I  http://localhost:8080/index.html                  # HEAD: headers only
curl -i  --path-as-is http://localhost:8080/../etc/passwd  # must NOT succeed
curl -i  http://localhost:8080/%2e%2e/%2e%2e/etc/passwd    # must NOT succeed
curl -i  -X POST http://localhost:8080/                    # 405
curl -s  http://localhost:8080/big.bin | sha256sum         # equals sha256sum www/big.bin

printf 'GET / HTTP/1.1\r\nHost: x\r\n'  | nc localhost 8080   # incomplete → timeout
printf 'GARBAGE\r\n\r\n'                | nc localhost 8080   # 400
python3 -c "print('GET /' + 'A'*100000 + ' HTTP/1.1\r\n\r\n')" | nc localhost 8080   # 414/431/400
```

### 7.3 Concurrency & load

```bash
ab -n 50000 -c 200 http://localhost:8080/index.html     # ApacheBench
wrk -t4 -c200 -d30s http://localhost:8080/index.html    # if installed
# Slowloris-style: open 100 idle connections; the server should still serve others
for i in $(seq 100); do (sleep 30 | nc localhost 8080 &) ; done; curl localhost:8080/
```

With `--threads 4` and 100 idle sockets, can new requests still be served after the 5 s timeouts fire? Explain why or why not in `notes.md`. (This is the key limitation of thread-per-connection designs, and the motivation for `epoll`.)

### 7.4 Sanitizers & Valgrind

```bash
# ThreadSanitizer cannot be combined with ASan: use separate builds
make clean && make CFLAGS_EXTRA="-fsanitize=thread -g -O1" LDFLAGS="-fsanitize=thread"
./tinyhttpd --port 8080 & ab -n 20000 -c 50 http://localhost:8080/index.html; kill -INT %1

valgrind --tool=helgrind ./tinyhttpd --port 8080 --threads 4    # lock-order & races
valgrind --leak-check=full ./tinyhttpd --port 8080              # SIGINT then check report
```

**Goal:** TSan reports **0 data races**; Valgrind shows no leaks after graceful shutdown; fd count stays flat under load.

### 7.5 Debugging with GDB

```bash
gdb -p $(pidof tinyhttpd)
(gdb) info threads
(gdb) thread apply all bt        # where is every thread blocked? (diagnose deadlocks)
```

**Exercise:** Deliberately introduce a deadlock (lock order inversion) and a lost wakeup (replace `while` with `if`, remove a `signal`). Use `thread apply all bt` and TSan/Helgrind to diagnose each. Write up what you saw.

### 7.6 Strace for ground truth

```bash
strace -f -e trace=network,read,write,close -p $(pidof tinyhttpd)
```

Watch your server's real syscalls: confirm one `accept` per connection, a matching `close`, and observe short `write`s on large files.

---

## 8. Stretch Goals

- [ ] **Keep-alive** connections and request pipelining
- [ ] Switch to **`poll`/`epoll`** event loop (single-threaded, thousands of connections) and compare with the pool under 10k idle clients
- [ ] `Range` requests and `If-Modified-Since` / `ETag` caching
- [ ] IPv6 via `getaddrinfo` (dual-stack)
- [ ] Simple **CGI** support using `fork`/`execve`/pipes (and carefully sanitized environment)
- [ ] TLS via OpenSSL/mbedTLS
- [ ] Per-IP rate limiting with the hash table from Project 2
- [ ] Use your Project 5 allocator via `LD_PRELOAD` under load

## 9. Definition of Done

- [ ] Serves files correctly, with correct headers and MIME types, including large (>1 GB sparse) files
- [ ] Rejects traversal attacks and malformed requests with proper status codes
- [ ] 50k requests @ 200 concurrency: 0 failures, flat fd count, flat memory
- [ ] **ThreadSanitizer-clean**; no leaks after graceful `SIGINT` shutdown
- [ ] Idle/slow clients can't hold a worker indefinitely
- [ ] `notes.md` documents ownership of fds, lock hierarchy, and your findings from the deliberate-deadlock exercise

➡️ **Next:** [Project 5: Memory Allocator](../05_allocator/README.md)
CURRICULUM_EOF_7f3a
cat > "$ROOT/05_allocator/README.md" <<'CURRICULUM_EOF_7f3a'
# Project 5: `mymalloc`, a Custom Memory Allocator

**Level:** Advanced | **Estimated time:** 3-4 weeks | **Prev:** [Project 4](../04_http_server/README.md) | **Back to:** [Curriculum Home](../README.md)

---

## 1. Overview

You will implement your own `malloc`, `free`, `calloc`, and `realloc`, and then inject them into **real programs** (`ls`, `python`, your own HTTP server from Project 4) using `LD_PRELOAD`:

```bash
LD_PRELOAD=./libmymalloc.so ls -la /usr
LD_PRELOAD=./libmymalloc.so ./tinyhttpd --port 8080
```

### Why this project matters for a C developer

Every Project so far *used* the heap. Now you build it. Writing an allocator forces you to:

- Understand what a **pointer actually is**: an address in a virtual address space you manage.
- Learn how the OS provides memory: `brk`/`sbrk` and `mmap`.
- Master **alignment**, **pointer arithmetic**, and **type punning** without falling into undefined behavior.
- Weigh classic systems trade-offs: **speed vs. fragmentation vs. metadata overhead vs. safety**.
- Debug bugs where the debugger's own tools (Valgrind/ASan) are *replaced by the thing you are writing*.

After this project, "`malloc` is slow", "heap fragmentation", "use-after-free exploit", and "arena allocator" will be concrete concepts, not buzzwords.

---

## 2. Core C Concepts Learned

- [ ] Virtual memory, the process address space (text/data/heap/mmap/stack)
- [ ] System calls: `sbrk`/`brk`, `mmap`/`munmap`, `getpagesize`/`sysconf(_SC_PAGESIZE)`
- [ ] Pointer arithmetic with `char *` / `uint8_t *` / `uintptr_t`
- [ ] Alignment requirements; `_Alignof`, `max_align_t`; aligned rounding with bit masks
- [ ] Block headers/footers ("boundary tags"), size-and-flag packing in low bits
- [ ] Intrusive linked lists (list nodes stored **inside** free blocks)
- [ ] Allocation policies: first-fit, next-fit, best-fit, segregated lists
- [ ] Splitting and **coalescing** blocks; internal vs. external fragmentation
- [ ] `size_t` overflow in `calloc`; `realloc` edge-case semantics
- [ ] Thread-safety: a global lock vs. per-thread arenas
- [ ] Shared-library interposition (`-shared -fPIC`, `LD_PRELOAD`, `dlsym(RTLD_NEXT)`)
- [ ] Writing a **heap consistency checker** (invariants as code)
- [ ] Why `printf` inside an allocator is dangerous (reentrancy); use `write(2)`
- [ ] Valgrind client requests / poisoning for allocator debugging

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Virtual memory** | Pages (4 KiB), page tables conceptually, demand paging, why `malloc` of 1 GB "succeeds" instantly (overcommit). CS:APP ch. 9 |
| **`brk`/`sbrk`** | The "program break"; heap grows upward; contiguous only; `man 2 brk` |
| **`mmap` anonymous** | `MAP_PRIVATE \| MAP_ANONYMOUS`; returned memory is zeroed; page-granular; can be returned with `munmap` |
| **glibc malloc overview** | Arenas, bins, chunks, `M_MMAP_THRESHOLD`. Skim "Understanding glibc malloc" write-ups |
| **Alignment** | Why `malloc` must return 16-byte aligned memory on x86-64; misaligned SSE access faults |
| **Data structure alignment & padding** | `offsetof`, `sizeof` of structs |
| **Implicit vs. explicit free lists** | CS:APP §9.9 is **required reading** |
| **Fragmentation** | Internal vs. external; why coalescing helps; pathological patterns |
| **Pointer provenance & strict aliasing** | Why you must treat the raw arena as `char` bytes and cast carefully |
| **Bit tricks** | `(n + 15) & ~15`; low bits of aligned sizes are free flag storage |
| **Dynamic linking & `LD_PRELOAD`** | How symbol resolution lets you replace `malloc` |
| **`errno` and `ENOMEM`** | What `malloc` should do on failure |

> **Required reading before Part 2:** CS:APP 3rd ed., **Section 9.9: Dynamic Memory Allocation**, covering implicit free list, placement, splitting, coalescing with boundary tags.

---

## 4. Repository Directory Layout

```text
05_allocator/
├── README.md
├── Makefile
├── include/
│   ├── mymalloc.h         # public API: mm_malloc, mm_free, ... (+ malloc names for preload)
│   ├── block.h            # header layout, flag macros, neighbor navigation
│   ├── freelist.h         # free-list operations
│   └── debug.h            # mm_check(), mm_dump(), tracing macros
├── src/
│   ├── mymalloc.c         # core allocator
│   ├── block.c
│   ├── freelist.c
│   ├── os_mem.c           # sbrk / mmap wrappers (the only OS-touching file)
│   ├── debug.c
│   └── preload.c          # exports malloc/free/calloc/realloc for LD_PRELOAD
├── tests/
│   ├── test_basic.c
│   ├── test_stress.c      # randomized alloc/free/realloc with patterns
│   ├── test_edge.c        # zero size, huge size, NULL, alignment
│   ├── traces/            # recorded alloc/free traces + replay driver
│   ├── bench.c
│   └── run_preload.sh
└── notes.md
```

> **Why isolate `os_mem.c`?** All OS interaction (how we obtain raw memory) lives in one file with a two-function interface (`os_grow(size)` / `os_release`). You can swap `sbrk` for `mmap` (or a static array for testing!) without touching allocator logic. A **static 1 MB array as the backing store** is a great way to debug deterministically before using real syscalls.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Bump allocator: get memory from the OS, alignment, `free` is a no-op |
| 2 | Block headers + free list: real `free`, first-fit reuse |
| 3 | Splitting & coalescing; heap consistency checker |
| 4 | `calloc`, `realloc`, large allocations via `mmap`, optional performance upgrades |
| 5 | Thread safety, debugging features, `LD_PRELOAD` integration, benchmarks |

---

### Part 1: Bump Allocator

#### Tasks

- [ ] Implement `os_grow(size_t n)` using `sbrk` (check for `(void *)-1`). Round request up to page size multiples.
- [ ] Maintain a "current chunk" with `cur` and `end` pointers; allocation = round size up to 16, advance `cur`.
- [ ] If the current chunk is exhausted, request more from the OS.
- [ ] `free()` does nothing (for now). Write a test that exhausts memory in a loop to *prove* why that's insufficient.
- [ ] Verify every returned pointer is 16-byte aligned (assert in tests).
- [ ] Return `NULL` and set `errno = ENOMEM` on failure.

#### Milestone skeleton

```c
#include <stddef.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>

#define ALIGNMENT 16u
#define ALIGN_UP(n)  (((n) + (ALIGNMENT - 1)) & ~(size_t)(ALIGNMENT - 1))

static uint8_t *cur, *end;

static int grow_heap(size_t need)
{
    size_t page = (size_t)sysconf(_SC_PAGESIZE);
    size_t chunk = (need + page - 1) / page * page;
    void *p = sbrk((intptr_t)chunk);
    if (p == (void *)-1) return -1;
    /* NOTE: other code may have moved the break; handle non-contiguous growth */
    if ((uint8_t *)p != end) cur = (uint8_t *)p;   /* new region isn't adjacent */
    end = (uint8_t *)p + chunk;
    return 0;
}

void *mm_malloc(size_t size)
{
    if (size == 0) return NULL;                  /* one allowed behavior */
    if (size > SIZE_MAX - ALIGNMENT) { errno = ENOMEM; return NULL; }  /* overflow */
    size_t need = ALIGN_UP(size);
    if ((size_t)(end - cur) < need && grow_heap(need) != 0) {
        errno = ENOMEM; return NULL;
    }
    void *p = cur;
    cur += need;
    return p;
}
```

> **Why 16-byte alignment?** On x86-64 the ABI guarantees `malloc` results are suitably aligned for *any* standard type (`max_align_t` is 16 bytes, for `long double` and SSE types). Code compiled with `-O2` may use aligned vector instructions (`movaps`) on your pointer and **fault** if it's misaligned.

> **Why `ALIGN_UP` via mask instead of `%` and `/`?** `(n + 15) & ~15` is two cheap ALU operations and works because alignment is a power of two. Make sure you can explain *why* adding 15 then clearing the low 4 bits rounds up.

> **Why check `size > SIZE_MAX - ALIGNMENT` first?** Otherwise `size + 15` wraps to a tiny number, you hand back a 16-byte block for a request of ~2^64 bytes, and the caller writes far out of bounds. Integer overflow in allocators is a classic **security vulnerability**.

#### Checkpoint 1

```c
void *a = mm_malloc(1), *b = mm_malloc(17);
assert(((uintptr_t)a % 16) == 0 && ((uintptr_t)b % 16) == 0);
assert((uint8_t *)b - (uint8_t *)a == 16);
```

---

### Part 2: Block Headers & a Free List

#### Design

Each allocation is preceded by a **header** storing its size and whether it's free. `free(p)` finds the header by stepping back from `p`, and marks the block free so `malloc` can reuse it.

```text
          ┌──────── header ────────┐┌──────────── payload ───────────┐
 heap:    │ size │ is_free │ next │ prev ││ user data ...                │
          └─────────────────────────┘└──────────────────────────────────┘
          ▲                          ▲
          block start                pointer returned to caller (16-aligned)
```

You'll first use a simple **doubly-linked list of ALL blocks** in address order (simple, makes coalescing easy). In Part 5 you may upgrade to boundary tags + explicit free list.

#### Tasks

- [ ] Define `BlockHeader` and ensure `sizeof(BlockHeader)` is a **multiple of 16** (so payload stays aligned). Enforce with `_Static_assert`.
- [ ] Implement helpers: `header_of(void *payload)`, `payload_of(Block *b)`.
- [ ] `mm_malloc`: scan the block list for the first free block with `size >= need` (**first-fit**); otherwise extend the heap and append a new block.
- [ ] `mm_free`: `free(NULL)` is a no-op; otherwise mark free. **Detect double free** (header already free → abort with message via `write(2)`).
- [ ] Add a `magic` field or validate that the pointer lies within the heap before trusting the header.

#### Milestone skeleton: `include/block.h`

```c
#include <stddef.h>
#include <stdint.h>

typedef struct Block {
    size_t        size;      /* payload bytes (multiple of 16) */
    size_t        is_free;   /* 0/1 (size_t to keep header 16-multiple) */
    struct Block *next;      /* next block in ADDRESS order */
    struct Block *prev;
} Block;                     /* 32 bytes on LP64 */

_Static_assert(sizeof(Block) % 16 == 0, "header must preserve alignment");

#define HDR_SIZE  (sizeof(Block))

static inline void *payload_of(Block *b)  { return (uint8_t *)b + HDR_SIZE; }
static inline Block *header_of(void *p)   { return (Block *)((uint8_t *)p - HDR_SIZE); }
```

> **Why must the header size be a multiple of 16?** The caller receives `block + HDR_SIZE`. If the block start is 16-aligned and the header is, say, 24 bytes, the payload is only 8-aligned, so you've silently broken the ABI contract.

> **Why `uint8_t *` (or `char *`) arithmetic, never `void *`?** Arithmetic on `void *` is a GNU extension, not standard C. `char`-type pointers also have special aliasing privileges, making byte-level arithmetic well-defined.

> **Metadata overhead:** 32-byte headers on a 16-byte allocation = 200% overhead. Real allocators use 8-16 bytes (and glibc reuses the *footer* space of the previous chunk). In Part 5 you'll measure and reduce this.

---

### Part 3: Splitting, Coalescing & the Heap Checker

#### Tasks

- [ ] **Split:** when a free block is much larger than needed (leftover ≥ `HDR_SIZE + 16`), carve it into an allocated part and a **new free remainder** with its own header.
- [ ] **Coalesce on free:** if the next block (by address) is free **and physically adjacent**, merge; same for the previous block. Merge **both directions**.
- [ ] Careful: blocks from separate `sbrk` regions may not be adjacent. Verify `(uint8_t*)b + HDR_SIZE + b->size == (uint8_t*)b->next` before merging.
- [ ] Implement **`mm_check()`**, a heap invariant checker (see below). Call it after *every* operation in tests.
- [ ] Add a `mm_dump()` that prints the heap layout using `write(2)`/`snprintf`, not `printf`.

#### Milestone skeleton

```c
static void split_block(Block *b, size_t need)
{
    if (b->size >= need + HDR_SIZE + ALIGNMENT) {          /* worth splitting? */
        Block *rest = (Block *)((uint8_t *)payload_of(b) + need);
        rest->size    = b->size - need - HDR_SIZE;
        rest->is_free = 1;
        rest->next    = b->next;
        rest->prev    = b;
        if (b->next) b->next->prev = rest;
        b->next = rest;
        b->size = need;
    }
}

static Block *coalesce(Block *b)
{
    /* forward merge */
    if (b->next && b->next->is_free && adjacent(b, b->next)) {
        b->size += HDR_SIZE + b->next->size;
        b->next  = b->next->next;
        if (b->next) b->next->prev = b;
    }
    /* backward merge */
    if (b->prev && b->prev->is_free && adjacent(b->prev, b)) {
        b = b->prev;
        /* TODO: same merge, absorbing the (old) b into b->prev */
    }
    return b;
}
```

#### The heap consistency checker: your most valuable tool

```c
/* Returns 0 if the heap is consistent, else a nonzero code (and prints why). */
int mm_check(void)
{
    for (Block *b = heap_head; b; b = b->next) {
        /* 1. payload pointer is 16-byte aligned                                */
        /* 2. size is a multiple of 16 and >= 16                                */
        /* 3. block lies entirely within [heap_lo, heap_hi)                     */
        /* 4. b->next->prev == b  (list links are mutually consistent)          */
        /* 5. no two ADJACENT blocks are both free (coalescing is complete)     */
        /* 6. if next block is adjacent: b + HDR + size == next                 */
        /* 7. is_free is exactly 0 or 1                                         */
    }
    return 0;
}
```

> **Why write an invariant checker?** Allocator bugs corrupt metadata *silently*, then crash 10,000 operations later in an unrelated place. A checker that runs after every operation converts "random crash much later" into "fails on the exact operation that broke the heap." Professional allocator developers consider this non-optional.

> **Why does the previous block need to be free *and* adjacent before merging?** The list links blocks in address order, but each `sbrk` call can return a **non-contiguous** region (something else moved the break). Merging across a gap would make you "own" memory that isn't yours.

#### Checkpoint 3

```c
void *a = mm_malloc(100), *b = mm_malloc(100), *c = mm_malloc(100);
mm_free(a); mm_free(c); mm_free(b);   /* order matters: tests both merge directions */
assert(mm_check() == 0);
assert(count_blocks() == 1);          /* everything coalesced into one free block */
```

---

### Part 4: `calloc`, `realloc`, and Large Allocations

#### Tasks

- [ ] **`mm_calloc(n, size)`**: check `n * size` for overflow **before** multiplying; zero the memory (fresh `mmap` pages are already zero, so recycled blocks need `memset`).
- [ ] **`mm_realloc(p, new_size)`** with all the edge cases:
  - `p == NULL` → behaves like `malloc(new_size)`
  - `new_size == 0` → behaves like `free(p)` and returns `NULL` (document your choice)
  - shrink → split in place if worthwhile
  - grow → try to **expand in place** by absorbing a free adjacent next block; otherwise `malloc` new + `memcpy(min(old,new))` + `free` old
  - on failure, **the original block must remain valid**
- [ ] **Large allocations via `mmap`**: if `size ≥ 128 KiB` (tune it), `mmap` a dedicated region (header + payload, page-rounded), mark it `is_mmapped`, and `munmap` on free. This avoids fragmenting the main heap and returns memory to the OS.
- [ ] *(Performance, optional)* **Segregated free lists** (size classes 16, 32, 48, ..., 512, then powers of two) for O(1) typical allocation, or **best-fit** to reduce fragmentation. Benchmark each policy.
- [ ] *(Optional)* Shrink the heap by `sbrk(-n)` when the top block is free and large.

#### Milestone skeleton

```c
void *mm_calloc(size_t n, size_t size)
{
    if (size != 0 && n > SIZE_MAX / size) { errno = ENOMEM; return NULL; }
    size_t total = n * size;
    void *p = mm_malloc(total);
    if (p) memset(p, 0, total);       /* skip for fresh mmap'd blocks (already zero) */
    return p;
}

void *mm_realloc(void *p, size_t new_size)
{
    if (!p)            return mm_malloc(new_size);
    if (new_size == 0) { mm_free(p); return NULL; }

    Block *b = header_of(p);
    size_t need = ALIGN_UP(new_size);
    if (b->size >= need) { /* TODO: shrink via split_block */ return p; }

    /* TODO: try to absorb b->next if free, adjacent, and big enough */

    void *q = mm_malloc(new_size);
    if (!q) return NULL;              /* original untouched, still valid */
    memcpy(q, p, b->size < new_size ? b->size : new_size);
    mm_free(p);
    return q;
}
```

#### Upgrade path: boundary tags (reduce overhead from 32 → 8-16 bytes)

Replace the all-blocks linked list with **header + footer** words:

```text
   [ hdr: size|alloc ][ payload ... ][ ftr: size|alloc ]
```

- Pack `alloc` into bit 0 of `size` (sizes are multiples of 16, so the low 4 bits are always zero, **free metadata space**).
- The *next* block is at `(char*)b + size`; the *previous* block's size lives in the word just before your header.
- Free blocks reuse their (otherwise unused) payload to store `next_free`/`prev_free` pointers → an **explicit free list** of only free blocks, so `malloc` doesn't walk allocated blocks.

```c
#define PACK(size, alloc)  ((size) | (alloc))
#define GET_SIZE(w)        ((w) & ~(size_t)0xF)
#define GET_ALLOC(w)       ((w) & 0x1)
```

> **Why `memcpy` and not `memmove` in `realloc`?** The old and new blocks are guaranteed distinct, non-overlapping allocations, so `memcpy` is correct and potentially faster. If you had **in-place expansion**, you'd skip the copy altogether. Know *when* each is legal.

> **Why must `realloc` leave the original intact on failure?** Callers write `tmp = realloc(p, n); if (!tmp) { handle; free(p); }`. If you freed `p` before failing, you'd create a double-free in correct client code. (This is exactly the bug from Project 2's pitfalls table, now seen from the *other side*.)

---

### Part 5: Thread Safety, Debug Features, Preload & Benchmarks

#### Tasks

**Thread safety**
- [ ] Protect all allocator state with one global `pthread_mutex_t` (simplest correct design).
- [ ] Measure contention using your Project 4 server or a multi-threaded benchmark.
- [ ] *(Stretch)* Per-thread caches (`__thread` storage) that grab batches from the global heap, the idea behind tcmalloc/jemalloc.

**Debug features** (compile-time switch `-DMM_DEBUG`)
- [ ] **Canaries:** write a known pattern (`0xDEADBEEF...`) after each payload; verify on `free` to detect heap overflows.
- [ ] **Poison on free:** `memset(p, 0xDD, size)` to make use-after-free visible fast.
- [ ] **Poison on alloc:** fill new blocks with `0xAA` so reading uninitialized memory yields obviously wrong values.
- [ ] **Double-free and invalid-free detection** (pointer not in heap / bad magic).
- [ ] Allocation counters and `mm_stats()`: bytes in use, peak usage, fragmentation ratio.

**`LD_PRELOAD` integration** (`src/preload.c`)
- [ ] Export `malloc`, `free`, `calloc`, `realloc` (and ideally `posix_memalign`, `aligned_alloc`, `memalign`) with the standard names.
- [ ] Build `libmymalloc.so` (`-shared -fPIC`).
- [ ] Test with real programs: `ls`, `cat`, `sort`, `python3 -c "print(sum(range(10**6)))"`, `gcc`, and your Project 4 server.
- [ ] Handle **reentrancy during startup**: libc/`dlsym` may call `malloc` before your allocator initializes. Use lazy init guarded by the mutex, and a tiny static bootstrap buffer if needed.
- [ ] **Never call `printf`, `fprintf`, or anything that mallocs from inside the allocator**; it recurses infinitely or deadlocks on your own mutex. Use `write(2, ...)` and a hand-rolled integer-to-string.

#### Milestone skeleton: `src/preload.c`

```c
#include <stddef.h>
#include "mymalloc.h"

void *malloc(size_t n)               { return mm_malloc(n); }
void  free(void *p)                  { mm_free(p); }
void *calloc(size_t n, size_t s)     { return mm_calloc(n, s); }
void *realloc(void *p, size_t n)     { return mm_realloc(p, n); }

/* TODO: posix_memalign, aligned_alloc, memalign, malloc_usable_size */
```

```bash
gcc -shared -fPIC -O2 -o libmymalloc.so src/*.c -pthread
LD_PRELOAD=./libmymalloc.so ls -l /
```

#### Milestone skeleton: async-safe debug printing

```c
#include <unistd.h>
static void dbg_write_hex(int fd, uintptr_t v)
{
    char buf[2 + sizeof v * 2];
    size_t i = sizeof buf;
    do { buf[--i] = "0123456789abcdef"[v & 0xF]; v >>= 4; } while (v);
    buf[--i] = 'x'; buf[--i] = '0';
    (void)!write(fd, buf + i, sizeof buf - i);
}
```

> **Why can't valgrind/ASan verify your allocator?** They *intercept* `malloc`/`free` themselves. When you replace them, the tools either bypass your code or are confused by your heap games. Use your own `mm_check()`, canaries, and poison patterns, and optionally the Valgrind **client-request macros** (`VALGRIND_MALLOCLIKE_BLOCK`, `VALGRIND_FREELIKE_BLOCK`) to teach Valgrind about your blocks.

---

## 6. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Header not a multiple of 16** | Crashes in SSE/AVX code (`movaps`), only at `-O2` | `_Static_assert(sizeof(Block) % 16 == 0)` |
| **`size + ALIGNMENT - 1` overflow** | Tiny block for a gigantic request → heap overflow | Check against `SIZE_MAX` first |
| **`n * size` overflow in `calloc`** | Same, via the classic CVE pattern | `n > SIZE_MAX / size` check |
| **Forgetting header size when splitting** | Overlapping blocks, corrupted neighbors | Draw the memory diagram; verify with `mm_check()` |
| **Coalescing non-adjacent blocks** | Memory "owned" that isn't yours | Compare addresses before merging |
| **Merging then using the stale pointer** | Use-after-free of *your own* metadata | Return the merged block pointer from `coalesce()` |
| **Not updating `prev`/`next` of neighbors** | List corruption → infinite loops | Update both directions; run `mm_check()` each step |
| **`realloc` freeing before failing** | Double-free in callers | Only free the old block after the new copy succeeds |
| **`realloc(p, 0)` / `realloc(NULL, n)`** | Wrong semantics → leaks or crashes | Implement and test the documented behavior |
| **`free(NULL)` crashes** | Segfault in common client code | Early return |
| **No double-free detection** | Silent heap corruption | Check `is_free`/magic; abort loudly |
| **Using `printf` in the allocator** | Infinite recursion / deadlock under `LD_PRELOAD` | `write(2)` + manual formatting |
| **Initialization race** | Crash in multithreaded programs at startup | Lock-protected lazy init (or `pthread_once`) |
| **Assuming `sbrk` regions are contiguous** | Corruption when other code calls `sbrk` or `mmap` | Track region boundaries; handle gaps |
| **Misaligned `mmap` payload** | Faults | Header size multiple of 16; `mmap` is page-aligned |
| **Wrong `munmap` size** | `EINVAL` / leak | Store total mapping length in the header |
| **Returning memory with stale data from `calloc`** | Non-zero "zeroed" memory | `memset` recycled blocks |
| **Type-punning via incompatible pointer casts** | Optimizer-dependent breakage | Keep raw heap as `uint8_t *`; cast only to your `Block` type at well-defined offsets |
| **Holding the lock during `mmap`/`munmap`** | Contention hot spot | Do syscalls outside the critical section where possible |
| **Fragmentation blow-up** | RSS grows though live data doesn't | Coalesce; consider best-fit / size classes; measure it |

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests (`tests/test_basic.c`, `tests/test_edge.c`)

- [ ] `malloc(1)`, `malloc(15)`, `malloc(16)`, `malloc(17)`: all 16-aligned, all distinct, writable end-to-end
- [ ] `malloc(0)` and `free(NULL)` behave sanely
- [ ] `malloc(SIZE_MAX)` and `malloc(SIZE_MAX - 8)` return `NULL` with `ENOMEM` (no crash, no wraparound)
- [ ] `calloc(SIZE_MAX / 2, 4)` fails cleanly; `calloc(100, 8)` returns all zeros even on a reused (dirtied) block
- [ ] Free-then-malloc same size reuses the same address (first-fit determinism)
- [ ] Coalescing in all orders: free A,B,C; C,B,A; A,C,B (6 permutations)
- [ ] `realloc` grow/shrink preserves contents (fill with a pattern, check after)
- [ ] `realloc(NULL, n)`, `realloc(p, 0)`, `realloc` failure leaves `p` valid
- [ ] Large allocation (1 MB) uses `mmap` path; `free` returns it (check `/proc/self/maps` before/after)

### 7.2 Randomized stress test with data integrity checking

```c
#define SLOTS 1000
struct { void *p; size_t n; uint8_t tag; } live[SLOTS] = {0};

for (long iter = 0; iter < 5000000; iter++) {
    int i = rand() % SLOTS;
    if (live[i].p) {
        /* verify EVERY byte still equals tag → detects overlap/corruption */
        for (size_t k = 0; k < live[i].n; k++)
            assert(((uint8_t *)live[i].p)[k] == live[i].tag);
        if (rand() % 3 == 0) { /* realloc: verify min(old,new) bytes preserved */ }
        else { mm_free(live[i].p); live[i].p = NULL; }
    } else {
        live[i].n = 1 + (size_t)(rand() % 4096);
        live[i].tag = (uint8_t)rand();
        live[i].p = mm_malloc(live[i].n);
        assert(live[i].p && ((uintptr_t)live[i].p % 16) == 0);
        memset(live[i].p, live[i].tag, live[i].n);
    }
    if (iter % 1000 == 0) assert(mm_check() == 0);
}
```

Seed `srand` with a printed value so any failure is **reproducible**. Run with several seeds.

### 7.3 Real-program validation

```bash
LD_PRELOAD=$PWD/libmymalloc.so ls -R /usr/share | wc -l
LD_PRELOAD=$PWD/libmymalloc.so python3 -c "import json; print(len(json.dumps(list(range(10**6)))))"
LD_PRELOAD=$PWD/libmymalloc.so gcc -O2 -c ../01_cli_tool/src/search.c -I../01_cli_tool/include -o /tmp/x.o
LD_PRELOAD=$PWD/libmymalloc.so ../04_http_server/tinyhttpd --port 8080 &
ab -n 20000 -c 50 http://localhost:8080/index.html
```

Note: if the program crashes, run under GDB with `LD_PRELOAD` set via `(gdb) set environment LD_PRELOAD=./libmymalloc.so`, enable `-DMM_DEBUG`, and see which invariant fires first.

### 7.4 Trace-driven benchmarks

Record `(op, size, id)` traces from a real run (via a logging shim), then replay on glibc malloc vs. `mymalloc`. Report in `notes.md`:

| Metric | How to measure |
|--------|---------------|
| **Throughput** | ops/sec (`clock_gettime`) |
| **Peak memory** | max `heap_size` vs. max live bytes |
| **Utilization** | `peak_live_bytes / peak_heap_bytes` (higher = less fragmentation) |
| **Latency tail** | worst-case single `malloc` time (first-fit list walks can be slow) |
| **Per-allocation overhead** | header bytes ÷ average size |

Compare policies: first-fit vs. next-fit vs. best-fit vs. segregated lists.

### 7.5 Debugging toolkit

```bash
gdb ./test_stress
(gdb) break mm_check if heap_corrupt_flag    # or break on abort
(gdb) x/16gx b                                # examine a header: raw 8-byte words
(gdb) x/64xb payload                          # bytes of payload (see canary patterns)
(gdb) watch *(size_t *)0x...                  # hardware watchpoint on a header word
(gdb) p *(Block *)0x...                       # interpret memory as your struct

strace -e trace=brk,mmap,munmap ./test_stress # confirm you ask the OS for memory sparingly
ltrace -e malloc+free ./test_basic            # see calls (if not preloaded)
```

**Exercise:** corrupt a header on purpose (`((size_t *)p)[-4] = 0;`), then use `mm_check()` + GDB `x/` commands to track down which invariant fails and where.

### 7.6 Sanitizers for *your own* allocator code

Compile **allocator internals** with UBSan (`-fsanitize=undefined`) to catch shifts, misalignment, and signed overflow in your arithmetic. (Skip ASan for the allocator itself since it intercepts `malloc`, but you *can* run client tests that use `mm_malloc` directly, as a library with a different name, under ASan to check the **clients** don't misuse memory.)

---

## 8. Stretch Goals

- [ ] **Slab/pool allocator** for fixed-size objects: O(1) alloc/free, zero fragmentation
- [ ] **Arena (region) allocator** with bulk free, which is ideal for request-scoped memory in Project 4
- [ ] **Per-thread arenas** to eliminate lock contention (see tcmalloc/jemalloc design docs)
- [ ] **Red-black tree or buddy system** allocator and comparison of fragmentation behavior
- [ ] Implement `posix_memalign`/`aligned_alloc` with arbitrary power-of-two alignment
- [ ] Use `madvise(MADV_DONTNEED)` to return free pages to the OS without `munmap`
- [ ] **Simple mark-and-sweep garbage collector** on top: conservative stack scan + heap scan using your block headers to validate "is this word a pointer into a live block?"
- [ ] Write a **toy VM** (Project 5 alternative): bytecode interpreter, stack machine, using your allocator for its heap

## 9. Definition of Done

- [ ] `malloc/free/calloc/realloc` pass all unit tests and the randomized integrity stress (5M ops, multiple seeds, `mm_check()` clean)
- [ ] Overflow-safe on every size computation; returns 16-byte-aligned pointers always
- [ ] Coalescing correct in both directions; large blocks use `mmap`
- [ ] Thread-safe: passes a multithreaded stress test under ThreadSanitizer (for client code) and heap checker
- [ ] `LD_PRELOAD` runs `ls`, `python3`, `gcc`, and `tinyhttpd` without crashing
- [ ] Benchmark table in `notes.md` comparing your allocator with glibc, with an honest explanation of where and why you win/lose
- [ ] `notes.md` includes: memory diagram of your block layout, invariants list, and 3 bugs `mm_check()` caught

---

## 🎓 Curriculum Complete

You've now built a CLI tool, a database engine, a binary parser, a concurrent network server, and the allocator beneath them all. Natural next steps:

- **Read real code:** `redis` (data structures, event loop), `sqlite` (storage engine), `musl libc` (clean libc), Linux kernel `mm/slab.c`
- **Go deeper on I/O:** `epoll`/`io_uring`, lock-free queues, memory-ordering and `<stdatomic.h>`
- **Security:** write an exploit for a deliberately vulnerable program (pwnable.kr, CTFs) to see why every pitfall in these READMEs matters
- **Compilers/runtimes:** write a small language interpreter or JIT on top of Projects 2 and 5

⬅️ **Back to:** [Curriculum Home](../README.md)
CURRICULUM_EOF_7f3a

echo "Done. Created ./$ROOT (no nested git repo was made)."
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Next:  git add \"$ROOT\" && git commit -m \"Add C systems programming curriculum\" && git push"
fi
echo "Start:  less $ROOT/01_cli_tool/README.md"
