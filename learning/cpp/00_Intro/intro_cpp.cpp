// ============================================================================
//  Project : C++ Introduction
//  Author  : Miles3103
//  Topic   : Intro — why C++, differences from C, first programs
// ============================================================================

/*
** WHY C++ AFTER C?
**
** C is a foundation. C++ builds on top of it and adds:
**
**   1. CLASSES & OBJECTS     → group data + functions together (OOP)
**   2. REFERENCES            → cleaner alternative to pointers in many cases
**   3. FUNCTION OVERLOADING  → same name, different parameters
**   4. TEMPLATES             → write code that works for ANY type
**   5. STL                   → vector, map, string — powerful built-ins
**   6. EXCEPTIONS            → structured error handling (try/catch)
**   7. RAII                  → automatic resource management
**
** EVERYTHING from C still works in C++.
** The key shift: in C you write PROCEDURES that act on data.
**                in C++ you write OBJECTS that contain data AND behavior.
**
** COMPILE:
**   g++ -Wall -Wextra -Werror -std=c++17 filename.cpp -o output
**
** C++ standard versions:
**   C++98 → original  |  C++11 → big update  |  C++17 → modern  |  C++23 → latest
**   We use C++17. Always compile with -std=c++17.
*/

#include <iostream>   // std::cout, std::cin, std::endl
#include <string>     // std::string

// ============================================================================
//  1. OUTPUT — cout vs printf
// ============================================================================

void    demo_output()
{
    // cout uses the << "insertion" operator
    // endl flushes the buffer AND adds newline
    // '\n' is faster (no flush) — prefer '\n' in loops
    std::cout << "Hello from C++!" << '\n';
    std::cout << "cout chains: " << 42 << " | " << 3.14 << '\n';

    // std::endl vs '\n'
    std::cout << "Using endl" << std::endl;  // flushes buffer — slower
    std::cout << "Using \\n" << '\n';         // just newline — faster
}

// ============================================================================
//  2. REFERENCES — the cleaner pointer
// ============================================================================

void    demo_references()
{
    int     x = 10;
    int&    ref = x;    // ref IS x — not a copy, not an address, an alias

    std::cout << "\n=== References ===\n";
    std::cout << "x   = " << x   << '\n';
    std::cout << "ref = " << ref << '\n';

    ref = 99;           // modifies x directly
    std::cout << "After ref = 99: x = " << x << '\n';

    // Unlike pointers: references CANNOT be null, CANNOT be reassigned
    // They MUST be initialized when declared
    std::cout << "Same address: " << (&x == &ref ? "yes" : "no") << '\n';
}

// ============================================================================
//  3. FUNCTION OVERLOADING — same name, different types
// ============================================================================

// C would require different names: print_int, print_double, print_str
// C++ lets you use the SAME name — the compiler picks the right one
void    print(int n)         { std::cout << "int:    " << n    << '\n'; }
void    print(double d)      { std::cout << "double: " << d    << '\n'; }
void    print(std::string s) { std::cout << "string: " << s    << '\n'; }
void    print(int a, int b)  { std::cout << "two ints: " << a << ", " << b << '\n'; }

void    demo_overloading()
{
    std::cout << "\n=== Function Overloading ===\n";
    print(42);
    print(3.14);
    print(std::string("Hello"));
    print(10, 20);
}

// ============================================================================
//  4. DEFAULT PARAMETERS
// ============================================================================

// Parameters with defaults must come LAST
void    greet(std::string name, std::string greeting = "Hello")
{
    std::cout << greeting << ", " << name << "!\n";
}

void    demo_defaults()
{
    std::cout << "\n=== Default Parameters ===\n";
    greet("Miles3103");              // uses default "Hello"
    greet("Miles3103", "Welcome");   // overrides default
}

// ============================================================================
//  5. std::string — the C++ string (vs char array in C)
// ============================================================================

void    demo_string()
{
    std::cout << "\n=== std::string ===\n";

    std::string s1 = "Hello";
    std::string s2 = " World";
    std::string s3 = s1 + s2;  // concatenation with + (no strcat needed!)

    std::cout << "s3 = " << s3 << '\n';
    std::cout << "length = " << s3.length() << '\n';
    std::cout << "s3[0] = " << s3[0] << '\n';

    // String comparison with == (no strcmp needed!)
    std::cout << "(s1 == \"Hello\") = " << (s1 == "Hello") << '\n';

    // Find substring
    size_t pos = s3.find("World");
    if (pos != std::string::npos)
        std::cout << "\"World\" found at index " << pos << '\n';

    // Substring
    std::cout << "s3.substr(0,5) = " << s3.substr(0, 5) << '\n';
}

// ============================================================================
//  6. NAMESPACE — avoiding name collisions
// ============================================================================

// std:: prefix comes from the std namespace
// You'll often see: using namespace std; — but avoid it in headers!
// Better practice: use std:: explicitly, or just for specific names:
// using std::cout; using std::string;

namespace Miles
{
    int     value = 42;
    void    hello() { std::cout << "Hello from Miles namespace!\n"; }
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    demo_output();
    demo_references();
    demo_overloading();
    demo_defaults();
    demo_string();

    std::cout << "\n=== Namespace ===\n";
    Miles::hello();
    std::cout << "Miles::value = " << Miles::value << '\n';

    return (0);
}
