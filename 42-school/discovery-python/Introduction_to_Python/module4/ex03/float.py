#Prompt the user for a number
user_input=(input("Give me a number: "))
#Convert the string to a float
num = float(user_input)
#determine if it's an integer or decimal 
if num.is_integer():
    print("This number is an integer: ")
else:
    print("This number is decimal: ")