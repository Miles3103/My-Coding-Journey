#!/usr/bin/env python3

"""
print("License check: ")
has_license = True 
licenseinfo = {"name" : "miles","age" : 23,}
list(licenseinfo)
username = input("Enter your name: ")
age = int(input("Enter your age: "))
if len(username) != 0 and age != 0:
   for x in licenseinfo.items():
    if username ==  licenseinfo[0] and age == licenseinfo[1] :
        print("You can drive, you have a license")
    else:
        print("You need to get license")
else:
    print("You are too young to drive")
# ...existing code...
"""
print("License check: ")
has_license = True 
licenseinfo = {"name": "miles", "age": 23}

username = input("Enter your name: ").strip()
age_input = input("Enter your age: ").strip()

try:
    age = int(age_input)
except ValueError:
    print("Invalid age entered.")
else:
    if not username:
        print("No name entered.")
    elif age < 18:
        print("You are too young to drive")
    elif username == licenseinfo["name"] and age == licenseinfo["age"]:
        print("You can drive, you have a license")
    else:
        print("You need to get license")
# ...existing code...