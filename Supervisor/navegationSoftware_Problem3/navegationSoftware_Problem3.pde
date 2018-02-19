

/*
Conventions:

2px = 1cm

1 cell = 40x40 px

534 x 436



Erro de diferença superior: 18cm
Erro de diferença lateral: 7cm

*/

import java.util.LinkedList;
import java.util.Iterator;
import javax.swing.JOptionPane; 
import java.util.Arrays;
import processing.serial.*;



Serial myPort;
int state = 0; 
int numClick = 0;
String input1="";
String input2="";
boolean buildObject = false;
boolean putPositions=false;
boolean isWalking = false;
LinkedList objects;
LinkedList positions; //Begin and End
boolean getObject= false;
int[] xVector, yVector;
final float robotExpansion = 0; //proportional
final float adjust = robotExpansion/2;
final int realMapWidth = 520;
final int realMapHeight = 400;
final int realMapX = 300;
final int realMapY = 40; 
final int mapWidth =  realMapWidth - (int)robotExpansion;
final int mapHeight =  realMapHeight- (int)robotExpansion;
final int mapPositionX = realMapX +(int)adjust;
final int mapPositionY = realMapY + (int)adjust;

void setup(){
  
  
  size(1200,600); //proportional
  objects = new LinkedList();
  positions = new LinkedList();
  drawFrame();
  String portName = Serial.list()[0]; 
  myPort = new Serial(this,portName,9600); //conectado
  
  
  

}

void draw(){
  
        stroke(0);
        update(mouseX, mouseY);
       
        
        if(getObject){
           stroke(0);
           moveObject();
        }
        
        if(putPositions){
           stroke(0);
           movePositions(); 
        }
    
   
       if(isWalking){
         
              while(myPort.available()>0){ //lê o quadrado da matriz que o robô está
                
                
                byte[] input = new byte[1];
                input = myPort.readBytes();
                
                println(input);
                
                break;
              }
         
         
         
       }

 
    
}


