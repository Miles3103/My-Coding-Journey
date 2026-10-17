# **************************************************************************** #
#                                                                              #
#                          MILES3103 C EXAM SYSTEM                             #
#                     Low-Level Mastery Framework v14.0                        #
#                                                                              #
#   v11 — Fixed: FAIL message no longer disappears instantly                  #
#   v12 — Attempt counter, streak, open/cat/history cmds                      #
#   v13 — Full backup save system: save/load/saves/deletesave + auto-save     #
#   v14 — Full diff on FAIL: line-by-line table + character-level hint        #
#          Expected output defined for all 60 levels                           #
#                                                                              #
# **************************************************************************** #


════════════════════════════════════════════════════════════════
  TABLE OF CONTENTS
════════════════════════════════════════════════════════════════

  1.  The Philosophy — Why This Exam?
  2.  Project Structure
  3.  How to Run the Exam (Step-by-Step)
  4.  The Workflow — Writing & Submitting Code
  5.  All Shell Commands (Complete Reference)
  6.  Score System & Ranks
  7.  Streak System
  8.  Attempt & Fail Tracking
  9.  Backup & Save System
  10. Diff on Fail — How It Works  ← NEW in v14
  11. Stats & Scoreboard
  12. Troubleshooting & Common Errors
  13. Level Map (60 Levels)
  14. Tips for Success


════════════════════════════════════════════════════════════════
  1. THE PHILOSOPHY — WHY THIS EXAM?
════════════════════════════════════════════════════════════════

This exam is modeled after the "Piscine" and "Exam Shell" used at 42 Network
schools. Unlike standard coding tutorials, this system focuses on:

  LOW-LEVEL UNDERSTANDING
    By using write() from <unistd.h> instead of printf(), you learn how
    the Operating System actually handles output at the syscall level.

  STRICT DISCIPLINE
    The grader uses -Wall -Wextra -Werror flags. A "minor warning" is a
    total failure. This forces you to write clean, perfect code from day 1.

  MEMORY MASTERY
    The curriculum moves progressively toward Pointers and Memory Addresses,
    which are the heart of powerful C programming.

  SELF-RELIANCE
    No IDE "Run" button. You understand the compilation process and debug
    using the Trace logs the system provides.

  MEASURABLE PROGRESS
    Every attempt is logged. You see your pass rate, fail count, streaks,
    and per-level history — exactly like a real exam environment.


════════════════════════════════════════════════════════════════
  2. PROJECT STRUCTURE
════════════════════════════════════════════════════════════════

  miles3103_v14.sh      The main exam shell and grader
  README.txt            This file

  subjects/             Level instructions (auto-generated on startup)
                        Do NOT edit these files manually.

  rendu/                YOUR WORKSPACE. All submissions go here.
    ft_hello/
      ft_hello.c        ← Level 0 solution
    ft_putnbr/
      ft_putnbr.c       ← Level 7 solution
    ft_fibonacci/
      ft_fibonacci.c    ← Level 39 solution
    ...                 One folder per level, named after the function.

  traces/               Compile and grading logs — one file per level.
    trace_ft_hello.txt
    trace_ft_putnbr.txt
    ...

  saves/                Backup save slots (created automatically)
    autosave/           Auto-created after every PASS
    quicksave/          Created when you type: save
    my_slot/            Created when you type: save my_slot
    ...

  .level                Hidden — stores your current level number
  .score                Hidden — stores your total score
  .passed               Hidden — list of cleared level numbers
  .attempts             Hidden — full log of every grademe attempt
  .streak               Hidden — current consecutive win streak
  .best                 Hidden — best streak ever recorded


════════════════════════════════════════════════════════════════
  3. HOW TO RUN THE EXAM (STEP-BY-STEP)
