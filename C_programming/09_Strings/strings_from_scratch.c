/* ************************************************************************** */
/*                                                                            */
/*   Project : Strings From Scratch                                           */
/*   Author  : Miles3103                                                      */
/*   Topic   : Strings — implementing string.h from the ground up             */
/*                                                                            */
/* ************************************************************************** */

/*
** STRINGS IN C — WHAT THEY REALLY ARE
**
** A string is NOT a built-in type in C.
** It's just a char array with a '\0' (null byte) at the end.
**
**   char str[] = "Hello";
**   Stored as: ['H','e','l','l','o','\0']
**              [72, 101, 108, 108, 111, 0]
**
** The null terminator '\0' is the ONLY signal that the string ends.
** Without it, any string function will read past the end → crash.
**
** RULE: Any time you work with strings, make sure '\0' is there.
**
** WHY IMPLEMENT YOUR OWN?
**   - Deep understanding of what the standard library does
**   - Required by 42 projects (no <string.h> allowed)
**   - Teaches pointer walking, memory layout, edge cases
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
		return (0);
	while (s[i] != '\0')
		i++;
	return (i);
}

/* ============================================================ */
/*  ft_putchar / ft_putstr                                       */
/* ============================================================ */
void	ft_putchar(char c)
{
	write(1, &c, 1);
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
	dst[i] = '\0';  /* don't forget the null terminator! */
	return (dst);
}

/* ============================================================ */
/*  ft_strncpy — copy at most n chars, always null-terminates   */
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
		dst[i++] = '\0';
	return (dst);
}

/* ============================================================ */
/*  ft_strcmp — compare two strings                              */
/*  Returns: 0 if equal, positive if s1>s2, negative if s1<s2  */
/* ============================================================ */
int	ft_strcmp(const char *s1, const char *s2)
{
	while (*s1 && *s1 == *s2)
	{
		s1++;
		s2++;
	}
	return ((unsigned char)*s1 - (unsigned char)*s2);
}

/* ============================================================ */
/*  ft_strcat — append src to end of dst                        */
/* ============================================================ */
char	*ft_strcat(char *dst, const char *src)
{
	char	*end;

	end = dst;
	while (*end != '\0')  /* walk to end of dst */
		end++;
	while (*src != '\0')  /* copy src */
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
			return ((char *)s);
		s++;
	}
	if (c == '\0')
		return ((char *)s);
	return (NULL);
}

/* ============================================================ */
/*  ft_atoi — convert string to integer                         */
/*  Handles: whitespace, +/- signs, overflow (simple)           */
/* ============================================================ */
int	ft_atoi(const char *str)
{
	int	sign;
	int	result;

	sign   = 1;
	result = 0;
	/* Skip leading whitespace */
	while (*str == ' ' || (*str >= 9 && *str <= 13))
		str++;
	/* Handle sign */
	if (*str == '-' || *str == '+')
	{
		if (*str == '-')
			sign = -1;
		str++;
	}
	/* Convert digits */
	while (*str >= '0' && *str <= '9')
	{
		result = result * 10 + (*str - '0');
		str++;
	}
	return (result * sign);
}

/* ============================================================ */
/*  ft_toupper / ft_tolower                                      */
/* ============================================================ */
char	ft_toupper(char c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 32);
	return (c);
}

char	ft_tolower(char c)
{
	if (c >= 'A' && c <= 'Z')
		return (c + 32);
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
	printf("ft_strlen(\"hello\")  = %d\n", ft_strlen("hello"));
	printf("ft_strlen(\"\")       = %d\n", ft_strlen(""));
	printf("ft_strlen(\"42\")     = %d\n\n", ft_strlen("42"));

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
