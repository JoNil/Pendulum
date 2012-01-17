#!/usr/bin/python3

from math import pi, sin, cos, acos

res = "("

def v(x):
    if x <= 0.5:
        return 1.5-2*x
    else:
        return 2*x-0.5

def trig(x):
    return -sin(x*pi)*0.5+1.35

operator = trig;
table_size = 72
domain = 1

for i in range(table_size):
    res += str(operator(i*domain/table_size))
    if i != table_size-1:
        res += ", "
    if (i+1) % 4 == 0:
        res += "\n"
    
res = res[0:-1] + ");"

print(res)
