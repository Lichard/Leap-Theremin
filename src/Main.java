import java.io.File;
import java.io.IOException;
import java.lang.Math;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.State;
import javax.sound.sampled.*;

class SampleListener extends Listener {
	public AudioInputStream audioInputStream;
	public FloatControl gainControl;

	public void onInit(Controller controller) {
		System.out.println("Initialized");
	}

	public void onConnect(Controller controller) {
		System.out.println("Connected");
		try {
			audioInputStream = AudioSystem.getAudioInputStream(new File(
					"th06_05.wav"));
		} catch (UnsupportedAudioFileException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Clip clip;
		try {
			clip = AudioSystem.getClip();
			clip.open(audioInputStream);
			gainControl = (FloatControl) clip
					.getControl(FloatControl.Type.MASTER_GAIN);
			System.out.println(gainControl.getMaximum() + "   "
					+ gainControl.getMinimum());

			clip.start();
		} catch (LineUnavailableException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void onDisconnect(Controller controller) {
		System.out.println("Disconnected");
	}

	public void onExit(Controller controller) {
		System.out.println("Exited");
	}

	public void onFrame(Controller controller) {
		// Get the most recent frame and report some basic information

		Frame frame = controller.frame();
		float h;
		if (!frame.hands().empty()) {
			Hand hand = frame.hands().get(0);
			FingerList fingers = hand.fingers();
			if (!fingers.empty()) {
				// Calculate the hand's average finger tip position
				Vector avgPos = Vector.zero();
				for (Finger finger : fingers) {
					avgPos = avgPos.plus(finger.tipPosition());
				}
				h = avgPos.divide(fingers.count()).getY();
				h = (h-50)/500;
				h = (float) Math.min(Math.max(h, 0), 1);
				h = (float) (30*Math.log10(h));
				gainControl.setValue(h);
				System.out.println(hand.palmPosition().getY() + "   " + h);
			}
		}
	}
}

public class Main {
	public static void main(String[] args) {
		// Create a sample listener and controller
		SampleListener listener = new SampleListener();
		Controller controller = new Controller();

		// Have the sample listener receive events from the controller
		controller.addListener(listener);

		// Keep this process running until Enter is pressed
		System.out.println("Press Enter to quit...");
		try {
			System.in.read();
		} catch (IOException e) {
			e.printStackTrace();
		}

		// Remove the sample listener when done
		controller.removeListener(listener);
	}
}