#include <stdio.h>

int main(void) {
    int number;
    int original_number;
    int reversed_number = 0;

    printf("Input a number: ");
    scanf("%d", &number);

    original_number = number;

    while (number != 0) {
        reversed_number = reversed_number * 10 + (number % 10);
        number /= 10;
    }

    if (original_number == reversed_number) {
        printf("Palindrome\n");
    } else {
        printf("Not Palindrome\n");
    }

    return 0;
}
