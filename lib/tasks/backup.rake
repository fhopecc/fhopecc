bkdir = 'd:\backup\data_yml'
directory bkdir
namespace "backup" do
	task :data_yml => bkdir do
		url = URI.parse "http://moneylog.heroku.com/db_dumper.yml"
		res = Net::HTTP.start(url.host, url.port) {|http|
			http.get("/db_dumper.yml")
		}
		back_file ="#{bkdir}\\data#{Date.today.year}#{Date.today.month}#{Date.today.day}.yml.gz" 
		Zlib::GzipWriter.open(back_file) { |gz|
			gz.write(res.body)
		}
	end
end
