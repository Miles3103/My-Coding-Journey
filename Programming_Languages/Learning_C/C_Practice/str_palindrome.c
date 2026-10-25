#include <stdio.h>
#include <string.h>

int	check_palindrome(char str[], int len)
{

	for (int i = 0; i < len / 2; i++)
	{
		if (str[i] != str[len - 1 - i])
		{
			return 0;
		}
	}
	return 1;
}

int	main(void)
{
	char str1[] = "ismail";
	char str2[] = "abccba";
	char str3[] = "ismsi";
	if (check_palindrome(str1, strlen(str1)))
		printf("Palindrome found!\n");
	else
		printf("No palindrome found.\n");
	if (check_palindrome(str2, strlen(str2)))
		printf("Palindrome found!\n");
	else
		printf("No palindrome found.\n");
	if (check_palindrome(str3, strlen(str3)))
		printf("Palindrome found!\n");
	else
		printf("No palindrome found.\n");
}
