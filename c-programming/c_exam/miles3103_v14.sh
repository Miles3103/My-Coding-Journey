#!/bin/bash
# **************************************************************************** #
#                                                                              #
#  Project : Miles3103 C Low-Level Mastery Shell v14.0                        #
#  Coverage: C Intro → Pointers (Deep Mastery Edition)                        #
#  Total   : 60 Levels  (3 per topic × 20 topics)                             #
#  Changes : v14 — Full diff on FAIL: line-by-line table + char-level hint    #
#                  Expected output defined for all 60 levels                  #
#                                                                              #
# **************************************************************************** #

# ══════════════════════════════════════════════════════════════════
#  TERMINAL COLORS
# ══════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ══════════════════════════════════════════════════════════════════
#  INIT
# ══════════════════════════════════════════════════════════════════
mkdir -p subjects rendu traces saves
[ ! -f .level    ] && echo 0 > .level
[ ! -f .score    ] && echo 0 > .score
[ ! -f .passed   ] && touch .passed
[ ! -f .attempts ] && touch .attempts
[ ! -f .streak   ] && echo 0 > .streak
[ ! -f .best     ] && echo 0 > .best

MAX_LEVEL=59

# ══════════════════════════════════════════════════════════════════
#  FILENAME MAP  (indexed array — bash 4+ required)
# ══════════════════════════════════════════════════════════════════
FILENAMES=(
    "ft_hello.c"        # 0
    "ft_return.c"       # 1
    "ft_pipeline.c"     # 2
    "ft_structure.c"    # 3
    "ft_functions.c"    # 4
    "ft_prototype.c"    # 5
    "ft_write.c"        # 6
    "ft_putnbr.c"       # 7
    "ft_print_combo.c"  # 8
    "ft_comments.c"     # 9
    "ft_doccomment.c"   # 10
    "ft_bugfix.c"       # 11
    "ft_variables.c"    # 12
    "ft_scope.c"        # 13
    "ft_swap.c"         # 14
    "ft_sizeof.c"       # 15
    "ft_limits.c"       # 16
    "ft_unsigned.c"     # 17
    "ft_implicit.c"     # 18
    "ft_percent.c"      # 19
    "ft_ascii.c"        # 20
    "ft_define.c"       # 21
    "ft_enum.c"         # 22
    "ft_macros.c"       # 23
    "ft_bitwise.c"      # 24
    "ft_compound.c"     # 25
    "ft_ternary.c"      # 26
    "ft_truth_table.c"  # 27
    "ft_shortcircuit.c" # 28
    "ft_password.c"     # 29
    "ft_grade.c"        # 30
    "ft_fizzbuzz.c"     # 31
    "ft_leap.c"         # 32
    "ft_calc.c"         # 33
    "ft_chartype.c"     # 34
    "ft_statemachine.c" # 35
    "ft_collatz.c"      # 36
    "ft_dowhile.c"      # 37
    "ft_digitsum.c"     # 38
    "ft_fibonacci.c"    # 39
    "ft_patterns.c"     # 40
    "ft_prime.c"        # 41
    "ft_find.c"         # 42
    "ft_filter.c"       # 43
    "ft_nested.c"       # 44
    "ft_stats.c"        # 45
    "ft_bubblesort.c"   # 46
    "ft_matrix.c"       # 47
    "ft_strfuncs.c"     # 48
    "ft_strmanip.c"     # 49
    "ft_numconv.c"      # 50
    "ft_readbuf.c"      # 51
    "ft_parseinput.c"   # 52
    "ft_multiline.c"    # 53
    "ft_memaddr.c"      # 54
    "ft_passref.c"      # 55
    "ft_swapptr.c"      # 56
    "ft_ptrarith.c"     # 57
    "ft_ptrtoptr.c"     # 58
    "ft_funcptr.c"      # 59
)

TOPICS=(
    "C Intro"    "C Intro"    "C Intro"
    "Syntax"     "Syntax"     "Syntax"
    "Output"     "Output"     "Output"
    "Comments"   "Comments"   "Comments"
    "Variables"  "Variables"  "Variables"
    "Data Types" "Data Types" "Data Types"
    "Type Conv." "Type Conv." "Type Conv."
    "Constants"  "Constants"  "Constants"
    "Operators"  "Operators"  "Operators"
    "Booleans"   "Booleans"   "Booleans"
    "If...Else"  "If...Else"  "If...Else"
    "Switch"     "Switch"     "Switch"
    "While Loop" "While Loop" "While Loop"
    "For Loop"   "For Loop"   "For Loop"
    "Break/Cont" "Break/Cont" "Break/Cont"
    "Arrays"     "Arrays"     "Arrays"
    "Strings"    "Strings"    "Strings"
    "User Input" "User Input" "User Input"
    "Mem. Addr." "Mem. Addr." "Mem. Addr."
    "Pointers"   "Pointers"   "Pointers"
)

get_filename() { echo "${FILENAMES[$1]}"; }
get_dirname()  { local f="${FILENAMES[$1]}"; echo "${f%.c}"; }
get_topic()    { echo "${TOPICS[$1]}"; }

# ══════════════════════════════════════════════════════════════════
#  SCORE HELPERS
# ══════════════════════════════════════════════════════════════════
get_score()     { cat .score; }
get_level()     { cat .level; }
add_score()     { echo $(( $(get_score) + $1 )) > .score; }
already_passed(){ grep -qx "$1" .passed 2>/dev/null; }
mark_passed()   { echo "$1" >> .passed; }
get_streak()    { cat .streak; }
get_best()      { cat .best; }

inc_streak() {
    local s=$(( $(get_streak) + 1 ))
    echo $s > .streak
    local b=$(get_best)
    [ $s -gt $b ] && echo $s > .best
}
reset_streak()  { echo 0 > .streak; }

get_attempts() {
    local lvl=$1
    grep -c "^$lvl:" .attempts 2>/dev/null || echo 0
}
get_passes_for() {
    local lvl=$1
    grep -c "^$lvl:PASS:" .attempts 2>/dev/null || echo 0
}
get_fails_for() {
    local lvl=$1
    grep -c "^$lvl:FAIL:" .attempts 2>/dev/null || echo 0
}
add_attempt() {
    local lvl=$1 result=$2
    echo "$lvl:$result:$(date +%H:%M)" >> .attempts
}

get_hardest_level() {
    # level with most fails that has also been passed
    local hardest_lvl="-"
    local hardest_count=0
    if [ -s .passed ]; then
        while IFS= read -r lvl; do
            local f=$(get_fails_for "$lvl")
            if [ "$f" -gt "$hardest_count" ]; then
                hardest_count=$f
                hardest_lvl=$lvl
            fi
        done < .passed
    fi
    echo "$hardest_lvl ($hardest_count fails)"
}

score_bar() {
    local score=$1 width=${2:-20}
    local filled=$(( score * width / 60 ))
    local bar=""
    for i in $(seq 1 $width); do
        [ $i -le $filled ] && bar="${bar}█" || bar="${bar}░"
    done
    echo "$bar"
}

get_rank() {
    local s=$1
    if   [ $s -ge 54 ]; then echo "★★★ C MASTER"
    elif [ $s -ge 42 ]; then echo "★★☆ Advanced Programmer"
    elif [ $s -ge 24 ]; then echo "★☆☆ Intermediate Coder"
    elif [ $s -ge 12 ]; then echo "☆☆☆ Junior Developer"
    else                     echo "☆☆☆ Apprentice"
    fi
}

# ══════════════════════════════════════════════════════════════════
#  SCOREBOARD
# ══════════════════════════════════════════════════════════════════
show_scoreboard() {
    local score=$(get_score)
    local level=$(get_level)
    local pct=$(( score * 100 / 60 ))
    local bar=$(score_bar $score 30)
    local rank=$(get_rank $score)
    local streak=$(get_streak)
    local best=$(get_best)
    local total_attempts=$(wc -l < .attempts 2>/dev/null | tr -d ' ')
    [ -z "$total_attempts" ] && total_attempts=0
    local total_pass=$(grep -c ":PASS:" .attempts 2>/dev/null || echo 0)
    local total_fail=$(grep -c ":FAIL:" .attempts 2>/dev/null || echo 0)
    local win_rate=0
    [ "$total_attempts" -gt 0 ] && win_rate=$(( total_pass * 100 / total_attempts ))
    local hardest=$(get_hardest_level)

    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║                   ◆  SCOREBOARD  ◆                      ║${RESET}"
    echo -e "${BOLD}${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    printf "${CYAN}║${RESET}  Total Score  : ${BOLD}${GREEN}%-4s${RESET} / 60 points                          ${CYAN}║${RESET}\n" "$score"
    printf "${CYAN}║${RESET}  Progress     : ${BOLD}${YELLOW}%-3s${RESET}%%                                       ${CYAN}║${RESET}\n" "$pct"
    printf "${CYAN}║${RESET}  Levels Done  : ${BOLD}%-3s${RESET} / 60                                  ${CYAN}║${RESET}\n" "$level"
    printf "${CYAN}║${RESET}  Bar          : [${GREEN}%-30s${RESET}]               ${CYAN}║${RESET}\n" "$bar"
    printf "${CYAN}║${RESET}  Rank         : ${BOLD}${MAGENTA}%-30s${RESET}          ${CYAN}║${RESET}\n" "$rank"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    printf "${CYAN}║${RESET}  Win streak   : ${BOLD}${YELLOW}%-3s${RESET}  Best streak : ${BOLD}${YELLOW}%-3s${RESET}                   ${CYAN}║${RESET}\n" "$streak" "$best"
    printf "${CYAN}║${RESET}  Attempts     : ${GRAY}%-4s${RESET} total                                 ${CYAN}║${RESET}\n" "$total_attempts"
    printf "${CYAN}║${RESET}  Passes       : ${GREEN}%-4s${RESET} (${GREEN}%3s${RESET}%% win rate)                         ${CYAN}║${RESET}\n" "$total_pass" "$win_rate"
    printf "${CYAN}║${RESET}  Failures     : ${RED}%-4s${RESET}                                        ${CYAN}║${RESET}\n" "$total_fail"
    printf "${CYAN}║${RESET}  Hardest lvl  : ${YELLOW}%-30s${RESET}          ${CYAN}║${RESET}\n" "$hardest"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    if [ -s .passed ]; then
        local passed_list
        passed_list=$(sort -n .passed | tr '\n' ' ')
        echo -e "${CYAN}║${RESET}  Cleared: ${GREEN}$passed_list${RESET}"
    else
        echo -e "${CYAN}║${RESET}  No levels cleared yet."
    fi
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    read -r -p "  Press Enter to continue..." _x < /dev/tty
}

# ══════════════════════════════════════════════════════════════════
#  PROGRESS DISPLAY
# ══════════════════════════════════════════════════════════════════
show_progress() {
    local level=$(get_level)
    local score=$(get_score)
    local fname=$(get_filename $level)
    local topic=$(get_topic $level)
    local subtask=$(( (level % 3) + 1 ))
    local rank=$(get_rank $score)
    local streak=$(get_streak)
    local attempts=$(get_attempts $level)
    local passes=$(get_passes_for $level)
    local fails=$(get_fails_for $level)
    local total_fail=$(grep -c ":FAIL:" .attempts 2>/dev/null || echo 0)

    # 60-char progress bar
    local pbar=""
    for i in $(seq 0 $MAX_LEVEL); do
        if   [ $i -lt $level  ]; then pbar="${pbar}${GREEN}#${RESET}"
        elif [ $i -eq $level  ]; then pbar="${pbar}${YELLOW}>${RESET}"
        else                          pbar="${pbar}${DIM}.${RESET}"
        fi
    done

    echo -e "  ${BOLD}Topic   :${RESET} ${CYAN}$topic${RESET}  (task ${subtask}/3)"
    echo -e "  ${BOLD}Level   :${RESET} ${YELLOW}$level${RESET} / $MAX_LEVEL   ${BOLD}This level:${RESET} ${GREEN}${passes}✓${RESET} ${RED}${fails}✗${RESET}  ${GRAY}(${attempts} total)${RESET}"
    echo -e "  ${BOLD}File    :${RESET} ${WHITE}$fname${RESET}"
    echo -e "  ${BOLD}Progress:${RESET} [${pbar}]"
    echo -e "  ${BOLD}Score   :${RESET} ${GREEN}$score${RESET}/60  [${GREEN}$(score_bar $score)${RESET}]  ${BOLD}All-time fails:${RESET} ${RED}${total_fail}${RESET}  ${BOLD}Streak:${RESET} ${YELLOW}${streak}${RESET}"
    echo -e "  ${BOLD}Rank    :${RESET} ${MAGENTA}$rank${RESET}"
}

