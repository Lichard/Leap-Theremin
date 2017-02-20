import com.leapmotion.leap.*; //<>//
import java.net.InetAddress;
import controlP5.*;

com.leapmotion.leap.Controller controller = new com.leapmotion.leap.Controller();
ControlP5 controlp5;


Vector h1 = new Vector();
Vector h2 = new Vector();
int f1, f2;
int handCount, fingerCount;
int time=0;
int oscFreq = 2; //how often to send OSC messages in millis
boolean h1e, h2e;
boolean sendOSCOnFist = false;

void setup() {
  size( 200, 400 );
  oscSetup();

  controlp5 = new ControlP5(this);
  // parameters : name, default value (float), x, y,  width, height
  controlp5.addNumberbox("OSC Freq", 2, 50, 150, 60, 14);
}

void draw() {
  background(0);
  Frame frame = controller.frame();
  text( frame.hands().count() + " Hands", 50, 50 );
  text( numFingers(frame) + " Fingers", 50, 100 );

  handCount = frame.hands().count();
  h1e=false;
  h2e=false;

  if ( millis() > time ) {
    time = millis()+oscFreq;

    for (Hand hand : frame.hands()) {
      if (hand.isLeft()) {
        h1e=true;
        h1 = hand.palmPosition();
        f1 = numFingers(hand.fingers());
      } else {
        h2e=true;
        h2 = hand.palmPosition();
        f2 = numFingers(hand.fingers());
      }
    }
    sendActiveOsc();
  }
}

void controlEvent(ControlEvent event) {
  if (event.isController()) {
    println("event from: " + event.getController().getName());
    if (event.getController().getName()=="OSC Freq") {
      int val = (int)event.getController().getValue();
      if(val <1){
       event.getController().setValueLabel("1");
       val = 1;
      }
      oscFreq = val;
    }
  }
}

//---------------------------Helpers
int numFingers(FingerList fl) {
  int fingers=0;
  for (Finger f : fl) {
    if (f.isExtended())
      fingers++;
  }
  return fingers;
}

int numFingers(Frame fr) {
  int fingers=0;
  for (Finger f : fr.fingers()) {
    if (f.isExtended())
      fingers++;
  }
  return fingers;
}