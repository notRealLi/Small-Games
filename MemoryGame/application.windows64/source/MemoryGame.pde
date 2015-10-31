int maxColumn = 4; // Number of columns 
int maxRow = 3; // Number of rows

int numTiles = 12; // Number of tiles
Tile[] tiles = new Tile[numTiles]; // Array of tiles
Tile[] revealedTiles = new Tile[numTiles]; // Array of showing tiles

int tWidth; // Width of columns 
int tHeight; // Height of columns 

int numImage = 6; // Number of images

PImage[] images = new PImage[numImage]; // Array of images

int numRevealed = 0; // Number of showing tiles
boolean pause = false; // If the game is paused

void setup () {
  size(600,800);
  tWidth = width / maxRow;
  tHeight = height / maxColumn;
  
  images[0] = loadImage("0.jpg");
  images[1] = loadImage("1.jpg");
  images[2] = loadImage("2.jpg");
  images[3] = loadImage("3.jpg");
  images[4] = loadImage("4.jpg");
  images[5] = loadImage("5.jpg");
  
  initialize();
}

void draw () {
  int numMatched = 0; // Number of revealed tiles
  
  for (int i = 0; i < numTiles; i++) {   
    tiles[i].drawTile(); // Drawing tiles
    
    // Counting revealed tiles
    if (tiles[i].ifRevealed)
      numMatched++;
  }
  
  // Showing winning message and pause the game
  if (numMatched > 11) {
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(40);
    text("You won!", width/2, height/2);
    text("Click to start a new game.", width/2, height/2 + 40);
    noLoop();
    pause = true;
  }
}

class Tile {
  float posX; // X position of tile
  float posY; // Y position of tile
  PImage image; // Image of tile
  int imageID; // ID of image of tile
  boolean ifRevealed; // if tile is revealed
  boolean ifImage; // if tile is assigned an image
  
  Tile (float x, float y) {
    posX = x;
    posY = y;
    ifImage = false;
    ifRevealed = false;
  }
  
  // Tile drawing function
  void drawTile () {
    // Draw picture
    if (ifRevealed)
      image(image, posX, posY, tWidth, tHeight);
    
    // Draw tile
    else {
      stroke(255);
      strokeWeight(5);
      fill(0);
      rect(posX, posY, tWidth, tHeight);
    }
  }
}

void initialize () {
  
  // Create Tile objects and draw them on screen
  for (int row = 0; row < maxRow; row++) {
    for (int column = 0; column < maxColumn; column++) { 
      tiles[row * maxColumn + column] = new Tile(row * tWidth, column * tHeight);
      tiles[row * maxColumn + column].drawTile();
    }
  }  
  
  // Assign a pair of tiles with the same image
  for (int i = 0; i < numTiles/2; i++) {
    assignImage(i);
    assignImage(i);
  }   
}

void assignImage (int num) {
  
  int r = int(random(11.99));
  
  // Loop to find a tile without an image
  while (tiles[r].ifImage) {
    r = int(random(11.99));
  }
  
  tiles[r].image = images[num];
  tiles[r].ifImage = true;
  tiles[r].imageID = num;
}

void mousePressed () {
  
  // Check if an unrevealed tile is clicked
  for (int i = 0; i < numTiles; i++) {
    if (mouseX >= tiles[i].posX && mouseX <= (tiles[i].posX + tWidth) &&
        mouseY >= tiles[i].posY && mouseY <= (tiles[i].posY + tHeight) &&
        tiles[i].ifRevealed == false) {
      
          
      if (numRevealed > 1) {
        
        // Check if showing tiles match images 
        if (revealedTiles[0].imageID != revealedTiles[1].imageID)
          revealedTiles[0].ifRevealed = revealedTiles[1].ifRevealed = false;
        numRevealed = 0;
      }
      
      revealedTiles[numRevealed] = tiles[i];    
      numRevealed++;     
      tiles[i].ifRevealed = !tiles[i].ifRevealed;
     
    }
  }
  
  // Click screen to restart game
  if (pause) {
    pause = false;
    initialize();
    loop();
  }
}
