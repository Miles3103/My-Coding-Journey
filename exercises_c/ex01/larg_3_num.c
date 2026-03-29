#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <num1> <num2> <num3>\n", argv[0]);
        return 1;
    }

    int n1 = atoi(argv[1]);
    int n2 = atoi(argv[2]);
    int n3 = atoi(argv[3]);

    printf("1st Number = %d\n", n1);
    printf("2nd Number = %d\n", n2);
    printf("3rd Number = %d\n", n3);

    if (n1 > n2 && n1 > n3) {
        printf("The 1st Number is the greatest\n");
    } else if (n2 > n1 && n2 > n3) {
        printf("The 2nd Number is the greatest\n");
    } else {
        printf("The 3rd Number is the greatest\n");
    }

    return 0;
}