# ══════════════════════════════════════════════════════════════════
#  SUBJECT GENERATION
# ══════════════════════════════════════════════════════════════════
generate_subjects() {

cat > subjects/lvl0.txt << 'EOF'
=== LEVEL 0 ─ C INTRO [1/3] : Your First Program ===
FILE: rendu/ft_hello/ft_hello.c

Write a complete C program that prints:
  Hello, C World!
using write() ONLY. No printf allowed.

Rules:
  - Include <unistd.h>
  - Use write(1, ..., len)
  - End with newline

Expected output:
  Hello, C World!

Tip: write(1, "Hello, C World!\n", 16);
EOF

cat > subjects/lvl1.txt << 'EOF'
=== LEVEL 1 ─ C INTRO [2/3] : Return Values ===
FILE: rendu/ft_return/ft_return.c

Write a C program that:
  1. Prints "Program starting" using write()
  2. Prints "Program done" using write()
  3. Returns 0 from main

Add a comment at the top:
  /* Q: What does returning 0 mean? What does returning 1 mean? */

Expected output:
  Program starting
  Program done

Tip: Non-zero return = error code (Unix convention).
EOF

cat > subjects/lvl2.txt << 'EOF'
=== LEVEL 2 ─ C INTRO [3/3] : GCC Compilation Pipeline ===
FILE: rendu/ft_pipeline/ft_pipeline.c

Print the 4 stages of GCC compilation using write():
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking

Expected output:
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking

Tip: These map to: cpp -> cc1 -> as -> ld
EOF

cat > subjects/lvl3.txt << 'EOF'
=== LEVEL 3 ─ SYNTAX [1/3] : Program Structure ===
FILE: rendu/ft_structure/ft_structure.c

Write a well-structured C program that:
  1. Has a file header comment (author, date, description)
  2. Has a helper function ft_print(char *s) using write()
     that prints the string + newline
  3. Calls ft_print("Syntax is power") from main

Expected output:
  Syntax is power

Tip: Function must be declared BEFORE main or use a prototype.
EOF

cat > subjects/lvl4.txt << 'EOF'
=== LEVEL 4 ─ SYNTAX [2/3] : Multiple Functions ===
FILE: rendu/ft_functions/ft_functions.c

Write THREE separate functions (max 5 lines each):
  greet()    -> prints "Hello"
  farewell() -> prints "Goodbye"
  main()     -> calls greet(), then farewell()

Expected output:
  Hello
  Goodbye

Tip: Small focused functions = good C style.
EOF

cat > subjects/lvl5.txt << 'EOF'
=== LEVEL 5 ─ SYNTAX [3/3] : Prototypes ===
FILE: rendu/ft_prototype/ft_prototype.c

Demonstrate function prototypes:
  1. Write prototype at top: int add(int a, int b);
  2. Define add() AFTER main
  3. In main: compute add(7, 8), print: Result: 15

Expected output:
  Result: 15

Tip: Prototype tells the compiler the signature before definition.
EOF

cat > subjects/lvl6.txt << 'EOF'
=== LEVEL 6 ─ OUTPUT [1/3] : write() Mastery ===
FILE: rendu/ft_write/ft_write.c

Using ONLY write(), print:
  *** HEADER ***
  (blank line)
  Content here
  (blank line)
  *** FOOTER ***

Expected output:
  *** HEADER ***

  Content here

  *** FOOTER ***

Tip: A blank line = just "\n" written to stdout.
EOF

cat > subjects/lvl7.txt << 'EOF'
=== LEVEL 7 ─ OUTPUT [2/3] : ft_putnbr ===
FILE: rendu/ft_putnbr/ft_putnbr.c

WITHOUT printf, write a function:
  void ft_putnbr(int n)
that uses write() to print an integer.

In main call it for: 0, 42, -7, 100 (each on own line)

Expected output:
  0
  42
  -7
  100

Tip: n % 10 gives last digit. Add '0' to convert to char.
     Handle negative: print '-' then negate n.
     Edge case: INT_MIN needs special handling.
EOF

cat > subjects/lvl8.txt << 'EOF'
=== LEVEL 8 ─ OUTPUT [3/3] : ft_print_combo ===
FILE: rendu/ft_print_combo/ft_print_combo.c

Write ft_print_combo() that prints via write():
  - All lowercase letters a to z (space-separated)
  - Newline
  - All digits 0 to 9 (space-separated)
  - Newline

Expected output:
  a b c d e f g h i j k l m n o p q r s t u v w x y z
  0 1 2 3 4 5 6 7 8 9

Tip: Use char variable in a loop. 'a' + i gives letter.
EOF

cat > subjects/lvl9.txt << 'EOF'
=== LEVEL 9 ─ COMMENTS [1/3] : Comment Styles ===
FILE: rendu/ft_comments/ft_comments.c

Write a C program demonstrating ALL comment types:
  1. File header block comment (/* ... */)
  2. Function-level comment above a function
  3. Inline comment on a variable declaration
  4. TODO comment inside main
  5. Program prints: "Comments guide future you"

Expected output:
  Comments guide future you

Tip: Good comments explain WHY, not WHAT.
EOF

cat > subjects/lvl10.txt << 'EOF'
=== LEVEL 10 ─ COMMENTS [2/3] : Documenting Functions ===
FILE: rendu/ft_doccomment/ft_doccomment.c

Write TWO functions, each with a full doc-comment:
  @param  - what the parameter is
  @return - what the function returns
  @desc   - what it does

Function 1: int ft_strlen(char *s)   -- returns length
Function 2: int ft_isalpha(char c)   -- 1 if letter, 0 if not

Test in main:
  ft_strlen("hello")  -> Length: 5
  ft_isalpha('3')     -> IsAlpha: 0
  ft_isalpha('z')     -> IsAlpha: 1

Expected output:
  Length: 5
  IsAlpha: 0
  IsAlpha: 1
EOF

cat > subjects/lvl11.txt << 'EOF'
=== LEVEL 11 ─ COMMENTS [3/3] : Commented Debugging ===
FILE: rendu/ft_bugfix/ft_bugfix.c

Write a program with a BUGGY version commented out
and a FIXED version active. Comment explaining the bug.

The bug: multiplying instead of adding
  // int result = a * b;  /* BUG: should be addition */
  int result = a + b;     /* FIX: correct operation */

With a = 6, b = 4, print: Sum: 10

Expected output:
  Sum: 10
EOF

cat > subjects/lvl12.txt << 'EOF'
=== LEVEL 12 ─ VARIABLES [1/3] : Declaration & Init ===
FILE: rendu/ft_variables/ft_variables.c

Declare ONE variable of each type:
  char   letter    = 'X'
  int    count     = 2025
  float  pi_approx = 3.14f
  double precise   = 2.718281828

Print each with printf:
  letter: X
  count: 2025
  pi_approx: 3.14
  precise: 2.718282

Expected output:
  letter: X
  count: 2025
  pi_approx: 3.14
  precise: 2.718282

Tip: printf("pi_approx: %.2f\n", pi_approx);
     printf("precise: %f\n", precise);
EOF

cat > subjects/lvl13.txt << 'EOF'
=== LEVEL 13 ─ VARIABLES [2/3] : Scope & Lifetime ===
FILE: rendu/ft_scope/ft_scope.c

Demonstrate variable scope:
  - Global int g = 100
  - Function scope_demo() with local int g = 999
    prints: local g = 999
  - main() calls scope_demo(), then prints: global g = 100

Expected output:
  local g = 999
  global g = 100

Tip: Local variables shadow globals within their scope.
EOF

cat > subjects/lvl14.txt << 'EOF'
=== LEVEL 14 ─ VARIABLES [3/3] : Swap Without Temp ===
FILE: rendu/ft_swap/ft_swap.c

Swap two integers WITHOUT a temporary variable.
Use XOR swap or arithmetic swap.

Start: a = 5, b = 9

Expected output:
  Before: a=5, b=9
  After:  a=9, b=5

Tip XOR swap: a ^= b; b ^= a; a ^= b;
Tip arith:    a = a+b; b = a-b; a = a-b;
EOF

cat > subjects/lvl15.txt << 'EOF'
=== LEVEL 15 ─ DATA TYPES [1/3] : sizeof Explorer ===
FILE: rendu/ft_sizeof/ft_sizeof.c

Print the size of every fundamental C type using sizeof.
Use printf with %zu format specifier.

Expected output (these exact lines, in this order):
  char:      1 bytes
  int:       4 bytes
  float:     4 bytes
  double:    8 bytes

Tip: printf("char:      %zu bytes\n", sizeof(char));
EOF

cat > subjects/lvl16.txt << 'EOF'
=== LEVEL 16 ─ DATA TYPES [2/3] : Limits & Overflow ===
FILE: rendu/ft_limits/ft_limits.c

Include <limits.h> and print:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128

Then demonstrate overflow:
  int overflow = INT_MAX + 1;
  Print: Overflow result: -2147483648

Expected output:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128
  Overflow result: -2147483648

Tip: Cast to avoid UB: (int)((unsigned int)INT_MAX + 1)
EOF

cat > subjects/lvl17.txt << 'EOF'
=== LEVEL 17 ─ DATA TYPES [3/3] : Unsigned vs Signed ===
FILE: rendu/ft_unsigned/ft_unsigned.c

  1. signed char sc = -1; unsigned char uc = (unsigned char)sc;
     Print:
       signed char:   -1
       unsigned char: 255

  2. unsigned int ui = 0; ui = ui - 1;
     Print: unsigned underflow: 4294967295

Expected output:
  signed char:   -1
  unsigned char: 255
  unsigned underflow: 4294967295
EOF

cat > subjects/lvl18.txt << 'EOF'
=== LEVEL 18 ─ TYPE CONVERSION [1/3] : Implicit Conversion ===
FILE: rendu/ft_implicit/ft_implicit.c

  1. int i = 65; char c = i; print c as char -> 'A'
  2. char ch = 'z'; int n = ch; print n -> 122
  3. int a=5, b=2; double d = a / b; print -> 2.000000
  4. double e = (double)a / b; print -> 2.500000

Expected output:
  char from int: A
  int from char: 122
  int division stored as double: 2.000000
  cast before division: 2.500000
EOF

cat > subjects/lvl19.txt << 'EOF'
=== LEVEL 19 ─ TYPE CONVERSION [2/3] : Explicit Casting ===
FILE: rendu/ft_percent/ft_percent.c

Write: int ft_percent(int part, int total)
Returns the integer percentage (truncated).
Example: ft_percent(1, 3) = 33

Test in main:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%

Expected output:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%

Tip: return (int)((double)part / total * 100);
EOF

cat > subjects/lvl20.txt << 'EOF'
=== LEVEL 20 ─ TYPE CONVERSION [3/3] : ASCII & Char Math ===
FILE: rendu/ft_ascii/ft_ascii.c

  1. Convert uppercase A, M, Z to lowercase by adding 32:
       A -> a
       M -> m
       Z -> z
  2. Convert char digits to int values:
       '5' -> 5
       '9' -> 9

Expected output:
  A -> a
  M -> m
  Z -> z
  '5' -> 5
  '9' -> 9
EOF

cat > subjects/lvl21.txt << 'EOF'
=== LEVEL 21 ─ CONSTANTS [1/3] : #define vs const ===
FILE: rendu/ft_define/ft_define.c

  - #define BUFFER_SIZE 1024
  - #define PI 3.14159265
  - const int MAX_USERS = 100;
  - const char SEPARATOR = '-';

Print all four:
  BUFFER_SIZE: 1024
  PI: 3.14159265
  MAX_USERS: 100
  SEPARATOR: -

Expected output:
  BUFFER_SIZE: 1024
  PI: 3.14159265
  MAX_USERS: 100
  SEPARATOR: -
EOF

cat > subjects/lvl22.txt << 'EOF'
=== LEVEL 22 ─ CONSTANTS [2/3] : Enum Constants ===
FILE: rendu/ft_enum/ft_enum.c

typedef enum e_day { MON=1, TUE, WED, THU, FRI, SAT, SUN } t_day;

Write const char *day_name(t_day d) returning the day name string.
Loop MON to SUN and print:
  1: Monday
  2: Tuesday
  ...
  7: Sunday

Expected output (all 7 lines):
  1: Monday
  2: Tuesday
  3: Wednesday
  4: Thursday
  5: Friday
  6: Saturday
  7: Sunday
EOF

cat > subjects/lvl23.txt << 'EOF'
=== LEVEL 23 ─ CONSTANTS [3/3] : Macro Functions ===
FILE: rendu/ft_macros/ft_macros.c

Write macros (not functions):
  #define MAX(a, b)   largest of a, b
  #define MIN(a, b)   smallest of a, b
  #define ABS(x)      absolute value
  #define SQUARE(x)   x squared

Test in main:
  MAX(3, 7)   = 7
  MIN(3, 7)   = 3
  ABS(-5)     = 5
  SQUARE(4)   = 16

Expected output:
  MAX(3, 7)   = 7
  MIN(3, 7)   = 3
  ABS(-5)     = 5
  SQUARE(4)   = 16

Tip: Wrap args in () e.g. #define SQUARE(x) ((x)*(x))
EOF

cat > subjects/lvl24.txt << 'EOF'
=== LEVEL 24 ─ OPERATORS [1/3] : Bitwise Operations ===
FILE: rendu/ft_bitwise/ft_bitwise.c

With a = 10 (0b1010) and b = 12 (0b1100):
  a & b  = 8
  a | b  = 14
  a ^ b  = 6
  ~a     = -11
  a << 1 = 20
  a >> 1 = 5

Expected output:
  a & b  = 8
  a | b  = 14
  a ^ b  = 6
  ~a     = -11
  a << 1 = 20
  a >> 1 = 5
EOF

cat > subjects/lvl25.txt << 'EOF'
=== LEVEL 25 ─ OPERATORS [2/3] : Assignment & Compound ===
FILE: rendu/ft_compound/ft_compound.c

Start with int x = 16. Apply and print after EACH:
  x += 4   -> x += 4  : 20
  x -= 5   -> x -= 5  : 15
  x *= 3   -> x *= 3  : 45
  x /= 9   -> x /= 9  : 5
  x %= 3   -> x %= 3  : 2
  x <<= 2  -> x <<= 2 : 8

Expected output:
  x += 4  : 20
  x -= 5  : 15
  x *= 3  : 45
  x /= 9  : 5
  x %= 3  : 2
  x <<= 2 : 8
EOF

cat > subjects/lvl26.txt << 'EOF'
=== LEVEL 26 ─ OPERATORS [3/3] : Ternary & Precedence ===
FILE: rendu/ft_ternary/ft_ternary.c

Write using ONLY ternary operators:
  const char *ft_classify(int n) -> "negative"/"zero"/"positive"
  int ft_abs(int n)               -> n < 0 ? -n : n

Test:
  ft_classify(-5) -> -5: negative
  ft_classify(0)  -> 0: zero
  ft_classify(3)  -> 3: positive
  ft_abs(-42)     -> abs(-42): 42

Expected output:
  -5: negative
  0: zero
  3: positive
  abs(-42): 42
EOF

cat > subjects/lvl27.txt << 'EOF'
=== LEVEL 27 ─ BOOLEANS [1/3] : Truth Tables ===
FILE: rendu/ft_truth_table/ft_truth_table.c

Include <stdbool.h>. Print the full truth table for &&, ||, !:

Expected output (exact spacing):
  A=0 B=0: AND=0 OR=0  NOT_A=1
  A=0 B=1: AND=0 OR=1  NOT_A=1
  A=1 B=0: AND=0 OR=1  NOT_A=0
  A=1 B=1: AND=1 OR=1  NOT_A=0
EOF

cat > subjects/lvl28.txt << 'EOF'
=== LEVEL 28 ─ BOOLEANS [2/3] : Short-Circuit Evaluation ===
FILE: rendu/ft_shortcircuit/ft_shortcircuit.c

Write two functions with side effects:
  int check_a() { printf("check_a called\n"); return 0; }
  int check_b() { printf("check_b called\n"); return 1; }

Test:
  Print "Test 1:" then evaluate: check_a() && check_b()
  Print "Test 2:" then evaluate: check_b() || check_a()

Expected output:
  Test 1:
  check_a called
  Test 2:
  check_b called

Note: check_b() is NOT called in Test 1 (short-circuit),
      check_a() is NOT called in Test 2 (short-circuit).
EOF

cat > subjects/lvl29.txt << 'EOF'
=== LEVEL 29 ─ BOOLEANS [3/3] : Boolean in Practice ===
FILE: rendu/ft_password/ft_password.c

Write: int ft_is_valid_password(char *password)
Returns 1 if ALL conditions true:
  - Length >= 8
  - Has at least one uppercase letter
  - Has at least one digit
Returns 0 otherwise.

Test:
  "hello"          -> invalid
  "Hello1!!"       -> valid
  "SHORT1A"        -> invalid
  "longbutnodigit" -> invalid

Expected output:
  hello: invalid
  Hello1!!: valid
  SHORT1A: invalid
  longbutnodigit: invalid
EOF

cat > subjects/lvl30.txt << 'EOF'
=== LEVEL 30 ─ IF...ELSE [1/3] : Grade Calculator ===
FILE: rendu/ft_grade/ft_grade.c

Write: char ft_grade(int score)
  score >= 90 -> 'A'
  score >= 80 -> 'B'
  score >= 70 -> 'C'
  score >= 60 -> 'D'
  else        -> 'F'

Expected output:
  95: A
  83: B
  71: C
  65: D
  40: F
EOF

cat > subjects/lvl31.txt << 'EOF'
=== LEVEL 31 ─ IF...ELSE [2/3] : FizzBuzz ===
FILE: rendu/ft_fizzbuzz/ft_fizzbuzz.c

FizzBuzz from 1 to 20.

Expected output (first 8 lines shown, all 20 required):
  1
  2
  Fizz
  4
  Buzz
  Fizz
  7
  8

Tip: Check divisible by 15 (FizzBuzz) BEFORE 3 or 5 alone!
EOF

cat > subjects/lvl32.txt << 'EOF'
=== LEVEL 32 ─ IF...ELSE [3/3] : Leap Year ===
FILE: rendu/ft_leap/ft_leap.c

Write: int ft_is_leap(int year)
Rules:
  - Divisible by 4   -> leap
  - EXCEPT divisible by 100 -> NOT leap
  - EXCEPT divisible by 400 -> IS leap

Expected output:
  2000: leap
  1900: not leap
  2024: leap
  2023: not leap
EOF

cat > subjects/lvl33.txt << 'EOF'
=== LEVEL 33 ─ SWITCH [1/3] : Calculator ===
FILE: rendu/ft_calc/ft_calc.c

Write: int ft_calc(int a, char op, int b)
Switch on op: '+' '-' '*' '/'
Return 0 for division by zero.

Expected output:
  10 + 3 = 13
  10 - 3 = 7
  10 * 3 = 30
  10 / 3 = 3
  10 / 0 = 0
EOF

cat > subjects/lvl34.txt << 'EOF'
=== LEVEL 34 ─ SWITCH [2/3] : Fall-Through ===
FILE: rendu/ft_chartype/ft_chartype.c

Write ft_char_type(char c) using intentional fall-through for vowels.
  'a','e','i','o','u' -> vowel
  other a-z           -> consonant
  0-9                 -> digit
  else                -> other

Expected output:
  a: vowel
  b: consonant
  5: digit
  !: other
EOF

cat > subjects/lvl35.txt << 'EOF'
=== LEVEL 35 ─ SWITCH [3/3] : State Machine ===
FILE: rendu/ft_statemachine/ft_statemachine.c

typedef enum { RED, YELLOW, GREEN } t_light;

Write: t_light next_light(t_light current)
Cycle: RED -> GREEN -> YELLOW -> RED

Simulate 6 transitions starting from RED.
Print the current light BEFORE each transition.

Expected output (exactly):
  RED
  GREEN
  YELLOW
  RED
  GREEN
  YELLOW
EOF

cat > subjects/lvl36.txt << 'EOF'
=== LEVEL 36 ─ WHILE LOOP [1/3] : Collatz Conjecture ===
FILE: rendu/ft_collatz/ft_collatz.c

Collatz from n = 6:
  If even: n = n / 2
  If odd:  n = n * 3 + 1
Print each value until you reach 1.
Then print: Steps: X (count transitions, not the starting number)

Expected output:
  6
  3
  10
  5
  16
  8
  4
  2
  1
  Steps: 8
EOF

cat > subjects/lvl37.txt << 'EOF'
=== LEVEL 37 ─ WHILE LOOP [2/3] : do...while Validation ===
FILE: rendu/ft_dowhile/ft_dowhile.c

Using do...while, process values: {-1, 0, 200, 50, -5, 42}
Print "Valid: X" if 1-100 inclusive, else "Invalid: X"

Expected output:
  Invalid: -1
  Invalid: 0
  Invalid: 200
  Valid: 50
  Invalid: -5
  Valid: 42
EOF

cat > subjects/lvl38.txt << 'EOF'
=== LEVEL 38 ─ WHILE LOOP [3/3] : Digit Sum & Reverse ===
FILE: rendu/ft_digitsum/ft_digitsum.c

Write:
  int ft_digit_sum(int n)  -- sum of all digits
  int ft_reverse(int n)    -- reverse the digits

Expected output:
  digit_sum(12345)  = 15
  digit_sum(9999)   = 36
  ft_reverse(12345) = 54321
  ft_reverse(100)   = 1
EOF

cat > subjects/lvl39.txt << 'EOF'
=== LEVEL 39 ─ FOR LOOP [1/3] : Fibonacci Sequence ===
FILE: rendu/ft_fibonacci/ft_fibonacci.c

Print first 10 Fibonacci numbers, space-separated, newline at end.

Expected output (exact):
  0 1 1 2 3 5 8 13 21 34
EOF

cat > subjects/lvl40.txt << 'EOF'
=== LEVEL 40 ─ FOR LOOP [2/3] : Nested Loops & Patterns ===
FILE: rendu/ft_patterns/ft_patterns.c

Print a right-triangle (growing) then inverted triangle (shrinking):

Expected output (exactly):
  *
  **
  ***
  ****
  *****
  *****
  ****
  ***
  **
  *
EOF

cat > subjects/lvl41.txt << 'EOF'
=== LEVEL 41 ─ FOR LOOP [3/3] : Prime Number Sieve ===
FILE: rendu/ft_prime/ft_prime.c

Write: int ft_is_prime(int n)
Print all primes from 2 to 50 (space-separated), then the count.

Expected output:
  2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
  Count: 15
EOF

cat > subjects/lvl42.txt << 'EOF'
=== LEVEL 42 ─ BREAK/CONTINUE [1/3] : Search & Stop ===
FILE: rendu/ft_find/ft_find.c

Write: int ft_find(int *arr, int size, int target)
Returns the index, or -1 if not found. Use break to stop early.

arr = {5, 12, 3, 8, 42, 7, 19}

Expected output:
  Find 8:  Found at index 3
  Find 42: Found at index 4
  Find 99: Not found
EOF

cat > subjects/lvl43.txt << 'EOF'
=== LEVEL 43 ─ BREAK/CONTINUE [2/3] : Filter with Continue ===
FILE: rendu/ft_filter/ft_filter.c

Process {-3, 7, -1, 0, 5, -8, 2, 9, -4, 6}:
  Skip negatives and zero with continue.
  Print index (0-based) and value for positives.
  Print sum of positives at end.

Expected output:
  [1]: 7
  [4]: 5
  [6]: 2
  [7]: 9
  [9]: 6
  Sum of positives: 29
EOF

cat > subjects/lvl44.txt << 'EOF'
=== LEVEL 44 ─ BREAK/CONTINUE [3/3] : Nested Loop Control ===
FILE: rendu/ft_nested/ft_nested.c

Print pairs (i,j) where i and j are 1-5 and i*j is a perfect square.
Include <math.h>, compile with -lm.

Hint: sqrt(n) is an integer if (int)sqrt(n)*(int)sqrt(n) == n

Expected output:
  (1,1)=1
  (1,4)=4
  (2,2)=4
  (3,3)=9
  (4,4)=16
  (5,5)=25
EOF

cat > subjects/lvl45.txt << 'EOF'
=== LEVEL 45 ─ ARRAYS [1/3] : Array Statistics ===
FILE: rendu/ft_stats/ft_stats.c

arr[] = {4, 7, 2, 9, 1, 5, 8, 3, 6, 10}
Write:
  int   ft_min(int *arr, int n)
  int   ft_max(int *arr, int n)
  int   ft_sum(int *arr, int n)
  float ft_avg(int *arr, int n)

Expected output:
  Min: 1
  Max: 10
  Sum: 55
  Avg: 5.50
EOF

cat > subjects/lvl46.txt << 'EOF'
=== LEVEL 46 ─ ARRAYS [2/3] : Bubble Sort ===
FILE: rendu/ft_bubblesort/ft_bubblesort.c

Implement: void ft_bubble_sort(int *arr, int n)
Sort {64, 34, 25, 12, 22, 11, 90} in ascending order.

Expected output:
  Before: 64 34 25 12 22 11 90
  After:  11 12 22 25 34 64 90
EOF

cat > subjects/lvl47.txt << 'EOF'
=== LEVEL 47 ─ ARRAYS [3/3] : 2D Arrays & Matrix ===
FILE: rendu/ft_matrix/ft_matrix.c

int m[3][3] = {{1,2,3},{4,5,6},{7,8,9}};

Write:
  void print_matrix(int m[3][3])
  int  matrix_sum(int m[3][3])       -- sum of all elements
  int  matrix_trace(int m[3][3])     -- sum of diagonal (1+5+9)

Expected output:
  1 2 3
  4 5 6
  7 8 9
  Sum: 45
  Trace: 15
EOF

cat > subjects/lvl48.txt << 'EOF'
=== LEVEL 48 ─ STRINGS [1/3] : String Functions from Scratch ===
FILE: rendu/ft_strfuncs/ft_strfuncs.c

WITHOUT <string.h>, implement:
  int   ft_strlen(char *s)
  char *ft_strcpy(char *dst, char *src)
  int   ft_strcmp(char *s1, char *s2)
  char *ft_strchr(char *s, char c)

Expected output:
  strlen: 5
  strcpy: world
  strcmp equal: 0
  strcmp diff: nonzero
  strchr: llo
EOF

cat > subjects/lvl49.txt << 'EOF'
=== LEVEL 49 ─ STRINGS [2/3] : String Manipulation ===
FILE: rendu/ft_strmanip/ft_strmanip.c

Implement:
  void ft_toupper_str(char *s)    -- in-place uppercase
  void ft_tolower_str(char *s)    -- in-place lowercase
  void ft_reverse_str(char *s)    -- in-place reverse
  int  ft_count_words(char *s)    -- count space-separated words

Expected output:
  upper: HELLO WORLD
  lower: hello world
  reverse: edcba
  words: 4
EOF

cat > subjects/lvl50.txt << 'EOF'
=== LEVEL 50 ─ STRINGS [3/3] : Number <-> String Conversion ===
FILE: rendu/ft_numconv/ft_numconv.c

Implement:
  int   ft_atoi(char *s)   -- string to int
  char *ft_itoa(int n)     -- int to string (malloc allowed)

Expected output:
  atoi("42"):    42
  atoi("-100"):  -100
  atoi("0"):     0
  itoa(12345):   12345
  itoa(-7):      -7
EOF

cat > subjects/lvl51.txt << 'EOF'
=== LEVEL 51 ─ USER INPUT [1/3] : read() Buffer ===
FILE: rendu/ft_readbuf/ft_readbuf.c

Using ONLY read() and write():
  Read up to 32 chars from stdin.
  Null-terminate the buffer.
  Strip trailing newline if present.
  Print: "You entered: " followed by the string.

Test with piped input: echo "Hello42" | ./ft_readbuf

Expected output:
  You entered: Hello42
EOF

cat > subjects/lvl52.txt << 'EOF'
=== LEVEL 52 ─ USER INPUT [2/3] : Parsing Input ===
FILE: rendu/ft_parseinput/ft_parseinput.c

Read a line from stdin, count uppercase, lowercase, digits, spaces.
Test input: "Hello World 42"

Expected output:
  Uppercase: 2
  Lowercase: 8
  Digits: 2
  Spaces: 2
EOF

cat > subjects/lvl53.txt << 'EOF'
=== LEVEL 53 ─ USER INPUT [3/3] : Multi-line Reader ===
FILE: rendu/ft_multiline/ft_multiline.c

Read exactly 3 lines from stdin using a loop with read().
For each line print: "Line N (len=X): content"
(length excludes the newline)

Test with: printf "hello\nworld\n42\n"

Expected output:
  Line 1 (len=5): hello
  Line 2 (len=5): world
  Line 3 (len=2): 42
EOF

cat > subjects/lvl54.txt << 'EOF'
=== LEVEL 54 ─ MEMORY ADDRESS [1/3] : Address Explorer ===
FILE: rendu/ft_memaddr/ft_memaddr.c

Print addresses of:
  - A global variable   (label: global)
  - A stack variable    (label: stack)
  - A heap variable     (label: heap, use malloc)
Free the heap allocation.

Expected output format (addresses will vary):
  global: 0x[hex address]
  stack:  0x[hex address]
  heap:   0x[hex address]

Tip: printf("global: %p\n", (void*)&g);
EOF

cat > subjects/lvl55.txt << 'EOF'
=== LEVEL 55 ─ MEMORY ADDRESS [2/3] : Pass by Reference ===
FILE: rendu/ft_passref/ft_passref.c

Demonstrate pass-by-value vs pass-by-reference:
  void double_val(int n)   -- modifies local copy only
  void double_ref(int *n)  -- modifies caller's variable

Start with x = 5.

Expected output:
  After double_val: 5
  After double_ref: 10
EOF

cat > subjects/lvl56.txt << 'EOF'
=== LEVEL 56 ─ MEMORY ADDRESS [3/3] : ft_swap via Pointers ===
FILE: rendu/ft_swapptr/ft_swapptr.c

Write:
  void ft_swap(int *a, int *b)
  void ft_swap_str(char **a, char **b)

Expected output:
  Before swap: a=10, b=20
  After swap:  a=20, b=10
  Before swap: s1=hello, s2=world
  After swap:  s1=world, s2=hello
EOF

cat > subjects/lvl57.txt << 'EOF'
=== LEVEL 57 ─ POINTERS [1/3] : Pointer Arithmetic ===
FILE: rendu/ft_ptrarith/ft_ptrarith.c

Navigate int arr[] = {10,20,30,40,50} using ONLY pointer arithmetic.
(No arr[i] subscript allowed)

Expected output:
  *p     = 10
  *(p+1) = 20
  *(p+2) = 30
  *(p+3) = 40
  *(p+4) = 50
  int units apart:  1
  bytes apart:      4
EOF

cat > subjects/lvl58.txt << 'EOF'
=== LEVEL 58 ─ POINTERS [2/3] : Pointer to Pointer ===
FILE: rendu/ft_ptrtoptr/ft_ptrtoptr.c

  int x = 42;
  int *p = &x;
  int **pp = &p;

Print all three ways to access x, then modify x through **pp.

Expected output:
  x    = 42
  *p   = 42
  **pp = 42
  After **pp = 99: x = 99
EOF

cat > subjects/lvl59.txt << 'EOF'
=== LEVEL 59 ─ POINTERS [3/3] ★ FINAL BOSS ★ ===
FILE: rendu/ft_funcptr/ft_funcptr.c

Part 1 — Function pointer dispatch table:
  int ft_add(int a, int b)  { return a + b; }
  int ft_sub(int a, int b)  { return a - b; }
  int ft_mul(int a, int b)  { return a * b; }

  Store them in an array of function pointers and call each.

Part 2 — ft_map:
  void ft_map(int *arr, int n, int (*f)(int))
  Apply a doubling function to {1,2,3,4,5}.

Expected output:
  ft_add(10, 3) = 13
  ft_sub(10, 3) = 7
  ft_mul(10, 3) = 30
  2 4 6 8 10

  You have completed the C Mastery Exam. You are ready.
EOF

}  # end generate_subjects

