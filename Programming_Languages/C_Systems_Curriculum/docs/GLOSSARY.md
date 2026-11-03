# C Glossary (plain English)

Look up any term you meet. The last column says where it's taught.

| Term | Plain-English meaning | Lesson |
|---|---|---|
| **Address** | The number that says where a byte lives in memory | 6 |
| **Alignment** | Rule that a value sits at an address divisible by its size (4-byte int at multiples of 4) | 8 |
| **ASan (AddressSanitizer)** | Compiler feature that crashes your program with a clear report on memory errors | 9, 12 |
| **Assembler / assembly** | Human-readable machine instructions / the tool that turns them into machine code | 1 |
| **Buffer** | A block of memory used to hold data (an array of bytes) | 5 |
| **Buffer overflow** | Writing past the end of a buffer into neighbouring memory | 5 |
| **Compiler** | Program that translates C source into machine code (`gcc`, `clang`) | 1 |
| **Dangling pointer** | A pointer to memory that has been freed or has gone out of scope | 6 |
| **Declaration** | Announces a name and type (`int f(int);`). Can repeat | 11 |
| **Definition** | Actually creates the function/variable. Exactly once | 11 |
| **Decay** | An array turning into a pointer to its first element when passed around | 5 |
| **Dereference** | Following a pointer to the value it points at (`*p`) | 6 |
| **Endianness** | Byte order of multi-byte numbers: little-endian stores the least significant byte first | 8 |
| **`errno`** | Global error code set by failing library calls | 10 |
| **Exit status** | The number `main` returns; 0 = success. Shows up as `$?` | 1, 10 |
| **File descriptor** | A small integer the OS uses to name an open file or socket | 10, P4 |
| **Fragmentation** | Free memory split into pieces too small to use | P5 |
| **gdb** | The GNU debugger: pause, step through and inspect a running program | 12 |
| **Header (`.h`)** | File of declarations shared between source files | 11 |
| **Heap** | Memory you allocate manually with `malloc` and release with `free` | 9 |
| **Implicit declaration** | Calling a function the compiler hasn't seen declared; almost always a bug | 1 |
| **Include guard** | `#ifndef`/`#define`/`#endif` wrapper preventing double inclusion | 11 |
| **Linker** | Joins object files and libraries into one program | 1, 11 |
| **Leak** | Heap memory that is never freed and can no longer be reached | 9 |
| **Macro** | Text substitution done by the preprocessor (`#define MAX 10`) | 2 |
| **`malloc` / `free`** | Request / return a block of heap memory | 9 |
| **Memory-safe** | A language that prevents out-of-bounds and use-after-free. C is *not* | 12 |
| **NUL (`'\0'`)** | The zero byte that ends a C string | 5 |
| **`NULL`** | The pointer value meaning "points at nothing" | 6 |
| **Object file (`.o`)** | One compiled `.c` file, not yet linked | 1, 11 |
| **Opaque type** | A type whose fields are hidden from users (header only declares it) | 11 |
| **Out-parameter** | A pointer parameter a function writes a result through | 6 |
| **Overflow (integer)** | A result too big for its type. Unsigned wraps; signed is undefined | 2 |
| **Padding** | Unused bytes the compiler inserts inside structs for alignment | 8 |
| **Pass by value** | Function arguments are copies of the caller's values | 4 |
| **Pointer** | A variable that holds an address | 6 |
| **Preprocessor** | First compile stage: handles `#include` and `#define` | 1 |
| **Prototype** | A function declaration, usually in a header | 4, 11 |
| **Segmentation fault** | Crash caused by touching memory you're not allowed to | 6 |
| **Stack** | Fast automatic memory for locals, organised in per-call frames | 4, 9 |
| **Stack frame** | The slice of stack belonging to one function call | 4 |
| **`static`** | Persist for the whole program and/or be private to the file | 4 |
| **String** | A `char` array ending in `'\0'` | 5 |
| **Struct** | A bundle of named fields | 8 |
| **Translation unit** | One `.c` file after preprocessing; compiled on its own | 11 |
| **`typedef`** | Gives an existing type a new name | 8 |
| **UB (undefined behavior)** | Code the C standard assigns no meaning; anything can happen | 12 |
| **UBSan** | Sanitizer that detects many kinds of UB at runtime | 12 |
| **Union** | Several members sharing one memory slot | 8 |
| **Use after free** | Touching memory after `free` | 9 |
| **valgrind** | Tool that runs your program and reports memory errors and leaks | 9, 12 |
| **Wild pointer** | An uninitialized pointer holding a random address | 6 |
