require 'net/ldap'
require "pp"

task :ad_test do

	ldap = Net::LDAP.new :host => "hltb.gov.tw", 
					:port => 389, 
					:auth => {
		                :method => :simple, 
									  :username => "ccl00695", 
									  :password => "btmw222$" } 
	treebase = "dc=hltb,dc=gov,dc=tw" 

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

task :ldap_test do

 ldap = Net::LDAP.new :host => '192.168.1.4',
      :port => 389,
      :auth => {
            :method => :simple,
            :username => 'domain\ccl00695',
            :password => "btmw222$"
      }

 filter = Net::LDAP::Filter.eq( "cn", "ccl*" )
 treebase = "dc=htlb,dc=gov,dc=tw"

 ldap.search( :base => treebase, :filter => filter ) do |entry|
   puts "DN: #{entry.dn}"
   entry.each do |attribute, values|
     puts "   #{attribute}:"
     values.each do |value|
       puts "      --->#{value}"
     end
   end
 end

 #p ldap.get_operation_result

end	
