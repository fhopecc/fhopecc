require 'rake'
require 'fileutils'
require 'fhope_conf'
require 'java'

class XSLT
	include FileUtils
	attr_accessor :fop_home, :xalan_home
	def initialize()
		super
		@fop_home="c:/fop-0.20.5"
		@xalan_home=$xalan_home
	end
  def trans(xml, xslt, out) 
	  cmd="java -jar #{$xalan_home}/xalan.jar -IN #{xml} -XSL #{xslt} -OUT #{out}"
	  system cmd
  end
end
class DocbkXSLT < XSLT
	include FileUtils
	attr_accessor :docbkxsl_home, :custom_xsl, :custom_fo_xsl
	#deprecated
  attr_accessor :xhtml_xsl, :html_xsl
  def initialize()
		super
		@custom_xsl="fhope.docbk.xsl"
		@custom_fo_xsl="fhope.fo.docbk.xsl"
	end

  def conf_font 
  	#fontname="&#x6a19;&#x6977;&#x9ad4;"
		fontname="DFKai-SB"
  	fontfile="/c:/WINDOWS/Fonts/KAIU.TTF"
	  add_font fontname, fontfile
  end

	def get_custom_xsl_path format
		xsl_home = "#{@docbkxsl_home}/#{format}"
		puts "xsl_home=#{xsl_home}"
		install @custom_xsl, xsl_home
		xsl = "#{xsl_home}/#{File.basename(@custom_xsl)}"
	end
	def get_custom_fo_xsl_path format
		xsl_home = "#{@docbkxsl_home}/#{format}"
		install @custom_fo_xsl, xsl_home
		xsl = "#{xsl_home}/#{File.basename(@custom_fo_xsl)}"
	end
	def add_font(fontname, fontfile)
		fontxml="/#{fop_home}/conf/#{File.basename(fontfile).sub_ext('xml')}"

		fontfile=fontfile.gsub(/\//, "\\")
		fontxml=fontxml.gsub(/\//, "\\")

    java = Java.new
		java.jars.include "#{fop_home}/build/*.jar"
		java.jars.include "#{fop_home}/lib/*.jar"
		java.run("org.apache.fop.fonts.apps.TTFReader", 
     "#{fontfile} #{fontxml} >> log.out")
	end
	def get_xerces_jar
    fs = FileList["#{fop_home}/lib/xercesImpl*"]
		File.basename fs.entries[0]
	end
	def to_fo(xml, out)
    fop_xsl = get_custom_fo_xsl_path 'fo'
    trans xml, fop_xsl, out
	end	
	def to_pdf(xml, out)
		#conf_font
    install "config.xml", "#{fop_home}/conf"
    foout=out.sub_ext('fo')
		config="#{fop_home}/conf/config.xml"
		to_fo xml, foout
    cmd="#{fop_home}/fop.bat -fo #{foout} -c #{config} -pdf #{out} >> log.out"
    #cmd="#{fop_home}/fop.bat -fo #{foout} -pdf #{out} >> log.out"
		system cmd
	end
	def to_html(xml, out)
    html_xsl = get_custom_xsl_path 'html'
    trans xml, html_xsl, out
	end
	# xhtml script
	def to_xhtml(xml, out)

		fs = Rant::FileList["#{File.dirname(xml)}/*.rb"]
		fs.each do |f|
			fix_big5_in_source_code f
		end

		xhtml_xsl = get_custom_xsl_path 'xhtml'

    trans xml, xhtml_xsl, out

		fs.each do |f|
			restore_fix_big5_in_source_code f
		end

		fix_docbook_xhtml out
	end
	# when you want to include source code
	# xml must be add 
	# <?xml encoding="Big5"?>
	# in front of the source code 
	def fix_big5_in_source_code(src)
		strbig5='<?xml encoding="Big5"?>' + "\n"
		bak = src+".bak"	
	  cp src, bak
		sf=File.new(bak, 'r')
		nf=File.new(src, 'w')
		nf << strbig5
		sf.each_line do |l|
			nf << l unless l == strbig5
		end
		sf.close
		nf.close
	end
	def restore_fix_big5_in_source_code(src)
		bak = src+".bak"	
		cp bak, src
		rm bak
	end
  # Using docbook xsl to transform docbook to xhtml will
  # produce '<span ="">'. For this is not a valid xml syntax,
  # web browser refuse to display this document, and 
  # we have to change '<span ="">' to '<span class="">' to 
  # let the browser to display it. 
  def fix_docbook_xhtml(xhtml)
    sf=File.new(xhtml, 'r')
	  nf=File.new(xhtml+'~', 'w')
	  sf.each_line do |l|
      r=l.gsub(/ =""/, ' class=""')
		  nf << r
	  end
	  sf.close
	  nf.close
	  cp nf.path, sf.path
	  rm nf.path
  end
end
#deprecated, for bad names
#replace this class of DocbkXSLT
class DocBook < DocbkXSLT
  def initialize()
		super
    @fop_xsl="d:/docbk/fo/bg5docbook.xsl"
		@xhtml_xsl="/docbk/xhtml/docbook.xsl"
	end
end

