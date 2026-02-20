/* ************************************************************************** */
/* */
/* Project: Logical NOT Operation                                             */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int is_logged_in = 0;

    // !0 becomes 1 (True)
    if (!is_logged_in)
    {
        printf("Access Denied. Please log in.\n");
    }

    return (0);
}
