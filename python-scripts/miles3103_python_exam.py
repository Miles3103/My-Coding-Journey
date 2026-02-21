#!/usr/bin/env python3
"""
================================================================================
  Miles3103 — Python Mastery Exam v1.0
  60 Levels | 20 Topics | 3 Tasks Each

  TOPIC MAP:
   0-2   Basics          3-5   Strings          6-8   Control Flow
   9-11  Functions      12-14  Lists            15-17  Tuples & Sets
  18-20  Dicts          21-23  Comprehensions   24-26  File I/O
  27-29  Error Handling 30-32  OOP Basics       33-35  OOP Advanced
  36-38  Inheritance    39-41  Iterators/Gen    42-44  Decorators
  45-47  Functional     48-50  Regex & stdlib   51-53  Dataclasses
  54-56  Typing         57-59  Modern Python    Final Boss: Level 59

  HOW TO USE:
    python3 miles3103_python_exam.py

  Commands at the prompt:
    grademe — check your solution for the current level
    skip    — skip to next level
    hint    — show a hint
    reset   — go back to level 0
    exit    — quit (progress is saved)
================================================================================
"""

import os
import sys
import subprocess
import importlib.util
import re

LEVEL_FILE  = ".py_level"
SUBJECTS_DIR = "py_subjects"
RENDU_DIR    = "py_rendu"
TRACES_DIR   = "py_traces"
MAX_LEVEL    = 59

# ──────────────────────────────────────────────────────────────────────────────
#  LEVEL DEFINITIONS  (subject text + grader function)
# ──────────────────────────────────────────────────────────────────────────────

SUBJECTS = {}
GRADERS  = {}

def level(n, topic, text):
    SUBJECTS[n] = f"=== LEVEL {n} — {topic} ===\n{text}"

def grader(n):
    def decorator(fn):
        GRADERS[n] = fn
        return fn
    return decorator

def run_solution(level_num):
    """Run the student's solution and return (stdout, stderr, returncode)."""
    path = os.path.join(RENDU_DIR, f"lvl{level_num}", "solution.py")
    if not os.path.exists(path):
        return None, f"File not found: {path}", 1
    result = subprocess.run(
        [sys.executable, path],
        capture_output=True, text=True, timeout=10
    )
    return result.stdout.strip(), result.stderr.strip(), result.returncode

def check(output, *patterns):
    """Return True if all patterns are found in output."""
    for p in patterns:
        if p not in output:
            return False
    return True

def check_lines(output, *exact_lines):
    """Return True if each exact line appears in output."""
    lines = output.splitlines()
    for el in exact_lines:
        if el not in lines:
            return False
    return True

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 0: BASICS (levels 0-2)
# ══════════════════════════════════════════════════════════════════════════════

level(0, "BASICS [1/3] : Hello & Variables", """
FILE: py_rendu/lvl0/solution.py

Print the following EXACTLY (using print()):
  Hello, Python World!
  Type: <class 'int'>
  Type: <class 'str'>
  Type: <class 'float'>
  Type: <class 'bool'>

Declare: x=42, name="Miles3103", pi=3.14, active=True
Use type() to print their types.

Expected output:
  Hello, Python World!
  Type: <class 'int'>
  Type: <class 'str'>
  Type: <class 'float'>
  Type: <class 'bool'>

Tip: print(type(x)) prints the type of x.
""")

@grader(0)
def grade_0(out, err):
    return check_lines(out,
        "Hello, Python World!",
        "Type: <class 'int'>",
        "Type: <class 'str'>",
        "Type: <class 'float'>",
        "Type: <class 'bool'>")

# ──────────────────────────────────────────────────────────────────────────────

level(1, "BASICS [2/3] : F-Strings & Arithmetic", """
FILE: py_rendu/lvl1/solution.py

Given: a=17, b=5

Print ALL of the following using f-strings:
  17 + 5 = 22
  17 - 5 = 12
  17 * 5 = 85
  17 / 5 = 3.4
  17 // 5 = 3
  17 % 5 = 2
  17 ** 5 = 1419857

Expected output (exactly):
  17 + 5 = 22
  17 - 5 = 12
  17 * 5 = 85
  17 / 5 = 3.4
  17 // 5 = 3
  17 % 5 = 2
  17 ** 5 = 1419857

Tip: f"{a} + {b} = {a+b}"
     Note: / always gives float in Python. // is integer division.
""")

@grader(1)
def grade_1(out, err):
    return check_lines(out,
        "17 + 5 = 22", "17 - 5 = 12", "17 * 5 = 85",
        "17 / 5 = 3.4", "17 // 5 = 3", "17 % 5 = 2",
        "17 ** 5 = 1419857")

# ──────────────────────────────────────────────────────────────────────────────

level(2, "BASICS [3/3] : Type Conversion & Truthiness", """
FILE: py_rendu/lvl2/solution.py

Demonstrate type conversion and truthiness:

1. Convert and print:
   int("42")      → 42
   float("3.14")  → 3.14
   str(100)       → 100
   int(9.99)      → 9   (truncates!)
   bool(0)        → False
   bool("")       → False
   bool([])       → False
   bool(42)       → True

2. Swap WITHOUT a temp variable:
   x, y = 10, 20
   x, y = y, x
   Print: x=20 y=10

Expected output:
  42
  3.14
  100
  9
  False
  False
  False
  True
  x=20 y=10

Tip: Python's x, y = y, x swap is unique — no temp variable needed.
""")

@grader(2)
def grade_2(out, err):
    return check_lines(out, "42", "3.14", "100", "9",
                       "False", "False", "False", "True", "x=20 y=10")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 1: STRINGS (levels 3-5)
# ══════════════════════════════════════════════════════════════════════════════

level(3, "STRINGS [1/3] : Methods & Slicing", """
FILE: py_rendu/lvl3/solution.py

Given: s = "  Hello, Miles3103!  "

Print:
  stripped: Hello, Miles3103!
  upper:    HELLO, MILES3103!
  lower:    hello, miles3103!
  replace:  Hello, World!
  length:   19
  starts:   True
  ends:     True
  slice [7:17]: Miles3103

Use: strip(), upper(), lower(), replace(), len(), startswith(), endswith(), slicing

Expected output (exact):
  stripped: Hello, Miles3103!
  upper: HELLO, MILES3103!
  lower: hello, miles3103!
  replace: Hello, World!
  length: 19
  starts: True
  ends: True
  slice [7:17]: Miles3103

Tip: s.strip() removes whitespace. s[7:17] slices characters 7-16.
""")

@grader(3)
def grade_3(out, err):
    return check(out,
        "stripped: Hello, Miles3103!",
        "upper: HELLO, MILES3103!",
        "lower: hello, miles3103!",
        "replace: Hello, World!",
        "length: 19",
        "starts: True",
        "ends: True",
        "slice [7:17]: Miles3103")

# ──────────────────────────────────────────────────────────────────────────────

level(4, "STRINGS [2/3] : Split, Join & Format", """
FILE: py_rendu/lvl4/solution.py

1. Split "the quick brown fox" into words, print:
   words: ['the', 'quick', 'brown', 'fox']
   count: 4
   joined with '-': the-quick-brown-fox

2. F-string formatting:
   name="Miles3103", score=95.678, rank=3
   Print with exact formatting:
   Name:     Miles3103
   Score:    95.68
   Rank:     #003

Expected output:
  words: ['the', 'quick', 'brown', 'fox']
  count: 4
  joined with -: the-quick-brown-fox
  Name:     Miles3103
  Score:    95.68
  Rank:     #003

Tip: "sep".join(list), f"{score:.2f}", f"#{rank:03d}"
""")

@grader(4)
def grade_4(out, err):
    return check(out,
        "words: ['the', 'quick', 'brown', 'fox']",
        "count: 4",
        "joined with -: the-quick-brown-fox",
        "Name:     Miles3103",
        "Score:    95.68",
        "Rank:     #003")

# ──────────────────────────────────────────────────────────────────────────────

level(5, "STRINGS [3/3] : Palindrome & Anagram", """
FILE: py_rendu/lvl5/solution.py

Write TWO functions:

def is_palindrome(s: str) -> bool:
    # Returns True if s is the same forwards and backwards
    # Case-insensitive, ignore spaces

def is_anagram(s1: str, s2: str) -> bool:
    # Returns True if s1 and s2 use the same letters (case-insensitive)

Test:
  is_palindrome("racecar")     → True
  is_palindrome("hello")       → False
  is_palindrome("A man a plan a canal Panama") → True
  is_anagram("listen", "silent")  → True
  is_anagram("hello", "world")    → False

Expected output:
  racecar: True
  hello: False
  A man a plan a canal Panama: True
  listen/silent: True
  hello/world: False

Tip: s.lower().replace(" ","") to normalize.
     sorted(s) == sorted(t) for anagram check.
""")

@grader(5)
def grade_5(out, err):
    return check_lines(out,
        "racecar: True", "hello: False",
        "A man a plan a canal Panama: True",
        "listen/silent: True", "hello/world: False")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 2: CONTROL FLOW (levels 6-8)
# ══════════════════════════════════════════════════════════════════════════════

level(6, "CONTROL FLOW [1/3] : if/elif + FizzBuzz", """
FILE: py_rendu/lvl6/solution.py

1. Write grade(score) → "A"/"B"/"C"/"D"/"F"
   >=90→A, >=80→B, >=70→C, >=60→D, else→F

2. FizzBuzz 1-20:
   multiple of 3 AND 5 → FizzBuzz
   multiple of 3 only  → Fizz
   multiple of 5 only  → Buzz
   otherwise → number

Print grade results, then FizzBuzz output.

Expected output (partial):
  95 → A
  83 → B
  71 → C
  55 → F
  1
  2
  Fizz
  4
  Buzz
  Fizz
  7
  8
  Fizz
  Buzz

Tip: Check 15 (both) BEFORE checking 3 or 5 alone!
""")

@grader(6)
def grade_6(out, err):
    return check(out, "95 → A", "83 → B", "71 → C", "55 → F",
                 "FizzBuzz", "Fizz", "Buzz") and "1\n" in out + "\n"

# ──────────────────────────────────────────────────────────────────────────────

