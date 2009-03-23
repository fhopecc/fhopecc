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
	def self.print
	end
end
