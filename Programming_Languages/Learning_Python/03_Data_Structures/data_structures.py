#!/usr/bin/env python3
"""
================================================================================
  Project : Data Structures
  Author  : Miles3103
  Topic   : list, tuple, dict, set — the 4 core Python containers
================================================================================

THE 4 BUILT-IN CONTAINERS:

  list   [1, 2, 3]       → ordered, mutable, allows duplicates
  tuple  (1, 2, 3)       → ordered, IMMUTABLE, allows duplicates
  dict   {"a": 1}        → key-value pairs, ordered (3.7+), mutable
  set    {1, 2, 3}       → unordered, mutable, NO duplicates

CHOOSING THE RIGHT ONE:
  - Need to change values?              → list
  - Values should never change?         → tuple (safer, faster)
  - Need to look up by key?             → dict
  - Need uniqueness / set math?         → set
"""

# ============================================================================
#  1. LIST — the workhorse of Python
# ============================================================================

print("=== LIST ===")

# Create
nums    = [3, 1, 4, 1, 5, 9, 2, 6]
mixed   = [42, "hello", True, 3.14, None]   # can hold any type
empty   = []
matrix  = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Access
print(nums[0])      # first: 3
print(nums[-1])     # last:  6
print(nums[-2])     # second to last: 2

# Slicing [start:stop:step] — EXCLUSIVE of stop
print(nums[2:5])    # [4, 1, 5]
print(nums[:3])     # [3, 1, 4]
print(nums[5:])     # [9, 2, 6]
print(nums[::2])    # every other: [3, 4, 5, 2]
print(nums[::-1])   # reversed: [6, 2, 9, 5, 1, 4, 1, 3]

# Modify
nums[0] = 99
nums.append(10)         # add to end
nums.insert(2, 77)      # insert at index 2
nums.extend([20, 30])   # add multiple items
removed = nums.pop()    # remove and return last
nums.remove(1)          # remove first occurrence of value
del nums[0]             # delete by index

# Info
print(f"length:  {len(nums)}")
print(f"sum:     {sum(nums)}")
print(f"min:     {min(nums)}")
print(f"max:     {max(nums)}")
print(f"count 1: {nums.count(1)}")
print(f"index 5: {nums.index(5)}")

# Sort
nums.sort()                         # in-place, ascending
nums.sort(reverse=True)             # in-place, descending
sorted_copy = sorted(nums)          # returns new list, original unchanged

# Copy — CRITICAL: avoid aliasing bugs
a = [1, 2, 3]
b = a           # b IS a — changing b changes a!
c = a.copy()    # shallow copy — safe for flat lists
d = a[:]        # also a shallow copy
print(f"b is a: {b is a}")   # True  — same object
print(f"c is a: {c is a}")   # False — independent copy

# 2D matrix access
print(f"\nMatrix[1][2] = {matrix[1][2]}")  # row 1, col 2 → 6
for row in matrix:
    print(row)

# ============================================================================
#  2. TUPLE — immutable list
# ============================================================================

print("\n=== TUPLE ===")

point   = (3, 7)
rgb     = (255, 128, 0)
single  = (42,)         # note the comma — (42) is just 42!
empty   = ()

# Unpack
x, y = point
r, g, b = rgb
print(f"x={x}, y={y}")
print(f"r={r}, g={g}, b={b}")

# Extended unpacking
first, *rest = (1, 2, 3, 4, 5)
*head, last  = (1, 2, 3, 4, 5)
a, *mid, z   = (1, 2, 3, 4, 5)
print(f"first={first}, rest={rest}")
print(f"head={head}, last={last}")
print(f"a={a}, mid={mid}, z={z}")

# Tuples as dict keys (lists can't be keys — must be hashable)
coords = {(0, 0): "origin", (1, 0): "east", (0, 1): "north"}
print(coords[(0, 0)])

# Named tuple — gives fields names
from collections import namedtuple
Point = namedtuple("Point", ["x", "y"])
p = Point(3, 7)
print(f"p.x={p.x}, p.y={p.y}")

