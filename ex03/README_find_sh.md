# find_sh.sh

A one-line `find` command that locates every `.sh` file in the current
directory and all of its sub-directories, and prints just the file names
with the `.sh` extension stripped off — no paths, no extension.

**Requirements:** any POSIX-compliant `find` and `basename`, run from an
`sh`-compatible shell (macOS, Linux, WSL — no extra dependencies).

## What it does

Given this layout:

```
.
├── deploy.sh
└── scripts/
    └── build.sh
```

Running `find_sh.sh` prints:

```
deploy
build
```

Note that only the *name* is printed, not the path — `scripts/build.sh`
becomes `build`, not `scripts/build`.

## The command

```sh
find . -name "*.sh" -exec basename {} .sh \;
```

## How it works

| Part | Role |
|---|---|
| `find .` | Start searching from the current directory; `find` recurses into sub-directories by default. |
| `-name "*.sh"` | Match any file whose name ends in `.sh`. |
| `-exec basename {} .sh \;` | For every match, run `basename` on it. `{}` is replaced by the matched file's full path. The second argument to `basename` (`.sh`) tells it to strip that exact suffix off the end, in addition to its normal job of stripping the directory path. The result is just the bare name with no path and no `.sh`. |

`\;` terminates the `-exec` action — it's `find`'s own required syntax, not
a shell command separator.

## Why this counts as "one command"

The whole thing is a single invocation of `find`. The escaped `\;` is part
of `-exec`'s syntax, not a `;` used to chain separate shell commands, and
there's no `&&`, `|`, or other chaining between independent commands.

## Usage

```sh
sh find_sh.sh
```

or make it executable:

```sh
chmod +x find_sh.sh
./find_sh.sh
```

## Testing

Quick check with throwaway files:

```sh
mkdir test_sh && cd test_sh
mkdir sub
touch deploy.sh sub/build.sh not_a_script.txt

sh ../find_sh.sh
```

Expected output:

```
deploy
build
```

`not_a_script.txt` should be correctly ignored since it doesn't end in
`.sh`. Clean up afterward with `cd .. && rm -rf test_sh`.

<details>
<summary>Edge cases worth trying</summary>

- A file literally named `.sh` (no name before the extension) — `basename`
  will strip the suffix and print an empty line, since there's nothing left.
- A file named `script.sh.sh` — only the final `.sh` is stripped, leaving
  `script.sh` printed, since `-name "*.sh"` matched the whole name but
  `basename` only removes the trailing suffix once.
- A nested directory several levels deep — confirm it recurses correctly
  and still prints only the bare name, not any part of the path.

</details>
