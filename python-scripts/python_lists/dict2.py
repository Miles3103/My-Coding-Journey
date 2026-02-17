#!/usr/bin/env python3

# Nested Dictionary

myfamily = { "child1" :{"name" : "ismail", "year" : 2002}, "child2" : {"name" : "ali" , "year" : 2002}, "child3" : {"name ": "adam", "year" : 2005}}
print(myfamily)
print("$$$$$$$$$$$$$$$$$$$$$4")
x = myfamily.items()
print(x)
print(myfamily["child1"]["name"])
for x, obj in myfamily.items():
    print(x)
    for y in obj:
        print(y + ':',obj[y])
print("@@@@@@@@@@@@@@@@@@@@@@@@@@@2")

print(len(myfamily.items()))