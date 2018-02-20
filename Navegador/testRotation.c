task main(){

  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  nMotorEncoderTarget[motorB] = 590;
  motor[motorB] = 20;
  motor[motorC] = 20;

  while(nMotorRunState[motorB] != runStateIdle){}
  motor[motorB] = 0;                       // motor B is stopped at a power level of 0
  motor[motorC] = 0;

}
