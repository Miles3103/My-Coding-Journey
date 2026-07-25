*This project has been created as part of the 42 curriculum by iismail-.*

# Piscine 2026 — C Piscine

## Description

This repository tracks progress through the **42 C Piscine**: the full
introductory sequence of Shell and C modules (`Shell00`/`Shell01`,
`C00`–`C14`) that forms the entry point into the 42 curriculum. Each module
folder contains the numbered exercises for that module, building from basic
I/O and control flow up through pointers, string manipulation, recursion,
and command-line argument handling.

## Progress

| Module | Status | Exercises present |
|--------|--------|--------------------|
| `Shell00` | 🟡 In progress | ex00, ex01, ex02, ex04 |
| `Shell01` | ⬜ Not started | — |
| `C00` | ✅ Complete | ex00 – ex08 |
| `C01` | ✅ Complete | ex00 – ex08 |
| `C02` | 🟡 In progress | ex00, ex01, ex02 |
| `C03` | ✅ Complete | ex00 – ex05 |
| `C04` | ✅ Complete | ex00 – ex05 |
| `C05` | ✅ Complete | ex00 – ex05 |
| `C06` | ✅ Complete | ex00 – ex03 |
| `C07` – `C13` | ⬜ Not started | subject only |
| `C14` | ⬜ Not started | subject not yet added |

## Module Overview

| Module | Topics |
|--------|--------|
| `Shell00` | Basic shell commands, file creation, listing/formatting output |
| `Shell01` | Advanced shell scripting, permissions, one-liners |
| `C00` | First output functions — `ft_putchar`, alphabet/number printing, combinations |
| `C01` | Pointers — `ft_ft`, `ft_ultimate_ft`, `ft_swap`, div/mod, `ft_putstr`, `ft_strlen`, array reverse/sort |
| `C02` | String basics — `ft_strcpy`, `ft_strncpy`, `ft_str_is_alpha` |
| `C03` | String comparison/concatenation — `ft_strcmp`, `ft_strncmp`, `ft_strcat`, `ft_strncat`, `ft_strstr`, `ft_strlcat` |
| `C04` | Number/string conversion — `ft_putnbr`, `ft_atoi`, base conversion (`ft_putnbr_base`, `ft_atoi_base`) |
| `C05` | Recursion & math — iterative/recursive factorial and power, Fibonacci, integer square root |
| `C06` | Command-line arguments — printing, reversing, and sorting `argv` |
| `C07` – `C14` | Not yet started |

## Instructions

Each exercise is a standalone `.c` file compiled directly with the 42-standard flags:

```bash
cd C05/ex00
cc -Wall -Wextra -Werror ft_iterative_factorial.c your_test_main.c -o test
./test
```

No `a.out` binaries, editor swap files (`.swp`/`.swo`), or backup files
(`#file#`) should be committed — see note below.

## ⚠️ Cleanup Needed Before Submission

- Remove all committed `a.out` binaries (found in most `ex` folders) — only
  source files should be tracked; binaries should be built locally.
- Remove editor leftovers: `.fr_print_comb.c.swo`, `.ft_print_comb2.c.swp`,
  `#ft_atoi.c#`.
- Remove `C13/Chat _ Microsoft Teams.html` and its asset folder — unrelated
  to the piscine and likely contains personal chat data.
- Fix filename typos so they match their function names (also check the
  function name *inside* each file, not just the filename):
  - `ft_is_nagative.c` → `ft_is_negative.c`
  - `ft_srlen.c` → `ft_strlen.c`
  - `ft_strncyp.c` → `ft_strncpy.c`
  - `ft_strncar.c` → `ft_strncat.c`
  - `ft_stlen.c` → `ft_strlen.c`

## Resources

- [C Standard Library Reference — cppreference.com](https://en.cppreference.com/w/c)
- [man pages — Linux manual pages](https://man7.org/linux/man-pages/)
- [42 Norm documentation](https://github.com/42School/norminette)
- [Bash Reference Manual — gnu.org](https://www.gnu.org/software/bash/manual/bash.html)

### AI Usage

AI (Claude) was used to review the repository structure, identify leftover/
unwanted files (editor swaps, stray binaries, an unrelated saved webpage),
and flag filename/function-name typos before submission. Exercise logic
itself was written and understood independently.
