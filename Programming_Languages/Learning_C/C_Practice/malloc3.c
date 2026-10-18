#include <stdio.h>
#include <stdlib.h>

int*	twoSum(int* nums, int numsSize, int target, int* returnSize)
{
	int* result = (int*)malloc(2 * sizeof(int));
	if (result == 0)
	{
		*returnSize = 0;
		return NULL;
	}
	for (int i = 0; i < numsSize; i++)
	{
		for (int j = i + 1; j < numsSize; j++)
		{
			if (nums[i] + nums[j] == target)
			{
				result[0] = i; 
				result[1] = j;
				*returnSize = 2;
				return result;
			}
		}
	}
	free(result);
	*returnSize = 0;
	return NULL;

}

void printArray(int* arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d%s", arr[i], (i < size - 1) ? ", " : "");
    }
    printf("]\n");
}

int	main(void)
{
	int nums[] = {1, 2, 3, 4, 5, 6, 7, 8, };
	int numsSize = sizeof(nums)/sizeof(nums[0]);
	int target = 10;
	int returnSize = 0;
	
	printf("Input nums array: ");
	printArray(nums, numsSize);
	int* result = twoSum(nums, numsSize, target, &returnSize);
	if (result != NULL && returnSize == 2)
	{
		printf("Indices: [%d, %d]\nValues : [%d + %d} = %d\n", result[0], result[1], nums[result[0]], nums[result[1]], target);
		free(result);
	}
	else
	{
		printf("No tow sum solution found\n");
	}
	return (0);
}



