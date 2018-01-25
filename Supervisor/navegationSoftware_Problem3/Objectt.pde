public class Objectt{
 
   private int x;
   private int y;
   private int _height;
   private int _width;
   
   public Objectt(int x, int y, int _height, int _width){
    
     this.x = x;
     this.y = y;
     this._height = _height;
     this._width = _width;
     
   }
   
   public void setX(int x){
      this.x = x;
   
   }
   
   public void setY(int y){
      this.y = y;
   
   }
   
   public void setHeight(int _height){
      this._height = _height;
   
   }
   
   public void setWidth(int _width){
      this._width = _width;
   
   }
   
   public int getX(){
    return this.x;
     
   }
   
   public int getY(){
    return this.y;
     
   }
   
   public int getHeight(){
    return this._height;
     
   }
   
   public int getWidth(){
    return this._width;
     
   }
   
   
   
   
 }