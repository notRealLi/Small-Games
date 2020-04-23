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
        this.target = connection.toNode().terrain().position();
        COST_PATH += connection.toNode().terrain().cost();
      } else {
        if(!PATHFINDING_OVER) PATHFINDING_OVER = true;
      }
    } else {
      PVector newPosition = this.steer.arrive(this.target, this.position);
      if(newPosition != null)
        this.position(newPosition);
      else
        this.target = null;
    }
  }
  
  public PVector position() {
    return this.position;
  }
  
  public float size() {
    return this.size;
  }
  
  public boolean hasPath() {
    return !(this.path == null);
  }
  
  public void position(PVector pos) {
    this.position = pos;
  }
  
  public void path(ArrayList<Connection> p) {
    this.path = p;
  }
  
  public void pathfind(Graph graph, Node startNode, Node goalNode, Heuristic heuristic) {
    // set the estimated total cost of start node
    startNode.estimatedTotalCost(heuristic.estimate(startNode) + 0);
    
    Nodes open = new Nodes();
    Nodes closed = new Nodes();
    // add start node to open list
    open.add(startNode);
    
    Node currentNode = null;
    
    while(open.size() > 0) {
      //get the node with smallest total cost
      currentNode = open.smallestElement();
       
      // goal node is reached
      if(currentNode.terrain() == goalNode.terrain()) 
        break;
      
      // get the outgoing connections of current node
      ArrayList<Connection> connections = graph.getConnections(currentNode);
      
      // loop through the connections
      for(int i=0; i<connections.size(); i++) {
        Connection connection = connections.get(i);
        Node endNode = connection.toNode();
        
        float endNodeCostSoFar = currentNode.costSoFar() + endNode.terrain().cost();
        
        // if node is in the closed list
        if(closed.contains(endNode)) {
            if(endNode.costSoFar <= endNodeCostSoFar)
              continue;             
            
            closed.remove(endNode);
            endNode.heuristic(endNode.estimatedTotalCost() - endNode.costSoFar());
            
          // if node is in the open list  
        } else if(open.contains(endNode)) {
          if(endNode.costSoFar() <= endNodeCostSoFar)
            continue;
            
          endNode.heuristic(endNode.estimatedTotalCost() - endNode.costSoFar());
          
          // if node is unisited
        } else {
          endNode.heuristic(heuristic.estimate(endNode));
          
          endNode.costSoFar(endNodeCostSoFar);
          endNode.connection(connection);
          endNode.estimatedTotalCost(endNodeCostSoFar + endNode.heuristic());
          
          // if the node is an obstacle, do not consider it
          if(!open.contains(endNode) && endNode.terrain.type() != "Obstacle")
            open.add(endNode);
        }
      }
      
      open.remove(currentNode);
      closed.add(currentNode);
    }
    
    // No path is found 
    if(currentNode.terrain() != goalNode.terrain())
      return;
      
    // A path is found
    else {
      ArrayList<Connection> path = new ArrayList<Connection>();
      
      while(currentNode.terrain() != startNode.terrain()) {
        path.add(currentNode.connection());
        currentNode = currentNode.connection().fromNode();
      }
      Collections.reverse(path);
      this.path = path;
    }
  }
}
