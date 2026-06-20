# 42 Piscine: Shell 01 - Exercise 00 (Oh yeah, mooore...)

A comprehensive guide explaining how to replicate specific file types, permissions, hard/soft links, and modification timestamps to match the required `ls -l` output.

## 📋 The Assignment

The goal is to create a set of files and directories within the `ex00/` directory that perfectly matches the following `ls -l` output scheme:

```bash
%> ls -l
total XX
drwx--xr-x 2 XX XX XX Jun 1 20:47 test0
-rwx--xr-- 1 XX XX 4 Jun 1 21:46 test1
dr-x---r-- 2 XX XX XX Jun 1 22:45 test2
-r-----r-- 2 XX XX 1 Jun 1 23:44 test3
-rw-r----x 1 XX XX 2 Jun 1 23:43 test4
-r-----r-- 2 XX XX 1 Jun 1 23:44 test5
lrwxrwxrwx 1 XX XX 5 Jun 1 22:20 test6 -> test0
%>
```

---

## 🛠️ Step-by-Step Implementation

### Step 1: Create the Base Files & Folders
We must initialize the files with exact byte sizes (matching the number before the date) and create the required directories.

* **`test0` and `test2`**: Created as directories (`mkdir`).
* **`test1`, `test3`, `test4`**: Created using `echo -n` to write exact string character counts without an automatic newline character.

```bash
mkdir test0 test2
echo -n "1234" > test1
echo -n "1" > test3
echo -n "12" > test4
```

### Step 2: Establish the Links
* **`test5` (Hard Link)**: Notice `test3` and `test5` share an identical size, timestamp, and show a link count of `2`. They point to the same hard data block.
* **`test6` (Symbolic Link)**: A soft shortcut pointing directly to `test0`.

```bash
ln test3 test5
ln -s test0 test6
```

### Step 3: Configure File Permissions
We use `chmod` with absolute octal numeric modes to assign Read (`4`), Write (`2`), and Execute (`1`) permissions.

```bash
chmod 715 test0
chmod 714 test1
chmod 504 test2
chmod 404 test3
chmod 641 test4
```
*(Note: `test5` automatically updates its permissions through `test3` due to the hard link. `test6` defaults to standard symlink permissions).*

### Step 4: Synchronize Timestamps
We alter the modification times using `touch -m -t` in the format `YYYYMMDDhhmm`. 

> ⚠️ **Year Warning:** If June 1st is older than 6 months from today, `ls -l` displays the year instead of the hour. Use the **current calendar year (2026)** to force the hour format display.

```bash
touch -m -t 202606012047 test0
touch -m -t 202606012146 test1
touch -m -t 202606012245 test2
touch -m -t 202606012344 test3
touch -m -t 202606012343 test4
touch -m -t 202606012344 test5
touch -h -m -t 202606012220 test6
```
*(Note: The `-h` flag on `test6` forces the timestamp change onto the symbolic link itself, rather than resolving to `test0`).*

---

## 📦 Submission Archive

Once your local `ls -l` output flawlessly replicates the assignment prompt, compress the folder using the allowed `tar` command parameters:

```bash
tar -cf exo.tar *
```

Ensure `exo.tar` is sitting cleanly inside your `ex00/` directory before running your final repository push.

