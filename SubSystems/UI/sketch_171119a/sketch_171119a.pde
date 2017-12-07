// Need to do settings file
// play around with fonts
// send value to MSP
// add the type chnage in settings
// make the needed value change with min and max range
// make an error stating that you are out of range when you change stuff in settings
// add indication of min and max on digital view
// play around with colours
// add border to settings button

import processing.serial.*;

Serial myPort;// The serial port from which the data will be recieved

// minimum and maximum angles for analog view
float minAngle = 0.8;
float maxAngle = 2*PI-0.75;

// Font for the text ###Have a look at other fonts###
PFont f;

// 0 - Analog, 1 - Digital
int stateRPM = 0;
int statePH = 0;
int stateTemp = 1;

Boolean isSettingsPH = false;
Boolean isSettingsTemp = false;
Boolean isSettingsRPM = false;

// Current values of the sensors
Integer currentRPM = 1500;
Integer currentPH = 7;
Integer currentTemp = 25;

Integer neededRPM = 800;
Integer neededPH = 7;
Integer neededTemp = 30;

int minPH = 3;
int maxPH = 8;

int minTemp = 25;
int maxTemp = 35;
int modeTemp = 0;

int minRPM = 0;
int maxRPM = 1500;
int modeRPM = 0;

PImage modeSettingsButton;
PImage modeBackButton;
PImage modeDigitalButton;
PImage modeAnalogButton;
PImage modeGraphButton;
PImage upButton;
PImage downButton;
PImage settingsUpButton;
PImage settingsDownButton;

Boolean isOn = true;