# ══════════════════════════════════════════════════════════════════
#  EXPECTED OUTPUT MAP  (all 60 levels)
# ══════════════════════════════════════════════════════════════════
get_expected() {
    local lvl=$1
    case $lvl in
        0)  printf "Hello, C World!" ;;
        1)  printf "Program starting\nProgram done" ;;
        2)  printf "1. Preprocessing\n2. Compilation\n3. Assembly\n4. Linking" ;;
        3)  printf "Syntax is power" ;;
        4)  printf "Hello\nGoodbye" ;;
        5)  printf "Result: 15" ;;
        6)  printf "*** HEADER ***\n\nContent here\n\n*** FOOTER ***" ;;
        7)  printf "0\n42\n-7\n100" ;;
        8)  printf "a b c d e f g h i j k l m n o p q r s t u v w x y z\n0 1 2 3 4 5 6 7 8 9" ;;
        9)  printf "Comments guide future you" ;;
        10) printf "Length: 5\nIsAlpha: 0\nIsAlpha: 1" ;;
        11) printf "Sum: 10" ;;
        12) printf "letter: X\ncount: 2025\npi_approx: 3.14\nprecise: 2.718282" ;;
        13) printf "local g = 999\nglobal g = 100" ;;
        14) printf "Before: a=5, b=9\nAfter:  a=9, b=5" ;;
        15) printf "char:      1 bytes\nint:       4 bytes\nfloat:     4 bytes\ndouble:    8 bytes" ;;
        16) printf "INT_MAX:  2147483647\nINT_MIN:  -2147483648\nCHAR_MAX: 127\nCHAR_MIN: -128\nOverflow result: -2147483648" ;;
        17) printf "signed char:   -1\nunsigned char: 255\nunsigned underflow: 4294967295" ;;
        18) printf "char from int: A\nint from char: 122\nint division stored as double: 2.000000\ncast before division: 2.500000" ;;
        19) printf "1 of 3   = 33%%\n2 of 3   = 66%%\n1 of 4   = 25%%\n3 of 4   = 75%%\n1 of 7   = 14%%" ;;
        20) printf "A -> a\nM -> m\nZ -> z\n'5' -> 5\n'9' -> 9" ;;
        21) printf "BUFFER_SIZE: 1024\nPI: 3.14159265\nMAX_USERS: 100\nSEPARATOR: -" ;;
        22) printf "1: Monday\n2: Tuesday\n3: Wednesday\n4: Thursday\n5: Friday\n6: Saturday\n7: Sunday" ;;
        23) printf "MAX(3, 7)   = 7\nMIN(3, 7)   = 3\nABS(-5)     = 5\nSQUARE(4)   = 16" ;;
        24) printf "a & b  = 8\na | b  = 14\na ^ b  = 6\n~a     = -11\na << 1 = 20\na >> 1 = 5" ;;
        25) printf "x += 4  : 20\nx -= 5  : 15\nx *= 3  : 45\nx /= 9  : 5\nx %%= 3  : 2\nx <<= 2 : 8" ;;
        26) printf "-5: negative\n0: zero\n3: positive\nabs(-42): 42" ;;
        27) printf "A=0 B=0: AND=0 OR=0  NOT_A=1\nA=0 B=1: AND=0 OR=1  NOT_A=1\nA=1 B=0: AND=0 OR=1  NOT_A=0\nA=1 B=1: AND=1 OR=1  NOT_A=0" ;;
        28) printf "Test 1:\ncheck_a called\nTest 2:\ncheck_b called" ;;
        29) printf "hello: invalid\nHello1!!: valid\nSHORT1A: invalid\nlongbutnodigit: invalid" ;;
        30) printf "95: A\n83: B\n71: C\n65: D\n40: F" ;;
        31) printf "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz" ;;
        32) printf "2000: leap\n1900: not leap\n2024: leap\n2023: not leap" ;;
        33) printf "10 + 3 = 13\n10 - 3 = 7\n10 * 3 = 30\n10 / 3 = 3\n10 / 0 = 0" ;;
        34) printf "a: vowel\nb: consonant\n5: digit\n!: other" ;;
        35) printf "RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW" ;;
        36) printf "6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8" ;;
        37) printf "Invalid: -1\nInvalid: 0\nInvalid: 200\nValid: 50\nInvalid: -5\nValid: 42" ;;
        38) printf "digit_sum(12345)  = 15\ndigit_sum(9999)   = 36\nft_reverse(12345) = 54321\nft_reverse(100)   = 1" ;;
        39) printf "0 1 1 2 3 5 8 13 21 34" ;;
        40) printf "*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*" ;;
        41) printf "2 3 5 7 11 13 17 19 23 29 31 37 41 43 47\nCount: 15" ;;
        42) printf "Find 8:  Found at index 3\nFind 42: Found at index 4\nFind 99: Not found" ;;
        43) printf "[1]: 7\n[4]: 5\n[6]: 2\n[7]: 9\n[9]: 6\nSum of positives: 29" ;;
        44) printf "(1,1)=1\n(1,4)=4\n(2,2)=4\n(3,3)=9\n(4,4)=16\n(5,5)=25" ;;
        45) printf "Min: 1\nMax: 10\nSum: 55\nAvg: 5.50" ;;
        46) printf "Before: 64 34 25 12 22 11 90\nAfter:  11 12 22 25 34 64 90" ;;
        47) printf "1 2 3\n4 5 6\n7 8 9\nSum: 45\nTrace: 15" ;;
        48) printf "strlen: 5\nstrcpy: world\nstrcmp equal: 0\nstrcmp diff: nonzero\nstrchr: llo" ;;
        49) printf "upper: HELLO WORLD\nlower: hello world\nreverse: edcba\nwords: 4" ;;
        50) printf 'atoi("42"):    42\natoi("-100"):  -100\natoi("0"):     0\nitoa(12345):   12345\nitoa(-7):      -7' ;;
        51) printf "You entered: Hello42" ;;
        52) printf "Uppercase: 2\nLowercase: 8\nDigits: 2\nSpaces: 2" ;;
        53) printf "Line 1 (len=5): hello\nLine 2 (len=5): world\nLine 3 (len=2): 42" ;;
        54) printf "global: 0x[addr]\nstack:  0x[addr]\nheap:   0x[addr]" ;;
        55) printf "After double_val: 5\nAfter double_ref: 10" ;;
        56) printf "Before swap: a=10, b=20\nAfter swap:  a=20, b=10\nBefore swap: s1=hello, s2=world\nAfter swap:  s1=world, s2=hello" ;;
        57) printf "*p     = 10\n*(p+1) = 20\n*(p+2) = 30\n*(p+3) = 40\n*(p+4) = 50\nint units apart:  1\nbytes apart:      4" ;;
        58) printf "x    = 42\n*p   = 42\n**pp = 42\nAfter **pp = 99: x = 99" ;;
        59) printf "ft_add(10, 3) = 13\nft_sub(10, 3) = 7\nft_mul(10, 3) = 30\n2 4 6 8 10\n\nYou have completed the C Mastery Exam. You are ready." ;;
        *)  printf "" ;;
    esac
}

