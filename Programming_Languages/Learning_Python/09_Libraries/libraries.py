#!/usr/bin/env python3
"""
================================================================================
  Project : Python Libraries & Ecosystem
  Author  : Miles3103
  Topic   : Standard library deep dive + popular third-party packages
================================================================================

THE PYTHON ECOSYSTEM:
  Python's superpower is its ecosystem of packages.
  Install anything with: pip install package_name

  STANDARD LIBRARY (no install needed):
    os, sys, pathlib    → file system, OS interaction
    json, csv           → data formats
    re                  → regular expressions
    datetime            → dates and times
    argparse            → command-line arguments
    logging             → proper logging
    unittest            → testing
    threading, asyncio  → concurrency
    http.server         → simple web server
    sqlite3             → built-in database

  POPULAR THIRD-PARTY:
    requests    → HTTP requests (pip install requests)
    numpy       → numerical computing (pip install numpy)
    pandas      → data analysis (pip install pandas)
    matplotlib  → plotting (pip install matplotlib)
    flask       → web framework (pip install flask)
    fastapi     → modern web API (pip install fastapi)
    pytest      → testing (pip install pytest)
    pydantic    → data validation (pip install pydantic)

This file covers the standard library ones (always available).
"""

import os
import sys
import re
import logging
import argparse
import sqlite3
import hashlib
import secrets
import threading
import time
from pathlib import Path
from datetime import datetime

# ============================================================================
#  1. REGULAR EXPRESSIONS — pattern matching
# ============================================================================

print("=== Regular Expressions (re) ===")

# re.search — find first match anywhere in string
text = "Miles3103 scored 95.5 on 2026-02-20 at exam@42.fr"

# Find email
email = re.search(r'[\w.]+@[\w.]+\.\w+', text)
if email:
    print(f"Email found: {email.group()}")

# Find date
date  = re.search(r'\d{4}-\d{2}-\d{2}', text)
if date:
    print(f"Date found: {date.group()}")

# re.findall — find ALL matches
numbers = re.findall(r'\d+\.?\d*', text)
print(f"All numbers: {numbers}")

# re.sub — replace matches
clean = re.sub(r'\d+', 'X', "Phone: 0612345678, Code: 42")
print(f"Redacted: {clean}")

# re.split
parts = re.split(r'[,\s]+', "one, two,   three,four")
print(f"Split: {parts}")

# Groups — capture parts of the match
pattern = r'(\d{4})-(\d{2})-(\d{2})'
match = re.search(pattern, text)
if match:
    year, month, day = match.groups()
    print(f"Year={year}, Month={month}, Day={day}")

# Compile pattern for repeated use (faster)
email_re = re.compile(r'[\w.]+@[\w.]+\.\w+')
emails = email_re.findall("a@b.com, c@d.org, invalid, e@f.io")
print(f"All emails: {emails}")

# ============================================================================
#  2. LOGGING — proper logging (not print for production)
# ============================================================================

print("\n=== Logging ===")

# Configure once at the start of your program
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s | %(levelname)-8s | %(name)s | %(message)s',
    datefmt='%H:%M:%S'
)

logger = logging.getLogger("miles3103")

logger.debug("Debug: detailed diagnostic info")
logger.info("Info: confirmation things work as expected")
logger.warning("Warning: something unexpected but not critical")
logger.error("Error: something failed but program continues")
# logger.critical("Critical: program cannot continue")

# Log to file
file_handler = logging.FileHandler("/tmp/app.log")
file_handler.setLevel(logging.WARNING)
logger.addHandler(file_handler)
logger.warning("This also goes to the file")

# ============================================================================
#  3. ARGPARSE — command-line arguments
# ============================================================================

print("\n=== argparse (simulated) ===")

parser = argparse.ArgumentParser(
    description="Miles3103's awesome CLI tool",
    formatter_class=argparse.RawDescriptionHelpFormatter
)

parser.add_argument("filename",         nargs="?", default="input.txt",
                    help="Input file to process")
parser.add_argument("-o", "--output",   default="output.txt",
                    help="Output file")
parser.add_argument("-n", "--count",    type=int, default=10,
                    help="Number of items to process")
parser.add_argument("-v", "--verbose",  action="store_true",
                    help="Enable verbose output")
parser.add_argument("--format",         choices=["json", "csv", "txt"],
                    default="txt", help="Output format")

# Simulate: python script.py data.txt -o result.json -n 5 -v --format json
args = parser.parse_args(["data.txt", "-o", "result.json", "-n", "5",
                           "-v", "--format", "json"])
print(f"filename: {args.filename}")
print(f"output:   {args.output}")
print(f"count:    {args.count}")
print(f"verbose:  {args.verbose}")
print(f"format:   {args.format}")

