import processing.serial.*;

import java.util.*;

final float G2Y = 0.30;
final float Y2R = 0.75;
final int IN = 1;
final int OUT = 0;
final int GREEN = 0;
final int YELLOW = 1;
final int RED = 2;
static final String SORT_ALPHABETICAL = "Sort Alphabetically";
static final String SORT_OCCUPATION =   "Sort by Occupation";
static final String IP = "http://192.168.0.10";

private int strokeWeight = 5;
private int textSize = 40;
private int textVerticalDistance = 65;
private int textXAlign = 40;
private int textYAlign = 60;
private int rectYAlign = textYAlign -textSize;
private int textsXdistance = 50;
private int rectWidth = 30;
private int rectXStart = 12;
private int rectHeight = 10;
private int newY =0;
private int velocity = 1;

int butWidth = rectWidth ;
int butHeight = rectHeight;
int butX;
int but1Y = rectYAlign;      // Position of rect button
int but2Y = but1Y + butHeight + textVerticalDistance;      // Position of rect button
color butColor = #000000;
color but1Highlight, but2Highlight;
boolean but1Over = false;
boolean but2Over = false;


List<Room> rooms = new ArrayList<Room>();
Serial port;

color colorRect;
int windowHeight;
int nRooms;

String message1;
String message2;

void setup(){
  //DISPLAY SETTINGS
  //WIDTH MUST BE SMALLER THAN 1400
  size(900,700);
  background(#FFFFFF);
  fill(0);
  textSize(textSize);
  frameRate(30);
  port = new Serial(this, Serial.list()[1], 115200);
  //ROOMS
  rooms.add(new Room("102.1",10));
  //ROOM GENERATOR FOR TESTING, CHANGE i TO SEE SLIDING
  for(int i = 1; i<13; i++){ 
    rooms.add(new Room("test"+i,i*2));
  }  
  windowHeight = rectHeight*rooms.size() +
  textVerticalDistance*(rooms.size()-1);

  nRooms = rooms.size();
  //println("Height  " + height +"full: " + windowHeight);
}

void draw(){
  background(255);
  //updates the window height if a new room is added
  if (rooms.size() != nRooms){
    windowHeight = (rectHeight)*rooms.size() +
    textVerticalDistance*(rooms.size()-1);
  }
  drawButtons();
  //does the sliding
  if (windowHeight > height){ 
    translate(0, newY);
    println(newY + " " + -windowHeight);
    if (newY < -windowHeight + height){ // IF REACHES END
      delay(1000);
      newY = 100;
    }
    newY-=velocity;
  }
  drawRooms();
  
  
  //reads data from server
  String line = port.readString(); //SERIAL TEXT SHOULD BE SENT IN THE FORMAT: "roomName,Mov",
                                               //where Mov is either 1 or 0, in or out
  
  if (line != null){
    println(line);
    //String html_source = join( lines, "\n" ); //<>//
    String[] data = line.split(","); // ex: ["RoomA", "1"]  a person walked in on roomA
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
  }
}

//draw roooms---------------------------------------------------
public void drawRooms(){
   if (rooms.size() !=0){
     pushMatrix();
     for (Room r: rooms){
       //fazer retangulo
       
       message1 = r.toString();
       message2 = r.getOccupation() + "/" + r.getMaxOccupation();
       stroke(0);
       strokeWeight(strokeWeight);
       switch(r.occupationType()){
         case GREEN:
           colorRect = color(#00FF00);
           break;
         case YELLOW:
           colorRect = color(230, 206, 50);
           break;
         case RED:
           colorRect = color(#FF0000);
           break;
       };
       fill(colorRect);
       rect(textXAlign-rectXStart, rectYAlign, textWidth(message1)+rectWidth, textAscent()+rectHeight);
       fill(0);
       text(message1, textXAlign, textYAlign);
       text(message2, textXAlign + textWidth(message1) + textsXdistance
       , textYAlign);
      
       translate(0,textVerticalDistance);
     }
     
     popMatrix();
   }
}

public Room findRoom(String r){
  for (Room rm : rooms){
    if (rm.getName().equals(r))
      return rm;
  }
  return new Room("ERROR", -1); //SHOULDNT HAPPEN
}

//Buttons---------------------------------------------------
public void mousePressed(){
  if (but1Over){
    sortRoomsName();
    background(255);
    newY = 100;
  } else if(but2Over){
    sortRoomsOccupation();
    background(255);
    newY = 100;
  }
}

boolean overRect(float x, float y, float width, float height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
void update() {
  if ( overRect(width-textWidth(SORT_ALPHABETICAL)- 55,
  but1Y, butWidth+textWidth(SORT_ALPHABETICAL),
  butHeight + textSize) ) {
    but1Over = true;
    but2Over = false;
  } else if ( overRect(width-textWidth(SORT_ALPHABETICAL)- 55,
  but2Y-10, butWidth+textWidth(SORT_ALPHABETICAL),
  butHeight + textSize) ) {
    but1Over = false;
    but2Over = true;
  } else {
    but1Over = but2Over = false;
  }
}
  
public void drawButtons(){
  update();
  
  //draws the buttons
  stroke(0);
  strokeWeight(strokeWeight);
  if (but1Over) {
    fill(100);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but1Y, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
    fill(255);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but2Y-10, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
  } else if(but2Over){
    fill(255);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but1Y, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
    fill(100);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but2Y-10, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
  } else{
    fill(255);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but1Y, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
    rect(width-textWidth(SORT_ALPHABETICAL)- 55,
    but2Y-10, butWidth+textWidth(SORT_ALPHABETICAL),
    butHeight + textSize);
  }
  
  
  fill(0);
  text(SORT_ALPHABETICAL, width -textWidth(SORT_ALPHABETICAL)
  -textXAlign,textYAlign);
  text(SORT_OCCUPATION, width -textWidth(SORT_ALPHABETICAL)
  -textXAlign, but2Y +30);
}

//sorters---------------------------------------------------
public void sortRoomsName(){
    Collections.sort(rooms,new Comparator<Room>(){
    @Override
    public int compare(Room r1, Room r2){
      return r1.getName().compareTo(r2.getName());
    }
  });
}

public void sortRoomsOccupation(){
    Collections.sort(rooms,new Comparator<Room>(){
    @Override
    public int compare(Room r1, Room r2){
      if (r1.getOccupationPercentage()>r2.getOccupationPercentage()){
        return 1;
      }
      else if (r1.getOccupationPercentage()==r2.getOccupationPercentage())
        return 0;
      return -1;
    }
  });
}
