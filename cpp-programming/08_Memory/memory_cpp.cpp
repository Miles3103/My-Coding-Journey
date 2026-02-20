// ============================================================================
//  Project : Memory Management in C++
//  Author  : Miles3103
//  Topic   : Memory — RAII, smart pointers, rule of five, move semantics
// ============================================================================

/*
** MEMORY IN C++ — MUCH SAFER THAN C IF YOU KNOW THE RULES
**
** C way:  malloc() → use → free()   (manual, error-prone)
** C++ way: RAII — Resource Acquisition Is Initialization
**
** RAII PRINCIPLE:
**   Acquire resource in constructor.
**   Release resource in destructor.
**   The object's lifetime manages the resource's lifetime.
**   When the object goes out of scope → destructor → resource freed.
**   You can NEVER forget to free — it's automatic.
**
** SMART POINTERS (C++11) — own resources automatically:
**
**   unique_ptr<T>  → sole ownership. Cannot be copied. Can be moved.
**                    Use for MOST cases. Zero overhead vs raw pointer.
**
**   shared_ptr<T>  → shared ownership via reference counting.
**                    Last owner to die frees the resource.
**                    Slight overhead. Use when shared ownership is needed.
**
**   weak_ptr<T>    → non-owning reference to shared_ptr.
**                    Breaks circular references. Check if alive before use.
**
** RULE OF FIVE (if you define any one, define all five):
**   1. Destructor
**   2. Copy Constructor
**   3. Copy Assignment Operator
**   4. Move Constructor       (C++11)
**   5. Move Assignment Operator (C++11)
**
** If your class manages a resource (heap memory, file, socket),
** you MUST implement the Rule of Five correctly.
** Otherwise use Rule of Zero: let compiler generate all — use smart pointers.
*/

#include <iostream>
#include <memory>      // unique_ptr, shared_ptr, weak_ptr, make_unique, make_shared
#include <string>
#include <vector>
#include <utility>     // std::move

// ============================================================================
//  RULE OF FIVE — class that owns heap memory
// ============================================================================

class Buffer
{
private:
    char*   _data;
    size_t  _size;

public:
    // 1. Constructor
    explicit Buffer(size_t size) : _data(new char[size]()), _size(size)
    {
        std::cout << "[Buffer] ctor: size=" << _size << '\n';
    }

    // 2. Destructor
    ~Buffer()
    {
        std::cout << "[Buffer] dtor: size=" << _size << '\n';
        delete[] _data;  // [] because it was allocated with new[]
    }

    // 3. Copy Constructor — deep copy
    Buffer(const Buffer& other) : _data(new char[other._size]()), _size(other._size)
    {
        std::cout << "[Buffer] copy ctor\n";
        for (size_t i = 0; i < _size; i++)
            _data[i] = other._data[i];
    }

    // 4. Copy Assignment — deep copy with self-assignment check
    Buffer& operator=(const Buffer& other)
    {
        std::cout << "[Buffer] copy assign\n";
        if (this == &other) return *this;   // self-assignment check!
        delete[] _data;
        _data = new char[other._size]();
        _size = other._size;
        for (size_t i = 0; i < _size; i++)
            _data[i] = other._data[i];
        return *this;
    }

    // 5. Move Constructor — steal from rvalue (no copy, just transfer)
    Buffer(Buffer&& other) noexcept : _data(other._data), _size(other._size)
    {
        std::cout << "[Buffer] move ctor\n";
        other._data = nullptr;  // leave other in valid but empty state
        other._size = 0;
    }

    // 6. Move Assignment
    Buffer& operator=(Buffer&& other) noexcept
    {
        std::cout << "[Buffer] move assign\n";
        if (this == &other) return *this;
        delete[] _data;
        _data = other._data;
        _size = other._size;
        other._data = nullptr;
        other._size = 0;
        return *this;
    }

    void    fill(char c) { for (size_t i = 0; i < _size; i++) _data[i] = c; }
    void    print() const
    {
        std::cout << "Buffer[" << _size << "]: ";
        for (size_t i = 0; i < _size; i++) std::cout << _data[i];
        std::cout << '\n';
    }
    size_t  size() const { return _size; }
};

// ============================================================================
//  UNIQUE_PTR — sole ownership
// ============================================================================

