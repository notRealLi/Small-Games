class Terrain {
  private String  type;
  private PVector position; // center position of terrain
  private float   cost;
  
  private float   size;
  private color   colour;
  
  public Terrain(String t, PVector p) {
    this.type(t);
    
    this.position = p;
    this.size = TERRAIN_SIZE;
  }
  
  public Terrain(PVector p) {
    this("Open", p);
  }
  
  public void type(String t) {
    this.type = t;
    
    if(t == "Open") {    
      this.cost = 1;
      this.colour = WHITE;
    }
    else if(t == "Grassland") { 
      this.cost = 3;
      this.colour = GREEN;
    }
    else if(t == "Swampland") {     
      this.cost = 4;
      this.colour = PURPLE;
    }
    else if(t == "Obstacle") {    
      this.cost = OBSTACLE_COST;
      this.colour = BLACK;    
    }
    else if(t == "Start") {    
      this.cost = 0;
      this.colour = RED;    
    }
    else if(t == "Goal") {    
      this.cost = 0;
      this.colour = WHITE;    
    }
  }
  
  public float cost() {
    return this.cost;
  }  
  
  public String type() {
    return this.type;
  }
  
  public PVector position() {
    return this.position;
  }
  
  public color colour() {
    return this.colour;
  }
  
  public boolean ifNeighbor(Terrain target) {
    if(this != target && PVector.dist(this.position, target.position()) <= TERRAIN_NEIGHBOR_RADIUS)
      return true;
    
    return false;
  }
}
