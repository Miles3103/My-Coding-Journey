#!/usr/bin/env python3
"""
================================================================================
  Project : Modules, Files & Error Handling
  Author  : Miles3103
  Topic   : import, file I/O, try/except/finally, custom exceptions
================================================================================

MODULES:
  A module is just a .py file. Import it with 'import'.
  Python's standard library has 200+ modules for everything.

FILE I/O:
  Python makes file handling easy — always use 'with open()' which
  automatically closes the file even if an error occurs (RAII-like).

ERROR HANDLING:
  Python uses try/except (not try/catch like C++).
  Exception hierarchy is very similar to C++.
  Best practice: catch specific exceptions, not bare 'except:'.
"""

import os
import json
import csv
import pathlib
from typing import Generator

# ============================================================================
#  1. IMPORTING — different ways
# ============================================================================

print("=== Imports ===")

import math                        # import whole module
from math import sqrt, pi, ceil    # import specific names
from math import factorial as fact  # import with alias
import sys as system                # module alias

print(f"math.sqrt(16) = {math.sqrt(16)}")
print(f"sqrt(25) = {sqrt(25)}")          # no 'math.' needed
print(f"pi = {pi:.6f}")
print(f"fact(10) = {fact(10)}")
print(f"Python version: {system.version[:6]}")

# ============================================================================
#  2. USEFUL STANDARD LIBRARY MODULES
# ============================================================================

print("\n=== Standard Library ===")

# os — operating system interface
print(f"Current dir: {os.getcwd()}")
print(f"Home dir:    {os.path.expanduser('~')}")
print(f"Path exists: {os.path.exists('/tmp')}")

# pathlib — modern path handling (prefer over os.path)
p = pathlib.Path("/tmp")
print(f"Is dir: {p.is_dir()}")
print(f"Parts:  {p.parts}")

# datetime
from datetime import datetime, date, timedelta
now   = datetime.now()
today = date.today()
print(f"\nNow:   {now.strftime('%Y-%m-%d %H:%M:%S')}")
print(f"Today: {today}")
print(f"In 7 days: {today + timedelta(days=7)}")

# random
import random
print(f"\nrandom int 1-10:  {random.randint(1, 10)}")
print(f"random choice:    {random.choice(['rock', 'paper', 'scissors'])}")
nums = list(range(10))
random.shuffle(nums)
print(f"shuffled 0-9:     {nums}")

# collections
from collections import Counter, defaultdict, deque, OrderedDict
words = "the quick brown fox jumps over the lazy dog".split()
freq  = Counter(words)
print(f"\nmost common: {freq.most_common(3)}")

# itertools
import itertools
pairs = list(itertools.combinations([1, 2, 3, 4], 2))
print(f"combinations: {pairs}")

# ============================================================================
#  3. FILE I/O — always use 'with open()'
# ============================================================================

print("\n=== File I/O ===")

filepath = "/tmp/miles3103_test.txt"

# WRITE
with open(filepath, "w", encoding="utf-8") as f:
    f.write("Line 1: Hello, Miles3103!\n")
    f.write("Line 2: Python file I/O\n")
    f.write("Line 3: Always use 'with open()'\n")
    print(f"Written to {filepath}")

# READ all at once
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()
print(f"Full content:\n{content}")

# READ line by line (memory efficient for large files)
print("Line by line:")
with open(filepath, "r", encoding="utf-8") as f:
    for i, line in enumerate(f, 1):
        print(f"  [{i}] {line.rstrip()}")

# READ all lines into list
with open(filepath, "r") as f:
    lines = f.readlines()
print(f"Lines list: {[l.strip() for l in lines]}")

# APPEND
with open(filepath, "a") as f:
    f.write("Line 4: Appended!\n")

# ============================================================================
#  4. JSON — the most common data format
# ============================================================================

print("\n=== JSON ===")

json_path = "/tmp/miles3103_data.json"

