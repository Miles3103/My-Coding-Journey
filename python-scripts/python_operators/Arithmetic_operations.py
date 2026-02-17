#!/usr/bin/env python3

#Arithmetic operations 
print("#Arithmetic operations ")
"""+ Addition, - Subtraction, * Multipliction, / Divison,
  % Modulus, ** Exponentiation, // fFloor division """

x = 15
y = 4

print(f"x = {x} y = {y}")
print(f"x + y = {x+y}")
print(f"x - y = {x-y}")
print(f"x * y = {x*y}")
print(f"x / y = {x/y}")
print(f"x % y = {x%y}")
print(f"x ** y = {x**y}")
print(f"x // y = {x//y}")
print("&&&&&&&&&&&&&&&&")
#Comparison Operators
print("#Comparison Operators")
""" == Equal , != Not equal, > Greater than , < Less than, >= Greater or equal to,
    <= Less than or equal to """
print("*****************************")
print(f"x == y = {x == y}")
print(f"x != y = {x != y}")
print(f"x > y = {x > y}")
print(f"x < y = {x < y}")
print(f"x >= y = {x >= y}")
print(f"x <= y = {x <= y}")
print("8888888888888888")
#Chaining comparison operators
print("#Chaining comparison operators")
x = 5
print(f"1 < x < 10 = {1 < x < 10}")
print(f"1 < x and x < 10 = {1 < x and x < 10}")

print(f"1 > x > 10 = {1 > x > 10}")
print(f"1 > x and x > 10 = {1 > x and x > 10}")

print("#####################")
#Logical Operators
print("#Logical Operators")
""" and Returns True if both statements are True, 
    or Returns True if one of the statements is True,
     not Reverse the result, returns false if the result is true, """
a = 5
print(f"a > 5 and a < 10 =  {a > 5 and a < 10}")
print(f"a < 5 or a > 10 = {a < 5 or a > 10}")
print(f"not(a > 3 and a < 10 = {not(a> 3 and a< 10)})")
print("$$$$$$$$$$$$$$$$$$$$$")
#Identity operators
print("#Identity operators")

s = ["apple", "banana"]
d = ["apple", "banana"]
f = s
print(f"s is f = {s is f}")
print(f"s is d = {s is d}")
print(f"s == d = {s == d}")
print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
#python membership operators
print("#Python membership operators")

fruits = ["apple", "banana", "cherry"]

print("pineaple" not in fruits)
print("pineaple" in fruits)
txt = "Hello World"
print("H" in txt)
print("hello" in txt)
print("z" in txt)
print("z" not in txt)
print("%%%%%%%%%%%%%%%%%%")
#Bitwise operators 
"""&, ^, -, <<, >> """
print(f" 6 & 3 = {6 & 3}")
print(f"6 | 3 = {6 | 3}")
print(f"6 ^ 3 = {6 ^ 3}")
print(6**2)