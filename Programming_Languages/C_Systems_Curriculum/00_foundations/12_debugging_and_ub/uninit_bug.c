/* BUG DEMO: reading an uninitialized variable. ASan will NOT catch this; valgrind will. */
#include <stdio.h>

int main(void)
{
    int total;                       /* BUG: never initialized */
    for (int i = 1; i <= 10; i++) total += i;
    if (total > 50) printf("big: %d\n", total);
    else            printf("small: %d\n", total);
    return 0;
}