# ============================================================================
#  3. DICT — key-value store
# ============================================================================

print("\n=== DICT ===")

# Create
person = {"name": "Miles3103", "age": 20, "level": 15}
empty  = {}
from_keys = dict.fromkeys(["a", "b", "c"], 0)   # {a:0, b:0, c:0}

# Access
print(person["name"])               # KeyError if missing
print(person.get("age"))            # None if missing (safe)
print(person.get("score", 0))       # default value if missing

# Modify
person["score"] = 99.5              # add new key
person["age"] = 21                  # update existing
person.update({"rank": "S", "active": True})  # update multiple
deleted = person.pop("active")      # remove and return
person.setdefault("country", "PL")  # set only if key doesn't exist

# Iterate
print("\nKeys:", list(person.keys()))
print("Values:", list(person.values()))
print("Items:", list(person.items()))

for key, value in person.items():
    print(f"  {key}: {value}")

# Check membership (checks keys)
print("name" in person)     # True
print("email" in person)    # False

# Merge dicts (Python 3.9+)
defaults = {"color": "blue", "size": 10}
overrides = {"size": 20, "weight": 5}
merged = defaults | overrides       # {color:blue, size:20, weight:5}
print(merged)

# Dict comprehension
squares = {n: n**2 for n in range(1, 6)}
print(squares)   # {1:1, 2:4, 3:9, 4:16, 5:25}

# Count frequency — classic pattern
words = ["the", "cat", "sat", "on", "the", "mat", "the", "cat"]
freq = {}
for word in words:
    freq[word] = freq.get(word, 0) + 1
print(freq)

# Better with defaultdict
from collections import defaultdict, Counter
freq2 = defaultdict(int)
for word in words:
    freq2[word] += 1
print(dict(freq2))

# Even better with Counter
freq3 = Counter(words)
print(freq3.most_common(3))   # top 3 most common

# ============================================================================
#  4. SET — unique elements, set math
# ============================================================================

print("\n=== SET ===")

# Create
s1 = {1, 2, 3, 4, 5}
s2 = {3, 4, 5, 6, 7}
s3 = set([1, 2, 2, 3, 3, 3])  # duplicates removed → {1, 2, 3}
empty_set = set()               # NOT {} — that's an empty dict!

print(f"s1: {s1}")
print(f"s2: {s2}")
print(f"s3 (from list with dupes): {s3}")

# Set operations — mathematical set theory
print(f"\nUnion (s1 | s2):        {s1 | s2}")
print(f"Intersection (s1 & s2): {s1 & s2}")
print(f"Difference (s1 - s2):   {s1 - s2}")
print(f"Symmetric diff (s1^s2): {s1 ^ s2}")

# Membership — O(1) lookup (much faster than list for large data)
print(f"\n3 in s1: {3 in s1}")
print(f"9 in s1: {9 in s1}")

# Modify
s1.add(6)
s1.discard(1)       # removes if present, no error if not
s1.remove(2)        # removes, raises KeyError if not present

# Subset / superset
a = {1, 2, 3}
b = {1, 2, 3, 4, 5}
print(f"\na ⊆ b: {a.issubset(b)}")    # True
print(f"b ⊇ a: {b.issuperset(a)}")  # True
print(f"a ∩ b == ∅: {a.isdisjoint({6, 7})}")  # True

# Classic use: remove duplicates from list
dupes = [1, 3, 2, 1, 4, 3, 2, 5]
unique = list(set(dupes))
print(f"\nRemove dupes: {sorted(unique)}")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("list   → ordered, mutable, general purpose")
    print("tuple  → ordered, immutable, use for fixed data / dict keys")
    print("dict   → fast key lookup, use .get() to avoid KeyError")
    print("set    → unique values, O(1) lookup, set math operations")
    print("Counter → best way to count frequencies")
    print("Never do b = a for lists/dicts — use .copy() instead!")
