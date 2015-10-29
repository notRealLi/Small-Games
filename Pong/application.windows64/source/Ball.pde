class Ball {
  private float posX;
  private float posY;
  private int diameter;
  private int moveX;
  private int moveY;
  
  public Ball (float x, float y) {
    posX = x;
    posY = y;
    diameter = 20;
    moveX = 2;
    moveY = 3;
  }
  
  public float getX () {return posX;}
  public void setX (float x) {posX = x;}
  
  public float getY () {return posY;}
  public void setY (float y) {posY = y;}
  
  public int getDia () {return diameter;}
  
  public int getMX () {return moveX;}
  public void setMX (int mx) {moveX = mx;}
  
  public int getMY () {return moveY;}
  public void setMY (int my) {moveY = my;}
}
