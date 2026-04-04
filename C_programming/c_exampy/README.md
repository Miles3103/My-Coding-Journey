# miles3103 — C Low-Level Mastery Exam

> **60 levels. 20 topics. One mission: become a C programmer.**
> Works on Windows, Linux, and macOS.

---

## What is this?

A self-contained, terminal-based C exam shell that takes you from your very first `write()` call all the way through pointer arithmetic and function pointers — in 60 progressive levels across 20 core topics.

You write real `.c` files. GCC compiles them. The script grades your output against expected results, shows you a line-by-line diff on failure, tracks your score/streaks/history, and auto-saves your progress after every pass.

---

## Topics covered (3 levels each)

| # | Topic | # | Topic |
|---|-------|---|-------|
| 1 | C Intro | 11 | Switch |
| 2 | Syntax | 12 | While Loop |
| 3 | Output (`write()`) | 13 | For Loop |
| 4 | Comments | 14 | Break / Continue |
| 5 | Variables | 15 | Arrays |
| 6 | Data Types | 16 | Strings |
| 7 | Type Conversion | 17 | User Input |
| 8 | Constants & Macros | 18 | Memory Addresses |
| 9 | Operators | 19 | Pointers |
| 10 | Booleans | 20 | **Final Boss** — Function Pointers |

---

## Requirements

### Python
- **Python 3.6+** must be installed and on your PATH
- Download: <https://www.python.org/downloads/>
- ⚠️ On Windows: tick **"Add Python to PATH"** during installation

### GCC
| Platform | How to get GCC |
|----------|---------------|
| **Windows** | Install [MSYS2](https://www.msys2.org/), then run: `pacman -S mingw-w64-x86_64-gcc` |
| **Windows (alt)** | [MinGW-w64 standalone](https://www.mingw-w64.org/) |
| **Ubuntu/Debian** | `sudo apt install gcc` |
| **macOS** | `xcode-select --install` |

Verify with: `gcc --version`

---

## Setup

```
your-folder/
├── miles3103.py      ← the exam script
├── run_exam.bat      ← Windows one-click launcher
├── rendu/            ← your .c solutions go here (auto-created)
├── traces/           ← compile/run logs (auto-created)
└── saves/            ← save slots (auto-created)
```

1. Put `miles3103.py` (and optionally `run_exam.bat`) in a dedicated folder
2. Run it

---

## Running

**Windows (easiest):**
```
Double-click run_exam.bat
```

**Windows / Linux / macOS (terminal):**
```bash
python miles3103.py
```
or
```bash
python3 miles3103.py
```

---

## Workflow

When you start a level, the exam tells you exactly what to write and where:

```
FILE: rendu/ft_hello/ft_hello.c
```

1. Type `open` to open the file in your editor (Notepad on Windows, or `$EDITOR`)
2. Write your solution
3. Type `grademe` — the script compiles and runs it
4. **PASS** → score +1, auto-saved, moves to next level
5. **FAIL** → shows a diff table + char-level hint, try again

---

## Commands

| Command | Description |
|---------|-------------|
| `grademe` | Compile & grade your current `.c` file |
| `hint` | Re-read the current level's subject |
| `open` | Open your `.c` file in `$EDITOR` / Notepad |
| `cat` | Print your `.c` file to the terminal |
| `score` | Full scoreboard with stats |
| `stats` | Per-level pass/fail breakdown table |
| `history` | Attempt log for the current level |
| `save [name]` | Save progress to a named slot |
| `load [name]` | Restore a saved slot |
| `saves` | List all save slots |
| `deletesave <n>` | Delete a save slot |
| `skip` | Skip level (no credit awarded) |
| `goto N` | Jump to any level 0–59 |
| `reset` | Reset level counter (score kept) |
| `resetscore` | Full reset — level + score + streaks |
| `exit` | Quit (progress auto-saved) |

---

## Scoring & Ranks

| Score | Rank |
|-------|------|
| 0–11 | ☆☆☆ Apprentice |
| 12–23 | ☆☆☆ Junior Developer |
| 24–41 | ★☆☆ Intermediate Coder |
| 42–53 | ★★☆ Advanced Programmer |
| 54–60 | ★★★ C MASTER |

Each level passed for the **first time** awards 1 point. Re-passing a cleared level doesn't add points but still counts as practice.

---

## File structure for your solutions

Every level tells you the exact path. Example for Level 0:

```
rendu/ft_hello/ft_hello.c
```

The `rendu/` folder and subdirectories are created automatically when you run `grademe` or `open`.

---

## Save system

Progress auto-saves after every PASS. You can also manually save named slots:

```
save checkpoint1
load checkpoint1
saves              ← list all slots
deletesave checkpoint1
```

State files (`.level`, `.score`, `.passed`, `.attempts`, `.streak`, `.best`) are plain text files in the working directory — safe to back up or copy between machines.

---

## Tips

- **Compile flag:** all solutions are compiled with `-Wall -Wextra -Werror` — warnings are errors, just like 42 school
- **`-lm` is included** automatically (needed for levels using `<math.h>`)
- Levels 51–53 test programs that read from **stdin** — the grader pipes the input automatically, you don't need to handle that yourself
- Level 54 (memory addresses) is graded on label format only, since addresses vary per run
- Your existing solutions from the bash version are 100% compatible — same folder structure

---

## Compatibility notes (Windows)

- ANSI colors are enabled automatically via the Windows Console API (works on Windows 10+)
- The `open` command uses Notepad by default; set `EDITOR=code` (or any editor) in your environment to use VS Code or another editor
- Compiled binaries are named `eval_bin.exe` on Windows and cleaned up after each grade run

---

## Version

`v14.0` — Python/Windows port of the original bash script  
Original: `Miles3103 C Low-Level Mastery Shell v14.0`
