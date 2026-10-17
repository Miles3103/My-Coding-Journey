// ============================================================================
//  Project : Polymorphism
//  Author  : Miles3103
//  Topic   : Polymorphism — virtual dispatch, vtable, interfaces, RTTI
// ============================================================================

/*
** POLYMORPHISM — "MANY FORMS"
**
** The ability to call the correct function at runtime based on the
** ACTUAL type of the object, even when accessed through a base pointer.
**
** HOW IT WORKS (vtable):
**   Every class with virtual functions has a hidden vtable (virtual table).
**   The vtable is an array of function pointers.
**   Each object has a hidden vptr that points to its class's vtable.
**   When you call ptr->virtualFunc(), the runtime looks up the vtable.
**
**   Base vtable:      [area → Shape::area, describe → Shape::describe]
**   Circle vtable:    [area → Circle::area, describe → Circle::describe]
**
** TYPES OF POLYMORPHISM IN C++:
**   1. Runtime (dynamic)  → virtual functions, base pointers/refs
**   2. Compile-time       → templates, function overloading
**
** dynamic_cast — safe downcast (base* → derived*)
**   Returns nullptr if the cast is invalid (use with pointers)
**   Throws std::bad_cast if the cast fails (use with references)
**
** typeid — get runtime type information
*/

#include <iostream>
#include <string>
#include <vector>
#include <memory>    // std::unique_ptr
#include <cmath>

// ============================================================================
//  INTERFACE via Abstract Base Class
//  Pure abstract = 0 data, all pure virtual = true interface
// ============================================================================

class IDrawable
{
public:
    virtual void    draw()  const = 0;
    virtual void    resize(double factor) = 0;
    virtual ~IDrawable() = default;
};

class ISerializable
{
public:
    virtual std::string serialize()   const = 0;
    virtual void        deserialize(const std::string& data) = 0;
    virtual ~ISerializable() = default;
};

// ============================================================================
//  A class implementing MULTIPLE interfaces (C++ version of Java interfaces)
// ============================================================================

class Canvas : public IDrawable, public ISerializable
{
private:
    std::string _content;
    double      _scale;

public:
    Canvas(const std::string& content, double scale = 1.0)
        : _content(content), _scale(scale) {}

    void    draw() const override
    {
        std::cout << "[Canvas] drawing: '" << _content
                  << "' at scale " << _scale << '\n';
    }

    void    resize(double factor) override
    {
        _scale *= factor;
        std::cout << "[Canvas] resized to scale " << _scale << '\n';
    }

    std::string serialize() const override
    {
        return "{content:" + _content + ",scale:" + std::to_string(_scale) + "}";
    }

    void    deserialize(const std::string& data) override
    {
        _content = data;
        std::cout << "[Canvas] deserialized: " << data << '\n';
    }
};

// ============================================================================
//  ANIMAL HIERARCHY — classic polymorphism demo
// ============================================================================

class Animal
{
protected:
    std::string _name;
    int         _age;

public:
    Animal(const std::string& name, int age)
        : _name(name), _age(age) {}

    virtual std::string speak()  const = 0;   // pure virtual
    virtual std::string type()   const = 0;   // pure virtual

    virtual void    info() const
    {
        std::cout << type() << " | name=" << _name
                  << " | age=" << _age
                  << " | says: \"" << speak() << "\"\n";
    }

    std::string getName() const { return _name; }
    int         getAge()  const { return _age;  }

    virtual ~Animal() = default;
};

class Dog : public Animal
{
public:
    Dog(const std::string& name, int age) : Animal(name, age) {}

    std::string speak() const override { return "Woof!"; }
    std::string type()  const override { return "Dog";   }

    void    fetch() const
    {
        std::cout << _name << " fetches the ball!\n";
    }
};

class Cat : public Animal
{
public:
    Cat(const std::string& name, int age) : Animal(name, age) {}

    std::string speak() const override { return "Meow!"; }
    std::string type()  const override { return "Cat";   }

    void    purr() const
    {
        std::cout << _name << " purrs...\n";
    }
};

class Bird : public Animal
{
private:
    bool    _canFly;

public:
    Bird(const std::string& name, int age, bool canFly = true)
        : Animal(name, age), _canFly(canFly) {}

    std::string speak() const override { return "Tweet!"; }
    std::string type()  const override { return "Bird";   }

    void    info() const override   // overriding info too
    {
        Animal::info();  // call base version first
        std::cout << "  can fly: " << (_canFly ? "yes" : "no") << '\n';
    }
};

// ============================================================================
//  FUNCTION using polymorphism — works for ANY Animal
// ============================================================================

void    make_speak(const Animal& a)
{
    // Calls the correct speak() based on actual runtime type
    std::cout << a.getName() << " says: " << a.speak() << '\n';
}

void    make_all_speak(const std::vector<Animal*>& animals)
{
    for (const Animal* a : animals)
        a->info();   // virtual dispatch — correct method called every time
}

// ============================================================================
//  dynamic_cast — safe downcasting
// ============================================================================

void    demo_dynamic_cast()
{
    std::cout << "\n=== dynamic_cast (safe downcasting) ===\n";

    Animal*     a = new Dog("Rex", 3);

    // Downcast: Animal* → Dog*
    Dog*    d = dynamic_cast<Dog*>(a);
    if (d)
    {
        std::cout << "Successfully cast to Dog*\n";
        d->fetch();
    }

    // Failed downcast: Dog is not a Cat
    Cat*    c = dynamic_cast<Cat*>(a);
    if (!c)
        std::cout << "dynamic_cast<Cat*> returned nullptr (correct)\n";

    delete a;
}

// ============================================================================
//  smart pointer polymorphism — modern C++ way (no raw delete)
// ============================================================================

void    demo_smart_polymorphism()
{
    std::cout << "\n=== Polymorphism with unique_ptr ===\n";

    // vector of base class smart pointers — each holds a different derived type
    std::vector<std::unique_ptr<Animal>>    zoo;

    zoo.push_back(std::make_unique<Dog>("Rex", 3));
    zoo.push_back(std::make_unique<Cat>("Whiskers", 5));
    zoo.push_back(std::make_unique<Bird>("Tweety", 2));
    zoo.push_back(std::make_unique<Bird>("Penguin", 4, false));

    for (const auto& animal : zoo)
        animal->info();   // correct virtual function called each time

    // No delete needed — unique_ptr frees memory automatically
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    // --- Interface demo ---
    std::cout << "=== Interface (Multiple Inheritance) ===\n";
    Canvas  cv("Hello World");
    cv.draw();
    cv.resize(2.5);
    std::cout << "Serialized: " << cv.serialize() << '\n';

    // --- Classic animal polymorphism ---
    std::cout << "\n=== Animal Polymorphism ===\n";
    Dog     dog("Rex", 3);
    Cat     cat("Whiskers", 5);
    Bird    bird("Tweety", 2);

    std::vector<Animal*>    animals = {&dog, &cat, &bird};
    make_all_speak(animals);

    demo_dynamic_cast();
    demo_smart_polymorphism();

    return (0);
}
