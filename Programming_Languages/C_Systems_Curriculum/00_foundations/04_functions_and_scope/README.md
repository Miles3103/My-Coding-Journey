# Lesson 4: Functions & Scope

**Time:** ~3 h | **Prev:** [Lesson 3](../03_control_flow/README.md) | **Next:** [Lesson 5](../05_arrays_and_strings/README.md)
**File:** [`functions.c`](functions.c)

## You will be able to
- write functions with prototypes and return values
- explain **pass by value** and why a plain `swap(a, b)` can't work
- describe the **stack** and what happens during a call, including recursion
- use `static` in three different places without mixing them up

---

## 1. Concept: a function is a named, reusable piece of code

```c
int add(int a, int b)       /* return type, name, parameters */
{
    return a + b;
}
```

A **prototype** (declaration) tells the compiler a function exists before it's defined: `int add(int a, int b);`. Prototypes live in header files (Lesson 11).

### Pass by value: C always copies
When you call `swap_wrong(x, y)`, C copies the *values* of `x` and `y` into the function's own variables. The function swaps its *copies* and the originals never change. Run the example and see. The fix is to pass **addresses** (pointers), which is the next lesson.

> It's like handing someone a photocopy of your document. They can scribble on it all day, and yours stays clean.

### The stack: where local variables live
Every call gets a **stack frame**, a block of memory holding its parameters and local variables. When the function returns, its frame is released automatically. Frames are stacked: `main` calls `f`, `f` calls `g`, and each sits on top of the last. The example prints the addresses of locals at increasing recursion depths so you can *see* the frames (on most machines the stack grows toward lower addresses).

Consequences you must know:
- Locals are **uninitialized** (garbage) until you assign them.
- A local's memory is **gone after return**. **Never return a pointer to a local variable.**
- The stack is small (usually 8 MB). Deep recursion or huge local arrays cause a **stack overflow** crash.

### Scope and lifetime
| Kind | Declared | Lives | Visible |
|---|---|---|---|
| Local (automatic) | inside a function/block | until the block ends | only that block |
| `static` local | inside a function, with `static` | whole program | only that function (keeps its value between calls) |
| Global | outside any function | whole program | whole file (and others via `extern`) |

**`static` means three related things:** (1) a `static` *local* remembers its value between calls (like `next_id`), (2) a `static` *global or function* is **private to its .c file** (the encapsulation tool you'll use constantly), (3) it's allocated for the whole program, not on the stack.

### Recursion
A function that calls itself needs a **base case** (when to stop) and progress toward it. `factorial(n) = n * factorial(n-1)`, base case `n <= 1`. Each call adds a stack frame, so recursion costs memory. Loops are cheaper when they're equally clear.

### Unspecified evaluation order
`printf("%d %d", next_id(), next_id())` is a trap: C doesn't say which argument is evaluated first. The example splits them into separate statements. (This is why `-Wall` warns about expressions like `i = i++ + 1`.)

## 2. Run it
```bash
make && ./bin/functions
```

## 3. Common mistakes
- Returning the address of a local: `int *f(void) { int x = 5; return &x; }`. This is a dangling pointer. `-Wall` warns.
- Forgetting the return statement in a non-void function (UB if the caller uses the value).
- Calling a function before its declaration (implicit declaration warning). Add a prototype.
- Thinking `void f(int a[])` receives the array. It receives a **pointer** (Lesson 5).
- Unbounded recursion (a missing base case) → stack overflow.

## 4. Exercises
- [ ] **E1.** Write `int max3(int a, int b, int c)` and test it with a table of cases.
- [ ] **E2.** Write `long fib(int n)` recursively, then iteratively. Time both for n = 40. Why is the recursive one slow?
- [ ] **E3.** Write `int gcd(int a, int b)` using Euclid's algorithm, recursively.
- [ ] **E4.** Make a counter function using a `static` local that counts how many times it was called. Then reset it using a second function. What problem do you hit? *(Hint: only functions in the same file can reach a static; add a `reset` function beside it.)*
- [ ] **E5.** Write a recursive function that never stops. Run it under ASan and read the `stack-overflow` report. Then add the base case.
- [ ] **E6.** Add `assert(n >= 0)` (from `<assert.h>`) to `factorial`. Call it with -1 and see the abort message.

## 5. Self-check
<details><summary>Questions</summary>

1. Why can't a function `swap(int a, int b)` swap its caller's variables?
2. What happens to a local variable when its function returns?
3. List the meanings of `static`.
4. What is a base case?

**Answers:** (1) Arguments are copied; it only changes its copies. (2) Its stack frame is released; the memory may be reused. (3) A static local persists between calls; a static global/function is private to its file; both live for the whole program. (4) The condition that stops recursion.
</details>

## 6. Where this shows up later
- **Project 1:** `static void usage(...)` hides a helper inside `options.c`.
- **Project 2:** header/source split, with `static` helpers and "who owns this?" comments on every function.
- **Project 5:** the allocator itself manages the *heap*; knowing the stack is your baseline.
