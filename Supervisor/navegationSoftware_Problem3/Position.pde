

 class Position {
  
  
     private int x;
     private int y;
     private int _width;
     private int _height;
     private int[] colorFill;
   
     public Position(int x, int y, int _width, int _height, int[] colorFill){
        
        this.x = x;
        this.y =y;
        this._width = _width;
        this._height = _height;
        this.colorFill = colorFill;
      
      }
  
  
  
    public int getX(){
     return this.x; 
    }
    
    public int getY(){
     return this.y; 
    }
    
    public void setX(int x){
      this.x = x;
    }
    
     public void setY(int y){
      this.y = y;
    }
    
    public int getWidth(){
     return this._width; 
    }
    
    public int getHeight(){
     return this._height; 
    }
    
    public int[] getColor(){
     return this.colorFill; 
    }
    
     public void setColor(int[] colors){
    this.colorFill = colors;
    }
  
  
  
}