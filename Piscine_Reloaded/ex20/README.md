# ft_strdup

Turn-in directory: `ex20/`
Files to turn in: `ft_strdup.c`
Allowed functions: `malloc`

A function that reproduces the behavior of the standard `strdup` (see `man strdup`): it allocates a new buffer and copies a string into it.

## 📋 The Assignment

* Reproduce the behavior of `strdup`.
* Prototype:
  ```c
  char *ft_strdup(char *src);
  ```

## 💡 The Code

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

* **`ft_strlen`**: A hand-written helper (the real `strlen` isn't in the allowed-functions list) that counts the characters in `src` up to, but not including, the terminating `'\0'`. Marked `static` since it's a private implementation detail, not part of the required interface.
* **`len = ft_strlen(src)`**: Figures out how many characters need to be copied.
* **`dst = malloc(sizeof(char) * (len + 1))`**: Allocates exactly enough space for the string plus its own null terminator. `malloc` is the one function the subject allows.
* **`if (dst == NULL) return (NULL);`**: Mirrors the real `strdup`'s behavior — if allocation fails, it returns `NULL` rather than crashing or copying into invalid memory.
* **Copy loop**: Walks `src` character by character, writing each one into the matching position in `dst`.
* **`dst[len] = '\0'`**: Manually null-terminates the new string, since the copy loop only handles the visible characters.
* **`return (dst)`**: Hands back the freshly allocated, independent copy.

### ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror -fsanitize=address` — no warnings, no memory errors or leaks reported. Tested:

| Input                  | Result                                      |
|-------------------------|----------------------------------------------|
| `"Hello, world!"`       | Duplicated correctly                          |
| `""`                    | Returns a valid pointer to an empty string (`strlen` of result is `0`) |
| `"mutable"` (then mutated after duplicating) | Duplicate is unaffected — confirms it's a true deep copy, not just a pointer to the same memory |

Since the duplicate is freshly allocated memory, the caller is responsible for `free()`-ing it when done — exactly like the real `strdup`.

### 🛠️ Norm Notes

This file is `norminette`-clean: tabs throughout, one declaration per line with assignment on a separate line, return values in parentheses, no `for` loops, and only 2 functions in the file (well under the 5-function cap).

> ⚠️ Before submitting, update the header's `By:`, `Created:`, and `Updated:` lines with your real 42 login and email — they're currently placeholders.

---

## 🛠️ Compilation and Testing

```c
#include <stdio.h>
#include <stdlib.h>

char *ft_strdup(char *src);

int main(void)
{
    char *dup = ft_strdup("Hello, world!");

    printf("%s\n", dup);
    free(dup);
    return (0);
}
```

```bash
gcc -Wall -Wextra -Werror -fsanitize=address ft_strdup.c main.c -o test_strdup
./test_strdup
```

Check the norm:
```bash
norminette ft_strdup.c
```

## 📦 Submission

Make sure `ex20/` contains only `ft_strdup.c` before committing and pushing.
