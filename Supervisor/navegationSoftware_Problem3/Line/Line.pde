class Line{
 
  float xOrigin;
  float yOrigin;
  float xFinal;
  float yFinal;
  
  public Line(float xOrigin, float yOrigin, float xFinal, float yFinal){
    
    this.xOrigin = xOrigin;
    this.yOrigin = yOrigin;
    this.xFinal = xFinal;
    this.yFinal = yFinal;
    
    
  }
  
  public float getXOrigin(){
   return this.xOrigin; 
  }
  
  public float getYOrigin(){
   return this.yOrigin; 
  }
  
  public float getXFinal(){
   return this.xFinal; 
  }
  
  public float getYFinal(){
   return this.yFinal; 
  }
  
  
  
}