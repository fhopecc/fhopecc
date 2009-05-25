class Hltb
	def self.download_tax_report docno
		tmp  = "tmp/hltb"
		docf = "#{docno}-01.tif"
   
		url  = URI.parse('http://www.fdc.gov.tw/public/doc')
    
		res = Net::HTTP.start(url.host, url.port) {|http|
	  	http.get("/public/doc/#{docf}")
		}
		unless res.is_a? Net::HTTPOK
			msg = "Failed to download patch! Reason was #{res.class.to_s}"
			raise msg
		end
		File.open("#{tmp}/#{docf}", "wb") { |file|
			file.write(res.body)
		}
	end

	def self.print_tax_report docno
  	tmp    = "tmp/hltb"
		tmpjpg = File.join(tmp, 'jpg')
		docf = "#{tmp}/#{docno}-01.tif"
    imgs = Magick::ImageList.new(docf)
		[1, 4, 7, 9, 12].each do |i|
			img = File.join(tmpjpg, "#{i-1}.jpg")
      imgs[i-1].write(img)
			cmd = "rundll32 shimgvw.dll,ImageView_PrintTo d:\\fhopecc\\tmp\\hltb\\jpg\\#{i-1}.jpg internet"
			puts cmd
			puts system(cmd)
		end
	end

end
