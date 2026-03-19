#!/usr/bin/env python3
# **************************************************************************** #
#                                                                              #
#  Project : Miles3103 C Low-Level Mastery Exam v14.0  ── Python/Windows Port #
#  Coverage: C Intro → Pointers (Deep Mastery Edition)                        #
#  Total   : 60 Levels  (3 per topic × 20 topics)                             #
#  Works on: Windows, Linux, macOS  (Python 3.6+)                             #
#                                                                              #
# **************************************************************************** #

import os
import sys
import subprocess
import shutil
import datetime
import math
import re
import time

# ══════════════════════════════════════════════════════════════════
#  WINDOWS / ANSI COLOR SETUP
# ══════════════════════════════════════════════════════════════════
if sys.platform == "win32":
    import ctypes
    # Enable ANSI escape codes on Windows 10+
    kernel32 = ctypes.windll.kernel32
    kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)

RED     = '\033[0;31m'
GREEN   = '\033[0;32m'
YELLOW  = '\033[1;33m'
CYAN    = '\033[0;36m'
BLUE    = '\033[0;34m'
MAGENTA = '\033[0;35m'
WHITE   = '\033[1;37m'
GRAY    = '\033[0;90m'
BOLD    = '\033[1m'
DIM     = '\033[2m'
RESET   = '\033[0m'

MAX_LEVEL = 59

# ══════════════════════════════════════════════════════════════════
#  FILE / TOPIC MAPS
# ══════════════════════════════════════════════════════════════════
FILENAMES = [
    "ft_hello.c","ft_return.c","ft_pipeline.c","ft_structure.c","ft_functions.c",
    "ft_prototype.c","ft_write.c","ft_putnbr.c","ft_print_combo.c","ft_comments.c",
    "ft_doccomment.c","ft_bugfix.c","ft_variables.c","ft_scope.c","ft_swap.c",
    "ft_sizeof.c","ft_limits.c","ft_unsigned.c","ft_implicit.c","ft_percent.c",
    "ft_ascii.c","ft_define.c","ft_enum.c","ft_macros.c","ft_bitwise.c",
    "ft_compound.c","ft_ternary.c","ft_truth_table.c","ft_shortcircuit.c","ft_password.c",
    "ft_grade.c","ft_fizzbuzz.c","ft_leap.c","ft_calc.c","ft_chartype.c",
    "ft_statemachine.c","ft_collatz.c","ft_dowhile.c","ft_digitsum.c","ft_fibonacci.c",
    "ft_patterns.c","ft_prime.c","ft_find.c","ft_filter.c","ft_nested.c",
    "ft_stats.c","ft_bubblesort.c","ft_matrix.c","ft_strfuncs.c","ft_strmanip.c",
    "ft_numconv.c","ft_readbuf.c","ft_parseinput.c","ft_multiline.c","ft_memaddr.c",
    "ft_passref.c","ft_swapptr.c","ft_ptrarith.c","ft_ptrtoptr.c","ft_funcptr.c",
]

TOPICS = [
    "C Intro","C Intro","C Intro",
    "Syntax","Syntax","Syntax",
    "Output","Output","Output",
    "Comments","Comments","Comments",
    "Variables","Variables","Variables",
    "Data Types","Data Types","Data Types",
    "Type Conv.","Type Conv.","Type Conv.",
    "Constants","Constants","Constants",
    "Operators","Operators","Operators",
    "Booleans","Booleans","Booleans",
    "If...Else","If...Else","If...Else",
    "Switch","Switch","Switch",
    "While Loop","While Loop","While Loop",
    "For Loop","For Loop","For Loop",
    "Break/Cont","Break/Cont","Break/Cont",
    "Arrays","Arrays","Arrays",
    "Strings","Strings","Strings",
    "User Input","User Input","User Input",
    "Mem. Addr.","Mem. Addr.","Mem. Addr.",
    "Pointers","Pointers","Pointers",
]

def get_filename(lvl): return FILENAMES[lvl]
def get_dirname(lvl):  return FILENAMES[lvl][:-2]   # strip .c
def get_topic(lvl):    return TOPICS[lvl]

# ══════════════════════════════════════════════════════════════════
#  STATE HELPERS  (dot-files in cwd)
# ══════════════════════════════════════════════════════════════════
def _read(f, default="0"):
    try:
        with open(f) as fh: return fh.read().strip()
    except: return default

def _write(f, val):
    with open(f, "w") as fh: fh.write(str(val) + "\n")

def _append(f, line):
    with open(f, "a") as fh: fh.write(line + "\n")

def _lines(f):
    try:
        with open(f) as fh: return [l.strip() for l in fh if l.strip()]
    except: return []

def get_level():   return int(_read(".level", "0"))
def get_score():   return int(_read(".score", "0"))
def get_streak():  return int(_read(".streak", "0"))
def get_best():    return int(_read(".best", "0"))
def set_level(v):  _write(".level", v)
def set_score(v):  _write(".score", v)
def set_streak(v): _write(".streak", v)
def set_best(v):   _write(".best", v)
def add_score(n):  set_score(get_score() + n)

def already_passed(lvl):
    return str(lvl) in _lines(".passed")

def mark_passed(lvl):
    _append(".passed", str(lvl))

def inc_streak():
    s = get_streak() + 1
    set_streak(s)
    if s > get_best(): set_best(s)

def reset_streak(): set_streak(0)

def add_attempt(lvl, result):
    ts = datetime.datetime.now().strftime("%H:%M")
    _append(".attempts", f"{lvl}:{result}:{ts}")

def get_attempts(lvl):
    return sum(1 for l in _lines(".attempts") if l.startswith(f"{lvl}:"))

def get_passes_for(lvl):
    return sum(1 for l in _lines(".attempts") if l.startswith(f"{lvl}:PASS:"))

def get_fails_for(lvl):
    return sum(1 for l in _lines(".attempts") if l.startswith(f"{lvl}:FAIL:"))

def get_total_pass():
    return sum(1 for l in _lines(".attempts") if ":PASS:" in l)

def get_total_fail():
    return sum(1 for l in _lines(".attempts") if ":FAIL:" in l)

# ══════════════════════════════════════════════════════════════════
#  DISPLAY HELPERS
# ══════════════════════════════════════════════════════════════════
def clear():
    os.system("cls" if sys.platform == "win32" else "clear")

def pause(msg="  Press Enter to continue..."):
    input(msg)

def c(color, text): return color + text + RESET

def score_bar(score, width=20):
    filled = score * width // 60
    return "█" * filled + "░" * (width - filled)

def get_rank(s):
    if s >= 54: return "★★★ C MASTER"
    if s >= 42: return "★★☆ Advanced Programmer"
    if s >= 24: return "★☆☆ Intermediate Coder"
    if s >= 12: return "☆☆☆ Junior Developer"
    return        "☆☆☆ Apprentice"

def get_hardest_level():
    passed = _lines(".passed")
    best_lvl, best_count = "-", 0
    for lvl in passed:
        f = get_fails_for(int(lvl))
        if f > best_count:
            best_count = f
            best_lvl = lvl
    return f"{best_lvl} ({best_count} fails)"

