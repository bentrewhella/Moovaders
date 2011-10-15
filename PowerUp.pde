class PowerUp {
  int posX;
  int posY;
  int lengthX;
  int lengthY;
  int speedY;
  int type;
  /* 
  0 = fireRate
  1 = numGuns
  2 = recharge rate
  3 = extra life
  4 = bullet power
  */
  
  PImage powTemplate;
  PImage powSprite;
  
  PowerUp (int tX, int tY) {
    posX = tX;
    posY = tY;
    lengthX = 30;
    lengthY = 30;
    speedY = 100;
    type = (int) random (0,5); 
    loadPowerUp();
  }
  
  void loadPowerUp () {
    switch (type) {
      case 0: // fireRate
        powTemplate = loadImage("PowFireSpeed.png");
        break;
      case 1: // numGuns
        powTemplate = loadImage("PowNumGuns.png");
        break;
      case 2: // Recharge rate
        powTemplate = loadImage("PowRecharge.png");
        break;
      case 3: // extra life
        powTemplate = loadImage("PowLife.png");
        break;
      case 4: // bullet power
        powTemplate = loadImage("PowBulletPower.png");
        break;
    }
    powTemplate.loadPixels();
  
    color baseColor = color(random(0,255), random(0,255), random(0,255));
    // update the base image
    for (int y = 0; y < powTemplate.height; y++) {
      for (int x = 0; x < powTemplate.width; x++) {
        int loc = x + y*powTemplate.width;
        if (alpha (powTemplate.pixels[loc]) == 255) {
          powTemplate.pixels[loc] = baseColor;
        }
      }
    }
  
    powTemplate.updatePixels();   
    powSprite = powTemplate; 
  }
  
  void movePowerUp () {
    float moveRate = (float) speedY/1000.0 * frameTime;
    posY += (int) moveRate;
    if (posY > height) {
      powerUps.remove(this);
    }
  }
  
  void drawPowerUp () {
     imageMode (CENTER);
    image (powSprite, posX, posY, lengthX, lengthY);
  }
}
