class Kinematic {
  private PVector position;
  private float   orientation;
  
  private PVector velocity;
  private float   rotation;
  
  public Kinematic(PVector pos, float orient, PVector v, float r) {
    this.position    = pos;
    this.orientation = orient;
    this.velocity    = v;
    this.rotation    = r;
  }
  
  // setters 
  public void setPosition(PVector pos) { 
    this.position = pos;
  }
  
  public void setOrientation(float orient) { 
    this.orientation = orient;
  }
  
  public void setVelocity(PVector v) { 
    this.velocity = v;
  }
  
  public void setRotation(float r) { 
    this.rotation = r;
  }
  
  // getters
  public PVector getPosition() { 
    return this.position;
  }
  
  public float getOrientation() { 
    return this.orientation;
  }
  
  public PVector getVelocity() { 
    return this.velocity;
  }
  
  public float getRotation() { 
    return this.rotation;
  }
  
  // methods
  public void update(Steering steering, float maxSpeed) {
    // update position
    this.position.add(this.velocity);
    this.orientation += this.rotation;
    
    // update acceleration
    this.velocity.add(steering.getLinear());
    
    // limit speed
    if (this.velocity.mag() > maxSpeed) {
      this.velocity.normalize();
      this.velocity.mult(maxSpeed);
    }
  }
}
