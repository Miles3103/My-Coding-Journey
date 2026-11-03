#include <stdio.h>
#include "stack.h"

int main(void)
{
    Stack *s = stack_create();
    if (!s) return 1;
    for (int i = 1; i <= 5; i++) stack_push(s, i * 10);
    printf("size = %zu\n", stack_size(s));

    int v;
    while (stack_pop(s, &v)) printf("popped %d\n", v);     /* last in, first out */

    stack_destroy(s);
    return 0;
}
