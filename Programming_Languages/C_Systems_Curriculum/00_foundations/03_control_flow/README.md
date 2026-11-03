# Lesson 3: Control Flow

**Time:** ~2 h | **Prev:** [Lesson 2](../02_types_and_operators/README.md) | **Next:** [Lesson 4](../04_functions_and_scope/README.md)
**File:** [`control.c`](control.c)

## You will be able to
- write `if`, `switch`, `for`, `while` and `do/while` correctly
- explain C's idea of true and false
- use `break` and `continue`, and rely on short-circuit evaluation

---

## 1. Concept: C has no `true` or `false`, only zero and non-zero

In C, **0 is false and everything else is true**. (`<stdbool.h>` gives you `bool`, `true` and `false`, but under the hood they're just 1 and 0.) So `if (n)` means "if n is not zero" and `while (*s)` means "while the current character isn't `'\0'`". You'll see this pattern all over real C.

### The control structures

```c
if (x > 0) { ... } else if (x < 0) { ... } else { ... }

switch (value) {            /* compares one integer against constants */
case 1:  ...; break;        /* WITHOUT break, execution FALLS THROUGH to the next case */
case 2:
case 3:  ...; break;        /* deliberate fallthrough: 2 and 3 share code */
default: ...;
}

for (int i = 0; i < n; i++) { ... }   /* init; condition; step */
while (cond) { ... }                  /* checks BEFORE each pass */
do { ... } while (cond);              /* checks AFTER, so it runs at least once */
```

- `break` leaves the nearest loop or `switch`. `continue` jumps to the next iteration.
- There's no `foreach`. To walk an array you loop over indexes (or pointers, Lesson 7).
- Conditions can be any expression: `while ((c = getchar()) != EOF)` assigns *and* tests.

### Short-circuit evaluation
`A && B` evaluates `B` **only if `A` is true**. `A || B` evaluates `B` only if `A` is false. This is a safety tool:

```c
if (p != NULL && p->value > 0)   /* safe: p->value is never touched when p is NULL */
if (d != 0 && 10 / d > 1)        /* no division by zero */
```
Swap the order and you crash. Order matters.

### The ternary operator
`cond ? a : b` is an expression, an inline if/else: `n = (n % 2 == 0) ? n / 2 : 3 * n + 1;`.

## 2. Run it
```bash
make && ./bin/control
```
Predict the FizzBuzz line and the Collatz sequence from 6 before running.

## 3. Common mistakes
- **`=` vs `==`**: `if (x = 0)` assigns 0 and is always false. `-Wall` warns.
- **Missing `break` in `switch`**: falls through into the next case. Comment deliberate fallthroughs.
- **Off-by-one**: `i <= n` instead of `i < n` when indexing an array of `n` elements (a buffer overflow, Lesson 5).
- **A stray `;` after `if (...)` or `for (...)`**: the loop body becomes empty.
- Using braces inconsistently. **Always use `{}`**, even for one-line bodies. It prevents a famous class of bugs (Apple's "goto fail" security hole).
- `for (unsigned i = n - 1; i >= 0; i--)`: infinite loop, since an unsigned `i` is never negative.

## 4. Exercises
- [ ] **E1.** Print the multiplication table 1×1 to 9×9 using nested loops.
- [ ] **E2.** Write `is_prime(unsigned n)` and print all primes below 100. Stop testing divisors at √n using `i * i <= n`.
- [ ] **E3.** Read integers from the user with `scanf("%d", &n)` until it returns something other than 1 (the number of items successfully read). Print their sum and the maximum.
- [ ] **E4.** Implement a simple calculator: read `num op num` (`+ - * /`), use `switch` on the operator, and refuse to divide by zero.
- [ ] **E5.** Write the Collatz function so it counts the steps and find which start value below 1000 takes the most.
- [ ] **E6.** Reproduce the unsigned-countdown bug, then fix it two ways: loop `for (size_t i = n; i-- > 0; )`, or use a signed index.

## 5. Self-check
<details><summary>Questions</summary>

1. What are the true/false rules in C?
2. What does `if (p && p->x)` protect you from?
3. When does `do/while` differ from `while`?
4. What happens in a `switch` if you forget `break`?

**Answers:** (1) 0 is false; anything else is true. (2) Dereferencing NULL: `p->x` is never evaluated when `p` is NULL. (3) `do/while` runs the body once before testing. (4) Execution falls through into the following case's code.
</details>

## 6. Where this shows up later
- **Project 1:** `while ((c = getopt(...)) != -1) { switch (c) ... }` is exactly this lesson.
- **Project 4:** accept loops and retry loops (`if (errno == EINTR) continue;`).
