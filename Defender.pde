class Defender {
  int posX;
  int posY;
  int lengthX;
  int lengthY;
  float easingX;
  int ammo;
  int fullAmmo;
  int numGuns;
  ArrayList bullets;
  float lastShotTime;
  int score;
  int lives;
  int keyMove;
  int firingRate;
  int lastRecharged;
  int rechargeRate;
  int bulletPower;
  
  PImage defenderTemplateImage;
  PImage defenderSprite;
  
  // power up stuff
  // defender fire rate
  // defender speed
  // extra life
  // score up
  // number of guns
  // gun speed
  
  Defender (int tX, int tY, int tWidth, int tHeight) {
    posX = tX;
    posY = tY;
    lengthX = tWidth;
    lengthY = tHeight;
    easingX = 0.15;
    
    ammo = 10;
    fullAmmo = 10;
    bullets = new ArrayList();
    
    lastShotTime = 0.0;
    lastRecharged = 0;
    
    score = 0;
    lives = 5;
    keyMove = 0;
    numGuns = 1;
    firingRate = 200;
    rechargeRate = 300;
    bulletPower = 1;
    
    defenderTemplateImage = loadImage ("Spaceship.png");
    defenderTemplateImage.loadPixels();
    
    color baseColor = color(random(0,255), random(0,255), random(0,255));
    // update the base image
    for (int y = 0; y < defenderTemplateImage.height; y++) {
      for (int x = 0; x < defenderTemplateImage.width; x++) {
        int loc = x + y*defenderTemplateImage.width;
        if (alpha (defenderTemplateImage.pixels[loc]) == 255) {
          defenderTemplateImage.pixels[loc] = baseColor;
        }
      }
    }
    
    // add a pattern
    for (int j = 0; j < 5; j++) {
        color c = color(random(0,255), random(0,255), random(0,255));
        
        // chaose a random row
        int y = (int) random (0, defenderTemplateImage.height);
        int x = (int) random (0, defenderTemplateImage.width);
        int loc = x + y*defenderTemplateImage.width;
      
        // loop until we find a solid block
        while (alpha (defenderTemplateImage.pixels[loc]) != 255) {
          y = (int) random (0, defenderTemplateImage.height);
          x = (int) random (0, defenderTemplateImage.width);
          loc = x + y*defenderTemplateImage.width;
        }
        
        // now loop and walk
        while (alpha (defenderTemplateImage.pixels[loc]) == 255) {
          // color this block
          defenderTemplateImage.pixels[loc] = c;
          // also update the mirror image
          int x1 = defenderTemplateImage.width - x - 1;
          int loc1 = x1 + y*defenderTemplateImage.width;
          defenderTemplateImage.pixels[loc1] = c;
          
          y += (int) random (-2,2);
          x += (int) random (-2,2);
          
          if (y < 0 || y > defenderTemplateImage.height || x < 0 || x > defenderTemplateImage.width) {
            break;
          }
          else {
            loc = x + y*defenderTemplateImage.width;
            if (loc >= defenderTemplateImage.width * defenderTemplateImage.height) {
              break;
            } 
          }
        }
    }
  
    defenderTemplateImage.updatePixels();   
    defenderSprite = defenderTemplateImage;
    
  }
  
  void shootBullet () {
    
    Bullet nBullet;
    switch (numGuns) {
      case 1: 
        if (ammo > 0) {
          nBullet = new Bullet (posX, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          ammo--;
        }
        break;
      case 2:
        if (ammo > 1) {
          nBullet = new Bullet (posX-15, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          nBullet = new Bullet (posX+15, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          ammo -= 2;
        }
        break;
      case 3:
        if (ammo > 2) {
          nBullet = new Bullet (posX-15, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          nBullet = new Bullet (posX, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          nBullet = new Bullet (posX+15, posY-8, false, -500); // speed measured in pixels per second
          bullets.add(nBullet);
          ammo -=3;
        }
        break;
    }
    lastShotTime = millis();
   // shootSample.trigger();
  }
  
  
  
  void moveDefender (int yAbs) {
    // movement
    posY = yAbs;
     if (useMouse) {
        float newX = (mouseX - posX) * easingX;
        posX +=  (int) newX;
        if (gameActive && mousePressed && ammo > 0 && (millis() - lastShotTime) > firingRate) {
          shootBullet();
        }
     }
     
     else {
       if (rightPressed && !leftPressed && keyMove < 10) {
         keyMove += 1;
       }
       if (leftPressed && !rightPressed && keyMove > -10) {
         keyMove -= 1;
       }
       if ((leftPressed && rightPressed) || (!leftPressed && !rightPressed)) {
         if (keyMove > 0) {
           keyMove -= 1;
         }
         if (keyMove < 0) {
           keyMove += 1;
         }
       }
       posX += keyMove;
       if (posX < -20) {
         posX = -20;
         keyMove = 0;
       }
       if (posX > width+20) {
         posX = width+20;
         keyMove = 0;
       }  
       if (gameActive && firePressed && ammo > 0 && (millis() - lastShotTime) > firingRate) {
         shootBullet();
       }      
     }

   
    // move existing bullets
    for (int i = 0; i < bullets.size(); i++) {
      Bullet nextBullet = (Bullet) bullets.get(i);
      nextBullet.moveBullet();
    }
    
    // recharge bullets if neccessary
    if (millis() - lastRecharged > rechargeRate && ammo < fullAmmo) {
      ammo++;
      lastRecharged = millis();
    }
  
    // check to see if hit powerup
    
    for (int i = 0; i < powerUps.size(); i++) {
      PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
      if (posX+lengthX/2 > nextPowerUp.posX - nextPowerUp.lengthX/2 && posX-lengthX/2 < nextPowerUp.posX + nextPowerUp.lengthX/2 && 
          posY+lengthY/2 > nextPowerUp.posY - nextPowerUp.lengthY/2 && posY-lengthY/2 < nextPowerUp.posY + nextPowerUp.lengthY/2) {
        // process powerup
        switch (nextPowerUp.type) {
          case 0: // firing rate
            firingRate *= 0.8;
            break;
          case 1: // number guns
            if (numGuns < 3) {
              numGuns++;
            } 
          case 2: // recharge rate
            rechargeRate *= 0.8;
            break;
          case 3: // extra life
            lives++;
            break;
          case 4: // bullet power
            bulletPower++;
            break;
        }
        powerUps.remove(nextPowerUp);
      }
    }
    
  }
  
  void explodeDefender () {
    // run through each pixel and create an array
    defenderParticles = new ArrayList();
    
    defenderSprite.loadPixels();
    for (int y = 0; y < defenderSprite.height; y++) {
      for (int x = 0; x < defenderSprite.width; x++) {
        int loc = x + y*defenderSprite.width;
        if (alpha (defenderSprite.pixels[loc]) == 255) {
          // we have a block
          PVector vec = new PVector (posX + 3*(x-(defenderSprite.width/2)), posY + 3*(y-(defenderSprite.height/2)), 0.0);
          Particle newP = new Particle (vec, defenderSprite.pixels[loc]);
          defenderParticles.add(newP);
        }
      }
    }
    
    startGameOverTrans();
  }
  
  void drawDefender () {
    imageMode (CENTER);
    image (defenderSprite, posX, posY, lengthX, lengthY);
    for (int i = 0; i < bullets.size(); i++) {
      Bullet nextBullet = (Bullet) bullets.get(i);
      nextBullet.drawBullet();
    }
  }
}


