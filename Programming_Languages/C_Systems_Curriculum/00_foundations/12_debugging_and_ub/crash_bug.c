/* BUG DEMO: segmentation fault from a NULL pointer. Debug with gdb: run, bt, frame, print */
#include <stdio.h>
#include <string.h>

typedef struct { const char *name; int score; } Entry;

static Entry table[] = { {"ada", 90}, {"linus", 80} };

static Entry *lookup(const char *name)
{
    for (size_t i = 0; i < 2; i++)
        if (strcmp(table[i].name, name) == 0) return &table[i];
    return NULL;                                   /* "not found" */
}

int main(void)
{
    printf("ada   = %d\n", lookup("ada")->score);
    printf("grace = %d\n", lookup("grace")->score);   /* BUG: NULL->score */
    return 0;
}
