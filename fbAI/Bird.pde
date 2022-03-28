class Bird {
  //Brain brain;
  PVector pos = new PVector(30, 250);
  //PVector pos = new PVector(width/2, height/2);
  PVector vel;
  PVector acc;
  boolean dead = false;
  boolean isJumping = false;
  int jumpLength = 10;
  int score = 0;

  
  //------------------------------------------------------------------------
  Bird() {
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  void update() {
    if(!dead) {
      if(o.Collision(score, pos))
        dead = true;
      else if (o.pipes.get(score).pos.x + o.pipeWidth + 26 < pos.x)
        score += 2;
      if(!dead && pos.y > height - 20 || pos.y < 0) {
        dead = true;
      } else if (!isJumping) {
        //vel = new PVector(0, 0);
        acc = new PVector(0, 10);
        vel.add(acc);
        vel.limit(7);
        pos.add(vel);
      } else if(isJumping) {
        jump();
      }
    } else
      kill();
    show();
  }
  
  //------------------------------------------------------------------------
  void show() {
    //fill(255, 250, 99);
    if(dead) fill(255, 0, 0);
    //textAlign(CENTER, CENTER);
    //textSize(30);
    //text("Score: " + score/2, 100, 100);
    ellipse(pos.x, pos.y, 26, 20);
  }
  
  //------------------------------------------------------------------------
  void jump() {
    acc = new PVector(0, -10);
    //vel = new PVector(0, 0);
    vel.add(acc);
    vel.limit(10);
    pos.add(vel);
    jumpLength--;
    if(jumpLength == 0) {
      isJumping = false;
      jumpLength = 10;
    }
  }
  
  //------------------------------------------------------------------------
  void kill() {
    dead = true;
    isJumping = false;
    if(pos.y < height - 20) {
      acc = new PVector(0, 10);
      vel.add(acc);
      vel.limit(10);
      pos.add(vel);
    }
  }
  
  //------------------------------------------------------------------------
}