level(7, "CONTROL FLOW [2/3] : Loops & Patterns", """
FILE: py_rendu/lvl7/solution.py

1. Print first 10 squares using a for loop:
   1 4 9 16 25 36 49 64 81 100

2. Print this triangle (5 rows):
   *
   * *
   * * *
   * * * *
   * * * * *

3. Sum all multiples of 3 or 5 below 1000 using a while loop.
   Print: Sum of multiples of 3 or 5 below 1000: 233168

Expected output:
  1 4 9 16 25 36 49 64 81 100
  *
  * *
  * * *
  * * * *
  * * * * *
  Sum of multiples of 3 or 5 below 1000: 233168

Tip: print(*[i**2 for i in range(1,11)])  for squares on one line.
""")

@grader(7)
def grade_7(out, err):
    return check(out,
        "1 4 9 16 25 36 49 64 81 100",
        "* * * * *",
        "Sum of multiples of 3 or 5 below 1000: 233168")

# ──────────────────────────────────────────────────────────────────────────────

level(8, "CONTROL FLOW [3/3] : Recursion", """
FILE: py_rendu/lvl8/solution.py

Write THREE recursive functions:

def factorial(n: int) -> int  — n!

def fibonacci(n: int) -> int  — nth Fibonacci (0-indexed)
  fib(0)=0, fib(1)=1, fib(2)=1 ...

def flatten(lst: list) -> list
  — flattens arbitrarily nested lists
  flatten([1, [2, [3, [4]]]]) → [1, 2, 3, 4]

Print:
  factorial(0) = 1
  factorial(7) = 5040
  fib(10) = 55
  fib sequence: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
  flatten: [1, 2, 3, 4, 5, 6]

Expected output:
  factorial(0) = 1
  factorial(7) = 5040
  fib(10) = 55
  fib sequence: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
  flatten: [1, 2, 3, 4, 5, 6]

Tip: for flatten: isinstance(item, list) to check if an element is a list.
""")

@grader(8)
def grade_8(out, err):
    return check_lines(out,
        "factorial(0) = 1", "factorial(7) = 5040",
        "fib(10) = 55",
        "fib sequence: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]",
        "flatten: [1, 2, 3, 4, 5, 6]")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 3: FUNCTIONS (levels 9-11)
# ══════════════════════════════════════════════════════════════════════════════

level(9, "FUNCTIONS [1/3] : *args & **kwargs", """
FILE: py_rendu/lvl9/solution.py

Write:
  def ft_sum(*args) → sum of all arguments (any count)
  def ft_max(*args) → largest of all arguments
  def build_tag(tag, content, **attrs) → HTML-like string
    e.g. build_tag("a", "click", href="http://x.com", class_="btn")
    → <a href="http://x.com" class="btn">click</a>

Print:
  ft_sum(1,2,3,4,5) = 15
  ft_sum() = 0
  ft_max(3,1,4,1,5,9,2,6) = 9
  <p>Hello</p>
  <a href="https://42.fr" class="link">42 School</a>

Expected output:
  ft_sum(1,2,3,4,5) = 15
  ft_sum() = 0
  ft_max(3,1,4,1,5,9,2,6) = 9
  <p>Hello</p>
  <a href="https://42.fr" class="link">42 School</a>

Tip: For build_tag, strip trailing _ from attr names (class_ → class).
     " ".join(f'{k.rstrip("_")}="{v}"' for k,v in attrs.items())
""")

@grader(9)
def grade_9(out, err):
    return check(out,
        "ft_sum(1,2,3,4,5) = 15", "ft_sum() = 0",
        "ft_max(3,1,4,1,5,9,2,6) = 9",
        "<p>Hello</p>",
        'href="https://42.fr"',
        "42 School</a>")

# ──────────────────────────────────────────────────────────────────────────────

level(10, "FUNCTIONS [2/3] : Closures & Higher-Order", """
FILE: py_rendu/lvl10/solution.py

1. Write make_multiplier(n) → returns a function that multiplies by n
   double = make_multiplier(2)
   triple = make_multiplier(3)

2. Write make_counter(start=0) → returns a counter function
   Each call increments and returns the new value.

3. Write apply(func, values) → applies func to each item in values list

Print:
  double(5) = 10
  triple(5) = 15
  counter: 1 2 3 4 5
  squares: [1, 4, 9, 16, 25]

Expected output:
  double(5) = 10
  triple(5) = 15
  counter: 1 2 3 4 5
  squares: [1, 4, 9, 16, 25]

Tip: Closure: def make_mult(n): def mult(x): return x*n; return mult
     Counter: use a mutable container (list) to allow mutation: count=[0]
""")

@grader(10)
def grade_10(out, err):
    return check_lines(out,
        "double(5) = 10", "triple(5) = 15",
        "counter: 1 2 3 4 5",
        "squares: [1, 4, 9, 16, 25]")

# ──────────────────────────────────────────────────────────────────────────────

level(11, "FUNCTIONS [3/3] : Lambda & Functional Tools", """
FILE: py_rendu/lvl11/solution.py

Use ONLY lambdas, map(), filter(), sorted() — no def allowed for small ops.

Given: numbers = [5, 3, 8, 1, 9, 2, 7, 4, 6]
       words = ["banana", "apple", "cherry", "date"]

1. Filter evens from numbers → list
2. Square all numbers → list (use map)
3. Sort words by length, then alphabetically → list
4. Chain: filter odds, square them, sum them
5. sorted with key=lambda that sorts case-insensitively

Print:
  evens: [8, 2, 4, 6]
  squares: [25, 9, 64, 1, 81, 4, 49, 16, 36]
  sorted words: ['date', 'apple', 'banana', 'cherry']
  sum of odd squares: 171
  case-insensitive: ['apple', 'banana', 'cherry', 'date']

Expected output:
  evens: [8, 2, 4, 6]
  squares: [25, 9, 64, 1, 81, 4, 49, 16, 36]
  sorted words: ['date', 'apple', 'banana', 'cherry']
  sum of odd squares: 171
  case-insensitive: ['apple', 'banana', 'cherry', 'date']
""")

@grader(11)
def grade_11(out, err):
    return check_lines(out,
        "evens: [8, 2, 4, 6]",
        "squares: [25, 9, 64, 1, 81, 4, 49, 16, 36]",
        "sorted words: ['date', 'apple', 'banana', 'cherry']",
        "sum of odd squares: 171",
        "case-insensitive: ['apple', 'banana', 'cherry', 'date']")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 4: LISTS (levels 12-14)
# ══════════════════════════════════════════════════════════════════════════════

level(12, "LISTS [1/3] : Slicing & Methods", """
FILE: py_rendu/lvl12/solution.py

Given: nums = [5, 3, 8, 1, 9, 2, 7, 4, 6]

Print:
  original:   [5, 3, 8, 1, 9, 2, 7, 4, 6]
  reversed:   [6, 4, 7, 2, 9, 1, 8, 3, 5]
  every other:[5, 8, 9, 7, 6]
  first 3:    [5, 3, 8]
  last 3:     [7, 4, 6]
  sorted:     [1, 2, 3, 4, 5, 6, 7, 8, 9]
  sum:        45
  min/max:    1 / 9

Use ONLY slicing and built-in functions — no loops!

Expected output:
  original: [5, 3, 8, 1, 9, 2, 7, 4, 6]
  reversed: [6, 4, 7, 2, 9, 1, 8, 3, 5]
  every other: [5, 8, 9, 7, 6]
  first 3: [5, 3, 8]
  last 3: [7, 4, 6]
  sorted: [1, 2, 3, 4, 5, 6, 7, 8, 9]
  sum: 45
  min/max: 1 / 9

Tip: lst[::-1] reverses. lst[::2] every other. sorted(lst) returns new list.
""")

@grader(12)
def grade_12(out, err):
    return check(out,
        "original: [5, 3, 8, 1, 9, 2, 7, 4, 6]",
        "reversed: [6, 4, 7, 2, 9, 1, 8, 3, 5]",
        "every other: [5, 8, 9, 7, 6]",
        "sorted: [1, 2, 3, 4, 5, 6, 7, 8, 9]",
        "sum: 45", "min/max: 1 / 9")

# ──────────────────────────────────────────────────────────────────────────────

level(13, "LISTS [2/3] : Aliasing Bug & 2D Lists", """
FILE: py_rendu/lvl13/solution.py

1. Demonstrate the aliasing bug:
   a = [1, 2, 3]
   b = a          # BUG: b IS a
   c = a.copy()   # SAFE: c is a copy
   b[0] = 99
   Print:
     a after b[0]=99: [99, 2, 3]   (changed!)
     c after b[0]=99: [1, 2, 3]    (unchanged)

2. Create a 3x3 identity matrix (1s on diagonal, 0s elsewhere):
   [[1, 0, 0],
    [0, 1, 0],
    [0, 0, 1]]
   Print it row by row.

3. Flatten it using a list comprehension:
   flat: [1, 0, 0, 0, 1, 0, 0, 0, 1]

Expected output:
  a after b[0]=99: [99, 2, 3]
  c after b[0]=99: [1, 2, 3]
  [1, 0, 0]
  [0, 1, 0]
  [0, 0, 1]
  flat: [1, 0, 0, 0, 1, 0, 0, 0, 1]
""")

@grader(13)
def grade_13(out, err):
    return check(out,
        "a after b[0]=99: [99, 2, 3]",
        "c after b[0]=99: [1, 2, 3]",
        "[1, 0, 0]", "[0, 1, 0]", "[0, 0, 1]",
        "flat: [1, 0, 0, 0, 1, 0, 0, 0, 1]")

# ──────────────────────────────────────────────────────────────────────────────

level(14, "LISTS [3/3] : zip, enumerate, unpacking", """
FILE: py_rendu/lvl14/solution.py

names  = ["Alice", "Bob", "Charlie", "Diana"]
scores = [95, 82, 78, 91]
grades = ["A", "B", "C", "A"]

1. Use zip to print a table:
   Alice: 95 (A)
   Bob: 82 (B)
   Charlie: 78 (C)
   Diana: 91 (A)

2. Use enumerate(names, start=1) to print numbered:
   1. Alice
   2. Bob
   3. Charlie
   4. Diana

3. Unpack:
   first, *middle, last = scores
   Print: first=95 middle=[82, 78] last=91

Expected output:
  Alice: 95 (A)
  Bob: 82 (B)
  Charlie: 78 (C)
  Diana: 91 (A)
  1. Alice
  2. Bob
  3. Charlie
  4. Diana
  first=95 middle=[82, 78] last=91
""")

