ArrayList defenderParticles;

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  color col;
  
  Particle (PVector l, color c) {
    acc = new PVector (0,0.05, 0);
    vel = new PVector (random(-1,1), random (-2, 0), 0);
    loc = l.get();
    col = c;
  }
  
  void update () {
    vel.add(acc);
    loc.add(vel);
  }
  
  void drawParticle() {
    stroke(col);
    fill(col);
    rect(loc.x, loc.y, 3, 3);
  }
}
