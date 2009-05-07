require 'singleton'
class OAYPM 
  include Singleton

	def logger
		@logger ||= Logger.new('log/oaypm.log')
	end

	def load_program sys, date
		logger.debug "start load #{sys}_#{date} programs"
		Net::FTP.open '10.78.247.3' do |ftp|
			ftp.login
			ftp.chdir sys 
			files = ftp.nlst.select {|f| f =~ /.*\.(sql|SQL|zip|txt)/ }
			files.each do |f|
				logger.debug "try to get file #{f}"
				unless Program.exists?(:basename => f)
					ftp.getbinaryfile f, "#{const_get(sys + 'TMP')}/#{f}"
					logger.info "get file #{f} ok"
					unless f =~ /.*§ó·s¬ö¿ý.*\.txt/
						program = Program.new :basename => f
						program.save
					end
				end
			end
		end
	end

	def exe_sqls sys
		logger.debug "start execute #{sys} programs"
		unexe_sqls = Program.unexe_sqls.select{|p|p.basename =~ /^#{sys}/}
		unexe_sqls.each do |p|
			sql = p.basename
			`sqlplus #{sys}/#{sys}@eoaud < #{const_get(sys + 'TMP')}/#{sql} > log/#{sql}.log`
			p.loaded = 't'
			p.save
			logger.debug "execute #{sql} ok"
		end
	end

end
