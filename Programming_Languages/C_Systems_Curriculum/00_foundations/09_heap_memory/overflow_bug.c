/* BUG DEMO: heap buffer overflow (off-by-one). */
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *a = malloc(4 * sizeof *a);
    for (int i = 0; i <= 4; i++)     /* BUG: <= writes a[4], one past the end */
        a[i] = i;
    printf("done: %d\n", a[0]);
    free(a);
    return 0;
}
