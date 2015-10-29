class Brick {
  private float posX;
  private float posY;
  private int bWidth;
  private int bHeight;
  private String colour;
  
  public Brick (float x, float y, String c) {
    posX = x;
    posY = y;
    colour = c;
    bWidth = 100;
    bHeight = 20;
  }
  
  public float getX () {return posX;}
  public void setX (float x) {posX = x;}
  
  public float getY () {return posY;}
  public void setY (float y) {posY = y;}
  
  public String getCol () {return colour;}
  public void setCol (String c) {colour = c;}
  
  public int getWid () {return bWidth;}
  public int getHei () {return bHeight;}
}
