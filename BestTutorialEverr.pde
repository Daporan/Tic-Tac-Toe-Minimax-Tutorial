int width = 480;
int height = 480;
int rectSize = width/3;

color rectColor, rectHighlight;
color xColor, oColor;

int[][] board = new int[3][3];
int player = 1;
int result = 0;
boolean drawn;
int me = 1;

void setup() {
  size(480, 480);
  rectColor = color(60);
  rectHighlight = color(120);
  xColor = color(50,50,255);
  oColor = color(255,50,50);
  ellipseMode(CORNER);
}

class AIMove{
    int score, x, y;
    public AIMove(int score, int x, int y){
      this.score = score; this.x = x; this.y = y;
    }
}

AIMove aiMove(){
  AIMove move = new AIMove(2, 0, 0);
  if (player == me)
    move.score = -2;

  if (moveCount() == 0 || gameOver() > 0){
      int res = gameOver();
      int score = -1;
      if (res == me) score = 1;
      else if (res == 0) score = 0;
      return new AIMove(score, 0, 0);
  }

  for (int i = 0; i < 3; i++){
    for (int j = 0; j < 3; j++){
      if (board[i][j] > 0) continue;
      
      board[i][j] = player;
      
      player = 3 - player;
      AIMove tmp = aiMove();
      player = 3 - player;
      
      if (player == me && tmp.score > move.score || player != me && tmp.score < move.score){
        move.score = tmp.score;
        move.x = i; 
        move.y = j;
      }
 
      board[i][j] = 0;
    }
  }
  return move;
}

void draw() {
  if (gameOver() == 0 && moveCount() > 0 && drawn && player != me){
    delay(500);
    
    AIMove move = aiMove();
    board[move.x][move.y] = player;
    player = 3 - player;
  }
  
  drawn = true;
  
  for (int i = 0; i < 3; i++){
    for (int j = 0; j < 3; j++){
      int x = i * width/3;
      int y = j * height/3;
      
      stroke(255);
      strokeWeight(3);
      if (board[i][j] == 1){
        fill(rectColor);
        rect(x, y, rectSize, rectSize);
        
        stroke(0);
        strokeWeight(22);
        line(x, y, x + rectSize, y + rectSize);
        line(x + rectSize, y, x, y + rectSize);
        
        stroke(xColor);
        strokeWeight(15);
        line(x, y, x + rectSize, y + rectSize);
        line(x + rectSize, y, x, y + rectSize);
      }
      else if (board[i][j] == 2){
        fill(rectColor);
        rect(x, y, rectSize, rectSize);
        
        stroke(0);
        strokeWeight(22);
        ellipse(x, y, rectSize, rectSize);
        
        stroke(oColor);
        strokeWeight(15);
        ellipse(x, y, rectSize, rectSize);
      }
      else{
        if (overRect(x, y, rectSize, rectSize)) {
          fill(rectHighlight);
        }
        else{
          fill(rectColor);
        }
        rect(x, y, rectSize, rectSize);
      }
    }
  }
  
  result = gameOver();
  if (result > 0){
    textSize(48);
    fill(255);
    text("Player " + (3 - player) + " won!", 10, 60);
  }
}

int gameOver(){
   //rows
   for (int i = 0; i < 3; i++){
     if (board[i][0] == board[i][1] && board[i][0] == board[i][2]){
       if (board[i][0] > 0) return board[i][0];
     }
   }
   
   //cols
   for (int i = 0; i < 3; i++){
     if (board[0][i] == board[1][i] && board[0][i] == board[2][i]){
       if (board[0][i] > 0) return board[0][i];
     }
   }
   
   //diagonal
   if (board[0][0] == board[1][1] && board[0][0] == board[2][2]){
     if (board[0][0] > 0) return board[0][0];
   }
   if (board[0][2] == board[1][1] && board[1][1] == board[2][0]){
     if (board[0][2] > 0) return board[0][2];
   }
   return 0;
}

int moveCount(){
  int count = 0;
  for (int i = 0; i < 3; i++){
    for (int j = 0; j < 3; j++){
      if (board[i][j] == 0) count++;
    }
  }
  return count;
}

void mousePressed() {
  if (result > 0 || player != me) return;
  for (int i = 0; i < 3; i++){
    for (int j = 0; j < 3; j++){
      if (board[i][j] == 0 && overRect(i * width/3, j * height/3, rectSize, rectSize)) {
        board[i][j] = player;
        player = 3 - player;
        drawn = false;
      }
    }
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
