/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_libft.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/07/17 02:07:41 by iismail-          #+#    #+#             */
/*   Updated: 2026/07/17 02:07:55 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
/* ************************************************************************** */
/*                                                                            */
/*   test_libft.c  -  standalone test suite for libft                        */
/*                                                                            */
/*   Not part of the mandatory submission. Compile and run manually:         */
/*   See instructions printed at the bottom of this file / in chat.          */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

static int	g_pass = 0;
static int	g_fail = 0;

# define GREEN "\033[32m"
# define RED   "\033[31m"
# define RESET "\033[0m"

static void	check(int condition, const char *label)
{
	if (condition)
	{
		g_pass++;
		printf(GREEN "[PASS]" RESET " %s\n", label);
	}
	else
	{
		g_fail++;
		printf(RED "[FAIL]" RESET " %s\n", label);
	}
}

static void	check_str(const char *got, const char *expected, const char *label)
{
	int	ok;

	if (got == NULL && expected == NULL)
		ok = 1;
	else if (got == NULL || expected == NULL)
		ok = 0;
	else
		ok = (strcmp(got, expected) == 0);
	if (ok)
	{
		g_pass++;
		printf(GREEN "[PASS]" RESET " %s\n", label);
	}
	else
	{
		g_fail++;
		printf(RED "[FAIL]" RESET " %s -> got [%s] expected [%s]\n",
			label, got ? got : "(null)", expected ? expected : "(null)");
	}
}

/* ---------------------------------------------------------------------- */
/*  Part 1 - libc reimplementations                                       */
/* ---------------------------------------------------------------------- */

static void	test_char_classification(void)
{
	printf("\n-- char classification --\n");
	check(ft_isalpha('a') == 1 && ft_isalpha('Z') == 1, "isalpha letters");
	check(ft_isalpha('5') == 0 && ft_isalpha(' ') == 0, "isalpha non-letters");
	check(ft_isdigit('0') == 1 && ft_isdigit('9') == 1, "isdigit digits");
	check(ft_isdigit('a') == 0, "isdigit non-digit");
	check(ft_isalnum('a') == 1 && ft_isalnum('5') == 1, "isalnum letter/digit");
	check(ft_isalnum('!') == 0, "isalnum symbol");
	check(ft_isascii(0) == 1 && ft_isascii(127) == 1, "isascii bounds");
	check(ft_isascii(128) == 0 && ft_isascii(-1) == 0, "isascii out of range");
	check(ft_isprint(' ') == 1 && ft_isprint('~') == 1, "isprint bounds");
	check(ft_isprint(31) == 0 && ft_isprint(127) == 0, "isprint non-printable");
	check(ft_toupper('a') == 'A' && ft_toupper('A') == 'A', "toupper");
	check(ft_toupper('5') == '5', "toupper non-letter untouched");
	check(ft_tolower('A') == 'a' && ft_tolower('a') == 'a', "tolower");
}

static void	test_strlen(void)
{
	printf("\n-- ft_strlen --\n");
	check(ft_strlen("hello") == strlen("hello"), "strlen normal");
	check(ft_strlen("") == 0, "strlen empty");
}

static void	test_memset_bzero(void)
{
	char	buf1[10];
	char	buf2[10];

	printf("\n-- ft_memset / ft_bzero --\n");
	memset(buf2, 'X', 10);
	ft_memset(buf1, 'X', 10);
	check(memcmp(buf1, buf2, 10) == 0, "memset matches libc");
	memset(buf2, 0, 10);
	ft_bzero(buf1, 10);
	check(memcmp(buf1, buf2, 10) == 0, "bzero zeroes correctly");
}

