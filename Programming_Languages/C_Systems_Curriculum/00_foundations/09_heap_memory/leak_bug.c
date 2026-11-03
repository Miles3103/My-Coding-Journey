/* BUG DEMO: memory leak. Run it with ASan (make bugs) or valgrind --leak-check=full */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *s = malloc(100);
    strcpy(s, "I will be lost");
    printf("%s\n", s);
    s = malloc(50);          /* BUG: the first block is now unreachable, never freed */
    strcpy(s, "second");
    printf("%s\n", s);
    free(s);
    return 0;
}
