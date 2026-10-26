#include <stdio.h>

int	main(void)
{
	int term1 = 0;
	int term2 = 1;
	int fibn = 0;
	int len = 0;

	scanf("%d", &len);

	for (int i = 2; i < len; i++)
	{
		fibn = term1 + term2;
		term1 = term2;
		term2 = fibn;
	}
	printf("%d\n", fibn);
}
