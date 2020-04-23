Bubbles bubbles;

void setup() {
  // set up game windows specs
  size(SCREEN_WIDTH, SCREEN_HEIGHT); 
  frameRate(FRAME_RATE);
}

void draw() {
  if(!GAME_START) {
    noLoop();
    titleScreen();
  }
  else {
    background(BACKGROUND_COLOR);
    
    int gameStatus = bubbles.update();
    
    if(frameCount % (2 * FRAME_RATE) == 0 && bubbles.wanderers.size() < WANDERER_MAX_NUMBER) {
      bubbles.wanderers.refillBubbles();
      //println(frameCount);
    }
    
    if(frameCount % (1 * FRAME_RATE) == 0 && bubbles.player.hp() > 0)
      bubbles.player.fade(FADING_RATE);
    
    if(frameCount % (5 * FRAME_RATE) == 0)
      bubbles.flockers.changeDirection(SCREEN_WIDTH, SCREEN_HEIGHT);
      
    if(gameStatus == 1 || gameStatus == -1) {
      noLoop();
      GAME_START = false;
      gameOverScreen(gameStatus);
    } 
  }
}

void titleScreen() {
  background(BACKGROUND_COLOR);
  textAlign(CENTER);
  
  textSize(40);
  fill(TITLE_COLOR_1);
  text("Bubbles", SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 300); 
  
  textSize(30);
  fill(TITLE_COLOR_2);
  text("Please Click Anywhere To Start", SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
  
  fill(TITLE_COLOR_1);
  stroke(BACKGROUND_COLOR);
  ellipseMode(CENTER);
  ellipse(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 320, 100, 100);
  
  fill(TITLE_COLOR_3);
  for(int i=0;i<100; i++) {
    ellipse(random(0, SCREEN_WIDTH), random(SCREEN_HEIGHT - 400, SCREEN_HEIGHT), 20, 20);
  }
}

void gameOverScreen(int gameStatus) {
  if(gameStatus == 1)
    GAME_OVER_MESSAGE = "You Win!";
  else
    GAME_OVER_MESSAGE = "You Lose...";
    
  background(BACKGROUND_COLOR);
  textAlign(CENTER);
  
  textSize(40);
  fill(TITLE_COLOR_1);
  text(GAME_OVER_MESSAGE, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 300); 
  
  textSize(30);
  fill(TITLE_COLOR_2);
  text("Please Click Anywhere To Replay", SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

void mouseClicked() {
  if(!GAME_START) { 
    GAME_START = true;
    bubbles = new Bubbles();
    loop();
  }
}
