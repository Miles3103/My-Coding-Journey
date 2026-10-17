#!/usr/bin/env python3
import sys
#step 1
def downcase_it(text):
    #take a string and return it in lowercase
    return text.lower()
#get command - line argument ,excluding the script name itself(sys.argv[0])
arguments = sys.argv[1:]
#step 2
#check the edg case no parameters
if not arguments:
    print("none")
else:
    #step 3
    #process and display the result for ech argument
    results = []
    for arg in arguments:
        #run the method to the argument
        lowercase_str = downcase_it(arg)
        results.append(lowercase_str)

        #print the output by aline break
        #matching the output exampl
    print('\n'.join(results))



