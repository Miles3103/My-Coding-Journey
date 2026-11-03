# Lesson 12: Debugging & Undefined Behavior

**Time:** ~4 h | **Prev:** [Lesson 11](../11_modules_and_make/README.md) | **Next:** [Capstone](../capstone/README.md)
**Files:** [`gdb_target.c`](gdb_target.c) plus the bug demos [`crash_bug.c`](crash_bug.c), [`uninit_bug.c`](uninit_bug.c), [`ub_signed_bug.c`](ub_signed_bug.c), [`stack_oob_bug.c`](stack_oob_bug.c)

## You will be able to
- follow a repeatable debugging method instead of guessing
- use **gdb** to stop a program, inspect variables and find a crash
- choose between **sanitizers** and **valgrind**
- explain what **undefined behavior** is and why it's the central danger of C

---

## 1. Concept: undefined behavior (UB)

The C standard says that certain mistakes have **no defined meaning**. The compiler is allowed to assume they never happen, so the program may crash, print garbage, *appear to work*, or behave differently after you change an unrelated line or optimization level.

| UB example | Lesson |
|---|---|
| Reading/writing out of an array's bounds | 5 |
| Dereferencing `NULL` or a dangling pointer | 6 |
| Use after `free`, double free | 9 |
| Signed integer overflow (`INT_MAX + 1`) | 2 |
| Reading an uninitialized variable | 4 |
| Shifting by ≥ the type's width | 2 |
| Wrong `printf` format for the argument | 2 |
| Two threads touching the same data without synchronization (a data race) | Project 4 |

**Why "it worked on my machine" proves nothing:** UB can pass every test and fail in production. The cure is *tools that look for it* (sanitizers, valgrind, warnings), not hope.

## 2. A repeatable debugging method
1. **Reproduce** it reliably. Find the smallest input that triggers it.
2. **Read the first error or warning** completely. Note the file and line.
3. **Run with sanitizers** (`-fsanitize=address,undefined -g`). They report the exact line of memory errors and UB.
4. **Form a hypothesis**, then test it with a `printf` to stderr or a gdb breakpoint. Change **one thing at a time**.
5. **Shrink the program** until the bug is a dozen lines. Often the shrinking itself reveals the cause.
6. **Fix the cause, not the symptom**, then add a test so it never returns.

## 3. Tool 1: sanitizers (your default)
```bash
make bugs
./bin/stack_oob_bug     # stack-buffer-overflow, with file:line
./bin/ub_signed_bug     # "signed integer overflow: 2147483647 + 1 cannot be represented"
./bin/crash_bug         # SEGV on a NULL address, with file:line
```
| Tool | Flag | Catches |
|---|---|---|
| AddressSanitizer | `-fsanitize=address` | overflows, use-after-free, double free, leaks |
| UBSan | `-fsanitize=undefined` | signed overflow, bad shifts, misaligned access, NULL member access |
| ThreadSanitizer | `-fsanitize=thread` | data races (Project 4); can't combine with ASan |

## 4. Tool 2: valgrind (no recompiling; catches uninitialized reads)
```bash
gcc -g -O0 uninit_bug.c -o uninit          # plain build, no sanitizers
valgrind --track-origins=yes ./uninit
```
Look for `Conditional jump or move depends on uninitialised value(s)`. Run the program a few times first: the garbage in `total` changes between runs, which is exactly why UB is slippery.

## 5. Tool 3: gdb (stop time and look around)
Compile with `-g -O0` (debug info, no optimization; otherwise variables get optimized away).

```bash
gcc -std=gnu11 -g -O0 12_debugging_and_ub/crash_bug.c -o crash
gdb ./crash
```
| Command | What it does |
|---|---|
| `run` (`r`), `run arg1` | start the program |
| `bt` | **backtrace**: the chain of calls that led here (start here after a crash) |
| `frame N` / `up` / `down` | move between stack frames |
| `print x`, `print *p`, `print arr[2]@5` | inspect values (`@5` = 5 elements) |
| `info locals` / `info args` | all local variables / arguments |
| `break file.c:42` / `break func` | stop at a line / function |
| `next` (`n`) / `step` (`s`) | run one line (stepping over / into calls) |
| `continue` (`c`) | run until the next breakpoint |
| `watch x` | stop whenever `x` changes |
| `display x` | print `x` every time you stop |
| `x/16xb p` | examine 16 raw bytes at address `p` |
| `quit` (`q`) | leave |

