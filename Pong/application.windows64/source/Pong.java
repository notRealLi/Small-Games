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

public class Pong extends PApplet {

//// All about the ball
Ball ball;

//// All about the pad
Pad leftPad;
Pad rightPad;

boolean isPaused;

public void setup (){
  size(800,720); 
  background(0);
  
  ball = new Ball(width/2, height/2);
  leftPad = new Pad(5, height/2);
  rightPad = new Pad(width - 5, height/2);
  
  //// Drawing the line
  stroke(255);
  line(width/2, 0, width/2, height); 
  
  //// Drawing the ball
  fill(0,191,255);
  ellipse(ball.getX(), ball.getY(), ball.getDia(), ball.getDia());
  
  //// Drawing the two paddles
  fill(224,238,238);
  rectMode(CENTER);
  rect(leftPad.getX(), leftPad.getY(), leftPad.getWid(), leftPad.getHei());
  rect(rightPad.getX(), rightPad.getY(), rightPad.getWid(), rightPad.getHei());
  
  //// Player score display
  PFont font = loadFont("Asimov.vlw");
  fill(255);
  textFont(font, 50);
  text(rightPad.getSco(), width - 30, 40);
  text(leftPad.getSco(), 30, 40);
  
  isPaused = true;
}

public void draw (){
  if (!isPaused){
    //// Ball movemwnt
    if (ball.getX() > 0 - ball.getDia()/2 && ball.getX() < width + ball.getDia()/2){ //// To check if the ball is within the frame of the window
      backgroundClear();
      ball.setX(ball.getX() + ball.getMX());
      ball.setY(ball.getY() + ball.getMY());
      
      if ((ball.getX() >= rightPad.getX() - rightPad.getWid()/2 - ball.getDia()/2) && 
          ball.getY() > rightPad.getY() - rightPad.getHei()/2 && 
          ball.getY() < rightPad.getY() + rightPad.getHei()/2 || 
          (ball.getX() <= leftPad.getX() + leftPad.getWid()/2 + ball.getDia()/2) &&
          ball.getY() > leftPad.getY() - leftPad.getHei()/2 && 
          ball.getY() < leftPad.getY() + leftPad.getHei()/2) { //// To check if the ball's touching the paddles
        ball.setMX(ball.getMX()*-1); //// Change direction horizontally
      }
      
      if (ball.getY() + ball.getDia()/2 >= height || ball.getY() - ball.getDia()/2 <= 0) { // To check if the ball's touching the top or the bottom
        ball.setMY(ball.getMY()*-1); //// Change direction vertically
      }
      
          
    } 
    
    else { //// if the ball misses the paddle, increase player score, reset ball location
      if (ball.getX() <= 0 - ball.getDia()/2)
        rightPad.setSco(rightPad.getSco()+1);
      
      else 
        leftPad.setSco(leftPad.getSco()+1);
      ball.setX(width/2);
      ball.setY(height/2);
    }
  } 
  
  //// Drawing the ball
  fill(0,191,255);
  ellipse(ball.getX(), ball.getY(), ball.getDia(), ball.getDia()); 
  
  //// Drawing paddles
  rect(leftPad.getX(), leftPad.getY(), leftPad.getWid(), leftPad.getHei());
  rect(rightPad.getX(), rightPad.getY(), rightPad.getWid(), rightPad.getHei());
}

public void backgroundClear (){ //// To clear the screen before drawing the ball so it does not leave a trail
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  PFont font = loadFont("Asimov.vlw");
  textFont(font, 30);
  fill(255);
  text(rightPad.getSco(), width - 30, 40);
  text(leftPad.getSco(), 15, 40);
}

public void keyPressed (){ //// To check keyboard input
  switch(key){
    case 'w':
      if(!isPaused)
        moveLeftPad(leftPad, 'w');
      break;
    case 's':
      if(!isPaused)
        moveLeftPad(leftPad, 's');
      break;
    case 'o':
      if(!isPaused)
        moveRightPad(rightPad, 'o');
      break;
    case 'k':
      if(!isPaused)
        moveRightPad(rightPad, 'k');
      break;
    case ' ':
      isPaused = !isPaused;
      break;
    default:
      break;
  }
}


public void moveLeftPad (Pad pad, char dir){ 
  if (pad.getY() - pad.getHei()/2 > 0){ // To make sure the paddle does not leave the screen through the top
    if (dir == 'w'){
      pad.setY(pad.getY() - pad.getSpe());
    }
  }
  
  if (pad.getY() + pad.getHei()/2 < height){ // To make sure the paddle does not leave the screen through the bottom
    if (dir == 's'){
      pad.setY(pad.getY() + pad.getSpe());
    }
  }
  //rect(padX, padY, padW, padH);
}

public void moveRightPad (Pad pad, char dir){
  if (rightPad.getY() - pad.getHei()/2 > 0){ // To make sure the paddle does not leave the screen through the top
    if (dir == 'o'){
      pad.setY(pad.getY() - pad.getSpe());
    }
  }
  
  if (rightPad.getY() + pad.getHei()/2 < height){ // To make sure the paddle does not leave the screen through the bottom
    if (dir == 'k'){
      pad.setY(pad.getY() + pad.getSpe());
    }
  }
  //rect(padX, padY, padW, padH);
}
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pong" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