# ══════════════════════════════════════════════════════════════════
#  DIFF DISPLAY
# ══════════════════════════════════════════════════════════════════
show_diff() {
    local expected="$1"
    local got="$2"
    local lvl="$3"

    # levels with dynamic output (addresses vary) — skip line diff
    if [ "$lvl" -eq 54 ]; then
        echo -e "  ${YELLOW}Note:${RESET} Addresses vary per run — checking label format only."
        echo -e "  ${BOLD}Expected format:${RESET}"
        echo -e "    ${GREEN}global: 0x...${RESET}"
        echo -e "    ${GREEN}stack:  0x...${RESET}"
        echo -e "    ${GREEN}heap:   0x...${RESET}"
        echo ""
        return
    fi

    echo -e "  ${BOLD}${CYAN}┌─────────────────────────────────────────────────────────┐${RESET}"
    printf  "  ${CYAN}│${RESET}  ${BOLD}%-24s${RESET}  ${BOLD}%-24s${RESET}  ${CYAN}│${RESET}\n" "EXPECTED" "YOUR OUTPUT"
    echo -e "  ${CYAN}├──────────────────────────────┬──────────────────────────┤${RESET}"

    local exp_line got_line match idx
    idx=0
    # iterate over expected lines
    while IFS= read -r exp_line; do
        idx=$(( idx + 1 ))
        got_line=$(echo "$got" | sed -n "${idx}p")
        if [ "$exp_line" = "$got_line" ]; then
            match="${GREEN}✓${RESET}"
            printf "  ${CYAN}│${RESET}  ${GREEN}%-28s${RESET}${CYAN}│${RESET}  ${GREEN}%-24s${RESET}  ${CYAN}│${RESET} %b\n" \
                "${exp_line:0:28}" "${got_line:0:24}" "$match"
        else
            match="${RED}✗${RESET}"
            # truncate long lines for display
            local e_disp="${exp_line:0:28}"
            local g_disp="${got_line:0:24}"
            printf "  ${CYAN}│${RESET}  ${GREEN}%-28s${RESET}${CYAN}│${RESET}  ${RED}%-24s${RESET}  ${CYAN}│${RESET} %b\n" \
                "$e_disp" "${g_disp:-(empty)}" "$match"
        fi
    done <<< "$expected"

    # check if got has EXTRA lines beyond expected
    local exp_lines got_lines
    exp_lines=$(echo "$expected" | wc -l | tr -d ' ')
    got_lines=$(echo "$got" | wc -l | tr -d ' ')
    if [ "$got_lines" -gt "$exp_lines" ]; then
        local extra=$(( got_lines - exp_lines ))
        for i in $(seq 1 $extra); do
            local extra_line=$(echo "$got" | sed -n "$(( exp_lines + i ))p")
            printf "  ${CYAN}│${RESET}  ${GRAY}%-28s${RESET}${CYAN}│${RESET}  ${RED}%-24s${RESET}  ${CYAN}│${RESET} %b\n" \
                "(unexpected)" "${extra_line:0:24}" "${RED}✗${RESET}"
        done
    fi

    echo -e "  ${CYAN}└──────────────────────────────┴──────────────────────────┘${RESET}"

    # line count mismatch summary
    if [ "$exp_lines" -ne "$got_lines" ]; then
        echo -e "  ${RED}Line count: expected ${exp_lines}, got ${got_lines}${RESET}"
    fi

    # char-level hint on first mismatched line
    local first_exp first_got
    local lidx=0
    while IFS= read -r exp_line; do
        lidx=$(( lidx + 1 ))
        first_got=$(echo "$got" | sed -n "${lidx}p")
        if [ "$exp_line" != "$first_got" ]; then
            first_exp="$exp_line"
            break
        fi
    done <<< "$expected"

    if [ -n "$first_exp" ]; then
        echo ""
        echo -e "  ${BOLD}First difference on line ${lidx}:${RESET}"
        # find char position
        local pos=0
        local elen=${#first_exp}
        local glen=${#first_got}
        local maxlen=$(( elen > glen ? elen : glen ))
        for (( c=0; c<maxlen; c++ )); do
            if [ "${first_exp:$c:1}" != "${first_got:$c:1}" ]; then
                pos=$c
                break
            fi
            pos=$(( c + 1 ))
        done
        local exp_char="${first_exp:$pos:1}"
        local got_char="${first_got:$pos:1}"
        [ -z "$exp_char" ] && exp_char="(end)"
        [ -z "$got_char" ] && got_char="(end)"
        echo -e "  Expected char at pos $pos: ${GREEN}'${exp_char}'${RESET}"
        echo -e "  Got char at pos $pos     : ${RED}'${got_char}'${RESET}"
        # show arrow under the difference
        local arrow="$(printf '%*s' $pos '')^"
        echo -e "  ${GREEN}${first_exp}${RESET}"
        echo -e "  ${RED}${first_got}${RESET}"
        echo -e "  ${YELLOW}${arrow}${RESET}"
    fi
    echo ""
}

# ══════════════════════════════════════════════════════════════════
#  GRADER
# ══════════════════════════════════════════════════════════════════
grade_me() {
    local LEVEL
    LEVEL=$(get_level)
    local FNAME
    FNAME=$(get_filename "$LEVEL")
    local DNAME
    DNAME=$(get_dirname "$LEVEL")
    local TASK_DIR="rendu/$DNAME"
    local TRACE="traces/trace_${DNAME}.txt"
    mkdir -p "$TASK_DIR"

    echo ""
    echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────────────────────┐${RESET}"
    printf   "${CYAN}│${RESET}  ${BOLD}Grading Level %-3s${RESET}  File: ${WHITE}%-28s${RESET}${CYAN}│${RESET}\n" "$LEVEL" "$FNAME"
    echo -e "${BOLD}${CYAN}└─────────────────────────────────────────────────────────┘${RESET}"

    local SRC="$TASK_DIR/$FNAME"
    if [ ! -f "$SRC" ]; then
        echo -e "${RED}  ✗ ERROR:${RESET} $SRC not found."
        echo -e "  Create your file there and run ${BOLD}grademe${RESET} again."
        return 1
    fi

    echo -ne "${GRAY}  Compiling...${RESET}"
    gcc -Wall -Wextra -Werror "$SRC" -o eval_bin -lm 2>"$TRACE"
    if [ $? -ne 0 ]; then
        echo -e "\r${RED}  ✗ COMPILE ERROR${RESET}"
        echo ""
        cat "$TRACE"
        echo -e "${GRAY}  Trace saved: $TRACE${RESET}"
        return 1
    fi
    echo -e "\r${GREEN}  ✓ Compiled OK${RESET}"

    local PASS=0
    local OUTPUT=""

    case $LEVEL in
        0)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Hello, C World!" ]] && PASS=1 ;;

        1)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Program starting" &&
            echo "$OUTPUT" | grep -q "Program done" && PASS=1 ;;

        2)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Preprocessing" &&
            echo "$OUTPUT" | grep -q "Compilation" &&
            echo "$OUTPUT" | grep -q "Assembly" &&
            echo "$OUTPUT" | grep -q "Linking" && PASS=1 ;;

        3)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Syntax is power" ]] && PASS=1 ;;

        4)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Hello" &&
            echo "$OUTPUT" | grep -q "Goodbye" && PASS=1 ;;

        5)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Result: 15" ]] && PASS=1 ;;

        6)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "HEADER" &&
            echo "$OUTPUT" | grep -q "Content here" &&
            echo "$OUTPUT" | grep -q "FOOTER" && PASS=1 ;;

        7)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qx "0" &&
            echo "$OUTPUT" | grep -qx "42" &&
            echo "$OUTPUT" | grep -qx "\-7" &&
            echo "$OUTPUT" | grep -qx "100" && PASS=1 ;;

        8)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "^a b c d e f" &&
            echo "$OUTPUT" | grep -q "^0 1 2 3 4 5" && PASS=1 ;;

        9)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Comments guide future you" ]] && PASS=1 ;;

        10) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Length: 5" &&
            echo "$OUTPUT" | grep -q "IsAlpha: 0" &&
            echo "$OUTPUT" | grep -q "IsAlpha: 1" && PASS=1 ;;

        11) OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Sum: 10" ]] && PASS=1 ;;

        12) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "letter: X" &&
            echo "$OUTPUT" | grep -q "count: 2025" &&
            echo "$OUTPUT" | grep -q "pi_approx: 3.14" &&
            echo "$OUTPUT" | grep -q "precise: 2.718282" && PASS=1 ;;

        13) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "local g = 999" &&
            echo "$OUTPUT" | grep -q "global g = 100" && PASS=1 ;;

        14) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Before: a=5, b=9" &&
            echo "$OUTPUT" | grep -q "After:  a=9, b=5" && PASS=1 ;;

        15) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "char:" &&
            echo "$OUTPUT" | grep -q "int:" &&
            echo "$OUTPUT" | grep -q "float:" &&
            echo "$OUTPUT" | grep -q "double:" && PASS=1 ;;

        16) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "INT_MAX:  2147483647" &&
            echo "$OUTPUT" | grep -q "INT_MIN:  -2147483648" &&
            echo "$OUTPUT" | grep -q "CHAR_MAX: 127" &&
            echo "$OUTPUT" | grep -q "CHAR_MIN: -128" &&
            echo "$OUTPUT" | grep -q "Overflow result: -2147483648" && PASS=1 ;;

        17) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "signed char:   -1" &&
            echo "$OUTPUT" | grep -q "unsigned char: 255" &&
            echo "$OUTPUT" | grep -q "unsigned underflow: 4294967295" && PASS=1 ;;

        18) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "char from int: A" &&
            echo "$OUTPUT" | grep -q "int from char: 122" &&
            echo "$OUTPUT" | grep -q "2.000000" &&
            echo "$OUTPUT" | grep -q "2.500000" && PASS=1 ;;

        19) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "1 of 3   = 33%" &&
            echo "$OUTPUT" | grep -q "2 of 3   = 66%" &&
            echo "$OUTPUT" | grep -q "1 of 4   = 25%" &&
            echo "$OUTPUT" | grep -q "3 of 4   = 75%" &&
            echo "$OUTPUT" | grep -q "1 of 7   = 14%" && PASS=1 ;;

        20) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "A -> a" &&
            echo "$OUTPUT" | grep -q "M -> m" &&
            echo "$OUTPUT" | grep -q "Z -> z" &&
            echo "$OUTPUT" | grep -q "'5' -> 5" &&
            echo "$OUTPUT" | grep -q "'9' -> 9" && PASS=1 ;;

        21) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "BUFFER_SIZE: 1024" &&
            echo "$OUTPUT" | grep -q "PI: 3.14159265" &&
            echo "$OUTPUT" | grep -q "MAX_USERS: 100" &&
            echo "$OUTPUT" | grep -q "SEPARATOR: -" && PASS=1 ;;

        22) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "1: Monday" &&
            echo "$OUTPUT" | grep -q "2: Tuesday" &&
            echo "$OUTPUT" | grep -q "3: Wednesday" &&
            echo "$OUTPUT" | grep -q "7: Sunday" && PASS=1 ;;

        23) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "MAX(3, 7)   = 7" &&
            echo "$OUTPUT" | grep -q "MIN(3, 7)   = 3" &&
            echo "$OUTPUT" | grep -q "ABS(-5)     = 5" &&
            echo "$OUTPUT" | grep -q "SQUARE(4)   = 16" && PASS=1 ;;

        24) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "a & b  = 8" &&
            echo "$OUTPUT" | grep -q "a | b  = 14" &&
            echo "$OUTPUT" | grep -q "a ^ b  = 6" &&
            echo "$OUTPUT" | grep -q "~a     = -11" &&
            echo "$OUTPUT" | grep -q "a << 1 = 20" &&
            echo "$OUTPUT" | grep -q "a >> 1 = 5" && PASS=1 ;;

        25) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "x += 4  : 20" &&
            echo "$OUTPUT" | grep -q "x -= 5  : 15" &&
            echo "$OUTPUT" | grep -q "x *= 3  : 45" &&
            echo "$OUTPUT" | grep -q "x /= 9  : 5" &&
            echo "$OUTPUT" | grep -q "x %= 3  : 2" &&
            echo "$OUTPUT" | grep -q "x <<= 2 : 8" && PASS=1 ;;

        26) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "negative" &&
            echo "$OUTPUT" | grep -q "zero" &&
            echo "$OUTPUT" | grep -q "positive" &&
            echo "$OUTPUT" | grep -q "abs(-42): 42" && PASS=1 ;;

        27) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qF "A=0 B=0: AND=0 OR=0  NOT_A=1" &&
            echo "$OUTPUT" | grep -qF "A=0 B=1: AND=0 OR=1  NOT_A=1" &&
            echo "$OUTPUT" | grep -qF "A=1 B=0: AND=0 OR=1  NOT_A=0" &&
            echo "$OUTPUT" | grep -qF "A=1 B=1: AND=1 OR=1  NOT_A=0" && PASS=1 ;;

        28) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "check_a called" &&
            echo "$OUTPUT" | grep -q "check_b called" &&
            # check_b must NOT appear under Test 1 AND check_a must NOT under Test 2
            ! (echo "$OUTPUT" | grep -A2 "Test 1:" | grep -q "check_b called") &&
            ! (echo "$OUTPUT" | grep -A2 "Test 2:" | grep -q "check_a called") && PASS=1 ;;

        29) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "hello: invalid" &&
            echo "$OUTPUT" | grep -q "Hello1!!: valid" &&
            echo "$OUTPUT" | grep -q "SHORT1A: invalid" &&
            echo "$OUTPUT" | grep -q "longbutnodigit: invalid" && PASS=1 ;;

        30) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "95: A" &&
            echo "$OUTPUT" | grep -q "83: B" &&
            echo "$OUTPUT" | grep -q "71: C" &&
            echo "$OUTPUT" | grep -q "65: D" &&
            echo "$OUTPUT" | grep -q "40: F" && PASS=1 ;;

        31) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Fizz" &&
            echo "$OUTPUT" | grep -q "Buzz" &&
            echo "$OUTPUT" | grep -q "FizzBuzz" &&
            # Verify line 3 is Fizz (number 3), line 5 is Buzz
            [[ "$(echo "$OUTPUT" | sed -n '3p')" == "Fizz" ]] &&
            [[ "$(echo "$OUTPUT" | sed -n '5p')" == "Buzz" ]] &&
            [[ "$(echo "$OUTPUT" | sed -n '15p')" == "FizzBuzz" ]] && PASS=1 ;;

        32) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "2000: leap" &&
            echo "$OUTPUT" | grep -q "1900: not leap" &&
            echo "$OUTPUT" | grep -q "2024: leap" &&
            echo "$OUTPUT" | grep -q "2023: not leap" && PASS=1 ;;

        33) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "10 + 3 = 13" &&
            echo "$OUTPUT" | grep -q "10 - 3 = 7" &&
            echo "$OUTPUT" | grep -q "10 \* 3 = 30" &&
            echo "$OUTPUT" | grep -q "10 / 3 = 3" &&
            echo "$OUTPUT" | grep -q "10 / 0 = 0" && PASS=1 ;;

        34) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "a: vowel" &&
            echo "$OUTPUT" | grep -q "b: consonant" &&
            echo "$OUTPUT" | grep -q "5: digit" &&
            echo "$OUTPUT" | grep -q "!: other" && PASS=1 ;;

        35) OUTPUT=$(./eval_bin 2>/dev/null)
            local EXPECTED
            EXPECTED=$(printf "RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW")
            [[ "$OUTPUT" == "$EXPECTED" ]] && PASS=1 ;;

        36) OUTPUT=$(./eval_bin 2>/dev/null)
            local EXPECTED
            EXPECTED=$(printf "6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8")
            [[ "$OUTPUT" == "$EXPECTED" ]] && PASS=1 ;;

        37) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Invalid: -1" &&
            echo "$OUTPUT" | grep -q "Invalid: 0" &&
            echo "$OUTPUT" | grep -q "Invalid: 200" &&
            echo "$OUTPUT" | grep -q "Valid: 50" &&
            echo "$OUTPUT" | grep -q "Invalid: -5" &&
            echo "$OUTPUT" | grep -q "Valid: 42" && PASS=1 ;;

        38) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qF "digit_sum(12345)  = 15" &&
            echo "$OUTPUT" | grep -qF "digit_sum(9999)   = 36" &&
            echo "$OUTPUT" | grep -qF "ft_reverse(12345) = 54321" &&
            echo "$OUTPUT" | grep -qF "ft_reverse(100)   = 1" && PASS=1 ;;

        39) OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "0 1 1 2 3 5 8 13 21 34" ]] && PASS=1 ;;

        40) OUTPUT=$(./eval_bin 2>/dev/null)
            local EXPECTED
            EXPECTED=$(printf "*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*")
            [[ "$OUTPUT" == "$EXPECTED" ]] && PASS=1 ;;

        41) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "^2 3 5 7 11 13 17 19 23 29 31 37 41 43 47$" &&
            echo "$OUTPUT" | grep -q "Count: 15" && PASS=1 ;;

        42) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Found at index 3" &&
            echo "$OUTPUT" | grep -q "Found at index 4" &&
            echo "$OUTPUT" | grep -q "Not found" && PASS=1 ;;

        43) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "\[1\]: 7" &&
            echo "$OUTPUT" | grep -q "\[4\]: 5" &&
            echo "$OUTPUT" | grep -q "\[6\]: 2" &&
            echo "$OUTPUT" | grep -q "\[7\]: 9" &&
            echo "$OUTPUT" | grep -q "\[9\]: 6" &&
            echo "$OUTPUT" | grep -q "Sum of positives: 29" && PASS=1 ;;

        44) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "(1,1)=1" &&
            echo "$OUTPUT" | grep -q "(1,4)=4" &&
            echo "$OUTPUT" | grep -q "(2,2)=4" &&
            echo "$OUTPUT" | grep -q "(3,3)=9" &&
            echo "$OUTPUT" | grep -q "(4,4)=16" &&
            echo "$OUTPUT" | grep -q "(5,5)=25" && PASS=1 ;;

        45) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Min: 1" &&
            echo "$OUTPUT" | grep -q "Max: 10" &&
            echo "$OUTPUT" | grep -q "Sum: 55" &&
            echo "$OUTPUT" | grep -q "Avg: 5.50" && PASS=1 ;;

        46) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qF "Before: 64 34 25 12 22 11 90" &&
            echo "$OUTPUT" | grep -qF "After:  11 12 22 25 34 64 90" && PASS=1 ;;

        47) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "^1 2 3$" &&
            echo "$OUTPUT" | grep -q "^4 5 6$" &&
            echo "$OUTPUT" | grep -q "^7 8 9$" &&
            echo "$OUTPUT" | grep -q "Sum: 45" &&
            echo "$OUTPUT" | grep -q "Trace: 15" && PASS=1 ;;

        48) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "strlen: 5" &&
            echo "$OUTPUT" | grep -q "strcpy: world" &&
            echo "$OUTPUT" | grep -q "strcmp equal: 0" &&
            echo "$OUTPUT" | grep -q "strchr: llo" && PASS=1 ;;

        49) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "upper: HELLO WORLD" &&
            echo "$OUTPUT" | grep -q "lower: hello world" &&
            echo "$OUTPUT" | grep -q "reverse: edcba" &&
            echo "$OUTPUT" | grep -q "words: 4" && PASS=1 ;;

        50) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qF 'atoi("42"):    42' &&
            echo "$OUTPUT" | grep -qF 'atoi("-100"):  -100' &&
            echo "$OUTPUT" | grep -qF 'atoi("0"):     0' &&
            echo "$OUTPUT" | grep -qF 'itoa(12345):   12345' &&
            echo "$OUTPUT" | grep -qF 'itoa(-7):      -7' && PASS=1 ;;

        51) OUTPUT=$(echo "Hello42" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "You entered: Hello42" && PASS=1 ;;

        52) OUTPUT=$(printf "Hello World 42\n" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Uppercase: 2" &&
            echo "$OUTPUT" | grep -q "Lowercase: 8" &&
            echo "$OUTPUT" | grep -q "Digits: 2" &&
            echo "$OUTPUT" | grep -q "Spaces: 2" && PASS=1 ;;

        53) OUTPUT=$(printf "hello\nworld\n42\n" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Line 1 (len=5): hello" &&
            echo "$OUTPUT" | grep -q "Line 2 (len=5): world" &&
            echo "$OUTPUT" | grep -q "Line 3 (len=2): 42" && PASS=1 ;;

        54) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "global: 0x" &&
            echo "$OUTPUT" | grep -q "stack:  0x" &&
            echo "$OUTPUT" | grep -q "heap:   0x" && PASS=1 ;;

        55) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "After double_val: 5" &&
            echo "$OUTPUT" | grep -q "After double_ref: 10" && PASS=1 ;;

        56) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Before swap: a=10, b=20" &&
            echo "$OUTPUT" | grep -q "After swap:  a=20, b=10" &&
            echo "$OUTPUT" | grep -q "Before swap: s1=hello, s2=world" &&
            echo "$OUTPUT" | grep -q "After swap:  s1=world, s2=hello" && PASS=1 ;;

        57) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qF "*p     = 10" &&
            echo "$OUTPUT" | grep -qF "*(p+4) = 50" &&
            echo "$OUTPUT" | grep -q "int units apart:  1" &&
            echo "$OUTPUT" | grep -q "bytes apart:      4" && PASS=1 ;;

        58) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "x    = 42" &&
            echo "$OUTPUT" | grep -qF "**pp = 42" &&
            echo "$OUTPUT" | grep -qF "After **pp = 99: x = 99" && PASS=1 ;;

        59) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "ft_add(10, 3) = 13" &&
            echo "$OUTPUT" | grep -q "ft_sub(10, 3) = 7" &&
            echo "$OUTPUT" | grep -q "ft_mul(10, 3) = 30" &&
            echo "$OUTPUT" | grep -q "2 4 6 8 10" &&
            echo "$OUTPUT" | grep -q "You have completed" && PASS=1 ;;

        *)  PASS=1 ;;
    esac

    echo ""
    echo -e "${GRAY}┌── Your output ─────────────────────────────────────────────┐${RESET}"
    echo "$OUTPUT" | while IFS= read -r line; do
        printf "${GRAY}│${RESET} %s\n" "$line"
    done
    echo -e "${GRAY}└────────────────────────────────────────────────────────────┘${RESET}"
    echo ""

    # Save trace
    { echo "=== Level $LEVEL | $(date) ==="; echo "$OUTPUT"; } >> "$TRACE"

    if [ $PASS -eq 1 ]; then
        add_attempt "$LEVEL" "PASS"
        inc_streak
        local SCORE_MSG
        if ! already_passed "$LEVEL"; then
            add_score 1
            mark_passed "$LEVEL"
            SCORE_MSG="  ${GREEN}+1 point awarded!${RESET}  Score: ${BOLD}$(get_score)/60${RESET}"
        else
            SCORE_MSG="  ${GRAY}(already cleared — no extra point)${RESET}"
        fi

        local streak=$(get_streak)
        local streak_msg=""
        [ $streak -ge 3 ] && streak_msg="  ${YELLOW}🔥 ${streak} win streak!${RESET}"
        [ $streak -ge 5 ] && streak_msg="  ${YELLOW}⚡ ${streak} win streak! On fire!${RESET}"

        echo -e "${GREEN}  ╔══════════════════════════════════════════════════════╗${RESET}"
        echo -e "${GREEN}  ║                    ✓  PASS                          ║${RESET}"
        echo -e "${GREEN}  ╚══════════════════════════════════════════════════════╝${RESET}"
        echo ""
        echo -e "${GREEN}  Level ${BOLD}$LEVEL${RESET}${GREEN} cleared!  [ ${WHITE}$FNAME${GREEN} ]${RESET}"
        echo -e "$SCORE_MSG"
        [ -n "$streak_msg" ] && echo -e "$streak_msg"
        auto_save
        echo -e "  ${GRAY}(auto-saved)${RESET}"

        local NEXT=$(( LEVEL + 1 ))
        echo $NEXT > .level

        if [ $NEXT -gt $MAX_LEVEL ]; then
            echo ""
            echo -e "${BOLD}${GREEN}"
            echo "  ╔══════════════════════════════════════════════════════╗"
            echo "  ║          EXAM COMPLETE — C MASTERY ACHIEVED         ║"
            printf "  ║          FINAL SCORE: %-3s / 60                      ║\n" "$(get_score)"
            echo "  ║                                                      ║"
            echo "  ║  Topics mastered:                                    ║"
            echo "  ║  Intro · Syntax · Output · Comments · Variables      ║"
            echo "  ║  Data Types · Type Conv · Constants · Operators      ║"
            echo "  ║  Booleans · If/Else · Switch · While · For           ║"
            echo "  ║  Break/Continue · Arrays · Strings · Input           ║"
            echo "  ║  Memory Addresses · Pointers                         ║"
            echo "  ╚══════════════════════════════════════════════════════╝"
            echo -e "${RESET}"
            rm -f eval_bin
            exit 0
        fi
        echo ""
        read -r -p "  Press Enter for Level $NEXT..." _x < /dev/tty
    else
        add_attempt "$LEVEL" "FAIL"
        reset_streak
        local attempts=$(get_attempts $LEVEL)
        local fails_here=$(get_fails_for $LEVEL)
        local total_fail=$(grep -c ":FAIL:" .attempts 2>/dev/null || echo 0)

        echo -e "${RED}  ╔══════════════════════════════════════════════════════╗${RESET}"
        echo -e "${RED}  ║                    ✗  FAIL                          ║${RESET}"
        echo -e "${RED}  ╚══════════════════════════════════════════════════════╝${RESET}"
        echo ""
        echo -e "  Attempt ${BOLD}#${attempts}${RESET} on level ${BOLD}$LEVEL${RESET}. ${RED}Fails on this level: ${fails_here}${RESET}  |  ${RED}Total fails all-time: ${total_fail}${RESET}"
        echo ""

        # Show full diff for all levels
        local EXPECTED_OUT
        EXPECTED_OUT=$(get_expected "$LEVEL")
        if [ -n "$EXPECTED_OUT" ]; then
            show_diff "$EXPECTED_OUT" "$OUTPUT" "$LEVEL"
        fi

        # Show attempt-based tips
        if [ "$attempts" -eq 1 ]; then
            echo -e "  ${YELLOW}Tip:${RESET} Compare your output letter-by-letter with expected."
        elif [ "$attempts" -eq 2 ]; then
            echo -e "  ${YELLOW}Tip:${RESET} Check for extra spaces, missing newlines, or wrong spelling."
        elif [ "$attempts" -ge 3 ]; then
            echo -e "  ${YELLOW}Tip:${RESET} Type ${CYAN}hint${RESET} to re-read the full subject. $attempts attempts so far."
        fi

        echo ""
        echo -e "  ${BOLD}Next steps:${RESET}"
        echo -e "  · ${CYAN}hint${RESET}         — re-read the subject"
        echo -e "  · ${WHITE}open${RESET}         — open your file in \$EDITOR"
        echo -e "  · ${GRAY}cat $TRACE${RESET}"
        echo ""
        echo -e "  Score: ${BOLD}$(get_score)/60${RESET}   Streak reset to 0."
        echo ""
        sleep 0.3
        read -r -p "  Press Enter to try again..." _x < /dev/tty
    fi
    rm -f eval_bin
}

