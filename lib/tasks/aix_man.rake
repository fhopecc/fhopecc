require 'enumerator'
require 'net/ftp'
ap1 = '10.66.251.1'
files = ['/elt/eltapp/app/wtg/WTG100X_.class']
aps  = ['10.66.251.1', '10.66.251.2', '10.66.251.3']
test = '10.66.248.1'
account = 'apsvr'
passwd = 'rvsp_111'

namespace 'aix_man' do

	desc 'get files from ap'
	task :getfilesfromap do
		Net::FTP.open ap1, account, passwd do |ftp|
			files.each_with_index do |f, i|
				localf = "tmp/#{File.basename(f)}.#{i}"
				ftp.chdir File.dirname(f)
				ftp.getbinaryfile(f,localf, 1024)
				puts "get file #{f} into #{localf}"
			end
		end
	end

	desc 'put files to ap'
	task :putfiletoap do
		aps.each do |ap|
			Net::FTP.open ap, account, passwd do |ftp|
				files.each_with_index do |f, i|
					localf = "tmp/#{File.basename(f)}.#{i}"
					ftp.chdir File.dirname(f)
					ftp.putbinaryfile(localf,f, 1024)
					puts "put file #{localf} into #{f} at host #{ap}"
				end
			end
		end
	end

	desc 'put file to test ap'
	task :put_file_to_test do
		Net::FTP.open test, account, passwd do |ftp|
			files.each do |f|
				localf = "tmp/upload/#{File.basename(f)}"
				ftp.chdir File.dirname(f)
				ftp.putbinaryfile(localf,f, 1024)
				puts "put file #{localf} into #{f} at test!"
			end
		end
	end

end
