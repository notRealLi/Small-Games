class Wanderer extends Bubble {  
  // properties for wandering behavior
  private PVector wanderTarget;
  private float   wanderRange;
  
  public Wanderer(PVector pos, float radius, color bColor) {
    super(pos, radius, bColor, 
          random(0.8, 1.0), // maxSpeed 
          random(0.1, 0.4), // maxAcceleration
          3.0, 0.9);        // Slow radius and target radius
    
    this.wanderTarget = null;
    this.wanderRange = 300.0;
  }
  
  // public methods
  
  /* wanderers have one steering behavior - Wander */
  public void steer(PVector t) {
    Steering steerResult = null;
    
    if (t == null)
      steerResult = this.wander();
    
    if(steerResult != null)
      this.kin.update(steerResult, this.maxSpeed);
  }
  
  private Steering wander() {
    // get a random target when the previous one is reached
    if(this.target == null) {
      PVector position = this.kin.getPosition();
      
      float wanderTargetX = min(max(position.x + random(-this.wanderRange,this.wanderRange), 
                                    -this.radius),
                                width+radius);
      float wanderTargetY = min(max(position.y + random(-this.wanderRange,this.wanderRange), 
                                    -this.radius),
                                height+radius);
      this.target = new PVector(wanderTargetX, wanderTargetY);
    }
    
    return this.arrive();
  } 
}
