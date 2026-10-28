#include <stdio.h>
#include <string.h>

int	main(void)
{
	int age;
	char name[16];
	char city[16];

	printf("Enter your name:\n");
	scanf("%s", name);
	printf("Enter your age:\n");
	scanf("%d", &age);
	printf("enter your city\n");
	scanf("%s", city);
	printf("Welcome %s ,Age: %d , City: %s\n", name, age, city);
}
