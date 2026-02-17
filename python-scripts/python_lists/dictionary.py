#!/usr/bin/env python3

thisdict = { "brand" : "ford", "model" : "mustang", "year" : 1964}
print(thisdict)

print(thisdict["brand"])
print(thisdict["year"])
print(len(thisdict))
thisdict2 = dict(name = "miles", age = 23, country = "Sudan")
print(thisdict2)
print(thisdict2["name"])
print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
x = thisdict["year"]
print(x)
x = thisdict.get("model")
print(x)
print("000000000000000000")
#x = thisdict.keys()
#print(x)
print("%5555555555555555555555555555%")

x = thisdict.keys()
print(x)
thisdict["color"] = "white"
print(x)
print("!!!!!!!!!!!!!!!!!!!!!!!!!")
print(thisdict.values())
print("$$$$$$$$$$$$$$$$$$$$$$$")
print(thisdict.items())
thisdict.update({"color": "red"})
print(thisdict)
print(thisdict)
for x in thisdict:
    print(thisdict[x])
for x in thisdict.values():
    print(x)
for x,y in thisdict.items():
    print(x,y)
mydic = thisdict.copy()
print(mydic)
mydic = dict(thisdict)
print(mydic)