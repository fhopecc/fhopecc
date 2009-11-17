package mras;
import java.util.*;
import org.apache.log4j.*;

public class MRASP {
  String source = "";
	String strtype = "";
	String usemed = "";
  boolean legal = false;
	List tokens = null;
	List data = null;
	List req_props=new ArrayList();
	Map props = new TreeMap(); // 用 TreeMap 是測試時，我必須預測屬性值對的順序，
	                           // 才能寫出預期字串
	Logger log = Logger.getLogger(this.getClass());

	public enum Type {
    UseMed, ReqProps, MedStatus, Legality, Invalid
	};

  public Type type;

  public MRASP(String src) {
    source = src;
		tokens = tokenize(source);
		parse(tokens);
	}
	public String getSource() {
		return source;
	}
	public List getTokens() {
		return tokens;
	}
  public boolean isLegal() {
    return legal;
	}

	public String getUsemed() {
		return usemed;
	}

	public void setReqProps(Iterator ireqprops) {
    req_props.clear();
		while(ireqprops.hasNext()) 
			req_props.add(ireqprops.next());
		type = Type.ReqProps;		
	}

	public void setLegality(boolean b) {
    type  = Type.Legality;
    legal = b;
	}

	List tokenize(String src) {
		 List toks = new ArrayList();
		 // st is splited by space char and space is not viewed as a token
		 // st2 by ',', st3 by ':', and the delimiters is viewed as a token
     StringTokenizer st = new StringTokenizer(src);
     while (st.hasMoreTokens()) {
			 String token = st.nextToken();
			 log.debug("token=" + token);
       StringTokenizer st2 = new StringTokenizer(token, ",", true); 
       while (st2.hasMoreTokens()) {
			   String token2 = st2.nextToken();
			   log.debug("token2=" + token2);
         StringTokenizer st3 = new StringTokenizer(token2, ":", true); 
         while (st3.hasMoreTokens()) {
			     String token3 = st3.nextToken();
			     log.debug("token3=" + token3);
					 toks.add(token3);
			   }
			 }
     }
		 return toks;
	}

	void parse(List toks) {
		log.debug("start parse");
		int cur_tok_pointer = 0;
    strtype=(String)toks.get(cur_tok_pointer);
		log.debug("strtype is " + strtype);
		cur_tok_pointer++;
		data=toks.subList(1, toks.size()-1);

		if(strtype.equals("usemed")) {
      usemed = (String)toks.get(cur_tok_pointer);
			type = Type.UseMed;
		}else if(strtype.equals("req_props")) {
      prop_list(toks, cur_tok_pointer);
			type = Type.ReqProps;
		}else if(strtype.equals("med_status")) {
		  log.debug("test log");
			type = Type.MedStatus;
      prop_val_pair_list(toks, cur_tok_pointer);
		}else if(strtype.equals("legality")) {
			legal = toks.get(cur_tok_pointer).equals("true");
			type = Type.Legality;
		}else {
			type = Type.Invalid;
		}
	}

	int prop_list(List toks, int cur_tok_pointer) {
    req_props.add(toks.get(cur_tok_pointer));
		cur_tok_pointer++;
		if(cur_tok_pointer >= toks.size()) return -1;
    if(toks.get(cur_tok_pointer).equals(",")) {
			cur_tok_pointer++;
			cur_tok_pointer = prop_list(toks, cur_tok_pointer);
		}
		return cur_tok_pointer;
  }


	int prop_val_pair_list(List toks, int cur_tok_pointer) {
		log.debug("test log2");
    cur_tok_pointer = prop_val_pair(toks, cur_tok_pointer);
		if(cur_tok_pointer >= toks.size()) return -1;
    if(toks.get(cur_tok_pointer).equals(",")) {
			cur_tok_pointer++;
			cur_tok_pointer = prop_val_pair_list(toks, cur_tok_pointer);
	  }
		return cur_tok_pointer;
  }

	int prop_val_pair(List toks, int cur_tok_pointer) {
    String prop =(String)toks.get(cur_tok_pointer);
		log.debug("prop=#{prop}");
	  cur_tok_pointer += 2;
    String val = (String)toks.get(cur_tok_pointer);
		log.debug("val=#{val}");
		props.put(prop, val);
		cur_tok_pointer += 1;
		return cur_tok_pointer;
	}

  /* 
	 * sample message:
	 * "usemed 制酸劑"
	 * "req_props 用法,限制天數,疾病"
	 * "med_status 用法:口服,限制天數:13,疾病:疝氣"
	 * "legality true"
	 */
	public String toString() {
    switch(type) {
			case UseMed:
				return "usemed "+usemed;
			case ReqProps:
				String s=""; // string to store the req props string 
				Iterator ps = req_props.iterator();
				while(ps.hasNext()) {
					String t = ps.next().toString();
					if(ps.hasNext()) 
					  s += t + ",";
					else
					  s += t; 
				}
				return "req_props " + s;
			case MedStatus:
				s="";
				Iterator ks = props.keySet().iterator();
				while(ks.hasNext()) {
          String k = ks.next().toString();
					if(ks.hasNext())
						s += k + ":" + props.get(k).toString() + ",";
					else
						s += k + ":" + props.get(k).toString();
				}
				return "med_status " + s;
			case Legality:
				return "legality " + (isLegal()?"true":"false");
		}
		return null;
	}

}
