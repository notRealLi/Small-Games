abstract class Bubble {
  // cosmetic properties
  protected float radius;
  protected color bodyColor;
  
  // kinematic properties 
  protected Kinematic kin;
  
  // properties for arriving behavior
  protected float maxSpeed;
  protected float maxAcceleration;
  protected float slowRadius;
  protected float targetRadius;
  protected PVector target;
  
  protected boolean isAlive;
  
  protected Bubble(PVector pos, float radius, color bColor,
                   float maxSpeed, float maxAcceleration, 
                   float slowRadius, float targetRadius) {
    this.kin = new Kinematic(pos, 
                             0.0, 
                             new PVector(0.0, 0.0), 
                             0.0);
    this.radius    = radius;
    this.bodyColor = bColor;
    
    this.maxSpeed        = maxSpeed;
    this.maxAcceleration = maxAcceleration;
    this.slowRadius      = slowRadius;
    this.targetRadius    = targetRadius;
    this.target      = null;
    
    this.isAlive = true;
  }
  
  // public methods
  public void steer(PVector t) {}
  public void flock(ArrayList<Bubble> bubs, PVector t) {}
  public void shiftColor(color bColor) {}
  
  public boolean absorb(Bubble bub) {
    if(this.checkCenterDistance(bub) && this.checkRadiusDifference(bub)) 
      return true;
   
    return false;  
  }
  
  public void grow(Bubble bub) {
    this.radius += bub.radius*0.12; 
  }
  
  // protected and private methods
  protected Steering seek(PVector target) {
    Steering steer = new Steering();
    PVector direction = PVector.sub(target, this.kin.getPosition());
    direction.normalize();
    steer.setLinear(PVector.mult(direction, this.maxAcceleration));
    
    return steer;
  }
  
  protected Steering arrive() {
    
    // get the direction then the distance of target
    PVector direction = PVector.sub(this.target, this.kin.getPosition());
    float distance = direction.mag();
    
    // check if target radius is reached  
    if(distance < targetRadius) {
      this.target = null;
      return null;
    }
    
    // set target speed according to whether slow radius is reached
    float targetSpeed;
    if(distance > slowRadius) {
      targetSpeed = this.maxSpeed;  
    }
    
    else
      targetSpeed = this.maxSpeed * distance/slowRadius * 0.8;
    
    // set target velocity
    PVector targetVelocity = direction;
    targetVelocity.normalize();
    targetVelocity.mult(targetSpeed);
    
    // set accelleration
    Steering steering = new Steering();
    steering.linear = PVector.sub(targetVelocity, this.kin.getVelocity());
    
    if(steering.linear.mag() > this.maxAcceleration) {
      steering.linear.normalize();
      steering.linear.mult(this.maxAcceleration);
    }
      
    return steering;
  }
  
  protected boolean checkCenterDistance(Bubble bub) {
    PVector difference = PVector.sub(bub.kin.getPosition(), this.kin.getPosition());
    float distance = difference.mag();
     
    if(distance < (this.radius - bub.radius) * 0.5)
      return true;
      
    return false;
  }
  
  protected boolean checkRadiusDifference(Bubble bub) { 
    if(this.radius > bub.radius * 2.6)
      return true;

    return false;
  }
}
