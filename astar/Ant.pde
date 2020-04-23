import java.util.Collections;

class Ant {
  private float   size;
  private color   colour;

  private PVector start;
  private PVector goal;
  private PVector position; // current terrain the ant is in
  
  private ArrayList<Connection> path;
  private Steer steer;
  private PVector target;

  public Ant() {
    this.size = ANT_SIZE;
    this.colour = BLACK;
    this.path = null;
    this.steer = new Steer();
    this.target = null;
  }
  
  public void move() {
    if(this.target == null) {
      if(!this.path.isEmpty()) {
        Connection connection = this.path.remove(0);
        this.target = connection.getToNode().getTerrain().getPosition();
        COST_PATH += connection.getToNode().getTerrain().getCost();
      } else {
        if(!PATHFINDING_OVER) PATHFINDING_OVER = true;
      }
    } else {
      PVector newPosition = this.steer.arrive(this.target, this.position);
      if(newPosition != null)
        this.setPosition(newPosition);
      else
        this.target = null;
    }
  }
  
  public PVector getPosition() {
    return this.position;
  }
  
  public float getSize() {
    return this.size;
  }
  
  public boolean hasPath() {
    return !(this.path == null);
  }
  
  public void setPosition(PVector pos) {
    this.position = pos;
  }
  
  public void setPath(ArrayList<Connection> p) {
    this.path = p;
  }
  
  public void pathfind(Graph graph, Node startNode, Node goalNode, Heuristic heuristic) {
    // set the estimated total cost of start node
    startNode.setEstimatedTotalCost(heuristic.estimate(startNode) + 0);
    
    Nodes open = new Nodes();
    Nodes closed = new Nodes();
    // add start node to open list
    open.add(startNode);
    
    Node currentNode = null;
    
    while(open.size() > 0) {
      //get the node with smallest total cost
      currentNode = open.smallestElement();
       
      // goal node is reached
      if(currentNode.getTerrain() == goalNode.getTerrain()) 
        break;
      
      // get the outgoing connections of current node
      ArrayList<Connection> connections = graph.getConnections(currentNode);
      
      // loop through the connections
      for(int i=0; i<connections.size(); i++) {
        Connection connection = connections.get(i);
        Node endNode = connection.getToNode();
        
        float endNodeCostSoFar = currentNode.getCostSoFar() + endNode.getTerrain().getCost();
        
        // if node is in the closed list
        if(closed.contains(endNode)) {
            if(endNode.costSoFar <= endNodeCostSoFar)
              continue;             
            
            closed.remove(endNode);
            endNode.setHeuristic(endNode.getEstimatedTotalCost() - endNode.getCostSoFar());
            
          // if node is in the open list  
        } else if(open.contains(endNode)) {
          if(endNode.getCostSoFar() <= endNodeCostSoFar)
            continue;
            
          endNode.setHeuristic(endNode.getEstimatedTotalCost() - endNode.getCostSoFar());
          
          // if node is unisited
        } else {
          endNode.setHeuristic(heuristic.estimate(endNode));
          
          endNode.setCostSoFar(endNodeCostSoFar);
          endNode.setConnection(connection);
          endNode.setEstimatedTotalCost(endNodeCostSoFar + endNode.getHeuristic());
          
          // if the node is an obstacle, do not consider it
          if(!open.contains(endNode) && endNode.getTerrain().getType() != "Obstacle")
            open.add(endNode);
        }
      }
      
      open.remove(currentNode);
      closed.add(currentNode);
    }
    
    // No path is found 
    if(currentNode.getTerrain() != goalNode.getTerrain())
      return;
      
    // A path is found
    else {
      ArrayList<Connection> path = new ArrayList<Connection>();
      
      while(currentNode.getTerrain() != startNode.getTerrain()) {
        path.add(currentNode.getConnection());
        currentNode = currentNode.getConnection().getFromNode();
      }
      Collections.reverse(path);
      this.path = path;
    }
  }
}
