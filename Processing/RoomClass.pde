public class Room {
  private int _occupation = 3;
  private int _maxOccupation;
  private String _roomName;

    public Room(String roomName, int maxOccupation) {
    _maxOccupation = maxOccupation;
    _roomName = roomName;
  }
  
  public Room(String roomName, int maxOccupation, int Occ) {
    _maxOccupation = maxOccupation;
    _roomName = roomName;
    _occupation = Occ;
  }


  public String getName() {
    return _roomName;
  }
  
  public int getOccupation(){
    return _occupation;
  }
  
  public float getOccupationPercentage(){
    return (float) (float)(_occupation)/(float)(_maxOccupation);
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
    float percentage = getOccupationPercentage();
    if (percentage < G2Y) {
      return GREEN;
    } else if (percentage >Y2R)
      return RED;
    return YELLOW;
  }
  
  public void addEntry(){
    _occupation += 1;
  }
  
  public void removeEntry(){
    _occupation -= 1;
  }
  
  @Override
  public String toString(){
    return "ClassRoom " + _roomName;
  }
}
