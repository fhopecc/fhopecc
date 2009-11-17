package mras;
import java.net.*;
import java.util.*;
import java.io.*;
import org.apache.log4j.*;

public class Server {
	static Logger log = Logger.getLogger("MRAS Server");
  static boolean listening = true;
  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = null;
    try {
      serverSocket = new ServerSocket(1729);
			log.info("server start in port 1729!");
			
    } catch (IOException e) {
      log.error("Could not listen on port: 1729.");
      System.exit(-1);
    }
    while (listening)
	    new MRASThread(serverSocket.accept()).start();

    serverSocket.close();
		log.info("server close!");
    System.exit(0);
  }
}

class MRASThread extends Thread {
  private Socket socket=null;
	Logger log = Logger.getLogger(this.getClass());
  Agent agent = null;
	final String onturl = "public/owls/NHIMedRule.rdf-xml.owl";

	public MRASThread(Socket socket) {
		super("MRASThread");
		this.socket=socket;
		agent=new Agent(onturl);
		log.info("服務"+this.toString()+"啟動成功");
		log.info("健保法規知識庫:" + onturl + "載入成功");
	}

	public void run() {
		try {
			PrintWriter out=new PrintWriter(socket.getOutputStream(), true);
			BufferedReader in = new BufferedReader(
					                  new InputStreamReader(
															socket.getInputStream()));
		  out.println("hello MRAS");	
		  log.info("送出 hello 封包");
			String inputLine, outputLine;

			while((inputLine = in.readLine()) != null) {
				if(inputLine.equals("bye")) break;
				MRASP mrasp = new MRASP(inputLine);
				switch (mrasp.type) {
					case UseMed:
            Set properties = agent.getRequireProperties(mrasp.getUsemed());
						mrasp.setReqProps(properties.iterator());
			      outputLine = mrasp.toString();
						break;
					case MedStatus:
            mrasp.setLegality(agent.checkValid(mrasp.props));
			      outputLine = mrasp.toString();
						break;
					default:
            outputLine = mrasp.getSource();
				}
				
				log.debug(outputLine);
				out.println(outputLine);
			}
      //MedRuleAgentServer.listening = false; // every thread can stop the server
			                                      // regradless other
																						// running thread
			out.close();
			in.close();
			socket.close();
			log.info("server closed.");
		} catch (Exception e) {
	    e.printStackTrace();
		}
  }

}
