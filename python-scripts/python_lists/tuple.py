#!/usr/bin/env python3

#Tuple is unchangeable, allow duplicates items
mytuple = ("apple", "banana", "cherry", "banana")
print(mytuple)
print(mytuple[0])

#tuple with one item
thistuple = ("apple")
print(thistuple)
print(type(thistuple))
tuple1 = ("apple", "banana", "cherry")
tuple2 = (1, 2, 6, 9, 9)
tuple3 = (True, False, True, False)

print(tuple1, " ",tuple2, " ", tuple3)

#tuple can contain different data types:

tuple12 = ("abc", 23, True, 40, "male")
print(tuple12)
print(type(tuple12))
print(tuple12[-1])
print(tuple12[2:4])
print(tuple12[:4])
#change input values

#convert the tuple into a list to able to change it
print(mytuple)
y = list(mytuple)
y[1] = "ismail"
mytuple = tuple(y)
print(mytuple)
y = list(mytuple)
y.append("abdalla")
mytuple = tuple(y)
print(mytuple)
for i in range(len(mytuple)):
    print(mytuple[i])
print("$$$$$$$$$$$$$$$$$$$$$$$$$$$")
i = 0
while i < len(mytuple):
    print(mytuple[i])
    i = i + 1
print("###############################")

#set in python , unordered , unchangeable, duplicates not allowed
thisset = {"ismail", "abdalla", "ali", "ismail"}
print(thisset)
print(len(thisset))
print(type(thisset))
for x in thisset:
    print(x)
print("ismail" in thisset)
print("ismail" not in thisset)
thisset.add("adam")
print(thisset)
thisset.remove("ali")
print(thisset)
tropical = {"pineaple", "mango", "papaya"}
thisset.update(tropical)
print(thisset)
set2 = {"love", "war", "cat"}
set3 = thisset.union(set2)
print(set3)
set4 = thisset.difference(set2)
print(set4)
set5 = set2.difference(thisset)
print(set5)
print("*****************************")
set7 = {"mama", "osman", "mother", "miles"}
set8 = {"Doodo", "miles","marya"}
set8.difference_update(set7)
print(set8)
print("&&&&&&&&&&&&&&&&&")
set10 = set8.symmetric_difference(set7) # = set10 = set8 ^ set7
print(set10)
print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
set11 = frozenset(set7)
print(set11)
print(type(set11))