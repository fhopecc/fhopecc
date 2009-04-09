namespace "vim" do
	desc "clean all vim tmps which filename end with '~'"
	task :clear_tmps do
		vim_tmps = Dir['**/*~', '**/.*.swp']
		vim_tmps.each do |f|
			FileUtils.rm_f f
			puts "rm #{f}"
		end
	end
end

