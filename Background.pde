float rotateDegree = 0;
ArrayList stars;

void setUpBackground () {
  stars = new ArrayList();
  for (int i = 0; i < 200; i++) {
    PVector pv = new PVector (random (-200,width+200), random (-1000,1000), random (-1000,1000));
    stars.add(pv);
  }
}

void drawBackground () {
  rotateDegree += 0.1;
  
 
  pushMatrix();
  stroke(255);
  translate (0,0,200);
  rotateX(radians(rotateDegree));
  for (int i = 0; i < stars.size(); i++) {
    PVector pv = (PVector) stars.get(i);
    point (pv.x, pv.y, pv.z);
  }
  popMatrix();
}

