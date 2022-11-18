#include "Adafruit_VL53L0X.h"
#include "WiFi.h"
#include "ESPAsyncWebServer.h"

#include <Wire.h>

// address we will assign if dual sensor is present
#define LOX1_ADDRESS 0x30
#define LOX2_ADDRESS 0x31

// set the pins to shutdown
#define SHT_LOX1 19
#define SHT_LOX2 18

// objects for the vl53l0x
Adafruit_VL53L0X lox1 = Adafruit_VL53L0X();
Adafruit_VL53L0X lox2 = Adafruit_VL53L0X();

// this holds the measurement
VL53L0X_RangingMeasurementData_t measure1;
VL53L0X_RangingMeasurementData_t measure2;

int people=0;
String room="102.1";

// Set your access point network credentials
const char* ssid = "ESP32-Access-Point";
const char* password = "123456789";

/*
    Reset all sensors by setting all of their XSHUT pins low for delay(10), then set all XSHUT high to bring out of reset
    Keep sensor #1 awake by keeping XSHUT pin high
    Put all other sensors into shutdown by pulling XSHUT pins low
    Initialize sensor #1 with lox.begin(new_i2c_address) Pick any number but 0x29 and it must be under 0x7F. Going with 0x30 to 0x3F is probably OK.
    Keep sensor #1 awake, and now bring sensor #2 out of reset by setting its XSHUT pin high.
    Initialize sensor #2 with lox.begin(new_i2c_address) Pick any number but 0x29 and whatever you set the first sensor to
 */
void setID() {
  // all reset
  digitalWrite(SHT_LOX1, LOW);    
  digitalWrite(SHT_LOX2, LOW);
  delay(10);
  // all unreset
  digitalWrite(SHT_LOX1, HIGH);
  digitalWrite(SHT_LOX2, HIGH);
  delay(10);

  // activating LOX1 and resetting LOX2
  digitalWrite(SHT_LOX1, HIGH);
  digitalWrite(SHT_LOX2, LOW);

  // initing LOX1
  if(!lox1.begin(LOX1_ADDRESS)) {
    Serial.println(F("Failed to boot first VL53L0X"));
    while(1);
  }
  delay(10);

  // activating LOX2
  digitalWrite(SHT_LOX2, HIGH);
  delay(10);

  //initing LOX2
  if(!lox2.begin(LOX2_ADDRESS)) {
    Serial.println(F("Failed to boot second VL53L0X"));
    while(1);
  }
}

void read_dual_sensors() {
  
  lox1.rangingTest(&measure1, false); // pass in 'true' to get debug data printout!
  lox2.rangingTest(&measure2, false); // pass in 'true' to get debug data printout!

  // print sensor one reading
  Serial.print(F("1: "));
  if(measure1.RangeStatus != 4) {     // if not out of range
    Serial.print(measure1.RangeMilliMeter);
  } else {
    Serial.print(F("Out of range"));
  }
  
  Serial.print(F(" "));

  // print sensor two reading
  Serial.print(F("2: "));
  if(measure2.RangeStatus != 4) {
    Serial.print(measure2.RangeMilliMeter);
  } else {
    Serial.print(F("Out of range"));
  }
  
  Serial.println();
}
/*
void calibrate(){

  int sum1=0,n1=0,sum2=0,n2=0;

  while(digitalRead(cal_b)==HIGH){
    read_dual_sensors();
    sum1+=measure1.RangeMilliMeter;
    ave1=sum1/n1;
    n1++;
    sum2+=measure2.RangeMilliMeter;
    ave2=sum2/n2;
    n2++;
     Serial.println("Calibrating...");
  }
 
}
*/
String readP() {
  return String(room + "," +people);
}

void server_setup(){

/*
  Rui Santos
  Complete project details at https://RandomNerdTutorials.com/esp32-client-server-wi-fi/
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files.
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
*/
// Create AsyncWebServer object on port 80
  AsyncWebServer server(80);

  // Serial port for debugging purposes
  Serial.println();
  
  // Setting the ESP as an access point
  Serial.print("Setting AP (Access Point)…");
  // Remove the password parameter, if you want the AP (Access Point) to be open
  WiFi.softAP(ssid, password);

  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  server.on("/people", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/plain", readP().c_str());
  });

  // Start server
  server.begin();
}



void setup() {
  Serial.begin(115200);

  // wait until serial port opens for native USB devices
  while (! Serial) { delay(1); }

  pinMode(SHT_LOX1, OUTPUT);
  pinMode(SHT_LOX2, OUTPUT);

  Serial.println(F("Shutdown pins inited..."));

  digitalWrite(SHT_LOX1, LOW);
  digitalWrite(SHT_LOX2, LOW);

  Serial.println(F("Both in reset mode...(pins are low)"));
  
  
  Serial.println(F("Starting..."));
  setID();

  server_setup();
 
}

void loop() {
  
  read_dual_sensors();
  if( (measure1.RangeStatus!=4)&&(measure2.RangeStatus==4)){
    read_dual_sensors();
    while (!((measure1.RangeStatus==4)&&(measure2.RangeStatus==4))){
      read_dual_sensors();
    }
        people++;
    
  } else if ((measure1.RangeStatus==4)&&(measure2.RangeStatus!=4)){
    read_dual_sensors();
   while (!((measure1.RangeStatus==4)&&(measure2.RangeStatus==4))){
      read_dual_sensors();
    }  
    if (people>0)  people--;
    }
  
  Serial.print(people);

  delay(100);
}



