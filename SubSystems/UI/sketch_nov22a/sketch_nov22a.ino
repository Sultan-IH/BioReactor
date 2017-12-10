float ph = 5;
float temp = 25.5;
float rpm = 1000;
char in;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print( String(temp) + ";" + String(ph) + ";" + String(rpm) + ";\n");
  delay(100);
}
