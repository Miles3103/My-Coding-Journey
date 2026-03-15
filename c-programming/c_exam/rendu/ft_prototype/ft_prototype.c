#include <unistd.h>

int	add(int a, int b);
int	main(void)
{
	int	Result = add (7, 8);
	char	ten = (Result / 10) + '0';
	char	unit = (Result % 10) + '0';
	write (1, "Result: ", 8);
	write (1, &ten, 1);
	write (1, &unit, 1);
	write (1, "\n", 2);
	return 0;
}

int	add(int a, int b)
{
	return (a + b);
}
