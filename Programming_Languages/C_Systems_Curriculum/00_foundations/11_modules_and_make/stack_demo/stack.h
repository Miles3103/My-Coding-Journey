#ifndef STACK_H          /* include guard: stops the file being read twice */
#define STACK_H

#include <stdbool.h>
#include <stddef.h>

typedef struct Stack Stack;           /* opaque: callers can't see inside */

Stack *stack_create(void);            /* returns heap memory; free with stack_destroy */
void   stack_destroy(Stack *s);       /* safe on NULL */
bool   stack_push(Stack *s, int v);   /* false if out of memory */
bool   stack_pop(Stack *s, int *out); /* false if empty */
size_t stack_size(const Stack *s);

#endif
