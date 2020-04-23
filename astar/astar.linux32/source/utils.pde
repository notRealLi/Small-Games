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

color WHITE = color(255);
color BLACK = color(0);
color GREEN = color(104, 237, 107);
color PURPLE = color(170, 153, 190);
color RED = color(210, 56, 32);

float SELECTOR_OFFSET_X = 120;
float LABEL_OFFSET_X    = 50;

float ANT_SIZE = 30;

boolean PATHFINDING_OVER = false;
int     COST_PATH = 0;
