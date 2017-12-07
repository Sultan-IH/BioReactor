int ph = 0;
int temp = 25;
int rpm = 0;
char in;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print(String(ph) + "," + String(temp) + "," + String(rpm) + "b");
  Serial.print("\n");
  in = Serial.read();
  delay(100);
}
