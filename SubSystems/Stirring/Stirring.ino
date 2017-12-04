
// most launchpads have a red LED
#include <Timer.h>
#define ROT_PIN P2_0
Timer t;                               //instantiate the timer object
unsigned long int numrots = 0;
unsigned long int rpm = 0;
int lastState;
int measuringInterval = 5000; // measuring interval in millis

void setup() {                
  // initialize the digital pin as an output.
  Serial.begin(9600);
  Serial.println("Serial started") ;
  t.every(1, takeReading);
  t.every(measuringInterval, calcRPM);
  t.every(measuringInterval, printReading);
  lastState = digitalRead(ROT_PIN);
}

// the loop routine runs over and over again forever:
void loop() 
{
  t.update();
  
}

void takeReading(){
  int state = digitalRead(ROT_PIN);
  if(state != lastState){
    ++numrots;
    lastState = state;
  }
}

void calcRPM(){
  rpm = numrots / 4 *(60000 / measuringInterval);
  numrots = 0; 
}

void printReading(){
  Serial.print("The RPM is: ");
  Serial.println(rpm);
}
