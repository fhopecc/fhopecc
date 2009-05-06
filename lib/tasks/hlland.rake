require 'net/ftp'
require 'net/http'
require 'uri'
require 'ping'
docdate  = '0980505' #來文日期
docno    = '0980005791' #文號
password = '23687'   #密碼

tmpdir   = 'tmp/hlland'
libdir   = "#{tmpdir}/lib"
patchdir = "#{tmpdir}/patch"
patchz   = "#{patchdir}/#{docno}.zip" 
patchr   = "#{tmpdir}/patch.rar"
unzip    = 'lib/bin/unzip'
rar      = 'lib/bin/rar'
targets  = ['96tt003', '96tt006', '97tt024', '97tt025', '97tt027', '97tt040']

def logger
	@logger ||= Logger.new("log/#{File.basename(__FILE__)}.log")
end

def copy_task 
  libdir = 'tmp/hlland/lib'
	Dir.glob("#{libdir}/*").each do |f|
		unless File.basename(f) == 'v_qry1.exe'
			FileUtils.copy f, "T:/"
		end
	end
end

def copy_to target
	if Ping.pingecho target, 10, 445
	  system 'net use T: /delete'
	  system 'net use T: \\\\' + target + '\\HL'
    copy_task
    logger.info "copy to #{target} completely!"
	else
    logger.error "#{target} is dead!"
	end
end

directory patchdir
directory libdir
namespace 'hlland' do
	task :download_patchz => patchdir do |t|
		url = URI.parse('http://att.hl.gov.tw')
		res = Net::HTTP.start(url.host, url.port) {|http|
	  	http.get("/SEND/..%5CSENDATT_FILE%5C#{docdate}%5C376550400A_#{docno}.zip")
		}
		unless res.is_a? Net::HTTPOK
			msg = "Failed to download patchz, because #{res.class.to_s}"
			logger.info msg
			raise msg
		end
		File.open(patchz, "wb") { |file|
			file.write(res.body)
		}
		logger.info "#{t.name} is completely!"
	end

	task :unzip_patchz => :download_patchz do
		m = `#{unzip} -o  #{patchz} -d #{tmpdir}`
		m  =~ /tmp.*\.rar/
		tf =  $&
    FileUtils.mv tf, patchr
		logger.info "unzip #{patchz} to #{patchr}"
	end

	task :expend_patchr => [libdir, :unzip_patchz] do
		m = `#{rar} e -o+ -p#{password} #{patchr} #{libdir}`
		logger.info "expend #{patchr} "
	end
  
	task :clear do
	  FileUtils.rm patchz
	  FileUtils.rm patchr
		Dir.glob("#{libdir}/*").each do |f|
			FileUtils.rm f
		end
	end

  desc "update hlland query program"
	task :update => :expend_patchr do
		copy_to '96tt003'
		copy_to '96tt006'
		copy_to '97tt024'
		copy_to '97tt025'
		copy_to '97tt027'
		copy_to '97tt040'
	  Rake::Task["hlland:clear"].invoke
  end

end

#require 'ostruct'
#tf = '0970016796.zip' 
#hllandftp = OpenStruct.new
#hllandftp.ip = '210.241.12.129'
#hllandftp.user = 'hlftp'
#hllandftp.passwd = 'hlftp52025'
#tmpf = "#{tmpdir}/#{tf}" 

#m = `#{unzip} -o -P #{password} #{tmpf} -d #{tmpunzip}`
#file tmpf => tmpdir do |t|
#	Net::FTP.open hllandftp.ip, hllandftp.user, hllandftp.passwd do |ftp|
#		ftp.getbinaryfile(File.basename(t.name),t.name, 1024)
#	  logger.info "get file completed!" 
#	end
#end