static void	test_memcpy_memmove(void)
{
	char	src[20] = "0123456789";
	char	dst1[20];
	char	dst2[20];
	char	overlap1[20] = "0123456789";
	char	overlap2[20] = "0123456789";

	printf("\n-- ft_memcpy / ft_memmove --\n");
	memcpy(dst2, src, 11);
	ft_memcpy(dst1, src, 11);
	check(memcmp(dst1, dst2, 11) == 0, "memcpy matches libc");
	memmove(overlap1 + 2, overlap1, 5);
	ft_memmove(overlap2 + 2, overlap2, 5);
	check(memcmp(overlap1, overlap2, 20) == 0, "memmove overlap dst>src");
	strcpy(overlap1, "0123456789");
	strcpy(overlap2, "0123456789");
	memmove(overlap1, overlap1 + 2, 5);
	ft_memmove(overlap2, overlap2 + 2, 5);
	check(memcmp(overlap1, overlap2, 20) == 0, "memmove overlap dst<src");
}

static void	test_strlcpy_strlcat(void)
{
	char	dst1[10];
	char	dst2[10];
	size_t	r1;

	printf("\n-- ft_strlcpy / ft_strlcat --\n");
	r1 = ft_strlcpy(dst1, "hello", sizeof(dst1));
	check(r1 == 5 && strcmp(dst1, "hello") == 0, "strlcpy fits");
	r1 = ft_strlcpy(dst1, "way too long a string", sizeof(dst1));
	check(r1 == 21 && strlen(dst1) == 9, "strlcpy truncates, returns src len");
	strcpy(dst1, "foo");
	strcpy(dst2, "foo");
	ft_strlcat(dst1, "bar", sizeof(dst1));
	strcat(dst2, "bar");
	check(strcmp(dst1, dst2) == 0, "strlcat normal append");
	strcpy(dst1, "1234567");
	ft_strlcat(dst1, "XYZ", sizeof(dst1));
	check(strlen(dst1) == 9, "strlcat truncates to dstsize-1");
}

static void	test_strchr_strrchr(void)
{
	printf("\n-- ft_strchr / ft_strrchr --\n");
	check(ft_strchr("hello", 'l') == strchr("hello", 'l'),
		"strchr finds first (pointer arithmetic check skipped, value below)");
	check(*ft_strchr("hello", 'l') == 'l', "strchr value");
	check(ft_strchr("hello", 'z') == NULL, "strchr not found");
	check(*ft_strchr("hello", '\0') == '\0', "strchr nul terminator");
	check(*ft_strrchr("hello", 'l') == 'l', "strrchr value");
	check(ft_strrchr("hello", 'z') == NULL, "strrchr not found");
}

static void	test_strncmp_memcmp_memchr(void)
{
	printf("\n-- ft_strncmp / ft_memcmp / ft_memchr --\n");
	check(ft_strncmp("abc", "abd", 3) == strncmp("abc", "abd", 3),
		"strncmp differs at last char");
	check(ft_strncmp("abc", "abc", 3) == 0, "strncmp equal");
	check(ft_strncmp("abc", "abd", 0) == 0, "strncmp n=0 always 0");
	check(ft_memcmp("abc", "abd", 3) == memcmp("abc", "abd", 3),
		"memcmp differs at last byte");
	check(ft_memcmp("abc", "abc", 3) == 0, "memcmp equal");
	check(*(char *)ft_memchr("hello", 'l', 5) == 'l', "memchr found");
	check(ft_memchr("hello", 'z', 5) == NULL, "memchr not found");
}

static void	test_strnstr(void)
{
	printf("\n-- ft_strnstr --\n");
	check_str(ft_strnstr("hello world", "world", 20), "world", "strnstr found");
	check(ft_strnstr("hello world", "xyz", 20) == NULL, "strnstr not found");
	check_str(ft_strnstr("hello world", "", 20), "hello world",
		"strnstr empty needle returns haystack");
	check(ft_strnstr("hello world", "world", 7) == NULL,
		"strnstr respects len limit");
}

static void	test_atoi(void)
{
	printf("\n-- ft_atoi --\n");
	check(ft_atoi("42") == 42, "atoi simple");
	check(ft_atoi("   -42") == -42, "atoi leading whitespace + sign");
	check(ft_atoi("+42") == 42, "atoi explicit plus");
	check(ft_atoi("abc") == 0, "atoi non-numeric");
	check(ft_atoi("42abc") == 42, "atoi stops at non-digit");
	check(ft_atoi("-2147483648") == INT_MIN, "atoi INT_MIN");
}

