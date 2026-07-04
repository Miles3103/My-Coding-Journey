/* test.c — numbered libft test harness
**
** Usage:
**   ./test          -> shows the menu
**   ./test all      -> runs every test
**   ./test 7        -> runs only test 7
**   ./test 3 12 30  -> runs tests 3, 12 and 30
**
** Not part of the submission — for your own use only.
*/

#include "libft.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int	g_pass;
static int	g_fail;

#define OK(cond, label) do { \
	if (cond) { g_pass++; printf("  [PASS] %s\n", label); } \
	else { g_fail++; printf("  [FAIL] %s\n", label); } \
} while (0)

/* ---- helpers for Part 2/3 manual checks (no libc equivalent) ---- */

static char	to_upper_helper(unsigned int i, char c)
{
	(void)i;
	if (c >= 'a' && c <= 'z')
		return (c - 32);
	return (c);
}

static void	upper_inplace_helper(unsigned int i, char *c)
{
	(void)i;
	if (*c >= 'a' && *c <= 'z')
		*c -= 32;
}

static void	free_str_helper(void *content)
{
	free(content);
}

static void	upper_content_helper(void *content)
{
	char	*s;
	int		i;

	s = (char *)content;
	i = 0;
	while (s[i])
	{
		if (s[i] >= 'a' && s[i] <= 'z')
			s[i] -= 32;
		i++;
	}
}

