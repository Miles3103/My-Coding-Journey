/* BUG DEMO: stack buffer overflow. ASan reports it with the exact line. */
#include <stdio.h>

int main(int argc, char **argv)
{
    (void)argv;
    int a[5] = {0};
    volatile int i = 4 + argc;       /* 5 when run with no arguments */
    a[i] = 1;                        /* BUG: a has indexes 0..4 */
    printf("%d\n", a[0]);
    return 0;
}
