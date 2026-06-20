# 42 Piscine: Shell 01 - Exercise 01 (Only the best know how to display Z)

An educational guide explaining how to create a file that outputs a specific string followed by a newline character when read.

## 📋 The Assignment

The goal is to create a single file named `z` inside the `ex01/` directory. When a user runs the `cat` command on this file, it must display the letter `Z` followed immediately by a newline.

```bash
%> cat z
Z
%>
```

---

## 🛠️ Step-by-Step Implementation

Unlike the previous exercise where we avoided newlines, this assignment **requires** a trailing newline character. There are two standard ways to achieve this in the terminal.

### Method 1: Using `echo` (Recommended)
By default, the `echo` command automatically appends a newline character to the end of whatever text you output. This makes it perfect for this exercise.

Run this command inside your `ex01/` directory:
```bash
echo "Z" > z
```

### Method 2: Using `printf`
If you prefer explicit formatting, you can use `printf` and manually add the newline escape sequence (`\n`).

Run this command inside your `ex01/` directory:
```bash
printf "Z\n" > z
```

---

## 🔍 Verification

To ensure your file is formatted perfectly before submitting, you can run two tests:

1. **Standard Verification**: Run `cat z`. You should see `Z` and your terminal prompt should start on the very next line.
   ```bash
   cat z
   ```

2. **Hidden Character Verification**: Run `cat -e z`. The `-e` flag forces the terminal to show hidden newline characters as a `$` symbol.
   ```bash
   cat -e z
   ```
   **Expected Output:**
   ```bash
   Z\$
   ```
   *(If you see `Z` without a `$`, or if you see `%`, your file is missing the required newline).*

---

## 📦 Submission

Ensure that the file `z` is the only required file sitting cleanly inside your `ex01/` directory, then commit and push to your repository.

