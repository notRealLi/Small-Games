void drawTerrain() {
  rectMode(CENTER);
  stroke(0);
  
  for(int i=0; i<terrains.size(); i++) {
    Terrain t = terrains.get(i);
    
    fill(t.getColour());
    rect(t.getPosition().x, t.getPosition().y, TERRAIN_SIZE, TERRAIN_SIZE);
    
    if(t.getType() == "Goal")
      image(terrains.goalImage(), t.getPosition().x, t.getPosition().y, TERRAIN_SIZE/2, TERRAIN_SIZE/2);  
  }
}

void drawTerrainSelector() {
  fill(BLACK);
  textSize(17);
  textAlign(CENTER);
  text("Terrain Selector", 90, startY);
  
  ellipseMode(CENTER);
  textSize(16);
  
  // Grassland
  fill(GREEN);
  stroke(GREEN);
  ellipse(SELECTOR_OFFSET_X, startY + 70, 60, 60);
  
  if(TERRAIN_TYPE == "Grassland") {
    fill(BLACK);
    text("Grass(3)", LABEL_OFFSET_X, startY + 70);
  }
  
  // Swampland
  fill(PURPLE);
  stroke(PURPLE);
  ellipse(SELECTOR_OFFSET_X, startY + 170, 60, 60);
  
  if(TERRAIN_TYPE == "Swampland") {
    fill(BLACK);
    text("Swamp(4)", LABEL_OFFSET_X, startY + 170);
  }
  
  // Obstacle
  fill(BLACK);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, startY + 270, 60, 60);
  
  if(TERRAIN_TYPE == "Obstacle") {
    fill(BLACK);
    text("Obstacle", LABEL_OFFSET_X, startY + 270);
  }
  
  // Open
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, startY + 370, 60, 60);
  
  if(TERRAIN_TYPE == "Open") {
    fill(BLACK);
    text("Open(1)", LABEL_OFFSET_X, startY + 370);
  }
  
  // Start
  fill(RED);
  stroke(RED);
  ellipse(SELECTOR_OFFSET_X, startY + 470, 60, 60);
  
  if(TERRAIN_TYPE == "Start") {
    fill(BLACK);
    text("Start(0)", LABEL_OFFSET_X, startY + 470);
  }
  
  // Goal
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, startY + 570, 60, 60);
  imageMode(CENTER);
  image(terrains.goalImage(), SELECTOR_OFFSET_X, startY + 570, 30, 30);
  
  if(TERRAIN_TYPE == "Goal") {  
    fill(BLACK);
    text("Goal(0)", LABEL_OFFSET_X, startY + 570);
  }
}

void drawAnt() {
  fill(BLACK);
  ellipseMode(CENTER);
  ellipse(ant.getPosition().x, ant.getPosition().y, 
          ant.getSize(), ant.getSize());
}

void drawStartText() {
  if(!PATHFINDING_OVER && terrains.getStart() != null & terrains.getGoal() != null) {
    fill(BLACK);
    textSize(11);
    textAlign(CENTER);
    text("Press SPACE To Start Pathfinding", SCREEN_WIDTH/2, 20);
  }
  
  if(PATHFINDING_OVER) {
    fill(BLACK);
    textSize(11);
    textAlign(CENTER);
    text("Press SPACE To Restart", SCREEN_WIDTH/2, 20);
    text("Total Cost Of Path: " + COST_PATH, SCREEN_WIDTH/2, 40);
  }
}
