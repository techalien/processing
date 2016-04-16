import processing.serial.*;
boolean firstContact = false;
Serial myPort;        // The serial port
int xPos1,xPos2,graph_offsetx1,step = 1,graph_offsety;
int graph_offsetx2;
// horizontal position of the graph
float inByte = 0;
float tempC,tempF,rh;

void setup () {
    size(800, 500);
  graph_offsetx1 = 45;
  xPos1 = graph_offsetx1;
  graph_offsetx2 = width/2 + 45;
  xPos2 = graph_offsetx2;
  // set the window size:


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
  text("Time",width/4,height-10);
  stroke(127, 34, 255);
  line(xPos1, height-20, xPos1, height - 2*tempC-graph_offsety);

  // at the edge of the screen, go back to the beginning:
  if (xPos1 >=( width/2 -5)) {
    xPos1 = graph_offsetx1;
    background(0);
  } else {
    // increment the horizontal position:
    xPos1+=step;
  }
  stroke(127, 34, 0);
  line(xPos1, height-20, xPos1, height - 2*tempF-graph_offsety);
  // at the edge of the screen, go back to the beginning:
  if (xPos1 >= ( width/2 -5)) {
    xPos1 = graph_offsetx1;
    background(0);
  } else {
    // increment the horizontal position:
    xPos1+=step;
  }
  text("rH",width/2,height - height/4);
  text("Time",width - width/4,height-10);
  stroke(127, 127, 127);
  line(xPos2, height-20, xPos2, height - 2*rh-graph_offsety);
  if (xPos2 >= ( width)) {
    xPos2 = graph_offsetx2;
    background(0);
  } else {
    // increment the horizontal position:
    xPos2+=step;
  }
  fill(0,0,0);
  rect(0,0,width,height/2);
  fill(127, 34, 255);
  text("Celcius:" + tempC+"^C",width/4,height/4);
  fill(127,34,0);
  text("Faren:" + tempF+"^F",width - width/4,height/4);
  fill(127,127,127);
  text("rH:" + rh+"%",width/2,height/2 - 10);
  delay(60000);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
 String inString = myPort.readStringUntil('\n');
 inString = trim(inString);
 String[] inList = split(inString," ");
  if (firstContact == false) {
    if (inString.equals("121")) {
      myPort.clear();    // clear the serial port buffer
      println("contact");
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');
      
    }
  }
  else {
    
    println("start");
    tempC = float(inList[1]);
    tempF=tempC * 1.8 + 32;
    rh = float(inList[0]);
    println(tempC);
    println(tempF);
    println("serial");
    delay(60000); 
    myPort.write('A');
    }
  }