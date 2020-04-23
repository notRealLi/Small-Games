class Wanderers {
  private ArrayList<Bubble> bubs;
  private Renderer renderer;
  
  public Wanderers() {
    this.bubs = new ArrayList<Bubble>();
    
    for (int i=0; i<WANDERER_MAX_NUMBER; i++) {
      this.bubs.add(new Wanderer(new PVector(random(0, SCREEN_WIDTH - 100), random(0, SCREEN_HEIGHT-100)), 
                                 random(WANDERER_MIN_INITIAL_RADIUS, WANDERER_MAX_INITIAL_RADIUS), 
                                 WANDERER_COLOR));
    }
    
    renderer = new Renderer();
  }
  
  // getters
  public Bubble get(int i) {
    return this.bubs.get(i);
  }
  
  public ArrayList<Bubble> getArray() {
    return this.bubs;
  }
  
  // setters
  public void set(int i, Bubble bub) {
    this.bubs.set(i, bub);
  }
  
  // public methods
  public void update() {
    this.sort();
    this.checkAbsorb();
    this.steer();
  }
  
  public void steer() {
    for(int i=0; i<this.size(); i++) {
      Bubble bub = this.get(i);
    
      if(bub instanceof Wanderer)
        bub.steer(null);
      else if(bub instanceof Player)
        bub.steer(new PVector(mouseX, mouseY));
      
      this.renderer.render(bub);
    }
  }
  
  public int size() {
    return this.bubs.size();
  }
  
  public void add(Bubble bub) {
    this.bubs.add(bub);
  }
  
  public void remove(int i) {
    this.bubs.remove(i);
  }
  
  // move
  private void sort() {
    for(int i=0; i<this.size()-1; i++) {
      for(int j=i+1; j<this.size(); j++) {  
        if(this.get(j).radius < this.get(i).radius) {
            Bubble temp = this.get(i);
            this.set(i, this.get(j));
            this.set(j, temp);
        }
      } 
    }
  }
  
  private void checkAbsorb() {
    for(int i=this.size()-1; i>=1; i--) {
      for(int j=i-1; j>=0; j--) { 
        if(this.get(i).isAlive &&
           this.get(j).isAlive &&
           this.get(i).absorb(this.get(j))) {
             this.get(i).grow(this.get(j));
             this.get(j).isAlive = false;
           }
      } 
    }
    
    for(int i=this.size()-1; i>=0; i--) {
      if(!this.get(i).isAlive)
       this.remove(i); 
    }
  }
  
  void refillBubbles() {
    float radiusSum = 0;
    for(int i=0; i<this.size(); i++) {
      radiusSum += this.get(i).radius;
    }
    
    float radiusAvg = radiusSum / this.size();
    this.add(new Wanderer(new PVector(0, random(0, SCREEN_HEIGHT)), 
                          min(random(radiusAvg/5 , radiusAvg*2), SCREEN_HEIGHT/4), 
                          WANDERER_COLOR));
  }
}
