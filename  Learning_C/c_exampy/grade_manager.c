/* ************************************************************************** */
/*                                                                            */
/*   Project : Student Grade Manager v2                                       */
/*   Author  : Miles3103                                                      */
/*   Topic   : Project — combining structs, arrays, functions, strings        */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS THIS PROJECT?
**
**   This is a showcase project combining everything learned so far:
**     - Structs     → group related fields into one custom type
**     - Arrays      → store and iterate over a collection of structs
**     - Functions   → modular logic with clear inputs and outputs
**     - Pointers    → modify structs in-place without copying
**     - Sorting     → bubble sort adapted for custom struct fields
**     - Formatting  → printf format specifiers for aligned table output
**
**   This is the kind of real C code you put on GitHub to demonstrate skill.
**
** STRUCTS IN C:
**   A struct groups related variables under one name and type.
**   You access fields with the dot operator: student.score
**   When passed by pointer, use the arrow: student->score
**
**   typedef struct s_student
**   {
**       char    name[32];
**       double  score;
**       char    grade;
**       int     rank;
**   } t_student;
**
** NOTE:
**   Structs are passed by VALUE in C — the whole struct is copied.
**   For efficiency and in-place modification, always pass a pointer:
**   void sort(t_student *students, int count)
*/

#include <stdio.h>
#include <string.h>

#define MAX_STUDENTS  10   /* maximum number of students the array can hold */
#define NAME_LEN      32   /* maximum length of a student name including '\0' */

/* ============================================================ */
/*  STRUCT — group related data into one custom type            */
/* ============================================================ */

typedef struct s_student
{
	char	name[NAME_LEN];
	double	score;
	char	grade;
	int		rank;
}	t_student;

/* ============================================================ */
/*  HELPER FUNCTIONS                                            */
/* ============================================================ */

/*
** @desc   Assigns a letter grade based on a numeric score.
** @param  score : the student's score (0.0 – 100.0)
** @return       : 'A', 'B', 'C', 'D', or 'F'
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
** @desc   Sorts the students array by score in descending order.
**         Uses bubble sort — simple and correct for small arrays.
** @param  students : pointer to the array (modified in-place)
** @param  count    : number of students in the array
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
				tmp            = students[i];
				students[i]    = students[i + 1];
				students[i + 1] = tmp;
				swapped = 1;
			}
			i++;
		}
		if (!swapped)  /* no swaps this pass = already sorted */
			break ;
		count--;       /* largest is settled at the end — skip it */
	}
}

/*
** @desc   Assigns ranks 1..count after the array is sorted.
**         Rank 1 = highest score.
*/
void	assign_ranks(t_student *students, int count)
{
	for (int i = 0; i < count; i++)
		students[i].rank = i + 1;
}

/*
** @desc   Returns the class average score.
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
** @desc   Prints the full leaderboard as a formatted table.
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
** @desc   Prints class statistics — average, high, low, pass/fail counts.
**         Assumes array is already sorted descending by score.
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
		students[0].score, students[0].name);          /* index 0 = highest after sort */
	printf("Lowest Score  : %.2f (%s)\n",
		students[count - 1].score, students[count - 1].name); /* last = lowest */
	printf("Passed        : %d / %d\n", passed, count);
	printf("Failed        : %d / %d\n", failed, count);
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* Student data — in a real program this would come from a file or input */
	t_student	students[MAX_STUDENTS] = {
		{"Alice",     92.5, 0, 0},
		{"Miles3103", 88.0, 0, 0},
		{"Bob",       74.3, 0, 0},
		{"Charlie",   55.0, 0, 0},
		{"Diana",     98.1, 0, 0},
		{"Eve",       61.5, 0, 0},
		{"Frank",     83.7, 0, 0},
	};
	int	count = 7;

	/* Assign letter grades before sorting */
	for (int i = 0; i < count; i++)
		students[i].grade = assign_grade(students[i].score);

	/* Sort descending by score, then assign ranks 1..count */
	sort_by_score(students, count);
	assign_ranks(students, count);

	/* Display */
	printf("╔══════════════════════════════════════════╗\n");
	printf("║      STUDENT GRADE MANAGER v2.0         ║\n");
	printf("║      Author: Miles3103                  ║\n");
	printf("╚══════════════════════════════════════════╝\n");

	print_leaderboard(students, count);
	print_stats(students, count);

	return (0);
}
