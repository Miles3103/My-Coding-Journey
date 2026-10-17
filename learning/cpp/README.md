# Miles3103 — C++ Programming Journey 🚀

> **Goal:** Go from C programmer to solid C++ developer in 2 months.
> Every file explains not just *what* the code does but *why* — the mental models, the gotchas, the patterns used in real professional code.

---

## 📁 Repository Structure

```
cpp-programming/
├── 00_Intro/           ← cout vs printf, references, overloading, namespaces
├── 01_Variables_Types/ ← auto, const, constexpr, nullptr, type aliases
├── 02_Functions/       ← overloading, default params, inline, lambdas
├── 03_OOP_Classes/     ← classes, constructors, destructors, operator overloading
├── 04_Inheritance/     ← base/derived, virtual, abstract classes, override
├── 05_Polymorphism/    ← vtable, dynamic_cast, interfaces, smart ptr polymorphism
├── 06_Templates/       ← function templates, class templates, specialization
├── 07_STL/             ← vector, map, set, algorithms, iterators, lambdas
├── 08_Memory/          ← RAII, unique_ptr, shared_ptr, rule of five, move semantics
├── 09_Exceptions/      ← try/catch/throw, custom exceptions, exception safety
├── 10_Modern_Cpp/      ← C++11/14/17: lambdas, optional, variant, string_view
└── 11_Projects/        ← showcase projects combining everything
```

---

## 🔑 C vs C++ — The Key Differences

| Concept | C | C++ |
|---------|---|-----|
| Output | `printf("hello")` | `std::cout << "hello"` |
| String | `char arr[]` + `<string.h>` | `std::string` — safe, dynamic |
| Null pointer | `NULL` (just 0) | `nullptr` — type-safe |
| Error handling | return codes (-1) | exceptions (try/catch) |
| Memory | `malloc` / `free` (manual) | RAII / smart pointers (automatic) |
| Type alias | `typedef int MyInt` | `using MyInt = int` |
| Struct/data | struct (data only) | class (data + behavior + access) |
| Generics | copy-paste per type | templates — one version for all |
| Collections | arrays + manual code | STL: vector, map, set, algorithm |
| References | only pointers | references AND pointers |

---

## 🗓️ 2-Month Mastery Roadmap

### WEEK 1–2: C++ Basics (Transition from C)
**Goal:** Understand what C++ adds on top of C. Get comfortable with cout, string, references, overloading.

| Day | Focus | File |
|-----|-------|------|
| 1–2 | cout, references, namespaces, overloading | `00_Intro/` |
| 3–4 | auto, const, constexpr, nullptr, type aliases | `01_Variables_Types/` |
| 5–6 | Functions: overloading, defaults, inline | `02_Functions/` |
| 7   | Write 5 small programs using only C++ basics | Practice |

**End of week goal:** You can write any C program in C++ style. You understand references vs pointers. You use `std::string` fluently.

---

### WEEK 3–4: OOP — The Core of C++
**Goal:** Master classes. This is the most important part of C++.

| Day | Focus | File |
|-----|-------|------|
| 8–9  | Classes: constructors, destructors, methods, access | `03_OOP_Classes/` |
| 10   | Operator overloading (<<, +, ==, =) | `03_OOP_Classes/` |
| 11–12 | Inheritance: virtual, override, abstract, base ptr | `04_Inheritance/` |
| 13–14 | Polymorphism: vtable, dynamic_cast, interfaces | `05_Polymorphism/` |
| 15   | Build a class hierarchy from scratch | Practice |

**End of week goal:** You can design a class hierarchy. You understand virtual dispatch. You know when to use `virtual`, `override`, `= 0`, `= default`, `= delete`.

---

### WEEK 5–6: Templates + STL
**Goal:** Write generic code. Use the STL fluently.

