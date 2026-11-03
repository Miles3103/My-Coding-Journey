#ifndef SEARCH_H
#define SEARCH_H

#include <stdio.h>
#include "options.h"

/* Searches one open stream. Does not close fp (the caller owns it).
 * label is the name shown in output (filename or "(stdin)").
 * Returns the number of matching lines, or -1 on a read error. */
long search_stream(FILE *fp, const char *label,
                   const char *pattern, const Options *o);

/* Searches a file, or a directory tree when o->recursive is set.
 * Returns the number of matching lines, or -1 on error. */
long search_path(const char *path, const char *pattern, const Options *o);

#endif
