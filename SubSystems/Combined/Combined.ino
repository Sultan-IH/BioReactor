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
//short CycleTracker = 0;
//Stiring
unsigned long t; //time variables
short stateOfSensor = 0;
short previousState = 0;
short CurrentRPM = 0;
short IdealRPM = 55;
short MotorPWM = 255;
//Definitions and global varaibles*

void setup(){
  // put your setup code here, to run once:
  analogReference(DEFAULT);
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  Serial.begin(9600);
}

//Self explainatory
void AdjustTemp(){
  CurrentTemp = (((float)analogRead(2)-548.0)/-3.2);
  if (CurrentTemp > 20){
    CurrentTemp = SERIESRESISTOR/(1023/(float)analogRead(2)-1);
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
  CurrentpH = (((float)analogRead(2)/1024 * 3.55)*-13.5)+17.855;
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

void adjustRPM(){
    //short hits = 0;
    while (true){
      stateOfSensor = digitalRead(1);
      if ((previousState == 0)&&(stateOfSensor == 1)) { //check for rising edge
        CurrentRPM = (short)(1000000 * 60 / (micros() - t)); //print the rpm
        t = micros(); 
        break;
      }
      previousState = stateOfSensor;
      //Make sure rpm not slower than 10 (i.e waiting too loong)
      if ((micros() - t)> 6000000){
        CurrentRPM = 0;//may as well be
        t = micros();
        break;
      }
      //Make sure rpm not slower than 10 (i.e waiting too loong)
    }
    if ( (IdealRPM - CurrentRPM) > 5){
      MotorPWM +=10;
      if (MotorPWM > 255){
        MotorPWM = 255;
      }
      analogWrite(1,MotorPWM);
    }else if ((IdealRPM - CurrentRPM) < -5){
      MotorPWM -=1;
      if (MotorPWM < 0){
        MotorPWM = 0;
      }
      analogWrite(1,MotorPWM);
    }
  }

short getDecimal(float val)
{
  short decPart = 1000*(val-int(val)); //multiply by 1000 assuming that values will have a maximum of 3 decimal places. 
  if(decPart>0)return(decPart);           //return the decimal part of float number if it is available 
  else if(decPart<0)return((-1)*decPart); //if negative, multiply by -1
  else if(decPart=0)return(00);           //return 0 if decimal part of float number is not available
}


//Self explainatory*



void loop()
{
  // put your main code here, to run repeatedly:
  //CycleTracker += 1;
  //Measure and adjust params
  adjustRPM();
  AdjustTemp();
  AdjustpH();
  //Measure and adjust params
  //Update UI and look for input from UI
  //if (CycleTracker == 1){
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
              IdealRPM = (short)Input.toFloat();
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
   Serial.print(String(int(CurrentTemp))+'.'+String(getDecimal(CurrentTemp))+';'+String(int(CurrentpH))+ '.'+String(getDecimal(CurrentpH))+';'+String(MotorPWM)+';'+'\n');
   //Send Data
   //CycleTracker = 0;
  //}
  //Update UI and look for input from UI*
  
}
