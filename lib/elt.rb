require 'net/ftp'
require 'lib/eltdb.rb'
class ELT
	attr_accessor :host
	def initialize host=:ELTAPT
    @host = host
		@account  = "apsvr"
		@password = "rvsp_111"
	end

	def mget blocksize, *files
		hosts.each do |host|
			Net::FTP.open host, @account, @password do |ftp|
				files.each do |f|
					ftp.chdir File.dirname(f)
          bfn = File.basename(f)
					ftp.getbinaryfile bfn, bfn, blocksize
				end
			end
		end
	end

	def upload *files
		hosts.each do |host|
			Net::FTP.open host, @account, @password do |ftp|
				files.each do |f|
					ftp.chdir deploy_dir(f)
					ftp.putbinaryfile(f, f, 1024)
				end
			end
		end
	end

	def hosts
    case @host
		when :ELTUAT
			["10.66.248.1"]
		else
			["10.66.251.1", "10.66.251.2", "10.66.251.3" ]
		end
	end

	def system file
    file[0..2]
	end

	def prog_type file
    case File.extname(file)
		when ".class"
			:apfile
		else
      :webfile
		end
	end

	def deploy_dir file
		case prog_type(file)
		when :apfile
			"/elt/eltapp/app/#{system(file).downcase}"
		else
			"/elt/eltweb/app/#{system(file).downcase}"
		end
	end

	def self.install_eltsql db, n1, n2, year = (Date.today.year - 1911)
    sys = ELTDB.get_sys n1, n2, year
		dir = "/elt/shared_perm/prog/send_prog/" << 
		      "#{year.to_s.rjust(3, '0')}#{n1}E#{n2.to_s.rjust(5, '0')}/" <<
          "eltapp/bin/#{sys.downcase}"

		Net::FTP.open '10.66.251.1', 'apsvr', 'rvsp_111' do |ftp|
			ftp.chdir dir
			ftp.nlst("*.sql").each do |sql|
        ftp.getbinaryfile sql, "lib/sql/#{year}#{n1}E#{n2}_#{sql}"
			end

		end

    Dir["lib/sql/#{year}#{n1}E#{n2}_*.sql"].each do |sql|
		  `sqlplus ELTWEB/bewt_111@#{db} < #{sql} > log/sql/#{File.basename(sql)}.#{db}.log`
		end
	end
  
end
