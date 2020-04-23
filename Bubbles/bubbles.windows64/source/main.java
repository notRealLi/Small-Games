import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

Bubbles bubbles;

public void setup() {
  // set up game windows specs
  size(SCREEN_WIDTH, SCREEN_HEIGHT); 
  frameRate(FRAME_RATE);
}

public void draw() {
  if(!GAME_START) {
    noLoop();
    titleScreen();
  }
  else {
    background(BACKGROUND_COLOR);
    
    int gameStatus = bubbles.update();
    
    if(frameCount % (2 * FRAME_RATE) == 0 && bubbles.wanderers.size() < WANDERER_MAX_NUMBER) {
      bubbles.wanderers.refillBubbles();
      //println(frameCount);
    }
    
    if(frameCount % (1 * FRAME_RATE) == 0 && bubbles.player.hp() > 0)
      bubbles.player.fade(FADING_RATE);
    
    if(frameCount % (5 * FRAME_RATE) == 0)
      bubbles.flockers.changeDirection(SCREEN_WIDTH, SCREEN_HEIGHT);
      
    if(gameStatus == 1 || gameStatus == -1) {
      noLoop();
      GAME_START = false;
      gameOverScreen(gameStatus);
    } 
  }
}

public void titleScreen() {
  background(BACKGROUND_COLOR);
  textAlign(CENTER);
  
  textSize(40);
  fill(TITLE_COLOR_1);
  text("Bubbles", SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 300); 
  
  textSize(30);
  fill(TITLE_COLOR_2);
  text("Please Click Anywhere To Start", SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
  
  fill(TITLE_COLOR_1);
  stroke(BACKGROUND_COLOR);
  ellipseMode(CENTER);
  ellipse(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 320, 100, 100);
  
  fill(TITLE_COLOR_3);
  for(int i=0;i<100; i++) {
    ellipse(random(0, SCREEN_WIDTH), random(SCREEN_HEIGHT - 400, SCREEN_HEIGHT), 20, 20);
  }
}

public void gameOverScreen(int gameStatus) {
  if(gameStatus == 1)
    GAME_OVER_MESSAGE = "You Win!";
  else
    GAME_OVER_MESSAGE = "You Lose...";
    
  background(BACKGROUND_COLOR);
  textAlign(CENTER);
  
  textSize(40);
  fill(TITLE_COLOR_1);
  text(GAME_OVER_MESSAGE, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 300); 
  
  textSize(30);
  fill(TITLE_COLOR_2);
  text("Please Click Anywhere To Replay", SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

public void mouseClicked() {
  if(!GAME_START) { 
    GAME_START = true;
    bubbles = new Bubbles();
    loop();
  }
}
abstract class Bubble {
  // cosmetic properties
  protected float radius;
  protected int bodyColor;
  
  // kinematic properties 
  protected Kinematic kin;
  
  // properties for arriving behavior
  protected float maxSpeed;
  protected float maxAcceleration;
  protected float slowRadius;
  protected float targetRadius;
  protected PVector target;
  
  protected boolean isAlive;
  
  protected Bubble(PVector pos, float radius, int bColor,
                   float maxSpeed, float maxAcceleration, 
                   float slowRadius, float targetRadius) {
    this.kin = new Kinematic(pos, 
                             0.0f, 
                             new PVector(0.0f, 0.0f), 
                             0.0f);
    this.radius    = radius;
    this.bodyColor = bColor;
    
    this.maxSpeed        = maxSpeed;
    this.maxAcceleration = maxAcceleration;
    this.slowRadius      = slowRadius;
    this.targetRadius    = targetRadius;
    this.target      = null;
    
    this.isAlive = true;
  }
  
  // public methods
  public void steer(PVector t) {}
  public void flock(ArrayList<Bubble> bubs, PVector t) {}
  public void shiftColor(int bColor) {}
  
  public boolean absorb(Bubble bub) {
    if(this.checkCenterDistance(bub) && this.checkRadiusDifference(bub)) 
      return true;
   
    return false;  
  }
  
  public void grow(Bubble bub) {
    this.radius += bub.radius*0.12f; 
  }
  
  // protected and private methods
  protected Steering seek(PVector target) {
    Steering steer = new Steering();
    PVector direction = PVector.sub(target, this.kin.getPosition());
    direction.normalize();
    steer.setLinear(PVector.mult(direction, this.maxAcceleration));
    
    return steer;
  }
  
  protected Steering arrive() {
    
    // get the direction then the distance of target
    PVector direction = PVector.sub(this.target, this.kin.getPosition());
    float distance = direction.mag();
    
    // check if target radius is reached  
    if(distance < targetRadius) {
      this.target = null;
      return null;
    }
    
    // set target speed according to whether slow radius is reached
    float targetSpeed;
    if(distance > slowRadius) {
      targetSpeed = this.maxSpeed;  
    }
    
    else
      targetSpeed = this.maxSpeed * distance/slowRadius * 0.8f;
    
    // set target velocity
    PVector targetVelocity = direction;
    targetVelocity.normalize();
    targetVelocity.mult(targetSpeed);
    
    // set accelleration
    Steering steering = new Steering();
    steering.linear = PVector.sub(targetVelocity, this.kin.getVelocity());
    
    if(steering.linear.mag() > this.maxAcceleration) {
      steering.linear.normalize();
      steering.linear.mult(this.maxAcceleration);
    }
      
    return steering;
  }
  
  protected boolean checkCenterDistance(Bubble bub) {
    PVector difference = PVector.sub(bub.kin.getPosition(), this.kin.getPosition());
    float distance = difference.mag();
     
    if(distance < (this.radius - bub.radius) * 0.5f)
      return true;
      
    return false;
  }
  
  protected boolean checkRadiusDifference(Bubble bub) { 
    if(this.radius > bub.radius * 2.6f)
      return true;

    return false;
  }
}
class Bubbles {
  private Player player;
  private Wanderers wanderers;
  private Flockers flockers;
  
  public Bubbles() {
    this.player = new Player(new PVector(SCREEN_WIDTH/2, SCREEN_HEIGHT/2),
                             PLAYER_INITIAL_RADIUS,
                             PLAYER_COLOR);
    
    this.wanderers = new Wanderers();
    this.flockers = new Flockers();  
    this.wanderers.add(this.player);
  }
  
  // public methods
  public int update() {
    this.flockers.update();
    this.wanderers.update();
    this.checkCollision();
    
    if(!this.player.isAlive || this.player.hp() < 1) {
      return -1;   
    } else if(this.player.radius >= WINNING_RADIUS) {
      return 1;
    } else {
      return 0;
    }
  }
  
  // private methods
  private void checkCollision() {
    for(int i=0; i<this.flockers.size(); i++) {
      if(PVector.dist(this.flockers.get(i).kin.getPosition(), this.player.kin.getPosition()) <
         (this.flockers.get(i).radius + this.player.radius)/2.4f) {
        this.player.isAlive = false;
       }
    }
  }
}
class Flocker extends Bubble {  
  public Flocker(PVector pos, float radius, int bColor) {
    super(pos, radius, bColor, 
          1.5f, // maxSpeed 
          0.2f, // maxAcceleration
          3.0f, 0.9f);        // Slow radius and target radius
  }
  
  public void flock(ArrayList<Bubble> bubs, PVector t) {
    this.target = t;
    
    Steering steerResult     = new Steering();
    ArrayList<Bubble> others = this.removeSelf(bubs);
    
    Steering velocityMatchResult = this.velocityMatch(others);
    Steering cohereResult        = this.cohere(others);
    Steering separateResult      = this.separate(others);
    Steering seekResult          = this.seek(this.target);
    
    velocityMatchResult.weight(1.0f);
    cohereResult.weight(1.5f);
    separateResult.weight(2.5f);
    seekResult.weight(3.0f);
    
    steerResult.add(velocityMatchResult);
    steerResult.add(cohereResult);
    steerResult.add(separateResult);
    steerResult.add(seekResult);
    
    if(steerResult != null)
      this.kin.update(steerResult, this.maxSpeed);
  }
  
  // private methods
  private Steering velocityMatch(ArrayList<Bubble> bubs) {
    float neighborRadius = 100.0f;
    PVector velocitySum = new PVector(0, 0);
    
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      float distance = PVector.sub(neighbor.kin.getPosition(), this.kin.getPosition())
                              .mag();
      
      if(distance < neighborRadius)
         velocitySum.add(neighbor.kin.getVelocity());
    }
    
    velocitySum.div(bubs.size());
    velocitySum.normalize();
    velocitySum.mult(this.maxSpeed);
    
    // set accelleration
    Steering steering = new Steering();
    steering.linear = PVector.sub(velocitySum, this.kin.getVelocity());
    
    if(steering.linear.mag() > this.maxAcceleration) {
      steering.linear.normalize();
      steering.linear.mult(this.maxAcceleration);
    }
      
    return steering;
  } 
  
  private Steering cohere(ArrayList<Bubble> bubs) {
    float neighborRadius = 100.0f;
    PVector centerPosition = new PVector(0, 0);
    
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      float distance = PVector.sub(neighbor.kin.getPosition(), this.kin.getPosition())
                              .mag();
      
      if(distance < neighborRadius)
         centerPosition.add(neighbor.kin.getPosition());
    }
    
    centerPosition.div(bubs.size());
    
    return this.seek(centerPosition);
  }
  
  private Steering separate(ArrayList<Bubble> bubs) {
    float separationThreshold = 50.0f;
    Steering steer = new Steering();
    
    for(int i=0; i<bubs.size(); i++) {
      Bubble neighbor = bubs.get(i);
      PVector direction = PVector.sub(this.kin.getPosition(), neighbor.kin.getPosition());
      float distance = direction.mag();
      
      float strength;
      float decay = 10.0f;
      if(distance < separationThreshold) {
        strength = min(decay/(distance*distance), this.maxAcceleration);
        strength = this.maxAcceleration;
        direction.normalize();
        steer.addLinear(PVector.mult(direction, strength));  
      }
    }
      
    return steer;
  }   
  
  private ArrayList<Bubble> removeSelf(ArrayList<Bubble> bubs) {
    ArrayList<Bubble> newBubs = (ArrayList<Bubble>)bubs.clone();
    
    for(int i=0; i<newBubs.size(); i++) {
      if(newBubs.get(i) == this) {
        newBubs.remove(i);
        return newBubs;
      }
    }
    
    return newBubs;
  }
}
class Flockers {
  private ArrayList<Bubble> bubs;
  private Renderer renderer;
  private PVector flockingDirection;
  
  public Flockers() {
    bubs = new ArrayList<Bubble>();
    for (int i=0; i<FLOCKER_MAX_NUMBER; i++) {
      bubs.add(new Flocker(new PVector(random(FLOCKER_INITIAL_MIN_X, FLOCKER_INITIAL_MAX_X), 
                                       random(FLOCKER_INITIAL_MIN_Y, FLOCKER_INITIAL_MAX_Y)), 
                           FLOCKER_INITIAL_RADIUS, 
                           FLOCKER_COLOR));
    }
    
    renderer = new Renderer();
    flockingDirection = new PVector(SCREEN_WIDTH, SCREEN_HEIGHT);
  }
  
  // getters
  public Bubble get(int i) {
    return this.bubs.get(i);
  }
  
  public ArrayList<Bubble> getArray() {
    return this.bubs;
  }
  
  // public methods
  public void update() {
    for(int i=0; i<this.size();i++) {
      this.get(i).flock(this.bubs, this.flockingDirection);
      renderer.render(this.get(i));
    }
  }
  
  public int size() {
    return this.bubs.size();
  }
  
  public void changeDirection(float maxX, float maxY) {
    this.flockingDirection = new PVector(random(0, maxX), 
                                         random(0, maxY));
  }
}
class Kinematic {
  private PVector position;
  private float   orientation;
  
  private PVector velocity;
  private float   rotation;
  
  public Kinematic(PVector pos, float orient, PVector v, float r) {
    this.position    = pos;
    this.orientation = orient;
    this.velocity    = v;
    this.rotation    = r;
  }
  
  // setters 
  public void setPosition(PVector pos) { 
    this.position = pos;
  }
  
  public void setOrientation(float orient) { 
    this.orientation = orient;
  }
  
  public void setVelocity(PVector v) { 
    this.velocity = v;
  }
  
  public void setRotation(float r) { 
    this.rotation = r;
  }
  
  // getters
  public PVector getPosition() { 
    return this.position;
  }
  
  public float getOrientation() { 
    return this.orientation;
  }
  
  public PVector getVelocity() { 
    return this.velocity;
  }
  
  public float getRotation() { 
    return this.rotation;
  }
  
  // methods
  public void update(Steering steering, float maxSpeed) {
    // update position
    this.position.add(this.velocity);
    this.orientation += this.rotation;
    
    // update acceleration
    this.velocity.add(steering.getLinear());
    
    // limit speed
    if (this.velocity.mag() > maxSpeed) {
      this.velocity.normalize();
      this.velocity.mult(maxSpeed);
    }
  }
}
class Player extends Bubble { 
  public Player(PVector pos, float radius, int bColor) {
    super(pos, radius, bColor, 
          3.0f,       // maxSpeed 
          0.6f,       // maxAcceleration
          3.0f, 1.5f); // Slow radius and target radius
  }
  
  // public methods
  public void steer(PVector t) {
    this.target = t;
    Steering arriveResult = this.arrive();
    
    if(arriveResult != null)
      this.kin.update(arriveResult, this.maxSpeed);
  } 
  
  public void fade(int bColor) {
    this.bodyColor -= bColor;
  }
  
  public float hp() {
    return alpha(this.bodyColor);
  }
}
class Renderer {
  private int screenWidth;
  private int screenHeight;
  
  public Renderer() {
    this.screenWidth = SCREEN_WIDTH;
    this.screenHeight = SCREEN_HEIGHT;
  }
  
  public void render(Bubble bub) {
    float radius = bub.radius;
    int fillColor = bub.bodyColor;
    
    PVector position = bub.kin.getPosition();
    position = toroidalize(position, radius);
    
    fill(fillColor);
    stroke(STROKE_COLOR);
    ellipseMode(CENTER);
    ellipse(position.x, position.y, radius, radius); 
  }
  
  public PVector toroidalize(PVector position, float radius) {
    if (position.x < -radius) {
      position.x = this.screenWidth + radius;
    }
    
    if (position.x > this.screenWidth + radius) {
      position.x = -radius;
    }
    
    if (position.y < -radius) {
      position.y = this.screenHeight + radius;
    }
    
    if (position.y > this.screenHeight + radius) {
      position.y = -radius;
    }
    
    return position;
  }
}
class Steering {
  private PVector linear;
  
  public Steering() {
    linear = new PVector(0, 0);
  }
  
  public Steering(PVector lin) {
    this.linear  = lin;
  }
  
  // setters 
  public void setLinear(PVector lin) { 
    this.linear = lin;
  }
  
  public void addLinear(PVector lin) { 
    this.linear.add(lin);
  }
  
  // getters
  public PVector getLinear() { 
    return this.linear;
  }
  
  // public methods
  public void add(Steering steer) {
    this.addLinear(steer.getLinear());
  }
  
  public void weight(float w) {
    this.linear.mult(w);
  }
}
class Wanderer extends Bubble {  
  // properties for wandering behavior
  private PVector wanderTarget;
  private float   wanderRange;
  
  public Wanderer(PVector pos, float radius, int bColor) {
    super(pos, radius, bColor, 
          random(0.8f, 1.0f), // maxSpeed 
          random(0.1f, 0.4f), // maxAcceleration
          3.0f, 0.9f);        // Slow radius and target radius
    
    this.wanderTarget = null;
    this.wanderRange = 300.0f;
  }
  
  // public methods
  public void steer(PVector t) {
    Steering steerResult = null;
    
    if (t == null)
      steerResult = this.wander();
    
    if(steerResult != null)
      this.kin.update(steerResult, this.maxSpeed);
  }
  
  private Steering wander() {
    if(this.target == null) {
      PVector position = this.kin.getPosition();
      
      float wanderTargetX = min(max(position.x + random(-this.wanderRange,this.wanderRange), 
                                    -this.radius),
                                width+radius);
      float wanderTargetY = min(max(position.y + random(-this.wanderRange,this.wanderRange), 
                                    -this.radius),
                                height+radius);
      this.target = new PVector(wanderTargetX, wanderTargetY);
    }
    
    return this.arrive();
  } 
}
class Wanderers {
  private ArrayList<Bubble> bubs;
  private Renderer renderer;
  
  public Wanderers() {
    this.bubs = new ArrayList<Bubble>();
    
    for (int i=0; i<WANDERER_MAX_NUMBER; i++) {
      this.bubs.add(new Wanderer(new PVector(random(0, SCREEN_WIDTH - 100), random(0, SCREEN_HEIGHT-100)), 
                                 random(WANDERER_MIN_INITIAL_RADIUS, WANDERER_MAX_INITIAL_RADIUS), 
                                 WANDERER_COLOR));
    }
    
    renderer = new Renderer();
  }
  
  // getters
  public Bubble get(int i) {
    return this.bubs.get(i);
  }
  
  public ArrayList<Bubble> getArray() {
    return this.bubs;
  }
  
  // setters
  public void set(int i, Bubble bub) {
    this.bubs.set(i, bub);
  }
  
  // public methods
  public void update() {
    this.sort();
    this.checkAbsorb();
    this.steer();
  }
  
  public void steer() {
    for(int i=0; i<this.size(); i++) {
      Bubble bub = this.get(i);
    
      if(bub instanceof Wanderer)
        bub.steer(null);
      else if(bub instanceof Player)
        bub.steer(new PVector(mouseX, mouseY));
      
      this.renderer.render(bub);
    }
  }
  
  public int size() {
    return this.bubs.size();
  }
  
  public void add(Bubble bub) {
    this.bubs.add(bub);
  }
  
  public void remove(int i) {
    this.bubs.remove(i);
  }
  
  // move
  private void sort() {
    for(int i=0; i<this.size()-1; i++) {
      for(int j=i+1; j<this.size(); j++) {  
        if(this.get(j).radius < this.get(i).radius) {
            Bubble temp = this.get(i);
            this.set(i, this.get(j));
            this.set(j, temp);
        }
      } 
    }
  }
  
  private void checkAbsorb() {
    for(int i=this.size()-1; i>=1; i--) {
      for(int j=i-1; j>=0; j--) { 
        if(this.get(i).isAlive &&
           this.get(j).isAlive &&
           this.get(i).absorb(this.get(j))) {
             this.get(i).grow(this.get(j));
             this.get(j).isAlive = false;
           }
      } 
    }
    
    for(int i=this.size()-1; i>=0; i--) {
      if(!this.get(i).isAlive)
       this.remove(i); 
    }
  }
  
  public void refillBubbles() {
    float radiusSum = 0;
    for(int i=0; i<this.size(); i++) {
      radiusSum += this.get(i).radius;
    }
    
    float radiusAvg = radiusSum / this.size();
    this.add(new Wanderer(new PVector(0, random(0, SCREEN_HEIGHT)), 
                          min(random(radiusAvg/5 , radiusAvg*2), SCREEN_HEIGHT/4), 
                          WANDERER_COLOR));
  }
}
// game configuration
int FRAME_RATE       = 70;    // frame rate 
int SCREEN_WIDTH     = 1300;  // screen width
int SCREEN_HEIGHT    = 900;   // screen height
int BACKGROUND_COLOR = 255;   // background color
int STROKE_COLOR     = 255;   // stroke color of bubbles
boolean GAME_START   = false; 
int TITLE_COLOR_1  = color(255, 87, 51, 255);
int TITLE_COLOR_2  = 0xff7B7B7B;
int TITLE_COLOR_3  = 0xffC8C5C4;
String GAME_OVER_MESSAGE;

// player
float PLAYER_INITIAL_RADIUS = 50.0f;
int PLAYER_COLOR          = color(255, 87, 51, 255);
float WINNING_RADIUS        = 450.0f;
int FADING_RATE           = color(0, 0, 0, 3);

// wanderers
int   WANDERER_MAX_NUMBER         = 80; 
float WANDERER_MIN_INITIAL_RADIUS = 5.0f;
float WANDERER_MAX_INITIAL_RADIUS = 60.0f;
int WANDERER_COLOR              = 0xffC8C5C4;

// flockers
int   FLOCKER_MAX_NUMBER       = 60;
float FLOCKER_INITIAL_MIN_X    = SCREEN_WIDTH/2 + 100;
float FLOCKER_INITIAL_MAX_X    = SCREEN_WIDTH/2 + 300;
float FLOCKER_INITIAL_MIN_Y    = SCREEN_HEIGHT/2 + 100;
float FLOCKER_INITIAL_MAX_Y    = SCREEN_HEIGHT/2 + 300;
float FLOCKER_INITIAL_RADIUS   = 20;
int FLOCKER_COLOR            = 0xff7B7B7B;
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
