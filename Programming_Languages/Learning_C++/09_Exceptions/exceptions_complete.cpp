// ============================================================================
//  Project : Exceptions — Error Handling in C++
//  Author  : Miles3103
//  Topic   : Exceptions — try/catch/throw, custom exceptions, RAII safety
// ============================================================================

/*
** EXCEPTIONS — STRUCTURED ERROR HANDLING
**
** In C, errors are handled by returning error codes: if (ret == -1) { ... }
** In C++, exceptions let you SEPARATE normal code from error handling.
**
** HOW IT WORKS:
**   throw  → signals an error, unwinds the call stack
**   try    → wraps code that might throw
**   catch  → handles specific exception types
**
** STACK UNWINDING:
**   When an exception is thrown, C++ automatically:
**   1. Destroys all local objects (calls their destructors)
**   2. Walks back through the call stack until a catch is found
**   This is why RAII is so powerful — destructors always run!
**
** EXCEPTION HIERARCHY (from <stdexcept>):
**   std::exception         (base)
**   ├── std::runtime_error  (runtime errors: overflow, range, etc.)
**   │   ├── std::overflow_error
**   │   ├── std::underflow_error
**   │   └── std::out_of_range
**   └── std::logic_error    (programming errors: invalid arg, etc.)
**       ├── std::invalid_argument
**       └── std::domain_error
**
** BEST PRACTICES:
**   - Catch by const reference: catch (const std::exception& e)
**   - Throw by value, catch by reference
**   - Never throw in a destructor (use noexcept on destructors)
**   - Use specific exceptions, not catch-all (catch (...)) for real code
*/

#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

// ============================================================================
//  CUSTOM EXCEPTION CLASSES
// ============================================================================

// Base custom exception
class MilesException : public std::exception
{
private:
    std::string _message;
    int         _code;

public:
    MilesException(const std::string& msg, int code = 0)
        : _message(msg), _code(code) {}

    // Override what() — the standard error message interface
    const char* what() const noexcept override
    {
        return _message.c_str();
    }

    int code() const { return _code; }
};

// Specific exception types
class ValidationError : public MilesException
{
public:
    explicit ValidationError(const std::string& field)
        : MilesException("Validation failed for: " + field, 400) {}
};

class DatabaseError : public MilesException
{
public:
    explicit DatabaseError(const std::string& detail)
        : MilesException("Database error: " + detail, 500) {}
};

// ============================================================================
//  FUNCTIONS THAT THROW
// ============================================================================

double  safe_divide(double a, double b)
{
    if (b == 0.0)
        throw std::invalid_argument("Division by zero");
    return a / b;
}

int     safe_sqrt(int n)
{
    if (n < 0)
        throw std::domain_error("Cannot take sqrt of negative number");
    // Simple integer sqrt
    int i = 0;
    while (i * i <= n) i++;
    return i - 1;
}

std::string get_element(const std::vector<std::string>& v, size_t index)
{
    if (index >= v.size())
        throw std::out_of_range(
            "Index " + std::to_string(index) +
            " out of range (size=" + std::to_string(v.size()) + ")");
    return v[index];
}

// ============================================================================
//  BASIC TRY/CATCH
// ============================================================================

void    demo_basic()
{
    std::cout << "=== Basic try/catch ===\n";

    // Safe division
    try
    {
        double r = safe_divide(10.0, 2.0);
        std::cout << "10 / 2 = " << r << '\n';

        r = safe_divide(5.0, 0.0);  // throws!
        std::cout << "This won't print\n";
    }
    catch (const std::invalid_argument& e)
    {
        std::cout << "Caught invalid_argument: " << e.what() << '\n';
    }

    // Multiple catch blocks
    try
    {
        std::vector<std::string>    data = {"hello", "world"};
        std::cout << get_element(data, 0) << '\n';
        std::cout << get_element(data, 5) << '\n';  // throws!
    }
    catch (const std::out_of_range& e)
    {
        std::cout << "Caught out_of_range: " << e.what() << '\n';
    }
    catch (const std::exception& e)
    {
        // Catches any remaining std::exception subclass
        std::cout << "Caught exception: " << e.what() << '\n';
    }
}

// ============================================================================
//  CUSTOM EXCEPTIONS
// ============================================================================

void    validate_age(int age)
{
    if (age < 0 || age > 150)
        throw ValidationError("age");
    std::cout << "Age " << age << " is valid\n";
}

void    demo_custom()
{
    std::cout << "\n=== Custom Exceptions ===\n";

    try
    {
        validate_age(25);
        validate_age(-5);   // throws ValidationError
    }
    catch (const MilesException& e)
    {
        std::cout << "Caught MilesException [code=" << e.code() << "]: "
                  << e.what() << '\n';
    }

    // Catching by base class catches all derived exceptions
    try
    {
        throw DatabaseError("connection timeout");
    }
    catch (const std::exception& e)
    {
        std::cout << "Caught via base class: " << e.what() << '\n';
    }
}

// ============================================================================
//  EXCEPTION SAFETY + RAII
// ============================================================================

class Resource
{
private:
    std::string _name;

public:
    explicit Resource(const std::string& name) : _name(name)
    {
        std::cout << "[Resource] acquired: " << _name << '\n';
    }

    ~Resource()
    {
        // This ALWAYS runs, even when exception is thrown!
        std::cout << "[Resource] released: " << _name << '\n';
    }
};

void    risky_function()
{
    Resource    r1("database_conn");
    Resource    r2("file_handle");

    std::cout << "Doing some work...\n";
    throw std::runtime_error("Something went wrong mid-function!");

    // r1 and r2 destructors called automatically during stack unwinding
    // even though we never reached the end of the function
}

void    demo_raii_safety()
{
    std::cout << "\n=== RAII + Exception Safety ===\n";
    std::cout << "Calling risky_function()...\n";

    try
    {
        risky_function();
    }
    catch (const std::runtime_error& e)
    {
        std::cout << "Caught: " << e.what() << '\n';
        std::cout << "Notice: both Resources were released despite the exception!\n";
    }
}

// ============================================================================
//  RETHROWING
// ============================================================================

void    inner()
{
    throw std::runtime_error("original error");
}

void    middle()
{
    try
    {
        inner();
    }
    catch (const std::exception& e)
    {
        std::cout << "middle() caught and rethrowing: " << e.what() << '\n';
        throw;  // rethrow the SAME exception (not a copy)
    }
}

void    demo_rethrow()
{
    std::cout << "\n=== Rethrowing ===\n";
    try
    {
        middle();
    }
    catch (const std::exception& e)
    {
        std::cout << "outer caught: " << e.what() << '\n';
    }
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    demo_basic();
    demo_custom();
    demo_raii_safety();
    demo_rethrow();

    return (0);
}
