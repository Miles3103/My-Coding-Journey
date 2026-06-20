# 42 Piscine: C 01 - Exercise 02 / 11 (ft_div_mod)

An educational guide explaining how to write a C function that calculates both the quotient and the remainder of an integer division, returning the results via pointers.

## 📋 The Assignment

The goal is to write a function named `ft_div_mod` inside a file named `ft_div_mod.c`. The function performs division on two integers and stores the results in variables outside the function scope by dereferencing pointer arguments.

### 🛠️ Allowed Functions
* None

### 📋 Function Prototype
```c
void ft_div_mod(int a, int b, int *div, int *mod);
```

---

## 💡 The Solution

This exercise demonstrates how a function can "return" multiple distinct values to the caller by using pointers instead of a single standard `return` statement. 

Place this exact code inside your `ft_div_mod.c` file:

```c
void	ft_div_mod(int a, int b, int *div, int *mod)
{
	*div = a / b;
	*mod = a % b;
}
```

### 🔍 Detailed Code Breakdown

* **`int a, int b`**: The input integer values for the math operation. `a` is the dividend and `b` is the divisor.
* **`int *div`**: A pointer holding the memory address where the quotient should be written.
* **`int *mod`**: A pointer holding the memory address where the remainder (modulus) should be written.
* **`*div = a / b;`**: Computes the integer division and securely saves the result directly into the memory location pointed to by `div`.
* **`*mod = a % b;`**: Computes the remainder using the modulo operator (`%`) and saves it directly into the memory location pointed to by `mod`.

> ⚠️ **Important Note for Submission:** Do **NOT** include headers like `#include <unistd.h>`, output helper functions like `ft_putchar`, or an `int main(void)` function inside your submitted file. Your file must contain only the `ft_div_mod` function.

---

## 🛠️ Compilation and Testing

To verify that your calculations are accurate and map to external variables properly without causing memory segment faults, build an isolated validation file.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   void ft_div_mod(int a, int b, int *div, int *mod);

   int main(void)
   {
       int dividend = 13;
       int divisor = 4;
       int quotient = 0;
       int remainder = 0;

       printf("Inputs -> a: %d, b: %d\n", dividend, divisor);
       
       // Pass input values directly, and pass addresses of storage variables
       ft_div_mod(dividend, divisor, &quotient, &remainder);
       
       printf("Results -> div: %d, mod: %d\n", quotient, remainder);
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_div_mod.c main.c -o test_div_mod
   ```

3. **Run your program**:
   ```bash
   ./test_div_mod
   ```

4. **Expected Output**:
   ```bash
   Inputs -> a: 13, b: 4
   Results -> div: 3, mod: 1
   ```

---

## 📦 Submission

Clean your project folder by executing `rm main.c test_div_mod`. Ensure your `ex11/` directory contains **only** the `ft_div_mod.c` file before committing and pushing your code to Git.