# ══════════════════════════════════════════════════════════════════
#  SCOREBOARD
# ══════════════════════════════════════════════════════════════════
def show_scoreboard():
    score = get_score()
    level = get_level()
    pct   = score * 100 // 60
    bar   = score_bar(score, 30)
    rank  = get_rank(score)
    streak = get_streak()
    best   = get_best()
    ta     = len(_lines(".attempts"))
    tp     = get_total_pass()
    tf     = get_total_fail()
    wr     = (tp * 100 // ta) if ta else 0
    hardest= get_hardest_level()

    print()
    print(c(BOLD+CYAN, "╔══════════════════════════════════════════════════════════╗"))
    print(c(BOLD+CYAN, "║                   ◆  SCOREBOARD  ◆                      ║"))
    print(c(BOLD+CYAN, "╠══════════════════════════════════════════════════════════╣"))
    print(f"{CYAN}║{RESET}  Total Score  : {BOLD}{GREEN}{score:<4}{RESET} / 60 points                          {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Progress     : {BOLD}{YELLOW}{pct:<3}{RESET}%                                       {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Levels Done  : {BOLD}{level:<3}{RESET} / 60                                  {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Bar          : [{GREEN}{bar:<30}{RESET}]               {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Rank         : {BOLD}{MAGENTA}{rank:<30}{RESET}          {CYAN}║{RESET}")
    print(c(CYAN, "╠══════════════════════════════════════════════════════════╣"))
    print(f"{CYAN}║{RESET}  Win streak   : {BOLD}{YELLOW}{streak:<3}{RESET}  Best streak : {BOLD}{YELLOW}{best:<3}{RESET}                   {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Attempts     : {GRAY}{ta:<4}{RESET} total                                 {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Passes       : {GREEN}{tp:<4}{RESET} ({GREEN}{wr:>3}{RESET}% win rate)                         {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Failures     : {RED}{tf:<4}{RESET}                                        {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Hardest lvl  : {YELLOW}{hardest:<30}{RESET}          {CYAN}║{RESET}")
    print(c(CYAN, "╠══════════════════════════════════════════════════════════╣"))
    passed_list = _lines(".passed")
    if passed_list:
        pl = " ".join(sorted(passed_list, key=int))
        print(f"{CYAN}║{RESET}  Cleared: {GREEN}{pl}{RESET}")
    else:
        print(f"{CYAN}║{RESET}  No levels cleared yet.")
    print(c(BOLD+CYAN, "╚══════════════════════════════════════════════════════════╝"))
    print()
    pause()

# ══════════════════════════════════════════════════════════════════
#  PROGRESS DISPLAY
# ══════════════════════════════════════════════════════════════════
def show_progress():
    level   = get_level()
    score   = get_score()
    fname   = get_filename(level)
    topic   = get_topic(level)
    subtask = (level % 3) + 1
    rank    = get_rank(score)
    streak  = get_streak()
    attempts= get_attempts(level)
    passes  = get_passes_for(level)
    fails   = get_fails_for(level)
    tf      = get_total_fail()

    # 60-char progress bar
    pbar = ""
    for i in range(MAX_LEVEL + 1):
        if   i < level:  pbar += f"{GREEN}#{RESET}"
        elif i == level: pbar += f"{YELLOW}>{RESET}"
        else:            pbar += f"{DIM}.{RESET}"

    print(f"  {BOLD}Topic   :{RESET} {CYAN}{topic}{RESET}  (task {subtask}/3)")
    print(f"  {BOLD}Level   :{RESET} {YELLOW}{level}{RESET} / {MAX_LEVEL}   {BOLD}This level:{RESET} {GREEN}{passes}✓{RESET} {RED}{fails}✗{RESET}  {GRAY}({attempts} total){RESET}")
    print(f"  {BOLD}File    :{RESET} {WHITE}{fname}{RESET}")
    print(f"  {BOLD}Progress:{RESET} [{pbar}]")
    print(f"  {BOLD}Score   :{RESET} {GREEN}{score}{RESET}/60  [{GREEN}{score_bar(score)}{RESET}]  {BOLD}All-time fails:{RESET} {RED}{tf}{RESET}  {BOLD}Streak:{RESET} {YELLOW}{streak}{RESET}")
    print(f"  {BOLD}Rank    :{RESET} {MAGENTA}{rank}{RESET}")

# ══════════════════════════════════════════════════════════════════
#  SUBJECT TEXTS  (all 60 levels)
# ══════════════════════════════════════════════════════════════════
SUBJECTS = {
0: """=== LEVEL 0 ─ C INTRO [1/3] : Your First Program ===
FILE: rendu/ft_hello/ft_hello.c

Write a complete C program that prints:
  Hello, C World!
using write() ONLY. No printf allowed.

Rules:
  - Include <unistd.h>
  - Use write(1, ..., len)
  - End with newline

Expected output:
  Hello, C World!

Tip: write(1, "Hello, C World!\\n", 16);""",

1: """=== LEVEL 1 ─ C INTRO [2/3] : Return Values ===
FILE: rendu/ft_return/ft_return.c

Write a C program that:
  1. Prints "Program starting" using write()
  2. Prints "Program done" using write()
  3. Returns 0 from main

Add a comment at the top:
  /* Q: What does returning 0 mean? What does returning 1 mean? */

Expected output:
  Program starting
  Program done

Tip: Non-zero return = error code (Unix convention).""",

2: """=== LEVEL 2 ─ C INTRO [3/3] : GCC Compilation Pipeline ===
FILE: rendu/ft_pipeline/ft_pipeline.c

Print the 4 stages of GCC compilation using write():
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking

Expected output:
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking

Tip: These map to: cpp -> cc1 -> as -> ld""",

3: """=== LEVEL 3 ─ SYNTAX [1/3] : Program Structure ===
FILE: rendu/ft_structure/ft_structure.c

Write a well-structured C program that:
  1. Has a file header comment (author, date, description)
  2. Has a helper function ft_print(char *s) using write()
     that prints the string + newline
  3. Calls ft_print("Syntax is power") from main

Expected output:
  Syntax is power

Tip: Function must be declared BEFORE main or use a prototype.""",

4: """=== LEVEL 4 ─ SYNTAX [2/3] : Multiple Functions ===
FILE: rendu/ft_functions/ft_functions.c

Write THREE separate functions (max 5 lines each):
  greet()    -> prints "Hello"
  farewell() -> prints "Goodbye"
  main()     -> calls greet(), then farewell()

Expected output:
  Hello
  Goodbye

Tip: Small focused functions = good C style.""",

5: """=== LEVEL 5 ─ SYNTAX [3/3] : Prototypes ===
FILE: rendu/ft_prototype/ft_prototype.c

Demonstrate function prototypes:
  1. Write prototype at top: int add(int a, int b);
  2. Define add() AFTER main
  3. In main: compute add(7, 8), print: Result: 15

Expected output:
  Result: 15

Tip: Prototype tells the compiler the signature before definition.""",

6: """=== LEVEL 6 ─ OUTPUT [1/3] : write() Mastery ===
FILE: rendu/ft_write/ft_write.c

Using ONLY write(), print:
  *** HEADER ***
  (blank line)
  Content here
  (blank line)
  *** FOOTER ***

Expected output:
  *** HEADER ***

  Content here

  *** FOOTER ***

Tip: A blank line = just "\\n" written to stdout.""",

7: """=== LEVEL 7 ─ OUTPUT [2/3] : ft_putnbr ===
FILE: rendu/ft_putnbr/ft_putnbr.c

WITHOUT printf, write a function:
  void ft_putnbr(int n)
that uses write() to print an integer.

In main call it for: 0, 42, -7, 100 (each on own line)

Expected output:
  0
  42
  -7
  100

Tip: n % 10 gives last digit. Add '0' to convert to char.
     Handle negative: print '-' then negate n.
     Edge case: INT_MIN needs special handling.""",

8: """=== LEVEL 8 ─ OUTPUT [3/3] : ft_print_combo ===
FILE: rendu/ft_print_combo/ft_print_combo.c

Write ft_print_combo() that prints via write():
  - All lowercase letters a to z (space-separated)
  - Newline
  - All digits 0 to 9 (space-separated)
  - Newline

Expected output:
  a b c d e f g h i j k l m n o p q r s t u v w x y z
  0 1 2 3 4 5 6 7 8 9

Tip: Use char variable in a loop. 'a' + i gives letter.""",

9: """=== LEVEL 9 ─ COMMENTS [1/3] : Comment Styles ===
FILE: rendu/ft_comments/ft_comments.c

Write a C program demonstrating ALL comment types:
  1. File header block comment (/* ... */)
  2. Function-level comment above a function
  3. Inline comment on a variable declaration
  4. TODO comment inside main
  5. Program prints: "Comments guide future you"

Expected output:
  Comments guide future you

Tip: Good comments explain WHY, not WHAT.""",

10: """=== LEVEL 10 ─ COMMENTS [2/3] : Documenting Functions ===
FILE: rendu/ft_doccomment/ft_doccomment.c

Write TWO functions, each with a full doc-comment:
  @param  - what the parameter is
  @return - what the function returns
  @desc   - what it does

Function 1: int ft_strlen(char *s)   -- returns length
Function 2: int ft_isalpha(char c)   -- 1 if letter, 0 if not

Test in main:
  ft_strlen("hello")  -> Length: 5
  ft_isalpha('3')     -> IsAlpha: 0
  ft_isalpha('z')     -> IsAlpha: 1

Expected output:
  Length: 5
  IsAlpha: 0
  IsAlpha: 1""",

11: """=== LEVEL 11 ─ COMMENTS [3/3] : Commented Debugging ===
FILE: rendu/ft_bugfix/ft_bugfix.c

Write a program with a BUGGY version commented out
and a FIXED version active. Comment explaining the bug.

The bug: multiplying instead of adding
  // int result = a * b;  /* BUG: should be addition */
  int result = a + b;     /* FIX: correct operation */

With a = 6, b = 4, print: Sum: 10

Expected output:
  Sum: 10""",

12: """=== LEVEL 12 ─ VARIABLES [1/3] : Declaration & Init ===
FILE: rendu/ft_variables/ft_variables.c

Declare ONE variable of each type:
  char   letter    = 'X'
  int    count     = 2025
  float  pi_approx = 3.14f
  double precise   = 2.718281828

Print each with printf:
  letter: X
  count: 2025
  pi_approx: 3.14
  precise: 2.718282

Expected output:
  letter: X
  count: 2025
  pi_approx: 3.14
  precise: 2.718282

Tip: printf("pi_approx: %.2f\\n", pi_approx);
     printf("precise: %f\\n", precise);""",

13: """=== LEVEL 13 ─ VARIABLES [2/3] : Scope & Lifetime ===
FILE: rendu/ft_scope/ft_scope.c

Demonstrate variable scope:
  - Global int g = 100
  - Function scope_demo() with local int g = 999
    prints: local g = 999
  - main() calls scope_demo(), then prints: global g = 100

Expected output:
  local g = 999
  global g = 100

Tip: Local variables shadow globals within their scope.""",

14: """=== LEVEL 14 ─ VARIABLES [3/3] : Swap Without Temp ===
FILE: rendu/ft_swap/ft_swap.c

Swap two integers WITHOUT a temporary variable.
Use XOR swap or arithmetic swap.

Start: a = 5, b = 9

Expected output:
  Before: a=5, b=9
  After:  a=9, b=5

Tip XOR swap: a ^= b; b ^= a; a ^= b;
Tip arith:    a = a+b; b = a-b; a = a-b;""",

15: """=== LEVEL 15 ─ DATA TYPES [1/3] : sizeof Explorer ===
FILE: rendu/ft_sizeof/ft_sizeof.c

Print the size of every fundamental C type using sizeof.
Use printf with %zu format specifier.

Expected output (these exact lines, in this order):
  char:      1 bytes
  int:       4 bytes
  float:     4 bytes
  double:    8 bytes

Tip: printf("char:      %zu bytes\\n", sizeof(char));""",

16: """=== LEVEL 16 ─ DATA TYPES [2/3] : Limits & Overflow ===
FILE: rendu/ft_limits/ft_limits.c

Include <limits.h> and print:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128

Then demonstrate overflow:
  int overflow = INT_MAX + 1;
  Print: Overflow result: -2147483648

Expected output:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128
  Overflow result: -2147483648

Tip: Cast to avoid UB: (int)((unsigned int)INT_MAX + 1)""",

17: """=== LEVEL 17 ─ DATA TYPES [3/3] : Unsigned vs Signed ===
FILE: rendu/ft_unsigned/ft_unsigned.c

  1. signed char sc = -1; unsigned char uc = (unsigned char)sc;
     Print:
       signed char:   -1
       unsigned char: 255

  2. unsigned int ui = 0; ui = ui - 1;
     Print: unsigned underflow: 4294967295

Expected output:
  signed char:   -1
  unsigned char: 255
  unsigned underflow: 4294967295""",

18: """=== LEVEL 18 ─ TYPE CONVERSION [1/3] : Implicit Conversion ===
FILE: rendu/ft_implicit/ft_implicit.c

  1. int i = 65; char c = i; print c as char -> 'A'
  2. char ch = 'z'; int n = ch; print n -> 122
  3. int a=5, b=2; double d = a / b; print -> 2.000000
  4. double e = (double)a / b; print -> 2.500000

Expected output:
  char from int: A
  int from char: 122
  int division stored as double: 2.000000
  cast before division: 2.500000""",

19: """=== LEVEL 19 ─ TYPE CONVERSION [2/3] : Explicit Casting ===
FILE: rendu/ft_percent/ft_percent.c

Write: int ft_percent(int part, int total)
Returns the integer percentage (truncated).
Example: ft_percent(1, 3) = 33

Test in main:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%

Expected output:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%

Tip: return (int)((double)part / total * 100);""",

20: """=== LEVEL 20 ─ TYPE CONVERSION [3/3] : ASCII & Char Math ===
FILE: rendu/ft_ascii/ft_ascii.c

  1. Convert uppercase A, M, Z to lowercase by adding 32:
       A -> a
       M -> m
       Z -> z
  2. Convert char digits to int values:
       '5' -> 5
       '9' -> 9

Expected output:
  A -> a
  M -> m
  Z -> z
  '5' -> 5
  '9' -> 9""",

21: """=== LEVEL 21 ─ CONSTANTS [1/3] : #define vs const ===
FILE: rendu/ft_define/ft_define.c

  - #define BUFFER_SIZE 1024
  - #define PI 3.14159265
  - const int MAX_USERS = 100;
  - const char SEPARATOR = '-';

Print all four:
  BUFFER_SIZE: 1024
  PI: 3.14159265
  MAX_USERS: 100
  SEPARATOR: -

Expected output:
  BUFFER_SIZE: 1024
  PI: 3.14159265
  MAX_USERS: 100
  SEPARATOR: -""",

22: """=== LEVEL 22 ─ CONSTANTS [2/3] : Enum Constants ===
FILE: rendu/ft_enum/ft_enum.c

typedef enum e_day { MON=1, TUE, WED, THU, FRI, SAT, SUN } t_day;

Write const char *day_name(t_day d) returning the day name string.
Loop MON to SUN and print:
  1: Monday
  2: Tuesday
  ...
  7: Sunday

Expected output (all 7 lines):
  1: Monday
  2: Tuesday
  3: Wednesday
  4: Thursday
  5: Friday
  6: Saturday
  7: Sunday""",

23: """=== LEVEL 23 ─ CONSTANTS [3/3] : Macro Functions ===
FILE: rendu/ft_macros/ft_macros.c

Write macros (not functions):
  #define MAX(a, b)   largest of a, b
  #define MIN(a, b)   smallest of a, b
  #define ABS(x)      absolute value
  #define SQUARE(x)   x squared

Test in main:
  MAX(3, 7)   = 7
  MIN(3, 7)   = 3
  ABS(-5)     = 5
  SQUARE(4)   = 16

Expected output:
  MAX(3, 7)   = 7
  MIN(3, 7)   = 3
  ABS(-5)     = 5
  SQUARE(4)   = 16

Tip: Wrap args in () e.g. #define SQUARE(x) ((x)*(x))""",

24: """=== LEVEL 24 ─ OPERATORS [1/3] : Bitwise Operations ===
FILE: rendu/ft_bitwise/ft_bitwise.c

With a = 10 (0b1010) and b = 12 (0b1100):
  a & b  = 8
  a | b  = 14
  a ^ b  = 6
  ~a     = -11
  a << 1 = 20
  a >> 1 = 5

Expected output:
  a & b  = 8
  a | b  = 14
  a ^ b  = 6
  ~a     = -11
  a << 1 = 20
  a >> 1 = 5""",

25: """=== LEVEL 25 ─ OPERATORS [2/3] : Assignment & Compound ===
FILE: rendu/ft_compound/ft_compound.c

Start with int x = 16. Apply and print after EACH:
  x += 4   -> x += 4  : 20
  x -= 5   -> x -= 5  : 15
  x *= 3   -> x *= 3  : 45
  x /= 9   -> x /= 9  : 5
  x %= 3   -> x %= 3  : 2
  x <<= 2  -> x <<= 2 : 8

Expected output:
  x += 4  : 20
  x -= 5  : 15
  x *= 3  : 45
  x /= 9  : 5
  x %= 3  : 2
  x <<= 2 : 8""",

26: """=== LEVEL 26 ─ OPERATORS [3/3] : Ternary & Precedence ===
FILE: rendu/ft_ternary/ft_ternary.c

Write using ONLY ternary operators:
  const char *ft_classify(int n) -> "negative"/"zero"/"positive"
  int ft_abs(int n)               -> n < 0 ? -n : n

Test:
  ft_classify(-5) -> -5: negative
  ft_classify(0)  -> 0: zero
  ft_classify(3)  -> 3: positive
  ft_abs(-42)     -> abs(-42): 42

Expected output:
  -5: negative
  0: zero
  3: positive
  abs(-42): 42""",

27: """=== LEVEL 27 ─ BOOLEANS [1/3] : Truth Tables ===
FILE: rendu/ft_truth_table/ft_truth_table.c

Include <stdbool.h>. Print the full truth table for &&, ||, !:

Expected output (exact spacing):
  A=0 B=0: AND=0 OR=0  NOT_A=1
  A=0 B=1: AND=0 OR=1  NOT_A=1
  A=1 B=0: AND=0 OR=1  NOT_A=0
  A=1 B=1: AND=1 OR=1  NOT_A=0""",

28: """=== LEVEL 28 ─ BOOLEANS [2/3] : Short-Circuit Evaluation ===
FILE: rendu/ft_shortcircuit/ft_shortcircuit.c

Write two functions with side effects:
  int check_a() { printf("check_a called\\n"); return 0; }
  int check_b() { printf("check_b called\\n"); return 1; }

Test:
  Print "Test 1:" then evaluate: check_a() && check_b()
  Print "Test 2:" then evaluate: check_b() || check_a()

Expected output:
  Test 1:
  check_a called
  Test 2:
  check_b called

Note: check_b() is NOT called in Test 1 (short-circuit),
      check_a() is NOT called in Test 2 (short-circuit).""",

29: """=== LEVEL 29 ─ BOOLEANS [3/3] : Boolean in Practice ===
FILE: rendu/ft_password/ft_password.c

Write: int ft_is_valid_password(char *password)
Returns 1 if ALL conditions true:
  - Length >= 8
  - Has at least one uppercase letter
  - Has at least one digit
Returns 0 otherwise.

Test:
  "hello"          -> invalid
  "Hello1!!"       -> valid
  "SHORT1A"        -> invalid
  "longbutnodigit" -> invalid

Expected output:
  hello: invalid
  Hello1!!: valid
  SHORT1A: invalid
  longbutnodigit: invalid""",

30: """=== LEVEL 30 ─ IF...ELSE [1/3] : Grade Calculator ===
FILE: rendu/ft_grade/ft_grade.c

Write: char ft_grade(int score)
  score >= 90 -> 'A'
  score >= 80 -> 'B'
  score >= 70 -> 'C'
  score >= 60 -> 'D'
  else        -> 'F'

Expected output:
  95: A
  83: B
  71: C
  65: D
  40: F""",

31: """=== LEVEL 31 ─ IF...ELSE [2/3] : FizzBuzz ===
FILE: rendu/ft_fizzbuzz/ft_fizzbuzz.c

FizzBuzz from 1 to 20.

Expected output (first 8 lines shown, all 20 required):
  1
  2
  Fizz
  4
  Buzz
  Fizz
  7
  8

Tip: Check divisible by 15 (FizzBuzz) BEFORE 3 or 5 alone!""",

32: """=== LEVEL 32 ─ IF...ELSE [3/3] : Leap Year ===
FILE: rendu/ft_leap/ft_leap.c

Write: int ft_is_leap(int year)
Rules:
  - Divisible by 4   -> leap
  - EXCEPT divisible by 100 -> NOT leap
  - EXCEPT divisible by 400 -> IS leap

Expected output:
  2000: leap
  1900: not leap
  2024: leap
  2023: not leap""",

33: """=== LEVEL 33 ─ SWITCH [1/3] : Calculator ===
FILE: rendu/ft_calc/ft_calc.c

Write: int ft_calc(int a, char op, int b)
Switch on op: '+' '-' '*' '/'
Return 0 for division by zero.

Expected output:
  10 + 3 = 13
  10 - 3 = 7
  10 * 3 = 30
  10 / 3 = 3
  10 / 0 = 0""",

34: """=== LEVEL 34 ─ SWITCH [2/3] : Fall-Through ===
FILE: rendu/ft_chartype/ft_chartype.c

Write ft_char_type(char c) using intentional fall-through for vowels.
  'a','e','i','o','u' -> vowel
  other a-z           -> consonant
  0-9                 -> digit
  else                -> other

Expected output:
  a: vowel
  b: consonant
  5: digit
  !: other""",

35: """=== LEVEL 35 ─ SWITCH [3/3] : State Machine ===
FILE: rendu/ft_statemachine/ft_statemachine.c

typedef enum { RED, YELLOW, GREEN } t_light;

Write: t_light next_light(t_light current)
Cycle: RED -> GREEN -> YELLOW -> RED

Simulate 6 transitions starting from RED.
Print the current light BEFORE each transition.

Expected output (exactly):
  RED
  GREEN
  YELLOW
  RED
  GREEN
  YELLOW""",

36: """=== LEVEL 36 ─ WHILE LOOP [1/3] : Collatz Conjecture ===
FILE: rendu/ft_collatz/ft_collatz.c

Collatz from n = 6:
  If even: n = n / 2
  If odd:  n = n * 3 + 1
Print each value until you reach 1.
Then print: Steps: X (count transitions, not the starting number)

Expected output:
  6
  3
  10
  5
  16
  8
  4
  2
  1
  Steps: 8""",

37: """=== LEVEL 37 ─ WHILE LOOP [2/3] : do...while Validation ===
FILE: rendu/ft_dowhile/ft_dowhile.c

Using do...while, process values: {-1, 0, 200, 50, -5, 42}
Print "Valid: X" if 1-100 inclusive, else "Invalid: X"

Expected output:
  Invalid: -1
  Invalid: 0
  Invalid: 200
  Valid: 50
  Invalid: -5
  Valid: 42""",

38: """=== LEVEL 38 ─ WHILE LOOP [3/3] : Digit Sum & Reverse ===
FILE: rendu/ft_digitsum/ft_digitsum.c

Write:
  int ft_digit_sum(int n)  -- sum of all digits
  int ft_reverse(int n)    -- reverse the digits

Expected output:
  digit_sum(12345)  = 15
  digit_sum(9999)   = 36
  ft_reverse(12345) = 54321
  ft_reverse(100)   = 1""",

39: """=== LEVEL 39 ─ FOR LOOP [1/3] : Fibonacci Sequence ===
FILE: rendu/ft_fibonacci/ft_fibonacci.c

Print first 10 Fibonacci numbers, space-separated, newline at end.

Expected output (exact):
  0 1 1 2 3 5 8 13 21 34""",

40: """=== LEVEL 40 ─ FOR LOOP [2/3] : Nested Loops & Patterns ===
FILE: rendu/ft_patterns/ft_patterns.c

Print a right-triangle (growing) then inverted triangle (shrinking):

Expected output (exactly):
  *
  **
  ***
  ****
  *****
  *****
  ****
  ***
  **
  *""",

41: """=== LEVEL 41 ─ FOR LOOP [3/3] : Prime Number Sieve ===
FILE: rendu/ft_prime/ft_prime.c

Write: int ft_is_prime(int n)
Print all primes from 2 to 50 (space-separated), then the count.

Expected output:
  2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
  Count: 15""",

42: """=== LEVEL 42 ─ BREAK/CONTINUE [1/3] : Search & Stop ===
FILE: rendu/ft_find/ft_find.c

Write: int ft_find(int *arr, int size, int target)
Returns the index, or -1 if not found. Use break to stop early.

arr = {5, 12, 3, 8, 42, 7, 19}

Expected output:
  Find 8:  Found at index 3
  Find 42: Found at index 4
  Find 99: Not found""",

43: """=== LEVEL 43 ─ BREAK/CONTINUE [2/3] : Filter with Continue ===
FILE: rendu/ft_filter/ft_filter.c

Process {-3, 7, -1, 0, 5, -8, 2, 9, -4, 6}:
  Skip negatives and zero with continue.
  Print index (0-based) and value for positives.
  Print sum of positives at end.

Expected output:
  [1]: 7
  [4]: 5
  [6]: 2
  [7]: 9
  [9]: 6
  Sum of positives: 29""",

44: """=== LEVEL 44 ─ BREAK/CONTINUE [3/3] : Nested Loop Control ===
FILE: rendu/ft_nested/ft_nested.c

Print pairs (i,j) where i and j are 1-5 and i*j is a perfect square.
Include <math.h>, compile with -lm.

Hint: sqrt(n) is an integer if (int)sqrt(n)*(int)sqrt(n) == n

Expected output:
  (1,1)=1
  (1,4)=4
  (2,2)=4
  (3,3)=9
  (4,4)=16
  (5,5)=25""",

45: """=== LEVEL 45 ─ ARRAYS [1/3] : Array Statistics ===
FILE: rendu/ft_stats/ft_stats.c

arr[] = {4, 7, 2, 9, 1, 5, 8, 3, 6, 10}
Write:
  int   ft_min(int *arr, int n)
  int   ft_max(int *arr, int n)
  int   ft_sum(int *arr, int n)
  float ft_avg(int *arr, int n)

Expected output:
  Min: 1
  Max: 10
  Sum: 55
  Avg: 5.50""",

46: """=== LEVEL 46 ─ ARRAYS [2/3] : Bubble Sort ===
FILE: rendu/ft_bubblesort/ft_bubblesort.c

Implement: void ft_bubble_sort(int *arr, int n)
Sort {64, 34, 25, 12, 22, 11, 90} in ascending order.

Expected output:
  Before: 64 34 25 12 22 11 90
  After:  11 12 22 25 34 64 90""",

47: """=== LEVEL 47 ─ ARRAYS [3/3] : 2D Arrays & Matrix ===
FILE: rendu/ft_matrix/ft_matrix.c

int m[3][3] = {{1,2,3},{4,5,6},{7,8,9}};

Write:
  void print_matrix(int m[3][3])
  int  matrix_sum(int m[3][3])       -- sum of all elements
  int  matrix_trace(int m[3][3])     -- sum of diagonal (1+5+9)

Expected output:
  1 2 3
  4 5 6
  7 8 9
  Sum: 45
  Trace: 15""",

48: """=== LEVEL 48 ─ STRINGS [1/3] : String Functions from Scratch ===
FILE: rendu/ft_strfuncs/ft_strfuncs.c

WITHOUT <string.h>, implement:
  int   ft_strlen(char *s)
  char *ft_strcpy(char *dst, char *src)
  int   ft_strcmp(char *s1, char *s2)
  char *ft_strchr(char *s, char c)

Expected output:
  strlen: 5
  strcpy: world
  strcmp equal: 0
  strcmp diff: nonzero
  strchr: llo""",

49: """=== LEVEL 49 ─ STRINGS [2/3] : String Manipulation ===
FILE: rendu/ft_strmanip/ft_strmanip.c

Implement:
  void ft_toupper_str(char *s)    -- in-place uppercase
  void ft_tolower_str(char *s)    -- in-place lowercase
  void ft_reverse_str(char *s)    -- in-place reverse
  int  ft_count_words(char *s)    -- count space-separated words

Expected output:
  upper: HELLO WORLD
  lower: hello world
  reverse: edcba
  words: 4""",

50: """=== LEVEL 50 ─ STRINGS [3/3] : Number <-> String Conversion ===
FILE: rendu/ft_numconv/ft_numconv.c

Implement:
  int   ft_atoi(char *s)   -- string to int
  char *ft_itoa(int n)     -- int to string (malloc allowed)

Expected output:
  atoi("42"):    42
  atoi("-100"):  -100
  atoi("0"):     0
  itoa(12345):   12345
  itoa(-7):      -7""",

51: """=== LEVEL 51 ─ USER INPUT [1/3] : read() Buffer ===
FILE: rendu/ft_readbuf/ft_readbuf.c

Using ONLY read() and write():
  Read up to 32 chars from stdin.
  Null-terminate the buffer.
  Strip trailing newline if present.
  Print: "You entered: " followed by the string.

Test with piped input: echo "Hello42" | ./ft_readbuf

Expected output:
  You entered: Hello42""",

52: """=== LEVEL 52 ─ USER INPUT [2/3] : Parsing Input ===
FILE: rendu/ft_parseinput/ft_parseinput.c

Read a line from stdin, count uppercase, lowercase, digits, spaces.
Test input: "Hello World 42"

Expected output:
  Uppercase: 2
  Lowercase: 8
  Digits: 2
  Spaces: 2""",

53: """=== LEVEL 53 ─ USER INPUT [3/3] : Multi-line Reader ===
FILE: rendu/ft_multiline/ft_multiline.c

Read exactly 3 lines from stdin using a loop with read().
For each line print: "Line N (len=X): content"
(length excludes the newline)

Test with: printf "hello\\nworld\\n42\\n"

Expected output:
  Line 1 (len=5): hello
  Line 2 (len=5): world
  Line 3 (len=2): 42""",

54: """=== LEVEL 54 ─ MEMORY ADDRESS [1/3] : Address Explorer ===
FILE: rendu/ft_memaddr/ft_memaddr.c

Print addresses of:
  - A global variable   (label: global)
  - A stack variable    (label: stack)
  - A heap variable     (label: heap, use malloc)
Free the heap allocation.

Expected output format (addresses will vary):
  global: 0x[hex address]
  stack:  0x[hex address]
  heap:   0x[hex address]

Tip: printf("global: %p\\n", (void*)&g);""",

55: """=== LEVEL 55 ─ MEMORY ADDRESS [2/3] : Pass by Reference ===
FILE: rendu/ft_passref/ft_passref.c

Demonstrate pass-by-value vs pass-by-reference:
  void double_val(int n)   -- modifies local copy only
  void double_ref(int *n)  -- modifies caller's variable

Start with x = 5.

Expected output:
  After double_val: 5
  After double_ref: 10""",

56: """=== LEVEL 56 ─ MEMORY ADDRESS [3/3] : ft_swap via Pointers ===
FILE: rendu/ft_swapptr/ft_swapptr.c

Write:
  void ft_swap(int *a, int *b)
  void ft_swap_str(char **a, char **b)

Expected output:
  Before swap: a=10, b=20
  After swap:  a=20, b=10
  Before swap: s1=hello, s2=world
  After swap:  s1=world, s2=hello""",

57: """=== LEVEL 57 ─ POINTERS [1/3] : Pointer Arithmetic ===
FILE: rendu/ft_ptrarith/ft_ptrarith.c

Navigate int arr[] = {10,20,30,40,50} using ONLY pointer arithmetic.
(No arr[i] subscript allowed)

Expected output:
  *p     = 10
  *(p+1) = 20
  *(p+2) = 30
  *(p+3) = 40
  *(p+4) = 50
  int units apart:  1
  bytes apart:      4""",

58: """=== LEVEL 58 ─ POINTERS [2/3] : Pointer to Pointer ===
FILE: rendu/ft_ptrtoptr/ft_ptrtoptr.c

  int x = 42;
  int *p = &x;
  int **pp = &p;

Print all three ways to access x, then modify x through **pp.

Expected output:
  x    = 42
  *p   = 42
  **pp = 42
  After **pp = 99: x = 99""",

59: """=== LEVEL 59 ─ POINTERS [3/3] ★ FINAL BOSS ★ ===
FILE: rendu/ft_funcptr/ft_funcptr.c

Part 1 — Function pointer dispatch table:
  int ft_add(int a, int b)  { return a + b; }
  int ft_sub(int a, int b)  { return a - b; }
  int ft_mul(int a, int b)  { return a * b; }

  Store them in an array of function pointers and call each.

Part 2 — ft_map:
  void ft_map(int *arr, int n, int (*f)(int))
  Apply a doubling function to {1,2,3,4,5}.

Expected output:
  ft_add(10, 3) = 13
  ft_sub(10, 3) = 7
  ft_mul(10, 3) = 30
  2 4 6 8 10

  You have completed the C Mastery Exam. You are ready.""",
}

def show_subject(lvl=None):
    if lvl is None: lvl = get_level()
    text = SUBJECTS.get(lvl, "")
    if not text: return
    print()
    print(c(BOLD+CYAN, f"══ SUBJECT: Level {lvl} ══════════════════════════════════"))
    for line in text.splitlines():
        if "Expected output" in line:
            print(c(BOLD+YELLOW, line))
        elif line.strip().startswith("Tip:") or line.strip().startswith("Tip "):
            print(c(CYAN, line))
        elif line.strip().startswith("FILE:"):
            print(c(GREEN, line))
        else:
            print(line)
    print()

# ══════════════════════════════════════════════════════════════════
#  EXPECTED OUTPUTS
# ══════════════════════════════════════════════════════════════════
EXPECTED = {
    0:  "Hello, C World!",
    1:  "Program starting\nProgram done",
    2:  "1. Preprocessing\n2. Compilation\n3. Assembly\n4. Linking",
    3:  "Syntax is power",
    4:  "Hello\nGoodbye",
    5:  "Result: 15",
    6:  "*** HEADER ***\n\nContent here\n\n*** FOOTER ***",
    7:  "0\n42\n-7\n100",
    8:  "a b c d e f g h i j k l m n o p q r s t u v w x y z\n0 1 2 3 4 5 6 7 8 9",
    9:  "Comments guide future you",
    10: "Length: 5\nIsAlpha: 0\nIsAlpha: 1",
    11: "Sum: 10",
    12: "letter: X\ncount: 2025\npi_approx: 3.14\nprecise: 2.718282",
    13: "local g = 999\nglobal g = 100",
    14: "Before: a=5, b=9\nAfter:  a=9, b=5",
    15: "char:      1 bytes\nint:       4 bytes\nfloat:     4 bytes\ndouble:    8 bytes",
    16: "INT_MAX:  2147483647\nINT_MIN:  -2147483648\nCHAR_MAX: 127\nCHAR_MIN: -128\nOverflow result: -2147483648",
    17: "signed char:   -1\nunsigned char: 255\nunsigned underflow: 4294967295",
    18: "char from int: A\nint from char: 122\nint division stored as double: 2.000000\ncast before division: 2.500000",
    19: "1 of 3   = 33%\n2 of 3   = 66%\n1 of 4   = 25%\n3 of 4   = 75%\n1 of 7   = 14%",
    20: "A -> a\nM -> m\nZ -> z\n'5' -> 5\n'9' -> 9",
    21: "BUFFER_SIZE: 1024\nPI: 3.14159265\nMAX_USERS: 100\nSEPARATOR: -",
    22: "1: Monday\n2: Tuesday\n3: Wednesday\n4: Thursday\n5: Friday\n6: Saturday\n7: Sunday",
    23: "MAX(3, 7)   = 7\nMIN(3, 7)   = 3\nABS(-5)     = 5\nSQUARE(4)   = 16",
    24: "a & b  = 8\na | b  = 14\na ^ b  = 6\n~a     = -11\na << 1 = 20\na >> 1 = 5",
    25: "x += 4  : 20\nx -= 5  : 15\nx *= 3  : 45\nx /= 9  : 5\nx %= 3  : 2\nx <<= 2 : 8",
    26: "-5: negative\n0: zero\n3: positive\nabs(-42): 42",
    27: "A=0 B=0: AND=0 OR=0  NOT_A=1\nA=0 B=1: AND=0 OR=1  NOT_A=1\nA=1 B=0: AND=0 OR=1  NOT_A=0\nA=1 B=1: AND=1 OR=1  NOT_A=0",
    28: "Test 1:\ncheck_a called\nTest 2:\ncheck_b called",
    29: "hello: invalid\nHello1!!: valid\nSHORT1A: invalid\nlongbutnodigit: invalid",
    30: "95: A\n83: B\n71: C\n65: D\n40: F",
    31: "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz",
    32: "2000: leap\n1900: not leap\n2024: leap\n2023: not leap",
    33: "10 + 3 = 13\n10 - 3 = 7\n10 * 3 = 30\n10 / 3 = 3\n10 / 0 = 0",
    34: "a: vowel\nb: consonant\n5: digit\n!: other",
    35: "RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW",
    36: "6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8",
    37: "Invalid: -1\nInvalid: 0\nInvalid: 200\nValid: 50\nInvalid: -5\nValid: 42",
    38: "digit_sum(12345)  = 15\ndigit_sum(9999)   = 36\nft_reverse(12345) = 54321\nft_reverse(100)   = 1",
    39: "0 1 1 2 3 5 8 13 21 34",
    40: "*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*",
    41: "2 3 5 7 11 13 17 19 23 29 31 37 41 43 47\nCount: 15",
    42: "Find 8:  Found at index 3\nFind 42: Found at index 4\nFind 99: Not found",
    43: "[1]: 7\n[4]: 5\n[6]: 2\n[7]: 9\n[9]: 6\nSum of positives: 29",
    44: "(1,1)=1\n(1,4)=4\n(2,2)=4\n(3,3)=9\n(4,4)=16\n(5,5)=25",
    45: "Min: 1\nMax: 10\nSum: 55\nAvg: 5.50",
    46: "Before: 64 34 25 12 22 11 90\nAfter:  11 12 22 25 34 64 90",
    47: "1 2 3\n4 5 6\n7 8 9\nSum: 45\nTrace: 15",
    48: "strlen: 5\nstrcpy: world\nstrcmp equal: 0\nstrcmp diff: nonzero\nstrchr: llo",
    49: "upper: HELLO WORLD\nlower: hello world\nreverse: edcba\nwords: 4",
    50: 'atoi("42"):    42\natoi("-100"):  -100\natoi("0"):     0\nitoa(12345):   12345\nitoa(-7):      -7',
    51: "You entered: Hello42",
    52: "Uppercase: 2\nLowercase: 8\nDigits: 2\nSpaces: 2",
    53: "Line 1 (len=5): hello\nLine 2 (len=5): world\nLine 3 (len=2): 42",
    54: "global: 0x[addr]\nstack:  0x[addr]\nheap:   0x[addr]",
    55: "After double_val: 5\nAfter double_ref: 10",
    56: "Before swap: a=10, b=20\nAfter swap:  a=20, b=10\nBefore swap: s1=hello, s2=world\nAfter swap:  s1=world, s2=hello",
    57: "*p     = 10\n*(p+1) = 20\n*(p+2) = 30\n*(p+3) = 40\n*(p+4) = 50\nint units apart:  1\nbytes apart:      4",
    58: "x    = 42\n*p   = 42\n**pp = 42\nAfter **pp = 99: x = 99",
    59: "ft_add(10, 3) = 13\nft_sub(10, 3) = 7\nft_mul(10, 3) = 30\n2 4 6 8 10\n\nYou have completed the C Mastery Exam. You are ready.",
}

# ══════════════════════════════════════════════════════════════════
#  DIFF DISPLAY
# ══════════════════════════════════════════════════════════════════
def show_diff(expected_str, got_str, lvl):
    if lvl == 54:
        print(f"  {YELLOW}Note:{RESET} Addresses vary per run — checking label format only.")
        print(f"  {BOLD}Expected format:{RESET}")
        print(f"    {GREEN}global: 0x...{RESET}")
        print(f"    {GREEN}stack:  0x...{RESET}")
        print(f"    {GREEN}heap:   0x...{RESET}")
        print()
        return

    exp_lines = expected_str.splitlines()
    got_lines = got_str.splitlines() if got_str else []

    print(f"  {BOLD}{CYAN}┌─────────────────────────────────────────────────────────┐{RESET}")
    print(f"  {CYAN}│{RESET}  {BOLD}{'EXPECTED':<24}{RESET}  {BOLD}{'YOUR OUTPUT':<24}{RESET}  {CYAN}│{RESET}")
    print(f"  {CYAN}├──────────────────────────────┬──────────────────────────┤{RESET}")

    max_rows = max(len(exp_lines), len(got_lines))
    first_diff_idx = None

    for i in range(max_rows):
        el = exp_lines[i] if i < len(exp_lines) else None
        gl = got_lines[i] if i < len(got_lines) else None
        if el is None:
            # extra line in output
            gl_d = (gl or "")[:24]
            print(f"  {CYAN}│{RESET}  {GRAY}{'(unexpected)':<28}{RESET}{CYAN}│{RESET}  {RED}{gl_d:<24}{RESET}  {CYAN}│{RESET} {RED}✗{RESET}")
        elif gl is None:
            # missing line
            el_d = el[:28]
            print(f"  {CYAN}│{RESET}  {GREEN}{el_d:<28}{RESET}{CYAN}│{RESET}  {RED}{'(missing)':<24}{RESET}  {CYAN}│{RESET} {RED}✗{RESET}")
            if first_diff_idx is None: first_diff_idx = i
        elif el == gl:
            el_d = el[:28]; gl_d = gl[:24]
            print(f"  {CYAN}│{RESET}  {GREEN}{el_d:<28}{RESET}{CYAN}│{RESET}  {GREEN}{gl_d:<24}{RESET}  {CYAN}│{RESET} {GREEN}✓{RESET}")
        else:
            el_d = el[:28]; gl_d = (gl or "")[:24]
            print(f"  {CYAN}│{RESET}  {GREEN}{el_d:<28}{RESET}{CYAN}│{RESET}  {RED}{gl_d if gl_d else '(empty)':<24}{RESET}  {CYAN}│{RESET} {RED}✗{RESET}")
            if first_diff_idx is None: first_diff_idx = i

    print(f"  {CYAN}└──────────────────────────────┴──────────────────────────┘{RESET}")

    if len(exp_lines) != len(got_lines):
        print(f"  {RED}Line count: expected {len(exp_lines)}, got {len(got_lines)}{RESET}")

    # Char-level hint on first mismatch
    if first_diff_idx is not None:
        fe = exp_lines[first_diff_idx] if first_diff_idx < len(exp_lines) else ""
        fg = got_lines[first_diff_idx] if first_diff_idx < len(got_lines) else ""
        print()
        print(f"  {BOLD}First difference on line {first_diff_idx + 1}:{RESET}")
        max_c = max(len(fe), len(fg))
        pos = max_c
        for c_i in range(max_c):
            ec = fe[c_i] if c_i < len(fe) else ""
            gc = fg[c_i] if c_i < len(fg) else ""
            if ec != gc:
                pos = c_i
                break
        ec = fe[pos] if pos < len(fe) else "(end)"
        gc = fg[pos] if pos < len(fg) else "(end)"
        print(f"  Expected char at pos {pos}: {GREEN}'{ec}'{RESET}")
        print(f"  Got char at pos {pos}     : {RED}'{gc}'{RESET}")
        arrow = " " * pos + "^"
        print(f"  {GREEN}{fe}{RESET}")
        print(f"  {RED}{fg}{RESET}")
        print(f"  {YELLOW}{arrow}{RESET}")
    print()

# ══════════════════════════════════════════════════════════════════
#  COMPILER / RUNNER
# ══════════════════════════════════════════════════════════════════
def find_gcc():
    """Find gcc on Windows (MinGW/MSYS2/WSL/Cygwin) or Linux/Mac."""
    for candidate in ["gcc", "gcc.exe", "cc"]:
        if shutil.which(candidate):
            return candidate
    return None

def run_program(binary, stdin_data=None):
    """Run a compiled binary, optionally with stdin input."""
    try:
        result = subprocess.run(
            [binary],
            input=stdin_data,
            capture_output=True,
            text=True,
            timeout=10
        )
        return result.stdout.strip(), result.returncode
    except subprocess.TimeoutExpired:
        return "[TIMEOUT]", 1
    except Exception as e:
        return f"[RUN ERROR: {e}]", 1

# ══════════════════════════════════════════════════════════════════
#  GRADER
# ══════════════════════════════════════════════════════════════════
def grade_me():
    level = get_level()
    fname = get_filename(level)
    dname = get_dirname(level)
    task_dir = os.path.join("rendu", dname)
    os.makedirs(task_dir, exist_ok=True)
    trace_dir = "traces"
    os.makedirs(trace_dir, exist_ok=True)
    trace_file = os.path.join(trace_dir, f"trace_{dname}.txt")

    print()
    print(f"{BOLD}{CYAN}┌─────────────────────────────────────────────────────────┐{RESET}")
    print(f"{CYAN}│{RESET}  {BOLD}Grading Level {level:<3}{RESET}  File: {WHITE}{fname:<28}{RESET}{CYAN}│{RESET}")
    print(f"{BOLD}{CYAN}└─────────────────────────────────────────────────────────┘{RESET}")

    src = os.path.join(task_dir, fname)
    if not os.path.isfile(src):
        print(f"{RED}  ✗ ERROR:{RESET} {src} not found.")
        print(f"  Create your file there and run {BOLD}grademe{RESET} again.")
        return

    gcc = find_gcc()
    if not gcc:
        print(f"{RED}  ✗ ERROR:{RESET} gcc not found. Install MinGW-w64 or GCC.")
        print("  Download: https://www.mingw-w64.org/  or use MSYS2.")
        return

    binary = "eval_bin.exe" if sys.platform == "win32" else "eval_bin"
    print(f"{GRAY}  Compiling...{RESET}", end="", flush=True)

    compile_result = subprocess.run(
        [gcc, "-Wall", "-Wextra", "-Werror", src, "-o", binary, "-lm"],
        capture_output=True, text=True
    )

    if compile_result.returncode != 0:
        print(f"\r{RED}  ✗ COMPILE ERROR{RESET}")
        print()
        print(compile_result.stderr)
        with open(trace_file, "a") as tf:
            tf.write(f"=== Level {level} COMPILE ERROR | {datetime.datetime.now()} ===\n")
            tf.write(compile_result.stderr + "\n")
        print(f"{GRAY}  Trace saved: {trace_file}{RESET}")
        return
    print(f"\r{GREEN}  ✓ Compiled OK{RESET}")

    # --- Run & check ---
    output, _ = run_program(f"./{binary}")
    PASS = False

    def contains(text, sub): return sub in text
    def line_eq(text, n, val):
        lines = text.splitlines()
        return len(lines) >= n and lines[n-1] == val

    lvl = level
    out = output

    if   lvl == 0:  PASS = out == "Hello, C World!"
    elif lvl == 1:  PASS = "Program starting" in out and "Program done" in out
    elif lvl == 2:  PASS = all(x in out for x in ["Preprocessing","Compilation","Assembly","Linking"])
    elif lvl == 3:  PASS = out == "Syntax is power"
    elif lvl == 4:  PASS = "Hello" in out and "Goodbye" in out
    elif lvl == 5:  PASS = "Result: 15" in out
    elif lvl == 6:  PASS = "HEADER" in out and "Content here" in out and "FOOTER" in out
    elif lvl == 7:  PASS = all(x in out.splitlines() for x in ["0","42","-7","100"])
    elif lvl == 8:  PASS = "a b c d e f" in out and "0 1 2 3 4 5" in out
    elif lvl == 9:  PASS = out == "Comments guide future you"
    elif lvl == 10: PASS = "Length: 5" in out and "IsAlpha: 0" in out and "IsAlpha: 1" in out
    elif lvl == 11: PASS = "Sum: 10" in out
    elif lvl == 12: PASS = all(x in out for x in ["letter: X","count: 2025","pi_approx: 3.14","precise: 2.718282"])
    elif lvl == 13: PASS = "local g = 999" in out and "global g = 100" in out
    elif lvl == 14: PASS = "Before: a=5, b=9" in out and "After:  a=9, b=5" in out
    elif lvl == 15: PASS = all(x in out for x in ["char:","int:","float:","double:"])
    elif lvl == 16: PASS = all(x in out for x in ["INT_MAX:  2147483647","INT_MIN:  -2147483648","CHAR_MAX: 127","CHAR_MIN: -128","Overflow result: -2147483648"])
    elif lvl == 17: PASS = all(x in out for x in ["signed char:   -1","unsigned char: 255","unsigned underflow: 4294967295"])
    elif lvl == 18: PASS = all(x in out for x in ["char from int: A","int from char: 122","2.000000","2.500000"])
    elif lvl == 19: PASS = all(x in out for x in ["1 of 3   = 33%","2 of 3   = 66%","1 of 4   = 25%","3 of 4   = 75%","1 of 7   = 14%"])
    elif lvl == 20: PASS = all(x in out for x in ["A -> a","M -> m","Z -> z","'5' -> 5","'9' -> 9"])
    elif lvl == 21: PASS = all(x in out for x in ["BUFFER_SIZE: 1024","PI: 3.14159265","MAX_USERS: 100","SEPARATOR: -"])
    elif lvl == 22: PASS = all(x in out for x in ["1: Monday","2: Tuesday","3: Wednesday","7: Sunday"])
    elif lvl == 23: PASS = all(x in out for x in ["MAX(3, 7)   = 7","MIN(3, 7)   = 3","ABS(-5)     = 5","SQUARE(4)   = 16"])
    elif lvl == 24: PASS = all(x in out for x in ["a & b  = 8","a | b  = 14","a ^ b  = 6","~a     = -11","a << 1 = 20","a >> 1 = 5"])
    elif lvl == 25: PASS = all(x in out for x in ["x += 4  : 20","x -= 5  : 15","x *= 3  : 45","x /= 9  : 5","x %= 3  : 2","x <<= 2 : 8"])
    elif lvl == 26: PASS = all(x in out for x in ["negative","zero","positive","abs(-42): 42"])
    elif lvl == 27: PASS = all(x in out for x in ["A=0 B=0: AND=0 OR=0  NOT_A=1","A=0 B=1: AND=0 OR=1  NOT_A=1","A=1 B=0: AND=0 OR=1  NOT_A=0","A=1 B=1: AND=1 OR=1  NOT_A=0"])
    elif lvl == 28:
        has_a = "check_a called" in out
        has_b = "check_b called" in out
        lines = out.splitlines()
        # After "Test 1:", check_b should NOT appear before "Test 2:"
        t1_lines = []
        t2_lines = []
        in_t1 = False; in_t2 = False
        for l in lines:
            if l.strip() == "Test 1:": in_t1 = True; in_t2 = False
            elif l.strip() == "Test 2:": in_t2 = True; in_t1 = False
            elif in_t1: t1_lines.append(l)
            elif in_t2: t2_lines.append(l)
        PASS = has_a and has_b and "check_b called" not in t1_lines and "check_a called" not in t2_lines
    elif lvl == 29: PASS = all(x in out for x in ["hello: invalid","Hello1!!: valid","SHORT1A: invalid","longbutnodigit: invalid"])
    elif lvl == 30: PASS = all(x in out for x in ["95: A","83: B","71: C","65: D","40: F"])
    elif lvl == 31:
        PASS = ("Fizz" in out and "Buzz" in out and "FizzBuzz" in out
                and line_eq(out, 3, "Fizz") and line_eq(out, 5, "Buzz") and line_eq(out, 15, "FizzBuzz"))
    elif lvl == 32: PASS = all(x in out for x in ["2000: leap","1900: not leap","2024: leap","2023: not leap"])
    elif lvl == 33: PASS = all(x in out for x in ["10 + 3 = 13","10 - 3 = 7","10 * 3 = 30","10 / 3 = 3","10 / 0 = 0"])
    elif lvl == 34: PASS = all(x in out for x in ["a: vowel","b: consonant","5: digit","!: other"])
    elif lvl == 35: PASS = out == "RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW"
    elif lvl == 36: PASS = out == "6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8"
    elif lvl == 37: PASS = all(x in out for x in ["Invalid: -1","Invalid: 0","Invalid: 200","Valid: 50","Invalid: -5","Valid: 42"])
    elif lvl == 38: PASS = all(x in out for x in ["digit_sum(12345)  = 15","digit_sum(9999)   = 36","ft_reverse(12345) = 54321","ft_reverse(100)   = 1"])
    elif lvl == 39: PASS = out == "0 1 1 2 3 5 8 13 21 34"
    elif lvl == 40: PASS = out == "*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*"
    elif lvl == 41: PASS = "2 3 5 7 11 13 17 19 23 29 31 37 41 43 47" in out and "Count: 15" in out
    elif lvl == 42: PASS = all(x in out for x in ["Found at index 3","Found at index 4","Not found"])
    elif lvl == 43: PASS = all(x in out for x in ["[1]: 7","[4]: 5","[6]: 2","[7]: 9","[9]: 6","Sum of positives: 29"])
    elif lvl == 44: PASS = all(x in out for x in ["(1,1)=1","(1,4)=4","(2,2)=4","(3,3)=9","(4,4)=16","(5,5)=25"])
    elif lvl == 45: PASS = all(x in out for x in ["Min: 1","Max: 10","Sum: 55","Avg: 5.50"])
    elif lvl == 46: PASS = "Before: 64 34 25 12 22 11 90" in out and "After:  11 12 22 25 34 64 90" in out
    elif lvl == 47: PASS = all(x in out for x in ["1 2 3","4 5 6","7 8 9","Sum: 45","Trace: 15"])
    elif lvl == 48: PASS = all(x in out for x in ["strlen: 5","strcpy: world","strcmp equal: 0","strchr: llo"])
    elif lvl == 49: PASS = all(x in out for x in ["upper: HELLO WORLD","lower: hello world","reverse: edcba","words: 4"])
    elif lvl == 50: PASS = all(x in out for x in ['atoi("42"):    42','atoi("-100"):  -100','atoi("0"):     0','itoa(12345):   12345','itoa(-7):      -7'])
    elif lvl == 51:
        inp_out, _ = run_program(f"./{binary}", stdin_data="Hello42\n")
        PASS = "You entered: Hello42" in inp_out
        output = inp_out
        out = inp_out
    elif lvl == 52:
        inp_out, _ = run_program(f"./{binary}", stdin_data="Hello World 42\n")
        PASS = all(x in inp_out for x in ["Uppercase: 2","Lowercase: 8","Digits: 2","Spaces: 2"])
        output = inp_out; out = inp_out
    elif lvl == 53:
        inp_out, _ = run_program(f"./{binary}", stdin_data="hello\nworld\n42\n")
        PASS = all(x in inp_out for x in ["Line 1 (len=5): hello","Line 2 (len=5): world","Line 3 (len=2): 42"])
        output = inp_out; out = inp_out
    elif lvl == 54: PASS = "global: 0x" in out and "stack:  0x" in out and "heap:   0x" in out
    elif lvl == 55: PASS = "After double_val: 5" in out and "After double_ref: 10" in out
    elif lvl == 56: PASS = all(x in out for x in ["Before swap: a=10, b=20","After swap:  a=20, b=10","Before swap: s1=hello, s2=world","After swap:  s1=world, s2=hello"])
    elif lvl == 57: PASS = all(x in out for x in ["*p     = 10","*(p+4) = 50","int units apart:  1","bytes apart:      4"])
    elif lvl == 58: PASS = all(x in out for x in ["x    = 42","**pp = 42","After **pp = 99: x = 99"])
    elif lvl == 59: PASS = all(x in out for x in ["ft_add(10, 3) = 13","ft_sub(10, 3) = 7","ft_mul(10, 3) = 30","2 4 6 8 10","You have completed"])
    else:           PASS = True

    # Show output box
    print()
    print(f"{GRAY}┌── Your output ─────────────────────────────────────────────┐{RESET}")
    for line in output.splitlines():
        print(f"{GRAY}│{RESET} {line}")
    print(f"{GRAY}└────────────────────────────────────────────────────────────┘{RESET}")
    print()

    # Append trace
    with open(trace_file, "a") as tf:
        tf.write(f"=== Level {level} | {datetime.datetime.now()} ===\n{output}\n")

    # Cleanup binary
    try: os.remove(binary)
    except: pass

    if PASS:
        add_attempt(level, "PASS")
        inc_streak()
        if not already_passed(level):
            add_score(1)
            mark_passed(level)
            score_msg = f"  {GREEN}+1 point awarded!{RESET}  Score: {BOLD}{get_score()}/60{RESET}"
        else:
            score_msg = f"  {GRAY}(already cleared — no extra point){RESET}"

        streak = get_streak()
        streak_msg = ""
        if streak >= 5: streak_msg = f"  {YELLOW}⚡ {streak} win streak! On fire!{RESET}"
        elif streak >= 3: streak_msg = f"  {YELLOW}🔥 {streak} win streak!{RESET}"

        print(f"{GREEN}  ╔══════════════════════════════════════════════════════╗{RESET}")
        print(f"{GREEN}  ║                    ✓  PASS                          ║{RESET}")
        print(f"{GREEN}  ╚══════════════════════════════════════════════════════╝{RESET}")
        print()
        print(f"{GREEN}  Level {BOLD}{level}{RESET}{GREEN} cleared!  [ {WHITE}{fname}{GREEN} ]{RESET}")
        print(score_msg)
        if streak_msg: print(streak_msg)
        auto_save()
        print(f"  {GRAY}(auto-saved){RESET}")

        next_lvl = level + 1
        set_level(next_lvl)

        if next_lvl > MAX_LEVEL:
            print()
            print(f"{BOLD}{GREEN}")
            print("  ╔══════════════════════════════════════════════════════╗")
            print("  ║          EXAM COMPLETE — C MASTERY ACHIEVED         ║")
            print(f"  ║          FINAL SCORE: {get_score():<3} / 60                      ║")
            print("  ║                                                      ║")
            print("  ║  Topics mastered:                                    ║")
            print("  ║  Intro · Syntax · Output · Comments · Variables      ║")
            print("  ║  Data Types · Type Conv · Constants · Operators      ║")
            print("  ║  Booleans · If/Else · Switch · While · For           ║")
            print("  ║  Break/Continue · Arrays · Strings · Input           ║")
            print("  ║  Memory Addresses · Pointers                         ║")
            print("  ╚══════════════════════════════════════════════════════╝")
            print(f"{RESET}")
            sys.exit(0)
        print()
        pause(f"  Press Enter for Level {next_lvl}...")
    else:
        add_attempt(level, "FAIL")
        reset_streak()
        attempts   = get_attempts(level)
        fails_here = get_fails_for(level)
        total_fail = get_total_fail()

        print(f"{RED}  ╔══════════════════════════════════════════════════════╗{RESET}")
        print(f"{RED}  ║                    ✗  FAIL                          ║{RESET}")
        print(f"{RED}  ╚══════════════════════════════════════════════════════╝{RESET}")
        print()
        print(f"  Attempt {BOLD}#{attempts}{RESET} on level {BOLD}{level}{RESET}. {RED}Fails on this level: {fails_here}{RESET}  |  {RED}Total fails all-time: {total_fail}{RESET}")
        print()

        exp_str = EXPECTED.get(level, "")
        if exp_str:
            show_diff(exp_str, output, level)

        if attempts == 1:
            print(f"  {YELLOW}Tip:{RESET} Compare your output letter-by-letter with expected.")
        elif attempts == 2:
            print(f"  {YELLOW}Tip:{RESET} Check for extra spaces, missing newlines, or wrong spelling.")
        elif attempts >= 3:
            print(f"  {YELLOW}Tip:{RESET} Type {CYAN}hint{RESET} to re-read the full subject. {attempts} attempts so far.")

        print()
        print(f"  {BOLD}Next steps:{RESET}")
        print(f"  · {CYAN}hint{RESET}         — re-read the subject")
        print(f"  · {WHITE}open{RESET}         — open your file in notepad / your $EDITOR")
        print()
        print(f"  Score: {BOLD}{get_score()}/60{RESET}   Streak reset to 0.")
        print()
        time.sleep(0.3)
        pause("  Press Enter to try again...")

# ══════════════════════════════════════════════════════════════════
#  STATS TABLE
# ══════════════════════════════════════════════════════════════════
def show_stats():
    current = get_level()
    print()
    print(c(BOLD+CYAN, "╔══════════════════════════════════════════════════════════╗"))
    print(c(BOLD+CYAN, "║               ◆  PER-LEVEL STATS  ◆                     ║"))
    print(c(BOLD+CYAN, "╠══════════════════════════════════════════════════════════╣"))
    print(f"{CYAN}║{RESET}  {BOLD}{'Lvl':<4}  {'File':<22}  {'Pass':>5}  {'Fail':>5}  {'Status':<8}{RESET}  {CYAN}║{RESET}")
    print(c(CYAN, "╠══════════════════════════════════════════════════════════╣"))

    total_p = total_f = 0
    for i in range(min(current + 1, MAX_LEVEL + 1)):
        fname = get_filename(i)
        p = get_passes_for(i)
        f = get_fails_for(i)
        total_p += p; total_f += f
        if already_passed(i):
            status = "✓ clean" if f == 0 else f"✓ +{f}retry"
            col = GREEN if f == 0 else YELLOW
        elif i == current:
            status = "► active"; col = CYAN
        elif p == 0 and f == 0:
            status = "─ untried"; col = GRAY
        else:
            status = "✗ stuck"; col = RED
        short = fname[:22]
        print(f"{CYAN}║{RESET}  {col}{i:<4}  {short:<22}  {p:>5}  {f:>5}  {status:<8}{RESET}  {CYAN}║{RESET}")

    print(c(CYAN, "╠══════════════════════════════════════════════════════════╣"))
    print(f"{CYAN}║{RESET}  {BOLD}{'TOTAL':<27}{RESET}  {GREEN}{total_p:>5}{RESET}  {RED}{total_f:>5}{RESET}          {CYAN}║{RESET}")
    print(c(BOLD+CYAN, "╚══════════════════════════════════════════════════════════╝"))
    print()
    pause()

# ══════════════════════════════════════════════════════════════════
#  SAVE / LOAD
# ══════════════════════════════════════════════════════════════════
def _copy_state_to(slot_dir):
    os.makedirs(slot_dir, exist_ok=True)
    for f in [".level",".score",".passed",".attempts",".streak",".best"]:
        try: shutil.copy2(f, os.path.join(slot_dir, f.lstrip(".")))
        except: pass
    with open(os.path.join(slot_dir, "timestamp"), "w") as tf:
        tf.write(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    with open(os.path.join(slot_dir, "meta"), "w") as mf:
        mf.write(f"Level={get_level()} Score={get_score()}")

def _copy_state_from(slot_dir):
    for f in ["level","score","passed","attempts","streak","best"]:
        src = os.path.join(slot_dir, f)
        dst = f".{f}"
        try: shutil.copy2(src, dst)
        except: pass

def sanitize_slot(name): return re.sub(r'[^a-zA-Z0-9_\-]', '', name) or "quicksave"

def auto_save(): _copy_state_to(os.path.join("saves", "autosave"))

def do_save(slot="quicksave"):
    slot = sanitize_slot(slot)
    _copy_state_to(os.path.join("saves", slot))
    print(f"  {GREEN}✓ Saved{RESET} → slot '{BOLD}{slot}{RESET}'  (level={get_level()}, score={get_score()}/60)")

def do_load(slot="quicksave"):
    slot = sanitize_slot(slot)
    slot_dir = os.path.join("saves", slot)
    if not os.path.isdir(slot_dir):
        print(f"  {RED}No save found with name '{slot}'.{RESET}  Use {CYAN}saves{RESET} to list slots.")
        return
    ts   = _read(os.path.join(slot_dir, "timestamp"), "unknown")
    meta = _read(os.path.join(slot_dir, "meta"), "")
    confirm = input(f"  Load '{slot}' ({meta}, saved {ts})? This overwrites current progress. (y/n): ")
    if confirm.strip().lower() == "y":
        _copy_state_from(slot_dir)
        print(f"  {GREEN}✓ Loaded{RESET} slot '{BOLD}{slot}{RESET}'  →  level={get_level()}, score={get_score()}/60")
        time.sleep(1)
    else:
        print(f"  {GRAY}Load cancelled.{RESET}")

def list_saves():
    print()
    print(c(BOLD+CYAN, "╔══════════════════════════════════════════════════════════╗"))
    print(c(BOLD+CYAN, "║                  ◆  SAVE SLOTS  ◆                       ║"))
    print(c(BOLD+CYAN, "╠══════════════════════════════════════════════════════════╣"))
    saves_dir = "saves"
    found = False
    if os.path.isdir(saves_dir):
        for slot in sorted(os.listdir(saves_dir)):
            slot_dir = os.path.join(saves_dir, slot)
            if not os.path.isdir(slot_dir): continue
            found = True
            ts   = _read(os.path.join(slot_dir, "timestamp"), "no date")
            meta = _read(os.path.join(slot_dir, "meta"), "")
            marker = f"{GRAY}[auto]{RESET} " if slot == "autosave" else ""
            print(f"{CYAN}║{RESET}  {BOLD}{slot:<15}{RESET}  {meta}  {marker}{GRAY}{ts}{RESET}  {CYAN}║{RESET}")
    if not found:
        print(f"{CYAN}║{RESET}  {GRAY}No saves yet. Use: save [name]{RESET}                        {CYAN}║{RESET}")
    print(c(BOLD+CYAN, "╚══════════════════════════════════════════════════════════╝"))
    print()
    print(f"  {GRAY}Commands: {WHITE}save [name]{RESET}  {WHITE}load [name]{RESET}  {RED}deletesave [name]{RESET}")
    print()
    pause()

def delete_save(slot):
    if not slot:
        print(f"  {RED}Usage: deletesave <name>{RESET}"); return
    slot = sanitize_slot(slot)
    slot_dir = os.path.join("saves", slot)
    if not os.path.isdir(slot_dir):
        print(f"  {RED}No save slot named '{slot}'.{RESET}"); return
    confirm = input(f"  Delete save '{slot}'? (y/n): ")
    if confirm.strip().lower() == "y":
        shutil.rmtree(slot_dir)
        print(f"  {RED}Deleted{RESET} save slot '{slot}'.")
        time.sleep(1)
    else:
        print(f"  {GRAY}Cancelled.{RESET}")

# ══════════════════════════════════════════════════════════════════
#  HELP
# ══════════════════════════════════════════════════════════════════
def show_help():
    print()
    print(c(BOLD+CYAN, "╔══════════════════════════════════════════════════════════╗"))
    print(c(BOLD+CYAN, "║                    ◆  COMMANDS  ◆                       ║"))
    print(c(BOLD+CYAN, "╠══════════════════════════════════════════════════════════╣"))
    cmds = [
        (GREEN,  "grademe",      "compile & grade your solution"),
        (CYAN,   "hint",         "re-read the current subject"),
        (WHITE,  "open",         "open your .c file in notepad / $EDITOR"),
        (WHITE,  "cat",          "print your current .c file"),
        (CYAN,   "score",        "show full scoreboard"),
        (CYAN,   "stats",        "per-level pass/fail breakdown"),
        (CYAN,   "history",      "attempt log for this level"),
        (MAGENTA,"save [name]",  "save progress to a named slot"),
        (MAGENTA,"load [name]",  "restore a saved slot"),
        (MAGENTA,"saves",        "list all save slots"),
        (MAGENTA,"deletesave N", "delete a save slot"),
        (YELLOW, "skip",         "skip level (no credit)"),
        (YELLOW, "goto N",       "jump to level N"),
        (RED,    "reset",        "restart level counter (score kept)"),
        (RED,    "resetscore",   "full reset (level + score + streaks)"),
        (GRAY,   "exit",         "quit (progress saved)"),
    ]
    for col, cmd, desc in cmds:
        print(f"{CYAN}║{RESET}  {col}{cmd:<14}{RESET}  {desc:<38}  {CYAN}║{RESET}")
    print(c(BOLD+CYAN, "╚══════════════════════════════════════════════════════════╝"))
    print()
    pause()

# ══════════════════════════════════════════════════════════════════
#  HISTORY
# ══════════════════════════════════════════════════════════════════
def show_history(level):
    print()
    print(f"{BOLD}  Attempt history — Level {level}{RESET}")
    print(f"{GRAY}  ──────────────────────────────{RESET}")
    found = False
    for line in _lines(".attempts"):
        parts = line.split(":")
        if len(parts) >= 3 and parts[0] == str(level):
            found = True
            result = parts[1]
            ts = parts[2]
            if result == "PASS":
                print(f"  {GREEN}✓ PASS{RESET}  at {ts}")
            else:
                print(f"  {RED}✗ FAIL{RESET}  at {ts}")
    if not found:
        print(f"  {GRAY}No attempts yet on this level.{RESET}")
    print()
    pause()

# ══════════════════════════════════════════════════════════════════
#  OPEN FILE
# ══════════════════════════════════════════════════════════════════
def open_file(level):
    dname = get_dirname(level)
    fname = get_filename(level)
    fpath = os.path.join("rendu", dname, fname)
    os.makedirs(os.path.join("rendu", dname), exist_ok=True)
    if not os.path.isfile(fpath):
        open(fpath, "w").close()  # create empty file
    editor = os.environ.get("EDITOR", "")
    if not editor:
        if sys.platform == "win32":
            editor = "notepad"
        else:
            editor = "nano"
    os.system(f'{editor} "{fpath}"')

def cat_file(level):
    dname = get_dirname(level)
    fname = get_filename(level)
    fpath = os.path.join("rendu", dname, fname)
    if os.path.isfile(fpath):
        print()
        print(f"{GRAY}── {fpath} ──{RESET}")
        with open(fpath) as f:
            for i, line in enumerate(f, 1):
                print(f"{i:>4}  {line}", end="")
        print()
    else:
        print(f"  {RED}File not found:{RESET} {fpath}")
    print()
    pause()

# ══════════════════════════════════════════════════════════════════
#  INIT
# ══════════════════════════════════════════════════════════════════
def init():
    for d in ["subjects","rendu","traces","saves"]:
        os.makedirs(d, exist_ok=True)
    for f, default in [(".level","0"),(".score","0"),(".streak","0"),(".best","0")]:
        if not os.path.isfile(f): _write(f, default)
    for f in [".passed",".attempts"]:
        if not os.path.isfile(f): open(f, "w").close()

# ══════════════════════════════════════════════════════════════════
#  MAIN LOOP
# ══════════════════════════════════════════════════════════════════
def main():
    init()

    while True:
        level = get_level()
        fname = get_filename(level)

        clear()
        print(c(BOLD+CYAN, "╔══════════════════════════════════════════════════════════╗"))
        print(c(BOLD+CYAN, "║      MILES3103 — C MASTERY EXAM v14.0  (60 Levels)      ║"))
        print(c(BOLD+CYAN, "╚══════════════════════════════════════════════════════════╝"))
        print()
        show_progress()
        print()

        if level > MAX_LEVEL:
            print(f"{GREEN}  ALL LEVELS COMPLETE — You are a C programmer now.{RESET}")
            show_scoreboard()
            sys.exit(0)

        show_subject(level)

        dname = get_dirname(level)
        print(f"{GRAY}  ────────────────────────────────────────────────────────{RESET}")
        print(f"  {BOLD}Your file :{RESET} {WHITE}rendu/{dname}/{fname}{RESET}")
        print(f"  {BOLD}Trace log :{RESET} {GRAY}traces/trace_{dname}.txt{RESET}")
        print(f"{GRAY}  ────────────────────────────────────────────────────────{RESET}")
        print(f"  {GREEN}grademe{RESET} · {CYAN}hint{RESET} · {WHITE}open{RESET} · {WHITE}cat{RESET} · {CYAN}score{RESET} · {CYAN}stats{RESET} · {MAGENTA}save{RESET} · {MAGENTA}load{RESET} · {MAGENTA}saves{RESET} · {WHITE}help{RESET}")
        print(f"{GRAY}  ────────────────────────────────────────────────────────{RESET}")

        try:
            raw = input(f"  {BOLD}{CYAN}exam{RESET}[{YELLOW}lvl{level}{RESET}|{GREEN}{get_score()}/60{RESET}]{BOLD}> {RESET}").strip()
        except (KeyboardInterrupt, EOFError):
            print()
            print(f"  {GRAY}Exiting. Progress saved at level {get_level()}. Score: {get_score()}/60.{RESET}")
            sys.exit(0)

        inp = raw.lower()

        if raw == "grademe":
            os.makedirs(os.path.join("rendu", get_dirname(level)), exist_ok=True)
            grade_me()
        elif raw in ("score","scoreboard"):
            show_scoreboard()
        elif raw == "stats":
            show_stats()
        elif raw in ("saves","savelist"):
            list_saves()
        elif raw == "save":
            do_save("quicksave"); time.sleep(1)
        elif raw.startswith("save "):
            do_save(raw[5:]); time.sleep(1)
        elif raw == "load":
            do_load("quicksave")
        elif raw.startswith("load "):
            do_load(raw[5:])
        elif raw.startswith("deletesave "):
            delete_save(raw[11:])
        elif raw in ("hint","subject"):
            show_subject(level)
            pause()
        elif raw == "open":
            open_file(level)
        elif raw == "cat":
            cat_file(level)
        elif raw == "history":
            show_history(level)
        elif raw == "skip":
            print(f"  {YELLOW}Skipping level {level}...{RESET}")
            set_level(level + 1); time.sleep(1)
        elif raw.startswith("goto "):
            try:
                target = int(raw[5:])
                if 0 <= target <= MAX_LEVEL:
                    set_level(target)
                    print(f"  {YELLOW}Jumped to level {target}.{RESET}"); time.sleep(1)
                else:
                    print(f"  {RED}Invalid level. Use 0-{MAX_LEVEL}{RESET}"); time.sleep(1)
            except ValueError:
                print(f"  {RED}Usage: goto <number>{RESET}"); time.sleep(1)
        elif raw == "reset":
            confirm = input("  Reset level to 0? (score is kept) (y/n): ")
            if confirm.strip().lower() == "y": set_level(0)
        elif raw == "resetscore":
            confirm = input("  Reset ALL progress including score? (y/n): ")
            if confirm.strip().lower() == "y":
                set_level(0); set_score(0); set_streak(0); set_best(0)
                open(".passed","w").close(); open(".attempts","w").close()
                print(f"  {RED}Full reset done.{RESET}"); time.sleep(1)
        elif raw in ("help","h","?"):
            show_help()
        elif raw in ("exit","quit","q"):
            print(f"  {GRAY}Progress saved at level {get_level()}. Score: {get_score()}/60. Streak: {get_streak()}. Keep going!{RESET}")
            sys.exit(0)
        elif raw == "":
            pass  # just redraw
        else:
            print(f"  {RED}Unknown command.{RESET} Type {BOLD}help{RESET} for the list.")
            time.sleep(1)

if __name__ == "__main__":
    main()
