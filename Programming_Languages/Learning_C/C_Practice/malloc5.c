#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int *numbers = malloc(5000 + sizeof(int));

	char *name = malloc(100 *sizeof(char));
	if (name  == NULL || numbers == NULL)
		printf("ERROR!\n");
	else
		printf("Memory allocated\n");
	free(name);
	free(numbers);

}