# ============================================================================
#  4. SQLITE3 — built-in database
# ============================================================================

print("\n=== SQLite3 ===")

# In-memory database (":memory:") for demo
conn = sqlite3.connect(":memory:")
conn.row_factory = sqlite3.Row  # rows behave like dicts
cur  = conn.cursor()

# Create table
cur.execute("""
    CREATE TABLE players (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        name    TEXT NOT NULL,
        level   INTEGER DEFAULT 1,
        score   REAL DEFAULT 0.0,
        created TEXT
    )
""")

# Insert rows — ALWAYS use parameterized queries (prevents SQL injection!)
players = [
    ("Miles3103", 15, 9850.5),
    ("Alice",     10, 7200.0),
    ("Bob",        8, 5100.0),
    ("Charlie",   20, 15000.0),
]
cur.executemany(
    "INSERT INTO players (name, level, score, created) VALUES (?, ?, ?, ?)",
    [(n, l, s, datetime.now().isoformat()) for n, l, s in players]
)
conn.commit()

# Query
print("All players (sorted by score):")
for row in cur.execute("SELECT * FROM players ORDER BY score DESC"):
    print(f"  #{row['id']} {row['name']:12} level={row['level']:3} score={row['score']:8.1f}")

# Parameterized query
min_level = 10
print(f"\nPlayers at level >= {min_level}:")
for row in cur.execute("SELECT name, level FROM players WHERE level >= ?", (min_level,)):
    print(f"  {row['name']} (lvl {row['level']})")

# Aggregate functions
row = cur.execute("SELECT COUNT(*), AVG(score), MAX(level) FROM players").fetchone()
print(f"\nTotal: {row[0]}, Avg score: {row[1]:.1f}, Max level: {row[2]}")

conn.close()

# ============================================================================
#  5. HASHLIB & SECRETS — cryptography basics
# ============================================================================

print("\n=== Hashlib & Secrets ===")

# Hash a password (in real apps: use bcrypt or argon2, not sha256)
password = "MySecretPassword123"
hashed   = hashlib.sha256(password.encode()).hexdigest()
print(f"SHA256: {hashed[:32]}...")

# Generate secure random tokens
token = secrets.token_hex(32)       # 64-char hex string
url   = secrets.token_urlsafe(16)   # URL-safe base64
pin   = secrets.randbelow(10000)    # random int in [0, 10000)
print(f"Token: {token[:16]}...")
print(f"URL:   {url}")
print(f"PIN:   {pin:04d}")

# ============================================================================
#  6. THREADING — concurrent execution
# ============================================================================

print("\n=== Threading (basic) ===")

def worker(name: str, duration: float) -> None:
    print(f"  [{name}] starting")
    time.sleep(duration)
    print(f"  [{name}] done after {duration}s")

# Create and start threads
threads = [
    threading.Thread(target=worker, args=("Task-A", 0.05)),
    threading.Thread(target=worker, args=("Task-B", 0.03)),
    threading.Thread(target=worker, args=("Task-C", 0.04)),
]

start = time.perf_counter()
for t in threads:
    t.start()
for t in threads:
    t.join()   # wait for all to finish
elapsed = time.perf_counter() - start

print(f"  All done in {elapsed*1000:.0f}ms (would be ~120ms sequential)")

# ============================================================================
#  7. PATHLIB — modern path handling
# ============================================================================

print("\n=== pathlib ===")

# Create paths with / operator (much cleaner than os.path.join)
base    = Path("/tmp")
logfile = base / "miles3103" / "app.log"
print(f"Path:    {logfile}")
print(f"Parent:  {logfile.parent}")
print(f"Name:    {logfile.name}")
print(f"Stem:    {logfile.stem}")
print(f"Suffix:  {logfile.suffix}")

# Find files
py_files = list(Path(".").glob("*.py"))
print(f"\n.py files in current dir: {len(py_files)}")

# Create directory tree
(base / "test_dir" / "subdir").mkdir(parents=True, exist_ok=True)
(base / "test_dir" / "hello.txt").write_text("Hello from pathlib!")
content = (base / "test_dir" / "hello.txt").read_text()
print(f"Read back: {content}")

# Cleanup
import shutil
shutil.rmtree(base / "test_dir")
Path("/tmp/app.log").unlink(missing_ok=True)
print("Cleanup done.")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("re module: search, findall, sub, compile for pattern matching")
    print("logging > print for production code")
    print("argparse makes professional CLI tools in minutes")
    print("sqlite3 is built-in — use parameterized queries always")
    print("secrets module for cryptographically secure randomness")
    print("pathlib > os.path — cleaner, more readable path handling")
