class Brain {
  PVector[] moves = {new PVector(0, -1), new PVector(0, 1), new PVector(-1, 0), new PVector(1, 0)};  //up, down, left, right
  boolean autoRestart = true;
  int gen = 1;
  int maxScore = 0;
  int maxBT = 0;
  int biggestTile = 0;
  int biggestTileS = 0;
  
  ArrayList<Tile> tiles;
  ArrayList<PVector> emptyPositions;
  
  Brain() {
    p = new Player();
    emptyPositions = new ArrayList<PVector>(p.emptyPositions);
    pickMove();
  }
  
  void info() {
    text("GEN: " + gen, 1050, 350);
    text("Max score: " + maxScore + " --- " + maxBT, 1050, 400);
    text("Biggest tile: " + biggestTile + " --- " + biggestTileS, 1050, 450);
  }
  
  void update() {
    emptyPositions = new ArrayList<PVector>(p.emptyPositions);
    if(p.dead && autoRestart) {
      restart();
    }
    //p.moveDirection = moves[floor(random(4))];
    p.moveDirection = moves[pickMove()];
    p.update();
    pickMove();
  }
  
  void restart() {
    int score = p.score();
    if(score > maxScore) {
      maxScore = score;
      maxBT = p.topTile();
    }
    if(p.topTile() > biggestTile) {
      biggestTile = p.topTile();
      biggestTileS = score();
    }
    p = new Player();
    gen++;
    pickMove();
    //score = 0;
    //update();
  }
  
  
  
  
  
  
  // Predicts possible scores for each move and picks the best one
  int pickMove() {
    int bestMove = floor(random(4));
    int score = 0;
    for(int j = 0; j < 4; j++) { //move each direction    
      tiles = new ArrayList<Tile>(p.tiles);
      
      int pScore = predictScore(j);
      
      if(pScore > score) {
        score = pScore;
        bestMove = j;
      } else if(pScore == score) {
        if(random(1) > 0.5)
          bestMove = j;
      }
      println("move[" + j + "]: " + pScore);
    }
    
    println("Best: " + bestMove);
    println("up, down, left, right");
    return bestMove;
  }
  
  
  
  
  
  
  
  int predictScore(int move) {
    int score = 0;
    PVector moveDirection = moves[move];
    //emptyPositions = new ArrayList<PVector>(p.emptyPositions);
    //setEmptyPositions();
    ArrayList<PVector> sortingOrder = new ArrayList<PVector>(p.sortingOrder());
    ArrayList<PVector> oldEmptyPositions = new ArrayList<PVector>(emptyPositions);
    
    for(int j = 0; j < sortingOrder.size(); j++) {
      for(int i = 0; i < tiles.size(); i++) { //to do order them in direction of movement
        if(tiles.get(i).position.x == sortingOrder.get(j).x && tiles.get(i).position.y == sortingOrder.get(j).y) {
          PVector moveTo = new PVector(tiles.get(i).position.x + moveDirection.x, tiles.get(i).position.y + moveDirection.y);
          int valueOfMoveTo = getValue(floor(moveTo.x), floor(moveTo.y));
          while(valueOfMoveTo == 0) {
            tiles.get(i).position = new PVector(moveTo.x, moveTo.y);
            tiles.get(i).moveTo(moveTo);
            moveTo = new PVector(tiles.get(i).position.x + moveDirection.x, tiles.get(i).position.y + moveDirection.y);
            valueOfMoveTo = getValue(floor(moveTo.x), floor(moveTo.y));
          }
          if(valueOfMoveTo == tiles.get(i).value) {
            //merge tiles
            getTile(floor(moveTo.x), floor(moveTo.y)).value *= 2;
            tiles.remove(i);
          }
        }
      }
    }
    score = score();
    setEmptyPositions();
    if(emptyPositions.isEmpty()) {
      score = -1;
    } else if(!emptyPositions.equals(oldEmptyPositions)) {
      addNewTile();
      score += 5000;
    }

    return score;
  }
  
  void setEmptyPositions() {
    emptyPositions.clear();
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < 4; j++) {
        if(getValue(i, j) == 0) {
          emptyPositions.add(new PVector(i, j));
        }
      }
    }
  }
  
  void addNewTile() {
    PVector temp = emptyPositions.remove(floor(random(emptyPositions.size())));
    tiles.add(new Tile(floor(temp.x), floor(temp.y)));
  }
  
  int getValue(int x, int y) {
    if(x > 3 || x < 0 || y > 3 || y < 0) {
      return -1;
    }
    for(int i = 0; i < tiles.size(); i++) {
      if(tiles.get(i).position.x == x && tiles.get(i).position.y == y) {
        return tiles.get(i).value;
      }
    }
    return 0; //means its free
  }
  
  Tile getTile(int x, int y) {
    for(int i = 0; i < tiles.size(); i++) {
      if(tiles.get(i).position.x == x && tiles.get(i).position.y == y) {
        return tiles.get(i);
      }
    }
    return null;
  }
  
  int score() {
    int score = 0;
    for(int i = 0; i < tiles.size(); i++) {
      score += pow(tiles.get(i).value, 2);
    }
    return score;
  }
}
