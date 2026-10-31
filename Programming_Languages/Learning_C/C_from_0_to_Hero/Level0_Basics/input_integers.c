#include <stdio.h>

int main() {
    int int1, int2;
    int int_sum, int_diff, int_prod, int_quot, int_rem;
    
    double dbl1, dbl2;
    double dbl_sum, dbl_diff, dbl_prod, dbl_quot;

    // --- 1. READ INPUTS & CHECK SCANF RETURN VALUE ---
    printf("Enter two integers: ");
    int scan_result = scanf("%d %d", &int1, &int2);

    // scanf returns the number of successfully matched and assigned items
    if (scan_result != 2) {
        printf("Error: Invalid input. Please enter exactly two integers.\n");
        return 1; 
    }

    // Assign the same numbers to doubles for comparison
    dbl1 = (double)int1;
    dbl2 = (double)int2;

    printf("\n--- INTEGER OPERATIONS (int) ---\n");
    int_sum  = int1 + int2;
    int_diff = int1 - int2;
    int_prod = int1 * int2;

    printf("Sum        (int + int): %d\n", int_sum);
    printf("Difference (int - int): %d\n", int_diff);
    printf("Product    (int * int): %d\n", int_prod);

    // --- 2. TEST DIVISION BY ZERO & COMPARE / vs % ---
    if (int2 == 0) {
        printf("Quotient   (int / int): Undefined (Cannot divide by 0!)\n");
        printf("Remainder  (int %% int): Undefined (Cannot modulo by 0!)\n");
    } else {
        int_quot = int1 / int2; // Integer division cuts off the decimal part
        int_rem  = int1 % int2;  // Modulo operator gets the remainder
        printf("Quotient   (int / int): %d (Truncated towards zero)\n", int_quot);
        printf("Remainder  (int %% int): %d\n", int_rem);
    }

    printf("\n--- FLOATING-POINT OPERATIONS (double) ---\n");
    dbl_sum  = dbl1 + dbl2;
    dbl_diff = dbl1 - dbl2;
    dbl_prod = dbl1 * dbl2;

    printf("Sum        (double + double): %.4f\n", dbl_sum);
    printf("Difference (double - double): %.4f\n", dbl_diff);
    printf("Product    (double * double): %.4f\n", dbl_prod);

    // --- 3. DOUBLE DIVISION BY ZERO ---
    // Dividing a non-zero double by 0.0 results in infinity (inf) or -inf instead of crashing.
    dbl_quot = dbl1 / dbl2; 
    printf("Quotient   (double / double): %.4f\n", dbl_quot);
    
    // Note: The % operator is strictly for integers. 
    // Writing `dbl1 % dbl2` would cause a compilation error.

    return 0;
}
