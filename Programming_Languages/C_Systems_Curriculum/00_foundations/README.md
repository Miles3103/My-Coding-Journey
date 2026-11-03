# Phase 0: C Foundations (from zero)

**Time:** 3 to 4 weeks at 5 to 8 hours a week | **Prerequisite:** none. You only need a Linux/macOS/WSL terminal.
**Next:** [Project 1: mini-grep](../01_cli_tool/README.md)

Phase 0 teaches C itself, one idea per lesson, so Projects 1 to 5 feel like applying skills you already have, not guessing at new ones.
Every lesson has a **tested, runnable example**, a plain-language explanation of **why** C works that way, common mistakes, exercises, and a self-check quiz.

---

## The lessons

| # | Lesson | You will understand | Time |
|---|--------|---------------------|------|
| 1 | [Hello, World & the compiler](01_hello_world/README.md) | What compiling really does, reading error messages, exit codes | 2 h |
| 2 | [Types & operators](02_types_and_operators/README.md) | Integers, floats, sizes, overflow, bitwise ops | 3 h |
| 3 | [Control flow](03_control_flow/README.md) | if / switch / loops, truthiness, short-circuiting | 2 h |
| 4 | [Functions & scope](04_functions_and_scope/README.md) | Pass-by-value, the stack, recursion, `static` | 3 h |
| 5 | [Arrays & strings](05_arrays_and_strings/README.md) | Contiguous memory, `'\0'`, why `strcpy` is dangerous | 4 h |
| 6 | [Pointers](06_pointers/README.md) | Addresses, `&` and `*`, out-parameters, `NULL` | 5 h |
| 7 | [Pointers, arrays & const](07_pointers_arrays_const/README.md) | Pointer arithmetic, `const`, function pointers, `void *` | 5 h |
| 8 | [Structs, enums, unions](08_structs_enums_unions/README.md) | Padding, `typedef`, grouping data | 3 h |
| 9 | [The heap](09_heap_memory/README.md) | `malloc`/`free`, ownership, leaks, ASan & valgrind | 5 h |
| 10 | [Files & arguments](10_files_and_args/README.md) | `FILE *`, `errno`, `argv`, `strtol` | 4 h |
| 11 | [Modules & Make](11_modules_and_make/README.md) | Headers, `.c` files, linking, Makefiles | 3 h |
| 12 | [Debugging & undefined behavior](12_debugging_and_ub/README.md) | gdb, sanitizers, valgrind, what UB means | 4 h |
| ★ | [Capstone: contacts book](capstone/README.md) | Everything combined, and your entry test for Project 1 | 6 h |

---

## How to study each lesson (the loop that works)

1. **Read** the concept section. Don't memorise; get the picture.
2. **Run** the example: `make`, then `./bin/<name>`.
3. **Predict** before you run: for each `printf`, write down what you think it prints. Wrong predictions are the most valuable part.
4. **Break it.** Change a value, delete a line, remove a `const`, index past the end. Read the compiler or sanitizer message. This is how you learn what errors mean.
5. **Type your own version** in `my_work/` (don't copy-paste) and do the exercises.
6. **Explain it** out loud or in `notes.md` as if teaching a friend. If you can't, re-read.
7. Answer the **self-check**, then commit: `git commit -am "L06: pointers done"`.

> **Rule of thumb:** if you've been stuck for more than 30 minutes, write down exactly what you expected vs. what happened, then ask (me, a forum, a friend). Precise questions get precise answers.

---

## Running the examples

From this folder (`00_foundations/`):

```bash
make                     # builds every example into ./bin (sanitizers ON)
./bin/hello
./bin/pointers
make bugs                # builds the deliberately broken programs
./bin/uaf_bug            # watch AddressSanitizer catch the bug
make clean
```

Check your toolchain first: `bash ../tools/doctor.sh`

Your own exercise files go in [`my_work/`](my_work/). Compile them with:

```bash
gcc -std=gnu11 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined my_work/ex1.c -o my_work/ex1
```

Tip: put `alias cc11='gcc -std=gnu11 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined'` in your `~/.bashrc` or `~/.zshrc`, then compile with `cc11 file.c -o file`.

---

## Three habits to build from day one

1. **Always compile with warnings on** (`-Wall -Wextra`). Treat every warning as a bug you haven't understood yet.
2. **Read the first error only.** Later errors are often fallout from the first one.
3. **Initialize every variable.** Uninitialized variables hold garbage, and C won't tell you.

## Ready for Project 1 when

- [ ] You finished lessons 1 to 12 (exercises, not just reading)
- [ ] The capstone works and runs clean under the sanitizers
- [ ] You can explain, without notes, the difference between `char *p`, `char p[]`, and `const char *p`
- [ ] You can explain who owns each `malloc`'d block in your capstone and where it is freed

➡️ **Start:** [Lesson 1: Hello, World](01_hello_world/README.md)
