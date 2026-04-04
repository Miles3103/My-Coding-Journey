#!/usr/bin/env python3
"""
================================================================================
  Project : OOP — Classes & Objects
  Author  : Miles3103
  Topic   : Classes, inheritance, dunder methods, properties, dataclasses
================================================================================

PYTHON OOP vs C++ OOP:
  - No access modifiers (public/private) — convention uses _ prefix
  - _name  → "please treat as private" (nothing enforces it)
  - __name → name mangling (harder to access from outside)
  - No constructor overloading — use default args instead
  - Everything inherits from 'object' by default
  - Multiple inheritance supported
  - "Dunder" (double underscore) methods make objects behave like built-ins

DUNDER METHODS (Magic Methods):
  __init__    → constructor (called on creation)
  __str__     → str(obj) and print(obj)
  __repr__    → repr(obj) — unambiguous representation for debugging
  __len__     → len(obj)
  __add__     → obj + other
  __eq__      → obj == other
  __lt__      → obj < other  (enables sorting!)
  __getitem__ → obj[key]
  __contains__→ item in obj
  __iter__    → for x in obj
"""

from dataclasses import dataclass, field
from typing import Optional, Iterator

# ============================================================================
#  1. BASIC CLASS
# ============================================================================

print("=== Basic Class ===")

class Animal:
    """Base class for all animals."""

    # Class variable — shared across ALL instances
    species_count = 0

    def __init__(self, name: str, age: int, sound: str = "..."):
        # Instance variables — unique to each object
        self.name  = name      # public
        self.age   = age       # public
        self._sound = sound    # "private" by convention

        Animal.species_count += 1

    def speak(self) -> str:
        return f"{self.name} says: {self._sound}"

    def birthday(self) -> None:
        self.age += 1
        print(f"Happy birthday {self.name}! Now {self.age}.")

    # __str__ — for print() and str()
    def __str__(self) -> str:
        return f"{self.__class__.__name__}(name={self.name}, age={self.age})"

    # __repr__ — for debugging, should be unambiguous
    def __repr__(self) -> str:
        return f"{self.__class__.__name__}({self.name!r}, {self.age!r})"


dog = Animal("Rex", 3, "Woof!")
cat = Animal("Whiskers", 5, "Meow!")

print(dog.speak())
print(cat.speak())
print(str(dog))          # calls __str__
print(repr(dog))         # calls __repr__
dog.birthday()
print(f"Total animals: {Animal.species_count}")

# ============================================================================
#  2. INHERITANCE
# ============================================================================

print("\n=== Inheritance ===")

class Dog(Animal):
    """Dog is an Animal with extra dog-specific behavior."""

    def __init__(self, name: str, age: int, breed: str):
        super().__init__(name, age, "Woof!")   # call parent __init__
        self.breed = breed

    def fetch(self, item: str) -> str:
        return f"{self.name} fetches the {item}!"

    def __str__(self) -> str:
        return f"Dog(name={self.name}, breed={self.breed}, age={self.age})"


class Cat(Animal):
    def __init__(self, name: str, age: int, indoor: bool = True):
        super().__init__(name, age, "Meow!")
        self.indoor = indoor

    def purr(self) -> str:
        return f"{self.name} purrs..."

    def __str__(self) -> str:
        loc = "indoor" if self.indoor else "outdoor"
        return f"Cat(name={self.name}, {loc})"


rex     = Dog("Rex", 3, "Labrador")
shadow  = Cat("Shadow", 7, indoor=False)

print(rex)
print(shadow)
print(rex.speak())     # inherited from Animal
print(rex.fetch("ball"))
print(shadow.purr())

# isinstance / issubclass
print(f"\nisinstance(rex, Dog):    {isinstance(rex, Dog)}")
print(f"isinstance(rex, Animal): {isinstance(rex, Animal)}")   # True!
print(f"issubclass(Dog, Animal): {issubclass(Dog, Animal)}")

# ============================================================================
#  3. DUNDER METHODS — make your class behave like built-ins
# ============================================================================

print("\n=== Dunder Methods ===")

