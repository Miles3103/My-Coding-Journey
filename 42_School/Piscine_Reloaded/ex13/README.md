# 42 Piscine: C Module - Exercise 13 (ft_recursive_factorial)

An educational guide explaining how to write an efficient, recursive C function that calculates the mathematical factorial of a number while safely handling invalid boundaries, recursion exit states, and integer overflows.

## 📋 The Assignment

The goal is to write a function named `ft_recursive_factorial` inside a file named `ft_recursive_factorial.c`. The function must calculate the factorial of an integer parameter (`nb`) using a recursive algorithm (a function that calls itself).

* If the input is invalid or negative, the function must return `0`.
* The execution must use recursion instead of an iterative loop structure.
* Any input that results in an integer overflow must return `0`.

### 🛠️ Allowed Functions
* None

### 📋 Function Prototype
```c
int ft_recursive_factorial(int nb);
```

---

## 💡 The Solution

We design the function to call itself with a decremented argument (`nb - 1`) until it hits our defined base case. To respect the assignment rule regarding errors/overflows, we explicitly cap the input boundary at `12`. Any value higher than 12 completely overflows a standard signed 32-bit `int` container ($13! = 6,227,020,800$, which is larger than $2,147,483,647$).

Place this exact code inside your `ft_recursive_factorial.c` file:

```c
int	ft_recursive_factorial(int nb)
{
	if (nb < 0 || nb > 12)
	{
		return (0);
	}
	if (nb == 0 || nb == 1)
	{
		return (1);
	}
	return (nb * ft_recursive_factorial(nb - 1));
}
```

### 🔍 Detailed Code Breakdown

* **`if (nb < 0 || nb > 12)`**: Drops invalid negative inputs and immediately intercepts any input greater than 12 to prevent silent calculation corruption due to data type overflow limits.
* **`if (nb == 0 || nb == 1)`**: The **Base Case**. This is the vital exit condition for recursion. When the function winds down to `1` or `0`, it returns `1` instead of calling itself again, safely unwinding the calculation stack.
* **`return (nb * ft_recursive_factorial(nb - 1))`**: The **Recursive Step**. It multiplies the current value of `nb` by the returned outcome of the exact same function evaluated for `nb - 1`.

> ⚠️ **Important Note for Submission:** Do **NOT** include headers like `#include <unistd.h>` or an `int main(void)` function inside your turned-in file. Leaving a main function inside your code repository will break the Moulinette test pipeline compiling mechanism.

---

## 🛠️ Compilation and Testing

To verify that your calculations are accurate and wind down your execution stack without causing a segmentation fault, create an isolated testing workspace.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   int ft_recursive_factorial(int nb);

   int main(void)
   {
       printf("Factorial of -3: %d (Expected: 0)\n", ft_recursive_factorial(-3));
       printf("Factorial of  0: %d (Expected: 1)\n", ft_recursive_factorial(0));
       printf("Factorial of  4: %d (Expected: 24)\n", ft_recursive_factorial(4));
       printf("Factorial of 12: %d (Expected: 479001600)\n", ft_recursive_factorial(12));
       printf("Factorial of 64: %d (Expected: 0 due to overflow)\n", ft_recursive_factorial(64));
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_recursive_factorial.c main.c -o test_recursive
   ```

3. **Run your program**:
   ```bash
   ./test_recursive
   ```

---

## 📦 Submission

Clean your project folder directory by executing `rm main.c test_recursive`. Ensure your `ex13/` directory contains **only** the `ft_recursive_factorial.c` file before committing and pushing your code changes to Git.

