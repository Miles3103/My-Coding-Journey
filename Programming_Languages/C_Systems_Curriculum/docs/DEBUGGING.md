# Debugging Guide

## The method
1. **Reproduce** reliably; shrink the input.
2. **Read the first error/warning** completely. Note file:line.
3. **Run with sanitizers**: `-g -O0 -fsanitize=address,undefined`.
4. **One hypothesis, one change.** Test it (stderr `printf`, gdb breakpoint).
5. **Shrink the program** until the bug fits on a screen.
6. **Fix the cause, add a test.**

## Decoder: what the message means
| Message | Meaning | First thing to try |
|---|---|---|
| `expected ';' before ...` | Syntax slip, usually on the *previous* line | Look one line up |
| `implicit declaration of function 'x'` | Missing `#include`/prototype | Add the header; under `-std=c11`, POSIX names (`getopt`, `getline`) need `-std=gnu11` or `#define _POSIX_C_SOURCE 200809L` |
| `unknown type name 'X'` | Header not included | Include it |
| `warning: format '%d' expects ...` | Wrong printf format (UB) | Fix the format (`%zu` for size_t) |
| `warning: ... may be used uninitialized` | Real bug | Initialize it |
| `undefined reference to 'x'` | **Linker:** definition not linked | Compile/link the `.c` that defines it; check spelling |
| `multiple definition of 'x'` | **Linker:** defined twice | Don't define things in headers |
| `Segmentation fault` | Bad memory access | `gdb` → `run` → `bt`; or ASan |
| `heap-buffer-overflow` / `stack-buffer-overflow` | Wrote/read past a buffer | Check the loop bound and `+1` for `'\0'` |
| `heap-use-after-free` | Used freed memory | Find the "freed by" stack, then who still holds the pointer |
| `attempting double-free` | `free` twice | Set to NULL after free; fix ownership |
| `detected memory leaks` | Lost a block | The report shows the allocation site; free it on every path |
| `signed integer overflow` | UB in arithmetic | Use a wider or unsigned type; validate inputs |
| `Conditional jump ... uninitialised value` (valgrind) | Read of uninitialized data | `--track-origins=yes` shows where it came from |
| `free(): invalid pointer` / `double free or corruption` | Heap metadata damaged | Look for earlier overflows/underflows; run under ASan |
| `*** No rule to make target` | Make can't find a file | Check paths/names and your current folder |
| `*** missing separator` | Spaces instead of TAB in a Makefile | Use a TAB |

## "Which tool?"
| Symptom | Tool |
|---|---|
| Crashes (segfault) | gdb `bt`, or ASan |
| Wrong output, no crash | gdb breakpoints/`watch`, or stderr prints |
| Memory error suspected | ASan + UBSan |
| Uninitialized value suspected | valgrind |
| Leaks | ASan (LeakSanitizer) or valgrind |
| Threads misbehave (Project 4) | ThreadSanitizer, helgrind, `gdb: thread apply all bt` |
| Allocator bugs (Project 5) | your own `mm_check()`, canaries, poison patterns |

## Segfault checklist
- [ ] Is a pointer NULL or uninitialized? (`print p` in gdb)
- [ ] Did I free it earlier? Is it a returned local's address?
- [ ] Is an index out of range? (`print i`, `print n`)
- [ ] Did I forget `+1` for the `'\0'`?
- [ ] Is it infinite recursion? (`bt` is thousands of frames)
- [ ] Am I writing to a string literal?

## Keep a bug log
For every bug write: symptom → tool that found it → root cause → fix → how to avoid it. Do this in each project's `notes.md`. Within a month you'll recognise most bugs on sight.
