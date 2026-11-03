#ifndef OPTIONS_H
#define OPTIONS_H

#include <stdbool.h>

typedef struct {
    bool ignore_case;   /* -i */
    bool line_numbers;  /* -n */
    bool invert;        /* -v */
    bool count_only;    /* -c */
    bool recursive;     /* -r */
} Options;

/* Returns 0 on success, -1 on bad usage (message already printed to stderr).
 * *pattern points INTO argv (not owned; do not free).
 * *first_file is the index in argv of the first file operand (== argc if none). */
int parse_args(int argc, char **argv, Options *opts,
               const char **pattern, int *first_file);

#endif
