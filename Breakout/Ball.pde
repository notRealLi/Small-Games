class Ball {
  private float posX;
  private float posY;
  private int diameter;
  private float moveX;
  private float moveY;
  
  public Ball (float x, float y) {
    posX = x;
    posY = y;
    diameter = 20;
    moveX = 4;
    moveY = 2;
  }
  
  public float getX () {return posX;}
  public void setX (float x) {posX = x;}
  
  public float getY () {return posY;}
  public void setY (float y) {posY = y;}
  
  public int getDia () {return diameter;}
  
  public float getMX () {return moveX;}
  public void setMX (float mx) {moveX = mx;}
  
  public float getMY () {return moveY;}
  public void setMY (float my) {moveY = my;}
  
  public void speedChange() {
    moveX *= 1.2;
    moveY *= 1.2;
  }
}
