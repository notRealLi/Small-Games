class Heuristic {
  private Terrain goalTerrain;
  
  public Heuristic(Terrain goal) {
    this.goalTerrain = goal;
  }
  
  public float estimate(Node node) {
    return PVector.dist(goalTerrain.position(), node.terrain().position()) + node.terrain().cost() * 25;
  }
}
