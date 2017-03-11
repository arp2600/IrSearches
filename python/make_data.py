# Quick script to make an array of sorted random value of arbitrary size and write them to a file('data') as space separated values
import random

a = 0
data = list()
# max_val = 10000
max_val = 100
while a < max_val:
    a += 1 + int(random.random() * 9)
    data.append(a)

with open("data", "w") as f:
    f.write(" ".join(map(str, data)))

