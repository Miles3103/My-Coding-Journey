#include <stdio.h>

/* Studen informations */


int	main(void)
{
	int studentID = 123456789;
	int studentAge = 24;
	float studentFee = 120.41;
	char studentGrade = 'B';

	printf ("Student ID: %d\n",studentID);
	printf ("Student Age: %d\n",studentAge);
	printf ("Student Fee: %.2f\n",studentFee);
	printf ("Student Grade: %c\n",studentGrade);

	return 0;
}