# ══════════════════════════════════════════════════════════════════
#  SHOW SUBJECT
# ══════════════════════════════════════════════════════════════════
show_subject() {
    local LEVEL
    LEVEL=$(get_level)
    local FILE="subjects/lvl${LEVEL}.txt"
    if [ -f "$FILE" ]; then
        echo ""
        echo -e "${BOLD}${CYAN}══ SUBJECT: Level $LEVEL ══════════════════════════════════${RESET}"
        # Highlight expected output lines
        while IFS= read -r line; do
            if echo "$line" | grep -q "Expected output"; then
                echo -e "${BOLD}${YELLOW}$line${RESET}"
            elif echo "$line" | grep -q "^  Tip:"; then
                echo -e "${CYAN}$line${RESET}"
            elif echo "$line" | grep -q "^  FILE:"; then
                echo -e "${GREEN}$line${RESET}"
            else
                echo "$line"
            fi
        done < "$FILE"
        echo ""
    fi
}

# ══════════════════════════════════════════════════════════════════
#  GOTO COMMAND (jump to a specific level)
# ══════════════════════════════════════════════════════════════════
goto_level() {
    local target=$1
    if [[ ! "$target" =~ ^[0-9]+$ ]] || [ "$target" -gt $MAX_LEVEL ]; then
        echo -e "${RED}  Invalid level. Use 0-$MAX_LEVEL${RESET}"
        return
    fi
    echo "$target" > .level
    echo -e "  ${YELLOW}Jumped to level $target.${RESET}"
    sleep 1
}

