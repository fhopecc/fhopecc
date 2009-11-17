package mras;
import java.util.*;
import junit.framework.*;
import org.apache.log4j.*;

public class MRASPTest extends TestCase {
	Logger log;

  public MRASPTest(String name) {
		super(name);
	}

	public void testTokens() {
		String str = "med_status ノ猭:狝,ぱ计:13,痚痜:";
    MRASP mras = new MRASP(str);

		// the following is equal ruby code: mras.tokens.join('-') 
		Iterator tokens = mras.getTokens().iterator(); 
    String joinstr="";
		if(tokens.hasNext()) {
      joinstr = (String)tokens.next(); 
		}
		while(tokens.hasNext()) {
      joinstr += "-" + (String)tokens.next(); 
		}
		assertEquals("med_status-ノ猭-:-狝-,-ぱ计-:-13-,-痚痜-:-", joinstr);
	}

  public void test_usemed() {
		String str = "usemed 荒警";
    MRASP mras = new MRASP(str);

		assertEquals(MRASP.Type.UseMed, mras.type);
		assertEquals("荒警", mras.getUsemed());
	}
  
  public void test_req_props() {
		String str = "req_props ノ猭,ぱ计,痚痜";
    MRASP mras = new MRASP(str);

		assertEquals(MRASP.Type.ReqProps, mras.type);

    // equlas ruby code: mras.req_props.join("-")
    String joinstr="";
		Iterator req_props = mras.req_props.iterator();
		if(req_props.hasNext()) {
      joinstr = (String)req_props.next(); 
		}
		while(req_props.hasNext()) {
      joinstr += "-" + (String)req_props.next(); 
		}
		assertEquals("ノ猭-ぱ计-痚痜", joinstr);
	}

  public void test_medstatus() {
		String str = "med_status ノ猭:狝,ぱ计:13,痚痜:";
    MRASP mras = new MRASP(str);
		assertEquals(MRASP.Type.MedStatus, mras.type);
		assertEquals("狝", mras.props.get("ノ猭"));
		assertEquals("13", mras.props.get("ぱ计")); 
		assertEquals("", mras.props.get("痚痜")); 
	}

  public void test_legality() {
		String str = "legality true";
    MRASP mras = new MRASP(str);
		assertEquals(MRASP.Type.Legality, mras.type);
		assertTrue(mras.isLegal());
	}
	public void testToString() {
		String str = "usemed 荒警";
    MRASP mras = new MRASP(str);
		assertEquals(str, mras.toString());

		str = "req_props ノ猭,ぱ计,痚痜";
    mras = new MRASP(str);
		assertEquals(str, mras.toString());

    str = "med_status ノ猭:狝,痚痜:,ぱ计:13";
    mras = new MRASP(str);
		assertEquals(str, mras.toString());

		str = "legality true";
    mras = new MRASP(str);
		assertEquals(str, mras.toString());
	}
  public void testInvalid() {
		String str = "invalid message";
		MRASP mras = new MRASP(str);
		assertEquals(MRASP.Type.Invalid, mras.type);
		assertEquals(str, mras.getSource());
	}

}
