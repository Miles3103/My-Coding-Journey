#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int *arr = malloc(10 * sizeof(int));
	if (arr == NULL)
	{
		printf("Memory allocation failes\n");
	}
	else
	{
		printf("Meomry allocation successfully\n");
	}
	for (int i = 0; i < 10; i++)
	{
		arr[i] = i + 1;
	}
	for (int i = 0; i < 10; i++)
	{
		printf("arr[%d] = %d\n", i, arr[i]);
	}
	free(arr);
	arr = NULL;
}
