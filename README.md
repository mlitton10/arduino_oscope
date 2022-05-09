# arduino_oscope
![GitHub](https://img.shields.io/github/license/mlitton10/arduino_oscope) ![GitHub issues](https://img.shields.io/github/issues/mlitton10/arduino_oscope)
Code for data acquisition and transfer to computer via serial transmission.


Current State of the code in version 1.0.1:

1. Bash Script: arduino_coms.sh
  This script manages all necesary actions. It first passes arguements to make_arduino_file.sh (see below) which creates a directory and writes the C++ code to a .ino file. It then compiles the C++ code and uploads it to the board. After upload a processing script is run which reads the data coming through the serial protocol and saves the data to a text file. Finally, this script calls the python script with necessary arguements.
2. Bash Script: make_arduino_file.sh
  This script writes the C++ code to a .ino file. The main purpose of this script is to allow the baud rate to be adjustable. The baud rate must be matched between the C++ deployed on board and the processing script. In order to pass a custom baud rate to the C++ file pre compilation the code is written to a .ino file using this bash script.
3. Processing Script: sketch_data_handler.pde
  This sketch is used to read the data coming from the arduino over serial transmission. It will continue reading data until the specified number of samples is met or the connection to the arduino board is lost. The data is then saved to a text file.
4. Python Script: handle_serial_data.py
  This script does the final layer of data processing. The data file is read and each line is checked for quality. The serial transmission can drop/get cut off giving bad data. These datapoints are filtered out and then interpolated over. Finally, the data is plotted. Further analysis can be done here.


How to use:
1. Run source arduino_coms.sh (Baud rate) (Number of Samples) (text file for data) (file name for arduino C++ script)
  a. Parantheses are mandatory positional arguements
  b. View data plotted via matplotlib, can be saved here, can be viewed again by calling python script:
    i. python handle_serial_data.py --baud_raet (baud_rate) --samples (number of samples) --in_file (location of data file)
  
