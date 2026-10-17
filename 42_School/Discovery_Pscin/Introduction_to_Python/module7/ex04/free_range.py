#!/usr/bin/env python3
import sys

# Cheching number of parameters is exactly 2
if len(sys.argv) != 3:
    print("none")
else:


#Convert parameters to integers
    num1 = int(sys.argv[1])
    num2 = int(sys.argv[2])
#Check if the fist number1 is smaller than than number2
    if num1 < num2 :
    #using range to constract array list
    #using num2+ 1 cuz range() is exclusive of the end value
     result_list =list(range(num1,num2+1))
     print(result_list)
    else:
    #frist numbe is not smaller than the 2 number
     print("none")



     #Pay attention to spacing and command order in the lines of code.,it's my bigest problem for now
   