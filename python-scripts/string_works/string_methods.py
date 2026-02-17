#!/usr/bin/env python3

course = "  Python Programming"  

print(course.upper())
print(course.lower())
print(course.title())
print(course.strip()) #to take out the space in the beginnig and end
print(course.lstrip()) #for the lefet space
print(course.rstrip()) #fpr the right space
print(course.find("tho"))
print(course[4:7])
print(course.replace("t", "e"))
#print(course.replace(course[1],"g"))
print("por" in course)
print("ismail" not in course)
