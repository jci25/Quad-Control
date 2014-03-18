import ioio.lib.api.PulseInput;
import ioio.lib.api.PulseInput.PulseMode;
import ioio.lib.api.PwmOutput;
import ioio.lib.api.exception.ConnectionLostException;
import ioio.lib.util.BaseIOIOLooper;
import ioio.lib.util.IOIOLooper;
import ioio.lib.util.pc.IOIOConsoleApp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URI;

import org.java_websocket.drafts.Draft_17;


public class Mains extends IOIOConsoleApp  {
protected float c1, c2, c3, c4, c5;
Socket s;
ServerSocket ss;
	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("Main");
		new Mains().go(args);
	}

	@Override
	protected void run(String[] args) throws Exception {
		//set up the server
		System.out.println("Run");
		try{
			ExampleClient c = new ExampleClient(new URI("ws://tux64-14.cs.drexel.edu:8888/ws"), new Draft_17(), this);
			c.connect();
		}catch(Exception e){
			System.out.println("Accepted Error");
		}
		while(1 == 1){
			
		}
		
	}

	@Override
	public IOIOLooper createIOIOLooper(String arg0, Object arg1) {
		// TODO Auto-generated method stub
		return new BaseIOIOLooper() {
			PwmOutput ch1, ch2, ch3, ch4, ch5;
			
			int freq = 51;
			float low = (float) .053;
			float mid = (float) .074;
			float high = (float) .094;
			
			 @Override
			 protected void setup() throws ConnectionLostException,
			 InterruptedException {
			 // ... code to run when IOIO connects ...
				 PulseInput pulse = ioio_.openPulseInput(45, PulseMode.FREQ);
				 ch1 = ioio_.openPwmOutput(1, freq); //roll
				 ch2 = ioio_.openPwmOutput(2, freq); //pitch
				 ch3 = ioio_.openPwmOutput(3, freq); //throttle
				 ch4 = ioio_.openPwmOutput(4, freq); //yaw
				 ch5 = ioio_.openPwmOutput(5, freq); //mode
				 
				 c1 = mid;
				 c2 = mid;
				 c3 = low;
				 c4 = mid;
				 c5 = mid;
				 System.out.println("Setup");
				 
				 
			 }
			 
			 @Override
			 public void loop() throws ConnectionLostException,
			 		InterruptedException {
				 //System.out.println(c3);
				 ch1.setDutyCycle(c1);
				 ch2.setDutyCycle(c2);
				 ch3.setDutyCycle(c3);
				 ch4.setDutyCycle(c4);
				 ch5.setDutyCycle(c5);
				 //Thread.sleep(10);
			 }
			 
			 @Override
			 public void disconnected() {
			 	// ... code to run when IOIO is disconnected ...
				 System.out.println("Disconnected");
				 closeAll();
			 }
			 
			 private void closeAll() {
				ch1.close();
				ch2.close();
				ch3.close();
				ch4.close();
				ch5.close();
				
			}

			@Override
			 public void incompatible() {
			 	// ... code to run when a IOIO with an incompatible firmware
			 	// version is connected ...
				System.out.println("NOpe");
			 } 		
			 };
	}

}
