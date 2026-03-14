/* Author: Miles
** Date: 2026
** Description: Demonstrates program structure with a helper function
*/

#include <unistd.h>

void	ft_print(char *s);

void	ft_print(char *s)
{
	int	i;

	i = 0;
	while (s[i] != '\0')
	{
		write (1, &s[i], 1);
		i++;
	}
	write (1, "\n", 1);
}
int	main(void)
{
	ft_print("Syntax is power");
	return (0);
}
