#!/usr/bin/env python3
# help_your_professor.py

def average(class_scores):
    """
    Calculates the average score from a dictionary of student scores.
    The average is the sum of all scores divided by the number of scores.
    """
    
    # 1. Get a list of all the scores (the dictionary values)
    scores = class_scores.values()
    
    # 2. Check to make sure the class is not empty to avoid a DivisionByZero error
    if not scores:
        return 0.0 # Return 0 if there are no students
        
    # 3. Calculate the sum of all scores
    total_score = sum(scores)
    
    # 4. Count the number of scores (i.e., the number of students)
    num_students = len(scores)
    
    # 5. Calculate the average and return it
    return total_score / num_students

# --- Example Usage (as shown in your prompt) ---

class_3B = {
    "marine": 18,
    "georges": 15,
    "celine": 8,
    "luc": 9
}

class_3C = {
    "quentin": 17,
    "julie": 15,
    "marc": 8,
    "stephanie": 13
}

# Output calculation:
# Class 3B Average: (18 + 15 + 8 + 9) / 4 = 50 / 4 = 12.5
# Class 3C Average: (17 + 6 + 12 + 13) / 4 = 48 / 4 = 12.0

print(f"Average for class 3B: {average(class_3B)}")
print(f"Average for class 3C: {average(class_3C)}")