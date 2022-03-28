class Brain {
  Bird bird;
  PVector birdPos;
  PVector bottomPipePos;
  
  //vision
  double distanceToTopPipe;
  double distanceToBottomPipe;
  double distanceToGround;
  
  float[] weights = new float[3];
  int lifeTime = 0;
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Brain() {
    bird = new Bird();
    
    weights[0] = random(2) - 1;
    weights[1] = random(2) - 1;
    weights[2] = random(2) - 1;
  }
  
  /*
  void update() {
    //PVector pipe = o.pipes.get(bird.score+1).pos;
    float pipeY = o.pipes.get(bird.score + 1).pos.y;
    float birdY = bird.pos.y + 20;
    //fill(255, 0, 0);
    //rect(pipe.x, pipe.y, 50, 400);
    
    if(birdY >= pipeY)
      bird.isJumping = true;
  }
  */
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
    if(!bird.dead) {
      lifeTime++;
      bird.update();
      birdPos = bird.pos;
      bottomPipePos = o.pipes.get(bird.score+1).pos;
      vision();  //calculate needed distances
      //show();  //draw 'vision' vectors
      if(think())
        bird.isJumping = true;
    } else
      population.alive--;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
    stroke(255, 0, 0);
    strokeWeight(3);
    line(birdPos.x, birdPos.y, bottomPipePos.x + 25, bottomPipePos.y - 150);  //top pipe
    line(birdPos.x, birdPos.y, bottomPipePos.x + 25, bottomPipePos.y);  //bottom pipe
    line(birdPos.x, birdPos.y, birdPos.x, height);                      //ground
    strokeWeight(1);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void drawNeuralNetwork() {
    textAlign(CENTER, CENTER);
    textSize(10);
    
    
    for(int i = 0; i < weights.length; i++) {
      if(weights[i] < 0)
        stroke(0, 0, 255);
      else
        stroke(255, 0, 0);
        
      strokeWeight(1 + abs(weights[i] * 3));
      line(250, 400 + (50 * i), 350, 450);
      
      strokeWeight(2);
      stroke(0);
      fill(255);
      ellipse(250, 400 + (50 * i), 30, 30);
      fill(0);
      text(i + 1, 250, 400 + (50 * i));
    }
    
    fill(255);
    ellipse(350, 450, 30, 30);  //output
    fill(0);
    text("O", 350, 450);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void vision() {
    //distanceToTopPipe = Math.hypot(birdPos.x - bottomPipePos.x, birdPos.y - (bottomPipePos.y - 150));
    //distanceToBottomPipe = Math.hypot(birdPos.x - bottomPipePos.x, birdPos.y - bottomPipePos.y);
    distanceToTopPipe = birdPos.y - (bottomPipePos.y - 150);
    distanceToBottomPipe = birdPos.y - bottomPipePos.y;
    distanceToGround = height - birdPos.y;
    //println("Dist to top pipe: " + distanceToTopPipe);
    //println("Dist to bottom pipe: " + distanceToBottomPipe);
    //println("Dist to ground: " + distanceToGround);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  boolean think() {
    double output = output();
    //println(output);
    if(output > 0.5)
      return true;
    else
      return false;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  double output() {
    return Math.tanh(weightedSum());
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  double weightedSum() {
    return (distanceToTopPipe * weights[0]) + (distanceToBottomPipe * weights[1]) + (distanceToGround * weights[2]);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  int fitness() {
    int f = 0;
    
     f = lifeTime;// + (bird.score * 20);
    
    return f;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void mutate() {
    float mutationRate = 0.05;
    for(int i = 0; i < weights.length; i++) {
      float rand = random(1);
      if(rand < mutationRate) {
        weights[i] = random(2) - 1;
        //println("mutated");
      }
    }
  }
}
