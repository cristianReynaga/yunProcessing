/*
   Cliente YUN para postear datos a Processing
   Compilado en:    IDE v1.5.7
   Placa:           Arduino Yun
   Version:         0.0.1
   Fecha:           Agosto 2014
   Funcion:         Postear 4 señales de datos: temperatura y humedad (DHT11), ruido (electret) y luz (LDR)
   Direccion General de Innovacion y Gobierno Abierto
*/

#include <Console.h>
#include "DHT.h"

const int ledPin = 13; // the pin that the LED is attached to
char incomingByte;      // a variable to read incoming Console data into
const int del = 100;
const int dataSize = 4;

//Temp
String headerT = "A";
String tailT = "B";
String mensajeT = "";

//Hum
String headerH = "C";
String tailH = "D";
String mensajeH = "";

//Noise
String headerN = "E";
String tailN = "F";
String mensajeN = "";

//Light
String headerL = "G";
String tailL = "H";
String mensajeL = "";




// Variables sensores
byte Offset = 0;
#define DHTPIN 2 //Seleccionamos el pin en el que se //conectará el sensor
#define DHTTYPE DHT11 //Se selecciona el DHT11 (hay //otros DHT)
DHT dht(DHTPIN, DHTTYPE); //Se inicia una variable que será usada por Arduino para comunicarse con el sensor
unsigned long time;
// Variables Luz
int lightPin = 5;  //Pin de la foto-resistencia
int light = 0;   //Variable light
int light0 = 0;
float Res0 = 10.0;
//int min = 0;       //valor mínimo que da la foto-resistencia
//int max = 1000;       //valor máximo que da la foto-resistencia
// Variables ruido
int electretPin = 0;
int lect = 0;
int noise = 0;
int threshold = 760;


void setup() {

  Bridge.begin();   // Initialize Bridge
  Console.begin();  // Initialize Console
  dht.begin();

  // Wait for the Console port to connect
  while (!Console);

}

void loop() {

  //Sensores

  //Temperatura
  int temp = dht.readTemperature() - 6;
  //Humedad
  int hum = dht.readHumidity() + 7;
  //Ruido
  int lect = analogRead(electretPin);
  noise = lect - threshold;
  //Luz
  light0 = analogRead(lightPin);   // Read the analogue pin
  float Vout0 = light0 * 0.0048828125;  // calculate the voltage
  light = 500 / (Res0 * ((5 - Vout0) / Vout0));


  //Sending data
  mensajeT += headerT;
  mensajeH += headerH;
  mensajeN += headerN;
  mensajeL += headerL;

  int largo = 1;//String(light).length();

  //  for (int i = 0; i < largo; i++) {
  mensajeT += String(temp);
  mensajeH += String(hum);
  mensajeN += String(noise);
  mensajeL += String(light);
  delay(del);
  // }

  mensajeT += tailT;
  mensajeH += tailH;
  mensajeN += tailN;
  mensajeL += tailL;

  delay(del);
  Console.print(mensajeT);
  Console.print(mensajeH);
  Console.print(mensajeN);
  Console.print(mensajeL);

  mensajeT = "";
  mensajeH = "";
  mensajeN = "";
  mensajeL = "";

}


