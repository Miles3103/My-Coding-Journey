#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct { double x, y; } Point;
typedef struct { Point top_left; double w, h; } Rect;
typedef enum { RED, GREEN, BLUE } Color;
typedef struct { const char *name; int age; } Person;

typedef struct { char a; int b; char c; } Wasteful;     /* padding between fields */
typedef struct { int b; char a; char c; } Reordered;    /* same fields, less padding */
typedef union { uint32_t u; uint8_t bytes[4]; } Word;   /* all members share ONE memory slot */

static double area(const Rect *r) { return r->w * r->h; }          /* const pointer: read-only, cheap */
static void   move(Point *p, double dx, double dy) { p->x += dx; p->y += dy; }

static const char *color_name(Color c)
{
    switch (c) {
    case RED:   return "red";
    case GREEN: return "green";
    case BLUE:  return "blue";
    }
    return "?";
}

static int by_age(const void *a, const void *b)
{
    const Person *x = a, *y = b;
    return (x->age > y->age) - (x->age < y->age);
}

int main(void)
{
    Rect r = { .top_left = {1.0, 2.0}, .w = 3.0, .h = 4.0 };   /* designated initializers */
    printf("area = %.1f\n", area(&r));
    move(&r.top_left, 10, 10);
    printf("top_left now (%.1f, %.1f)\n", r.top_left.x, r.top_left.y);

    Color c = GREEN;
    printf("color %d is %s\n", c, color_name(c));

    printf("\nsizeof(Wasteful)=%zu  sizeof(Reordered)=%zu  (same data, different order)\n",
           sizeof(Wasteful), sizeof(Reordered));
    printf("Wasteful offsets: a=%zu b=%zu c=%zu\n",
           offsetof(Wasteful, a), offsetof(Wasteful, b), offsetof(Wasteful, c));

    Word w = { .u = 0x01020304 };
    printf("\n0x01020304 stored as bytes: %u %u %u %u  (", w.bytes[0], w.bytes[1], w.bytes[2], w.bytes[3]);
    printf("%s-endian)\n", w.bytes[0] == 4 ? "little" : "big");

    Person people[] = { {"Ada", 36}, {"Linus", 28}, {"Grace", 45} };
    qsort(people, 3, sizeof people[0], by_age);
    printf("\nsorted by age:\n");
    for (size_t i = 0; i < 3; i++) printf("  %-6s %d\n", people[i].name, people[i].age);
    return 0;
}
