#include <math.h>
#include <msp430.h>

//Definitions and global varaibles
#define THERMISTORNOMINAL 10000
#define BCOEFFICIENT 4220
#define SERIESRESISTOR 12000
#define TEMPERATURENOMINAL 25
#define TEMPTHRESHOLD 0.5


float TempToHold = 25.0;
short PWM = 128;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(9600);
}
float GetTemp(){
  float steinhart;
  float resistance = SERIESRESISTOR/(1023/(float)analogRead(2)-1);//convert adc value to resistance & divide resistance by it
  steinhart = logf(resistance/THERMISTORNOMINAL)/BCOEFFICIENT;// 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15);// + (1/To)
  steinhart = 1.0 / steinhart;// Invert
  return (steinhart - 273.15);//get in C
}
void loop()
{
  // put your main code here, to run repeatedly:
  float Temp = GetTemp();
  float diff = (Temp-TempToHold);
  Serial.println(Temp);
  if ( diff < TEMPTHRESHOLD ){
    PWM +=1;
  }else if (diff > TEMPTHRESHOLD){
    PWM -=1;
  }
  if (PWM > 254){
    PWM = 254;
  }else if (PWM < 0){
    PWM = 0;
  }
  analogWrite(6,PWM);//Write the pwm
  Serial.println(PWM);
  delay(100);
  
  
}
