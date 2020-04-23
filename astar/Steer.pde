class Steer {
  private float   speed;

  public Steer() {
    this.speed = 5;
  }

  protected PVector arrive(PVector target, PVector position) {
    
    // get the direction then the distance of target
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    float distance = direction.mag();


    if (distance != 0){
      position.add(PVector.mult(direction, this.speed));
      return position;
    }
    
    return null;
  }
}
