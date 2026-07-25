*This project has been created as part of the 42 curriculum by iismail-.*

# Piscine Reloaded

## Description

This repository groups the exercises from the **Piscine Reloaded** track: a
progressive set of small, focused challenges that build fundamental shell
scripting and C programming skills from the ground up.

The exercises are organized into two broad groups:

- **Shell 01 (`ex00`–`ex05`)** — file manipulation, permissions, links,
  timestamps, single-command scripting, and shell-escaping tricks.
- **C Module (`ex06`–`ex27`)** — from basic loops and standard output, through
  pointers, recursion, arrays, function pointers, macros, headers, and a
  first hand-written `Makefile`, culminating in small libc-style utilities
  that are the direct ancestors of the functions built in `libft`.

Each exercise lives in its own directory with its own dedicated `README.md`
explaining the assignment, the approach taken, and any edge cases handled.

## Exercise Index

| # | Directory | Exercise | Summary |
|---|-----------|----------|---------|
| 00 | `ex00` | File replication | Recreate a set of files/dirs matching a given `ls -l` output (types, permissions, links, timestamps) |
| 01 | `ex01` | `z` | Create a file that outputs `Z\n` when read |
| 02 | `ex02` | `clean` | One-line script that finds and deletes temp files recursively |
| 03 | `ex03` | `find_sh.sh` | One-line script that lists `.sh` files without their extension |
| 04 | `ex04` | `MAC.sh` | One-line script extracting MAC addresses from network interfaces |
| 05 | `ex05` | `MaRViN` | Create a file with an exact 2-byte content and a deliberately hostile filename |
| 06 | `ex06` | `ft_print_alphabet` | Print the lowercase alphabet |
| 07 | `ex07` | `ft_print_numbers` | Print digits `0`–`9` |
| 08 | `ex08` | `ft_is_negative` | Print `'N'`/`'P'` depending on an integer's sign |
| 09 | `ex09` | `ft_ft` | Set an integer's value through a pointer |
| 10 | `ex10` | `ft_swap` | Swap two integers via pointers |
| 11 | `ex11` | `ft_div_mod` | Compute quotient and remainder via pointers |
| 12 | `ex12` | `ft_iterative_factorial` | Iterative factorial with overflow/edge handling |
| 13 | `ex13` | `ft_recursive_factorial` | Recursive factorial with overflow/edge handling |
| 14 | `ex14` | `ft_sqrt` | Integer square root, `0` if irrational |
| 15 | `ex15` | `ft_putstr` | Print a string using a `ft_putchar` helper |
| 16 | `ex16` | `ft_strlen` | Reimplementation of `strlen` |
| 17 | `ex17` | `ft_strcmp` | Reimplementation of `strcmp` |
| 18 | `ex18` | `ft_print_params` | Print each CLI argument on its own line |
| 19 | `ex19` | `ft_sort_params` | Print CLI arguments sorted in ASCII order |
| 20 | `ex20` | `ft_strdup` | Reimplementation of `strdup` |
| 21 | `ex21` | `ft_range` | Build an int array covering `[min, max)` |
| 22 | `ex22` | `ft_abs.h` | An `ABS` macro (the one Norm exception) |
| 23 | `ex23` | `ft_point.h` | Define a `t_point` struct/type for a given `main` |
| 24 | `ex24` | Makefile | Hand-written `Makefile` building `libft.a` from `srcs/`/`includes/` |
| 25 | `ex25` | `ft_foreach` | Apply a function to every element of an int array |
| 26 | `ex26` | `ft_count_if` | Count array elements satisfying a predicate |
| 27 | `ex27` | `ft_display_file` | Print a file's contents given as a CLI argument |

## Instructions

Each exercise is self-contained in its own directory. Most C exercises are a
single `.c` file meant to be compiled and tested individually, e.g.:

```bash
cd ex16
cc -Wall -Wextra -Werror ft_strlen.c your_test_main.c -o test
./test
```

Exercises that ship their own `Makefile` (`ex24`, `ex27`) should be built with:

```bash
cd ex24
make
```

Refer to each exercise's own `README.md` for the exact expected behavior,
function prototype, and any constraints specific to that exercise (e.g.
allowed functions, forbidden loop types, single-command-only scripts, etc.).

## Resources

- [Bash Reference Manual — gnu.org](https://www.gnu.org/software/bash/manual/bash.html)
- [man pages — Linux manual pages](https://man7.org/linux/man-pages/)
- [C Standard Library Reference — cppreference.com](https://en.cppreference.com/w/c)
- [42 Norm documentation](https://github.com/42School/norminette)

### AI Usage

AI (Claude) was used to review completed exercises for correctness, help
draft and word individual exercise `README.md` files, and build small
non-submitted test scripts/programs to validate expected behavior before
peer evaluation. All exercise logic was written and understood
independently; AI was not used to generate solutions to the assignments
themselves.
