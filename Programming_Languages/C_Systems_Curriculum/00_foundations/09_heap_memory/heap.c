#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int    *data;     /* heap array, owned by the IntVec */
    size_t  len;      /* elements in use */
    size_t  cap;      /* elements allocated */
} IntVec;

/* Returns 0 on success, -1 if out of memory (the vector is left unchanged). */
static int vec_push(IntVec *v, int x)
{
    if (v->len == v->cap) {
        size_t ncap = v->cap ? v->cap * 2 : 4;            /* double: amortized O(1) */
        if (ncap > SIZE_MAX / sizeof *v->data) return -1; /* would overflow the byte count */
        int *tmp = realloc(v->data, ncap * sizeof *tmp);  /* into a TEMP, so failure can't leak */
        if (!tmp) return -1;
        v->data = tmp;
        v->cap  = ncap;
    }
    v->data[v->len++] = x;
    return 0;
}

static void vec_free(IntVec *v)
{
    free(v->data);
    *v = (IntVec){0};          /* leave a safe, empty vector behind */
}

/* Returns heap memory. The CALLER must free it. */
static char *dup_string(const char *s)
{
    size_t n = strlen(s) + 1;  /* +1 for the '\0' */
    char *copy = malloc(n);
    if (!copy) return NULL;
    memcpy(copy, s, n);
    return copy;
}

int main(void)
{
    IntVec v = {0};
    for (int i = 1; i <= 100; i++) {
        if (vec_push(&v, i * i) != 0) { fprintf(stderr, "out of memory\n"); vec_free(&v); return 1; }
    }
    long total = 0;
    for (size_t i = 0; i < v.len; i++) total += v.data[i];
    printf("pushed %zu squares (capacity grew to %zu), sum = %ld\n", v.len, v.cap, total);
    vec_free(&v);

    char *s = dup_string("copied onto the heap");
    if (!s) return 1;
    printf("%s\n", s);
    free(s);
    s = NULL;                  /* hygiene: a NULL pointer fails loudly, a dangling one fails randomly */

    int *zeros = calloc(8, sizeof *zeros);                /* zero-filled, overflow-checked */
    if (!zeros) return 1;
    printf("calloc'd zeros[7] = %d\n", zeros[7]);
    free(zeros);
    return 0;
}
