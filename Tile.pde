class Tile {
  int value;
  int row, col;
  float tileWidth;
  float tileHeight;
  color tileColor;

  Tile(int row, int col, int value) {
    this.row = row;
    this.col = col;
    this.value = value;

    switch(value) {
    case 2:
      tileColor = color(238, 228, 218);
      break;

    case 4:
      tileColor = color(237, 224, 200);
      break;

    case 8:
      tileColor = color(242, 177, 121);
      break;

    case 16:
      tileColor = color(245, 149, 99);
      break;

    case 32:
      tileColor = color(246, 124, 95);
      break;

    case 64:
      tileColor = color(246, 94, 59);
      break;

    default:
      tileColor = color(237, 207, 114);
      break;
    }


    board[row][col] = value;
    tiles.add(this);
    show();
  }

  void moveLeft() {
    board[row][col] = 0;

    col--;
    board[row][col] = value;
  }

  void moveRight() {
    board[row][col] = 0;

    col++;
    board[row][col] = value;
  }

  void moveDown() {
    board[row][col] = 0;

    row++;
    board[row][col] = value;
  }

  void moveUp() {
    board[row][col] = 0;

    row--;
    board[row][col] = value;
  }

  void merge(Tile t) {
    this.delete();
    t.delete();

    Tile mergedTile = new Tile(t.row, t.col, t.value + this.value);
    score += 2*this.value;
    //println(score);
  }

  void delete() {
    board[row][col] = 0;
    tiles.remove(this);

    drawBoard();
  }

  void show() {
    noStroke();
    fill(tileColor);
    float x = width/25 + col * (spc + width/25);
    float y = height/25 + row * (spc + height/25) + 50;
    rect(x, y, spc, spc, 10);


    fill((value == 2 || value == 4) ? 0 : 255);
    textSize(100);
    text(str(value), x + spc/2 - textWidth(str(value))/2, y+spc/2 + 25);
  }
}