════════════════════════════════════════════════════════════════

  STEP A — Make the script executable (first time only)
  ──────────────────────────────────────────────────────
    $ chmod +x miles3103_v14.sh

  STEP B — Start the exam shell
  ──────────────────────────────────────────────────────
    $ ./miles3103_v14.sh

  You will see the main screen:

    ╔══════════════════════════════════════════════════════════╗
    ║      MILES3103 — C MASTERY EXAM v14.0  (60 Levels)      ║
    ╚══════════════════════════════════════════════════════════╝

    Topic   : C Intro  (task 1/3)
    Level   : 0 / 59   This level: 0✓ 0✗  (0 total)
    File    : ft_hello.c
    Progress: [>........................................................]
    Score   : 0/60  [░░░░░░░░░░░░░░░░░░░░]  All-time fails: 0  Streak: 0
    Rank    : ☆☆☆ Apprentice

  STEP C — Open a second terminal window
  ──────────────────────────────────────────────────────
  Keep the exam shell open in one terminal.
  Use a second terminal to write your code.

  STEP D — Create your solution file
  ──────────────────────────────────────────────────────
  The shell always tells you exactly which file to create.
  Example for Level 0:

    FILE: rendu/ft_hello/ft_hello.c

  In your second terminal:
    $ mkdir -p rendu/ft_hello
    $ nano rendu/ft_hello/ft_hello.c

  The folder name and the file name are ALWAYS the same as the function.

  STEP E — Write your solution
  ──────────────────────────────────────────────────────
  Write your C code. Follow the subject instructions exactly.
  Pay close attention to the expected output — spacing and newlines matter.

  Or use the built-in open command from the exam shell:
    > open
  This creates the file if it doesn't exist and opens it in your $EDITOR.

  STEP F — Submit for grading
  ──────────────────────────────────────────────────────
  Go back to the exam shell terminal and type:
    > grademe

  The grader will:
    1. Compile your file with: gcc -Wall -Wextra -Werror
    2. Run your binary and capture output
    3. Compare output to expected result
    4. Show PASS or FAIL with full details


════════════════════════════════════════════════════════════════
  4. THE WORKFLOW — WRITING & SUBMITTING CODE
════════════════════════════════════════════════════════════════

  TYPICAL SESSION FLOW:
  ─────────────────────

    Exam shell          │   Your editor terminal
    ────────────────────┼──────────────────────────────────────
    Read the subject    │
    > open              │   (file opens in nano/vim/$EDITOR)
                        │   Write your solution
                        │   Save and close the editor
    > grademe           │
    ✓ PASS — Level 7!   │
    > save checkpoint   │   (optional: save a backup slot)
    > [Enter]           │   (continue to next level)

  AFTER A FAIL:
  ─────────────
  The FAIL screen shows:
    - How many times you've failed THIS level
    - Your total all-time fail count
    - A full line-by-line diff: expected vs your output  ← NEW in v14
    - A character-level hint pointing to the exact wrong char
    - Tips that get more detailed after each retry
    - The trace file path to inspect compile/run errors

  > hint              Re-read the subject carefully
  > cat               View your current file with line numbers
  > open              Re-open your file to edit it
  > grademe           Try again


════════════════════════════════════════════════════════════════
  5. ALL SHELL COMMANDS — COMPLETE REFERENCE
