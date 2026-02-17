#!/usr/bin/env python3

username = str(input("Enter your name: "))

if len(username) > 0 :
    print(f"Welcome, {username}")
else:
    print("Error: Username cannot be empty")