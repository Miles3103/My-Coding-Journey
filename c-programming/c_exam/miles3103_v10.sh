#!/bin/bash
# **************************************************************************** #
#                                                                              #
#  Project: Miles3103 C Low-Level Mastery Shell v9.0                           #
#  Coverage: C Intro → Pointers (Deep Mastery Edition)                         #
#  Total Levels: 60  (3 per topic x 20 topics)                                 #
#  Changes v9: Custom filenames per level + Score tracking                     #
#                                                                              #
# **************************************************************************** #

mkdir -p subjects rendu traces
if [ ! -f .level ]; then echo 0 > .level; fi
if [ ! -f .score ]; then echo 0 > .score; fi
if [ ! -f .passed ]; then touch .passed; fi

MAX_LEVEL=59

# ══════════════════════════════════════════════════════════════════
#  FILENAME MAP
# ══════════════════════════════════════════════════════════════════
get_dirname() {
    local fname=$(get_filename $1)
    echo "${fname%.c}"
}

get_filename() {
    local filenames=(
        "ft_hello.c"          # 0
        "ft_return.c"         # 1
        "ft_pipeline.c"       # 2
        "ft_structure.c"      # 3
        "ft_functions.c"      # 4
        "ft_prototype.c"      # 5
        "ft_write.c"          # 6
        "ft_putnbr.c"         # 7
        "ft_print_combo.c"    # 8
        "ft_comments.c"       # 9
        "ft_doccomment.c"     # 10
        "ft_bugfix.c"         # 11
        "ft_variables.c"      # 12
        "ft_scope.c"          # 13
        "ft_swap.c"           # 14
        "ft_sizeof.c"         # 15
        "ft_limits.c"         # 16
        "ft_unsigned.c"       # 17
        "ft_implicit.c"       # 18
        "ft_percent.c"        # 19
        "ft_ascii.c"          # 20
        "ft_define.c"         # 21
        "ft_enum.c"           # 22
        "ft_macros.c"         # 23
        "ft_bitwise.c"        # 24
        "ft_compound.c"       # 25
        "ft_ternary.c"        # 26
        "ft_truth_table.c"    # 27
        "ft_shortcircuit.c"   # 28
        "ft_password.c"       # 29
        "ft_grade.c"          # 30
        "ft_fizzbuzz.c"       # 31
        "ft_leap.c"           # 32
        "ft_calc.c"           # 33
        "ft_chartype.c"       # 34
        "ft_statemachine.c"   # 35
        "ft_collatz.c"        # 36
        "ft_dowhile.c"        # 37
        "ft_digitsum.c"       # 38
        "ft_fibonacci.c"      # 39
        "ft_patterns.c"       # 40
        "ft_prime.c"          # 41
        "ft_find.c"           # 42
        "ft_filter.c"         # 43
        "ft_nested.c"         # 44
        "ft_stats.c"          # 45
        "ft_bubblesort.c"     # 46
        "ft_matrix.c"         # 47
        "ft_strfuncs.c"       # 48
        "ft_strmanip.c"       # 49
        "ft_numconv.c"        # 50
        "ft_readbuf.c"        # 51
        "ft_parseinput.c"     # 52
        "ft_multiline.c"      # 53
        "ft_memaddr.c"        # 54
        "ft_passref.c"        # 55
        "ft_swapptr.c"        # 56
        "ft_ptrarith.c"       # 57
        "ft_ptrtoptr.c"       # 58
        "ft_funcptr.c"        # 59
    )
    echo "${filenames[$1]}"
}

# ══════════════════════════════════════════════════════════════════
#  SCORE FUNCTIONS
# ══════════════════════════════════════════════════════════════════
add_score() {
    local points=$1
    local current=$(cat .score)
    echo $((current + points)) > .score
}

get_score() {
    cat .score
}

already_passed() {
    grep -qx "$1" .passed 2>/dev/null
}

mark_passed() {
    echo "$1" >> .passed
}

show_score_bar() {
    local score=$(get_score)
    local max_score=$((MAX_LEVEL + 1))  # 60 levels * 1 point each
    local filled=$(( score > 20 ? 20 : score ))
    local bar=""
    for i in $(seq 1 20); do
        if [ $i -le $filled ]; then bar="${bar}█"; else bar="${bar}░"; fi
    done
    echo "  Score   : $score / 60 pts  [${bar}]"
}

show_scoreboard() {
    echo ""
    echo "+============================================================+"
    echo "|                    SCORE BOARD                            |"
    echo "+============================================================+"
    local score=$(get_score)
    local level=$(cat .level)
    local pct=$(( score * 100 / 60 ))
    echo "  Total Score : $score / 60 points"
    echo "  Completion  : $pct%"
    echo "  Levels Done : $level / 60"
    echo ""
    if [ $score -ge 60 ]; then
        echo "  RANK: ★★★ C MASTER ★★★"
    elif [ $score -ge 45 ]; then
        echo "  RANK: ★★☆ Advanced Programmer"
    elif [ $score -ge 30 ]; then
        echo "  RANK: ★☆☆ Intermediate Coder"
    elif [ $score -ge 15 ]; then
        echo "  RANK: ☆☆☆ Junior Developer"
    else
        echo "  RANK: ☆☆☆ Apprentice"
    fi
    echo ""
    echo "  Cleared levels:"
    if [ -s .passed ]; then
        local passed_list=$(sort -n .passed | tr '\n' ' ')
        echo "  [ $passed_list]"
    else
        echo "  (none yet)"
    fi
    echo "+============================================================+"
    read -p "  Press Enter to continue..."
}


