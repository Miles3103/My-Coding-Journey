# 42 Piscine: C Module - ft_sort_params
A small guide to a program that prints its own command-line arguments, sorted in ASCII order, one per line.
## 📋 The Assignment
Create a program inside a file named `ft_sort_params.c`. Since this is a program, the file needs its own `main`. Display all the given arguments sorted by ASCII order, except for `argv[0]`. Every argument has to have its own line.
### 🛠️ Allowed Functions
* `ft_putchar`
---
## 💡 The Solution
This is the content of `ft_sort_params.c`:
```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

static int	ft_strcmp(char *s1, char *s2)
{
	int	i;

	i = 0;
	while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i])
		i++;
	return ((unsigned char)s1[i] - (unsigned char)s2[i]);
}

static void	ft_sort(char **argv, int argc)
{
	int		i;
	int		j;
	char	*tmp;

	i = 1;
	while (i < argc - 1)
	{
		j = i + 1;
		while (j < argc)
		{
			if (ft_strcmp(argv[i], argv[j]) > 0)
			{
				tmp = argv[i];
				argv[i] = argv[j];
				argv[j] = tmp;
			}
			j++;
		}
		i++;
	}
}

static void	ft_putstr(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
	{
		ft_putchar(str[i]);
		i++;
	}
	ft_putchar('\n');
}

int	main(int argc, char **argv)
{
	int	i;

	ft_sort(argv, argc);
	i = 1;
	while (i < argc)
	{
		ft_putstr(argv[i]);
		i++;
	}
	return (0);
}
```
### 🔍 Detailed Code Breakdown
* **`ft_putchar`**: The one function the subject allows. Writes a single character to standard output via `write`.
* **`ft_strcmp`**: A hand-written stand-in for the real `strcmp` (not in the allowed list). Returns the difference between the first pair of mismatching characters, or `0` if the strings are identical, which makes `> 0` a reliable "comes after" check.
* **`ft_sort`**: A selection-style sort over `argv[1..argc-1]`, deliberately starting at index `1` to skip the program name. Swaps `char*` pointers in place whenever an out-of-order pair is found.
* **`ft_putstr`**: Prints one argument character by character via `ft_putchar`, followed by a newline so each argument lands on its own line.
* **`main`**: Sorts `argv` in place, then prints each sorted argument from index `1` to `argc - 1`.
> ⚠️ **Important Note for Submission:** Keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation and alignment, no `for` loops, and no more than 5 functions in the file.
---
## 🛠️ Compilation and Testing
Since this exercise produces a full program (it has its own `main`), there's no separate `main.c` needed.
1. **Compile using the strict 42 toolchain flags**:
   ```bash
   gcc -Wall -Wextra -Werror ft_sort_params.c -o ft_sort_params
   ```
2. **Run your program**:
   ```bash
   ./ft_sort_params banana Apple cherry apple Banana
   ```
   Expected output:
   ```
   Apple
   Banana
   apple
   banana
   cherry
   ```
3. **Check the norm**:
   ```bash
   norminette ft_sort_params.c
   ```
---
## 📦 Submission
Clean your project folder by removing the compiled binary. Ensure your exercise directory contains **only** `ft_sort_params.c` before committing and pushing your code changes to Git.
