#include <stdio.h>

static const char *grade(int score)
{
    switch (score / 10) {
    case 10:
    case 9:  return "A";
    case 8:  return "B";
    case 7:  return "C";
    default: return "F";
    }
}

int main(void)
{
    printf("== FizzBuzz 1..15 (for loop, if / else if) ==\n");
    for (int i = 1; i <= 15; i++) {
        if (i % 15 == 0)      printf("FizzBuzz ");
        else if (i % 3 == 0)  printf("Fizz ");
        else if (i % 5 == 0)  printf("Buzz ");
        else                  printf("%d ", i);
    }
    printf("\n");

    printf("\n== switch ==\n");
    int scores[] = {95, 83, 71, 40};
    for (size_t i = 0; i < sizeof scores / sizeof scores[0]; i++)
        printf("score %d -> %s\n", scores[i], grade(scores[i]));

    printf("\n== while: Collatz sequence from 6 ==\n");
    unsigned n = 6;
    while (n != 1) {
        printf("%u ", n);
        n = (n % 2 == 0) ? n / 2 : 3 * n + 1;     /* ternary operator */
    }
    printf("1\n");

    printf("\n== do/while runs at least once ==\n");
    int k = 10;
    do { printf("k = %d\n", k); k++; } while (k < 10);

    printf("\n== break and continue: odd numbers below 10, stop at 7 ==\n");
    for (int i = 0; i < 100; i++) {
        if (i % 2 == 0) continue;     /* skip evens */
        if (i > 7) break;             /* leave the loop */
        printf("%d ", i);
    }
    printf("\n");

    printf("\n== short-circuit: the right side is skipped when not needed ==\n");
    int d = 0;
    if (d != 0 && 10 / d > 1) printf("never reached\n");
    else printf("no division by zero happened\n");
    return 0;
}
