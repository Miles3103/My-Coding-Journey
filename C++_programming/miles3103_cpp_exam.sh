#!/bin/bash
# **************************************************************************** #
#                                                                              #
#  Project: Miles3103 C++ Mastery Exam v1.0                                   #
#  Coverage: C++ Intro → Modern C++ (60 Levels, 3 per topic x 20 topics)      #
#                                                                              #
#  TOPIC MAP:                                                                  #
#   0-2   Intro/IO         3-5   References        6-8   Functions            #
#   9-11  Strings         12-14  Classes           15-17  Constructors        #
#  18-20  Operator OL    21-23  Inheritance       24-26  Polymorphism         #
#  27-29  Templates      30-32  STL Vector        33-35  STL Map/Set          #
#  36-38  Exceptions     39-41  Smart Pointers    42-44  Lambdas              #
#  45-47  Iterators      48-50  Move Semantics    51-53  Constexpr/Auto       #
#  54-56  Rule of Five   57-59  Modern C++        Final Boss: Level 59        #
#                                                                              #
#  HOW TO USE:                                                                 #
#    chmod +x miles3103_cpp_exam.sh                                            #
#    ./miles3103_cpp_exam.sh                                                   #
#    Commands: grademe | skip | hint | reset | exit                            #
#                                                                              #
# **************************************************************************** #

mkdir -p subjects rendu traces
if [ ! -f .level ]; then echo 0 > .level; fi

MAX_LEVEL=59

CXX="g++"
CXXFLAGS="-Wall -Wextra -Werror -std=c++17"