data = {
    "name": "Miles3103",
    "level": 15,
    "score": 9850.5,
    "languages": ["C", "C++", "Python"],
    "active": True,
    "stats": {"strength": 80, "speed": 95}
}

# Write JSON
with open(json_path, "w") as f:
    json.dump(data, f, indent=2)   # indent for pretty printing
print(f"JSON written to {json_path}")

# Read JSON
with open(json_path, "r") as f:
    loaded = json.load(f)

print(f"Name: {loaded['name']}")
print(f"Languages: {loaded['languages']}")
print(f"Speed: {loaded['stats']['speed']}")

# Convert to/from string
json_str = json.dumps(data, indent=2)
parsed   = json.loads(json_str)
print(f"From string: {parsed['level']}")

# ============================================================================
#  5. CSV
# ============================================================================

print("\n=== CSV ===")

csv_path = "/tmp/miles3103_scores.csv"

# Write CSV
rows = [
    ["Name", "Score", "Grade"],
    ["Alice", 95, "A"],
    ["Bob", 82, "B"],
    ["Miles3103", 88, "B"],
    ["Charlie", 71, "C"],
]
with open(csv_path, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(rows)

# Read CSV
with open(csv_path, "r") as f:
    reader = csv.DictReader(f)   # each row is a dict
    for row in reader:
        print(f"  {row['Name']}: {row['Score']} ({row['Grade']})")

# ============================================================================
#  6. ERROR HANDLING — try/except/else/finally
# ============================================================================

print("\n=== Error Handling ===")

# Basic try/except
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Caught: {e}")

# Multiple except clauses
def safe_parse(value: str) -> float:
    try:
        return float(value)
    except ValueError:
        print(f"  Cannot convert '{value}' to float")
        return 0.0
    except TypeError:
        print(f"  Expected string, got {type(value).__name__}")
        return 0.0

print(safe_parse("3.14"))
print(safe_parse("abc"))
print(safe_parse(None))

# else — runs if NO exception was raised
# finally — runs ALWAYS (like destructor)
def read_file_safe(path: str) -> str | None:
    try:
        with open(path, "r") as f:
            content = f.read()
    except FileNotFoundError:
        print(f"  File not found: {path}")
        return None
    except PermissionError:
        print(f"  Permission denied: {path}")
        return None
    else:
        print(f"  Successfully read {len(content)} chars")
        return content
    finally:
        print(f"  (finally block always runs)")

read_file_safe(filepath)
read_file_safe("/nonexistent/path.txt")

# ============================================================================
#  7. CUSTOM EXCEPTIONS
# ============================================================================

print("\n=== Custom Exceptions ===")

class MilesError(Exception):
    """Base exception for Miles3103's code."""
    def __init__(self, message: str, code: int = 0):
        super().__init__(message)
        self.code = code

class ValidationError(MilesError):
    pass

class DatabaseError(MilesError):
    pass

def validate_score(score: float) -> float:
    if not isinstance(score, (int, float)):
        raise ValidationError(f"Score must be a number, got {type(score).__name__}", code=400)
    if score < 0 or score > 100:
        raise ValidationError(f"Score {score} out of range [0, 100]", code=422)
    return float(score)

for test in [85, 110, -5, "abc"]:
    try:
        validated = validate_score(test)
        print(f"  Valid score: {validated}")
    except ValidationError as e:
        print(f"  ValidationError [code={e.code}]: {e}")
    except Exception as e:
        print(f"  Unexpected: {e}")

# Cleanup temp files
os.remove(filepath)
os.remove(json_path)
os.remove(csv_path)
print("\nTemp files cleaned up.")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("Always use 'with open()' — closes file automatically")
    print("json.dump/load for writing/reading JSON")
    print("csv.DictReader gives each row as a dictionary")
    print("Catch specific exceptions, not bare 'except:'")
    print("'else' runs on success, 'finally' always runs")
    print("Custom exceptions should inherit from Exception or a subclass")
