class Bubbles {
  private Player player;
  private Wanderers wanderers;
  private Flockers flockers;
  
  public Bubbles() {
    this.player = new Player(new PVector(SCREEN_WIDTH/2, SCREEN_HEIGHT/2),
                             PLAYER_INITIAL_RADIUS,
                             PLAYER_COLOR);
    
    this.wanderers = new Wanderers();
    this.flockers = new Flockers();  
    this.wanderers.add(this.player);
  }
  
  // public methods
  public int update() {
    this.flockers.update();
    this.wanderers.update();
    this.checkCollision();
    
    if(!this.player.isAlive || this.player.hp() < 1) {
      return -1;   
    } else if(this.player.radius >= WINNING_RADIUS) {
      return 1;
    } else {
      return 0;
    }
  }
  
  // private methods
  private void checkCollision() {
    for(int i=0; i<this.flockers.size(); i++) {
      if(PVector.dist(this.flockers.get(i).kin.getPosition(), this.player.kin.getPosition()) <
         (this.flockers.get(i).radius + this.player.radius)/2.3) {
        this.player.isAlive = false;
       }
    }
  }
}
