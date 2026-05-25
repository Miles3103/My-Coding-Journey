# Miles3103 — C Mastery Shell v15.0
### Professional Edition · 60 Levels · C Intro → Pointers

---

## Quick Start

```bash
bash install.sh     # install & check dependencies
miles3103           # launch the exam
```

Or without installing:
```bash
bash miles3103.sh
```

---

## Requirements

| Tool | Purpose |
|------|---------|
| `bash 4+` | Shell (comes with Linux; macOS needs `brew install bash`) |
| `gcc` | Compile your solutions |
| `nano` or `vim` | Edit files (or set `$EDITOR`) |

---

## How It Works

1. **Read the subject** — shown every time you load a level
2. **Write your solution** — type `open` to edit the `.c` file
3. **Grade it** — type `grademe` to compile and test
4. **If it fails** — a diff table shows exactly what's wrong
5. **Pass** — earn a point and move to the next level

---

## Commands

| Command | What it does |
|---------|-------------|
| `grademe` | Compile & grade your solution |
| `hint` | Re-read the current subject |
| `open` | Open your `.c` file in `$EDITOR` |
| `cat` | Print your `.c` file to screen |
| `diff` | Show the last output diff again |
| `score` | Full scoreboard |
| `stats` | Per-level pass/fail breakdown |
| `history` | Attempt log for current level |
| `save [name]` | Save progress to a named slot |
| `load [name]` | Restore a saved slot |
| `saves` | List all save slots |
| `deletesave N` | Delete a save slot |
| `skip` | Skip level (no points) |
| `goto N` | Jump to level N (0–59) |
| `reset` | Reset level counter (score kept) |
| `resetscore` | Full reset — all progress erased |
| `exit` / `q` | Quit (auto-saved) |

---

## File Structure

```
miles3103/
├── miles3103.sh        ← main entry point
├── install.sh          ← installer
├── lib/
│   ├── colors.sh       ← terminal color system
│   ├── data.sh         ← filenames, topics, expected outputs
│   ├── state.sh        ← save/load, scoring, streaks
│   ├── ui.sh           ← all display components
│   ├── grader.sh       ← compile, run, diff
│   ├── subjects.sh     ← 60 level briefs
│   └── commands.sh     ← command dispatcher & main loop
├── rendu/              ← your solution files go here
│   └── ft_hello/
│       └── ft_hello.c
├── subjects/           ← auto-generated level briefs
├── traces/             ← compiler output logs
└── saves/              ← named save slots
```

---

## Topics (3 levels each)

| # | Topic | # | Topic |
|---|-------|---|-------|
| 0–2 | C Intro | 30–32 | If...Else |
| 3–5 | Syntax | 33–35 | Switch |
| 6–8 | Output | 36–38 | While Loop |
| 9–11 | Comments | 39–41 | For Loop |
| 12–14 | Variables | 42–44 | Break/Continue |
| 15–17 | Data Types | 45–47 | Arrays |
| 18–20 | Type Conversion | 48–50 | Strings |
| 21–23 | Constants | 51–53 | User Input |
| 24–26 | Operators | 54–56 | Memory Addresses |
| 27–29 | Booleans | 57–59 | Pointers |

---

## Ranking

| Score | Rank |
|-------|------|
| 54–60 | ★★★ C Master |
| 42–53 | ★★☆ Advanced Programmer |
| 24–41 | ★☆☆ Intermediate Coder |
| 12–23 | ☆☆☆ Junior Developer |
| 0–11 | ☆☆☆ Apprentice |