generate_subjects() {

# LEVEL 0
cat << 'EOF' > subjects/lvl0.txt
=== LEVEL 0 - C INTRO [1/3] : Your First Program ===
FILE: rendu/lvl0/ft_hello.c

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

cat << 'EOF' > subjects/lvl1.txt
=== LEVEL 1 - C INTRO [2/3] : Return Values ===
FILE: rendu/lvl1/ft_return.c

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

cat << 'EOF' > subjects/lvl2.txt
=== LEVEL 2 - C INTRO [3/3] : GCC Compilation Pipeline ===
FILE: rendu/lvl2/ft_pipeline.c

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

cat << 'EOF' > subjects/lvl3.txt
=== LEVEL 3 - SYNTAX [1/3] : Program Structure ===
FILE: rendu/lvl3/ft_structure.c

Write a well-structured C program that:
  1. Has a file header comment (author, date, description)
  2. Has a helper function ft_print(char *s) using write()
     that prints the string + newline
  3. Calls ft_print("Syntax is power") from main

Expected output:
  Syntax is power

Tip: Function must be declared BEFORE main or use a prototype.
EOF

cat << 'EOF' > subjects/lvl4.txt
=== LEVEL 4 - SYNTAX [2/3] : Multiple Functions ===
FILE: rendu/lvl4/ft_functions.c

Write THREE separate functions (max 5 lines each):
  greet()    -> prints "Hello"
  farewell() -> prints "Goodbye"
  main()     -> calls greet(), then farewell()

Expected output:
  Hello
  Goodbye

Tip: Small focused functions = good C style.
EOF

cat << 'EOF' > subjects/lvl5.txt
=== LEVEL 5 - SYNTAX [3/3] : Prototypes ===
FILE: rendu/lvl5/ft_prototype.c

Demonstrate function prototypes:
  1. Write prototype at top: int add(int a, int b);
  2. Define add() AFTER main
  3. In main: compute add(7, 8), print: Result: 15

Expected output:
  Result: 15

Tip: Prototype tells the compiler the signature before definition.
EOF

cat << 'EOF' > subjects/lvl6.txt
=== LEVEL 6 - OUTPUT [1/3] : write() Mastery ===
FILE: rendu/lvl6/ft_write.c

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

cat << 'EOF' > subjects/lvl7.txt
=== LEVEL 7 - OUTPUT [2/3] : ft_putnbr ===
FILE: rendu/lvl7/ft_putnbr.c

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
EOF

cat << 'EOF' > subjects/lvl8.txt
=== LEVEL 8 - OUTPUT [3/3] : ft_print_combo ===
FILE: rendu/lvl8/ft_print_combo.c

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

cat << 'EOF' > subjects/lvl9.txt
=== LEVEL 9 - COMMENTS [1/3] : Comment Styles ===
FILE: rendu/lvl9/ft_comments.c

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

cat << 'EOF' > subjects/lvl10.txt
=== LEVEL 10 - COMMENTS [2/3] : Documenting Functions ===
FILE: rendu/lvl10/ft_doccomment.c

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

cat << 'EOF' > subjects/lvl11.txt
=== LEVEL 11 - COMMENTS [3/3] : Commented Debugging ===
FILE: rendu/lvl11/ft_bugfix.c

Write a program with a BUGGY version commented out
and a FIXED version active. Comment explaining the bug.

The bug: multiplying instead of adding
  // int result = a * b;  /* BUG: should be addition */
  int result = a + b;     /* FIX: correct operation */

With a = 6, b = 4, print: Sum: 10

Expected output:
  Sum: 10
EOF

cat << 'EOF' > subjects/lvl12.txt
=== LEVEL 12 - VARIABLES [1/3] : Declaration & Init ===
FILE: rendu/lvl12/ft_variables.c

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
EOF

cat << 'EOF' > subjects/lvl13.txt
=== LEVEL 13 - VARIABLES [2/3] : Scope & Lifetime ===
FILE: rendu/lvl13/ft_scope.c

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

cat << 'EOF' > subjects/lvl14.txt
=== LEVEL 14 - VARIABLES [3/3] : Swap Without Temp ===
FILE: rendu/lvl14/ft_swap.c

Swap two integers WITHOUT a temporary variable.
Use XOR swap or arithmetic swap.

Start: a = 5, b = 9

Expected output:
  Before: a=5, b=9
  After:  a=9, b=5

Tip XOR swap: a ^= b; b ^= a; a ^= b;
Tip arith:    a = a+b; b = a-b; a = a-b;
EOF

cat << 'EOF' > subjects/lvl15.txt
=== LEVEL 15 - DATA TYPES [1/3] : sizeof Explorer ===
FILE: rendu/lvl15/ft_sizeof.c

Print the size of every fundamental C type using sizeof.
Use printf with %zu format specifier.

Expected output (at minimum these lines):
  char:      1 bytes
  int:       4 bytes
  float:     4 bytes
  double:    8 bytes

Tip: printf("char: %zu bytes\n", sizeof(char));
EOF

cat << 'EOF' > subjects/lvl16.txt
=== LEVEL 16 - DATA TYPES [2/3] : Limits & Overflow ===
FILE: rendu/lvl16/ft_limits.c

Include <limits.h> and print:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128

Then demonstrate overflow:
  int overflow = 2147483647 + 1;
  Print: Overflow result: -2147483648

Expected output:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128
  Overflow result: -2147483648
EOF

cat << 'EOF' > subjects/lvl17.txt
=== LEVEL 17 - DATA TYPES [3/3] : Unsigned vs Signed ===
FILE: rendu/lvl17/ft_unsigned.c

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

cat << 'EOF' > subjects/lvl18.txt
=== LEVEL 18 - TYPE CONVERSION [1/3] : Implicit Conversion ===
FILE: rendu/lvl18/ft_implicit.c

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

cat << 'EOF' > subjects/lvl19.txt
=== LEVEL 19 - TYPE CONVERSION [2/3] : Explicit Casting ===
FILE: rendu/lvl19/ft_percent.c

Write: int ft_percent(int part, int total)
Returns the integer percentage.
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
EOF

cat << 'EOF' > subjects/lvl20.txt
=== LEVEL 20 - TYPE CONVERSION [3/3] : ASCII & Char Math ===
FILE: rendu/lvl20/ft_ascii.c

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

cat << 'EOF' > subjects/lvl21.txt
=== LEVEL 21 - CONSTANTS [1/3] : #define vs const ===
FILE: rendu/lvl21/ft_define.c

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

cat << 'EOF' > subjects/lvl22.txt
=== LEVEL 22 - CONSTANTS [2/3] : Enum Constants ===
FILE: rendu/lvl22/ft_enum.c

typedef enum e_day { MON=1, TUE, WED, THU, FRI, SAT, SUN } t_day;

Write char *day_name(t_day d) returning the day name.
Loop MON to SUN and print:
  1: Monday
  2: Tuesday
  ...
  7: Sunday

Expected output (first 3 lines checked):
  1: Monday
  2: Tuesday
  3: Wednesday
EOF

cat << 'EOF' > subjects/lvl23.txt
=== LEVEL 23 - CONSTANTS [3/3] : Macro Functions ===
FILE: rendu/lvl23/ft_macros.c

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

cat << 'EOF' > subjects/lvl24.txt
=== LEVEL 24 - OPERATORS [1/3] : Bitwise Operations ===
FILE: rendu/lvl24/ft_bitwise.c

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

cat << 'EOF' > subjects/lvl25.txt
=== LEVEL 25 - OPERATORS [2/3] : Assignment & Compound ===
FILE: rendu/lvl25/ft_compound.c

Start with int x = 16. Apply and print after EACH:
  x += 4   -> 20
  x -= 5   -> 15
  x *= 3   -> 45
  x /= 9   -> 5
  x %= 3   -> 2
  x <<= 2  -> 8

Expected output (first 3 lines checked):
  x += 4  : 20
  x -= 5  : 15
  x *= 3  : 45
EOF

cat << 'EOF' > subjects/lvl26.txt
=== LEVEL 26 - OPERATORS [3/3] : Ternary & Precedence ===
FILE: rendu/lvl26/ft_ternary.c

Write using ONLY ternary operators:
  char *ft_classify(int n) -> "negative"/"zero"/"positive"
  int ft_abs(int n)        -> n < 0 ? -n : n

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

cat << 'EOF' > subjects/lvl27.txt
=== LEVEL 27 - BOOLEANS [1/3] : Truth Tables ===
FILE: rendu/lvl27/ft_truth_table.c

Include <stdbool.h>. Print the full truth table for &&, ||, !:

Expected output (exact):
  A=0 B=0: AND=0 OR=0  NOT_A=1
  A=0 B=1: AND=0 OR=1  NOT_A=1
  A=1 B=0: AND=0 OR=1  NOT_A=0
  A=1 B=1: AND=1 OR=1  NOT_A=0
EOF

cat << 'EOF' > subjects/lvl28.txt
=== LEVEL 28 - BOOLEANS [2/3] : Short-Circuit Evaluation ===
FILE: rendu/lvl28/ft_shortcircuit.c

Write two functions with side effects:
  int check_a() { printf("check_a called\n"); return 0; }
  int check_b() { printf("check_b called\n"); return 1; }

Test:
  Print "Test 1:" then: check_a() && check_b()
  Print "Test 2:" then: check_b() || check_a()

Expected output:
  Test 1:
  check_a called
  Test 2:
  check_b called
EOF

cat << 'EOF' > subjects/lvl29.txt
=== LEVEL 29 - BOOLEANS [3/3] : Boolean in Practice ===
FILE: rendu/lvl29/ft_password.c

Write: int ft_is_valid_password(char *password)
Returns 1 if ALL true:
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

cat << 'EOF' > subjects/lvl30.txt
=== LEVEL 30 - IF...ELSE [1/3] : Grade Calculator ===
FILE: rendu/lvl30/ft_grade.c

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

cat << 'EOF' > subjects/lvl31.txt
=== LEVEL 31 - IF...ELSE [2/3] : FizzBuzz ===
FILE: rendu/lvl31/ft_fizzbuzz.c

FizzBuzz from 1 to 20.

Expected output (first 8 lines):
  1
  2
  Fizz
  4
  Buzz
  Fizz
  7
  8

Tip: Check 15 (FizzBuzz) BEFORE checking 3 or 5 alone!
EOF

cat << 'EOF' > subjects/lvl32.txt
=== LEVEL 32 - IF...ELSE [3/3] : Leap Year ===
FILE: rendu/lvl32/ft_leap.c

Write: int ft_is_leap(int year)

Expected output:
  2000: leap
  1900: not leap
  2024: leap
  2023: not leap
EOF

cat << 'EOF' > subjects/lvl33.txt
=== LEVEL 33 - SWITCH [1/3] : Calculator ===
FILE: rendu/lvl33/ft_calc.c

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

cat << 'EOF' > subjects/lvl34.txt
=== LEVEL 34 - SWITCH [2/3] : Fall-Through ===
FILE: rendu/lvl34/ft_chartype.c

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

cat << 'EOF' > subjects/lvl35.txt
=== LEVEL 35 - SWITCH [3/3] : State Machine ===
FILE: rendu/lvl35/ft_statemachine.c

typedef enum { RED, YELLOW, GREEN } t_light;

Write: char *next_light(t_light current)
  RED -> GREEN -> YELLOW -> RED

Simulate 6 transitions from RED:

Expected output:
  RED
  GREEN
  YELLOW
  RED
  GREEN
  YELLOW
EOF

cat << 'EOF' > subjects/lvl36.txt
=== LEVEL 36 - WHILE LOOP [1/3] : Collatz Conjecture ===
FILE: rendu/lvl36/ft_collatz.c

Collatz from n = 6. Print each step, then: Steps: 8

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

cat << 'EOF' > subjects/lvl37.txt
=== LEVEL 37 - WHILE LOOP [2/3] : do...while Validation ===
FILE: rendu/lvl37/ft_dowhile.c

Using do...while, process: {-1, 0, 200, 50, -5, 42}
Print "Valid: X" if 1-100, else "Invalid: X"

Expected output:
  Invalid: -1
  Invalid: 0
  Invalid: 200
  Valid: 50
  Invalid: -5
  Valid: 42
EOF

cat << 'EOF' > subjects/lvl38.txt
=== LEVEL 38 - WHILE LOOP [3/3] : Digit Sum & Reverse ===
FILE: rendu/lvl38/ft_digitsum.c

Write:
  int ft_digit_sum(int n)
  int ft_reverse(int n)

Expected output:
  digit_sum(12345)  = 15
  digit_sum(9999)   = 36
  ft_reverse(12345) = 54321
  ft_reverse(100)   = 1
EOF

cat << 'EOF' > subjects/lvl39.txt
=== LEVEL 39 - FOR LOOP [1/3] : Fibonacci Sequence ===
FILE: rendu/lvl39/ft_fibonacci.c

Print first 10 Fibonacci numbers, space-separated:

Expected output:
  0 1 1 2 3 5 8 13 21 34
EOF

cat << 'EOF' > subjects/lvl40.txt
=== LEVEL 40 - FOR LOOP [2/3] : Nested Loops & Patterns ===
FILE: rendu/lvl40/ft_patterns.c

Print a right-triangle then inverted triangle:

Expected output:
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

cat << 'EOF' > subjects/lvl41.txt
=== LEVEL 41 - FOR LOOP [3/3] : Prime Number Sieve ===
FILE: rendu/lvl41/ft_prime.c

Write: int ft_is_prime(int n)
Print all primes 2-50 space-separated, then Count:

Expected output:
  2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
  Count: 15
EOF

cat << 'EOF' > subjects/lvl42.txt
=== LEVEL 42 - BREAK/CONTINUE [1/3] : Search & Stop ===
FILE: rendu/lvl42/ft_find.c

Write: int ft_find(int *arr, int size, int target) -- use break.
arr = {5, 12, 3, 8, 42, 7, 19}

Expected output:
  Find 8:  Found at index 3
  Find 42: Found at index 4
  Find 99: Not found
EOF

cat << 'EOF' > subjects/lvl43.txt
=== LEVEL 43 - BREAK/CONTINUE [2/3] : Filter with Continue ===
FILE: rendu/lvl43/ft_filter.c

Process {-3, 7, -1, 0, 5, -8, 2, 9, -4, 6}:
  Skip negatives and zero with continue.

Expected output:
  [1]: 7
  [4]: 5
  [6]: 2
  [7]: 9
  [9]: 6
  Sum of positives: 29
EOF

cat << 'EOF' > subjects/lvl44.txt
=== LEVEL 44 - BREAK/CONTINUE [3/3] : Nested Loop Control ===
FILE: rendu/lvl44/ft_nested.c

Print pairs (i,j) where i and j are 1-5 and i*j is a perfect square.
Include <math.h>, compile with -lm.

Expected output:
  (1,1)=1
  (1,4)=4
  (2,2)=4
  (3,3)=9
  (4,4)=16
  (5,5)=25
EOF

cat << 'EOF' > subjects/lvl45.txt
=== LEVEL 45 - ARRAYS [1/3] : Array Statistics ===
FILE: rendu/lvl45/ft_stats.c

arr[] = {4, 7, 2, 9, 1, 5, 8, 3, 6, 10}
Write ft_min, ft_max, ft_sum, ft_avg.

Expected output:
  Min: 1
  Max: 10
  Sum: 55
  Avg: 5.50
EOF

cat << 'EOF' > subjects/lvl46.txt
=== LEVEL 46 - ARRAYS [2/3] : Bubble Sort ===
FILE: rendu/lvl46/ft_bubblesort.c

Implement: void ft_bubble_sort(int *arr, int n)
Sort {64, 34, 25, 12, 22, 11, 90} ascending.

Expected output:
  Before: 64 34 25 12 22 11 90
  After:  11 12 22 25 34 64 90
EOF

cat << 'EOF' > subjects/lvl47.txt
=== LEVEL 47 - ARRAYS [3/3] : 2D Arrays & Matrix ===
FILE: rendu/lvl47/ft_matrix.c

int m[3][3] = {{1,2,3},{4,5,6},{7,8,9}};
Write print_matrix, matrix_sum, matrix_trace.

Expected output:
  1 2 3
  4 5 6
  7 8 9
  Sum: 45
  Trace: 15
EOF

cat << 'EOF' > subjects/lvl48.txt
=== LEVEL 48 - STRINGS [1/3] : String Functions from Scratch ===
FILE: rendu/lvl48/ft_strfuncs.c

WITHOUT <string.h>, implement:
  ft_strlen, ft_strcpy, ft_strcmp, ft_strchr

Expected output:
  strlen: 5
  strcpy: world
  strcmp equal: 0
  strcmp diff: nonzero
  strchr: llo
EOF

cat << 'EOF' > subjects/lvl49.txt
=== LEVEL 49 - STRINGS [2/3] : String Manipulation ===
FILE: rendu/lvl49/ft_strmanip.c

Implement: ft_toupper_str, ft_tolower_str, ft_reverse_str, ft_count_words

Expected output:
  upper: HELLO WORLD
  lower: hello world
  reverse: edcba
  words: 4
EOF

cat << 'EOF' > subjects/lvl50.txt
=== LEVEL 50 - STRINGS [3/3] : Number <-> String Conversion ===
FILE: rendu/lvl50/ft_numconv.c

Implement: ft_atoi, ft_itoa

Expected output:
  atoi("42"):    42
  atoi("-100"):  -100
  atoi("0"):     0
  itoa(12345):   12345
  itoa(-7):      -7
EOF

cat << 'EOF' > subjects/lvl51.txt
=== LEVEL 51 - USER INPUT [1/3] : read() Buffer ===
FILE: rendu/lvl51/ft_readbuf.c

Using ONLY read() and write():
  Read up to 32 chars, null-terminate, strip newline, print back.

Test: piped input "Hello42"

Expected output:
  You entered: Hello42
EOF

cat << 'EOF' > subjects/lvl52.txt
=== LEVEL 52 - USER INPUT [2/3] : Parsing Input ===
FILE: rendu/lvl52/ft_parseinput.c

Read a line, count uppercase, lowercase, digits, spaces.
Test input: "Hello World 42"

Expected output:
  Uppercase: 2
  Lowercase: 8
  Digits: 2
  Spaces: 2
EOF

cat << 'EOF' > subjects/lvl53.txt
=== LEVEL 53 - USER INPUT [3/3] : Multi-line Reader ===
FILE: rendu/lvl53/ft_multiline.c

Read exactly 3 lines. For each print length and content.
Test: "hello\nworld\n42\n"

Expected output:
  Line 1 (len=5): hello
  Line 2 (len=5): world
  Line 3 (len=2): 42
EOF

cat << 'EOF' > subjects/lvl54.txt
=== LEVEL 54 - MEMORY ADDRESS [1/3] : Address Explorer ===
FILE: rendu/lvl54/ft_memaddr.c

Print addresses of global, stack, and heap variables.

Expected output format:
  global: 0x[hex]
  stack:  0x[hex]
  heap:   0x[hex]
EOF

cat << 'EOF' > subjects/lvl55.txt
=== LEVEL 55 - MEMORY ADDRESS [2/3] : Pass by Reference ===
FILE: rendu/lvl55/ft_passref.c

Demonstrate pass-by-value vs pass-by-reference:
  void double_val(int n)   -- won't affect caller
  void double_ref(int *n)  -- WILL affect caller

Expected output:
  After double_val: 5
  After double_ref: 10
EOF

cat << 'EOF' > subjects/lvl56.txt
=== LEVEL 56 - MEMORY ADDRESS [3/3] : ft_swap via Pointers ===
FILE: rendu/lvl56/ft_swapptr.c

Write:
  void ft_swap(int *a, int *b)
  void ft_swap_str(char **a, char **b)

Expected output:
  Before swap: a=10, b=20
  After swap:  a=20, b=10
  Before swap: s1=hello, s2=world
  After swap:  s1=world, s2=hello
EOF

cat << 'EOF' > subjects/lvl57.txt
=== LEVEL 57 - POINTERS [1/3] : Pointer Arithmetic ===
FILE: rendu/lvl57/ft_ptrarith.c

Navigate int arr[] = {10,20,30,40,50} using ONLY pointer arithmetic.

Expected output:
  *p     = 10
  *(p+1) = 20
  *(p+2) = 30
  *(p+3) = 40
  *(p+4) = 50
  int units apart:  1
  bytes apart:      4
EOF

cat << 'EOF' > subjects/lvl58.txt
=== LEVEL 58 - POINTERS [2/3] : Pointer to Pointer ===
FILE: rendu/lvl58/ft_ptrtoptr.c

  int x = 42;
  int *p = &x;
  int **pp = &p;

Expected output:
  x    = 42
  *p   = 42
  **pp = 42
  After **pp = 99: x = 99
EOF

cat << 'EOF' > subjects/lvl59.txt
=== LEVEL 59 - POINTERS [3/3] *** FINAL BOSS *** ===
FILE: rendu/lvl59/ft_funcptr.c

Function pointer dispatch + ft_map with function pointers.

Expected output:
  ft_add(10, 3) = 13
  ft_sub(10, 3) = 7
  ft_mul(10, 3) = 30
  2 4 6 8 10

  You have completed the C Mastery Exam. You are ready.
EOF

}
generate_subjects


