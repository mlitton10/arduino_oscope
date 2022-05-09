#!/bin/bash

BAUD_RATE=$1
NUM_SAMPLE=$2
OUT_FILE=$3
ARDUINO_FILE=$4

echo $BAUD_RATE
echo $NUM_SAMPLE
echo $OUT_FILE
echo $ARDUINO_FILE

ARDUINO_FILE_LENGTH=${#ARDUINO_FILE}
ARDUINO_SUB_LENGTH=$(($ARDUINO_FILE_LENGTH-4))
start=0
ARDUINO_SUB=${ARDUINO_FILE:$start:$ARDUINO_SUB_LENGTH}

create_dir_cmd="mkdir "$ARDUINO_SUB
$create_dir_cmd

ARDUINO_PATH=$ARDUINO_SUB"/"$ARDUINO_FILE

create_arduino_cmd="source make_arduino_file.sh "$BAUD_RATE" "$ARDUINO_PATH
$create_arduino_cmd

#create_path_cmd="source ~/.profile"
#$create_path_cmd

arduino_compile="arduino-cli compile -b arduino:avr:uno "$ARDUINO_SUB
$arduino_compile

arduino_upload="arduino-cli upload -b arduino:avr:uno "$ARDUINO_SUB
ARGS=$BAUD_RATE" "$NUM_SAMPLE" "$OUT_FILE

echo $ARGS

PROCESSING_LOC="/home/mattl/processing-4.0b8/"
PROCESSING_SKETCH_LOC="/home/mattl/arduino_oscope/src/sketch_data_handler/"
PROCESS_RUN_CMD="processing-java --sketch="$PROCESSING_SKETCH_LOC" --run "$ARGS

run_cmd="$PROCESSING_LOC$PROCESS_RUN_CMD"

echo $run_cmd

PYTHON_ARGS="--baud_rate "$BAUD_RATE" --samples "$NUM_SAMPLE" --in_file "$OUT_FILE

python_run_cmd="python handle_serial_data.py "$PYTHON_ARGS

$run_cmd
$python_run_cmd
