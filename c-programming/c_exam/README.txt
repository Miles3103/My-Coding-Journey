# **************************************************************************** #
#                                                                              #
#                          MILES3103 C EXAM SYSTEM                             #
#                        Low-Level Mastery Framework v10.0                     #
#                                                                              #
# **************************************************************************** #

## 1. THE PHILOSOPHY: WHY THIS EXAM?
This exam is modeled after the "Piscine" and "Exam Shell" used at 42 Network
schools. Unlike standard coding tutorials, this system focuses on:

* **Low-Level Understanding**: By using `write()` from `<unistd.h>` instead
    of `printf()`, you learn how the Operating System actually handles data.
* **Strict Discipline**: The grader uses `-Wall -Wextra -Werror` flags.
    In this exam, a "minor warning" is treated as a "total failure." This
    forces you to write clean, perfect code.
* **Memory Mastery**: The curriculum moves toward Pointers and Memory
    Addresses, which are the heart of powerful C programming.
* **Self-Reliance**: You have no IDE "Run" button. You must understand the
    compilation process and debug using the provided Trace logs.



## 2. PROJECT STRUCTURE

    miles3103_v10.sh    -> The main Grader and Shell interface
    subjects/           -> Level instructions (auto-generated, do not edit)
    rendu/              -> Your workspace. All submissions go here.
        ft_hello/
            ft_hello.c          <- Level 0
        ft_putnbr/
            ft_putnbr.c         <- Level 7
        ft_fibonacci/
            ft_fibonacci.c      <- Level 39
        ...                     <- One folder per level, named after the function
    traces/             -> Compilation and logic failure logs
    .level              -> Hidden file that saves your current level
    .score              -> Hidden file that saves your total score
    .passed             -> Hidden file tracking which levels you cleared



## 3. HOW TO RUN THE EXAM

### Step A: Setup
Make the script executable:
    $ chmod +x miles3103_v10.sh

### Step B: Start the Session
    $ ./miles3103_v10.sh

### Step C: The Workflow
1. Read the assignment shown in the shell.
2. Open a second terminal window.
3. The shell tells you exactly which file to create, for example:
       rendu/ft_putnbr/ft_putnbr.c
4. Create that folder and file:
       $ mkdir -p rendu/ft_putnbr
       $ nano rendu/ft_putnbr/ft_putnbr.c
5. Write your code. The filename and folder are always the same name.

### Step D: Submission
Go back to the Exam Shell terminal and type:
    grademe



## 4. SHELL COMMANDS

    grademe     -> Compile and test your current solution
    score       -> Show the full scoreboard, rank, and cleared levels
    hint        -> Re-display the current level subject
    skip        -> Skip the current level (no point awarded)
    reset       -> Jump back to level 0 (score is kept)
    resetscore  -> Wipe ALL progress including score (full reset)
    exit        -> Save and quit (progress is always saved)



## 5. SCORE SYSTEM

* Each of the 60 levels is worth 1 point.
* Points are awarded only once per level — you cannot replay for extra credit.
* Your current score is always visible in the prompt:
      exam[lvl7 | score:6/60]>
* A score bar and rank are shown on the main screen:
      Score : 24 / 60 pts  [████████░░░░░░░░░░░░]
      Rank  : ★☆☆ Intermediate Coder

  Ranks:
      0  - 11  pts  ->  Apprentice
      12 - 23  pts  ->  Junior Developer
      24 - 41  pts  ->  Intermediate Coder
      42 - 53  pts  ->  Advanced Programmer
      54 - 60  pts  ->  C MASTER



## 6. TROUBLESHOOTING

If your code fails:
1. Check the `traces/` folder for the latest log (named after your function,
   e.g. `traces/trace_ft_putnbr.txt`).
2. Look for "unused variable", "implicit declaration", or "missing include".
3. Remember: warnings are errors. `-Werror` means zero tolerance.
4. Use `hint` in the shell to re-read the subject.



## 7. LEVEL MAP (60 Levels)

  Lvl 00-02   C Intro          ft_hello, ft_return, ft_pipeline
  Lvl 03-05   Syntax           ft_structure, ft_functions, ft_prototype
  Lvl 06-08   Output           ft_write, ft_putnbr, ft_print_combo
  Lvl 09-11   Comments         ft_comments, ft_doccomment, ft_bugfix
  Lvl 12-14   Variables        ft_variables, ft_scope, ft_swap
  Lvl 15-17   Data Types       ft_sizeof, ft_limits, ft_unsigned
  Lvl 18-20   Type Conversion  ft_implicit, ft_percent, ft_ascii
  Lvl 21-23   Constants        ft_define, ft_enum, ft_macros
  Lvl 24-26   Operators        ft_bitwise, ft_compound, ft_ternary
  Lvl 27-29   Booleans         ft_truth_table, ft_shortcircuit, ft_password
  Lvl 30-32   If...Else        ft_grade, ft_fizzbuzz, ft_leap
  Lvl 33-35   Switch           ft_calc, ft_chartype, ft_statemachine
  Lvl 36-38   While Loop       ft_collatz, ft_dowhile, ft_digitsum
  Lvl 39-41   For Loop         ft_fibonacci, ft_patterns, ft_prime
  Lvl 42-44   Break/Continue   ft_find, ft_filter, ft_nested
  Lvl 45-47   Arrays           ft_stats, ft_bubblesort, ft_matrix
  Lvl 48-50   Strings          ft_strfuncs, ft_strmanip, ft_numconv
  Lvl 51-53   User Input       ft_readbuf, ft_parseinput, ft_multiline
  Lvl 54-56   Memory Addresses ft_memaddr, ft_passref, ft_swapptr
  Lvl 57-59   Pointers         ft_ptrarith, ft_ptrtoptr, ft_funcptr



********************************************************************************
* "Success is not final, failure is not fatal: it is the courage to continue  *
*  that counts." - Miles3103 C Mastery Shell v10.0                            *
********************************************************************************
