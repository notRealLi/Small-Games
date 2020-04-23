class Flockers {
  private ArrayList<Bubble> bubs;
  private Renderer renderer;
  private PVector flockingDirection;
  
  public Flockers() {
    bubs = new ArrayList<Bubble>();
    for (int i=0; i<FLOCKER_MAX_NUMBER; i++) {
      bubs.add(new Flocker(new PVector(random(FLOCKER_INITIAL_MIN_X, FLOCKER_INITIAL_MAX_X), 
                                       random(FLOCKER_INITIAL_MIN_Y, FLOCKER_INITIAL_MAX_Y)), 
                           FLOCKER_INITIAL_RADIUS, 
                           FLOCKER_COLOR));
    }
    
    renderer = new Renderer();
    flockingDirection = new PVector(SCREEN_WIDTH, SCREEN_HEIGHT);
  }
  
  // getters
  public Bubble get(int i) {
    return this.bubs.get(i);
  }
  
  public ArrayList<Bubble> getArray() {
    return this.bubs;
  }
  
  // public methods
  public void update() {
    for(int i=0; i<this.size();i++) {
      this.get(i).flock(this.bubs, this.flockingDirection);
      renderer.render(this.get(i));
    }
  }
  
  public int size() {
    return this.bubs.size();
  }
  
  public void changeDirection(float maxX, float maxY) {
    this.flockingDirection = new PVector(random(0, maxX), 
                                         random(0, maxY));
  }
}