# ══════════════════════════════════════════════════════════════════
#  GRADER
# ══════════════════════════════════════════════════════════════════
grade_me() {
    LEVEL=$(cat .level)
    FNAME=$(get_filename $LEVEL)
    TASK_DIR="rendu/$(get_dirname $LEVEL)"
    TRACE="traces/trace_$(get_dirname $LEVEL).txt"
    mkdir -p "$TASK_DIR"

    echo ""
    echo "+--------------------------------------------------+"
    printf "|  Grading Level %-3s  File: %-24s |\n" "$LEVEL" "$FNAME"
    echo "+--------------------------------------------------+"

    if [ ! -f "$TASK_DIR/$FNAME" ]; then
        echo "ERROR: $TASK_DIR/$FNAME not found."
        echo "Create your file there and run grademe again."
        return 1
    fi

    gcc -Wall -Wextra -Werror "$TASK_DIR/$FNAME" -o eval_bin -lm 2>"$TRACE"
    if [ $? -ne 0 ]; then
        echo "COMPILE ERROR -- check: $TRACE"
        cat "$TRACE"
        return 1
    fi

    PASS=0
    OUTPUT=""

    case $LEVEL in
        0)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Hello, C World!" ]] && PASS=1 ;;
        1)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Program starting" && echo "$OUTPUT" | grep -q "Program done" && PASS=1 ;;
        2)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Preprocessing" && echo "$OUTPUT" | grep -q "Compilation" && \
            echo "$OUTPUT" | grep -q "Assembly" && echo "$OUTPUT" | grep -q "Linking" && PASS=1 ;;
        3)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Syntax is power" ]] && PASS=1 ;;
        4)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Hello" && echo "$OUTPUT" | grep -q "Goodbye" && PASS=1 ;;
        5)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Result: 15" ]] && PASS=1 ;;
        6)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "HEADER" && echo "$OUTPUT" | grep -q "Content here" && \
            echo "$OUTPUT" | grep -q "FOOTER" && PASS=1 ;;
        7)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qx "0" && echo "$OUTPUT" | grep -qx "42" && \
            echo "$OUTPUT" | grep -qx "\-7" && echo "$OUTPUT" | grep -qx "100" && PASS=1 ;;
        8)  OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "a b c" && echo "$OUTPUT" | grep -q "0 1 2" && PASS=1 ;;
        9)  OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Comments guide future you" ]] && PASS=1 ;;
        10) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Length: 5" && echo "$OUTPUT" | grep -q "IsAlpha: 0" && \
            echo "$OUTPUT" | grep -q "IsAlpha: 1" && PASS=1 ;;
        11) OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "Sum: 10" ]] && PASS=1 ;;
        12) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "letter: X" && echo "$OUTPUT" | grep -q "count: 2025" && \
            echo "$OUTPUT" | grep -q "pi_approx: 3.14" && PASS=1 ;;
        13) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "local g = 999" && echo "$OUTPUT" | grep -q "global g = 100" && PASS=1 ;;
        14) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Before: a=5, b=9" && echo "$OUTPUT" | grep -q "After:  a=9, b=5" && PASS=1 ;;
        15) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "char" && echo "$OUTPUT" | grep -q "int" && \
            echo "$OUTPUT" | grep -q "float" && echo "$OUTPUT" | grep -q "double" && PASS=1 ;;
        16) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "INT_MAX:  2147483647" && echo "$OUTPUT" | grep -q "INT_MIN:  -2147483648" && \
            echo "$OUTPUT" | grep -q "Overflow result:" && PASS=1 ;;
        17) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "signed char:   -1" && echo "$OUTPUT" | grep -q "unsigned char: 255" && \
            echo "$OUTPUT" | grep -q "unsigned underflow: 4294967295" && PASS=1 ;;
        18) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "char from int: A" && echo "$OUTPUT" | grep -q "int from char: 122" && \
            echo "$OUTPUT" | grep -q "2.500000" && PASS=1 ;;
        19) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "1 of 3   = 33%" && echo "$OUTPUT" | grep -q "3 of 4   = 75%" && PASS=1 ;;
        20) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "A -> a" && echo "$OUTPUT" | grep -q "Z -> z" && \
            echo "$OUTPUT" | grep -q "'5' -> 5" && PASS=1 ;;
        21) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "BUFFER_SIZE: 1024" && echo "$OUTPUT" | grep -q "PI: 3.14159265" && \
            echo "$OUTPUT" | grep -q "MAX_USERS: 100" && PASS=1 ;;
        22) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "1: Monday" && echo "$OUTPUT" | grep -q "3: Wednesday" && PASS=1 ;;
        23) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "MAX(3, 7)   = 7" && echo "$OUTPUT" | grep -q "ABS(-5)     = 5" && \
            echo "$OUTPUT" | grep -q "SQUARE(4)   = 16" && PASS=1 ;;
        24) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "a & b  = 8" && echo "$OUTPUT" | grep -q "a | b  = 14" && \
            echo "$OUTPUT" | grep -q "a ^ b  = 6" && PASS=1 ;;
        25) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "x += 4  : 20" && echo "$OUTPUT" | grep -q "x -= 5  : 15" && PASS=1 ;;
        26) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "negative" && echo "$OUTPUT" | grep -q "zero" && \
            echo "$OUTPUT" | grep -q "positive" && echo "$OUTPUT" | grep -q "abs(-42): 42" && PASS=1 ;;
        27) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "A=0 B=0: AND=0 OR=0  NOT_A=1" && \
            echo "$OUTPUT" | grep -q "A=1 B=1: AND=1 OR=1  NOT_A=0" && PASS=1 ;;
        28) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "check_a called" && echo "$OUTPUT" | grep -q "check_b called" && PASS=1 ;;
        29) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "hello: invalid" && echo "$OUTPUT" | grep -q "Hello1!!: valid" && \
            echo "$OUTPUT" | grep -q "SHORT1A: invalid" && PASS=1 ;;
        30) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "95: A" && echo "$OUTPUT" | grep -q "83: B" && \
            echo "$OUTPUT" | grep -q "40: F" && PASS=1 ;;
        31) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Fizz" && echo "$OUTPUT" | grep -q "Buzz" && \
            echo "$OUTPUT" | grep -q "FizzBuzz" && PASS=1 ;;
        32) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "2000: leap" && echo "$OUTPUT" | grep -q "1900: not leap" && \
            echo "$OUTPUT" | grep -q "2024: leap" && echo "$OUTPUT" | grep -q "2023: not leap" && PASS=1 ;;
        33) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "10 + 3 = 13" && echo "$OUTPUT" | grep -q "10 / 0 = 0" && PASS=1 ;;
        34) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "a: vowel" && echo "$OUTPUT" | grep -q "b: consonant" && \
            echo "$OUTPUT" | grep -q "5: digit" && echo "$OUTPUT" | grep -q "!: other" && PASS=1 ;;
        35) OUTPUT=$(./eval_bin 2>/dev/null)
            EXPECTED=$'RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW'
            [[ "$OUTPUT" == "$EXPECTED" ]] && PASS=1 ;;
        36) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qx "6" && echo "$OUTPUT" | grep -qx "1" && \
            echo "$OUTPUT" | grep -q "Steps: 8" && PASS=1 ;;
        37) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Invalid: -1" && echo "$OUTPUT" | grep -q "Valid: 50" && \
            echo "$OUTPUT" | grep -q "Valid: 42" && PASS=1 ;;
        38) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "digit_sum(12345)  = 15" && \
            echo "$OUTPUT" | grep -q "ft_reverse(12345) = 54321" && PASS=1 ;;
        39) OUTPUT=$(./eval_bin 2>/dev/null)
            [[ "$OUTPUT" == "0 1 1 2 3 5 8 13 21 34" ]] && PASS=1 ;;
        40) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -qx "\*" && echo "$OUTPUT" | grep -qx "\*\*\*\*\*" && PASS=1 ;;
        41) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "2 3 5 7 11" && echo "$OUTPUT" | grep -q "47" && \
            echo "$OUTPUT" | grep -q "Count: 15" && PASS=1 ;;
        42) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Found at index 3" && echo "$OUTPUT" | grep -q "Found at index 4" && \
            echo "$OUTPUT" | grep -q "Not found" && PASS=1 ;;
        43) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "\[1\]: 7" && echo "$OUTPUT" | grep -q "Sum of positives: 29" && PASS=1 ;;
        44) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "(1,1)=1" && echo "$OUTPUT" | grep -q "(3,3)=9" && PASS=1 ;;
        45) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Min: 1" && echo "$OUTPUT" | grep -q "Max: 10" && \
            echo "$OUTPUT" | grep -q "Sum: 55" && echo "$OUTPUT" | grep -q "Avg: 5.50" && PASS=1 ;;
        46) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Before: 64 34 25" && echo "$OUTPUT" | grep -q "After:  11 12 22" && PASS=1 ;;
        47) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "1 2 3" && echo "$OUTPUT" | grep -q "Sum: 45" && \
            echo "$OUTPUT" | grep -q "Trace: 15" && PASS=1 ;;
        48) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "strlen: 5" && echo "$OUTPUT" | grep -q "strcpy: world" && \
            echo "$OUTPUT" | grep -q "strcmp equal: 0" && echo "$OUTPUT" | grep -q "strchr: llo" && PASS=1 ;;
        49) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "upper: HELLO WORLD" && echo "$OUTPUT" | grep -q "lower: hello world" && \
            echo "$OUTPUT" | grep -q "reverse: edcba" && echo "$OUTPUT" | grep -q "words: 4" && PASS=1 ;;
        50) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q 'atoi("42"):    42' && echo "$OUTPUT" | grep -q 'atoi("-100"):  -100' && \
            echo "$OUTPUT" | grep -q "itoa(12345):   12345" && PASS=1 ;;
        51) OUTPUT=$(echo "Hello42" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "You entered: Hello42" && PASS=1 ;;
        52) OUTPUT=$(printf "Hello World 42\n" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Uppercase: 2" && echo "$OUTPUT" | grep -q "Lowercase: 8" && \
            echo "$OUTPUT" | grep -q "Digits: 2" && echo "$OUTPUT" | grep -q "Spaces: 2" && PASS=1 ;;
        53) OUTPUT=$(printf "hello\nworld\n42\n" | ./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "Line 1 (len=5): hello" && \
            echo "$OUTPUT" | grep -q "Line 2 (len=5): world" && \
            echo "$OUTPUT" | grep -q "Line 3 (len=2): 42" && PASS=1 ;;
        54) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "global: 0x" && echo "$OUTPUT" | grep -q "stack:  0x" && \
            echo "$OUTPUT" | grep -q "heap:   0x" && PASS=1 ;;
        55) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "After double_val: 5" && echo "$OUTPUT" | grep -q "After double_ref: 10" && PASS=1 ;;
        56) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "After swap:  a=20, b=10" && \
            echo "$OUTPUT" | grep -q "After swap:  s1=world, s2=hello" && PASS=1 ;;
        57) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "\*p     = 10" && echo "$OUTPUT" | grep -q "\*(p+4) = 50" && \
            echo "$OUTPUT" | grep -q "bytes apart:      4" && PASS=1 ;;
        58) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "x    = 42" && echo "$OUTPUT" | grep -q "\*\*pp = 42" && \
            echo "$OUTPUT" | grep -q "After \*\*pp = 99: x = 99" && PASS=1 ;;
        59) OUTPUT=$(./eval_bin 2>/dev/null)
            echo "$OUTPUT" | grep -q "ft_add(10, 3) = 13" && echo "$OUTPUT" | grep -q "ft_mul(10, 3) = 30" && \
            echo "$OUTPUT" | grep -q "2 4 6 8 10" && PASS=1 ;;
        *)  PASS=1 ;;
    esac

    echo ""
    echo "-- Output ------------------------------------------"
    echo "$OUTPUT"
    echo "----------------------------------------------------"
    echo ""
    echo "$OUTPUT" >> "$TRACE"

    if [ $PASS -eq 1 ]; then
        # Award points (only once per level)
        if ! already_passed $LEVEL; then
            add_score 1
            mark_passed $LEVEL
            SCORE_MSG="  +1 point awarded!  Score: $(get_score)/60"
        else
            SCORE_MSG="  (already cleared, no extra point)"
        fi

        echo "OK  LEVEL $LEVEL CLEARED!  [ $FNAME ]"
        echo "$SCORE_MSG"
        NEXT=$((LEVEL + 1))
        echo $NEXT > .level

        if [ $NEXT -gt $MAX_LEVEL ]; then
            echo ""
            echo "+==================================================+"
            echo "|   EXAM COMPLETE -- C MASTERY ACHIEVED            |"
            echo "|   FINAL SCORE: $(get_score) / 60                           |"
            echo "|   60 levels done. You covered:                   |"
            echo "|   Intro, Syntax, Output, Comments, Variables,    |"
            echo "|   Data Types, Type Conversion, Constants,        |"
            echo "|   Operators, Booleans, If/Else, Switch,          |"
            echo "|   While, For, Break/Continue, Arrays, Strings,   |"
            echo "|   User Input, Memory Addresses, Pointers         |"
            echo "+==================================================+"
            rm -f eval_bin
            exit 0
        fi
        echo ""
        read -p "   Press Enter for Level $NEXT..."
    else
        echo "FAIL  Output did not match expected."
        echo "   Check the subject carefully. Trace: $TRACE"
        echo "   Score: $(get_score)/60"
    fi
    rm -f eval_bin
}


