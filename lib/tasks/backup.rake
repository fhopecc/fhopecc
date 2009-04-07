bkdir = 'd:\backup\data_yml'
back_file ="#{bkdir}\\data#{Date.today.year}#{Date.today.month}#{Date.today.day}.yml.gz" 
data_yml = "db/data.yml"
directory bkdir
namespace "backup" do
	desc "backup heroku data into local machine"
	task :data_yml => bkdir do
		url = URI.parse "http://moneylog.heroku.com/db_dumper.yml"
		res = Net::HTTP.start(url.host, url.port) {|http|
			http.get("/db_dumper.yml")
		}
		Zlib::GzipWriter.open(back_file) { |gz|
			gz.write(res.body)
		}
	end

	task :unzip_backup => :data_yml do
    Zlib::GzipReader.open(back_file) do |gz|
			File.open(data_yml, 'w') do |f|
				f.print gz.read
			end
		end		
	end

	desc "sync local data as data on heroku"
	task :sync_heroku => :unzip_backup do
	  Rake::Task['db:data:load'].invoke
	end
end
