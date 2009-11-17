#file: fhope_conf.rb
#version: 0.1
#author: fhope
class String
	def trim
		gsub /\s/, ''
	end
end

AtHome = 'FHOPE'
AtHome2 = 'shen-o4yezsvioc'
AtOffice = '94TT101'
hostname = (`hostname`).trim

$docbkXSLHome="/docbook-xsl-1.72.0"
$xalan_home="c:/xalan-j_2_7_0"
case hostname
when AtHome
  $docbkXSLHome="/docbook-xsl-1.69.1"
  $xalan_home="/xalan-j_2_7_0"
when AtHome2
  $docbkXSLHome="d:/docbook-xsl-1.71.1"
  $xalan_home="d:/xalan-j_2_7_0"
when AtOffice
  $docbkXSLHome="c:/docbook-xsl-1.70.1"
  $xalan_home="c:/xalan-j_2_7_0"
end
=begin
class String
	def sub_ext ext
		File.dirname(self) + "/" + File.basename(self, File.extname(self))+"."+ext
	end
end
=end
