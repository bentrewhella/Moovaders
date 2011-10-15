import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import processing.opengl.*; 

// audio
Minim minim;
AudioSample shootSample;
AudioPlayer music;


Defender mDefender;
InvaderWave invaderWave;
ArrayList invaderBombs;
ArrayList explosions;
ArrayList powerUps;
Saucer saucer;
int gameState;
int lastFrameTime;
int frameTime;
float backgroundRotation;
/*0 = main menu
  1 = level interlude
  2 = game play
  3 = dying
  4 = game over
  5 = Options
  6 = high scores */
  
int level;
PFont font120;
PFont font40;
PFont font30;

boolean leftPressed;
boolean rightPressed;
boolean firePressed;

PImage gameOver;
PImage moovaders;

void setup () {
  size (640, 480, OPENGL);
  minim = new Minim(this);
  music = minim.loadFile("Space Invaders - Full Track.mp3");
  music.loop();
  frameRate(60);
  gameState = 0;
  font120 = loadFont("VTCBadDataTrip-120.vlw");
  font40 = loadFont("VTCBadDataTrip-40.vlw");
  font30 = loadFont("VTCBadDataTrip-30.vlw");
  
  
  gameOver = loadImage("GameOver.png");
  moovaders = loadImage("Moovaders.png");
  setUpBackground();
  
  
  leftPressed = false;
  rightPressed = false;
  firePressed = false;
  lastFrameTime = millis();
  
}

void gameLoop () {
  
  mDefender.moveDefender(height - 30);
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
  
  if (saucer != null) {
    saucer.moveSaucer();
  }
 
   
  
  pushMatrix();
  translate (0,0,-100);
  rotateX(radians(backgroundRotation));
  
  background(50,0,50);
  
  drawBackground();
  
  mDefender.drawDefender();
  
  rectMode(CENTER);
   stroke(255);
   fill(125);
   
   for (int i = 0; i < powerUps.size(); i++) {
    PowerUp nextPowerUp = (PowerUp) powerUps.get(i);
    nextPowerUp.drawPowerUp();
  } 
  
   invaderWave.drawWave();
   
   if (saucer != null) {
     saucer.drawSaucer();
   }
  
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
   /*for (int i = 0; i < mDefender.lives; i++) {
     text("i", 80+15*i, 80);
   }*/
}


void newLevel() {
  level++;
  gameState = 1;
  startNextLevelTrans();
}

void keyPressed () {
  if (key == 'a') {
    leftPressed = true;
  }
  if (key == 'd') {
    rightPressed =true;
  }
  if (key == 32) {
    firePressed = true;
  }
}

void keyReleased () {
  if (key == 'a') {
    leftPressed = false;
  }
  if (key == 'd') { // && mDefender.keyMove == 5) {
    rightPressed = false;
  }
   if (key == 32) {
    firePressed = false;
  }
}


void draw () {
  frameTime = millis() - lastFrameTime;
 
  switch (gameState) {
    case 0: {
      displayMenu();
      break;
    }
    case 1: {
      drawLevelTrans();
      break;
    }
    case 2: {
      gameLoop();
      break;
    }
    case 3: {
      // display dying
      drawGameOverTrans();
      break;
    }
    case 4: {
      displayGameOver();
      break;
    }
    case 5: {
      displayOptions();
      break;
    }
    case 6: {
      //displayHighScores ();
      break;
    }
  }
  lastFrameTime = millis();
}

void stop () {
  music.close();
  shootSample.close();
  minim.stop();
  super.stop();
}
  
