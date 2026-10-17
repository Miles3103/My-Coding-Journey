# 42 Piscine: Shell 01 - Exercise 05 (Can you create it?)

An educational guide explaining how to bypass shell interpretation to create a file containing an exact text string with a highly complex name full of special characters.

## 📋 The Assignment

The goal is to create a single file inside the `ex05/` directory. 
* The file contents must be exactly `"42"` (2 bytes, no trailing newline, or with a newline depending on the byte count check).
* The filename must be exactly: `"\?$*'MaRViN'*$?\"`

```bash
\$> ls -lRa *MaRV* | cat -e
-rw---xr-- 1 75355 32015 2 Oct 2 12:21 "\?\$*'MaRViN'*\$?\"\$
```

---

## 💡 The Solution

Because the filename contains single quotes, double quotes, dollar signs, and asterisks, standard terminal commands will fail or substitute variables if not escaped correctly. We use **strong quoting (single quotes)** to treat everything as literal text, and explicitly escape the single quotes inside the name.

Navigate to your `ex05/` directory and run this single command:

```bash
echo -n "42" > '"\?\(*'\''MaRViN'\''*\)?\"'
```

### 🔍 Detailed Command Breakdown

1. **`echo -n "42"`**: Writes the characters `4` and `2` without adding an automatic trailing newline. Notice the `ls -l` output shows a file size of exactly **2** bytes.
2. **`>`**: Overwrites or creates the target file.
3. **The Filename Quoting Breakdown**:
   * We start with a single quote `'` to neutralize the first characters: `"\?\$*`
   * To insert a literal single quote (`'`), we must temporarily exit our string block using `'`, write an escaped quote `\'`, and restart the string block with `'`.
   * We repeat this wrapping around the word `MaRViN`.
   * The final part `*$?\"` is locked inside the closing single quotes.

---

## 🛠️ Setup and Testing

To verify that your file name and contents were created flawlessly without any accidental shell expansions, run these verification checks:

1. **Check the exact filename structure**:
   Run `ls` with `cat -e` to make sure the terminal shows the exact name without hiding characters:
   ```bash
   ls -la | grep MaRV | cat -e
   ```
   **Expected Output:**
   ```bash
   -rw-r--r--  1 user  group  2 Jun 20 19:48 "\?\$*'MaRViN'*\$?\"\$
   ```

2. **Verify File Content Size**:
   The output size column must show exactly `2` bytes. You can double-check the content using `cat -e`:
   ```bash
   cat -e '"\?\$*'\''MaRViN'\''*\$?\"'
   ```
   **Expected Output:**
   ```bash
   42
   ```
   *(If you see `42$`, you added a newline character by mistake. Delete the file and re-run the `echo -n` command).*

---

## 📦 Submission

Ensure your `ex05/` directory only contains this uniquely named file before pushing your project to Git.

