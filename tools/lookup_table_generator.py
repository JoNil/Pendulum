#!/usr/bin/python3

from math import pi, cos, acos

res = "("

operator = acos;
table_size = 64
domain = 1

for i in range(table_size):
    res += str(operator(i*domain/table_size))
    if i != table_size-1:
        res += ", "
    if (i+1) % 4 == 0:
        res += "\n"
    
res = res[0:-1] + ");"

print(res)
