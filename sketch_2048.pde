import java.util.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

int cols, rows, score, spc;
int[][] board, prevBoard;
ArrayList<Tile> tiles;
boolean clicked = false;
Tile t;

boolean gameOver;

void setup() {
  size(800, 850);
  background(187, 173, 160);

  rows = 4;
  cols = 4;
  spc = 160;
  score = 0;

  tiles = new ArrayList<>();

  drawBoard();

  spawnNewTile(2);
}

void drawBoard() {
  noStroke();
  fill(205, 193, 180);

  board = new int[rows][cols];
  prevBoard = new int[rows][cols];

  for (int i=0; i<cols; i++) {
    float startX = width/25 + i * (spc + width/25);
    for (int j=0; j<rows; j++) {
      float startY = height/25 + j * (spc + height/25) + 50;
      rect(startX, startY, spc, spc, 10);

      if (tiles.size() > 0) {
        Tile tile = getTileFromPos(j, i);
        if (tile != null) {
          board[j][i] = tile.value;

          pushStyle();
          tile.show();
          popStyle();
        }
      } else {
        board[j][i] = 0;
      }
    }
  }


  rect(3*width/25 + 2 * spc, height/25 - 20, 2.2*spc, 50, 10);
  textSize(40);
  fill(255);
  text("BEST: " + str(score), 3*width/25 + 2 * spc + 10, height/25 + 18);

  fill(128, 128, 128);
  rect(width/25, height/25 - 20, 2.2*spc, 50, 10);
  textSize(40);
  fill(255);
  text("New Game", width/25 + 80, height/25 + 18);
}

void newGame(){
  for(int i=0; i<cols; i++){
    for(int j=0; j<rows; j++){
      board[i][j] = 0;
      prevBoard[i][j] = 0;
    }
  }
  
  tiles.clear();
  score = 0;
  
  drawBoard();
  spawnNewTile(2);
}

void draw() {
  if (tiles.size() == 16) {
    if (!checkForMoves()) {
      gameOver();
    }
  }

  if (mousePressed) {
    if (mouseX > width/25 && mouseX < width/25 + 2.2*spc && mouseY > height/25 - 20 && mouseY < height/25 + 30) {
      newGame();
    }
  }
}

boolean checkForMoves() {
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      if (i<3) {
        if (board[i+1][j] == board[i][j]) {
          return true;
        }
      }
      if (j<3) {
        if (board[i][j+1] == board[i][j]) {
          return true;
        }
      }
    }
  }

  return false;
}

void gameOver() {
  gameOver = true;

  textSize(100);
  fill(0);
  text("Game Over ", width/2 - 230, height/2);
  text("Final Score: " + str(score), width/2 - 270, height/2 + 100);
}

void spawnNewTile(int numOfTiles) {
  for(int i=0; i<numOfTiles; i++){
  //Choose random position on board
  int randomRow = int(random(rows));
  int randomCol = int(random(cols));

  while (board[randomRow][randomCol] != 0) {
    randomRow = int(random(rows));
    randomCol = int(random(cols));
  }

  int randomValue = (random(1) <= 0.9) ? 2 : 4;

  Tile newTile = new Tile(randomRow, randomCol, randomValue);
  }
}

ArrayList<Tile> getAllTilesOnRow(int row) {
  ArrayList<Tile> rowTiles = new ArrayList<>();

  for (int i=0; i<cols; i++) {
    if (board[row][i] != 0) {
      Tile rowTile = getTileFromPos(row, i);
      if (rowTile != null) {
        rowTiles.add(rowTile);
      }
    }
  }

  return rowTiles;
}

ArrayList<Tile> getAllTilesOnCol(int col) {
  ArrayList<Tile> colTiles = new ArrayList<>();

  for (int i=0; i<rows; i++) {
    if (board[i][col] != 0) {
      Tile colTile = getTileFromPos(i, col);
      if (colTile != null) {
        colTiles.add(colTile);
      }
    }
  }

  return colTiles;
}

Tile getTileFromPos(int row, int col) {
  for (Tile t : tiles) {
    if (t.row == row && t.col == col) {
      return t;
    }
  }

  return null;
}

void moveTilesRight() {

  if (!gameOver) {
    // Save the current board state before moving
    saveBoardState();

    for (int i = 0; i < rows; i++) {
      ArrayList<Tile> rowTiles = getAllTilesOnRow(i);
      Collections.reverse(rowTiles);

      for (Tile tile : rowTiles) {
        while (tile.col != cols - 1) {
          boolean freeSpace = board[i][tile.col + 1] == 0;

          if (freeSpace) {
            tile.moveRight();
          } else if (board[i][tile.col + 1] == tile.value) {
            tile.merge(getTileFromPos(i, tile.col+1));
            break;
          } else {
            break;
          }
        }
      }
    }

    // After moving, check if the board has changed
    if (boardChanged()) {
      spawnNewTile(1);
    }

    drawBoard();
  }
}

void moveTilesLeft() {

  if (!gameOver) {
    // Save the current board state before moving
    saveBoardState();

    for (int i = 0; i < rows; i++) {
      ArrayList<Tile> rowTiles = getAllTilesOnRow(i);

      for (Tile tile : rowTiles) {
        while (tile.col != 0) {
          boolean freeSpace = board[i][tile.col - 1] == 0;

          if (freeSpace) {
            tile.moveLeft();
          } else if (board[i][tile.col - 1] == tile.value) {
            tile.merge(getTileFromPos(i, tile.col -1));
            break;
          } else {
            break;
          }
        }
      }
    }

    // After moving, check if the board has changed
    if (boardChanged()) {
      spawnNewTile(1);
    }

    drawBoard();
  }
}

void moveTilesUp() {

  if (!gameOver) {
    // Save the current board state before moving
    saveBoardState();

    for (int i = 0; i < cols; i++) {
      ArrayList<Tile> colTiles = getAllTilesOnCol(i);

      for (Tile tile : colTiles) {
        while (tile.row != 0) {
          boolean freeSpace = board[tile.row - 1][i] == 0;

          if (freeSpace) {
            tile.moveUp();
          } else if (board[tile.row - 1][i] == tile.value) {
            tile.merge(getTileFromPos(tile.row-1, i));
            break;
          } else {
            break;
          }
        }
      }
    }

    // After moving, check if the board has changed
    if (boardChanged()) {
      spawnNewTile(1);
    }

    drawBoard();
  }
}

void moveTilesDown() {

  if (!gameOver) {
    // Save the current board state before moving
    saveBoardState();

    for (int i = 0; i < cols; i++) {
      ArrayList<Tile> colTiles = getAllTilesOnCol(i);
      Collections.reverse(colTiles);

      for (Tile tile : colTiles) {
        while (tile.row != rows - 1) {
          boolean freeSpace = board[tile.row + 1][i] == 0;
          if (freeSpace) {
            tile.moveDown();
          } else if (board[tile.row + 1][i] == tile.value) {
            tile.merge(getTileFromPos(tile.row+1, i));
            break;
          } else {
            break;
          }
        }
      }
    }

    if (boardChanged()) {
      spawnNewTile(1);
    }

    drawBoard();
  }
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case RIGHT:
      moveTilesRight();
      break;

    case LEFT:
      moveTilesLeft();
      break;

    case UP:
      moveTilesUp();
      break;

    case DOWN:
      moveTilesDown();
      break;
    }
  }
}


void saveBoardState() {
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      prevBoard[i][j] = board[i][j];
    }
  }
}

boolean boardChanged() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (prevBoard[i][j] != board[i][j]) {
        gameOver = false;
        return true;
      }
    }
  }
  return false;
}
