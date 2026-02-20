/* ************************************************************************** */
/* */
/* Project: Integrated Variable System                                        */
/* Author:  Miles3103                                                         */
/* Description: Combining int, float, double, char, and bool into one system. */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <stdbool.h>

int	main(void)
{
	// --- 1. Identity (Text & Chars) ---
	char	name[] = "Miles3103";
	char	rank = 'S'; // S-Tier rank

	// --- 2. Stats (Integers) ---
	int	level = 15;
	int	experience = 146858894;

	// --- 3. Physics & Measurements (Decimals) ---
	float	health = 98.5f;
	double	accuracy = 0.999987654321; // High precision

	// --- 4. Logic (Booleans) ---
	bool	is_online = true;

	// --- Output: Bringing it all together ---
	printf("=== USER PROFILE: %s ===\n", name);
	printf("Status:  [%s]\n", is_online ? "ONLINE" : "OFFLINE");
	printf("Rank:    %c\n", rank);
	printf("Level:   %d\n", level);
	printf("XP:      %d pts\n", experience);
	printf("Health:  %.1f%%\n", health);
	printf("Aim:     %.8f precision\n", accuracy);
	printf("============================\n");

	return (0);
}
