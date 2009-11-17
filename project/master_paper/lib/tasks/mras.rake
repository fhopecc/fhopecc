require 'java'
require 'fileutils'

java = Java.new
java.target_dir = 'lib/java'
java.srcs.include '**/*.java'
java.jars.include 'lib/java/jars/*.jar'
java.extclasspath.push 'config'


namespace 'mras' do
	desc 'test mras'
  task :test do
		puts java.srcs.join("\n")
	end

	task :javac do
		java.compile
	end

	desc "start mras_server"
	task :server do
		java.run 'mras.Server'
	end

	task :set_package do
		javasrcs = FileList['**/*.java']
		javasrcs.each do |j|
			File.open "#{j}.tmp", 'w' do |tar|
			  File.open j, 'r' do |src|
					first_line = true
					src.each_line do |l|
            unless first_line 
              tar << l
						else
							tar << "package mras;\n"
							first_line = false
						end
					end
				end
			end
			FileUtils.cp "#{j}.tmp", j
			FileUtils.rm "#{j}.tmp"
		end
	end

end