**Crash workflow:** `gdb ./crash` → `run` → *crash* → `bt` → `frame 1` → `print entry` (it's `0x0`) → found it.

**Logic-bug workflow** with `gdb_target.c` (the program prints the wrong answers but doesn't crash):
```bash
gcc -std=gnu11 -g -O0 12_debugging_and_ub/gdb_target.c -o gdb_target
gdb ./gdb_target
(gdb) break find_max
(gdb) run
(gdb) next          # repeat; after each, 'print max' and 'print a[i]'
(gdb) watch max
(gdb) continue
```
Watch `max` stay `0` while `a[i]` is `-8`, `-3`, `-5`, and the starting value is the bug.

## 6. Print debugging, done well
- Print to **stderr**: `fprintf(stderr, "i=%d len=%zu\n", i, len);`
- Print **before** the crash point, not after.
- Label output (`"after parse:"`) so you can follow it.
- Use `assert(cond)` to state facts that must be true; it stops at the exact moment they stop being true. Compile with `-DNDEBUG` to remove them in release builds.

## 7. Common mistakes
- Debugging **optimized** code (`-O2`) in gdb, where variables vanish and lines jump.
- Changing several things at once, so you never learn which one mattered.
- "Fixing" a crash by adding a NULL check at the crash site when the **real** bug is upstream.
- Ignoring warnings.
- Trusting that a program is correct because it printed the right output once.

## 8. Exercises
- [ ] **E1.** For each `*_bug.c`, run it under the sanitizer, note the **bug class**, the **file:line**, and fix it. Keep a table in `notes.md`.
- [ ] **E2.** Use gdb on `crash_bug.c`: reproduce the crash, run `bt`, find which variable is NULL, then fix it two ways (handle `NULL` in `main`; return a status code from `lookup`).
- [ ] **E3.** Use gdb on `gdb_target.c` to find **both** logic bugs *without* adding `printf`. Fix them (`INT_MIN` as the starting max, or use `a[0]`; `(double)sum / n`).
- [ ] **E4.** Run `uninit_bug` under valgrind and read the origin report. Run it 5 times without valgrind and note how the output varies.
- [ ] **E5.** Write a program with a **signed overflow** that only shows at `-O2`. Compile and run at `-O0` and `-O2` and compare (wrap the run in `timeout 5` in case it never stops). *(Hint: a loop `for (int i = 1; i > 0; i++)`.)* Now you've seen UB change behavior.
- [ ] **E6.** Add `assert`s to your own earlier exercise code to state its preconditions (`n > 0`, `p != NULL`).
- [ ] **E7 (stretch).** Run `make clean && make` with `-fsanitize=address,undefined` removed from the Makefile, then run `overflow_bug`. Does it crash? Why is "no crash" **worse** than a crash?

## 9. Self-check
<details><summary>Questions</summary>

1. What does "undefined behavior" allow the compiler to do?
2. What's the first gdb command to run after a crash, and why?
3. Which tool finds uninitialized reads: ASan or valgrind?
4. Why compile with `-O0 -g` when debugging?

**Answers:** (1) Anything: it may assume the case never occurs and optimize accordingly, producing crashes, garbage, or code that seems fine. (2) `bt`, since it shows the chain of calls that led to the crash. (3) Valgrind. (4) `-g` adds line/variable info; `-O0` stops the optimizer from reordering or removing code and variables.
</details>

## 10. Where this shows up later
- Every project's "Testing & Verification" section uses these tools. **Project 4** adds ThreadSanitizer and `gdb thread apply all bt`; **Project 5** adds a heap checker, because the allocator *replaces* the very tools you use here.
