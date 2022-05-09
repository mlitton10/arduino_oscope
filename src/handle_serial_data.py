"""
Python script for reading Arduino analog output data text file. Basic Analysis and plotting is done to data
"""

import matplotlib.pyplot as plt  #graphics/plotting library
import argparse  # Create the parser
from scipy.interpolate import interp1d

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
counter = []

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
    if  check < 50 or check > 1024:  
        continue
    voltage_list.append(check*voltage_res)
    times.append(count/transmission_rate)
    counter.append(count)
#    print(count,check)

print(counter[0])
def patch_signal(counter,ts,v,rate):
    interp = interp1d(ts, v)
    patched, patched_t = [], []
    for i in range(counter[0],counter[-1]):
        t = i/rate
        patched_t.append(t)
        if i != counter:
            patch = interp(t)
            patched.append(patch)
        else:
            patched.append(v[ts.index(t)])
    return patched_t, patched

t, volts = patch_signal(counter,times,voltage_list,transmission_rate)
fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(t,volts)
ax.scatter(t,volts)
ax.set_xlabel('t [s]')
ax.set_ylabel('Signal [V]')
plt.show()
