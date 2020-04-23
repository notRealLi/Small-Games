class Heuristic {
  private Terrain goalTerrain;
  
  public Heuristic(Terrain goal) {
    this.goalTerrain = goal;
  }
  
  public float estimate(Node node) {
    return PVector.dist(goalTerrain.getPosition(), node.getTerrain().getPosition()) + node.getTerrain().getCost() * 25;
  }
}
