/* ************************************************************************** */
/* */
/* Project: String Copying                                                    */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>

int main(void)
{
    char src[] = "Copy This";
    char dest[20];

    strcpy(dest, src);
    printf("Destination now holds: %s\n", dest);

    return (0);
}
