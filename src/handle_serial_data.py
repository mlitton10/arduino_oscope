"""
Python script for reading Arduino analog output data text file. Basic Analysis and plotting is done to data
"""

import matplotlib.pyplot as plt  #graphics/plotting library
import argparse  # Create the parser

parser = argparse.ArgumentParser()  # Initialize parser object
parser.add_argument('--baud_rate', type=int, required=True)  # Add an argument
parser.add_argument('--samples', type=int, required=True)  # Add an argument
parser.add_argument('--in_file', type=str, required=True)  # Add an argument
args = parser.parse_args()  # Parse arguements

baud_rate, num_samples, in_file = args.baud_rate, args.samples, args.in_file

in_file = "../data/" + in_file

print(f'Baud_rate: {baud_rate}')
print(f'num_samples: {num_samples}')
print(f'in_file: {in_file}')

plt.style.use('dark_background')

bit_resolution = 10
transmission_rate = baud_rate/bit_resolution  # datapoints per second
voltage_res = 5/1024  # volts per unit


lines = []
with open(in_file) as f:
    lines = f.readlines()

count = 0
voltage_list = []
times = []

for line in lines:
    if line == '' or line == '\n' or line == 'null\n': 
        continue
    count += 1  # count all time points
    try:
        check = int(line)
    except ValueError:
        try:
            check = int(line[:-2])  # clean up some strings with weird characters 
        except ValueError:
            try:
                check = int(line[:-3])
            except ValueError:
                continue
    if  check < 100 or check > 1000:  
        continue
    voltage_list.append(check*voltage_res)
    times.append(count/transmission_rate)
#    print(count,check)

fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(times,voltage_list)
ax.scatter(times,voltage_list)
ax.set_xlabel('t [s]')
ax.set_ylabel('Signal [V]')
plt.show()
