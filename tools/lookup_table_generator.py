#!/usr/bin/python3

from math import pi, sin, cos, acos

res = "("

def v(x):
    if x <= 0.5:
        return 1.5-2*x
    else:
        return 2*x-0.5

a = 1.0

def trig(x):
    return -a*sin(x*pi/72) + 1 - 2*a/pi
        
def correct(i):
    return 72/26.3297*92/(2*pi)*(acos((i-46+10)/46)-acos((i-46+1+10)/46))
    
x = 0
p = 0.07
N = 71.98
    
for i in range(72):
    x += 1/(2*pi)*(acos(cos(2*pi*p)*(i-N/2)/(N/2))-acos(cos(2*pi*p)*(i+1-N/2)/(N/2)))

def correct_2(i):
    return N/x*1/(2*pi)*(acos(cos(2*pi*p)*(i-N/2)/(N/2))-acos(cos(2*pi*p)*(i+1-N/2)/(N/2)))

operator = correct_2;
domain = 72
table_size = 72

test = 0

for i in range(table_size):
    res += str(operator(i*domain/table_size))
    test += operator(i*domain/table_size) 
    if i != table_size-1:
        res += ", "
    if (i+1) % 4 == 0:
        res += "\n"
    
res = res[0:-1] + ");"

print(res)
print(test)
