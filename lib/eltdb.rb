require 'oci8'

class ELTDB
	@@logger = Logger.new('log/dba.log')
	@@logger.datetime_format = "%Y%m%d %H:%M:%S"
	def initialize db=:ELTUDT
    @logger ||= Logger.new('log/dba.log')
		@logger.datetime_format = "%Y%m%d %H:%M:%S"

		case db
		when :ELTUD
      @conn = OCI8.new('system', 'mets_111','ELTUD')
		else
      @conn = OCI8.new('system', 'mets_111','ELTUDT')
		end
	end

	def change_index_tablespace index, tbs
		@conn.exec "ALTER INDEX ELTWEB.#{index} REBUILD TABLESPACE #{tbs}"
	end


	def grant_mrole user, sys
    @conn.exec "GRANT ELTWEB_#{sys}_MODIFY_ROLE TO #{user}"
    @conn.exec "ALTER USER #{user} DEFAULT ROLE ALL"
	end

	def grant_vrole user, sys
    @conn.exec "GRANT ELTWEB_#{sys}_VIEW_ROLE TO #{user}"
    @conn.exec "ALTER USER #{user} DEFAULT ROLE ALL"
	end

	def reset_password user, password
    @conn.exec "ALTER USER #{user} " << 
               "IDENTIFIED BY \"#{password}\" " <<
               "ACCOUNT UNLOCK"
	end

	def revoke_mrole user, sys
		@logger.info "revoke #{user} #{sys} modify privilege"
    @conn.exec "REVOKE ELTWEB_#{sys}_MODIFY_ROLE FROM #{user}"
    @conn.exec "ALTER USER #{user} DEFAULT ROLE ALL"
	end

  def self.backup_table table
		db   = OCI8.new('eltweb', 'bewt_111','ELTUD')
		test = OCI8.new('eltweb', 'bewt_111','ELTUDT')
		[db, test].each do |conn|
      bkt = "#{table}bk#{Date.today.strftime("%Y%m%d")}"
		  conn.exec "create table #{bkt} as select * from #{table}"
		end
	end

	def self.create_pk table, *pkeys
 	  db   = OCI8.new('eltweb', 'bewt_111','ELTUD')
		test = OCI8.new('eltweb', 'bewt_111','ELTUDT')
		[db, test].each do |conn|
			begin
				conn.exec "ALTER TABLE #{table} " << 
					"ADD (CONSTRAINT PK_#{table} " <<
					"PRIMARY KEY(#{pkeys.join(',')}))"
			rescue OCIError => e
				case e.code
				when 955 #pk is already existed 
					conn.exec "drop index PK_#{table}"
					retry
				else
				  puts $!.messages
				end
			end
	  end
	end

	def self.grant_table_to_role table
    db      = OCI8.new('system', 'mets_111','ELTUD')
    testdb  = OCI8.new('system', 'mets_111','ELTUDT')
		role    = table[0..2]
   	gselect = "GRANT SELECT ON eltweb.#{table} TO ELTWEB_#{role}_VIEW_ROLE"
		ginsert = "GRANT INSERT ON eltweb.#{table} TO ELTWEB_#{role}_MODIFY_ROLE"
		gdelete = "GRANT DELETE ON eltweb.#{table} TO ELTWEB_#{role}_MODIFY_ROLE"
		gupdate = "GRANT UPDATE ON eltweb.#{table} TO ELTWEB_#{role}_MODIFY_ROLE"
		[db, testdb].each do |conn|
			conn.exec gselect
	 	  conn.exec ginsert
		  conn.exec gdelete
		  conn.exec gupdate
		end
	end

	def self.create_role sys, db='ELTUDT'
		conn = OCI8.new('system', 'mets_111',db)
    vrole = "eltweb_#{sys}_view_role"
    mrole = "eltweb_#{sys}_modify_role"
		conn.exec "CREATE ROLE #{vrole} NOT IDENTIFIED"
		conn.exec "CREATE ROLE #{mrole} NOT IDENTIFIED"
	end

	def self.get_sys n1, n2, year = (Date.today.year - 1911)
		conn = OCI8.new('eltweb', 'bewt_111','ELTUD')
    puts "select * from ypmt010  where app_no = " +
         " '#{year.to_s.rjust(3, '0')}#{n1}E#{n2.to_s.rjust(5, '0')}' "
    c = conn.exec("select * from ypmt010 where app_no = " +
        " '#{year.to_s.rjust(3, '0')}#{n1}E#{n2.to_s.rjust(5, '0')}' ")
		c.fetch_hash['SYS_CD']
  end


	def self.revoke_all_mroles
		@@logger.info "start revoke_all_mroles"
		db = ELTDB.new :ELTUD
		['cwl07971', 'ysj06660', 'ksh07147'].each do |u|
		  u = u.upcase
			rs = DbaRolePriv.find( :all, :conditions => 
					["grantee = ? and granted_role like ?", u, "ELTWEB_%_MODIFY_%"])
			rs.each do |r|
				db.revoke_mrole u, r.granted_role[7,3]
			end
		end
	end

end

