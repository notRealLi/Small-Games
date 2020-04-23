class Graph {
  private ArrayList<Node> nodes;
  
  public Graph(ArrayList<Terrain> terrains) {
    nodes = new ArrayList<Node>();
    for(int i=0; i<terrains.size(); i++) 
      nodes.add(new Node(terrains.get(i)));
  }
  
  public ArrayList<Connection> getConnections(Node fromNode) {
    ArrayList<Connection> connections = new ArrayList<Connection>();
    
    for(int i=0; i<this.size(); i++) {
      Node toNode = this.getNode(i);
      
      if(fromNode != toNode && fromNode.ifNeighbor(toNode)) 
        connections.add(new Connection(fromNode, toNode));
    }
    
    return connections;
  }
  
  public int size() {
    return this.nodes.size();
  }
  
  public Node getNode(int i) {
    return this.nodes.get(i);
  }
}
