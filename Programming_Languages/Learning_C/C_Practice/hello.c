#include <stdio.h>

int	main(int argc, char *argv[])
{
	if (argc == 0)
	{
		printf("No arguments passed\n");
	}
	else
	{
		for (int i = 1; i < argc; i++)
		{
			printf("Argument: %d = %s\n", i, argv[i]);
		}
	}
}
