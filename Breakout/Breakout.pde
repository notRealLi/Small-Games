//// All about the bricks
int numBricks; // Total number of bricks
int brickCountWin; // Count of bricks towards winning
int brickCountSpeed; // Count of bricks towards next speed change
Brick[] bricks;

Ball ball;
Pad pad;

int numTurns = 3; // Number of turns left
int numPoints = 0; // Number of points

boolean Pause = true; // To check if the game is paused

void setup () {
  fullscreen();
  //size(800,640);
  frameRate(90);
  background(0);  
  stroke(255);
  strokeWeight(3.5);
    
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
  float brickNextY = 30; // Y coordinate of the next brick
  color brickColor; // Color of the next brick
  int rowMax = 8; // Max number of bricks per row
  int columnMax = 8; // Max number of bricks per column
  numBricks = rowMax * columnMax;
  bricks = new Brick[numBricks];
  float brickWidth = width / columnMax;
  
  for (int row = 0; row < rowMax; row++) {   
    float brickNextX = 0; // X coordinate of the next brick    
    for (int column = 0; column < columnMax; column++) {   
          
      if (row < 2)
        bricks[row*columnMax+column] = new Brick(brickNextX,brickNextY, brickWidth, "red"); // Red bricks
      else if (row < 4)
        bricks[row*columnMax+column] = new Brick(brickNextX,brickNextY, brickWidth, "orange"); // Orange bricks
      else if (row < 6)
        bricks[row*columnMax+column] = new Brick(brickNextX,brickNextY, brickWidth, "green"); // Green bricks
      else 
        bricks[row*columnMax+column] = new Brick(brickNextX,brickNextY, brickWidth, "yellow"); // Yellow bricks      
      brickNextX += brickWidth;
    }   
    brickNextY += 20;
  }
  
  noLoop(); // Starting game with pause
}

void draw () {
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


void keyPressed () {
  
  // Pause and resume game
  if (key == ' ')
    Pause = !Pause;
  
  if (!Pause)
    loop();
  else
    noLoop();
}

void dificultyChange() {
  
  // Speed up the ball every 6th hits
  if (brickCountSpeed%6 == 0) {
    ball.speedChange();
  }
  
  // Shrink the paddle every 22 hits
  if (brickCountSpeed%22 == 0) {
    pad.setWid(pad.getWid()/2);
  }
}

void resetGame() {  
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

