public class Room {
  private int _occupation = 0;
  private int _maxOccupation;
  private String _roomName;

  public Room(String roomName, int maxOccupation) {
    _maxOccupation = maxOccupation;
    _roomName = roomName;
  }

  public String getName() {
    return _roomName;
  }
  
  public int getOccupation(){
    return _occupation;
  }
  
  public float getOccupationPercentage(){
    return (float) ((_occupation/_maxOccupation) *100);
  } 
  
  public int getMaxOccupation(){
    return _maxOccupation;
  }
  
  public void setMaxOccupation(int o) {
    _maxOccupation = o;
  }
  
  public void setName(String n) {
    _roomName = n;
  }
   
  public int occupationType() {
    float percentage = (float) ((_occupation/_maxOccupation) *100);
    if (percentage < 0.25) {
      return GREEN;
    } else if (percentage > 0.75)
      return RED;
    return YELLOW;
  }
  
  public void addEntry(){
    _occupation += 1;
  }
  
  public void removeEntry(){
    _occupation -= 1;
  }
}