class Vector:
    """2D vector with full operator support."""

    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __str__(self)  -> str:  return f"({self.x}, {self.y})"
    def __repr__(self) -> str:  return f"Vector({self.x}, {self.y})"

    def __len__(self)  -> int:  return 2   # vectors have 2 components

    def __add__(self, other: "Vector") -> "Vector":
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other: "Vector") -> "Vector":
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar: float) -> "Vector":
        return Vector(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar: float) -> "Vector":
        return self.__mul__(scalar)   # supports 3 * v as well as v * 3

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Vector): return NotImplemented
        return self.x == other.x and self.y == other.y

    def __lt__(self, other: "Vector") -> bool:
        return self.magnitude() < other.magnitude()

    def __abs__(self) -> float:
        return self.magnitude()

    def __neg__(self) -> "Vector":
        return Vector(-self.x, -self.y)

    def __getitem__(self, index: int) -> float:
        if index == 0: return self.x
        if index == 1: return self.y
        raise IndexError("Vector index out of range")

    def __iter__(self) -> Iterator[float]:
        yield self.x
        yield self.y

    def magnitude(self) -> float:
        return (self.x**2 + self.y**2) ** 0.5


v1 = Vector(3, 4)
v2 = Vector(1, 2)

print(f"v1 = {v1}, v2 = {v2}")
print(f"v1 + v2 = {v1 + v2}")
print(f"v1 - v2 = {v1 - v2}")
print(f"v1 * 3  = {v1 * 3}")
print(f"3 * v1  = {3 * v1}")
print(f"v1 == v2: {v1 == v2}")
print(f"len(v1): {len(v1)}")
print(f"abs(v1): {abs(v1)}")
print(f"-v1: {-v1}")
print(f"v1[0]: {v1[0]}, v1[1]: {v1[1]}")
print(f"unpack: {[c for c in v1]}")
print(f"sorted: {sorted([v1, v2, Vector(0,0)])}")

# ============================================================================
#  4. PROPERTIES — controlled attribute access
# ============================================================================

print("\n=== Properties ===")

class Temperature:
    """Temperature with automatic unit conversion."""

    def __init__(self, celsius: float = 0):
        self._celsius = celsius   # store internally in Celsius

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError(f"Temperature below absolute zero: {value}")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5/9

    @property
    def kelvin(self) -> float:
        return self._celsius + 273.15

    def __str__(self) -> str:
        return f"{self._celsius:.1f}°C / {self.fahrenheit:.1f}°F / {self.kelvin:.1f}K"


t = Temperature(100)
print(t)
t.fahrenheit = 32    # set via setter
print(t)
t.celsius = -40      # same in both scales
print(t)

try:
    t.celsius = -300   # below absolute zero
except ValueError as e:
    print(f"ValueError: {e}")

# ============================================================================
#  5. CLASS METHODS AND STATIC METHODS
# ============================================================================

print("\n=== Class & Static Methods ===")

class Date:
    def __init__(self, day: int, month: int, year: int):
        self.day   = day
        self.month = month
        self.year  = year

    # classmethod — receives the class itself (cls), not instance (self)
    # Used as alternative constructors
    @classmethod
    def from_string(cls, date_str: str) -> "Date":
        """Create Date from 'DD-MM-YYYY' string."""
        day, month, year = map(int, date_str.split("-"))
        return cls(day, month, year)

    @classmethod
    def today(cls) -> "Date":
        import datetime
        d = datetime.date.today()
        return cls(d.day, d.month, d.year)

    # staticmethod — no self or cls — just a utility function in the namespace
    @staticmethod
    def is_leap_year(year: int) -> bool:
        return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

    def __str__(self) -> str:
        return f"{self.day:02d}/{self.month:02d}/{self.year}"


d1 = Date(20, 2, 2026)
d2 = Date.from_string("15-08-2025")
d3 = Date.today()

print(d1)
print(d2)
print(d3)
print(f"2024 leap year: {Date.is_leap_year(2024)}")
print(f"2025 leap year: {Date.is_leap_year(2025)}")

# ============================================================================
#  6. DATACLASS — automatic __init__, __str__, __eq__ and more
# ============================================================================

print("\n=== dataclass ===")

@dataclass
class Player:
    name:   str
    level:  int = 1
    score:  float = 0.0
    items:  list  = field(default_factory=list)  # mutable default

    def level_up(self) -> None:
        self.level += 1
        print(f"{self.name} leveled up to {self.level}!")

    def add_item(self, item: str) -> None:
        self.items.append(item)


p1 = Player("Miles3103", level=15, score=9850.5)
p2 = Player("Alice", level=10)

print(p1)         # auto-generated __str__
print(p2)
print(p1 == p2)   # auto-generated __eq__

p1.level_up()
p1.add_item("Sword")
p1.add_item("Shield")
print(p1)


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("_name → private by convention, __name → name mangling")
    print("super().__init__() must be called in derived __init__")
    print("Dunder methods make your class work with built-in syntax")
    print("@property → attribute with getter/setter logic")
    print("@classmethod → alternative constructors")
    print("@staticmethod → utility functions in class namespace")
    print("@dataclass → auto-generates boilerplate for data classes")
