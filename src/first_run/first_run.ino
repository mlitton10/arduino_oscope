int analogPin = A3;
int volts = 0;
int baud_rate = 9600;
void setup() {
Serial.begin(baud_rate);
}

void loop() {
volts = analogRead(analogPin);
Serial.println(volts);
}
