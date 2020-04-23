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
  
  public float costSoFar() {
    return this.costSoFar;
  }
  
  public float estimatedTotalCost() {
    return this.estimatedTotalCost;
  }

  public float heuristic() {
    return this.heuristic;
  } 
  
  public Connection connection() {
    return this.connection;
  }
  
  public Terrain terrain() {
    return this.terrain;
  }
  
  public void costSoFar(float cost) {
    this.costSoFar = cost;
  }
  
  public void estimatedTotalCost(float cost) {
    this.estimatedTotalCost = cost;
  }
  
  public void heuristic(float heuristic) {
    this.heuristic = heuristic;
  }
  
  public void connection(Connection connection) {
    this.connection = connection;
  }
  
  public boolean ifNeighbor(Node target) {
    return this.terrain().ifNeighbor(target.terrain());  
  }
}
