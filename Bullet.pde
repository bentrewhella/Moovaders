int invadersKilled = 1;

class Bullet {
  int speed;
  int posX;
  int posY;
  boolean enemyBullet;
  boolean hit;
  
  Bullet (int tX, int tY, boolean tEnemyBullet, int tSpeed) {
    speed = tSpeed;
    posY = tY;
    posX = tX;
    hit = false;
    enemyBullet = tEnemyBullet;
  }
  
  void moveBullet () {
    float moveRate = (float) speed/1000.0 * frameTime;
    posY += (int) moveRate;
  
    // collision detection
    if (!enemyBullet) {
      if (posY < -100) {
        mDefender.bullets.remove(this);
       // mDefender.ammo++;
      }
      for (int j = 0; j < invaderWave.invaders.size(); j++) {
        Invader nextInvader = (Invader) invaderWave.invaders.get(j);
    
        if (!hit && posX >= nextInvader.posX-nextInvader.lengthX/2 && posX <=nextInvader.posX+nextInvader.lengthX/2 && posY >= nextInvader.posY-nextInvader.lengthY/2 && posY <= nextInvader.posY+nextInvader.lengthY/2) {
          
          //invader destroyed
          hit = true;
          Explosion newExplosion = new Explosion (posX, posY, 10);
          explosions.add(newExplosion);
          mDefender.score+= 10;
          nextInvader.health-= mDefender.bulletPower;
          nextInvader.removeChunck(posX, posY);
          if (nextInvader.health <= 0) {
            //invaders.remove(invaders.indexOf(nextInvader));
            mDefender.score+= 100;
            invaderWave.invaders.remove(nextInvader);
            invadersKilled++;
          }
          
        }
      }
      
      // probably not the best place for this
      if (invaderWave.invaders.isEmpty()) {
          // level complete
          newLevel();
      }
      
      // see if hit the saucer
     if (saucer != null) {
      if (posX >= saucer.posX - saucer.lengthX/2 && posX <= saucer.posX + saucer.lengthX/2 && posY >= saucer.posY - saucer.lengthY/2 && posY <= saucer.posY + saucer.lengthY/2) {
        mDefender.score += 1000;
        
        Explosion newExplosion = new Explosion (posX, posY, 20);
        explosions.add(newExplosion);
        // release power up
        PowerUp newPowerUp = new PowerUp(saucer.posX, saucer.posY);
        powerUps.add(newPowerUp);
        saucer = null;
      }
     }
     if (invadersKilled % 10 == 0 && saucer == null && powerUps.isEmpty()) {
        // generate a new saucer
        saucer = new Saucer();
      }
      
      for (int i = 0; i < powerUps.size(); i++) {
        PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
        if (posX >= nextPowerUp.posX - nextPowerUp.lengthX/2 && posX < nextPowerUp.posX + nextPowerUp.lengthX/2 && 
          posY > nextPowerUp.posY - nextPowerUp.lengthY/2 && posY < nextPowerUp.posY + nextPowerUp.lengthY/2) {
          nextPowerUp.type++;
          if (nextPowerUp.type > 4) {
            nextPowerUp.type = 0;
          }
          nextPowerUp.loadPowerUp();
        }
      }
    }
    else { // now these are the bombs
      // see if the defender has been hit
      if (posX >= mDefender.posX - mDefender.lengthX/2 && posX <= mDefender.posX + mDefender.lengthX/2 && posY >= mDefender.posY - mDefender.lengthY/2 && posY <= mDefender.posY + mDefender.lengthY/2) {
        Explosion newExplosion = new Explosion (posX, posY, 15);
        explosions.add(newExplosion);
        mDefender.lives--;
        if (mDefender.numGuns > 1) {
          mDefender.numGuns--;
        }
        invaderBombs.remove(this);
        if (mDefender.lives == 0) {
          mDefender.explodeDefender();
        }
      }
      else  {
        if (posY >= height) {
          invaderBombs.remove(this);
        }
      }
    }
   
   
  }
 
  
  void drawBullet () {
    if (!hit) {
      if (enemyBullet) {
        stroke(255);
        fill(125);
        rect(posX, posY, 2, 5);
      }
      else {
        stroke(255);
        fill(200);
        rect(posX, posY, 1, 5*mDefender.bulletPower);
      }
    }
  }
}