void keyPressed() {
 
  if(buildObject){
      if (key==ENTER||key==RETURN) {
     
        if(state == 1){
          
           if(input1 == "" || input2 == ""){ //can't draw the object
            JOptionPane.showMessageDialog(null, "Você deve preencher as informações necessárias");
            state=0;
            input1="";
            input2="";
            return;
         }
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
    
       for(int i = mouseX-realMapX;i%40 !=0; mouseX++,i=mouseX-realMapX);
       for(int i =mouseY-realMapY;i%40 != 0; mouseY++,i = mouseY-realMapY);
      
     
       Iterator i  = objects.iterator();  //verify intesection 
       boolean canAdd = true;
       
       LinkedList linesForAdd = new LinkedList(); //4 lines about the rect choose
       linesForAdd.add( new Line((float)mouseX-adjust,(float)mouseY-adjust,(float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion,(float)mouseY-adjust));
       linesForAdd.add(new Line((float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion,(float)mouseY-adjust, (float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion, (float)mouseY+Float.parseFloat(input2)+robotExpansion ));
       linesForAdd.add(new Line( (float)mouseX-adjust+Float.parseFloat(input1)+robotExpansion, (float)mouseY-adjust+Float.parseFloat(input2)+robotExpansion, (float)mouseX-adjust,  (float)mouseY+Float.parseFloat(input2)+robotExpansion  ));
       linesForAdd.add(new Line(  (float)mouseX-adjust,  (float)mouseY-adjust+Float.parseFloat(input2)+robotExpansion, (float)mouseX-adjust, (float)mouseY-adjust  ));
       
              for(int b =1; b <=linesForAdd.size(); b++){ //Verify if the object is out of map
             
                   Line lWish = (Line)linesForAdd.get(b-1);
                   if(  !(lWish.getXOrigin() >= mapPositionX && lWish.getXOrigin() <= mapPositionX+mapWidth)  || !(lWish.getYOrigin() >= mapPositionY && lWish.getYOrigin() <= mapPositionY+mapHeight) || !(lWish.getXFinal() >= mapPositionX && lWish.getXFinal() <= mapPositionX+mapWidth) ||  !(lWish.getYFinal() >= mapPositionY && lWish.getYFinal() <= mapPositionY+mapHeight) ){
                            
                           canAdd = false;
                           b=5;
                           break;
                           
                          }
                   
              }
       
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
           Objectt obj = new Objectt((int)(mouseX-adjust),(int)(mouseY-adjust),(int)(Integer.parseInt(input2)+robotExpansion), (int)(Integer.parseInt(input1)+robotExpansion));
           objects.add(obj);
           getObject=false;  
           input1="";
           input2="";
           

       }
       else{
           JOptionPane.showMessageDialog(null, "Você não pode sobrepor objetos ou coloca-los fora do mapa");
           getObject=false;
           input1="";
           input2="";
           state=0;
       }
    }
    
    
    
    if(putPositions){
      
      for(int i = mouseX-realMapX;i%40 !=0; mouseX++,i=mouseX-realMapX);
      for(int i =mouseY-realMapY;i%40 != 0; mouseY++,i = mouseY-realMapY);
      
      if(numClick == 1){
        
       int[] colors = new int[3]; colors[0] = 0; colors[1] = 0; colors[2] = 255;
       positions.add(new Position(mouseX,mouseY,40,40,colors)); 
       numClick =0;
       putPositions=false;
       planPath();
       return;
      }
      
      int[] colors = new int[3]; colors[0] = 25; colors[1] = 255; colors[2] = 0;
      positions.add(new Position(mouseX,mouseY,40,40,colors));
      numClick++;
    }
  
    switch(isOver(mouseX,mouseY)){
      
       case "novoObjeto":
       
         buildObject = true; 
         drawSideBar();
         break;
     
       case "enviar":
       
         sendPath();
         break;
     
       case "fObjeto":
           
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
           
       case "restaurarButton":
       xVector =null;
       yVector = null;
       objects.clear();
       positions.clear();
       
       
       break;
       
       case "construirObjeto":
       
        if(input1 == "" || input2 == ""){ //can't draw the object
            JOptionPane.showMessageDialog(null, "Você deve preencher as informações necessárias");
            state=0;
            input1="";
            input2="";
            return;
         }
         state =0;
         buildObject = false;
         drawFrame();
         getObject=true;
         
       
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
       
     case "restaurarButton":
     
       fill(240);
       rect(300,550,90,20,6,6,6,6);
       fill(0);
       text("Restaurar", 320,565);
     
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
          else if(  (x <= 390 && x >= 300 ) && (y <= 570 && y >= 550) ){
            return  "restaurarButton";
          }
          
          return "noOne";
}


void drawSideBar(){
  
          stroke(0);
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
          fill(158); //Expansão do mapa
          rect(realMapX,realMapY,realMapWidth,realMapHeight);
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
          fill(250);
          rect(300,550,90,20,6,6,6,6); //Restaurar Button
          fill(0);
          text("Restaurar", 320,565);
    
          //Draw Objects
          Iterator i = objects.iterator();
          while(i.hasNext()){
            
            Objectt obj = (Objectt) i.next();
            fill(158);
            rect(obj.getX(),obj.getY(),obj.getWidth(),obj.getHeight()); //Expanção do objeto
            fill(0);
            rect(obj.getX()+adjust,obj.getY()+adjust,obj.getWidth()-robotExpansion,obj.getHeight()-robotExpansion);
            
            
          }
          
          //DrawPositions
          Iterator i2 = positions.iterator();
          while(i2.hasNext()){
            
            Position p = (Position)i2.next();
            int[] colorFill = p.getColor();
            fill(colorFill[0],colorFill[1],colorFill[2]);
            rect(p.getX(),p.getY(),p.getWidth(),p.getHeight());
            
          }
          
           //DrawPath
          if(xVector != null && yVector !=null){
            for(int a = 0 ; a<xVector.length; a++){
             if(a+1 == xVector.length){
               break;
             }
             else{
               //println("Xi:" + xVector[a] + "Yi:" + yVector[a] +"Xf:" + xVector[a+1]+"Yf:" + yVector[a+1]); 
               stroke(255,7,7);
               strokeWeight(40);
               line(xVector[a],yVector[a],xVector[a+1],yVector[a+1]);
               
             }
            }
            strokeWeight(1);
          }
          
          //obj conventions
          
          if(objects.size() > 0){
              
            int distance= realMapY;
            int space = 15;
            int obj =0;
            Iterator iterator = objects.iterator();
            fill(0);
            text("Medidas dos objetos", realMapX-250, distance);
            distance += space;
           
            
            while(iterator.hasNext()){
               text("----------------------Obj:"+obj, realMapX-250, distance);
               distance += space;
              
                Objectt o = (Objectt) iterator.next();
                
                 text("Altura em cm: "+ o.getHeight()/2, realMapX-250, distance);
                 distance += space;
                 text("Largura em cm: "+ o.getWidth()/2, realMapX-250, distance);
                 distance += space;
                 text("Distancia superior cm: "+ (o.getY()-realMapY)/2, realMapX-250, distance);
                 distance += space;
                 text("Distancia lateral cm: "+ (o.getX()-realMapX)/2, realMapX-250, distance);
                 distance += space;
                
                obj++;
              
              
            }
            
            
          }
          
          
          //drawPositionsInfo
          if(positions.size() >0){
            
            
            int distance= realMapY;
            int space = 15;
            int position =0;
            Iterator iterator = positions.iterator();
            fill(0);
            text("Medidas das posições", realMapX+560, distance);
            distance += space;
    
            
            while(iterator.hasNext()){
              
             
               text("----------------------Obj:"+position, realMapX+560, distance);
               distance += space;
              
                Position p = (Position) iterator.next();
                
                 text("Distancia superior cm: "+ (p.getY()-realMapY)/2, realMapX+560, distance);
                 distance += space;
                 text("Distancia lateral cm: "+ (p.getX()-realMapX)/2, realMapX+560, distance);
                 distance += space;
                
                position++;
              
              
              
              
              
              
            }
            
            
          }
          
          
          
  
}


 void moveObject(){
   
   rect((float)mouseX,(float)mouseY, Float.parseFloat(input1),Float.parseFloat(input2));
   

 }
 
void movePositions(){
 
  fill(130);
  rect((float)mouseX, (float)mouseY, 40,40);
  
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
     // println("planPath x:" + xOrigin + "y:" + yOrigin);
      i++;
    }
    else if(i == 1){
      xFinal = p.getX();
      yFinal = p.getY();
     // println("planPath xfinal:" + xFinal + "yfinal:" + yFinal);
    }
  }
  
  
  PotentialFields planning = new PotentialFields( mapPositionX, mapPositionY, mapWidth, mapHeight);

 /* Iterator it2 = objects.iterator();
  int cont1 =0;
  while(it2.hasNext()){
    Objectt o = (Objectt)it.next();    //Quando executa da NoSuchElementException  
    println(" X object :" + o.getX() + "Y :" + o.getY() + "height :" + o.getHeight() + "width :" + o.getWidth() );
    cont1++;
  }
  */
  
 
  
  planning.fillObstacles2(objects);
  planning.fillFreeCells2();
  
  int maxValue =  planning.fillsPotential2(xOrigin,yOrigin,xFinal,yFinal);
  //println("Valor maximo retornado :" + maxValue);


if(maxValue != Integer.MAX_VALUE){
  
   if(maxValue != 0){
    String[] path1 = planning.returnPath3(xOrigin,yOrigin,xFinal,yFinal,maxValue);
    if(path1 != null){
      String[] path = new String[path1.length];
      path = path1;
 
     xVector = new int[path.length];
     yVector = new int[path.length];
     for(int cont=0;cont<path.length;cont++){
       String s = path[cont];
       String[] c = s.split("#");
       
       xVector[cont]= Integer.parseInt(c[0]);
       yVector[cont]= Integer.parseInt(c[1]);

       //println("xVector:" + xVector[cont] + "yVector:" + yVector[cont]);
     }
     for(int a = 0 ; a<path.length; a++){
       if(a+1 == path.length){
         break;
       }
       else{
         //println("Xi:" + xVector[a] + "Yi:" + yVector[a] +"Xf:" + xVector[a+1]+"Yf:" + yVector[a+1]); 
         line(xVector[a],yVector[a],xVector[a+1],yVector[a+1]);
       }
    }
    
  }
  else{
     JOptionPane.showMessageDialog(null,"Este caminho não existe");
     xVector =null;
     yVector = null;
     objects.clear();
     positions.clear();
  }
  

  //println("X origin : "+xOrigin + "Y Origin : " + yOrigin);
  //println("X final : "+xFinal + "Y final : " + yFinal);

  
    }

  
  }
  else{
     JOptionPane.showMessageDialog(null,"Este caminho não existe");
     xVector =null;
     yVector = null;
     objects.clear();
     positions.clear();
  }

}




void sendPath(){
  
     if(xVector != null && yVector != null){
        isWalking = true;
       
        

        
        
        int x = xVector[1] - xVector[0];
        int y = yVector[1] - yVector[0];
        
        int direction = getDirection(x,y);
        int quant =1;
        
        
        myPort.write("x");
        myPort.write("Y");

        
        
        
        for(int i =1; i<xVector.length; i++){
          
          
               x = xVector[i] - xVector[i-1];
               y = yVector[i] - yVector[i-1];
               
               int newDirection = getDirection(x,y);
               
               if(newDirection == direction){
                 quant++;  
               }
               else{
                myPort.write(quant);
                myPort.write("w");
                myPort.write(direction);
                myPort.write("y");
                direction = newDirection;
                quant = 1; 
               }
  
        }
        
        myPort.write("z");
        isWalking=false;
        
    
     }
     else{
      JOptionPane.showMessageDialog(null,"Você deve montar o caminho primeiro"); 
     }
    
 
}




int getDirection(int x,int y){
  
  
  
  if(x<0 && y<0){
   return 1; 
  }
  else if(x==0 && y<0){
   return 2; 
  }
  else if(x>0 && y<0){
   return 3;
  }
  else if(x>0 && y ==0){
   return 4; 
  }
  else if(x>0 && y>0){
    return 5;
  }
  else if(x==0 && y>0){
  return 6;
  }
  else if(x<0 && y>0){
    return 7;
  }
  else if(x<0 && y==0){
   return 8; 
  }
  
  
  
  
  
  
  
 
  return 0;
}