package mras;
import java.util.*;
import junit.framework.*;
import com.hp.hpl.jena.ontology.*;
import com.hp.hpl.jena.util.iterator.*;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;
import org.apache.log4j.*;

public class AgentTest extends TestCase {
	Logger log = Logger.getLogger(this.getClass());
	final String onturl = "NHIMedRule.rdf-xml.owl";
  String base="http://www.stut.edu.tw/NHIMedRule.owl#";
  Agent agent=null;
  public AgentTest(String name) {
		super(name);
	}
  protected void setUp() {
		agent=new Agent(onturl);
	}
	protected void tearDown() {
		agent = null;
		System.gc();
	}

  public void testGetNumberPropery() {
    String propuri = "連續使用天數小於";
		OntProperty p = agent.getNumberProperyByLocalName(propuri);
		assertEquals(base + propuri.replaceAll("大於|小於|等於",""), p.getURI());
	}

  public void testGetOntProperty() {
		String lpn = "醫令用藥";// local property name
    OntProperty p = agent.getOntPropertyByLocalName(lpn);
		assertEquals(base + "醫令用藥", p.toString());
		assertEquals(base + "藥物", p.getRange().toString());
	}

  public void testGetRequireProperties() {
		String medlurl="非類固醇抗發炎劑之注射劑";
    List proplist = new ArrayList();
		String strprops = "";
    for(Iterator i=agent.getRequireProperties(medlurl).iterator();i.hasNext();) {
			String propurl=(String)i.next();
			proplist.add(propurl);
			strprops+=propurl + ",";
		}
		assertTrue(proplist.contains("醫令用藥"));
		assertTrue(proplist.contains("患有疾病"));
		assertTrue(proplist.contains("病患能接受的藥物用法"));
		assertTrue(proplist.contains("連續使用天數"));
	}

  public void testCheckNumberRangeRestriction() {
		try {
		  String str = "med_status 醫令用藥:非類固醇抗發炎劑之注射劑" +
	  		         ",患有疾病:中風,病患能接受的藥物用法:注射";
      Individual id = agent.createMedStatIndividualByMRASString(str);
		  assertFalse(agent.checkValid("非類固醇抗發炎劑之注射劑",id));
		  fail("應該丟出 ValueNotFoundException 例外，因為沒有屬性[連續使用天數]");
		}catch (ValueNotFoundException e) {
			log.warn(e.getMessage());
		}

		String str = "med_status 醫令用藥:非類固醇抗發炎劑之注射劑" +
	  		  ",患有疾病:中風,病患能接受的藥物用法:注射" +
					",連續使用天數:4";
    Individual id = agent.createMedStatIndividualByMRASString(str);
		assertTrue(agent.checkValid("非類固醇抗發炎劑之注射劑",id));

		str = "med_status 醫令用藥:非類固醇抗發炎劑之注射劑" +
	  		  ",患有疾病:中風,病患能接受的藥物用法:注射" +
					",連續使用天數:7";
    id = agent.createMedStatIndividualByMRASString(str);
		assertFalse(agent.checkValid("非類固醇抗發炎劑之注射劑",id));
	}

	// I should find a way to test the property, 
	// The ontology object will not be destroyed, 
	// and the following assertions failed for
	// read the property the upper code set.
  /*
	public void testCreateMedStatIndividualByPVMap() {
		String str = "med_status 醫令用藥:非類固醇抗發炎劑之注射劑," +
			           "患有疾病:急性上呼吸道感染,病患能接受的藥物用法:注射";
    MRAS mras = new MRAS(str);
    Individual id = agent.createMedStatIndividualByPVMap(mras.props);
		assertEquals(base+"醫療狀態:1", id.getURI());
		for(StmtIterator i=id.listProperties();i.hasNext();) {
      Statement stat = i.nextStatement();
			String propurl = stat.getPredicate().toString();
			String valurl = stat.getResource().toString();
			if(propurl.equals(base+"醫令用藥")) {
			  assertEquals(base + "非類固醇抗發炎劑之注射劑:4",valurl);
		} else if(propurl.equals(base+"患有疾病")) {
			  assertEquals(base + "急性上呼吸道感染:3",valurl);
		  } else if(propurl.equals(base+"病患能接受的藥物用法")) {
			  assertEquals(base + "注射:2",valurl);
			}
		}
	}
	*/
}
