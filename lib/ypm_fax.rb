require "win32ole" if RUBY_PLATFORM =~ /win/
require 'tmail'
require 'tmpdir'
require 'tempfile'
require 'iconv'  
require 'net/ftp'
require 'fileutils'
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
class YPMFAX
	def self.print_receipt mail
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

		selection.font.namefareast = "º–∑¢≈È"
		selection.font.nameascii = "Times New Roman"
		selection.font.size = 12 
		selection.font.italic = false 
		selection.typeText(ic.iconv(mail.subject.to_s << "\n" << 
				("-"*mail.subject.length) << "\n" <<
				mail.from.to_s << "\n" <<
				mail.date.to_s << "\n" <<
				("="*mail.date.to_s.length) << "\n" <<
				mail.body.to_s) << "\n" << 
				"√±¶¨°G" )
		doc.printout
		sleep 1
		word.Quit 0
	end

	def self.print mail
		if mail.attachments[0]
			a = mail.attachments[0]
			puts "print mail [#{a.original_filename}]"

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
end
