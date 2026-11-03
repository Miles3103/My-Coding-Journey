# Lesson 10: Files, Errors & Command-Line Arguments

**Time:** ~4 h | **Prev:** [Lesson 9](../09_heap_memory/README.md) | **Next:** [Lesson 11](../11_modules_and_make/README.md)
**Files:** [`fileio.c`](fileio.c), [`args.c`](args.c)

## You will be able to
- read and write text and binary files, checking every call
- handle failures with `errno`, `perror`, `strerror`
- read `argc`/`argv`, parse numbers safely with `strtol`, and set exit statuses

---

## 1. Concept: a `FILE *` is a buffered stream

`fopen` gives you a `FILE *`, an opaque handle to a file with an in-memory buffer. Three are open for you already: `stdin` (keyboard/pipe), `stdout` (screen), `stderr` (errors, unbuffered).

| Task | Functions |
|---|---|
| open / close | `fopen(path, mode)`, `fclose(fp)` |
| modes | `"r"` read, `"w"` write (truncates!), `"a"` append, add `b` for binary (`"rb"`) |
| text out | `fprintf(fp, ...)`, `fputs` |
| text in | `getline` (any length, heap buffer), `fgets` (fixed buffer) |
| binary | `fread(buf, size, count, fp)`, `fwrite(...)` |
| position | `fseek`, `ftell`, `rewind` |
| status | `feof(fp)`, `ferror(fp)` |

### Rules that prevent bugs
1. **Check every `fopen`** (it returns NULL on failure) **and every `fread`/`fwrite`** (they return how many items were done, and a short count means a problem).
2. **Check `fclose` too.** Buffered data is written at close, and a full disk surfaces *there*.
3. **EOF vs. error:** `getline`/`fgets` return failure at both end-of-file and errors. Afterwards call `ferror(fp)` to tell them apart.
4. **Never loop on `while (!feof(fp))`.** `feof` only becomes true *after* a read fails, so you'd process one bogus extra item. Loop on the read function's return value instead (the example does).
5. **Close what you open.** Leaked file descriptors crash long-running programs (a server dies with `Too many open files`).

### Buffering and why `printf` output sometimes appears late
`stdout` is **line-buffered** on a terminal and **fully buffered** when redirected to a file or pipe; `stderr` is unbuffered. When debugging crashes, print to `stderr` (`fprintf(stderr, ...)`) so output isn't lost in the buffer.

### Errors: `errno`
Failing library/system calls set the global `errno` to a code (e.g. `ENOENT` = 2, "No such file or directory").
- `perror("prefix")` prints `prefix: <message>` to stderr.
- `strerror(errno)` returns the message string.
- **Save `errno` immediately** (`int saved = errno;`) because other calls, including `printf`, can overwrite it.
- Only look at `errno` **after a call reports failure**. A successful call may leave stale values.

### Command-line arguments
```c
int main(int argc, char *argv[])
```
`argc` is the number of arguments **including the program name**; `argv[0]` is the program name and `argv[argc]` is `NULL`. Everything arrives as text, so numbers need converting.

**`atoi` vs `strtol`:** `atoi("abc")` silently returns 0. `strtol` lets you detect problems:
```c
char *end; errno = 0;
long v = strtol(s, &end, 10);
if (errno != 0 || end == s || *end != '\0') /* bad input */;
```
(`end == s`: no digits at all; `*end != '\0'`: trailing junk like `7x`; `errno`: overflow.)

### Exit status
`return n;` from `main` (or `exit(n)`) becomes `$?` in the shell. Convention: **0 success, non-zero failure.** `grep`-style tools use 0 = found, 1 = not found, 2 = error.

### The shell side: streams and redirection
```bash
./prog > out.txt          # stdout to a file
./prog 2> err.txt         # stderr to a file
./prog 2>&1 | less        # merge both and pipe
./prog < input.txt        # stdin from a file
cat a.txt | ./prog        # stdin from a pipe
```
Writing **results to stdout and errors to stderr** makes your tools composable, which is the Unix way.

## 2. Run it
```bash
make
./bin/fileio                     # writes, reads, round-trips a binary file, then cleans up
./bin/args 12 abc 7x -5          # parse arguments
./bin/args; echo "exit=$?"       # no arguments → status 2
./bin/args 12 abc 2>/dev/null; echo "exit=$?"   # hides the error text; status 1
```

## 3. Common mistakes
- Not checking `fopen`'s result, which gives a NULL dereference crash instead of a clear message.
- `while (!feof(fp))` loops (see above).
- Opening with `"w"` and wiping a file you meant to append to.
- Using `atoi` on user input.
- Forgetting `argv[0]` is the program name, so the first real argument is `argv[1]`.
- Mixing binary data with text mode, or writing structs raw (Lesson 8).
- Reading into a fixed buffer with no length (`scanf("%s", buf)`). Use `fgets`/`getline`.

## 4. Exercises
- [ ] **E1.** Write `mycat`: prints each file named on the command line (or stdin if none). Report unreadable files with `perror` and continue. Exit non-zero if any failed.
- [ ] **E2.** Write `wc_lite file`: count lines, words and bytes. Compare with `wc`.
- [ ] **E3.** Write `copy src dst` using `fread`/`fwrite` with a 64 KB buffer. Verify with `cmp`. Test with an empty file and a 10 MB file.
- [ ] **E4.** Write `sum`: read integers from the file arguments (one per line), use `strtol`, skip and report invalid lines on stderr, print the total. Exit 1 if any line was invalid.
- [ ] **E5.** Make a program that appends a timestamped line to `log.txt` each run (`"a"` mode, `time()`, `strftime`). Run it five times and `cat` the file.
- [ ] **E6.** Write a tiny binary record file: write 3 records field by field (id as `uint32_t`, a length-prefixed name), read them back, and hex-dump with `xxd`. Why did we avoid `fwrite(&record, ...)`?
- [ ] **E7 (stretch).** Add `-n` (number lines) and `-v` (verbose) flags to `mycat` using a manual `argv` loop. Then re-do it with `getopt` as in Project 1.

## 5. Self-check
<details><summary>Questions</summary>

1. What should you do with `getline`'s `-1` return value?
2. Why save `errno` right away?
3. What does `end == s` mean after `strtol(s, &end, 10)`?
4. Where should error messages go and why?

**Answers:** (1) Check `ferror(fp)`: -1 means either end-of-file or a read error. (2) Later calls may overwrite it. (3) No digits were found: the input isn't a number. (4) `stderr`, so they don't pollute stdout when the output is piped or redirected.
</details>

## 6. Where this shows up later
- **Project 1:** the whole tool: `getopt`, `getline`, `perror`, exit codes.
- **Project 2:** binary log files with `fwrite`, `fflush`, `fsync`.
- **Project 3:** reading headers with `fread` and validating sizes.
