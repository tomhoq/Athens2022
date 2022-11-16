
#include <VL53L0X.h>
#include <Wire.h>
int red =5;
int yellow =6;
int green =7;
int debug =8;
VL53L0X sensor1;
VL53L0X sensor2;

int distance1, distance2;

void setup() {
  Serial.begin(9600);
  Wire.begin();

  for (int i=5; i<=8; i++)
    pinMode(i, OUTPUT);
  
  
  sensor1.init();
  sensor1.setTimeout(1000);// set time out for sensor 1
  sensor2.init();
  sensor2.setTimeout(1000);// set time out for sensor 1

  Serial.println(sensor1.getAddress());
  Serial.println(sensor2.getAddress());

  delay(1000);
  
  sensor1.startContinuous(); //will measure continously
  //sensor.setBus(something)
  sensor2.startContinuous(); //will measure continously
  //sensor.setBus(something)
}

void loop() {
  // put your main code here, to run repeatedly:
  distance1 = sensor1.readRangeContinuousMillimeters();
  distance2 = sensor2.readRangeContinuousMillimeters();
  Serial.println(distance1 + " mm");
  Serial.println(distance2 + " mm");

  if (sensor1.timeoutOccurred()) { Serial.print(" TIMEOUT 1"); }
  if (sensor2.timeoutOccurred()) { Serial.print(" TIMEOUT 2"); }  
}
