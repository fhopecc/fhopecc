DOCROOT = 'doc/rails_book'
PUBROOT = 'public/rails_book'
namespace "rails_book" do
	directory 'public/rails_book'
	directory 'public/rails_book/doc'

	desc 'make rails book html'
	task :make_html =>  'public/rails_book' do
		`gerbil #{DOCROOT}/html.fmt #{DOCROOT}/rails_book.erb > #{PUBROOT}/rails_book.html`
	end
end

namespace "mlog_manual" do
	desc 'make manual'
	task :make_html do
		`gerbil #{DOCROOT}/html.fmt #{DOCROOT}/mlog_manual.erb > public/manual.html`
	end
end

namespace 'runpc' do
	directory 'tmp/runpc/wdscript'
	directory 'public/rails_book'
	desc 'make rails book html'
	task :make_html =>  'public/rails_book' do
		`erbook xhtml doc/rails_book/run_on_rails.erb > public/rails_book/run_on_rails.xhtml`
	end

	task :make_word_script => 'tmp/runpc/wdscript' do |t|
		obj = 'tmp/pcadv/wdscript/run_on_rails_1.rb' 
		src = "#{DOCROOT}/#{File.basename(obj, '.rb')}.erb"
		`gerbil #{DOCROOT}/runpc.fmt #{src} > #{obj}`
		`ruby #{obj}`
	end

	task :make_word => :make_word_script
end

namespace 'pcadv' do
	directory 'tmp/pcadv/wdscript'
	directory 'public/rails_book'
	desc 'make rails book html'
	task :make_html =>  'public/rails_book' do
		`gerbil #{DOCROOT}/html.fmt doc/rails_book/pcadv_restful_rails.erb > public/rails_book/pcadv_restful_rails.html`
	end

	task :make_word_script => 'tmp/pcadv/wdscript' do |t|
		obj = 'tmp/pcadv/wdscript/pcadv_restful_rails.rb' 
		src = "#{DOCROOT}/#{File.basename(obj, '.rb')}.erb"
		`gerbil #{DOCROOT}/pcadv.fmt #{src} > #{obj}`
		`ruby #{obj}`
	end

	task :make_word => :make_word_script
end

