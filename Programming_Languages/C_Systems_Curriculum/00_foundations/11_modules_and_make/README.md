# Lesson 11: Modules, Headers & Make

**Time:** ~3 h | **Prev:** [Lesson 10](../10_files_and_args/README.md) | **Next:** [Lesson 12](../12_debugging_and_ub/README.md)
**Files:** [`stack_demo/`](stack_demo/): `stack.h`, `stack.c`, `main.c`, `Makefile`

## You will be able to
- split a program into `.h` / `.c` modules with a clean interface
- explain declaration vs definition, include guards, `static` and `extern`
- write a Makefile and understand compile vs link errors

---

## 1. Concept: separate *what* from *how*

A real program is many files. Each **module** has:
- a **header (`.h`)**: the *interface*, i.e. what callers may use (function declarations, types, constants)
- a **source file (`.c`)**: the *implementation*, i.e. how it works (definitions, private helpers)

```text
stack.h  ──(included by)──►  main.c        main.c  ──compile──►  main.o ─┐
   ▲                                                                      ├─link─► stack_demo
stack.h  ──(included by)──►  stack.c       stack.c ──compile──►  stack.o ─┘
```
Each `.c` file is compiled **on its own** into an object file (`.o`) (a *translation unit*). The **linker** then connects the calls in one `.o` to the definitions in another.

### Declaration vs. definition
- **Declaration** says "this exists": `int add(int a, int b);` or `extern int counter;`. It can appear many times.
- **Definition** *creates* it: `int add(int a, int b) { ... }`. It must appear **exactly once** in the whole program.

**Header rule:** put declarations, types and macros in headers, never function bodies or variable definitions. If a header defines a function and two `.c` files include it, you get `multiple definition` at link time.

### Include guards
```c
#ifndef STACK_H
#define STACK_H
/* ... */
#endif
```
If `a.h` and `b.h` both include `stack.h`, the compiler could see it twice and complain about duplicate types. The guard makes the second inclusion empty.

### Hiding things (encapsulation, the C way)
C has no `private`. Instead:
- **`static` functions and globals are private to their `.c` file**, so mark every helper `static`.
- **Opaque types:** the header says `typedef struct Stack Stack;` but doesn't define it, so callers can only hold a `Stack *` and use your functions. Only `stack.c` knows the fields. This lets you change the internals without breaking callers. (`stack_demo` does this.)

### Compile errors vs. link errors
| Message | Stage | Typical cause |
|---|---|---|
| `error: unknown type name 'Stack'` | compile | missing `#include` |
| `warning: implicit declaration of function` | compile | missing prototype/header |
| `undefined reference to 'stack_push'` | **link** | forgot to compile/link `stack.c`, or a typo in the name |
| `multiple definition of 'x'` | **link** | a definition in a header, or two `.c` files defining the same thing |

## 2. Make: rebuild only what changed
A Makefile is a list of **rules**:
```make
target: dependencies
<TAB>command that builds the target
```
Make compares file timestamps. If a dependency is newer than the target, it re-runs the command. Edit `stack.c` and only `stack.o` and the final link re-run.

Useful variables: `$@` = the target, `$<` = first dependency, `$^` = all dependencies. **The command lines must start with a TAB, not spaces.**

```bash
cd 11_modules_and_make/stack_demo
make            # builds stack_demo
./stack_demo
touch stack.c && make     # only stack.o is rebuilt
make clean
```
Run `make -n` to print what *would* run without running it.

## 3. Common mistakes
- **Spaces instead of a TAB** in a Makefile (`*** missing separator`).
- **Forgetting header dependencies** in the rule, so editing a header doesn't trigger a rebuild. (Look at `%.o: %.c stack.h`. For bigger projects use `gcc -MMD`.)
- **Defining variables/functions in headers.**
- **Including `.c` files** (`#include "stack.c"`). Don't; compile and link them.
- **Circular includes** (`a.h` includes `b.h` includes `a.h`). Use forward declarations: `typedef struct Stack Stack;`.
- Using `-I` wrongly: with `include/` you need `-Iinclude`.

## 4. Exercises
- [ ] **E1.** Run the demo. Then deliberately cause each linker error from the table above and read the messages.
- [ ] **E2.** Add `stack_peek(const Stack *s, int *out)` (does not remove) to `stack.h` and `stack.c`; use it in `main.c`.
- [ ] **E3.** Add a `stack_clear`. Then add a `-Wall` warning on purpose in `stack.c` and watch Make rebuild only that file.
- [ ] **E4.** Remove the include guard from `stack.h` and include it twice in `main.c`. What error appears?
- [ ] **E5.** Create your own module `strutil.h/.c` with `trim`, `starts_with`, `ends_with` and a `main.c` that tests them. Write its Makefile **from scratch** (no copying).
- [ ] **E6.** Move `stack.h` into an `include/` folder and `stack.c`/`main.c` into `src/`. Update the Makefile with `-Iinclude` and `vpath`/paths. *(This is exactly the layout of Projects 1 to 5.)*
- [ ] **E7 (stretch).** Add a `make test` target that builds and runs a `test_stack.c` full of `assert`s.

## 5. Self-check
<details><summary>Questions</summary>

1. What's the difference between a declaration and a definition?
2. What problem do include guards solve?
3. How do you make a function private to a file?
4. `undefined reference to 'foo'`: compile or link error, and what's the usual cause?

**Answers:** (1) A declaration announces a name/type (repeatable); a definition creates the thing (exactly once). (2) The same header being included twice in one translation unit. (3) Mark it `static`. (4) A link error; `foo.c` wasn't compiled/linked, or the name is misspelled.
</details>

## 6. Where this shows up later
- **All projects** use `include/`, `src/`, `tests/` and a Makefile in exactly this way.
- **Project 2** uses opaque types for `HashTable` and `Log`.
