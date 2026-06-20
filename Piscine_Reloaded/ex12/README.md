# 42 Piscine: C Module - Exercise 12 (ft_iterative_factorial)

An educational guide explaining how to write an efficient, iterative C function that calculates the mathematical factorial of a number within standard execution time limits while safely handling invalid boundaries and integer overflows.

## 📋 The Assignment

The goal is to write a function named `ft_iterative_factorial` inside a file named `ft_iterative_factorial.c`. The function must calculate the factorial of an integer parameter (`nb`) using an iterative loop algorithm.

* If the input is invalid or negative, the function must return `0`.
* The execution must complete in less than 2 seconds (enforcing an iterative approach rather than a massive calculation stack).
* Any input that results in an integer overflow must return `0`.

### 🛠️ Allowed Functions
* None

### 📋 Function Prototype
```c
int ft_iterative_factorial(int nb);
```

---

## 💡 The Solution

We initialize our tracking accumulator variable to `1` and loop downward from `nb` to `1`, multiplying the values along the way. To respect the assignment rule regarding errors/overflows and keep execution instantaneous, we explicitly cap the input boundary at `12`. Any value higher than 12 completely overflows a standard signed 32-bit `int` container ($13! = 6,227,020,800$, which is larger than $2,147,483,647$).

Place this exact code inside your `ft_iterative_factorial.c` file:

```c
int	ft_iterative_factorial(int nb)
{
	int	result;

	if (nb < 0 || nb > 12)
	{
		return (0);
	}
	result = 1;
	while (nb > 0)
	{
		result *= nb;
		nb--;
	}
	return (result);
}
```

### 🔍 Detailed Code Breakdown

* **`if (nb < 0 || nb > 12)`**: Drops invalid negative inputs and immediately intercepts any input greater than 12 to prevent silent calculation corruption due to data type overflow limits.
* **`result = 1;`**: Baseline initialization. This handles the mathematical definition where $0! = 1$. If `nb` is 0, the `while` loop condition is skipped entirely, returning the correct value.
* **`while (nb > 0)`**: Multiplies the current accumulator state by the value of `nb` and decrements `nb` by 1 until it hits 0.

> ⚠️ **Important Note for Submission:** Do **NOT** include headers like `#include <unistd.h>` or an `int main(void)` function inside your turned-in file. Leaving a main function inside your code repository will break the Moulinette test pipeline compiling mechanism.

---

## 🛠️ Compilation and Testing

To verify that your calculations are accurate and return instantaneous values without formatting issues, create an isolated testing workspace.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   int ft_iterative_factorial(int nb);

   int main(void)
   {
       printf("Factorial of -3: %d (Expected: 0)\n", ft_iterative_factorial(-3));
       printf("Factorial of  0: %d (Expected: 1)\n", ft_iterative_factorial(0));
       printf("Factorial of  4: %d (Expected: 24)\n", ft_iterative_factorial(4));
       printf("Factorial of 12: %d (Expected: 479001600)\n", ft_iterative_factorial(12));
       printf("Factorial of 15: %d (Expected: 0 due to overflow)\n", ft_iterative_factorial(15));
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_iterative_factorial.c main.c -o test_factorial
   ```

3. **Run your program**:
   ```bash
   ./test_factorial
   ```

---

## 📦 Submission

Clean your project folder directory by executing `rm main.c test_factorial`. Ensure your `ex12/` directory contains **only** the `ft_iterative_factorial.c` file before committing and pushing your code changes to Git.