static void	*dup_upper_helper(void *content)
{
	char	*s;
	char	*copy;
	int		i;

	s = (char *)content;
	copy = malloc(strlen(s) + 1);
	i = 0;
	while (s[i])
	{
		copy[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
		i++;
	}
	copy[i] = 0;
	return (copy);
}

/* ================= PART 1 ================= */

static void t01_isalpha(void)
{
	printf("01. ft_isalpha\n");
	OK(ft_isalpha('a') != 0, "'a' -> true");
	OK(ft_isalpha('Z') != 0, "'Z' -> true");
	OK(ft_isalpha('5') == 0, "'5' -> false");
	OK(ft_isalpha(' ') == 0, "' ' -> false");
}

static void t02_isdigit(void)
{
	printf("02. ft_isdigit\n");
	OK(ft_isdigit('0') != 0, "'0' -> true");
	OK(ft_isdigit('9') != 0, "'9' -> true");
	OK(ft_isdigit('a') == 0, "'a' -> false");
}

static void t03_isalnum(void)
{
	printf("03. ft_isalnum\n");
	OK(ft_isalnum('a') != 0, "'a' -> true");
	OK(ft_isalnum('5') != 0, "'5' -> true");
	OK(ft_isalnum('!') == 0, "'!' -> false");
}

static void t04_isascii(void)
{
	printf("04. ft_isascii\n");
	OK(ft_isascii(0) != 0, "0 -> true");
	OK(ft_isascii(127) != 0, "127 -> true");
	OK(ft_isascii(128) == 0, "128 -> false");
	OK(ft_isascii(-1) == 0, "-1 -> false");
}

static void t05_isprint(void)
{
	printf("05. ft_isprint\n");
	OK(ft_isprint(' ') != 0, "' ' -> true");
	OK(ft_isprint('~') != 0, "'~' -> true");
	OK(ft_isprint(0) == 0, "0 -> false");
	OK(ft_isprint(127) == 0, "127 (DEL) -> false");
}

static void t06_strlen(void)
{
	printf("06. ft_strlen\n");
	OK(ft_strlen("") == strlen(""), "empty string");
	OK(ft_strlen("hello") == strlen("hello"), "\"hello\"");
	OK(ft_strlen("a b c") == strlen("a b c"), "\"a b c\"");
}

static void t07_memset(void)
{
	char a[10];
	char b[10];

	printf("07. ft_memset\n");
	memset(b, 'x', 10);
	ft_memset(a, 'x', 10);
	OK(memcmp(a, b, 10) == 0, "fill 10 bytes with 'x'");
	memset(b, 0, 5);
	ft_memset(a, 0, 5);
	OK(memcmp(a, b, 10) == 0, "fill 5 bytes with 0");
}

static void t08_bzero(void)
{
	char a[10];
	char b[10];

	printf("08. ft_bzero\n");
	memset(a, 'z', 10);
	memset(b, 'z', 10);
	bzero(b, 10);
	ft_bzero(a, 10);
	OK(memcmp(a, b, 10) == 0, "zero 10 bytes");
}

static void t09_memcpy(void)
{
	char a[20];
	char b[20];

	printf("09. ft_memcpy\n");
	memcpy(b, "hello world", 12);
	ft_memcpy(a, "hello world", 12);
	OK(memcmp(a, b, 12) == 0, "copy 12 bytes");
}

static void t10_memmove(void)
{
	char a[20] = "123456789";
	char b[20] = "123456789";

	printf("10. ft_memmove\n");
	memmove(b + 2, b, 5);
	ft_memmove(a + 2, a, 5);
	OK(memcmp(a, b, 9) == 0, "overlapping move fwd");
	strcpy(a, "123456789");
	strcpy(b, "123456789");
	memmove(b, b + 2, 5);
	ft_memmove(a, a + 2, 5);
	OK(memcmp(a, b, 9) == 0, "overlapping move back");
}

static void t11_strlcpy(void)
{
	char a[20];
	char b[20];
	size_t ra, rb;

	printf("11. ft_strlcpy\n");
	rb = strlcpy(b, "hello", 20);
	ra = ft_strlcpy(a, "hello", 20);
	OK(ra == rb && strcmp(a, b) == 0, "dst big enough");
	rb = strlcpy(b, "hello", 3);
	ra = ft_strlcpy(a, "hello", 3);
	OK(ra == rb && strcmp(a, b) == 0, "dst too small (truncated)");
	rb = strlcpy(b, "hello", 0);
	ra = ft_strlcpy(a, "hello", 0);
	OK(ra == rb, "size 0 (no write, returns strlen(src))");
}

static void t12_strlcat(void)
{
	char a[20];
	char b[20];
	size_t ra, rb;

	printf("12. ft_strlcat\n");
	strcpy(a, "foo"); strcpy(b, "foo");
	rb = strlcat(b, "bar", 20);
	ra = ft_strlcat(a, "bar", 20);
	OK(ra == rb && strcmp(a, b) == 0, "normal concat");
	strcpy(a, "foo"); strcpy(b, "foo");
	rb = strlcat(b, "bar", 5);
	ra = ft_strlcat(a, "bar", 5);
	OK(ra == rb && strcmp(a, b) == 0, "truncated concat");
}

static void t13_toupper(void)
{
	printf("13. ft_toupper\n");
	OK(ft_toupper('a') == 'A', "'a' -> 'A'");
	OK(ft_toupper('Z') == 'Z', "'Z' stays 'Z'");
	OK(ft_toupper('5') == '5', "'5' stays '5'");
}

static void t14_tolower(void)
{
	printf("14. ft_tolower\n");
	OK(ft_tolower('A') == 'a', "'A' -> 'a'");
	OK(ft_tolower('z') == 'z', "'z' stays 'z'");
	OK(ft_tolower('5') == '5', "'5' stays '5'");
}

static void t15_strchr(void)
{
	const char *s = "hello world";

	printf("15. ft_strchr\n");
	OK(ft_strchr(s, 'w') == strchr(s, 'w'), "find 'w'");
	OK(ft_strchr(s, 'z') == strchr(s, 'z'), "not found -> NULL");
	OK(ft_strchr(s, '\0') == strchr(s, '\0'), "find '\\0' (end)");
}

static void t16_strrchr(void)
{
	const char *s = "hello world";

	printf("16. ft_strrchr\n");
	OK(ft_strrchr(s, 'o') == strrchr(s, 'o'), "find last 'o'");
	OK(ft_strrchr(s, 'z') == strrchr(s, 'z'), "not found -> NULL");
}

static void t17_strncmp(void)
{
	printf("17. ft_strncmp\n");
	OK(ft_strncmp("abc", "abd", 3) == strncmp("abc", "abd", 3), "\"abc\" vs \"abd\"");
	OK(ft_strncmp("abc", "abc", 5) == strncmp("abc", "abc", 5), "equal, n > len");
	OK((ft_strncmp("abc", "abd", 2) == 0) == (strncmp("abc", "abd", 2) == 0), "n limits comparison");
}

static void t18_memchr(void)
{
	const char *s = "hello world";

	printf("18. ft_memchr\n");
	OK(ft_memchr(s, 'w', 11) == memchr(s, 'w', 11), "find 'w'");
	OK(ft_memchr(s, 'z', 11) == memchr(s, 'z', 11), "not found -> NULL");
}

static void t19_memcmp(void)
{
	printf("19. ft_memcmp\n");
	OK((ft_memcmp("abc", "abd", 3) == 0) == (memcmp("abc", "abd", 3) == 0), "diff bytes");
	OK(ft_memcmp("abc", "abc", 3) == memcmp("abc", "abc", 3), "equal bytes");
}

/* strnstr is BSD-only; glibc doesn't declare it (see subject note).
** Test manually instead of comparing against libc. */
static void t20_strnstr(void)
{
	const char *s = "hello world";
	char *r;

	printf("20. ft_strnstr\n");
	r = ft_strnstr(s, "world", 11);
	OK(r == s + 6, "found within len (\"world\" at offset 6)");
	r = ft_strnstr(s, "world", 5);
	OK(r == NULL, "not found, len too short to reach needle");
	r = ft_strnstr(s, "", 11);
	OK(r == s, "empty needle -> returns haystack");
	r = ft_strnstr(s, "xyz", 11);
	OK(r == NULL, "needle not present -> NULL");
}

static void t21_atoi(void)
{
	printf("21. ft_atoi\n");
	OK(ft_atoi("42") == atoi("42"), "\"42\"");
	OK(ft_atoi("   -42") == atoi("   -42"), "leading spaces + minus");
	OK(ft_atoi("+42") == atoi("+42"), "leading plus");
	OK(ft_atoi("abc") == atoi("abc"), "non numeric -> 0");
	OK(ft_atoi("42abc") == atoi("42abc"), "stops at first non-digit");
}

static void t22_calloc(void)
{
	unsigned char *p;
	int i;
	int allzero;

	printf("22. ft_calloc\n");
	p = ft_calloc(10, 1);
	allzero = 1;
	i = 0;
	while (i < 10)
	{
		if (p[i] != 0)
			allzero = 0;
		i++;
	}
	OK(allzero, "10 bytes all zeroed");
	free(p);
	p = ft_calloc(0, 0);
	OK(p != NULL, "nmemb=0/size=0 returns non-NULL freeable pointer");
	free(p);
}

static void t23_strdup(void)
{
	char *d;

	printf("23. ft_strdup\n");
	d = ft_strdup("hello");
	OK(d != NULL && strcmp(d, "hello") == 0, "copies string");
	free(d);
}

/* ================= PART 2 ================= */

static void t24_substr(void)
{
	char *r;

	printf("24. ft_substr\n");
	r = ft_substr("hello world", 6, 5);
	OK(r != NULL && strcmp(r, "world") == 0, "middle substring");
	free(r);
	r = ft_substr("hello", 0, 100);
	OK(r != NULL && strcmp(r, "hello") == 0, "len > strlen, clamps");
	free(r);
	r = ft_substr("hello", 100, 5);
	OK(r != NULL && strcmp(r, "") == 0, "start beyond string -> \"\"");
	free(r);
}

static void t25_strjoin(void)
{
	char *r;

	printf("25. ft_strjoin\n");
	r = ft_strjoin("foo", "bar");
	OK(r != NULL && strcmp(r, "foobar") == 0, "\"foo\" + \"bar\"");
	free(r);
	r = ft_strjoin("", "bar");
	OK(r != NULL && strcmp(r, "bar") == 0, "empty prefix");
	free(r);
}

static void t26_strtrim(void)
{
	char *r;

	printf("26. ft_strtrim\n");
	r = ft_strtrim("   hello   ", " ");
	OK(r != NULL && strcmp(r, "hello") == 0, "trim spaces both sides");
	free(r);
	r = ft_strtrim("xxhelloxx", "x");
	OK(r != NULL && strcmp(r, "hello") == 0, "trim custom char set");
	free(r);
	r = ft_strtrim("xxxx", "x");
	OK(r != NULL && strcmp(r, "") == 0, "trims to empty string");
	free(r);
}

static void t27_split(void)
{
	char **r;

	printf("27. ft_split\n");
	r = ft_split("hello world foo", ' ');
	OK(r && r[0] && r[1] && r[2] && !r[3]
		&& strcmp(r[0], "hello") == 0
		&& strcmp(r[1], "world") == 0
		&& strcmp(r[2], "foo") == 0, "3 words, NULL terminated");
	if (r) { free(r[0]); free(r[1]); free(r[2]); free(r); }
	r = ft_split("   a   b   ", ' ');
	OK(r && r[0] && r[1] && !r[2]
		&& strcmp(r[0], "a") == 0 && strcmp(r[1], "b") == 0,
		"repeated separators collapse");
	if (r) { free(r[0]); free(r[1]); free(r); }
	r = ft_split("", ' ');
	OK(r && !r[0], "empty string -> empty array");
	if (r) free(r);
}

static void t28_itoa(void)
{
	char *r;

	printf("28. ft_itoa\n");
	r = ft_itoa(42);
	OK(r != NULL && strcmp(r, "42") == 0, "positive number");
	free(r);
	r = ft_itoa(-42);
	OK(r != NULL && strcmp(r, "-42") == 0, "negative number");
	free(r);
	r = ft_itoa(0);
	OK(r != NULL && strcmp(r, "0") == 0, "zero");
	free(r);
	r = ft_itoa(-2147483648);
	OK(r != NULL && strcmp(r, "-2147483648") == 0, "INT_MIN edge case");
	free(r);
}

static void t29_strmapi(void)
{
	char *r;

	printf("29. ft_strmapi\n");
	r = ft_strmapi("hello", to_upper_helper);
	OK(r != NULL && strcmp(r, "HELLO") == 0, "uppercases via callback");
	free(r);
	r = ft_strmapi("", to_upper_helper);
	OK(r != NULL && strcmp(r, "") == 0, "empty string in/out");
	free(r);
}

static void t30_striteri(void)
{
	char s[] = "hello";

	printf("30. ft_striteri\n");
	ft_striteri(s, upper_inplace_helper);
	OK(strcmp(s, "HELLO") == 0, "uppercases in place via callback");
}

static void t31_putchar_fd(void)
{
	printf("31. ft_putchar_fd (visual check, writes to stdout)\n  -> ");
	ft_putchar_fd('A', 1);
	printf("\n  Expected: A\n");
}

static void t32_putstr_fd(void)
{
	printf("32. ft_putstr_fd (visual check)\n  -> ");
	ft_putstr_fd("hello", 1);
	printf("\n  Expected: hello\n");
}

static void t33_putendl_fd(void)
{
	printf("33. ft_putendl_fd (visual check)\n  -> ");
	ft_putendl_fd("hello", 1);
	printf("  Expected: hello (with trailing newline above)\n");
}

static void t34_putnbr_fd(void)
{
	printf("34. ft_putnbr_fd (visual check)\n  -> ");
	ft_putnbr_fd(-42, 1);
	printf("\n  Expected: -42\n");
}

/* ================= PART 3 ================= */

static void t35_lstnew(void)
{
	t_list *n;
	int val = 42;

	printf("35. ft_lstnew\n");
	n = ft_lstnew(&val);
	OK(n != NULL && n->content == &val && n->next == NULL, "new node correctly init");
	free(n);
}

static void t36_lstadd_front(void)
{
	t_list *lst;
	t_list *a;
	t_list *b;
	int v1 = 1, v2 = 2;

	printf("36. ft_lstadd_front\n");
	a = ft_lstnew(&v1);
	lst = a;
	b = ft_lstnew(&v2);
	ft_lstadd_front(&lst, b);
	OK(lst == b && lst->next == a, "new node becomes head");
	free(a); free(b);
}

static void t37_lstsize(void)
{
	t_list *a, *b, *c;
	int v = 1;

	printf("37. ft_lstsize\n");
	a = ft_lstnew(&v); b = ft_lstnew(&v); c = ft_lstnew(&v);
	a->next = b; b->next = c;
	OK(ft_lstsize(a) == 3, "3-node list");
	OK(ft_lstsize(NULL) == 0, "empty list -> 0");
	free(a); free(b); free(c);
}

static void t38_lstlast(void)
{
	t_list *a, *b, *c;
	int v = 1;

	printf("38. ft_lstlast\n");
	a = ft_lstnew(&v); b = ft_lstnew(&v); c = ft_lstnew(&v);
	a->next = b; b->next = c;
	OK(ft_lstlast(a) == c, "returns last node");
	OK(ft_lstlast(a) != NULL, "single/multi node works");
	free(a); free(b); free(c);
}

static void t39_lstadd_back(void)
{
	t_list *lst;
	t_list *a, *b;
	int v1 = 1, v2 = 2;

	printf("39. ft_lstadd_back\n");
	a = ft_lstnew(&v1);
	lst = a;
	b = ft_lstnew(&v2);
	ft_lstadd_back(&lst, b);
	OK(lst == a && a->next == b && b->next == NULL, "new node appended at end");
	free(a); free(b);
}

static void t40_lstdelone(void)
{
	t_list *n;
	char *content;

	printf("40. ft_lstdelone\n");
	content = malloc(6);
	strcpy(content, "hello");
	n = ft_lstnew(content);
	ft_lstdelone(n, free_str_helper);
	OK(1, "run under valgrind to confirm content+node freed, no crash");
}

static void t41_lstclear(void)
{
	t_list *lst;
	t_list *a, *b, *c;
	char *c1 = strdup("a");
	char *c2 = strdup("b");
	char *c3 = strdup("c");

	printf("41. ft_lstclear\n");
	a = ft_lstnew(c1); b = ft_lstnew(c2); c = ft_lstnew(c3);
	a->next = b; b->next = c;
	lst = a;
	ft_lstclear(&lst, free_str_helper);
	OK(lst == NULL, "list pointer set to NULL after clear");
}

static void t42_lstiter(void)
{
	t_list *a, *b;
	char *c1 = strdup("hello");
	char *c2 = strdup("world");

	printf("42. ft_lstiter\n");
	a = ft_lstnew(c1); b = ft_lstnew(c2);
	a->next = b;
	ft_lstiter(a, upper_content_helper);
	OK(strcmp(c1, "HELLO") == 0 && strcmp(c2, "WORLD") == 0,
		"applies function to every node's content");
	ft_lstdelone(a, free_str_helper);
	ft_lstdelone(b, free_str_helper);
}

static void t43_lstmap(void)
{
	t_list *a, *b, *new_lst;
	char *c1 = strdup("hello");
	char *c2 = strdup("world");

	printf("43. ft_lstmap\n");
	a = ft_lstnew(c1); b = ft_lstnew(c2);
	a->next = b;
	new_lst = ft_lstmap(a, dup_upper_helper, free_str_helper);
	OK(new_lst != NULL
		&& strcmp((char *)new_lst->content, "HELLO") == 0
		&& strcmp((char *)new_lst->next->content, "WORLD") == 0,
		"maps to new uppercased list");
	ft_lstdelone(a, free_str_helper);
	ft_lstdelone(b, free_str_helper);
	ft_lstclear(&new_lst, free_str_helper);
}

/* ================= runner ================= */

typedef struct s_test
{
	int		id;
	char	*name;
	void	(*fn)(void);
}	t_test;

static t_test g_tests[] = {
	{1, "ft_isalpha", t01_isalpha}, {2, "ft_isdigit", t02_isdigit},
	{3, "ft_isalnum", t03_isalnum}, {4, "ft_isascii", t04_isascii},
	{5, "ft_isprint", t05_isprint}, {6, "ft_strlen", t06_strlen},
	{7, "ft_memset", t07_memset}, {8, "ft_bzero", t08_bzero},
	{9, "ft_memcpy", t09_memcpy}, {10, "ft_memmove", t10_memmove},
	{11, "ft_strlcpy", t11_strlcpy}, {12, "ft_strlcat", t12_strlcat},
	{13, "ft_toupper", t13_toupper}, {14, "ft_tolower", t14_tolower},
	{15, "ft_strchr", t15_strchr}, {16, "ft_strrchr", t16_strrchr},
	{17, "ft_strncmp", t17_strncmp}, {18, "ft_memchr", t18_memchr},
	{19, "ft_memcmp", t19_memcmp}, {20, "ft_strnstr", t20_strnstr},
	{21, "ft_atoi", t21_atoi}, {22, "ft_calloc", t22_calloc},
	{23, "ft_strdup", t23_strdup}, {24, "ft_substr", t24_substr},
	{25, "ft_strjoin", t25_strjoin}, {26, "ft_strtrim", t26_strtrim},
	{27, "ft_split", t27_split}, {28, "ft_itoa", t28_itoa},
	{29, "ft_strmapi", t29_strmapi}, {30, "ft_striteri", t30_striteri},
	{31, "ft_putchar_fd", t31_putchar_fd}, {32, "ft_putstr_fd", t32_putstr_fd},
	{33, "ft_putendl_fd", t33_putendl_fd}, {34, "ft_putnbr_fd", t34_putnbr_fd},
	{35, "ft_lstnew", t35_lstnew}, {36, "ft_lstadd_front", t36_lstadd_front},
	{37, "ft_lstsize", t37_lstsize}, {38, "ft_lstlast", t38_lstlast},
	{39, "ft_lstadd_back", t39_lstadd_back}, {40, "ft_lstdelone", t40_lstdelone},
	{41, "ft_lstclear", t41_lstclear}, {42, "ft_lstiter", t42_lstiter},
	{43, "ft_lstmap", t43_lstmap},
};

#define NTESTS (int)(sizeof(g_tests) / sizeof(g_tests[0]))

static void	print_menu(void)
{
	int i;

	printf("Available tests:\n");
	i = 0;
	while (i < NTESTS)
	{
		printf("  %2d) %s\n", g_tests[i].id, g_tests[i].name);
		i++;
	}
	printf("\nUsage: ./test all | ./test <n> [<n> ...]\n");
}

static void	run_by_id(int id)
{
	int i;

	i = 0;
	while (i < NTESTS)
	{
		if (g_tests[i].id == id)
		{
			g_tests[i].fn();
			printf("\n");
			return ;
		}
		i++;
	}
	printf("No test numbered %d\n", id);
}

int	main(int argc, char **argv)
{
	int i;

	if (argc < 2)
	{
		print_menu();
		return (0);
	}
	if (strcmp(argv[1], "all") == 0)
	{
		i = 0;
		while (i < NTESTS)
		{
			g_tests[i].fn();
			printf("\n");
			i++;
		}
	}
	else
	{
		i = 1;
		while (i < argc)
		{
			run_by_id(atoi(argv[i]));
			i++;
		}
	}
	printf("==== %d passed, %d failed ====\n", g_pass, g_fail);
	return (g_fail != 0);
}
