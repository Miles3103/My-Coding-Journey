/* ************************************************************************** */
/*                                                                            */
/*   Project : Strings From Scratch                                           */
/*   Author  : Miles3103                                                      */
/*   Topic   : Strings — implementing string.h from the ground up             */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS A STRING IN C?
**
**   A string is NOT a built-in type. It is simply a char array with a
**   null terminator '\0' at the end — that byte is the ONLY signal that
**   the string has ended. Without it, every string function reads past the
**   end of the array, causing crashes and undefined behavior.
**
**     char str[] = "Hello";
**     Stored as: ['H','e','l','l','o','\0']
**                [ 72, 101, 108, 108, 111,  0]
**
** RULE: Any time you work with strings, ensure '\0' is placed at the end.
**
** WHY IMPLEMENT YOUR OWN STRING FUNCTIONS?
**   - 42 projects often forbid <string.h> — you must write ft_ versions
**   - Building them forces you to understand pointer walking and memory layout
**   - Every edge case (empty string, NULL input, length limits) becomes real
**
** FUNCTIONS IMPLEMENTED HERE:
**   ft_strlen    → count characters before '\0'
**   ft_putchar   → write one character to stdout using write()
**   ft_putstr    → write a full string using write()
**   ft_strcpy    → copy src into dst, returns dst
**   ft_strncpy   → copy at most n chars, always null-terminates
**   ft_strcmp    → compare two strings lexicographically
**   ft_strcat    → append src to end of dst
**   ft_strchr    → find first occurrence of a character
**   ft_atoi      → convert a string to an integer
**   ft_toupper   → convert one character to uppercase
**   ft_tolower   → convert one character to lowercase
**   ft_str_toupper → convert an entire string to uppercase in-place
**
** NOTE:
**   String literals like "Hello" are stored in read-only memory.
**   char *s = "Hello"; → s points to read-only data, never write to it.
**   char s[] = "Hello"; → s is a local writable copy. Safe to modify.
*/

#include <stdio.h>
#include <unistd.h>

/* ============================================================ */
/*  ft_strlen — count chars before '\0'                         */
/* ============================================================ */

int	ft_strlen(const char *s)
{
	int	i;

	i = 0;
	if (!s)
		return (0);  /* guard against NULL input */
	while (s[i] != '\0')
		i++;
	return (i);
}

/* ============================================================ */
/*  ft_putchar / ft_putstr — output without printf              */
/* ============================================================ */

void	ft_putchar(char c)
{
	write(1, &c, 1);  /* write exactly 1 byte to stdout */
}

void	ft_putstr(const char *s)
{
	if (!s)
		return ;
	write(1, s, ft_strlen(s));
}

/* ============================================================ */
/*  ft_strcpy — copy src into dst, returns dst                   */
/* ============================================================ */

char	*ft_strcpy(char *dst, const char *src)
{
	int	i;

	i = 0;
	while (src[i] != '\0')
	{
		dst[i] = src[i];
		i++;
	}
	dst[i] = '\0';  /* always place the null terminator manually */
	return (dst);
}

/* ============================================================ */
/*  ft_strncpy — copy at most n chars, pad remainder with '\0'  */
/* ============================================================ */

char	*ft_strncpy(char *dst, const char *src, int n)
{
	int	i;

	i = 0;
	while (i < n && src[i] != '\0')
	{
		dst[i] = src[i];
		i++;
	}
	while (i < n)
		dst[i++] = '\0';  /* pad with null bytes if src was shorter */
	return (dst);
}

/* ============================================================ */
/*  ft_strcmp — compare two strings                              */
/*  Returns 0 if equal, positive if s1 > s2, negative if s1 < s2 */
/* ============================================================ */

int	ft_strcmp(const char *s1, const char *s2)
{
	while (*s1 && *s1 == *s2)
	{
		s1++;
		s2++;
	}
	return ((unsigned char)*s1 - (unsigned char)*s2); /* cast avoids sign issues */
}

/* ============================================================ */
/*  ft_strcat — append src to end of dst                        */
/* ============================================================ */

