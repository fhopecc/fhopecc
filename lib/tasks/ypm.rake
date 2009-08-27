require 'ypm_fax'
def getypmno first, second
	first = first.to_s
	second = second.to_s
	second = '0' * (5 - second.length) + second
	ypmno = "0#{first}E#{second}" 
end

def config_sharing_dir
	system 'net use L: /delete'
	system 'net use M: /delete'
	system 'net use L: \\\\10.66.249.1\\D$\\docbatch\\template'
	system 'net use M: \\\\10.66.249.1\\D$\\Inetpub\\wwwroot\\JAVADOC\\Template'
end
namespace "ypm" do
	eltap1 = ['10.66.251.1', 'apsvr', 'ci$11111']
	doc_src = "/elt/eltapp/bin" + "/rgm"
	ypmfax = 'doc/ypmfax'
	docs = FileList[*((1..9).map {|n| "RGM0#{n}.doc"})]

  desc "make dir #{ypmfax}"
	directory ypmfax
	namespace "fax" do
		desc "load ypm fax word document"
		task :load, :first, :second  do |task, args|
			mkdir ypmfax unless File.exist?(ypmfax)
			#first = args[:first].to_s
			first = args.first.to_s
			second = args.second.to_s
			second = '0' * (5 - second.length) + second
			ypmno = "0#{first}E#{second}" 
			dir = "/elt/shared_perm/prog/comp_prog/#{ypmno}/fax"

			Net::FTP.open(eltap1[0], eltap1[1], eltap1[2]) do |ftp|
				ftp.chdir dir
				f = "#{ypmno}.doc"
				lf = "#{ypmfax}/#{ypmno}.doc" 
				ftp.getbinaryfile f, lf, 1024
			end
		end

		desc "call word to edit the specified ypmfax doc"
		task :edit, :first, :second  do |task, args|
      ypmno = getypmno args.first, args.second
			fax = "#{ypmfax}/#{ypmno}.doc" 
			cmd = "start #{fax}"
			system cmd
		end

    desc "print new ypmfax doc"
		task :print_new do |task|
			@mbox_path = 'C:/Documents and Settings/ccl00695/Application Data/Thunderbird/Profiles/1l08de6h.default/Mail/Local Folders/YPM.sbd/Notice'
			loader = TMail::UNIXMbox.new( @mbox_path, nil, true )
			loader.each_port do |port|
				mail = TMail::Mail.new(port)
				case mail['x-mozilla-status'].body
				when '0000', '0001' #0000:new mail, 0001:not deleted
			   YPMFAX.print_receipt mail
         YPMFAX.print mail
				end
			end
		end
	end

	namespace "vab" do
    desc "install process Service"
		task :processService do
			system 'net use T: /delete'
			system 'net use T: \\\\Vabserver\\VAB_FTX_SERVER'

			FileUtils.cp 'T:/ProcessService.class', 
			  'T:/ProcessService.class.bak'

      temp = nil
			Tempfile.open('ProcessService.class', 'tmp') do |tf|
				tf.binmode
				Net::FTP.open(eltap1[0], eltap1[1], eltap1[2]) do |ftp|
					ftp.chdir '/elt/eltapp/bin/vab'
					f = 'ProcessService.class'
					ftp.getbinaryfile f, tf.path, 1024
				end
				temp = tf
			end

      FileUtils.cp temp.path, 'T:/ProcessService.class'
		end
	end
  
end
