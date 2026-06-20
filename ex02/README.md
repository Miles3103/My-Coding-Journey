# clean

A one-line `find` command that recursively deletes editor backup files
(`*~` and `#*#`) from the current directory and all of its sub-directories.

**Requirements:** any POSIX-compliant `find` and an `sh`-compatible shell
(macOS, Linux, WSL — no extra dependencies).

## What it targets

- Files whose name **ends with `~`** (the classic Emacs/Vim backup suffix,
  e.g. `notes.txt~`)
- Files whose name **starts and ends with `#`** (Emacs auto-save files,
  e.g. `#notes.txt#`)

## The command

```sh
find . \( -name "*~" -o -name "#*#" \) -exec echo {} \; -exec rm {} \;
```

## How it works

| Part | Role |
|---|---|
| `find .` | Start searching from the current directory; `find` recurses into sub-directories by default. |
| `\( -name "*~" -o -name "#*#" \)` | Grouped condition: match a name ending in `~` **OR** a name starting and ending with `#`. The backslashed parentheses keep `find`'s `-o` (OR) from being misread by the shell. |
| `-exec echo {} \;` | For every match, print its path — this is the "show" step. `{}` is replaced by the matched file's path. |
| `-exec rm {} \;` | For every match, delete it — this is the "erase" step. |

Each match is processed through both `-exec` actions in order: it's echoed,
then removed.

## Why this counts as "one command"

Everything here is a single invocation of `find`. The `\;` sequences are not
shell command separators — they're `find`'s own required terminator for each
`-exec` action, escaped so the shell passes them through literally instead of
treating them as end-of-statement. No `;`, `&&`, `|`, or other shell chaining
is used between separate commands.

## Usage

```sh
sh clean
```

or make it executable:

```sh
chmod +x clean
./clean
```

Sample output when it finds matches:

```
$ ./clean
./notes.txt~
./drafts/#scratch#
```

Nothing is printed if no matching files exist.

## Testing

Quick check, using safe throwaway files:

```sh
mkdir test_clean && cd test_clean
touch "old.txt~" "#draft#" "keep_me.txt"
sh ../clean        # should print old.txt~ and #draft#, then delete them
ls                  # only keep_me.txt should remain
cd .. && rm -rf test_clean
```

<details>
<summary>Full test walkthrough (sub-directories + edge cases)</summary>

### 1. Set up a test directory with files that should and shouldn't match

```sh
mkdir test_clean && cd test_clean
mkdir subdir

touch "file.txt~" "subdir/notes.txt~"        # should match (ends in ~)
touch "#draft#" "subdir/#scratch#"           # should match (starts/ends with #)
touch "keep_me.txt" "subdir/important#file"  # should NOT match
```

That last one, `important#file`, is a good edge case — it contains `#` but
doesn't start with one, so `clean` should leave it alone.

### 2. List everything before running it

```sh
find . -type f
```

So you have a baseline to compare against.

### 3. Run `clean` and watch the output

```sh
sh ../clean
```

(adjust the path depending on where the `clean` file actually sits relative
to `test_clean`). You should see exactly the four matching paths printed —
`./file.txt~`, `./subdir/notes.txt~`, `./#draft#`, `./subdir/#scratch#`.

### 4. Confirm only the right files are gone

```sh
find . -type f
```

`keep_me.txt` and `subdir/important#file` should still be there; the four
matches should be gone.

### 5. Edge cases worth trying

- A file named just `~` or just `#` — won't match, since the pattern needs at
  least the suffix/prefix-and-suffix character plus something else
  (technically `"#*#"` does match a 2-character file literally named `##`, so
  test that one too if you're curious).
- An empty directory with no matches — `clean` should run with no output and
  no errors.
- Nested sub-sub-directories — confirm it recurses as deep as you go.

When you're done, just `cd ..` and `rm -rf test_clean` to clean up the test
scaffold itself.

</details>

## ⚠️ Warning

This permanently deletes matching files — there is no confirmation prompt
and no trash/recycle bin involved. Run it only in a directory where you're
sure those backup files are safe to remove.
