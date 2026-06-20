# ft_abs.h

Turn-in directory: `ex22/`
Files to turn in: `ft_abs.h`
Allowed functions: None

A macro that replaces its argument with its absolute value.

## 📋 The Assignment

* Create a macro `ABS` which replaces its argument by its absolute value:
  ```c
  #define ABS(Value)
  ```
* You are asked to do something that is normally banned by the Norm — that will be the only time it's authorized.

## 💡 The Code

```c
#ifndef FT_ABS_H
# define FT_ABS_H

# define ABS(Value) ((Value) < 0 ? -(Value) : (Value))

#endif
```

### 🔍 Detailed Code Breakdown

* **Include guard (`#ifndef` / `#define` / `#endif`)**: Standard practice for header files, so that including `ft_abs.h` more than once (directly or indirectly through other headers) doesn't cause a redefinition error.
* **`#define ABS(Value) (...)`**: A function-like macro. Unlike a regular function, this gets expanded directly by the preprocessor wherever `ABS(...)` appears in the code, before compilation even starts.
* **`(Value) < 0 ? -(Value) : (Value)`**: The actual logic — if the value is negative, return its negation (making it positive); otherwise return it unchanged. This is a ternary expression, the only way to express "pick one of two values based on a condition" in a single expression without a function call.
* **Parentheses around every occurrence of `Value`**: This is the part that actually matters for correctness, not just style. Macro arguments are substituted as raw text, not as evaluated values, so a naive version like `#define ABS(Value) (Value < 0 ? -Value : Value)` breaks on compound expressions. For `ABS(-3 + 1)`, the true branch `-Value` would expand to `- -3 + 1` (two separate tokens: a unary minus followed by the literal `-3`, then `+ 1`), which the compiler reads as `(-(-3)) + 1 = 4` — not the expected `2`. Wrapping every substitution site in its own parentheses, `((Value) < 0 ? -(Value) : (Value))`, forces the whole argument to be evaluated as a single unit no matter what expression is passed in, which is exactly why the test table below shows `ABS(-3 + 1)` correctly producing `2`.
* **The outer parentheses around the whole macro body**: Protect the macro itself from being mangled if it's used inside a larger expression, e.g. `2 * ABS(x)` — without them, operator precedence could combine `2 *` with only part of the ternary.

### 🛠️ Why the Norm Has to Be Broken Here

Running `norminette` on this file deliberately produces three errors:

* **`MACRO_FUNC_FORBIDDEN`**: The norm normally bans function-like macros (macros that take arguments) entirely.
* **`PREPROC_CONSTANT`**: The norm normally requires `#define` to only introduce constant values, not expressions.
* **`TERNARY_FBIDDEN`**: The norm normally bans the `?:` ternary operator anywhere in the code.

`ABS` as specified by the subject can't be written without breaking all three at once — there's no way to express "compute one of two values based on a runtime condition, in a single macro substitution" otherwise. The subject explicitly calls this out as the one sanctioned exception, so these three errors are expected and correct to submit as-is; they aren't bugs to fix.

### ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror` — no warnings. Tested:

| Expression        | Result | Expected |
|--------------------|--------|----------|
| `ABS(5)`           | 5      | 5        |
| `ABS(-5)`          | 5      | 5        |
| `ABS(0)`           | 0      | 0        |
| `ABS(-3 + 1)`      | 2      | 2        |
| `ABS(x)` where `x = -7` | 7 | 7        |

The `ABS(-3 + 1)` case in particular confirms the parenthesization is doing its job: the compound expression is evaluated as a whole (`-3 + 1 = -2`, then absolute value `2`), not mangled by naive text substitution.

---

## 🛠️ Testing It Yourself

```c
#include <stdio.h>
#include "ft_abs.h"

int main(void)
{
    printf("%d\n", ABS(-5));
    return (0);
}
```

```bash
gcc -Wall -Wextra -Werror main.c -o test_abs
./test_abs
```

## 📦 Submission

Make sure `ex22/` contains only `ft_abs.h` before committing and pushing. Don't be surprised or alarmed if `norminette` flags this file — that's expected for this exercise specifically.
