import java.util.LinkedList;
import java.util.Iterator;

public class PotentialFields{

  float xOrigin;
  float yOrigin;
  float xFinal;
  float yFinal;
  LinkedList occupiedCells, freeCells, path, list1, list2, obstacles;
  Cell[][] occupationMatrix;
  int rows, columns;
  int mapPositionX, mapPositionY;
  final int potentialExpansion = 40;
  final int potentialExpansionAdjust = potentialExpansion;
  
 
 private int findPosition(int index, boolean isX){
   
   int position;
   
   if(isX){
     position= index*40+mapPositionX;
   }
   else{
     position= index*40+mapPositionY;
   }
   
   
   return position;
 }
 
 private int findIndex(int position, boolean isX){
  
   
   int index;
   
   if(isX){
     index = (position-mapPositionX)/40;
   }
   else{
     index = (position-mapPositionY)/40;
     
   }
   
   
   return index;
 }
 
  PotentialFields( int  mapPositionX, int mapPositionY,  int mapWidth,int mapHeight ){
    //println("potential fields");
   
    this.mapPositionX =  mapPositionX;
    this.mapPositionY =  mapPositionY;
    rows = mapHeight/40;
    columns = mapWidth/40;
   // println("mapPositionx:"+ mapPositionX);
   // println("mapPositiony:"+ mapPositionY);
    
   
    occupiedCells = new LinkedList();
    freeCells = new LinkedList();
    occupationMatrix = new Cell[rows][columns]; 
    //println("linhas y:"+(rows + mapPositionY) + "colunas x: " + (columns +mapPositionX));
    
    list1 = new LinkedList();
    list2 = new LinkedList();
    obstacles = new LinkedList();
  
  }  

