# 42 Piscine: C Module - ft_range
A small guide to a function that builds an array of integers covering every value from `min` (inclusive) to `max` (exclusive).
## 📋 The Assignment
Write a function named `ft_range` inside a file named `ft_range.c`. The function returns an array of ints containing all values between `min` and `max`. `min` is included, `max` is excluded. If `min` is greater than or equal to `max`, a null pointer should be returned.
### 📋 Function Prototype
```c
int *ft_range(int min, int max);
```
### 🛠️ Allowed Functions
* `malloc`
---
## 💡 The Solution
This is the content of `ft_range.c`:
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
* **`arr = malloc(sizeof(int) * (max - min))`**: At this point `max - min` is guaranteed positive, so it's a safe size for the number of integers in the range.
* **`if (arr == NULL) return (NULL);`**: Standard allocation-failure check.
* **The `while` loop**: Fills the array from front to back, writing the current value of `min` into `arr[i]`, then advancing both the array index `i` and the value `min` together. The loop stops once `min` reaches `max`, which is exactly the exclusive upper bound the subject asks for.
* **`return (arr)`**: Hands back the freshly allocated array. The caller owns this memory and is responsible for `free()`-ing it.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, no `for` loops.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>
   #include <stdlib.h>

   int	*ft_range(int min, int max);

   int	main(void)
   {
       int *arr = ft_range(0, 5);
       int i;

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
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror -fsanitize=address ft_range.c main.c -o test_range
   ```
3. **Run your program**:
   ```bash
   ./test_range
   ```
   Expected output:
   ```
   0 1 2 3 4
   ```
4. **Check the norm**:
   ```bash
   norminette ft_range.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_range`. Ensure your exercise directory contains **only** `ft_range.c` before committing and pushing your code changes to Git.
