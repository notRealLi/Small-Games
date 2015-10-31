import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Breakout extends PApplet {

//// All about the bricks
final int numBricks = 64; // Total number of bricks
int brickCountWin; // Count of bricks towards winning
int brickCountSpeed; // Count of bricks towards next speed change
Brick[] bricks;

Ball ball;
Pad pad;

int numTurns = 3; // Number of turns left
int numPoints = 0; // Number of points

boolean Pause = true; // To check if the game is paused

public void setup () {
  size(800,640);
  frameRate(90);
  background(0);  
  stroke(255);
  strokeWeight(3.5f);
    
  //// Drawing the ball
  ball = new Ball(width/2, height/2);  
  fill(0,191,255);
  ellipse(ball.getX(), ball.getY(), ball.getDia(), ball.getDia());
  
  //// Drawing the paddle
  pad = new Pad(width/2, height-10);
  fill(224,238,238);
  rectMode(CENTER);
  rect(pad.getX(), pad.getY(), pad.getWid(), pad.getHei());
  
  //// Storing info of the bricks 
  brickCountWin = 0; // Count of bricks towards winning
  brickCountSpeed = 0; // Count of bricks towards next speed change 
  bricks = new Brick[numBricks];
  float brickNextY = 30; // Y coordinate of the next brick
  int brickColor; // Color of the next brick
  int rowMax = 8; // Max number of bricks per row
  int columnMax = 8; // Max number of bricks per column
  
  for (int row = 0; row < rowMax; row++) {   
    float brickNextX = 0; // X coordinate of the next brick    
    for (int column = 0; column < columnMax; column++) {      
      if (row < 2)
        bricks[row*8+column] = new Brick(brickNextX,brickNextY,"red"); // Red bricks
      else if (row < 4)
        bricks[row*8+column] = new Brick(brickNextX,brickNextY,"orange"); // Orange bricks
      else if (row < 6)
        bricks[row*8+column] = new Brick(brickNextX,brickNextY,"green"); // Green bricks
      else 
        bricks[row*8+column] = new Brick(brickNextX,brickNextY,"yellow"); // Yellow bricks      
      brickNextX += 100;
    }   
    brickNextY += 20;
  }
  
  noLoop(); // Starting game with pause
}

public void draw () {
  //// To check if the ball is within the frame of the window
  if (ball.getY() <= height - ball.getDia()/2){
    moveBalls();
    drawBricks(); // Refresh the bricks
    
  //// Drawing the ball
  fill(0,191,255);
  ellipse(ball.getX(), ball.getY(), ball.getDia(), ball.getDia()); 
  }
  
  //// When the paddle misses the ball
  else {
    drawBricks(); // Refresh the bricks
    
    // Refresh the ball
    ball = new Ball(width/2,height/2);
    fill(0,191,255);
    ellipse(ball.getX(), ball.getY(), ball.getDia(), ball.getDia());
    
    // Reset speed and speed counters
    brickCountSpeed = 0;
    
    numTurns--; // Adjusting number of turns left
    
    // Pause the game
    Pause = true;
    noLoop();
  }
  
  drawText(); // Draw text according to various game status 
  movePad(); // Refresh paddle
}


public void keyPressed () {
  
  // Pause and resume game
  if (key == ' ')
    Pause = !Pause;
  
  if (!Pause)
    loop();
  else
    noLoop();
}

public void dificultyChange() {
  
  // Speed up the ball every 6th hits
  if (brickCountSpeed%6 == 0) {
    ball.speedChange();
  }
  
  // Shrink the paddle every 22 hits
  if (brickCountSpeed%22 == 0) {
    pad.setWid(pad.getWid()/2);
  }
}

public void resetGame() {  
  // Reset bricks for next round
  for (int i = 0; i < numBricks; i++) {     
    if (i < 16)
      bricks[i].setCol("red");
    else if (i < 32)
      bricks[i].setCol("orange");
    else if (i < 48)
      bricks[i].setCol("green");
    else 
      bricks[i].setCol("yellow");
  }
  brickCountWin = 0;
  numTurns = 3;
  numPoints = 0;
  brickCountSpeed = 0;
  ball = new Ball(width/2,height/2);
  pad = new Pad(width/2, height-10);
}

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
    moveX *= 1.2f;
    moveY *= 1.2f;
  }
}
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
public void moveBalls () {
  //// To check if the ball's touching the paddles
  if (ball.getX() >= pad.getX() - pad.getWid()/2 + ball.getDia()/2 && 
      ball.getX() <= pad.getX() + pad.getWid()/2 - ball.getDia()/2 && 
      ball.getY() >= pad.getY() - pad.getHei()/2 - ball.getDia()/2) { 
    
    //// When the ball is touching the left half of the paddle    
    if (ball.getX() < pad.getX()) {
      
      // Different point of collision with the paddle causes different horizontal change of trail 
      if (ball.getX() <= (pad.getX() - pad.getWid()/4) && ball.getMX() > 0)
        ball.setMX(ball.getMX() * -1.1f);
      else if (ball.getX() > (pad.getX() - pad.getWid()/4) && ball.getMX() > 0)
        ball.setMX(ball.getMX() * -0.9f);
    }
    
    //// When the ball is touching the right half of the paddle 
    else {
      
      // Different point of collision with the paddle causes different horizontal change of trail
      if (ball.getX() >= (pad.getX() + pad.getWid()/4) && ball.getMX() < 0)
        ball.setMX(ball.getMX() * -1.1f);
      else if (ball.getX() < (pad.getX() + pad.getWid()/4) && ball.getMX() < 0)
        ball.setMX(ball.getMX() * -0.9f);
    }
      
    ball.setMY(ball.getMY() * -1); // Change ball direction vertically
  }
  
  //// To check if the ball's touching the top
  if (ball.getY() <= ball.getDia()/2) { 
    
    ball.setMY(ball.getMY() * -1); // Change direction vertically
  }
  
  //// To check if the ball's touching the sides
  if (ball.getX() >= width - ball.getDia()/2 || ball.getX() <= ball.getDia()/2) { 
  
    ball.setMX(ball.getMX() * -1); // Change direction horizontally
  }
  
  //// Detecting collision between the ball and bricks
  for (int i = 0; i < numBricks; i++) {
    
    //// To check if the ball is touching one of the remaining(visible) bricks
    if ((ball.getY() > bricks[i].getY() && (ball.getY() - bricks[i].getY()) <= (ball.getDia()/2 + bricks[i].getHei()) ||
        ball.getY() <= bricks[i].getY() && (bricks[i].getY() - ball.getY()) <= ball.getDia()/2)  && 
        ball.getX() >= bricks[i].getX() + ball.getDia()/2 && 
        ball.getX() <= bricks[i].getX() + bricks[i].getWid() - ball.getDia()/2 &&
        bricks[i].getCol() != "black") {
      
      // Point adjustment
      
      // Yellow bricks 
      if (bricks[i].getCol() == "yellow") 
        numPoints += 1;
        
      // Green bricks  
      else if (bricks[i].getCol() == "green")  
        numPoints += 3;  
      
      // Orange bricks  
      else if (bricks[i].getCol() == "orange") { 
        numPoints += 5;
      }
      
      // Red bricks
      else if (bricks[i].getCol() == "red") { 
        numPoints += 7;
      }
        
      brickCountWin++; // Increment of count of bricks towards winning
      brickCountSpeed++; // Increment of count of bricks towards next speed change
      dificultyChange(); // Checking whether to change speed
      
      ball.setMY(ball.getMY() * -1); // Change direction vertically
      bricks[i].setCol("black"); // Make the brick hit invisible
      drawBricks(); // Refresh the bricks
    }
  }
  
  ball.setX(ball.getX() + ball.getMX()); // Move ball horizontally
  ball.setY(ball.getY() + ball.getMY()); // Move ball vertically
}