@grader(14)
def grade_14(out, err):
    return check(out,
        "Alice: 95 (A)", "Bob: 82 (B)", "Charlie: 78 (C)", "Diana: 91 (A)",
        "1. Alice", "2. Bob", "3. Charlie", "4. Diana",
        "first=95 middle=[82, 78] last=91")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 5: TUPLES & SETS (levels 15-17)
# ══════════════════════════════════════════════════════════════════════════════

level(15, "TUPLES & SETS [1/3] : Tuples", """
FILE: py_rendu/lvl15/solution.py

1. Named tuple:
   from collections import namedtuple
   Point = namedtuple("Point", ["x", "y"])
   p = Point(3, 7)
   Print: p.x=3 p.y=7

2. Tuple as dict key (lists can't be):
   grid = {(0,0): "origin", (1,0): "east", (0,1): "north"}
   Print: (0,0) → origin, (1,0) → east

3. Function returning multiple values (tuple):
   def stats(nums): returns (min, max, sum, len)
   Print: min=1 max=9 sum=45 count=9

Expected output:
  p.x=3 p.y=7
  (0,0) → origin
  (1,0) → east
  min=1 max=9 sum=45 count=9

Tip: Tuples are immutable → hashable → usable as dict keys.
""")

@grader(15)
def grade_15(out, err):
    return check(out,
        "p.x=3 p.y=7",
        "(0,0) → origin", "(1,0) → east",
        "min=1 max=9 sum=45 count=9")

# ──────────────────────────────────────────────────────────────────────────────

level(16, "TUPLES & SETS [2/3] : Set Operations", """
FILE: py_rendu/lvl16/solution.py

a = {1, 3, 5, 7, 9}
b = {3, 6, 9, 1, 7}   # Note: different from what you see — sets are unordered

Print:
  union:        {1, 3, 5, 6, 7, 9}
  intersection: {1, 3, 7, 9}
  difference:   {5}
  symmetric:    {5, 6}
  a ⊆ b: False
  3 in a: True

Also: remove duplicates from [1,2,2,3,3,3,4,4,4,4]
  unique: [1, 2, 3, 4]  (as sorted list)

Expected output:
  union: {1, 3, 5, 6, 7, 9}
  intersection: {1, 3, 7, 9}
  difference: {5}
  symmetric: {5, 6}
  a subset of b: False
  3 in a: True
  unique: [1, 2, 3, 4]

Tip: |, &, -, ^ operators or .union(), .intersection(), etc.
""")

@grader(16)
def grade_16(out, err):
    return check(out,
        "union: {1, 3, 5, 6, 7, 9}",
        "intersection: {1, 3, 7, 9}",
        "difference: {5}",
        "symmetric: {5, 6}",
        "3 in a: True",
        "unique: [1, 2, 3, 4]")

# ──────────────────────────────────────────────────────────────────────────────

level(17, "TUPLES & SETS [3/3] : Counter", """
FILE: py_rendu/lvl17/solution.py

from collections import Counter

1. Count word frequency in:
   text = "the cat sat on the mat the cat sat"

   Print top 3 most common with count:
   the: 3
   cat: 2
   sat: 2

2. Count characters in "mississippi":
   Print sorted by frequency (highest first):
   s: 4
   i: 4
   p: 2
   m: 1

3. Counter arithmetic:
   c1 = Counter("aab")
   c2 = Counter("bbc")
   Print c1 + c2 as dict sorted by key:
   {'a': 2, 'b': 3, 'c': 1}

Expected output:
  the: 3
  cat: 2
  sat: 2
  s: 4
  i: 4
  p: 2
  m: 1
  {'a': 2, 'b': 3, 'c': 1}
""")

@grader(17)
def grade_17(out, err):
    return check(out,
        "the: 3", "cat: 2", "sat: 2",
        "s: 4", "i: 4", "p: 2", "m: 1",
        "{'a': 2, 'b': 3, 'c': 1}")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 6: DICTS (levels 18-20)
# ══════════════════════════════════════════════════════════════════════════════

level(18, "DICTS [1/3] : Basics & Safe Access", """
FILE: py_rendu/lvl18/solution.py

person = {"name": "Miles3103", "age": 20, "level": 15}

1. Safe access:
   Print age: 20
   Print score (not in dict, default 0): 0
   Print using .get() — no KeyError!

2. Update and add:
   person["level"] = 16
   person["score"] = 9850
   person.update({"rank": "S", "active": True})

3. Iterate:
   Print each key: value pair sorted by key

4. Dict comprehension: squares {1:1, 2:4, 3:9, 4:16, 5:25}

Expected output:
  age: 20
  score: 0
  active: True
  age: 20
  level: 16
  name: Miles3103
  rank: S
  score: 9850
  {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
""")

@grader(18)
def grade_18(out, err):
    return check(out,
        "age: 20", "score: 0",
        "level: 16", "rank: S", "score: 9850",
        "{1: 1, 2: 4, 3: 9, 4: 16, 5: 25}")

# ──────────────────────────────────────────────────────────────────────────────

level(19, "DICTS [2/3] : defaultdict & grouping", """
FILE: py_rendu/lvl19/solution.py

from collections import defaultdict

1. Word frequency without KeyError:
   words = "to be or not to be that is the question to be".split()
   Use defaultdict(int) to count.
   Print sorted by frequency (highest first), then alpha:
   be: 3
   to: 3
   ...

2. Group words by first letter:
   Use defaultdict(list)
   words = ["apple","avocado","banana","blueberry","cherry","apricot"]
   Print sorted:
   a: ['apple', 'apricot', 'avocado']
   b: ['banana', 'blueberry']
   c: ['cherry']

Expected output:
  be: 3
  to: 3
  is: 1
  not: 1
  or: 1
  question: 1
  that: 1
  the: 1
  a: ['apple', 'apricot', 'avocado']
  b: ['banana', 'blueberry']
  c: ['cherry']
""")

@grader(19)
def grade_19(out, err):
    return check(out,
        "be: 3", "to: 3",
        "a: ['apple', 'apricot', 'avocado']",
        "b: ['banana', 'blueberry']",
        "c: ['cherry']")

# ──────────────────────────────────────────────────────────────────────────────

level(20, "DICTS [3/3] : Nested Dicts & Merging", """
FILE: py_rendu/lvl20/solution.py

1. Nested dict — student records:
   students = {
     "alice": {"grade": "A", "score": 95, "courses": ["math","cs"]},
     "bob":   {"grade": "B", "score": 82, "courses": ["math","english"]},
   }
   Print: Alice's score: 95
   Print: Bob's courses: ['math', 'english']
   Add charlie: grade C, score 74, courses ["cs","art"]
   Print all students sorted by name: name: score

2. Merge dicts (Python 3.9+):
   defaults = {"color": "blue", "size": 10, "debug": False}
   overrides = {"size": 20, "debug": True}
   merged = defaults | overrides
   Print merged

Expected output:
  Alice's score: 95
  Bob's courses: ['math', 'english']
  alice: 95
  bob: 82
  charlie: 74
  {'color': 'blue', 'size': 20, 'debug': True}
""")

@grader(20)
def grade_20(out, err):
    return check(out,
        "Alice's score: 95",
        "Bob's courses: ['math', 'english']",
        "alice: 95", "bob: 82", "charlie: 74",
        "{'color': 'blue', 'size': 20, 'debug': True}")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 7: COMPREHENSIONS (levels 21-23)
# ══════════════════════════════════════════════════════════════════════════════

level(21, "COMPREHENSIONS [1/3] : List & Dict", """
FILE: py_rendu/lvl21/solution.py

NO explicit for loops allowed — use comprehensions only!

1. List comprehension: squares of even numbers 1-20
   [4, 16, 36, 64, 100, 144, 196, 256, 324, 400]

2. Nested comprehension: flatten [[1,2],[3,4],[5,6]]
   [1, 2, 3, 4, 5, 6]

3. Dict comprehension: {word: len(word)} for
   ["python", "is", "awesome"]
   {'python': 6, 'is': 2, 'awesome': 7}

4. Filter + transform: lowercase words longer than 4 chars from
   ["Hello", "Hi", "World", "OK", "Python"]
   ['hello', 'world', 'python']

Expected output:
  [4, 16, 36, 64, 100, 144, 196, 256, 324, 400]
  [1, 2, 3, 4, 5, 6]
  {'python': 6, 'is': 2, 'awesome': 7}
  ['hello', 'world', 'python']
""")

@grader(21)
def grade_21(out, err):
    return check_lines(out,
        "[4, 16, 36, 64, 100, 144, 196, 256, 324, 400]",
        "[1, 2, 3, 4, 5, 6]",
        "{'python': 6, 'is': 2, 'awesome': 7}",
        "['hello', 'world', 'python']")

# ──────────────────────────────────────────────────────────────────────────────

level(22, "COMPREHENSIONS [2/3] : Generators", """
FILE: py_rendu/lvl22/solution.py

1. Generator expression — memory efficient:
   import sys
   list_sq = [x**2 for x in range(1000000)]
   gen_sq  = (x**2 for x in range(1000000))
   Print: list is larger than generator: True/False
   (list_sq takes much more memory than gen_sq)

2. Write generator function:
   def infinite_counter(start=0):
       yields start, start+1, start+2, ... forever

   Print first 5 values from infinite_counter(10):
   10 11 12 13 14

3. Write: def take(n, gen) — returns first n items from generator as list

   from the fibonacci generator:
   def fibonacci(): yields 0,1,1,2,3,5,8,13,...
   Print: take(10, fibonacci()) = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

Expected output:
  list is larger: True
  10 11 12 13 14
  take(10, fib) = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
""")

@grader(22)
def grade_22(out, err):
    return check(out,
        "list is larger: True",
        "10 11 12 13 14",
        "take(10, fib) = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]")

# ──────────────────────────────────────────────────────────────────────────────

level(23, "COMPREHENSIONS [3/3] : Data Pipeline", """
FILE: py_rendu/lvl23/solution.py

Build a lazy data pipeline using generators (NO lists in between steps):

Raw data (list of strings to parse):
  raw = ["alice,95,math", "bob,45,english", "charlie,78,math",
         "diana,32,art", "eve,88,math", "frank,61,english"]

Pipeline steps (each a generator function):
  1. parse(lines)         → yields (name, score, subject) tuples
  2. filter_pass(records) → yields only records with score >= 60
  3. enrich(records)      → adds grade: A≥90 B≥80 C≥70 D≥60
  4. format_out(records)  → yields "NAME: SCORE (GRADE) - SUBJECT"

Chain and print results:
  alice: 95 (A) - math
  charlie: 78 (C) - math
  eve: 88 (B) - math
  frank: 61 (D) - english

Expected output:
  alice: 95 (A) - math
  charlie: 78 (C) - math
  eve: 88 (B) - math
  frank: 61 (D) - english
""")

