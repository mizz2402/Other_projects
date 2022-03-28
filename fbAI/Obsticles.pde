class Obsticles {
  ArrayList<Pipe> pipes = new ArrayList<Pipe>();
  int pipeHeight = 400;
  int pipeWidth = 50;
  int pipeGap = 150;
  int spawnRate = 70;
  int frameCounter = spawnRate;
  
  Obsticles() {
    spawnPipes();
  }
  
  void reset() {
    pipes = new ArrayList<Pipe>();
    frameCounter = 0;
  }
  
  //------------------------------------------------------------------------
  void update() {
    if(frameCounter == 0) {
      //if(!bird.dead) spawnPipes();
      if(!population.allBirdsDead())
        spawnPipes();
      frameCounter = spawnRate;
    }
    frameCounter--;
    show();
  }
  
  //------------------------------------------------------------------------
  void show() {
    for(int i = 0 + population.bestScore(); i < pipes.size(); i++) {
    //for(int i = 0; i < pipes.size(); i++) {
      pipes.get(i).update();
    }
  }
  
  //------------------------------------------------------------------------
  void spawnPipes() {
    // 0 - -250
    int y = floor(random(250) * -1);
    pipes.add(new Pipe(width, y));
    y += pipeHeight + pipeGap;
    pipes.add(new Pipe(width, y));
  }
  
  //------------------------------------------------------------------------
  boolean Collision(int pipeId, PVector bird) {
    //bird size: 26x20
    int xFix = 13;  // 26/2
    int yFix = 10;  // 20/2
    if(bird.x + xFix > pipes.get(pipeId).pos.x && bird.x - xFix < pipes.get(pipeId).pos.x + pipeWidth) {
      if(bird.y - yFix < pipes.get(pipeId).pos.y + pipeHeight)
        return true;
      else if(bird.y + yFix > pipes.get(pipeId + 1).pos.y)
        return true;
    }
    return false;
  }
}
