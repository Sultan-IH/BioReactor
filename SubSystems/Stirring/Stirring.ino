
#include <Timer.h>
#define ROT_PIN P2_0 // for 
Timer t;  //instantiate the timer object
unsigned long int numrots = 0; // unsigned long as this cant be negative
unsigned long int rpm = 0; // set inital value to 0
int lastState; // for signal debouncing; we only want to register a 1 or 0 if it came after a 0 or a 1 respectively
int measuringInterval = 5000; // measuring interval in millis
int idealRPM = 55;
void setup() {                
  // initialize the digital pin as an output.
  Serial.begin(9600);
  Serial.println("Serial started") ;
  t.every(1, takeReading);
  t.every(measuringInterval, calcRPM);
  t.every(measuringInterval, printReading);
  t.every(10, adjustRPM);
  lastState = digitalRead(ROT_PIN);
}

// the loop routine runs over and over again forever:
void loop() 
{
  t.update();
  
}

void takeReading(){
  int state = digitalRead(ROT_PIN);
  if(state != lastState){ //debouncing the signal
    ++numrots;
    lastState = state;
  }
}

void calcRPM(){
  rpm = numrots / 4 *(60000 / measuringInterval); // it takes 4 changes of state to measure 1 rotation
  numrots = 0; // reset the number of rotoations
}

void printReading(){
  Serial.print("The RPM is: ");
  Serial.println(rpm);
}


void adjustRPM(){
  int diff = idealRPM - rpm;
}
