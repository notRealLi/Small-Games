class Player extends Bubble { 
  public Player(PVector pos, float radius, color bColor) {
    super(pos, radius, bColor, 
          3.0,       // maxSpeed 
          0.6,       // maxAcceleration
          3.0, 1.5); // Slow radius and target radius
  }
  
  // public methods
  public void steer(PVector t) {
    this.target = t;
    Steering arriveResult = this.arrive();
    
    if(arriveResult != null)
      this.kin.update(arriveResult, this.maxSpeed);
  } 
  
  public void fade(color bColor) {
    this.bodyColor -= bColor;
  }
  
  public float hp() {
    return alpha(this.bodyColor);
  }
}
