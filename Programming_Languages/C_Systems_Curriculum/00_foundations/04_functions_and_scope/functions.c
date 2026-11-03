#include <stdio.h>

static int next_id(void)              /* 'static' local keeps its value between calls */
{
    static int id = 0;
    return ++id;
}

static void swap_wrong(int a, int b)  /* receives COPIES, so the caller never sees the swap */
{
    int t = a; a = b; b = t;
}

static long factorial(int n)          /* recursion: a function calling itself */
{
    return n <= 1 ? 1 : n * factorial(n - 1);
}

static void show_stack_address(int depth)
{
    int local = depth;
    printf("depth %d: local variable lives at %p\n", depth, (void *)&local);
    if (depth < 3) show_stack_address(depth + 1);
}

int main(void)
{
    /* NOTE: C does NOT define the order in which function arguments are evaluated.
     * printf("%d %d", next_id(), next_id()) could print "2 1". Sequence calls with separate statements. */
    int first = next_id();
    int second = next_id();
    int third = next_id();
    printf("next_id: %d %d %d\n", first, second, third);

    int x = 1, y = 2;
    swap_wrong(x, y);
    printf("after swap_wrong: x=%d y=%d (unchanged! C passes by value)\n", x, y);

    printf("10! = %ld\n", factorial(10));

    printf("\nEach call gets its own stack frame; deeper calls sit at lower addresses:\n");
    show_stack_address(0);
    return 0;
}
