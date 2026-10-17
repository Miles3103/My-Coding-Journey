# 42 Piscine: C 00 - Exercise 03 / 08 (ft_is_negative)

An educational guide explaining how to write a C function that evaluates the sign of a passed integer and prints a corresponding character to standard output.

## 📋 The Assignment

The goal is to write a function named `ft_is_negative` inside a file named `ft_is_negative.c`. The function checks an incoming integer parameter (`n`) and outputs:
* `'N'` if the integer is strictly less than zero (negative).
* `'P'` if the integer is greater than or equal to zero (positive or null).

### 🛠️ Allowed Functions
* `ft_putchar` (which utilizes the `write` system call underneath).

### 📋 Function Prototype
```c
void ft_is_negative(int n);
```

---

## 💡 The Solution

This exercise introduces basic conditional logic using an `if / else` branch statement. We compare the signed integer `n` directly against standard boundary limits.

Place this exact code inside your `ft_is_negative.c` file:

```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

void	ft_is_negative(int n)
{
	if (n < 0)
	{
		ft_putchar('N');
	}
	else
	{
		ft_putchar('P');
	}
}
```

> ⚠️ **Important Note for Submission:** Do **NOT** include your `int main(void)` function inside the final submission file. Leaving a main function inside your folder triggers a duplicate symbol compilation error when the Moulinette tests your work, resulting in an automatic failure.

---

## 🛠️ Compilation and Testing

To test your function across various integer boundaries (positive, negative, and zero), create an independent validation workspace.

1. **Create an isolated `main.c` file**:
   ```c
   void ft_is_negative(int n);

   int main(void)
   {
       ft_is_negative(-5);  // Expected: N
       ft_is_negative(0);   // Expected: P
       ft_is_negative(42);  // Expected: P
       return (0);
   }
   ```
   *(Note: In your initial testing snippet, passing character literals like `'a'` or `'8'` sends their underlying ASCII values, 97 and 56, which are both evaluated as positive numbers).*

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_is_negative.c main.c -o test_sign
   ```

3. **Run your program**:
   ```bash
   ./test_sign
   ```

4. **Expected Output**:
   ```bash
   NPP
   ```

---

## 📦 Submission

Clean up your workspace folder by running `rm main.c test_sign`. Ensure your `ex08/` directory contains **only** the `ft_is_negative.c` file before committing and pushing your code to Git.

