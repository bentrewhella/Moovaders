 
class InvaderWave {
  ArrayList invaders;
  int speedX;
  int xStart;
  int xEnd;
  int yPos;
  
  int lastBombTime;
  int bombWait;
  
  
  // difficulty
  // invader bombRate;
  // invader speed;
  // invader hit points;

  
  InvaderWave (int level, int tyPos, int tSpeedX) {
    invaders = new ArrayList();
    speedX = level*80;
    
    
    lastBombTime = 0;
    bombWait = (int) random (200, 500);
    
    int levelLoadNum = ((level-1)%6)+1;
    
    String filename = ("Level" + levelLoadNum + ".png");
    
    PImage levelImage = loadImage (filename);
    levelImage.loadPixels();
    
    int placeXPosMult = (width * 3/4)/levelImage.width;
    int placeYPosMult = (height * 1/2)/levelImage.height;
    int placeXSize = placeXPosMult * 4/5;
    int placeYSize = placeYPosMult * 4/5;
    
    
    for (int y = 0; y < levelImage.height; y++) {
      for (int x = 0; x < levelImage.width; x++) {
        int loc = x + y*levelImage.width;
        
        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        float r = red(levelImage.pixels[loc]);
        if (r == 255) {
          //draw an enemy
         Invader newInvader = new Invader (x * placeXPosMult, tyPos+ (y * placeYPosMult), placeXSize, placeYSize, level);
         invaders.add(newInvader);
        }
      }
    }  
  }
  
  void moveWave(int yTrans) {
    float moveRate = (float) speedX / 1000.0 * frameTime;
    
    Invader leftMostInvader = (Invader) invaders.get(0);
    Invader rightMostInvader = (Invader) invaders.get(0);
    
    for (int i = 0; i < invaders.size(); i++) {
      Invader nextInvader = (Invader) invaders.get(i);
      if (leftMostInvader.posX > nextInvader.posX) {
        leftMostInvader = nextInvader;
      }
      if (rightMostInvader.posX < nextInvader.posX) {
        rightMostInvader = nextInvader;
      }
    }
    
    if (leftMostInvader.posX + moveRate < 20 || rightMostInvader.posX + moveRate > width - 20) {
      // reverse direction
      speedX = -speedX;
      moveRate = (float) speedX / 1000.0 * frameTime;
    }
    
    // now do movement
    for (int i = 0; i < invaders.size(); i++) {
      Invader nextInvader = (Invader) invaders.get(i);
      nextInvader.moveInvader((int)moveRate, yTrans);
    }
    
    if (gameActive && millis() - lastBombTime > bombWait) {
      //select a random 
      int randomBomberLocation = (int) random(0, invaders.size()-1);
      Invader bomber = (Invader) invaders.get(randomBomberLocation);
      Bullet newBomb = new Bullet (bomber.posX, bomber.posY, true, 300);
      invaderBombs.add(newBomb);
      lastBombTime = millis();
      bombWait = (int) random (3000/invaders.size(), 10000/invaders.size());
    }
    
  }
  
 
  
  void drawWave () {
    for (int i = 0; i < invaders.size(); i++) {
        Invader nextInvader = (Invader) invaders.get(i);
        nextInvader.drawInvader();
    }
  }
}
