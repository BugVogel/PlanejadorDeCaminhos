

/*

Conventions:

1px = 5cm


*/
import java.util.LinkedList;
import java.util.Iterator;
import javax.swing.JOptionPane; 
import java.util.Arrays;


int state = 0; 
int numClick = 0;
String input1="";
String input2="";
boolean buildObject = false;
boolean putPositions=false;
LinkedList objects;
LinkedList positions; //Begin and End
boolean getObject= false;
int[] xVector, yVector;
final float robotExpansion = 10.5*2; //proportional
final float adjust = robotExpansion/2;
final int mapWidth = 534;
final int mapHeight = 436;
final int mapPositionX = 300;
final int mapPositionY = 40;

void setup(){
  
  
  size(1200,600); //proportional
  objects = new LinkedList();
  positions = new LinkedList();
  drawFrame();
  
  

}

void draw(){
  
    update(mouseX, mouseY);
    //Redesenha o caminho
    if(xVector != null && yVector !=null){
      for(int a = 0 ; a<xVector.length; a++){
       if(a+1 == xVector.length){
         break;
       }
       else{
         //println("Xi:" + xVector[a] + "Yi:" + yVector[a] +"Xf:" + xVector[a+1]+"Yf:" + yVector[a+1]); 
         line(xVector[a],yVector[a],xVector[a+1],yVector[a+1]);
       }
      }
    }
    
    if(getObject){
      
       moveObject();
    }
    
    if(putPositions){
     
       movePositions(); 
    }
    
   

 
    
}


void keyPressed() {
 
  if(buildObject){
      if (key==ENTER||key==RETURN) {
     
        if(state == 1){
         state =0;
         buildObject = false;
         drawFrame();
         getObject=true;
         return;
        }
        state = 1;
      }
      else if(key == BACKSPACE){
        input1="";
        input2="";
        state=0;
        fill(255,255,255);
        rect(900, 0, 300, 500, 3, 6, 12, 18); //SideBar
        rect(930, 110, 250, 30, 6,6,6,6); //input1
        rect(930, 210, 250, 30, 6,6,6,6); //input2
        rect(1000, 300, 70, 40, 6,6,6,6); //botão construir
      }
      else{
        
          if(state == 1){
            input2 += key;
          }
          else{
            input1 = input1 + key;
          }
         
      
      }
  }

}