════════════════════════════════════════════════════════════════

  GRADING
  ───────
  grademe
    Compile and test your current solution.
    Uses: gcc -Wall -Wextra -Werror <file> -o eval_bin -lm
    Shows: your output, PASS/FAIL, score update, streak update.
    Auto-saves progress on every PASS.

  VIEWING & EDITING
  ─────────────────
  hint
    Re-display the current level's subject (instructions + expected output).
    Use this when you're unsure what the level is asking.

  open
    Open your current .c file in $EDITOR (defaults to nano if not set).
    Creates the file if it doesn't exist yet.
    Example: if $EDITOR=vim, it opens vim on rendu/ft_putnbr/ft_putnbr.c

  cat
    Print your current .c file in the terminal with line numbers.
    Useful for a quick look without leaving the exam shell.

  PROGRESS & STATS
  ─────────────────
  score
    Show the full scoreboard:
      - Total score and percentage
      - Progress bar
      - Rank
      - Win streak and best streak
      - Total attempts, passes, fails, win rate %
      - Hardest level (most retries before passing)
      - List of all cleared levels

  stats
    Show a per-level breakdown table:
      Lvl  File                    Pass   Fail  Status
        0  ft_hello.c                 1      0  ✓ clean
        7  ft_putnbr.c                1      3  ✓ +3retry
        9  ft_comments.c              0      2  ✗ stuck
       10  ft_doccomment.c            0      0  ► active

    Status meanings:
      ✓ clean    Passed on first try — perfect
      ✓ +Nretry  Passed but needed N retries before clearing
      ✗ stuck    Attempted but not yet cleared
      ► active   The level you are currently on
      ─ untried  Not reached yet

  history
    Show the timestamped attempt log for the CURRENT level only.
    Example output:
      Attempt history — Level 7
      ──────────────────────────────
      ✗ FAIL  at 14:02
      ✗ FAIL  at 14:15
      ✓ PASS  at 14:31

  BACKUP / SAVE SYSTEM  ← NEW in v13
  ────────────────────────────────────
  save
    Save your progress to the "quicksave" slot.
    Saves: level, score, passed list, attempts, streak, best streak.

  save <name>
    Save your progress to a named slot.
    Examples:
      save before_pointers
      save checkpoint_lvl30
      save mybackup
    Names can contain letters, numbers, underscores, and hyphens.

  load
    Load the "quicksave" slot (asks for confirmation first).

  load <name>
    Load a named slot (asks for confirmation first).
    WARNING: This overwrites your current progress.
    Examples:
      load before_pointers
      load autosave

  saves
    List all available save slots with their level, score, and timestamp.
    Example output:
      ╔══════════════════════════════════════════════════════════╗
      ║  autosave       Level=10 Score=9/60  2026-03-15 14:31  [auto] ║
      ║  quicksave      Level=9  Score=8/60  2026-03-15 13:45        ║
      ║  before31       Level=30 Score=29/60 2026-03-14 20:10        ║
      ╚══════════════════════════════════════════════════════════╝

  deletesave <name>
    Delete a save slot (asks for confirmation first).
    Example:
      deletesave old_backup

  AUTO-SAVE (happens automatically):
    Every time you pass a level, the system silently writes to saves/autosave/.
    You will see "(auto-saved)" on the PASS screen.
    To restore it: load autosave

  NAVIGATION
  ──────────
  skip
    Skip the current level. No point is awarded.
    Useful if you want to explore later levels first.

  goto N
    Jump directly to level N (0–59).
    Examples:
      goto 0
      goto 31
      goto 57

  RESET
  ─────
  reset
    Reset the level counter back to 0.
    Your score and cleared levels are KEPT.
    Use this to re-practice from the beginning.

  resetscore
    Full wipe of ALL progress:
      - Level → 0
      - Score → 0
      - Cleared levels → empty
      - Attempts log → empty
      - Streak → 0
      - Best streak → 0
    This does NOT delete your save slots in saves/.
    This does NOT delete your .c files in rendu/.

  OTHER
  ─────
  help  (or h or ?)
    Show the command reference inside the exam shell.

  exit  (or quit or q)
    Quit the exam. All progress is automatically saved to disk.
    Your .level, .score, .passed, .attempts, .streak files persist.


════════════════════════════════════════════════════════════════
  6. SCORE SYSTEM & RANKS
════════════════════════════════════════════════════════════════

  - There are 60 levels, each worth 1 point.
  - A point is awarded only the FIRST time you pass a level.
  - Re-passing a cleared level gives no extra credit.
  - Your score is always visible in the prompt:

      exam[lvl7|6/60]>

  RANKS:
    0  – 11  pts  →  ☆☆☆ Apprentice
    12 – 23  pts  →  ☆☆☆ Junior Developer
    24 – 41  pts  →  ★☆☆ Intermediate Coder
    42 – 53  pts  →  ★★☆ Advanced Programmer
    54 – 60  pts  →  ★★★ C MASTER

  SCORE BAR:
    Shown on the main screen and scoreboard.
    [████████░░░░░░░░░░░░]
    Each █ represents approximately 3 points.


════════════════════════════════════════════════════════════════
  7. STREAK SYSTEM