static void	test_calloc_strdup(void)
{
	void	*p;
	char	*s;

	printf("\n-- ft_calloc / ft_strdup --\n");
	p = ft_calloc(10, sizeof(char));
	check(p != NULL, "calloc normal alloc not null");
	check(((char *)p)[0] == 0 && ((char *)p)[9] == 0, "calloc zeroes memory");
	free(p);
	p = ft_calloc(0, 0);
	check(p != NULL, "calloc(0,0) still returns freeable pointer");
	free(p);
	s = ft_strdup("hello");
	check_str(s, "hello", "strdup copies content");
	free(s);
}

/* ---------------------------------------------------------------------- */
/*  Part 2 - additional functions                                         */
/* ---------------------------------------------------------------------- */

static void	test_substr(void)
{
	char	*s;

	printf("\n-- ft_substr --\n");
	s = ft_substr("hello world", 6, 5);
	check_str(s, "world", "substr normal");
	free(s);
	s = ft_substr("hello", 2, 100);
	check_str(s, "llo", "substr len beyond string");
	free(s);
	s = ft_substr("hello", 100, 5);
	check_str(s, "", "substr start beyond string");
	free(s);
}

static void	test_strjoin(void)
{
	char	*s;

	printf("\n-- ft_strjoin --\n");
	s = ft_strjoin("foo", "bar");
	check_str(s, "foobar", "strjoin normal");
	free(s);
	s = ft_strjoin("", "bar");
	check_str(s, "bar", "strjoin empty s1");
	free(s);
}

static void	test_strtrim(void)
{
	char	*s;

	printf("\n-- ft_strtrim --\n");
	s = ft_strtrim("  hello  ", " ");
	check_str(s, "hello", "strtrim spaces both sides");
	free(s);
	s = ft_strtrim("xxhelloxx", "x");
	check_str(s, "hello", "strtrim custom set");
	free(s);
	s = ft_strtrim("xxxx", "x");
	check_str(s, "", "strtrim entire string trimmed");
	free(s);
}

static void	test_split(void)
{
	char	**res;

	printf("\n-- ft_split --\n");
	res = ft_split("a,b,,c", ',');
	check(res[0] && res[1] && res[2] && !res[3], "split correct word count");
	check_str(res[0], "a", "split word 0");
	check_str(res[1], "b", "split word 1");
	check_str(res[2], "c", "split word 2 (empty fields skipped)");
	free(res[0]);
	free(res[1]);
	free(res[2]);
	free(res);
	res = ft_split("", ',');
	check(res[0] == NULL, "split empty string returns empty array");
	free(res);
}

static void	test_itoa(void)
{
	char	*s;

	printf("\n-- ft_itoa --\n");
	s = ft_itoa(42);
	check_str(s, "42", "itoa positive");
	free(s);
	s = ft_itoa(-42);
	check_str(s, "-42", "itoa negative");
	free(s);
	s = ft_itoa(0);
	check_str(s, "0", "itoa zero");
	free(s);
	s = ft_itoa(INT_MIN);
	check_str(s, "-2147483648", "itoa INT_MIN (overflow trap)");
	free(s);
	s = ft_itoa(INT_MAX);
	check_str(s, "2147483647", "itoa INT_MAX");
	free(s);
}

static char	map_upper(unsigned int i, char c)
{
	(void)i;
	return (ft_toupper(c));
}

static void	iter_upper(unsigned int i, char *c)
{
	(void)i;
	*c = ft_toupper(*c);
}

static void	test_strmapi_striteri(void)
{
	char	*s;
	char	buf[] = "hello";

	printf("\n-- ft_strmapi / ft_striteri --\n");
	s = ft_strmapi("hello", map_upper);
	check_str(s, "HELLO", "strmapi uppercases");
	free(s);
	ft_striteri(buf, iter_upper);
	check_str(buf, "HELLO", "striteri modifies in place");
}

