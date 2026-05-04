#include <stdio.h>

int main(void) {
    int n, original, reversed = 0, digit;

    printf("Enter a number: ");
    scanf("%d", &n);

    original = n;           /* save original to compare later */

    while (n != 0) {         /* repeat until all digits extracted */
        digit    = n % 10;  /* peel the last digit              */
        reversed = reversed * 10 + digit; /* append to reversed  */
        n        = n / 10;  /* drop the last digit             */
    }

    if (original == reversed)
        printf("%d is a Palindrome\n", original);
    else
        printf("%d is Not a Palindrome\n", original);

    return 0;
}
