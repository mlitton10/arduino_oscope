#!/bin/bash/

BAUD=$1
ARDUINO_FILE=$2

create_cmd="touch "$ARDUINO_FILE
$create_cmd
space=" "

fileArray=("int analogPin = A3;\n" "int  volts = 0;\n" "int baud_rate = "$BAUD";\n" "void setup() {\n" "   Serial.begin(baud_rate);\n" "}\n" "\n" "void loop() {\n" "   volts = analogRead(analogPin);\n" "   Serial.println(volts);\n" "}\n")

FILE_STR=""

for str in ${fileArray[@]}; do
    str_length=${#str}
    end_str_length=$(($str_length-2))
    end_str=${str:$end_str_length}
    end_line="\n"
    
    if [ $end_str == $end_line ]; then
	FILE_STR=$FILE_STR$str
    else
	FILE_STR=$FILE_STR$str$space
    fi
done

echo -en $FILE_STR > $ARDUINO_FILE
