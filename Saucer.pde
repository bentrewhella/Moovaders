class Saucer {
  int posX;
  int posY;
  int lengthX;
  int lengthY;
  int timeStarted;
  
  PImage saucerTemplate;
  PImage saucerSprite;
  
  Saucer () {
    timeStarted = millis();
    posX = 0;
    posY = -20;
    lengthX = 60;
    lengthY = 30;
    saucerTemplate = loadImage("UFO.png");
    saucerTemplate.loadPixels();
    
     color baseColor = color(random(0,255), random(0,255), random(0,255));
    // update the base image
    for (int y = 0; y < saucerTemplate.height; y++) {
      for (int x = 0; x < saucerTemplate.width; x++) {
        int loc = x + y*saucerTemplate.width;
        if (alpha (saucerTemplate.pixels[loc]) == 255) {
          saucerTemplate.pixels[loc] = baseColor;
        }
      }
    }
    
    // add a pattern
    for (int j = 0; j < 5; j++) {
        color c = color(random(0,255), random(0,255), random(0,255));
        
        // chaose a random row
        int y = (int) random (0, saucerTemplate.height);
        int x = (int) random (0, saucerTemplate.width);
        int loc = x + y*saucerTemplate.width;
      
        // loop until we find a solid block
        while (alpha (saucerTemplate.pixels[loc]) != 255) {
          y = (int) random (0, saucerTemplate.height);
          x = (int) random (0, saucerTemplate.width);
          loc = x + y*saucerTemplate.width;
        }
        
        // now loop and walk
        while (alpha (saucerTemplate.pixels[loc]) == 255) {
          // color this block
          saucerTemplate.pixels[loc] = c;
          // also update the mirror image
          int x1 = saucerTemplate.width - x - 1;
          int loc1 = x1 + y*saucerTemplate.width;
          saucerTemplate.pixels[loc1] = c;
          
          y += (int) random (-2,2);
          x += (int) random (-2,2);
          
          if (y < 0 || y > saucerTemplate.height || x < 0 || x > saucerTemplate.width) {
            break;
          }
          else {
            loc = x + y*saucerTemplate.width;
            if (loc >= saucerTemplate.width * saucerTemplate.height) {
              break;
            } 
          }
        }
    }
  
    saucerTemplate.updatePixels();   
    saucerSprite = saucerTemplate;
  }
  
  void moveSaucer () {
    float newTime = millis() - timeStarted;
    float smallNewTime = newTime/1000;
    posX = (int) (noise(smallNewTime) * width);
  }
  
  void drawSaucer () {
    imageMode (CENTER);
    image (saucerSprite, posX, posY, lengthX, lengthY);
  }
  
}