════════════════════════════════════════════════════════════════

  A STREAK counts how many levels you have passed in a row without failing.

  - Every PASS increases your streak by 1.
  - Every FAIL resets your streak to 0.
  - Your best-ever streak is recorded separately.

  STREAK MILESTONES:
    3+ wins in a row  →  🔥 "X win streak!" shown on PASS screen
    5+ wins in a row  →  ⚡ "On fire!" shown on PASS screen

  The current streak is shown on the main screen:
    Score: 12/60  [████░░░░░░░░░░░░░░░░]  All-time fails: 4  Streak: 3

  View streak history in the scoreboard:
    > score
    Win streak   :  3    Best streak :  7


════════════════════════════════════════════════════════════════
  8. ATTEMPT & FAIL TRACKING
════════════════════════════════════════════════════════════════

  Every time you run grademe, the result (PASS or FAIL) is logged with a
  timestamp to the .attempts file. This data powers several features:

  MAIN SCREEN — per-level counts:
    Level: 7 / 59   This level: 1✓ 3✗  (4 total)
    Shows passes, fails, and total attempts on the current level.

  MAIN SCREEN — all-time total:
    All-time fails: 9
    Shows your total fail count across all levels.

  FAIL SCREEN — context-aware:
    Attempt #4 on level 7.  Fails on this level: 3  |  Total fails all-time: 9
    - Attempt 1 tip: "Compare output letter-by-letter"
    - Attempt 2 tip: "Check for extra spaces, missing newlines"
    - Attempt 3+ tip: "Type hint to re-read the full subject"

  HISTORY COMMAND:
    > history
    Shows every attempt on the current level with timestamp.

  STATS COMMAND:
    > stats
    Shows a full table of pass/fail counts for every level you've reached.

  SCOREBOARD:
    > score
    Shows total passes, total fails, and your win rate percentage.
    Also shows your "hardest level" — the cleared level that took the most
    retries before you passed it.


════════════════════════════════════════════════════════════════
  9. BACKUP & SAVE SYSTEM  ← NEW in v13
════════════════════════════════════════════════════════════════

  WHAT IS SAVED?
  ──────────────
  Each save slot stores a complete snapshot of:
    - Current level number
    - Total score
    - List of all cleared levels
    - Complete attempt log
    - Current streak
    - Best streak ever

  Note: save slots do NOT include your .c solution files.
  Your rendu/ folder is untouched by save/load operations.

  WHERE ARE SAVES STORED?
  ───────────────────────
  All slots live inside the saves/ folder next to the script:

    saves/
      autosave/         ← written automatically on every PASS
        level
        score
        passed
        attempts
        streak
        best
        timestamp
        meta
      quicksave/        ← written when you type: save
      before31/         ← written when you type: save before31

  You can back up the entire saves/ folder by copying it elsewhere.
  You can also move a saves/ folder between machines to transfer progress.

  HOW TO USE SAVES — COMMON SCENARIOS
  ─────────────────────────────────────

  SCENARIO 1: Quick backup before a risky attempt
    > save backup_now
    (try some difficult levels...)
    (if you mess things up)
    > load backup_now

  SCENARIO 2: Save before the pointer levels
    > save before_pointers
    (work through levels 57-59...)
    (want to practice pointers again from scratch?)
    > load before_pointers

  SCENARIO 3: Recovering from accidental resetscore
    The autosave is updated on every PASS, so it always reflects your
    last successfully cleared level:
    > load autosave

  SCENARIO 4: Check what saves you have
    > saves
    Lists all slots with level, score, and save date/time.

  SCENARIO 5: Clean up old slots
    > deletesave old_backup
    (confirms before deleting)

  AUTO-SAVE DETAIL:
  ─────────────────
  Every time grademe results in a PASS, the system automatically writes
  to saves/autosave/ before you press Enter for the next level.
  The PASS screen shows "(auto-saved)" to confirm this happened.
  The autosave slot is overwritten on each PASS — it always reflects
  your most recent cleared level.


════════════════════════════════════════════════════════════════
  10. DIFF ON FAIL — HOW IT WORKS  ← NEW in v14
