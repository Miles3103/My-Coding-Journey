#include <unistd.h>

int main(void)
{
	write (1, "Hello, C World!\n", 16);
	return 0;
}