@grader(23)
def grade_23(out, err):
    return check_lines(out,
        "alice: 95 (A) - math",
        "charlie: 78 (C) - math",
        "eve: 88 (B) - math",
        "frank: 61 (D) - english")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 8: FILE I/O (levels 24-26)
# ══════════════════════════════════════════════════════════════════════════════

level(24, "FILE I/O [1/3] : Read & Write", """
FILE: py_rendu/lvl24/solution.py

1. Write 5 lines to /tmp/miles_test.txt:
   Line 1: Python
   Line 2: is
   Line 3: awesome
   Line 4: for
   Line 5: scripting

2. Read and print line count and each line numbered:
   Lines: 5
   1: Python
   2: is
   3: awesome
   4: for
   5: scripting

3. Append "Line 6: and more!" then read and print last line:
   Last: Line 6: and more!

Clean up: os.remove("/tmp/miles_test.txt")

Expected output:
  Lines: 5
  1: Python
  2: is
  3: awesome
  4: for
  5: scripting
  Last: Line 6: and more!
""")

@grader(24)
def grade_24(out, err):
    return check(out,
        "Lines: 5",
        "1: Python", "3: awesome", "5: scripting",
        "Last: Line 6: and more!")

# ──────────────────────────────────────────────────────────────────────────────

level(25, "FILE I/O [2/3] : JSON & CSV", """
FILE: py_rendu/lvl25/solution.py

import json, csv, os

1. Write this dict to /tmp/miles_data.json (with indent=2):
   data = {"name":"Miles3103","level":15,"skills":["C","C++","Python"],"score":9850.5}
   Read it back and print:
   name: Miles3103
   skills: ['C', 'C++', 'Python']
   score: 9850.5

2. Write this to /tmp/miles_scores.csv:
   Name,Score,Grade
   Alice,95,A
   Bob,82,B
   Charlie,78,C
   Read with csv.DictReader and print each row:
   Alice scored 95 (A)
   Bob scored 82 (B)
   Charlie scored 78 (C)

Clean up both files.

Expected output:
  name: Miles3103
  skills: ['C', 'C++', 'Python']
  score: 9850.5
  Alice scored 95 (A)
  Bob scored 82 (B)
  Charlie scored 78 (C)
""")

@grader(25)
def grade_25(out, err):
    return check(out,
        "name: Miles3103",
        "skills: ['C', 'C++', 'Python']",
        "score: 9850.5",
        "Alice scored 95 (A)",
        "Bob scored 82 (B)",
        "Charlie scored 78 (C)")

# ──────────────────────────────────────────────────────────────────────────────

level(26, "FILE I/O [3/3] : pathlib", """
FILE: py_rendu/lvl26/solution.py

from pathlib import Path

Use pathlib (NOT os.path) for all operations:

1. Create directory /tmp/miles_proj/src with parents=True
2. Write Path("/tmp/miles_proj/src/main.py").write_text("print('hello')")
3. Write Path("/tmp/miles_proj/README.md").write_text("# Miles3103 Project")

4. Print:
   exists: True
   is_dir: True
   stem: main
   suffix: .py
   parent: /tmp/miles_proj/src

5. Use glob to find all .py files under /tmp/miles_proj (recursive):
   py files: 1

6. Read and print main.py content:
   print('hello')

Clean up: import shutil; shutil.rmtree(Path("/tmp/miles_proj"))

Expected output:
  exists: True
  is_dir: True
  stem: main
  suffix: .py
  py files: 1
  print('hello')
""")

@grader(26)
def grade_26(out, err):
    return check(out,
        "exists: True", "is_dir: True",
        "stem: main", "suffix: .py",
        "py files: 1", "print('hello')")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 9: ERROR HANDLING (levels 27-29)
# ══════════════════════════════════════════════════════════════════════════════

level(27, "ERROR HANDLING [1/3] : try/except/else/finally", """
FILE: py_rendu/lvl27/solution.py

1. Safe divide — handle ZeroDivisionError:
   safe_divide(10, 2) = 5.0
   safe_divide(5, 0)  → caught: division by zero

2. Safe int parse — handle ValueError:
   safe_int("42")    = 42
   safe_int("hello") → caught: invalid literal

3. Demonstrate else and finally:
   try:
     result = int("99")
   except ValueError:
     print("parse failed")
   else:
     print(f"parsed: {result}")   ← runs on SUCCESS
   finally:
     print("always runs")         ← runs ALWAYS

Expected output:
  5.0
  caught: division by zero
  42
  caught: invalid literal
  parsed: 99
  always runs
""")

@grader(27)
def grade_27(out, err):
    return check(out,
        "5.0",
        "caught: division by zero",
        "42",
        "caught: invalid literal",
        "parsed: 99",
        "always runs")

# ──────────────────────────────────────────────────────────────────────────────

level(28, "ERROR HANDLING [2/3] : Custom Exceptions", """
FILE: py_rendu/lvl28/solution.py

Create exception hierarchy:
  class AppError(Exception):
    def __init__(self, msg, code=0): stores message and code
    def __str__(self): returns f"[{code}] {msg}"

  class ValidationError(AppError): default code=400
  class NotFoundError(AppError):   default code=404

Write:
  def validate_age(age) → raises ValidationError if age < 0 or > 150
  def find_user(db, name) → raises NotFoundError if not in db

Test:
  validate_age(25)   → prints: age 25 is valid
  validate_age(-5)   → catches ValidationError: prints error
  find_user(db, "Alice")  → prints: Found Alice: 95
  find_user(db, "Ghost")  → catches NotFoundError: prints error

Expected output:
  age 25 is valid
  ValidationError: [400] Age -5 out of range
  Found Alice: 95
  NotFoundError: [404] Ghost not found
""")

@grader(28)
def grade_28(out, err):
    return check(out,
        "age 25 is valid",
        "ValidationError: [400] Age -5 out of range",
        "Found Alice: 95",
        "NotFoundError: [404] Ghost not found")

# ──────────────────────────────────────────────────────────────────────────────

level(29, "ERROR HANDLING [3/3] : Context Managers", """
FILE: py_rendu/lvl29/solution.py

1. Write a context manager class:
   class Timer:
     __enter__: records start time, prints "Timer started"
     __exit__:  computes elapsed, prints f"Timer stopped: Xs elapsed"

   Use it:
   with Timer():
     sum(range(1000000))

2. Write using @contextmanager decorator:
   from contextlib import contextmanager

   @contextmanager
   def managed_resource(name):
     print(f"Acquiring {name}")
     yield name
     print(f"Releasing {name}")

   with managed_resource("database") as res:
     print(f"Using {res}")

Expected output:
  Timer started
  Timer stopped: ... elapsed
  Acquiring database
  Using database
  Releasing database

Tip: __exit__(self, exc_type, exc_val, exc_tb) — return False to re-raise exceptions.
""")

@grader(29)
def grade_29(out, err):
    return check(out,
        "Timer started", "Timer stopped",
        "Acquiring database",
        "Using database",
        "Releasing database")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 10: OOP BASICS (levels 30-32)
# ══════════════════════════════════════════════════════════════════════════════

level(30, "OOP BASICS [1/3] : Class & __init__", """
FILE: py_rendu/lvl30/solution.py

Create class BankAccount:
  def __init__(self, owner, balance=0.0)
  def deposit(self, amount)   — fails silently if amount <= 0
  def withdraw(self, amount)  — fails if amount <= 0 or > balance, prints error
  def __str__(self)           — returns f"[{owner}] ${balance:.2f}"
  @property balance           — read-only access to _balance

Class variable: interest_rate = 0.05
Method: apply_interest() — adds balance * interest_rate to balance

Test:
  acc = BankAccount("Miles3103", 1000)
  print(acc)
  acc.deposit(500)
  acc.withdraw(200)
  acc.withdraw(2000)
  acc.apply_interest()
  print(acc)
  print(f"rate: {BankAccount.interest_rate}")

Expected output:
  [Miles3103] $1000.00
  [Miles3103] $1365.00
  Error: insufficient funds
  rate: 0.05
""")

@grader(30)
def grade_30(out, err):
    return check(out,
        "[Miles3103] $1000.00",
        "[Miles3103] $1365.00",
        "Error: insufficient funds",
        "rate: 0.05")

# ──────────────────────────────────────────────────────────────────────────────

level(31, "OOP BASICS [2/3] : Dunder Methods", """
FILE: py_rendu/lvl31/solution.py

Create class Vector2D(x, y):
  __str__      → "(x, y)"
  __repr__     → "Vector2D(x, y)"
  __add__      → component-wise addition
  __sub__      → component-wise subtraction
  __mul__      → scalar multiplication (v * 3)
  __eq__       → True if x and y match
  __lt__       → compare by magnitude (enables sorting!)
  __len__      → always 2 (2D vector)
  __abs__      → magnitude = sqrt(x²+y²)
  __neg__      → negate both components
  __getitem__  → v[0]=x, v[1]=y

Test:
  v1 = Vector2D(3, 4); v2 = Vector2D(1, 2)
  print all operations and verify sorting works

Expected output:
  v1 = (3, 4)
  v1 + v2 = (4, 6)
  v1 - v2 = (2, 2)
  v1 * 2 = (6, 8)
  abs(v1) = 5.0
  -v1 = (-3, -4)
  v1 == v1: True
  sorted: [(0, 0), (1, 2), (3, 4)]
""")

@grader(31)
def grade_31(out, err):
    return check(out,
        "v1 = (3, 4)",
        "v1 + v2 = (4, 6)",
        "v1 - v2 = (2, 2)",
        "v1 * 2 = (6, 8)",
        "abs(v1) = 5.0",
        "-v1 = (-3, -4)",
        "v1 == v1: True",
        "sorted:")

# ──────────────────────────────────────────────────────────────────────────────