| Day | Focus | File |
|-----|-------|------|
| 16–17 | Function templates, class templates, specialization | `06_Templates/` |
| 18–19 | vector, map, set — when to use which | `07_STL/` |
| 20–21 | STL algorithms: sort, find, count_if, transform | `07_STL/` |
| 22   | Iterators, range-based for, structured bindings | `07_STL/` |
| 23–24 | Build a templated container from scratch | Practice |

**End of week goal:** You can write template functions. You use vector/map/set naturally. You know at least 10 STL algorithms and when to apply them.

---

### WEEK 7–8: Modern C++ + Mastery
**Goal:** Write professional, safe, modern C++ code.

| Day | Focus | File |
|-----|-------|------|
| 25–26 | RAII, unique_ptr, shared_ptr, Rule of Five | `08_Memory/` |
| 27   | Move semantics, std::move, rvalue references | `08_Memory/` |
| 28–29 | Exceptions: try/catch, custom exceptions, safety | `09_Exceptions/` |
| 30–31 | Lambdas, optional, variant, string_view | `10_Modern_Cpp/` |
| 32–35 | Build the RPG Inventory project + extend it | `11_Projects/` |

**End of week goal:** You use smart pointers by default. You never write `new`/`delete` manually. You handle errors with exceptions. You write lambdas confidently.

---

## 🧠 Skills Checklist

After completing this roadmap:

**OOP:**
- [ ] Write a class with proper constructor, destructor, copy constructor, copy assignment
- [ ] Explain what a vtable is and how virtual dispatch works
- [ ] Design an abstract base class (interface) that multiple classes implement
- [ ] Use `dynamic_cast` to safely downcast a base pointer

**Templates:**
- [ ] Write a function template that works for any comparable type
- [ ] Write a class template (like `Stack<T>`)
- [ ] Explain the difference between template specialization and overloading

**STL:**
- [ ] Use `std::vector` as your default container
- [ ] Use `std::map` and `std::unordered_map` and know when to prefer each
- [ ] Apply `std::sort`, `std::find_if`, `std::transform`, `std::count_if`
- [ ] Write lambda comparators for sorting

**Memory:**
- [ ] Use `unique_ptr` and `make_unique` — never raw `new`
- [ ] Implement the Rule of Five for a class that owns a resource
- [ ] Explain RAII and why destructors make C++ safer than C

**Modern C++:**
- [ ] Write lambdas with capture by value and by reference
- [ ] Use `std::optional` for functions that might not return a value
- [ ] Use structured bindings `auto [a, b] = ...`

---

## 🔧 Compile Commands

```bash
# Standard compilation (always use these flags)
g++ -Wall -Wextra -Werror -std=c++17 filename.cpp -o output

# With math library
g++ -Wall -Wextra -Werror -std=c++17 filename.cpp -o output -lm

# Check for memory errors
valgrind --leak-check=full ./output

# Compile all files in a folder
for f in *.cpp; do
    g++ -Wall -Wextra -Werror -std=c++17 "$f" -o test && echo "$f: OK" && rm test
done
```

---

## 📚 Resources

- **Stroustrup** — *A Tour of C++* (short, from the creator of C++)
- **Meyers** — *Effective Modern C++* (the advanced bible)
- **cppreference.com** — the best online reference
- **learncpp.com** — best free step-by-step tutorial
- **godbolt.org** — see what your code compiles to (assembly)

---

## 💡 The 4 Pillars — Remember These

```
ENCAPSULATION  → class hides its data, exposes only what's needed
INHERITANCE    → derived class reuses and extends base class
POLYMORPHISM   → base pointer calls the right derived method (virtual)
ABSTRACTION    → pure virtual (= 0) forces subclasses to implement interface
```

---

*"C makes it easy to shoot yourself in the foot. C++ makes it harder,*
*but when you do, it blows away your whole leg."*
*— Bjarne Stroustrup (inventor of C++, joking)*

*In practice: modern C++ with smart pointers and RAII is far safer than C.*
