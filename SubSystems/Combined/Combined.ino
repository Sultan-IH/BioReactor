#include <math.h>
#include <msp430.h>

//Definitions and global varaibles
#define THERMISTORNOMINAL 8150
#define BCOEFFICIENT 4220
#define SERIESRESISTOR 10000

//Thermal
float TempToHold = 25.0;
float CurrentTemp = 20;
//pH
float OptimalpH = 5.5;
float CurrentpH = 5.5;
//UI
short CycleTracker = 0;
//Stiring
unsigned long t; //time variables
short stateOfSensor = 0;
short previousState = 0;
short CurrentRPM = 0;
short IdealRPM = 2000;
short MotorPWM = 128;
//Definitions and global varaibles*

void setup(){
  // put your setup code here, to run once:
  /*BCSCTL1 = CALBC1_16MHZ;                  // DCO at 16 MHz    
  DCOCTL = CALDCO_16MHZ;                   // DCO at 16 MHz*/
  analogReference(DEFAULT);
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  attachInterrupt(P2_4, getRPM, RISING);      //  ADD A HIGH PRIORITY ACTION ( AN INTERRUPT)  WHEN THE SENSOR GOES FROM LOW TO HIGH
  t = micros();
  Serial.begin(9600);
}

//Self explainatory
void AdjustTemp(){
  CurrentTemp = (((float)analogRead(P1_0)-548.0)/-3.2);
  if (CurrentTemp > 20){
    CurrentTemp = SERIESRESISTOR/(1023/(float)analogRead(P1_0)-1);
    CurrentTemp = 1/(logf(CurrentTemp/THERMISTORNOMINAL)/BCOEFFICIENT + 0.003354016435);
    CurrentTemp -= 273.15;
  }
  if ( (TempToHold-CurrentTemp) > 0.5 ){
    if ( ((((TempToHold-CurrentTemp)/15)*255)+110)>254){
      analogWrite(14,255);
    }else{
      analogWrite(14,((int)(((TempToHold-CurrentTemp)/15)*255)+110));
    }
  }else if ((TempToHold-CurrentTemp) < 0.5){
    analogWrite(14,0);
  }
}


void AdjustpH(){
  CurrentpH = (((float)analogRead(P1_5)/1024 * 3.55)*-13.5)+17.855;
  if ((OptimalpH - CurrentpH) > 1){
    digitalWrite(10,HIGH);//PUMP acid
    digitalWrite(9,LOW);;
  }else if ( (OptimalpH - CurrentpH) < -1){
    digitalWrite(10,LOW);
    digitalWrite(9,HIGH);//PUMP base
  }else{
    //Turn off pumping
    digitalWrite(10,LOW);
    digitalWrite(9,LOW);
  }
}

void getRPM(){
  if ((micros() - t) < 600000000){
    CurrentRPM = (short)(60000000 / (micros() - t));
  }
  t = micros();
}

void adjustRPM(){
    if ((IdealRPM - CurrentRPM) > 5){
      MotorPWM +=1;
      if (MotorPWM > 128){
        MotorPWM = 128;
      }
      analogWrite(P2_5,MotorPWM);
    }else if ((IdealRPM - CurrentRPM) < -5){
      MotorPWM -=1;
      if (MotorPWM < 25){
        MotorPWM = 25;
      }
      analogWrite(P2_5,MotorPWM);
    }
  }


//Self explainatory*



void loop()
{
  // put your main code here, to run repeatedly:
  CycleTracker += 1;
  //Measure and adjust params
  adjustRPM();
  AdjustTemp();
  AdjustpH();
  //Measure and adjust params
  //Update UI and look for input from UI
  if (CycleTracker == 100){
    //Check input
    String Input="";
    short InputIndex = 0;
    while (Serial.available() > 0) {
      char ch = Serial.read();
      if (ch == '\n'){
        //End of input
        InputIndex = 0;
        Input = "";
        //End of input 
      }else{
        if (ch == ';'){
          switch (InputIndex) {
            case 0:
              TempToHold = Input.toFloat();
              break;
            case 1:
              OptimalpH = Input.toFloat();
              break;
            case 2:
              IdealRPM = ((short)Input.toFloat())*2;
              MotorPWM = (short)(103*0.3*((IdealRPM - CurrentRPM)/IdealRPM)+25);
              break;
          }
          Input = "";
          InputIndex +=1;
        }else{
          Input += ch;
        }
      }
   }
   //Check input
   
   //Send Data
   Serial.print(String(int(CurrentTemp))+';'+String(int(CurrentpH))+ ';'+String(CurrentRPM/2)+';'+'\n');
   //Send Data
   CycleTracker = 0;
  }
  //Update UI and look for input from UI*
  
}
