# Miles3103 — Python Scripts Journey 🚀

> **Goal:** Go from zero to confident Python developer in 2 months.
> Python is the fastest language to write in — focus on learning the
> Pythonic way of doing things, not just translating C habits into Python.

---

## 📁 Repository Structure

```
python-scripts/
├── 00_Basics/                 ← variables, types, f-strings, arithmetic
├── 01_Control_Flow/           ← if/elif, for, while, match, break/continue
├── 02_Functions/              ← args, kwargs, *args, **kwargs, closures, lambdas
├── 03_Data_Structures/        ← list, tuple, dict, set, Counter, defaultdict
├── 04_OOP/                    ← classes, inheritance, dunder methods, dataclasses
├── 05_Modules_Files/          ← import, file I/O, JSON, CSV, error handling
├── 06_Error_Handling/         ← try/except, custom exceptions, context managers
├── 07_Comprehensions/         ← list/dict/set comprehensions, generators, yield
├── 08_Decorators_Generators/  ← decorators, functools, memoization, retry
├── 09_Libraries/              ← re, logging, argparse, sqlite3, pathlib, threading
└── 10_Projects/               ← showcase projects combining everything
```

---

## 🔑 Python vs C/C++ — The Mental Shift

| Concept | C / C++ | Python |
|---------|---------|--------|
| Variables | `int x = 5;` | `x = 5` |
| Print | `printf("%d\n", x)` | `print(x)` or `print(f"{x}")` |
| String | `char[]` + `<string.h>` | `str` — built-in, powerful |
| Array | `int arr[10]` | `list` — dynamic, any type |
| Hash map | manual or `std::map` | `dict` — built-in |
| Null | `NULL` / `nullptr` | `None` |
| Boolean | `0` / `1` | `True` / `False` |
| Division | `7/2 = 3` (int) | `7/2 = 3.5` (always float!) |
| Memory | manual `malloc`/`free` | automatic garbage collection |
| Types | static (declared) | dynamic (inferred at runtime) |
| OOP | explicit `class`, `public:` | simpler `class`, no access modifiers |
| Error handling | return codes / exceptions | exceptions (`try`/`except`) |
| Compile | `gcc`/`g++` required | run directly: `python3 file.py` |

---

## 🗓️ 2-Month Mastery Roadmap

### WEEK 1–2: Python Fundamentals
**Goal:** Get comfortable with Python syntax. Unlearn C habits.

| Day | Focus | File |
|-----|-------|------|
| 1–2 | Variables, types, f-strings, arithmetic | `00_Basics/` |
| 3–4 | if/elif/else, for, while, range, enumerate | `01_Control_Flow/` |
| 5–6 | Functions: args, defaults, *args, **kwargs | `02_Functions/` |
| 7   | Review — write 5 small scripts from scratch | Practice |

**Key habits to build:**
- Use f-strings, not `+` concatenation or `%`
- `for item in collection:` not `for (int i = 0; i < n; i++)`
- `7 / 2` is `3.5` — use `//` for integer division
- `None` not `NULL`, `True`/`False` not `1`/`0`

---

### WEEK 3–4: Data Structures + OOP
**Goal:** Master Python's built-in types. Write real classes.

| Day | Focus | File |
|-----|-------|------|
| 8–9  | list, tuple — slicing, sorting, comprehensions | `03_Data_Structures/` |
| 10–11 | dict, set, Counter, defaultdict | `03_Data_Structures/` |
| 12–13 | Classes, __init__, __str__, dunder methods | `04_OOP/` |
| 14  | Inheritance, @property, @classmethod, @dataclass | `04_OOP/` |
| 15  | Write a class hierarchy from scratch | Practice |

**End of week goal:** You can build a `Person`, `BankAccount`, or `Vector` class with full operator support without looking anything up.

---

### WEEK 5–6: The Pythonic Way
**Goal:** Write code that looks like Python, not C in Python syntax.

