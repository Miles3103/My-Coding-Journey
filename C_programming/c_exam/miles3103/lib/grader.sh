#!/usr/bin/env bash
# lib/grader.sh — Compile & grade solutions

# Store last output for 'diff' command
LAST_OUTPUT=""
LAST_EXPECTED=""
LAST_LEVEL=""

grade_me() {
    local level
    level=$(get_level)
    local fname
    fname=$(get_filename "$level")
    local dname
    dname=$(get_dirname "$level")
    local src="$RENDU_DIR/$dname/$fname"
    local trace="$TRACES_DIR/trace_${dname}.txt"
    local bin="$SCRIPT_DIR/.eval_bin"

    mkdir -p "$RENDU_DIR/$dname"

    echo ""
    tbox_top 66
    tbox_line "  ${BOLD}Grading  Level ${level}${RESET}  —  ${C_FILE}${fname}${RESET}" 66
    tbox_bottom 66

    # ── File check ──────────────────────────────────────────────────────
    if [ ! -f "$src" ]; then
        echo ""
        printf "  ${C_FAIL}✗ File not found:${RESET} %s\n" "$src"
        printf "  Create it with: ${C_CMD}open${RESET}  then type ${C_CMD}grademe${RESET} again.\n"
        echo ""
        return 1
    fi

    # ── Compile ─────────────────────────────────────────────────────────
    echo ""
    printf "  ${C_MUTED}Compiling...${RESET}"
    local compile_flags=("-Wall" "-Wextra" "-Werror" "-o" "$bin")
    # level 44 needs math
    [ "$level" -eq 44 ] && compile_flags+=("-lm")

    if gcc "${compile_flags[@]}" "$src" 2>"$trace"; then
        printf "\r  ${C_PASS}✓ Compiled successfully${RESET}          \n"
    else
        printf "\r  ${C_FAIL}✗ Compile error${RESET}                   \n\n"
        # Show errors nicely
        tbox_top 66
        tbox_line "  ${BOLD}${C_FAIL}Compiler Errors${RESET}" 66
        tbox_sep 66
        while IFS= read -r line; do
            tbox_line "  ${C_FAIL}${line}${RESET}" 66
        done < "$trace"
        tbox_bottom 66
        printf "\n  ${C_MUTED}Full trace: %s${RESET}\n\n" "$trace"
        rm -f "$bin"
        return 1
    fi

    # ── Run & capture output ─────────────────────────────────────────────
    local output=""
    case $level in
        51) output=$(echo "Hello42" | "$bin" 2>/dev/null) ;;
        52) output=$(printf "Hello World 42\n" | "$bin" 2>/dev/null) ;;
        53) output=$(printf "hello\nworld\n42\n" | "$bin" 2>/dev/null) ;;
        *)  output=$("$bin" 2>/dev/null) ;;
    esac

    # Save for 'diff' command
    LAST_OUTPUT="$output"
    LAST_EXPECTED=$(get_expected "$level")
    LAST_LEVEL="$level"

    # ── Display output ───────────────────────────────────────────────────
    show_output "$output"

    # ── Save trace ───────────────────────────────────────────────────────
    {
        echo "=== Level $level | $(date) ==="
        echo "$output"
        echo ""
    } >> "$trace"

    # ── Grade logic ──────────────────────────────────────────────────────
    local pass=0
    _run_grade_check "$level" "$output" && pass=1

    rm -f "$bin"

    # ── Result ───────────────────────────────────────────────────────────
    if [ "$pass" -eq 1 ]; then
        add_attempt "$level" "PASS"
        inc_streak
        local is_new=0
        if ! already_passed "$level"; then
            add_score 1
            mark_passed "$level"
            is_new=1
        fi
        local score streak
        score=$(get_score)
        streak=$(get_streak)
        show_pass_banner "$level" "$score" "$streak" "$is_new"
        auto_save
        printf "  ${C_MUTED}Progress auto-saved.${RESET}\n\n"

        local next=$(( level + 1 ))
        set_level "$next"
        if [ "$next" -gt "$MAX_LEVEL" ]; then
            show_completion
            rm -f "$bin"
            exit 0
        fi
        printf "  Press Enter for Level ${BYELLOW}%s${RESET}..." "$next"
        read -r _ < /dev/tty
    else
        add_attempt "$level" "FAIL"
        reset_streak
        local attempts fails total_fail
        attempts=$(get_attempts_for "$level")
        fails=$(get_fails_for "$level")
        total_fail=$(get_total_fail)
        show_fail_banner "$level" "$attempts" "$fails" "$total_fail"

        # Show diff
        local expected
        expected=$(get_expected "$level")
        if [ -n "$expected" ]; then
            show_diff "$expected" "$output" "$level"
        fi

        show_fail_tips "$attempts" "$level"
        printf "  Score: ${BOLD}%s/60${RESET}   Streak reset to 0.\n\n" "$(get_score)"
        sleep 0.3
        press_enter
    fi
}