 /* preenche o potencial dos obstaculos com MaxValue 
 */
  void fillObstacles2(LinkedList objects ){
      obstacles = objects;
      Iterator it = obstacles.iterator();
      int obj = 0;
      while(it.hasNext()){
        Objectt o = (Objectt) it.next();

        int _height = o.getHeight()+potentialExpansion;
        int _whidth = o.getWidth()+potentialExpansion;
       // println(" Obstacle : "+ obj +" X : " + x + " Y : " + y + "height : " + _height + "whidth : " + _whidth   );
        
       // int contX=x, contY = y;
        
         
         
       
        for(int x=o.getX()-potentialExpansionAdjust, contX=findIndex(x,true), xBegin = x; x >= xBegin && x <  _whidth+xBegin ;x+=40,contX++){
        for(int y=o.getY()-potentialExpansionAdjust, contY =findIndex(y,false), yBegin = y; y >=yBegin && y < _height+yBegin;y+=40,contY++){
              Cell c = new Cell();
              c.setPotential(Integer.MAX_VALUE);
              c.setObstacle(true);
              c.setInitialState(false);
              c.setStatus(true);
              c.setCoordinateX(x);
              c.setCoordinateY(y);
              occupationMatrix[contY][contX] = c;  
             
               
            /*
              println("Matriz fill obstacles 2 get x :  "+occupationMatrix[contY][contX].getCoordinateX());
              println("Matriz fill obstacles 2 get y :  "+occupationMatrix[contY][contX].getCoordinateY());
              println("Matriz fill obstacles 2 potencial :  "+occupationMatrix[contY][contX].getPotential());
              */
        }
      }
  
      obj++;
    }
   
  }
   
  
  /*Preenche todas as células livres
  */
  void fillFreeCells2(){
    //println("fillFreeCells");
  

   
    
     for(int i = 0, x = mapPositionX;  i < columns ; x+=40,i++){
      for(int j = 0, y = mapPositionY; j < rows  ; y+=40,j++){
        if(occupationMatrix[j][i] == null){
         // println("Celula livre "+"i= "+i+"j= "+j);
          Cell c = new Cell();
          c.setPotential(-1);
          c.setObstacle(false);
          c.setInitialState(true);
          c.setStatus(false);
          c.setCoordinateX(x);
          c.setCoordinateY(y);
          occupationMatrix[j][i] = c;
          
          
        }
       
      /*  println(" FillFreeCells getX : "+occupationMatrix[i][j].getCoordinateX());
        println(" FillFreeCells getY : "+occupationMatrix[i][j].getCoordinateY());
        println(" FillFreeCells getInitialState : "+occupationMatrix[i][j].getInitialState());
        println(" FillFreeCells getObstacle : "+occupationMatrix[i][j].getObstacle());
        println(" FillFreeCells getStatus : "+occupationMatrix[i][j].getStatus());
        println(" FillFreeCells getPotential : "+occupationMatrix[i][j].getPotential());*/
        
      }
     }
  }
  
 
  /*Preenche o potencial de todas as células livre conforme origem e destino
  */
  int fillsPotential2(int xOrigin,int yOrigin, int xFinal, int yFinal){
    int potential = 1;
    
             
             xOrigin = findIndex(xOrigin,true);
             yOrigin = findIndex(yOrigin,false);
             xFinal =  findIndex(xFinal, true);
             yFinal =  findIndex(yFinal, false);
    
             occupationMatrix[yFinal][xFinal].setPotential(0);
             //println("Matriz potencial: " + occupationMatrix[yFinal][xFinal].getPotential());
             occupationMatrix[yFinal][xFinal].setStatus(true);
             //println("Matriz Status: " + occupationMatrix[yFinal][xFinal].getStatus());
             occupationMatrix[yFinal][xFinal].setInitialState(false);
             //println("Matriz iniitalstate: " + occupationMatrix[yFinal][xFinal].getInitialState());
             occupationMatrix[yFinal][xFinal].setFilledPotential(true);
             //println("Matriz filledPotential: " + occupationMatrix[yFinal][xFinal].getFilledPotential());
             //potential++;
             fillsAdjacencies2(xFinal,yFinal, potential);
             Iterator it = list1.iterator();
             potential++;
            
             while(it.hasNext()){
               Cell c = (Cell)it.next();
               if(c.getCoordinateX() == findPosition(xOrigin,true) && c.getCoordinateY() == findPosition(yOrigin,false)){
                 /*println("Matriz ponto de origem x : " + c.getCoordinateX());
                 println("Matriz ponto de origem y : " + c.getCoordinateY());
                 println("Matriz ponto de origem potential : " + c.getPotential()); */
                  
                 return c.getPotential();
                 
               }
               else{
                 
                
                 
                 
                  fillsAdjacencies2(findIndex(c.getCoordinateX(),true), findIndex(c.getCoordinateY(),false), potential);
                   
               }
             }
            while(true){
           
              
              if(list2.size() == 0){
                return Integer.MAX_VALUE; //Não achou ninguém, não existe caminho
              }
             potential++;
             LinkedList auxList = new LinkedList();
             auxList = (LinkedList)list2.clone();
             list2.clear();
             Iterator it2 = auxList.iterator();
             
            /* Iterator a = auxList.iterator();
             while(a.hasNext()){
               
               Cell c = (Cell) a.next();
               println("X auxlist : " + c.getCoordinateX() + "Y : " + c.getCoordinateY());
             }*/
             
             while(it2.hasNext()){
               Cell c = (Cell)it2.next();
               
               if(c.getCoordinateX() == findPosition(xOrigin,true) && c.getCoordinateY() == findPosition(yOrigin,false)){
                 /*println("Matriz ponto de origem x : " + c.getCoordinateX());
                 println("Matriz ponto de origem y : " + c.getCoordinateY());
                 println("Matriz ponto de origem potential : " + c.getPotential()); */

                 return c.getPotential();

               }
               else{
                  
                 fillsAdjacencies2(findIndex(c.getCoordinateX(),true), findIndex(c.getCoordinateY(),false), potential);
                     
                      
                  
                  
               }
             

           }
         }
     
    }
    
