# Lesson 1: Hello, World & the Compiler

**Time:** ~2 h | **Next:** [Lesson 2: Types & operators](../02_types_and_operators/README.md)
**Files:** [`hello.c`](hello.c), [`pipeline.sh`](pipeline.sh)

## You will be able to
- compile and run a C program from the terminal
- explain what the compiler and linker each do
- read a compiler error message and find the line it points to
- explain what a program's **exit status** is

---

## 1. Concept: what is C, really?

C is a **compiled** language. You write text; a program called the **compiler** (`gcc`) translates it into **machine code**, the raw instructions your CPU runs. There is no interpreter and no runtime watching over you. That is why C is fast, and also why it won't stop you from doing something dangerous.

Think of it as the difference between a **recipe** (the `.c` file) and a **finished meal** (the executable). The compiler is the cook, and once the meal is made, the recipe isn't needed to eat it.

When you type `gcc hello.c -o hello`, four stages run in one go:

| Stage | Command | What it does | Output |
|---|---|---|---|
| 1. Preprocess | `gcc -E` | Pastes `#include` files in, expands `#define` | `.i` text |
| 2. Compile | `gcc -S` | Translates C into assembly | `.s` text |
| 3. Assemble | `gcc -c` | Turns assembly into machine code | `.o` object file |
| 4. Link | `gcc` | Joins `.o` files with library code (like `printf`) | executable |

**Why separate stages?** Big projects have hundreds of `.c` files. Each is compiled to a `.o` on its own, and only the changed ones are recompiled. The linker then joins them. You'll use this in Lesson 11.

See it happen: `bash pipeline.sh`.

## 2. The example, line by line

```c
#include <stdio.h>      /* declares printf */

int main(void)          /* every C program starts here */
{
    printf("Hello, C!\n");   /* \n = newline */
    return 0;                /* 0 = success */
}
```

- `#include <stdio.h>` is a **preprocessor** instruction: "paste the contents of this header here". The header holds the *declaration* of `printf` (its name and argument types) so the compiler can check your call. The *code* for `printf` lives in the C library and is added at the link stage.
- `int main(void)` is the **entry point**. The OS calls `main`, and its `int` return value goes back to the OS.
- `printf("...\n")` prints text. `\n` is an escape sequence for a newline; without it your prompt would land on the same line.
- `return 0;` means "success". **Any non-zero value means failure.** Shells and scripts rely on this: `grep` returns 0 if it found a match and 1 if not, and your `mgrep` will do the same.

## 3. Try it

```bash
cd 00_foundations
gcc -Wall -Wextra -o hello 01_hello_world/hello.c
./hello
echo $?          # prints the exit status: 0
```

Now **break it on purpose** and read each message. The format is always `file:line:column: severity: message`.

| Change | What you'll see | Lesson |
|---|---|---|
| Delete a `;` | `error: expected ';' before 'return'` | The error often points at the line *after* the real mistake |
| Delete `#include <stdio.h>` | warning: implicit declaration of function 'printf' | Without the header the compiler doesn't know `printf`. Always fix this warning |
| Change `main` to `mian` | linker error: `undefined reference to 'main'` | A *linker* error, not a compiler error. The name was never defined |
| Change `return 0;` to `return 3;` | no error; `echo $?` prints 3 | Exit codes are just numbers you choose |

## 4. Common mistakes
- Forgetting `-Wall -Wextra`. Warnings catch real bugs, so always turn them on.
- Reading the **last** error first. Start with the **first**; the rest are often fallout.
- Writing `void main()`. The standard form is `int main(void)`.
- Running `hello` instead of `./hello`. The shell only looks in `PATH`, not the current folder.

## 5. Exercises
- [ ] **E1.** Write `my_work/hello2.c` that prints your name and a favourite quote on two lines. Use `\"` for quotes inside the text and `\\` for a backslash.
- [ ] **E2.** Print a tab-separated row: `name<TAB>age<TAB>city`. (`\t` is a tab.)
- [ ] **E3.** Make your program return `42`. Verify with `echo $?`. Then run `./hello && echo yes || echo no` with a program that returns 0, then 1. What do `&&` and `||` do with exit codes?
- [ ] **E4.** Run `bash pipeline.sh`. In your own words, write one sentence about what each of the four stages did.
- [ ] **E5.** Add `int unused = 5;` inside `main` and compile with `-Wall -Wextra`. Read the warning. Then compile *without* those flags. What changed?
- [ ] **E6 (stretch).** Run `gcc -E hello.c | tail -5`. Where did your code end up in that output?

## 6. Self-check
<details><summary>Questions (try before opening the answers)</summary>

1. What are the four stages from source to executable?
2. Why does `printf` need `#include <stdio.h>` if the library code is linked later?
3. What does `return 0` from `main` mean, and who reads it?
4. Is `undefined reference to 'main'` a compiler error or a linker error?

**Answers:** (1) preprocess, compile, assemble, link. (2) The header gives the compiler the function's *declaration* so it can check your call; the code itself is added by the linker. (3) Success; the shell or parent process reads it (`$?`). (4) A linker error: every file compiled, but no `main` was found to link.
</details>

## 7. Where this shows up later
- **Project 1:** your `mgrep` returns 0 / 1 / 2 so scripts can react to it.
- **Lesson 11:** you'll run the compile and link stages separately with a Makefile.
