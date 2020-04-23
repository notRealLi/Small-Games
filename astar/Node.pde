class Node {
  private float costSoFar;
  private float estimatedTotalCost;
  private float   heuristic;
  private Connection connection;
  Terrain terrain;
  
  public Node(Terrain terrain) {
    this.terrain = terrain;
    this.connection = null;
    this.costSoFar = 0;
    this.heuristic = 0;
    this.estimatedTotalCost = 0;
  }
  
  public float getCostSoFar() {
    return this.costSoFar;
  }
  
  public float getEstimatedTotalCost() {
    return this.estimatedTotalCost;
  }

  public float getHeuristic() {
    return this.heuristic;
  } 
  
  public Connection getConnection() {
    return this.connection;
  }
  
  public Terrain getTerrain() {
    return this.terrain;
  }
  
  public void setCostSoFar(float cost) {
    this.costSoFar = cost;
  }
  
  public void setEstimatedTotalCost(float cost) {
    this.estimatedTotalCost = cost;
  }
  
  public void setHeuristic(float heuristic) {
    this.heuristic = heuristic;
  }
  
  public void setConnection(Connection connection) {
    this.connection = connection;
  }
  
  public boolean ifNeighbor(Node target) {
    return this.getTerrain().ifNeighbor(target.getTerrain());  
  }
}
