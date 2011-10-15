int selectedOption = 0;
int lastMenuItemTime = 0;

/*0 = New Game
  1 = Options
  2 = High scores */

  

void displayMenu () {
  background(0);
  drawBackground();
  
  imageMode(CENTER);
  image(moovaders, width/2, height/2-100, 511, 237);
  
  fill(125, 194, 209);
  textAlign(CENTER);
  
  if (selectedOption == 0) {
    textFont (font40, 40);
  }
  else {
    textFont (font30, 30);
  }
  text("New Game", width/2, height/2+100);
  
  if (selectedOption == 1) {
    textFont (font40, 40);
  }
  else {
    textFont (font30, 30);
  }
  text("Options", width/2, height/2+140);
  
  if (selectedOption == 2) {
    textFont (font40, 40);
  }
  else {
    textFont (font30, 30);
  }
  text("High Scores", width/2, height/2+180);
  
  if (keyPressed && key == CODED && (millis() - lastMenuItemTime > 100)) {
    lastMenuItemTime = millis();
    if (keyCode == UP) {
      selectedOption--;
      if (selectedOption == -1) selectedOption = 2;
    }
    else if (keyCode == DOWN) {
      selectedOption = (selectedOption +1) % 3;
    }
  }
  
  int textWid = 100;
  if (mouseX >= (width/2) - textWid && mouseX <= (width/2) + textWid && mouseY >= (height/2) + 60 && mouseY <= (height/2) + 180) {
    if (mouseY >= (height/2) + 60 && mouseY < (height/2 + 100)) {
      selectedOption = 0;
    }
    if (mouseY >= (height/2) + 100 && mouseY < (height/2 + 140)) {
      selectedOption = 1;
    }
    if (mouseY >= (height/2) + 140 && mouseY <= (height/2 + 180)) {
      selectedOption = 2;
    }
  }
  
  if (mousePressed || (keyPressed && (key == 32 || key == 10 || key == 13))) {
    switch (selectedOption) {
      case 0: 
        startLevel1Trans();
        gameState = 1;
        break;
      case 1:
        gameState = 5;
        break;
      case 2:
        // display high scores
        break;
    } 
  }
}


int selectedKeyOption = 0;
boolean useMouse = true;

void displayOptions () {
  background(0);
  drawBackground();
  imageMode(CENTER);
  image(moovaders, width/2, height/2-100, 511, 237);
  
  fill(125, 194, 209);
  textAlign(CENTER);
  
  if (useMouse) {
    textFont (font40, 40);
  }
  else {
    textFont (font30, 30);
  }
  text ("Mouse", width/2 + 100, height/2+100);
  
  if (!useMouse) {
    textFont (font40, 40);
  }
  else {
    textFont (font30, 30);
  }
  text("Keys", width/2 -100, height/2+100);
  
  if (mousePressed && mouseX >= (width/2) + 100 - 50 && mouseX <= (width/2) + 100 + 50 && mouseY >= (height/2+100) - 20 && mouseY <= (height/2)+100 + 20) {
    useMouse = true;
  }
  else if 
    (mousePressed && mouseX >= (width/2) - 100 - 50 && mouseX <= (width/2) - 100 + 50 && mouseY >= (height/2+100) - 20 && mouseY <= (height/2)+100 + 20) {
    useMouse = false;
  }
  textFont (font30, 30);
  text ("Back", width/2, height/2+180);
  
  if (mousePressed && mouseX >= (width/2) - 50 && mouseX <= (width/2)  + 50 && mouseY >= (height/2+180) - 20 && mouseY <= (height/2)+180 + 20) {
    gameState = 0;
  }
}
  

void displayGameOver () {
   background(50,0,50);
  drawBackground();
  imageMode(CENTER);
  
  image(gameOver, width/2, height/2, 400, 50);
   textFont (font30, 30);
   fill(255,255,40);
   textAlign(LEFT);
   text("Score: " + mDefender.score, 20, 40); 
   text("Lives: " + mDefender.lives, 20, 80); 
  
  /*
  fill(255,255,40);
  textAlign(CENTER);
  String newGame = "New Game";
  text(newGame, width/2 - 50, height/2 - 25, 100, 50); 
  */
  if (mousePressed) {
    int textWid = 400;
    if (mouseX >= (width/2) - textWid && mouseX <= (width/2) + textWid && mouseY >= (height/2) - 25 && mouseY <= (height/2) + 25) {
      gameState = 0;
      mDefender.lives = 5;
    }
  }
}
