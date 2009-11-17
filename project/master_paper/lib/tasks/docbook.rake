require 'logger'
namespace "doc" do
	require 'xslt'
	docsrc = 'doc/docbook'
  docbkxslt=DocbkXSLT.new
  docbkxslt.xalan_home="c:/xalan-j_2_7_0"
  docbkxslt.docbkxsl_home='c:/docbook-xsl-1.73.2'
  docbkxslt.custom_xsl="#{docsrc}/fhope.docbk.xsl"

  docbksrc= proc {|tn| 
		log = Logger.new 'logs/rake.log'
	  bn =File.basename tn, File.extname(tn) 

		fs = ["doc/#{bn}.xml", "#{bn}html"] + 
		FileList["doc/*.xml", "doc/*.inc"].exclude("doc/#{bn}.xml").to_a

		log.debug fs.join("\n")
		return fs
	}

	#rule '.html' => '.xml' do |t|
	
  rule('.html' => [
    proc {|tn| 
	  	log = Logger.new 'log/rake.log'
	    bn =File.basename tn, File.extname(tn) 
  
  		#fs = ["doc/#{bn}.xml", 'doc/fhope.docbk.xsl', "#{bn}html"] + 
  		#FileList["doc/*.xml", "doc/*.inc"].exclude("doc/#{bn}.xml").to_a
			fs = ["#{docsrc}/#{bn}.xml"] + FileList["#{docsrc}/*.xml", "#{docsrc}/*.inc"].exclude("#{docsrc}/#{bn}.xml").to_a
  		log.debug "make #{tn}.html from " + fs.join(";")

  		return fs
    }]) do |t|


  	docbkxslt.to_html t.source, t.name
  end

  desc "make the doc in html format"
  task :make_html => "public/mras.html"
end
