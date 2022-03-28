class Pipe {
  int pipeWidth = 50;
  int pipeHeight = 400;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(-1, 0);
  PVector pos = new PVector();
  
  Pipe(int x, int y) {
    pos = new PVector(x, y);
  }
  
  //------------------------------------------------------------------------
  void update() {
    //pos.x -= 3;
    //if(!bird.dead) move();
    if(!population.allBirdsDead())
      move();
    show();
  }
  
  //------------------------------------------------------------------------
  void show() {
    fill(52, 168, 50);
    rect(pos.x, pos.y, pipeWidth, pipeHeight);
  }
  
  //------------------------------------------------------------------------
  void move() {
    //acc = new PVector(-1, 0);
    vel.add(acc);
    vel.limit(3);
    pos.add(vel);
  }
}
