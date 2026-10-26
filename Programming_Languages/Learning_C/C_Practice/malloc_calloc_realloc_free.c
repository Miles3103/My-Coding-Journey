#include <stdio.h>
#include <stdlib.h> // Required for malloc, calloc, realloc, and free

int main(void)
{
    int n = 5;
    int *ptr = NULL;

    // ==========================================
    // 1. MALLOC (Memory Allocation)
    // ==========================================
    // Allocates raw memory for 'n' integers.
    // WARNING: The memory contains uninitialized garbage values.
    ptr = malloc(n * sizeof(int));
    
    if (ptr == NULL)
    {
        printf("Memory allocation failed!\n");
        return 1;
    }

    printf("--- 1. Malloc Example ---\n");
    printf("Assigned values to malloc block:\n");
    for (int i = 0; i < n; i++)
    {
        ptr[i] = (i + 1) * 10; // Assigning: 10, 20, 30, 40, 50
        printf("%d ", ptr[i]);
    }
    printf("\n\n");

    // ==========================================
    // 2. REALLOC (Re-allocation)
    // ==========================================
    // Resizes the previously allocated block to hold 8 integers instead of 5.
    int new_n = 8;
    
    // Always use a temporary pointer with realloc. 
    // If realloc fails, it returns NULL and keeps the original pointer intact.
    int *temp = realloc(ptr, new_n * sizeof(int));
    
    if (temp == NULL)
    {
        printf("Memory reallocation failed!\n");
        free(ptr); // Clean up old memory before exiting
        return 1;
    }
    ptr = temp; // Update original pointer to the new memory block

    printf("--- 2. Realloc Example ---\n");
    printf("Expanded size to 8. Adding values to new slots:\n");
    for (int i = 5; i < new_n; i++)
    {
        ptr[i] = (i + 1) * 10; // Assigning: 60, 70, 80
    }
    
    for (int i = 0; i < new_n; i++)
    {
        printf("%d ", ptr[i]);
    }
    printf("\n\n");

    // ==========================================
    // 3. CALLOC (Contiguous Allocation)
    // ==========================================
    // Allocates memory for 4 elements and automatically initializes everything to 0.
    int *c_ptr = calloc(4, sizeof(int));
    
    if (c_ptr == NULL)
    {
        printf("Calloc allocation failed!\n");
        free(ptr);
        return 1;
    }

    printf("--- 3. Calloc Example ---\n");
    printf("Calloc memory starts clean (all zeros):\n");
    for (int i = 0; i < 4; i++)
    {
        printf("%d ", c_ptr[i]); // Will print: 0 0 0 0
    }
    printf("\n\n");

    // ==========================================
    // 4. FREE (Deallocation)
    // ==========================================
    // Always free your allocated memory to prevent memory leaks when done.
    free(ptr);
    ptr = NULL; // Good practice: prevent dangling pointers

    free(c_ptr);
    c_ptr = NULL;

    printf("--- 4. Free Example ---\n");
    printf("All memory successfully freed and pointers set to NULL.\n");

    return 0;
}
