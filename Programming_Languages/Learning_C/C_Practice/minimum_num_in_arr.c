#include <stdio.h>

int	find_min(int arr[], int len)
{
	int min;
	min = arr[0];

	for (int i = 0; i < len; i++)
	{
		if (arr[i] < min)
		{
			min = arr[i];
		}
	}
	return min;
}
int	find_max(int arr[], int len)
{
	int max;

	max = arr[0];
	for (int i= 0; i < len; i++)
	{
		if (arr[i] > max)
		{
			max = arr[i];
		}
	}
	return max;
}
void	print_arr(int arr[], int len)
{
	printf("Array: ");
	for (int i = 0; i < len; i++)
	{
		printf("%d ", arr[i]);
	}
	printf("\n");
}

int	find_dupnum(int arr[], int len, int result[])
{
	for (int i = 0; i < len; i++)
	{
		for (int j = i + 1 ; j < len; j++)
		{
			if (arr[i] == arr[j])
			{
				result[0] = arr[i];
				result[1] = arr[j];
			}
		}
	}
	return result[2];
}

int	main(void)
{
	int arr[] = {5, 12, 12, 7, 9,25, 22, 2};
	int min;
	int max;
	int result[2];
	int len = sizeof(arr)/sizeof(arr[0]);

	printf("Array length: %d\n", len);
	print_arr(arr, len);
	min = find_min(arr, len);
	printf("Min found : %d\n", min);
	max = find_max(arr, len);
	printf("Max found: %d\n", max);
	find_dupnum(arr, len, result);
	printf("Duplicate found: \n");
	print_arr(result, sizeof(result)/sizeof(result[0]));
	printf("===================================\n");
	int arr2[] = {1000, 0,12, 34, 66, 87, 23, 50, 600, 256};
	int len2 = sizeof(arr2)/sizeof(arr2[0]);
	printf("Array length: %d\n", len2);
	print_arr(arr2,len2);
	min = find_min(arr2, len);
	printf("Min found: %d\n", min);
	max = find_max(arr2, len2);
	printf("Max found: %d\n", max);
}
