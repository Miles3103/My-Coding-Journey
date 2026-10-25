#include <stdio.h>

int	sum_arr(int arr[], int len)
{
	int sum;
	 sum = 0;

	for (int i = 0; i < len; i++)
	{
		sum = sum + arr[i];
	}
	return sum;
}

int	main(void)
{
	int arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
	int len = sizeof(arr) / sizeof(arr[0]);
	printf("Sum of array = %d\n",sum_arr(arr, len));
}