# ── Grade checks per level ─────────────────────────────────────────────────
_run_grade_check() {
    local level="$1"
    local out="$2"

    case $level in
        0)  [[ "$out" == "Hello, C World!" ]] ;;
        1)  echo "$out" | grep -q "Program starting" &&
            echo "$out" | grep -q "Program done" ;;
        2)  echo "$out" | grep -q "Preprocessing" &&
            echo "$out" | grep -q "Compilation" &&
            echo "$out" | grep -q "Assembly" &&
            echo "$out" | grep -q "Linking" ;;
        3)  [[ "$out" == "Syntax is power" ]] ;;
        4)  echo "$out" | grep -q "Hello" &&
            echo "$out" | grep -q "Goodbye" ;;
        5)  [[ "$out" == "Result: 15" ]] ;;
        6)  echo "$out" | grep -q "HEADER" &&
            echo "$out" | grep -q "Content here" &&
            echo "$out" | grep -q "FOOTER" ;;
        7)  echo "$out" | grep -qx "0" &&
            echo "$out" | grep -qx "42" &&
            echo "$out" | grep -qx "\-7" &&
            echo "$out" | grep -qx "100" ;;
        8)  echo "$out" | grep -q "^a b c d e f" &&
            echo "$out" | grep -q "^0 1 2 3 4 5" ;;
        9)  [[ "$out" == "Comments guide future you" ]] ;;
        10) echo "$out" | grep -q "Length: 5" &&
            echo "$out" | grep -q "IsAlpha: 0" &&
            echo "$out" | grep -q "IsAlpha: 1" ;;
        11) [[ "$out" == "Sum: 10" ]] ;;
        12) echo "$out" | grep -q "letter: X" &&
            echo "$out" | grep -q "count: 2025" &&
            echo "$out" | grep -q "pi_approx: 3.14" &&
            echo "$out" | grep -q "precise: 2.718282" ;;
        13) echo "$out" | grep -q "local g = 999" &&
            echo "$out" | grep -q "global g = 100" ;;
        14) echo "$out" | grep -q "Before: a=5, b=9" &&
            echo "$out" | grep -q "After:  a=9, b=5" ;;
        15) echo "$out" | grep -q "char:" &&
            echo "$out" | grep -q "int:" &&
            echo "$out" | grep -q "float:" &&
            echo "$out" | grep -q "double:" ;;
        16) echo "$out" | grep -q "INT_MAX:  2147483647" &&
            echo "$out" | grep -q "INT_MIN:  -2147483648" &&
            echo "$out" | grep -q "CHAR_MAX: 127" &&
            echo "$out" | grep -q "CHAR_MIN: -128" &&
            echo "$out" | grep -q "Overflow result: -2147483648" ;;
        17) echo "$out" | grep -q "signed char:   -1" &&
            echo "$out" | grep -q "unsigned char: 255" &&
            echo "$out" | grep -q "unsigned underflow: 4294967295" ;;
        18) echo "$out" | grep -q "char from int: A" &&
            echo "$out" | grep -q "int from char: 122" &&
            echo "$out" | grep -q "2.000000" &&
            echo "$out" | grep -q "2.500000" ;;
        19) echo "$out" | grep -q "1 of 3   = 33%" &&
            echo "$out" | grep -q "2 of 3   = 66%" &&
            echo "$out" | grep -q "1 of 4   = 25%" &&
            echo "$out" | grep -q "3 of 4   = 75%" &&
            echo "$out" | grep -q "1 of 7   = 14%" ;;
        20) echo "$out" | grep -q "A -> a" &&
            echo "$out" | grep -q "M -> m" &&
            echo "$out" | grep -q "Z -> z" &&
            echo "$out" | grep -q "'5' -> 5" &&
            echo "$out" | grep -q "'9' -> 9" ;;
        21) echo "$out" | grep -q "BUFFER_SIZE: 1024" &&
            echo "$out" | grep -q "PI: 3.14159265" &&
            echo "$out" | grep -q "MAX_USERS: 100" &&
            echo "$out" | grep -q "SEPARATOR: -" ;;
        22) echo "$out" | grep -q "1: Monday" &&
            echo "$out" | grep -q "2: Tuesday" &&
            echo "$out" | grep -q "3: Wednesday" &&
            echo "$out" | grep -q "7: Sunday" ;;
        23) echo "$out" | grep -q "MAX(3, 7)   = 7" &&
            echo "$out" | grep -q "MIN(3, 7)   = 3" &&
            echo "$out" | grep -q "ABS(-5)     = 5" &&
            echo "$out" | grep -q "SQUARE(4)   = 16" ;;
        24) echo "$out" | grep -q "a & b  = 8" &&
            echo "$out" | grep -q "a | b  = 14" &&
            echo "$out" | grep -q "a ^ b  = 6" &&
            echo "$out" | grep -q "~a     = -11" &&
            echo "$out" | grep -q "a << 1 = 20" &&
            echo "$out" | grep -q "a >> 1 = 5" ;;
        25) echo "$out" | grep -q "x += 4  : 20" &&
            echo "$out" | grep -q "x -= 5  : 15" &&
            echo "$out" | grep -q "x *= 3  : 45" &&
            echo "$out" | grep -q "x /= 9  : 5" &&
            echo "$out" | grep -q "x %= 3  : 2" &&
            echo "$out" | grep -q "x <<= 2 : 8" ;;
        26) echo "$out" | grep -q "negative" &&
            echo "$out" | grep -q "zero" &&
            echo "$out" | grep -q "positive" &&
            echo "$out" | grep -q "abs(-42): 42" ;;
        27) echo "$out" | grep -qF "A=0 B=0: AND=0 OR=0  NOT_A=1" &&
            echo "$out" | grep -qF "A=0 B=1: AND=0 OR=1  NOT_A=1" &&
            echo "$out" | grep -qF "A=1 B=0: AND=0 OR=1  NOT_A=0" &&
            echo "$out" | grep -qF "A=1 B=1: AND=1 OR=1  NOT_A=0" ;;
        28) echo "$out" | grep -q "check_a called" &&
            echo "$out" | grep -q "check_b called" &&
            ! (echo "$out" | grep -A2 "Test 1:" | grep -q "check_b called") &&
            ! (echo "$out" | grep -A2 "Test 2:" | grep -q "check_a called") ;;
        29) echo "$out" | grep -q "hello: invalid" &&
            echo "$out" | grep -q "Hello1!!: valid" &&
            echo "$out" | grep -q "SHORT1A: invalid" &&
            echo "$out" | grep -q "longbutnodigit: invalid" ;;
        30) echo "$out" | grep -q "95: A" &&
            echo "$out" | grep -q "83: B" &&
            echo "$out" | grep -q "71: C" &&
            echo "$out" | grep -q "65: D" &&
            echo "$out" | grep -q "40: F" ;;
        31) echo "$out" | grep -q "Fizz" &&
            echo "$out" | grep -q "Buzz" &&
            echo "$out" | grep -q "FizzBuzz" &&
            [[ "$(echo "$out" | sed -n '3p')"  == "Fizz"     ]] &&
            [[ "$(echo "$out" | sed -n '5p')"  == "Buzz"     ]] &&
            [[ "$(echo "$out" | sed -n '15p')" == "FizzBuzz" ]] ;;
        32) echo "$out" | grep -q "2000: leap" &&
            echo "$out" | grep -q "1900: not leap" &&
            echo "$out" | grep -q "2024: leap" &&
            echo "$out" | grep -q "2023: not leap" ;;
        33) echo "$out" | grep -q "10 + 3 = 13" &&
            echo "$out" | grep -q "10 - 3 = 7" &&
            echo "$out" | grep -q "10 \* 3 = 30" &&
            echo "$out" | grep -q "10 / 3 = 3" &&
            echo "$out" | grep -q "10 / 0 = 0" ;;
        34) echo "$out" | grep -q "a: vowel" &&
            echo "$out" | grep -q "b: consonant" &&
            echo "$out" | grep -q "5: digit" &&
            echo "$out" | grep -q "!: other" ;;
        35) [[ "$out" == "$(printf 'RED\nGREEN\nYELLOW\nRED\nGREEN\nYELLOW')" ]] ;;
        36) [[ "$out" == "$(printf '6\n3\n10\n5\n16\n8\n4\n2\n1\nSteps: 8')" ]] ;;
        37) echo "$out" | grep -q "Invalid: -1" &&
            echo "$out" | grep -q "Invalid: 0" &&
            echo "$out" | grep -q "Invalid: 200" &&
            echo "$out" | grep -q "Valid: 50" &&
            echo "$out" | grep -q "Invalid: -5" &&
            echo "$out" | grep -q "Valid: 42" ;;
        38) echo "$out" | grep -qF "digit_sum(12345)  = 15" &&
            echo "$out" | grep -qF "digit_sum(9999)   = 36" &&
            echo "$out" | grep -qF "ft_reverse(12345) = 54321" &&
            echo "$out" | grep -qF "ft_reverse(100)   = 1" ;;
        39) [[ "$out" == "0 1 1 2 3 5 8 13 21 34" ]] ;;
        40) [[ "$out" == "$(printf '*\n**\n***\n****\n*****\n*****\n****\n***\n**\n*')" ]] ;;
        41) echo "$out" | grep -q "^2 3 5 7 11 13 17 19 23 29 31 37 41 43 47$" &&
            echo "$out" | grep -q "Count: 15" ;;
        42) echo "$out" | grep -q "Found at index 3" &&
            echo "$out" | grep -q "Found at index 4" &&
            echo "$out" | grep -q "Not found" ;;
        43) echo "$out" | grep -q "\[1\]: 7" &&
            echo "$out" | grep -q "\[4\]: 5" &&
            echo "$out" | grep -q "\[6\]: 2" &&
            echo "$out" | grep -q "\[7\]: 9" &&
            echo "$out" | grep -q "\[9\]: 6" &&
            echo "$out" | grep -q "Sum of positives: 29" ;;
        44) echo "$out" | grep -q "(1,1)=1" &&
            echo "$out" | grep -q "(1,4)=4" &&
            echo "$out" | grep -q "(2,2)=4" &&
            echo "$out" | grep -q "(3,3)=9" &&
            echo "$out" | grep -q "(4,4)=16" &&
            echo "$out" | grep -q "(5,5)=25" ;;
        45) echo "$out" | grep -q "Min: 1" &&
            echo "$out" | grep -q "Max: 10" &&
            echo "$out" | grep -q "Sum: 55" &&
            echo "$out" | grep -q "Avg: 5.50" ;;
        46) echo "$out" | grep -qF "Before: 64 34 25 12 22 11 90" &&
            echo "$out" | grep -qF "After:  11 12 22 25 34 64 90" ;;
        47) echo "$out" | grep -q "^1 2 3$" &&
            echo "$out" | grep -q "^4 5 6$" &&
            echo "$out" | grep -q "^7 8 9$" &&
            echo "$out" | grep -q "Sum: 45" &&
            echo "$out" | grep -q "Trace: 15" ;;
        48) echo "$out" | grep -q "strlen: 5" &&
            echo "$out" | grep -q "strcpy: world" &&
            echo "$out" | grep -q "strcmp equal: 0" &&
            echo "$out" | grep -q "strchr: llo" ;;
        49) echo "$out" | grep -q "upper: HELLO WORLD" &&
            echo "$out" | grep -q "lower: hello world" &&
            echo "$out" | grep -q "reverse: edcba" &&
            echo "$out" | grep -q "words: 4" ;;
        50) echo "$out" | grep -qF 'atoi("42"):    42' &&
            echo "$out" | grep -qF 'atoi("-100"):  -100' &&
            echo "$out" | grep -qF 'atoi("0"):     0' &&
            echo "$out" | grep -qF 'itoa(12345):   12345' &&
            echo "$out" | grep -qF 'itoa(-7):      -7' ;;
        51) echo "$out" | grep -q "You entered: Hello42" ;;
        52) echo "$out" | grep -q "Uppercase: 2" &&
            echo "$out" | grep -q "Lowercase: 8" &&
            echo "$out" | grep -q "Digits: 2" &&
            echo "$out" | grep -q "Spaces: 2" ;;
        53) echo "$out" | grep -q "Line 1 (len=5): hello" &&
            echo "$out" | grep -q "Line 2 (len=5): world" &&
            echo "$out" | grep -q "Line 3 (len=2): 42" ;;
        54) echo "$out" | grep -q "global: 0x" &&
            echo "$out" | grep -q "stack:  0x" &&
            echo "$out" | grep -q "heap:   0x" ;;
        55) echo "$out" | grep -q "After double_val: 5" &&
            echo "$out" | grep -q "After double_ref: 10" ;;
        56) echo "$out" | grep -q "Before swap: a=10, b=20" &&
            echo "$out" | grep -q "After swap:  a=20, b=10" &&
            echo "$out" | grep -q "Before swap: s1=hello, s2=world" &&
            echo "$out" | grep -q "After swap:  s1=world, s2=hello" ;;
        57) echo "$out" | grep -qF "*p     = 10" &&
            echo "$out" | grep -qF "*(p+4) = 50" &&
            echo "$out" | grep -q "int units apart:  1" &&
            echo "$out" | grep -q "bytes apart:      4" ;;
        58) echo "$out" | grep -q "x    = 42" &&
            echo "$out" | grep -qF "**pp = 42" &&
            echo "$out" | grep -qF "After **pp = 99: x = 99" ;;
        59) echo "$out" | grep -q "ft_add(10, 3) = 13" &&
            echo "$out" | grep -q "ft_sub(10, 3) = 7" &&
            echo "$out" | grep -q "ft_mul(10, 3) = 30" &&
            echo "$out" | grep -q "2 4 6 8 10" &&
            echo "$out" | grep -q "You have completed" ;;
        *)  return 0 ;;
    esac
}
