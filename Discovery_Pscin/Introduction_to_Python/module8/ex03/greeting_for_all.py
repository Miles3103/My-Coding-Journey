#!/usr/bin/env python3

# Define the method with a default parameter value
def greetings(name="noble stranger"):
    """
    Takes a name (string) as a parameter.
    If the parameter is a string, it prints a welcome message.
    If no parameter is provided, it uses the default "noble stranger".
    If the parameter is not a string, it prints an error message.
    """
    
    # Check if the argument is a string (and not the default value 'noble stranger'
    # which we allow to be printed as the welcome message).
    # If the user explicitly passes a non-string argument (like 42 or True),
    # this check handles the error requirement.
    if not isinstance(name, str):
        print("Error: It was not a Name.")
    else:
        # If it is a string (either a valid name or the default), display the welcome message.
        print(f"Hello, {name}")

# --- Testing the Method (as shown in the example) ---

# 1. Valid string argument
greetings('Alexandra')

# 2. String argument with numbers (still valid)
greetings('Wil')

# 3. Called without an argument (uses the default value)
greetings()

# 4. Called with a non-string argument (integer 42) - should trigger the error
greetings(42)