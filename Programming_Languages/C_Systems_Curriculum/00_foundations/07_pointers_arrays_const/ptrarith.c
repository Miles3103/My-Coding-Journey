#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

static size_t my_strlen(const char *s)
{
    const char *p = s;
    while (*p) p++;
    return (size_t)(p - s);          /* pointer subtraction counts elements */
}

static char *my_strcpy(char *dst, const char *src)
{
    char *d = dst;
    while ((*d++ = *src++)) { }      /* copies the '\0' too, then the loop ends */
    return dst;
}

static int cmp_int(const void *a, const void *b)
{
    int x = *(const int *)a, y = *(const int *)b;
    return (x > y) - (x < y);        /* -1, 0 or 1, and no overflow like x - y could cause */
}

static int twice(int x)  { return 2 * x; }
static int square(int x) { return x * x; }
static int apply(int (*f)(int), int v) { return f(v); }   /* f is a function pointer */

static void swap_bytes(void *a, void *b, size_t n)        /* void* = "address of anything" */
{
    unsigned char tmp[64];
    assert(n <= sizeof tmp);
    memcpy(tmp, a, n);
    memcpy(a, b, n);
    memcpy(b, tmp, n);
}

int main(void)
{
    int a[] = {10, 20, 30, 40};
    printf("a[2] = %d, *(a + 2) = %d  (identical: a[i] means *(a + i))\n", a[2], *(a + 2));

    int *p = a;
    p += 3;                          /* moves 3 * sizeof(int) BYTES, not 3 bytes */
    printf("p - a = %td elements, *p = %d\n", p - a, *p);

    char buf[32];
    my_strcpy(buf, "pointers");
    printf("my_strcpy -> \"%s\", my_strlen = %zu\n", buf, my_strlen(buf));

    int unsorted[] = {5, -2, 9, 0, 3};
    qsort(unsorted, 5, sizeof unsorted[0], cmp_int);   /* function pointer as a callback */
    printf("sorted: ");
    for (int i = 0; i < 5; i++) printf("%d ", unsorted[i]);
    printf("\n");

    printf("apply(twice, 7) = %d, apply(square, 7) = %d\n", apply(twice, 7), apply(square, 7));

    double d1 = 1.5, d2 = 2.5;
    swap_bytes(&d1, &d2, sizeof d1);
    printf("generic swap: d1=%.1f d2=%.1f\n", d1, d2);

    const char *ro = "read-only text";      /* pointer to const char: can't modify the text */
    char *const fixed = buf;                /* const pointer: can't repoint, CAN modify the text */
    fixed[0] = 'P';
    printf("%s | %s\n", ro, buf);
    return 0;
}
