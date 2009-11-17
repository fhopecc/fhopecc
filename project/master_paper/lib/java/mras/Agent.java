package mras;
import java.util.*;
import java.io.*;
import com.hp.hpl.jena.ontology.*;
import com.hp.hpl.jena.util.iterator.*;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;
import org.apache.log4j.*;

/*
 * Number Property �����O�ƭ��ݩ�
 * <p>
 * Number Range Property �����O�ƭ��ݩʪ��϶�����
 * <p>
 * ��� uri �R�W�D�ҬO�������A�ƭȰ϶��ݩʬ��@�ƭ��ݩʦW�٫�m
 * �u�j��v�B�u�p��v�Ρu����v�r���A�� BNF �p�U�G
 * <p>
 * <nrp_uri>     ::= <np_uri><nrp_postfix>
 * <p>
 * <nrp_postfix> ::= "�j��"|"����"|"�p��"
 * <p>
 * getNumberPropery �|�̨�ǤJ���ƭȰ϶��ݩʥ��a�W(local name)�A
 * �Ǧ^��������ƭ��ݩ�
 * <p>
 * nrpuri2npuri �|��ƭȰ϶��ݩʪ�uri�ন�������ƭ��ݩ� uri
 * <p>
 * �Q�ΥN�z�H�إ��������A�Ӯ׮ɡA�Y�L�k���ͿW�@�L�G���Ӯ� uri�A
 * �h�Ӯץ[�J���ݩʭȷ|���_�ֿn�A
 * �ӥ����z���C���uŪ�ӮײĤ@���ݩʭȡA
 * �G�إߴX�����ۦP�ݩʪ��Ӯ׫K�|���Ϳ��~�C
 * �@�}�l�O�ϥ� private class field $id �C���إ߭Ӯ׮ɻ��W $id�A
 * �ӨD�o�Ӯת��W���Ǹ��A�����G���ġA
 * �]�����ҥN�z�H�|���] $id �Ǹ��C
 * �{�b��H�ثe�ɶ�����������ƪ�ܨӨ��N $id�A
 * �ɶ��O�@�Ӧ۵M������Ǹ��A���O�ܡH
 * <p>
 * fhopecc modified at 2007-01-03
 *
 * @author fhopecc
 * @version 1.0
 * @see java.util.Date#getTime()
 *
 */
public class Agent {
	/*
	 * �ϥ� java.util.Date#getTime() ���N $id ���Ǹ��\��C
	 *
	 * @deprecated
   * @see java.util.Date#getTime()
	 * @see #getSeq()
	 */
	int $id = 1;
	OntModel ontology;
  Logger log=Logger.getLogger(this.getClass());
	String base="http://www.stut.edu.tw/NHIMedRule.owl#";
  final static String GET_REQUIRED_STATUS = "get_required_status";
  final static String KMED = "med";

	/*
	 * �Ǧ^�ثe�ɶ�������ƪ�ܧ@���ӮקǸ�
	 *
	 * @see #$id
	 */
	private long getSeq() {
		return new Date().getTime();
	}

  public Agent(String ontURL) {
    OntDocumentManager dm = OntDocumentManager.getInstance();
    ontology = dm.getOntology(ontURL, OntModelSpec.OWL_DL_MEM_TRANS_INF);
	}

	public OntModel getOntology() {
		return ontology;
	}
  
	// list all classes is subclass of med rule
	public Iterator listRules() {
		ExtendedIterator classes = getOntology().listNamedClasses();
		ArrayList ruleClasses = new ArrayList();
		while(classes.hasNext()) {
			OntClass cls=(OntClass)classes.next();
			ExtendedIterator superClasses = 
				cls.listSuperClasses().filterKeep(getLocalNameFilter("�������A����"));
      //System.out.println("superclass of "+cls.toString()+":"+cls.getLocalName());
			if(superClasses.hasNext()) {
			  //OntClass supercls=(OntClass)superClasses.next();
        //System.out.println(">>class:"+cls.toString());
				/*
				if(supercls.getLocalName() != null) {
				  if(supercls.getLocalName().equals("�������A����")) {
					  ruleClasses.add(cls);
            //System.out.println("add "+cls.getLocalName());
					}
				}
				*/
				ruleClasses.add(cls);
			}
		}
		return ruleClasses.iterator();
	}