level(32, "OOP BASICS [3/3] : @property & @classmethod", """
FILE: py_rendu/lvl32/solution.py

Create class Temperature:
  stores internally in Celsius (_celsius)

  @property celsius     → getter
  @celsius.setter       → validates: raises ValueError below -273.15
  @property fahrenheit  → c*9/5+32 (no setter needed here)
  @property kelvin      → c+273.15

  @classmethod from_fahrenheit(cls, f) → alternative constructor
  @classmethod from_kelvin(cls, k)     → alternative constructor

  @staticmethod is_valid(celsius) → bool: celsius >= -273.15

  __str__ → "X°C / Y°F / ZK"

Test:
  t1 = Temperature(100)
  t2 = Temperature.from_fahrenheit(32)
  t3 = Temperature.from_kelvin(373.15)

Expected output:
  100°C / 212.0°F / 373.15K
  0°C / 32.0°F / 273.15K
  100°C / 212.0°F / 373.15K
  is_valid(-300): False
  ValueError caught
""")

@grader(32)
def grade_32(out, err):
    return check(out,
        "100°C / 212.0°F / 373.15K",
        "0°C / 32.0°F / 273.15K",
        "is_valid(-300): False",
        "ValueError caught")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 11: OOP ADVANCED (levels 33-35)
# ══════════════════════════════════════════════════════════════════════════════

level(33, "OOP ADVANCED [1/3] : Inheritance", """
FILE: py_rendu/lvl33/solution.py

Create base class Animal:
  __init__(name, age)
  speak() → raises NotImplementedError (force override)
  __str__ → f"{type(self).__name__}({name}, age={age})"

Create Dog(Animal):
  speak() → f"{name} says: Woof!"
  fetch(item) → f"{name} fetches the {item}!"

Create Cat(Animal):
  speak() → f"{name} says: Meow!"

Create GuideDog(Dog):  (inherits from Dog)
  __init__(name, age, owner)
  speak() → calls super().speak() + adds " (guide dog)"

Test:
  d = Dog("Rex", 3); c = Cat("Mia", 5); g = GuideDog("Buddy", 4, "John")
  print each, call speak(), call fetch("ball") on dog

Expected output:
  Dog(Rex, age=3)
  Rex says: Woof!
  Rex fetches the ball!
  Cat(Mia, age=5)
  Mia says: Meow!
  GuideDog(Buddy, age=4)
  Buddy says: Woof! (guide dog)
""")

@grader(33)
def grade_33(out, err):
    return check(out,
        "Dog(Rex, age=3)", "Rex says: Woof!", "Rex fetches the ball!",
        "Cat(Mia, age=5)", "Mia says: Meow!",
        "GuideDog(Buddy, age=4)", "Buddy says: Woof! (guide dog)")

# ──────────────────────────────────────────────────────────────────────────────

level(34, "OOP ADVANCED [2/3] : ABC & Polymorphism", """
FILE: py_rendu/lvl34/solution.py

from abc import ABC, abstractmethod
import math

Create abstract base class Shape(ABC):
  @abstractmethod area() → float
  @abstractmethod perimeter() → float
  @abstractmethod name() → str
  def describe(self) → prints f"{name}: area={area:.2f} perimeter={perimeter:.2f}"

Create: Circle(radius), Rectangle(w, h), Triangle(a, b, c) — Heron's formula

Polymorphism: store all in a list and call describe() on each.
Also: sort by area and print names.

Expected output:
  Circle: area=78.54 perimeter=31.42
  Rectangle: area=24.00 perimeter=20.00
  Triangle: area=6.00 perimeter=12.00
  By area: Triangle Rectangle Circle
""")

@grader(34)
def grade_34(out, err):
    return check(out,
        "Circle: area=78.54",
        "Rectangle: area=24.00",
        "Triangle: area=6.00",
        "By area: Triangle Rectangle Circle")

# ──────────────────────────────────────────────────────────────────────────────

level(35, "OOP ADVANCED [3/3] : Dataclass", """
FILE: py_rendu/lvl35/solution.py

from dataclasses import dataclass, field
from typing import List

@dataclass
class Player:
    name:   str
    level:  int = 1
    score:  float = 0.0
    items:  List[str] = field(default_factory=list)

    def level_up(self):   level += 1, print f"{name} → level {level}"
    def add_item(self, item): items.append(item)
    def top_score(self, s): score = max(score, s)

Also create:
@dataclass(frozen=True)    # immutable!
class Point:
    x: float
    y: float
    def distance_to(self, other: "Point") -> float: ...

Test:
  p = Player("Miles3103", level=15, score=9000)
  p.level_up()
  p.add_item("Sword"); p.add_item("Shield")
  p.top_score(9500)
  print(p)

  pt1 = Point(0, 0); pt2 = Point(3, 4)
  print(f"distance: {pt1.distance_to(pt2)}")
  # pt1.x = 5  # should raise FrozenInstanceError

Expected output:
  Miles3103 → level 16
  Player(name='Miles3103', level=16, score=9500.0, items=['Sword', 'Shield'])
  distance: 5.0
""")

@grader(35)
def grade_35(out, err):
    return check(out,
        "Miles3103 → level 16",
        "Player(name='Miles3103', level=16, score=9500.0, items=['Sword', 'Shield'])",
        "distance: 5.0")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 12: ITERATORS & GENERATORS (levels 36-38)
# ══════════════════════════════════════════════════════════════════════════════

level(36, "ITERATORS [1/3] : Custom Iterator", """
FILE: py_rendu/lvl36/solution.py

Create class Range that works with for loops:
  class Range:
    __init__(self, start, stop, step=1)
    __iter__(self) → returns self
    __next__(self) → yields next value or raises StopIteration
    __len__(self)  → number of elements
    __contains__(self, item) → True if item would be yielded

Test:
  for n in Range(1, 6):       print 1 2 3 4 5
  for n in Range(0, 10, 2):   print 0 2 4 6 8
  print(len(Range(0, 10, 2))) → 5
  print(4 in Range(0, 10, 2)) → True
  print(3 in Range(0, 10, 2)) → False

Expected output:
  1 2 3 4 5
  0 2 4 6 8
  5
  True
  False
""")

@grader(36)
def grade_36(out, err):
    return check(out,
        "1 2 3 4 5", "0 2 4 6 8",
        "5", "True", "False")

# ──────────────────────────────────────────────────────────────────────────────

level(37, "ITERATORS [2/3] : Generator Functions", """
FILE: py_rendu/lvl37/solution.py

1. def integers_from(n): yields n, n+1, n+2, ... forever

2. def take(n, gen): returns first n items as list

3. def squares_gen(): yields 1, 4, 9, 16, 25, ... (infinite squares)

4. def running_total(iterable):
   yields cumulative sum: [1,2,3,4] → 1, 3, 6, 10

5. yield from example:
   def chain(*iterables): yield from each one

Print:
  take(5, integers_from(10)) = [10, 11, 12, 13, 14]
  take(5, squares_gen()) = [1, 4, 9, 16, 25]
  running_total([1,2,3,4,5]) = [1, 3, 6, 10, 15]
  chain: [1, 2, 3, 4, 5, 6]

Expected output:
  take(5, integers_from(10)) = [10, 11, 12, 13, 14]
  take(5, squares_gen()) = [1, 4, 9, 16, 25]
  running_total = [1, 3, 6, 10, 15]
  chain: [1, 2, 3, 4, 5, 6]
""")

@grader(37)
def grade_37(out, err):
    return check_lines(out,
        "take(5, integers_from(10)) = [10, 11, 12, 13, 14]",
        "take(5, squares_gen()) = [1, 4, 9, 16, 25]",
        "running_total = [1, 3, 6, 10, 15]",
        "chain: [1, 2, 3, 4, 5, 6]")

# ──────────────────────────────────────────────────────────────────────────────

level(38, "ITERATORS [3/3] : itertools", """
FILE: py_rendu/lvl38/solution.py

import itertools

1. chain: combine [1,2,3] and [4,5,6] → [1,2,3,4,5,6]
2. islice: first 5 from infinite count(10) → [10,11,12,13,14]
3. combinations: choose 2 from [1,2,3,4] → list all
4. permutations: 2-perms of "ABC" → list count
5. groupby: group [1,1,2,2,3,1,1] by value → show groups
6. product: all (row,col) for a 2x3 grid → list

Expected output:
  chain: [1, 2, 3, 4, 5, 6]
  islice: [10, 11, 12, 13, 14]
  combinations(4,2): 6 items
  permutations(ABC,2): 6 items
  groupby: 1→2 2→2 3→1 1→2
  product 2x3: 6 pairs
""")

@grader(38)
def grade_38(out, err):
    return check(out,
        "chain: [1, 2, 3, 4, 5, 6]",
        "islice: [10, 11, 12, 13, 14]",
        "combinations(4,2): 6 items",
        "permutations(ABC,2): 6 items",
        "product 2x3: 6 pairs")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 13: DECORATORS (levels 39-41)
# ══════════════════════════════════════════════════════════════════════════════

level(39, "DECORATORS [1/3] : Basic Decorator", """
FILE: py_rendu/lvl39/solution.py

import functools

1. Write decorator: @timer
   — prints how long the function took in ms
   — use time.perf_counter()
   — use @functools.wraps to preserve function name

2. Write decorator: @logger
   — prints "Calling funcname(args)" before
   — prints "funcname returned result" after

Apply @timer and @logger to:
  def compute(n): return sum(range(n))

Call compute(1000000) and show both decorators working.
Also verify __name__ is preserved.

Expected output must contain:
  Calling compute
  compute returned 499999500000
  compute took
  function name: compute
""")

@grader(39)
def grade_39(out, err):
    return check(out,
        "Calling compute",
        "compute returned 499999500000",
        "compute took",
        "function name: compute")

# ──────────────────────────────────────────────────────────────────────────────

level(40, "DECORATORS [2/3] : Decorators with Arguments", """
FILE: py_rendu/lvl40/solution.py

import functools

1. @repeat(n) — calls the function n times:
   @repeat(3)
   def say(msg): print(msg)
   say("hello") → prints hello 3 times

2. @validate(**types) — validates argument types:
   @validate(name=str, age=int, score=float)
   def register(name, age, score): ...

   register("Alice", 20, 95.5) → prints: Registered Alice
   register("Bob", "twenty", 80.0) → prints: TypeError: age must be int

3. @retry(n, delay=0) — retries on exception up to n times:
   (use a counter to make it fail first 2 times then succeed)
   prints: Attempt 1 failed, Attempt 2 failed, Success on attempt 3

Expected output:
  hello
  hello
  hello
  Registered Alice
  TypeError: age must be int
  Attempt 1 failed
  Attempt 2 failed
  Success on attempt 3
""")

@grader(40)
def grade_40(out, err):
    return check(out,
        "hello\nhello\nhello",
        "Registered Alice",
        "TypeError: age must be int",
        "Attempt 1 failed",
        "Attempt 2 failed",
        "Success on attempt 3")

