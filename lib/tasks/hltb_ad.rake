require 'net/ldap'
require "pp"

OAD = Net::LDAP.new :host => "hltb.gov.tw", 
					:port => 389, 
					:auth => {
		                :method => :simple, 
									  :username => "ccl00695", 
									  :password => "btmw222$" }
OADBase = "dc=hltb,dc=gov,dc=tw" 

def add_user user, temp_user 
	filter = Net::LDAP::Filter.eq("cn", "ccl00695") 
	OAD.search ( :base => OADBase, :filter => filter) do |entry| 
     puts entry.attrbute_names
		 puts entry.class.name
		 puts entry.dn
		 puts entry.methods.join("\n")
		 
		 #entry.get_attrs.each do |a|
		#	 puts entry.send a
		#	 puts entry.send a
		# end
     #ops = [
     #  [:replace, :sn, 'ccl']
     #]

     #ldap.modify :dn => entry.dn, :operations => ops
		 #File.open 'log\ldap.log', 'w' do |t|
		 #end

	end
end

task :add_user do
  add_user "khc05655", "hhj00981"
end

task :ad_test do

	filter = Net::LDAP::Filter.eq("cn", "ccl00695") 
	ldap.search ( :base => treebase, :filter => filter) do |entry| 
		 puts entry.dn
		 puts entry.sn
     ops = [
       [:replace, :sn, 'ccl']
     ]

     ldap.modify :dn => entry.dn, :operations => ops
		 File.open 'log\ldap.log', 'w' do |t|
		 end
	end 

	#puts ldap.get_operation_result 
	
end

