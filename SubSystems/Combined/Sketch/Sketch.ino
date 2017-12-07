#include <math.h>
#include <msp430.h>

//Definitions and global varaibles
#define THERMISTORNOMINAL 8150
#define BCOEFFICIENT 4220
#define SERIESRESISTOR 10000
#define TEMPERATURENOMINAL 25

//Thermal
float TempToHold = 25.0;
float CurrentTemp = 25.0;
float CurrentTempDiff = 0.0;
short HeaterPWM = 0;
//pH
float OptimalPh = 5.5;
float CurrentpH = 7.0;
//Stiring
int t, cur_t; //time variables
int val;
int prev_val = 0;
short CurrentRPM = 0;
short IdealRPM = 55;
short MotorPWM = 0;
//UI
short CycleTracker = 0;
String Input = "";
short InputIndex = 0;
//Definitions and global varaibles*

void setup()
{
  // put your setup code here, to run once:
  analogReference(DEFAULT);
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  Serial.begin(9600);
}

//Self explainatory
float GetTempSteinhart(float input){
  float steinhart;
  float resistance = SERIESRESISTOR/(1023/Input);//convert adc value to resistance & divide resistance by it
  steinhart = logf(resistance/THERMISTORNOMINAL)/BCOEFFICIENT;// 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15);// + (1/To)
  steinhart = 1.0 / steinhart;// Invert
  return (steinhart - 273.15);//get in C
}

void GetThermalReadings(){
  float input = (float)analogRead(2);
  float temp = ((input-548.0)/-3.2);
  if (temp > 20){
    temp = GetTempSteinhart(input-1);
  }
  CurrentTempDiff = (TempToHold-temp);
  CurrentTemp = temp;
}

void AdjustTemp(){
  if ( CurrentTempDiff > 0.5 ){
    HeaterPWM = (short)((CurrentTempDiff/15)*255)+110; 
  }else if (CurrentTempDiff < 0.5){
    HeaterPWM =0;//stop heating
  }
  if (HeaterPWM > 254){
    HeaterPWM = 254;
  }
  analogWrite(14,HeaterPWM);//Write the pwm
}

//--------\\

void GetpH(){
  // put your main code here, to run repeatedly:
  float voltage = (float)analogRead(P1_5)/1024 * 3.55;//read voltage from pin number 1.5
  CurrentpH = (voltage*-13.5)+17.855;// convert the voltage into a ph number
}

void AdjustpH(){
  if (difference > 1){
    digitalWrite(10,HIGH);//PUMP acid
    digitalWrite(9,LOW);;
  }else if ( difference < -1){
    digitalWrite(10,LOW);
    digitalWrite(9,HIGH);//PUMP base
  }else{
    //Turn off pumping
    digitalWrite(10,LOW);
    digitalWrite(9,LOW);
  }
}

  //--------\\
void UpdateRPM(){
  val = digitalRead(1);
  if (prev_val == 0 && val == 1) { //check for rising edge
     cur_t = micros();
     CurrentRPM = (short)(1000000 * 60 / (cur_t - t)); //print the rpm
     t = micros();
   }
   prev_val = val;
}

  void adjustRPM(){
    short diff = IdealRPM - CurrentRPM;
    if (diff > 5){
      MotorPWM +=1;
      analogWrite(1,MotorPWM);
    }else if (diff < -5){
      MotorPWM -=1;
      analogWrite(1,MotorPWM);
    }
  }
//Self explainatory*



void loop()
{
  // put your main code here, to run repeatedly:
  CycleTracker += 1;
  
  GetThermalReadings();
  AdjustTemp();
  
  GetpH();
  AdjustpH();
  
  UpdateRPM();
  adjustRPM();
  
  //Update UI and look for input from UI
  if (CycleTracker == 100){
    //Check input
    while (Serial.available() > 0) {
    char ch += Serial.read();
    if (ch == '\n'){
      //End of input
      InputIndex = 0;
      Input = "";
      //End of input 
    }else{
      if (ch == ";"){
        switch (InputIndex) {
          case 0:
            TempToHold = Input.toFloat();
            break;
          case 1:
            OptimalPh = Input.toFloat();
            break;
          default:
            IdealRPM = (short)Input.toFloat();
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
   Serial.write(String(CurrentTemp, DEC)+";"+String(CurrentpH, DEC)+";"+String(CurrentRPM, DEC)+";"+'\n');
   //Send Data
   CycleTracker = 0;
  }
  //Update UI and look for input from UI*
  
  delay(500);//temporary
  
}
