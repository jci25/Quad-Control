import ioio.lib.api.PulseInput;
import ioio.lib.api.PwmOutput;
import ioio.lib.api.PulseInput.PulseMode;
import ioio.lib.api.exception.ConnectionLostException;
import ioio.lib.util.BaseIOIOLooper;
import ioio.lib.util.IOIOLooper;

import java.net.URI;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_17;
import org.java_websocket.handshake.ServerHandshake;


public class ExampleClient extends WebSocketClient {

	Mains otg;
		public ExampleClient( URI serverUri , Draft draft ) {
			super( serverUri, draft );
		}

		public ExampleClient( URI serverURI, Draft_17 draft_17, Mains mains ) {
			super( serverURI );
			otg = mains;
		}

		@Override
		public void onOpen( ServerHandshake handshakedata ) {
			System.out.println( "opened connection" );
			this.send("Add Joes RPI");
			// otg = new IOIO(null);
			// if you plan to refuse connection based on ip or httpfields overload: onWebsocketHandshakeReceivedAsClient
		}

		@Override
		public void onMessage( String message ) {
			String[] pwm = message.split(" ");
			System.out.println(message);
			if(pwm.length == 5){
				if(Math.abs(otg.c1 - Float.parseFloat(pwm[0])) > .001){
					otg.c1 = Float.parseFloat(pwm[0]);
				}
				if(Math.abs(otg.c2 - Float.parseFloat(pwm[1])) > .001){
					otg.c2 = Float.parseFloat(pwm[1]);
				}
				if(Math.abs(otg.c3 - Float.parseFloat(pwm[2])) > .001){
					otg.c3 = Float.parseFloat(pwm[2]);
				}
				if(Math.abs(otg.c4 - Float.parseFloat(pwm[3])) > .001){
					otg.c4 = Float.parseFloat(pwm[3]);
				}
				if(Math.abs(otg.c5 - Float.parseFloat(pwm[4])) > .001){
					otg.c5 = Float.parseFloat(pwm[4]);
				}
				
			}
		}
		
		@Override
		public void onClose( int code, String reason, boolean remote ) {
			// The codecodes are documented in class org.java_websocket.framing.CloseFrame
			System.out.println( "Connection closed by " + ( remote ? "remote peer" : "us" ) );
		}

		@Override
		public void onError( Exception ex ) {
			ex.printStackTrace();
			// if the error is fatal then onClose will be called additionally
		}

		

}