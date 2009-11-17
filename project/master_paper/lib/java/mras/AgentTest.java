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
    String propuri = "�s��ϥΤѼƤp��";
		OntProperty p = agent.getNumberProperyByLocalName(propuri);
		assertEquals(base + propuri.replaceAll("�j��|�p��|����",""), p.getURI());
	}

  public void testGetOntProperty() {
		String lpn = "��O����";// local property name
    OntProperty p = agent.getOntPropertyByLocalName(lpn);
		assertEquals(base + "��O����", p.toString());
		assertEquals(base + "�Ī�", p.getRange().toString());
	}

  public void testGetRequireProperties() {
		String medlurl="�D���T�J�ܵo�������`�g��";
    List proplist = new ArrayList();
		String strprops = "";
    for(Iterator i=agent.getRequireProperties(medlurl).iterator();i.hasNext();) {
			String propurl=(String)i.next();
			proplist.add(propurl);
			strprops+=propurl + ",";
		}
		assertTrue(proplist.contains("��O����"));
		assertTrue(proplist.contains("�w���e�f"));
		assertTrue(proplist.contains("�f�w�౵�����Ī��Ϊk"));
		assertTrue(proplist.contains("�s��ϥΤѼ�"));
	}

  public void testCheckNumberRangeRestriction() {
		try {
		  String str = "med_status ��O����:�D���T�J�ܵo�������`�g��" +
	  		         ",�w���e�f:����,�f�w�౵�����Ī��Ϊk:�`�g";
      Individual id = agent.createMedStatIndividualByMRASString(str);
		  assertFalse(agent.checkValid("�D���T�J�ܵo�������`�g��",id));
		  fail("���ӥ�X ValueNotFoundException �ҥ~�A�]���S���ݩ�[�s��ϥΤѼ�]");
		}catch (ValueNotFoundException e) {
			log.warn(e.getMessage());
		}

		String str = "med_status ��O����:�D���T�J�ܵo�������`�g��" +
	  		  ",�w���e�f:����,�f�w�౵�����Ī��Ϊk:�`�g" +
					",�s��ϥΤѼ�:4";
    Individual id = agent.createMedStatIndividualByMRASString(str);
		assertTrue(agent.checkValid("�D���T�J�ܵo�������`�g��",id));

		str = "med_status ��O����:�D���T�J�ܵo�������`�g��" +
	  		  ",�w���e�f:����,�f�w�౵�����Ī��Ϊk:�`�g" +
					",�s��ϥΤѼ�:7";
    id = agent.createMedStatIndividualByMRASString(str);
		assertFalse(agent.checkValid("�D���T�J�ܵo�������`�g��",id));
	}

	// I should find a way to test the property, 
	// The ontology object will not be destroyed, 
	// and the following assertions failed for
	// read the property the upper code set.
  /*
	public void testCreateMedStatIndividualByPVMap() {
		String str = "med_status ��O����:�D���T�J�ܵo�������`�g��," +
			           "�w���e�f:��ʤW�I�l�D�P�V,�f�w�౵�����Ī��Ϊk:�`�g";
    MRAS mras = new MRAS(str);
    Individual id = agent.createMedStatIndividualByPVMap(mras.props);
		assertEquals(base+"�������A:1", id.getURI());
		for(StmtIterator i=id.listProperties();i.hasNext();) {
      Statement stat = i.nextStatement();
			String propurl = stat.getPredicate().toString();
			String valurl = stat.getResource().toString();
			if(propurl.equals(base+"��O����")) {
			  assertEquals(base + "�D���T�J�ܵo�������`�g��:4",valurl);
		} else if(propurl.equals(base+"�w���e�f")) {
			  assertEquals(base + "��ʤW�I�l�D�P�V:3",valurl);
		  } else if(propurl.equals(base+"�f�w�౵�����Ī��Ϊk")) {
			  assertEquals(base + "�`�g:2",valurl);
			}
		}
	}
	*/
}
