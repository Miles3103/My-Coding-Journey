#include <stdio.h>
#include <string.h>

int main(void)
{
    char str[] = "it's wonderful life!";
    int count = 0;

    for (size_t i = 0; i < strlen(str); i++)
    {
        char c = str[i];
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
            c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U')
        {
            count++;
        }
    }
    
    printf("%d\n", count);
    return 0;
}
