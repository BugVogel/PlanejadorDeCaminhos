 
 
 public class Objectt{
 
   private float x;
   private float y;
   private float _height;
   private float _width;
   
   public Objectt(float x, float y, float _height, float _width){
    
     this.x = x;
     this.y = y;
     this._height = _height;
     this._width = _width;
     
   }
   
   public void setX(float x){
      this.x = x;
   
   }
   
   public void setY(float y){
      this.y = y;
   
   }
   
   public void setHeight(float _height){
      this._height = _height;
   
   }
   
   public void setWidth(float _width){
      this._width = _width;
   
   }
   
   public float getX(){
    return this.x;
     
   }
   
   public float getY(){
    return this.y;
     
   }
   
   public float getHeight(){
    return this._height;
     
   }
   
   public float getWidth(){
    return this._width;
     
   }
   
   
   
   
 }