generate_subjects() {

cat << 'EOF' > subjects/lvl0.txt
=== LEVEL 0 — C++ INTRO [1/3] : Hello with cout ===
FILE: rendu/lvl0/task.cpp

Write a C++ program that prints exactly:
  Hello, C++ World!

Rules:
  - Use #include <iostream>
  - Use std::cout (NOT printf)
  - End with '\n' (not std::endl)
  - Return 0 from main

Expected output:
  Hello, C++ World!

Tip: std::cout << "text" << '\n';
EOF

cat << 'EOF' > subjects/lvl1.txt
=== LEVEL 1 — C++ INTRO [2/3] : Namespace ===
FILE: rendu/lvl1/task.cpp

Write a program using a custom namespace:

  namespace Academy {
      int level = 42;
      void greet() { prints "Welcome to the Academy" }
  }

In main:
  1. Call Academy::greet()
  2. Print: Level: 42  (using Academy::level)

Expected output:
  Welcome to the Academy
  Level: 42

Tip: namespace Name { ... }  accessed with Name::member
EOF

cat << 'EOF' > subjects/lvl2.txt
=== LEVEL 2 — C++ INTRO [3/3] : Output Formatting ===
FILE: rendu/lvl2/task.cpp

Print a formatted table using #include <iomanip>:
  Name        Score  Grade
  Alice          95      A
  Bob            82      B
  Miles3103      88      B

Rules:
  - Use std::left, std::right, std::setw()
  - Name column: 12 wide, left-aligned
  - Score column: 7 wide, right-aligned
  - Grade column: 7 wide, right-aligned

Expected output (exact spacing):
  Name        Score  Grade
  Alice          95      A
  Bob            82      B
  Miles3103      88      B

Tip: std::cout << std::left << std::setw(12) << name ...
EOF

cat << 'EOF' > subjects/lvl3.txt
=== LEVEL 3 — REFERENCES [1/3] : Alias ===
FILE: rendu/lvl3/task.cpp

Demonstrate references:
  int x = 10;
  int& ref = x;   // ref is an alias for x

Print:
  x = 10
  ref = 10
  Same address: yes

Then: ref = 99;
Print:
  After ref = 99: x = 99

Expected output:
  x = 10
  ref = 10
  Same address: yes
  After ref = 99: x = 99

Tip: &x == &ref is true — they are the SAME memory location.
EOF

cat << 'EOF' > subjects/lvl4.txt
=== LEVEL 4 — REFERENCES [2/3] : Pass by Reference ===
FILE: rendu/lvl4/task.cpp

Write TWO functions:
  void by_value(int n)     — doubles n (caller NOT changed)
  void by_reference(int &n)— doubles n (caller IS changed)

Test with x = 5:
  Before: 5
  After by_value: 5
  After by_reference: 10

Expected output:
  Before: 5
  After by_value: 5
  After by_reference: 10

Tip: This is the key difference from C pointer-passing.
EOF

cat << 'EOF' > subjects/lvl5.txt
=== LEVEL 5 — REFERENCES [3/3] : Const Reference ===
FILE: rendu/lvl5/task.cpp

Write: void print_info(const std::string& name, const std::string& lang)
  - Takes both by const reference (no copy!)
  - Prints: name uses lang

Write: size_t count_chars(const std::string& s, char c)
  - Returns count of c in s (no copy of s!)

Test:
  Miles3103 uses C++
  'l' in "Hello World" = 3

Expected output:
  Miles3103 uses C++
  'l' in "Hello World" = 3

Tip: const T& = read-only access with zero copy overhead.
EOF

cat << 'EOF' > subjects/lvl6.txt
=== LEVEL 6 — FUNCTIONS [1/3] : Overloading ===
FILE: rendu/lvl6/task.cpp

Write THREE overloaded print() functions:
  void print(int n)          — prints: int: N
  void print(double d)       — prints: double: D
  void print(std::string s)  — prints: string: S

In main, call:
  print(42)
  print(3.14)
  print(std::string("hello"))

Expected output:
  int: 42
  double: 3.14
  string: hello

Tip: Same name, different parameter types — compiler picks the right one.
EOF

cat << 'EOF' > subjects/lvl7.txt
=== LEVEL 7 — FUNCTIONS [2/3] : Default Parameters ===
FILE: rendu/lvl7/task.cpp

Write: std::string greet(std::string name, std::string greeting = "Hello", std::string end = "!")
  Returns: greeting + ", " + name + end

Test:
  greet("Miles3103")                   -> Hello, Miles3103!
  greet("Miles3103", "Welcome")        -> Welcome, Miles3103!
  greet("Miles3103", "Hi", ".")        -> Hi, Miles3103.

Expected output:
  Hello, Miles3103!
  Welcome, Miles3103!
  Hi, Miles3103.

Tip: Default params must come LAST in the parameter list.
EOF

cat << 'EOF' > subjects/lvl8.txt
=== LEVEL 8 — FUNCTIONS [3/3] : Template Function ===
FILE: rendu/lvl8/task.cpp

Write a template function:
  template <typename T>
  T ft_max(T a, T b) { returns the larger value }

And:
  template <typename T>
  void ft_swap(T& a, T& b) { swaps a and b in-place }

Test:
  ft_max(3, 7) = 7
  ft_max(3.14, 2.71) = 3.14
  ft_max('a', 'z') = z
  Before swap: a=5 b=9
  After swap:  a=9 b=5

Expected output:
  ft_max(3, 7) = 7
  ft_max(3.14, 2.71) = 3.14
  ft_max('a', 'z') = z
  Before swap: a=5 b=9
  After swap:  a=9 b=5
EOF

cat << 'EOF' > subjects/lvl9.txt
=== LEVEL 9 — STRINGS [1/3] : std::string Basics ===
FILE: rendu/lvl9/task.cpp

Use std::string (no C-strings allowed):
  std::string s = "Hello, Miles3103!";

Print:
  length = 17
  [0] = H
  last = !
  upper 5: Hello

Then concatenate: s + " Learning C++"
Print:
  Hello, Miles3103! Learning C++

Expected output:
  length = 17
  [0] = H
  last = !
  upper 5: Hello
  Hello, Miles3103! Learning C++

Tip: .length(), .front(), .back(), .substr(), operator+
EOF

cat << 'EOF' > subjects/lvl10.txt
=== LEVEL 10 — STRINGS [2/3] : String Operations ===
FILE: rendu/lvl10/task.cpp

Write: bool ft_palindrome(const std::string& s)
  Returns true if s reads the same forwards and backwards.

Write: std::string ft_reverse(const std::string& s)
  Returns a new reversed string.

Test:
  "racecar"  -> is palindrome
  "hello"    -> not palindrome
  reverse("Miles3103") = 3013seliM

Expected output:
  racecar: is palindrome
  hello: not palindrome
  reverse(Miles3103) = 3013seliM

Tip: Compare s[i] with s[s.length()-1-i]
EOF

cat << 'EOF' > subjects/lvl11.txt
=== LEVEL 11 — STRINGS [3/3] : String Manipulation ===
FILE: rendu/lvl11/task.cpp

Write: std::string ft_toupper(std::string s)
  Returns s with all lowercase letters converted to uppercase.

Write: int ft_count(const std::string& s, char c)
  Returns count of character c in s.

Write: std::string ft_replace(std::string s, char from, char to)
  Returns s with all occurrences of 'from' replaced by 'to'.

Test:
  toupper("hello world") = HELLO WORLD
  count('l', "hello world") = 3
  replace('o','0', "hello world") = hell0 w0rld

Expected output:
  HELLO WORLD
  3
  hell0 w0rld
EOF

cat << 'EOF' > subjects/lvl12.txt
=== LEVEL 12 — CLASSES [1/3] : Basic Class ===
FILE: rendu/lvl12/task.cpp

Create a class Rectangle:
  Private: double _width, _height
  Public:
    Constructor: Rectangle(double w, double h)
    double area()      const — returns width * height
    double perimeter() const — returns 2*(width+height)
    void   print()     const — prints: Rectangle(WxH) area=A perimeter=P

Test with Rectangle(4.0, 6.0):
  Rectangle(4x6) area=24 perimeter=20

Expected output:
  Rectangle(4x6) area=24 perimeter=20

Tip: Use const methods for anything that doesn't change the object.
EOF

cat << 'EOF' > subjects/lvl13.txt
=== LEVEL 13 — CLASSES [2/3] : Encapsulation ===
FILE: rendu/lvl13/task.cpp

Create class BankAccount:
  Private: std::string _owner, double _balance
  Public:
    Constructor(std::string owner, double initial = 0.0)
    bool deposit(double amount)  — fails if amount <= 0
    bool withdraw(double amount) — fails if amount <= 0 or > balance
    double getBalance() const
    void print() const — prints: [owner] balance: $B

Test:
  [Miles3103] balance: $0
  Deposit 500: ok
  Withdraw 200: ok
  Withdraw 400: failed
  [Miles3103] balance: $300

Expected output:
  [Miles3103] balance: $0
  Deposit 500: ok
  Withdraw 200: ok
  Withdraw 400: failed
  [Miles3103] balance: $300
EOF

cat << 'EOF' > subjects/lvl14.txt
=== LEVEL 14 — CLASSES [3/3] : Static Members ===
FILE: rendu/lvl14/task.cpp

Create class Counter:
  Private: int _value
  Static:  int s_total (tracks total instances ever created)
  Public:
    Counter()     — default, _value=0, increment s_total
    Counter(int v)— sets _value, increment s_total
    void increment()    — _value++
    int  getValue()  const
    static int getTotal() — returns s_total
    void print() const — prints: Counter[value=V]

Test:
  Counter a, b(10), c(5)
  a.increment(); a.increment();
  Print each, then print total.

Expected output:
  Counter[value=2]
  Counter[value=10]
  Counter[value=5]
  Total counters created: 3

Tip: static int Counter::s_total = 0; defined outside the class.
EOF

cat << 'EOF' > subjects/lvl15.txt
=== LEVEL 15 — CONSTRUCTORS [1/3] : Constructor Types ===
FILE: rendu/lvl15/task.cpp

Create class Point with:
  double _x, _y
  Default ctor:          Point()         → x=0, y=0
  Parameterized ctor:    Point(x, y)     → sets values
  Copy ctor:             Point(const Point&)
  
  void print() const → "(x, y)"
  double distanceTo(const Point& other) const
    → sqrt((x2-x1)^2 + (y2-y1)^2)  use #include <cmath>

Test:
  Point a           → (0, 0)
  Point b(3.0, 4.0) → (3, 4)
  Point c = b       → (3, 4)  (copy)
  distance(a, b)    = 5

Expected output:
  (0, 0)
  (3, 4)
  (3, 4)
  distance = 5

Tip: Initializer list: Point(x,y) : _x(x), _y(y) {}
EOF

cat << 'EOF' > subjects/lvl16.txt
=== LEVEL 16 — CONSTRUCTORS [2/3] : Destructor ===
FILE: rendu/lvl16/task.cpp

Create class Resource:
  string _name
  Constructor: prints "[Resource] acquired: name"
  Destructor:  prints "[Resource] released: name"

In main, using scopes:
  {
    Resource a("FileHandle");
    Resource b("NetworkConn");
    // both destroyed here
  }
  Resource c("Database");
  // c destroyed at end of main

Expected output (exact):
  [Resource] acquired: FileHandle
  [Resource] acquired: NetworkConn
  [Resource] released: NetworkConn
  [Resource] released: FileHandle
  [Resource] acquired: Database
  [Resource] released: Database

Tip: Destructors run in REVERSE order of construction.
EOF

cat << 'EOF' > subjects/lvl17.txt
=== LEVEL 17 — CONSTRUCTORS [3/3] : Initializer List ===
FILE: rendu/lvl17/task.cpp

Create class Student:
  const std::string _name   (const — MUST use initializer list)
  const int         _id     (const — MUST use initializer list)
  double            _gpa

  Constructor(string name, int id, double gpa = 0.0)
    — MUST use initializer list for ALL members
  void print() const → "Student[id=ID name=NAME gpa=GPA]"
  void study(double hours) → _gpa += hours * 0.1 (max 4.0)

Test:
  Student s("Miles3103", 42);
  s.print()
  s.study(5.0); s.study(3.0); s.study(10.0);
  s.print()

Expected output:
  Student[id=42 name=Miles3103 gpa=0]
  Student[id=42 name=Miles3103 gpa=1.8]

Tip: Constructor(name, id) : _name(name), _id(id), _gpa(0.0) {}
EOF

cat << 'EOF' > subjects/lvl18.txt
=== LEVEL 18 — OPERATOR OVERLOADING [1/3] : Arithmetic ===
FILE: rendu/lvl18/task.cpp

Create class Vector2D with double _x, _y:
  Constructor(x, y)
  operator+  → returns new Vector2D (sum)
  operator-  → returns new Vector2D (difference)
  operator*  → scalar multiply: Vector2D * double
  operator== → true if x and y are equal
  friend operator<< → prints "(x, y)"

Test:
  v1(3, 4) + v2(1, 2) = (4, 6)
  v1(3, 4) - v2(1, 2) = (2, 2)
  v1(3, 4) * 2 = (6, 8)
  v1 == v1: 1

Expected output:
  (4, 6)
  (2, 2)
  (6, 8)
  1

Tip: operator+(const Vector2D& rhs) const { return Vector2D(_x+rhs._x, ...) }
EOF

cat << 'EOF' > subjects/lvl19.txt
=== LEVEL 19 — OPERATOR OVERLOADING [2/3] : Comparison & Stream ===
FILE: rendu/lvl19/task.cpp

Create class Temperature with double _celsius:
  Constructor(double celsius)
  Getters: celsius(), fahrenheit() = c*9/5+32, kelvin() = c+273.15
  operator<  → compare by celsius
  operator== → compare by celsius
  operator<< → prints "X°C"

Test (must sort 3 temps using std::sort — include <vector> <algorithm>):
  Temperatures: 100°C, 0°C, 37°C
  Sorted: 0°C, 37°C, 100°C
  0°C == 0°C: 1

Expected output:
  Sorted: 0°C 37°C 100°C
  0°C == 0°C: 1

Tip: For std::sort to work, operator< must be defined.
     std::sort(v.begin(), v.end());
EOF

cat << 'EOF' > subjects/lvl20.txt
=== LEVEL 20 — OPERATOR OVERLOADING [3/3] : [] and = ===
FILE: rendu/lvl20/task.cpp

Create class IntArray:
  int*  _data (heap allocated)
  size_t _size

  Constructor(size_t size)  — allocates with new[]
  Destructor                — deletes with delete[]
  Copy constructor          — deep copy!
  Copy assignment           — deep copy with self-check!
  operator[](size_t i)      — returns reference to element
  size_t size() const
  void print() const        — prints all elements

Test:
  IntArray a(5); fill 0-4: a[0]=0, a[1]=1 ... a[4]=4
  IntArray b = a;     // copy
  b[0] = 99;          // change b — a must be unaffected!
  a.print() → 0 1 2 3 4
  b.print() → 99 1 2 3 4

Expected output:
  0 1 2 3 4
  99 1 2 3 4

Tip: Deep copy = new allocation + copy each element.
EOF

cat << 'EOF' > subjects/lvl21.txt
=== LEVEL 21 — INHERITANCE [1/3] : Base and Derived ===
FILE: rendu/lvl21/task.cpp

Create base class Animal:
  protected: std::string _name
  public:
    Constructor(string name)
    virtual string speak() const = 0  (pure virtual)
    void print() const → "name says: speak()"

Create Dog : public Animal
  speak() returns "Woof!"
  void fetch() → prints "name fetches the ball!"

Create Cat : public Animal
  speak() returns "Meow!"

Test:
  Dog d("Rex");    d.print(); d.fetch();
  Cat c("Whiskers"); c.print();

Expected output:
  Rex says: Woof!
  Rex fetches the ball!
  Whiskers says: Meow!
EOF

cat << 'EOF' > subjects/lvl22.txt
=== LEVEL 22 — INHERITANCE [2/3] : Virtual & Override ===
FILE: rendu/lvl22/task.cpp

Create class Shape:
  virtual double area() const = 0
  virtual string name() const = 0
  virtual void describe() const — prints "name: area=X"
  virtual destructor!

Create Circle(double radius) : Shape
  area() = PI * r * r  (use M_PI from <cmath>)
  name() = "Circle"

Create Rectangle(double w, double h) : Shape
  area() = w * h
  name() = "Rectangle"
  Override describe() to also print dimensions

Test via base pointer:
  Shape* s1 = new Circle(5.0);
  Shape* s2 = new Rectangle(4.0, 6.0);
  s1->describe(); s2->describe();
  delete s1; delete s2;

Expected output:
  Circle: area=78.5398
  Rectangle(4x6): area=24

Tip: Use std::cout << std::fixed << std::setprecision(4)
EOF

cat << 'EOF' > subjects/lvl23.txt
=== LEVEL 23 — INHERITANCE [3/3] : Multiple Inheritance ===
FILE: rendu/lvl23/task.cpp

Create two interfaces (abstract classes):
  class IFlyable  { virtual void fly()  const = 0; virtual ~IFlyable() = default; }
  class ISwimmable{ virtual void swim() const = 0; virtual ~ISwimmable() = default; }

Create:
  Duck : public IFlyable, public ISwimmable
    fly()  → "Duck is flying"
    swim() → "Duck is swimming"
    void quack() → "Quack!"

  Fish : public ISwimmable
    swim() → "Fish is swimming"

Test:
  Duck d; d.fly(); d.swim(); d.quack();
  Fish f; f.swim();
  ISwimmable* ptr = &d; ptr->swim();

Expected output:
  Duck is flying
  Duck is swimming
  Quack!
  Fish is swimming
  Duck is swimming
EOF

cat << 'EOF' > subjects/lvl24.txt
=== LEVEL 24 — POLYMORPHISM [1/3] : Virtual Dispatch ===
FILE: rendu/lvl24/task.cpp

Create Animal hierarchy (Animal → Dog, Cat, Bird)
Each with virtual speak() returning their sound.

Store in vector<Animal*> and iterate:
  Animal* animals[] = {new Dog("Rex"), new Cat("Mia"), new Bird("Tweet")};

For each animal, call speak() — correct method must be called!

Then print types using typeid (include <typeinfo>):
  typeid(*a).name()

Expected output:
  Rex: Woof!
  Mia: Meow!
  Tweet: Tweet!
  (type names will vary by compiler — just show something)

Tip: Without 'virtual', all would call Animal::speak().
     With 'virtual', the actual type's method is called.
EOF

cat << 'EOF' > subjects/lvl25.txt
=== LEVEL 25 — POLYMORPHISM [2/3] : dynamic_cast ===
FILE: rendu/lvl25/task.cpp

Using the Animal/Dog/Cat hierarchy from the previous level:

Write: void process(Animal* a)
  Try to dynamic_cast to Dog*
  If Dog:  call fetch() and print "Fetched!"
  If not:  print "Not a dog"

Test:
  Animal* a1 = new Dog("Rex");
  Animal* a2 = new Cat("Mia");
  process(a1) → "Fetched!"
  process(a2) → "Not a dog"
  delete a1; delete a2;

Expected output:
  Rex fetches! Fetched!
  Not a dog

Tip: dynamic_cast<Dog*>(ptr) returns nullptr if ptr is not a Dog.
EOF

cat << 'EOF' > subjects/lvl26.txt
=== LEVEL 26 — POLYMORPHISM [3/3] : Smart Ptr Polymorphism ===
FILE: rendu/lvl26/task.cpp

Rebuild the shape hierarchy (Circle, Rectangle, Triangle).
Use unique_ptr instead of raw pointers.

  vector<unique_ptr<Shape>> shapes;
  shapes.push_back(make_unique<Circle>(5.0));
  shapes.push_back(make_unique<Rectangle>(4.0, 6.0));
  shapes.push_back(make_unique<Triangle>(3.0, 4.0, 5.0));
    (Triangle: area = 0.5 * base * height)

For each shape, call describe().
No delete needed — unique_ptr handles cleanup.

Expected output:
  Circle: area=78.5398
  Rectangle: area=24
  Triangle: area=6

Tip: #include <memory>  std::make_unique<T>(args...)
EOF

cat << 'EOF' > subjects/lvl27.txt
=== LEVEL 27 — TEMPLATES [1/3] : Function Template ===
FILE: rendu/lvl27/task.cpp

Write three template functions:
  template<typename T> T ft_min(T a, T b)
  template<typename T> T ft_max(T a, T b)
  template<typename T> T ft_clamp(T val, T lo, T hi)
    — returns lo if val<lo, hi if val>hi, else val

Test all three with int and double:
  min(3, 7) = 3
  max(3.14, 2.71) = 3.14
  clamp(15, 0, 10) = 10
  clamp(-5, 0, 10) = 0
  clamp(5, 0, 10) = 5

Expected output:
  min(3, 7) = 3
  max(3.14, 2.71) = 3.14
  clamp(15, 0, 10) = 10
  clamp(-5, 0, 10) = 0
  clamp(5, 0, 10) = 5
EOF

cat << 'EOF' > subjects/lvl28.txt
=== LEVEL 28 — TEMPLATES [2/3] : Class Template ===
FILE: rendu/lvl28/task.cpp

Write a template class Stack<T, int MaxSize=100>:
  void push(const T& val)  — throws std::overflow_error if full
  T    pop()               — throws std::underflow_error if empty
  T&   peek()              — top element
  bool isEmpty() const
  int  size() const
  void print() const       — prints all elements top to bottom

Test Stack<int> and Stack<std::string>:
  int stack: push 10,20,30 → peek=30 → pop=30 → size=2
  str stack: push "a","b","c" → print: c b a

Expected output:
  peek = 30
  pop = 30
  size = 2
  c b a
EOF

cat << 'EOF' > subjects/lvl29.txt
=== LEVEL 29 — TEMPLATES [3/3] : Template Specialization ===
FILE: rendu/lvl29/task.cpp

Write a general template:
  template<typename T>
  void describe(const T& val) { prints "value: X" }

Write specializations:
  describe<bool>      → prints "bool: true/false"
  describe<std::string> → prints "string[N]: X"  (N = length)
  describe<char>      → prints "char 'C' = ASCII N"

Test:
  describe(42)
  describe(true)
  describe(false)
  describe(std::string("hello"))
  describe('A')

Expected output:
  value: 42
  bool: true
  bool: false
  string[5]: hello
  char 'A' = ASCII 65
EOF

cat << 'EOF' > subjects/lvl30.txt
=== LEVEL 30 — STL VECTOR [1/3] : Basics ===
FILE: rendu/lvl30/task.cpp

Use std::vector<int>:
  Start: {5, 3, 8, 1, 9, 2, 7, 4, 6}
  1. Print size and capacity
  2. Sort ascending with std::sort
  3. Print all elements
  4. Find 7 with std::find — print its index
  5. Erase the element at index 3
  6. Print result

Expected output (sort, index may vary):
  size=9
  1 2 3 4 5 6 7 8 9
  found 7 at index 6
  1 2 3 5 6 7 8 9

Tip: #include <vector> <algorithm>
     std::find returns an iterator
EOF

cat << 'EOF' > subjects/lvl31.txt
=== LEVEL 31 — STL VECTOR [2/3] : Algorithms ===
FILE: rendu/lvl31/task.cpp

Given vector<int> nums = {1..10}:

Use STL algorithms (no manual loops):
  1. count_if: how many even numbers?
  2. any_of:   is any number > 8?
  3. all_of:   are all numbers > 0?
  4. transform: create new vector with each element squared
  5. accumulate: sum of all elements

Print each result.

Expected output:
  evens: 5
  any > 8: yes
  all > 0: yes
  squares: 1 4 9 16 25 36 49 64 81 100
  sum: 55

Tip: #include <algorithm> <numeric>
     Use lambdas: [](int n){ return n > 8; }
EOF

cat << 'EOF' > subjects/lvl32.txt
=== LEVEL 32 — STL VECTOR [3/3] : Custom Sort ===
FILE: rendu/lvl32/task.cpp

Create struct Person { string name; int age; double score; }

Create vector of 4+ people.
Sort THREE times using lambdas:
  1. By name (alphabetical)
  2. By age (youngest first)
  3. By score (highest first)

Print the sorted order each time (just names).

Expected output (use these people):
  Alice(25, 88), Bob(32, 95), Charlie(19, 72), Diana(28, 91)

By name:   Alice Bob Charlie Diana
By age:    Charlie Alice Diana Bob
By score:  Bob Diana Alice Charlie

Tip: std::sort(v.begin(), v.end(), [](const Person& a, const Person& b){ return a.name < b.name; });
EOF

cat << 'EOF' > subjects/lvl33.txt
=== LEVEL 33 — STL MAP/SET [1/3] : std::map ===
FILE: rendu/lvl33/task.cpp

Use std::map<string, int> to count word frequency:
  Text: "the cat sat on the mat the cat"

After counting:
  Print all words and counts (sorted alphabetically by key).
  Print the most frequent word.

Expected output:
  cat: 2
  mat: 1
  on: 1
  sat: 1
  the: 3
  Most frequent: the (3)

Tip: Use .find() to check existence.
     Iterate with: for (const auto& [word, count] : freq)
EOF

cat << 'EOF' > subjects/lvl34.txt
=== LEVEL 34 — STL MAP/SET [2/3] : std::set ===
FILE: rendu/lvl34/task.cpp

Given two lists:
  list1 = {1, 3, 5, 7, 9, 2, 4}
  list2 = {3, 6, 9, 1, 7, 8, 5}

Using std::set:
  1. Create set from list1 (auto-sorted, no dupes)
  2. Find intersection (elements in BOTH lists)
  3. Find union (all unique elements)
  4. Find difference (in list1 but NOT in list2)

Print each result sorted.

Expected output:
  set1: 1 2 3 4 5 7 9
  intersection: 1 3 5 7 9
  union: 1 2 3 4 5 6 7 8 9
  difference: 2 4

Tip: Use set_intersection, set_union, set_difference from <algorithm>
EOF

cat << 'EOF' > subjects/lvl35.txt
=== LEVEL 35 — STL MAP/SET [3/3] : unordered_map ===
FILE: rendu/lvl35/task.cpp

Build a simple phone book using unordered_map<string,string>:
  Add: Alice→555-1234, Bob→555-5678, Charlie→555-9012
  
Operations:
  1. Lookup "Bob" — found: 555-5678
  2. Lookup "Diana" — not found
  3. Update "Alice" → 555-9999
  4. Delete "Charlie"
  5. Print remaining entries (sorted by name for consistency)

Expected output:
  Bob: 555-5678
  Diana: not found
  Updated Alice: 555-9999
  Remaining:
  Alice: 555-9999
  Bob: 555-5678

Tip: unordered_map has O(1) lookup vs O(log n) for map.
     Sort entries by copying to vector<pair<>> then sorting.
EOF

cat << 'EOF' > subjects/lvl36.txt
=== LEVEL 36 — EXCEPTIONS [1/3] : try/catch ===
FILE: rendu/lvl36/task.cpp

Write: double safe_divide(double a, double b)
  throws std::invalid_argument("division by zero") if b == 0

Write: int safe_at(std::vector<int>& v, int idx)
  throws std::out_of_range("index N out of range") if invalid

Test:
  safe_divide(10, 2) = 5
  safe_divide(5, 0)  → caught: division by zero
  safe_at({1,2,3}, 1) = 2
  safe_at({1,2,3}, 5) → caught: index 5 out of range

Expected output:
  5
  caught: division by zero
  2
  caught: index 5 out of range

Tip: try { ... } catch (const std::invalid_argument& e) { e.what() }
EOF

cat << 'EOF' > subjects/lvl37.txt
=== LEVEL 37 — EXCEPTIONS [2/3] : Custom Exceptions ===
FILE: rendu/lvl37/task.cpp

Create exception hierarchy:
  class AppError : public std::exception
    — stores message and int code
    — what() returns message
    — code() returns the code

  class ValidationError : public AppError (code=400)
  class NotFoundError   : public AppError (code=404)

Write:
  int find_score(map<string,int>& db, const string& name)
    → throws NotFoundError if not in db
  int validate_score(int score)
    → throws ValidationError if score < 0 or > 100

Test:
  find "Alice" (exists) → prints score
  find "Ghost" → NotFoundError caught [404]
  validate 85  → ok
  validate 150 → ValidationError caught [400]

Expected output:
  Alice: 95
  NotFoundError [404]: Ghost not found
  Score 85 ok
  ValidationError [400]: Score 150 out of range
EOF

cat << 'EOF' > subjects/lvl38.txt
=== LEVEL 38 — EXCEPTIONS [3/3] : RAII + Exception Safety ===
FILE: rendu/lvl38/task.cpp

Create class ManagedResource:
  string _name
  Constructor → prints "[ManagedResource] acquired: name"
  Destructor  → prints "[ManagedResource] released: name"

Write: void risky_function()
  Creates TWO ManagedResources inside it, then throws runtime_error.

In main:
  try { risky_function(); }
  catch { print "caught error" }
  Print "main continues"

Expected output:
  [ManagedResource] acquired: res1
  [ManagedResource] acquired: res2
  [ManagedResource] released: res2
  [ManagedResource] released: res1
  caught error
  main continues

Key insight: destructors always run during stack unwinding!
EOF

cat << 'EOF' > subjects/lvl39.txt
=== LEVEL 39 — SMART POINTERS [1/3] : unique_ptr ===
FILE: rendu/lvl39/task.cpp

Create class Gadget:
  string _name
  Constructor → "[Gadget] created: name"
  Destructor  → "[Gadget] destroyed: name"

Demonstrate unique_ptr:
  1. Create unique_ptr<Gadget> p1 = make_unique<Gadget>("Phone")
  2. Use p1->... to access it
  3. Move it: auto p2 = std::move(p1)
  4. Show p1 is now null: (p1 ? "valid" : "null")
  5. Let p2 go out of scope → auto-destroyed

Expected output:
  [Gadget] created: Phone
  Using: Phone
  p1 is null after move
  [Gadget] destroyed: Phone

Tip: unique_ptr cannot be copied — only moved.
EOF

cat << 'EOF' > subjects/lvl40.txt
=== LEVEL 40 — SMART POINTERS [2/3] : shared_ptr ===
FILE: rendu/lvl40/task.cpp

Create class Connection (same logging as Gadget).

Demonstrate shared_ptr:
  1. auto p1 = make_shared<Connection>("DB"); print ref_count
  2. auto p2 = p1;                            print ref_count (2)
  3. auto p3 = p2;                            print ref_count (3)
  4. Enter scope: { auto p4 = p1; print (4) } scope ends → print (3)
  5. p2.reset();                              print ref_count (2)

Expected output:
  [Connection] created: DB
  ref count: 1
  ref count: 2
  ref count: 3
  ref count: 4
  ref count: 3
  ref count: 2
  [Connection] destroyed: DB

Tip: use_count() returns the reference count.
EOF

cat << 'EOF' > subjects/lvl41.txt
=== LEVEL 41 — SMART POINTERS [3/3] : Custom Deleter ===
FILE: rendu/lvl41/task.cpp

unique_ptr can take a custom deleter — useful for C APIs.

Simulate a C-style FILE API:
  struct FakeFile { string name; };
  FakeFile* fake_open(string name) { prints "opened: name"; returns new FakeFile{name} }
  void fake_close(FakeFile* f) { prints "closed: f->name"; delete f; }

Use unique_ptr with custom deleter:
  auto deleter = [](FakeFile* f){ fake_close(f); };
  unique_ptr<FakeFile, decltype(deleter)> fp(fake_open("data.txt"), deleter);

Access fp->name, then let it go out of scope.

Expected output:
  opened: data.txt
  name: data.txt
  closed: data.txt

Tip: unique_ptr<T, Deleter> where Deleter is the type of your function/lambda.
EOF

cat << 'EOF' > subjects/lvl42.txt
=== LEVEL 42 — LAMBDAS [1/3] : Basics ===
FILE: rendu/lvl42/task.cpp

Demonstrate lambdas:
  1. Basic:  auto greet = []() { prints "Hello from lambda" }
  2. Params: auto add   = [](int a, int b) -> int { return a+b; }
  3. Capture by value:     int x=5; auto get_x = [x]() { return x; }
  4. Capture by reference: int cnt=0; auto inc = [&cnt]() { cnt++; }

Print:
  Hello from lambda
  add(3,4) = 7
  x = 5 (captured by value)
  cnt after 3 increments = 3

Expected output:
  Hello from lambda
  add(3,4) = 7
  x = 5
  cnt = 3
EOF

cat << 'EOF' > subjects/lvl43.txt
=== LEVEL 43 — LAMBDAS [2/3] : Lambdas + STL ===
FILE: rendu/lvl43/task.cpp

Given: vector<string> words = {"banana","apple","cherry","date","elderberry"}

Use lambdas with STL algorithms:
  1. Sort by length (shortest first)
  2. Filter: only words longer than 5 chars (use copy_if)
  3. Transform: create vector of lengths
  4. for_each: print each word with its length "word(N)"

Expected output:
  Sorted by length: date apple banana cherry elderberry
  Long words (>5): banana cherry elderberry
  Lengths: 6 5 6 4 10
  date(4) apple(5) banana(6) cherry(6) elderberry(10)

Tip: std::copy_if(src.begin(), src.end(), back_inserter(dst), lambda);
EOF

cat << 'EOF' > subjects/lvl44.txt
=== LEVEL 44 — LAMBDAS [3/3] : std::function & Closures ===
FILE: rendu/lvl44/task.cpp

Use std::function<> to store any callable:
  #include <functional>

  1. Write: auto make_adder(int n) → returns lambda that adds n
     auto add5 = make_adder(5);   add5(3) = 8
     auto add10 = make_adder(10); add10(7) = 17

  2. Store operations in vector<std::function<int(int,int)>>:
     {plus, minus, multiplies} from <functional>
     Apply each to (10, 3) and print

  3. Write: int apply_twice(std::function<int(int)> f, int x)
     apply_twice(add5, 0) = 10

Expected output:
  add5(3) = 8
  add10(7) = 17
  10 + 3 = 13
  10 - 3 = 7
  10 * 3 = 30
  apply_twice(add5, 0) = 10
EOF

cat << 'EOF' > subjects/lvl45.txt
=== LEVEL 45 — ITERATORS [1/3] : Iterator Basics ===
FILE: rendu/lvl45/task.cpp

Demonstrate iterators manually (no range-based for):
  vector<int> v = {10, 20, 30, 40, 50};

  1. Forward iteration: begin() to end()
  2. Reverse iteration: rbegin() to rend()
  3. Distance between two iterators
  4. std::advance to jump forward
  5. Find and erase using iterator

Expected output:
  forward: 10 20 30 40 50
  reverse: 50 40 30 20 10
  distance(begin, end) = 5
  after advance(it, 2): 30
  after erasing 30: 10 20 40 50
EOF

cat << 'EOF' > subjects/lvl46.txt
=== LEVEL 46 — ITERATORS [2/3] : Custom Iterator ===
FILE: rendu/lvl46/task.cpp

Create a class Range that can be iterated with range-based for:
  Range r(1, 10);   // generates 1 2 3 4 5 6 7 8 9
  for (int n : r) { ... }

Implement a nested iterator class with:
  operator*(), operator++(), operator!=(const iterator&)
  begin() and end() methods on Range

Test:
  for (int n : Range(1, 6)) cout << n << " ";  → 1 2 3 4 5
  Sum via accumulate of Range(1, 11)            → 55

Expected output:
  1 2 3 4 5
  sum(1..10) = 55

Tip: This is how range-based for works under the hood.
EOF

cat << 'EOF' > subjects/lvl47.txt
=== LEVEL 47 — ITERATORS [3/3] : Stream Iterators ===
FILE: rendu/lvl47/task.cpp

Use stream iterators (#include <iterator>):
  1. ostream_iterator: print vector with separator
  2. istream_iterator: read from string stream
  3. Copy vector to sorted set using copy + insert_iterator

Given: vector<int> v = {5,3,8,1,9,2,7,4,6}

Operations:
  1. Print with ostream_iterator (space separator)
  2. Sort a copy and print
  3. Copy sorted to set<int> and print size (no duplicates)
  4. add duplicate 5,5,5 then copy to set — size stays same

Expected output:
  original: 5 3 8 1 9 2 7 4 6
  sorted: 1 2 3 4 5 6 7 8 9
  unique count: 9
  with dupes, unique count: 9
EOF

cat << 'EOF' > subjects/lvl48.txt
=== LEVEL 48 — MOVE SEMANTICS [1/3] : Rvalue References ===
FILE: rendu/lvl48/task.cpp

Demonstrate lvalue vs rvalue:

Create class HeavyObject:
  vector<int> _data
  Constructor(int size) → fills with size numbers, prints "constructed size=N"
  Copy ctor     → prints "COPIED size=N"    (expensive!)
  Move ctor     → prints "MOVED size=N"     (cheap!)

Show the difference:
  HeavyObject a(1000000);         // constructed
  HeavyObject b = a;              // COPIED  (expensive)
  HeavyObject c = std::move(a);  // MOVED   (cheap, a is now empty)

Expected output:
  constructed size=1000000
  COPIED size=1000000
  MOVED size=1000000

Tip: Move ctor: HeavyObject(HeavyObject&& other) noexcept
     Steal: _data = std::move(other._data);
EOF

cat << 'EOF' > subjects/lvl49.txt
=== LEVEL 49 — MOVE SEMANTICS [2/3] : Move Assignment ===
FILE: rendu/lvl49/task.cpp

Extend the HeavyObject from level 48 to also have:
  Move assignment operator
  Method: int size() const

Demonstrate:
  HeavyObject a(5), b(3);
  Print: "Before move assign: b size=3"
  b = std::move(a);
  Print: "After move assign:  b size=5, a size=0"

Then in a function:
  HeavyObject make_object(int n) { return HeavyObject(n); }
  HeavyObject r = make_object(7);  // should be moved, not copied
  Print: r.size()

Expected output:
  Before move assign: b size=3
  After move assign: b size=5, a size=0
  from factory: 7
EOF

cat << 'EOF' > subjects/lvl50.txt
=== LEVEL 50 — MOVE SEMANTICS [3/3] : Perfect Forwarding ===
FILE: rendu/lvl50/task.cpp

Write a template function that perfectly forwards arguments:
  template<typename T, typename... Args>
  unique_ptr<T> make(Args&&... args) {
      return make_unique<T>(std::forward<Args>(args)...);
  }

Create class Widget:
  Widget(string name, int value) — prints "[Widget] name=N value=V"
  Destructor — prints "[Widget] ~name"

Use make<Widget>("Button", 42) instead of make_unique directly.

Also write: template<typename Func, typename... Args>
  auto call_with(Func f, Args&&... args) → calls f with perfect forwarding

Test: call_with([](int a, int b){ return a+b; }, 10, 20) = 30

Expected output:
  [Widget] name=Button value=42
  call result: 30
  [Widget] ~Button
EOF

cat << 'EOF' > subjects/lvl51.txt
=== LEVEL 51 — CONSTEXPR/AUTO [1/3] : constexpr ===
FILE: rendu/lvl51/task.cpp

Write constexpr functions (evaluated at COMPILE TIME):
  constexpr int factorial(int n)
  constexpr int fibonacci(int n)
  constexpr int power(int base, int exp)

Verify they work at compile time:
  static_assert(factorial(5) == 120, "factorial failed");
  static_assert(fibonacci(10) == 55, "fibonacci failed");
  static_assert(power(2, 10) == 1024, "power failed");

Then print:
  factorial(7) = 5040
  fibonacci(15) = 610
  power(3, 5) = 243

Expected output:
  factorial(7) = 5040
  fibonacci(15) = 610
  power(3, 5) = 243

Tip: constexpr int factorial(int n) { return n <= 1 ? 1 : n * factorial(n-1); }
EOF

cat << 'EOF' > subjects/lvl52.txt
=== LEVEL 52 — CONSTEXPR/AUTO [2/3] : auto & decltype ===
FILE: rendu/lvl52/task.cpp

Demonstrate auto type deduction:
  auto i   = 42;          print type with typeid
  auto d   = 3.14;
  auto s   = std::string("hello");
  auto v   = std::vector<int>{1,2,3};

  for (auto& x : v) { x *= 2; }  // auto in loop

Demonstrate decltype:
  int x = 5; double y = 3.14;
  decltype(x + y) result = x + y;  // should be double
  print type of result

Write a template using auto return type (C++14):
  auto add(auto a, auto b) { return a + b; }
  test with int+int and double+int

Expected output (type names may vary):
  i is int, d is double
  v after doubling: 2 4 6
  result type is double
  add(3,4) = 7
  add(3,1.5) = 4.5
EOF

cat << 'EOF' > subjects/lvl53.txt
=== LEVEL 53 — CONSTEXPR/AUTO [3/3] : if constexpr ===
FILE: rendu/lvl53/task.cpp

Write a template function using if constexpr:
  template<typename T>
  void print_info(const T& val)
    if T is integral:       print "int[N bytes]: val"
    if T is floating point: print "float[N bytes]: val"
    if T is same as string: print "string[length]: val"
    otherwise:              print "other: val"

Use: std::is_integral_v<T>, std::is_floating_point_v<T>
     std::is_same_v<T, std::string>
     sizeof(T)

Test:
  print_info(42)
  print_info(3.14f)
  print_info(3.14)
  print_info(std::string("hello"))

Expected output:
  int[4 bytes]: 42
  float[4 bytes]: 3.14
  float[8 bytes]: 3.14
  string[5]: hello
EOF

cat << 'EOF' > subjects/lvl54.txt
=== LEVEL 54 — RULE OF FIVE [1/3] : Big Three ===
FILE: rendu/lvl54/task.cpp

Create class Buffer managing heap memory:
  char* _data; size_t _size;

Implement the "Big Three":
  1. Constructor(size_t size) — new char[size](), prints "ctor size=N"
  2. Destructor              — delete[] _data, prints "dtor size=N"
  3. Copy ctor              — deep copy, prints "copy ctor"
  4. Copy assignment        — deep copy with self-check, prints "copy assign"

Test:
  Buffer a(5); a.fill('A'); a.print();
  Buffer b = a;              // copy ctor
  b.fill('B'); b.print();
  a.print();                 // a unaffected
  Buffer c(3); c = b;       // copy assign
  c.print();

Expected output:
  ctor size=5
  AAAAA
  copy ctor
  BBBBB
  AAAAA
  ctor size=3
  copy assign
  BBBBB
  dtor size=5
  dtor size=5
  dtor size=3
EOF

cat << 'EOF' > subjects/lvl55.txt
=== LEVEL 55 — RULE OF FIVE [2/3] : Move Semantics ===
FILE: rendu/lvl55/task.cpp

Extend the Buffer class from lvl54 with:
  5. Move ctor    — steal _data, prints "move ctor"
  6. Move assign  — steal _data with self-check, prints "move assign"

After move, the source should have _data=nullptr, _size=0.
Add: size_t size() const and bool valid() const (data != nullptr)

Test:
  Buffer a(5); a.fill('Z');
  Buffer b = std::move(a);   // move ctor
  Print: b.valid()=1 a.valid()=0
  Buffer c(3); c = std::move(b);  // move assign
  Print: c.valid()=1 b.valid()=0

Expected output:
  move ctor
  b valid=1 a valid=0
  move assign
  c valid=1 b valid=0
EOF

cat << 'EOF' > subjects/lvl56.txt
=== LEVEL 56 — RULE OF FIVE [3/3] : Rule of Zero ===
FILE: rendu/lvl56/task.cpp

Rule of Zero: if you use smart pointers/RAII wrappers,
you don't need to write any of the Big Five manually.

Rewrite Buffer using unique_ptr<char[]>:
  class SafeBuffer {
    unique_ptr<char[]> _data;
    size_t _size;
    // NO destructor needed — unique_ptr handles cleanup!
    // Copy is DELETED automatically (unique_ptr is not copyable)
    // Move works automatically!
  }

Test:
  SafeBuffer a(5);     fill 'X'; a.print()
  SafeBuffer b = std::move(a);  // move works
  b.print()
  // SafeBuffer c = b; // should be a compile ERROR — uncomment to verify

Expected output:
  XXXXX
  XXXXX
  (no memory leaks — destructor runs automatically)
EOF

cat << 'EOF' > subjects/lvl57.txt
=== LEVEL 57 — MODERN C++ [1/3] : structured bindings & optional ===
FILE: rendu/lvl57/task.cpp

1. Structured bindings (C++17):
   auto [a, b, c] = std::tuple(1, 3.14, std::string("hi"));
   for (const auto& [key, val] : map) { ... }

2. std::optional<T>:
   Write: optional<int> find_first_even(vector<int> v)
     returns the first even number, or nullopt if none

Test:
  auto [x, y, z] = tuple(42, 2.71, string("cpp"));
  print: x=42 y=2.71 z=cpp

  find_first_even({1,3,5,4,7}) = 4
  find_first_even({1,3,5,7,9}) = none

Expected output:
  x=42 y=2.71 z=cpp
  found: 4
  not found
EOF

cat << 'EOF' > subjects/lvl58.txt
=== LEVEL 58 — MODERN C++ [2/3] : variant & string_view ===
FILE: rendu/lvl58/task.cpp

1. std::variant<int, double, string>:
   Assign each type, use std::get<T> and std::visit

2. std::string_view — non-owning string reference:
   Write: size_t count_vowels(std::string_view sv)
   Works with both std::string and C-string without copying!

Test:
  variant v = 42;     visit → prints "int: 42"
  v = 3.14;           visit → prints "double: 3.14"
  v = string("hi");   visit → prints "string: hi"

  count_vowels("Hello World") = 3
  count_vowels(string("Miles")) = 2

Expected output:
  int: 42
  double: 3.14
  string: hi
  vowels in "Hello World" = 3
  vowels in "Miles" = 2
EOF

cat << 'EOF' > subjects/lvl59.txt
=== LEVEL 59 — MODERN C++ [3/3] *** FINAL BOSS *** ===
=== Event System — Everything Combined                ===
FILE: rendu/lvl59/task.cpp

Build a type-safe event system using:
  templates, lambdas, unordered_map, vector, function, any modern C++ feature

  class EventBus {
    unordered_map<string, vector<function<void(const string&)>>> _handlers;
  public:
    void subscribe(string event, function<void(const string&)> handler)
    void emit(string event, string data)
    void unsubscribeAll(string event)
  }

Use it:
  bus.subscribe("login",  [](const string& user){ print "Login: user" })
  bus.subscribe("login",  [](const string& user){ print "Log: user logged in" })
  bus.subscribe("logout", [](const string& user){ print "Logout: user" })

  bus.emit("login",  "Miles3103")   // both handlers fire
  bus.emit("logout", "Alice")
  bus.emit("login",  "Bob")
  bus.unsubscribeAll("login")
  bus.emit("login", "Charlie")      // no handlers — silent

Expected output:
  Login: Miles3103
  Log: Miles3103 logged in
  Logout: Alice
  Login: Bob
  Log: Bob logged in

  You have mastered C++. Welcome to the next level.
EOF

}
generate_subjects

# ══════════════════════════════════════════════════════════════════
#  TOPIC MAP & HINTS
# ══════════════════════════════════════════════════════════════════
get_topic() {
    case $(( $1 / 3 )) in
        0)  echo "C++ Intro/IO" ;;
        1)  echo "References" ;;
        2)  echo "Functions" ;;
        3)  echo "Strings" ;;
        4)  echo "Classes" ;;
        5)  echo "Constructors" ;;
        6)  echo "Operator Overloading" ;;
        7)  echo "Inheritance" ;;
        8)  echo "Polymorphism" ;;
        9)  echo "Templates" ;;
        10) echo "STL Vector" ;;
        11) echo "STL Map/Set" ;;
        12) echo "Exceptions" ;;
        13) echo "Smart Pointers" ;;
        14) echo "Lambdas" ;;
        15) echo "Iterators" ;;
        16) echo "Move Semantics" ;;
        17) echo "constexpr/auto" ;;
        18) echo "Rule of Five" ;;
        19) echo "Modern C++" ;;
    esac
}

