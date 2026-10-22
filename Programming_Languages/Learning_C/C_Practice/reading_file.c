#include <stdio.h>

int	main(void)
{
	FILE *file = fopen("user.txt", "r");
	char buffer[256];

	if (file == NULL)
	{
		printf("Could not open file\n");
	}
	while (fgets(buffer, sizeof(buffer), file) != NULL)
	{
		printf("%s", buffer);
	}
}
