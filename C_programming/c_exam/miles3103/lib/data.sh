#!/usr/bin/env bash
# lib/data.sh — Level metadata & expected outputs

MAX_LEVEL=59

FILENAMES=(
    "ft_hello.c"        "ft_return.c"       "ft_pipeline.c"
    "ft_structure.c"    "ft_functions.c"    "ft_prototype.c"
    "ft_write.c"        "ft_putnbr.c"       "ft_print_combo.c"
    "ft_comments.c"     "ft_doccomment.c"   "ft_bugfix.c"
    "ft_variables.c"    "ft_scope.c"        "ft_swap.c"
    "ft_sizeof.c"       "ft_limits.c"       "ft_unsigned.c"
    "ft_implicit.c"     "ft_percent.c"      "ft_ascii.c"
    "ft_define.c"       "ft_enum.c"         "ft_macros.c"
    "ft_bitwise.c"      "ft_compound.c"     "ft_ternary.c"
    "ft_truth_table.c"  "ft_shortcircuit.c" "ft_password.c"
    "ft_grade.c"        "ft_fizzbuzz.c"     "ft_leap.c"
    "ft_calc.c"         "ft_chartype.c"     "ft_statemachine.c"
    "ft_collatz.c"      "ft_dowhile.c"      "ft_digitsum.c"
    "ft_fibonacci.c"    "ft_patterns.c"     "ft_prime.c"
    "ft_find.c"         "ft_filter.c"       "ft_nested.c"
    "ft_stats.c"        "ft_bubblesort.c"   "ft_matrix.c"
    "ft_strfuncs.c"     "ft_strmanip.c"     "ft_numconv.c"
    "ft_readbuf.c"      "ft_parseinput.c"   "ft_multiline.c"
    "ft_memaddr.c"      "ft_passref.c"      "ft_swapptr.c"
    "ft_ptrarith.c"     "ft_ptrtoptr.c"     "ft_funcptr.c"
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
get_subtask()  { echo $(( ($1 % 3) + 1 )); }

# ── Expected outputs ───────────────────────────────────────────────────────
get_expected() {
    case $1 in
        0)  printf 'Hello, C World!' ;;
        1)  printf 'Program starting\nProgram done' ;;
        2)  printf '1. Preprocessing\n2. Compilation\n3. Assembly\n4. Linking' ;;
        3)  printf 'Syntax is power' ;;
        4)  printf 'Hello\nGoodbye' ;;
        5)  printf 'Result: 15' ;;
        6)  printf '*** HEADER ***\n\nContent here\n\n*** FOOTER ***' ;;
        7)  printf '0\n42\n-7\n100' ;;
        8)  printf 'a b c d e f g h i j k l m n o p q r s t u v w x y z\n0 1 2 3 4 5 6 7 8 9' ;;
        9)  printf 'Comments guide future you' ;;
        10) printf 'Length: 5\nIsAlpha: 0\nIsAlpha: 1' ;;
        11) printf 'Sum: 10' ;;
        12) printf 'letter: X\ncount: 2025\npi_approx: 3.14\nprecise: 2.718282' ;;
        13) printf 'local g = 999\nglobal g = 100' ;;
        14) printf 'Before: a=5, b=9\nAfter:  a=9, b=5' ;;
        15) printf 'char:      1 bytes\nint:       4 bytes\nfloat:     4 bytes\ndouble:    8 bytes' ;;
        16) printf 'INT_MAX:  2147483647\nINT_MIN:  -2147483648\nCHAR_MAX: 127\nCHAR_MIN: -128\nOverflow result: -2147483648' ;;
        17) printf 'signed char:   -1\nunsigned char: 255\nunsigned underflow: 4294967295' ;;
        18) printf 'char from int: A\nint from char: 122\nint division stored as double: 2.000000\ncast before division: 2.500000' ;;
        19) printf '1 of 3   = 33%%\n2 of 3   = 66%%\n1 of 4   = 25%%\n3 of 4   = 75%%\n1 of 7   = 14%%' ;;
        20) printf "A -> a\nM -> m\nZ -> z\n'5' -> 5\n'9' -> 9" ;;
        21) printf 'BUFFER_SIZE: 1024\nPI: 3.14159265\nMAX_USERS: 100\nSEPARATOR: -' ;;
        22) printf '1: Monday\n2: Tuesday\n3: Wednesday\n4: Thursday\n5: Friday\n6: Saturday\n7: Sunday' ;;
        23) printf 'MAX(3, 7)   = 7\nMIN(3, 7)   = 3\nABS(-5)     = 5\nSQUARE(4)   = 16' ;;
        24) printf 'a & b  = 8\na | b  = 14\na ^ b  = 6\n~a     = -11\na << 1 = 20\na >> 1 = 5' ;;
        25) printf 'x += 4  : 20\nx -= 5  : 15\nx *= 3  : 45\nx /= 9  : 5\nx %%= 3  : 2\nx <<= 2 : 8' ;;
        26) printf '-5: negative\n0: zero\n3: positive\nabs(-42): 42' ;;
        27) printf 'A=0 B=0: AND=0 OR=0  NOT_A=1\nA=0 B=1: AND=0 OR=1  NOT_A=1\nA=1 B=0: AND=0 OR=1  NOT_A=0\nA=1 B=1: AND=1 OR=1  NOT_A=0' ;;
        28) printf 'Test 1:\ncheck_a called\nTest 2:\ncheck_b called' ;;
        29) printf 'hello: invalid\nHello1!!: valid\nSHORT1A: invalid\nlongbutnodigit: invalid' ;;
        30) printf '95: A\n83: B\n71: C\n65: D\n40: F' ;;
        31) printf '1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz' ;;
        32) printf '2000: leap\n1900: not leap\n2024: leap\n2023: not leap' ;;
        33) printf '10 + 3 = 13\n10 - 3 = 7\n10 * 3 = 30\n10 / 3 = 3\n10 / 0 = 0' ;;
        34) printf 'a: vowel\nb: consonant\n5: digit\n!: other' ;;
        35) printf 'RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW' ;;
        36) printf '6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8' ;;
        37) printf 'Invalid: -1\nInvalid: 0\nInvalid: 200\nValid: 50\nInvalid: -5\nValid: 42' ;;
        38) printf 'digit_sum(12345)  = 15\ndigit_sum(9999)   = 36\nft_reverse(12345) = 54321\nft_reverse(100)   = 1' ;;
        39) printf '0 1 1 2 3 5 8 13 21 34' ;;
        40) printf '*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*' ;;
        41) printf '2 3 5 7 11 13 17 19 23 29 31 37 41 43 47\nCount: 15' ;;
        42) printf 'Find 8:  Found at index 3\nFind 42: Found at index 4\nFind 99: Not found' ;;
        43) printf '[1]: 7\n[4]: 5\n[6]: 2\n[7]: 9\n[9]: 6\nSum of positives: 29' ;;
        44) printf '(1,1)=1\n(1,4)=4\n(2,2)=4\n(3,3)=9\n(4,4)=16\n(5,5)=25' ;;
        45) printf 'Min: 1\nMax: 10\nSum: 55\nAvg: 5.50' ;;
        46) printf 'Before: 64 34 25 12 22 11 90\nAfter:  11 12 22 25 34 64 90' ;;
        47) printf '1 2 3\n4 5 6\n7 8 9\nSum: 45\nTrace: 15' ;;
        48) printf 'strlen: 5\nstrcpy: world\nstrcmp equal: 0\nstrcmp diff: nonzero\nstrchr: llo' ;;
        49) printf 'upper: HELLO WORLD\nlower: hello world\nreverse: edcba\nwords: 4' ;;
        50) printf 'atoi("42"):    42\natoi("-100"):  -100\natoi("0"):     0\nitoa(12345):   12345\nitoa(-7):      -7' ;;
        51) printf 'You entered: Hello42' ;;
        52) printf 'Uppercase: 2\nLowercase: 8\nDigits: 2\nSpaces: 2' ;;
        53) printf 'Line 1 (len=5): hello\nLine 2 (len=5): world\nLine 3 (len=2): 42' ;;
        54) printf 'global: 0x[addr]\nstack:  0x[addr]\nheap:   0x[addr]' ;;
        55) printf 'After double_val: 5\nAfter double_ref: 10' ;;
        56) printf 'Before swap: a=10, b=20\nAfter swap:  a=20, b=10\nBefore swap: s1=hello, s2=world\nAfter swap:  s1=world, s2=hello' ;;
        57) printf '*p     = 10\n*(p+1) = 20\n*(p+2) = 30\n*(p+3) = 40\n*(p+4) = 50\nint units apart:  1\nbytes apart:      4' ;;
        58) printf 'x    = 42\n*p   = 42\n**pp = 42\nAfter **pp = 99: x = 99' ;;
        59) printf 'ft_add(10, 3) = 13\nft_sub(10, 3) = 7\nft_mul(10, 3) = 30\n2 4 6 8 10\n\nYou have completed the C Mastery Exam. You are ready.' ;;
        *)  printf '' ;;
    esac
}
