# ft_sort_params

Turn-in directory: `ex19/`
Files to turn in: `ft_sort_params.c`
Allowed functions: `ft_putchar`

A program that prints its own command-line arguments, sorted in ASCII order, one per line — skipping `argv[0]` (the program's own name).

## 📋 The Assignment

* This is a program, so the file needs an `int main`.
* Display all given arguments sorted by ASCII order.
* Display all arguments except `argv[0]`.
* Each argument gets its own line.
* The only function you're allowed to call is `ft_putchar` — everything else (string length, string comparison, swapping, sorting) has to be written by hand.

## 💡 The Code

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
* **`ft_strcmp`**: A hand-written stand-in for the real `strcmp` (which isn't allowed). Walks both strings together and returns the difference between the first pair of characters that don't match, or `0` if the strings are identical — exactly the convention the real `strcmp` uses, which makes `> 0` a reliable "comes after" check.
* **`ft_sort`**: A selection-style sort over `argv[1..argc-1]` (deliberately starting at index `1` to skip the program name). For each position `i`, it compares against every later position `j` and swaps pointers in place whenever an out-of-order pair is found — only the `char*` pointers are swapped, not the string contents.
* **`ft_putstr`**: Prints one argument character by character via `ft_putchar`, followed by a newline so each argument lands on its own line.
* **`main`**: Sorts `argv` in place, then walks from index `1` to `argc - 1` printing each sorted argument.

### ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror` (no warnings) and tested:

| Invocation                                  | Output                                    |
|----------------------------------------------|--------------------------------------------|
| `./a.out`                                     | (nothing — no crash with zero arguments)   |
| `./a.out hello`                               | `hello`                                    |
| `./a.out banana Apple cherry apple Banana`    | `Apple`<br>`Banana`<br>`apple`<br>`banana`<br>`cherry` |

Note the ASCII ordering: uppercase letters (`A`–`Z`, codes 65–90) sort before lowercase letters (`a`–`z`, codes 97–122), which is why `Apple`/`Banana` come before `apple`/`banana` even though they're "the same word."

### 🛠️ Norm Notes

This file is `norminette`-clean. A few rules that shaped the implementation:

* **No `for` loops.** The norm forbids them outright — only `while`/`if`/`switch` are allowed, so every loop here is a `while`.
* **Max 5 functions per file.** `ft_putchar`, `ft_strcmp`, `ft_sort`, `ft_putstr`, and `main` is exactly 5 — there's no room for a separate `ft_swap`, so the pointer swap is inlined directly inside `ft_sort`.
* **One declaration per line, no inline assignment.** Every variable is declared on its own line at the top of its scope, then assigned afterward (e.g. `int i;` then `i = 0;`, never `int i = 0;`).
* **Tabs, not spaces**, for indentation and for aligning return types from function names.
* **Return values in parentheses**: `return (0);`, not `return 0;`.

> ⚠️ Before submitting, update the header's `By:`, `Created:`, and `Updated:` lines with your real 42 login and email — they're currently placeholders.

---

## 🛠️ Compilation and Testing

```bash
gcc -Wall -Wextra -Werror ft_sort_params.c -o test_sort
./test_sort banana Apple cherry apple Banana
```

Check the norm:
```bash
norminette ft_sort_params.c
```

## 📦 Submission

Make sure `ex19/` contains only `ft_sort_params.c` before committing and pushing.
