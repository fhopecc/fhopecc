if RUBY_PLATFORM =~ /win/
require 'rubygems'
require 'tmail'
require 'net/ftp'
require 'fileutils'
require 'tmpdir'
require 'tempfile'
require "win32ole" 
require 'iconv'  
include FileUtils

module TMail
  class UNIXMbox
    def fromline2time( line )
      m = /\AFrom \S+ \w+ (\w+) (\d+) (\d+):(\d+):(\d+) (\d+)/.match(line) \
              or return nil
			begin
        Time.local(m[6].to_i, m[1], m[2].to_i, m[3].to_i, m[4].to_i, m[5].to_i)
			rescue
				return nil
			end
    end
	end
end

  module WordConst
	end
include WordConst
def print_ypm_mail mail
	ic = Iconv.new("big5", "utf-8")  
	begin 
		word = WIN32OLE.connect("word.application") 
	rescue 
		word = WIN32OLE.new("word.application") 
		word.documents.add 
	end 
  WIN32OLE.const_load word

	#word.visible = true 
  selection = word.selection
	doc = word.activedocument

  selection.font.namefareast = "標楷體"
  selection.font.nameascii = "Times New Roman"
	selection.font.size = 12 
	selection.font.italic = false 
	selection.typeText(ic.iconv(mail.subject.to_s << "\n" << 
			("-"*mail.subject.length) << "\n" <<
			mail.from.to_s << "\n" <<
			mail.date.to_s << "\n" <<
			("="*mail.date.to_s.length) << "\n" <<
			mail.body.to_s) << "\n" << 
			"簽收：" )
  doc.printout

  sleep 1

  word.Quit 0
end

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

def print_ypm_fax mail

	if mail.attachments[0]
		a = mail.attachments[0]
	  puts "print mail [#{a.original_filename}]"

    print_ypm_mail mail
    temp = nil
		Tempfile.open(a.original_filename, 'tmp') do |f|
			f.binmode
			a.each_byte do |b|
				f.putc b
			end
			temp = f
		end
		syscmd = '"c:\Program Files\Microsoft Office\Office10\WINWORD.EXE" "' << 
		         temp.path << '" /q /n /mPrint2AndCloseWord'
		system syscmd
		return a.original_filename
	end
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
			@mbox_path = 'C:/Documents and Settings/ccl00695/Application Data/Thunderbird/Profiles/1l08de6h.default/Mail/Local Folders/程式館.sbd/程式館通知'
			loader = TMail::UNIXMbox.new( @mbox_path, nil, true )
			loader.each_port do |port|
				mail = TMail::Mail.new(port)
				case mail['x-mozilla-status'].body
				when '0000', '0001' #0000:new mail, 0001:not deleted
         print_ypm_fax mail
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

desc "test word"
task :test_word do 
	require "win32ole" 
	mail = nil
  @mbox_path = 'C:/Documents and Settings/ccl00695/Application Data/Thunderbird/Profiles/1l08de6h.default/Mail/Local Folders/程式館.sbd/程式館通知'
  loader = TMail::UNIXMbox.new( @mbox_path, nil, true )
	loader.each_port do |port|
		mail = TMail::Mail.new(port)
	end

	begin 
		word = WIN32OLE.connect("word.application") 
	rescue 
		#如果沒有打開的Word程式，創建一個 
		word = WIN32OLE.new("word.application") 
		word.documents.add 
	end 

	word.visible = true 
	doc = word.ActiveDocument() 
	#創建檔文本字體 
	word.selection.font.name = "Courier New" 
	word.selection.font.size = 10.5 
	word.selection.font.italic = false 
	#一行行寫入，換行符用\11，這樣可以作為一個整體來 
	#處理檔，而不用分段。 
	#word.selection.typeText("test my張簡稜剛") 
	#word.selection.typeText("\n") 
	#word.selection.typeText("張簡稜剛 ok ok") 
	require 'iconv'  
	ic = Iconv.new("big5", "utf-8")  
	word.selection.typeText(ic.iconv(mail.subject))
	puts mail.subject
  #doc.PrintOut
  #word.Quit

end
end
