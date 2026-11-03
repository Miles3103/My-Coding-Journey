#include <stdio.h>

static void swap(int *a, int *b)
{
    int t = *a;
    *a = *b;
    *b = t;
}

/* "Out parameters": returns status, hands results back through pointers. */
static int divide(int num, int den, int *quot, int *rem)
{
    if (den == 0) return -1;
    *quot = num / den;
    *rem  = num % den;
    return 0;
}

int main(void)
{
    int x = 42;
    int *p = &x;                      /* p holds the ADDRESS of x */
    printf("x = %d, stored at address %p\n", x, (void *)&x);
    printf("p = %p, *p = %d\n", (void *)p, *p);

    *p = 99;                          /* write THROUGH the pointer */
    printf("after *p = 99: x = %d\n", x);

    int a = 1, b = 2;
    swap(&a, &b);
    printf("after swap(&a,&b): a=%d b=%d\n", a, b);

    int q, r;
    if (divide(17, 5, &q, &r) == 0) printf("17 / 5 = %d remainder %d\n", q, r);

    int *nothing = NULL;
    printf("nothing is %s\n", nothing == NULL ? "NULL (points nowhere; never dereference it)" : "valid");

    int **pp = &p;                    /* pointer to a pointer */
    **pp = 7;
    printf("after **pp = 7: x = %d\n", x);

    printf("a pointer is %zu bytes on this machine\n", sizeof p);
    return 0;
}
