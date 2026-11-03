## Project 1, Part 1 notes

### Build errors I hit and what they meant
| Message | Cause | Fix |
|---|---|---|
| `make: *** No makefile found` | Ran `make` inside `src/` | `cd` up to `01_cli_tool/` (the Makefile's folder) |
| `ISO C forbids an empty translation unit` | A `.c` file had no code in it | Write code in it (warning only) |
| `undefined reference to 'main'` | No `main()` anywhere (empty `main.c`) | Every program needs exactly one `main()` |
| `zsh: no such file: ./mgrep` | The build failed, so no program was made | Fix the build errors first |
| `implicit declaration of 'getopt'` | `-std=c11` hides POSIX functions | Use `-std=gnu11` in `common/Makefile.common` |

### Rules to remember
- Run `make` and `./mgrep` from `01_cli_tool/`, never from `src/` or `include/`.
- Check the folder name in the prompt (or `pwd`) before building.
- Work in ONE copy of the project (I had two: `C` and `C_Systems_Curriculum`).
- Read the FIRST error in compiler output; the later ones are often fallout.

### What I learned about getopt
- `getopt(argc, argv, "invcr")` returns one flag letter per call, `?` for an unknown flag, and `-1` when done.
- `optind` is the index of the first non-flag argument, which is my PATTERN.
- Files start at `optind + 1`.
- GNU getopt accepts flags after the pattern too (`mgrep foo -n file`).
- `pattern` points INTO `argv`, so I do not own it and must not `free` it.
- `*opts = (Options){0};` zeroes every flag, because uninitialized structs hold garbage.

### Exit codes
0 = match found, 1 = no match, 2 = error or bad usage.
