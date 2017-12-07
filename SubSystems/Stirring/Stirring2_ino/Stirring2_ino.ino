int t, cur_t; //time variables
int val;
int prev_val = 0;
short RPM = 0;
void setup()
{
  // put your setup code here, to run once:
  int t, cur_t; //time variables
}

void GetRPM(){
  // put your main code here, to run repeatedly:
  if (prev_val == 0 && val == 1) { //check for rising edge
     cur_t = micros();
     RPM = (short)(1000000 * 60 / (cur_t - t)); //print the rpm
     t = micros();
   }
   prev_val = val;
}

void loop()
{
  
   
}
