#!/usr/bin/env python3 
import sys

# Required word length
TARGET_LENGTH = 8

# 1. Define the shrink function
def shrink(text):
    """Takes a string and returns its first eight characters."""
    # Use [:] for string slicing
    return text[:TARGET_LENGTH]

# 2. Define the enlarge function
def enlarge(text):
    """
    Takes a string and appends 'Z' characters until its length becomes 8.
    """
    # Calculate the required number of 'Z' characters
    z_count = TARGET_LENGTH - len(text)
    # Append 'Z' characters and return the result
    return text + ('Z' * z_count)

# --- Execution Start --- #

# Check the number of arguments: sys.argv is a list, and a length of 1 means there are no extra arguments other than the file name itself
# Error corrected: sys.arg -> sys.argv
if len(sys.argv) == 1:
    # Print 'none' if no arguments were passed
    print('none')
    # Exit the program after printing
    exit()

# Get the arguments passed by the user (starting from the second element sys.argv[1:])
arguments = sys.argv[1:]

# Process every argument passed to the program
for arg in arguments:
    arg_length = len(arg)
    
    # Check the length conditions
    if arg_length > TARGET_LENGTH:
        # If the argument is longer than 8 characters, call shrink
        print(shrink(arg))
        
    elif arg_length < TARGET_LENGTH:
        # If the argument is shorter than 8 characters, call enlarge
        print(enlarge(arg))
        
    else: # arg_length == TARGET_LENGTH
        # If the argument is exactly 8 characters long, print it directly
        print(arg)