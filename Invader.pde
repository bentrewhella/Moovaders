class Invader {
  int posX;
  int posY;
  int lengthX;
  int lengthY;
  int offsetY;
  int normalPosY;

  
  int health;
  
  PImage invaderTemplateImage;
  PImage sprite;
  
  Invader (int tX, int tY, int tWidth, int tHeight, int level) {
    posX = tX;
    posY = tY;
    lengthX = tWidth;
    lengthY = tHeight;
    offsetY = 50;
    normalPosY = tY;
    health=level;
    
    invaderTemplateImage = loadImage ("Invader.png");
    
    invaderTemplateImage.loadPixels();
  
    color baseColor = color(random(0,255), random(0,255), random(0,255));
    // update the base image
    for (int y = 0; y < invaderTemplateImage.height; y++) {
      for (int x = 0; x < invaderTemplateImage.width; x++) {
        int loc = x + y*invaderTemplateImage.width;
        if (alpha (invaderTemplateImage.pixels[loc]) != 0) {
          invaderTemplateImage.pixels[loc] = baseColor;
        }
      }
    }
    
    // add a pattern
    for (int j = 0; j < 3; j++) {
        color c = color(random(0,255), random(0,255), random(0,255));
        
        // chaose a random row
        int y = (int) random (0, invaderTemplateImage.height);
        int x = (int) random (0, invaderTemplateImage.width);
        int loc = x + y*invaderTemplateImage.width;
      
        // loop until we find a solid block
        while (alpha (invaderTemplateImage.pixels[loc]) == 0) {
          y = (int) random (0, invaderTemplateImage.height);
          x = (int) random (0, invaderTemplateImage.width);
          loc = x + y*invaderTemplateImage.width;
        }
        
        // now loop and walk
        while (alpha (invaderTemplateImage.pixels[loc]) != 0) {
          // color this block
          invaderTemplateImage.pixels[loc] = c;
          // also update the mirror image
          int x1 = invaderTemplateImage.width - x - 1;
          int loc1 = x1 + y*invaderTemplateImage.width;
          invaderTemplateImage.pixels[loc1] = c;
          
          y += (int) random (-2,2);
          x += (int) random (-2,2);
          
          if (y < 0 || y > invaderTemplateImage.height || x < 0 || x > invaderTemplateImage.width) {
            break;
          }
          else {
            loc = x + y*invaderTemplateImage.width;
            if (loc >= invaderTemplateImage.width * invaderTemplateImage.height) {
              break;
            } 
          }
        }
    }
  
    invaderTemplateImage.updatePixels();   
    sprite = invaderTemplateImage;
  }
  
  void removeChunck (int bulletX, int bulletY) {
    
    sprite.loadPixels();
    color clear = color(0,0,0,0);
     
     int normalX = posX - (lengthX/2);
     int normalY = posY - (lengthY/2);
   
     int offsetX = bulletX - normalX;
     int offsetY = bulletY - normalY;
    
     
     float ratioX = (float) sprite.width / (float) lengthX;
     float ratioY = (float) sprite.height / (float) lengthY;
    
     
     float explodeX = offsetX * ratioX;
     float explodeY = offsetY * ratioY;
     
     
     
     for (int y = -1; y < 4; y++) {
      for (int x = -1; x < 3; x++) {
        int pixelX = (int) explodeX + x;
        int pixelY = (int) explodeY + y;
        
        if (pixelX >= 0 && pixelX < sprite.width && pixelY >= 0 && pixelY < sprite.height) {
          int loc = pixelX + pixelY * sprite.width;
          sprite.pixels[loc] = clear;
        }
      }
     }
     sprite.updatePixels();
  }
  
  void moveInvader (int xMove, int yMove) {
    posX += xMove;
    posY += yMove;
  }
  
  void drawInvader () {
    /* stroke(255);
    fill(125);
    rectMode (CORNER);
    rect (posX, posY, lengthX, lengthY);*/
    
    imageMode(CENTER);
    //float healthAlpha = (255/5) * health;
   // tint (255, (int) healthAlpha);
    image (sprite, posX, posY, lengthX, lengthY);
    
  }
  
}
