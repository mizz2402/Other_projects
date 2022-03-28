class Population {
  Brain[] brains;
  int gen = 1;
  int maxScore = 5 * 2;
  float fitnessSum;
  float avgFitness;
  int bestBrain = 0;
  int alive;
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  Population(int size) {
    brains = new Brain[size];
    for(int i = 0; i < size; i++) {
      brains[i] = new Brain();
    }
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void update() {
    alive = brains.length;
    boolean report = false;
    for(int i = 0; i < brains.length; i++) {
      fill(255, 250, 99);
      if(i == bestBrain) fill(0, 255, 0);  //color best bird
      brains[i].update();
      if(brains[i].bird.score == maxScore) {
        brains[i].bird.dead = true;
        report = true;
      }
      //brains[i].update();
    }
    
    if(report) {
      println("Generation " + gen + " reached goal - " + (maxScore/2));
      println(alive + "% of birds survived!");
    }
    
    if(allBirdsDead()) {
      naturalSelection();
      if(gen < 11)  // stop mutation after 10 generations and removes score limit
        mutateBrains();
      else
        maxScore = -1;
    }
    
    show();
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void show() {
    fill(252, 186, 3);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("Score: " + bestScore()/2, 100, 100);
    text("Gen: " + gen, 250, 100);
    text("Max score: " + maxScore/2, 110, 20);
    text("Alive: " + alive, 310, 20);
    brains[bestBrain].drawNeuralNetwork();
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  int bestScore() {
    int score = brains[0].bird.score;
    
    for(int i = 1; i < brains.length; i++) {
      if(brains[i].bird.score > score) {
        score = brains[i].bird.score;
        bestBrain = i;
      }
    }
    
    return score;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  boolean allBirdsDead() {
    for(int i = 0; i < brains.length; i++)
      if(!brains[i].bird.dead)
        return false;
    return true;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void naturalSelection() {
    Brain[] newBrains = new Brain[brains.length];
    calculateFitnessSum();
    
    //clone the best one
    newBrains[0] = new Brain();
    newBrains[0].weights = brains[bestBrain].weights.clone();
    
    for(int i = 1; i < newBrains.length; i++) {
      Brain[] parents = {selectParent(), selectParent()};  //select 2 parents
      
      newBrains[i] = getBaby(parents);  //make a baby!
      //newBrains[i].bird.score = 0;
    }
    o.reset();
    brains = newBrains.clone();
    maxScore += 10;
    gen++;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void calculateFitnessSum() {
    fitnessSum = 0;
    for(int i = 0; i < brains.length; i++)
      fitnessSum += brains[i].fitness();
    avgFitness = fitnessSum / brains.length;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  Brain selectParent() {
    float rand = random(fitnessSum);
    float runningSum = 0;
    
    for(int i = 0; i < brains.length; i++) {
      runningSum += brains[i].fitness();
      if(runningSum > rand)
        if(brains[i].fitness() < avgFitness)
          return selectParent();
        else
          return brains[i];
    }
    
    println("fuck: null parent");
    //should never get to this point
    return null;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  Brain getBaby(Brain[] parents) {
    Brain baby = new Brain();
    float babyWeight = 0;
    for(int i = 0; i < baby.weights.length; i++) {
      babyWeight = (parents[0].weights[i] + parents[1].weights[i]) / 2;
      baby.weights[i] = babyWeight;
    }
    
    return baby;
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void mutateBrains() {
    for(int i = 1; i < brains.length; i++)
      brains[i].mutate();
  }
}
