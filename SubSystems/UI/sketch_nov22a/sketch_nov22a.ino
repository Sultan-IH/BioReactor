int ph = 0;
bool phUp = true;
int temp = 25;
bool tempUp = true;
int rpm = 0;
bool rpmUp = true;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print(String(ph) + "," + String(temp) + "," + String(rpm) + "b");
  Serial.print("\n");
  if (phUp == true){
    ph+=1;
    if (ph == 14){
      phUp = false;
    }
  }else{
    ph-=1;
    if (ph == 0){
      phUp = true;
    }
  }

  if (tempUp == true){
    temp+=1;
    if (temp == 35){
      tempUp = false;
    }
  }else{
    temp-=1;
    if (temp == 25){
      tempUp = true;
    }
  }

  if (rpmUp == true){
    rpm+=1;
    if (rpm == 1500){
      rpmUp = false;
    }
  }else{
    rpm-=1;
    if (rpm == 0){
      rpmUp = true;
    }
  }
  delay(100);
}
