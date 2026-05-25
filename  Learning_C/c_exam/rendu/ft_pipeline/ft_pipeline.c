#include <unistd.h>

int	main(void)
{
	write (1, "1. Preprocessing\n", 17);
	write (1, "2. Compilation\n", 15);
	write (1, "3. Assembly\n", 12);
	write (1, "4. Linking\n", 11);
	return (0);
}
