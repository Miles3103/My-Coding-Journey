#!/bin/bash

# **************************************************************************** #
#                                                                              #
#  Project: Miles3103 C Low-Level Mastery Shell v6.2                           #
#  Feature: Dynamic Directory Per Task (42-Style)                              #
#                                                                              #
# **************************************************************************** #

mkdir -p subjects rendu traces
if [ ! -f .level ]; then echo 0 > .level; fi

# --- SUBJECT GENERATOR ---
generate_subjects() {
cat << 'EOF' > subjects/lvl0.txt
Assignment: low_level_hello
📍 WORK DIR: rendu/lvl0/
📍 FILE:     task.c
Goal: Print "C is fun\n" using write().
EOF

cat << 'EOF' > subjects/lvl1.txt
Assignment: single_char
📍 WORK DIR: rendu/lvl1/
📍 FILE:     task.c
Goal: Read one char and write it twice.
EOF
}
generate_subjects

# --- THE MOULINETTE (Updated for Directories) ---
grade_me() {
    LEVEL=$(cat .level)
    TASK_DIR="rendu/lvl$LEVEL"
    TRACE="traces/trace_lvl$LEVEL.txt"
    
    mkdir -p "$TASK_DIR" # Automatically creates the folder for you
    echo "--- Grading Level $LEVEL ---" | tee $TRACE

    # 1. Check for file in the specific subdirectory
    if [ ! -f "$TASK_DIR/task.c" ]; then
        echo "❌ ERROR: File not found!" | tee -a $TRACE
        echo "   You must save your code in: $TASK_DIR/task.c"
        return
    fi

    # 2. Compile from the subdirectory
    gcc -Wall -Wextra -Werror "$TASK_DIR/task.c" -o eval_bin 2>> $TRACE
    if [ $? -ne 0 ]; then
        echo "❌ FAILURE: Compilation error. Check $TRACE" | tee -a $TRACE
        return
    fi

    # 3. Test Logic
    PASS=0
    case $LEVEL in
        0) [[ $(./eval_bin) == "C is fun" ]] && PASS=1 ;;
        1) [[ $(echo "a" | ./eval_bin) == "aa" ]] && PASS=1 ;;
        *) PASS=1 ;; 
    esac

    if [ $PASS -eq 1 ]; then
        echo "✅ SUCCESS! Level $LEVEL cleared." | tee -a $TRACE
        echo $((LEVEL + 1)) > .level
        read -p "Press Enter for next level..."
    else
        echo "❌ FAILURE: Check your logic in $TRACE" | tee -a $TRACE
    fi
    rm -f eval_bin
}

# --- MAIN LOOP ---
while true; do
    LEVEL=$(cat .level)
    clear
    echo "======================================================"
    echo "  MILES3103 EXAM SYSTEM - LEVEL $LEVEL                "
    echo "  CURRENT DIR: rendu/lvl$LEVEL/                       "
    echo "======================================================"
    if [ -f "subjects/lvl$LEVEL.txt" ]; then
        cat "subjects/lvl$LEVEL.txt"
    else
        echo "🏆 EXAM COMPLETE!"
        exit 0
    fi
    echo "------------------------------------------------------"
    echo "Commands: grademe | exit"
    echo -n "exam $> "
    read input
    [[ "$input" == "grademe" ]] && grade_me
    [[ "$input" == "exit" ]] && exit 0
done
