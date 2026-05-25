/* ************************************************************************** */
/*                                                                            */
/*   Project : Scope — Complete Guide                                         */
/*   Author  : Miles3103                                                      */
/*   Topic   : Scope — local, global, static, block, shadowing                */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS SCOPE?
**
**   Scope defines WHERE in your code a variable is visible and usable.
**   A variable only exists within the block {} it was declared in.
**   Try to use it outside that block and the compiler will error.
**
**   C has four levels of scope:
**
**   BLOCK SCOPE (most common)
**     → Variable declared inside {}  — lives only in that block
**     → Created when the block is entered, destroyed when it exits
**     → This includes: function bodies, if/else, for, while blocks
**
**   FUNCTION SCOPE
**     → goto labels — almost never used in modern C
**
**   FILE SCOPE (global)
**     → Variable declared OUTSIDE any function
**     → Visible to every function in the file from declaration onward
**     → Lives for the entire program duration (data segment)
**     → Use sparingly — globals make code hard to reason about
**
**   PROTOTYPE SCOPE
**     → Parameter names in a function prototype — visible only there
**
** STORAGE CLASSES THAT AFFECT LIFETIME:
**
**   auto    → default for locals; lifetime = block duration
**   static  → declared in a function but persists between calls
**             (same as global lifetime, but local scope)
**   extern  → tells the compiler a variable is defined in another file
**
** SHADOWING:
**   A local variable can have the same name as a global.
**   Inside that scope, the local SHADOWS (hides) the global.
**   The global still exists — it is just unreachable by that name there.
**   This is legal but confusing — avoid it.
**
** NOTE:
**   Global variables are zero-initialized by default.
**   Local variables are NOT — their initial value is garbage.
**   Always initialize your locals explicitly.
*/

#include <stdio.h>

/* ============================================================ */
/*  GLOBAL VARIABLE — visible to all functions below            */
/* ============================================================ */

int	g_program_count = 0;  /* zero-initialized automatically */

/* ============================================================ */
/*  BLOCK SCOPE — variable lives only inside its {}             */
/* ============================================================ */

void	demo_block_scope(void)
{
	int	x = 10;  /* x is local to demo_block_scope */

	printf("=== Block Scope ===\n");
	printf("x in function body = %d\n", x);

	{
		int	y = 20;  /* y is local to THIS inner block only */
		printf("x inside inner block = %d\n", x);  /* x still visible here */
		printf("y inside inner block = %d\n", y);
	}
	/* y is destroyed here — using it past this point would not compile */

	/* for loop variable — scoped to the loop block */
	for (int i = 0; i < 3; i++)
		printf("  loop i = %d\n", i);
	/* i is destroyed here too */

	printf("\n");
}

/* ============================================================ */
/*  GLOBAL SCOPE — g_program_count visible everywhere           */
/* ============================================================ */

void	demo_global_scope(void)
{
	g_program_count++;  /* modifying the global directly */
	printf("=== Global Scope ===\n");
	printf("g_program_count = %d  (incremented from anywhere)\n\n",
		g_program_count);
}

/* ============================================================ */
/*  STATIC LOCAL — local scope, global lifetime                 */
/*  The variable is initialized ONCE and retains its value      */
/*  between calls — unlike a regular local that resets each time */
/* ============================================================ */

void	demo_static_local(void)
{
	static int	call_count = 0;  /* initialized ONCE at program start */
	int			regular    = 0;  /* reset to 0 on every call */

	call_count++;
	regular++;
	printf("call_count (static)  = %d\n", call_count);
	printf("regular    (local)   = %d\n", regular);
}

/* ============================================================ */
/*  SHADOWING — local name hides the global                     */
/* ============================================================ */

void	demo_shadowing(void)
{
	printf("=== Shadowing ===\n");
	printf("g_program_count BEFORE shadow = %d\n", g_program_count);

	{
		int	g_program_count = 999;  /* local shadows the global */
		printf("g_program_count INSIDE shadow = %d  (local)\n", g_program_count);
		/* the real global still exists — we just can't reach it by this name here */
	}

	printf("g_program_count AFTER  shadow = %d  (global restored)\n\n",
		g_program_count);
}

/* ============================================================ */
/*  LIFETIME COMPARISON — stack vs static                       */
/* ============================================================ */

/*
** @desc   Returns a pointer to a static int.
**         Static locals survive after the function returns —
**         the pointer is still valid in the caller.
**
**         NEVER return a pointer to a regular local:
**         int *bad(void) { int x = 5; return &x; }
**         x is on the stack and destroyed on return.
*/
int	*get_static_counter(void)
{
	static int	counter = 0;  /* lives in the data segment — not the stack */

	counter++;
	return (&counter);  /* safe: static variables outlive the function */
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* --- BLOCK SCOPE --- */
	demo_block_scope();

	/* --- GLOBAL SCOPE --- */
	demo_global_scope();
	demo_global_scope();  /* call twice to show it accumulates */
	printf("\n");

	/* --- STATIC LOCAL --- */
	printf("=== Static Local vs Regular Local ===\n");
	demo_static_local();  /* call_count = 1, regular = 1 */
	demo_static_local();  /* call_count = 2, regular = 1 (reset!) */
	demo_static_local();  /* call_count = 3, regular = 1 (reset!) */
	printf("\n");

	/* --- SHADOWING --- */
	demo_shadowing();

	/* --- STATIC POINTER RETURN --- */
	printf("=== Static Pointer (safe to return) ===\n");
	int	*p1 = get_static_counter();
	int	*p2 = get_static_counter();
	int	*p3 = get_static_counter();
	printf("After 3 calls, *p3 = %d  (all point to the same static int)\n",
		*p3);
	printf("p1 == p2 == p3? %s\n",
		(p1 == p2 && p2 == p3) ? "yes — same address" : "no");

	return (0);
}
