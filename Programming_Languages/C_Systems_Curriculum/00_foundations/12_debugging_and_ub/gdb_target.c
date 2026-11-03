/* A program with LOGIC bugs (no crash). Use gdb to find them.
 * Expected: max of {-8,-3,-5} is -3, and the average of {1,2,4} is 2.33. */
#include <stdio.h>

static int find_max(const int *a, int n)
{
    int max = 0;                       /* BUG 1: what if every number is negative? */
    for (int i = 0; i < n; i++)
        if (a[i] > max) max = a[i];
    return max;
}

static double average(const int *a, int n)
{
    int sum = 0;
    for (int i = 0; i < n; i++) sum += a[i];
    return sum / n;                    /* BUG 2: integer division happens BEFORE the conversion */
}

int main(void)
{
    int neg[] = {-8, -3, -5};
    int pos[] = {1, 2, 4};
    printf("max of neg = %d (expected -3)\n", find_max(neg, 3));
    printf("average of pos = %.2f (expected 2.33)\n", average(pos, 3));
    return 0;
}
