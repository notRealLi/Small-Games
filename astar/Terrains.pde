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
  
  public void setStart(Terrain t) {
    if(this.start != null && this.start != t) {
      this.start.setType("Open");
    }
    this.start = t;
  }
  
  public void setGoal(Terrain t) {
    if(this.goal != null && this.start != t)
      this.goal.setType("Open");
    this.goal = t;
  }
  
  public Terrain get(int i) {
    return this.terrains.get(i);
  }
  
  public void add(Terrain t) {
    this.terrains.add(t);
  }
  
  public Terrain getStart() {
   return this.start;
  }
  
  public Terrain getGoal() {
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
