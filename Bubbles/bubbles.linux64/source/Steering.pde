class Steering {
  private PVector linear;
  
  public Steering() {
    linear = new PVector(0, 0);
  }
  
  public Steering(PVector lin) {
    this.linear  = lin;
  }
  
  // setters 
  public void setLinear(PVector lin) { 
    this.linear = lin;
  }
  
  public void addLinear(PVector lin) { 
    this.linear.add(lin);
  }
  
  // getters
  public PVector getLinear() { 
    return this.linear;
  }
  
  // public methods
  public void add(Steering steer) {
    this.addLinear(steer.getLinear());
  }
  
  /* apply weight to the steering result */
  public void weight(float w) {
    this.linear.mult(w);
  }
}
