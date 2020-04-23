class Player extends Bubble { 
  public Player(PVector pos, float radius, color bColor) {
    super(pos, radius, bColor, 
          3.0,       // maxSpeed 
          0.6,       // maxAcceleration
          3.0, 1.5); // Slow radius and target radius
  }
  
  // public methods
  
  /* player has only one steering behavior - Arriving (at the mouse position)*/
  public void steer(PVector t) {
    this.target = t;
    Steering arriveResult = this.arrive();
    
    if(arriveResult != null)
      this.kin.update(arriveResult, this.maxSpeed);
  } 
  
  // the opacity of player bubble fades over time.
  public void fade(color bColor) {
    this.bodyColor -= bColor;
  }
  
  // get the opacity of player which is also the hp of player
  public float hp() {
    return alpha(this.bodyColor);
  }
}