════════════════════════════════════════════════════════════════

  Every time grademe results in a FAIL, the system now shows you a
  side-by-side comparison table of the expected output vs your output,
  followed by a character-level hint on the first wrong line.

  EXAMPLE — Level 7 (ft_putnbr), missing the minus sign:

    ┌──────────────────────────────┬──────────────────────────┐
    │ EXPECTED                     │ YOUR OUTPUT              │
    ├──────────────────────────────┼──────────────────────────┤
    │ 0                            │ 0                        │ ✓
    │ 42                           │ 42                       │ ✓
    │ -7                           │ 7                        │ ✗
    │ 100                          │ 100                      │ ✓
    └──────────────────────────────┴──────────────────────────┘

    First difference on line 3:
    Expected char at pos 0: '-'
    Got char at pos 0     : '7'
    -7
    7
    ^

  EXAMPLE — Extra line in output (unexpected printf left in code):

    ┌──────────────────────────────┬──────────────────────────┐
    │ EXPECTED                     │ YOUR OUTPUT              │
    ├──────────────────────────────┼──────────────────────────┤
    │ Hello, C World!              │ Hello, C World!          │ ✓
    │ (unexpected)                 │ debug: x=42              │ ✗
    └──────────────────────────────┴──────────────────────────┘
    Line count: expected 1, got 2

  WHAT EACH SYMBOL MEANS:
    ✓   Line matches exactly
    ✗   Line is wrong or missing
    (empty)     Your output had no line where one was expected
    (unexpected) Your output had an extra line not in expected

  SPECIAL CASE — Level 54 (Memory Addresses):
    Addresses change every run so an exact diff is impossible.
    Instead the diff shows the required label format:
      global: 0x...
      stack:  0x...
      heap:   0x...
    The grader checks only that these labels exist with "0x".

  HOW TO USE THE DIFF:
    1. Look for the first ✗ line — that is where your output diverges.
    2. Read the "First difference" section to see the exact character.
    3. Common causes:
         - Wrong letter case  (Hello vs hello)
         - Missing minus sign  (-7 vs 7)
         - Extra space         ("Sum: 10 " vs "Sum: 10")
         - Missing newline     (two values on one line)
         - Extra debug output  (leftover printf/write)
    4. Fix your file with: open
    5. Re-submit with:     grademe


════════════════════════════════════════════════════════════════
  11. STATS & SCOREBOARD
════════════════════════════════════════════════════════════════

  SCOREBOARD  (type: score)
  ──────────────────────────
  ╔══════════════════════════════════════════════════════════╗
  ║                   ◆  SCOREBOARD  ◆                      ║
  ╠══════════════════════════════════════════════════════════╣
  ║  Total Score  : 12   / 60 points                        ║
  ║  Progress     : 20%                                     ║
  ║  Levels Done  : 12  / 60                                ║
  ║  Bar          : [████████░░░░░░░░░░░░░░░░░░░░░░]        ║
  ║  Rank         : ☆☆☆ Junior Developer                    ║
  ╠══════════════════════════════════════════════════════════╣
  ║  Win streak   :   3   Best streak :   7                 ║
  ║  Attempts     :  28   total                             ║
  ║  Passes       :  14   ( 50% win rate)                   ║
  ║  Failures     :  14                                     ║
  ║  Hardest lvl  : 7 (3 fails)                             ║
  ╠══════════════════════════════════════════════════════════╣
  ║  Cleared: 0 1 2 3 4 5 6 7 8 9 10 11                    ║
  ╚══════════════════════════════════════════════════════════╝

  PER-LEVEL STATS TABLE  (type: stats)
  ──────────────────────────────────────
  ╔══════════════════════════════════════════════════════════╗
  ║               ◆  PER-LEVEL STATS  ◆                     ║
  ╠══════════════════════════════════════════════════════════╣
  ║  Lvl  File                    Pass   Fail  Status       ║
  ╠══════════════════════════════════════════════════════════╣
  ║    0  ft_hello.c                 1      0  ✓ clean      ║
  ║    1  ft_return.c                1      0  ✓ clean      ║
  ║    7  ft_putnbr.c                1      3  ✓ +3retry    ║
  ║    9  ft_comments.c              0      2  ✗ stuck      ║
  ║   10  ft_doccomment.c            0      0  ► active     ║
  ╠══════════════════════════════════════════════════════════╣
  ║  TOTAL (levels 0–10)    Pass:  12  Fail:  14            ║
  ╚══════════════════════════════════════════════════════════╝


