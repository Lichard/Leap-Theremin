import com.leapmotion.leap.*; //<>//
import java.net.InetAddress;

Controller controller = new Controller();

Vector h1 = new Vector();
Vector h2 = new Vector();
int f1, f2;
int handCount, fingerCount;
int time=0;
int oscFreq = 10; //how often to send OSC messages in millis
boolean h1e, h2e;

void setup() {
  size( 200, 200 );
  oscSetup();
}

void draw() {
  background(0);
  Frame frame = controller.frame();
  text( frame.hands().count() + " Hands", 50, 50 );

  fingerCount = 0;

  for (Finger f : frame.fingers()) {
    if (f.isExtended())
      fingerCount++;
  }

  text( fingerCount + " Fingers", 50, 100 );


  handCount = frame.hands().count();
  h1e=false;
  h2e=false;
 
  if ( millis() > time ) {
    time = millis()+oscFreq;
    int lfingers = 0;
    int rfingers = 0;

    for (Hand hand : frame.hands()) {
      if (hand.isLeft()) {
        for(Finger f: hand.fingers())
          if(f.isExtended())
            lfingers++;
        h1e=true;
        h1 = hand.palmPosition();
        f1 = lfingers;
      } else {
        for(Finger f: hand.fingers())
          if(f.isExtended())
            rfingers++;
        h2e=true;
        h2 = hand.palmPosition();
        f2 = rfingers;
      }
    }

    sendActiveOsc();
  }
}