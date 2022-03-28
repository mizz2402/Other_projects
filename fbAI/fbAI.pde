Obsticles o;
//Bird bird;
Population population;
//Brain brain;

boolean released = true;

void setup() {
  size(400, 700);
  //bird = new Bird();
  //brain = new Brain();
  population = new Population(100);
  o = new Obsticles();
}

void draw() {
  frameRate(180);  //use 60 fps for normal speed
  noStroke();
  background(66, 135, 245);
  //fucking sun?
  fill(255, 232, 25);
  ellipse(width - 20, 20, 70, 70);
  
  //clouds
  fill(255);
  ellipse(90, 40, 130, 50);
  ellipse(250, 60, 170, 60);
  
  stroke(0);
  o.update();
  population.update();
  
  //bird.update();
  //brain.update();
  
  //draw ground
  fill(129, 245, 66);
  rect(0, height-15, width, 15);
}

/*
void keyPressed() {
  if(released && !bird.dead)
    bird.isJumping = true;
  released = false;
}

void keyReleased() {
  released = true;
}
*/
