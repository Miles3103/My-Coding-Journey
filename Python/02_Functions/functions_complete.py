#!/usr/bin/env python3
"""
================================================================================
  Project : Functions — Complete Guide
  Author  : Miles3103
  Topic   : Functions — args, kwargs, *args, **kwargs, closures, decorators
================================================================================

PYTHON FUNCTIONS vs C FUNCTIONS:
  - No return type declaration
  - No parameter types (but you CAN add type hints — recommended)
  - Can return multiple values
  - Functions are FIRST-CLASS OBJECTS — pass them like variables
  - Support closures, default args, keyword args, *args, **kwargs
  - Docstrings for built-in documentation

FUNCTION SIGNATURES:
  def func(pos, /, normal, *, kw_only):
    /  → before this: positional-only
    *  → after this:  keyword-only
  (Advanced — important for library design)
"""

from typing import Any, Callable

# ============================================================================
#  1. BASIC FUNCTIONS + TYPE HINTS
# ============================================================================

print("=== Basic Functions ===")

# No type hints (works but not recommended)
def add(a, b):
    return a + b

# With type hints (Python 3.5+) — doesn't enforce, but documents intent
def multiply(a: int, b: int) -> int:
    """
    Multiplies two integers and returns the result.
    
    Args:
        a: First integer
        b: Second integer
    Returns:
        Product of a and b
    """
    return a * b

print(add(3, 4))
print(multiply(5, 6))
print(multiply.__doc__)  # access the docstring

# ============================================================================
#  2. RETURN MULTIPLE VALUES
# ============================================================================

print("=== Multiple Return Values ===")

def min_max(numbers: list) -> tuple:
    """Returns (min, max) as a tuple."""
    return min(numbers), max(numbers)

def divide_with_remainder(a: int, b: int) -> tuple[int, int]:
    return a // b, a % b

data = [3, 7, 1, 9, 4, 2, 8]
lo, hi = min_max(data)       # tuple unpacking
print(f"min={lo}, max={hi}")

quotient, remainder = divide_with_remainder(17, 5)
print(f"17 ÷ 5 = {quotient} remainder {remainder}")

# ============================================================================
#  3. DEFAULT PARAMETERS
# ============================================================================

print("\n=== Default Parameters ===")

def greet(name: str, greeting: str = "Hello", punctuation: str = "!") -> str:
    return f"{greeting}, {name}{punctuation}"

print(greet("Miles3103"))                          # uses defaults
print(greet("Miles3103", "Welcome"))               # overrides greeting
print(greet("Miles3103", punctuation="..."))       # keyword arg

# GOTCHA: never use mutable default (list, dict) — it's shared across calls!
def bad_append(item, lst=[]):     # BUG: lst is shared between calls
    lst.append(item)
    return lst

def good_append(item, lst=None):  # CORRECT: create new list each call
    if lst is None:
        lst = []
    lst.append(item)
    return lst

print(bad_append(1))   # [1]
print(bad_append(2))   # [1, 2] — bug! previous call's list persists
print(good_append(1))  # [1]
print(good_append(2))  # [2] — correct

# ============================================================================
#  4. *ARGS — variable positional arguments
# ============================================================================

print("\n=== *args ===")

def ft_sum(*args: int) -> int:
    """Accepts any number of integers and returns their sum."""
    total = 0
    for n in args:
        total += n
    return total

print(ft_sum(1, 2, 3))           # 6
print(ft_sum(1, 2, 3, 4, 5))    # 15
print(ft_sum())                  # 0

# Unpacking a list into *args with *
numbers = [10, 20, 30]
print(ft_sum(*numbers))          # same as ft_sum(10, 20, 30)

# ============================================================================
#  5. **KWARGS — variable keyword arguments
# ============================================================================

print("\n=== **kwargs ===")

def build_profile(**kwargs) -> dict:
    """Accepts any keyword arguments and returns them as a dict."""
    return kwargs

profile = build_profile(name="Miles3103", age=20, rank="S", active=True)
print(profile)

