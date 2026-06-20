# Print Program Arguments

A `main` that prints every command-line argument (excluding the program name itself), one character at a time via a custom `ft_putchar`, each argument on its own line.

## 📋 The Code

```c
#include <unistd.h>

void    ft_putchar(char c)
{
    write(1, &c, 1);
}

int main(int argc, char **argv)
{
    int i;
    int j;

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

## 🐛 Bugs Fixed From the Original Draft

* **Inverted loop condition.** The draft had `while (i >= argc)`. Starting from `i = 1`, that's only true when `argc == 1` (no arguments were passed) — and in that case it immediately reads `argv[1]`, which doesn't exist, and crashes. With real arguments (`argc > 1`), the loop body never ran at all. The fix is `while (i < argc)`, so it walks `argv[1]` up through `argv[argc - 1]`.
* **`i++` inside the wrong loop.** The draft incremented both `i` and `j` together inside the inner `while`, so partway through printing one argument's characters it would start jumping into a *different* argument (or past the end of `argv` entirely). `i` should only advance once per argument — it's been moved to the end of the outer loop, after the whole argument has been printed.
* **Added `ft_putchar('\n')`** after each argument so they print on separate lines rather than running together. This wasn't in the original but makes the output readable; remove it if you want them concatenated instead.

## ✅ Correctness

Compiled with `gcc -Wall -Wextra -Werror` (no warnings) and tested:

| Invocation                      | Output                  |
|----------------------------------|--------------------------|
| `./a.out`                        | (nothing — no crash)    |
| `./a.out hello world 42`         | `hello`<br>`world`<br>`42` |

## 🔍 How It Works

* **`i = 1`**: Starts at index `1` to skip `argv[0]`, which is the program's own name.
* **Outer `while (i < argc)`**: Runs once per argument that was actually passed.
* **Inner `while (argv[i][j] != '\0')`**: Walks the characters of the current argument and prints each one with `ft_putchar`.
* **`ft_putchar('\n')` then `i++`**: After an argument's characters are fully printed, move to the next line and the next argument.

## 🛠️ Testing It Yourself

```bash
gcc -Wall -Wextra -Werror main.c -o test_args
./test_args hello world 42
```
