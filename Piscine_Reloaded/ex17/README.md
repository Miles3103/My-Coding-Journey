# ft_strcmp

A function that compares two null-terminated strings character by character, mirroring the standard `strcmp` from `<string.h>`.

## 📋 The Function

```c
int ft_strcmp(char *s1, char *s2);
```

Compares `s1` and `s2`. Returns `0` if they're identical, or the (non-zero) difference between the first pair of characters that don't match.

## 💡 The Code

```c
#include <unistd.h>

int ft_strcmp(char *s1, char *s2)
{
    int i;

    i = 0;
    while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i])
    {
        i++;
    }
    return (s1[i] - s2[i]);
}
```

## 🐛 Bugs Fixed From the Original Draft

The version pasted in had a few issues that kept it from compiling/working as a complete function:

* **Comparing pointers instead of characters.** `s1 != '\0'` checks whether the pointer itself is non-null, not whether the *current character* is non-null. The fix is to index into the string: `s1[i] != '\0'`.
* **Comparing addresses instead of contents.** `s1 == s2` is true only if both pointers point to the same memory location — it does not check whether the characters they point to are equal. The fix is `s1[i] == s2[i]`.
* **Unused variable `j`.** It was declared and reset but never read or incremented. Since both strings are walked at the same position, only one index (`i`) is needed; `j` was removed.
* **Missing return / incomplete function.** The original snippet ended mid-loop with no `return` and no closing brace, so it wasn't a complete, compilable function.

## ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror` (no warnings) and tested against the real `strcmp` for sign agreement:

| `s1`    | `s2`    | `ft_strcmp` | `strcmp` |
|---------|---------|-------------|----------|
| "hello" | "hello" | 0           | 0        |
| "hello" | "world" | -15         | -15      |
| "abc"   | "abd"   | -1          | -1       |
| "abc"   | "ab"    | 99          | 99       |
| "ab"    | "abc"   | -99         | -99      |
| ""      | ""      | 0           | 0        |
| "a"     | ""      | 97          | 97       |

## 🔍 How It Works

* **`i = 0`**: A single index is enough since both strings are compared position by position.
* **`while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i])`**: Keeps advancing as long as neither string has ended *and* the characters at the current position match.
* **`return (s1[i] - s2[i])`**: When the loop stops, `i` points to either the first mismatching pair of characters, or the end of one (or both) strings. Subtracting the character codes gives a positive, negative, or zero result — exactly like the standard `strcmp`.
* **`#include <unistd.h>`**: Not used by this function (no `write` calls), but harmless to leave in.

## 🛠️ Testing It Yourself

```c
#include <stdio.h>

int ft_strcmp(char *s1, char *s2);

int main(void)
{
    printf("%d\n", ft_strcmp("abc", "abd"));
    return (0);
}
```

```bash
gcc -Wall -Wextra -Werror ft_strcmp.c main.c -o test_strcmp
./test_strcmp
```
