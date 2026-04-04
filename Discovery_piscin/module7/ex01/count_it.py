#!/usr/bin/env python3

import sys
import re
num_param = len(sys.argv) -1

if num_param == 0:
    print("none")
else:   
    print(f"Parametrs {num_param}")
    for i in range(1,len(sys.argv)):
        param = sys.argv[i]
        print(f"{param}:  {len(param)}")