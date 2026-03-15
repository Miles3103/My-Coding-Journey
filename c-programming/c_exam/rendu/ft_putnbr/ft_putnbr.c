#include <unistd.h>
#include <limits.h>

void ft_putnbr(int n)
{
    if (n == INT_MIN)
    {
        write(1, "-2147483648", 11);
        return;
    }
    if (n < 0)
    {
        write(1, "-", 1);
        n = -n;
    }
    if (n >= 10)
        ft_putnbr(n / 10);
    char c = (n % 10) + '0';
    write(1, &c, 1);
}

int main()
{
    ft_putnbr(0);   write(1, "\n", 1);
    ft_putnbr(42);  write(1, "\n", 1);
    ft_putnbr(-7);  write(1, "\n", 1);
    ft_putnbr(100); write(1, "\n", 1);
    return 0;
}