# ══════════════════════════════════════════════════════════════════
#  BACKUP / SAVE SYSTEM
# ══════════════════════════════════════════════════════════════════

# Save current progress to a named slot
do_save() {
    local slot="${1:-quicksave}"
    # sanitize: only alphanum + underscore
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    [ -z "$slot" ] && slot="quicksave"
    local dir="saves/${slot}"
    mkdir -p "$dir"
    cp .level    "$dir/level"
    cp .score    "$dir/score"
    cp .passed   "$dir/passed"
    cp .attempts "$dir/attempts"
    cp .streak   "$dir/streak"
    cp .best     "$dir/best"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" > "$dir/timestamp"
    echo "Level=$(cat .level) Score=$(cat .score)" > "$dir/meta"
    echo -e "  ${GREEN}✓ Saved${RESET} → slot '${BOLD}${slot}${RESET}'  (level=$(cat .level), score=$(cat .score)/60)"
}

# Auto-save called silently after every PASS
auto_save() {
    local dir="saves/autosave"
    mkdir -p "$dir"
    cp .level    "$dir/level"
    cp .score    "$dir/score"
    cp .passed   "$dir/passed"
    cp .attempts "$dir/attempts"
    cp .streak   "$dir/streak"
    cp .best     "$dir/best"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" > "$dir/timestamp"
    echo "Level=$(cat .level) Score=$(cat .score)" > "$dir/meta"
}

