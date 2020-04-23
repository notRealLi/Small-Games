class Connection {
  private Node fromNode;
  private Node toNode;
  
  public Connection(Node from, Node to) {
    this.fromNode = from;
    this.toNode   = to;
  } 
  
  public Node toNode() {
    return this.toNode;
  }
  
  public Node fromNode() {
    return this.fromNode;
  }
}
