#include <stdlib.h>
#include "stack.h"

struct Stack {                         /* the real definition lives ONLY here */
    int    *items;
    size_t  len, cap;
};

static bool grow(Stack *s)             /* static = private to this file */
{
    size_t ncap = s->cap ? s->cap * 2 : 4;
    int *tmp = realloc(s->items, ncap * sizeof *tmp);
    if (!tmp) return false;
    s->items = tmp;
    s->cap   = ncap;
    return true;
}

Stack *stack_create(void)
{
    return calloc(1, sizeof(Stack));
}

void stack_destroy(Stack *s)
{
    if (!s) return;
    free(s->items);
    free(s);
}

bool stack_push(Stack *s, int v)
{
    if (s->len == s->cap && !grow(s)) return false;
    s->items[s->len++] = v;
    return true;
}

bool stack_pop(Stack *s, int *out)
{
    if (s->len == 0) return false;
    *out = s->items[--s->len];
    return true;
}

size_t stack_size(const Stack *s) { return s->len; }
