# 42 Piscine: C Module - ft_foreach
A small guide to a function that applies a given function to every element of an int array, in order.
## 📋 The Assignment
Write a function named `ft_foreach` inside a file named `ft_foreach.c`. The function applies a function `f` to every element of an int array `tab`, following the array's order.
### 📋 Function Prototype
```c
void ft_foreach(int *tab, int length, void (*f)(int));
```
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_foreach.c`:
```c
void	ft_foreach(int *tab, int length, void (*f)(int))
{
	int	i;

	i = 0;
	while (i < length)
	{
		f(tab[i]);
		i++;
	}
}
```
### 🔍 Detailed Code Breakdown
* **`void (*f)(int)`**: A function pointer parameter — `f` is the address of some function that takes an `int` and returns nothing, which lets the caller plug in any such function without `ft_foreach` needing to know what it does.
* **`while (i < length)`**: Walks the array from index `0` up to (but not including) `length`, in the array's order, front to back.
* **`f(tab[i])`**: Calls whatever function was passed in, with the current element as its argument.
* **`length == 0`**: The loop condition is false immediately, so nothing is called — safe for an empty array.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, no `for` loops.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>

   void	ft_foreach(int *tab, int length, void (*f)(int));

   void	print_int(int n)
   {
       printf("%d ", n);
   }

   int	main(void)
   {
       int tab[5] = {1, 2, 3, 4, 5};

       ft_foreach(tab, 5, print_int);
       printf("\n");
       return (0);
   }
   ```
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_foreach.c main.c -o test_foreach
   ```
3. **Run your program**:
   ```bash
   ./test_foreach
   ```
   Expected output:
   ```
   1 2 3 4 5
   ```
4. **Check the norm**:
   ```bash
   norminette ft_foreach.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_foreach`. Ensure your exercise directory contains **only** `ft_foreach.c` before committing and pushing your code changes to Git.
