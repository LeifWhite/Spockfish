/**
TODO:
1. Fix moving into check
2. Make more efficient
3. Draw by repetition fix
4. Draw by insufficient material add
*/

//Used for purposes of checking equality in arrays without iteration
import java.util.Arrays;
//Initial chess starting position, lowercase letters are black, capital letters are white
char [][] startingBoard ={
{'r','n','b','q','k','b','n','r'},
{'p','p','p','p','p','p','p','p'},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{'P','P','P','P','P','P','P','P'},
{'R','N','B','Q','K','B','N','R'}};
/*char [][] startingBoard ={
{' ',' ',' ',' ','k',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ','r',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ',' ',' ',' ',' '},
{' ',' ',' ',' ','K',' ',' ',' '}};*/

//Keeps record of moves
ArrayList <String[]> log = new ArrayList();
//Keeps record of boards
ArrayList <Board[]> b_log = new ArrayList();
//Convert move text to arrays and vice versa
Convert convert; 
//User interface
DisplayBoard displayBoard;
//Starting board
Board chessboard; 
//Mode: cc = Computer vs Computer, hc = Human vs Computer, hh = Human vs Human
String mode = "cc";
//How many half-moves have been completed 
int moveCount = 0;

void setup() {
  //Sets high framerate
    frameRate(31000);
    //Canvas size
    size(600, 600);
    //Visual Preference
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(50);
    textFont(createFont("Chess Alpha 2", 80));
    //Initialize variables
    convert  = new Convert();
   
    displayBoard  = new DisplayBoard();
    chessboard = new Board(startingBoard);
}
void mouseReleased(){
  //If human's turn, detect mouse interaction
  if(displayBoard.turn == 'h'){
    displayBoard.mouseI();
  }
  
}

void draw() {
   //displays board
    displayBoard.show();
    //if computer's turn, automatic movement
   if(displayBoard.turn == 'c'){
     displayBoard.mouseI();
   }


}
