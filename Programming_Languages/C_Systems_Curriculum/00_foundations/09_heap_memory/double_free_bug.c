/* BUG DEMO: double free. */
#include <stdlib.h>

int main(void)
{
    char *p = malloc(16);
    free(p);
    free(p);                 /* BUG: freeing the same block twice corrupts the allocator */
    return 0;
}