void mousePressed(){
  
    if(getObject){ //the object is on the mouse
     
       Iterator i  = objects.iterator();  //verify intesection 
       boolean canAdd = true;
       
       LinkedList linesForAdd = new LinkedList(); //4 lines about the rect choose
       linesForAdd.add( new Line((float)mouseX-adjust,(float)mouseY-adjust,(float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion,(float)mouseY-adjust));
       linesForAdd.add(new Line((float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion,(float)mouseY-adjust, (float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion, (float)mouseY+Float.parseFloat(input2)+robotExpansion ));
       linesForAdd.add(new Line( (float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion, (float)mouseY-adjust+Float.parseFloat(input2)+robotExpansion, (float)mouseX-adjust,  (float)mouseY+Float.parseFloat(input2)+robotExpansion  ));
       linesForAdd.add(new Line(  (float)mouseX-adjust,  (float)mouseY-adjust+Float.parseFloat(input2)+robotExpansion, (float)mouseX-adjust, (float)mouseY-adjust  ));
       
       while(i.hasNext()){
         
         Objectt obj = (Objectt)i.next();
         
         LinkedList linesAdded = new LinkedList();
         linesAdded.add(new Line(obj.getX(), obj.getY(), obj.getX()+obj.getWidth(), obj.getY()));
         linesAdded.add(new Line( obj.getX()+obj.getWidth(), obj.getY(), obj.getX()+obj.getWidth(),obj.getY()+obj.getHeight()));
         linesAdded.add(new Line(obj.getX()+obj.getWidth(),obj.getY()+obj.getHeight(), obj.getX(), obj.getY()+obj.getHeight()));
         linesAdded.add(new Line(obj.getX(), obj.getY()+obj.getHeight(),obj.getX(),obj.getY()));
         
         for(int a =1; a <=linesAdded.size(); a++){
            Line lStill = (Line) linesAdded.get(a-1);
           for(int b =1; b <=linesForAdd.size(); b++){
           
             Line lWish = (Line)linesForAdd.get(b-1);
             
            //float det = (lWish.getXFinal() - lWish.getXOrigin()) * (lStill.getYFinal() - lStill.getYOrigin())  -   (lWish.getYFinal() - lWish.getYOrigin()) * (lStill.getXFinal() - lStill.getXFinal());
          
          
          
              if( a%2 !=0 && b%2 == 0 ){  // top/bottom and side
              
                  if( (  lWish.getXOrigin() >= lStill.getXOrigin() && lWish.getXOrigin() <=lStill.getXFinal() ) && ( (lStill.getYOrigin() >= lWish.getYOrigin()  && lStill.getYOrigin()<=lWish.getYFinal()) ||  (lStill.getYOrigin() >= lWish.getYFinal()  && lStill.getYOrigin()<=lWish.getYOrigin())  ) ){
                  //There's a intersection
                  
                    canAdd=false;
                    a=5;
                    break;
                  }
              
              }
              else if(a%2 == 0 && b%2 !=0){  //side and top/bottom
               
                   if( ( lStill.getXOrigin()>= lWish.getXOrigin() && lStill.getXOrigin()<= lWish.getXFinal() ) && ( ( lWish.getYOrigin() >= lStill.getYOrigin() && lWish.getYOrigin() <= lStill.getYFinal()) || (lWish.getYOrigin() >= lStill.getYFinal() && lWish.getYOrigin() <= lStill.getYOrigin() )    ) ){
                     //There's a intersection
                      canAdd=false;
                      a=5;
                      break;
                   }

              }
            

             
             
           
           }
         }
         
           
           
           
           
           
         

         //<>//
         
         }
      
       if(canAdd){ //mudei aqui
           Objectt obj = new Objectt((int)(mouseX-adjust),(int)(mouseY-adjust),(int)(Integer.parseInt(input1)+robotExpansion),(int)(Integer.parseInt(input2)+robotExpansion));
           objects.add(obj);
           getObject=false;  
           input1="";
           input2="";
       }
       else{
           JOptionPane.showMessageDialog(null, "Você não pode sobrepor objetos");
           getObject=false;
           input1="";
           input2="";
           state=0;
       }
    }
    
    
    
    if(putPositions){
      
      
      if(numClick == 1){
        
       int[] colors = new int[3]; colors[0] = 255; colors[1] = 0; colors[2] = 10;
       positions.add(new Position(mouseX,mouseY,5,5,colors)); 
       numClick =0;
       putPositions=false;
       planPath();
       return;
      }
      
      int[] colors = new int[3]; colors[0] = 25; colors[1] = 255; colors[2] = 0;
      positions.add(new Position(mouseX,mouseY,5,5,colors));
      numClick++;
    }
  
    switch(isOver(mouseX,mouseY)){
      
       case "novoObjeto":
         buildObject = true; 
         drawSideBar();
         break;
     
       case "enviar":

         break;
     
       case "construirObjeto":
         
           buildObject=false;
           drawFrame();
           getObject=true;

         break;
     
       case "planejar":

         putPositions = true;
         break;
        
        
       case "voltarSideBar":
       
           buildObject=false;
           drawFrame(); 
           break; 
         
         
       default:
       buildObject =false;
      
    }
 
  
  
  
  
  
}


void update(int x, int y){
  
  
   switch(isOver(x,y)){
     
     case "novoObjeto":
         fill(240);
         rect(1100, 10, 75,40,6,6,6,6); //Botão novo objeto
         fill(0);
         text("Novo Objeto", 1105, 30);
         break;
     
     case "enviar":
         fill(240);
         rect(180,550,90,20,6,6,6,6); //Enviar Button
         fill(0);
         text("Enviar", 210, 565);
         break;
     
     case "construirObjeto":
         fill(240);
         rect(1000, 300, 70, 40, 6,6,6,6); //botão construir
         fill(0);
         text("Construir",1010, 325);
         break;
     
     case "planejar":
        fill(240);
        rect(40,550,120,20,6,6,6,6); //Planejar Percurso button
        fill(0);
        text("Planejar Percurso", 55, 565); 
        break;
     
     case "voltarSideBar":
       fill(240);
       rect(1100, 300, 70,40,6,6,6,6);
       fill(0);
       text("Voltar",1120, 325);
      
       break;
     
     default:
     
       drawFrame();
      
      if(buildObject){
        drawSideBar();
      }
   
   }
   
  
  
}


String isOver(int x, int y){
          
          if( (x <= 1175 && x >= 1100 ) && (y <= 50 && y >= 10) && !buildObject){ 
            return "novoObjeto";
          }
          else if((x <= 270 && x >= 180 ) && (y <= 570 && y >= 550)){
            return "enviar";
          }
          else if( (x <= 160 && x >= 40 ) && (y <= 570 && y >= 550) ){
            return "planejar";
          }
          else if( (x <= 1070 && x >= 1000 ) && (y <= 340 && y >= 300) && buildObject){
            return "construirObjeto";
          }
          else if( (x <= 1170 && x >= 1100 ) && (y <= 340 && y >= 300) && buildObject ){
            
            return "voltarSideBar"; 
          }
          
          return "noOne";
}


void drawSideBar(){
          fill(250);
          rect(900, 0, 300, 500, 3, 6, 12, 18); //SideBar
          rect(930, 110, 250, 30, 6,6,6,6); //input1
          rect(930, 210, 250, 30, 6,6,6,6); //input2
          rect(1000, 300, 70, 40, 6,6,6,6); //botão construir
          rect(1100, 300, 70,40,6,6,6,6); //voltar Button
          fill(0); 
          text("Criação de Objeto", 1000, 50);
          text ("Digite a largara do objeto\n\n"+input1, 930, 100); 
          text("Digite o tamanho do objeto\n\n"+input2,930, 200);
          text("Construir",1010, 325);
          text("Voltar",1120, 325);
  
}

void drawFrame(){
  
          background(251,247,247);
          fill(250);
          rect(1100, 10, 75,40,6,6,6,6); //Botão novo objeto
          fill(0);
          text("Novo Objeto", 1105, 30);
          fill(250);
          rect(mapPositionX,mapPositionY,mapWidth,mapHeight ); //Quadrado do mapa
          fill(0);
          text("Planejador de percurso",500,20);
          fill(250);
          rect(40,550,120,20,6,6,6,6); //Planejar Percurso button
          fill(0);
          text("Planejar Percurso", 55, 565); 
          fill(250);
          rect(180,550,90,20,6,6,6,6); //Enviar Button
          fill(0);
          text("Enviar", 210, 565); 
    
          //Draw Objects
          Iterator i = objects.iterator();
          while(i.hasNext()){
            
            Objectt obj = (Objectt) i.next();
            fill(158);
            rect(obj.getX(),obj.getY(),obj.getHeight(),obj.getWidth()); //Expanção do objeto
            fill(0);
            rect(obj.getX()+adjust,obj.getY()+adjust,obj.getHeight()-robotExpansion,obj.getWidth()-robotExpansion);
            
            
          }
          
          //DrawPositions
          Iterator i2 = positions.iterator();
          while(i2.hasNext()){
            
            Position p = (Position)i2.next();
            int[] colorFill = p.getColor();
            fill(colorFill[0],colorFill[1],colorFill[2]);
            ellipse(p.getX(),p.getY(),p.getWidth(),p.getHeight());
            
          }
          
  
}


 void moveObject(){
   
   rect((float)mouseX,(float)mouseY, Float.parseFloat(input1),Float.parseFloat(input2));
   

 }
 
void movePositions(){
 
  fill(0);
  ellipse((float)mouseX, (float)mouseY, 1,1);
  
}


void planPath(){
  Iterator it = positions.iterator();
  int xOrigin =0, yOrigin=0,xFinal=0, yFinal=0;
  int i=0;
  while(it.hasNext()){
    Position p = (Position) it.next();
    if(i==0){
      xOrigin = p.getX();
      yOrigin = p.getY();
      println("planPath x:" + xOrigin + "y:" + yOrigin);
      i++;
    }
    else if(i == 1){
      xFinal = p.getX();
      yFinal = p.getY();
      println("planPath xfinal:" + xFinal + "yfinal:" + yFinal);
    }
  }
  PotentialFields planning = new PotentialFields( mapPositionX, mapPositionY, mapWidth, mapHeight);

 /* Iterator it2 = objects.iterator();
  int cont =0;
  while(it2.hasNext()){
    Objectt o = (Objectt)it.next();
    println(" X object :" + o.getX() + "Y :" + o.getY() + "height :" + o.getHeight() + "width :" + o.getWidth() );
    cont++;
  }*/
  
  planning.fillObstacles2(objects);
  planning.fillFreeCells2();
  
  int maxValue =  planning.fillsPotential2(xOrigin,yOrigin,xFinal,yFinal);
  println("Valor maximo retornado :" + maxValue);
  
   if(maxValue != 0){
    String[] path1 = planning.returnPath3(xOrigin,yOrigin,xFinal,yFinal,maxValue);// ta dando erro null pointer
    if(path1 != null){
      String[] path = new String[path1.length]; //ta dando erro
      path = path1;
 
     xVector = new int[path.length];
     yVector = new int[path.length];
     for(int cont=0;cont<path.length;cont++){
       String s = path[cont];
       String[] c = s.split("#");
       xVector[cont]= Integer.parseInt(c[0]);
       yVector[cont]= Integer.parseInt(c[1]);
       println("xVector:" + xVector[cont] + "yVector:" + yVector[cont]);
     }
     for(int a = 0 ; a<path.length; a++){
       if(a+1 == path.length){
         break;
       }
       else{
         println("Xi:" + xVector[a] + "Yi:" + yVector[a] +"Xf:" + xVector[a+1]+"Yf:" + yVector[a+1]); 
         line(xVector[a],yVector[a],xVector[a+1],yVector[a+1]);
       }
    }
    
  }
  else{
      println("Não existe o caminho");
  }
  println("X origin : "+xOrigin + "Y Origin : " + yOrigin);
  println("X final : "+xFinal + "Y final : " + yFinal);
  
 }

  
  
}