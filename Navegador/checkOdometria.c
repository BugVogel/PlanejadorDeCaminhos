task main(){
  wait1Msec(1000);
  motor[motorB] =0;
  motor[motorC] =0;
	nMotorEncoder(motorB) = 0;
	nMotorEncoder(motorC) = 0;
	while(nMotorEncoder(motorB) < (160*360)/17.3){
	 motor[motorB] = 20;
	 motor[motorC] = 20;
	}
	motor[motorB] =0;
  motor[motorC] =0;
}
//17.3cm circunferencia
