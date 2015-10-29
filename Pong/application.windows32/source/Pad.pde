class Pad {
  private float posX;
  private float posY;
  private int pWidth;
  private int pHeight;
  private int speed;
  private int score;
  
  public Pad (float x, float y) {
    posX = x;
    posY = y;
    pWidth = 10;
    pHeight = 100;
    speed = 6;
    score = 0;
  }
  
  public float getX () {return posX;}
  public void setX (float x) {posX = x;}
  
  public float getY () {return posY;}
  public void setY (float y) {posY = y;}
  
  public int getWid () {return pWidth;}
  public int getHei () {return pHeight;}
  
  public int getSpe () {return speed;}
  
  public int getSco () {return score;}
  public void setSco (int sc) {score = sc;}
}
