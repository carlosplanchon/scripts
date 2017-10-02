#!/usr/bin/env python3

from os import system
system('touch converted.log')

hour_difference = 5

with open('latest.log', 'r') as log:
    with open('converted.log', 'w') as converted:
        for line in log.readlines():
            if line[0] == '[':
                hour = int(line[1:3]) - hour_difference

                if int(hour) < 0: 
                    hour += 24

                hour = str(hour)

                if len(hour) == 1:
                    hour = '0' + hour

                line = '[' + hour + line[3:]

                if not '[Server thread/WARN]' in line:
                        converted.write(line)
