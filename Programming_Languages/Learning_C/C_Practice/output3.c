#include <stdio.h>

int	main(void)
{
	
	char str[] = "Hello,World3!";

	for (int i = 0; str[i] != '\0'; i++)
	{
		putchar (str[i]);
	}
	putchar('\n');
}
