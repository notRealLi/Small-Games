// game configuration
int FRAME_RATE       = 70;                      // frame rate 
int SCREEN_WIDTH     = 1300;                    // screen width
int SCREEN_HEIGHT    = 900;                     // screen height
int BACKGROUND_COLOR = 255;                     // background color
int STROKE_COLOR     = 255;                     // stroke color of bubbles
boolean GAME_START   = false;                   // if the game has started
color TITLE_COLOR_1  = color(255, 87, 51, 255); // title font color
color TITLE_COLOR_2  = #7B7B7B;                 // title font color
color TITLE_COLOR_3  = #C8C5C4;                 // title font color
String GAME_OVER_MESSAGE;                       // game over message 

// player
float PLAYER_INITIAL_RADIUS = 50.0;
color PLAYER_COLOR          = color(255, 87, 51, 255);
float WINNING_RADIUS        = 450.0;                   // player wins when they reach this size
color FADING_RATE           = color(0, 0, 0, 3);       // speed of player hp decreasing

// wanderers
int   WANDERER_MAX_NUMBER         = 80; 
float WANDERER_MIN_INITIAL_RADIUS = 5.0;
float WANDERER_MAX_INITIAL_RADIUS = 60.0;
color WANDERER_COLOR              = #C8C5C4;

// flockers
int   FLOCKER_MAX_NUMBER       = 60;
float FLOCKER_INITIAL_MIN_X    = SCREEN_WIDTH/2 + 100;
float FLOCKER_INITIAL_MAX_X    = SCREEN_WIDTH/2 + 300;
float FLOCKER_INITIAL_MIN_Y    = SCREEN_HEIGHT/2 + 100;
float FLOCKER_INITIAL_MAX_Y    = SCREEN_HEIGHT/2 + 300;
float FLOCKER_INITIAL_RADIUS   = 20;
color FLOCKER_COLOR            = #7B7B7B;
