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

Integer neededRPM = 0;
Integer neededPH = 0;
Integer neededTemp = 0;

void setup() {
  
  size(1280, 720);
  
  f = createFont("Arial",16,true);
  myPort = new Serial(this, Serial.list()[1], 9600);
}

void draw(){
  background(255, 204, 0);
  
  getValue();
  
  if (stateRPM == 0){ // Shows analog PH
    drawAnalogPH(currentPH, neededPH);
  }
  
  if (stateTemp == 0){ // Shows digital Temperature
  
    drawDigitalTemp(currentTemp, neededTemp);
  }
  
  if (stateRPM == 0){ // Shows analog RPM
    drawAnalogRPM(currentRPM, neededRPM);
  } 
  
}

void getValue(){
  if (myPort.available() > 0){ // if the porst is empty
    String str = myPort.readString(); // Reads the serail value
    if (str.charAt(0) == 'a' && str.charAt(str.length()-1) == 'a'){
      println(str);
    }
  }
}

void updateValues(){
  
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
   text(neededValue,210,598);
   
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
   ellipse(1060, 270, 380, 380); // Main face
   
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
   arc(1060, 270, 360, 360, PI-0.8, 2*PI+0.8);
   
   // Creates the arrow on the dial
   noStroke();
   fill(0);
   translate(1060, 270);
   rotate(workOutPos(min, max, value));
   rect(0,0,10,190);
   
   rotate(-workOutPos(min, max, value));
   translate(-1060,-270);
   
   textFont(f,50);// Needed text render
   text(neededValue,1060,598);

}

void drawDigitalPH(){
  
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
   ellipse(640, 270, 380, 380); // Main face
   
   fill(#F1C40F);
   ellipse(640, 580, 100, 100); // The required value Face
   
   rect(470, 545, 80, 80, 7);//bottom left button
   
   rect(730, 545, 80, 80, 7);// bottom right button
   
   rect(780, 70, 40, 40, 7); // top left button (settings)
   
   rect(460, 70, 40, 40, 7); // top right button (mode)
   
   // Shows the temp value
   textFont(f,200);
   fill(0);
   text(value,530,330);
   
   textFont(f,50);
   text(neededValue,610,598);
   
}

void drawDigitalRPM(){
  
}

float workOutPos(float min, float max, int current){
  // Returns the position of the arrow on analog face
  return ((maxAngle - minAngle)/(max-min))*current+0.8;
}