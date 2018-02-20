#pragma config(Sensor, S1, sesorLuz, sensorLightActive)
#pragma config(Sensor, S4, sensorToque, sensorTouch)


int valTime100=0;
int valTime1=0;
int angulacao = 0; //ajuda quando o passo no esta bem definido
int linha;
int curvas =0;
int direct = 0;
int states = 0;
int toqueSensor = 0;
int position[2] = {100,10};
int branco = 74;
char ligar = 'n';
bool iniciar = false;

bool fezPasso12=false;


int motoa = 30;
int motob = 5;

//----------------Tasks-----------------------------


task send(){

	while(true){
	  ubyte bytesEnviados[3];

	  bytesEnviados[0] = position[0];
	  bytesEnviados[1] = position[1];

		if(SensorValue(S4)){
		  bytesEnviados[2] = 1;
		}
		else{
		  bytesEnviados[2] = 0;
	  }

	  nxtWriteRawBluetooth(bytesEnviados,3);
	  wait1Msec(80);
	  }
}

task comunication(){
      setBluetoothOn();
	    setBluetoothRawDataMode();
	    while(!bBTRawMode){ //Espera entrar no modo
	          wait1Msec(50);

	    }
      while(true){
      nxtReadRawBluetooth(&ligar, 20);
          if(ligar == 'y'){
            iniciar = true;
          }
          if(ligar == 'n'){
            motor[motorA] =0;
            motor[motorB]=0;
            iniciar = false;
          }
      }EndTimeSlice();
}
//os sinais do Y sao invertidos
  //0 -y
  //1 -x
  //2 -y
  //2 +x
  //2 -x volta
  //3 -y
  //4 +x
  //5 -y
  //6 +x
  //7 +y
  //7 -x
  //7 +x volta
  //8 +y
  //9 -x
  //10 -y
  //11-x
  //12 +y

void odometriaControl(){
      switch (states) {
			   case 0:
						position[1] = position[1] + 2;
				  break;
				  case 1:
						position[0] = position[0] - 2;
					break;
					case 2:
					    switch (angulacao) {
			          case 0:
						      position[1] = position[1] + 2;
				          break;
				       case 1:
						      position[0] = position[0] + 4;
					        break;
					     case 2:
						      position[0] = position[0] - 4;
					        break;
					      default:
					        break;
					      }
					break;
					case 3:
					  angulacao = 0;
						position[1] = position[1] + 2;
					break;
					case 4:
						position[0] = position[0] + 2;
					break;
					case 5:
						position[1] = position[1] + 2;
					break;
					case 6:
						position[0] = position[0] + 2;
					break;
					case 7:
						switch (angulacao) {
			          case 0:
						      position[1] = position[1] - 2;
				          break;
				       case 1:
						      position[0] = position[0] - 4;
					        break;
					     case 2:
						      position[0] = position[0] + 4;
					        break;
					      default:
					        break;
					      }
					break;
					case 8:
					  position[1] = position[1] - 2;
					break;
					case 9:
						position[0] = position[0] - 2;
					break;
					case 10:
						position[1] = position[1] + 2;
					break;
					case 11:
					  position[0] = position[0] - 2;
					break;
					case 12:
					  position[1] = position[1] - 2;

					break;
					default:
					break;
					}
}


task odometria(){

   while(true)  // while Motor B is still running:
   {
      if(nMotorEncoder[motorB] >= 40){
          nMotorEncoder[motorB] = 0;
          odometriaControl();
          nxtDisplayCenteredTextLine(3, "X:%d Y:%d", position[0],position[1]);
      }
   }
}


//----------------functions----------------------
void resetar(){
    int temp;
    temp = motob;
    motob = motoa;
    motoa = temp;
    direct = !direct;
    ClearTimer(T1);
}


void passo1(){
    StopTask(odometria);
    motor[motorA] = -60;
    motor[motorB] =60;
    while(linha >= 45)linha = SensorValue[S1];
    resetar();
    states = 1;
    ClearTimer(T1);
    StartTask(odometria);
}

void passo2(){
    StopTask(odometria);
    motor[motorA] = 60;
    motor[motorB] = -60;
    while(linha >= 45)linha = SensorValue[S1];
    resetar();
    states=2;
    ClearTimer(T1);
    StartTask(odometria);
}


void passo3(){


  motor[motorA] = 30;
  motor[motorB] = 30;
  wait1Msec(300);
  StopTask(odometria);//-----------------------------------stop odometria
  motor[motorA] = 40;
  motor[motorB] = -40;
  while(linha <= branco){
    linha = SensorValue[S1];
    ClearTimer(T1);
    valTime100 = time100[T1];
  }
  ClearTimer(T1);
  valTime100 = time100[T1];
  angulacao = 1;
  StartTask(odometria);//|||||||||||||||||||||||||||||||||start odometria
  while(true){
        valTime100 = time100[T1];

        linha = SensorValue[S1];
        //cinza
        if(linha >= branco){
          ClearTimer(T1);
           motor[motorA] = motob;
           motor[motorB] =motoa;
           wait1Msec(250);
        }
        else if(linha<=45){ //preto

          motor[motorA] = 30;
          motor[motorB] = 30;
          wait1Msec(300);
          StopTask(odometria);//-----------------------------------stop odometria
          motor[motorA] = 60;
          motor[motorB] = -60;
          linha = SensorValue[S1];
          while(linha >= 45){
              linha = SensorValue[S1];
          }
          ClearTimer(T1);
          states = 3;
          StartTask(odometria);//|||||||||||||||||||||||||||||||||start odometria
          return;

         }

        else{//branco
           motor[motorA] = motoa;
           motor[motorB] = motob;
           if(valTime100 >= 13){


                while(true){

                   if(SensorValue[S4]){ //Descarga
                           motor[motorA] =0;
                           motor[motorB] =0;
                        while(SensorValue[S4]); //Tirar carga
                             wait1Msec(1000);
                             motor[motorA] = 50;
                             motor[motorB] =-50;
                             linha = SensorValue[S1];
                             while(linha <=  branco){
                                   linha = SensorValue[S1];

                            }
                             angulacao = 2;
                             ClearTimer(T1);
                             break;



                    }
                    else{
				                    motor[motorA] =0;
				                    motor[motorB] =0;
				                    while(!SensorValue[S4]); //Colocar carga
				                         wait1Msec(1000);

				                         motor[motorA] = 50;
				                         motor[motorB] =-50;
				                         linha = SensorValue[S1];
				                        while(linha <=  branco){
				                               linha = SensorValue[S1];


				                        }
				                        angulacao = 2;
				                        ClearTimer(T1);
				                        break;

				                  }
                }




               }
        }
        //states = 3;
        linha = SensorValue[S1];
}
}

