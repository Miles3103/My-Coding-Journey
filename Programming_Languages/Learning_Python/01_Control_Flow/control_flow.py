#!/usr/bin/env python3
"""
================================================================================
  Project : Control Flow
  Author  : Miles3103
  Topic   : if/elif/else, while, for, break, continue, match (3.10+)
================================================================================

KEY DIFFERENCES FROM C:
  - No parentheses needed:   if x > 5:   (not if (x > 5))
  - Colon at end:            if x > 5:
  - Indentation is the body: (no curly braces)
  - 'elif' not 'else if'
  - 'for' loops over iterables, not just counts
  - 'range()' for numeric loops
  - 'match' statement (like switch) added in Python 3.10
  - No do-while loop (use while True + break instead)
"""

# ============================================================================
#  1. IF / ELIF / ELSE
# ============================================================================

print("=== if/elif/else ===")

score = 87

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"Score {score} → Grade {grade}")

# One-liner if (ternary equivalent)
status = "passing" if score >= 60 else "failing"
print(f"Status: {status}")

# Truthy/falsy — Python's powerful shortcut
name = ""
display = name if name else "Anonymous"  # if name is not empty
print(f"Display name: {display}")

# ============================================================================
#  2. WHILE LOOP
# ============================================================================

print("\n=== while loop ===")

# Basic while
i = 1
while i <= 5:
    print(f"  count: {i}")
    i += 1

# while with else — runs if loop ended normally (not via break)
print("\nwhile with else:")
n = 10
while n > 0:
    n -= 3
else:
    print(f"  loop done, n={n}")

# do-while equivalent (Python has no do-while)
print("\ndo-while equivalent:")
inputs = [5, -1, 3, 0, 7]  # simulated input
idx = 0
while True:
    val = inputs[idx]; idx += 1
    print(f"  processing: {val}")
    if val <= 0:
        break

# ============================================================================
#  3. FOR LOOP — iterates over ANY iterable
# ============================================================================

print("\n=== for loop ===")

# Over a list
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(f"  {fruit}")

# Over a string (char by char)
for char in "Miles":
    print(char, end=" ")
print()

# range(stop) — 0 to stop-1
print("\nrange(5):")
for i in range(5):
    print(i, end=" ")
print()

# range(start, stop)
print("range(2, 8):")
for i in range(2, 8):
    print(i, end=" ")
print()

# range(start, stop, step)
print("range(0, 20, 3):")
for i in range(0, 20, 3):
    print(i, end=" ")
print()

# Counting backwards
print("countdown:")
for i in range(5, 0, -1):
    print(i, end=" ")
print("GO!")

# ============================================================================
#  4. ENUMERATE — index + value together
# ============================================================================

print("\n=== enumerate ===")

languages = ["C", "C++", "Python", "Rust"]
for i, lang in enumerate(languages):
    print(f"  [{i}] {lang}")

# Start from 1
for i, lang in enumerate(languages, start=1):
    print(f"  {i}. {lang}")

# ============================================================================
#  5. ZIP — iterate multiple lists together
# ============================================================================

print("\n=== zip ===")

names  = ["Alice", "Bob", "Charlie"]
scores = [95, 82, 78]
grades = ["A", "B", "C"]

for name, score, grade in zip(names, scores, grades):
    print(f"  {name}: {score} ({grade})")

# ============================================================================
#  6. BREAK AND CONTINUE
# ============================================================================

print("\n=== break and continue ===")

# break — exit loop
print("break at 5:")
for i in range(10):
    if i == 5:
        print(f"  breaking at {i}")
        break
    print(f"  {i}", end=" ")
print()

# continue — skip current iteration
print("skip evens:")
for i in range(10):
    if i % 2 == 0:
        continue
    print(i, end=" ")
print()

# for/else — else runs if loop completed without break (unique to Python!)
print("\nfor/else (search with break):")
numbers = [3, 7, 11, 15, 2, 9]
target = 15
for num in numbers:
    if num == target:
        print(f"  Found {target}!")
        break
else:
    print(f"  {target} not found")

# ============================================================================
#  7. NESTED LOOPS
# ============================================================================

print("\n=== nested loops ===")

# Multiplication table 3x3
for i in range(1, 4):
    for j in range(1, 4):
        print(f"{i*j:3}", end="")
    print()

# Triangle pattern
for i in range(1, 6):
    print("* " * i)

# ============================================================================
#  8. MATCH STATEMENT (Python 3.10+) — like switch in C
# ============================================================================

print("\n=== match statement ===")

def classify_input(command):
    match command:
        case "quit" | "exit" | "q":
            return "Exiting program"
        case "help" | "h" | "?":
            return "Showing help"
        case "start":
            return "Starting..."
        case str(x) if x.startswith("go "):
            return f"Going to: {x[3:]}"
        case _:
            return f"Unknown command: {command}"

for cmd in ["quit", "help", "go north", "fly", "start"]:
    print(f"  '{cmd}' → {classify_input(cmd)}")

# Match with structured patterns
print("\nmatch with types:")
def describe(value):
    match value:
        case int(n) if n < 0:
            return f"negative int: {n}"
        case int(n):
            return f"positive int: {n}"
        case str(s):
            return f"string of length {len(s)}"
        case [*items]:
            return f"list with {len(items)} items"
        case _:
            return "something else"

for v in [-5, 42, "hello", [1, 2, 3], 3.14]:
    print(f"  {repr(v):15} → {describe(v)}")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("for loops iterate over ANYTHING (list, str, range, dict...)")
    print("enumerate() gives you index + value")
    print("zip() walks multiple lists at the same time")
    print("for/else runs if loop didn't break — unique Python feature")
    print("match statement is Python's switch (3.10+)")
