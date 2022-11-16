static final int Y2R = 0.75;
static final int G2Y = 0.25;
static final int GREEN = 0;
static final int YELLOW = 1;
static final int RED = 2;

public class Room{
  private int _occupation = 0;
  private int _maxOccupation;
  private String _roomName;
  
  public Room(int maxOccupation, String roomName){
     _maxOccupation = maxOccupation;
     _roomName = roomName;
  }
  
  public String getName() {  return _roomName;}
  
  public int occupationType(){ 
    float percentage = (float) ((_occupation/_maxOccupation) *100)
    if (percentage < G2Y)
      return GREEN;
    else if (percentage > Y2R)
      return RED;
    return YELLOW;
  }
  
}