	public OntClass getRule(String medName) {
    Iterator rules=listRules();
		
    while(rules.hasNext()) {
      OntClass cls=(OntClass)rules.next();
			//Iterator properties
		}
		return null;
	}
  
	public Filter getLocalNameFilter(final String localName) {
		return new Filter() { 
      public boolean accept(Object o) {
        if(o instanceof OntClass) {
			  	OntClass c=(OntClass)o;
			  	if(c.getLocalName() != null) {
            return c.getLocalName().equals(localName);
				  }
			  }
			  return false;
		  }
		};
	}

	public String nrpuri2npuri(String nrpuri) {
    return nrpuri.replaceAll("�j��|�p��|����", "");
	}
	// create a individual by property:value map
	public Individual createMedStatIndividualByPVMap(Map pvmap) {
    OntClass clsMedStat=ontology.createClass(base+"�������A");
		Individual ms=ontology.createIndividual(clsMedStat+":"+getSeq(), clsMedStat);
    $id++;
		Iterator ps = pvmap.keySet().iterator();
		while(ps.hasNext()) {
			String p = (String)ps.next(); // property name
			String v = (String)pvmap.get(p); // value class name
		  OntProperty prop=getOntPropertyByLocalName(p);
			log.info("create indvidual:p is"+p+"v is"+v);
			if(prop.isDatatypeProperty()) {
		    ms.addProperty(prop, v);
				log.fatal(prop.getRange());
				log.fatal(ms.getPropertyValue(prop));
				log.fatal(ms.getPropertyValue(prop).isLiteral()?"literal":"nonliteral");
				log.fatal("val:"+((Literal)ms.getPropertyValue(prop)).getInt());
			  $id++;
			} else {
        OntClass valCls=ontology.createClass(base+v);
		    Individual valIns=ontology.createIndividual(valCls+":"+getSeq(), valCls);
			  $id++;
			  log.info("create indvidual:prop is"+p +"valIns is"+v);
		    ms.addProperty(prop, valIns);
			}
		}
		return ms;
	}
	public Individual createMedStatIndividualByMRASString(String strMras) {
    MRASP mrasp = new MRASP(strMras);
    return createMedStatIndividualByPVMap(mrasp.props);
	}
	//lpropname: local property name
	public OntProperty getOntPropertyByLocalName(String lpropname) {
		log.debug("lpropname = " + lpropname);
		OntProperty prop=ontology.getOntProperty(base+lpropname);
		return prop;
	}

	// �P�_�ǤJ���������A�O�_�X�k(individual is med status)
	// medcls: the name reference the med class
  public boolean checkValid(String medcls, Individual id){
		boolean res=true;
		for(Iterator i=getRestrictionsByMed(medcls);i.hasNext();) {
			OntClass cls=(OntClass) i.next();
			res=res && checkClass(cls, id);
		}
		return res;
	}

	public boolean checkValid(Map props) {
    Individual id = createMedStatIndividualByPVMap(props);
    return checkValid((String)props.get("��O����"), id);
	}