PrintWriter output;
void setup() {
  /*if (fileExists("settings.txt") == false){
    output = createWriter("settings.txt"); 
  }*/
  String filename = "settings.txt";

  File fi = new File(dataPath(filename));
  
  if (!fi.exists())
  {
    output = createWriter("settings.txt"); 
  }
  size(1280, 720);
  
  modeSettingsButton = loadImage ("Picture8.png");
  modeSettingsButton.resize(0,40);
  modeBackButton = loadImage ("Picture9.png");
  modeBackButton.resize(0,40);
  modeDigitalButton = loadImage ("Picture7.png");
  modeDigitalButton.resize(0,40);
  modeAnalogButton = loadImage("Picture5.png");
  modeAnalogButton.resize(0,40);
  upButton = loadImage("Picture3.png");
  upButton.resize(0,80);
  downButton = loadImage("Picture2.png");
  downButton.resize(0,80);
  settingsUpButton = loadImage("Picture3.png");
  settingsUpButton.resize(0,40);
  settingsDownButton = loadImage("Picture2.png");
  settingsDownButton.resize(0,40);
  
  
  f = createFont("Arial",16,true);
  //myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw(){
  background(#F5D76E);
  
  getValue();
  
  if (statePH == 0){ // Shows analog PH
    drawAnalogPH(currentPH, neededPH, minPH, maxPH);
  }
  else if ( statePH == 1){
    drawDigitalPH(currentPH, neededPH);
   //else if (statePH == 2){ }
  }
  
  if (isSettingsPH){
    drawSettingsPH(minPH, maxPH);
  }
  
  if (stateTemp == 0){ // Shows digital Temperature
    drawAnalogTemp(currentTemp, neededTemp, minTemp, maxTemp);
  }else if (stateTemp == 1){
    drawDigitalTemp(currentTemp, neededTemp, minTemp, maxTemp);
  }
  
  if (isSettingsTemp){
    drawSettingsTemp(minTemp, maxTemp, modeTemp);
  }
  
  if (stateRPM == 0){ // Shows analog RPM
    drawAnalogRPM(currentRPM, neededRPM, minRPM, maxRPM);
  } else if (stateRPM == 1){
    drawDigitalRPM(currentRPM, neededRPM);
    //else if (stateRPM == 2){}
  }
  
  if (isSettingsRPM){
    drawSettingsRPM(minRPM,maxRPM, modeRPM);
  }
  
  
  delay(100); ///////////////// Try to make it work without the delay ////////////////
  
}

void mouseClicked(){
  
  if (mouseOverRect(0,0,0,0)){ // On/Off button
    if (isOn){
      isOn = false;
    }else{
      isOn = true;
    }
  }
  
  if (mouseOverRect(40,70,40,40)){ // pH settings button - not settings
      if (!isSettingsPH){
        isSettingsPH = true;
      }else{
        isSettingsPH = false;
      }
    }
  
  if (isSettingsPH){ // When pH settings are open
    
    if (mouseOverRect(370,180,40,40)){ // minPH UP button
      if (minPH<13){
        if (minPH + 1 == maxPH){
          minPH +=1;
          maxPH +=1;
        }else{
          minPH += 1;
      }
      }
    }
    
    if (mouseOverRect(325,180,40,40)){ // minPH down button
      if (minPH > 0){
        minPH -= 1;
      }
    }
    
    if (mouseOverRect(370,230,40,40)){ // maxPH up button
      if (maxPH <14){
        maxPH += 1;
      }
    }
    
    if (mouseOverRect(325,230,40,40)){ // maxPH down button
      if (maxPH > 1){
        if (maxPH -1 == minPH){
          maxPH-=1;
          minPH-=1;
        }else{
          maxPH-=1;
        }
      }
    }
    
  }else{ // When pH settings are closed
    if (mouseOverRect(360, 70, 40, 40)){ // pH state button
      if (statePH == 0){
        statePH = 1;
      }else{
        statePH = 0;
      }
    }
    
    if (mouseOverRect(310,545,80,80)){ // pH up button
      if (neededPH < maxPH){
        neededPH +=1;
      }
    }
    
    if (mouseOverRect(50,545,80,80)){ // pH down button
      if (neededPH > minPH){
        neededPH -=1;
      }
    }
  }
  
     
  if (mouseOverRect(1200, 70, 40, 40)){ // RPM state button
    if (stateRPM == 0){
      stateRPM = 1;
    }else{
      stateRPM = 0;
    }
  }
  
  if (mouseOverRect(460, 70,40,40)){ // Settings button Temp
    if (!isSettingsTemp){
      isSettingsTemp = true;
    }else{
      isSettingsTemp = false;
    }
  }
  
  if (isSettingsTemp){ // when temp settings are open
    if (mouseOverRect(370+420,180,40,40)){ // minPH UP button
      if (minTemp<59){
        if (minTemp + 1 == maxTemp){
          minTemp +=1;
          maxTemp +=1;
        }else{
          minTemp += 1;
      }
      }
    }
    
    if (mouseOverRect(325+420,180,40,40)){ // minPH down button
      if (minTemp > 0){
        minTemp -= 1;
      }
    }
    
    if (mouseOverRect(370+420,230,40,40)){ // maxPH up button
      if (maxTemp <60){
        maxTemp += 1;
      }
    }
    
    if (mouseOverRect(325+420,230,40,40)){ // maxPH down button
      if (maxTemp > 1){
        if (maxTemp -1 == minTemp){
          maxTemp-=1;
          minTemp-=1;
          
        }else{
          maxTemp-=1;
        }
      }
    }
  }else{ // when tesp settings are closed
    if (mouseOverRect(730,545,80,80)){ // Temp up button
      if (neededTemp < maxTemp){
        neededTemp +=1;
      }
    }
    
    if (mouseOverRect(470,545,80,80)){ // Temp down button
      if (neededTemp > minTemp){
        neededTemp -=1;
      }
    }
    
    if (mouseOverRect(1200-420,70,40,40)){
      if (stateTemp == 0){
      stateTemp = 1;
    }else{
      stateTemp = 0;
    }
    }
  }
  
    if (mouseOverRect(880,70,40,40)){ // pH settings button - back to main view
      if (!isSettingsRPM){
        isSettingsRPM = true;
      }else{
        isSettingsRPM = false;
      }
    }
    
  if(isSettingsRPM){ // when RPM settings are open
    if (mouseOverRect(370+840,180,40,40)){ // minRPM UP button
      if (minRPM<1900){
        if (minRPM + 100 == maxRPM){
          minRPM +=100;
          maxRPM +=100;
        }else{
          minRPM += 100;
        }
      }
    }
    
    if (mouseOverRect(325+840,180,40,40)){ // minRPM down button
      if (minRPM > 0){
        minRPM -= 100;
      }
    }
    
    if (mouseOverRect(370+840,230,40,40)){ // maxRPM up button
      if (maxRPM <2000){
        maxRPM += 100;
      }
    }
    
    if (mouseOverRect(325+840,230,40,40)){ // maxRPM down button
      if (maxRPM > 100){
        if (maxRPM - 100 == minRPM){
          maxRPM -=100 ;
          minRPM -=100 ;
          
        }else{
          maxRPM -= 100;
        }
      }
    }
  }else{ // when RPM settings are closed
    
    if (mouseOverRect(1150,545,80,80)){ // RPM up button
      if (neededRPM < maxRPM){
        neededRPM +=100;
      }
    }
    
    if (mouseOverRect(890,545,80,80)){ // RMP down button
      if (neededRPM > minRPM){
        neededRPM -=100;
      }
    }
    
  }
   
}

void getValue(){
  /*if (myPort.available() > 0){ // if the porst is empty
    String str = myPort.readStringUntil('b'); // Reads the serail value
    String str1 = str.substring(1,str.length()-1);
    println(str1);
    int[] nums = int(split(str1, ','));
    
    if(nums.length == 3){
      currentPH = nums[0];
      currentTemp = nums[1];
      currentRPM = nums[2];
      
      // Test values
      currentPH = 7;
      currentTemp = 30;
      currentRPM = 1000;
    }
  }*/
   // Test values
      currentPH = 7;
      currentTemp = 30;
      currentRPM = 1000;
}

void getSettings(){
  
}

void drawSettingsRPM(int min, int max, int mode){
  noStroke();
  
  fill(#ECF0F1, 240);
  rect(20+840,50,400,620);
  
  fill(#95A5A6, 230);
  image(modeBackButton, 40+840, 70); // top left button (Back)
  image(settingsUpButton, 370+840,180); // min up button
  image(settingsDownButton, 325+840,180); // min down button
  
  rect(170+840, 178, 150, 45);
  
  image(settingsUpButton, 370+840,230); // max up button
  image(settingsDownButton, 325+840,230); // max down button
  
  rect(170+840, 225, 150, 45);
  
  fill(0);
  textFont(f, 40);
  text("Range", 40+840, 170);
  text("Min", 60+840, 215);
  text(min, 170+840,215);
  text("Max", 60+840, 260);
  text(max, 170+840,260);
}

void drawSettingsTemp(int min, int max, int mode){
  noStroke();
  
  fill(#ECF0F1, 240);
  rect(20+420,50,400,620);
  
  fill(#95A5A6, 230);
  image(modeBackButton, 40+420, 70); // top left button (Back)
  image(settingsUpButton, 370+420,180); // min up button
  image(settingsDownButton, 325+420,180); // min down button
  
  rect(170+420, 178, 150, 45);
  
  image(settingsUpButton, 370+420,230); // max up button
  image(settingsDownButton, 325+420,230); // max down button
  
  rect(170+420, 225, 150, 45);
  
  fill(0);
  textFont(f, 40);
  text("Range", 40+420, 170);
  text("Min", 60+420, 215);
  text(min, 170+420,215);
  text("Max", 60+420, 260);
  text(max, 170+420,260);
}

void drawSettingsPH(int min, int max){
  noStroke();
  
  fill(#ECF0F1, 240);
  rect(20,50,400,620);
  
  fill(#95A5A6, 230);
  image(modeBackButton, 40, 70); // top left button (Back)
  image(settingsUpButton, 370,180); // min up button
  image(settingsDownButton, 325,180); // min down button
  
  rect(170, 178, 150, 45);
  
  image(settingsUpButton, 370,230); // max up button
  image(settingsDownButton, 325,230); // max down button
  
  rect(170, 225, 150, 45);
  
  fill(0);
  textFont(f, 40);
  text("Range", 40, 170);
  text("Min", 60, 215);
  text(min, 170,215);
  text("Max", 60, 260);
  text(max, 170,260);
  
  
}

void drawAnalogPH(int value, int neededValue, int min, int max){   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(20, 50, 400, 620); // Background for the section
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(20, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(220, 270+30, 380, 380); // Main face
   
   ellipse(220, 580, 100, 100); // The required value Face
   
   image(upButton,310,545); // bottom right button (up)
   
   image(downButton,50, 545); // bottom left button (down)
   
   rect(40, 70, 40, 40, 7); // top left button (Settings)
   image(modeSettingsButton, 40,70);
   
   image(modeDigitalButton, 360,70); // top right button (mode)
   
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
   text(neededValue,207 + getNeededPos(neededValue),597);
   
   text("pH", 190, 95);
   translate(-15,15);
   DailPosPH(min, max);
   translate(15,-15);
   
}

void drawAnalogTemp(int value, int neededValue, int min, int max){
  noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(860-420, 50, 400, 620); // Background for the section
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(860-420, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(1060-420, 270+30, 380, 380); // Main face
   
   ellipse(1060-420, 580, 100, 100); // The required value Face
   
   image(upButton, 1150-420,545); // bottom right button (up)
   
   image(downButton, 890-420, 545); // bottom left button (down)
   
   rect(880-420, 70, 40, 40, 7); // top left button (settings)
   image(modeSettingsButton, 880-420,70);
   
   image(modeDigitalButton, 1200-420,70); // top right button (mode)

   // Create the Arc around the meter
   noFill();
   stroke(176);
   strokeWeight(20);
   strokeCap(SQUARE);
   arc(1060-420, 270+30, 360, 360, PI-0.8, 2*PI+0.8);
   
   // Creates the arrow on the dial
   noStroke();
   fill(0);
   translate(1060-420, 270+30);
   rotate(workOutPos(min, max, value));
   rect(0,0,10,190);
   
   rotate(-workOutPos(min, max, value));
   translate(-1060+420,-270-30);
   
   textFont(f,50);// Needed text render
   if (str(neededValue).length() == 4){
     textFont(f,42); 
   }
   text(neededValue,1050 -420 + getNeededPos(neededValue),598);
   
   text("Temperature", 500, 95);
   
   text("°C", 610, 460);
   translate(-15+420,15);
   DailPosPH(min, max);
   translate(15-420,-15);
}

void drawAnalogRPM(int value, int neededValue, int min, int max){//+840
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(860, 50, 400, 620); // Background for the section
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(860, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(1060, 270+30, 380, 380); // Main face
   
   ellipse(1060, 580, 100, 100); // The required value Face
   
   image(upButton, 1150,545); // bottom right button (up)
   
   image(downButton, 890, 545); // bottom left button (down)
   
   rect(880, 70, 40, 40, 7); // top left button (settings)
   image(modeSettingsButton, 880,70);
   
   image(modeDigitalButton, 1200,70); // top right button (mode)

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
   if (str(neededValue).length() == 4){
     textFont(f,42); 
   }
   text(neededValue,1050 + getNeededPos(neededValue),598);
   
   text("Stirring", 985, 95);
   
   text("RPM", 1000, 460);
   
   text("°C", 610, 460);
   translate(-20+840,5);
   DailPosRPM(min, max);
   translate(20-840,-5);

}

void drawDigitalPH(int value, int neededValue){
   
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(20, 50, 400, 620); // Background for the section
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(20, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(220, 270+30, 380, 380); // Main face
   
   ellipse(220, 580, 100, 100); // The required value Face
   
   image(upButton,310,545); // bottom right button (up)
   
   image(downButton,50, 545); // bottom left button (down)
   
   rect(40, 70, 40, 40, 7); // top left button (Settings)
   image(modeSettingsButton, 40,70);
   
   
   image(modeAnalogButton, 360,70); // top right button (mode)
   
   // Shows the temp value
   textFont(f,200);
   fill(0);
   text(value,170 + getDigitPos(value) ,330+30); // Actaul text render
   
   textFont(f,50);// Needed text render
   text(neededValue,207+ getNeededPos(neededValue),597);
   
   text("pH", 190, 95);
   
}

void drawDigitalTemp(int value, int neededValue, int min, int max){// + 420
   noStroke();
   
   if (value == neededValue){// Pick the colour for the BG
     fill(#28B463);
   }else{
     fill(#FF2D00);
   }
   
   rect(440, 50, 400, 620); // Background for the section
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(440, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(640, 270+30, 380, 380); // Main face
   
   ellipse(640, 580, 100, 100); // The required value Face
   
   image(upButton, 730, 545); // bottom right button (up)
   
   image(downButton, 470, 545); // bottom left button (down)
   
   rect(460, 70, 40, 40, 7); // top left button (settings)
   image(modeSettingsButton, 460,70);
   
   
   image(modeAnalogButton, 780,70); // top right button (mode)
   
   // Shows the temp value
   textFont(f,200);
   fill(0);
   text(value,605 + getDigitPos(value) ,330+30); // actual text render
   
   textFont(f,50);
   text(neededValue,630 + getNeededPos(neededValue),598); // needed text render
   
   text("Temperature", 500, 95);
   
   text("°C", 610, 460);
   
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
   
   fill(#ECF0F1, 40); // Opaque layer
   rect(860, 50, 400, 620); 
   
   fill(#95A5A6, 230);
   ellipse(1060, 270+30, 380, 380); // Main face
   
   ellipse(1060, 580, 100, 100); // The required value Face
   
   image(upButton, 1150,545); // bottom right button (up)
   
   image(downButton, 890, 545); // bottom left button (down)
   
   rect(880, 70, 40, 40, 7); // top left button (settings)
   image(modeSettingsButton, 880,70);
   
   image(modeAnalogButton, 1200,70); // top right button (mode)
   
   noStroke();
   textFont(f,200);
   fill(0);
   
   if (str(value).length() == 4){
     textFont(f,170);
   }
   
   text(value,1020 + getDigitPos(value) ,330+30); // Actual text render
   
   textFont(f,50);// Needed text render
   
   if (str(neededValue).length() == 4){
     textFont(f,42); 
   }
   text(neededValue,1050 + getNeededPos(neededValue),598);
   
   text("Stirring", 985, 95);
   
   text("RPM", 1000, 460);
}

float workOutPos(int min, int max, int current){
  // Returns the position of the arrow on analog face
  return ((maxAngle - minAngle)/(max-min))*(current-min)+0.8;
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
    pos = -155;
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
    pos = -40;
  }
  
  return pos;
}

void DailPosPH(int min, int max){
  int r = 145;
  int offsetX = 220;
  int offsetY = 300;
  int posX;
  int posY;
  float cAngle;
  for (int i = 0; i <= max-min; i++){
    posX = 0;
    posY = 0;
    cAngle = workOutPos(min, max, min+i);
    if (cAngle > PI/2 && cAngle <= PI){
      cAngle -= PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY -posY;
      posX = offsetX - posX;
    }else if (cAngle > PI && cAngle <= 3*PI/2){
      cAngle -= PI;
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY = offsetY -posY;
      posX = offsetX + posX;
    }else if (cAngle > 3*PI/2){
      cAngle -= 3*PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY +posY;
      posX = offsetX + posX;
    }else{
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY += offsetY;
      posX = offsetX - posX;
    }
    textFont(f,40);
    text(str(i+min),posX,posY);
  }
}

void DailPosTemp(int min, int max){
  int r = 145;
  int offsetX = 220;
  int offsetY = 300;
  int posX;
  int posY;
  float cAngle;
  for (int i = 0; i <= max-min; i++){
    posX = 0;
    posY = 0;
    cAngle = workOutPos(min, max, min+i);
    if (cAngle > PI/2 && cAngle <= PI){
      cAngle -= PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY -posY;
      posX = offsetX - posX;
    }else if (cAngle > PI && cAngle <= 3*PI/2){
      cAngle -= PI;
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY = offsetY -posY;
      posX = offsetX + posX;
    }else if (cAngle > 3*PI/2){
      cAngle -= 3*PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY +posY;
      posX = offsetX + posX;
    }else{
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY += offsetY;
      posX = offsetX - posX;
    }
    textFont(f,40);
    text(str(i+min),posX,posY);
  }
}

void DailPosRPM(int min, int max){
  int r = 145;
  int offsetX = 220;
  int offsetY = 300;
  int posX;
  int posY;
  float cAngle;
  for (int i = 0; i <= (max-min)/100; i++){
    posX = 0;
    posY = 0;
    cAngle = workOutPos(min, max, min+i*100);
    if (cAngle > PI/2 && cAngle <= PI){
      cAngle -= PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY -posY;
      posX = offsetX - posX;
    }else if (cAngle > PI && cAngle <= 3*PI/2){
      cAngle -= PI;
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY = offsetY -posY;
      posX = offsetX + posX;
    }else if (cAngle > 3*PI/2){
      cAngle -= 3*PI/2;
      posY = round(sin(cAngle) * r);
      posX = round(sqrt(sq(r)-sq(posY)));
      posY = offsetY +posY;
      posX = offsetX + posX;
    }else{
      posX = round(sin(cAngle) * r);
      posY = round(sqrt(sq(r)-sq(posX)));
      posY += offsetY;
      posX = offsetX - posX;
    }
    textFont(f,25);
    text(str(100*i+min),posX,posY);
  }
}

boolean fileExists(String filename) {

 File file = new File(filename);

 if(!file.exists()){
  return false;
 }
   
 return true;
}