════════════════════════════════════════════════════════════════
  12. TROUBLESHOOTING & COMMON ERRORS
════════════════════════════════════════════════════════════════

  COMPILE ERROR
  ─────────────
  The grader shows the full gcc error output when compilation fails.
  The trace is also saved to: traces/trace_<functionname>.txt

  Common causes:
    - Missing #include <unistd.h> or #include <stdio.h>
    - Unused variable  →  remove it or use (void)var;
    - Implicit function declaration  →  add the correct #include
    - Warning treated as error (-Werror)  →  fix ALL warnings, not just errors

  FAIL — OUTPUT MISMATCH
  ──────────────────────
  The grader runs your binary and compares output line-by-line.
  The FAIL screen shows a full diff table — use it to find the exact
  line and character that is wrong (see Section 10).

  Things that cause silent mismatches:
    - Extra space at end of a line
    - Missing newline at end of output
    - Wrong number of newlines between lines
    - Uppercase vs lowercase spelling
    - Extra debug printf() left in your code

  How to debug:
    1. Read the diff table on the FAIL screen — find the first ✘ line
    2. Read the "First difference" character hint below the table
    3. Type: cat          (view your current file with line numbers)
    4. Type: hint         (re-read the subject and expected output)
    5. Manually compile and run in your other terminal:
         $ gcc rendu/ft_hello/ft_hello.c -o test && ./test
    6. Check: traces/trace_<n>.txt for the raw grader log.

  FILE NOT FOUND ERROR
  ─────────────────────
  The grader says: "rendu/ft_hello/ft_hello.c not found"

  Make sure:
    - The folder exists:  rendu/ft_hello/
    - The file exists:    rendu/ft_hello/ft_hello.c
    - The name matches EXACTLY (case-sensitive, underscore not hyphen)

  Quick fix:
    > open
  This auto-creates the correct folder and file for the current level.

  WRONG EDITOR OPENS WITH "open"
  ───────────────────────────────
  The "open" command uses $EDITOR. To change it:
    $ export EDITOR=vim
    $ export EDITOR=code      (VS Code, if in a GUI terminal)
    $ export EDITOR=gedit

  To make it permanent, add it to your ~/.bashrc or ~/.zshrc.

  PASS SCREEN DISAPPEARS TOO FAST / ENTER EATEN
  ───────────────────────────────────────────────
  This was fixed in v11. All read prompts now use /dev/tty directly.
  If you still see this, make sure you are running v14 (not v10).
  Check with:  head -5 miles3103_v14.sh


════════════════════════════════════════════════════════════════
  13. LEVEL MAP (60 LEVELS)
════════════════════════════════════════════════════════════════

  Lvl 00–02   C Intro           ft_hello, ft_return, ft_pipeline
  Lvl 03–05   Syntax            ft_structure, ft_functions, ft_prototype
  Lvl 06–08   Output            ft_write, ft_putnbr, ft_print_combo
  Lvl 09–11   Comments          ft_comments, ft_doccomment, ft_bugfix
  Lvl 12–14   Variables         ft_variables, ft_scope, ft_swap
  Lvl 15–17   Data Types        ft_sizeof, ft_limits, ft_unsigned
  Lvl 18–20   Type Conversion   ft_implicit, ft_percent, ft_ascii
  Lvl 21–23   Constants         ft_define, ft_enum, ft_macros
  Lvl 24–26   Operators         ft_bitwise, ft_compound, ft_ternary
  Lvl 27–29   Booleans          ft_truth_table, ft_shortcircuit, ft_password
  Lvl 30–32   If...Else         ft_grade, ft_fizzbuzz, ft_leap
  Lvl 33–35   Switch            ft_calc, ft_chartype, ft_statemachine
  Lvl 36–38   While Loop        ft_collatz, ft_dowhile, ft_digitsum
  Lvl 39–41   For Loop          ft_fibonacci, ft_patterns, ft_prime
  Lvl 42–44   Break/Continue    ft_find, ft_filter, ft_nested
  Lvl 45–47   Arrays            ft_stats, ft_bubblesort, ft_matrix
  Lvl 48–50   Strings           ft_strfuncs, ft_strmanip, ft_numconv
  Lvl 51–53   User Input        ft_readbuf, ft_parseinput, ft_multiline
  Lvl 54–56   Memory Addresses  ft_memaddr, ft_passref, ft_swapptr
  Lvl 57–59   Pointers          ft_ptrarith, ft_ptrtoptr, ft_funcptr

  DIFFICULTY CURVE:
    Lvl 00–11   Easy      Core syntax, output, comments
    Lvl 12–29   Medium    Variables, types, operators, booleans
    Lvl 30–44   Medium+   Control flow, loops, arrays
    Lvl 45–56   Hard      Strings, user input, memory addresses
    Lvl 57–59   Expert    Deep pointer mastery (Final Boss)


