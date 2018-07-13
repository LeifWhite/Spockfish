class Brain{
  //board to analyze
  Board board;
  //factor weight
  double [] factors = new double[7];
  final float VARIATION = 0.5;
  //branch(0) = brain, branch(1) = sub-branches
  //used to hold tree of branches for minimax iteration
  ArrayList <Brain> branch = new ArrayList<Brain>();
  //evaluation of position
  double eval;
  Brain(Board b){
    board = b;
    //Pawn, Knight, Bishop, Rook, Queen, Center Control, King Safety
    factors[0] = 1.0;
    factors[1] = 3.0;
    factors[2] = 3.15;
    factors[3] = 5.0;
    factors[4] = 9.0;
    factors[5] = 0.05;
    factors[6] = 0.05;
    //sets evaluation
    eval = positionEvaluation();
    
  }
   /**
  *Used to determine best possible move assuming your opponent plays the best possible move etc.
  *
  *@return the best brain of the bunch
  */
  Brain minimax(){
   //sets returning brain to null
   Brain b = null;
   //This is to determine the best possible result from the list of brains iterated through.  
   //Starts out set as an outrageously bad number
   double maxEval = -1000*board.mover;
   
  // println(branch.size()+", "+branch.get(0));
  
  //If there are actually branches...
   if(branch.size()>0){
     //iterate through the branches
    for(int i = 0; i<branch.size(); i++){
      //used to choose randomly between eqaully good moves
      double randVal = random(-VARIATION, VARIATION);
      //Minimaxes all branches using recursive function
      Brain holdVal = branch.get(i).minimax();
      //if the current evaluation is stronger than the previous max, this becomes the new max
       if((holdVal.eval+randVal>maxEval && board.mover == 1)||(holdVal.eval+randVal<maxEval && board.mover == -1)){
         maxEval = holdVal.eval+randVal;
         b = branch.get(i);
         //b.board.playMove = branch.get(i).board.playMove;
         //println(board.playMove.move);
       }
    }
   }
   //if there are no branches, return current brain
   else{
     b = this;
   }
   //return best brain move
   return b;
  }
   /**
  *Sets the branches variables equal to every possible brain if a any move is played
  *
  *@param depth How deep to search before evaluation. Stronger and ~30 times longer per ply.  MUST BE EVEN
  */
  void plies (int depth){
    //If depth does not equal 0
    if(depth!=0){
      //iterate through all legal moves
      for(int i = 0; i<board.legalMoves.length; i++){
        //play them on a hypothetical board
        Board testBoard = board.copyBoard();
        //creates hypothetical move on hypothetical board
         testBoard.playMove = new Move(board.legalMoves[i], testBoard, false);
         //plays hypothetical move on hypothetical board
         testBoard.playMove.makeMove();
         //assess legal moves on hypothetical board
         testBoard.assessLegalMoves();
         testBoard.updateLegalMoves();
         //creates new brain based upon this hypothetical move on the hypothetical board
         Brain testBrain = new Brain(testBoard);
         //recursive algorithm to apply the same function to that brain
         testBrain.plies(depth-1);     
         //adds this brain to the move branches
         branch.add(testBrain);
        
        
      }
    }
    else{
      /** I DON'T KNOW WHY I ADDED THIS**/
     // branch.add(this);
    }
    
  }
  /**Determines how strong a position is
  *
  *@return Returns the positional evaluation, positive means white is stronger, negative means black is stronger
  */
  double positionEvaluation(){
    //sees how this game could end
    String gameEnd = board.gameEnd();
    //if the game ends in checkmate evaluation
    if(gameEnd == "Checkmate"){
      //set evaluation as ridiculously high
      return board.mover*-500;
    }
    //if game ends in a draw, return eval of 0
    else if(gameEnd == "Draw"){
      return 0;
    }
    //otherwise, compute positional sum
    double sum = 0;
    //iterate through the board
    for(int i = 0; i<board.brd.length; i++){
       for(int j = 0; j<board.brd[i].length; j++){
        
           //Holds converted king squares
         int[][] cK = {convert.intoArray(board.kingPos[0]), convert.intoArray(board.kingPos[1])};
         
          //if the controlled square on mirror board is non-zero
         if(board.controlledSquares[i][j]!=0 ){
           //Test center control
           if(dist(i, j, 3.5, 3.5)<=2.1){
             sum+=factors[5]*board.controlledSquares[i][j];
             if(dist(i, j, 3.5, 3.5)<=1.1){
               sum+=factors[5]*board.controlledSquares[i][j];
             }
           }
           //King safety
    
           if(dist(i, j, cK[0][0], cK[0][1])<=1.5){
           
               sum+=factors[6]*board.controlledSquares[i][j];
               if(i == cK[0][0] && j == cK[0][1]){
                 sum+=factors[6]*board.controlledSquares[i][j]*0.5;
               }             
               
             
           }
            if(dist(i, j, cK[1][0], cK[1][1])<=1.5){
            
               sum+=factors[6]*board.controlledSquares[i][j];
               if(i == cK[1][0] && j == cK[1][1]){
                 sum+=factors[6]*board.controlledSquares[i][j]*0.5;
               }
             
           }
         }
         //if the square holds a piece
         if(board.brd[i][j]!=' '){
          
         int multip;
         //multiplier is to add a negative value for a black piece and a positive value for a white one
         if(Character.isLowerCase(board.brd[i][j])){
           multip = -1;
         }
         else{
           multip = 1;
         }
          if(dist(i, j, cK[0][0], cK[0][1])<=1.5||dist(i, j, cK[1][0], cK[1][1])<=1.5){
             sum+=factors[6]*multip;
           }
         //sees what piece it is and adds the piece value to the evaluation
         switch(Character.toLowerCase(board.brd[i][j])){
           case 'p':
           sum += factors[0]*multip;
           break;
           case 'n':
           sum += factors[1]*multip;
           break;
           case 'b':
           sum += factors[2]*multip;
           break;
           case 'r':
           sum += factors[3]*multip;
           break;
           case 'q':
           sum += factors[4]*multip;
           break;
         }
         
         }
        
      }
    }
    //returns quantitative position evaluation     
    return sum;
  }
  
}
