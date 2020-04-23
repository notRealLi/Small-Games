class Nodes {
  ArrayList<Node> nodes;
  
  public Nodes() {
    this.nodes = new ArrayList<Node>();
  }
  
  public void add(Node node) {
    this.nodes.add(node);
  }
  
  public void remove(Node node) {
    this.nodes.remove(node);
  }
  
  public int size() {
    return this.nodes.size();
  }
  
  public boolean contains(Node node) {
    for(int i=0; i < this.size(); i++) {
      if(this.nodes.get(i).terrain().position() == node.terrain().position())
        return true;
    }
    
    return false;
  }
  
  public Node find(Node node) {
    return nodes.get(nodes.indexOf(node));
  }
  
  public Node smallestElement() {
    Node smallest = this.nodes.get(0);
    for(int i=1; i < this.size(); i++) {
      if(this.nodes.get(i).estimatedTotalCost() < smallest.estimatedTotalCost())
        smallest = this.nodes.get(i);
    }

    return smallest;
  }
}
