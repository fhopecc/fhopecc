namespace "vim" do
  desc 'setup the vim environment'
  task :setup => :deploy
  
  desc "clean all vim tmps which filename end with '~'"
  task :clear_tmps do
    vim_tmps = Dir['**/*~', '**/.*.swp']
		vim_tmps.each do |f|
			FileUtils.rm_f f
			puts "rm #{f}"
		end
	end

	desc "make vim shell executable"
	task :make_executable do
		os.addSearchPath "vim.exe"
	end

  vimhome   = ENV["VIMHOME"] 
	vimhome ||= 'c:/vim'
	version ||= ENV["VERSION"] 
	version ||= '72' 
	vimsys = "#{vimhome}/vim#{version}"
  here = File.dirname(__FILE__) + '/../../config/vim'

  desc 'deploy the vim configuration files'
  task :deploy => "#{vimsys}/filetype.vim" 
  task :deploy => "#{vimsys}/compiler/rake.vim" 
  task :deploy => "#{vimsys}/compiler/rant.vim" 
  task :deploy => "#{vimsys}/compiler/ruby.vim" 
  task :deploy => "#{vimsys}/compiler/rubyunit.vim" 
  #task :deploy => "#{vimsys}/compiler/javascript.vim" 
  task :deploy => "#{vimhome}/_vimrc" 
  task :deploy => "#{vimhome}/fhope.vim" 
  task :deploy => "#{vimhome}/vimfiles/plugin/refactoring.vim" 
  task :deploy => "#{vimhome}/vimfiles/ftplugin/xml.vim" 
  task :deploy => "#{vimhome}/vimfiles/ftplugin/docbk.vim" 
	#
  rule /#{vimsys}\/.*/ => [
    proc{|s|
      s.gsub vimsys, here
  }] do |t|
    cp t.prerequisites[0], t.name
  end

  rule /#{vimhome}\/.*/ => [
    proc{|s|
      s.gsub vimhome, here
  }] do |t|
    cp t.prerequisites[0], t.name
  end

  #file "#{vimhome}/_vimrc" => "#{here}/_vimrc" do |t|
  #  cp t.source, t.name
  #end
		                    
end

