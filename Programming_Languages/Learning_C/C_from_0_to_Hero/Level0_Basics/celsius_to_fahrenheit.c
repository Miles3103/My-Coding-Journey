#include <stdio.h>

int main() {
    int celsius = 20;
    
    // --- 1. THE WRONG WAY (Integer Truncation) ---
    // 9 / 5 evaluates to 1, making the formula: celsius * 1 + 32
    int f_wrong = celsius * (9 / 5) + 32;

    // --- 2. FIX 1: Multiply Before Dividing (Keeps using ints) ---
    // celsius * 9 happens first, preserving the data before division
    int f_int_fix = (celsius * 9) / 5 + 32;

    // --- 3. FIX 2: Using Floating-Point Literals (Recommended) ---
    // 9.0 / 5.0 evaluates to 1.8 accurately
    double f_double_fix1 = celsius * (9.0 / 5.0) + 32.0;

    // --- 4. FIX 3: Using Explicit Type Casting ---
    // Casting 9 to (double) forces C to perform floating-point division
    int num = 9, den = 5;
    double f_double_fix2 = celsius * ((double)num / den) + 32;

    // --- PRINTING THE RESULTS ---
    printf("Input Temperature: %d C\n\n", celsius);
    
    printf("WRONG approach [celsius * (9 / 5) + 32]:\n");
    printf("Result: %d F (9/5 evaluated to 1!)\n\n", f_wrong);

    printf("CORRECT approach 1 (Int math reordered) [(celsius * 9) / 5 + 32]:\n");
    printf("Result: %d F\n\n", f_int_fix);

    printf("CORRECT approach 2 (Floating-point literals) [celsius * (9.0 / 5.0) + 32.0]:\n");
    printf("Result: %.2f F\n\n", f_double_fix1);

    printf("CORRECT approach 3 (Type casting) [celsius * ((double)num / den) + 32]:\n");
    printf("Result: %.2f F\n", f_double_fix2);

    return 0;
}
