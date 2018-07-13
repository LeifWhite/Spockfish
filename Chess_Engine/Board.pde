class Board{
  //Character board
  char [][] brd; 
  /*Used to determine which squares are controlled by which side.  
  For each white piece controlling a square 1 is added, 
  for each black piece controlling a square 1 is subtracted
  */
  int [][] controlledSquares = {
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0}
  };
  //Used to determine where the kings are
  String [] kingPos = new String[2];
  //En Passant Square coordinates
  int [] ePS = new int[2]; 
  //Castling rules, (Queenside white, kingside white, queenside black, kingside black)
  boolean [] aTC = new boolean[4]; 
  //Allows en passant or not
  boolean allowEnPassant; 
  //1 represents white, -1 represents black
  int mover;  
  //Count on 50-move rule
  int mSB;
  //What move is played on this board
  Move playMove;  
  //List of legal moves
  String [] legalMoves;
  String [] oppLegalMoves;
  Board(char[][] b){  
    //Initialization
    mSB = 0;
    brd = b;
    ePS[0] = -1;
    ePS[1] = -1;
    for(int i = 0 ; i<aTC.length; i++){
      aTC[i] = true;
    }
    allowEnPassant =  false;
    mover = 1;
    for(int i = 0; i<brd.length; i++){
      for(int j = 0; j<brd[i].length; j++){
        if(brd[i][j] == 'k'){
          int [] square = {i, j};
          kingPos[1] = convert.intoString(square);
        }
        else if(brd[i][j] == 'K'){
          int [] square = {i, j};
          kingPos[0] = convert.intoString(square);
        }
      }
    }
    
  }
  /*************/
  /**
  *Sets the variable legalMoves using the determine LegalMoves method
  *
  *
  */
  void assessLegalMoves (){
   
  legalMoves = determineLegalMoves(mover);
  
  
  }
  /************/
 /**
  *Resets all controlled squares
  *
  *@Line Reference: 4
  */
  void controlledSquareReset(){
    for(int i = 0; i<controlledSquares.length; i++){
      for(int j = 0; j<controlledSquares[i].length; j++){
        controlledSquares[i][j] = 0;
      }
    }
  }
  /*********/
 /**
  *Used to determine all possible moves available to a given piece assuming that there are no pieces on the board
  *This creates a more efficient process in determining legal moves
  *
  *@param p which piece is being evaluated
  *@param startSquare array indexes of starting square
  *@return a list of possible legal moves assuming empty board
  */
  ArrayList <String> legalMoveTo(char p, int [] startSquare){
    //Initializes list to be returned
    ArrayList <String> ls = new ArrayList<String>();
    //if it is legal, add one hit to a controlled square (BROKEN)

    //Switches through possible piece types, uses Character.toLowerCase() because side does not matter
    switch(Character.toLowerCase(p)){
      
      //Pawn
      
      case 'p':
      //End Square locations
      int [][] eSA = {
      {startSquare[0]-mover, startSquare[1]},
      {startSquare[0]-mover, startSquare[1]-1},
      {startSquare[0]-mover, startSquare[1]+1},
      {startSquare[0]-(2*mover), startSquare[1]},
    };
    //Iterates through end square locations and adds all possibilities (including captures) that are possible to the list
      for(int i = 0; i<eSA.length-1; i++){
        //Makes sure array is not out of bounds
        if(eSA[i][0]>=0 && eSA[i][0]<=7 && eSA[i][1]>=0 && eSA[i][1]<=7){
        ls.add(convert.intoString(eSA[i]));
        if(i!=0){
        controlledSquares[eSA[i][0]][eSA[i][1]]+=mover;
        }
        }
      }
      //Adds double move if on first rank
      if((mover == 1 && startSquare[0] ==6) || (mover == -1 && startSquare[0] == 1)){
         ls.add(convert.intoString(eSA[3]));
         
      }
      break;
      
      //Knight
      
      case 'n':
      //Knight end squares
      int [][] endSq = {
        {startSquare[0]+2, startSquare[1]+1},
        {startSquare[0]-2, startSquare[1]+1},
        {startSquare[0]+2, startSquare[1]-1},
        {startSquare[0]-2, startSquare[1]-1},
        {startSquare[0]+1, startSquare[1]+2},
        {startSquare[0]+1, startSquare[1]-2},
        {startSquare[0]-1, startSquare[1]+2},
        {startSquare[0]-1, startSquare[1]-2},
      };
      //Iterates through end squares and adds to list
      for(int i = 0; i<endSq.length; i++){
        //Makes sure array is not out of bounds
        if(endSq[i][0]>=0 && endSq[i][0]<=7 && endSq[i][1]>=0 && endSq[i][1]<=7){
        ls.add(convert.intoString(endSq[i]));
        controlledSquares[endSq[i][0]][endSq[i][1]]+=mover;
        }
      }
      break;
      //Rook
      case 'r':
      //Iterates through board length
      for(int i = 0; i<8; i++){
        //Sets end squares accross vertical axis, using remainder to go to prior indexed squares
        int [] eS = {(startSquare[0]+i)%8, startSquare[1]};
        //if not start square, adds to list
        if((startSquare[0]+i)%8!=startSquare[0]){
        ls.add(convert.intoString(eS));
        controlledSquares[eS[0]][eS[1]]+=mover;
        }
        //Sets end squares accross horizontal axis, using remainder to go to prior indexed squares
        int [] eS2 = {startSquare[0], (startSquare[1]+i)%8};
         //if not start square, adds to list
         if((startSquare[1]+i)%8!=startSquare[1]){
        ls.add(convert.intoString(eS2));
         controlledSquares[eS2[0]][eS2[1]]+=mover;
         }
      }
      break;
      
      //Bishop
      
      case 'b':
      //index for while loop, used while instead of for loop in order to have more flexible indexing
     int w = 1;
     /*Used for flexibility, 
     once indexed until end of possible forward movement, 
     moves back to starting square and works backwards*/
     boolean forward = true;
     //Iteration as long as necessary through top left to bottom right movement
       while(true){      
         //If still moving forward and reach end of board, go backward
         if(forward &&(startSquare[0]+w > 7 || startSquare[1]+w>7)){
           forward = false;
           w = 1;
         }
         //if moving forward, add all diagonal squares in your path
         if(forward){
         int [] eS = {startSquare[0]+w, startSquare[1]+w};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         //if moving backward, add all diagonal squares in your path while subtracting iterator
         else if(startSquare[0]-w>=0 && startSquare[1]-w>=0){
         int [] eS = {startSquare[0]-w, startSquare[1]-w};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         //otherwise end loop
         else{
           break;
         }
        //increments iterator
           w++;
        
       }
       //resets for second type of movement
       w = 1;
       forward = true;
       //Iteration as long as necessary through top right to bottom left movement
       while(true){      
           //If still moving forward and reach end of board, go backward
         if(forward &&(startSquare[0]+w > 7 || startSquare[1]-w<0)){
           forward = false;
           w = 1;
         }
         //Moves down and to the left adding elements to list
         if(forward){
         int [] eS = {startSquare[0]+w, startSquare[1]-w};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         //Moves up and to the right adding elements to list
         else if(startSquare[0]-w>=0 && startSquare[1]+w<=7){
         int [] eS = {startSquare[0]-w, startSquare[1]+w};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         //Breaks from loop
         else{
           break;
         }
         //increments iterator
         w++;
       }
      break;
      
      //Queen
      
      case 'q':
      //This is a copy and paste of the rook case plus the bishop case.  For more information, visit those.
      //Rook movement
      for(int i = 0; i<8; i++){
        
        int [] eS = {(startSquare[0]+i)%8, startSquare[1]};
        if((startSquare[0]+i)%7!=startSquare[0]){
        ls.add(convert.intoString(eS));
        controlledSquares[eS[0]][eS[1]]+=mover;
        }
        int [] eS2 = {startSquare[0], (startSquare[1]+i)%8};
         if((startSquare[1]+i)%8!=startSquare[1]){
        ls.add(convert.intoString(eS2));
        controlledSquares[eS2[0]][eS2[1]]+=mover;
         }
       
      }
      //Bishop movement (used different variable names because cases do not have sub-local variables)
       int r = 1;
       boolean f = true;
       while(true){      
         if(f &&(startSquare[0]+r > 7 || startSquare[1]+r>7)){
           f = false;
           r = 1;
         }
         if(f){
         int [] eS = {startSquare[0]+r, startSquare[1]+r};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         else if(startSquare[0]-r>=0 && startSquare[1]-r>=0){
         int [] eS = {startSquare[0]-r, startSquare[1]-r};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         else{
           break;
         }
        
           r++;
        
       }
       r = 1;
       f = true;
       while(true){      
         if(f &&(startSquare[0]+r > 7 || startSquare[1]-r<0)){
           f = false;
           r = 1;
         }
         if(f){
         int [] eS = {startSquare[0]+r, startSquare[1]-r};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         else if(startSquare[0]-r>=0 && startSquare[1]+r<=7){
         int [] eS = {startSquare[0]-r, startSquare[1]+r};
         ls.add(convert.intoString(eS));
         controlledSquares[eS[0]][eS[1]]+=mover;
         }
         else{
           break;
         }
         r++;
       }
      break;
      
      //King
      
      case 'k':
      //All possible end squares including castling
      int [][] endSquares = {
        {startSquare[0], startSquare[1]+1},
        {startSquare[0]-1, startSquare[1]+1},
        {startSquare[0]+1, startSquare[1]+1},
        {startSquare[0], startSquare[1]-1},
        {startSquare[0]-1, startSquare[1]-1},
        {startSquare[0]+1, startSquare[1]-1},
        {startSquare[0]-1, startSquare[1]},
        {startSquare[0]+1, startSquare[1]},
        {startSquare[0], startSquare[1]+2},
        {startSquare[0], startSquare[1]-2}
      };
      //Iterates through all basic king movement
      for(int i = 0; i<endSquares.length-2; i++){
        //If in array range, adds to list
        if(endSquares[i][0]>=0 && endSquares[i][0]<=7 && endSquares[i][1]>=0 && endSquares[i][1]<=7){
        ls.add(convert.intoString(endSquares[i]));
        controlledSquares[endSquares[i][0]][endSquares[i][1]]+=mover;
        }
      }
      //Adds castling squares if king is on starting square
      if(startSquare[1] == 4 && (startSquare[0] == 0||startSquare[0] == 7)){
        ls.add(convert.intoString(endSquares[8]));
        ls.add(convert.intoString(endSquares[9]));
        controlledSquares[endSquares[8][0]][endSquares[8][1]]+=mover;
        controlledSquares[endSquares[9][0]][endSquares[9][1]]+=mover;
      }
      break;
      
    }
    //Returns generated list
    return ls;
  }
   /*************/
   /**
  *Updates array of legal moves by testing for check 
  *
  */
  void updateLegalMoves () {
    //Arraylist used so it has flexible size
     ArrayList <String> lMoves = new ArrayList<String>();
     //Iterates through legal moves
     for(int i = 0; i<legalMoves.length; i++){
       /*Creates hypothetical move using:
       1. The iterated possible legal move
       2. The current board
       3. Asking for no real output
       */
       Move tMove = new Move(legalMoves[i], this, false);
       //If the move is a castling move, determine special legality and update lMoves
      if(Character.toLowerCase(tMove.startPiece) == 'k' && dist(tMove.startSquare[0], 0, tMove.startSquare[1], 0) == 2){
        /**CURRENTLY BROKEN, FIX THIS (Not working as should, castle into check?)*/
        if(tMove.legalMove(true, true)){
           lMoves.add(legalMoves[i]);
        }
        //If not legal, continue to next move
        else{
          continue;
        }
      }
      //Otherwise, if move does not result in check, add to legal moves
      else if(!tMove.inCheck()){
         lMoves.add(legalMoves[i]);
       }
     }
     //updates legal moves based on the updates from checks
     legalMoves = new String[lMoves.size()];
     for(int i = 0; i<lMoves.size(); i++){
       legalMoves[i] = lMoves.get(i);
     }
  }
  
   /*************/
   /**
  *Used to determine if game has been finished yet and returns how it has
  *
  *@return Kind of game end (Checkmate, draw, or none)
  */
  String gameEnd (){
    /**REQUIRES DRAW BY INSUFFICIENT MATERIAL*/
    //Updates legal moves
    chessboard.updateLegalMoves();
    //If one side has no legal moves   
    if(legalMoves.length == 0){
      //if that side is in check, game ends by checkmate
      if(isInCheck()!=0){
          return "Checkmate";
      }
      //otherwise it is a stalemate draw
      else{
        return "Draw";
      }
    }
    //Draw by 50 move rule
    if(mSB>=100){
      return "Draw";
    }
    /**IS NOT IMPLEMENTED IN HYPOTHETICAL MOVES YET*/
    //Goes through board log determines if position has been repeated 3 times for draw by repetition
    for(Board[] b:b_log){
      for(int i = 0; i<b.length; i++){
        //Count of how many times a position has been repeated
      int count = 0;
      //Iterates through boards again
       for(Board[] b2:b_log){
         try{
           //Tests to see if boards are equal using bequals method
          if(b[i].bequals(b2[i])){
          count ++;
          
          }
         }
         catch(Exception e){
           
         }
        }
        //count will always be at least 1 because it tests to see if one board equals itself
        if(count>=3){
          //if position has been repeated three times, return draw
          return "Draw";
        }
      }
    }
    //otherwise, return none
    return "None";
  }
  
   /*************/
  /**Used to determine if a position is in check
  *
  *@return which side is in check (1 is white, -1 is black, 0 is nobody)
  */
  int isInCheck(){
    //Generates all possible moves from either side in a position
     String [] allMoves = determineLegalMoves(mover*-1);
     //Iterates through board for king locations
     for(int i = 0; i<brd.length; i++){
        for(int j = 0; j<brd.length; j++){
           int [] square = {i, j};
           //if piece is a king
           if(Character.toLowerCase(brd[i][j]) == 'k'){
             //Updates king position
             if(brd[i][j] == 'k'){
               kingPos[1] = convert.intoString(square);
             }
             else{
               kingPos[0] = convert.intoString(square);
             }
             /*CAN BE ADJUSTED FOR EFFICIENCY?  ARE ALL MOVES NECESSARY?*/
             //iterates through all possible moves from either side
             for(int k = 0; k<allMoves.length; k++){
              //If final square is equal to the square the king is on
               if(allMoves[k].substring(2,4).equals(convert.intoString(square))){
                 //Determine  what square the attacking piece is from
                 int [] fromSquare = convert.intoArray(allMoves[k].substring(0, 2));
                //Makes sure that the attacking piece is from a different side than the attacked king
                 if(brd[i][j] == 'K' && Character.isLowerCase(brd[fromSquare[1]][fromSquare[0]])){
                   //If attacked king is white, return 1
                   return 1;
                 }
                 else if(brd[i][j] == 'k' && Character.isUpperCase(brd[fromSquare[1]][fromSquare[0]])){
                   //If attacked king is black, return -1
                   return -1;
                 }
               }
             }
           }
        }       
     }
     //Otherwise return 0
     return 0;
  }
  
   /*************/
  /**
  *Used to determine generate a list of legal moves ignoring checks.
  *
  *@param sideSpecific used to determine if both sides moves are being evaluated or not
  *@return an array of all possible legal moves ignoring checks
  */
  String [] determineLegalMoves(int mr){
    //Arraylist used for size flexibility
   ArrayList <String> lMoves = new ArrayList<String>();
  //iterates through board
   for(int i = 0; i<brd.length; i++){
     for(int j = 0; j<brd[i].length; j++){
      //if the board piece is the same color as the mover or the square is a piece and sideSpecific is false
       if((Character.isLowerCase(brd[i][j]) && mr == -1)||(Character.isUpperCase(brd[i][j]) && mr ==1)){
         //sets start square
       int [] square = {i, j};
       //determines all possible moves if blank board
        ArrayList <String> ls = legalMoveTo(brd[i][j], square);
        //iterates through those
        //println(ls.size());
          for(int k = 0; k<ls.size(); k++){          
               /*generates hypothetical move using 
               the start square, 
               legalMoveto generated end square, 
               this board, 
               and acknowledging hypothetical move
               */
               Move testLegality = new Move(convert.intoString(square)+ls.get(k), this, false);
               //Sets the side you want to check for legal moves for
               testLegality.mover = mr;
               //Tests if the move is legal or not
               if(testLegality.legalMove(true, false)){                
                 //add to legal moves list                 
                 lMoves.add(testLegality.move);
               }
               
             }
          
         
       }
       
     }
   }
   //Convert arrayList to array
   String [] legalReturns = new String[lMoves.size()];
   for(int i = 0; i<lMoves.size(); i++){
     legalReturns[i] = lMoves.get(i);
     
   }
   //return legal moves list
   return legalReturns;
  }
  
   /*************/
   /**
  *Used to determine if two boards are equal (vital for three time repetition draw)
  *
  *@param b Used for comparison to current board
  *@return true if boards are equal, false if they are not
  */
  boolean bequals(Board b){
    //iterates through board
    for(int i = 0; i<brd.length; i++){
      //checks if arrays are equal
      if(!Arrays.equals(brd[i], b.brd[i])){
        return false;
      }
    }
    //Checks if en passant, castling rights, and side moving are the same
    if(Arrays.equals(ePS, b.ePS) && Arrays.equals(aTC, b.aTC) && mover==b.mover){
      
      return true;
    }
    //if not, return false
    return false;
  }
  
   /*************/
  /**
  *Used to copy this board into a new one
  *
  *@return The copied board
  */
  Board copyBoard(){
    //constructs a new board to build off of the old one
    char [][] constructBoard = new char[8][8];
    //iterates through old board and sets new board values to old board values
    for(int i = 0; i<brd.length; i++){
       for(int j = 0; j<brd.length; j++){
      constructBoard[i][j] = brd[i][j];
      }
    }
    //creates a new board to return
    Board b = new Board(constructBoard);
    //sets new board values to old board values
    b.mSB = mSB;
    b.ePS[0] = ePS[0];
    b.ePS[1] = ePS[1];
    b.mover = mover;
    b.playMove = playMove;
    b.kingPos = kingPos;
    for(int i = 0; i<aTC.length; i++){
      b.aTC[i] = aTC[i];
    }
    b.allowEnPassant = allowEnPassant;
    //sets new board legal moves to old board legal moves
    b.legalMoves = new String[legalMoves.length];
    for(int i = 0; i<legalMoves.length; i++){
      b.legalMoves[i] = legalMoves[i];
    }
    //returns new board
    return b;
  }
}
