require 'net/ftp'
require 'net/http'
require 'uri'
require 'ostruct'
require 'ping'
docdate  = '0980305' #來文日期
docno = '0980002669' #文號
password = '63758'

Tmpdir = 'tmp/hlland'

tf = '0970016796.zip' 
hllandftp = OpenStruct.new
hllandftp.ip = '210.241.12.129'
hllandftp.user = 'hlftp'
hllandftp.passwd = 'hlftp52025'
tmpunzip = 'tmp/hlland/unzip'
tmpf = "#{Tmpdir}/#{tf}" 
unzip = 'lib/bin/unzip'
rar   = 'lib/bin/rar'

targets = ['96tt003', '96tt006', '97tt024', '97tt025', '97tt027', '97tt040']
def logger
	@logger ||= Logger.new("log/#{File.basename(__FILE__)}.log")
end

def copy_task 
	Dir.glob("#{Tmpdir}/*").each do |f|
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

directory Tmpdir
directory tmpunzip
namespace 'hlland' do

	#file tmpf => Tmpdir do |t|
	#	Net::FTP.open hllandftp.ip, hllandftp.user, hllandftp.passwd do |ftp|
	#		ftp.getbinaryfile(File.basename(t.name),t.name, 1024)
	#	  logger.info "get file completed!" 
	#	end
	#end

	task :download_patch do |t|
		url = URI.parse('http://att.hl.gov.tw/SEND/..%5CSENDATT_FILE%5C0980204%5C376550400A_0980001263.zip')
		res = Net::HTTP.start(url.host, url.port) {|http|
			#puts "/SEND/..%5CSENDATT_FILE%5C#{docdate}%5C376550400A_#{docno}.zip"
	  	http.get("/SEND/..%5CSENDATT_FILE%5C#{docdate}%5C376550400A_#{docno}.zip")
		}
		unless res.is_a? Net::HTTPOK
			msg = "Failed to download patch! Reason was #{res.class.to_s}"
			logger.info msg
			raise msg
		end
		File.open("#{Tmpdir}/update.zip", "wb") { |file|
			file.write(res.body)
		}
		logger.info "#{t.name} invoked completely"
	end

	#task :expend_patch => :download_patch do
	task :expend_patch do
		#m = `#{unzip} -o -P #{password} #{tmpf} -d #{tmpunzip}`
		#m  =  `#{unzip} -o  #{Tmpdir}/update.zip -d #{Tmpdir}`
		#m  =~ /tmp.*\.rar/
		#tf =  $&
		tf = Tmpdir + '\Hl.rar'
		#logger.info "unzip update.zip to #{tf} "
		m = `#{rar} e -o+ -p#{password} #{tf} #{Tmpdir}`
		logger.info "rar e #{tf} "
		FileUtils.rm_f tf
		logger.info "delete #{tf} "
		#FileUtils.rm_f "#{Tmpdir}/update.zip"
		#logger.info "delete update.zip "
	end

	task :update => :expend_patch do
		copy_to '96tt003'
		copy_to '96tt006'
		copy_to '97tt024'
		copy_to '97tt025'
		copy_to '97tt027'
		copy_to '97tt040'
  end

end
