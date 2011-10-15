
boolean gameActive;
int startTransTime;
int lastTransDrawTime;
PImage flameImage;

void startLevel1Trans () {
  mDefender = new Defender (width/2, height, 40,20);
  level = 1;
  invaderBombs = new ArrayList();
  explosions = new ArrayList();
  powerUps = new ArrayList();
  backgroundRotation = 0.0;
  startNextLevelTrans();
  flameImage = loadImage("Flame.png");
}

void drawLevelTrans () {
  int curTime = millis();
  
  if (curTime - startTransTime > 3000) {
    gameActive = true;
    gameState = 2;
  }
  else {
    // move mdefender absolutely
    //float moveAbs =  (height+60) - (0.03 * (curTime - startTransTime));
    float moveAbs;
    if (level == 1) {
      moveAbs = (height-30) + 80 * cos(radians(((curTime-startTransTime)/3000.0)*270));
    }
    else {
      moveAbs = (height-30) - 80 * sin(radians(((curTime-startTransTime)/3000.0)*180));
    }
    mDefender.moveDefender((int)moveAbs);
    // move invader wave incrementally
    float moveRate =  0.15 * (curTime - lastTransDrawTime);
    invaderWave.moveWave((int)moveRate);
    
  }
  
  for (int i = 0; i < powerUps.size(); i++) {
    PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
    nextPowerUp.movePowerUp();
  }
  for (int i = 0; i < invaderBombs.size(); i++) {
    Bullet nextBomb = (Bullet) invaderBombs.get(i);
    nextBomb.moveBullet();
  }
  for (int i = 0; i < explosions.size(); i++) {
    Explosion nextExplosion = (Explosion) explosions.get(i);
    nextExplosion.moveExplosion();
  }
  
  if (saucer != null) {
    saucer.moveSaucer();
  }
  
  pushMatrix();
  translate (0,0,-100);
  
  //backgroundRotation = 0.0067 * (curTime - startTransTime);
  if (backgroundRotation < 60) {
    backgroundRotation += 0.03;
  }
  rotateX(radians(backgroundRotation));
  
  background(50,0,50);
  drawBackground();
  
  mDefender.drawDefender();
  if (curTime-startTransTime < 2000 && curTime%2 == 0) {
    // draw flame effect
    image (flameImage, mDefender.posX-10, mDefender.posY+15, 10, 10);
    image (flameImage, mDefender.posX+10, mDefender.posY+15, 10, 10);
  }
    
  for (int i = 0; i < powerUps.size(); i++) {
    PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
    nextPowerUp.drawPowerUp();
  } 
  
   invaderWave.drawWave();
   /* don't draw the saucer
   if (saucer != null) {
     saucer.drawSaucer();
   }*/
  
   for (int i = 0; i < invaderBombs.size(); i++) {
      Bullet nextBomb = (Bullet) invaderBombs.get(i);
      nextBomb.drawBullet();
   }
    
   for (int i = 0; i < explosions.size(); i++) {
     Explosion nextExplosion = (Explosion) explosions.get(i);
     nextExplosion.drawExplosion();
   }
   
  popMatrix();
  int storeAmmoX = width - 20;
    for (int i = 0; i < mDefender.ammo; i++) {
      rect (storeAmmoX, 20, 2, 5);
      storeAmmoX -= 10;
    }
   
   textFont (font30, 30);
   fill(255,255,40);
   textAlign(LEFT);
   text("Score: " + mDefender.score, 20, 40); 
   text("Lives: " + mDefender.lives, 20, 80); 
  lastTransDrawTime = millis();
}

void startNextLevelTrans () {
  invaderWave = new InvaderWave (level, -300, 200);
  gameActive = false;
  startTransTime = millis();
  lastTransDrawTime = startTransTime;
}

void startGameOverTrans() {
  startTransTime = millis();
  gameState = 3;
}

void drawGameOverTrans() {
  int curTime = millis();
  
  if (curTime - startTransTime > 1500) {
    gameState = 4;
    
  }

  else {
    invaderWave.moveWave(0);
    for (int i = 0; i < powerUps.size(); i++) {
      PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
      nextPowerUp.movePowerUp();
    }
    for (int i = 0; i < invaderBombs.size(); i++) {
      Bullet nextBomb = (Bullet) invaderBombs.get(i);
      nextBomb.moveBullet();
    }
    for (int i = 0; i < explosions.size(); i++) {
      Explosion nextExplosion = (Explosion) explosions.get(i);
      nextExplosion.moveExplosion();
    }
    pushMatrix();
    
    float transRatio = (curTime - startTransTime)/1000.0;
    float transX = transRatio * (mDefender.posX-width/2);
    float transY = transRatio * (mDefender.posY-height/2);
    float transZ = (transRatio * 500) - 100;
    
    rotateX(radians(backgroundRotation));
    translate (-transX,-transY,transZ);
    
   
  
    background(50,0,50);
    drawBackground();
    for (int i = 0; i < defenderParticles.size(); i++) {
      Particle p = (Particle) defenderParticles.get(i);
      p.update();
      p.drawParticle();
    }
    for (int i = 0; i < powerUps.size(); i++) {
    PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
    nextPowerUp.drawPowerUp();
  } 
  
   invaderWave.drawWave();
   /* don't draw the saucer
   if (saucer != null) {
     saucer.drawSaucer();
   }*/
  
   for (int i = 0; i < invaderBombs.size(); i++) {
      Bullet nextBomb = (Bullet) invaderBombs.get(i);
      nextBomb.drawBullet();
   }
    
    popMatrix();
    int storeAmmoX = width - 20;
    for (int i = 0; i < mDefender.ammo; i++) {
      rect (storeAmmoX, 20, 2, 5);
      storeAmmoX -= 10;
    }
   
   textFont (font30, 30);
   fill(255,255,40);
   textAlign(LEFT);
   text("Score: " + mDefender.score, 20, 40); 
   text("Lives: " + mDefender.lives, 20, 80); 
   
   imageMode(CENTER);
   tint (255, 255*transRatio);
   image(gameOver, width/2, height/2, 400, 50);
   
  lastTransDrawTime = millis();
  }
  
}
  
