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
