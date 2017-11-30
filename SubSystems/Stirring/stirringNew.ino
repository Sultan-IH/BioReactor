// most launchpads have a red LED
#define ROT_PIN P2_0
int numrots = 0;
int rpm = 0;

int currentMilli = 0;

void setup()
{
    // initialize the digital pin as an output.
    Serial.begin(9600);
    Serial.println("Serial started");
}

// the loop routine runs over and over again forever:
void loop()
{
    currentMilli = millis();
    if (currentMilli >= 1000){
        rpm = numrots * 30;// not by 60 because it takes two blinks for one rot
        numrots = 0;
        currentMilli = 0;
        Serial.print("The RPM is: ");
        Serial.println( rpm);
    }
    takeReading();

}

void takeReading()
{
    if (!digitalRead(ROT_PIN))
        ++numrots;
}


