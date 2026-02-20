/* ************************************************************************** */
/*                                                                            */
/*   Project : Student Grade Manager v2                                       */
/*   Author  : Miles3103                                                      */
/*   Topic   : Project — combining structs, arrays, functions, strings        */
/*                                                                            */
/* ************************************************************************** */

/*
** THIS IS A SHOWCASE PROJECT.
** It combines everything you've learned:
**   - Structs (custom data types)
**   - Arrays of structs
**   - Functions with pointers
**   - String handling
**   - Sorting
**   - Formatted output
**
** This is the kind of code you put on GitHub to show real C skill.
*/

#include <stdio.h>
#include <string.h>

#define MAX_STUDENTS 10
#define NAME_LEN     32

/* ============================================================ */
/*  STRUCT — group related data into one type                    */
/* ============================================================ */

typedef struct s_student
{
	char	name[NAME_LEN];
	double	score;
	char	grade;
	int		rank;
}	t_student;

/* ============================================================ */
/*  HELPER FUNCTIONS                                             */
/* ============================================================ */

/*
** @desc   Assigns a letter grade based on score.
*/
char	assign_grade(double score)
{
	if (score >= 90.0) return ('A');
	if (score >= 80.0) return ('B');
	if (score >= 70.0) return ('C');
	if (score >= 60.0) return ('D');
	return ('F');
}

/*
** @desc   Sorts students by score (descending) using bubble sort.
**         Modifies the array in-place.
*/
void	sort_by_score(t_student *students, int count)
{
	t_student	tmp;
	int			swapped;
	int			i;

	while (1)
	{
		swapped = 0;
		i = 0;
		while (i < count - 1)
		{
			if (students[i].score < students[i + 1].score)
			{
				tmp = students[i];
				students[i] = students[i + 1];
				students[i + 1] = tmp;
				swapped = 1;
			}
			i++;
		}
		if (!swapped)
			break ;
		count--;
	}
}

/*
** @desc   Assigns ranks after sorting (1 = highest score).
*/
void	assign_ranks(t_student *students, int count)
{
	for (int i = 0; i < count; i++)
		students[i].rank = i + 1;
}

/*
** @desc   Calculates class average.
*/
double	class_average(t_student *students, int count)
{
	double	total;

	total = 0.0;
	for (int i = 0; i < count; i++)
		total += students[i].score;
	return (total / count);
}

/*
** @desc   Prints the full leaderboard.
*/
void	print_leaderboard(t_student *students, int count)
{
	printf("\n");
	printf("+=====+=========================+=========+======+==========+\n");
	printf("| Rank| Name                    |   Score | Grade| Status   |\n");
	printf("+=====+=========================+=========+======+==========+\n");
	for (int i = 0; i < count; i++)
	{
		printf("| %3d | %-23s | %7.2f | %4c | %-8s |\n",
			students[i].rank,
			students[i].name,
			students[i].score,
			students[i].grade,
			students[i].score >= 70.0 ? "PASSED" : "FAILED");
	}
	printf("+=====+=========================+=========+======+==========+\n");
}

/*
** @desc   Prints class statistics.
*/
void	print_stats(t_student *students, int count)
{
	double	avg = class_average(students, count);
	int		passed = 0;
	int		failed = 0;

	for (int i = 0; i < count; i++)
	{
		if (students[i].score >= 70.0) passed++;
		else                           failed++;
	}

	printf("\n=== Class Statistics ===\n");
	printf("Class Average : %.2f\n", avg);
	printf("Highest Score : %.2f (%s)\n",
		students[0].score, students[0].name);
	printf("Lowest Score  : %.2f (%s)\n",
		students[count - 1].score, students[count - 1].name);
	printf("Passed        : %d / %d\n", passed, count);
	printf("Failed        : %d / %d\n", failed, count);
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* Hardcoded student data — in a real program you'd read from a file */
	t_student	students[MAX_STUDENTS] = {
		{"Alice",   92.5, 0, 0},
		{"Miles3103", 88.0, 0, 0},
		{"Bob",     74.3, 0, 0},
		{"Charlie", 55.0, 0, 0},
		{"Diana",   98.1, 0, 0},
		{"Eve",     61.5, 0, 0},
		{"Frank",   83.7, 0, 0},
	};
	int	count = 7;

	/* Assign grades */
	for (int i = 0; i < count; i++)
		students[i].grade = assign_grade(students[i].score);

	/* Sort by score and assign ranks */
	sort_by_score(students, count);
	assign_ranks(students, count);

	/* Display results */
	printf("╔══════════════════════════════════════════╗\n");
	printf("║      STUDENT GRADE MANAGER v2.0         ║\n");
	printf("║      Author: Miles3103                  ║\n");
	printf("╚══════════════════════════════════════════╝\n");

	print_leaderboard(students, count);
	print_stats(students, count);

	return (0);
}
