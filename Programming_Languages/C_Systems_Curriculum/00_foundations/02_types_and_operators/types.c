#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

int main(void)
{
    printf("== sizes in bytes on THIS machine ==\n");
    printf("char      %zu\n", sizeof(char));
    printf("short     %zu\n", sizeof(short));
    printf("int       %zu\n", sizeof(int));
    printf("long      %zu\n", sizeof(long));
    printf("long long %zu\n", sizeof(long long));
    printf("float     %zu\n", sizeof(float));
    printf("double    %zu\n", sizeof(double));
    printf("void *    %zu\n", sizeof(void *));
    printf("size_t    %zu\n", sizeof(size_t));

    printf("\n== limits ==\n");
    printf("INT_MAX  = %d\n", INT_MAX);
    printf("UINT_MAX = %u\n", UINT_MAX);

    printf("\n== unsigned arithmetic wraps around (well-defined) ==\n");
    uint8_t small = 250;
    small = (uint8_t)(small + 10);
    printf("250 + 10 stored in a uint8_t = %u\n", small);

    printf("\n== integer division truncates toward zero ==\n");
    printf("7 / 2   = %d\n", 7 / 2);
    printf("7 %% 2   = %d\n", 7 % 2);
    printf("-7 / 2  = %d\n", -7 / 2);
    printf("7 / 2.0 = %.2f\n", 7 / 2.0);

    printf("\n== bitwise operators ==\n");
    unsigned a = 0xF0, b = 0x3C;
    printf("a & b  = 0x%02X\n", a & b);
    printf("a | b  = 0x%02X\n", a | b);
    printf("a ^ b  = 0x%02X\n", a ^ b);
    printf("1 << 4 = %u\n", 1u << 4);
    printf("a >> 4 = 0x%X\n", a >> 4);

    printf("\n== chars are small integers ==\n");
    char c = 'A';
    printf("'%c' has value %d; c + 1 is '%c'\n", c, c, c + 1);

    printf("\n== floating point is approximate ==\n");
    printf("0.1 + 0.2 == 0.3 ? %s\n", (0.1 + 0.2 == 0.3) ? "yes" : "no");
    printf("0.1 + 0.2 = %.17f\n", 0.1 + 0.2);

    bool ok = true;
    printf("\nbool true prints as %d\n", ok);
    return 0;
}
