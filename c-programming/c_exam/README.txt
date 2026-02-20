# **************************************************************************** #
#                                                                              #
#                          MILES3103 C EXAM SYSTEM                             #
#                        Low-Level Mastery Framework                           #
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
* `exam.sh`: The main "Moulinette" (Grader) and Shell interface.
* `subjects/`: Contains the instructions for each level.
* `rendu/`: Your active workspace. All submissions must be here.
* `traces/`: Contains detailed logs of compilation errors or logic failures.
* `.level`: A hidden file that saves your progress automatically.

## 3. HOW TO RUN THE EXAM

### Step A: Setup
Ensure the script is executable:
    $ chmod +x exam.sh

### Step B: Start the Session
Run the script to see your current assignment:
    $ ./exam.sh

### Step C: The Workflow
1. Read the "Assignment" and "How to do it" sections in the Shell.
2. Open a second terminal window.
3. Navigate to the `rendu/` folder and create your file:
    $ nano rendu/task.c
4. Write your code. **Always include <unistd.h>!**

### Step D: Submission
Go back to the Exam Shell terminal and type:
    $ grademe



## 4. TROUBLESHOOTING
If your code fails:
1. Check the `traces/` folder for the latest log.
2. Look for "unused variable" or "missing include" errors.
3. Use `status` in the shell to verify your level.

## 5. RESTARTING
To wipe all progress and start from Level 0 again:
    $ echo 0 > .level

********************************************************************************
* "Success is not final, failure is not fatal: it is the courage to continue  *
* that counts." - Miles3103 C Mastery Shell v6.0                             *
********************************************************************************
