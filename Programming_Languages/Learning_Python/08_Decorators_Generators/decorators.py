#!/usr/bin/env python3
"""
================================================================================
  Project : Decorators & Advanced Functions
  Author  : Miles3103
  Topic   : Decorators, functools, wraps, caching, timing, retry
================================================================================

DECORATORS — the most powerful and "Pythonic" pattern:
  A decorator is a function that takes a function and returns a new function.
  It lets you ADD BEHAVIOR to existing functions without modifying them.

  @decorator
  def func(): ...

  Is EXACTLY equivalent to:
  def func(): ...
  func = decorator(func)

REAL-WORLD USES:
  - Timing / profiling
  - Caching (memoization)
  - Authentication / authorization
  - Logging
  - Retry logic
  - Input validation
  - Rate limiting
"""

import time
import functools
from typing import Callable, Any

# ============================================================================
#  1. BASIC DECORATOR — understanding the pattern
# ============================================================================

print("=== Basic Decorator ===")

def my_decorator(func: Callable) -> Callable:
    """Wraps a function with before/after behavior."""
    @functools.wraps(func)   # preserves original function's metadata
    def wrapper(*args, **kwargs):
        print(f"  [Before] calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"  [After]  {func.__name__} returned {result}")
        return result
    return wrapper

@my_decorator
def add(a: int, b: int) -> int:
    """Adds two numbers."""
    return a + b

result = add(3, 4)
print(f"  result: {result}")
print(f"  function name preserved: {add.__name__}")   # 'add' not 'wrapper'

# ============================================================================
#  2. TIMING DECORATOR — measure execution time
# ============================================================================

print("\n=== Timing Decorator ===")

def timer(func: Callable) -> Callable:
    """Decorator that prints how long a function takes."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start  = time.perf_counter()
        result = func(*args, **kwargs)
        end    = time.perf_counter()
        print(f"  {func.__name__} took {(end - start)*1000:.3f}ms")
        return result
    return wrapper

@timer
def slow_sum(n: int) -> int:
    """Sum 0..n with artificial delay."""
    total = 0
    for i in range(n):
        total += i
    return total

@timer
def fast_sum(n: int) -> int:
    """Sum 0..n using formula."""
    return n * (n - 1) // 2

slow_sum(1_000_000)
fast_sum(1_000_000)

# ============================================================================
#  3. CACHE DECORATOR — memoization (remember previous results)
# ============================================================================

print("\n=== Cache / Memoization ===")

def memoize(func: Callable) -> Callable:
    """Cache function results to avoid recomputation."""
    cache = {}

    @functools.wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrapper

@memoize
@timer
def fib(n: int) -> int:
    """Fibonacci — slow without cache, fast with it."""
    if n <= 1: return n
    return fib(n - 1) + fib(n - 2)

print(f"fib(10) = {fib(10)}")
print(f"fib(10) = {fib(10)}")   # instant — from cache

# Python has a built-in cache decorator:
from functools import lru_cache

@lru_cache(maxsize=None)   # unlimited cache
def fib_builtin(n: int) -> int:
    if n <= 1: return n
    return fib_builtin(n - 1) + fib_builtin(n - 2)

print(f"fib_builtin(30) = {fib_builtin(30)}")

# ============================================================================
#  4. DECORATOR WITH ARGUMENTS — decorator factory
# ============================================================================

print("\n=== Decorator with Arguments ===")

def repeat(times: int) -> Callable:
    """Decorator factory — returns a decorator that repeats the function."""
    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for i in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name: str) -> None:
    print(f"  Hello, {name}!")

greet("Miles3103")

def validate_type(**expected_types):
    """Validates argument types at runtime."""
    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        def wrapper(**kwargs):
            for arg_name, arg_type in expected_types.items():
                if arg_name in kwargs and not isinstance(kwargs[arg_name], arg_type):
                    raise TypeError(
                        f"{arg_name} must be {arg_type.__name__}, "
                        f"got {type(kwargs[arg_name]).__name__}"
                    )
            return func(**kwargs)
        return wrapper
    return decorator

@validate_type(name=str, age=int)
def create_user(name: str, age: int) -> dict:
    return {"name": name, "age": age}

print(create_user(name="Miles3103", age=20))
try:
    create_user(name="Miles3103", age="twenty")
except TypeError as e:
    print(f"TypeError: {e}")

# ============================================================================
#  5. RETRY DECORATOR — handle transient failures
# ============================================================================

print("\n=== Retry Decorator ===")

import random

def retry(max_attempts: int = 3, delay: float = 0.1, exceptions=(Exception,)):
    """Retry a function on failure up to max_attempts times."""
    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_error = None
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    last_error = e
                    print(f"  Attempt {attempt} failed: {e}")
                    if attempt < max_attempts:
                        time.sleep(delay)
            raise last_error
        return wrapper
    return decorator

attempt_counter = [0]  # using list to allow mutation in nested scope

@retry(max_attempts=4, delay=0)
def flaky_service() -> str:
    """Simulates a service that fails sometimes."""
    attempt_counter[0] += 1
    if attempt_counter[0] < 3:
        raise ConnectionError("Service temporarily unavailable")
    return "Success!"

try:
    result = flaky_service()
    print(f"  Final result: {result}")
except Exception as e:
    print(f"  All attempts failed: {e}")

# ============================================================================
#  6. CLASS DECORATOR — using a class as a decorator
# ============================================================================

print("\n=== Class as Decorator ===")

class Counter:
    """Decorator that counts how many times a function is called."""
    def __init__(self, func: Callable):
        functools.update_wrapper(self, func)
        self.func  = func
        self.count = 0

    def __call__(self, *args, **kwargs):
        self.count += 1
        print(f"  [{self.func.__name__} call #{self.count}]")
        return self.func(*args, **kwargs)

@Counter
def say_hello(name: str) -> str:
    return f"Hello, {name}!"

print(say_hello("Alice"))
print(say_hello("Bob"))
print(say_hello("Miles3103"))
print(f"  Total calls: {say_hello.count}")

# ============================================================================
#  7. STACKING DECORATORS
# ============================================================================

print("\n=== Stacking Decorators ===")

# Applied bottom to top: first timer, then repeat
@repeat(2)
@timer
def compute(n: int) -> int:
    return sum(range(n))

compute(100_000)

# ============================================================================
#  8. functools UTILITIES
# ============================================================================

print("\n=== functools Utilities ===")

# partial — fix some arguments of a function
from functools import partial

def power(base: float, exponent: float) -> float:
    return base ** exponent

square = partial(power, exponent=2)
cube   = partial(power, exponent=3)

print(f"square(5) = {square(5)}")
print(f"cube(3)   = {cube(3)}")

# reduce — fold a sequence into a single value
from functools import reduce

product = reduce(lambda x, y: x * y, [1, 2, 3, 4, 5])
print(f"product of [1..5]: {product}")


if __name__ == "__main__":
    print("\n=== Key Takeaways ===")
    print("@decorator is syntactic sugar for func = decorator(func)")
    print("Always use @functools.wraps to preserve function metadata")
    print("Decorator factories take args and return a decorator")
    print("Stack decorators: applied bottom-up")
    print("@lru_cache is the built-in memoization decorator")
    print("functools.partial creates specialized versions of functions")
