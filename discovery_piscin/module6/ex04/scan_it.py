#!/usr/bin/env python3

import sys
import re
if len(sys.argv) != 3:
    print("none")
else:   
   keyword = sys.argv[1]
   text = sys.argv[2]
   matches = re.findall(re.escape(keyword),text)
   count = len(matches)

   if count > 0 :
    print(count)
   else:
    print("none")

    