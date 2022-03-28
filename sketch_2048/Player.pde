class Player {
  boolean dead = false;
  boolean won = false;
  ArrayList<Tile> tiles = new ArrayList<Tile>();
  ArrayList<PVector> emptyPositions = new ArrayList<PVector>();
  PVector moveDirection = new PVector();
  
  Player() {
    fillEmptyPositions();
    
    //add 2 tiles
    addNewTile();
    addNewTile();
  }
  
//------------------------------------------------------------------------------------------------------------
  void fillEmptyPositions() {
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < 4; j++) {
        emptyPositions.add(new PVector(i, j));
      }
    }
  }
  
//------------------------------------------------------------------------------------------------------------
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
  
//------------------------------------------------------------------------------------------------------------
  void show() {
    for(int i = 0; i < tiles.size(); i++) {
        tiles.get(i).show();
    }
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(30);
    if(dead) {
      text("STATUS: DEAD", 1050, 100);
    } else if(won) {
      text("STATUS: WON", 1050, 100);
    } else {
      text("STATUS: ALIVE", 1050, 100);
    }
    text("Score: " + score(), 1050, 200);
    text("Top Tile: " + topTile(), 1050, 250);
  }

//------------------------------------------------------------------------------------------------------------
  void update() {
    if(topTile() == 2048) {
      won = true;
    }
    if(!dead && !won) {
      move();
    }
    show();
  }
  
//------------------------------------------------------------------------------------------------------------
  int score() {
    int score = 0;
    for(int i = 0; i < tiles.size(); i++) {
      score += pow(tiles.get(i).value, 2);
    }
    return score;
  }
  
//------------------------------------------------------------------------------------------------------------
  int topTile() {
    int max = 0;
    for(int i = 0; i < tiles.size(); i++) {
      if(max < tiles.get(i).value) {
        max = tiles.get(i).value;
      }
    }
    return max;
  }
  
//------------------------------------------------------------------------------------------------------------
  void move() {
    ArrayList<PVector> sortingOrder = new ArrayList<PVector>(sortingOrder());
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
    
    setEmptyPositions();
    if(emptyPositions.isEmpty()) {
      dead = true;
    } else if(!emptyPositions.equals(oldEmptyPositions)) {
      addNewTile();
    }
  }
  
//------------------------------------------------------------------------------------------------------------
  ArrayList<PVector> sortingOrder() {
    ArrayList<PVector> sortingOrder = new ArrayList<PVector>();
    PVector sortingVec = new PVector();
    boolean vert = false; //is up or down
    if(moveDirection.x == 1) { //right
      sortingVec = new PVector(3, 0);
      vert = false;
    } else if(moveDirection.x == -1) { //left
      sortingVec = new PVector(0, 0);
      vert = false;
    } else if(moveDirection.y == 1) { //up
      sortingVec = new PVector(0, 3);
      vert = true;
    } else if(moveDirection.y == -1) { //down
      sortingVec = new PVector(0, 0);
      vert = true;
    }
    
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < 4; j ++) {
        PVector temp = new PVector(sortingVec.x, sortingVec.y);
        if(vert) {
          temp.x += j;
        } else {
          temp.y += j;
        }
        sortingOrder.add(temp);
      }
      sortingVec.sub(moveDirection);
    }
    
    return sortingOrder;
  }
  
//------------------------------------------------------------------------------------------------------------
  void addNewTile() {
    PVector temp = emptyPositions.remove(floor(random(emptyPositions.size())));
    tiles.add(new Tile(floor(temp.x), floor(temp.y)));
  }
  
//------------------------------------------------------------------------------------------------------------
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
  
//------------------------------------------------------------------------------------------------------------
  Tile getTile(int x, int y) {
    for(int i = 0; i < tiles.size(); i++) {
      if(tiles.get(i).position.x == x && tiles.get(i).position.y == y) {
        return tiles.get(i);
      }
    }
    return null;
  }
}
