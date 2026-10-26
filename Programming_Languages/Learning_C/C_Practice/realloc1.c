#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    // 1. Allocate space for 3 integers
    int *ptr = malloc(3 * sizeof(int));
    ptr[0] = 10;
    ptr[1] = 20;
    ptr[2] = 30;

    // 2. Resize the block to hold 5 integers instead of 3
    int *temp = realloc(ptr, 5 * sizeof(int));
    
    if (temp == NULL)
    {
        printf("Reallocation failed!\n");
        free(ptr); // Clean up original memory
        return 1;
    }
    
    ptr = temp; // Update pointer to the new memory block

    // Add new values
    ptr[3] = 40;
    ptr[4] = 50;

    // Print all values
    for (int i = 0; i < 5; i++)
    {
        printf("%d ", ptr[i]); // Output: 10 20 30 40 50
    }
    printf("\n");

    // Always free when done
    free(ptr);
    ptr = NULL;

    return 0;
}
