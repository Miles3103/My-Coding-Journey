# 42 Piscine: Shell 01 - Exercise 02 (clean)

An educational guide explaining how to write a single-command script that recursively searches for, displays, and deletes specific temporary files.

## 📋 The Assignment

The goal is to create a script file named `clean` inside the `ex02/` directory. It must contain exactly **one command line** (no `;`, `&&`, or pipes) that recursively searches the current directory and all subdirectories to find, print, and delete files matching these two patterns:
1. Files ending with a tilde (`~`)
2. Files starting and ending with a hashtag (`#file#`)

---

## 💡 The Solution

To achieve this in a single command, we use the `find` utility. We combine logical "OR" conditions (`-o`) to match both patterns and use the `-delete` or `-print -exec` functions to handle the files.

Place this exact line inside your `clean` file:

```bash
find . \( -name "*~" -o -name "#*#" \) -print -delete
```

### 🔍 Detailed Command Breakdown

* **`find .`**: Starts the search in the current directory (`.`) and works down through all subfolders.
* **`\( ... \)`**: Parentheses group our search criteria together. We must escape them with backslashes (`\(` and `\)`) so the shell doesn't misinterpret them.
* **`-name "*~"`**: Matches any file name that ends with a `~`.
* **`-o`**: The logical **OR** flag. It tells `find` to match the first pattern *or* the second pattern.
* **`-name "#*#"`**: Matches any file name that starts with a `#` and ends with a `#`.
* **`-print`**: Displays the paths of the found files on the terminal screen (as required by the prompt: *"show and erase"*).
* **`-delete`**: Erases the matched files completely. 

> ⚠️ **Order Matters:** In some legacy versions of `find`, putting `-delete` before `-print` will erase the file before it can be printed, resulting in empty output. Always place `-print` first.

---

## 🛠️ Setup and Testing

To verify your script works flawlessly before turning it in, follow these steps in your terminal:

1. **Create dummy test files**:
   ```bash
   mkdir -p test_dir/sub_dir
   touch test~ # Should be deleted
   touch "#test#" # Should be deleted
   touch test_dir/nested~ # Should be deleted
   touch test_dir/sub_dir/"#nested#" # Should be deleted
   touch normal_file.txt # Should NOT be deleted
   ```

2. **Make your script executable**:
   ```bash
   chmod +x clean
   ```

3. **Run your script**:
   ```bash
   ./clean
   ```

4. **Verify the output**:
   Your terminal should print the paths of the deleted files. If you run `ls -R`, the temporary files should be gone, while `normal_file.txt` remains.

---

## 📦 Submission

Ensure your `ex02/` directory only contains the `clean` script file before pushing your project to Git.

