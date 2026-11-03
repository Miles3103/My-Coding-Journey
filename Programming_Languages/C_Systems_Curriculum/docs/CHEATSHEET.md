# C Cheat Sheet

## Compile & run
```bash
gcc -std=gnu11 -Wall -Wextra -Wpedantic -g -O0 -fsanitize=address,undefined prog.c -o prog
./prog; echo $?              # run, then show the exit status
gcc -c file.c -o file.o      # compile only      gcc a.o b.o -o prog   # link only
gcc -E file.c                # preprocess only   gcc -S file.c        # to assembly
gcc -Iinclude ...            # where to look for #include "..."
gcc ... -pthread             # threads (Project 4)    gcc ... -lm   # math library
```

## printf formats
| `%d` int | `%u` unsigned | `%ld` long | `%zu` size_t | `%td` ptrdiff_t |
|---|---|---|---|---|
| `%f` / `%.2f` double | `%c` char | `%s` string | `%x` / `%02X` hex | `%p` pointer (cast `(void *)`) |

## Declarations: read right to left
| | |
|---|---|
| `int *p` | pointer to int |
| `const char *p` | pointer to const char (can't change the text) |
| `char *const p` | const pointer to char (can't repoint) |
| `int *a[4]` | array of 4 pointers to int |
| `int (*f)(int)` | pointer to a function taking int, returning int |

## Strings (`<string.h>`)
| Safe-ish | Notes | Avoid |
|---|---|---|
| `strlen(s)` | length without `'\0'` | `gets` (removed) |
| `strcmp(a,b)==0` | equality | `strcpy`, `strcat` (no bounds) |
| `memcpy(d,s,n)` | non-overlapping bytes | `strncpy` (may not terminate) |
| `memmove(d,s,n)` | overlapping bytes OK | `sprintf` (no bounds) |
| `snprintf(buf,size,fmt,...)` | bounded; check return `>= size` | `atoi` on user input |
| `strstr`, `strchr` | search | |

## Memory
```c
T *p = malloc(n * sizeof *p);   if (!p) ...;      free(p); p = NULL;
T *p = calloc(n, sizeof *p);                       /* zeroed, overflow-checked */
tmp = realloc(p, new_bytes); if (!tmp) {/* p still valid */} else p = tmp;
```
Allocate `strlen(s) + 1` for a copy of a string. Every `malloc` needs exactly one `free`.

## Files (`<stdio.h>`)
```c
FILE *fp = fopen(path, "r");  if (!fp) { perror(path); ... }
getline(&line, &cap, fp)      /* needs free(line) afterwards */
fread/fwrite(buf, size, count, fp)   /* check the returned count */
fclose(fp)                    /* check this too */
```
Modes: `r` read, `w` write (truncates), `a` append, `b` binary.

## Integers & bits
`x |= 1u<<n` set · `x &= ~(1u<<n)` clear · `x & (1u<<n)` test · `(n+15)&~15u` round up to 16 · `x & (x-1)` clear lowest set bit.
Use `size_t` for sizes/indexes, `<stdint.h>` types (`uint32_t`) for formats.

## Headers → what they give you
| Header | Provides |
|---|---|
| `<stdio.h>` | printf, FILE, fopen, getline, perror |
| `<stdlib.h>` | malloc, free, qsort, strtol, exit, abs |
| `<string.h>` | strlen, memcpy, strcmp, strstr |
| `<stdint.h>` / `<stddef.h>` / `<stdbool.h>` | fixed-width ints / size_t, offsetof / bool |
| `<limits.h>` | INT_MAX, CHAR_BIT |
| `<errno.h>` / `<ctype.h>` | errno, ENOENT / toupper, isdigit (cast to `unsigned char`) |
| `<unistd.h>` | getopt, read, write, close, sbrk |
| `<assert.h>` | assert |

## getopt gotcha
With `#define _POSIX_C_SOURCE ...`, `getopt` stops at the first non-option, so `prog PATTERN -n file` treats `-n` as a file name (POSIX behavior). Without that define on glibc, flags after operands are reordered (GNU behavior). Know which one you have.

## gdb
`gdb ./prog` → `run` · `bt` · `frame N` · `print x` · `info locals` · `break file.c:42` · `next` · `step` · `continue` · `watch x` · `x/16xb p` · `quit`

## valgrind
`valgrind --leak-check=full --track-origins=yes ./prog`

## Make
```make
target: deps
<TAB>command          # $@ = target   $< = first dep   $^ = all deps
```
`make` · `make clean` · `make -n` (dry run) · `make BUILD=release`

## Shell
`cmd > f` stdout to file · `cmd 2> f` stderr · `cmd 2>&1 | less` both · `cmd < f` stdin · `a | b` pipe · `echo $?` exit status · `man 3 getline` manual (section 2 = syscalls, 3 = C library)
