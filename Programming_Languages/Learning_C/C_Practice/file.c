#include <stdio.h>

int	main(void)
{
	FILE *file = fopen("hello.txt", "w");
	if (file == NULL)
	{
		printf("Error opening filw!\n");
		return 1;
	}
	fprintf(file, "Hello, World!\n");
	fprintf(file, "Age: %d\n", 24);
	fclose(file);
	return 0;
}
