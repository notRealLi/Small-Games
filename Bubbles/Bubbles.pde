class Bubbles {
  // Bubbles keeps an instance of Player, Wanderers and Flockers
  private Player player;
  private Wanderers wanderers;
  private Flockers flockers;
  
  public Bubbles() {
    this.player = new Player(new PVector(SCREEN_WIDTH/2, SCREEN_HEIGHT/2),
                             PLAYER_INITIAL_RADIUS,
                             PLAYER_COLOR);
    
    this.wanderers = new Wanderers();
    this.flockers = new Flockers();  
    
    // since player and wanderers need to compare with each other a number of 
    // properties, player is added to the wanderer array list
    this.wanderers.add(this.player);
  }
  
  // public methods
  
  /* update data and return the status of game*/
  public int update() {
    this.flockers.update();
    this.wanderers.update();
    this.checkCollision();
    
    // checks if the game is over
    // player loses if it's absorbed or touches a flocker or its HP(color) reaches 0 
    if(!this.player.isAlive || this.player.hp() < 1) {
      return -1;   
    } else if(this.player.radius >= WINNING_RADIUS) {
      return 1;
    } else {
      return 0;
    }
  }
  
  // private methods
  
  /* check if player collides with a flocker bubble */
  private void checkCollision() {
    for(int i=0; i<this.flockers.size(); i++) {
      if(PVector.dist(this.flockers.get(i).kin.getPosition(), this.player.kin.getPosition()) <
         (this.flockers.get(i).radius + this.player.radius)/2.6) {
        this.player.isAlive = false;
       }
    }
  }
}
