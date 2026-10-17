# 42 Piscine: C Module - ft_strdup
A small guide to a function that reproduces the behavior of the standard `strdup`: it allocates a new buffer and copies a string into it.
## 📋 The Assignment
Write a function named `ft_strdup` inside a file named `ft_strdup.c`. Reproduce the behavior of the function `strdup` (see `man strdup`).
### 📋 Function Prototype
```c
char *ft_strdup(char *src);
```
### 🛠️ Allowed Functions
* `malloc`
---
## 💡 The Solution
This is the content of `ft_strdup.c`:
```c
#include <stdlib.h>

static int	ft_strlen(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
		i++;
	return (i);
}

char	*ft_strdup(char *src)
{
	char	*dst;
	int		i;
	int		len;

	len = ft_strlen(src);
	dst = malloc(sizeof(char) * (len + 1));
	if (dst == NULL)
		return (NULL);
	i = 0;
	while (i < len)
	{
		dst[i] = src[i];
		i++;
	}
	dst[len] = '\0';
	return (dst);
}
```
### 🔍 Detailed Code Breakdown
* **`ft_strlen`**: A hand-written helper (the real `strlen` isn't in the allowed-functions list) that counts the characters in `src` up to, but not including, the terminating `'\0'`.
* **`len = ft_strlen(src)`**: Figures out how many characters need to be copied.
* **`dst = malloc(sizeof(char) * (len + 1))`**: Allocates exactly enough space for the string plus its own null terminator.
* **`if (dst == NULL) return (NULL);`**: Mirrors the real `strdup`'s behavior — if allocation fails, it returns `NULL` rather than crashing.
* **Copy loop**: Walks `src` character by character, writing each one into the matching position in `dst`.
* **`dst[len] = '\0'`**: Manually null-terminates the new string, since the copy loop only handles the visible characters.
> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment.
---
## 🛠️ Compilation and Testing
1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>
   #include <stdlib.h>

   char	*ft_strdup(char *src);

   int	main(void)
   {
       char *dup = ft_strdup("Hello, world!");

       printf("%s\n", dup);
       free(dup);
       return (0);
   }
   ```
2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror -fsanitize=address ft_strdup.c main.c -o test_strdup
   ```
3. **Run your program**:
   ```bash
   ./test_strdup
   ```
   Expected output:
   ```
   Hello, world!
   ```
4. **Check the norm**:
   ```bash
   norminette ft_strdup.c
   ```
---
## 📦 Submission
Clean your project folder by removing `main.c` and `test_strdup`. Ensure your exercise directory contains **only** `ft_strdup.c` before committing and pushing your code changes to Git.
