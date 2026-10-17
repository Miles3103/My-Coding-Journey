#!/usr/bin/env python3
"""
================================================================================
  Project : Comprehensions & Generators
  Author  : Miles3103
  Topic   : List/dict/set comprehensions, generator expressions, yield
================================================================================

COMPREHENSIONS — the most "Pythonic" feature:
  [expr for item in iterable if condition]
  One line replaces a 4-line for loop. Faster and more readable.

GENERATORS — lazy evaluation:
  Instead of creating a full list in memory, a generator produces
  values ONE AT A TIME as they are needed.
  - Saves memory for large datasets
  - Can represent infinite sequences
  - Use () instead of [] for generator expressions
  - Use 'yield' instead of 'return' in generator functions
"""

import sys

# ============================================================================
#  1. LIST COMPREHENSIONS
# ============================================================================

print("=== List Comprehensions ===")

# Basic: [expression for item in iterable]
squares = [x**2 for x in range(10)]
print(f"squares:    {squares}")

# With filter: [expression for item in iterable if condition]
even_sq = [x**2 for x in range(10) if x % 2 == 0]
print(f"even sq:    {even_sq}")

# Equivalent for loop (much more verbose):
# result = []
# for x in range(10):
#     if x % 2 == 0:
#         result.append(x**2)

# Nested — flatten a 2D matrix
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat   = [n for row in matrix for n in row]
print(f"flat:       {flat}")

# String operations
words  = ["hello", "WORLD", "Python", "Miles3103"]
lower  = [w.lower() for w in words]
upper  = [w.upper() for w in words]
lens   = [len(w) for w in words]
print(f"lower:      {lower}")
print(f"lengths:    {lens}")

# With multiple conditions
nums = [x for x in range(50) if x % 3 == 0 if x % 5 == 0]
print(f"mult of 3&5: {nums}")

# Conditional expression (if/else) in comprehension
labels = ["even" if x % 2 == 0 else "odd" for x in range(8)]
print(f"labels:     {labels}")

# ============================================================================
#  2. DICT COMPREHENSIONS
# ============================================================================

print("\n=== Dict Comprehensions ===")

# {key: value for item in iterable}
squares_dict = {x: x**2 for x in range(6)}
print(f"squares:    {squares_dict}")

# From two lists (zip)
keys   = ["name", "age", "level"]
values = ["Miles3103", 20, 15]
person = {k: v for k, v in zip(keys, values)}
print(f"person:     {person}")

# Invert a dict (swap keys and values)
original = {"a": 1, "b": 2, "c": 3}
inverted = {v: k for k, v in original.items()}
print(f"inverted:   {inverted}")

# Filter dict — keep only entries where value > 5
scores = {"Alice": 95, "Bob": 45, "Charlie": 78, "Diana": 32}
passing = {name: score for name, score in scores.items() if score >= 60}
print(f"passing:    {passing}")

# ============================================================================
#  3. SET COMPREHENSIONS
# ============================================================================

print("\n=== Set Comprehensions ===")

# {expression for item in iterable}  — automatically removes duplicates
numbers = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
unique_squares = {x**2 for x in numbers}
print(f"unique sq:  {unique_squares}")

# Unique first letters
names  = ["Alice", "Bob", "Anna", "Charlie", "Beth"]
firsts = {name[0] for name in names}
print(f"first letters: {sorted(firsts)}")

# ============================================================================
#  4. GENERATOR EXPRESSIONS — lazy list comprehension
# ============================================================================

print("\n=== Generator Expressions ===")

# List comprehension: creates ALL values in memory immediately
list_sq = [x**2 for x in range(1000000)]
gen_sq  = (x**2 for x in range(1000000))  # () not []

print(f"list size: {sys.getsizeof(list_sq):,} bytes")
print(f"gen size:  {sys.getsizeof(gen_sq):,} bytes")   # tiny!

# Generator produces values one at a time
gen = (x**2 for x in range(5))
print(next(gen))   # 0
print(next(gen))   # 1
print(next(gen))   # 4
# ... use for x in gen to consume the rest

# Generators work with sum, max, min, list, etc.
total = sum(x**2 for x in range(100))   # no [] needed inside sum()
print(f"sum of squares 0-99: {total}")

# ============================================================================
#  5. GENERATOR FUNCTIONS — using yield
# ============================================================================

print("\n=== Generator Functions ===")

def count_up(start: int, stop: int, step: int = 1):
    """Generator that yields numbers from start to stop."""
    current = start
    while current <= stop:
        yield current       # pause here, return value, resume next call
        current += step

# Usage — like range() but we built it
for n in count_up(1, 10, 2):
    print(n, end=" ")
print()

def fibonacci():
    """Infinite Fibonacci generator — never ends!"""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Take only first 15 Fibonacci numbers from infinite stream
fib = fibonacci()
first_15 = [next(fib) for _ in range(15)]
print(f"Fibonacci: {first_15}")

def read_large_file(filename: str):
    """Generator — reads file line by line without loading all into memory."""
    try:
        with open(filename) as f:
            for line in f:
                yield line.strip()
    except FileNotFoundError:
        yield "(file not found — in real use this would process GB of data)"

# Simulate processing a large file
for line in read_large_file("/etc/hostname"):
    print(f"Line: {line}")

# ============================================================================
#  6. yield from — delegating to another generator
# ============================================================================

print("\n=== yield from ===")

def chain(*iterables):
    """Yield all items from each iterable in sequence."""
    for it in iterables:
        yield from it

result = list(chain([1, 2], [3, 4], [5, 6]))
print(f"chain: {result}")

def flatten(nested):
    """Recursively flatten nested lists."""
    for item in nested:
        if isinstance(item, list):
            yield from flatten(item)
        else:
            yield item

deep = [1, [2, [3, [4, [5]]]]]
print(f"flatten: {list(flatten(deep))}")

# ============================================================================
#  7. PRACTICAL EXAMPLES
# ============================================================================

print("\n=== Practical Examples ===")

# Find all prime numbers up to N using sieve (comprehension style)
def sieve(n: int) -> list[int]:
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    for i in range(2, int(n**0.5) + 1):
        if is_prime[i]:
            for j in range(i*i, n+1, i):
                is_prime[j] = False
    return [i for i, prime in enumerate(is_prime) if prime]

primes = sieve(50)
print(f"primes ≤50: {primes}")

# Data pipeline using generators (memory efficient)
def read_data():
    """Simulated data source."""
    data = [" Alice,95 ", " Bob,45 ", " Charlie,78 ", " Diana,32 ", " Eve,88 "]
    for line in data:
        yield line

def parse(lines):
    for line in lines:
        name, score = line.strip().split(",")
        yield name.strip(), int(score)

def filter_passing(records, threshold=60):
    for name, score in records:
        if score >= threshold:
            yield name, score

def format_output(records):
    for name, score in records:
        yield f"  {name}: {score}"

# Chain the pipeline — data flows lazily through each stage
pipeline = format_output(filter_passing(parse(read_data())))
print("Passing students:")
for line in pipeline:
    print(line)


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("[x for x in it]     → list comprehension")
    print("{k:v for k,v in it} → dict comprehension")
    print("{x for x in it}     → set comprehension")
    print("(x for x in it)     → generator expression (lazy!)")
    print("yield                → turns a function into a generator")
    print("Generators save memory — prefer over lists for large data")
