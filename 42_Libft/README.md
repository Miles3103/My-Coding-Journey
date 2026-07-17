*This project has been created as part of the 42 curriculum by iismail-.*

# Libft — Your Very First Own Library

## Description

Libft is a C library that reimplements a set of standard functions from the C standard library (`libc`), along with additional utility functions and a linked list API. The goal is to build a solid foundation of reusable C functions that can be used throughout the 42 curriculum.

The library is organized into three parts:
- **Part 1** — Reimplementations of standard libc functions (string, memory, character classification)
- **Part 2** — Additional utility functions not found in libc (substring, split, join, etc.)
- **Part 3** — Linked list manipulation functions using the `t_list` structure

## Instructions

### Compilation

```bash
make        # Build libft.a
make clean  # Remove object files
make fclean # Remove object files and libft.a
make re     # Full rebuild
```

### Usage

Include the header in your C files and link against the library:

```c
#include "libft.h"
```

```bash
cc -Wall -Wextra -Werror your_file.c -L. -lft -o your_program
```

## Function Reference

### Part 1 — Libc Functions

| Function | Description |
|----------|-------------|
| `ft_isalpha` | Returns 1 if character is alphabetic, 0 otherwise |
| `ft_isdigit` | Returns 1 if character is a digit, 0 otherwise |
| `ft_isalnum` | Returns 1 if character is alphanumeric, 0 otherwise |
| `ft_isascii` | Returns 1 if character is in ASCII range, 0 otherwise |
| `ft_isprint` | Returns 1 if character is printable, 0 otherwise |
| `ft_toupper` | Converts lowercase letter to uppercase |
| `ft_tolower` | Converts uppercase letter to lowercase |
| `ft_strlen` | Returns the length of a string |
| `ft_memset` | Fills memory with a constant byte |
| `ft_bzero` | Zeroes out a block of memory |
| `ft_memcpy` | Copies memory area (no overlap handling) |
| `ft_memmove` | Copies memory area (overlap-safe) |
| `ft_strlcpy` | Size-bounded string copy |
| `ft_strlcat` | Size-bounded string concatenation |
| `ft_strchr` | Locates first occurrence of character in string |
| `ft_strrchr` | Locates last occurrence of character in string |
| `ft_strncmp` | Compares two strings up to n characters |
| `ft_memchr` | Locates byte in memory block |
| `ft_memcmp` | Compares two memory areas |
| `ft_strnstr` | Locates substring within a length-limited string |
| `ft_atoi` | Converts a string to an integer |
| `ft_calloc` | Allocates and zero-initializes memory |
| `ft_strdup` | Duplicates a string using malloc |

### Part 2 — Additional Functions

| Function | Description |
|----------|-------------|
| `ft_substr` | Extracts a substring from a string |
| `ft_strjoin` | Concatenates two strings into a new allocation |
| `ft_strtrim` | Trims characters from both ends of a string |
| `ft_split` | Splits a string by a delimiter into an array |
| `ft_itoa` | Converts an integer to a string |
| `ft_strmapi` | Applies a function to each character, returns new string |
| `ft_striteri` | Applies a function to each character in-place |
| `ft_putchar_fd` | Outputs a character to a file descriptor |
| `ft_putstr_fd` | Outputs a string to a file descriptor |
| `ft_putendl_fd` | Outputs a string followed by newline to a file descriptor |
| `ft_putnbr_fd` | Outputs an integer to a file descriptor |

### Part 3 — Linked List

| Function | Description |
|----------|-------------|
| `ft_lstnew` | Creates a new list node |
| `ft_lstadd_front` | Adds a node at the beginning of the list |
| `ft_lstsize` | Returns the number of nodes in the list |
| `ft_lstlast` | Returns the last node of the list |
| `ft_lstadd_back` | Adds a node at the end of the list |
| `ft_lstdelone` | Frees a single node using a delete function |
| `ft_lstclear` | Frees all nodes of the list |
| `ft_lstiter` | Iterates over the list and applies a function |
| `ft_lstmap` | Creates a new list by applying a function to each node |

## Resources

- [C Standard Library Reference — cppreference.com](https://en.cppreference.com/w/c)
- [man pages — Linux manual pages](https://man7.org/linux/man-pages/)
- [42 Norm documentation](https://github.com/42School/norminette)
- [Understanding linked lists — GeeksForGeeks](https://www.geeksforgeeks.org/linked-list-data-structure/)

### AI Usage

AI was used to assist with generating boilerplate structure and verifying compilation. All logic was reviewed and understood before inclusion. AI was not used as a substitute for understanding the underlying concepts.
