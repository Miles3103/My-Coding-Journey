#!/usr/bin/env oython3
# your_namebook.py

def array_of_names(persons_dict):
    """
    Takes a dictionary of {first_name: last_name} and returns a list
    of full names with proper capitalization.
    """
    full_names_list = []
    
    # Iterate through the key-value pairs (first_name, last_name) in the dictionary
    for first_name, last_name in persons_dict.items():
        # Capitalize both the first and last name
        capitalized_first = first_name.capitalize()
        capitalized_last = last_name.capitalize()
        
        # Combine them into a full name string
        full_name = f"{capitalized_first} {capitalized_last}"
        
        # Add the full name to the list
        full_names_list.append(full_name)
        
    return full_names_list


persons = {
    "jean": "valjeAn",
    "grace": "hopper",
    "xavier": "niel",
    "fifi": "brindacier"
}

# The method call will produce:
# ['Jean Valjean', 'Grace Hopper', 'Xavier Niel', 'Fifi Brindacier']
print(array_of_names(persons))