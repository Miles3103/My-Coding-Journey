# 42 Piscine: C Module - ft_abs.h
A small guide to a macro that replaces its argument with its absolute value.
## 📋 The Assignment
Create a file `ft_abs.h` containing a macro `ABS` which replaces its argument by its absolute value:
```c
#define ABS(Value)
```
You are asked to do something that is normally banned by the Norm — that will be the only time it's authorized.
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_abs.h`:
```c
#ifndef FT_ABS_H
# define FT_ABS_H

# define ABS(Value) ((Value) < 0 ? -(Value) : (Value))

#endif
```
### 🔍 Detailed Code Breakdown
* **Include guard (`#ifndef` / `#define` / `#endif`)**: Standard practice for header files, so including `ft_abs.h` more than once doesn't cause a redefinition error.
* **`#define ABS(Value) (...)`**: A function-like macro, expanded directly by the preprocessor wherever `ABS(...)` appears, before compilation even starts.
* **`(Value) < 0 ? -(Value) : (Value)`**: If the value is negative, return its negation (making it positive); otherwise return it unchanged.
* **Parentheses around every occurrence of `Value`**: This is what actually matters for correctness. A naive version like `#define ABS(Value) (Value < 0 ? -Value : Value)` breaks on compound expressions — `ABS(-3 + 1)` would expand the true branch to `- -3 + 1`, which the compiler reads as `4` instead of the correct `2`. Wrapping every substitution site in its own parentheses forces the whole argument to be evaluated as a single unit no matter what expression is passed in.
* **Running `norminette` on this file deliberately produces three errors** (`MACRO_FUNC_FORBIDDEN`, `PREPROC_CONSTANT`, `TERNARY_FBIDDEN`), since `ABS` can't be written without function-like macros, a non-constant `#define`, and the ternary operator — all of which the norm normally bans. The subject explicitly calls this the one sanctioned exception, so these errors are expected and correct to submit as-is.
> ⚠️ **Important Note for Submission:** Don't be surprised or alarmed if `norminette` flags this file — that's expected for this exercise specifically, since the subject explicitly authorizes breaking the norm here.
---
## 🛠️ Testing It Yourself
```c
#include <stdio.h>
#include "ft_abs.h"

int	main(void)
{
    printf("%d\n", ABS(-5));
    return (0);
}
```
```bash
gcc -Wall -Wextra -Werror main.c -o test_abs
./test_abs
```
Expected output:
```
5
```
---
## 📦 Submission
Ensure your exercise directory contains **only** `ft_abs.h` before committing and pushing your code changes to Git.
