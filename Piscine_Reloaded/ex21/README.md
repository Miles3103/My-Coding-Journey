# ft_range

Turn-in directory: `ex21/`
Files to turn in: `ft_range.c`
Allowed functions: `malloc`

A function that builds an array of integers covering every value from `min` (inclusive) to `max` (exclusive).

## 📋 The Assignment

* `ft_range` returns an array of ints containing all values between `min` and `max`.
* `min` is included, `max` is excluded.
* Prototype:
  ```c
  int *ft_range(int min, int max);
  ```
* If `min` is greater than or equal to `max`, return a null pointer.

## 💡 The Code

```c
#include <stdlib.h>

int	*ft_range(int min, int max)
{
	int	*arr;
	int	i;

	if (min >= max)
		return (NULL);
	arr = malloc(sizeof(int) * (max - min));
	if (arr == NULL)
		return (NULL);
	i = 0;
	while (min < max)
	{
		arr[i] = min;
		i++;
		min++;
	}
	return (arr);
}
```

### 🔍 Detailed Code Breakdown

* **`if (min >= max) return (NULL);`**: Handles the subject's explicit rule — when `min` and `max` are equal, or `min` is past `max`, there's no valid range, so a null pointer is returned immediately, before any allocation happens.
* **`arr = malloc(sizeof(int) * (max - min))`**: At this point `max - min` is guaranteed positive, so it's a safe size for the number of integers in the range. `malloc` is the one function the subject allows.
* **`if (arr == NULL) return (NULL);`**: Standard allocation-failure check — if the system can't provide the memory, return `NULL` rather than writing into invalid memory.
* **The `while` loop**: Fills the array from front to back, writing the current value of `min` into `arr[i]`, then advancing both the array index `i` and the value `min` together. The loop naturally stops once `min` reaches `max`, which is exactly the exclusive upper bound the subject asks for.
* **`return (arr)`**: Hands back the freshly allocated array. The caller owns this memory and is responsible for `free()`-ing it.

### ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror -fsanitize=address` — no warnings, no memory errors. Tested:

| Call                  | Result                          |
|------------------------|----------------------------------|
| `ft_range(0, 5)`       | `[0, 1, 2, 3, 4]`                |
| `ft_range(5, 5)`       | `NULL` (equal bounds)            |
| `ft_range(5, 2)`       | `NULL` (min greater than max)    |
| `ft_range(-3, 3)`      | `[-3, -2, -1, 0, 1, 2]`          |
| `ft_range(10, 11)`     | `[10]` (single-element range)    |

### 🛠️ Norm Notes

This file is `norminette`-clean: tabs throughout, one declaration per line, no `for` loops, return values in parentheses, and just a single function (well under the 5-function cap).

> ⚠️ Before submitting, update the header's `By:`, `Created:`, and `Updated:` lines with your real 42 login and email — they're currently placeholders.

---

## 🛠️ Compilation and Testing

```c
#include <stdio.h>
#include <stdlib.h>

int *ft_range(int min, int max);

int main(void)
{
    int *arr = ft_range(0, 5);
    int i;

    if (arr == NULL)
    {
        printf("NULL\n");
        return (0);
    }
    i = 0;
    while (i < 5)
    {
        printf("%d ", arr[i]);
        i++;
    }
    printf("\n");
    free(arr);
    return (0);
}
```

```bash
gcc -Wall -Wextra -Werror -fsanitize=address ft_range.c main.c -o test_range
./test_range
```

Check the norm:
```bash
norminette ft_range.c
```

## 📦 Submission

Make sure `ex21/` contains only `ft_range.c` before committing and pushing.
