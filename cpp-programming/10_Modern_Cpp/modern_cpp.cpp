// ============================================================================
//  Project : Modern C++ (C++11/14/17)
//  Author  : Miles3103
//  Topic   : Modern features — lambdas, auto, range-for, move, constexpr
// ============================================================================

/*
** MODERN C++ — WHAT CHANGED IN C++11/14/17
**
** C++11 was the biggest update in the language's history. It added:
**
**   auto            → type deduction
**   range-based for → for (auto& x : container)
**   lambdas         → anonymous functions [capture](params){ body }
**   nullptr         → type-safe null
**   smart pointers  → unique_ptr, shared_ptr
**   move semantics  → std::move, rvalue references T&&
**   constexpr       → compile-time computation
**   initializer_list → {1, 2, 3} syntax
**   variadic templates → template<typename... Args>
**   std::thread     → built-in threading
**
** C++14 added:
**   generic lambdas → [](auto x) { ... }
**   make_unique
**
** C++17 added:
**   structured bindings → auto [a, b] = pair;
**   if constexpr         → compile-time if
**   std::optional        → value or nothing
**   std::variant         → type-safe union
**   std::string_view     → non-owning string reference
**
** COMPILE WITH: g++ -std=c++17 -Wall -Wextra -Werror
*/

#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <functional>  // std::function
#include <optional>    // std::optional (C++17)
#include <variant>     // std::variant (C++17)
#include <string_view> // std::string_view (C++17)
#include <map>
#include <numeric>

// ============================================================================
//  LAMBDAS — anonymous functions
// ============================================================================

void    demo_lambdas()
{
    std::cout << "=== Lambdas ===\n";

    // Basic lambda
    auto    greet = []() { std::cout << "Hello from lambda!\n"; };
    greet();

    // Lambda with parameters
    auto    add = [](int a, int b) -> int { return a + b; };
    std::cout << "add(3, 4) = " << add(3, 4) << '\n';

    // Lambda CAPTURING local variables
    int     multiplier = 3;
    auto    multiply = [multiplier](int x) { return x * multiplier; };  // capture by value
    std::cout << "multiply(5) = " << multiply(5) << '\n';

    // Capture by reference — lambda can modify the variable
    int     count = 0;
    auto    increment = [&count]() { count++; };
    increment(); increment(); increment();
    std::cout << "count after 3 increments: " << count << '\n';

    // [=] capture all by value, [&] capture all by reference
    int     x = 10, y = 20;
    auto    sum_all = [=]() { return x + y; };  // captures x and y by value
    std::cout << "sum_all() = " << sum_all() << '\n';

    // Lambdas with STL algorithms
    std::vector<int>    v = {5, 3, 8, 1, 9, 2, 7, 4, 6};

    // sort descending using lambda comparator
    std::sort(v.begin(), v.end(), [](int a, int b) { return a > b; });
    std::cout << "sorted desc: ";
    for (int n : v) std::cout << n << ' ';
    std::cout << '\n';

    // filter with copy_if
    std::vector<int>    evens;
    std::copy_if(v.begin(), v.end(), std::back_inserter(evens),
        [](int n) { return n % 2 == 0; });
    std::cout << "evens: ";
    for (int n : evens) std::cout << n << ' ';
    std::cout << '\n';

    // std::function — store any callable (lambda, function ptr, functor)
    std::function<int(int, int)>    operation = add;
    std::cout << "std::function call: " << operation(7, 8) << '\n';
}

// ============================================================================
//  STRUCTURED BINDINGS (C++17)
// ============================================================================

void    demo_structured_bindings()
{
    std::cout << "\n=== Structured Bindings (C++17) ===\n";

    // Decompose pair
    std::map<std::string, int>  scores = {{"Alice", 95}, {"Bob", 82}};
    for (const auto& [name, score] : scores)
        std::cout << name << ": " << score << '\n';

    // Decompose array
    int         arr[3] = {10, 20, 30};
    auto        [a, b, c] = arr;
    std::cout << "a=" << a << " b=" << b << " c=" << c << '\n';
}

// ============================================================================
//  std::optional — "maybe a value" (C++17)
// ============================================================================

// Returns int if found, nothing if not — cleaner than returning -1 or bool+output param
std::optional<int>  find_first_even(const std::vector<int>& v)
{
    for (int n : v)
        if (n % 2 == 0)
            return n;   // has value
    return std::nullopt; // no value
}

void    demo_optional()
{
    std::cout << "\n=== std::optional ===\n";

    std::vector<int>    v1 = {1, 3, 5, 4, 7};
    std::vector<int>    v2 = {1, 3, 5, 7, 9};

    auto    r1 = find_first_even(v1);
    auto    r2 = find_first_even(v2);

    if (r1.has_value())
        std::cout << "Found even: " << r1.value() << '\n';

    // value_or — provide default if empty
    std::cout << "v2 result: " << r2.value_or(-1) << '\n';
}

// ============================================================================
//  std::variant — type-safe union (C++17)
// ============================================================================

void    demo_variant()
{
    std::cout << "\n=== std::variant ===\n";

    // Can hold int, double, or string — but only one at a time
    std::variant<int, double, std::string>  v;

    v = 42;
    std::cout << "int: " << std::get<int>(v) << '\n';

    v = 3.14;
    std::cout << "double: " << std::get<double>(v) << '\n';

    v = std::string("hello");
    std::cout << "string: " << std::get<std::string>(v) << '\n';

    // std::visit — calls the right lambda based on what's stored
    std::visit([](const auto& val) {
        std::cout << "visit: " << val << '\n';
    }, v);
}

// ============================================================================
//  std::string_view — non-owning string reference (C++17)
// ============================================================================

// Takes string_view instead of const string& — no copy, works with C strings too
size_t  count_vowels(std::string_view sv)
{
    size_t  count = 0;
    for (char c : sv)
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
            count++;
    return count;
}

void    demo_string_view()
{
    std::cout << "\n=== std::string_view ===\n";

    std::string     s = "Hello Miles3103";
    const char*     cs = "C-style string";

    // Works with both std::string and C-string — no copy
    std::cout << "vowels in \"" << s  << "\": " << count_vowels(s)  << '\n';
    std::cout << "vowels in \"" << cs << "\": " << count_vowels(cs) << '\n';
}

// ============================================================================
//  IF CONSTEXPR — compile-time branching in templates
// ============================================================================

template <typename T>
void    print_type_info(const T& val)
{
    if constexpr (std::is_integral_v<T>)
        std::cout << "integral: " << val << " (size=" << sizeof(T) << ")\n";
    else if constexpr (std::is_floating_point_v<T>)
        std::cout << "float: " << val << " (precision=" << sizeof(T) << ")\n";
    else
        std::cout << "other: " << val << '\n';
}

void    demo_if_constexpr()
{
    std::cout << "\n=== if constexpr ===\n";
    print_type_info(42);
    print_type_info(3.14);
    print_type_info(std::string("hello"));
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    demo_lambdas();
    demo_structured_bindings();
    demo_optional();
    demo_variant();
    demo_string_view();
    demo_if_constexpr();

    return (0);
}
