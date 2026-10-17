#include <unistd.h>

/**
 * @desc   Calculates the length of a null-terminated string.
 * @param  s - A pointer to the first character of the string.
 * @return The total number of characters in the string, excluding the null byte.
 */
int ft_strlen(char *s)
{
    int i;

    i = 0;
    while (s[i] != '\0')
    {
        i++;
    }
    return (i);
}

/**
 * @desc   Checks if the given character is an alphabet letter.
 * @param  c - The character to evaluate.
 * @return 1 if the character is an uppercase or lowercase letter, 0 otherwise.
 */
int ft_isalpha(char c)
{
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
    {
        return (1);
    }
    return (0);
}

/**
 * Helper function to print a single character using unistd.h
 */
void ft_putchar(char c)
{
    write(1, &c, 1);
}

/**
 * Helper function to print a positive number using unistd.h
 */
void ft_putnbr(int n)
{
    if (n >= 10)
    {
        ft_putnbr(n / 10);
    }
    ft_putchar((n % 10) + '0');
}

/**
 * Helper function to print a string using unistd.h
 */
void ft_putstr(char *s)
{
    write(1, s, ft_strlen(s));
}

int main(void)
{
    // Test 1: ft_strlen("hello")
    ft_putstr("Length: ");
    ft_putnbr(ft_strlen("hello"));
    ft_putstr("\n");

    // Test 2: ft_isalpha('3')
    ft_putstr("IsAlpha: ");
    ft_putnbr(ft_isalpha('3'));
    ft_putstr("\n");

    // Test 3: ft_isalpha('z')
    ft_putstr("IsAlpha: ");
    ft_putnbr(ft_isalpha('z'));
    ft_putstr("\n");

    return (0);
}