char	*ft_strcat(char *dst, const char *src)
{
	char	*end;

	end = dst;
	while (*end != '\0')  /* walk dst to its null terminator */
		end++;
	while (*src != '\0')  /* copy src from there */
		*end++ = *src++;
	*end = '\0';
	return (dst);
}

/* ============================================================ */
/*  ft_strchr — find first occurrence of c in s                 */
/* ============================================================ */

char	*ft_strchr(const char *s, char c)
{
	while (*s != '\0')
	{
		if (*s == c)
			return ((char *)s);  /* found — return pointer to it */
		s++;
	}
	if (c == '\0')
		return ((char *)s);  /* searching for '\0' — return end pointer */
	return (NULL);
}

/* ============================================================ */
/*  ft_atoi — convert string to integer                         */
/*  Handles leading whitespace, +/- sign, and digit conversion  */
/* ============================================================ */

int	ft_atoi(const char *str)
{
	int	sign;
	int	result;

	sign   = 1;
	result = 0;
	while (*str == ' ' || (*str >= 9 && *str <= 13)) /* skip whitespace */
		str++;
	if (*str == '-' || *str == '+')
	{
		if (*str == '-')
			sign = -1;
		str++;
	}
	while (*str >= '0' && *str <= '9')
	{
		result = result * 10 + (*str - '0'); /* '0' = 48 → digit value */
		str++;
	}
	return (result * sign);
}

/* ============================================================ */
/*  ft_toupper / ft_tolower / ft_str_toupper                    */
/*  ASCII: 'A'=65, 'a'=97 — difference of 32 between cases     */
/* ============================================================ */

char	ft_toupper(char c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 32);  /* shift from lowercase to uppercase range */
	return (c);
}

char	ft_tolower(char c)
{
	if (c >= 'A' && c <= 'Z')
		return (c + 32);  /* shift from uppercase to lowercase range */
	return (c);
}

void	ft_str_toupper(char *s)
{
	while (*s)
	{
		*s = ft_toupper(*s);
		s++;
	}
}

/* ============================================================ */
/*  MAIN — test everything                                       */
/* ============================================================ */

int	main(void)
{
	char	buf[50];
	char	buf2[50];

	printf("=== ft_strlen ===\n");
	printf("ft_strlen(\"hello\") = %d\n", ft_strlen("hello"));
	printf("ft_strlen(\"\")      = %d\n", ft_strlen(""));
	printf("ft_strlen(\"42\")    = %d\n\n", ft_strlen("42"));

	printf("=== ft_strcpy ===\n");
	ft_strcpy(buf, "Hello, Miles3103!");
	printf("ft_strcpy result: %s\n\n", buf);

	printf("=== ft_strcmp ===\n");
	printf("ft_strcmp(\"abc\",\"abc\") = %d  (0 = equal)\n",
		ft_strcmp("abc", "abc"));
	printf("ft_strcmp(\"abc\",\"abd\") = %d  (negative = s1 < s2)\n",
		ft_strcmp("abc", "abd"));
	printf("ft_strcmp(\"abd\",\"abc\") = %d  (positive = s1 > s2)\n\n",
		ft_strcmp("abd", "abc"));

	printf("=== ft_strcat ===\n");
	ft_strcpy(buf, "Hello ");
	ft_strcat(buf, "World!");
	printf("ft_strcat result: %s\n\n", buf);

	printf("=== ft_strchr ===\n");
	char	*found = ft_strchr("Hello World", 'W');
	printf("ft_strchr result: %s\n\n", found ? found : "not found");

	printf("=== ft_atoi ===\n");
	printf("ft_atoi(\"42\")    = %d\n", ft_atoi("42"));
	printf("ft_atoi(\"-100\") = %d\n", ft_atoi("-100"));
	printf("ft_atoi(\"  +7\") = %d\n\n", ft_atoi("  +7"));

	printf("=== ft_str_toupper ===\n");
	ft_strcpy(buf2, "hello world");
	ft_str_toupper(buf2);
	printf("ft_str_toupper: %s\n", buf2);

	return (0);
}
