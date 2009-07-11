Runpcfmt = File.join('lib', 'erbook', 'runpc.fmt')
HtmlFmt = File.join('lib', 'erbook', 'html.yaml')
rule '.html' => [
	proc { |t| Dir.glob(File.join('**', File.dirname(t).gsub(/^public/, 'doc'), '*.erb')) }
] do |t|
	src = File.join(File.dirname(t.name).gsub(/^public/, 'doc'), 
									File.basename(t.name).sub(/html$/, 'erb'))
  puts `erbook #{HtmlFmt} #{src} > #{t.name}`
end
namespace 'doc' do
	task :make_html, [:project] do |t, args|
		project = args.project
		docroot = "doc/#{project}"
		pubroot = "public/#{project}"
		directory docroot
		directory pubroot
		FileUtils.touch "#{docroot}/main.erb"
		Rake::Task[docroot].invoke
		Rake::Task[pubroot].invoke
		Rake::Task[File.join(pubroot, 'main.html')].invoke
	end
	task :deploy do
		url = 'fhopecc.freeoda.com'
		Net::FTP.open url, url, '19790729' do |ftp|
			ftp.put 'public/index.html'
			ftp.mkdir 'db'
			ftp.put 'public/db/main.html', 'db/main.html'
		end
	end
end
