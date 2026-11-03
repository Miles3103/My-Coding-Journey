#include <stdio.h>
#include "options.h"

int main(int argc, char *argv[])
{
    Options opts;
    const char *pattern;
    int first_file;

    if (parse_args(argc, argv, &opts, &pattern, &first_file) != 0)
        return 2;

    printf("pattern=%s i=%d n=%d v=%d c=%d r=%d\n", pattern,
           opts.ignore_case, opts.line_numbers, opts.invert,
           opts.count_only, opts.recursive);
    for (int i = first_file; i < argc; i++)
        printf("file: %s\n", argv[i]);
    return 0;
}
