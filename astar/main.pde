Terrains terrains;
Ant ant;

void setup() {
  frameRate(80);
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
  
  ant = new Ant();
  initTerrain();
}

void draw() {
  loop();
  background(255);
  
  drawTerrain();
  drawTerrainSelector();
  drawStartText();
  
  if(ant.hasPath())
    ant.move();
  
  if(ant.getPosition() != null)
    drawAnt();
}

void initTerrain() {
  terrains = new Terrains();
  for(int i=0; i<NUMBER_COL; i++) {
    for(int j=0; j<NUMBER_ROW; j++) {
      float x = GRID_START_X + j * TERRAIN_SIZE;
      float y = GRID_START_Y + i * TERRAIN_SIZE;
      
      Terrain t = new Terrain(new PVector(x, y));
      terrains.add(t);
    }
  }
}

void mouseClicked() {
  PVector position = new PVector(mouseX, mouseY);
  
  if(position.x >= GRID_START_X - TERRAIN_SIZE/2 && TERRAIN_TYPE != "") {
    for(int i=0; i<terrains.size(); i++) {
      Terrain t = terrains.get(i);
      if(PVector.dist(t.getPosition(), position) < TERRAIN_SIZE/2) {
        t.setType(TERRAIN_TYPE);
        if(TERRAIN_TYPE == "Start")
          terrains.setStart(t);
        else if (TERRAIN_TYPE == "Goal")
          terrains.setGoal(t);
      }  
    }
  }
  
  if(position.x <= GRID_START_X) {
    if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 70)) < 30)
      TERRAIN_TYPE = "Grassland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 170)) < 30)
      TERRAIN_TYPE = "Swampland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 270)) < 30)
      TERRAIN_TYPE = "Obstacle";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 370)) < 30)
      TERRAIN_TYPE = "Open";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 470)) < 30)  
      TERRAIN_TYPE = "Start";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, startY + 570)) < 30)  
      TERRAIN_TYPE = "Goal";  
  }
}

void keyPressed() {
  if(!PATHFINDING_OVER && key == ' ' && terrains.getStart() != null & terrains.getGoal() != null) {
    ant.setPosition(new PVector(terrains.getStart().getPosition().x, terrains.getStart().getPosition().y));
    
    ant.pathfind(new Graph(terrains.getTerrains()), 
                 new Node(terrains.getStart()),
                 new Node(terrains.getGoal()),
                 new Heuristic(terrains.getGoal()));
  }
  
  if(PATHFINDING_OVER) {
    PATHFINDING_OVER = false;
    COST_PATH = 0;
    ant = new Ant();
    initTerrain();
  }
}
