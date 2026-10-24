#include <stdio.h>

void	reve_Arr(int arr[], int len)
{
	int reve_arr;
	for (int i = 0; i < len / 2; i++)
	{
		reve_arr = arr[i];
		arr[i] = arr[len - 1 - i];
		arr[len - 1 - i] = reve_arr;
	}
}

int	main(void)
{
	int arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
	int len = sizeof(arr)/sizeof(arr[0]);

	printf("Array: { ");
	for (int i = 0; i < len; i++)
	{
		printf("%d ", arr[i]);
	}
	printf("}\n");

	printf("================================\n");
	reve_Arr(arr, len);
	printf("reve_Arr: { ");

	for (int i = 0; i < len; i++)
	{
		printf("%d ", arr[i]);
	}
	printf("}\n");

	/*printf("reve_arr: { ");
	for (int i = len - 1; i > -1; i--)
	{
		printf("%d ", arr[i]);
	}
	printf("} \n");*/
	printf("#################################\n");
}
