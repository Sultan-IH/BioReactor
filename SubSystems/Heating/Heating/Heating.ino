#include <math.h>
#include <msp430.h>

//Definitions and global varaibles
#define THERMISTORNOMINAL 8150
#define BCOEFFICIENT 4220
#define SERIESRESISTOR 10000
#define TEMPERATURENOMINAL 25


float TempToHold = 25.0;
float OptimalPh = 5.0;
short PWM = 0;


void setup()
{
  // put your setup code here, to run once:
  analogReference(DEFAULT);
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

float GetTempEq(){
  return (((float)analogRead(2)-548.0)/-3.2);
}

float GetpH(){
  // put your main code here, to run repeatedly:
  float voltage = (float)analogRead(P1_5);
  //read voltage from pin number 2
  float x= (voltage/72.59)-2.97;
  float pH= x;       // convert the voltage into a ph number
  Serial.print("voltage= ");
  Serial.println(voltage);
  Serial.print("pH level= ");                        // printing ph level=
  Serial.println(pH);   // printing the value of the ph
  Serial.println("________"); 
}
//Self explainatory*



void loop()
{
  // put your main code here, to run repeatedly:
  float Temp = GetTemp();
  float Tempp = GetTempEq();
  float diff = (TempToHold-Temp);
  if (Tempp < 20){
    diff = (TempToHold-Tempp);
  }
  Serial.println(Temp);
  Serial.println(Tempp);
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
  analogWrite(14,PWM);//Write the pwm
  Serial.println(PWM);
  Serial.println("----");
  GetpH();
  delay(500);
  analogWrite(10,0);//Write the pwm
  analogWrite(9,0);//Write the pwm
}
