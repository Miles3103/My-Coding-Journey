# 42 Piscine: C 01 - Exercise 00 / 09 (ft_ft)

An educational guide explaining how to write a C function that manipulates memory directly by dereferencing a pointer to an integer.

## 📋 The Assignment

The goal is to write a function named `ft_ft` inside a file named `ft_ft.c`. The function accepts a pointer to an integer as a parameter and sets the value stored at that memory address to exactly `42`.

### 🛠️ Allowed Functions
* None

### 📋 Function Prototype
```c
void ft_ft(int *nbr);
```

---

## 💡 The Solution

This exercise introduces the concept of **pointers** and **dereferencing**. The parameter `int *nbr` contains a memory address rather than a direct integer value. To modify the data sitting at that address, we use the dereference operator (`*`).

Place this exact code inside your `ft_ft.c` file:

```c
void	ft_ft(int *nbr)
{
	*nbr = 42;
}
```

### 🔍 Detailed Code Breakdown

* **`int *nbr`**: Declares that the parameter `nbr` is a pointer holding the memory address of an integer variable.
* **`*nbr = 42;`**: The `*` prefix tells the compiler to look *inside* the address stored in `nbr` and modify the actual value located there, overwriting it with `42`.

> ⚠️ **Important Note for Submission:** Do **NOT** include `#include <unistd.h>` or an `int main(void)` function inside the final submission file. Since no system calls (like `write`) are used, headers are not allowed by the 42 Norminette here.

---

## 🛠️ Compilation and Testing

To verify that your function successfully modifies data outside its own scope, create an independent validation file.

1. **Create an isolated `main.c` file**:
   ```c
   #include <stdio.h>

   void ft_ft(int *nbr);

   int main(void)
   {
       int a;

       a = 0;
       printf("Before: %d\n", a); // Expected: 0
       ft_ft(&a);                 // Pass the address of 'a' using the & operator
       printf("After: %d\n", a);  // Expected: 42
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_ft.c main.c -o test_pointer
   ```

3. **Run your program**:
   ```bash
   ./test_pointer
   ```

4. **Expected Output**:
   ```bash
   Before: 0
   After: 42
   ```

---

## 📦 Submission

Clean up your workspace folder by running `rm main.c test_pointer`. Ensure your `ex09/` directory contains **only** the `ft_ft.c` file before committing and pushing your code to Git.

