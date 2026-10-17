# 42 Piscine: Shell 01 - Exercise 03 (find_sh.sh)

An educational guide explaining how to write a single-command script that recursively locates all `.sh` files and prints only their filenames with the extension removed.

## 📋 The Assignment

The goal is to create a script file named `find_sh.sh` inside the `ex03/` directory. It must contain a single command line that searches the current directory and all subdirectories to find files ending in `.sh`, displaying only the clean filenames without their paths or extensions.

```bash
\$> ./find_sh.sh | cat -e
find_sh\(file1\)
file2\(file3\)
\$>
```

---

## 💡 The Solution

To fulfill the "single command" restriction while stripping both the directory path and the trailing extension, we use the `find` utility coupled with its internal `-exec` action executing `basename`.

Place this exact line inside your `find_sh.sh` file:

```bash
find . -type f -name "*.sh" -exec basename {} .sh \;
```

### 🔍 Detailed Command Breakdown

| Component | Role |
| :--- | :--- |
| `find .` | Starts the recursive search from the current directory downwards. |
| `-type f` | Restricts results strictly to regular files (prevents matching folders named `something.sh`). |
| `-name "*.sh"` | Filters for files ending specifically with the `.sh` suffix. |
| `-exec ... \;` | Instructs `find` to execute an external command on every single file it discovers. The `\;` tells `find` where the command arguments end. |
| `basename {} .sh` | The program executed on each match. `{}` represents the file's current path (e.g., `./dir/file1.sh`). `basename` strips the path directory (`./dir/`), and passing `.sh` as the second argument instructs it to strip the extension as well, leaving only `file1`. |

---

## 🛠️ Setup and Testing

To thoroughly test your script and see the exact formatting expected by the 42 Moulinette, run these commands in your terminal:

1. **Create dummy test files**:
   ```bash
   mkdir -p test_dir/sub_dir
   touch find_sh.sh
   touch test_dir/file1.sh
   touch test_dir/sub_dir/file2.sh
   touch normal_file.txt
   ```

2. **Make your script executable**:
   ```bash
   chmod +x find_sh.sh
   ```

3. **Run your script with `cat -e`**:
   The `-e` flag reveals hidden newline characters as `$` anchors to ensure there are no trailing spaces or formatting issues.
   ```bash
   ./find_sh.sh | cat -e
   ```

4. **Expected Output**:
   ```bash
   find_sh\$
   file1\(file2\)
   ```
   *(Notice that `normal_file.txt` is completely ignored, and no directory paths or `.sh` suffixes are visible).*

---

## 📦 Submission

Ensure your `ex03/` directory only contains the `find_sh.sh` script file before pushing your project to Git.

