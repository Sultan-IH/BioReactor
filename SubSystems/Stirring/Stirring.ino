

// most launchpads have a red LED
#define READ_PIN P2_0

int rpm = 0;
// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  Serial.begin(9600);
  Serial.println("Serial started") ;
  pinMode(READ_PIN, INPUT);

}

// the loop routine runs over and over again forever:
void loop() 
{
  getRPM(READ_PIN, &rpm);  
  Serial.print("Status of read pin: ");
  Serial.println(rpm);

}


void getRPM(int pinNum, int *rmp) {
  int numrot = 0;
  
  for(int i = 0; i < 10; ++i){
    delay(100);
    int status = !digitalRead(pinNum);
    numrot = numrot + status; 
  }
  *rmp = numrot * 30; // not 60 because it takes 2  0s for 1 rotation
}

