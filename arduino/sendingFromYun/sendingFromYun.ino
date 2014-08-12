
#include <Console.h>

const int ledPin = 13; // the pin that the LED is attached to
char incomingByte;      // a variable to read incoming Console data into
const int del = 100;
const int dataSize = 4;
char header='S';
char tail='E';
void setup() {
  Bridge.begin();   // Initialize Bridge
  Console.begin();  // Initialize Console

  // Wait for the Console port to connect
  while (!Console);

  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // see if there's incoming Console data:
  //if (Console.available() > 0) {
  // read the oldest byte in the Console buffer:
  incomingByte = Console.read();
  // Console.println(incomingByte);
  // if it's a capital H (ASCII 72), turn on the LED:
  if (incomingByte == 'H') {
    digitalWrite(ledPin, HIGH);
  }
  // if it's an L (ASCII 76) turn off the LED:
  if (incomingByte == 'L') {
    digitalWrite(ledPin, LOW);
  }
  int sensor = analogRead(0);
   // Console.print(header);
    //delay(del);
    Console.print(sensor);
    delay(del);
    //Console.print(",");
    //Console.print(404);
    //Console.print(",");
    //Console.print(504);
//    Console.print(tail);
  //  delay(del);
    //  Console.println();
    // Console.print('K');
    //Console.print(604);
    //Console.print(",");
    //Console.print(704);
    // Console.println();
  


}


