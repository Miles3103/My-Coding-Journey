# ft_strlen

A function that computes the length of a null-terminated string, mirroring the standard `strlen` from `<string.h>`.

## 📋 The Function

```c
int ft_strlen(char *str);
```

Takes a string and returns the number of characters in it, not counting the terminating `'\0'`.

## 💡 The Code

```c
#include <unistd.h>

int ft_strlen(char *str)
{
    int i;

    i = 0;
    while (str[i] != '\0')
    {
        i++;
    }
    return (i);
}
```

## ✅ Correctness

This code is functionally correct. It was compiled with `gcc -Wall -Wextra -Werror` (no warnings) and tested against several cases:

| Input        | Output | Expected |
|--------------|--------|----------|
| `""`         | 0      | 0        |
| `"a"`        | 1      | 1        |
| `"hello"`    | 5      | 5        |
| `"42 school"`| 9      | 9        |
| `"a b c"`    | 5      | 5        |

## 🔍 How It Works

* **`i = 0`**: `i` is both the index walking the string and the running character count.
* **`while (str[i] != '\0')`**: Advances `i` until it reaches the null terminator that marks the end of the string.
* **`return (i)`**: Once the loop exits, `i` holds exactly the number of characters before `'\0'`, which is the string's length.
* **Empty string**: If `str` is `""`, `str[0]` is already `'\0'`, the loop never runs, and the function correctly returns `0`.
* **`#include <unistd.h>`**: Not actually used by this function (no calls to `write` or anything else from it), but it's harmless to leave in — it just doesn't add anything here.

## 🛠️ Testing It Yourself

```c
#include <stdio.h>

int ft_strlen(char *str);

int main(void)
{
    printf("%d\n", ft_strlen("hello"));
    return (0);
}
```

```bash
gcc -Wall -Wextra -Werror ft_strlen.c main.c -o test_strlen
./test_strlen
```