def display_info(title: str, **details) -> None:
    print(f"\n{title}")
    for key, value in details.items():
        print(f"  {key}: {value}")

display_info("User Profile",
    username="Miles3103",
    level=15,
    score=99.5,
    premium=True)

# ============================================================================
#  6. COMBINING ALL PARAMETER TYPES
# ============================================================================

print("\n=== Combined Parameters ===")

def full_example(required: str, *args, keyword_only: bool = False, **kwargs):
    print(f"required:      {required}")
    print(f"args:          {args}")
    print(f"keyword_only:  {keyword_only}")
    print(f"kwargs:        {kwargs}")

full_example("hello", 1, 2, 3, keyword_only=True, extra="data", num=42)

# ============================================================================
#  7. FUNCTIONS AS FIRST-CLASS OBJECTS
# ============================================================================

print("\n=== Functions as Objects ===")

def square(x: float) -> float: return x ** 2
def cube(x: float) -> float:   return x ** 3
def negate(x: float) -> float: return -x

# Store in a list
operations = [square, cube, negate]
n = 3
for op in operations:
    print(f"{op.__name__}({n}) = {op(n)}")

# Pass function as argument (higher-order function)
def apply(func: Callable, value: float) -> float:
    return func(value)

print(apply(square, 5))    # 25
print(apply(abs, -7))      # 7

# ============================================================================
#  8. CLOSURES — function that remembers its enclosing scope
# ============================================================================

print("\n=== Closures ===")

def make_counter(start: int = 0):
    """Returns a counter function that remembers its count."""
    count = [start]  # list so inner function can mutate it
    
    def counter():
        count[0] += 1
        return count[0]
    
    return counter  # return the FUNCTION, not the result

counter_a = make_counter(0)
counter_b = make_counter(10)

print(counter_a())  # 1
print(counter_a())  # 2
print(counter_b())  # 11
print(counter_a())  # 3 — independent from counter_b

def make_multiplier(factor: float):
    """Returns a function that multiplies by factor."""
    def multiply(x: float) -> float:
        return x * factor   # factor is 'closed over'
    return multiply

double  = make_multiplier(2)
triple  = make_multiplier(3)
half    = make_multiplier(0.5)

print(double(10))   # 20
print(triple(10))   # 30
print(half(10))     # 5.0

# ============================================================================
#  9. RECURSION
# ============================================================================

print("\n=== Recursion ===")

def factorial(n: int) -> int:
    """n! = n * (n-1) * ... * 1"""
    if n <= 1:
        return 1
    return n * factorial(n - 1)

def fibonacci(n: int) -> int:
    """Returns nth Fibonacci number."""
    if n <= 0: return 0
    if n == 1: return 1
    return fibonacci(n - 1) + fibonacci(n - 2)

for i in range(8):
    print(f"  factorial({i}) = {factorial(i)}")

print("Fibonacci:", [fibonacci(i) for i in range(10)])

# ============================================================================
#  10. LAMBDA — anonymous one-liner functions
# ============================================================================

print("\n=== Lambda ===")

# lambda args: expression
sq       = lambda x: x ** 2
add_two  = lambda x, y: x + y
is_even  = lambda x: x % 2 == 0

print(sq(5))           # 25
print(add_two(3, 4))   # 7
print(is_even(6))      # True

# Lambdas are great with sorted(), map(), filter()
names = ["Charlie", "Alice", "Bob", "Diana"]
sorted_by_len = sorted(names, key=lambda n: len(n))
print(sorted_by_len)

numbers = [1, 2, 3, 4, 5, 6, 7, 8]
evens   = list(filter(lambda x: x % 2 == 0, numbers))
doubled = list(map(lambda x: x * 2, numbers))
print(f"evens:   {evens}")
print(f"doubled: {doubled}")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("Type hints document intent — use them")
    print("Never use mutable default args — use None instead")
    print("*args collects extra positional args as tuple")
    print("**kwargs collects extra keyword args as dict")
    print("Functions are objects — store, pass, return them")
    print("Closures remember the scope they were created in")
