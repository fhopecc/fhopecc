task :fo => [:install_docbook_file]do 
	med='src/doc/med_rule_semantic.xml'
  docbook=DocBook.new
	docbook.to_pdf(med, 'test.pdf')
	sys "start test.pdf"
end

task :conf_font do
	fontname="&#x6a19;&#x6977;&#x9ad4;"
	fontfile="c:/WINDOWS/Fonts/KAIU.TTF"
  xslt = XSLT.new
	xslt.add_font fontname, fontfile
end

task :config_docbook do
	require 'fhope_conf'
	zhtw = 'src/docbook/common/zh_tw.xml'
	t = $docbkXSLHome+'/common/'+File.basename(zhtw)
  sys.install zhtw, t
end

