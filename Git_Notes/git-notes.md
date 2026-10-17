# Git Notes — Complete Learning Guide

A practical guide to understanding and using Git from scratch.

---

## Table of Contents

1. [What is Git?](#what-is-git)
2. [How Git Thinks — The Big Picture](#how-git-thinks)
3. [Setup](#setup)
4. [The Three Areas You Must Know](#three-areas)
5. [Core Commands](#core-commands)
6. [Branching](#branching)
7. [Merging & Rebasing](#merging--rebasing)
8. [Working with Remote Repos](#working-with-remote-repos)
9. [Undoing Things](#undoing-things)
10. [Stashing](#stashing)
11. [Viewing History & Logs](#viewing-history--logs)
12. [Common Workflows](#common-workflows)
13. [.gitignore](#gitignore)
14. [Quick Reference Cheatsheet](#quick-reference-cheatsheet)

---

## 1. What is Git?

Git is a **version control system** — it tracks changes to your files over time so you can:

- Go back to any previous version of your code
- Work on new features without breaking the main code
- Collaborate with other developers without overwriting each other's work
- See exactly what changed, when, and who changed it

> Think of Git like a save system in a video game — except you can have multiple save slots, name them, and jump between them freely.

---

## 2. How Git Thinks — The Big Picture

Git stores your project as a series of **snapshots** (called commits), not just a list of file changes.

```
A --- B --- C --- D   (main branch)
              \
               E --- F   (feature branch)
```

Each letter is a commit (snapshot). Branches are just pointers to a commit.

### The key concept: everything is local

Git keeps the full history of your project on your own machine. You only talk to a remote (like GitHub) when you explicitly push or pull.

---

## 3. Setup

Before anything, tell Git who you are. This info gets attached to every commit you make.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Set VS Code as your default editor (optional)
git config --global core.editor "code --wait"

# Check your config
git config --list
```

---

## 4. The Three Areas You Must Know

This is the most important concept in Git. Files live in one of three places:

```
Working Directory  →  Staging Area (Index)  →  Repository (.git)
   (your files)         (git add)               (git commit)
```

| Area | What it is |
|------|-----------|
| **Working Directory** | Your actual files on disk — what you see and edit |
| **Staging Area** | A "draft" of your next commit — you choose what goes in |
| **Repository** | The permanent history of commits stored in the `.git` folder |

### Why have a staging area?

It lets you be precise. Imagine you fixed a bug AND added a feature in the same session. You can stage and commit them separately, keeping your history clean and meaningful.

```bash
git add bug-fix.py      # stage only the bug fix
git commit -m "Fix login bug"

git add new-feature.py  # now stage the feature
git commit -m "Add dark mode"
```

---

## 5. Core Commands

### Starting a repo

```bash
# Create a new Git repo in the current folder
git init

# Clone an existing repo from GitHub (or anywhere)
git clone https://github.com/user/repo.git

# Clone into a specific folder name
git clone https://github.com/user/repo.git my-folder
```

### Checking status

```bash
# See what's changed, staged, or untracked
git status

# Short version
git status -s
```

Status symbols in short mode:
- `??` — untracked file (Git doesn't know about it yet)
- `A` — newly staged file
- `M` — modified file
- `D` — deleted file

### Staging files

```bash
# Stage a specific file
git add filename.py

# Stage multiple files
git add file1.py file2.py

# Stage everything in the current directory
git add .

# Stage parts of a file interactively (pick specific lines)
git add -p filename.py
```

### Committing

```bash
# Commit staged files with a message
git commit -m "Your message here"

# Stage all tracked files AND commit in one step
git commit -am "Your message"

# Open editor to write a longer commit message
git commit
```

### What makes a good commit message?

```
# Good ✓
git commit -m "Fix null pointer error in user login"
git commit -m "Add search functionality to products page"
git commit -m "Refactor database connection to use env variables"

# Bad ✗
git commit -m "fix"
git commit -m "changes"
git commit -m "asdfgh"
```

> Rule of thumb: complete the sentence — *"If applied, this commit will... [your message]"*

---

## 6. Branching

Branches let you work on something without touching the main code. Each branch is an independent line of development.

```bash
# List all branches (* marks the current one)
git branch

# Create a new branch
git branch feature-login

# Switch to a branch
git checkout feature-login

# Create AND switch in one command (preferred)
git checkout -b feature-login

# Modern syntax (Git 2.23+)
git switch -c feature-login

# Delete a branch (safe — won't delete if unmerged)
git branch -d feature-login

# Force delete
git branch -D feature-login

# Rename current branch
git branch -m new-name
```

### How branches actually work

A branch is just a lightweight pointer (label) to a commit. Creating one is instant and costs almost nothing.

```
main    →  A --- B --- C
                       ↑
feature →              C --- D --- E
```

`HEAD` is a special pointer that tells Git which branch you're currently on.

---

## 7. Merging & Rebasing

Once your feature is done, you need to bring it back into main.

### Merging

```bash
# Switch to the branch you want to merge INTO
git checkout main

# Merge your feature branch
git merge feature-login
```

**Fast-forward merge** — happens when main hasn't moved since you branched off. Git just moves the pointer forward. Clean, no extra commit.

**Three-way merge** — happens when both branches have new commits. Git creates a new "merge commit" that ties them together.

```
Before:
main:    A --- B --- C
feature:           C --- D --- E

After merge:
main:    A --- B --- C ----------- F (merge commit)
                      \           /
feature:               D ------- E
```

### Merge conflicts

A conflict happens when the same line was changed differently in both branches. Git will mark the file like this:

```
<<<<<<< HEAD
console.log("Hello from main");
=======
console.log("Hello from feature");
>>>>>>> feature-login
```

To fix it:
1. Open the file and decide which version to keep (or combine both)
2. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. `git add` the resolved file
4. `git commit` to finish the merge

### Rebasing

Rebasing moves your branch's commits onto the tip of another branch, giving a cleaner, linear history.

```bash
git checkout feature-login
git rebase main
```

```
Before:
main:    A --- B --- C
feature:       B --- D --- E

After rebase:
main:    A --- B --- C
feature:             C --- D' --- E'  (replayed on top of C)
```

> **Rule:** Never rebase a branch that others are using. Rebase is great for your own local branches before merging.

---

## 8. Working with Remote Repos

A **remote** is a version of your repo hosted somewhere else (GitHub, GitLab, etc.).

```bash
# See your remotes
git remote -v

# Add a remote (origin is the conventional name)
git remote add origin https://github.com/user/repo.git

# Remove a remote
git remote remove origin

# Rename a remote
git remote rename origin upstream
```

### Pushing & Pulling

```bash
# Push your branch to the remote
git push origin main

# Push and set upstream (so future pushes just need: git push)
git push -u origin main

# Pull latest changes from remote (fetch + merge)
git pull

# Pull with rebase instead of merge
git pull --rebase

# Fetch without merging (just download, don't apply)
git fetch origin
```

### The difference between fetch and pull

```
git fetch  →  downloads changes, but does NOT touch your working files
git pull   →  downloads AND merges into your current branch (fetch + merge)
```

Fetching first lets you inspect what changed before applying it.

---

## 9. Undoing Things

This is where most beginners panic. Stay calm — Git almost never permanently deletes anything.

### Undo before staging (working directory)

```bash
# Discard changes to a file (goes back to last commit)
git checkout -- filename.py

# Modern syntax
git restore filename.py

# Discard ALL changes in working directory
git restore .
```

### Undo after staging (unstage a file)

```bash
git reset HEAD filename.py

# Modern syntax
git restore --staged filename.py
```

### Undo a commit

```bash
# Undo last commit but keep changes staged
git reset --soft HEAD~1

# Undo last commit and unstage changes (files still edited)
git reset --mixed HEAD~1   # this is the default

# Undo last commit AND discard all changes (DESTRUCTIVE)
git reset --hard HEAD~1
```

`HEAD~1` means "one commit before HEAD". Use `HEAD~2` for two commits back, etc.

### Revert (safe for shared branches)

```bash
# Creates a NEW commit that undoes a previous one
# Safe because it doesn't rewrite history
git revert abc1234    # abc1234 is the commit hash
```

> Use `reset` for local commits you haven't pushed. Use `revert` for commits already on a shared remote.

### Fix your last commit

```bash
# Change the commit message of the last commit
git commit --amend -m "Corrected message"

# Add a forgotten file to the last commit
git add forgotten-file.py
git commit --amend --no-edit
```

---

## 10. Stashing

Stash is like a clipboard for your uncommitted changes. Useful when you need to switch branches but aren't ready to commit.

```bash
# Save current changes to the stash
git stash

# Save with a description
git stash save "work in progress on login form"

# List all stashes
git stash list

# Apply the most recent stash (keeps it in the list)
git stash apply

# Apply AND remove from stash list
git stash pop

# Apply a specific stash
git stash apply stash@{2}

# Delete a stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

---

## 11. Viewing History & Logs

```bash
# Full log
git log

# Compact one-line log
git log --oneline

# Show graph of branches
git log --oneline --graph --all

# Show last 5 commits
git log -5

# Search commits by message
git log --grep="login"

# Show what changed in each commit
git log -p

# See who changed each line of a file
git blame filename.py
```

### Inspecting specific commits

```bash
# See details of a specific commit
git show abc1234

# See what changed between two commits
git diff abc1234 def5678

# See changes between your branch and main
git diff main..feature-login

# See staged changes (what you're about to commit)
git diff --staged
```

---

## 12. Common Workflows

### Starting a new feature

```bash
git checkout main
git pull                          # get latest
git checkout -b feature/dark-mode # new branch
# ... write code ...
git add .
git commit -m "Add dark mode toggle"
git push -u origin feature/dark-mode
# open a Pull Request on GitHub
```

### Keeping your branch up to date with main

```bash
git checkout main
git pull
git checkout feature/dark-mode
git rebase main    # replay your commits on top of latest main
```

### Fixing a bug on production quickly (hotfix)

```bash
git checkout main
git pull
git checkout -b hotfix/login-crash
# fix the bug
git add .
git commit -m "Fix crash on empty username login"
git checkout main
git merge hotfix/login-crash
git push
git branch -d hotfix/login-crash
```

---

## 13. .gitignore

A `.gitignore` file tells Git which files to never track. Put it in the root of your repo.

```
# .gitignore examples

# Ignore compiled Python files
__pycache__/
*.pyc
*.pyo

# Ignore virtual environments
venv/
.env/

# Ignore environment variables (NEVER commit secrets!)
.env
.env.local

# Ignore OS files
.DS_Store       # Mac
Thumbs.db       # Windows

# Ignore editor files
.vscode/
.idea/
*.swp

# Ignore build output
dist/
build/
*.log
```

```bash
# If you already committed a file and want to untrack it:
git rm --cached filename.py
# then add it to .gitignore and commit
```

> **Never commit passwords, API keys, or secrets.** Use `.env` files and add them to `.gitignore`.

---

## 14. Quick Reference Cheatsheet

### Setup
| Command | What it does |
|---------|-------------|
| `git config --global user.name "Name"` | Set your name |
| `git config --global user.email "email"` | Set your email |

### Basic
| Command | What it does |
|---------|-------------|
| `git init` | Create a new repo |
| `git clone <url>` | Copy a remote repo locally |
| `git status` | See what's changed |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit staged changes |

### Branches
| Command | What it does |
|---------|-------------|
| `git branch` | List branches |
| `git checkout -b <name>` | Create & switch to branch |
| `git merge <branch>` | Merge branch into current |
| `git branch -d <name>` | Delete branch |

### Remote
| Command | What it does |
|---------|-------------|
| `git remote add origin <url>` | Link to a remote |
| `git push -u origin main` | Push & set upstream |
| `git pull` | Fetch & merge from remote |
| `git fetch` | Download without merging |

### Undoing
| Command | What it does |
|---------|-------------|
| `git restore <file>` | Discard file changes |
| `git restore --staged <file>` | Unstage a file |
| `git reset --soft HEAD~1` | Undo commit, keep changes |
| `git reset --hard HEAD~1` | Undo commit, discard changes |
| `git revert <hash>` | Safely undo a pushed commit |

### Useful
| Command | What it does |
|---------|-------------|
| `git log --oneline --graph` | Visual history |
| `git diff --staged` | See staged changes |
| `git stash` | Save uncommitted work |
| `git stash pop` | Restore stashed work |
| `git blame <file>` | See who wrote each line |

---

## Tips to Remember

1. **Commit often, commit small** — small commits are easier to understand and undo
2. **Never force push to main** — you'll overwrite teammates' work
3. **Pull before you push** — always sync with remote first
4. **Branch for everything** — keep main clean and stable
5. **Write meaningful commit messages** — your future self will thank you
6. **Don't commit secrets** — API keys in a public repo = security disaster
7. **Use `git status` constantly** — it's your best friend for knowing where you are

---

*Happy committing!*
