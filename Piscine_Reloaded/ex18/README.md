# 42 Piscine: C Module - ft_print_params
A small guide to a program that prints every command-line argument it receives (excluding the program name itself), one character at a time via a custom `ft_putchar`, each argument on its own line.
## 📋 The Assignment
Create a program that displays its given arguments, in the order they were given, except for `argv[0]`. Each argument has to have its own line.
### 🛠️ Allowed Functions
* `ft_putchar`
---
## 💡 The Solution
This is the content of `ft_print_params.c`:
```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

int	main(int argc, char **argv)
{
	int	i;
	int	j;

	i = 1;
	while (i < argc)
	{
		j = 0;
		while (argv[i][j] != '\0')
		{
			ft_putchar(argv[i][j]);
			j++;
		}
		ft_putchar('\n');
		i++;
	}
	return (0);
}
```
### 🔍 Detailed Code Breakdown
* **`ft_putchar`**: The one function the subject allows. Writes a single character to standard output via `write`.
* **`i = 1`**: Starts at index `1` to skip `argv[0]`, which is the program's own name.
* **Outer `while (i < argc)`**: Runs once per argument that was actually passed.
* **Inner `while (argv[i][j] != '\0')`**: Walks the characters of the current argument and prints each one with `ft_putchar`.
* **`ft_putchar('\n')` then `i++`**: After an argument's characters are fully printed, move to the next line and the next argument.
* **No arguments given**: `argc` is `1` in that case, so the outer loop condition (`1 < 1`) is false immediately and nothing is printed — no crash.
> ⚠️ **Important Note for Submission:** Keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, no `for` loops.
---
## 🛠️ Compilation and Testing
Since this exercise produces a full program (it has its own `main`), there's no separate `main.c` needed.
1. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_print_params.c -o ft_print_params
   ```
2. **Run your program**:
   ```bash
   ./ft_print_params hello world 42
   ```
   Expected output:
   ```
   hello
   world
   42
   ```
3. **Check the norm**:
   ```bash
   norminette ft_print_params.c
   ```
---
## 📦 Submission
Clean your project folder by removing the compiled binary. Ensure your exercise directory contains **only** `ft_print_params.c` before committing and pushing your code changes to Git.

> Note: this exercise's exact official filename/turn-in spec wasn't provided directly — it was inferred from the gap between `ex14` and `ex19` and the function list in `ex24`'s subject. Rename the file if your actual subject specifies something different.
