class AuditTrail < ActiveRecord::Base
  #self.abstract_class = true
  establish_connection "hltb_development" 
  #establish_connection "eltud"
	
  set_table_name 'audit_trails'
end 
