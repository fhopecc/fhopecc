package mras;
import java.util.*;
import java.io.*;
import com.hp.hpl.jena.ontology.*;
import com.hp.hpl.jena.util.iterator.*;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;
import org.apache.log4j.*;

/*
 * Number Property 指的是數值屬性
 * <p>
 * Number Range Property 指的是數值屬性的區間限制
 * <p>
 * 兩者 uri 命名慣例是相關的，數值區間屬性為一數值屬性名稱後置
 * 「大於」、「小於」及「等於」字元，其 BNF 如下：
 * <p>
 * <nrp_uri>     ::= <np_uri><nrp_postfix>
 * <p>
 * <nrp_postfix> ::= "大於"|"等於"|"小於"
 * <p>
 * getNumberPropery 會依其傳入的數值區間屬性本地名(local name)，
 * 傳回其對應的數值屬性
 * <p>
 * nrpuri2npuri 會把數值區間屬性的uri轉成對應的數值屬性 uri
 * <p>
 * 利用代理人建立醫療狀態個案時，若無法產生獨一無二的個案 uri，
 * 則個案加入的屬性值會不斷累積，
 * 而本推理機每次只讀個案第一個屬性值，
 * 故建立幾次有相同屬性的個案便會產生錯誤。
 * 一開始是使用 private class field $id 每次建立個案時遞增 $id，
 * 來求得個案的獨有序號，但似乎失效，
 * 因為重啟代理人會重設 $id 序號。
 * 現在改以目前時間的內部長整數表示來取代 $id，
 * 時間是一個自然的全域序號，不是嗎？
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
	 * 使用 java.util.Date#getTime() 取代 $id 的序號功能。
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
	 * 傳回目前時間的長整數表示作為個案序號
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
				cls.listSuperClasses().filterKeep(getLocalNameFilter("醫療狀態限制"));
      //System.out.println("superclass of "+cls.toString()+":"+cls.getLocalName());
			if(superClasses.hasNext()) {
			  //OntClass supercls=(OntClass)superClasses.next();
        //System.out.println(">>class:"+cls.toString());
				/*
				if(supercls.getLocalName() != null) {
				  if(supercls.getLocalName().equals("醫療狀態限制")) {
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
    return nrpuri.replaceAll("大於|小於|等於", "");
	}
	// create a individual by property:value map
	public Individual createMedStatIndividualByPVMap(Map pvmap) {
    OntClass clsMedStat=ontology.createClass(base+"醫療狀態");
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

	// 判斷傳入的醫療狀態是否合法(individual is med status)
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
    return checkValid((String)props.get("醫令用藥"), id);
	}

  // classification engine
	// 測試個案 id 是否屬於類別 cls
	public boolean checkClass(OntClass cls, Individual id) {
		String clsurl = cls.toString();
		String idurl = id.toString();
		if(cls==null) {log.debug("類別["+ clsurl+"]為 null,驗證失敗!"); return false;}
		if(cls.isComplementClass()) {
			ComplementClass cc=cls.asComplementClass();
			for(Iterator i=cc.listOperands();i.hasNext();) {
				OntClass c=(OntClass)i.next();
			  if(checkClass(c, id)){
			    log.debug(idurl + "與互補類別:"+c+"相容，歸屬失敗!");
				 	return false;	
				}
			  log.debug(idurl + "與互補類別:"+c+"相斥，歸屬通過!");
			}
			return true;
		}else if(cls.isIntersectionClass()) {
			IntersectionClass ic=cls.asIntersectionClass();
			for(Iterator i=ic.listOperands();i.hasNext();) {
        OntClass c=(OntClass)i.next();
				if(!checkClass(c, id)){
					log.debug(idurl + "與交集類別:"+c+"相斥，歸屬失敗！");
					return false;
				}
				log.debug(idurl + "與交集類別:"+c+"相容，歸屬通過！");
			}
		}else if(cls.isUnionClass()) {
			UnionClass uc=cls.asUnionClass();
			for(Iterator i=uc.listOperands();i.hasNext();) {
        OntClass c=(OntClass)i.next();
				if(checkClass(c, id)){
			    log.debug(idurl +"與聯集類別:"+c+"相容，歸屬通過!");
					return true;
				}
			  log.debug(idurl + "聯集類別:"+c+"相斥，歸屬失敗!");
			}
		}else if(cls.isEnumeratedClass()) {
			EnumeratedClass ec=cls.asEnumeratedClass();
			if(ec.hasOneOf(id)) {
			  log.debug(idurl+ "在列舉類別:"+ec+"中，歸屬通過！");
				return true;
			}
			log.debug(idurl+"不在列舉類別:"+ec+"中，歸屬失敗");
      return false;
		}else if(cls.isRestriction()) {
			Restriction r=cls.asRestriction();
			return checkRestriction(r, id);
		}

		String idrdftype = id.getRDFType().toString();
		if(id.hasRDFType(cls)) {
			log.debug(idurl+"的 RDF 型態:"+idrdftype+"與類別 url:"+clsurl
					+"相等，歸屬通過！");
		 	return true;
		}
	  log.debug(idurl+"的 RDF 型態:"+idrdftype+"與類別 url:"+clsurl
					+"不相等，歸屬失敗！");

		for(Iterator i=cls.listSuperClasses();i.hasNext();) {
			OntClass c=(OntClass)i.next();
			String curl = c.toString();
			if(id.hasRDFType(c)){
			  log.debug(idurl+"的 RDF 型態:"+idrdftype+"與超類別 url:"+curl
					+"相等，歸屬通過！");
			 	return true;
			}
			log.debug(idurl+"的 RDF 型態:"+idrdftype+"與超類別 url:"+curl
					+"不相等，歸屬失敗！");
		}
	  log.debug(idurl + "未歸屬到任一類別，失敗!");
		return false;
	}
	public RDFNode getPropertyValue(Individual id, OntProperty prop) {
			OntProperty num_range = ontology.getOntProperty(base+"數值區間限制屬性");
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
			log.error("個案["+id+"]未給予屬性["+prop+"]的值，無法判斷!");
			throw new ValueNotFoundException(id, prop);
		}

		String rurl = r.toString();
		String idurl = id.toString();
		String propurl = prop.toString();
    String valurl = value.toString();

		if(r.isAllValuesFromRestriction()) {
			AllValuesFromRestriction avf=r.asAllValuesFromRestriction();
			log.debug(idurl + "屬性["+prop+"]的值為["+id.getPropertyValue(prop)+"] "
					+(checkAllValuesFromRestriction(avf, id)?"符合":"不符")
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
			OntProperty num_range = ontology.getOntProperty(base+"數值區間限制屬性");
			OntProperty range = ontology.getOntProperty(base+"區間限制屬性");
			if(p.hasSuperProperty(num_range, false)) {
        return checkNumberRangeRestriction(hvr, id);
			}
			if(p.hasSuperProperty(range, false)) {
        return checkRangeRestriction(hvr, id);
			}
			//log.debug(p + " has value of " + hvr.getHasValue());
			log.debug("has vlue 驗證:"+hvr.hasValue(id));

			log.debug(idurl + "屬性["+prop+"]的值為["+id.getPropertyValue(prop)+"] "
					+(hvr.hasValue(id)?"符合":"不符")
					+" hasValue ["+hvr.getHasValue()+"] ");
			return  hvr.hasValue(id);
			/*
		}else if(r.isCardinalityRestriction()) {
			CardinalityRestriction cr=r.asCardinalityRestriction();
			log.debug(cr.getOnProperty() + " cardinality=" + cr.getCardinality());
			*/
		}
		log.debug(idurl+ "屬性: "+ propurl + "其值：" + valurl + "不符限制" + rurl +
				 "，歸屬失敗");
		return false;
	}
	public boolean checkRangeRestriction(HasValueRestriction hvr, Individual id) {
		OntProperty prop = hvr.getOnProperty();
		//log.debug(idurl + "屬性["+prop+"]的值為["+id.getPropertyValue(prop)+"] "
		//			+(hvr.hasValue(id)?"符合":"不符")
		//			+" hasValue ["+hvr.getHasValue()+"] ");
		log.debug("區間限制未實作，驗證通過！");
		return true;
	}
	public boolean checkNumberRangeRestriction(HasValueRestriction hvr, Individual id) {
		OntProperty nrp = hvr.getOnProperty();
		OntProperty np = ontology.getOntProperty(nrpuri2npuri(nrp.getURI()));
    int value = ((Literal)id.getPropertyValue(np)).getInt();
		int hasValue = ((Literal)hvr.getHasValue()).getInt();
		OntProperty gtp = getOntPropertyByLocalName("值大於");
		OntProperty ltp = getOntPropertyByLocalName("值小於");
    if(nrp.hasSuperProperty(gtp, false)) {
		  log.warn(id+"."+np+"="+value+" restriction on "+nrp+" > "+hasValue);
      if(value > hasValue) return true; 
		} else if(nrp.hasSuperProperty(ltp, false)) {
		  log.warn(id+"."+np+"="+value+" restriction on "+nrp+" < "+hasValue);
      if(value < hasValue) return true; 
		}
		log.warn(id+"."+np+"="+value+" restriction on "+nrp+" = "+hasValue);
    if(value == hasValue) return true; 
		log.warn("歸屬失敗!");
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
	// 列出一顆藥的 Restrictions
	public Iterator getRestrictionsByMed(String medname) {
		List result=new ArrayList();
    OntClass clsMed=ontology.createClass(base+medname);
		OntProperty useMed=ontology.getOntProperty(base+"醫令用藥");
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
	// 列出一顆藥的受限屬性
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
		      OntProperty nrp = getOntPropertyByLocalName("數值區間限制屬性");
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
  // 列出一顆藥所有的 restriction
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
      "?reqprop rdfs:subPropertyOf base:數值區間限制屬性 . "+
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
