class Hltb
	def self.download_tax_report docno
		tmp  = "tmp/hltb"
		fs = ["#{docno}-01.tif", "#{docno}之附件.tif"]
		url  = URI.parse('http://www.fdc.gov.tw/public/doc')
		s = false
		fs.each do |f|
			res = Net::HTTP.start(url.host, url.port) {|http|
				http.get(URI.escape("/public/doc/#{f}"))
			}
			unless res.is_a? Net::HTTPOK
				puts "Failed to download #{f}, because #{res.class.to_s}"
				next
			else
				File.open("#{tmp}/#{docno}.tif", "wb") { |file|
					file.write(res.body)
				}
				puts "Download #{f} successfully!"
				s = true
				break
			end
		end
		raise "Failed to download!" unless s
	end
	def self.print_tax_report docno
  	tmp    = "tmp/hltb"
		tmpjpg = File.join(tmp, 'jpg')
		docf = "#{tmp}/#{docno}.tif"
    imgs = Magick::ImageList.new(docf)
		[1, 4, 7, 10, 13].each do |i|
			img = File.join(tmpjpg, "#{i-1}.jpg")
      imgs[i-1].write(img)
			cmd = "rundll32 shimgvw.dll,ImageView_PrintTo d:\\fhopecc\\tmp\\hltb\\jpg\\#{i-1}.jpg internet"
			puts cmd
			puts system(cmd)
		end
	end

end
