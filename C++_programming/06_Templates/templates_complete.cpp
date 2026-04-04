// ============================================================================
//  Project : Templates — Generic Programming
//  Author  : Miles3103
//  Topic   : Templates — function templates, class templates, specialization
// ============================================================================

/*
** TEMPLATES — WRITE ONCE, WORK FOR ANY TYPE
**
** The problem templates solve:
**   You write ft_max for int. Then you need ft_max for double.
**   Then for std::string. You end up copy-pasting the same logic.
**
** Templates let the COMPILER generate the right version for each type:
**
**   template <typename T>
**   T   max(T a, T b) { return a > b ? a : b; }
**
**   max(3, 7)       → compiler generates max<int>
**   max(3.14, 2.71) → compiler generates max<double>
**   max("b", "a")  → compiler generates max<std::string>
**
** TEMPLATE INSTANTIATION happens at COMPILE TIME — zero runtime cost.
** This is "compile-time polymorphism" vs virtual function "runtime polymorphism".
**
** TWO TYPES:
**   function templates  → templated functions
**   class templates     → templated classes (like std::vector<T>)
*/

#include <iostream>
#include <string>
#include <stdexcept>

// ============================================================================
//  FUNCTION TEMPLATES
// ============================================================================

// T is a placeholder for ANY type (as long as it supports > and <)
template <typename T>
T   ft_max(T a, T b)
{
    return (a > b ? a : b);
}

template <typename T>
T   ft_min(T a, T b)
{
    return (a < b ? a : b);
}

template <typename T>
void    ft_swap(T& a, T& b)
{
    T   tmp = a;
    a = b;
    b = tmp;
}

// Template with MULTIPLE type parameters
template <typename T, typename U>
void    print_pair(const T& first, const U& second)
{
    std::cout << "(" << first << ", " << second << ")\n";
}

// Template with NON-TYPE parameter (e.g., array size)
template <typename T, int N>
int     array_size(T (&)[N])    // array reference
{
    return N;
}

// ============================================================================
//  TEMPLATE SPECIALIZATION — custom behavior for specific types
// ============================================================================

// General template
template <typename T>
void    describe(const T& val)
{
    std::cout << "Value: " << val << '\n';
}

// Specialization for bool — different output
template <>
void    describe<bool>(const bool& val)
{
    std::cout << "Bool: " << (val ? "true" : "false") << '\n';
}

// Specialization for std::string
template <>
void    describe<std::string>(const std::string& val)
{
    std::cout << "String: \"" << val << "\" (length=" << val.length() << ")\n";
}

// ============================================================================
//  CLASS TEMPLATE: Stack<T>
//  A generic stack that works for any type
// ============================================================================

template <typename T, int MaxSize = 100>
class Stack
{
private:
    T       _data[MaxSize];
    int     _top;

public:
    Stack() : _top(-1) {}

    bool    isEmpty() const { return _top == -1; }
    bool    isFull()  const { return _top == MaxSize - 1; }
    int     size()    const { return _top + 1; }

    void    push(const T& val)
    {
        if (isFull())
            throw std::overflow_error("Stack is full");
        _data[++_top] = val;
    }

    T   pop()
    {
        if (isEmpty())
            throw std::underflow_error("Stack is empty");
        return _data[_top--];
    }

    const T&    peek() const
    {
        if (isEmpty())
            throw std::underflow_error("Stack is empty");
        return _data[_top];
    }

    void    print() const
    {
        std::cout << "Stack[" << size() << "]: ";
        for (int i = _top; i >= 0; i--)
            std::cout << _data[i] << " ";
        std::cout << '\n';
    }
};

// ============================================================================
//  CLASS TEMPLATE: Pair<T, U>
//  Like std::pair but written from scratch
// ============================================================================

template <typename T, typename U>
class Pair
{
private:
    T   _first;
    U   _second;

public:
    Pair(const T& f, const U& s) : _first(f), _second(s) {}

    T           first()  const { return _first;  }
    U           second() const { return _second; }

    void        swap()
    {
        T   tmp = _first;
        // This only works if both types are the same — illustrative
        std::cout << "Pair: (" << _first << ", " << _second << ")\n";
    }

    void    print() const
    {
        std::cout << "(" << _first << ", " << _second << ")\n";
    }
};

// Helper function to create Pair without specifying types (like std::make_pair)
template <typename T, typename U>
Pair<T, U>  make_pair(const T& f, const U& s)
{
    return Pair<T, U>(f, s);
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    // --- Function templates ---
    std::cout << "=== Function Templates ===\n";
    std::cout << "ft_max(3, 7)         = " << ft_max(3, 7)         << '\n';
    std::cout << "ft_max(3.14, 2.71)   = " << ft_max(3.14, 2.71)   << '\n';
    std::cout << "ft_max('a', 'z')     = " << ft_max('a', 'z')     << '\n';
    std::cout << "ft_min(10, 20)       = " << ft_min(10, 20)       << '\n';

    int     a = 5, b = 9;
    std::cout << "Before swap: a=" << a << " b=" << b << '\n';
    ft_swap(a, b);
    std::cout << "After swap:  a=" << a << " b=" << b << '\n';

    std::cout << "\n=== Multi-type template ===\n";
    print_pair(42, "hello");
    print_pair(3.14, true);

    std::cout << "\n=== Template specialization ===\n";
    describe(42);
    describe(true);
    describe(std::string("Miles3103"));

    // --- Stack<T> ---
    std::cout << "\n=== Stack<int> ===\n";
    Stack<int>      int_stack;
    int_stack.push(10);
    int_stack.push(20);
    int_stack.push(30);
    int_stack.print();
    std::cout << "peek: " << int_stack.peek() << '\n';
    std::cout << "pop:  " << int_stack.pop()  << '\n';
    int_stack.print();

    std::cout << "\n=== Stack<std::string> ===\n";
    Stack<std::string>  str_stack;
    str_stack.push("first");
    str_stack.push("second");
    str_stack.push("third");
    str_stack.print();
    str_stack.pop();
    str_stack.print();

    // --- Pair<T,U> ---
    std::cout << "\n=== Pair<T,U> ===\n";
    Pair<int, std::string>  p1(42, std::string("hello"));
    Pair<double, bool>      p2(3.14, true);
    p1.print();
    p2.print();

    return (0);
}
