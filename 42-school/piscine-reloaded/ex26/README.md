# 42 Piscine: C Module - ft_count_if
A small guide to a function that counts how many elements of a string array satisfy a given predicate function.
## 📋 The Assignment
Write a function named `ft_count_if` inside a file named `ft_count_if.c`. The function returns the number of elements of the array that, when passed to a function `f`, return `1`. The array is delimited by `0`.
### 📋 Function Prototype
```c
int	ft_count_if(char **tab, int (*f)(char*));
```
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_count_if.c`:
```c
int	ft_count_if(char **tab, int (*f)(char *))
{
	int	i;
	int	count;

	i = 0;
	count = 0;
	while (tab[i] != 0)
	{
		if (f(tab[i]) == 1)
			count++;
		i++;
	}
	return (count);
}
```
### 🔍 Detailed Code Breakdown
* **`int (*f)(char *)`**: A function pointer parameter. `f` is the address of some predicate function that takes a string and returns an `int`, so the caller decides what "counts" by passing in whichever function implements that check.
* **`while (tab[i] != 0)`**: Since no length is given, the array is walked until it hits the `0`/`NULL` sentinel that marks its end, the same convention `argv` uses.
* **`if (f(tab[i]) == 1) count++;`**: Calls the predicate on the current string and only counts a return value of exactly `1`.
* **`return (count)`**: Hands back the final tally once every element up to the `0` sentinel has been checked.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, and no `for` loops.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>

   int	ft_count_if(char **tab, int (*f)(char *));

   int	starts_with_a(char *s)
   {
       return (s[0] == 'a');
   }

   int	main(void)
   {
       char *tab[] = {"apple", "banana", "avocado", "cherry", "ant", 0};

       printf("%d\n", ft_count_if(tab, starts_with_a));
       return (0);
   }
   ```
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_count_if.c main.c -o test_count
   ```
3. **Run your program**:
   ```bash
   ./test_count
   ```
   Expected output:
   ```
   3
   ```
4. **Check the norm**:
   ```bash
   norminette ft_count_if.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_count`. Ensure your exercise directory contains **only** `ft_count_if.c` before committing and pushing your code changes to Git.
