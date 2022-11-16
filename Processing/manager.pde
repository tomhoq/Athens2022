import processing.serial.*;
import java.util.ArrayList;
import java.util.List;

final int IN = 1;
final int OUT = 0;
final int GREEN = 0;
final int YELLOW = 1;
final int RED = 2;

List<Room> rooms = new ArrayList<Room>();
Serial port;

void setup(){
  size(400,800);
  port = new Serial(this, Serial.list()[1], 9600);
  
  rooms.add(new Room("102-1", 30));
  rooms.add(new Room("101", 5));
}

void draw(){
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
