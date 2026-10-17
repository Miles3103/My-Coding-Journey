# 42 Piscine: C Module - ft_strlen
A small guide to a function that computes the length of a null-terminated string, mirroring the standard `strlen` from `<string.h>`.
## 📋 The Assignment
Write a function named `ft_strlen` inside a file named `ft_strlen.c`. The function takes a string and returns the number of characters in it, not counting the terminating `'\0'`.
### 📋 Function Prototype
```c
int	ft_strlen(char *str);
```
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_strlen.c`:
```c
int	ft_strlen(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
		i++;
	return (i);
}
```
### 🔍 Detailed Code Breakdown
* **`i = 0`**: `i` is both the index walking the string and the running character count.
* **`while (str[i] != '\0')`**: Advances `i` until it reaches the null terminator that marks the end of the string. No braces are needed since the loop body is a single statement.
* **`return (i)`**: Once the loop exits, `i` holds exactly the number of characters before `'\0'`, which is the string's length.
* **Empty string**: If `str` is `""`, `str[0]` is already `'\0'`, the loop never runs, and the function correctly returns `0`.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, and no braces around a single-statement loop.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>

   int	ft_strlen(char *str);

   int	main(void)
   {
       printf("%d\n", ft_strlen("hello"));
       return (0);
   }
   ```
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_strlen.c main.c -o test_strlen
   ```
3. **Run your program**:
   ```bash
   ./test_strlen
   ```
   Expected output:
   ```
   5
   ```
4. **Check the norm**:
   ```bash
   norminette ft_strlen.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_strlen`. Ensure your exercise directory contains **only** `ft_strlen.c` before committing and pushing your code changes to Git.
