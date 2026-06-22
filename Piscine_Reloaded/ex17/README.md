# 42 Piscine: C Module - ft_strcmp
A small guide to a function that compares two null-terminated strings character by character, mirroring the standard `strcmp` from `<string.h>`.
## 📋 The Assignment
Write a function named `ft_strcmp` inside a file named `ft_strcmp.c`. The function compares `s1` and `s2`, returning `0` if they're identical, or the (non-zero) difference between the first pair of characters that don't match.
### 📋 Function Prototype
```c
int	ft_strcmp(char *s1, char *s2);
```
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of `ft_strcmp.c`:
```c
int	ft_strcmp(char *s1, char *s2)
{
	int	i;

	i = 0;
	while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i])
		i++;
	return (s1[i] - s2[i]);
}
```
### 🔍 Detailed Code Breakdown
* **`i = 0`**: A single index is enough since both strings are compared position by position.
* **`while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i])`**: Keeps advancing as long as neither string has ended *and* the characters at the current position match.
* **`return (s1[i] - s2[i])`**: When the loop stops, `i` points to either the first mismatching pair of characters, or the end of one (or both) strings. Subtracting the character codes gives a positive, negative, or zero result, exactly like the standard `strcmp`.
* **Equal strings**: If `s1` and `s2` are identical, the loop runs until both hit `'\0'` simultaneously, and `'\0' - '\0'` correctly returns `0`.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, no braces around a single-statement loop.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>

   int	ft_strcmp(char *s1, char *s2);

   int	main(void)
   {
       printf("%d\n", ft_strcmp("abc", "abd"));
       return (0);
   }
   ```
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_strcmp.c main.c -o test_strcmp
   ```
3. **Run your program**:
   ```bash
   ./test_strcmp
   ```
   Expected output:
   ```
   -1
   ```
4. **Check the norm**:
   ```bash
   norminette ft_strcmp.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_strcmp`. Ensure your exercise directory contains **only** `ft_strcmp.c` before committing and pushing your code changes to Git.
