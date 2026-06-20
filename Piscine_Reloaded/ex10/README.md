# 42 Piscine: C 01 - Exercise 01 / 10 (ft_swap)

An educational guide explaining how to write a C function that swaps the data contents of two distinct memory addresses using a temporary holding variable.

## 📋 The Assignment

The goal is to write a function named `ft_swap` inside a file named `ft_swap.c`. The function must swap the values of two integers whose memory addresses are passed as pointer arguments.

### 🛠️ Allowed Functions
* None

### 📋 Function Prototype
```c
void ft_swap(int *a, int *b);
```

---

## 💡 The Solution

To swap two values in memory without losing either value, we must introduce a local third variable (often called `temp` or `storage`). This acts as a temporary safe house during the values exchange.

Place this exact, bug-free code inside your `ft_swap.c` file:

```c
void	ft_swap(int *a, int *b)
{
	int	temp;

	temp = *a;
	*a = *b;
	*b = temp;
}
```

### 🔍 Detailed Code Breakdown

1. **`int temp;`**: Allocates a localized integer space on the stack frame.
2. **`temp = *a;`**: Dereferences pointer `a` to extract its integer value, copying it securely inside `temp`.
3. **`*a = *b;`**: Dereferences pointer `b` to read its value, copying that data directly into the memory location pointed to by `a` (overwriting its old value).
4. **`*b = temp;`**: Safely retrieves the original value of `a` from `temp`, copying it directly into the memory location pointed to by `b`.

---

## 🛠️ Compilation and Testing

To verify that your function successfully modifies data boundaries without causing segmentation or prototype mismatches, isolate your validation tools.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   void ft_swap(int *a, int *b);

   int main(void)
   {
       int x;
       int y;

       x = 4;
       y = 9;
       printf("Before swap -> x: %d, y: %d\n", x, y);
       
       ft_swap(&x, &y); // Passing memory addresses using the reference operator
       
       printf("After swap  -> x: %d, y: %d\n", x, y);
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_swap.c main.c -o test_swap
   ```

3. **Run your program**:
   ```bash
   ./test_swap
   ```

4. **Expected Output**:
   ```bash
   Before swap -> x: 4, y: 9
   After swap  -> x: 9, y: 4
   ```

---

## 📦 Submission

Ensure you do **not** include `#include <unistd.h>`, `ft_putchar`, or an `int main(void)` function inside your submitted file. Clean your directory folder by executing `rm main.c test_swap`. Your `ex10/` directory must contain **only** the `ft_swap.c` file before pushing your code to Git.

