#include <stdio.h>

static void decay_demo(const int *p)
{
    /* Arrays "decay" to a pointer to their first element when passed to a function. */
    printf("inside the function: sizeof(p) = %zu (just a pointer)\n", sizeof p);
}

static int sum(const int *a, size_t n)     /* always pass the length separately */
{
    int total = 0;
    for (size_t i = 0; i < n; i++) total += a[i];
    return total;
}

int main(void)
{
    int nums[] = {4, 8, 15, 16, 23, 42};
    size_t n = sizeof nums / sizeof nums[0];   /* only works where the array is declared */
    printf("sizeof(nums) = %zu bytes, %zu elements\n", sizeof nums, n);
    decay_demo(nums);
    printf("sum = %d\n", sum(nums, n));

    int zeros[5] = {0};                         /* the rest of the array is zero-filled */
    int partial[5] = {1, 2};                    /* 1 2 0 0 0 */
    printf("partial: ");
    for (size_t i = 0; i < 5; i++) printf("%d ", partial[i]);
    printf("(zeros[0]=%d)\n", zeros[0]);

    int grid[2][3] = {{1, 2, 3}, {4, 5, 6}};    /* stored row by row in memory */
    printf("grid[1][2] = %d\n", grid[1][2]);
    printf("grid rows are contiguous: &grid[1][0] - &grid[0][0] = %td ints\n",
           &grid[1][0] - &grid[0][0]);
    return 0;
}
