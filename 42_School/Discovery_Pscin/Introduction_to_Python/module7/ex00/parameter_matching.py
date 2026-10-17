#!/usr/bin/env python3
import sys
import re


if len(sys.argv) != 2:
    print("none")
else:   
    keyword = sys.argv[1]

    user_input = input("What was the parameter? ")

    if user_input == keyword:
        print("Good job!")
    else:
        print("Nope,sorry...")
