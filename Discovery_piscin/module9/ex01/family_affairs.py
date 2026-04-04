#!/usr/bin/env python3
# family_affairs.py

def find_the_redheads(family_dict):
    """
    Takes a dictionary of {name: hair_color} and returns a list 
    of names with 'red' hair color using the filter function.
    """
    
    # Define the filtering criteria: 
    # This lambda function takes a (name, color) tuple (from dict.items()) 
    # and returns True if the color is exactly 'red'.
    redhead_filter = lambda item: item[1] == 'red'
    
    # 1. Apply the filter to the dictionary items
    # filter() returns an iterator of (name, color) tuples where the color is 'red'
    filtered_items_iterator = filter(redhead_filter, family_dict.items())
    
    # 2. Extract only the first names (index 0) from the filtered tuples
    # This uses a list comprehension for efficient extraction
    redhead_names = [item[0] for item in filtered_items_iterator]
    
    # 3. Return the final list of names
    # Note: Although filter() output is an iterator, 
    # we use a list comprehension here which automatically creates the list.
    # A more direct approach using just list() on filter() requires separate name extraction:
    # return [name for name, color in list(filter(lambda item: item[1] == 'red', family_dict.items()))]
    
    return redhead_names


dupont_family = {
    "florian": "red",
    "marie": "blond",
    "virginie": "brunette",
    "david": "red",
    "franck": "red"
}

# The method call will produce:
# ['florian', 'david', 'franck']
print(find_the_redheads(dupont_family))