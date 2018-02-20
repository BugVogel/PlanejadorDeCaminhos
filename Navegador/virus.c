#pragma config(Sensor, S1, sesorLuz, sensorLightActive)
#pragma config(Sensor, S4, sensorToque, sensorTouch)

float r = 2.912; //raio
float b = 2.912; //comprimento da base
float ce = 360.0; //resoluo do encoder
float cg = 0.46839; //reduo mecanica
float pi = 3.141592;
float xki = 0.0;
float xk = 0.0;
float yki = 0.0;
float yk = 0.0;
float Ok = 270.0;




task main(){
  xki = xk + ((r*(1/nMotorEncoder[motorB]) + (r*(1/nMotorEncoder[motorA]))/(pi*cg*cos(Ok))/ce;
  yki = yk + ((r*(1/nMotorEncoder[motorB]) + (r*(1/nMotorEncoder[motorA]))/(pi*cg*cos(Ok))/ce;
  Oki = Ok + ((r*(1/nMotorEncoder[motorB]) + (r*(1/nMotorEncoder[motorA]))*(pi*cg)/(ce*b);
}
