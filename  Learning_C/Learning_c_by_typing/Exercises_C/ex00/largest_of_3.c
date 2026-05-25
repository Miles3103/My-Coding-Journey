#include <stdio.h>

int	main(void)
{
	int	num1;
	int	num2;
	int	num3;

	num1 = 0;
	num2 = 0;
	num3 = 0;
	printf ("Enter all three numbers:\n");
	scanf ("%d %d %d", &num1, &num2, &num3);

	if (num1  == num2 && num1 == num3)
		printf ("All Numbers are equal\n");
	else if (num1 >= num2 && num1 >= num3 )
		printf ("1st Number is the greatest\n");
	else if (num2 >= num1 && num2  >= num3)
		printf ("2nd Number is the greatest\n");
	else 
		printf ("3rd Number is the greatest\n");
	return 0;
}
