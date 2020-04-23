import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

Terrains terrains;
Ant ant;

public void setup() {
  frameRate(80);
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
  
  ant = new Ant();
  initTerrain();
}

public void draw() {
  loop();
  background(255);
  
  drawTerrain();
  drawTerrainSelector();
  drawStartText();
  
  if(ant.hasPath())
    ant.move();
  
  if(ant.position() != null)
    drawAnt();
}

public void initTerrain() {
  terrains = new Terrains();
  for(int i=0; i<NUMBER_COL; i++) {
    for(int j=0; j<NUMBER_ROW; j++) {
      float x = GRID_START_X + j * TERRAIN_SIZE;
      float y = GRID_START_Y + i * TERRAIN_SIZE;
      
      Terrain t = new Terrain(new PVector(x, y));
      terrains.add(t);
    }
  }
}

public void mouseClicked() {
  PVector position = new PVector(mouseX, mouseY);
  
  if(position.x >= GRID_START_X - TERRAIN_SIZE/2 && TERRAIN_TYPE != "") {
    for(int i=0; i<terrains.size(); i++) {
      Terrain t = terrains.get(i);
      if(PVector.dist(t.position(), position) < TERRAIN_SIZE/2) {
        t.type(TERRAIN_TYPE);
        if(TERRAIN_TYPE == "Start")
          terrains.start(t);
        else if (TERRAIN_TYPE == "Goal")
          terrains.goal(t);
      }  
    }
  }
  
  if(position.x <= GRID_START_X) {
    if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 220)) < 30)
      TERRAIN_TYPE = "Grassland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 320)) < 30)
      TERRAIN_TYPE = "Swampland";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 420)) < 30)
      TERRAIN_TYPE = "Obstacle";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 520)) < 30)
      TERRAIN_TYPE = "Open";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 620)) < 30)  
      TERRAIN_TYPE = "Start";
    else if(PVector.dist(position, new PVector(SELECTOR_OFFSET_X, 720)) < 30)  
      TERRAIN_TYPE = "Goal";  
  }
}

public void keyPressed() {
  if(!PATHFINDING_OVER && key == ' ' && terrains.start() != null & terrains.goal() != null) {
    ant.position(new PVector(terrains.start().position().x, terrains.start().position().y));
    
    ant.pathfind(new Graph(terrains.getTerrains()), 
                 new Node(terrains.start()),
                 new Node(terrains.goal()),
                 new Heuristic(terrains.goal()));
  }
  
  if(PATHFINDING_OVER) {
    PATHFINDING_OVER = false;
    COST_PATH = 0;
    ant = new Ant();
    initTerrain();
  }
}


class Ant {
  private float   size;
  private int   colour;

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
class Heuristic {
  private Terrain goalTerrain;
  
  public Heuristic(Terrain goal) {
    this.goalTerrain = goal;
  }
  
  public float estimate(Node node) {
    return PVector.dist(goalTerrain.position(), node.terrain().position()) + node.terrain().cost() * 25;
  }
}
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
class Steer {
  private float   speed;

  public Steer() {
    this.speed = 5;
  }

  protected PVector arrive(PVector target, PVector position) {
    
    // get the direction then the distance of target
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    float distance = direction.mag();


    if (distance != 0){
      position.add(PVector.mult(direction, this.speed));
      return position;
    }
    
    return null;
  }
}
class Terrain {
  private String  type;
  private PVector position; // center position of terrain
  private float   cost;
  
  private float   size;
  private int   colour;
  
  public Terrain(String t, PVector p) {
    this.type(t);
    
    this.position = p;
    this.size = TERRAIN_SIZE;
  }
  
  public Terrain(PVector p) {
    this("Open", p);
  }
  
  public void type(String t) {
    this.type = t;
    
    if(t == "Open") {    
      this.cost = 1;
      this.colour = WHITE;
    }
    else if(t == "Grassland") { 
      this.cost = 3;
      this.colour = GREEN;
    }
    else if(t == "Swampland") {     
      this.cost = 4;
      this.colour = PURPLE;
    }
    else if(t == "Obstacle") {    
      this.cost = OBSTACLE_COST;
      this.colour = BLACK;    
    }
    else if(t == "Start") {    
      this.cost = 0;
      this.colour = RED;    
    }
    else if(t == "Goal") {    
      this.cost = 0;
      this.colour = WHITE;    
    }
  }
  
  public float cost() {
    return this.cost;
  }  
  
  public String type() {
    return this.type;
  }
  
  public PVector position() {
    return this.position;
  }
  
  public int colour() {
    return this.colour;
  }
  
  public boolean ifNeighbor(Terrain target) {
    if(this != target && PVector.dist(this.position, target.position()) <= TERRAIN_NEIGHBOR_RADIUS)
      return true;
    
    return false;
  }
}
class Terrains {
  private ArrayList<Terrain> terrains;
  Terrain start;
  Terrain goal;
  
  PImage goalIcon;
  
  public Terrains() {
    this.terrains = new ArrayList<Terrain>();
    goalIcon = loadImage("resources/goal.png");
    
    this.start = null;
    this.goal = null;
  }
  