get_subtask() { echo "$(( $1 % 3 + 1 ))/3"; }

# ══════════════════════════════════════════════════════════════════
#  GRADER
# ══════════════════════════════════════════════════════════════════
grade_me() {
    LEVEL=$(cat .level)
    TASK_DIR="rendu/lvl$LEVEL"
    TRACE="traces/trace_lvl$LEVEL.txt"
    mkdir -p "$TASK_DIR"

    echo ""
    echo "+----------------------------------------------------------+"
    printf "| Grading Level %-3d | Topic: %-28s |\n" $LEVEL "$(get_topic $LEVEL)"
    echo "+----------------------------------------------------------+"

    FILE="$TASK_DIR/task.cpp"
    if [ ! -f "$FILE" ]; then
        echo "ERROR: $FILE not found."
        echo "Create your file there and run grademe again."
        return 1
    fi

    $CXX $CXXFLAGS "$FILE" -o eval_bin -lm 2>"$TRACE"
    if [ $? -ne 0 ]; then
        echo "COMPILE ERROR — check: $TRACE"
        cat "$TRACE"
        return 1
    fi

    PASS=0
    OUTPUT=$(./eval_bin 2>/dev/null)

    case $LEVEL in
        0)  [[ "$OUTPUT" == "Hello, C++ World!" ]] && PASS=1 ;;
        1)  echo "$OUTPUT" | grep -q "Welcome to the Academy" &&
            echo "$OUTPUT" | grep -q "Level: 42" && PASS=1 ;;
        2)  echo "$OUTPUT" | grep -q "Alice" &&
            echo "$OUTPUT" | grep -q "95" &&
            echo "$OUTPUT" | grep -q "Miles3103" && PASS=1 ;;
        3)  echo "$OUTPUT" | grep -q "x = 10" &&
            echo "$OUTPUT" | grep -q "Same address: yes" &&
            echo "$OUTPUT" | grep -q "After ref = 99: x = 99" && PASS=1 ;;
        4)  echo "$OUTPUT" | grep -q "Before: 5" &&
            echo "$OUTPUT" | grep -q "After by_value: 5" &&
            echo "$OUTPUT" | grep -q "After by_reference: 10" && PASS=1 ;;
        5)  echo "$OUTPUT" | grep -q "Miles3103 uses C++" &&
            echo "$OUTPUT" | grep -q "'l' in \"Hello World\" = 3" && PASS=1 ;;
        6)  echo "$OUTPUT" | grep -q "int: 42" &&
            echo "$OUTPUT" | grep -q "double: 3.14" &&
            echo "$OUTPUT" | grep -q "string: hello" && PASS=1 ;;
        7)  echo "$OUTPUT" | grep -q "Hello, Miles3103!" &&
            echo "$OUTPUT" | grep -q "Welcome, Miles3103!" &&
            echo "$OUTPUT" | grep -q "Hi, Miles3103." && PASS=1 ;;
        8)  echo "$OUTPUT" | grep -q "ft_max(3, 7) = 7" &&
            echo "$OUTPUT" | grep -q "ft_max(3.14, 2.71) = 3.14" &&
            echo "$OUTPUT" | grep -q "Before swap: a=5 b=9" &&
            echo "$OUTPUT" | grep -q "After swap:  a=9 b=5" && PASS=1 ;;
        9)  echo "$OUTPUT" | grep -q "length = 17" &&
            echo "$OUTPUT" | grep -q "\[0\] = H" &&
            echo "$OUTPUT" | grep -q "Hello, Miles3103! Learning C++" && PASS=1 ;;
        10) echo "$OUTPUT" | grep -q "racecar: is palindrome" &&
            echo "$OUTPUT" | grep -q "hello: not palindrome" &&
            echo "$OUTPUT" | grep -q "3013seliM" && PASS=1 ;;
        11) echo "$OUTPUT" | grep -q "HELLO WORLD" &&
            echo "$OUTPUT" | grep -qx "3" &&
            echo "$OUTPUT" | grep -q "hell0 w0rld" && PASS=1 ;;
        12) echo "$OUTPUT" | grep -q "Rectangle(4x6)" &&
            echo "$OUTPUT" | grep -q "area=24" &&
            echo "$OUTPUT" | grep -q "perimeter=20" && PASS=1 ;;
        13) echo "$OUTPUT" | grep -q "\[Miles3103\] balance: \$300" &&
            echo "$OUTPUT" | grep -q "Deposit 500: ok" &&
            echo "$OUTPUT" | grep -q "Withdraw 400: failed" && PASS=1 ;;
        14) echo "$OUTPUT" | grep -q "Counter\[value=2\]" &&
            echo "$OUTPUT" | grep -q "Counter\[value=10\]" &&
            echo "$OUTPUT" | grep -q "Total counters created: 3" && PASS=1 ;;
        15) echo "$OUTPUT" | grep -q "(0, 0)" &&
            echo "$OUTPUT" | grep -q "(3, 4)" &&
            echo "$OUTPUT" | grep -q "distance = 5" && PASS=1 ;;
        16) echo "$OUTPUT" | grep -q "acquired: FileHandle" &&
            echo "$OUTPUT" | grep -q "acquired: NetworkConn" &&
            echo "$OUTPUT" | grep -q "released: NetworkConn" &&
            echo "$OUTPUT" | grep -q "released: FileHandle" && PASS=1 ;;
        17) echo "$OUTPUT" | grep -q "Student\[id=42 name=Miles3103 gpa=0\]" &&
            echo "$OUTPUT" | grep -q "gpa=1.8" && PASS=1 ;;
        18) echo "$OUTPUT" | grep -q "(4, 6)" &&
            echo "$OUTPUT" | grep -q "(2, 2)" &&
            echo "$OUTPUT" | grep -q "(6, 8)" && PASS=1 ;;
        19) echo "$OUTPUT" | grep -q "0°C" &&
            echo "$OUTPUT" | grep -q "37°C" &&
            echo "$OUTPUT" | grep -q "100°C" &&
            echo "$OUTPUT" | grep -q "0°C == 0°C: 1" && PASS=1 ;;
        20) echo "$OUTPUT" | grep -q "0 1 2 3 4" &&
            echo "$OUTPUT" | grep -q "99 1 2 3 4" && PASS=1 ;;
        21) echo "$OUTPUT" | grep -q "Rex says: Woof!" &&
            echo "$OUTPUT" | grep -q "Rex fetches the ball!" &&
            echo "$OUTPUT" | grep -q "Whiskers says: Meow!" && PASS=1 ;;
        22) echo "$OUTPUT" | grep -q "Circle: area=78" &&
            echo "$OUTPUT" | grep -q "Rectangle(4x6): area=24" && PASS=1 ;;
        23) echo "$OUTPUT" | grep -q "Duck is flying" &&
            echo "$OUTPUT" | grep -q "Duck is swimming" &&
            echo "$OUTPUT" | grep -q "Fish is swimming" && PASS=1 ;;
        24) echo "$OUTPUT" | grep -q "Rex: Woof!" &&
            echo "$OUTPUT" | grep -q "Mia: Meow!" &&
            echo "$OUTPUT" | grep -q "Tweet: Tweet!" && PASS=1 ;;
        25) echo "$OUTPUT" | grep -q "Fetched!" &&
            echo "$OUTPUT" | grep -q "Not a dog" && PASS=1 ;;
        26) echo "$OUTPUT" | grep -q "Circle: area=78" &&
            echo "$OUTPUT" | grep -q "Rectangle: area=24" &&
            echo "$OUTPUT" | grep -q "Triangle: area=6" && PASS=1 ;;
        27) echo "$OUTPUT" | grep -q "min(3, 7) = 3" &&
            echo "$OUTPUT" | grep -q "max(3.14, 2.71) = 3.14" &&
            echo "$OUTPUT" | grep -q "clamp(15, 0, 10) = 10" && PASS=1 ;;
        28) echo "$OUTPUT" | grep -q "peek = 30" &&
            echo "$OUTPUT" | grep -q "pop = 30" &&
            echo "$OUTPUT" | grep -q "size = 2" &&
            echo "$OUTPUT" | grep -q "c b a" && PASS=1 ;;
        29) echo "$OUTPUT" | grep -q "value: 42" &&
            echo "$OUTPUT" | grep -q "bool: true" &&
            echo "$OUTPUT" | grep -q "bool: false" &&
            echo "$OUTPUT" | grep -q "string\[5\]: hello" &&
            echo "$OUTPUT" | grep -q "char 'A' = ASCII 65" && PASS=1 ;;
        30) echo "$OUTPUT" | grep -q "size=9" &&
            echo "$OUTPUT" | grep -q "1 2 3 4 5 6 7 8 9" &&
            echo "$OUTPUT" | grep -q "found 7 at index" && PASS=1 ;;
        31) echo "$OUTPUT" | grep -q "evens: 5" &&
            echo "$OUTPUT" | grep -q "any > 8: yes" &&
            echo "$OUTPUT" | grep -q "sum: 55" &&
            echo "$OUTPUT" | grep -q "squares: 1 4 9" && PASS=1 ;;
        32) echo "$OUTPUT" | grep -q "Alice Bob Charlie Diana" &&
            echo "$OUTPUT" | grep -q "Charlie Alice Diana Bob" &&
            echo "$OUTPUT" | grep -q "Bob Diana Alice Charlie" && PASS=1 ;;
        33) echo "$OUTPUT" | grep -q "the: 3" &&
            echo "$OUTPUT" | grep -q "cat: 2" &&
            echo "$OUTPUT" | grep -q "Most frequent: the" && PASS=1 ;;
        34) echo "$OUTPUT" | grep -q "intersection: 1 3 5 7 9" &&
            echo "$OUTPUT" | grep -q "difference: 2 4" && PASS=1 ;;
        35) echo "$OUTPUT" | grep -q "Bob: 555-5678" &&
            echo "$OUTPUT" | grep -q "Diana: not found" &&
            echo "$OUTPUT" | grep -q "Alice: 555-9999" && PASS=1 ;;
        36) echo "$OUTPUT" | grep -qx "5" &&
            echo "$OUTPUT" | grep -q "caught: division by zero" &&
            echo "$OUTPUT" | grep -q "caught: index 5 out of range" && PASS=1 ;;
        37) echo "$OUTPUT" | grep -q "Alice: 95" &&
            echo "$OUTPUT" | grep -q "NotFoundError \[404\]" &&
            echo "$OUTPUT" | grep -q "ValidationError \[400\]" && PASS=1 ;;
        38) echo "$OUTPUT" | grep -q "acquired: res1" &&
            echo "$OUTPUT" | grep -q "released: res1" &&
            echo "$OUTPUT" | grep -q "caught error" &&
            echo "$OUTPUT" | grep -q "main continues" && PASS=1 ;;
        39) echo "$OUTPUT" | grep -q "created: Phone" &&
            echo "$OUTPUT" | grep -q "null after move" &&
            echo "$OUTPUT" | grep -q "destroyed: Phone" && PASS=1 ;;
        40) echo "$OUTPUT" | grep -q "ref count: 1" &&
            echo "$OUTPUT" | grep -q "ref count: 4" &&
            echo "$OUTPUT" | grep -q "destroyed: DB" && PASS=1 ;;
        41) echo "$OUTPUT" | grep -q "opened: data.txt" &&
            echo "$OUTPUT" | grep -q "name: data.txt" &&
            echo "$OUTPUT" | grep -q "closed: data.txt" && PASS=1 ;;
        42) echo "$OUTPUT" | grep -q "Hello from lambda" &&
            echo "$OUTPUT" | grep -q "add(3,4) = 7" &&
            echo "$OUTPUT" | grep -q "cnt = 3" && PASS=1 ;;
        43) echo "$OUTPUT" | grep -q "date apple banana cherry elderberry" &&
            echo "$OUTPUT" | grep -q "banana cherry elderberry" && PASS=1 ;;
        44) echo "$OUTPUT" | grep -q "add5(3) = 8" &&
            echo "$OUTPUT" | grep -q "add10(7) = 17" &&
            echo "$OUTPUT" | grep -q "apply_twice(add5, 0) = 10" && PASS=1 ;;
        45) echo "$OUTPUT" | grep -q "forward: 10 20 30 40 50" &&
            echo "$OUTPUT" | grep -q "reverse: 50 40 30 20 10" &&
            echo "$OUTPUT" | grep -q "after erasing 30: 10 20 40 50" && PASS=1 ;;
        46) echo "$OUTPUT" | grep -q "1 2 3 4 5" &&
            echo "$OUTPUT" | grep -q "sum(1..10) = 55" && PASS=1 ;;
        47) echo "$OUTPUT" | grep -q "original: 5 3 8 1 9 2 7 4 6" &&
            echo "$OUTPUT" | grep -q "sorted: 1 2 3 4 5 6 7 8 9" &&
            echo "$OUTPUT" | grep -q "unique count: 9" && PASS=1 ;;
        48) echo "$OUTPUT" | grep -q "constructed size=1000000" &&
            echo "$OUTPUT" | grep -q "COPIED size=1000000" &&
            echo "$OUTPUT" | grep -q "MOVED size=1000000" && PASS=1 ;;
        49) echo "$OUTPUT" | grep -q "b size=3" &&
            echo "$OUTPUT" | grep -q "b size=5" &&
            echo "$OUTPUT" | grep -q "a size=0" &&
            echo "$OUTPUT" | grep -q "from factory: 7" && PASS=1 ;;
        50) echo "$OUTPUT" | grep -q "name=Button value=42" &&
            echo "$OUTPUT" | grep -q "call result: 30" && PASS=1 ;;
        51) echo "$OUTPUT" | grep -q "factorial(7) = 5040" &&
            echo "$OUTPUT" | grep -q "fibonacci(15) = 610" &&
            echo "$OUTPUT" | grep -q "power(3, 5) = 243" && PASS=1 ;;
        52) echo "$OUTPUT" | grep -q "v after doubling: 2 4 6" &&
            echo "$OUTPUT" | grep -q "add(3,4) = 7" &&
            echo "$OUTPUT" | grep -q "add(3,1.5) = 4.5" && PASS=1 ;;
        53) echo "$OUTPUT" | grep -q "int\[4 bytes\]: 42" &&
            echo "$OUTPUT" | grep -q "string\[5\]: hello" && PASS=1 ;;
        54) echo "$OUTPUT" | grep -q "AAAAA" &&
            echo "$OUTPUT" | grep -q "BBBBB" &&
            echo "$OUTPUT" | grep -q "copy ctor" &&
            echo "$OUTPUT" | grep -q "copy assign" && PASS=1 ;;
        55) echo "$OUTPUT" | grep -q "move ctor" &&
            echo "$OUTPUT" | grep -q "b valid=1 a valid=0" &&
            echo "$OUTPUT" | grep -q "c valid=1 b valid=0" && PASS=1 ;;
        56) echo "$OUTPUT" | grep -q "XXXXX" &&
            LINES=$(echo "$OUTPUT" | grep -c "XXXXX")
            [ "$LINES" -ge 2 ] && PASS=1 ;;
        57) echo "$OUTPUT" | grep -q "x=42" &&
            echo "$OUTPUT" | grep -q "found: 4" &&
            echo "$OUTPUT" | grep -q "not found" && PASS=1 ;;
        58) echo "$OUTPUT" | grep -q "int: 42" &&
            echo "$OUTPUT" | grep -q "string: hi" &&
            echo "$OUTPUT" | grep -q "vowels in \"Hello World\" = 3" && PASS=1 ;;
        59) echo "$OUTPUT" | grep -q "Login: Miles3103" &&
            echo "$OUTPUT" | grep -q "Miles3103 logged in" &&
            echo "$OUTPUT" | grep -q "Logout: Alice" &&
            echo "$OUTPUT" | grep -q "Login: Bob" &&
            ! echo "$OUTPUT" | grep -q "Login: Charlie" && PASS=1 ;;
    esac

    rm -f eval_bin

    if [ $PASS -eq 1 ]; then
        echo ""
        echo "  ✓ ✓ ✓  LEVEL $LEVEL PASSED!  ✓ ✓ ✓"
        echo ""
        NEXT=$(( LEVEL + 1 ))
        if [ $NEXT -gt $MAX_LEVEL ]; then
            echo "╔══════════════════════════════════════════════╗"
            echo "║  ALL 60 LEVELS COMPLETE. YOU KNOW C++.      ║"
            echo "║  You are ready for real C++ projects.        ║"
            echo "╚══════════════════════════════════════════════╝"
        else
            echo $NEXT > .level
            echo "  Advancing to Level $NEXT: $(get_topic $NEXT)"
            echo ""
            cat subjects/lvl$NEXT.txt
        fi
    else
        echo ""
        echo "  ✗  WRONG OUTPUT — Level $LEVEL not passed."
        echo "  Expected output is in the subject file."
        echo "  Your output was:"
        echo "$OUTPUT" | head -10
        echo ""
        echo "  Check trace: $TRACE"
    fi
}

