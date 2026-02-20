/* ************************************************************************** */
/* */
/* Project: Basic User Input                                                  */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int age;
    float gpa;

    printf("Enter your age: ");
    // &age is the memory address of the variable
    scanf("%d", &age);

    printf("Enter your GPA: ");
    scanf("%f", &gpa);

    printf("Miles3103 is %d years old with a %.2f GPA.\n", age, gpa);

    return (0);
}
