#!/usr/bin/env python3

x = 29
if x > 10:
     print("Above 10,")
     if x > 20 :
          print("and also above 20")
          if x > 30 :
               print("also above 30")
          else:
              print("not above 30")
     else:
         print("less than 20")
       
else:
    print("less than 10")