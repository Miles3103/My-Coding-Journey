/* ************************************************************************** */
/*                                                                            */
/*   Project : Arrays — Complete Guide                                        */
/*   Author  : Miles3103                                                      */
/*   Topic   : Arrays — 1D, 2D, loops, statistics, sorting                   */
/*                                                                            */
/* ************************************************************************** */

/*
** ARRAYS IN C — WHAT THEY REALLY ARE
**
** An array is a contiguous block of memory holding elements of the same type.
** The name of an array IS a pointer to its first element.
**
**   int arr[5] = {10, 20, 30, 40, 50};
**   arr == &arr[0]    → both are the same address
**   arr[2] == *(arr+2) → the compiler converts indexing to pointer math
**
** KEY RULES:
**   - Index starts at 0
**   - C does NOT check bounds — going out of bounds = undefined behavior
**   - You CANNOT return a local array (it lives on the stack and dies)
**   - sizeof(arr) gives total bytes, not number of elements
**   - Length formula: sizeof(arr) / sizeof(arr[0])
*/

#include <stdio.h>

/* ============================================================ */
/*  STATISTICS FUNCTIONS                                         */
/* ============================================================ */

int	ft_min(int *arr, int n)
{
	int	min;
	int	i;

	min = arr[0];
	i = 1;
	while (i < n)
	{
		if (arr[i] < min)
			min = arr[i];
		i++;
	}
	return (min);
}

int	ft_max(int *arr, int n)
{
	int	max;
	int	i;

	max = arr[0];
	i = 1;
	while (i < n)
	{
		if (arr[i] > max)
			max = arr[i];
		i++;
	}
	return (max);
}

int	ft_sum(int *arr, int n)
{
	int	sum;
	int	i;

	sum = 0;
	i = 0;
	while (i < n)
		sum += arr[i++];
	return (sum);
}

double	ft_avg(int *arr, int n)
{
	return ((double)ft_sum(arr, n) / n);
}

/* ============================================================ */
/*  BUBBLE SORT                                                  */
/* ============================================================ */

void	ft_swap(int *a, int *b)
{
	int	tmp;

	tmp = *a;
	*a = *b;
	*b = tmp;
}

/*
** Bubble sort: compare adjacent pairs, push largest to end.
** Not efficient for large arrays, but great to understand.
** Time complexity: O(n^2)
*/
void	ft_bubble_sort(int *arr, int n)
{
	int	swapped;
	int	i;

	while (1)
	{
		swapped = 0;
		i = 0;
		while (i < n - 1)
		{
			if (arr[i] > arr[i + 1])
			{
				ft_swap(&arr[i], &arr[i + 1]);
				swapped = 1;
			}
			i++;
		}
		if (!swapped)  /* no swaps = already sorted */
			break ;
		n--;
	}
}

void	print_array(int *arr, int n, char *label)
{
	printf("%s: ", label);
	for (int i = 0; i < n; i++)
		printf("%d ", arr[i]);
	printf("\n");
}

/* ============================================================ */
/*  2D ARRAYS / MATRICES                                         */
/* ============================================================ */

void	print_matrix(int rows, int cols, int m[rows][cols])
{
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++)
			printf("%3d ", m[i][j]);
		printf("\n");
	}
}

int	matrix_trace(int n, int m[n][n])
{
	int	trace;

	trace = 0;
	for (int i = 0; i < n; i++)
		trace += m[i][i];
	return (trace);
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* --- 1D ARRAYS --- */
	int	data[] = {4, 7, 2, 9, 1, 5, 8, 3, 6, 10};
	int	n = sizeof(data) / sizeof(data[0]);

	printf("=== 1D Array Basics ===\n");
	printf("sizeof(data)          = %zu bytes\n", sizeof(data));
	printf("sizeof(data[0])       = %zu bytes\n", sizeof(data[0]));
	printf("Number of elements    = %d\n", n);
	printf("data == &data[0]      = %s\n\n",
		(void *)data == (void *)&data[0] ? "true" : "false");

	/* --- STATISTICS --- */
	printf("=== Statistics ===\n");
	print_array(data, n, "Array");
	printf("Min: %d\n", ft_min(data, n));
	printf("Max: %d\n", ft_max(data, n));
	printf("Sum: %d\n", ft_sum(data, n));
	printf("Avg: %.2f\n\n", ft_avg(data, n));

	/* --- SORTING --- */
	int	unsorted[] = {64, 34, 25, 12, 22, 11, 90};
	int	m = sizeof(unsorted) / sizeof(unsorted[0]);
	printf("=== Bubble Sort ===\n");
	print_array(unsorted, m, "Before");
	ft_bubble_sort(unsorted, m);
	print_array(unsorted, m, "After ");
	printf("\n");

	/* --- POINTER VS INDEX ACCESS --- */
	printf("=== Pointer vs Index Access (same thing!) ===\n");
	int	arr[] = {10, 20, 30, 40, 50};
	int	*p = arr;
	for (int i = 0; i < 5; i++)
		printf("arr[%d]=%d  *(p+%d)=%d  (p+%d)=%p\n",
			i, arr[i], i, *(p + i), i, (void *)(p + i));
	printf("\n");

	/* --- 2D ARRAY --- */
	printf("=== 2D Matrix ===\n");
	int	matrix[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
	print_matrix(3, 3, matrix);
	printf("Trace (diagonal sum): %d\n", matrix_trace(3, matrix));

	return (0);
}
