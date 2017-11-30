#include <math.h>
#include <msp430.h>

//Definitions and global varaibles
#define THERMISTORNOMINAL 7990
#define BCOEFFICIENT 4220
#define SERIESRESISTOR 10000
#define TEMPERATURENOMINAL 25


float TempToHold = 25.0;
short PWM = 0;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(9600);
}

String FormatAnalogData(String Name,short data){
    return Name +":"+ String(data, DEC) +"~"; 
}

//Self explainatory
float GetTemp(){
  float steinhart;
  float resistance = SERIESRESISTOR/(1023/(float)analogRead(2)-1);//convert adc value to resistance & divide resistance by it
  steinhart = logf(resistance/THERMISTORNOMINAL)/BCOEFFICIENT;// 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15);// + (1/To)
  steinhart = 1.0 / steinhart;// Invert
  return (steinhart - 273.15);//get in C
}
//Self explainatory*

void loop()
{
  // put your main code here, to run repeatedly:
  float Temp = GetTemp();
  float diff = (TempToHold-Temp);
  Serial.println(Temp);
  if ( diff > 0.5 ){
    //PWM +=1;
    PWM = (short)((diff/15)*255)+110; 
  }else if (diff < 0.5){
    PWM =0;//stop heating
  }
  if (PWM > 254){
    PWM = 254;
  }/*else if (PWM < 0){
    PWM = 0;
  }*/
  analogWrite(6,PWM);//Write the pwm
  Serial.println(PWM);
  delay(100);
}
