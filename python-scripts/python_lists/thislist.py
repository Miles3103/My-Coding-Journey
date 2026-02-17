#!/usr/bin/env python3

thislist = ["apple", "banana", "cherry"]
print(thislist)

thislist = ["apple", "banana", "cherry", "apple", "cherry"]
print(thislist)
print("$$$$$$$$$$$$$$$$")
#list length
print(len(thislist))
print("###############")
#list items data type
list1 = ["apple", "banana", "cherry"]
list2 = [1, 2, 3, 4, 5, 6]
list3 = [True, False, True, False, "hi", 23]
print(list1)
print(list2)
print(list3)
print("+++++++++++++++++++++++")
print(type(list1))
print(type(list2))
print(type(list3))
print(type(list3[-1]))
print(type(list3[-1]))
print("@@@@@@@@@@@@@@@@@@@@@@@@@@@")

#Access list items

list = ["apple", "banana", "cherry", "kiwi"]

print(list[2])
print(list[1])
print(list[0:])
print(list[:3])
print(list[2:])
print(list[0])
print("********************")
#insert items to the list

list = ["apple", "banana", "kiwi", "cherry"]
list.insert(3, "watermelon")
print(list)
print("++++++++++++++++++")
#use append to add items to the end of the list

list.append("orange")
print(list)
#check if item in the list

if "apple" in thislist:
    print("Yes , 'apple' is in the fruits list")
else:
    print("'apple' is not in the list")
thislist = ["apple", "banana", "cherry", "orange", "kiwi", "mango"]
thislist[0:1] = ["blackcurrant", "watermelon"]
print(thislist)

newiteams = ["ismail", "abdalla"]

thislist.extend(newiteams)
print(thislist)

thislist.remove(thislist[1])
print(thislist)
thislist.pop(5)
print(thislist)
del thislist[-1]
print(thislist)
#thislist.clear()
print(thislist)
for x in thislist:
    print(x)
print("%%%%%%%%%%%%%%%%%%%%%%")

for i in range(len(thislist)):
    print(thislist[i])
print("##################")
a = 1
while a < len(thislist):
   print(thislist[a])
   a = a +1
print("$$$$$$$$$$$$$$$$$$$$$$$$")
[print(x) for x in thislist]
print("*888888888888888888")
thislist = [100, 56, 44, 33, 29, 1,-1, 0, 45, 77,68045, 34]
thislist.sort()
print(thislist)