# ──────────────────────────────────────────────────────────────────────────────

level(41, "DECORATORS [3/3] : @lru_cache & functools", """
FILE: py_rendu/lvl41/solution.py

from functools import lru_cache, partial, reduce
import time

1. Without cache — slow fibonacci:
   def fib_slow(n): recursive, no cache
   Time fib_slow(30) — print time taken

2. With @lru_cache — fast fibonacci:
   @lru_cache(maxsize=None)
   def fib_fast(n): same logic
   Time fib_fast(30) — should be near instant
   Print: fib_fast(30) = 832040

3. partial — create specialized functions:
   from math import pow
   square = partial(pow, exp=2)   # wait — pow takes positional, use lambda instead
   square = partial(lambda b,e: b**e, e=2)
   cube   = partial(lambda b,e: b**e, e=3)
   print: square(5)=25.0, cube(3)=27.0

4. reduce:
   from functools import reduce
   product of [1..5] = 120
   largest of [3,1,4,1,5,9] = 9

Expected output:
  fib_fast(30) = 832040
  square(5) = 25.0
  cube(3) = 27.0
  product: 120
  largest: 9
""")

@grader(41)
def grade_41(out, err):
    return check(out,
        "fib_fast(30) = 832040",
        "square(5) = 25.0",
        "cube(3) = 27.0",
        "product: 120",
        "largest: 9")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 14: FUNCTIONAL (levels 42-44)
# ══════════════════════════════════════════════════════════════════════════════

level(42, "FUNCTIONAL [1/3] : map, filter, reduce", """
FILE: py_rendu/lvl42/solution.py

from functools import reduce

NO loops — use only map, filter, reduce, sorted, sum, min, max.

Given: nums = list(range(1, 11))  # [1..10]

1. Even numbers squared (filter then map): [4, 16, 36, 64, 100]
2. Sum of odd numbers: 25
3. Product of all numbers 1-10: 3628800
4. Max of squared evens: 100
5. Strings from ints: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']

Expected output:
  even squares: [4, 16, 36, 64, 100]
  sum of odds: 25
  10! = 3628800
  max even square: 100
  strings: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
""")

@grader(42)
def grade_42(out, err):
    return check_lines(out,
        "even squares: [4, 16, 36, 64, 100]",
        "sum of odds: 25",
        "10! = 3628800",
        "max even square: 100",
        "strings: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']")

# ──────────────────────────────────────────────────────────────────────────────

level(43, "FUNCTIONAL [2/3] : Currying & Composition", """
FILE: py_rendu/lvl43/solution.py

1. Manual currying:
   def curry_add(a): return lambda b: a + b
   add5 = curry_add(5)
   print: add5(3)=8, add5(10)=15

2. Function composition:
   def compose(*funcs): returns a function that applies funcs right-to-left
   double = lambda x: x*2
   add1   = lambda x: x+1
   square = lambda x: x**2
   f = compose(double, add1, square)  # double(add1(square(x)))
   f(3) = double(add1(9)) = double(10) = 20

3. Pipe (left-to-right composition):
   def pipe(*funcs): applies left-to-right
   g = pipe(square, add1, double)  # double(add1(square(x)))
   g(3) = 20  (same result, different order)

Expected output:
  add5(3) = 8
  add5(10) = 15
  compose(double,add1,square)(3) = 20
  pipe(square,add1,double)(3) = 20
""")

@grader(43)
def grade_43(out, err):
    return check_lines(out,
        "add5(3) = 8", "add5(10) = 15",
        "compose(double,add1,square)(3) = 20",
        "pipe(square,add1,double)(3) = 20")

# ──────────────────────────────────────────────────────────────────────────────

level(44, "FUNCTIONAL [3/3] : Memoization from scratch", """
FILE: py_rendu/lvl44/solution.py

1. Write your own memoize decorator (without lru_cache):
   def memoize(func):
     — stores results in a dict cache keyed by args
     — prints "cache miss: args" on first call
     — prints "cache hit: args" on subsequent calls
     — returns cached result

2. Apply to fibonacci and count cache hits vs misses.

3. Write: def memoize_with_limit(func, maxsize=5):
   — evicts oldest entry when cache is full (FIFO)
   — hint: use collections.OrderedDict

Apply to a square function, call with 10 different args,
then repeat some — show hits and misses.

Expected output must contain:
  cache miss: (10,)
  cache hit: (10,)
  fib(20) = 6765
  cache miss for new entry
  cache hit for repeated
""")

@grader(44)
def grade_44(out, err):
    return check(out,
        "cache miss",
        "cache hit",
        "fib(20) = 6765")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 15: REGEX & STDLIB (levels 45-47)
# ══════════════════════════════════════════════════════════════════════════════

level(45, "REGEX [1/3] : Pattern Matching", """
FILE: py_rendu/lvl45/solution.py

import re

text = "Contact us: alice@example.com or bob@test.org. Call 555-1234 or +1-800-555-9876. Born 2001-03-15."

1. Find all email addresses:
   emails: ['alice@example.com', 'bob@test.org']

2. Find all phone numbers (formats: NNN-NNNN, +N-NNN-NNN-NNNN):
   phones: ['555-1234', '+1-800-555-9876']

3. Find date and extract groups (year, month, day):
   year=2001 month=03 day=15

4. Replace all emails with [REDACTED]:
   Contact us: [REDACTED] or [REDACTED]. Call...

Expected output:
  emails: ['alice@example.com', 'bob@test.org']
  phones: ['555-1234', '+1-800-555-9876']
  year=2001 month=03 day=15
  [REDACTED]
""")

@grader(45)
def grade_45(out, err):
    return check(out,
        "emails: ['alice@example.com', 'bob@test.org']",
        "year=2001 month=03 day=15",
        "[REDACTED]")

# ──────────────────────────────────────────────────────────────────────────────

level(46, "REGEX [2/3] : String Processing", """
FILE: py_rendu/lvl46/solution.py

import re

1. Validate:
   def is_valid_email(s) → bool: reasonable email pattern
   def is_valid_password(s) → bool: min 8 chars, has uppercase, digit, special

   Test emails: "user@example.com"=True, "notanemail"=False, "a@b"=False
   Test passwords: "Hello1!"=False(too short), "Hello123!"=True, "nouppercase1!"=False

2. Extract all integers from "I have 3 cats, 12 fish and 1 dog":
   [3, 12, 1]

3. Tokenize "x = 3 + y * (z - 1)" into tokens:
   ['x', '=', '3', '+', 'y', '*', '(', 'z', '-', '1', ')']

Expected output:
  user@example.com: True
  notanemail: False
  a@b: False
  Hello1!: False
  Hello123!: True
  nouppercase1!: False
  integers: [3, 12, 1]
  tokens: ['x', '=', '3', '+', 'y', '*', '(', 'z', '-', '1', ')']
""")

@grader(46)
def grade_46(out, err):
    return check(out,
        "user@example.com: True",
        "notanemail: False",
        "Hello1!: False",
        "Hello123!: True",
        "integers: [3, 12, 1]",
        "tokens: ['x', '=', '3', '+', 'y', '*', '(', 'z', '-', '1', ')']")

# ──────────────────────────────────────────────────────────────────────────────

level(47, "STDLIB [3/3] : datetime, random, argparse", """
FILE: py_rendu/lvl47/solution.py

import datetime, random, argparse

1. datetime:
   now = datetime.datetime.now()
   Print: today is YYYY-MM-DD
   Print: in 30 days: YYYY-MM-DD
   Print: days since 2000-01-01: N

2. random (seed=42 for reproducibility):
   random.seed(42)
   Print: random int 1-100: N
   Print: random choice: (from ["rock","paper","scissors"])
   nums = list(range(10)); random.shuffle(nums)
   Print: shuffled: [...]

3. Simple argparse (just show the parser exists — parse []):
   parser = argparse.ArgumentParser(description="Miles exam tool")
   parser.add_argument("--name", default="Miles3103")
   args = parser.parse_args([])
   Print: Hello, Miles3103!

Expected output:
  today is 20
  in 30 days: 20
  days since 2000-01-01:
  random int 1-100: 2
  random choice: scissors
  shuffled:
  Hello, Miles3103!
""")

@grader(47)
def grade_47(out, err):
    return check(out,
        "today is 20",
        "in 30 days:",
        "days since 2000-01-01:",
        "random int 1-100: 2",
        "random choice: scissors",
        "Hello, Miles3103!")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 16: DATACLASSES (levels 48-50)
# ══════════════════════════════════════════════════════════════════════════════

level(48, "DATACLASSES [1/3] : Basic", """
FILE: py_rendu/lvl48/solution.py

from dataclasses import dataclass, field
from typing import List, ClassVar

@dataclass
class Student:
    name:    str
    student_id: int
    grades:  List[float] = field(default_factory=list)
    _count:  ClassVar[int] = 0   # class variable — not in __init__

    def __post_init__(self):
        Student._count += 1
        if not self.name:
            raise ValueError("Name cannot be empty")

    def add_grade(self, g: float): self.grades.append(g)
    def average(self) -> float:    return sum(self.grades)/len(self.grades) if self.grades else 0.0
    def __str__(self): return f"Student({self.name}, id={self.student_id}, avg={self.average():.1f})"

    @classmethod
    def total(cls) -> int: return cls._count

Test:
  s1 = Student("Alice", 1); s1.add_grade(90); s1.add_grade(85)
  s2 = Student("Bob", 2);   s2.add_grade(75)
  print(s1), print(s2)
  print(f"Total students: {Student.total()}")
  print(s1 == Student("Alice", 1))   # True (dataclass auto __eq__)

Expected output:
  Student(Alice, id=1, avg=87.5)
  Student(Bob, id=2, avg=75.0)
  Total students: 2
  True
""")

@grader(48)
def grade_48(out, err):
    return check(out,
        "Student(Alice, id=1, avg=87.5)",
        "Student(Bob, id=2, avg=75.0)",
        "Total students: 2",
        "True")

# ──────────────────────────────────────────────────────────────────────────────

