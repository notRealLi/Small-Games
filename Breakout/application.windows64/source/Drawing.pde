void moveBalls () {
  //// To check if the ball's touching the paddles
  if (ball.getX() >= pad.getX() - pad.getWid()/2 + ball.getDia()/2 && 
      ball.getX() <= pad.getX() + pad.getWid()/2 - ball.getDia()/2 && 
      ball.getY() >= pad.getY() - pad.getHei()/2 - ball.getDia()/2) { 
    
    //// When the ball is touching the left half of the paddle    
    if (ball.getX() < pad.getX()) {
      
      // Different point of collision with the paddle causes different horizontal change of trail 
      if (ball.getX() <= (pad.getX() - pad.getWid()/4) && ball.getMX() > 0)
        ball.setMX(ball.getMX() * -1.1);
      else if (ball.getX() > (pad.getX() - pad.getWid()/4) && ball.getMX() > 0)
        ball.setMX(ball.getMX() * -0.9);
    }
    
    //// When the ball is touching the right half of the paddle 
    else {
      
      // Different point of collision with the paddle causes different horizontal change of trail
      if (ball.getX() >= (pad.getX() + pad.getWid()/4) && ball.getMX() < 0)
        ball.setMX(ball.getMX() * -1.1);
      else if (ball.getX() < (pad.getX() + pad.getWid()/4) && ball.getMX() < 0)
        ball.setMX(ball.getMX() * -0.9);
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

void movePad () {
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

void drawBricks () {
  background(0);  
  stroke(255);
  strokeWeight(3.5);
  
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

void drawText () {
  
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
