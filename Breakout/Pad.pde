class Pad {
  private float posX;
  private float posY;
  private int pWidth;
  private int pHeight;
  //private int score;
  
  public Pad (float x, float y) {
    posX = x;
    posY = y;
    pWidth = 180;
    pHeight = 10;
  }
  
  public float getX () {return posX;}
  public void setX (float x) {posX = x;}
  
  public float getY () {return posY;}
  public void setY (float y) {posY = y;}
  
  public int getWid () {return pWidth;}
  public void setWid (int w) {pWidth = w;}
  
  public int getHei () {return pHeight;}
}