void passo4(){ //curva para esquerda

 StopTask(odometria);
 motor[motorA] = 60;
 motor[motorB] = -60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];
   wait1Msec(5);
   ClearTimer(T1);
   valTime100 = time100[T1];

 }

ClearTimer(T1);
states =4;

StartTask(odometria);
}


void passo5(){ //curva para a direita

 StopTask(odometria);
 motor[motorA] = -20;
 motor[motorB] =  60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }

 ClearTimer(T1);
 states =5;

StartTask(odometria);
}

void passo6(){//curva para a esquerda

StopTask(odometria);
motor[motorA] =  60;
motor[motorB] = -60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }

 states =6;
 ClearTimer(T1);

StartTask(odometria);
}

void passo7(){//curva para a esquerda

StopTask(odometria);
motor[motorA] =  60;
motor[motorB] = -60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];
   wait1Msec(5);
 }

 states =7;
 ClearTimer(T1);

StartTask(odometria);
}


void passo8(){

       passo3();
       ClearTimer(T1);
       states =8;
       valTime100= time100(T1);

}








void passo9(){ //curva para a esquerda

 StopTask(odometria);
 motor[motorA] =  60;
 motor[motorB] = -60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }
 ClearTimer(T1);
 states =9;



StartTask(odometria);
}

void passo10(){ //curva para a esquerda

 StopTask(odometria);
 motor[motorA] =  60;
 motor[motorB] = -60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }

 motor[motorA] =0;
 motor[motorB] =0;
 ClearTimer(T1);
 states =10;

StartTask(odometria);
}

void passo11(){ //curva para a direita
 StopTask(odometria);
 motor[motorA] = -60;
 motor[motorB] = 60;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }

 ClearTimer(T1);
 states =11;



StartTask(odometria);
}

void passo12(){// curva para a  direita
 StopTask(odometria);
 motor[motorA] = -30;
 motor[motorB] = 30;
 while(linha <=45){

    linha = SensorValue[S1];
 }

ClearTimer(T1);
fezPasso12 = true;
states = 12;
StartTask(odometria);
}

void passo13(){ // posiciona na base

 StopTask(odometria);
 motor[motorA] =  30;
 motor[motorB] = -30;
 linha = SensorValue[S1];
 while(linha >=45){

   linha = SensorValue[S1];

 }
 ClearTimer(T1);

motor[motorA] =0;
motor[motorB]=0;

states = 0;
iniciar = false;
position[0] = 90;
position[1] = 0;
ligar = 'n';
StartTask(odometria);
}






task main(){

//------------inica as taks------------------
   StartTask(comunication); //ligou bluetooth
   StartTask(odometria);
   StartTask(send);
   nMotorEncoder[motorA] = 0;
   nMotorEncoder[motorB] = 0;



    ClearTimer(T1);
    while(true){
    if(iniciar){
     linha = SensorValue[S1];
     valTime100 = time100[T1];
     valTime1 = time1[T1];
     StartTask(odometria);
       // preto
       if(linha <= 45){

               if(states < 11){
                 ClearTimer(T1);
               motor[motorA] = motoa;
               motor[motorB] =motob;
               }
               else{ //vai para outra borda

               motor[motorA] = motob;
               motor[motorB] =motoa;

               if(valTime1 >= 350){
                 passo12();
                 ClearTimer(T1);
                 valTime1 = time1[T1];
               }



               }

       }
       else{ //branco
              if(states < 11){
               motor[motorA] = motob;
               motor[motorB] =motoa;
               wait1Msec(2);
               }
               else{ //vai para outra borda


                 if(!fezPasso12){
                  ClearTimer(T1);
                 }
                 motor[motorA] = motoa;
                 motor[motorB] =motob;
                 wait1Msec(2);
                }
               if(valTime100 >= 9){
                 switch (states) {
										case 0:
										  passo1();
										  valTime100 = time100[T1];
										  break;
										case 1:
										  passo2();
										  valTime100 = time100[T1];
										  break;
										case 2:
										   passo3();
										   valTime100 = time100[T1];
										  break;
										case 3: passo4();
										valTime100 = time100[T1];
										break;
										case 4: passo5();
										valTime100 = time100[T1];
										break;
										case 5: passo6();
										valTime100 = time100[T1];
										break;
										case 6: passo7();
										valTime100 = time100[T1];
										break;
										case 7: passo8();
										valTime100 = time100[T1];
										break;
										case 8: passo9();
										valTime100 = time100[T1];
										break;
										case 9: passo10();
										valTime100 = time100[T1];
										break;
										case 10: passo11();
										valTime100 = time100[T1];
										break;
										case 12: passo13();
										break;
										default:
										  break;
										}
                 }
           }
         }
       }
}