  public void start(Terrain t) {
    if(this.start != null && this.start != t) {
      this.start.type("Open");
    }
    this.start = t;
  }
  
  public void goal(Terrain t) {
    if(this.goal != null && this.start != t)
      this.goal.type("Open");
    this.goal = t;
  }
  
  public Terrain get(int i) {
    return this.terrains.get(i);
  }
  
  public void add(Terrain t) {
    this.terrains.add(t);
  }
  
  public Terrain start() {
   return this.start;
  }
  
  public Terrain goal() {
   return this.goal;
  }
  
  public int size() {
   return this.terrains.size();
  }
  
  public PImage goalImage() {
    return this.goalIcon;
  }
  
  public ArrayList<Terrain> getTerrains() {
    return this.terrains;
  }
}
public void drawTerrain() {
  rectMode(CENTER);
  stroke(0);
  
  for(int i=0; i<terrains.size(); i++) {
    Terrain t = terrains.get(i);
    
    fill(t.colour());
    rect(t.position().x, t.position().y, TERRAIN_SIZE, TERRAIN_SIZE);
    
    if(t.type() == "Goal")
      image(terrains.goalImage(), t.position().x, t.position().y, TERRAIN_SIZE/2, TERRAIN_SIZE/2);  
  }
}

public void drawTerrainSelector() {
  fill(BLACK);
  textSize(17);
  textAlign(CENTER);
  text("Terrain Selector", 90, 150);
  
  ellipseMode(CENTER);
  textSize(16);
  
  // Grassland
  fill(GREEN);
  stroke(GREEN);
  ellipse(SELECTOR_OFFSET_X, 220, 60, 60);
  
  if(TERRAIN_TYPE == "Grassland") {
    fill(BLACK);
    text("Grass(3)", LABEL_OFFSET_X, 220);
  }
  
  // Swampland
  fill(PURPLE);
  stroke(PURPLE);
  ellipse(SELECTOR_OFFSET_X, 320, 60, 60);
  
  if(TERRAIN_TYPE == "Swampland") {
    fill(BLACK);
    text("Swamp(4)", LABEL_OFFSET_X, 320);
  }
  
  // Obstacle
  fill(BLACK);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 420, 60, 60);
  
  if(TERRAIN_TYPE == "Obstacle") {
    fill(BLACK);
    text("Obstacle", LABEL_OFFSET_X, 420);
  }
  
  // Open
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 520, 60, 60);
  
  if(TERRAIN_TYPE == "Open") {
    fill(BLACK);
    text("Open(1)", LABEL_OFFSET_X, 520);
  }
  
  // Start
  fill(RED);
  stroke(RED);
  ellipse(SELECTOR_OFFSET_X, 620, 60, 60);
  
  if(TERRAIN_TYPE == "Start") {
    fill(BLACK);
    text("Start(0)", LABEL_OFFSET_X, 620);
  }
  
  // Goal
  fill(WHITE);
  stroke(BLACK);
  ellipse(SELECTOR_OFFSET_X, 720, 60, 60);
  imageMode(CENTER);
  image(terrains.goalImage(), SELECTOR_OFFSET_X, 720, 30, 30);
  
  if(TERRAIN_TYPE == "Goal") {  
    fill(BLACK);
    text("Goal(0)", LABEL_OFFSET_X, 720);
  }
}

public void drawAnt() {
  fill(BLACK);
  ellipseMode(CENTER);
  ellipse(ant.position().x, ant.position().y, 
          ant.size(), ant.size());
}

public void drawStartText() {
  if(!PATHFINDING_OVER && terrains.start() != null & terrains.goal() != null) {
    fill(BLACK);
    textSize(22);
    textAlign(CENTER);
    text("Press SPACE To Start Pathfinding", SCREEN_WIDTH/2, 60);
  }
  
  if(PATHFINDING_OVER) {
    fill(BLACK);
    textSize(22);
    textAlign(CENTER);
    text("Press SPACE To Restart", SCREEN_WIDTH/2, 60);
    text("Total Cost Of Path: " + COST_PATH, SCREEN_WIDTH/2, 110);
  }
}
float  TERRAIN_SIZE            = 50;
String TERRAIN_TYPE            = "";
float  TERRAIN_NEIGHBOR_RADIUS = 50;

int SCREEN_WIDTH = 1000;
int SCREEN_HEIGHT = 1000;
float GRID_START_X = 150 + TERRAIN_SIZE;
float GRID_START_Y = 100 + TERRAIN_SIZE;
int   NUMBER_ROW = 16;
int   NUMBER_COL = NUMBER_ROW;
float OBSTACLE_COST = 256;

int WHITE = color(255);
int BLACK = color(0);
int GREEN = color(104, 237, 107);
int PURPLE = color(170, 153, 190);
int RED = color(210, 56, 32);

float SELECTOR_OFFSET_X = 120;
float LABEL_OFFSET_X    = 50;

float ANT_SIZE = 30;

boolean PATHFINDING_OVER = false;
int     COST_PATH = 0;
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
