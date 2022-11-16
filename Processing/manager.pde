import processing.serial.*;
import java.util.ArrayList;
import java.util.List;

final int IN = 1;
final int OUT = 0;
final int GREEN = 0;
final int YELLOW = 1;
final int RED = 2;

int textVerticalDistance = 40;
int textXAlign = 40;
int textYAlign = 60;
int textSizeToLenghtCoefficient = 30;

List<Room> rooms = new ArrayList<Room>();
Serial port;

String message1;
String message2;

void setup(){
  size(1800,1080);
  background(#FFFFFF);
  fill(0);
  textSize(40);
  frameRate(2);
  port = new Serial(this, Serial.list()[1], 9600);
  
  rooms.add(new Room("102-1", 30));
  rooms.add(new Room("101", 5));
}

void draw(){
  
   for (Room r: rooms){
     //fazer retangulo 
     message1 = "Room " + r.getName();
     // show colored circle
     message2 = r.getOccupation() + "/" + r.getMaxOccupation();
     text(message1, textXAlign, textYAlign);
     text(message2, textXAlign + message1.length()*30, textYAlign);
     textYAlign += textVerticalDistance;
   }
    
    textYAlign = 60;
    
  //while(port.readString() == null){}
  
  String incomingUpdate = port.readString(); //SERIAL TEXT SHOULD BE SENT IN THE FORMAT: "roomName,Mov",
                                             //where Mov is either 1 or 0, in or out
  if (incomingUpdate != null){
    String[] data = incomingUpdate.split(","); // ex: ["RoomA", "1"]  a person walked in on roomA
    Room activeRoom = findRoom(data[0]);
      
    switch(Integer.parseInt(data[1])){
       case IN:
         activeRoom.addEntry();
         break;
       case OUT:
         activeRoom.removeEntry();
         break;
       default:
         println("EXCEPTION: FORMAT ERROR");
         break;
    };
    port.write(activeRoom.getOccupationPercentage() + "," + 
    activeRoom.getOccupation());
  }
}

public Room findRoom(String r){
  for (Room rm : rooms){
    if (rm.getName().equals(r))
      return rm;
  }
  return new Room("ERROR", -1); //SHOULDNT HAPPEN
}
