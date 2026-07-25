# 42 Piscine: C Module - ft_putstr

A small guide to a function that prints a null-terminated string to standard output, character by character, using a custom `ft_putchar` helper.

## 📋 The Assignment

Write a function named `ft_putstr` inside a file named `ft_putstr.c`. The function takes a string and prints it to the standard output, one character at a time, by calling a helper function `ft_putchar`.

### 📋 Function Prototypes

```c
void	ft_putchar(char c);
void	ft_putstr(char *str);
```

### 🛠️ Allowed Functions

* `write`

---

## 💡 The Solution

This is the content of `ft_putstr.c`:

```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

void	ft_putstr(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
	{
		ft_putchar(str[i]);
		i++;
	}
}
```

### 🔍 Detailed Code Breakdown

* **`ft_putchar(char c)`**: Writes a single character to file descriptor `1` (standard output) using `write`. `&c` gives `write` the address of that one byte, and `1` tells it to write exactly one byte.
* **`ft_putstr(char *str)`**: Walks the string with index `i` until it hits the null terminator `'\0'`, calling `ft_putchar` on each character along the way.
* **Empty string handling**: If `str` is `""`, the `while` loop condition is false immediately (`str[0] == '\0'`), so nothing is printed and the function returns cleanly.

> ⚠️ **Important Note for Submission:** Do **NOT** include an `int main(void)` function inside your turned-in file, and keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, and no space between a function name and its opening parenthesis (`write(1, &c, 1);`, not `write (1, &c, 1);`).

---

## 🛠️ Compilation and Testing

1. **Create an isolated `main.c` file** outside of what you turn in:
   ```c
   #include <stdio.h>

   void	ft_putstr(char *str);

   int	main(void)
   {
       ft_putstr("Hello, world!\n");
       ft_putstr("");
       ft_putstr("42\n");
       return (0);
   }
   ```

2. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_putstr.c main.c -o test_putstr
   ```

3. **Run your program**:
   ```bash
   ./test_putstr
   ```
   Expected output:
   ```
   Hello, world!
   42
   ```

4. **Check the norm**:
   ```bash
   norminette ft_putstr.c
   ```

---

## 📦 Submission

Clean your project folder by removing `main.c` and `test_putstr`. Ensure your exercise directory contains **only** `ft_putstr.c` before committing and pushing your code changes to Git.
