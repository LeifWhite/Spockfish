class Move{
  //Declare variables
  Board board;
  String move;
  int [] ePS;
  int mover;
  boolean [] aTC;
  int[] startSquare;
  int[] endSquare;
  char startPiece;
  boolean allowEnPassant;
  boolean realBoard;
  Move(String mv, Board b, boolean rB){
    //Initialize variables (What the move is, what the board is, and are we really doing this?)
    move = mv;
 
    ePS = b.ePS.clone();
    
    mover = b.mover;
    aTC = b.aTC.clone();
    
    board = b;   
     realBoard = rB;
     startSquare = convert.intoArray(move.substring(0, 2));
     endSquare = convert.intoArray(move.substring(2, 4));
     startPiece = (board.brd[startSquare[1]][startSquare[0]]);
    allowEnPassant = b.allowEnPassant;
    
  }
   
  /**Makes a move on the board
  *
  *@return The updated board
  */
  char [][] makeMove(){
    //Creates hypothetical board
    char b [][];
    b = board.brd.clone();
    //If this is a legal move
    if(legalMove(false, true)){
     //If pawn move or capture, reset 50-move rule
      if(startPiece!='p' || b[endSquare[1]][endSquare[0]]!=' '){
        board.mSB = 0;
        if(Character.toLowerCase(b[endSquare[1]][endSquare[0]]) == 'r'){
          if(b[endSquare[1]][endSquare[0]] == 'R'){
            if(endSquare[1] == 7 && endSquare[0] == 0 && aTC[0]){
              aTC[0] = false;
            }
            else if(endSquare[1] == 7 && endSquare[0] == 7 && aTC[1]){
              aTC[1] = false;
            }
          }
          else if(b[endSquare[1]][endSquare[0]] == 'r'){
            if(endSquare[1] == 0 && endSquare[0] == 0 && aTC[2]){
              aTC[2] = false;
            }
            else if(endSquare[1] == 0 && endSquare[0] == 7 && aTC[3]){
              aTC[3] = false;
            }
          }
        }
      }
      //otherwise, increment half-moves without a pawn move or piece capture
      else{
        board.mSB++;
      }
      //Make the move on the hypothetical board
      b[endSquare[1]][endSquare[0]] = b[startSquare[1]][startSquare[0]];
      b[startSquare[1]][startSquare[0]] = ' ';
      /**REQUIRES REWORK, IF IT IS BLACK'S TURN, RESET SQUARES*/
     if(mover == -1){
      board.controlledSquareReset();
     }
     //Update board values
      board.aTC = aTC.clone();
      board.ePS = ePS.clone();
      board.allowEnPassant = allowEnPassant;    
      board.mover*=-1;
      //If real board, update log (keeps track of prior boards and moves) (BROKEN)
      if(realBoard){
      if(mover == 1){
        //If it is white's turn, add to the log the move you just made
        String [] logAdd = new String [2];
        logAdd[0] = move;
        log.add(logAdd);
        //Add to the log the board you just made
        Board [] b_logAdd = new Board[2];
        b_logAdd[0] = board.copyBoard();
        b_log.add(b_logAdd);
      }
      else{
        //If it is black's turn, update the value of the recently added log
        log.get(log.size()-1)[1] = move;
        b_log.get(b_log.size()-1)[1] = board.copyBoard();
      }
      }
    }
    else{
      //If illegal move, tell them!
      println("Bad move!");
    }
  //return created board
    return b;
    
  }
 /**Says if you are in check or not
  *
  *@return boolean value (true means in check, false means not in check)
  */
 boolean inCheck(){
   //Create a hypothetical board
   Board checkBoard = board.copyBoard();
   //Make the move on the hypothetical board
   Move testMove = new Move(move, checkBoard, false);
   testMove.legalMove(false, false);
   //Update the hypothetical board based upon the move you just made
    checkBoard.brd[endSquare[1]][endSquare[0]] = checkBoard.brd[startSquare[1]][startSquare[0]];
    checkBoard.brd[startSquare[1]][startSquare[0]] = ' ';
     checkBoard.aTC = aTC.clone();
      checkBoard.ePS = ePS.clone();
      checkBoard.allowEnPassant = allowEnPassant;
      checkBoard.mover*=-1;
      checkBoard.assessLegalMoves();
     //Iterate through the board
      for(int i = 0; i<checkBoard.brd.length; i++){
        for(int j = 0; j<checkBoard.brd.length; j++){
         
           int [] square = {i, j};
           //If the square you are on is a king of the opposite colot
            if((checkBoard.brd[i][j] == 'K' && checkBoard.mover == -1)|| (checkBoard.brd[i][j] == 'k' && checkBoard.mover == 1)){
            //iterate through legal moves
              for(int w = 0; w<checkBoard.legalMoves.length; w++){
               //If your legal move will make you end upon your opponent's king, 
              if(checkBoard.legalMoves[w].substring(2,4).equals(convert.intoString(square))){
                //You're totes ma goats in check
                return true;
              }
          }
        }
      }
    }
    //otherwise return false (not in check)
    return false;
  }
  /**Determines if a move is legal or not
  *
  *@param justChecking used to see if you are actually updating a board, or if you are just checking legality
  *@param checkForCheck used to see if you should actually check to see if the move is legal through checking rules
  *@return boolean statement regarding move's legality
  */
  boolean legalMove(boolean justChecking, boolean checkForCheck) {
   //Determines piece color
    String pieceColor;
    startPiece = (board.brd[startSquare[1]][startSquare[0]]);
    if (Character.isLowerCase(startPiece))
        pieceColor = "Black";
    else
        pieceColor = "White";
    //if piece color is not the same color as the side that is moving, return false
    if((pieceColor == "White" && mover == -1)||(pieceColor == "Black" && mover == 1)){
      return false;
    }
      
    //set so that pieces can be treated equally reagrdless of color
    startPiece = Character.toLowerCase(startPiece);
    //Can't move to a square that you already have a piece on
    if ((Character.isLowerCase(board.brd[endSquare[1]][endSquare[0]]) && pieceColor == "Black") ||
        (Character.isUpperCase(board.brd[endSquare[1]][endSquare[0]]) && pieceColor == "White")) {
       
          return false;
    }
    //when checking for check
    boolean confirmed = false;
   if(checkForCheck){
    //iterate through legal moves
     for(int i = 0; i<board.legalMoves.length; i++){
       if(move.equals(board.legalMoves[i])){
         confirmed = true;
       }
     }
     //if the move you are playing is illegal by prior examination, return false
     if(!confirmed){
     return false;
     }
   }
   
   //If not just checking
    if(!justChecking){
      //update en passant rules
    if(allowEnPassant){
      allowEnPassant = false;
    }
    else{
      ePS[0] = -1;
      ePS[1] = -1;
    }
    }
   
    switch (startPiece) {
      //pawn
        case 'p':
              //used because pawns go different directions based upon color
            int m = -1;
            if (pieceColor == "Black")
                m = 1;
            if (endSquare[1] == startSquare[1] + 1 * m && (endSquare[0] == startSquare[0] + 1 || endSquare[0] == startSquare[0] - 1)) {
                    //Capturing
              if (((Character.isLowerCase(board.brd[endSquare[1]][endSquare[0]]) && pieceColor == "White") ||
                            (Character.isUpperCase(board.brd[endSquare[1]][endSquare[0]]) && pieceColor == "Black")) ||
                        ((endSquare[1] == ePS[0] && endSquare[0] == ePS[1]) &&
                            ((Character.isLowerCase(board.brd[endSquare[1]+1][endSquare[0]]) && pieceColor == "White") ||
                                (Character.isUpperCase(board.brd[endSquare[1]-1][endSquare[0]]) && pieceColor == "Black")))) {
                                 //if this is the real deal
                                  if(!justChecking){
                                    //if en passant
                                  if(board.brd[endSquare[1]][endSquare[0]] == ' '){
                                    //capture pawn
                                  board.brd[endSquare[1]+mover][endSquare[0]] = ' ';
                                }
                                //promotion if back rank achieved
                                 if(endSquare[1] == 0 && m ==-1){
                                    //TO DO: Underpromotion
                                    board.brd[startSquare[1]][startSquare[0]] = 'Q';
                                  }
                                  else if(endSquare[1] ==7 && m == 1){
                                          board.brd[startSquare[1]][startSquare[0]] = 'q';
                                  }
                                 }
                        return true;
                    }
                    //Otherwise if moving forward
            } else if (board.brd[endSquare[1]][startSquare[0]] == ' ') {
              //if one square
                if (endSquare[1] == startSquare[1] + 1 * m && endSquare[0] == startSquare[0]) {
                  //if just checking, check for promotion on back rank
                    if(!justChecking){
                    
                      if(endSquare[1] == 0 && m ==-1){
                        
                          board.brd[startSquare[1]][startSquare[0]] = 'Q';
                         
                        }
                        else if(endSquare[1] ==7 && m == 1){
                         
                                board.brd[startSquare[1]][startSquare[0]] = 'q';
                        }
                      }
                    
                    return true;
                    //two square advance, checks to see if on starting rank and that you are not jumping
                } else if (((startSquare[1] == 1 && m == 1) || (startSquare[1] == 6 && m == -1)) &&
                    endSquare[1] == startSquare[1] + 2 * m &&
                    board.brd[startSquare[1] + 2 * m][startSquare[0]] == ' ' &&
                    board.brd[startSquare[1] + 1 * m][startSquare[0]] == ' ' &&
                    endSquare[0] == startSquare[0]) {
                      //if not just checking, set en passant rules
                      if(!justChecking){
                    allowEnPassant = true;
                    ePS[0] = startSquare[1]+1*m;
                    ePS[1] = startSquare[0];
                      }
                    return true;
                }
            }
           
            break;
            //rook
        case 'r':
            //if moving horizontally
            if (startSquare[1] == endSquare[1]) {
                //iterates through to make sure you aren't moving through something
                for (int i = min(startSquare[0], endSquare[0]); i < max(startSquare[0], endSquare[0]); i++) {
                    if (board.brd[startSquare[1]][i] != ' ' && i != endSquare[0] && i != startSquare[0]) {
                      
                        return false;
                    }

                }
                //if not just checking
                if(!justChecking){
                  //set castline rules
                  if(startSquare[0] == 0 && startSquare[1] == 7 &&pieceColor == "White"){
                   //White queen's rook
                    aTC[0] = false;
                  }
                  else if(startSquare[0] == 7 && startSquare[1] == 7 &&pieceColor == "White"){
                    //White king's rook
                    aTC[1] = false;
                  }
                  else if(startSquare[0] == 0 && startSquare[1] == 0 &&pieceColor == "Black"){
                    //Black queen's rook
                    aTC[2] = false;
                  }
                  else if(startSquare[0] == 7 && startSquare[1] == 0 &&pieceColor == "Black"){
                    //Black king's rook
                    aTC[3] = false;
                  }
                }
                return true;
                //If moving vertically
            } else if (startSquare[0] == endSquare[0]) {
                //iterate through all squares moving through and test to see that you are not jumping
                for (int i = min(startSquare[1], endSquare[1]); i < max(startSquare[1], endSquare[1]); i++) {

                    if (board.brd[i][startSquare[0]] != ' ' && i != endSquare[1] && i != startSquare[1]) {
                        return false;
                    }

                }  
                //If not just checking, update castling laws
                if(!justChecking){
               if(startSquare[0] == 0 && startSquare[1] == 7 &&pieceColor == "White"){
              
                  aTC[0] = false;
                }
                else if(startSquare[0] == 7 && startSquare[1] == 7 &&pieceColor == "White"){
                  aTC[1] = false;
                }
                else if(startSquare[0] == 0 && startSquare[1] == 0 &&pieceColor == "Black"){
                  aTC[2] = false;
                }
                else if(startSquare[0] == 7 && startSquare[1] == 0 &&pieceColor == "Black"){
                  aTC[3] = false;
                }
                }
                return true;
            }
           
             
            break;
            //Bishop
        case 'b':
          //if moving diagonally
            if (startSquare[0] - endSquare[0] == startSquare[1] - endSquare[1] ||
                startSquare[0] - endSquare[0] == -(startSquare[1] - endSquare[1])) {
                    //simple variable means moving from top left to bottom right
                boolean simple = false;
                if (startSquare[0] - endSquare[0] == startSquare[1] - endSquare[1]) {
                    simple = true;
                }
                
            //iterate through the length of the diagonal
                for (int i = 0; i < max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]); i++) {

                    try {
                      //Checks to see spaces are empty
                        if (board.brd[min(startSquare[1], endSquare[1]) + i][min(startSquare[0], endSquare[0]) + i] != ' ' &&
                            i != 0 && i != max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]) && simple) {
                            //if they are not, return false
                            return false;
                        } else if (board.brd[max(startSquare[1], endSquare[1]) - i][min(startSquare[0], endSquare[0]) + i] != ' ' &&
                            i != 0 && i != max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]) && !simple) {

                            return false;
                        }
                    } catch (Exception e) {

                    }
                }
                //otherwise return true
                return true;
            }

            break;
            //Queen
        case 'q':
                //THIS IS JUST ROOK + QUEEN, if you want further info, go back to those sections
            if (startSquare[0] - endSquare[0] == startSquare[1] - endSquare[1] ||
                startSquare[0] - endSquare[0] == -(startSquare[1] - endSquare[1])) {
                boolean simple = false;
                if (startSquare[0] - endSquare[0] == startSquare[1] - endSquare[1]) {
                    simple = true;
                }
                
                for (int i = 0; i < max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]); i++) {

                    try {
                        if (board.brd[min(startSquare[1], endSquare[1]) + i][min(startSquare[0], endSquare[0]) + i] != ' ' &&
                            i != 0 && i != max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]) && simple) {
                           
                            return false;
                        } else if (board.brd[max(startSquare[1], endSquare[1]) - i][min(startSquare[0], endSquare[0]) + i] != ' ' &&
                            i != 0 && i != max(startSquare[0], endSquare[0]) - min(startSquare[0], endSquare[0]) && !simple) {

                            return false;
                        }
                    } catch (Exception e) {

                    }
                }
                return true;
            } else if (startSquare[1] == endSquare[1]) {

                for (int i = min(startSquare[0], endSquare[0]); i < max(startSquare[0], endSquare[0]); i++) {
                    if (board.brd[startSquare[1]][i] != ' ' && i != endSquare[0] && i != startSquare[0]) {
                      
                        return false;
                    }
                
                }
                return true;
            } else if (startSquare[0] == endSquare[0]) {

                for (int i = min(startSquare[1], endSquare[1]); i < max(startSquare[1], endSquare[1]); i++) {

                    if (board.brd[i][startSquare[0]] != ' ' && i != endSquare[1] && i != startSquare[1]) {
                       
                      return false;
                    }

                }  
                return true;
            }
            break;
            
            //Knight
            
        case 'n':
            //if you are moving 2 squares one way, and one square the other, return true.  Knights are easy
            if ((dist(startSquare[0], 0, endSquare[0], 0) == 1 && dist(startSquare[1], 0, endSquare[1], 0) == 2) ||
                (dist(startSquare[0], 0, endSquare[0], 0) == 2 && dist(startSquare[1], 0, endSquare[1], 0) == 1)) {
                return true;
            }
            break;
            
            //King
        case 'k':
            //If end square is one square away
           if(dist(startSquare[0], 0, endSquare[0], 0)<=1 && dist(startSquare[1], 0, endSquare[1], 0)<=1){
             //if not just checking
             if(!justChecking){
               //update castling laws
               if(pieceColor == "White"){
                 aTC[0] = false;
                 aTC[1] = false;
               }
               else{
                 aTC[2] = false;
                 aTC[3] = false;
               }
             }
             //this part of kings are pretty easy.  Return true
             return true;
           }
           //This tests to see if castling laws would prevent you from castling.  If they do, you can't.  If they don't, you can.
           else if((((startSquare[0] == 4 && startSquare[1] == 7 && pieceColor == "White")
           ||(startSquare[0] == 4 && startSquare[1] == 0 && pieceColor == "Black"))
           &&((startSquare[0] == endSquare[0]+2 && board.brd[startSquare[1]][startSquare[0]-1]==' '
           &&board.brd[startSquare[1]][startSquare[0]-3]==' '
           &&((aTC[0]&&pieceColor == "White")||(aTC[2]&&pieceColor == "Black")))
           ||(startSquare[0] == endSquare[0]-2 && board.brd[startSquare[1]][startSquare[0]+1]==' '
           &&((aTC[1]&&pieceColor == "White")||(aTC[3]&&pieceColor == "Black")))))
           &&startSquare[1] == endSquare[1]){
             //If checking for check
             if(checkForCheck){
               //This will be the end square
             int [] square = new int[2];
             //This contains the array accessible values of the start square
             int [] sSquare = {startSquare[1], startSquare[0]};
             //hypothetical move
             Move hMove; 
             //on hypothetical board
             Board castleCheck = board.copyBoard();
             //If castling long
             if(startSquare[0] == endSquare[0]+2){
               square[0] = endSquare[1];
               square[1] = endSquare[0]+1;
              
             }
             //If castling short
             else{
               square[0] = endSquare[1];
               square[1] = endSquare[0]-1;
             }
             //Creates a hypothetical move to see if the king could legally move one square (instead of two) in the direction castling
             hMove = new Move(convert.intoString(sSquare)+convert.intoString(square), castleCheck, false);
               //if not, return false
               if(!hMove.legalMove(true, true)){
                
                 return false;
               }
               //sets up position to move back  
                castleCheck.brd[hMove.endSquare[1]][hMove.endSquare[0]] = castleCheck.brd[hMove.startSquare[1]][hMove.startSquare[0]];
                 castleCheck.brd[hMove.startSquare[1]][hMove.startSquare[0]] = ' ';
                 castleCheck.aTC = aTC.clone();
                 castleCheck.ePS = ePS.clone();
                 castleCheck.allowEnPassant = allowEnPassant;
               
                 
                 castleCheck.assessLegalMoves();
               //Creates a hypothetical move to see if the king could legally move back to the original square
               hMove = new Move(convert.intoString(square)+convert.intoString(sSquare), castleCheck, false);
                //if not, return false
                if(!hMove.legalMove(true, true)){
                 
                 return false;
               }
             }
             //If not just checking, have the rook move too
             if(!justChecking){
               if(endSquare[0] == startSquare[0]-2){
                 board.brd[startSquare[1]][3] = board.brd[startSquare[1]][0];
                 board.brd[startSquare[1]][0] = ' ';
               }
               else{
                 board.brd[startSquare[1]][5] = board.brd[startSquare[1]][7];
                 board.brd[startSquare[1]][7] = ' ';
               }
             }
             //return legal move
              return true;
           }
            break;

    }

    //If not told to do otherwise, default to return false
    return false;
}
}
