Player p;
Brain b;
boolean relesed = true;

void setup() {
  size(1260, 850);
  //p = new Player();
  b = new Brain();
}

void draw() {
  drawBackground();
  p.show();
  b.info();
  //b.update();
}

void drawBackground() {
  background(#bbada0);
  noStroke();
  fill(#cbc2b3);
  for(int i = 0; i < 4; i++) {
    for(int j = 0; j < 4; j++)
      rect(i * 200 + (i + 1) * 10, j * 200 + (j + 1) * 10, 200, 200, 20);
  }
}


void keyPressed() {
  if(keyCode == RIGHT) b.update();
  if(relesed) {
    if(keyCode == ENTER) {
      b.restart();
    } else if (keyCode == UP) {
      b.update();
    }
    relesed = false;
  }
}

/*
void keyPressed() {
  if(p.dead) {
    setup();
  }
  if(relesed) {
    switch(key) {
      case CODED:
        switch(keyCode) {
          case UP:
            p.moveDirection = new PVector(0, -1);
            p.update();
            break;
          case DOWN:
            p.moveDirection = new PVector(0, 1);
            p.update();
            break;
          case LEFT:
            p.moveDirection = new PVector(-1, 0);
            p.update();
            break;
          case RIGHT:
            p.moveDirection = new PVector(1, 0);
            p.update();
            break;
        }
    }
    relesed = false;
  }
}
*/
void keyReleased() {
  relesed = true;
}
