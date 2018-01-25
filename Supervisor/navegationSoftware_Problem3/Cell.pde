public class Cell{
  int coordinateX, coordinateY, potential;
  boolean status, //indica que a célula foi preenchida com o potencial ou com obstaculo
  initialState, //indica que a célula está livre e foi preenchida com -1
  obstacle,     //indica que a célula é um obstaculo
  filledPotential; //indica que a célula foi preenchida com o potencial
  
  public void setCoordinateX(int coordinateX){
    this.coordinateX = coordinateX; 
  }
  
  public void setCoordinateY(int coordinateY){
    this.coordinateY = coordinateY;
  }
  
  public void setPotential(int potential){
    this.potential = potential;
  }
  
  public void setStatus(boolean status){
    this.status = status; 
  }
  
  public void setInitialState(boolean initialState){
    this.initialState = initialState; 
  }
  
  public void setObstacle(boolean obstacle){
    this.obstacle = obstacle; 
  }
  
   public void setFilledPotential(boolean filledPotential){
    this.filledPotential = filledPotential; 
  }
  
  public int getCoordinateX(){
    return this.coordinateX; 
  }
  
  public int getCoordinateY(){
   return this.coordinateY; 
  }
  
  public int getPotential(){
   return this.potential; 
  }
  
  public boolean getStatus(){
   return this.status; 
  }
  
  public boolean getInitialState(){
   return this.initialState; 
  }
  
  public boolean getObstacle(){
   return this.obstacle; 
  }
  
  public boolean getFilledPotential(){
    return this.filledPotential;
  }
  
  
}