════════════════════════════════════════════════════════════════
  14. TIPS FOR SUCCESS
════════════════════════════════════════════════════════════════

  1. READ THE EXPECTED OUTPUT CAREFULLY
     The grader does exact or line-by-line matching. One extra space
     or missing newline is a FAIL. Copy the expected output mentally
     before you write a single line of code.

  2. COMPILE IN YOUR OWN TERMINAL FIRST
     Before running grademe, test manually:
       $ gcc -Wall -Wextra -Werror rendu/ft_hello/ft_hello.c -o t && ./t
     See your output directly. Fix all warnings before submitting.

  3. USE SAVE BEFORE HARD TOPICS
     Before starting the pointer levels (57+) or anytime you feel
     like you might experiment and break things:
       > save before_pointers

  4. USE THE AUTOSAVE AS YOUR SAFETY NET
     The autosave is updated every time you pass a level. If anything
     goes wrong (accidental reset, wrong goto, etc.):
       > load autosave

  5. USE "hint" MORE THAN YOU THINK
     The subjects contain tips that directly hint at the solution approach.
     Re-read the subject with "hint" after every fail.

  6. UNDERSTAND THE GRADER'S STRICTNESS
     -Wall  = all warnings
     -Wextra = extra warnings
     -Werror = warnings are errors
     Every unused variable, every missing include, every implicit
     declaration is a compile failure. This is intentional.

  7. TRACK YOUR HARDEST LEVELS WITH "stats"
     After a few levels, run "stats" to see which levels took the most
     retries. Those are the concepts to revisit and strengthen.

  8. DON'T SKIP THE POINTER LEVELS
     Levels 54–59 (Memory Addresses + Pointers) are the hardest but
     most important. They are what separates C programmers from the rest.
     Take your time. Use "save" before starting each one.

  9. BACK UP YOUR rendu/ FOLDER
     Your .c files in rendu/ are NOT included in save slots.
     Copy the entire rendu/ folder to a safe location regularly:
       $ cp -r rendu/ ~/backup_rendu_$(date +%Y%m%d)/

  10. THE PROMPT SHOWS YOUR LIVE STATUS
      exam[lvl7|6/60]>
      Everything you need to know is always visible.


════════════════════════════════════════════════════════════════
  QUICK REFERENCE CARD
════════════════════════════════════════════════════════════════

  GRADING        grademe
  VIEW SUBJECT   hint
  EDIT FILE      open
  VIEW FILE      cat
  SCOREBOARD     score
  STATS TABLE    stats
  ATTEMPT LOG    history

  SAVE           save [name]
  LOAD           load [name]
  LIST SAVES     saves
  DELETE SAVE    deletesave <name>

  SKIP LEVEL     skip
  JUMP TO LEVEL  goto N
  RESET LEVEL    reset
  FULL RESET     resetscore
  QUIT           exit


********************************************************************************
*                                                                              *
*   "Success is not final, failure is not fatal: it is the courage to         *
*    continue that counts."                                                    *
*                                                                              *
*                              — Miles3103 C Mastery Shell v14.0              *
*                                                                              *
********************************************************************************