static void	test_put_fd_functions(void)
{
	printf("\n-- ft_put*_fd (visual check, writes to stdout) --\n");
	printf("expected: putchar_fd -> 'A'  putstr_fd -> \"hi\"  ");
	printf("putendl_fd -> \"bye\\n\"  putnbr_fd -> \"-99\"\n");
	printf("actual:   ");
	ft_putchar_fd('A', 1);
	ft_putstr_fd("hi", 1);
	ft_putendl_fd("bye", 1);
	ft_putnbr_fd(-99, 1);
	printf("\n");
	check(1, "put*_fd ran without crashing (verify output above by eye)");
}

/* ---------------------------------------------------------------------- */
/*  Part 3 - linked list                                                  */
/* ---------------------------------------------------------------------- */

static void	del_int(void *content)
{
	free(content);
}

static void	iter_double(void *content)
{
	*(int *)content *= 2;
}

static void	*map_square(void *content)
{
	int	*new_val;

	new_val = malloc(sizeof(int));
	if (!new_val)
		return (NULL);
	*new_val = (*(int *)content) * (*(int *)content);
	return (new_val);
}

static t_list	*make_int_list(int a, int b, int c)
{
	t_list	*lst;
	int		*pa;
	int		*pb;
	int		*pc;

	pa = malloc(sizeof(int));
	pb = malloc(sizeof(int));
	pc = malloc(sizeof(int));
	*pa = a;
	*pb = b;
	*pc = c;
	lst = ft_lstnew(pa);
	ft_lstadd_back(&lst, ft_lstnew(pb));
	ft_lstadd_back(&lst, ft_lstnew(pc));
	return (lst);
}

static void	test_linked_list(void)
{
	t_list	*lst;
	t_list	*mapped;

	printf("\n-- linked list --\n");
	lst = make_int_list(1, 2, 3);
	check(ft_lstsize(lst) == 3, "lstsize counts nodes");
	check(*(int *)ft_lstlast(lst)->content == 3, "lstlast finds tail");

	ft_lstiter(lst, iter_double);
	check(*(int *)lst->content == 2, "lstiter applied to head");
	check(*(int *)ft_lstlast(lst)->content == 6, "lstiter applied to tail");

	mapped = ft_lstmap(lst, map_square, del_int);
	check(mapped != NULL && ft_lstsize(mapped) == 3, "lstmap builds new list");
	check(*(int *)mapped->content == 4, "lstmap squares first value (2*2)");

	ft_lstclear(&lst, del_int);
	check(lst == NULL, "lstclear nulls the head pointer");
	ft_lstclear(&mapped, del_int);
	check(mapped == NULL, "lstclear on mapped list");
}

static void	test_lstadd_front(void)
{
	t_list	*lst;
	int		val_a = 1;
	int		val_b = 2;

	printf("\n-- ft_lstadd_front --\n");
	lst = ft_lstnew(&val_a);
	ft_lstadd_front(&lst, ft_lstnew(&val_b));
	check(*(int *)lst->content == 2, "lstadd_front new head");
	check(*(int *)lst->next->content == 1, "lstadd_front old head now second");
	free(lst->next);
	free(lst);
}

int	main(void)
{
	printf("=========== LIBFT TEST SUITE ===========\n");
	test_char_classification();
	test_strlen();
	test_memset_bzero();
	test_memcpy_memmove();
	test_strlcpy_strlcat();
	test_strchr_strrchr();
	test_strncmp_memcmp_memchr();
	test_strnstr();
	test_atoi();
	test_calloc_strdup();
	test_substr();
	test_strjoin();
	test_strtrim();
	test_split();
	test_itoa();
	test_strmapi_striteri();
	test_put_fd_functions();
	test_lstadd_front();
	test_linked_list();
	printf("\n==========================================\n");
	printf("Results: " GREEN "%d passed" RESET ", %s%d failed" RESET "\n",
		g_pass, g_fail ? RED : GREEN, g_fail);
	if (g_fail)
		return (1);
	return (0);
}
