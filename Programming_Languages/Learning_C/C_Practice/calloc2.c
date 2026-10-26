#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int *arr = calloc(4, sizeof(int));

	if (arr == NULL)
	{
		printf("Calloc allocation failed!\n");
		return 1;
	}
	for (int i = 0; i < 4; i++)
		printf("%d", arr[i]);
	free(arr);
	printf("\n");
}
