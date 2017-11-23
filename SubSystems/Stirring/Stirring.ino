
// most launchpads have a red LED
#include <Timer.h>
#define ROT_PIN P2_0
Timer t;                               //instantiate the timer object
int numrots = 0;
int rpm = 0;
void setup() {                
  // initialize the digital pin as an output.
  Serial.begin(9600);
  Serial.println("Serial started") ;
  t.every(1, takeReading);
  t.every(1000, calcRPM);
}

// the loop routine runs over and over again forever:
void loop() 
{
  t.update();
}

void takeReading(){
  if(!digitalRead(ROT_PIN)) ++numrots;
}

void calcRPM(){
  rpm = numrots * 30;
  numrots = 0; 
}