  // classification engine
	// ���խӮ� id �O�_�ݩ����O cls
	public boolean checkClass(OntClass cls, Individual id) {
		String clsurl = cls.toString();
		String idurl = id.toString();
		if(cls==null) {log.debug("���O["+ clsurl+"]�� null,���ҥ���!"); return false;}
		if(cls.isComplementClass()) {
			ComplementClass cc=cls.asComplementClass();
			for(Iterator i=cc.listOperands();i.hasNext();) {
				OntClass c=(OntClass)i.next();
			  if(checkClass(c, id)){
			    log.debug(idurl + "�P�������O:"+c+"�ۮe�A�k�ݥ���!");
				 	return false;	
				}
			  log.debug(idurl + "�P�������O:"+c+"�ۥ��A�k�ݳq�L!");
			}
			return true;
		}else if(cls.isIntersectionClass()) {
			IntersectionClass ic=cls.asIntersectionClass();
			for(Iterator i=ic.listOperands();i.hasNext();) {
        OntClass c=(OntClass)i.next();
				if(!checkClass(c, id)){
					log.debug(idurl + "�P�涰���O:"+c+"�ۥ��A�k�ݥ��ѡI");
					return false;
				}
				log.debug(idurl + "�P�涰���O:"+c+"�ۮe�A�k�ݳq�L�I");
			}
		}else if(cls.isUnionClass()) {
			UnionClass uc=cls.asUnionClass();
			for(Iterator i=uc.listOperands();i.hasNext();) {
        OntClass c=(OntClass)i.next();
				if(checkClass(c, id)){
			    log.debug(idurl +"�P�p�����O:"+c+"�ۮe�A�k�ݳq�L!");
					return true;
				}
			  log.debug(idurl + "�p�����O:"+c+"�ۥ��A�k�ݥ���!");
			}
		}else if(cls.isEnumeratedClass()) {
			EnumeratedClass ec=cls.asEnumeratedClass();
			if(ec.hasOneOf(id)) {
			  log.debug(idurl+ "�b�C�|���O:"+ec+"���A�k�ݳq�L�I");
				return true;
			}
			log.debug(idurl+"���b�C�|���O:"+ec+"���A�k�ݥ���");
      return false;
		}else if(cls.isRestriction()) {
			Restriction r=cls.asRestriction();
			return checkRestriction(r, id);
		}

		String idrdftype = id.getRDFType().toString();
		if(id.hasRDFType(cls)) {
			log.debug(idurl+"�� RDF ���A:"+idrdftype+"�P���O url:"+clsurl
					+"�۵��A�k�ݳq�L�I");
		 	return true;
		}
	  log.debug(idurl+"�� RDF ���A:"+idrdftype+"�P���O url:"+clsurl
					+"���۵��A�k�ݥ��ѡI");

		for(Iterator i=cls.listSuperClasses();i.hasNext();) {
			OntClass c=(OntClass)i.next();
			String curl = c.toString();
			if(id.hasRDFType(c)){
			  log.debug(idurl+"�� RDF ���A:"+idrdftype+"�P�W���O url:"+curl
					+"�۵��A�k�ݳq�L�I");
			 	return true;
			}
			log.debug(idurl+"�� RDF ���A:"+idrdftype+"�P�W���O url:"+curl
					+"���۵��A�k�ݥ��ѡI");
		}
	  log.debug(idurl + "���k�ݨ���@���O�A����!");
		return false;
	}
	public RDFNode getPropertyValue(Individual id, OntProperty prop) {
			OntProperty num_range = ontology.getOntProperty(base+"�ƭȰ϶������ݩ�");
			if(prop.hasSuperProperty(num_range, false)) {
		    OntProperty np = ontology.getOntProperty(nrpuri2npuri(prop.getURI()));
				return id.getPropertyValue(np);
			}
			return id.getPropertyValue(prop);
	}
	// check restriction
  public boolean checkRestriction(Restriction r, Individual id){
		OntProperty prop = r.getOnProperty();
		RDFNode value = getPropertyValue(id, prop);

		if(value == null) {
			log.error("�Ӯ�["+id+"]�������ݩ�["+prop+"]���ȡA�L�k�P�_!");
			throw new ValueNotFoundException(id, prop);
		}

		String rurl = r.toString();
		String idurl = id.toString();
		String propurl = prop.toString();
    String valurl = value.toString();

		if(r.isAllValuesFromRestriction()) {
			AllValuesFromRestriction avf=r.asAllValuesFromRestriction();
			log.debug(idurl + "�ݩ�["+prop+"]���Ȭ�["+id.getPropertyValue(prop)+"] "
					+(checkAllValuesFromRestriction(avf, id)?"�ŦX":"����")
					+"all value from ["+avf.getAllValuesFrom()+"] ");
		  return checkAllValuesFromRestriction(avf, id);
		/*
		}else if(r.isSomeValuesFromRestriction()) {
			SomeValuesFromRestriction svf = r.asSomeValuesFromRestriction();
			log.debug(svf.getOnProperty() + " some value from " + svf.getSomeValuesFrom());
		*/
		}else if(r.isHasValueRestriction()) {
			HasValueRestriction hvr=r.asHasValueRestriction();
			OntProperty p = hvr.getOnProperty();
			OntProperty num_range = ontology.getOntProperty(base+"�ƭȰ϶������ݩ�");
			OntProperty range = ontology.getOntProperty(base+"�϶������ݩ�");
			if(p.hasSuperProperty(num_range, false)) {
        return checkNumberRangeRestriction(hvr, id);
			}
			if(p.hasSuperProperty(range, false)) {
        return checkRangeRestriction(hvr, id);
			}
			//log.debug(p + " has value of " + hvr.getHasValue());
			log.debug("has vlue ����:"+hvr.hasValue(id));

			log.debug(idurl + "�ݩ�["+prop+"]���Ȭ�["+id.getPropertyValue(prop)+"] "
					+(hvr.hasValue(id)?"�ŦX":"����")
					+" hasValue ["+hvr.getHasValue()+"] ");
			return  hvr.hasValue(id);
			/*
		}else if(r.isCardinalityRestriction()) {
			CardinalityRestriction cr=r.asCardinalityRestriction();
			log.debug(cr.getOnProperty() + " cardinality=" + cr.getCardinality());
			*/
		}
		log.debug(idurl+ "�ݩ�: "+ propurl + "��ȡG" + valurl + "���ŭ���" + rurl +
				 "�A�k�ݥ���");
		return false;
	}
	public boolean checkRangeRestriction(HasValueRestriction hvr, Individual id) {
		OntProperty prop = hvr.getOnProperty();
		//log.debug(idurl + "�ݩ�["+prop+"]���Ȭ�["+id.getPropertyValue(prop)+"] "
		//			+(hvr.hasValue(id)?"�ŦX":"����")
		//			+" hasValue ["+hvr.getHasValue()+"] ");
		log.debug("�϶������@�A���ҳq�L�I");
		return true;
	}
	public boolean checkNumberRangeRestriction(HasValueRestriction hvr, Individual id) {
		OntProperty nrp = hvr.getOnProperty();
		OntProperty np = ontology.getOntProperty(nrpuri2npuri(nrp.getURI()));
    int value = ((Literal)id.getPropertyValue(np)).getInt();
		int hasValue = ((Literal)hvr.getHasValue()).getInt();
		OntProperty gtp = getOntPropertyByLocalName("�Ȥj��");
		OntProperty ltp = getOntPropertyByLocalName("�Ȥp��");
    if(nrp.hasSuperProperty(gtp, false)) {
		  log.warn(id+"."+np+"="+value+" restriction on "+nrp+" > "+hasValue);
      if(value > hasValue) return true; 
		} else if(nrp.hasSuperProperty(ltp, false)) {
		  log.warn(id+"."+np+"="+value+" restriction on "+nrp+" < "+hasValue);
      if(value < hasValue) return true; 
		}
		log.warn(id+"."+np+"="+value+" restriction on "+nrp+" = "+hasValue);
    if(value == hasValue) return true; 
		log.warn("�k�ݥ���!");
		return false;
	}
	public OntProperty getNumberProperyByLocalName(String lnrpuri) {
    return getOntPropertyByLocalName(nrpuri2npuri(lnrpuri));
	}
	//check avf
  public boolean checkAllValuesFromRestriction(AllValuesFromRestriction avf, Individual id){
    OntProperty p = avf.getOnProperty();
		
		if(!id.hasProperty(p)) return false;
		if(p.isDatatypeProperty()) {
			Resource cons=avf.getAllValuesFrom();//retrieve the constraints
		  OntResource value=(OntResource)id.getPropertyValue(p);
			return value.hasRDFType(cons);
		}else if(p.isObjectProperty()) {
			OntClass cons=(OntClass)avf.getAllValuesFrom();//retrieve the constraints
			Individual value=ontology.getIndividual(id.getPropertyValue(p).toString());
			//Individual value=or.asIndividual();
			return checkClass(cons, value);
		}
		return false;
	}
	// �C�X�@���Ī� Restrictions
	public Iterator getRestrictionsByMed(String medname) {
		List result=new ArrayList();
    OntClass clsMed=ontology.createClass(base+medname);
		OntProperty useMed=ontology.getOntProperty(base+"��O����");
		// restrions.onProperty=useMed and useMed.allValueFrom = medName
		List avfMed=new ArrayList();
		for(Iterator rs=ontology.listRestrictions();rs.hasNext();) {
			Restriction r=(Restriction)rs.next();
			if(r.onProperty(useMed)) {
				AllValuesFromRestriction avf= r.asAllValuesFromRestriction();
        if(avf.hasAllValuesFrom(clsMed))
				  avfMed.add(r);
			}
		}
		// subclasses of above restrictions 
		List resClses=new ArrayList();
		for(Iterator cls=avfMed.iterator();cls.hasNext();) {
      OntClass c=(OntClass)cls.next();
			for(Iterator i=c.listSubClasses();i.hasNext();) 
				resClses.add(i.next());
		}
		// super restriction class of above class
		List rests=new ArrayList();
		for(Iterator i=resClses.iterator();i.hasNext();) {
      OntClass c=(OntClass)i.next();
			for(Iterator j=c.listSuperClasses();j.hasNext();) {
        OntClass r=(OntClass)j.next();
        if(r.isRestriction())
				  rests.add(r.asRestriction());	
			}
		}
		return rests.iterator();
	}
	// �C�X�@���Ī������ݩ�
  public Set getRequireProperties(String med) {
		HashSet reqprops=null;
    String queryString = "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> " +
			"prefix base: <http://www.stut.edu.tw/NHIMedRule.owl#>" +
			"prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
			"prefix owl: <http://www.w3.org/2002/07/owl#>" +
      "SELECT ?prop " +
      "WHERE { "+
      "?t owl:allValuesFrom base:"+med+" . "+
      "?c rdfs:subClassOf ?t . "+
      "?c rdfs:subClassOf ?restrict . "+
      "?restrict rdf:type owl:Restriction . "+
			"?restrict owl:onProperty ?prop . " +
      "}"
      ;
    Query query = QueryFactory.create(queryString) ;
    QueryExecution qexec = QueryExecutionFactory.create(query, ontology) ;
    try {
      ResultSet results = qexec.execSelect() ;
      reqprops=new HashSet();
      for (;results.hasNext();)
      {
        QuerySolution soln = results.nextSolution() ;
        Resource r = soln.getResource("prop") ; 
				/*
				if(r instanceof DatatypeProperty) {
					DatatypeProperty d = (DatatypeProperty)r;
					log.warn(">>>>>>>d " + d);
		      OntProperty nrp = getOntPropertyByLocalName("�ƭȰ϶������ݩ�");
					log.warn(">>>>>>nrp " + nrp);
          if(d.hasSuperProperty(nrp, false)) {
            reqprops.add(nrpuri2npuri(d.getLocalName()));
					}
				} else {
				*/
				  reqprops.add(nrpuri2npuri(r.getLocalName()));
					/*
				}
				*/
      }
    } finally { qexec.close() ; return reqprops;}
	}
  // �C�X�@���ĩҦ��� restriction
  public Iterator listRestrictionsByMed(String med) {
		HashSet restrictions=null;
    String queryString = "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> " +
			"prefix base: <http://www.stut.edu.tw/NHIMedRule.owl#>" +
			"prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
			"prefix owl: <http://www.w3.org/2002/07/owl#>" +
      "SELECT ?restrict " +
      "WHERE { "+
      "?m owl:allValuesFrom base:"+med+" . "+
      "?c rdfs:subClassOf ?m . "+
      "?c rdfs:subClassOf ?restrict . "+
      "?restrict rdf:type owl:Restriction . "+
      "}"
      ;
    Query query = QueryFactory.create(queryString) ;
    QueryExecution qexec = QueryExecutionFactory.create(query, ontology) ;
    try {
      ResultSet results = qexec.execSelect() ;
      restrictions=new HashSet();
      for (;results.hasNext();)
      {
        QuerySolution soln = results.nextSolution() ;
        Resource r = soln.getResource("restrict") ; 
        if(r instanceof Restriction)
				  restrictions.add((Restriction)r);
      }
    } finally { qexec.close() ; return restrictions.iterator();}
	}
  public Set getRangeProperties(String med){
		HashSet reqprops=null;
    String queryString = "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> " +
			"prefix base: <http://www.stut.edu.tw/NHIMedRule.owl#>" +
			"prefix owl: <http://www.w3.org/2002/07/owl#>" +
      "SELECT ?reqprop " +
      "WHERE { "+
      "?reqprop rdfs:subPropertyOf base:�ƭȰ϶������ݩ� . "+
      "?reqprop rdfs:domain ?d . "+
      "?t owl:allValuesFrom base:"+med+" . "+
      "?c rdfs:subClassOf ?t . "+
      "?c rdfs:subClassOf ?d . "+
      "}"
      ;
    Query query = QueryFactory.create(queryString) ;
    QueryExecution qexec = QueryExecutionFactory.create(query, ontology) ;
    try {
      ResultSet results = qexec.execSelect() ;
      reqprops=new HashSet();
      for (;results.hasNext();)
      {
        QuerySolution soln = results.nextSolution() ;
        Resource r = soln.getResource("reqprop") ; 
				//System.out.println(":"+r.toString());
				reqprops.add(r.toString());
      }
    } finally { qexec.close() ; return reqprops;}

	}
}
