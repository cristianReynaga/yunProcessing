
// Tabla RSSI
// 0 - 39  --> Excelente
// 40 - 59 --> Muy bueno
// 60 - 69 --> Bueno
// 70 - 79 --> Pobre
// 80 - .. --> Malo


#include <SPI.h>
#include <WiFi.h>
#include "WiFly.h"

int pos = 0;
int crap = 0;
int rssi_read = 0;
int rssi_val = 0;
long i = 0;


void setup() {
  
  // Iniciar comunicacion serial
  Serial.begin(9600);
  // Iniciar pines digitales para LEDs
  for (int thisPin = 2; thisPin < 7; thisPin++) {
        pinMode(thisPin, OUTPUT);
      }
  Serial.println("SPI UART on WiFly Shield terminal tool");
  Serial.println("--------------------------------------");  
  Serial.println();
  Serial.println("Conectar SPI UART...");
  SpiSerial.begin();
  Serial.println("Conectado por SPI UART :D");
  Serial.println(); 
}


void loop(){
  Serial.println("Loop!");
  WiFly.join("BA WiFi");
  if(Serial.println(SpiSerial.read()!=0))
  {
    Serial.println("OK, inicia");
    Serial.println("----------");
  }
  delay (1000); 
  SpiSerial.print("$$$");      // Ingresar a modo comando
  delay (1000);
  SpiSerial.println("show rssi");
  Serial.println(SpiSerial.read());
  
  while(SpiSerial.read()>=-1){
    //delay(1000);
    SpiSerial.println("show rssi");
    //Serial.println(SpiSerial.read());
    if (SpiSerial.read()>= 0 && SpiSerial.read() <= 39){
      digitalWrite(2, HIGH);
      digitalWrite(3, HIGH);
      digitalWrite(4, HIGH);
      digitalWrite(5, HIGH);
      digitalWrite(6, HIGH);
      Serial.println("10");
   }else if (SpiSerial.read()>= 40 && SpiSerial.read() <= 59){
      digitalWrite(2, HIGH);
      digitalWrite(3, HIGH);
      digitalWrite(4, HIGH);
      digitalWrite(5, HIGH);
      digitalWrite(6, LOW);
      Serial.println("8");
    }else if (SpiSerial.read()>= 60 && SpiSerial.read() <= 69){
      digitalWrite(2, HIGH);
      digitalWrite(3, HIGH);
      digitalWrite(4, HIGH);
      digitalWrite(5, LOW);
      digitalWrite(6, LOW);
      Serial.println("6");
    }else if (SpiSerial.read()>= 70 && SpiSerial.read() <= 79){
      digitalWrite(2, HIGH);
      digitalWrite(3, HIGH);
      digitalWrite(4, LOW);
      digitalWrite(5, LOW);
      digitalWrite(6, LOW);
      Serial.println("4");
    }else if(SpiSerial.read()>= 80 && SpiSerial.read() <= 140){
      digitalWrite(2, HIGH);
      digitalWrite(3, LOW);
      digitalWrite(4, LOW);
      digitalWrite(5, LOW);
      digitalWrite(6, LOW);
      Serial.println("2");
    }
  }
}
  
