/* BUG DEMO: signed integer overflow is undefined behavior. UBSan reports it at runtime. */
#include <limits.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    (void)argv;
    int x = INT_MAX - 1 + argc;      /* INT_MAX when run with no arguments */
    int y = x + 1;                   /* BUG: overflow; the compiler may assume this never happens */
    printf("%d\n", y);
    return 0;
}
