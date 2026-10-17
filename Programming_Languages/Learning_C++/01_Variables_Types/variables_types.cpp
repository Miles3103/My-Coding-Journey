// ============================================================================
//  Project : Variables & Types in C++
//  Author  : Miles3103
//  Topic   : Variables — auto, const, constexpr, references, type aliases
// ============================================================================

/*
** C++ ADDS THESE ON TOP OF C TYPES:
**
**   auto         → compiler deduces the type for you (C++11)
**   const        → value cannot change (compile-time enforcement)
**   constexpr    → value known at COMPILE time (faster than const)
**   decltype     → get the type of an expression
**   using        → type aliases (replaces typedef)
**   nullptr      → type-safe null pointer (replaces NULL/0)
**   References   → int& ref = x; — alias, never null, can't reassign
**
** KEY DIFFERENCE FROM C:
**   In C:   int *p = NULL;        // NULL is just 0 — not type-safe
**   In C++: int *p = nullptr;     // nullptr is typed — safer
**
**   In C:   typedef int MyInt;
**   In C++: using MyInt = int;    // cleaner syntax, works with templates
*/

#include <iostream>
#include <string>
#include <typeinfo>   // typeid

// ============================================================================
//  TYPE ALIASES — using (replaces typedef)
// ============================================================================

using Score    = double;          // simple alias
using Name     = std::string;     // alias for string
using IntPtr   = int *;           // pointer alias (careful with this)

// ============================================================================
//  CONSTEXPR — compile-time constants (faster than const)
// ============================================================================

constexpr int       MAX_SCORE   = 100;
constexpr double    PI          = 3.14159265358979;
constexpr int       ARRAY_SIZE  = 10;

// constexpr function — evaluated at compile time if inputs are constants
constexpr int   square(int x) { return x * x; }
constexpr int   cube(int x)   { return x * x * x; }

// ============================================================================
//  AUTO — let the compiler deduce the type
// ============================================================================

void    demo_auto()
{
    std::cout << "=== auto type deduction ===\n";

    auto    i   = 42;           // int
    auto    d   = 3.14;         // double
    auto    f   = 3.14f;        // float
    auto    s   = std::string("hello");  // std::string
    auto    b   = true;         // bool
    auto    c   = 'A';          // char

    // typeid().name() shows the deduced type (implementation defined)
    std::cout << "42      → " << typeid(i).name() << '\n';
    std::cout << "3.14    → " << typeid(d).name() << '\n';
    std::cout << "3.14f   → " << typeid(f).name() << '\n';
    std::cout << "\"hello\" → " << typeid(s).name() << '\n';

    // auto is especially useful with long type names
    // Instead of: std::vector<std::string>::iterator it = vec.begin();
    // You write:  auto it = vec.begin();

    std::cout << "i=" << i << " d=" << d << " b=" << b << " c=" << c << '\n';
}

// ============================================================================
//  CONST vs CONSTEXPR
// ============================================================================

void    demo_const()
{
    std::cout << "\n=== const vs constexpr ===\n";

    // const — value can't change, but may be set at runtime
    const int   runtime_limit = 50 + 50;    // computed at runtime
    std::cout << "const runtime_limit = " << runtime_limit << '\n';

    // constexpr — value MUST be known at compile time (computed by compiler)
    constexpr int   compile_limit = 50 + 50;  // compiler computes this
    std::cout << "constexpr MAX_SCORE = " << MAX_SCORE << '\n';
    std::cout << "constexpr square(7) = " << square(7) << '\n';
    std::cout << "constexpr cube(3)   = " << cube(3)   << '\n';

    // const pointer variants — 4 combinations:
    int     x = 10;
    int     y = 20;

    int *           p1 = &x;           // pointer and value both mutable
    const int *     p2 = &x;           // can't change *p2, CAN change p2
    int * const     p3 = &x;           // can change *p3, CAN'T change p3
    const int *const p4 = &x;          // nothing can change

    *p1 = 11;   // OK
    // *p2 = 11; // ERROR — *p2 is const
    p2 = &y;    // OK — p2 itself can change
    *p3 = 12;   // OK — *p3 can change
    // p3 = &y; // ERROR — p3 itself is const

    std::cout << "*p1=" << *p1 << " *p2=" << *p2
              << " *p3=" << *p3 << " *p4=" << *p4 << '\n';
}

// ============================================================================
//  REFERENCES vs POINTERS — when to use which
// ============================================================================

// Use REFERENCE when:
//   - You always have a valid object (never null)
//   - You don't need to reassign where it points
//   - Cleaner syntax is preferred (most function params)

// Use POINTER when:
//   - The value might be null (optional parameter)
//   - You need to change where it points
//   - Working with arrays / dynamic memory

void    by_value(int n)     { n *= 2; }               // copy — caller unchanged
void    by_pointer(int *n)  { if (n) *n *= 2; }       // pointer — caller changed
void    by_reference(int &n){ n *= 2; }                // reference — caller changed

void    demo_references()
{
    std::cout << "\n=== Reference vs Pointer vs Value ===\n";

    int x = 5;

    by_value(x);
    std::cout << "after by_value:     x = " << x << " (unchanged)\n";

    by_pointer(&x);
    std::cout << "after by_pointer:   x = " << x << " (changed)\n";

    by_reference(x);
    std::cout << "after by_reference: x = " << x << " (changed)\n";

    // Const reference — read access without copying (efficient for big types)
    const std::string   big = "A very long string that we don't want to copy";
    // void use(std::string s) — BAD: copies the whole string
    // void use(const std::string& s) — GOOD: no copy, can't modify
    const std::string&  ref = big;
    std::cout << "const ref length = " << ref.length() << '\n';
}

// ============================================================================
//  nullptr — type-safe null pointer
// ============================================================================

void    process(int *p)
{
    if (p == nullptr)   // safer than: if (p == NULL) or if (!p)
    {
        std::cout << "pointer is null — nothing to do\n";
        return ;
    }
    std::cout << "value = " << *p << '\n';
}

void    demo_nullptr()
{
    std::cout << "\n=== nullptr ===\n";

    int     x   = 42;
    int *   p1  = &x;
    int *   p2  = nullptr;   // type-safe null (not 0, not NULL)

    process(p1);
    process(p2);

    // nullptr can't be accidentally used as an integer (unlike NULL)
    // This would be a compile error: int n = nullptr; // ERROR
}

// ============================================================================
//  TYPE ALIASES IN ACTION
// ============================================================================

void    demo_aliases()
{
    std::cout << "\n=== Type Aliases ===\n";

    Score   exam = 95.5;
    Name    student = "Miles3103";

    std::cout << student << " scored " << exam << "/" << MAX_SCORE << '\n';
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    demo_auto();
    demo_const();
    demo_references();
    demo_nullptr();
    demo_aliases();

    return (0);
}
