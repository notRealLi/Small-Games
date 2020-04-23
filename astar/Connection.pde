class Connection {
  private Node fromNode;
  private Node toNode;
  
  public Connection(Node from, Node to) {
    this.fromNode = from;
    this.toNode   = to;
  } 
  
  public Node getToNode() {
    return this.toNode;
  }
  
  public Node getFromNode() {
    return this.fromNode;
  }
}
