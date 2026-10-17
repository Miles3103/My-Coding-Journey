// ============================================================================
//  Project : OOP — Classes & Objects
//  Author  : Miles3103
//  Topic   : Classes — constructor, destructor, methods, encapsulation
// ============================================================================

/*
** OBJECT-ORIENTED PROGRAMMING — THE BIG IDEA
**
** In C, you have DATA (structs) and FUNCTIONS separately.
** In C++, a CLASS combines both into one unit:
**
**   class BankAccount {
**       double  _balance;         // DATA (attributes)
**   public:
**       void    deposit(double);  // BEHAVIOR (methods)
**   };
**
** THE 4 PILLARS OF OOP:
**   1. ENCAPSULATION  → hide internal data, expose only what's needed
**   2. INHERITANCE    → a class can extend another (next file)
**   3. POLYMORPHISM   → same interface, different behavior (next file)
**   4. ABSTRACTION    → hide complexity behind a clean interface
**
** ACCESS MODIFIERS:
**   private:   only accessible within this class (default in class)
**   public:    accessible from anywhere
**   protected: accessible in this class and derived classes
**
** SPECIAL MEMBER FUNCTIONS (the "Rule of Three" / "Rule of Five"):
**   Constructor        → called when object is created
**   Destructor         → called when object is destroyed (free resources!)
**   Copy Constructor   → called when object is copied
**   Copy Assignment    → called with operator=
**   (Move versions in C++11)
*/

#include <iostream>
#include <string>

// ============================================================================
//  CLASS: Vector2D — a 2D math vector
//  Demonstrates: constructors, methods, operator overloading
// ============================================================================

class Vector2D
{
private:
    double  _x;     // underscore prefix = private member convention
    double  _y;

public:
    // --- CONSTRUCTORS ---

    // Default constructor
    Vector2D() : _x(0.0), _y(0.0)
    {
        std::cout << "[Vector2D] default ctor: (0, 0)\n";
    }

    // Parameterized constructor — use initializer list (faster than assignment)
    Vector2D(double x, double y) : _x(x), _y(y)
    {
        std::cout << "[Vector2D] ctor: (" << _x << ", " << _y << ")\n";
    }

    // Copy constructor
    Vector2D(const Vector2D& other) : _x(other._x), _y(other._y)
    {
        std::cout << "[Vector2D] copy ctor\n";
    }

    // --- DESTRUCTOR ---
    ~Vector2D()
    {
        std::cout << "[Vector2D] dtor: (" << _x << ", " << _y << ")\n";
    }

    // --- GETTERS (const methods — don't modify the object) ---
    double  getX() const { return _x; }
    double  getY() const { return _y; }

    // --- METHODS ---
    double  length() const
    {
        // sqrt from <cmath>
        return __builtin_sqrt(_x * _x + _y * _y);
    }

    void    normalize()
    {
        double  len = length();
        if (len != 0.0)
        {
            _x /= len;
            _y /= len;
        }
    }

    Vector2D    add(const Vector2D& other) const
    {
        return Vector2D(_x + other._x, _y + other._y);
    }

    // --- OPERATOR OVERLOADING ---
    // Lets you write v1 + v2 instead of v1.add(v2)

    Vector2D    operator+(const Vector2D& rhs) const
    {
        return Vector2D(_x + rhs._x, _y + rhs._y);
    }

    Vector2D    operator-(const Vector2D& rhs) const
    {
        return Vector2D(_x - rhs._x, _y - rhs._y);
    }

    Vector2D    operator*(double scalar) const
    {
        return Vector2D(_x * scalar, _y * scalar);
    }

    bool        operator==(const Vector2D& rhs) const
    {
        return (_x == rhs._x && _y == rhs._y);
    }

    // Copy assignment operator
    Vector2D&   operator=(const Vector2D& rhs)
    {
        if (this != &rhs)   // self-assignment check
        {
            _x = rhs._x;
            _y = rhs._y;
        }
        return (*this);
    }

    // << operator for printing (non-member friend)
    friend std::ostream&    operator<<(std::ostream& os, const Vector2D& v)
    {
        os << "(" << v._x << ", " << v._y << ")";
        return os;
    }
};

// ============================================================================
//  CLASS: BankAccount — real-world encapsulation example
// ============================================================================

class BankAccount
{
private:
    std::string _owner;
    double      _balance;
    int         _id;

    static int  s_nextId;   // static = shared across ALL instances

public:
    BankAccount(const std::string& owner, double initial_balance = 0.0)
        : _owner(owner), _balance(initial_balance), _id(s_nextId++)
    {
        if (initial_balance < 0)
        {
            std::cout << "Warning: cannot start with negative balance\n";
            _balance = 0.0;
        }
        std::cout << "[BankAccount #" << _id << "] created for " << _owner << '\n';
    }

    ~BankAccount()
    {
        std::cout << "[BankAccount #" << _id << "] closed\n";
    }

    // ENCAPSULATION: balance can only be changed through controlled methods
    bool    deposit(double amount)
    {
        if (amount <= 0)
        {
            std::cout << "Error: deposit must be positive\n";
            return false;
        }
        _balance += amount;
        std::cout << "Deposited $" << amount
                  << " | New balance: $" << _balance << '\n';
        return true;
    }

    bool    withdraw(double amount)
    {
        if (amount <= 0)
        {
            std::cout << "Error: withdrawal must be positive\n";
            return false;
        }
        if (amount > _balance)
        {
            std::cout << "Error: insufficient funds\n";
            return false;
        }
        _balance -= amount;
        std::cout << "Withdrew $" << amount
                  << " | New balance: $" << _balance << '\n';
        return true;
    }

    void    print() const
    {
        std::cout << "Account #" << _id
                  << " | Owner: " << _owner
                  << " | Balance: $" << _balance << '\n';
    }

    // Getters — read-only access to private data
    double          getBalance() const { return _balance; }
    std::string     getOwner()   const { return _owner;   }
    int             getId()      const { return _id;      }

    // Static method — belongs to the class, not any instance
    static int      getTotalAccounts() { return s_nextId; }
};

// Definition of static member (must be outside the class)
int BankAccount::s_nextId = 1000;

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    // --- Vector2D ---
    std::cout << "=== Vector2D ===\n";
    {
        // Objects are created on the stack — destructor called automatically
        Vector2D    v1(3.0, 4.0);
        Vector2D    v2(1.0, 2.0);

        std::cout << "v1 = " << v1 << '\n';
        std::cout << "v2 = " << v2 << '\n';
        std::cout << "v1.length() = " << v1.length() << '\n';

        Vector2D    v3 = v1 + v2;
        std::cout << "v1 + v2 = " << v3 << '\n';

        Vector2D    v4 = v1 * 2.0;
        std::cout << "v1 * 2 = " << v4 << '\n';

        std::cout << "v1 == v2: " << (v1 == v2 ? "yes" : "no") << '\n';

    }   // <-- destructors called here automatically

    // --- BankAccount ---
    std::cout << "\n=== BankAccount ===\n";
    {
        BankAccount alice("Alice", 1000.0);
        BankAccount bob("Bob");

        alice.print();
        bob.print();

        alice.deposit(500.0);
        alice.withdraw(200.0);
        alice.withdraw(2000.0);   // should fail

        bob.deposit(100.0);
        bob.deposit(-50.0);       // should fail

        std::cout << "\nTotal accounts created: "
                  << BankAccount::getTotalAccounts() << '\n';

    }   // <-- both accounts destroyed here

    return (0);
}
