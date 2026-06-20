# 42 Piscine: C Module - Exercise 14 (ft_sqrt)

An educational guide explaining how to write a C function that calculates the exact integer square root of a number, returning 0 if the square root is irrational or invalid.

## 📋 The Assignment

The goal is to write a function named `ft_sqrt` inside a file named `ft_sqrt.c`. The function must determine the square root of an integer parameter (`nb`).

* If the square root is a whole integer, return that integer value.
* If the square root is an irrational number (not a whole integer, e.g. √2 or √5), the function must return `0`.
* If the input is negative, the function must return `0`.

### 🛠️ Allowed Functions

* None

### 📋 Function Prototype

```c
int ft_sqrt(int nb);
```

---

## 💡 The Solution

Since floating-point libraries (`<math.h>`) are not allowed, we use a simple linear search. We start checking from `0` and square our tracking index variable (`i * i`) until it either matches `nb` perfectly or surpasses it.

This is the actual content of `ft_sqrt.c`:

```c
int	ft_sqrt(int nb)
{
	long	i;
	long	n;

	if (nb < 0)
		return (0);
	n = (long)nb;
	i = 0;
	while (i * i <= n)
	{
		if (i * i == n)
			return ((int)i);
		i++;
	}
	return (0);
}
```

### 🔍 Detailed Code Breakdown

* **`if (nb < 0)`**: Negative numbers cannot have a real square root, so they immediately return `0`. (`0` itself is handled naturally by the loop below: `i` starts at `0`, `0 * 0 == 0`, so `ft_sqrt(0)` correctly returns `0`.)
* **`long i, n`**: `nb` is cast and stored as `long`, and the loop counter `i` is also `long`. This avoids signed integer overflow when checking `i * i`, since for `nb` near `INT_MAX` the comparison value would overflow a 32-bit `int`.
* **`while (i * i <= n)`**: Loops upward, squaring the index to see if it matches our target `n`.
* **`if (i * i == n)`**: If the squared index hits the target exactly, it is a perfect square root, so we return `i` (cast back to `int`).
* **`return (0);`**: If the loop finishes without finding an exact match, the square root is irrational, so it returns `0`.

> ⚠️ **Important Note for Submission:** Do **NOT** include headers like `#include <unistd.h>` or an `int main(void)` function inside your turned-in file. Leaving a `main` function inside your code repository will break the Moulinette test pipeline's compiling mechanism. Also keep the file `norminette`-clean: no comments inside function bodies, a proper 42 header comment at the top, and no braces around single-statement `if`/`while` bodies.

---

## 🛠️ Compilation and Testing

To verify that your calculations are accurate and handle irrational/boundary cases correctly, create an isolated testing workspace outside of what you turn in.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   int	ft_sqrt(int nb);

   int	main(void)
   {
       printf("Sqrt of -4:  %d (Expected: 0)\n", ft_sqrt(-4));
       printf("Sqrt of 0:   %d (Expected: 0)\n", ft_sqrt(0));
       printf("Sqrt of 1:   %d (Expected: 1)\n", ft_sqrt(1));
       printf("Sqrt of 4:   %d (Expected: 2)\n", ft_sqrt(4));
       printf("Sqrt of 25:  %d (Expected: 5)\n", ft_sqrt(25));
       printf("Sqrt of 26:  %d (Expected: 0, irrational root)\n", ft_sqrt(26));
       printf("Sqrt of max: %d (Expected: 46340)\n", ft_sqrt(2147395600));
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_sqrt.c main.c -o test_sqrt
   ```

3. **Run your program**:
   ```bash
   ./test_sqrt
   ```

4. **Check the norm**:
   ```bash
   norminette ft_sqrt.c
   ```

---

## 📦 Submission

Clean your project folder by removing `main.c` and `test_sqrt`. Ensure your `ex14/` directory contains **only** the `ft_sqrt.c` file before committing and pushing your code changes to Git.
