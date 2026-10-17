#!/usr/bin/env python3
"""
================================================================================
  Project : Python Basics
  Author  : Miles3103
  Topic   : Variables, types, print, input, f-strings, type conversion
================================================================================

WHY PYTHON IS DIFFERENT FROM C AND C++:
  - No variable declarations — just assign and it exists
  - No types needed — Python figures them out (dynamic typing)
  - No semicolons, no curly braces — indentation IS the structure
  - No compilation — run directly: python3 filename.py
  - Garbage collected — no malloc, no free, no memory management
  - Everything is an object — even integers and functions

PYTHON'S PHILOSOPHY (The Zen of Python):
  - Beautiful is better than ugly
  - Explicit is better than implicit
  - Simple is better than complex
  - Readability counts

This makes Python the fastest language to write in,
but you trade low-level control for speed of development.
Use C for performance. Use Python for productivity.
"""

# ============================================================================
#  1. VARIABLES — no type declaration needed
# ============================================================================

print("=== Variables ===")

name    = "Miles3103"   # str
age     = 20            # int
height  = 1.75          # float
active  = True          # bool (capital T/F unlike C)
nothing = None          # None = null in Python

print(name, age, height, active, nothing)

# Multiple assignment
x, y, z = 10, 20, 30
print(f"x={x} y={y} z={z}")

# Swap — no temp variable needed (Python magic)
x, y = y, x
print(f"after swap: x={x} y={y}")

# Dynamic typing — type can change (unlike C)
val = 42
print(type(val))   # <class 'int'>
val = "now a string"
print(type(val))   # <class 'str'>

# ============================================================================
#  2. BUILT-IN TYPES
# ============================================================================

print("\n=== Built-in Types ===")

# Integers — unlimited precision in Python!
big = 10 ** 100   # 10 to the power of 100 — no overflow!
print(f"10^100 has {len(str(big))} digits")

# Floats
pi = 3.14159265
print(f"pi = {pi:.4f}")   # 4 decimal places

# Strings — single or double quotes, both fine
s1 = 'hello'
s2 = "world"
s3 = """
multi
line
string
"""
print(s1 + " " + s2)
print(f"multiline has {len(s3)} chars including newlines")

# Booleans — True/False (capitalized)
print(True and False)    # False
print(True or False)     # True
print(not True)          # False
print(bool(0))           # False
print(bool(""))          # False — empty string is falsy
print(bool([]))          # False — empty list is falsy
print(bool(42))          # True  — any non-zero is truthy

# None
result = None
print(result is None)    # True — use 'is' to check for None, not ==

# ============================================================================
#  3. TYPE CONVERSION
# ============================================================================

print("\n=== Type Conversion ===")

# int() float() str() bool() list()
print(int("42"))         # str  → int
print(int(3.99))         # float → int (truncates, not rounds)
print(float("3.14"))     # str  → float
print(str(100))          # int  → str
print(bool(0))           # int  → bool
print(list("hello"))     # str  → list of chars

# int with base
print(int("FF", 16))     # hex string → int (255)
print(int("1010", 2))    # binary string → int (10)

# ============================================================================
#  4. F-STRINGS — the modern way to format strings (Python 3.6+)
# ============================================================================

print("\n=== F-Strings ===")

name  = "Miles3103"
score = 95.678
level = 15

# Basic
print(f"Player: {name}")

# Expressions inside {}
print(f"Score rounded: {score:.2f}")
print(f"Score as int: {int(score)}")
print(f"Level squared: {level ** 2}")

# Padding and alignment
print(f"{'Left':<10}|{'Center':^10}|{'Right':>10}")
print(f"{name:<10}|{score:^10.1f}|{level:>10}")

# Thousands separator
big_number = 1000000
print(f"Big number: {big_number:,}")

# Binary, hex, octal
n = 255
print(f"{n} in binary: {n:b}")
print(f"{n} in hex:    {n:x}")
print(f"{n} in octal:  {n:o}")

# ============================================================================
#  5. USER INPUT
# ============================================================================

print("\n=== User Input (simulated) ===")

# input() always returns a STRING — must convert manually
# user_name = input("Enter name: ")    # uncomment for real use
# user_age  = int(input("Enter age: ")) # convert to int

# Simulating input for this demo:
user_name = "Miles3103"
user_age  = 20

print(f"Hello {user_name}, you are {user_age} years old")
print(f"In 10 years you will be {user_age + 10}")

# ============================================================================
#  6. ARITHMETIC — same as C but with extras
# ============================================================================

print("\n=== Arithmetic ===")

a, b = 17, 5
print(f"{a} + {b}  = {a + b}")
print(f"{a} - {b}  = {a - b}")
print(f"{a} * {b}  = {a * b}")
print(f"{a} / {b}  = {a / b}")     # float division always!
print(f"{a} // {b} = {a // b}")    # integer (floor) division
print(f"{a} % {b}  = {a % b}")     # modulo
print(f"{a} ** {b} = {a ** b}")    # power (no pow() needed)

# Integer division vs float division (DIFFERENT from C!)
print(f"\n7 / 2  = {7 / 2}")       # 3.5 (not 3 like in C!)
print(f"7 // 2 = {7 // 2}")       # 3 (floor division)
print(f"-7 // 2 = {-7 // 2}")     # -4 (floors toward -infinity)

# ============================================================================
#  7. COMPARISON & LOGICAL OPERATORS
# ============================================================================

print("\n=== Comparisons ===")

x = 5
print(x > 3)          # True
print(x == 5)         # True
print(x != 4)         # True
print(1 < x < 10)     # True — chained comparison (Python only!)
print(3 <= x <= 7)    # True

# Logical: 'and' 'or' 'not' (words, not && || !)
print(True and False)
print(False or True)
print(not False)

# Short-circuit evaluation (same as C)
# 'and': if left is False, right is never evaluated
# 'or':  if left is True,  right is never evaluated

# ============================================================================
#  8. IDENTITY AND MEMBERSHIP
# ============================================================================

print("\n=== Identity & Membership ===")

a = [1, 2, 3]
b = a           # b IS a (same object)
c = [1, 2, 3]  # c EQUALS a (different object, same values)

print(a is b)   # True  — same object in memory
print(a is c)   # False — different objects
print(a == c)   # True  — same values

# 'in' operator — test membership
print(2 in a)       # True
print(5 in a)       # False
print("Miles" in "Hello Miles3103")  # True — works on strings too!


if __name__ == "__main__":
    print("\n=== Summary ===")
    print("Python types: int, float, str, bool, None")
    print("No declarations, no semicolons, indentation = structure")
    print("f-strings are the modern way to format output")
    print("/ is always float division, // is integer division")
