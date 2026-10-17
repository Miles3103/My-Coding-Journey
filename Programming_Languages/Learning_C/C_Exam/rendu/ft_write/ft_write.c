#include <unistd.h>

int	main(void)
{
	write (1, "*** HEADER ***", 14);
	write (1, "\n", 2);
	write (1, "Content here", 12);
	write (1, "\n", 2);
	write (1, "*** FOOTER ***", 14);
	write (1, "\n", 2);
	return 0;
}	
