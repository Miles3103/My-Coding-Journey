#!/usr/bin/env python3

#persons_of_interest.py

def famous_births(people_dict):
    """
    Takes a dictionary of people (with nested dicts for name and date_of_birth), 
    sorts them by birth date, and prints the formatted output.
    """
    
    # 1. Get a list of the nested dictionaries (the values of the main dictionary)
    list_of_persons = list(people_dict.values())
    
    # 2. Sort the list of dictionaries
    # - The key function extracts the 'date_of_birth' value.
    # - int() is used to ensure the strings are sorted numerically (chronologically).
    sorted_persons = sorted(
        list_of_persons, 
        key=lambda person: int(person['date_of_birth'])
    )
    
    # 3. Print the output in the required format
    for person in sorted_persons:
        name = person['name']
        birth_year = person['date_of_birth']
        
        # The required format: "[Name] is a great scientist born in [Year]."
        print(f"{name} is a great scientist born in {birth_year}.")


women_scientists = {
    "ada": {"name": "Ada Lovelace", "date_of_birth": "1815"},
    "cecilia": {"name": "Cecilia Payne", "date_of_birth": "1900"},
    "lise": {"name": "Lise Meitner", "date_of_birth": "1878"},
    "grace": {"name": "Grace Hopper", "date_of_birth": "1906"}
}

famous_births(women_scientists)


