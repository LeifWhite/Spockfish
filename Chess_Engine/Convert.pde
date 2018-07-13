class Convert{
  /**Very basic class, only used to convert string squares into arrays and vice versa*/
  Convert(){
    
  }
 /**Converts a string square such as "e8" into an array like [0][4]
  *
  *@param square string, something like "c7" or "b3"
  */
int[] intoArray (String square) {
      //Initialization of return value
      int[] convertedSquare = new int[2];
        //Uses ascii to convert char values into int values
        convertedSquare[0] = square.charAt(0) - 97;
        convertedSquare[1] = abs((square.charAt(1) - 49) - 7);
        //returns the converted square
        return convertedSquare;
    }
  /**Converts a an array index for a square such as [3][7] into a square value like "d1"
  *
  *@param square array, something like [2][4] or [7][0]
  */
    String intoString(int[] square) { //input normal array style
     //Initialization of return value
        String convertedSquare = "";
    //Uses ascii to convert int values into char values
        convertedSquare += (char)(square[1] + 97);
        convertedSquare += (char)(abs(square[0] - 7) + 49);
        //returns the converted square
        return convertedSquare;
    }
   
}
