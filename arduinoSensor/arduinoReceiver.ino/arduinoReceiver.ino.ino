
#include <Wire.h>

String data;
void setup() {
  Serial.begin(9600);
  Wire.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  data = Serial.read(); 
  

  //send to other arduino wireless
}
