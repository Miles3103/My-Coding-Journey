#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int number = 0;
    printf("Enter the number of players: ");
    scanf("%d", &number);

    if (number <= 0)
    {
        printf("Please enter a valid positive number.\n");
        return 1;
    }

    // Using calloc ensures all initial scores are set to 0
    int *scores = calloc(number, sizeof(int));

    if (scores == NULL)
    {
        printf("Memory allocation failed!\n");
        return 1;
    }

    printf("Memory allocated successfully.\n");

    // Print the initialized scores
    for (int i = 0; i < number; i++)
    {
        printf("%d ", scores[i]);
    }
    printf("\n");

    // Always free allocated memory when done
    free(scores);
    scores = NULL;

    return 0;
}