public void movePad () {
  fill(224,238,238);
  rectMode(CENTER);
  
  //// Making sure paddle doesn't leave screen
  if (mouseX < pad.getWid()/2)
    pad.setX(pad.getWid()/2);
  else if (mouseX > width - pad.getWid()/2)
    pad.setX(width - pad.getWid()/2);
  else
    pad.setX(mouseX);
    
  rect(pad.getX(), pad.getY(), pad.getWid(), pad.getHei()); // Draw the paddle
}

public void drawBricks () {
  background(0);  
  stroke(255);
  strokeWeight(3.5f);
  
  //// Draw bricks
  for (int i = 0; i < numBricks; i++) { 
    if(bricks[i].getCol()=="red")
      fill(176,23,31);  
    else if(bricks[i].getCol()=="orange")
      fill(255,165,0); 
    else if(bricks[i].getCol()=="green")
      fill(113,198,113); 
    else if(bricks[i].getCol()=="yellow")
      fill(255,236,139);
    else{
      fill(0);
      stroke(0);
    }
    rectMode(CORNER);
    rect(bricks[i].getX(), bricks[i].getY(), bricks[i].getWid(), bricks[i].getHei());
    stroke(255);
  }
}

public void drawText () {
  
  //// Display of remaining turns
  fill(255);
  textSize(20);
  textAlign(CORNER);
  text("Turns Remaining: ", 5, height - 200);
  text(numTurns, 180, height - 198);
  
  //// Display of points
  text("Points: ", 5, height - 150);
  text(numPoints, 80, height - 148);
  
  //// When remaining turns reaches 0
  if (numTurns <= 0) {
    
    // Displays "Game Over" message
    fill(255,0,0);
    textSize(100);
    textAlign(CENTER,CENTER);
    text("Game Over", width/2, height/2 - 60);    
    
    // Reset game
    resetGame();
  }
  
  //// When all bricks are removed
  if (brickCountWin >= 64) {
    
    // Display winning message
    fill(255);
    textSize(100);
    textAlign(CENTER,CENTER);
    text("You win!", width/2, height/2 - 60);
    
    // Reset game
    resetGame();
    
    // Pause the game
    Pause = true;
    noLoop();
  }   
}
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Breakout" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
