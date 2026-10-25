#include <stdio.h>

double	arr_average(double arr[], int len)
{
	double sum = 0;
	double average;

	for (int i = 0; i < len; i++)
	{
		sum = sum + arr[i];
	}
	average = sum / len;

	return average;
}

void	print_arr(double arr[], int len)
{
	for (int i =0; i < len; i++)
	{
		printf(" %.2lf", arr[i]);
	}
}

int	main(void)
{
	double arr[] = {1.2, 1.5, 3.6, 7.9, 2.5};
	int len = sizeof(arr) / sizeof(arr[0]);

	printf("The average of arr {");
	print_arr(arr, len);
	printf(" } = %.2lf\n", arr_average(arr, len));
}