# ══════════════════════════════════════════════════════════════════
#  TOPIC LABELS
# ══════════════════════════════════════════════════════════════════
get_topic() {
    local topics=("C Intro" "C Intro" "C Intro"
                  "Syntax" "Syntax" "Syntax"
                  "Output" "Output" "Output"
                  "Comments" "Comments" "Comments"
                  "Variables" "Variables" "Variables"
                  "Data Types" "Data Types" "Data Types"
                  "Type Conv." "Type Conv." "Type Conv."
                  "Constants" "Constants" "Constants"
                  "Operators" "Operators" "Operators"
                  "Booleans" "Booleans" "Booleans"
                  "If...Else" "If...Else" "If...Else"
                  "Switch" "Switch" "Switch"
                  "While Loop" "While Loop" "While Loop"
                  "For Loop" "For Loop" "For Loop"
                  "Break/Cont" "Break/Cont" "Break/Cont"
                  "Arrays" "Arrays" "Arrays"
                  "Strings" "Strings" "Strings"
                  "User Input" "User Input" "User Input"
                  "Mem. Addr." "Mem. Addr." "Mem. Addr."
                  "Pointers" "Pointers" "Pointers")
    echo "${topics[$1]}"
}

show_progress() {
    LEVEL=$(cat .level)
    FNAME=$(get_filename $LEVEL)
    TOPIC=$(get_topic $LEVEL)
    SUBTASK=$(( (LEVEL % 3) + 1 ))
    SCORE=$(get_score)

    # Progress bar (30 chars wide)
    BAR=""
    for i in $(seq 0 $MAX_LEVEL); do
        if [ $i -lt $LEVEL ]; then
            BAR="${BAR}#"
        elif [ $i -eq $LEVEL ]; then
            BAR="${BAR}>"
        else
            BAR="${BAR}."
        fi
    done

    # Score bar (20 chars wide)
    SBAR=""
    SFILLED=$(( SCORE > 20 ? 20 : SCORE ))
    for i in $(seq 1 20); do
        if [ $i -le $SFILLED ]; then SBAR="${SBAR}█"; else SBAR="${SBAR}░"; fi
    done

    echo "  Topic   : $TOPIC (task $SUBTASK/3)"
    echo "  Level   : $LEVEL / $MAX_LEVEL"
    echo "  File    : $FNAME"
    echo "  Progress: [${BAR}]"
    echo "  Score   : $SCORE / 60 pts  [${SBAR}]"

    # Rank display
    if   [ $SCORE -ge 54 ]; then echo "  Rank    : ★★★ C MASTER"
    elif [ $SCORE -ge 42 ]; then echo "  Rank    : ★★☆ Advanced Programmer"
    elif [ $SCORE -ge 24 ]; then echo "  Rank    : ★☆☆ Intermediate Coder"
    elif [ $SCORE -ge 12 ]; then echo "  Rank    : ☆☆☆ Junior Developer"
    else                         echo "  Rank    : ☆☆☆ Apprentice"
    fi
}