| Day | Focus | File |
|-----|-------|------|
| 16–17 | List/dict/set comprehensions | `07_Comprehensions/` |
| 18   | Generator expressions, yield, yield from | `07_Comprehensions/` |
| 19–20 | Decorators, @wraps, decorator factories | `08_Decorators_Generators/` |
| 21–22 | Modules, file I/O, JSON, CSV | `05_Modules_Files/` |
| 23–24 | try/except/else/finally, custom exceptions | `05_Modules_Files/` |

**End of week goal:** You write comprehensions naturally. You understand decorators. You read/write files and JSON confidently.

---

### WEEK 7–8: Libraries + Real Projects
**Goal:** Use Python's ecosystem. Build real tools.

| Day | Focus | File |
|-----|-------|------|
| 25–26 | re, logging, argparse, pathlib | `09_Libraries/` |
| 27   | sqlite3, hashlib, threading | `09_Libraries/` |
| 28   | pip packages: requests, dataclasses, pydantic | Install & explore |
| 29–35 | Build Task Manager + extend it | `10_Projects/` |

**End of week goal:** You can build a complete CLI tool that reads args, validates input, persists JSON, handles errors gracefully, and has proper logging.

---

## 🧠 Skills Checklist

After completing this roadmap:

**Fundamentals:**
- [ ] Write any algorithm using for/while without thinking about syntax
- [ ] Use f-strings fluently with padding, precision, and expressions
- [ ] Explain why `b = a` is a bug for lists (aliasing vs copying)
- [ ] Use `enumerate()` and `zip()` naturally

**Data Structures:**
- [ ] Slice any list: `lst[::2]`, `lst[::-1]`, `lst[2:7]`
- [ ] Build frequency counters with `Counter` and `dict.get(k, 0)`
- [ ] Explain when to use list vs tuple vs set vs dict

**OOP:**
- [ ] Write a class with `__init__`, `__str__`, `__repr__`, `__eq__`, `__lt__`
- [ ] Use `@property` for controlled attribute access
- [ ] Use `@dataclass` to reduce boilerplate
- [ ] Explain `self`, `cls`, and `@staticmethod`

**Pythonic Code:**
- [ ] Replace any simple for-loop with a comprehension
- [ ] Write a generator function using `yield`
- [ ] Write a working decorator that preserves function metadata
- [ ] Use `@functools.lru_cache` for memoization

**Files & Errors:**
- [ ] Read and write JSON and CSV files
- [ ] Write proper `try/except/else/finally` blocks
- [ ] Create custom exception classes
- [ ] Use `with open()` — never `f = open()` without context manager

**Libraries:**
- [ ] Write a regex to extract emails, dates, or phone numbers
- [ ] Build a CLI tool with `argparse`
- [ ] Use `sqlite3` with parameterized queries
- [ ] Use `logging` instead of `print` for production code

---

## 🔧 How to Run

```bash
# Run any file
python3 filename.py

# Install packages
pip3 install requests numpy pandas

# Interactive REPL (great for experimenting)
python3

# Check installed packages
pip3 list

# Create virtual environment (best practice for projects)
python3 -m venv venv
source venv/bin/activate    # Linux/Mac
venv\Scripts\activate       # Windows

# Run with verbose output
python3 -v filename.py
```

---

## 💡 Python Zen — The Right Mindset

```python
import this   # run this in Python to see the full Zen
```

The most important rules:
- **Readability counts** — code is read more than it's written
- **There should be one obvious way to do it** — find the Pythonic way
- **Errors should never pass silently** — handle them explicitly
- **Simple is better than complex** — don't over-engineer

---

## 📚 Resources

- **docs.python.org** — official docs, excellent quality
- **realpython.com** — best tutorials for practical Python
- **pypi.org** — find any package with `pip install`
- **peps.python.org** — Python Enhancement Proposals (see PEP 8 for style)
- **exercism.io/tracks/python** — practice problems with mentorship

---

## 🏆 The Trifecta — After All Three Languages

| Use case | Best language |
|----------|--------------|
| OS, embedded, performance-critical | **C** |
| Games, high-performance apps, system tools | **C++** |
| Scripts, automation, data, web, AI/ML | **Python** |
| Learning how computers really work | **C first** |

Understanding all three makes you a complete programmer.
C teaches you the machine. C++ teaches you abstraction.
Python teaches you productivity.
