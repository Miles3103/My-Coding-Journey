#!/bin/bash

# **************************************************************************** #
#                                                                              #
#  Project: Miles3103 C Low-Level Mastery Shell                                #
#  Logic:   Automated Grading with write() and unistd.h Enforcement            #
#                                                                              #
# **************************************************************************** #

# 1. INITIALIZATION
mkdir -p subjects rendu traces
if [ ! -f .level ]; then echo 0 > .level; fi

# 2. THE CURRICULUM GENERATOR
generate_subjects() {
cat << 'EOF' > subjects/lvl0.txt
Assignment: low_level_hello
Goal: Print "C is fun\n" using ONLY write().
Constraint: Must include <unistd.h>.
EOF

cat << 'EOF' > subjects/lvl1.txt
Assignment: single_char
Goal: Read one character from stdin and write it back twice.
Example: Input 'a' -> Output 'aa'
EOF

cat << 'EOF' > subjects/lvl2.txt
Assignment: odd_only
Goal: Input an integer. If it's ODD, write "O\n". If it's EVEN, write nothing.
EOF

cat << 'EOF' > subjects/lvl3.txt
Assignment: alphabet_loop
Goal: Write a program that prints the lowercase alphabet 'a-z' followed by '\n'.
Constraint: You must use a loop.
EOF

cat << 'EOF' > subjects/lvl4.txt
Assignment: ft_putstr
Goal: Write a function that takes a string and writes it to stdout.
Submit: A main that calls your function with "Hello 42\n".
EOF

cat << 'EOF' > subjects/lvl5.txt
Assignment: rev_print
Goal: Input a word. Write it to the screen in reverse followed by a newline.
Example: "abc" -> "cba\n"
EOF

cat << 'EOF' > subjects/lvl6.txt
Assignment: pointer_swap
Goal: Write a function 'void swap(int *a, int *b)' that swaps the values.
Submit: Main that initializes a=1, b=2, calls swap, then writes the values.
EOF

cat << 'EOF' > subjects/lvl7.txt
Assignment: array_max
Goal: Create an array of 5 ints. Write the largest number to stdout.
EOF

cat << 'EOF' > subjects/lvl8.txt
Assignment: ft_strlen_manual
Goal: Write your own strlen function. Write the length of "Miles3103" to screen.
EOF

cat << 'EOF' > subjects/lvl9.txt
Assignment: memory_map
Goal: Create a variable. Print its hex address using a pointer and write().
EOF
}
generate_subjects

# 3. THE MOULINETTE (GRADER)
grade_me() {
    LEVEL=$(cat .level)
    TRACE="traces/trace_lvl$LEVEL.txt"
    echo "--- Grading Level $LEVEL ---" | tee $TRACE

    if [ ! -f rendu/task.c ]; then
        echo "❌ Error: rendu/task.c not found." | tee -a $TRACE
        return
    fi

    # Low-level Check
    if ! grep -q "#include <unistd.h>" rendu/task.c; then
        echo "❌ FAILURE: <unistd.h> is mandatory!" | tee -a $TRACE
        return
    fi

    # Strict Compilation (42 Flags)
    gcc -Wall -Wextra -Werror rendu/task.c -o eval_bin 2>> $TRACE
    if [ $? -ne 0 ]; then
        echo "❌ FAILURE: Compilation error. Check $TRACE" | tee -a $TRACE
        return
    fi

    # Automated Testing Logic
    PASS=0
    case $LEVEL in
        0) [[ $(./eval_bin) == "C is fun" ]] && PASS=1 ;;
        1) [[ $(echo "a" | ./eval_bin) == "aa" ]] && PASS=1 ;;
        2) [[ $(echo "3" | ./eval_bin) == "O" ]] && PASS=1 ;;
        3) [[ $(./eval_bin) == "abcdefghijklmnopqrstuvwxyz" ]] && PASS=1 ;;
        4) [[ $(./eval_bin) == "Hello 42" ]] && PASS=1 ;;
        5) [[ $(echo "cat" | ./eval_bin) == "tac" ]] && PASS=1 ;;
        6) [[ $(./eval_bin | xargs) == "2 1" ]] && PASS=1 ;;
        *) PASS=1 ;; # Levels 7-9 are manual review for this version
    esac

    if [ $PASS -eq 1 ]; then
        echo "✅ SUCCESS! Level $LEVEL cleared." | tee -a $TRACE
        echo $((LEVEL + 1)) > .level
        mv rendu/task.c "rendu/passed_lvl$LEVEL.c"
        read -p "Press Enter for the next challenge..."
    else
        echo "❌ FAILURE: Wrong output. Try again!" | tee -a $TRACE
    fi
    rm -f eval_bin
}

# 4. MAIN INTERFACE
while true; do
    LEVEL=$(cat .level)
    clear
    echo "======================================================"
    echo "  MILES3103 LOW-LEVEL EXAM - LEVEL $LEVEL             "
    echo "======================================================"
    if [ -f "subjects/lvl$LEVEL.txt" ]; then
        cat "subjects/lvl$LEVEL.txt"
    else
        echo "🏆 LEGENDARY STATUS REACHED! You finished the list."
        exit 0
    fi
    echo "------------------------------------------------------"
    echo "Commands: grademe | status | exit"
    echo -n "exam $> "
    read input

    case $input in
        "grademe") grade_me ;;
        "status") echo "Current Level: $LEVEL"; ls rendu/passed_* 2>/dev/null; read -p "..." ;;
        "exit") exit 0 ;;
    esac
done
