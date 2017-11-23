/// Make 4 digit number smaller
/// include the images
/// make up and down buttons work
/// add numbers to the faces
/// comments the code
/// Play around with the colours


import processing.serial.*;

Serial myPort;// The serial port from which the data will be recieved
 // minimum and maximum angles for analog view
float minAngle = 0.8;
float maxAngle = 2*PI-0.75;

// Font for the text ###Have a look at other fonts###
PFont f;

// 0 - Analog, 1 - Digital, 2 - Graph
int stateRPM = 0;
int statePH = 0;
// 0 - Digital, 1 - Graph
int stateTemp = 0;

// Current values of the sensors
Integer currentRPM = 1500;
Integer currentPH = 7;
Integer currentTemp = 25;

Integer neededRPM = 800;
Integer neededPH = 5000;
Integer neededTemp = 30;

void setup() {
  
  size(1280, 720);
  
  f = createFont("Arial",16,true);
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw(){
  background(255, 204, 0);
  
  getValue();
  
  if (statePH == 0){ // Shows analog PH
    drawAnalogPH(currentPH, neededPH);
  }
  else if ( statePH == 1){
    drawDigitalPH(currentPH, neededPH);
  }
  
  if (stateTemp == 0){ // Shows digital Temperature
  
    drawDigitalTemp(currentTemp, neededTemp);
  }
  
  if (stateRPM == 0){ // Shows analog RPM
    drawAnalogRPM(currentRPM, neededRPM);
  } else if (stateRPM == 1){
    drawDigitalRPM(currentRPM, neededRPM);
  }
  
  
  delay(100); ///////////////// Try to make it work without the delay ////////////////
  
}

void mouseClicked(){
  if (mouseOverRect(360, 70, 40, 40)){
    if (statePH == 0){
      statePH = 1;
    }else{
      statePH = 0;
    }
  }
  if (mouseOverRect(1200, 70, 40, 40)){
    if (stateRPM == 0){
      stateRPM = 1;
    }else{
      stateRPM = 0;
    }
  }
}

void getValue(){
  if (myPort.available() > 0){ // if the porst is empty
    String str = myPort.readStringUntil('b'); // Reads the serail value
    String str1 = str.substring(1,str.length()-1);
    println(str1);
    int[] nums = int(split(str1, ','));
    
    if(nums.length == 3){
      currentPH = nums[0];
      currentTemp = nums[1];
      currentRPM = nums[2];
    }
  }
}

void updateGraphs(){
  
}

void getSettings(){
  
}

void pHSettings(){
  
}

void tempSettings(){
  
}

void drawAnalogPH(int value, int neededValue){
   float min = 0;
   float max = 14;
   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(20, 50, 400, 620); // Background for the section
   
   fill(#F1C40F);
   ellipse(220, 270+30, 380, 380); // Main face
   
   ellipse(220, 580, 100, 100); // The required value Face
   
   rect(50, 545, 80, 80, 7);//bottom left button
   
   rect(310, 545, 80, 80, 7);// bottom right button
   
   rect(360, 70, 40, 40, 7); // top left button (settings)
   
   rect(40, 70, 40, 40, 7); // top right button (mode)
   
   // Create the Arc around the meter
   noFill();
   stroke(176);
   strokeWeight(20);
   strokeCap(SQUARE);
   arc(220, 270+30, 360, 360, PI-0.8, 2*PI+0.8);
   
   // Creates the arrow on the dial
   noStroke();
   fill(1);
   translate(220, 270+30);
   rotate(workOutPos(min, max, value));
   rect(0,0,10,190);
   
   // returns the other objects to original position
   rotate(-workOutPos(min, max, value));
   translate(-220, -270-30);
   
   textFont(f,50);// Neede text render
   text(neededValue,210 + getNeededPos(neededValue),598);
   
   text("pH", 190, 95);
   
}

void drawAnalogRPM(int value, int neededValue){//+840
   // Minimum and maximum values of the sensor
   float min = 0;
   float max = 1500;
   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(860, 50, 400, 620); // Background for the section
   
   fill(#F1C40F);
   ellipse(1060, 270+30, 380, 380); // Main face
   
   fill(#F1C40F);
   ellipse(1060, 580, 100, 100); // The required value Face
   
   rect(890, 545, 80, 80, 7);//bottom left button
   
   rect(1150, 545, 80, 80, 7);// bottom right button
   
   rect(1200, 70, 40, 40, 7); // top left button (settings)
   
   rect(880, 70, 40, 40, 7); // top right button (mode)

   // Create the Arc around the meter
   noFill();
   stroke(176);
   strokeWeight(20);
   strokeCap(SQUARE);
   arc(1060, 270+30, 360, 360, PI-0.8, 2*PI+0.8);
   
   // Creates the arrow on the dial
   noStroke();
   fill(0);
   translate(1060, 270+30);
   rotate(workOutPos(min, max, value));
   rect(0,0,10,190);
   
   rotate(-workOutPos(min, max, value));
   translate(-1060,-270-30);
   
   textFont(f,50);// Needed text render
   text(neededValue,1050 + getNeededPos(neededValue),598);
   
   text("Stirring", 985, 95);

}

void drawDigitalPH(int value, int neededValue){
   float min = 0;
   float max = 14;
   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(20, 50, 400, 620); // Background for the section
   
   fill(#F1C40F);
   ellipse(220, 270+30, 380, 380); // Main face
   
   ellipse(220, 580, 100, 100); // The required value Face
   
   rect(50, 545, 80, 80, 7);//bottom left button
   
   rect(310, 545, 80, 80, 7);// bottom right button
   
   rect(360, 70, 40, 40, 7); // top right button (mode)
   
   rect(40, 70, 40, 40, 7); // top left button (Settings)
   
   // Shows the temp value
   textFont(f,200);
   fill(0);
   text(value,170 + getDigitPos(value) ,330+30); // Actaul text render
   
   textFont(f,50);// Needed text render
   text(neededValue,210 + getNeededPos(neededValue),598);
   
   text("pH", 190, 95);
   
}

void drawDigitalTemp(int value, int neededValue){// + 420
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(440, 50, 400, 620); // Background for the section
   
   fill(#F1C40F);
   ellipse(640, 270+30, 380, 380); // Main face
   
   fill(#F1C40F);
   ellipse(640, 580, 100, 100); // The required value Face
   
   rect(470, 545, 80, 80, 7);//bottom left button
   
   rect(730, 545, 80, 80, 7);// bottom right button
   
   rect(780, 70, 40, 40, 7); // top left button (settings)
   
   rect(460, 70, 40, 40, 7); // top right button (mode)
   
   // Shows the temp value
   textFont(f,200);
   fill(0);
   text(value,605 + getDigitPos(value) ,330+30); // actual text render
   
   textFont(f,50);
   text(neededValue,630 + getNeededPos(neededValue),598); // needed text render
   
   text("Temperature", 500, 95);
   
}

void drawDigitalRPM(int value, int neededValue){
  // Minimum and maximum values of the sensor
   float min = 0;
   float max = 1500;
   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(860, 50, 400, 620); // Background for the section
   
   fill(#F1C40F);
   ellipse(1060, 270+30, 380, 380); // Main face
   
   fill(#F1C40F);
   ellipse(1060, 580, 100, 100); // The required value Face
   
   rect(890, 545, 80, 80, 7);//bottom left button
   
   rect(1150, 545, 80, 80, 7);// bottom right button
   
   rect(1200, 70, 40, 40, 7); // top left button (settings)
   
   rect(880, 70, 40, 40, 7); // top right button (mode)
   
   noStroke();
   textFont(f,200);
   fill(0);
   
   text(value,1020 + getDigitPos(value) ,330+30); // Actual text render
   
   textFont(f,50);// Needed text render
   text(neededValue,1050 + getNeededPos(neededValue),598);
   
   text("Stirring", 985, 95);
}

float workOutPos(float min, float max, int current){
  // Returns the position of the arrow on analog face
  return ((maxAngle - minAngle)/(max-min))*current+0.8;
}

boolean mouseOverRect(int x, int y, int w, int h) {
  // Checks if the mouse is over the rect
  return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
}

int getDigitPos(int value){
  // Calculates the offset for the actual vlaue
  int pos;
  pos = 0;
  if ( str(value).length() == 1){
    pos = 0;
  }else if (str(value).length() == 2){
    pos = -70;
  }else if (str(value).length() == 3){
    pos = -120;
  }else if (str(value).length() == 4){
    pos = -180;
  }
  
  return pos;
}

int getNeededPos(int value){
  // Calculates the offset for the needed value
  int pos;
  pos = 0;
  if ( str(value).length() == 1){
    pos = 0;
  }else if (str(value).length() == 2){
    pos = -17;
  }else if (str(value).length() == 3){
    pos = -34;
  }else if (str(value).length() == 4){
    pos = -48;
  }
  
  return pos;
}