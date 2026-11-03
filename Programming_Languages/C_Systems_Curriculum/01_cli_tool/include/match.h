#ifndef MATCH_H
#define MATCH_H

#include <stdbool.h>

/* Returns true if line contains pattern.
 * Case-insensitive when ignore_case is true. An empty pattern matches every line. */
bool line_matches(const char *line, const char *pattern, bool ignore_case);

#endif
