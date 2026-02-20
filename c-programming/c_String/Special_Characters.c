/* ************************************************************************** */
/* */
/* Project: Special Characters (Escape Sequences)                             */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // Using \n for new lines and \t for alignment
    printf("Item:\t\tPrice:\n");
    printf("Apple\t\t$1.50\n");
    printf("Orange\t\t$2.00\n");

    printf("\n"); // Extra space

    // Using \" to include quotes inside a string
    printf("He said, \"Hello Miles3103!\"\n");

    // Using \\ to show a file path
    printf("File location: C:\\Users\\Miles3103\\Desktop\n");

    return (0);
}
