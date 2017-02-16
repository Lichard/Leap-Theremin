import oscP5.*;
import netP5.*;

String ipNumber = "127.0.0.1";
int sendPort = 7110;
int receivePort = 33333;
OscP5 oscP5;
NetAddress myRemoteLocation;

void oscSetup() {
  oscP5 = new OscP5(this, receivePort);
  myRemoteLocation = new NetAddress(ipNumber, sendPort);
}

void oscTester() {
  OscMessage myMessage;
  myMessage = new OscMessage("/test");
  float testData = random(1);
  myMessage.add(testData);
  oscP5.send(myMessage, myRemoteLocation);
}

void sendActiveOsc() {
  OscMessage active;
  OscMessage hand1;
  OscMessage hand2;
  try {
    active = new OscMessage("/active");
    hand1 = new OscMessage("/hand1");
    hand2 = new OscMessage("/hand2");
    active.add(handCount);
    active.add(fingerCount);

    hand1.add(h1.getX());
    hand1.add(h1.getY());
    hand1.add(h1.getZ());
    hand1.add(f1);

    hand2.add(h2.getX());
    hand2.add(h2.getY());
    hand2.add(h2.getZ());
    hand2.add(f2);

    oscP5.send(active, myRemoteLocation);
    if(h1e)
      oscP5.send(hand1, myRemoteLocation);
    if(h2e)
      oscP5.send(hand2, myRemoteLocation);
    active.print();
    hand1.print();
    hand2.print();
  }
  catch(Exception e) {
    println("Exception:" + e.getMessage()); //<>// //<>// //<>// //<>//
    e.printStackTrace();
  }
} 