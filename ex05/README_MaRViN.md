# "\?$*'MaRViN'*$?\"

A file whose **name** is the literal string `\?$*'MaRViN'*$?\` (backslash,
question mark, dollar sign, asterisk, single quote, `MaRViN`, single quote,
asterisk, dollar sign, question mark, backslash), and whose **content** is
exactly the two characters `42` — nothing else, not even a trailing newline.

The challenge isn't the content, it's getting the shell to create a file
with that name without any of `\ ? $ * '` being interpreted as a wildcard,
variable, or escape sequence.

## The command used to create it

```sh
printf '42' > '\?$*'\''MaRViN'\''*$?\'
```

## How it works

**Why `printf` instead of `echo`**

`echo "42"` would write `42` *plus* a trailing newline character, since
that's `echo`'s default behavior. The task says the file should contain
"42" and **nothing else**, so even a newline would technically be an extra
byte. `printf '42'` writes exactly the two characters given and nothing
more.

**Why the filename is wrapped in single quotes**

Inside single quotes, the shell treats every character literally — `$`
won't trigger variable expansion, `*` and `?` won't trigger filename
globbing, and `\` won't act as an escape character. That's what makes it
possible to use all of those special characters in a filename at all.

**The one snag: quoting a literal single quote**

Single quotes can't contain a literal single quote inside them — there's
no escape character that works inside single quotes. The standard trick is
to close the quote, insert an escaped single quote, then reopen the quote:

```
'\''
```

Read as: `'` (close the current quoted string) + `\'` (one literal single
quote, escaped so the shell doesn't treat it as quoting syntax) + `'`
(open a new quoted string). The shell concatenates adjacent quoted/unquoted
pieces with no separator, so the result is seamless.

Breaking the full filename argument into its pieces:

| Piece | Meaning |
|---|---|
| `'\?$*'` | Literal `\?$*` |
| `\'` | One literal single quote |
| `'MaRViN'` | Literal `MaRViN` |
| `\'` | One literal single quote |
| `'*$?\'` | Literal `*$?\` |

Concatenated, those five pieces produce exactly: `\?$*'MaRViN'*$?\`

## Verifying it

To confirm the filename and content are exactly right after creating it:

```sh
ls -lb | cat -e
```

`ls -b` prints non-printable/special characters using escape sequences so
nothing gets swallowed by the terminal, and piping through `cat -e` makes
line endings visible (as `$`) so you can be sure nothing extra got added.

To check the content is precisely `42` with no trailing newline:

```sh
od -c '\?$*'\''MaRViN'\''*$?\'
```

Expected output:

```
0000000   4   2
0000002
```

Two bytes total — `4` and `2` — confirming there's no newline or other
character appended.

## Common pitfalls

Using `echo` instead of `printf` silently adds a trailing newline, which
fails the "nothing else" requirement even though the visible output looks
identical.

Forgetting to escape the single quotes around `MaRViN` either breaks the
command outright (unmatched quote) or silently produces the wrong
filename.

Typing smart/curly quotes (`’`) instead of straight quotes (`'`) — easy to
do if you copy the assignment text directly from a PDF or webpage, since
those often auto-convert quotes for display. The actual filename must use
straight single quotes (`'`), not typographic ones.
