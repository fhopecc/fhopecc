Runpcfmt = File.join('lib', 'erbook', 'runpc.fmt')
rule '.xhtml' => [
	proc { |t| Dir.glob(File.join('**', File.dirname(t).gsub(/^public/, 'doc'), '*.erb')) }
] do |t|
	src = File.join(File.dirname(t.name).gsub(/^public/, 'doc'), 
									File.basename(t.name).sub(/xhtml$/, 'erb'))
  puts `erbook xhtml #{src} > #{t.name}`
end

rule '.doc'  => [
	proc { |t| Dir.glob(File.join('**', File.dirname(t).gsub(/^public/, 'doc'), '*.erb')) }
] do |t|
	src = File.join(File.dirname(t.name).gsub(/^public/, 'doc'), 
									File.basename(t.name).sub(/doc$/, 'erb'))
  puts `erbook #{Runpcfmt} #{src} > #{t.name}`
end

desc 'make rails book html'
task :make_xhtml, [:project] do |t, args|
  project = args.project
  docroot = "doc/#{project}"
  pubroot = "public/#{project}"
	directory docroot
	directory pubroot
	Rake::Task[docroot].invoke
	Rake::Task[pubroot].invoke
	Rake::Task[File.join(pubroot, 'main.xhtml')].invoke
end

task :make_doc, [:project] do |t, args|
  project = args.project
  docroot = "doc/#{project}"
  pubroot = "public/#{project}"
	directory docroot
	directory pubroot
	Rake::Task[docroot].invoke
	Rake::Task[pubroot].invoke
	Rake::Task[File.join(pubroot, 'main.doc')].invoke
end

# clean all vim tmps which filename end with '~'
task :clean_vim_tmps do
	vim_tmps = Dir['**/*~']
	vim_tmps.each do |f|
		FileUtils.rm_f f
	end
end
