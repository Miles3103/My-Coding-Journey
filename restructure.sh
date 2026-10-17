#!/usr/bin/env bash
# restructure.sh - reorganise My-Coding-Journey using `git mv` so history is preserved.
# Run from the repository root:  bash restructure.sh
set -euo pipefail

[ -d .git ] || { echo "Run this from the repository root (no .git found)." >&2; exit 1; }

# Move with history when the path is tracked; plain mv for untracked files/dirs
# (so nothing is ever silently skipped or deleted).
mv_() {
  mkdir -p "$(dirname "$2")"
  if [ -n "$(git ls-files -- "$1" | head -n 1)" ]; then git mv -- "$1" "$2"; else mv -- "$1" "$2"; fi
}
rm_() { git rm -rq --ignore-unmatch -- "$@" 2>/dev/null || true; rm -rf -- "$@"; }

S=42_School; P=Programming_Languages

# Files that git tracks but that are already missing from disk (e.g. the old
# "Libft - The Complete Textbook.pdf") would make `git mv` of their folder fail.
# Record those deletions in the index first.
git ls-files --deleted -z | xargs -0 -r git rm -q --cached --

# ---------------------------------------------------------------- 1. junk ----
# Binaries, caches, editor backups, runtime state, duplicate/foreign files
rm_ "$S/42_Libft/test_libft" "$S/42_Libft/libft.zip" \
    "$S/Piscine_2026/C04/ex03/#ft_atoi.c#" \
    "$S/Piscine_2026/C13/Chat _ Microsoft Teams.html" \
    "$S/Piscine_2026/C13/Chat _ Microsoft Teams_files" \
    "$S/Piscine_2026/C13/Chat%20_%20Microsoft%20Teams.html" \
    "$P/Learning_C/C_Programming_Absolute_Beginner/main/hello.c" \
    "$P/Learning_C/C_Programming_Absolute_Beginner/main/a.out" \
    "$P/Learning_C/C_Programming_Absolute_Beginner/chapter1/a.out" \
    "$P/Learning_C/C_Practice/a.out" \
    "$P/Learning_C/Games_c/snake_c/snake" \
    "$P/Learning_C++/11_Projects/rpg_inventory" \
    "$P/Learning_C++/exercises_c/ex01/larg_3_num" \
    "$P/Learning_C++/exercises_c/.codex" \
    "$P/Assembly/Hello/hello" "$P/Assembly/Input/input" \
    "$P/Assembly/collect/collect" "$P/Assembly/small_game/game" \
    "$P/Learning_C/C_Exam/saves" \
    Linux
git ls-files -z | grep -zE '(^|/)__pycache__/' | xargs -0 -r git rm -q --cached --
find . -path ./.git -prune -o -name '__pycache__' -type d -print0 | xargs -0 -r rm -rf

# Duplicate flat copy of libft (the nested libft/ copy is the canonical one)
for f in "$S"/42_Libft/ft_*.c "$S/42_Libft/libft.h" "$S/42_Libft/Makefile" "$S/42_Libft/README.md"; do rm_ "$f"; done

# ------------------------------------------------------------ 2. libft -------
L=42-school/libft
mkdir -p $L/src $L/include $L/tests $L/docs
for f in "$S"/42_Libft/libft/ft_*.c; do mv_ "$f" "$L/src/$(basename "$f")"; done
mv_ "$S/42_Libft/libft/libft.h"   "$L/include/libft.h"
mv_ "$S/42_Libft/libft/Makefile"  "$L/Makefile"
mv_ "$S/42_Libft/libft/README.md" "$L/README.md"
mv_ "$S/42_Libft/test_libft.c"    "$L/tests/test_libft.c"
for f in "$S"/42_Libft/*; do [ -e "$f" ] && mv_ "$f" "$L/docs/$(basename "$f")"; done

# ------------------------------------------------------ 3. 42 coursework -----
mv_ "$S/Piscine_2026"     42-school/piscine-2026
mv_ "$S/Piscine_Reloaded" 42-school/piscine-reloaded
mv_ "$S/Discovery_Pscin"  42-school/discovery-python
mv_ "$S/42_exams"         42-school/exams
mv_ 42-school/piscine-2026/README\(3\).md 42-school/piscine-2026/README.md

# ----------------------------------------------------- 4. learning code ------
mv_ "$P/Learning_C"      learning/c
mv_ "$P/Learning_C++"    learning/cpp
mv_ "$P/Learning_Python" learning/python
mv_ "$P/Assembly"        learning/assembly
mv_ learning/c/C_Exam                         learning/c/exam
mv_ learning/c/C_Exampy                       learning/c/exam-py
mv_ learning/c/C_Practice                     learning/c/practice
mv_ learning/c/Games_c                        learning/c/games
mv_ learning/c/C_Programming_Absolute_Beginner learning/c/absolute-beginner

# ------------------------------------------- 5. third-party PDFs/books -------
# Copyrighted books are moved to a git-ignored folder (kept on disk, not tracked)
mkdir -p resources/books
for f in learning/c/C_Books learning/c/*.pdf learning/cpp/book.pdf learning/assembly/*.pdf; do
  [ -e "$f" ] || continue
  git rm -rq --cached --ignore-unmatch -- "$f" 2>/dev/null || true
  mv "$f" resources/books/
done

# ------------------------------------------------------------ 6. docs --------
mv_ Git_Notes/git-notes.md docs/git-notes.md
rm_ "learning/python/Pasted image.png"
find Git_Notes "$P" "$S" -depth -type d -empty -delete 2>/dev/null || true
for d in Git_Notes "$P" "$S"; do
  [ -d "$d" ] && echo "WARNING: $d still contains files that were not moved:" && find "$d" -type f | head
done

# ------------------------------------------- 7. filename typos / dead files --
PS=42-school/piscine-2026; DP=42-school/discovery-python/Introduction_to_Python
mv_ $PS/C00/ex04/ft_is_nagative.c $PS/C00/ex04/ft_is_negative.c
mv_ $PS/C01/ex06/ft_srlen.c       $PS/C01/ex06/ft_strlen.c
mv_ $PS/C02/ex01/ft_strncyp.c     $PS/C02/ex01/ft_strncpy.c
mv_ $PS/C03/ex03/ft_strncar.c     $PS/C03/ex03/ft_strncat.c
mv_ $PS/C04/ex00/ft_stlen.c       $PS/C04/ex00/ft_strlen.c
mv_ $DP/module6/ex00/aff_frist_param.py $DP/module6/ex00/aff_first_param.py
mv_ "$DP/module8/ex04/methods _everywhere.py" $DP/module8/ex04/methods_everywhere.py
# superseded exam v14 (v15 is a strict superset), empty asm stub, generated output
rm_ learning/c/exam/miles3103_v14.sh learning/assembly/asem learning/assembly/collect/info26

echo "Done. Review with: git status"