 /* (Private) Preenche o potencial das adjacencias de cada célula
 */
 int fillsAdjacencies2(int currentX, int currentY, int potential){
  // println("fill Adjacences x :" + currentX + "y: " + currentY);
   
   int neighbords=0;
   
   auxAdjacencies(currentX-1,currentY - 1,potential);
   auxAdjacencies(currentX-1,currentY,potential);
   auxAdjacencies(currentX,currentY-1,potential);
   auxAdjacencies(currentX-1,currentY+1,potential);
   auxAdjacencies(currentX+1,currentY-1,potential);
   auxAdjacencies(currentX+1,currentY,potential);
   auxAdjacencies(currentX,currentY+1,potential);
   auxAdjacencies(currentX+1,currentY+1,potential);

 
   return neighbords;

  }
  
  //Private
  int auxAdjacencies(int x, int y, int potential){
    //println("aux Adjacences x :" + x + "y: " + y);
    
  
    
    if(x>=0 && x<columns && y >= 0 && y< rows){
        
      if(occupationMatrix[y][x].getPotential() == -1 && !occupationMatrix[y][x].getObstacle() && occupationMatrix[y][x].getInitialState() && !occupationMatrix[y][x].getStatus()
                && !occupationMatrix[y][x].getFilledPotential()){
        occupationMatrix[y][x].setPotential(potential);
        occupationMatrix[y][x].setStatus(true);
        occupationMatrix[y][x].setInitialState(false);
        occupationMatrix[y][x].setFilledPotential(true);
        
       /* println("aux adjacencies Potential: " + occupationMatrix[y][x].getPotential());
        println("aux adjacencies Status: " + occupationMatrix[y][x].getStatus());
        println("aux adjacencies InitialState: " + occupationMatrix[y][x].getInitialState());
        println("aux adjacencies filledpotential: " + occupationMatrix[y][x].getFilledPotential()); */
        
        if((potential - 1) == 0){
          list1.add(occupationMatrix[y][x]);
        }
        else{
          list2.add(occupationMatrix[y][x]);
        }
     }
    }
    
    return 0;
  }
 
 //retorna o caminho a ser percorrido a partir do maior potencial até chegar em zero (que é o ponto final)
 String[] returnPath3(int xOrigin,int yOrigin, int xFinal, int yFinal, int maxValue ){
   path = new LinkedList();
   int nextValue = maxValue;
       
             
             xOrigin = findIndex(xOrigin,true);
             yOrigin = findIndex(yOrigin,false);
             xFinal =  findIndex(xFinal, true);
             yFinal =  findIndex(yFinal, false);
   
       path.add(occupationMatrix[yOrigin][xOrigin]);
       //println("Origem  x: " + occupationMatrix[yOrigin][xOrigin].getCoordinateX() + "y : " + occupationMatrix[yOrigin][xOrigin].getCoordinateY() +
       //"potential : " + occupationMatrix[yOrigin][xOrigin].getPotential());
       nextValue--;
       Cell c = adjacentSearch(xOrigin, yOrigin, nextValue);
       while(c!= null  && c.getPotential() == nextValue){
           path.add(c);
           nextValue--;
         
          
           
           c = adjacentSearch(findIndex(c.getCoordinateX(),true), findIndex(c.getCoordinateY(),false), nextValue);
           
          
          
          
       }
       String[] returnPath = new String[path.size()];
             Iterator it = path.iterator();
             int cont=0;
             while(it.hasNext()){
              Cell c1 = (Cell)it.next();
              int x = c1.getCoordinateX() +20;
              int y = c1.getCoordinateY() + 20;
              String s = x + "#" + y;
              //println("caminho s:" +s);
              returnPath[cont] = s;
              cont++;
          }
            
          return returnPath;
      
 }
 
 
 