level(49, "DATACLASSES [2/3] : Frozen & Ordering", """
FILE: py_rendu/lvl49/solution.py

from dataclasses import dataclass
from typing import Tuple

@dataclass(frozen=True, order=True)  # immutable + comparison support
class Point:
    x: float
    y: float

    def distance_to(self, other: "Point") -> float:
        return ((self.x-other.x)**2 + (self.y-other.y)**2)**0.5

    def __add__(self, other: "Point") -> "Point":
        return Point(self.x+other.x, self.y+other.y)

points = [Point(3,4), Point(1,1), Point(0,0), Point(2,3)]

Print:
  sorted: (list of points sorted by (x,y))
  min: smallest point
  p1 + p2: Point(4, 5)
  distance(0,0 to 3,4): 5.0

Try to modify a frozen point → catch the error.

Expected output:
  sorted: [Point(x=0, y=0), Point(x=1, y=1), Point(x=2, y=3), Point(x=3, y=4)]
  min: Point(x=0, y=0)
  (0,0)+(3,4) = Point(x=3, y=4)
  distance: 5.0
  FrozenInstanceError caught
""")

@grader(49)
def grade_49(out, err):
    return check(out,
        "sorted: [Point(x=0, y=0), Point(x=1, y=1), Point(x=2, y=3), Point(x=3, y=4)]",
        "min: Point(x=0, y=0)",
        "distance: 5.0",
        "FrozenInstanceError caught")

# ──────────────────────────────────────────────────────────────────────────────

level(50, "DATACLASSES [3/3] : Serialization", """
FILE: py_rendu/lvl50/solution.py

from dataclasses import dataclass, field, asdict, astuple
import json
from typing import List

@dataclass
class Address:
    street: str
    city: str
    country: str = "PL"

@dataclass
class Person:
    name: str
    age: int
    address: Address
    hobbies: List[str] = field(default_factory=list)

    def to_json(self) -> str:
        return json.dumps(asdict(self), indent=2)

    @classmethod
    def from_dict(cls, d: dict) -> "Person":
        d = d.copy()
        d["address"] = Address(**d["address"])
        return cls(**d)

p = Person("Miles3103", 20, Address("Main St", "Warsaw"), ["coding","chess"])
json_str = p.to_json()
p2 = Person.from_dict(json.loads(json_str))
print(p2.name)
print(p2.address.city)
print(p2.hobbies)
print(p == p2)

Expected output:
  Miles3103
  Warsaw
  ['coding', 'chess']
  True
""")

@grader(50)
def grade_50(out, err):
    return check_lines(out,
        "Miles3103", "Warsaw",
        "['coding', 'chess']", "True")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 17: TYPING (levels 51-53)
# ══════════════════════════════════════════════════════════════════════════════

level(51, "TYPING [1/3] : Type Hints", """
FILE: py_rendu/lvl51/solution.py

from typing import Optional, Union, List, Dict, Tuple, Any

Write fully type-annotated functions:

1. def greet(name: str, times: int = 1) -> str
2. def find_max(nums: List[int]) -> Optional[int]
   — returns None for empty list
3. def merge(d1: Dict[str, int], d2: Dict[str, int]) -> Dict[str, int]
4. def parse_value(s: str) -> Union[int, float, str]
   — tries int, then float, then returns as string

Test:
  greet("Miles3103", 2) prints the greeting
  find_max([3,1,4,1,5]) = 5
  find_max([]) = None
  merge({"a":1},{"b":2}) = {'a':1,'b':2}
  parse_value("42")   → 42 (int)
  parse_value("3.14") → 3.14 (float)
  parse_value("hi")   → hi (str)

Expected output:
  Hello, Miles3103!
  Hello, Miles3103!
  5
  None
  {'a': 1, 'b': 2}
  42 <class 'int'>
  3.14 <class 'float'>
  hi <class 'str'>
""")

@grader(51)
def grade_51(out, err):
    return check(out,
        "Hello, Miles3103!\nHello, Miles3103!",
        "5\nNone",
        "{'a': 1, 'b': 2}",
        "42 <class 'int'>",
        "3.14 <class 'float'>",
        "hi <class 'str'>")

# ──────────────────────────────────────────────────────────────────────────────

level(52, "TYPING [2/3] : Protocols & TypeVar", """
FILE: py_rendu/lvl52/solution.py

from typing import TypeVar, Generic, Protocol, runtime_checkable

T = TypeVar("T")

1. Generic class Stack[T]:
   class Stack(Generic[T]):
     push(item: T), pop() -> T, peek() -> T, empty() -> bool, size() -> int

2. Protocol — duck typing:
   @runtime_checkable
   class Drawable(Protocol):
     def draw(self) -> str: ...

   class Circle:
     def draw(self) -> str: return "Drawing Circle"
   class Square:
     def draw(self) -> str: return "Drawing Square"
   class NotDrawable:
     pass

   Check isinstance with Drawable.

Test:
  s: Stack[int] — push 1,2,3, pop once, print
  print(isinstance(Circle(), Drawable))   → True
  print(isinstance(NotDrawable(), Drawable)) → False
  draw_all([Circle(), Square()])

Expected output:
  Stack size: 2, top: 2
  True
  False
  Drawing Circle
  Drawing Square
""")

@grader(52)
def grade_52(out, err):
    return check(out,
        "Stack size: 2, top: 2",
        "True\nFalse",
        "Drawing Circle",
        "Drawing Square")

# ──────────────────────────────────────────────────────────────────────────────

level(53, "TYPING [3/3] : TypedDict & Literal", """
FILE: py_rendu/lvl53/solution.py

from typing import TypedDict, Literal, get_type_hints
from dataclasses import dataclass

1. TypedDict — typed dictionary schema:
   class UserRecord(TypedDict):
     name: str
     age: int
     role: Literal["admin", "user", "guest"]

   Create two UserRecords, print them.
   Show that role is checked at typing level (runtime won't enforce — just note it).

2. Literal for restricted values:
   def set_log_level(level: Literal["DEBUG","INFO","WARNING","ERROR"]) -> str:
     return f"Log level set to {level}"

   set_log_level("INFO") → works
   set_log_level("DEBUG") → works
   # set_log_level("VERBOSE") would fail type check (but not at runtime)

3. Print type hints of a function:
   def process(name: str, count: int) -> bool: ...
   print(get_type_hints(process))

Expected output:
  {'name': 'Alice', 'age': 30, 'role': 'admin'}
  {'name': 'Bob', 'age': 25, 'role': 'user'}
  Log level set to INFO
  Log level set to DEBUG
  {'name': <class 'str'>, 'count': <class 'int'>, 'return': <class 'bool'>}
""")

@grader(53)
def grade_53(out, err):
    return check(out,
        "{'name': 'Alice', 'age': 30, 'role': 'admin'}",
        "Log level set to INFO",
        "Log level set to DEBUG",
        "'return': <class 'bool'>")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 18: MODERN PYTHON (levels 54-56)
# ══════════════════════════════════════════════════════════════════════════════

level(54, "MODERN PYTHON [1/3] : Walrus & Match", """
FILE: py_rendu/lvl54/solution.py

Python 3.10+ features:

1. Walrus operator :=
   while chunk := input_simulation.pop(0) if input_simulation else None:
     process it

   Simulate: process lines from a list until empty.
   input_sim = ["hello", "world", "python", ""]
   While (line := input_sim.pop(0) if input_sim else None) and line:
     print(f"got: {line}")

2. match/case (structural pattern matching):
   def classify(cmd):
     match cmd:
       case "quit" | "exit": return "Quitting"
       case str(s) if s.startswith("go "): return f"Going to {s[3:]}"
       case ["list", *args]: return f"Listing: {args}"
       case _: return "Unknown"

   classify("quit") → Quitting
   classify("go north") → Going to north
   classify(["list", "files", "dirs"]) → Listing: ['files', 'dirs']
   classify("fly") → Unknown

Expected output:
  got: hello
  got: world
  got: python
  Quitting
  Going to north
  Listing: ['files', 'dirs']
  Unknown
""")

@grader(54)
def grade_54(out, err):
    return check(out,
        "got: hello", "got: world", "got: python",
        "Quitting", "Going to north",
        "Listing: ['files', 'dirs']", "Unknown")

# ──────────────────────────────────────────────────────────────────────────────

level(55, "MODERN PYTHON [2/3] : Enum & NamedTuple", """
FILE: py_rendu/lvl55/solution.py

from enum import Enum, auto, IntEnum
from typing import NamedTuple

1. Enum:
   class Color(Enum):
     RED = auto(); GREEN = auto(); BLUE = auto()

   class Direction(IntEnum):  # supports arithmetic!
     NORTH=0; EAST=1; SOUTH=2; WEST=3
     def opposite(self): return Direction((self + 2) % 4)

   Print: Color.RED, Color.RED.name, Color.RED.value
   Print: Direction.NORTH.opposite() = Direction.SOUTH

2. Typed NamedTuple:
   class Point(NamedTuple):
     x: float; y: float; label: str = ""
     def distance(self): return (self.x**2+self.y**2)**0.5

   p = Point(3, 4, "A")
   print(p, p.distance())
   x, y, label = p  # unpack

Expected output:
  Color.RED
  RED
  1
  Direction.SOUTH
  Point(x=3, y=4, label='A')
  5.0
  x=3 y=4 label=A
""")

@grader(55)
def grade_55(out, err):
    return check(out,
        "Color.RED\nRED\n1",
        "Direction.SOUTH",
        "Point(x=3, y=4, label='A')",
        "5.0",
        "x=3 y=4 label=A")

# ──────────────────────────────────────────────────────────────────────────────

level(56, "MODERN PYTHON [3/3] : Async Basics", """
FILE: py_rendu/lvl56/solution.py

import asyncio

1. Basic coroutine:
   async def greet(name, delay):
     await asyncio.sleep(delay)
     print(f"Hello, {name}!")

   asyncio.run(greet("Miles3103", 0))

2. Concurrent tasks (run 3 tasks concurrently):
   async def fetch(url, delay):
     await asyncio.sleep(delay)
     return f"data from {url}"

   async def main():
     tasks = [fetch("site1", 0.01), fetch("site2", 0.01), fetch("site3", 0.01)]
     results = await asyncio.gather(*tasks)
     for r in results: print(r)

3. async generator:
   async def arange(n):
     for i in range(n): yield i; await asyncio.sleep(0)

   async def consume():
     async for i in arange(5): print(i, end=" ")

Expected output:
  Hello, Miles3103!
  data from site1
  data from site2
  data from site3
  0 1 2 3 4
""")

@grader(56)
def grade_56(out, err):
    return check(out,
        "Hello, Miles3103!",
        "data from site1", "data from site2", "data from site3",
        "0 1 2 3 4")