void    demo_unique_ptr()
{
    std::cout << "\n=== unique_ptr (sole ownership) ===\n";

    // make_unique is preferred over new (exception-safe)
    auto    p1 = std::make_unique<Buffer>(5);
    p1->fill('A');
    p1->print();

    // CANNOT copy unique_ptr:
    // auto p2 = p1;  // ERROR: copy is deleted

    // CAN move unique_ptr:
    auto    p2 = std::move(p1);     // p1 is now null
    std::cout << "After move: p1=" << (p1 ? "valid" : "null") << '\n';
    p2->print();

    // unique_ptr in a function — auto freed when function returns
    {
        auto    local = std::make_unique<Buffer>(3);
        local->fill('X');
        local->print();
    }   // Buffer freed here automatically
    std::cout << "local Buffer was freed automatically\n";
}

// ============================================================================
//  SHARED_PTR — reference-counted shared ownership
// ============================================================================

void    demo_shared_ptr()
{
    std::cout << "\n=== shared_ptr (shared ownership) ===\n";

    auto    p1 = std::make_shared<Buffer>(4);
    p1->fill('B');

    std::cout << "ref count: " << p1.use_count() << '\n';  // 1

    {
        auto    p2 = p1;    // shared ownership — ref count goes to 2
        std::cout << "ref count after p2=p1: " << p1.use_count() << '\n';  // 2

        auto    p3 = p2;
        std::cout << "ref count after p3=p2: " << p1.use_count() << '\n';  // 3

        p2->print();

    }   // p2 and p3 destroyed — ref count back to 1

    std::cout << "ref count after scope: " << p1.use_count() << '\n';  // 1

}   // p1 destroyed — ref count = 0 — Buffer freed

// ============================================================================
//  WEAK_PTR — break circular references
// ============================================================================

struct Node {
    int                     value;
    std::shared_ptr<Node>   next;
    // If we used shared_ptr here AND next points back, we'd have a cycle!
    // weak_ptr<Node> prev;  // Use weak_ptr for back-references
    explicit Node(int v) : value(v) { std::cout << "[Node] ctor " << v << '\n'; }
    ~Node() { std::cout << "[Node] dtor " << value << '\n'; }
};

void    demo_weak_ptr()
{
    std::cout << "\n=== weak_ptr (non-owning reference) ===\n";

    auto    sp = std::make_shared<int>(42);
    std::weak_ptr<int>  wp = sp;    // does NOT increase ref count

    std::cout << "shared ref count: " << sp.use_count() << '\n';  // still 1

    // Must lock() to use — get a temporary shared_ptr
    if (auto temp = wp.lock())
        std::cout << "weak_ptr value: " << *temp << '\n';

    sp.reset();  // destroy the shared_ptr

    // After shared_ptr is gone, weak_ptr is expired
    if (wp.expired())
        std::cout << "weak_ptr is expired (object was freed)\n";
}

// ============================================================================
//  RAII IN PRACTICE — file handle wrapper
// ============================================================================

class FileHandle
{
private:
    FILE*   _file;
    std::string _name;

public:
    explicit FileHandle(const char* path, const char* mode)
        : _file(fopen(path, mode)), _name(path)
    {
        if (!_file)
            std::cout << "[FileHandle] failed to open: " << _name << '\n';
        else
            std::cout << "[FileHandle] opened: " << _name << '\n';
    }

    ~FileHandle()
    {
        if (_file)
        {
            fclose(_file);
            std::cout << "[FileHandle] closed: " << _name << '\n';
        }
    }

    // Deleted copy — file handles shouldn't be copied
    FileHandle(const FileHandle&)            = delete;
    FileHandle& operator=(const FileHandle&) = delete;

    bool    isOpen() const { return _file != nullptr; }
    FILE*   get()    const { return _file; }
};

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    std::cout << "=== Rule of Five — Buffer ===\n";
    {
        Buffer  b1(5);
        b1.fill('Z');

        Buffer  b2 = b1;            // copy constructor
        Buffer  b3 = std::move(b1); // move constructor
        std::cout << "b2: "; b2.print();
        std::cout << "b3: "; b3.print();
    }

    demo_unique_ptr();
    demo_shared_ptr();
    demo_weak_ptr();

    std::cout << "\n=== RAII FileHandle ===\n";
    {
        FileHandle  f("/tmp/test_raii.txt", "w");
        if (f.isOpen())
            fprintf(f.get(), "Hello from RAII!\n");
    }   // file closed automatically here

    return (0);
}
