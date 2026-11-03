#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

/* atoi("abc") silently returns 0. strtol lets you detect bad input. */
static int parse_long(const char *s, long *out)
{
    char *end;
    errno = 0;
    long v = strtol(s, &end, 10);
    if (errno != 0 || end == s || *end != '\0') return -1;   /* overflow, no digits, or trailing junk */
    *out = v;
    return 0;
}

int main(int argc, char *argv[])
{
    printf("argc = %d\n", argc);
    for (int i = 0; i < argc; i++) printf("argv[%d] = \"%s\"\n", i, argv[i]);

    if (argc == 1) {
        fprintf(stderr, "\nTry:  ./bin/args 12 abc 7x -5\n");
        return 2;
    }

    int bad = 0;
    for (int i = 1; i < argc; i++) {
        long v;
        if (parse_long(argv[i], &v) == 0) printf("%-6s -> number %ld\n", argv[i], v);
        else { fprintf(stderr, "%-6s -> not a valid integer\n", argv[i]); bad = 1; }
    }
    return bad ? 1 : 0;       /* the exit status is how shells and scripts see success */
}
