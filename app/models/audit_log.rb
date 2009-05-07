require 'rubygems'
require 'oci8'
require 'logger'
class AuditLog
	@@logger = Logger.new 'log/testauditlog.log'
  attr_accessor :logger
	attr_reader :user_name, :sql_text, :extime, :terminal

	DEFAULT_USERS  = [ 'ALL', 'CWL07971','HJC03836' ,'YSJ06660', 
                     'THY09104', 'WIY06831', 'KSH07147', 
                     'ACERTEST', 'U9617ACE', 'U9617AC01' ]

  def initialize _user_name, _sql_text, _extime, _terminal
    @user_name, @sql_text, 
		@extime, @terminal= _user_name, _sql_text, _extime, _terminal
		@logger = @@logger
  end 

	def duration
		@start_date.to_s + "-->" + @end_date.to_s
	end

  def fetch_data
    conn = OCI8.new("monitor", "e271828", "ELTUD")
    cursor = conn.exec audit_log_sql
    logger.debug "test fetch start"

    while r = cursor.fetch()
      logger.debug r.join(',')
			puts r.join(',')
    end
    cursor.close
    conn.logoff
		logger.debug "test fetch end"
	end

	def default_users
		DEFAULT_USERS
	end

  class << self
	  def find_all_by_user_name_and_start_date_and_end_date uname, sdate, edate
      conn = OCI8.new("monitor", "e271828", "ELTUD")
			if uname == 'ALL'
				cursor = conn.exec audit_all_log_sql sdate, edate 
			else
				cursor = conn.exec audit_log_sql uname, sdate, edate
			end

			als = []
      while r = cursor.fetch()
        als.push AuditLog.new(r[1], r[9], r[5], r[2])
      end
      cursor.close
      conn.logoff
			als
	  end

	  def audit_all_log_sql sdate, edate
	  	sd = sdate.strftime('%Y%m%d')
	  	ed = edate.strftime('%Y%m%d')
	  	sql = <<EOS
SELECT os_username,
       username,
       terminal,
       sessionid,
       to_char(extended_timestamp,'YY-MM-DD HH24:MI') e_time,
       to_char(nvl(extended_timestamp, sysdate),'YYYYMMDD') extime,
       owner,
       obj_name,
       action_name,
       sql_text
FROM   dba_audit_trail
WHERE owner in ('ELTWEB')
and NVL(to_char(extended_timestamp,'YYYYMMDD'),'00000000') >= '#{sd}' 
and NVL(to_char(extended_timestamp,'YYYYMMDD'),'00000000') <= '#{ed}'
order by extended_timestamp
EOS
  		@@logger.debug "sql, #{sql}"
  		sql
  	end

	  def audit_log_sql uname, sdate, edate
	  	sd = sdate.strftime('%Y%m%d')
	  	ed = edate.strftime('%Y%m%d')
	  	sql = <<EOS
SELECT os_username,
       username,
       terminal,
       sessionid,
       to_char(extended_timestamp,'YY-MM-DD HH24:MI') e_time,
       to_char(nvl(extended_timestamp, sysdate),'YYYYMMDD') extime,
       owner,
       obj_name,
       action_name,
       sql_text
FROM   dba_audit_trail
WHERE  username like UPPER('#{uname}%')
and owner in ('ELTWEB')
and NVL(to_char(extended_timestamp,'YYYYMMDD'),'00000000') >= '#{sd}' 
and NVL(to_char(extended_timestamp,'YYYYMMDD'),'00000000') <= '#{ed}'
order by extended_timestamp
EOS
  		@@logger.debug "sql, #{sql}"
  		sql
  	end

		def version
      "0.5"
		end

		def last_modify
      "fhopecc modified at 2008-1-10"
		end

		def change_log
			{
  		 0.3 => "support the ruby_oci8", 
			 0.4 => "add default user list", 
			 0.5 => "add user application form", 
			 0.6 => "add terminal" 
			}
		end
	end

end 