 //(Private) 
 Cell adjacentSearch(int currentX, int currentY, int potential){
    LinkedList allPotentials = new LinkedList();
    double distance, distAux;
    if(currentX>=0 && currentX<columns && currentY >= 0 && currentY< rows){
      if(!occupationMatrix[currentY][currentX].getObstacle() && !occupationMatrix[currentY][currentX].getInitialState() && occupationMatrix[currentY][currentX].getStatus()
                && occupationMatrix[currentY][currentX].getFilledPotential()){
                  
                 try{
                   if(occupationMatrix[currentY - 1][currentX-1].getPotential() == potential){ //diagonal superior esquerda
                     allPotentials.add(occupationMatrix[currentY - 1][currentX-1]); 
                     //println("diagonal superior esquerda");
                   }  
                  }
                  catch(ArrayIndexOutOfBoundsException e){
                    
                  }
                
                
                  try{ 
                   if(occupationMatrix[currentY][currentX-1].getPotential() == potential){ //esquerda
                     allPotentials.add(occupationMatrix[currentY][currentX-1]); 
                     //println("esquerda");
                   }
                  }
                  catch( ArrayIndexOutOfBoundsException e){
                  }
                  
                  try{
                   if(occupationMatrix[currentY + 1][currentX-1].getPotential() == potential){ //diagonal inferior esquerda
                     allPotentials.add(occupationMatrix[currentY + 1][currentX-1]);
                     //println("diagonal inferior esquerda");
                   }
                  }
                   catch( ArrayIndexOutOfBoundsException e){
                   }
                  
                  try{
                   if (occupationMatrix[currentY - 1][currentX].getPotential() == potential){ //cima
                     allPotentials.add(occupationMatrix[currentY - 1][currentX]);
                     //println("cima");
                   }
                  }
                  catch( ArrayIndexOutOfBoundsException e){
                   }
                  
                  try{
                   if(occupationMatrix[currentY + 1][currentX].getPotential() == potential){ //baixo
                     allPotentials.add(occupationMatrix[currentY + 1][currentX]);
                     //println("baixo");
                   }
                  }
                   catch( ArrayIndexOutOfBoundsException e){
                   }
                  
                  try{
                   if(occupationMatrix[currentY - 1][currentX+1].getPotential() == potential){ //diagonal superior direita
                     allPotentials.add(occupationMatrix[currentY - 1][currentX+1]);
                     //println("diagonal superior direita");
                   }
                  }
                   catch( ArrayIndexOutOfBoundsException e){
                   }
  
                   try{
                   if(occupationMatrix[currentY][currentX+1].getPotential() == potential){ //direita
                     allPotentials.add(occupationMatrix[currentY][currentX+1]);
                     //println("direita");
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
                 
                   try{
                   if(occupationMatrix[currentY + 1][currentX+1].getPotential() == potential ){ //diagonal inferior direita
                     allPotentials.add(occupationMatrix[currentY + 1][currentX+1]);
                    // println("diagonal inferior direita");
                   }
                   }
                   catch( ArrayIndexOutOfBoundsException e){
                    }
                   
                   
                   Iterator it = allPotentials.iterator();//todas as celulas que contem o potencial desejado
                   distAux =0;
                   distance = 0;
                   int cont=0,xMax = 0,yMax = 0,xDistAux = 0, yDistAux = 0, xDistance=0, yDistance=0 ;
                 //  float maxDistance = 0 ;
                   
                   
                   while(it.hasNext()){
                     Cell c = (Cell)it.next();
                     if(cont == 0){
                       distance = calculateDistances( c.getCoordinateX(), c.getCoordinateY());//retorna distancia media dessa celula com os obstaculos
                       distAux = distance;
                       xDistAux = c.getCoordinateX();
                       yDistAux = c.getCoordinateY();
                       xDistance =  c.getCoordinateX();
                       yDistance = c.getCoordinateY();
                      // println("xDistAux 1: " + xDistAux + "YDistAux : " + yDistAux );
                     
                     }
                     else{
                       distAux=distance;
                       xDistAux = xDistance;
                       yDistAux = yDistance;
                       
                       distance = calculateDistances( c.getCoordinateX(), c.getCoordinateY());
                       xDistance =  c.getCoordinateX();
                       yDistance = c.getCoordinateY();
                       
                      
                     }
                     
                      if(distAux < distance){
                         //maxDistance = distance;
                         xMax = xDistance;
                         yMax = yDistance;
                         //println(" 2 - Distancia anterior:" + distAux + " Distancia atual: " + distance  );
                         //println("xDistAux 2 : " + xDistAux + "YDistAux : " + yDistAux );
                       }
                       else{
                         //maxDistance = distAux;
                         xMax = xDistAux;
                         yMax = yDistAux ;
                         //println(" 3 - Distancia anterior:" + distAux + " Distancia atual: " + distance  );
                         //println("xDistAux 3: " + xDistAux + "YDistAux : " + yDistAux );
                       }
                     
                     cont++;
                   }
                   
                   
                   try{
                   if(occupationMatrix[currentY - 1][currentX-1].getCoordinateX() == xMax && occupationMatrix[currentY - 1][currentX-1].getCoordinateY() == yMax){ //diagonal superior esquerda
                    return occupationMatrix[currentY - 1][currentX-1]; 
                   }
                   }
                   catch( ArrayIndexOutOfBoundsException e){
                    }
                   try{
                   if(occupationMatrix[currentY][currentX-1].getCoordinateX() == xMax && occupationMatrix[currentY][currentX-1].getCoordinateY() == yMax){ //esquerda
                     return occupationMatrix[currentY][currentX-1];
                   }
                   }
                   catch( ArrayIndexOutOfBoundsException e){
                    }
                  
                   try{
                   if(occupationMatrix[currentY + 1][currentX-1].getCoordinateX() == xMax && occupationMatrix[currentY + 1][currentX-1].getCoordinateY() == yMax){ //diagonal inferior esquerda
                     return occupationMatrix[currentY + 1][currentX-1];
                   }
                   }
                   catch( ArrayIndexOutOfBoundsException e){
                    }
                  
                   try{
                   if (occupationMatrix[currentY - 1][currentX].getCoordinateX() == xMax && occupationMatrix[currentY - 1][currentX].getCoordinateY() == yMax){ //cima
                     return occupationMatrix[currentY - 1][currentX];
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
                  
                   try{
                   if(occupationMatrix[currentY + 1][currentX].getCoordinateX() == xMax && occupationMatrix[currentY + 1][currentX].getCoordinateY() == yMax){ //baixo
                     return occupationMatrix[currentY + 1][currentX];
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
                  
                   try{
                   if(occupationMatrix[currentY - 1][currentX+1].getCoordinateX() == xMax && occupationMatrix[currentY - 1][currentX+1].getCoordinateY() == yMax){ //diagonal superior direita
                     return occupationMatrix[currentY - 1][currentX+1];
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
  
                   try{
                   if(occupationMatrix[currentY][currentX+1].getCoordinateX() == xMax && occupationMatrix[currentY][currentX+1].getCoordinateY() == yMax){ //direita
                    return occupationMatrix[currentY][currentX+1];
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
                 
                   try{
                   if(occupationMatrix[currentY + 1][currentX+1].getCoordinateX() == xMax && occupationMatrix[currentY + 1][currentX+1].getCoordinateY() == yMax){ //diagonal inferior direita
                    return occupationMatrix[currentY + 1][currentX+1];
                   }
                   }
                    catch( ArrayIndexOutOfBoundsException e){
                    }
                   
                   
                }
    }
   
                  
   return null;
 }

//retorna media de distancias do ponto aos obstaculos 
 double calculateDistances(int x, int y){
   double[] obstaclesDistances = new double[obstacles.size()]; //tem as distancias do ponto passado para todos os obstaculos
   double finalDistance, distances=0;
   Iterator it = obstacles.iterator();
   int i=0;
   while(it.hasNext()){
     Objectt o = (Objectt) it.next();
     obstaclesDistances[i] = Math.sqrt(abs((o.getX()-x)^2+(o.getY()-y)^2)); 
     i++;
   }
   
   
   for(int j =0 ;j< obstaclesDistances.length;j++){
     distances += obstaclesDistances[j];
   }
   
   finalDistance = distances / obstaclesDistances.length;
   
   
   return finalDistance;
 }
 
}