# ══════════════════════════════════════════════════════════════════
#  PROGRESS BAR
# ══════════════════════════════════════════════════════════════════
show_progress() {
    LEVEL=$(cat .level)
    TOTAL=60
    FILLED=$LEVEL
    EMPTY=$(( TOTAL - FILLED ))
    BAR=""
    for i in $(seq 1 $FILLED); do BAR="${BAR}█"; done
    for i in $(seq 1 $EMPTY);  do BAR="${BAR}░"; done
    PCT=$(( LEVEL * 100 / TOTAL ))
    echo ""
    echo "  Progress: [$BAR] $LEVEL/$TOTAL ($PCT%)"
    echo "  Topic: $(get_topic $LEVEL) [$(get_subtask $LEVEL)]"
    echo ""
}

# ══════════════════════════════════════════════════════════════════
#  MAIN LOOP
# ══════════════════════════════════════════════════════════════════
LEVEL=$(cat .level)

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   Miles3103 — C++ Mastery Exam v1.0             ║"
echo "║   60 Levels | 20 Topics | 3 Tasks Each          ║"
echo "╚══════════════════════════════════════════════════╝"
show_progress
cat subjects/lvl$LEVEL.txt

echo ""
echo "Commands: grademe | skip | hint | reset | exit"
echo ""

while true; do
    printf "cpp-exam[lvl%d]> " $(cat .level)
    read CMD

    case "$CMD" in
        grademe)
            grade_me ;;
        skip)
            LEVEL=$(cat .level)
            if [ $LEVEL -lt $MAX_LEVEL ]; then
                NEXT=$(( LEVEL + 1 ))
                echo $NEXT > .level
                echo "Skipped to level $NEXT"
                show_progress
                cat subjects/lvl$NEXT.txt
            else
                echo "Already at final level."
            fi ;;
        hint)
            LEVEL=$(cat .level)
            echo "=== HINT for Level $LEVEL ==="
            grep -A2 "Tip:" subjects/lvl$LEVEL.txt || echo "No hint available." ;;
        reset)
            echo 0 > .level
            echo "Reset to level 0."
            cat subjects/lvl0.txt ;;
        exit|quit|q)
            echo "Progress saved at level $(cat .level). See you next time!"
            break ;;
        "")
            ;;
        *)
            echo "Unknown command. Use: grademe | skip | hint | reset | exit" ;;
    esac
done
