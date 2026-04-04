#!/usr/bin/env python3

import sys

if len(sys.argv) == 1:
    print("none")
    sys.exit(0)
found = False



for i in range(1,len(sys.argv)):
        param = sys.argv[i]


        if param.endswith('ism'):
           continue

        print(param + 'ism')
        found = True
        if not found:
          print("none")
