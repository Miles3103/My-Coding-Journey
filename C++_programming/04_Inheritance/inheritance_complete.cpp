// ============================================================================
//  Project : Inheritance
//  Author  : Miles3103
//  Topic   : Inheritance — base/derived, virtual, abstract classes
// ============================================================================

/*
** INHERITANCE — "IS-A" RELATIONSHIP
**
**   class Dog : public Animal {}  →  Dog IS-A Animal
**
** A derived class INHERITS all public/protected members of the base class.
** It can ADD new members and OVERRIDE existing ones.
**
** ACCESS IN INHERITANCE:
**   public inheritance    → public stays public, protected stays protected
**   protected inheritance → public becomes protected
**   private inheritance   → everything becomes private
**   (Almost always use public inheritance)
**
** VIRTUAL FUNCTIONS — the key to polymorphism:
**   Without virtual: base class function is always called (static dispatch)
**   With virtual:    the correct derived function is called (dynamic dispatch)
**
** ABSTRACT CLASS:
**   Has at least one PURE VIRTUAL function: virtual void f() = 0;
**   Cannot be instantiated — must be subclassed.
**   Acts as an INTERFACE — enforces a contract.
**
** CONSTRUCTOR ORDER:
**   Base constructor runs FIRST, then derived constructor.
**   Destructors run in REVERSE: derived first, then base.
**   This is why the base destructor MUST be virtual!
*/

#include <iostream>
#include <string>
#include <cmath>

// ============================================================================
//  ABSTRACT BASE CLASS: Shape
//  Pure virtual functions define the interface every Shape must implement
// ============================================================================

class Shape
{
protected:
    std::string _color;
    std::string _name;

public:
    Shape(const std::string& name, const std::string& color)
        : _color(color), _name(name)
    {
        std::cout << "[Shape] base ctor: " << _name << '\n';
    }

    // PURE VIRTUAL — every subclass MUST implement these
    virtual double  area()      const = 0;
    virtual double  perimeter() const = 0;

    // VIRTUAL with default implementation — subclass CAN override
    virtual void    describe() const
    {
        std::cout << _name << " | color=" << _color
                  << " | area=" << area()
                  << " | perimeter=" << perimeter() << '\n';
    }

    // Getters
    std::string     getName()  const { return _name;  }
    std::string     getColor() const { return _color; }

    // CRITICAL: base destructor MUST be virtual
    // Without this, deleting a derived object through a base pointer
    // would only call the base destructor — resource leak!
    virtual ~Shape()
    {
        std::cout << "[Shape] base dtor: " << _name << '\n';
    }
};

// ============================================================================
//  DERIVED: Circle
// ============================================================================

class Circle : public Shape
{
private:
    double  _radius;

public:
    Circle(double radius, const std::string& color = "white")
        : Shape("Circle", color), _radius(radius)
    {
        std::cout << "[Circle] ctor: radius=" << _radius << '\n';
    }

    ~Circle() override
    {
        std::cout << "[Circle] dtor\n";
    }

    // override keyword — compiler checks we're actually overriding something
    double  area()      const override { return M_PI * _radius * _radius; }
    double  perimeter() const override { return 2.0 * M_PI * _radius; }

    double  getRadius() const { return _radius; }
};

// ============================================================================
//  DERIVED: Rectangle
// ============================================================================

class Rectangle : public Shape
{
private:
    double  _width;
    double  _height;

public:
    Rectangle(double w, double h, const std::string& color = "white")
        : Shape("Rectangle", color), _width(w), _height(h)
    {
        std::cout << "[Rectangle] ctor: " << _width << "x" << _height << '\n';
    }

    ~Rectangle() override
    {
        std::cout << "[Rectangle] dtor\n";
    }

    double  area()      const override { return _width * _height; }
    double  perimeter() const override { return 2.0 * (_width + _height); }

    // Additional method not in base class
    bool    isSquare() const { return _width == _height; }
};

// ============================================================================
//  FURTHER DERIVED: Square inherits from Rectangle
// ============================================================================

class Square : public Rectangle
{
public:
    Square(double side, const std::string& color = "white")
        : Rectangle(side, side, color)
    {
        std::cout << "[Square] ctor: side=" << side << '\n';
    }

    ~Square() override
    {
        std::cout << "[Square] dtor\n";
    }

    // Override describe to show "Square" instead of "Rectangle"
    void    describe() const override
    {
        std::cout << "Square | color=" << getColor()
                  << " | area=" << area()
                  << " | side=" << std::sqrt(area()) << '\n';
    }
};

// ============================================================================
//  DEMONSTRATING POLYMORPHISM WITH BASE POINTER
//  (covered more in next file, but introduced here)
// ============================================================================

void    print_shape_info(const Shape& s)
{
    // Works for ANY Shape — Circle, Rectangle, Square, etc.
    // The correct area() and perimeter() are called (virtual dispatch)
    s.describe();
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    std::cout << "=== Creating Shapes ===\n";
    {
        Circle      c(5.0, "red");
        Rectangle   r(4.0, 6.0, "blue");
        Square      sq(3.0, "green");

        std::cout << "\n=== Shape Info ===\n";
        print_shape_info(c);
        print_shape_info(r);
        print_shape_info(sq);

        std::cout << "\n=== Type-Specific Methods ===\n";
        std::cout << "c.getRadius()   = " << c.getRadius() << '\n';
        std::cout << "r.isSquare()    = " << (r.isSquare() ? "yes" : "no") << '\n';
        std::cout << "sq.isSquare()   = " << (sq.isSquare() ? "yes" : "no") << '\n';

        // Pointer to base class — key to polymorphism
        std::cout << "\n=== Base Class Pointer ===\n";
        Shape*  ptr = &c;
        ptr->describe();  // calls Circle::describe (virtual dispatch)

        ptr = &sq;
        ptr->describe();  // calls Square::describe

        std::cout << "\n=== Destructors run in reverse order ===\n";
    }   // sq, r, c destroyed here (Square dtor → Rectangle dtor → Shape dtor)

    // Cannot instantiate abstract class:
    // Shape s("test", "red"); // ERROR: Shape has pure virtual methods

    return (0);
}
