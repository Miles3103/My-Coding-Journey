#!/usr/bin/env python3

# 1. Define a method called add_one
def add_one(number):
    """
    Takes a parameter, adds 1 to it, and attempts to modify the global variable 'my_variable'.
    NOTE: In Python, this only creates a local variable 'my_variable' inside the function.
    """
    # The variable 'my_variable' here is LOCAL to the function, 
    # even though it has the same name as the global variable.
    my_variable = number + 1
    # Display the variable INSIDE the function (for context)
    print(f"Inside add_one: my_variable is {my_variable}")
    return my_variable

# --- Main Program Body ---

# 2. Initialize a variable and display it
my_variable = 10 
print(f"Before calling add_one: my_variable is {my_variable}")

# 3. Call the method (add_one)
add_one(my_variable)

# 4. Display your variable again in the body of the program
print(f"After calling add_one: my_variable is {my_variable}")