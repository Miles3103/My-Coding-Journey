/* ************************************************************************** */
/* */
/* Project: Grade & Boundary Checker                                         */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <stdbool.h>

int main(void)
{
    double score = 89.5;
    char   grade;
    bool   is_passing;

    // 1. Logic Ladder for Grade Assignment
    if (score >= 90.0) {
        grade = 'A';
    } else if (score >= 80.0) {
        grade = 'B';
    } else if (score >= 70.0) {
        grade = 'C';
    } else {
        grade = 'F';
    }

    // 2. Boolean Logic for Pass/Fail Status
    // Any score 70 or above is a pass
    is_passing = (score >= 70.0);

    // 3. Formatted Output
    printf("--- Final Results ---\n");
    printf("Score:  %.1f\n", score);
    printf("Grade:  %c\n", grade);
    
    // Using ternary operator for a clean string output
    printf("Status: %s\n", is_passing ? "PASSED" : "FAILED");

    return (0);
}
