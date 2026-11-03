#define _POSIX_C_SOURCE 200809L          /* for getline() */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    const char *txt = "fileio_demo.txt", *bin = "fileio_demo.bin";

    /* ---- write text ---- */
    FILE *fp = fopen(txt, "w");
    if (!fp) { perror(txt); return 1; }
    fprintf(fp, "first line\nsecond line\nthird line (no newline at the end)");
    if (fclose(fp) != 0) { perror("fclose"); return 1; }      /* fclose can fail too: it flushes */

    /* ---- read text, line by line, any length ---- */
    fp = fopen(txt, "r");
    if (!fp) { perror(txt); return 1; }
    char *line = NULL;
    size_t cap = 0;
    ssize_t len;
    int n = 0;
    while ((len = getline(&line, &cap, fp)) != -1) {
        n++;
        printf("line %d (%zd bytes): %s%s", n, len, line, line[len - 1] == '\n' ? "" : "\n");
    }
    free(line);
    if (ferror(fp)) perror("read");
    fclose(fp);

    /* ---- binary: raw bytes of an int array ---- */
    int out[5] = {10, 20, 30, 40, 50}, in[5] = {0};
    fp = fopen(bin, "wb");
    if (!fp) { perror(bin); return 1; }
    if (fwrite(out, sizeof out[0], 5, fp) != 5) { perror("fwrite"); fclose(fp); return 1; }
    fclose(fp);

    fp = fopen(bin, "rb");
    if (!fp) { perror(bin); return 1; }
    size_t got = fread(in, sizeof in[0], 5, fp);
    fclose(fp);
    printf("binary round trip read %zu ints, in[4] = %d\n", got, in[4]);

    /* ---- errors: errno, perror, strerror ---- */
    FILE *missing = fopen("/no/such/file", "r");
    if (!missing) {
        int saved = errno;                                    /* save it before other calls change it */
        perror("fopen(/no/such/file)");
        printf("errno = %d -> \"%s\"\n", saved, strerror(saved));
    }

    remove(txt);
    remove(bin);
    return 0;
}
