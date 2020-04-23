class Renderer {
  private int screenWidth;
  private int screenHeight;
  
  public Renderer() {
    this.screenWidth = SCREEN_WIDTH;
    this.screenHeight = SCREEN_HEIGHT;
  }
  
  /* renders a bubble */
  public void render(Bubble bub) {
    float radius = bub.radius;
    int fillColor = bub.bodyColor;
    
    PVector position = bub.kin.getPosition();
    position = toroidalize(position, radius);
    
    fill(fillColor);
    stroke(STROKE_COLOR);
    ellipseMode(CENTER);
    ellipse(position.x, position.y, radius, radius); 
  }
  
  /* wraparound */ 
  PVector toroidalize(PVector position, float radius) {
    if (position.x < -radius) {
      position.x = this.screenWidth + radius;
    }
    
    if (position.x > this.screenWidth + radius) {
      position.x = -radius;
    }
    
    if (position.y < -radius) {
      position.y = this.screenHeight + radius;
    }
    
    if (position.y > this.screenHeight + radius) {
      position.y = -radius;
    }
    
    return position;
  }
}
