#include <stdio.h>

int	main(void)
{
	int result = 0;
	int n = 100;
	result = (n * (n + 1))/2;
	printf("%d\n", result);
	printf("+++++++++++++++++++++++++++++++\n");

	result = 0;
	for (int i = 1; i <= 100; i++)
	{
		result += i;
	}
	printf("%d\n",result);
}