# ══════════════════════════════════════════════════════════════════
#  MAIN LOOP
# ══════════════════════════════════════════════════════════════════
while true; do
    LEVEL=$(cat .level)
    FNAME=$(get_filename $LEVEL)
    clear
    echo "+============================================================+"
    echo "|    MILES3103 -- C MASTERY EXAM v9.0  (60 Levels)         |"
    echo "+============================================================+"
    show_progress
    echo ""

    if [ $LEVEL -gt $MAX_LEVEL ] || [ ! -f "subjects/lvl$LEVEL.txt" ]; then
        echo "ALL LEVELS COMPLETE -- You are a C programmer now."
        show_scoreboard
        exit 0
    fi

    cat "subjects/lvl$LEVEL.txt"
    echo ""
    echo "------------------------------------------------------------"
    echo "  Your file : rendu/$(get_dirname $LEVEL)/$FNAME"
    echo "  Trace log : traces/trace_lvl$LEVEL.txt"
    echo "------------------------------------------------------------"
    echo "  grademe   -- compile & test your solution"
    echo "  score     -- show full scoreboard"
    echo "  skip      -- skip this level (no credit)"
    echo "  reset     -- restart from level 0"
    echo "  hint      -- re-read the subject"
    echo "  exit      -- quit (progress saved)"
    echo "------------------------------------------------------------"
    echo -n "  exam[lvl$LEVEL | score:$(get_score)/60]> "
    read input

    case "$input" in
        grademe)
            mkdir -p "rendu/$(get_dirname $LEVEL)"
            grade_me
            ;;
        score|scoreboard)
            show_scoreboard
            ;;
        skip)
            echo "Skipping level $LEVEL..."
            echo $((LEVEL + 1)) > .level
            sleep 1
            ;;
        reset)
            read -p "  Reset to 0? This resets level but keeps score (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                echo 0 > .level
            fi
            ;;
        resetscore)
            read -p "  Reset ALL progress including score? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                echo 0 > .level
                echo 0 > .score
                > .passed
                echo "Full reset done."
                sleep 1
            fi
            ;;
        hint|subject)
            cat "subjects/lvl$LEVEL.txt"
            read -p "  Press Enter..."
            ;;
        exit|quit)
            echo "  Progress saved at level $LEVEL. Score: $(get_score)/60. Keep going!"
            exit 0
            ;;
        *)
            echo "  Unknown command. Try: grademe | score | skip | reset | hint | exit"
            sleep 1
            ;;
    esac
done
