#include <stdio.h>
#include <unistd.h>

int	main(void)
{
	write (1,"Hello, World!\n", 14);
	printf("Hello, World!\n");
	puts ("Hello, World!");
}
