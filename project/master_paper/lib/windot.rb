## A front-end for WinGraphviz.DOT.
##
## Versrion: 1.0
## Author: Gary W. Lee 
## Date: 2004-12-06 10:25:00
## ruby porting fhope@2006/8/24 下午 02:24:20
## note by fhope@2006/8/8 上午 09:44:25
## 1.安裝 winGraphviz.dll
## 2.安裝 ruby
## 3.copy this script 2 c:\ruby
## 4.you can type windot.py src.dot target.png
require 'win32ole'
def dot2png(fdot, fpng)	
	puts "#{fdot} trans into #{fpng}"
  trans = WIN32OLE.new('WinGraphviz.DOT')
	dotcmd=""
  IO.foreach(fdot) {|line| dotcmd+=line}
  png = trans.ToPNG(dotcmd)
  png.Save(fpng)
	puts "OK"
end
def neto2png(fdot, fpng)	
	puts "#{fdot} trans into #{fpng}"
  trans = WIN32OLE.new('WinGraphviz.NETO')
	dotcmd=""
  IO.foreach(fdot) {|line| dotcmd+=line}
  png = trans.ToPNG(dotcmd)
  png.Save(fpng)
	puts "OK"
end

def dot2gif(fdot, fgif)	
	puts "#{fdot} trans into #{fgif}"
  trans = WIN32OLE.new('WinGraphviz.DOT')
	dotcmd=""
  IO.foreach(fdot) {|line| dotcmd+=dotcmd}
  gif = trans.ToGIF(dotcmd)
  gif.Save(fgif)
	puts "OK"
end
def neto2svg(src)
  neto = WIN32OLE.new('WinGraphviz.NETO')
	return neto.ToSvg(src)
end
# EOF.
