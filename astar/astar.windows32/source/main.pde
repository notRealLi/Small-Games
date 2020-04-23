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
  
  if(ant.position() != null)
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
      if(PVector.dist(t.position(), position) < TERRAIN_SIZE/2) {
        t.type(TERRAIN_TYPE);
        if(TERRAIN_TYPE == "Start")
          terrains.start(t);
        else if (TERRAIN_TYPE == "Goal")
          terrains.goal(t);
      }  
    }
  }
  
  if(position.x <= GRID_START_X) {
    if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 220)) < 30)
      TERRAIN_TYPE = "Grassland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 320)) < 30)
      TERRAIN_TYPE = "Swampland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 420)) < 30)
      TERRAIN_TYPE = "Obstacle";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 520)) < 30)
      TERRAIN_TYPE = "Open";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 620)) < 30)  
      TERRAIN_TYPE = "Start";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 720)) < 30)  
      TERRAIN_TYPE = "Goal";  
  }
}

void keyPressed() {
  if(!PATHFINDING_OVER && key == ' ' && terrains.start() != null & terrains.goal() != null) {
    ant.position(new PVector(terrains.start().position().x, terrains.start().position().y));
    
    ant.pathfind(new Graph(terrains.getTerrains()), 
                 new Node(terrains.start()),
                 new Node(terrains.goal()),
                 new Heuristic(terrains.goal()));
  }
  
  if(PATHFINDING_OVER) {
    PATHFINDING_OVER = false;
    COST_PATH = 0;
    ant = new Ant();
    initTerrain();
  }
}
