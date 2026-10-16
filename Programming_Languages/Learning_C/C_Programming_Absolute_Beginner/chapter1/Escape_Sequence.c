/* Common Esxape Sequnces */

// (\n) 	Creates a new line
// (\t)		Moves the cursor to the next tab
// (\r)		Moves the cursor to the beginning of the current line
// (\\)		Inserts a backslash
// (\*)		Inserts a double quote
// (\')		Insert a single quote

#include <stdio.h>

int	 main(void)
{
	// (\n) New line
	printf("Creating a new line >> \n new line ");
	printf("==================================\n");
	printf("\tMoveing the cursor to the beginning of the current line \t\n");

	// (\t) Tab
	printf("############################################################\n");
	printf("\nSun\tMon\tWed\tTue\tThu\tFri\tSat\n");
	printf("\t\t\t\t1\t2\t3\n");
	printf("4\t5\t6\t7\t8\t9\t10\n");
	printf("11\t12\t13\t14\t15\t16\t17\n");
	printf("18\t19\t20\t21\t22\t23\t24\n");
	printf("25\t26\t27\t28\t29\t30\t31\n");

	printf("*************************************\n");

	// (\r) 
	printf("This escape sequence moves the cursor ");
	printf("to the beginning of this line\r");
	printf("*************************************\n");

	// (\\) 
	printf("hell\\miles\\0101");

	printf("*************************************\n");

	printf("\nA single quote looks like \'\n");
	
	printf("*************************************\n");
}
