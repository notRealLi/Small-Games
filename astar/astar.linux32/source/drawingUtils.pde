void drawTerrain() {
  rectMode(CENTER);
  stroke(0);
  
  for(int i=0; i<terrains.size(); i++) {
    Terrain t = terrains.get(i);
    
    fill(t.colour());
    rect(t.position().x, t.position().y, TERRAIN_SIZE, TERRAIN_SIZE);
    
    if(t.type() == "Goal")
      image(terrains.goalImage(), t.position().x, t.position().y, TERRAIN_SIZE/2, TERRAIN_SIZE/2);  
  }
}

void drawTerrainSelector() {
  fill(BLACK);
  textSize(17);
  textAlign(CENTER);
  text("Terrain Selector", 90, 150);
  
  ellipseMode(CENTER);
  textSize(16);
  
  // Grassland
  fill(GREEN);
  stroke(GREEN);
  ellipse(SELECTOR_OFFSET_X, 220, 60, 60);
  
  if(TERRAIN_TYPE == "Grassland") {
    fill(BLACK);
    text("Grass(3)", LABEL_OFFSET_X, 220);
  }
  
  // Swampland
  fill(PURPLE);
  stroke(PURPLE);
  ellipse(SELECTOR_OFFSET_X, 320, 60, 60);
  
  if(TERRAIN_TYPE == "Swampland") {
    fill(BLACK);
    text("Swamp(4)", LABEL_OFFSET_X, 320);
  }
  
  // Obstacle
  fill(BLACK);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 420, 60, 60);
  
  if(TERRAIN_TYPE == "Obstacle") {
    fill(BLACK);
    text("Obstacle", LABEL_OFFSET_X, 420);
  }
  
  // Open
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 520, 60, 60);
  
  if(TERRAIN_TYPE == "Open") {
    fill(BLACK);
    text("Open(1)", LABEL_OFFSET_X, 520);
  }
  
  // Start
  fill(RED);
  stroke(RED);
  ellipse(SELECTOR_OFFSET_X, 620, 60, 60);
  
  if(TERRAIN_TYPE == "Start") {
    fill(BLACK);
    text("Start(0)", LABEL_OFFSET_X, 620);
  }
  
  // Goal
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 720, 60, 60);
  imageMode(CENTER);
  image(terrains.goalImage(), SELECTOR_OFFSET_X, 720, 30, 30);
  
  if(TERRAIN_TYPE == "Goal") {  
    fill(BLACK);
    text("Goal(0)", LABEL_OFFSET_X, 720);
  }
}

void drawAnt() {
  fill(BLACK);
  ellipseMode(CENTER);
  ellipse(ant.position().x, ant.position().y, 
          ant.size(), ant.size());
}

void drawStartText() {
  if(!PATHFINDING_OVER && terrains.start() != null & terrains.goal() != null) {
    fill(BLACK);
    textSize(22);
    textAlign(CENTER);
    text("Press SPACE To Start Pathfinding", SCREEN_WIDTH/2, 60);
  }
  
  if(PATHFINDING_OVER) {
    fill(BLACK);
    textSize(22);
    textAlign(CENTER);
    text("Press SPACE To Restart", SCREEN_WIDTH/2, 60);
    text("Total Cost Of Path: " + COST_PATH, SCREEN_WIDTH/2, 110);
  }
}
