#include <unistd.h>

void	greet()
{
	write (1, "Hello\n", 6);
}

void	farewell()
{
	write (1, "Goodbye\n", 7);
}

int	main()
{
	greet();
	farewell();
	return 0;
}
