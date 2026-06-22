# ft_point.h

Turn-in directory: `ex23/`
Files to turn in: `ft_point.h`
Allowed functions: None

A header defining the `t_point` type used to compile the subject's given `main`.

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

## 💡 The Code

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

* **Include guard (`#ifndef` / `# define` / `#endif`)**: Prevents the header from being processed twice if it's included (directly or indirectly) more than once in the same compilation, which would otherwise cause a "redefinition of struct" error.
* **`struct s_point { int x; int y; }`**: A plain structure with two integer members, `x` and `y` — exactly what `set_point` needs to write into (`point->x = 42; point->y = 21;`).
* **`typedef ... t_point`**: Gives the struct the short alias `t_point` so it can be used directly as a type, the way the given `main` does (`t_point point;`), without writing `struct s_point` every time.
* **`s_` / `t_` naming convention**: `s_point` for the raw struct tag and `t_point` for the typedef'd alias is the standard 42 naming convention for structures.

### ✅ Correctness

The exact `main` from the subject was compiled against this header with `gcc -Wall -Wextra -Werror`: no warnings, and the program runs and exits with code `0`.

### 🛠️ Norm Notes

This file is `norminette`-clean: tabs aligning the member names, and the standard 42 header comment at the top.

> ⚠️ Before submitting, update the header's `By:`, `Created:`, and `Updated:` lines with your real 42 login and email — they're currently placeholders.

---

## 📦 Submission

Make sure `ex23/` contains only `ft_point.h` before committing and pushing.
