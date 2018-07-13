class DisplayBoard{
  String toggledSquare = "";
  String moveTo = ".";
  char turn = mode.charAt(0);
  DisplayBoard(){
     toggledSquare = "";
  }
  /**Plays a move, automatic if computer's turn, on mouse interaction if human's
  *
  */
  void mouseI(){
    //What square is the mouse over
    int [] arrSquare = {round(mouseY/(height/8)), round(mouseX/(width/8))};
    
    //if first square has not been toggled, and it is the human's turn
    if(toggledSquare=="" && turn =='h'){
      //set the first square to the square the mouse pressed
      toggledSquare = convert.intoString(arrSquare);
     
    }
    //on second toggle (or computer turn)
    else{
     //First move assess legal moves before moves, after that it will be after 
     if(moveCount == 0){
      chessboard.assessLegalMoves();
     }
      chessboard.updateLegalMoves();
      //end square set to current mouse square
        moveTo = convert.intoString(arrSquare);
        //if computer's turn
        if(turn == 'c'){
          //Generate brain based on current position
           Brain brain = new Brain(chessboard.copyBoard());
           //think (2) plies down 
           //(For all of my moves, how could my opponent respond and what would the position look like after that)
           brain.plies(2);
           //Out of all of the possibilities, assuming my opponent tries to do the same, which would leave me with the best position?
           Brain mm = brain.minimax();
           //Set move to this awesome move I just thought of
           toggledSquare = mm.board.playMove.move.substring(0, 2);
           moveTo = mm.board.playMove.move.substring(2, 4);
           //Print evaluation
           println(mm.eval);
          //If I am playing against a measly human, it is the human's turn now
           if(mode.equals("hc")){
              turn = 'h';
            }
        }
        //Otherwise, if it is the human's turn, the future human overlord can play now
        else if(mode.equals("hc")){
          turn = 'c';
        }
        //You can't move to the square you are currently on
      if(!toggledSquare.equals(moveTo)){
        //Set move
      String moveText = toggledSquare+moveTo;   
      //print move
      println(moveText);
      
     
      //Construct move based on string, this real move will be played on main board.
      chessboard.playMove = new Move(moveText, chessboard, true);
     //Make the move
      chessboard.brd = chessboard.playMove.makeMove();  
      //increment move count
      moveCount++;
      //determine possible legal moves
      chessboard.assessLegalMoves();
      //Print how the game has ended, if it has
      println(chessboard.gameEnd()+", "+(moveCount));
     
      }
      //reset start and end square
      toggledSquare = "";
      moveTo = ".";
    }
  }
  /**Displays board and pieces
  *
  */
  void show (){
    //Chess piece to print
    String symbol = " ";
    //iterate through board
    for(int i = 0; i<chessboard.brd.length; i++){
      for(int j = 0; j<chessboard.brd[i].length; j++){
        //Set every other square to be light colored
        if((i+j)%2==0){
          fill(205, 171, 110);
        }
        //and every other square to be dark colored
        else{
          fill(151, 101, 58);
        }
        //display squares
        rect(j*(width/8), i*(height/8), width/8, height/8);    
        
        //if the iterated square is piece
        if(chessboard.brd[i][j]!=' '){
          //if black piece, color black
          if(Character.isLowerCase(chessboard.brd[i][j])){
            fill(0);
          }
          //if white piece, color white
          else{
          fill(255);
          }
          //sets symbol variable to piece type
        switch(Character.toLowerCase(chessboard.brd[i][j])){
          case 'r':
           symbol = "L";
          break;          
          case 'n':
          symbol = "K";
          break;
          case 'b':
          symbol = "J";
          break;
          case 'q':
          symbol = "M";
          break;         
          case 'k':
          symbol = "N";
          break;
          case 'p':
          symbol = "I";
          break;
        }
        //prints symbol to the board
        textSize(80);
        text(symbol, j*(width/8)+width/14, i*(height/8)+height/18);               
        }
        /**WILL BE REMOVED IN FINAL RELEASE, PRINTS HOW CONTROLLED EACH SQUARE IS**/
        textSize(12);
        fill(255, 255, 255);
         text(chessboard.controlledSquares[i][j], j*(width/8)+width/14+15, i*(height/8)+height/18-15);
      }
    }
  }
}
