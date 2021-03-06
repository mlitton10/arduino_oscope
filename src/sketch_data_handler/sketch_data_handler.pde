import processing.serial.*;

Serial COMPort;  // Create object from Serial class

String[] lines = new String[3];

int num_samples = 5000;  // approximate number of values, appears to typically give 1.2 values per setpoint

String out_file = "../../data/serial_data_5000.txt";
int count;  //counter number of data points read
int baud_rate = 9600;

void setup() 
{
  if (args != null) {
  println(args.length);
  baud_rate = int(args[0]);
  print("Baud rate: "); println(baud_rate);
  num_samples = int(args[1]);
  print("Number of Samples: "); println(num_samples);
  out_file = "../../data/" + args[2];
  print("Out File: "); println(out_file);
  }
  frameRate(10);  // what does this do?
  String portName = Serial.list()[0];  //get serial port name (probably COM0 or COM1)
  COMPort = new Serial(this, portName, 9600);  // Initialize serial object for comms
  count = 0;
}

void draw() 
{
    while (count < num_samples) {
      if (COMPort.available() > 0) {  // If data is available,
      String read = COMPort.readString();  // read and store it to string read
    	// read = "value : " + read;
//    	println(count);
//        println(read);
    	lines = append(lines, read);// append new read to string lines
	    count++;
      }
      else {
        saveStrings(out_file, lines);//save string to file if comms interupted
        exit();
    }
  }
  saveStrings(out_file, lines);  //Once requested number of data points gathered save and exit
  exit();
}
