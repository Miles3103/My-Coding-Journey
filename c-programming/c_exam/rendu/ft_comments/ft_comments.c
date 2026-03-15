/*
** comments_demo.c
**
** Demonstrates the four main comment styles used in C.
** Good comments explain WHY the code does something,
** not WHAT it does — the code itself shows the what.
**
** Author : Miles
** Created: 2026
*/

#include <unistd.h>

/*
** ft_putstr - writes a null-terminated string to stdout.
** We use write() directly instead of printf() to stay
** close to the metal — no hidden buffering or formatting.
*/
void    ft_putstr(char *str)
{
    int i;

    i = 0;
    while (str[i] != '\0')
    {
        write(1, &str[i], 1);
        i++;
    }
}

int main(void)
{
    char *msg = "Comments guide future you"; /* the message we want to print */

    /* TODO: add ft_putnbr() here later to also print the message length */

    ft_putstr(msg);
    write(1, "\n", 1);
    return (0);
}
