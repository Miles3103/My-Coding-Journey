#include <stdio.h>
#include <limits.h>

int main(void)
{
    char            a = 'A';
    unsigned char   b = 255;
    short int       c = SHRT_MIN;
    unsigned short  d = USHRT_MAX;
    int             e = INT_MIN;
    unsigned int    f = UINT_MAX;
    long            g = LLONG_MIN;
    unsigned long   h = ULONG_MAX;
    float           i = 3.14f;
    double          j = 3.14159265358979;
    long double     k = 3.14159265358979323846L;
    _Bool           l = 1;

    printf("char:           %c\n",  a);
    printf("unsigned char:  %u\n",  b);
    printf("short:          %hd\n", c);
    printf("unsigned short: %hu\n", d);
    printf("int:            %d\n",  e);
    printf("unsigned int:   %u\n",  f);
    printf("long:           %ld\n", g);
    printf("unsigned long:  %lu\n", h);
    printf("float:          %f\n",  i);
    printf("double:         %lf\n", j);
    printf("long double:    %Lf\n", k);
    printf("bool:           %d\n",  l);
    return 0;
}
