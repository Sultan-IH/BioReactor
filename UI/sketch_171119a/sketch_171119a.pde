void setup() {
  size(1280, 720);
  background(255, 204, 0);
}

void draw(){
  drawAnalogPH();
  drawDigitalTemp();
  drawAnalogRPM();
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
   
   fill(#F1C40F);
   ellipse(220, 580, 100, 100);
   
   rect(50, 545, 80, 80, 7);//bottom left button
   
   rect(310, 545, 80, 80, 7);// bottom right button
   
   rect(360, 70, 40, 40, 7); // top left button (settings)
   
   rect(40, 70, 40, 40, 7); // top right button (mode)
}

void drawAnalogRPM(){
   noStroke();
   fill(#CCFFAA);
   rect(860, 50, 400, 620);
  
}

void drawDigitalPH(){
  
}

void drawDigitalTemp(){
   noStroke();
   fill(#CCFFAA);
   rect(440, 50, 400, 620);
}

void drawDigitalRPM(){
  
}