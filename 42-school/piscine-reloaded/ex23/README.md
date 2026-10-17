# 42 Piscine: C Module - ft_point.h
A small guide to a header defining the `t_point` type used by the subject's given `main`.
## 📋 The Assignment
Create a file `ft_point.h` that'll compile the following `main`:
```c
#include "ft_point.h"

void set_point(t_point *point)
{
    point->x = 42;
    point->y = 21;
}

int main(void)
{
    t_point point;

    set_point(&point);
    return (0);
}
```
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_point.h`:
```c
#ifndef FT_POINT_H
# define FT_POINT_H

typedef struct s_point
{
	int	x;
	int	y;
}	t_point;

#endif
```
### 🔍 Detailed Code Breakdown
* **Include guard (`#ifndef` / `# define` / `#endif`)**: Prevents the header from being processed twice if it's included more than once in the same compilation.
* **`struct s_point { int x; int y; }`**: A plain structure with two integer members, `x` and `y` — exactly what `set_point` needs to write into.
* **`typedef ... t_point`**: Gives the struct the short alias `t_point` so it can be used directly as a type, the way the given `main` does (`t_point point;`).
* **`s_` / `t_` naming convention**: `s_point` for the raw struct tag and `t_point` for the typedef'd alias is the standard 42 naming convention for structures.
> ⚠️ **Important Note for Submission:** Keep it `norminette`-clean: a proper 42 header comment at the top, tabs aligning the member names.
---
## 🛠️ Compilation and Testing
1. **Use the exact `main` given in the subject**, saved as `main.c` outside of what you turn in.
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror main.c -o test_point
   ```
3. **Run your program**:
   ```bash
   ./test_point
   echo $?
   ```
   Expected output:
   ```
   0
   ```
4. **Check the norm**:
   ```bash
   norminette ft_point.h
   ```
---
## 📦 Submission
Ensure your exercise directory contains **only** `ft_point.h` before committing and pushing your code changes to Git.
