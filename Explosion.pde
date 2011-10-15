class Explosion {
  int posX;
  int posY;
  
  int explosionTime;
  int explosionSize;
  color explosionColor;
  
  Explosion (int tX, int tY, int tSize) {
    posX = tX;
    posY = tY;
    explosionTime = millis();
    explosionSize = tSize;
    explosionColor = color(255);
  }
  
  void moveExplosion () {
    int currentTime = millis();
    if (currentTime - explosionTime > 250) {
      explosions.remove(this);
    }
  }
  
  void drawExplosion () {
    int currentTime = millis();
    fill(explosionColor);
    stroke(explosionColor);
    ellipseMode(CENTER);
    ellipse ((float) posX, (float) posY, (float)(currentTime - explosionTime)/100 * explosionSize, (float)(currentTime - explosionTime)/100 * explosionSize);
  }
}
