/* BUG DEMO: use after free. */
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *p = malloc(sizeof *p);
    *p = 123;
    free(p);
    printf("%d\n", *p);      /* BUG: reading freed memory */
    return 0;
}
