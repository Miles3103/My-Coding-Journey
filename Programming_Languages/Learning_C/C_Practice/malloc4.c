#include <stdio.h>
#include <stdlib.h>

// Function to find ALL matching pairs
int** allTwoSum(int* nums, int numsSize, int target, int* returnSize) {
    // Allocate space for up to numsSize pairs
    int** result = (int**)malloc(numsSize * sizeof(int*));
    if (result == NULL) {
        *returnSize = 0;
        return NULL;
    }

    *returnSize = 0;

    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                result[*returnSize] = (int*)malloc(2 * sizeof(int));
                result[*returnSize][0] = i;
                result[*returnSize][1] = j;
                (*returnSize)++;
            }
        }
    }

    return result;
}

int main(int argc, char* argv[]) {
    // Expecting: ./program <size> <target> <elem1> <elem2> ...
    if (argc < 4) {
        printf("Usage: %s <size> <target> <elem1> <elem2> ...\n", argv[0]);
        printf("Example: %s 6 10 1 2 3 4 6 7\n", argv[0]);
        return 1;
    }

    // 1. Get size and target from argv
    int numsSize = atoi(argv[1]);
    int target = atoi(argv[2]);

    // Check if the user provided the promised number of array elements
    if (argc - 3 < numsSize) {
        printf("Error: Expected %d elements, but received %d.\n", numsSize, argc - 3);
        return 1;
    }

    // 2. Allocate memory for input array
    int* nums = (int*)malloc(numsSize * sizeof(int));
    if (nums == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
    }

    // 3. Parse array elements starting at argv[3]
    for (int i = 0; i < numsSize; i++) {
        nums[i] = atoi(argv[3 + i]);
    }

    // 4. Find all matching pairs
    int pairCount = 0;
    int** pairs = allTwoSum(nums, numsSize, target, &pairCount);

    // 5. Print results
    if (pairs != NULL && pairCount > 0) {
        printf("Target: %d | Found %d pair(s):\n", target, pairCount);
        for (int i = 0; i < pairCount; i++) {
            int idx1 = pairs[i][0];
            int idx2 = pairs[i][1];
            printf("  Pair %d -> Indices: [%d, %d] | Values: %d + %d = %d\n",
                   i + 1, idx1, idx2, nums[idx1], nums[idx2], target);
            free(pairs[i]); // Free each pair array
        }
        free(pairs); // Free outer pointer array
    } else {
        printf("No pairs found that sum to %d.\n", target);
    }

    free(nums);
    return 0;
}
