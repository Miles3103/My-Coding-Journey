#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int	main(void)
{
	printf("=== Basic Malloc ===\n");
	int *arr = malloc(5 * sizeof(int));
	if (!arr)
	{
		printf("malloc failed\n");
		return 1;
	}
	for (int i = 0; i < 5; i++)
	{
		arr[i] = i + 1;
	}
	for (int i = 0; i < 5 ; i++)
	{
		printf("arr[%d] = %d\n", i, arr[i]);
	}
	free(arr);
	arr = 0;
	printf("Memory freed.\n\n");
}
