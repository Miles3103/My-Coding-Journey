#include <stdio.h>

/* Variables, 
 * integer (int)- stores whole numbers, such as 123 or -123
 * float - stores numbers with decimals, such as 23.5, -23.5
 * char - stores a single character, such as 'a', 'B', Characters are surrounded by single quotes
 */

/* Declaring Variables */

int main(void)
{
	int age = 24;
	printf("Age = %d \n", age);

	char letter = 'I';

	printf("Letter = %c\n", letter);

	float height = 172.5;

	printf ("Height = %.2f\n", height);
/* Change Variables */
	
	age++;
	printf ("New age = %d\n", age);

	letter = 'S';
	printf ("New letter = %c\n", letter);
	
	height+= .51;
	printf ("New height = %.2f\n", height);



	return 0;
}
