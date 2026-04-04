#include <unistd.h>

int	main(void)
{
	char c = 'a';
	while (c <= 'z')
	{
		write (1, &c, 1);
		write (1, " ", 1);
		c++;
	}
	write (1, "\n", 2);
	char digits = '0';
	while (digits <= '9')
	{
		write (1, &digits, 1);
		write (1, " ", 1);
		digits++;
	}
	write (1, "\n", 1);
}
