import processing.serial.*;
boolean firstContact = false;
Serial myPort;        // The serial port
int xPos,graph_offsetx = 45,step = 1,graph_offsety;         // horizontal position of the graph
float inByte = 0;
float tempC,tempF;

void setup () {
  xPos = graph_offsetx;
  // set the window size:
  size(800, 500);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
}
void draw () {
  // draw the line:
  fill(255,255,255);
  text("Temp",0,height - height/4);
  text("Time",width/2,height-10);
  stroke(127, 34, 255);
  line(xPos, height-20, xPos, height - 2*tempC-graph_offsety);

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = graph_offsetx;
    background(0);
  } else {
    // increment the horizontal position:
    xPos+=step;
  }
  stroke(127, 34, 0);
  line(xPos, height-20, xPos, height - 2*tempF-graph_offsety);
  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = graph_offsetx;
    background(0);
  } else {
    // increment the horizontal position:
    xPos+=step;
  }
  fill(0,0,0);
  rect(0,0,width,height/2);
  fill(127, 34, 255);
  text("Celcius:" + tempC,width/4,height/4);
  fill(127,34,0);
  text("Faren:" + tempF,width - width/4,height/4);
  delay(1000);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
 String inString = myPort.readStringUntil('\n');
 inString = trim(inString);
 inByte = float(inString);
  if (firstContact == false) {
    if (inString.equals("121")) {
      myPort.clear();    // clear the serial port buffer
      println("contact");
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    tempC = inByte;
    tempF=tempC * 1.8 + 32;
    println(tempC);
    println(tempF);
    println("serial");
    delay(1000); 
    myPort.write('A');
    }
  }