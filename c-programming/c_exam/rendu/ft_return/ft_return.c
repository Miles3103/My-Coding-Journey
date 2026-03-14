#include <unistd.h>

int	main(void)
{
	write (1, "Program starting\n", 17);
	write (1, "Program done\n", 13);
	return 0;
}
