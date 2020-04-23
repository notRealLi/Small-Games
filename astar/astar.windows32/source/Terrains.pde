class Terrains {
  private ArrayList<Terrain> terrains;
  Terrain start;
  Terrain goal;
  
  PImage goalIcon;
  
  public Terrains() {
    this.terrains = new ArrayList<Terrain>();
    goalIcon = loadImage("resources/goal.png");
    
    this.start = null;
    this.goal = null;
  }
  
  public void start(Terrain t) {
    if(this.start != null && this.start != t) {
      this.start.type("Open");
    }
    this.start = t;
  }
  
  public void goal(Terrain t) {
    if(this.goal != null && this.start != t)
      this.goal.type("Open");
    this.goal = t;
  }
  
  public Terrain get(int i) {
    return this.terrains.get(i);
  }
  
  public void add(Terrain t) {
    this.terrains.add(t);
  }
  
  public Terrain start() {
   return this.start;
  }
  
  public Terrain goal() {
   return this.goal;
  }
  
  public int size() {
   return this.terrains.size();
  }
  
  public PImage goalImage() {
    return this.goalIcon;
  }
  
  public ArrayList<Terrain> getTerrains() {
    return this.terrains;
  }
}
