#include <stdio.h>

void swap_with_temp(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void swap_without_temp_math(int *a, int *b) {
    *a = *a + *b;
    *b = *a - *b;
    *a = *a - *b;
}

void swap_without_temp_xor(int *a, int *b) {
    // CRITICAL SECURITY CHECK:
    // If a and b point to the exact same memory address, 
    // the XOR trick will accidentally wipe out the data to 0.
    if (a == b) {
        return; 
    }
    
    *a = *a ^ *b;
    *b = *a ^ *b;
    *a = *a ^ *b;
}

int main() {
    int x = 10, y = 20;

    printf("Initial values: x = %d, y = %d\n\n", x, y);

    // 1. Swapping with a temporary variable
    swap_with_temp(&x, &y);
    printf("1. After Temp Swap:  x = %d, y = %d\n", x, y);

    // 2. Swapping without temp using Addition/Subtraction
    swap_without_temp_math(&x, &y);
    printf("2. After Math Swap:  x = %d, y = %d\n", x, y);

    // 3. Swapping without temp using Bitwise XOR
    swap_without_temp_xor(&x, &y);
    printf("3. After XOR Swap:   x = %d, y = %d\n\n", x, y);

    // --- DEMONSTRATION OF THE XOR TRICK FAILURE ---
    int target = 99;
    printf("Before dangerous self-swap: target = %d\n", target);
    
    // We pass the same memory location to both arguments
    swap_without_temp_xor(&target, &target); 
    
    printf("After dangerous self-swap (unprotected): target will become 0!\n");

    return 0;
}
