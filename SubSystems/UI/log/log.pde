import processing.serial.*;

String COM_PORT = "/dev/ttyACM0"; // Port name
String FILENAME = "log.csv";

Serial port;
float brightness = 0;
PrintWriter output;
boolean writing = false;
boolean setup;
boolean startRecording = false;
boolean cannotConnect = false;
String cannotConnectReason = "";
int time;
String newdata;

float pulsing = 1;

void setup() {
  size(640,480);
  output = createWriter(FILENAME);
  setup = true;
}

void draw() {
  background(writing?0:brightness,writing?brightness*3:0,0);
  if(setup) {
    brightness += pulsing;
    if(brightness > 48)
      pulsing = -0.5;
    else if(brightness <= 0)
      pulsing = 1;
  } else if(writing) {
     brightness = 8;
  }

  if(writing && startRecording) {
     textSize(16);
     text("Writing serial data", 10, 30);
     text(newdata, 10,50);
     text("Press ENTER to stop recording", 10, 130);
  } else if(writing && !startRecording) {
     textSize(16);
     text("Waiting for the START signal", 10, 30);
     text("Or press SHIFT to start recording now", 10, 130);
  } else if(setup) {
     textSize(16);
     text("Waiting for MSP430...", 8, 30);
     textSize(12);
     text("Press SHIFT to start recording", 8, 50);
     text("Connecting to "+COM_PORT, 16, 72);
     text("Serial Devices Found", 16, 200);
     //Help to find the correct port
     for(int i=0;i<Serial.list().length;i++) {
        if(Serial.list()[i].equals(COM_PORT)) {
           connectToComPort();
        }
        textSize(10);
        text(Serial.list()[i], 24, 220+14*i);
        if(cannotConnect) {
           text(cannotConnectReason, 16, 96);
        }
     }
  } else if(!cannotConnect) {
      background(0,0,24);
      textSize(16);
      text("Download Complete", 8, 30);
  }
  textSize(10);
  text("Writing to log.csv", 300, 468);
}

void serialEvent (Serial port) {
  newdata = port.readString();
  print(newdata);
  if(newdata.indexOf("FINISHED") >= 0 && startRecording && !cannotConnect) {
    //print("Finished printing");
     writing = false;
  } else if(newdata.indexOf("START") >= 0 && !cannotConnect) {
       print("Found START");
       startRecording = true;
  } else if(startRecording && !cannotConnect) {
    writing = true;
    //print("Still printing: "+temperature);
    output.print(newdata);
  } else if(!startRecording && !cannotConnect) {
     writing = true;
  }
}
void keyPressed() {
  if(keyCode == ENTER || keyCode == RETURN) {
    finish();
  } else if(keyCode == SHIFT) {
    if(setup)
      connectToComPort();
    //Let's also start recording immediately
    startRecording = true;
  } else if(key >= '0' && key <= '9') {
     COM_PORT = COM_PORT + key;
  } else if(keyCode == BACKSPACE || keyCode == DELETE) {
     COM_PORT = "COM";
     cannotConnect = false;
  }
}
void connectToComPort() {
   try {
    port = new Serial(this, COM_PORT, 4800);
    // select the COM port shown below in the energia IDE
    port.bufferUntil('\n');
    setup = false;
    output = createWriter(FILENAME);
   } catch(Exception e) {
      cannotConnect = true;
      writing = false;
      startRecording = false;
      setup = true;
      cannotConnectReason = e.getMessage();
      print(cannotConnectReason);
   }
}
void finish() {
    writing = false;
    output.flush();
    output.close();
    exit();
}