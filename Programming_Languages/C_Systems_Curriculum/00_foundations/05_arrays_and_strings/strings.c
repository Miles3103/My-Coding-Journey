#include <stdio.h>
#include <string.h>

static size_t my_strlen(const char *s)
{
    size_t n = 0;
    while (s[n] != '\0') n++;
    return n;
}

static void reverse_in_place(char *s)
{
    size_t i = 0, j = strlen(s);
    if (j == 0) return;
    j--;
    while (i < j) { char t = s[i]; s[i] = s[j]; s[j] = t; i++; j--; }
}

int main(void)
{
    char word[] = "hello";                  /* a modifiable COPY: 6 bytes (5 + '\0') */
    printf("sizeof(word)=%zu  strlen(word)=%zu\n", sizeof word, strlen(word));
    printf("bytes: ");
    for (size_t i = 0; i < sizeof word; i++) printf("%d ", word[i]);
    printf("\n");

    const char *lit = "literal";            /* points at read-only memory: use const */
    printf("my_strlen(lit) = %zu\n", my_strlen(lit));

    reverse_in_place(word);
    printf("reversed: %s\n", word);

    printf("strcmp(\"apple\",\"banana\") = %s0\n", strcmp("apple", "banana") < 0 ? "<" : ">=");
    printf("strcmp(\"a\",\"a\") == 0 ? %s\n", strcmp("a", "a") == 0 ? "yes" : "no");

    char small[8];
    const char *first = "very", *second = "long-text";
    /* gcc is clever enough to warn that this will be truncated. That warning is the compiler
     * catching the bug for you. We silence it here only because truncation is the point of the demo. */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-truncation"
    int needed = snprintf(small, sizeof small, "%s-%s", first, second);
#pragma GCC diagnostic pop
    printf("snprintf wanted %d chars but the buffer holds %zu: got \"%s\"\n",
           needed, sizeof small - 1, small);
    if ((size_t)needed >= sizeof small) printf("-> truncated! always check the return value\n");
    return 0;
}
