#!/usr/bin/env bash
# lib/subjects.sh — Generate all 60 subject files

generate_subjects() {
    # Only regenerate if missing
    [ -f "$SUBJECTS_DIR/lvl59.txt" ] && return

    cat > "$SUBJECTS_DIR/lvl0.txt" << 'EOF'
FILE: rendu/ft_hello/ft_hello.c

Write a complete C program that prints:
  Hello, C World!
using write() ONLY. No printf allowed.

Rules:
  · Include <unistd.h>
  · Use write(1, ..., len)
  · End with a newline character

Tip: write(1, "Hello, C World!\n", 16);
     Count the characters carefully — including \n that's 16.

Expected output:
  Hello, C World!
EOF

    cat > "$SUBJECTS_DIR/lvl1.txt" << 'EOF'
FILE: rendu/ft_return/ft_return.c

Write a C program that:
  1. Prints "Program starting" using write()
  2. Prints "Program done" using write()
  3. Returns 0 from main

Add a comment at the top:
  /* Q: What does returning 0 mean? What does returning 1 mean? */

Tip: Non-zero return = error code (Unix convention).
     Return 0 means success.

Expected output:
  Program starting
  Program done
EOF

    cat > "$SUBJECTS_DIR/lvl2.txt" << 'EOF'
FILE: rendu/ft_pipeline/ft_pipeline.c

Print the 4 stages of GCC compilation using write():
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking

Tip: These map to: cpp → cc1 → as → ld

Expected output:
  1. Preprocessing
  2. Compilation
  3. Assembly
  4. Linking
EOF

    cat > "$SUBJECTS_DIR/lvl3.txt" << 'EOF'
FILE: rendu/ft_structure/ft_structure.c

Write a well-structured C program that:
  1. Has a file header comment (author, date, description)
  2. Has a helper function ft_print(char *s) using write()
     that prints the string followed by a newline
  3. Calls ft_print("Syntax is power") from main

Tip: Declare the function BEFORE main, or use a prototype.
     ft_print must use write(), not printf.

Expected output:
  Syntax is power
EOF

    cat > "$SUBJECTS_DIR/lvl4.txt" << 'EOF'
FILE: rendu/ft_functions/ft_functions.c

Write THREE separate functions (max 5 lines each):
  greet()    → prints "Hello"
  farewell() → prints "Goodbye"
  main()     → calls greet(), then farewell()

Tip: Small focused functions = good C style.
     Each function should have its own purpose.

Expected output:
  Hello
  Goodbye
EOF

    cat > "$SUBJECTS_DIR/lvl5.txt" << 'EOF'
FILE: rendu/ft_prototype/ft_prototype.c

Demonstrate function prototypes:
  1. Write prototype at top:  int add(int a, int b);
  2. Define add() AFTER main
  3. In main: compute add(7, 8) and print: Result: 15

Tip: A prototype tells the compiler the function signature
     before seeing the full definition.

Expected output:
  Result: 15
EOF

    cat > "$SUBJECTS_DIR/lvl6.txt" << 'EOF'
FILE: rendu/ft_write/ft_write.c

Using ONLY write(), print this exact layout:
  *** HEADER ***
  (blank line)
  Content here
  (blank line)
  *** FOOTER ***

Tip: A blank line = writing just "\n" to stdout.
     Total 5 write() calls (or combine them).

Expected output:
  *** HEADER ***

  Content here

  *** FOOTER ***
EOF

    cat > "$SUBJECTS_DIR/lvl7.txt" << 'EOF'
FILE: rendu/ft_putnbr/ft_putnbr.c

WITHOUT printf, write a function:
  void ft_putnbr(int n)
that uses write() to print an integer to stdout.

In main, call it for: 0, 42, -7, 100 (each on its own line)

Tip: n % 10 gives the last digit. Add '0' to convert to char.
     Handle negatives: print '-' then negate n.
     Edge case: INT_MIN (-2147483648) needs special handling.

Expected output:
  0
  42
  -7
  100
EOF

    cat > "$SUBJECTS_DIR/lvl8.txt" << 'EOF'
FILE: rendu/ft_print_combo/ft_print_combo.c

Write ft_print_combo() that uses write() to print:
  · All lowercase letters a to z, space-separated, then newline
  · All digits 0 to 9, space-separated, then newline

Tip: Use a char variable in a loop.
     'a' + i gives the i-th letter.
     Print a space between each character, not after the last.

Expected output:
  a b c d e f g h i j k l m n o p q r s t u v w x y z
  0 1 2 3 4 5 6 7 8 9
EOF

    cat > "$SUBJECTS_DIR/lvl9.txt" << 'EOF'
FILE: rendu/ft_comments/ft_comments.c

Write a C program demonstrating ALL comment types:
  1. File header block comment (/* ... */)
  2. Function-level comment above a function
  3. Inline comment on a variable declaration
  4. A TODO comment inside main
  5. Program prints: "Comments guide future you"

Tip: Good comments explain WHY, not WHAT.
     The code already shows what — comments add context.

Expected output:
  Comments guide future you
EOF

    cat > "$SUBJECTS_DIR/lvl10.txt" << 'EOF'
FILE: rendu/ft_doccomment/ft_doccomment.c

Write TWO functions, each with a full doc-comment block:
  @param  - what the parameter is
  @return - what the function returns
  @desc   - what it does

Function 1: int ft_strlen(char *s)    — returns string length
Function 2: int ft_isalpha(char c)    — returns 1 if letter, 0 if not

Test in main:
  ft_strlen("hello")  → print: Length: 5
  ft_isalpha('3')     → print: IsAlpha: 0
  ft_isalpha('z')     → print: IsAlpha: 1

Expected output:
  Length: 5
  IsAlpha: 0
  IsAlpha: 1
EOF

    cat > "$SUBJECTS_DIR/lvl11.txt" << 'EOF'
FILE: rendu/ft_bugfix/ft_bugfix.c

Write a program with a BUGGY version commented out
and a FIXED version active. Include a comment explaining the bug.

The bug: multiplying instead of adding
  // int result = a * b;  /* BUG: should be addition */
  int result = a + b;     /* FIX: correct operation   */

With a = 6, b = 4:

Expected output:
  Sum: 10
EOF

    cat > "$SUBJECTS_DIR/lvl12.txt" << 'EOF'
FILE: rendu/ft_variables/ft_variables.c

Declare ONE variable of each fundamental type:
  char   letter    = 'X'
  int    count     = 2025
  float  pi_approx = 3.14f
  double precise   = 2.718281828

Print each with printf using the correct format specifier.

Tip: printf("pi_approx: %.2f\n", pi_approx);
     printf("precise: %f\n", precise);   ← default is 6 decimal places

Expected output:
  letter: X
  count: 2025
  pi_approx: 3.14
  precise: 2.718282
EOF

    cat > "$SUBJECTS_DIR/lvl13.txt" << 'EOF'
FILE: rendu/ft_scope/ft_scope.c

Demonstrate variable scope:
  · Global int g = 100
  · Function scope_demo() with local int g = 999
    → prints: local g = 999
  · main() calls scope_demo(), then prints: global g = 100

Tip: Local variables shadow globals within their scope.
     The global g is untouched by the local one.

Expected output:
  local g = 999
  global g = 100
EOF

    cat > "$SUBJECTS_DIR/lvl14.txt" << 'EOF'
FILE: rendu/ft_swap/ft_swap.c

Swap two integers WITHOUT using a temporary variable.
Use either XOR swap or arithmetic swap.

Start: a = 5, b = 9

Tip: XOR swap:   a ^= b; b ^= a; a ^= b;
     Arith swap: a = a+b; b = a-b; a = a-b;

Expected output:
  Before: a=5, b=9
  After:  a=9, b=5
EOF

    cat > "$SUBJECTS_DIR/lvl15.txt" << 'EOF'
FILE: rendu/ft_sizeof/ft_sizeof.c

Print the size of every fundamental C type using sizeof().
Use the %zu format specifier (correct for size_t).

Tip: printf("char:      %zu bytes\n", sizeof(char));

Expected output:
  char:      1 bytes
  int:       4 bytes
  float:     4 bytes
  double:    8 bytes
EOF

    cat > "$SUBJECTS_DIR/lvl16.txt" << 'EOF'
FILE: rendu/ft_limits/ft_limits.c

Include <limits.h> and print:
  INT_MAX, INT_MIN, CHAR_MAX, CHAR_MIN

Then demonstrate overflow:
  int overflow = (int)((unsigned int)INT_MAX + 1);
  Print: Overflow result: -2147483648

Tip: Cast to (unsigned int) first to avoid undefined behaviour.

Expected output:
  INT_MAX:  2147483647
  INT_MIN:  -2147483648
  CHAR_MAX: 127
  CHAR_MIN: -128
  Overflow result: -2147483648
EOF

    cat > "$SUBJECTS_DIR/lvl17.txt" << 'EOF'
FILE: rendu/ft_unsigned/ft_unsigned.c

Part 1 — Signed vs Unsigned char:
  signed char sc = -1;
  unsigned char uc = (unsigned char)sc;
  → signed char:   -1
  → unsigned char: 255

Part 2 — Unsigned underflow:
  unsigned int ui = 0;
  ui = ui - 1;
  → unsigned underflow: 4294967295

Expected output:
  signed char:   -1
  unsigned char: 255
  unsigned underflow: 4294967295
EOF

    cat > "$SUBJECTS_DIR/lvl18.txt" << 'EOF'
FILE: rendu/ft_implicit/ft_implicit.c

Demonstrate implicit type conversion:
  1. int i = 65; char c = i;       → char from int: A
  2. char ch = 'z'; int n = ch;    → int from char: 122
  3. int a=5, b=2; double d = a/b; → int division stored as double: 2.000000
  4. double e = (double)a / b;     → cast before division: 2.500000

Tip: In case 3, the division happens as int/int BEFORE storing.
     In case 4, one operand is cast first, forcing float division.

Expected output:
  char from int: A
  int from char: 122
  int division stored as double: 2.000000
  cast before division: 2.500000
EOF

    cat > "$SUBJECTS_DIR/lvl19.txt" << 'EOF'
FILE: rendu/ft_percent/ft_percent.c

Write: int ft_percent(int part, int total)
Returns the integer percentage (truncated, not rounded).
Example: ft_percent(1, 3) = 33

Test in main with these exact values:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%

Tip: return (int)((double)part / total * 100);

Expected output:
  1 of 3   = 33%
  2 of 3   = 66%
  1 of 4   = 25%
  3 of 4   = 75%
  1 of 7   = 14%
EOF

    cat > "$SUBJECTS_DIR/lvl20.txt" << 'EOF'
FILE: rendu/ft_ascii/ft_ascii.c

Part 1 — Convert uppercase to lowercase by adding 32:
  A → a
  M → m
  Z → z

Part 2 — Convert char digits to their integer values:
  '5' → 5
  '9' → 9

Tip: 'a' - 'A' == 32. Char digit to int: c - '0'.

Expected output:
  A -> a
  M -> m
  Z -> z
  '5' -> 5
  '9' -> 9
EOF

    cat > "$SUBJECTS_DIR/lvl21.txt" << 'EOF'
FILE: rendu/ft_define/ft_define.c

Declare and print all four constants:
  #define BUFFER_SIZE 1024
  #define PI 3.14159265
  const int  MAX_USERS = 100;
  const char SEPARATOR = '-';

Tip: PI needs %.8f to show all 8 decimal digits.
     printf("PI: %.8f\n", PI);  → PI: 3.14159265

Expected output:
  BUFFER_SIZE: 1024
  PI: 3.14159265
  MAX_USERS: 100
  SEPARATOR: -
EOF

    cat > "$SUBJECTS_DIR/lvl22.txt" << 'EOF'
FILE: rendu/ft_enum/ft_enum.c

typedef enum e_day { MON=1, TUE, WED, THU, FRI, SAT, SUN } t_day;

Write: const char *day_name(t_day d)
Returns the day name as a string.

Loop from MON to SUN and print each.

Expected output:
  1: Monday
  2: Tuesday
  3: Wednesday
  4: Thursday
  5: Friday
  6: Saturday
  7: Sunday
EOF

    cat > "$SUBJECTS_DIR/lvl23.txt" << 'EOF'
FILE: rendu/ft_macros/ft_macros.c

Write these four macros (not functions):
  #define MAX(a, b)   largest of a and b
  #define MIN(a, b)   smallest of a and b
  #define ABS(x)      absolute value of x
  #define SQUARE(x)   x squared

Tip: Always wrap arguments in parentheses:
     #define SQUARE(x) ((x) * (x))

Expected output:
  MAX(3, 7)   = 7
  MIN(3, 7)   = 3
  ABS(-5)     = 5
  SQUARE(4)   = 16
EOF

    cat > "$SUBJECTS_DIR/lvl24.txt" << 'EOF'
FILE: rendu/ft_bitwise/ft_bitwise.c

With a = 10 (0b1010) and b = 12 (0b1100), print all results:

Tip: Work each one out by hand first:
     1010 & 1100 = 1000 = 8
     1010 | 1100 = 1110 = 14  etc.

Expected output:
  a & b  = 8
  a | b  = 14
  a ^ b  = 6
  ~a     = -11
  a << 1 = 20
  a >> 1 = 5
EOF

    cat > "$SUBJECTS_DIR/lvl25.txt" << 'EOF'
FILE: rendu/ft_compound/ft_compound.c

Start with int x = 16. Apply each compound operator in order
and print the result AFTER each one:

Expected output:
  x += 4  : 20
  x -= 5  : 15
  x *= 3  : 45
  x /= 9  : 5
  x %= 3  : 2
  x <<= 2 : 8
EOF

    cat > "$SUBJECTS_DIR/lvl26.txt" << 'EOF'
FILE: rendu/ft_ternary/ft_ternary.c

Write using ONLY ternary operators (no if/else):
  const char *ft_classify(int n) → "negative", "zero", or "positive"
  int ft_abs(int n)              → absolute value

Test in main:
  ft_classify(-5) → print: -5: negative
  ft_classify(0)  → print: 0: zero
  ft_classify(3)  → print: 3: positive
  ft_abs(-42)     → print: abs(-42): 42

Expected output:
  -5: negative
  0: zero
  3: positive
  abs(-42): 42
EOF

    cat > "$SUBJECTS_DIR/lvl27.txt" << 'EOF'
FILE: rendu/ft_truth_table/ft_truth_table.c

Include <stdbool.h>. Print the full truth table for &&, ||, !
Use exact spacing as shown.

Tip: Loop through all 4 combinations of A (0,0,1,1) and B (0,1,0,1).

Expected output:
  A=0 B=0: AND=0 OR=0  NOT_A=1
  A=0 B=1: AND=0 OR=1  NOT_A=1
  A=1 B=0: AND=0 OR=1  NOT_A=0
  A=1 B=1: AND=1 OR=1  NOT_A=0
EOF

    cat > "$SUBJECTS_DIR/lvl28.txt" << 'EOF'
FILE: rendu/ft_shortcircuit/ft_shortcircuit.c

Write two functions with side effects:
  int check_a() { printf("check_a called\n"); return 0; }
  int check_b() { printf("check_b called\n"); return 1; }

Then:
  Print "Test 1:" then evaluate: check_a() && check_b()
  Print "Test 2:" then evaluate: check_b() || check_a()

Note: In Test 1, check_b() is never called (check_a returns 0).
      In Test 2, check_a() is never called (check_b returns 1).

Expected output:
  Test 1:
  check_a called
  Test 2:
  check_b called
EOF

    cat > "$SUBJECTS_DIR/lvl29.txt" << 'EOF'
FILE: rendu/ft_password/ft_password.c

Write: int ft_is_valid_password(char *password)
Returns 1 if ALL conditions are true:
  · Length >= 8
  · Has at least one uppercase letter
  · Has at least one digit
Returns 0 otherwise.

Tip: Loop once through the string, track flags for each condition.

Expected output:
  hello: invalid
  Hello1!!: valid
  SHORT1A: invalid
  longbutnodigit: invalid
EOF

    cat > "$SUBJECTS_DIR/lvl30.txt" << 'EOF'
FILE: rendu/ft_grade/ft_grade.c

Write: char ft_grade(int score)
  score >= 90 → 'A'
  score >= 80 → 'B'
  score >= 70 → 'C'
  score >= 60 → 'D'
  else        → 'F'

Expected output:
  95: A
  83: B
  71: C
  65: D
  40: F
EOF

    cat > "$SUBJECTS_DIR/lvl31.txt" << 'EOF'
FILE: rendu/ft_fizzbuzz/ft_fizzbuzz.c

Classic FizzBuzz from 1 to 20.
Rules:
  · Divisible by 15 → FizzBuzz
  · Divisible by 3  → Fizz
  · Divisible by 5  → Buzz
  · Otherwise       → the number

Tip: Check divisible by 15 FIRST, before checking 3 or 5 alone!

Expected output (all 20 lines):
  1 / 2 / Fizz / 4 / Buzz / Fizz / 7 / 8 / Fizz / Buzz /
  11 / Fizz / 13 / 14 / FizzBuzz / 16 / 17 / Fizz / 19 / Buzz
EOF

    cat > "$SUBJECTS_DIR/lvl32.txt" << 'EOF'
FILE: rendu/ft_leap/ft_leap.c

Write: int ft_is_leap(int year)
Leap year rules (apply in order):
  · Divisible by 400 → IS leap
  · Divisible by 100 → NOT leap
  · Divisible by 4   → IS leap
  · Otherwise        → NOT leap

Expected output:
  2000: leap
  1900: not leap
  2024: leap
  2023: not leap
EOF

    cat > "$SUBJECTS_DIR/lvl33.txt" << 'EOF'
FILE: rendu/ft_calc/ft_calc.c

Write: int ft_calc(int a, char op, int b)
Use a switch on op for: '+' '-' '*' '/'
Return 0 for division by zero.

Expected output:
  10 + 3 = 13
  10 - 3 = 7
  10 * 3 = 30
  10 / 3 = 3
  10 / 0 = 0
EOF

    cat > "$SUBJECTS_DIR/lvl34.txt" << 'EOF'
FILE: rendu/ft_chartype/ft_chartype.c

Write ft_char_type(char c) using intentional fall-through for vowels:
  'a','e','i','o','u' → vowel
  other a-z           → consonant
  0-9                 → digit
  else                → other

Tip: Cases 'a':, 'e':, 'i':, 'o': can all fall through to 'u':
     which then prints "vowel".

Expected output:
  a: vowel
  b: consonant
  5: digit
  !: other
EOF

    cat > "$SUBJECTS_DIR/lvl35.txt" << 'EOF'
FILE: rendu/ft_statemachine/ft_statemachine.c

typedef enum { RED, YELLOW, GREEN } t_light;

Write: t_light next_light(t_light current)
Cycle: RED → GREEN → YELLOW → RED

Simulate 6 transitions starting from RED.
Print the CURRENT light BEFORE each transition.

Expected output (exactly 6 lines):
  RED
  GREEN
  YELLOW
  RED
  GREEN
  YELLOW
EOF

    cat > "$SUBJECTS_DIR/lvl36.txt" << 'EOF'
FILE: rendu/ft_collatz/ft_collatz.c

Collatz conjecture starting from n = 6:
  · If even: n = n / 2
  · If odd:  n = n * 3 + 1
Print each value including start (6) and end (1).
Then print the step count (transitions, not including start).

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

    cat > "$SUBJECTS_DIR/lvl37.txt" << 'EOF'
FILE: rendu/ft_dowhile/ft_dowhile.c

Using do...while, process these values: {-1, 0, 200, 50, -5, 42}
  · Print "Valid: X"   if value is 1-100 inclusive
  · Print "Invalid: X" otherwise

Expected output:
  Invalid: -1
  Invalid: 0
  Invalid: 200
  Valid: 50
  Invalid: -5
  Valid: 42
EOF

    cat > "$SUBJECTS_DIR/lvl38.txt" << 'EOF'
FILE: rendu/ft_digitsum/ft_digitsum.c

Write:
  int ft_digit_sum(int n)  — sum of all digits of n
  int ft_reverse(int n)    — reverse the digits of n

Tip: n % 10 gives last digit. Build reverse by multiplying by 10
     and adding extracted digits.

Expected output:
  digit_sum(12345)  = 15
  digit_sum(9999)   = 36
  ft_reverse(12345) = 54321
  ft_reverse(100)   = 1
EOF

    cat > "$SUBJECTS_DIR/lvl39.txt" << 'EOF'
FILE: rendu/ft_fibonacci/ft_fibonacci.c

Print the first 10 Fibonacci numbers, space-separated,
with a newline at the end.

Tip: Start with a=0, b=1. Each iteration: tmp=b; b=a+b; a=tmp;

Expected output (exact):
  0 1 1 2 3 5 8 13 21 34
EOF

    cat > "$SUBJECTS_DIR/lvl40.txt" << 'EOF'
FILE: rendu/ft_patterns/ft_patterns.c

Print a right-triangle growing from 1 to 5 stars,
then shrinking from 5 to 1 star.

Tip: Two for loops — one ascending, one descending.

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

    cat > "$SUBJECTS_DIR/lvl41.txt" << 'EOF'
FILE: rendu/ft_prime/ft_prime.c

Write: int ft_is_prime(int n)
Print all primes from 2 to 50, space-separated, then the count.

Tip: For each number n, check divisibility from 2 to sqrt(n).
     If no divisor found, it's prime.

Expected output:
  2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
  Count: 15
EOF

    cat > "$SUBJECTS_DIR/lvl42.txt" << 'EOF'
FILE: rendu/ft_find/ft_find.c

Write: int ft_find(int *arr, int size, int target)
Returns the index of target, or -1 if not found. Use break to stop early.

arr[] = {5, 12, 3, 8, 42, 7, 19}

Expected output:
  Find 8:  Found at index 3
  Find 42: Found at index 4
  Find 99: Not found
EOF

    cat > "$SUBJECTS_DIR/lvl43.txt" << 'EOF'
FILE: rendu/ft_filter/ft_filter.c

Process {-3, 7, -1, 0, 5, -8, 2, 9, -4, 6}:
  · Skip negatives and zero using continue
  · Print index (0-based) and value for positives
  · Print sum of positives at the end

Expected output:
  [1]: 7
  [4]: 5
  [6]: 2
  [7]: 9
  [9]: 6
  Sum of positives: 29
EOF

    cat > "$SUBJECTS_DIR/lvl44.txt" << 'EOF'
FILE: rendu/ft_nested/ft_nested.c

Print all pairs (i, j) where i and j are in 1..5
and i*j is a perfect square.
Include <math.h> and compile with -lm.

Tip: sqrt(n) is an integer when (int)sqrt(n) * (int)sqrt(n) == n

Expected output:
  (1,1)=1
  (1,4)=4
  (2,2)=4
  (3,3)=9
  (4,4)=16
  (5,5)=25
EOF

    cat > "$SUBJECTS_DIR/lvl45.txt" << 'EOF'
FILE: rendu/ft_stats/ft_stats.c

arr[] = {4, 7, 2, 9, 1, 5, 8, 3, 6, 10}

Write four functions:
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

    cat > "$SUBJECTS_DIR/lvl46.txt" << 'EOF'
FILE: rendu/ft_bubblesort/ft_bubblesort.c

Implement: void ft_bubble_sort(int *arr, int n)
Sort {64, 34, 25, 12, 22, 11, 90} in ascending order.

Tip: N-1 passes. In each pass, compare adjacent elements
     and swap if out of order. Largest element "bubbles up".

Expected output:
  Before: 64 34 25 12 22 11 90
  After:  11 12 22 25 34 64 90
EOF

    cat > "$SUBJECTS_DIR/lvl47.txt" << 'EOF'
FILE: rendu/ft_matrix/ft_matrix.c

int m[3][3] = {{1,2,3},{4,5,6},{7,8,9}};

Write:
  void print_matrix(int m[3][3])      — print each row space-separated
  int  matrix_sum(int m[3][3])        — sum of all 9 elements
  int  matrix_trace(int m[3][3])      — sum of diagonal: m[0][0]+m[1][1]+m[2][2]

Expected output:
  1 2 3
  4 5 6
  7 8 9
  Sum: 45
  Trace: 15
EOF

    cat > "$SUBJECTS_DIR/lvl48.txt" << 'EOF'
FILE: rendu/ft_strfuncs/ft_strfuncs.c

WITHOUT using <string.h>, implement:
  int   ft_strlen(char *s)
  char *ft_strcpy(char *dst, char *src)
  int   ft_strcmp(char *s1, char *s2)
  char *ft_strchr(char *s, char c)

Tip: ft_strcmp returns 0 if equal, non-zero otherwise.
     ft_strchr returns a pointer to the first occurrence, or NULL.

Expected output:
  strlen: 5
  strcpy: world
  strcmp equal: 0
  strcmp diff: nonzero
  strchr: llo
EOF

    cat > "$SUBJECTS_DIR/lvl49.txt" << 'EOF'
FILE: rendu/ft_strmanip/ft_strmanip.c

Implement (all in-place, modifying the original string):
  void ft_toupper_str(char *s)    — convert all chars to uppercase
  void ft_tolower_str(char *s)    — convert all chars to lowercase
  void ft_reverse_str(char *s)    — reverse the string in-place
  int  ft_count_words(char *s)    — count space-separated words

Expected output:
  upper: HELLO WORLD
  lower: hello world
  reverse: edcba
  words: 4
EOF

    cat > "$SUBJECTS_DIR/lvl50.txt" << 'EOF'
FILE: rendu/ft_numconv/ft_numconv.c

Implement:
  int   ft_atoi(char *s)    — string to int (handle sign, leading spaces)
  char *ft_itoa(int n)      — int to string (malloc allowed)

Tip: ft_atoi: skip whitespace, handle sign, then build the number.
     ft_itoa: handle negatives and INT_MIN specially.

Expected output:
  atoi("42"):    42
  atoi("-100"):  -100
  atoi("0"):     0
  itoa(12345):   12345
  itoa(-7):      -7
EOF

    cat > "$SUBJECTS_DIR/lvl51.txt" << 'EOF'
FILE: rendu/ft_readbuf/ft_readbuf.c

Using ONLY read() and write():
  · Read up to 32 chars from stdin
  · Null-terminate the buffer
  · Strip trailing newline if present
  · Print: "You entered: " followed by the input

Test: echo "Hello42" | ./ft_readbuf

Tip: read(0, buf, 32) returns the number of bytes read.
     Check if buf[bytes-1] == '\n' and replace with '\0'.

Expected output:
  You entered: Hello42
EOF

    cat > "$SUBJECTS_DIR/lvl52.txt" << 'EOF'
FILE: rendu/ft_parseinput/ft_parseinput.c

Read a line from stdin, count uppercase, lowercase, digits, spaces.

Test input: "Hello World 42"

Tip: Read with fgets or read(). Then loop through each character
     and classify it.

Expected output:
  Uppercase: 2
  Lowercase: 8
  Digits: 2
  Spaces: 2
EOF

    cat > "$SUBJECTS_DIR/lvl53.txt" << 'EOF'
FILE: rendu/ft_multiline/ft_multiline.c

Read exactly 3 lines from stdin using read() in a loop.
For each line print: "Line N (len=X): content"
(length excludes the newline)

Test with: printf "hello\nworld\n42\n" | ./ft_multiline

Tip: Read byte by byte until '\n'. Track line count and length.

Expected output:
  Line 1 (len=5): hello
  Line 2 (len=5): world
  Line 3 (len=2): 42
EOF

    cat > "$SUBJECTS_DIR/lvl54.txt" << 'EOF'
FILE: rendu/ft_memaddr/ft_memaddr.c

Print the addresses of three variables:
  · A global int        (label: "global")
  · A stack int (local) (label: "stack")
  · A heap int (malloc) (label: "heap")
Then free() the heap allocation.

Tip: printf("global: %p\n", (void*)&g);
     Addresses will differ every run — that's expected.

Expected output format (addresses vary):
  global: 0x[hex address]
  stack:  0x[hex address]
  heap:   0x[hex address]
EOF

    cat > "$SUBJECTS_DIR/lvl55.txt" << 'EOF'
FILE: rendu/ft_passref/ft_passref.c

Demonstrate pass-by-value vs pass-by-reference:
  void double_val(int n)   — doubles a local copy (no effect on caller)
  void double_ref(int *n)  — doubles the caller's variable via pointer

Start with x = 5.

Expected output:
  After double_val: 5
  After double_ref: 10
EOF

    cat > "$SUBJECTS_DIR/lvl56.txt" << 'EOF'
FILE: rendu/ft_swapptr/ft_swapptr.c

Write two swap functions:
  void ft_swap(int *a, int *b)          — swap two integers
  void ft_swap_str(char **a, char **b)  — swap two string pointers

Tip: ft_swap: use a temp variable.
     ft_swap_str: swap the pointers themselves (char *tmp = *a; etc.)

Expected output:
  Before swap: a=10, b=20
  After swap:  a=20, b=10
  Before swap: s1=hello, s2=world
  After swap:  s1=world, s2=hello
EOF

    cat > "$SUBJECTS_DIR/lvl57.txt" << 'EOF'
FILE: rendu/ft_ptrarith/ft_ptrarith.c

Navigate int arr[] = {10, 20, 30, 40, 50} using ONLY pointer arithmetic.
No arr[i] subscript notation allowed.

Also print:
  · "int units apart" between consecutive elements (always 1)
  · "bytes apart" (sizeof(int), typically 4)

Expected output:
  *p     = 10
  *(p+1) = 20
  *(p+2) = 30
  *(p+3) = 40
  *(p+4) = 50
  int units apart:  1
  bytes apart:      4
EOF

    cat > "$SUBJECTS_DIR/lvl58.txt" << 'EOF'
FILE: rendu/ft_ptrtoptr/ft_ptrtoptr.c

Declare:
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

    cat > "$SUBJECTS_DIR/lvl59.txt" << 'EOF'
FILE: rendu/ft_funcptr/ft_funcptr.c

★ FINAL BOSS ★

Part 1 — Function pointer dispatch table:
  int ft_add(int a, int b) { return a + b; }
  int ft_sub(int a, int b) { return a - b; }
  int ft_mul(int a, int b) { return a * b; }

  Store all three in an array of function pointers and call each.

Part 2 — ft_map:
  void ft_map(int *arr, int n, int (*f)(int))
  Apply a doubling function to {1, 2, 3, 4, 5} and print.

Tip: int (*ops[3])(int, int) = {ft_add, ft_sub, ft_mul};
     Then call: ops[i](10, 3);

Expected output:
  ft_add(10, 3) = 13
  ft_sub(10, 3) = 7
  ft_mul(10, 3) = 30
  2 4 6 8 10

  You have completed the C Mastery Exam. You are ready.
EOF
}