# ══════════════════════════════════════════════════════════════════════════════
#  TOPIC 19: FINAL CHALLENGE (levels 57-59)
# ══════════════════════════════════════════════════════════════════════════════

level(57, "FINAL CHALLENGE [1/3] : Design Patterns", """
FILE: py_rendu/lvl57/solution.py

Implement THREE classic design patterns in Python:

1. SINGLETON — only one instance ever:
   class Config:
     _instance = None
     @classmethod
     def get(cls): create/return single instance
     data = {}

   c1 = Config.get(); c1.data["theme"] = "dark"
   c2 = Config.get(); print(c2.data["theme"])  → dark
   print(c1 is c2)  → True

2. OBSERVER — event subscription:
   class EventBus:
     subscribe(event, callback)
     emit(event, data)

3. STRATEGY — swap algorithm at runtime:
   class Sorter:
     def __init__(self, strategy): self.strategy = strategy
     def sort(self, data): return self.strategy(data)

   bubble = Sorter(lambda x: sorted(x))
   reverse_sorter = Sorter(lambda x: sorted(x, reverse=True))
   data = [3,1,4,1,5,9,2,6]
   print(bubble.sort(data))
   print(reverse_sorter.sort(data))

Expected output:
  dark
  True
  event received: user_login Miles3103
  [1, 1, 2, 3, 4, 5, 6, 9]
  [9, 6, 5, 4, 3, 2, 1, 1]
""")

@grader(57)
def grade_57(out, err):
    return check(out,
        "dark", "True",
        "event received:",
        "[1, 1, 2, 3, 4, 5, 6, 9]",
        "[9, 6, 5, 4, 3, 2, 1, 1]")

# ──────────────────────────────────────────────────────────────────────────────

level(58, "FINAL CHALLENGE [2/3] : sqlite3 + ORM-like layer", """
FILE: py_rendu/lvl58/solution.py

import sqlite3
from dataclasses import dataclass, field
from typing import List, Optional

Build a minimal ORM-like data layer:

@dataclass
class Task:
    title: str
    done: bool = False
    id: int = field(default=0, init=False)

class TaskDB:
    def __init__(self, path=":memory:")  — connect + create table
    def add(self, task: Task) → Task    — INSERT, set task.id
    def get_all(self) → List[Task]      — SELECT all
    def mark_done(self, task_id: int)   — UPDATE
    def delete(self, task_id: int)      — DELETE
    def count(self) → int               — SELECT COUNT(*)

Test:
  db = TaskDB()
  t1 = db.add(Task("Learn Python"))
  t2 = db.add(Task("Build projects"))
  t3 = db.add(Task("Push to GitHub"))
  db.mark_done(t1.id)
  db.delete(t3.id)
  for t in db.get_all():
    print(f"[{'x' if t.done else ' '}] {t.title}")
  print(f"total: {db.count()}")

Expected output:
  [x] Learn Python
  [ ] Build projects
  total: 2
""")

@grader(58)
def grade_58(out, err):
    return check(out,
        "[x] Learn Python",
        "[ ] Build projects",
        "total: 2")

# ──────────────────────────────────────────────────────────────────────────────

level(59, "FINAL BOSS *** : Full Pipeline", """
FILE: py_rendu/lvl59/solution.py

Build a complete data analysis pipeline combining:
  ✓ Dataclass with validation (__post_init__)
  ✓ Generators for lazy loading
  ✓ Decorators (@timer, @lru_cache)
  ✓ Comprehensions
  ✓ Error handling
  ✓ Type hints throughout
  ✓ OOP with inheritance
  ✓ Functional tools

Task: Analyze a student dataset.

DATA (simulate — no file needed):
  raw = [
    "Alice,92,math,senior", "Bob,45,english,junior",
    "Charlie,78,math,senior", "Diana,61,art,junior",
    "Eve,88,math,senior", "Frank,52,english,senior",
    "Grace,95,art,junior", "Henry,71,math,junior",
  ]

Pipeline:
  1. Parse each line into Student(name, score, subject, year)
  2. Filter: passing only (score >= 60)
  3. Enrich: add grade (A/B/C/D)
  4. Group by subject
  5. Per group: compute avg score, top student

Print:
  PASSING STUDENTS: 6
  art:
    avg: 78.0
    top: Grace (95)
  math:
    avg: 82.25
    top: Alice (92)
  english:
    avg: 61.0
    top: Diana (61)

  You have mastered Python. Ship something great.

Expected output must contain:
  PASSING STUDENTS: 6
  art:
  avg: 78.0
  top: Grace (95)
  math:
  avg: 82.25
  top: Alice (92)
  You have mastered Python
""")

@grader(59)
def grade_59(out, err):
    return check(out,
        "PASSING STUDENTS: 6",
        "art:", "avg: 78.0", "top: Grace (95)",
        "math:", "avg: 82.25", "top: Alice (92)",
        "You have mastered Python")

# ══════════════════════════════════════════════════════════════════════════════
#  ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def get_level():
    if os.path.exists(LEVEL_FILE):
        try:
            return int(open(LEVEL_FILE).read().strip())
        except:
            pass
    return 0

def set_level(n):
    open(LEVEL_FILE, "w").write(str(n))

def get_topic(level_num):
    topic_names = [
        "Basics", "Strings", "Control Flow", "Functions", "Lists",
        "Tuples & Sets", "Dicts", "Comprehensions", "File I/O", "Error Handling",
        "OOP Basics", "OOP Advanced", "Iterators", "Decorators", "Functional",
        "Regex & stdlib", "Dataclasses", "Typing", "Modern Python", "Final Challenge"
    ]
    return topic_names[level_num // 3]

def progress_bar(level_num):
    total  = MAX_LEVEL + 1
    filled = level_num
    empty  = total - filled
    bar    = "█" * filled + "░" * empty
    pct    = level_num * 100 // total
    return f"[{bar}] {level_num}/{total} ({pct}%)"

def show_subject(level_num):
    print(SUBJECTS.get(level_num, f"No subject for level {level_num}"))

def grade_me(level_num):
    path = os.path.join(RENDU_DIR, f"lvl{level_num}", "solution.py")
    os.makedirs(os.path.dirname(path), exist_ok=True)

    print(f"\n+{'─'*54}+")
    print(f"| Grading Level {level_num:<3} │ Topic: {get_topic(level_num):<30} |")
    print(f"+{'─'*54}+")

    if not os.path.exists(path):
        print(f"\nERROR: {path} not found.")
        print("Create your solution there and run 'grademe' again.")
        return

    try:
        out, err, rc = run_solution(level_num)
    except subprocess.TimeoutExpired:
        print("TIMEOUT: solution ran for more than 10 seconds.")
        return
    except Exception as e:
        print(f"ERROR running solution: {e}")
        return

    if rc != 0 and not out:
        print(f"RUNTIME ERROR:\n{err}")
        return

    grader_fn = GRADERS.get(level_num)
    passed = grader_fn(out, err) if grader_fn else False

    os.makedirs(TRACES_DIR, exist_ok=True)
    trace_path = os.path.join(TRACES_DIR, f"trace_lvl{level_num}.txt")
    with open(trace_path, "w") as f:
        f.write(f"OUTPUT:\n{out}\n\nSTDERR:\n{err}\n")

    if passed:
        print(f"\n  ✓ ✓ ✓  LEVEL {level_num} PASSED!  ✓ ✓ ✓\n")
        next_level = level_num + 1
        if next_level > MAX_LEVEL:
            print("╔══════════════════════════════════════════════╗")
            print("║  ALL 60 LEVELS COMPLETE. YOU KNOW PYTHON.   ║")
            print("║  Now go build something real. You're ready.  ║")
            print("╚══════════════════════════════════════════════╝")
        else:
            set_level(next_level)
            print(f"  Advancing to Level {next_level}: {get_topic(next_level)}")
            print()
            show_subject(next_level)
    else:
        print(f"\n  ✗  WRONG OUTPUT — Level {level_num} not passed.")
        print(f"\n  Your output:")
        for line in (out or "(no output)").splitlines()[:10]:
            print(f"    {line}")
        if err:
            print(f"\n  Stderr:")
            for line in err.splitlines()[:5]:
                print(f"    {line}")
        print(f"\n  Trace saved: {trace_path}")

def show_hint(level_num):
    subject = SUBJECTS.get(level_num, "")
    lines = subject.splitlines()
    tips = [l for l in lines if l.strip().startswith("Tip:")]
    if tips:
        print("\n=== HINT ===")
        for t in tips:
            print(t)
    else:
        print("No specific hint for this level. Re-read the subject carefully.")

def main():
    for d in [SUBJECTS_DIR, RENDU_DIR, TRACES_DIR]:
        os.makedirs(d, exist_ok=True)

    level_num = get_level()

    print("")
    print("╔══════════════════════════════════════════════════╗")
    print("║   Miles3103 — Python Mastery Exam v1.0          ║")
    print("║   60 Levels | 20 Topics | 3 Tasks Each          ║")
    print("╚══════════════════════════════════════════════════╝")
    print(f"\n  Progress: {progress_bar(level_num)}")
    print(f"  Topic:    {get_topic(level_num)} [{level_num % 3 + 1}/3]")
    print()
    show_subject(level_num)
    print()
    print("Commands: grademe | skip | hint | reset | exit")
    print()

    while True:
        level_num = get_level()
        try:
            cmd = input(f"py-exam[lvl{level_num}]> ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print(f"\nProgress saved at level {level_num}. See you next time!")
            break

        if cmd == "grademe":
            grade_me(level_num)

        elif cmd == "skip":
            if level_num < MAX_LEVEL:
                set_level(level_num + 1)
                print(f"Skipped to level {level_num + 1}: {get_topic(level_num + 1)}")
                show_subject(level_num + 1)
            else:
                print("Already at the final level.")

        elif cmd == "hint":
            show_hint(level_num)

        elif cmd == "reset":
            set_level(0)
            print("Reset to level 0.")
            show_subject(0)

        elif cmd in ("exit", "quit", "q"):
            print(f"Progress saved at level {level_num}. See you next time!")
            break

        elif cmd == "":
            pass

        elif cmd == "progress":
            print(f"\n  Progress: {progress_bar(level_num)}")
            print(f"  Topic:    {get_topic(level_num)} [{level_num % 3 + 1}/3]\n")

        else:
            print("Unknown command. Use: grademe | skip | hint | reset | progress | exit")

if __name__ == "__main__":
    main()
