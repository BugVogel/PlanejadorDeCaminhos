char ligar = 'n';
bool iniciar = false;
string s1 = "Theory";
int s2;
ubyte bytesEnviados;

int x = 8; // 162
int w = 12; //12,4 ---- 250
int oldturn = 0;
int turn = 4;
int quant = 0;

//Valores da Comunicao

int length = 100; // 40 48  64
int IntArray[100] = {9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
  9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
  9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9};



//funoes de movimentao
void turn_minus_45(){//realiza um giro de +45 graus

  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  nMotorEncoderTarget[motorB] = 268/2;
  //nMotorEncoderTarget[motorC] = 259*4;// set the  target for Motor Encoder of Motor B to 360
  motor[motorB] = 20;
  motor[motorC] = -19;

  while(nMotorRunState[motorB] != runStateIdle){}
  motor[motorB] = 0;
  motor[motorC] = 0;
}

void turn_plus_45(){//realiza um giro de -45 graus
  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  //nMotorEncoderTarget[motorB] = 268/2;
  nMotorEncoderTarget[motorC] = 268/2;
  motor[motorB] = -19;
  motor[motorC] =  20;

  while(nMotorRunState[motorC] != runStateIdle){}
  motor[motorB] = 0;
  // motor B is stopped at a power level of 0
  motor[motorC] = 0;
}

void fowardX(int x){

  bytesEnviados = 'w';
  int t = 1;

  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  nMotorEncoderTarget[motorB] = 422*x;
  motor[motorB] = 20;
  motor[motorC] = 20;

  while(nMotorRunState[motorB] != runStateIdle){

    if(nMotorEncoder[motorB] >=
      420*t){
        nxtWriteRawBluetooth(bytesEnviados,1);
        t++;
    }

  }
  motor[motorB] = 0;                       // motor B is stopped at a power level of 0
  motor[motorC] = 0;
}

void fowardW(int x){

  bytesEnviados = 'w';
  int t = 1;

  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  nMotorEncoderTarget[motorB] = 590*x;
  motor[motorB] = 20;
  motor[motorC] = 20;

  while(nMotorRunState[motorB] != runStateIdle){

    if(nMotorEncoder[motorB] >= 580*t){
      nxtWriteRawBluetooth(bytesEnviados,1);
      t++;
    }

  }
  motor[motorB] = 0;                       // motor B is stopped at a power level of 0
  motor[motorC] = 0;
}



//Funcoes do sistema-------------------

void rotation(int current, int next){//calcula quantos giros de 45 sao necessarios
  if(current == next){

  }else if(current > next){
    for(int i = 0; i < current - next;i++){
      turn_plus_45();
    }
  }else{
    for(int i = 0; i < next - current;i++){
      turn_minus_45();
    }
  }
}

//Tasks do sistema---------------------------------

task fsteps(){
  oldturn = turn;
  for(int i=0;i<length;i = i+2)
  {

    quant = IntArray[i];
    turn = IntArray[i+1];
    nxtDisplayString(1, "%d",  quant);
    nxtDisplayString(2, "%d", turn);
    if(turn == 9){
      break;
    }
    rotation(oldturn,turn);
    if(turn % 2 == 0){
      fowardX(quant);
    }else{
      fowardW(quant);
    }
    oldturn = turn;
  }
}

task comunication(){

      bytesEnviados = 'x';
      char temp;
      wait1Msec(50);
      setBluetoothOn();
	    setBluetoothRawDataMode();
	    while(!bBTRawMode){ //Espera entrar no modo
	          wait1Msec(50);

	    }
      while(true){
        nxtReadRawBluetooth(&ligar, 20);
        if(ligar == 'x'){
          nxtWriteRawBluetooth(bytesEnviados,1);
          bytesEnviados = 'b';
	        wait1Msec(80);
        }
        if(ligar == 'y'){
          nxtWriteRawBluetooth(bytesEnviados,1);
	        wait1Msec(80);
	        int i = 0;

	        while(ligar != 'z'){
	          temp = ligar;
	          while(ligar == temp){
	            nxtReadRawBluetooth(&ligar, 20);
	          }
              if(ligar =='w' || ligar == 'z'){
              }else{
 	              IntArray[i] = ligar;
	              i++;
	            }
	          }

	        StartTask(fsteps);

        }
        nxtDisplayString(3, "%s", ligar);
      }
  }



//main---------------------------------

task main(){
  StartTask(comunication);
  while(true){}
}
