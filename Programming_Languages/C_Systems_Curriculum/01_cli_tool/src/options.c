#define _POSIX_C_SOURCE 200809L   /* exposes getopt() under -std=c11 */
#include <stdio.h>
#include <unistd.h>
#include "options.h"

static void usage(const char *prog)
{
    fprintf(stderr, "usage: %s [-invcr] PATTERN [FILE...]\n", prog);
}

int parse_args(int argc, char **argv, Options *opts,
               const char **pattern, int *first_file)
{
    *opts = (Options){0};                       /* all flags start false */
    int c;
    while ((c = getopt(argc, argv, "invcr")) != -1) {
        switch (c) {
        case 'i': opts->ignore_case  = true; break;
        case 'n': opts->line_numbers = true; break;
        case 'v': opts->invert       = true; break;
        case 'c': opts->count_only   = true; break;
        case 'r': opts->recursive    = true; break;
        default:  usage(argv[0]); return -1;    /* getopt already printed the error */
        }
    }
    if (optind >= argc) {                       /* no PATTERN given */
        usage(argv[0]);
        return -1;
    }
    *pattern    = argv[optind];
    *first_file = optind + 1;
    return 0;
}
