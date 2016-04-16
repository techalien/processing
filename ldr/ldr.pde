import processing.serial.*;
boolean firstContact = false;
Serial myPort;        // The serial port
         // horizontal position of the graph
int inByte = 0;
int intensity;

void setup () {
  // set the window size:
  size(800, 500);

 
  myPort = new Serial(this, Serial.list()[0], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
}
void draw () {
  int temp = intensity/4;
  background(temp,32,64);
  text("Intensity:"+intensity,width/2,height/2);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
 String inString = myPort.readStringUntil('\n');
 inString = trim(inString);
 inByte = int(inString);
  if (firstContact == false) {
    if (inString.equals("121")) {
      myPort.clear();    // clear the serial port buffer
      println("contact");
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    intensity = inByte;
    println(intensity);
    println("serial");
    delay(100); 
    myPort.write('A'); //Write anything to serial port to initiate a data read.
    }
  }
