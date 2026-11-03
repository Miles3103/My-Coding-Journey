# ★ Phase 0 Capstone: Contacts Book

**Time:** ~6 h | **Prev:** [Lesson 12](../12_debugging_and_ub/README.md) | **Next:** [Project 1: mini-grep](../../01_cli_tool/README.md)

Build a small command-line contacts manager that uses **every** Phase 0 skill: structs, a dynamic array on the heap, strings, files, arguments, multiple modules, a Makefile and sanitizers. **No starter code is provided: this is your entry test.**

```bash
$ ./contacts add "Ada Lovelace" ada@example.com 555-0101
Added (3 contacts)
$ ./contacts list
1  Ada Lovelace     ada@example.com   555-0101
$ ./contacts find ada
1  Ada Lovelace     ada@example.com   555-0101
$ ./contacts remove 1
Removed
$ ./contacts list; echo "exit=$?"
(no contacts)
exit=0
```

Contacts are saved in `contacts.dat` (path overridable with `--file PATH`) so they persist between runs.

## Requirements

### Part A: Data & memory
- [ ] `typedef struct { char *name; char *email; char *phone; } Contact;` (strings are **heap-allocated copies**)
- [ ] A `ContactList` struct holding a **dynamic array** (`Contact *items; size_t len, cap;`) that doubles when full
- [ ] Functions: `list_init`, `list_add`, `list_remove(index)`, `list_find(substring)`, `list_free`
- [ ] **Ownership comments** on every function (who frees what)

### Part B: Persistence
- [ ] `save(list, path)`: write a text file, one contact per line, fields separated by a tab
- [ ] `load(list, path)`: read with `getline`; tolerate a **missing file** (an empty list, not an error) and **malformed lines** (skip with a warning on stderr)
- [ ] Never write a raw struct with `fwrite` (you know why)

### Part C: Command line
- [ ] Subcommands: `add`, `list`, `find`, `remove`
- [ ] Parse numbers with `strtol`, rejecting `remove abc` and out-of-range indexes with a clear message
- [ ] Errors → stderr; results → stdout; **exit 0 on success, 1 on a user error, 2 on a usage or system error**

### Part D: Structure & build
- [ ] Modules: `contacts.h/.c` (data), `storage.h/.c` (files), `main.c` (CLI)
- [ ] Layout with `include/`, `src/`, a Makefile that rebuilds only what changed
- [ ] Builds with **zero warnings** under `-Wall -Wextra -Wpedantic`

## Verification (all required)
- [ ] 1,000 adds and removes in a loop (write a small test program) show **no ASan/UBSan errors and no leaks**
- [ ] `valgrind --leak-check=full` reports `All heap blocks were freed`
- [ ] Corrupt `contacts.dat` by hand (a blank line, a line with one field, a 10,000-character line). The program must not crash
- [ ] A name containing spaces and a tab character is handled sensibly (decide: reject tabs; document it)
- [ ] You can explain on paper the lifetime of every `malloc` in the program

## Stretch
- [ ] `sort` subcommand (use `qsort` with a comparator)
- [ ] Case-insensitive `find` (your own `strcasestr`, as in Project 1)
- [ ] `edit INDEX field value`
- [ ] Atomic save: write `contacts.dat.tmp`, then `rename` (a preview of Project 2)

## Hints, not solutions
- Write `list_add` first and test it alone with a `main` that adds 100 items.
- Duplicate strings with a helper `static char *dup(const char *s)` using `malloc` + `memcpy`; check for NULL; on failure free what you've already allocated (the `goto cleanup` idiom).
- Strip the `'\n'` from `getline` with `line[strcspn(line, "\n")] = '\0';`.
- Split a line with `strchr` or `strsep`/`strtok_r`. Think about which is safer for empty fields.

## You're ready for Project 1 when…
- [ ] The capstone passes every verification box above
- [ ] You can explain pass-by-value vs. pass-by-pointer, stack vs. heap, and `const char *` vs. `char *const` without notes
- [ ] You're comfortable reading a compiler error and a sanitizer report

➡️ **Next:** [Project 1: mini-grep](../../01_cli_tool/README.md), which is the same toolkit applied to a real Unix utility.
