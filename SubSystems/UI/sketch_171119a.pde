import processing.serial.*;

Serial myPort;// The serial port from which the data will be recieved

PFont f;

Boolean analogPH = true;
Boolean analogRPM = true;

Boolean graphPH = false;
Boolean graphTemp = false;
Boolean graphRPM = false;

Integer currentPH = 0;

void setup() {
  
  size(1280, 720);
  
  f = createFont("Arial",16,true);
  //myPort = new Serial(this, Serial.list()[3], 4800);
}

void draw(){
  background(255, 204, 0);
  
  if (analogPH == true && graphPH == false){ // Shows analog PH
    drawAnalogPH();
  }
  
  if (graphTemp == false){ // Shows digital Temperature
  
    drawDigitalTemp();
  }
  
  if (analogRPM == true && graphRPM == false){ // Shows analog RPM
    drawAnalogRPM();
  }
  
}

void getValue(){
  
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

void drawAnalogPH(){
  /*This is to be used as a template*/
  
   noStroke();
   fill(#CCFFAA);
   rect(20, 50, 400, 620);
   
   fill(#F1C40F);
   ellipse(220, 270, 380, 380);
   
   ellipse(220, 580, 100, 100);
   
   rect(50, 545, 80, 80, 7);//bottom left button
   
   rect(310, 545, 80, 80, 7);// bottom right button
   
   rect(360, 70, 40, 40, 7); // top left button (settings)
   
   rect(40, 70, 40, 40, 7); // top right button (mode)
   
   noFill();
   stroke(176);
   strokeWeight(20);
   strokeCap(SQUARE);
   arc(220, 270, 360, 360, PI-0.8, 2*PI+0.8);
}

void drawAnalogRPM(){//+840
   noStroke();
   fill(#CCFFAA);
   rect(860, 50, 400, 620);
   
   fill(#F1C40F);
   ellipse(1060, 270, 380, 380);
   
   fill(#F1C40F);
   ellipse(1060, 580, 100, 100);
   
   rect(890, 545, 80, 80, 7);//bottom left button
   
   rect(1150, 545, 80, 80, 7);// bottom right button
   
   rect(1200, 70, 40, 40, 7); // top left button (settings)
   
   rect(880, 70, 40, 40, 7); // top right button (mode)
   
   noFill();
   stroke(176);
   strokeWeight(20);
   strokeCap(SQUARE);
   arc(1060, 270, 360, 360, PI-0.8, 2*PI+0.8);
  
}

void drawDigitalPH(){
  
}

void drawDigitalTemp(){// + 420
   noStroke();
   fill(#CCFFAA);
   rect(440, 50, 400, 620);
   
   fill(#F1C40F);
   ellipse(640, 270, 380, 380);
   
   fill(#F1C40F);
   ellipse(640, 580, 100, 100);
   
   rect(470, 545, 80, 80, 7);//bottom left button
   
   rect(730, 545, 80, 80, 7);// bottom right button
   
   rect(780, 70, 40, 40, 7); // top left button (settings)
   
   rect(460, 70, 40, 40, 7); // top right button (mode)
   
  textFont(f,200);
  fill(0); 
  text(currentPH,640,270); 
   
}

void drawDigitalRPM(){
  
}