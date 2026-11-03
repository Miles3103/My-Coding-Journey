#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int *arr = malloc(9 * sizeof(int));
	if (arr == NULL)
	{
		perror("malloc");
		return 1;
	}
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"	
	for (int i = 0; i < 9; i++)
		printf("arr[%d] = %d\n", i, arr[i]);
	#pragma GCC diagnostic pop

	free(arr);
}