# Load a save slot
do_load() {
    local slot="${1:-quicksave}"
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    [ -z "$slot" ] && slot="quicksave"
    local dir="saves/${slot}"
    if [ ! -d "$dir" ]; then
        echo -e "  ${RED}No save found with name '${slot}'.${RESET}  Use ${CYAN}saves${RESET} to list slots."
        return 1
    fi
    local ts=$(cat "$dir/timestamp" 2>/dev/null || echo "unknown")
    local meta=$(cat "$dir/meta" 2>/dev/null || echo "")
    read -r -p "  Load '${slot}' ($meta, saved $ts)? This overwrites current progress. (y/n): " confirm < /dev/tty
    if [[ "$confirm" == "y" ]]; then
        cp "$dir/level"    .level
        cp "$dir/score"    .score
        cp "$dir/passed"   .passed
        cp "$dir/attempts" .attempts
        cp "$dir/streak"   .streak
        cp "$dir/best"     .best
        echo -e "  ${GREEN}✓ Loaded${RESET} slot '${BOLD}${slot}${RESET}'  →  level=$(cat .level), score=$(cat .score)/60"
        sleep 1
    else
        echo -e "  ${GRAY}Load cancelled.${RESET}"
    fi
}

# List all save slots
list_saves() {
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║                  ◆  SAVE SLOTS  ◆                       ║${RESET}"
    echo -e "${BOLD}${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    local found=0
    for dir in saves/*/; do
        [ -d "$dir" ] || continue
        found=1
        local slot=$(basename "$dir")
        local ts=$(cat "$dir/timestamp" 2>/dev/null || echo "no date")
        local meta=$(cat "$dir/meta"      2>/dev/null || echo "")
        local marker=""
        [ "$slot" = "autosave" ] && marker="${GRAY}[auto]${RESET} "
        printf "${CYAN}║${RESET}  ${BOLD}%-15s${RESET}  %s${marker}${GRAY}%s${RESET}  ${CYAN}║${RESET}\n" \
            "$slot" "$meta  " "$ts"
    done
    if [ $found -eq 0 ]; then
        echo -e "${CYAN}║${RESET}  ${GRAY}No saves yet. Use: save [name]${RESET}                        ${CYAN}║${RESET}"
    fi
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  ${GRAY}Commands: ${WHITE}save [name]${RESET}  ${WHITE}load [name]${RESET}  ${RED}deletesave [name]${RESET}"
    echo ""
    read -r -p "  Press Enter to continue..." _x < /dev/tty
}

# Delete a save slot
delete_save() {
    local slot="${1:-}"
    [ -z "$slot" ] && { echo -e "  ${RED}Usage: deletesave <name>${RESET}"; return 1; }
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    local dir="saves/${slot}"
    if [ ! -d "$dir" ]; then
        echo -e "  ${RED}No save slot named '${slot}'.${RESET}"
        return 1
    fi
    read -r -p "  Delete save '${slot}'? (y/n): " confirm < /dev/tty
    if [[ "$confirm" == "y" ]]; then
        rm -rf "$dir"
        echo -e "  ${RED}Deleted${RESET} save slot '${slot}'."
        sleep 1
    else
        echo -e "  ${GRAY}Cancelled.${RESET}"
    fi
}

# ══════════════════════════════════════════════════════════════════
#  STATS TABLE  (per-level breakdown)
# ══════════════════════════════════════════════════════════════════
show_stats() {
    local current=$(get_level)
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║               ◆  PER-LEVEL STATS  ◆                     ║${RESET}"
    echo -e "${BOLD}${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    printf "${CYAN}║${RESET}  ${BOLD}%-4s  %-22s  %5s  %5s  %6s${RESET}  ${CYAN}║${RESET}\n" "Lvl" "File" "Pass" "Fail" "Status"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"

    local total_p=0 total_f=0
    for i in $(seq 0 $((current > MAX_LEVEL ? MAX_LEVEL : current))); do
        local fname=$(get_filename $i)
        local p=$(get_passes_for $i)
        local f=$(get_fails_for $i)
        total_p=$(( total_p + p ))
        total_f=$(( total_f + f ))
        local status=""
        local color=""
        if already_passed "$i"; then
            # first-try vs needed retries
            if [ "$f" -eq 0 ]; then
                status="✓ clean"
                color="$GREEN"
            else
                status="✓ +${f}retry"
                color="$YELLOW"
            fi
        elif [ "$i" -eq "$current" ]; then
            status="► active"
            color="$CYAN"
        elif [ "$p" -eq 0 ] && [ "$f" -eq 0 ]; then
            status="─ untried"
            color="$GRAY"
        else
            status="✗ stuck"
            color="$RED"
        fi
        # trim filename to 22 chars
        local short="${fname:0:22}"
        printf "${CYAN}║${RESET}  ${color}%-4s  %-22s  %5s  %5s  %-8s${RESET}  ${CYAN}║${RESET}\n" \
            "$i" "$short" "$p" "$f" "$status"
    done

    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    printf "${CYAN}║${RESET}  ${BOLD}%-27s  ${GREEN}%5s${RESET}  ${RED}%5s${RESET}${RESET}          ${CYAN}║${RESET}\n" \
        "TOTAL (levels 0–$current)" "$total_p" "$total_f"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    read -r -p "  Press Enter to continue..." _x < /dev/tty
}

# ══════════════════════════════════════════════════════════════════
#  HELP
# ══════════════════════════════════════════════════════════════════
show_help() {
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║                    ◆  COMMANDS  ◆                       ║${RESET}"
    echo -e "${BOLD}${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN}║${RESET}  ${GREEN}grademe${RESET}      — compile & grade your solution           ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${CYAN}hint${RESET}         — re-read the current subject              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${WHITE}open${RESET}         — open your .c file in \$EDITOR             ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${WHITE}cat${RESET}          — print your current .c file              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${CYAN}score${RESET}        — show full scoreboard + stats             ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${CYAN}stats${RESET}        — per-level pass/fail breakdown table      ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${CYAN}history${RESET}      — show attempt log for this level          ${CYAN}║${RESET}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN}║${RESET}  ${MAGENTA}save [name]${RESET}  — save progress to a named slot           ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${MAGENTA}load [name]${RESET}  — restore a saved slot                    ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${MAGENTA}saves${RESET}        — list all save slots                     ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${MAGENTA}deletesave N${RESET} — delete a save slot                      ${CYAN}║${RESET}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN}║${RESET}  ${YELLOW}skip${RESET}         — skip level (no credit)                  ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${YELLOW}goto N${RESET}       — jump to level N                         ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${RED}reset${RESET}        — restart level counter (score kept)     ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${RED}resetscore${RESET}   — full reset (level + score + streaks)   ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}  ${GRAY}exit${RESET}         — quit (progress saved)                   ${CYAN}║${RESET}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    read -r -p "  Press Enter..." _x < /dev/tty
}

# ══════════════════════════════════════════════════════════════════
#  MAIN LOOP
# ══════════════════════════════════════════════════════════════════
generate_subjects

while true; do
    LEVEL=$(get_level)
    FNAME=$(get_filename $LEVEL)

    clear
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║      MILES3103 — C MASTERY EXAM v14.0  (60 Levels)      ║${RESET}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    show_progress
    echo ""

    if [ "$LEVEL" -gt "$MAX_LEVEL" ] || [ ! -f "subjects/lvl${LEVEL}.txt" ]; then
        echo -e "${GREEN}  ALL LEVELS COMPLETE — You are a C programmer now.${RESET}"
        show_scoreboard
        exit 0
    fi

    show_subject

    echo -e "${GRAY}  ────────────────────────────────────────────────────────${RESET}"
    echo -e "  ${BOLD}Your file :${RESET} ${WHITE}rendu/$(get_dirname $LEVEL)/$FNAME${RESET}"
    echo -e "  ${BOLD}Trace log :${RESET} ${GRAY}traces/trace_$(get_dirname $LEVEL).txt${RESET}"
    echo -e "${GRAY}  ────────────────────────────────────────────────────────${RESET}"
    echo -e "  ${GREEN}grademe${RESET} · ${CYAN}hint${RESET} · ${WHITE}open${RESET} · ${WHITE}cat${RESET} · ${CYAN}score${RESET} · ${CYAN}stats${RESET} · ${MAGENTA}save${RESET} · ${MAGENTA}load${RESET} · ${MAGENTA}saves${RESET} · ${WHITE}help${RESET}"
    echo -e "${GRAY}  ────────────────────────────────────────────────────────${RESET}"
    echo -ne "  ${BOLD}${CYAN}exam${RESET}[${YELLOW}lvl${LEVEL}${RESET}|${GREEN}$(get_score)/60${RESET}]${BOLD}> ${RESET}"
    read input

    case "$input" in
        grademe)
            mkdir -p "rendu/$(get_dirname $LEVEL)"
            grade_me
            ;;
        score|scoreboard)
            show_scoreboard
            ;;
        stats)
            show_stats
            ;;
        saves|savelist)
            list_saves
            ;;
        save)
            do_save "quicksave"
            sleep 1
            ;;
        save\ *)
            do_save "${input#save }"
            sleep 1
            ;;
        load)
            do_load "quicksave"
            ;;
        load\ *)
            do_load "${input#load }"
            ;;
        deletesave\ *)
            delete_save "${input#deletesave }"
            ;;
        hint|subject)
            show_subject
            read -r -p "  Press Enter..." _x < /dev/tty
            ;;
        open)
            local FPATH="rendu/$(get_dirname $LEVEL)/$FNAME"
            mkdir -p "rendu/$(get_dirname $LEVEL)"
            [ ! -f "$FPATH" ] && touch "$FPATH"
            ${EDITOR:-nano} "$FPATH"
            ;;
        cat)
            local FPATH="rendu/$(get_dirname $LEVEL)/$FNAME"
            if [ -f "$FPATH" ]; then
                echo ""
                echo -e "${GRAY}── $FPATH ──${RESET}"
                cat -n "$FPATH"
                echo ""
            else
                echo -e "  ${RED}File not found:${RESET} $FPATH"
            fi
            read -r -p "  Press Enter..." _x < /dev/tty
            ;;
        history)
            echo ""
            echo -e "${BOLD}  Attempt history — Level $LEVEL${RESET}"
            echo -e "${GRAY}  ──────────────────────────────${RESET}"
            local found=0
            while IFS=: read -r lvl result time; do
                if [ "$lvl" = "$LEVEL" ]; then
                    found=1
                    if [ "$result" = "PASS" ]; then
                        echo -e "  ${GREEN}✓ PASS${RESET}  at $time"
                    else
                        echo -e "  ${RED}✗ FAIL${RESET}  at $time"
                    fi
                fi
            done < .attempts
            [ $found -eq 0 ] && echo -e "  ${GRAY}No attempts yet on this level.${RESET}"
            echo ""
            read -r -p "  Press Enter..." _x < /dev/tty
            ;;
        skip)
            echo -e "  ${YELLOW}Skipping level $LEVEL...${RESET}"
            echo $(( LEVEL + 1 )) > .level
            sleep 1
            ;;
        goto\ *)
            goto_level "${input#goto }"
            ;;
        reset)
            read -r -p "  Reset level to 0? (score is kept) (y/n): " confirm < /dev/tty
            [[ "$confirm" == "y" ]] && echo 0 > .level
            ;;
        resetscore)
            read -r -p "  Reset ALL progress including score? (y/n): " confirm < /dev/tty
            if [[ "$confirm" == "y" ]]; then
                echo 0 > .level
                echo 0 > .score
                echo 0 > .streak
                echo 0 > .best
                > .passed
                > .attempts
                echo -e "  ${RED}Full reset done.${RESET}"
                sleep 1
            fi
            ;;
        help|h|"?")
            show_help
            ;;
        exit|quit|q)
            echo -e "  ${GRAY}Progress saved at level $LEVEL. Score: $(get_score)/60. Streak: $(get_streak). Keep going!${RESET}"
            exit 0
            ;;
        "")
            ;; # just redraw
        *)
            echo -e "  ${RED}Unknown command.${RESET} Type ${BOLD}help${RESET} for the list."
            sleep 1
            ;;
    esac
done
