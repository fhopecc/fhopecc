package mras;
import com.hp.hpl.jena.ontology.*;
import com.hp.hpl.jena.util.iterator.*;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;

/*
 * 給屬性限制類別使用，
 * 若傳入的個案缺乏屬性限制類別需要的屬性值，
 * 則會丟出此例外。
 * fhopecc modified at 2006-12-27
 */
public class ValueNotFoundException extends RuntimeException {
	OntProperty onProp;
	Individual individual;
  public ValueNotFoundException(Individual id, OntProperty prop) {
		super("個案["+id+"]的屬性["+prop.getURI() + "]值找不到，請補上屬性值！"); 
		individual = id;
		onProp = prop;
	}
	public OntProperty getOnProperty() {
		return onProp;
	}
	public Individual getIndividual() {
		return individual;
	}
}
