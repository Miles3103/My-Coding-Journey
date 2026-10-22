#include <stdio.h>

int	main(void)
{
	int arr[] = {5, 10, 4, 7, 9,12, 0, 12};
	int min;
	int len = sizeof(arr)/sizeof(arr[0]);
	min = arr[0];

	printf("Array = ");
	for (int i =0; i < len; i++)
	{
		printf("%d, ", arr[i]);
	}
	printf("\n");
	for (int i = 0; i < len; i++)
	{
		if (arr[i] < min)
		{
			min = arr[i];
		}
	}
	printf("Minimunm found : %d\n", min);
}
