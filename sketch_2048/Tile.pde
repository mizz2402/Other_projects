class Tile {
  int value;
  PVector position;
  PVector pixelPos; //top left
  
  Tile(int x, int y) {
    if(random(1) < 0.1) {
      value = 4;
    } else {
      value = 2;
    }
    
    position = new PVector(x, y);
    pixelPos = new PVector(x * 200 + (x +  1) * 10, y * 200 + (y + 1) * 10);
  }
  
  void show() {
    fill(bgColor());
    rect(pixelPos.x, pixelPos.y, 200, 200, 20);
    fill(textColor());
    textAlign(CENTER, CENTER);
    textSize(50);
    text(value, pixelPos.x + 100, pixelPos.y + 100);
  }
  
  void moveTo(PVector to) {
    position = new PVector(to.x, to.y);
    pixelPos = new PVector(to.x * 200 + (to.x +  1) * 10, to.y * 200 + (to.y + 1) * 10);
  }
  
  int textColor() {
    if(value > 4)
      return #ffffff;
    else
      return #736e64;
  }
  
  int bgColor() {
    switch(value) {
      case 2:
        return #eee6db;
      case 4:
        return #ece0c8;
      case 8:
        return #efb27c;
      case 16:
        return #f39768;
      case 32:
        return #f37d63;
      case 64:
        return #f46042;
      case 128:
        return #eacf76;
      case 256:
        return #edcb67;
      case 512:
        return #ecc85a;
      case 1024:
        return #e7c257;
      case 2048:
        return #e8be4e;
      default:
        return #3d3a33;
    }
  }
}
