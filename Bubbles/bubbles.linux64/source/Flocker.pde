class Flocker extends Bubble {  
  public Flocker(PVector pos, float radius, color bColor) {
    super(pos, radius, bColor, 
          1.5,       // maxSpeed 
          0.2,       // maxAcceleration
          3.0, 0.9); // Slow radius and target radius
  }
  
  /* combines the other steering behaviors and simulate flocking */
  public void flock(ArrayList<Bubble> bubs, PVector t) {
    this.target = t;
    
    Steering steerResult     = new Steering();
    ArrayList<Bubble> others = this.removeSelf(bubs);
    
    Steering velocityMatchResult = this.velocityMatch(others);
    Steering cohereResult        = this.cohere(others);
    Steering separateResult      = this.separate(others);
    Steering seekResult          = this.seek(this.target);
    
    velocityMatchResult.weight(1.0);
    cohereResult.weight(1.5);
    separateResult.weight(2.5);
    seekResult.weight(3.0);
    
    steerResult.add(velocityMatchResult);
    steerResult.add(cohereResult);
    steerResult.add(separateResult);
    steerResult.add(seekResult);
    
    if(steerResult != null)
      this.kin.update(steerResult, this.maxSpeed);
  }
  
  // private methods
  private Steering velocityMatch(ArrayList<Bubble> bubs) {
    // radius within which to match other flockers' velocity
    float neighborRadius = 100.0;
    PVector velocitySum = new PVector(0, 0);
    
    // calculating the total velocity of neighboring flockers
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      float distance = PVector.sub(neighbor.kin.getPosition(), this.kin.getPosition())
                              .mag();
      
      if(distance < neighborRadius)
         velocitySum.add(neighbor.kin.getVelocity());
    }
    
    // calculate the average velocity
    velocitySum.div(bubs.size());
    velocitySum.normalize();
    velocitySum.mult(this.maxSpeed);
    
    // set accelleration
    Steering steering = new Steering();
    steering.linear = PVector.sub(velocitySum, this.kin.getVelocity());
    
    if(steering.linear.mag() > this.maxAcceleration) {
      steering.linear.normalize();
      steering.linear.mult(this.maxAcceleration);
    }
      
    return steering;
  } 
  
  private Steering cohere(ArrayList<Bubble> bubs) {
    // radius within which to match other flockers' position
    float neighborRadius = 100.0;
    PVector centerPosition = new PVector(0, 0);
    
    // calculating the sum of neighboring flockers' positions
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      float distance = PVector.sub(neighbor.kin.getPosition(), this.kin.getPosition())
                              .mag();
      
      if(distance < neighborRadius)
         centerPosition.add(neighbor.kin.getPosition());
    }
    
    // the center point of the flock
    centerPosition.div(bubs.size());
    
    return this.seek(centerPosition);
  }
  
  private Steering separate(ArrayList<Bubble> bubs) {
    // distance threshold. starts to separate when reached
    float separationThreshold = 50.0;
    Steering steer = new Steering();
    
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      PVector direction = PVector.sub(this.kin.getPosition(), neighbor.kin.getPosition());
      float distance = direction.mag();
      
      // final strength of separation
      float strength;
      // constant for calculating the strength of separation force
      float decay = 10.0;
      if(distance < separationThreshold) {
        strength = min(decay/(distance*distance), this.maxAcceleration);
        strength = this.maxAcceleration;
        direction.normalize();
        steer.addLinear(PVector.mult(direction, strength));  
      }
    }
      
    return steer;
  }   
  
  /* returns an array list of other flockers */
  private ArrayList<Bubble> removeSelf(ArrayList<Bubble> bubs) {
    ArrayList<Bubble> newBubs = (ArrayList<Bubble>)bubs.clone();
    
    for(int i=0; i<newBubs.size(); i++) {
      if(newBubs.get(i) == this) {
        newBubs.remove(i);
        return newBubs;
      }
    }
    
    return newBubs;
  }
}
