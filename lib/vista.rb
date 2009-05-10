require 'winxp'
module VISTA
	include WINXP
  def set_sysenv var, val
    unless system "setx #{var} \"#{val}\" /M >nul 2>nul"
			puts "Fails " if var != 'PATH'
		end
	end

  def add_path path
		unless ENV['PATH'].split(/;/).include? path
      set_sysenv 'PATH', "%PATH%;#{path}"
			puts "Path [#{path}] pushesin PATH envvar successfully!"
		else
			puts "Path [#{path}] is already in PATH envvar!"
		end
	end

	def uniq_path
		upaths = ENV['PATH'].split(/;/).uniq 
    set_sysenv 'PATH', "#{upaths.join(';')}"
	  puts "PATH has unique its elements successfully!"
	end

	def del_path path
		paths = ENV['PATH'].split(/;/)
		if paths.include? path
			paths.delete path
      set_sysenv 'PATH', "#{paths.join(';')}"
			puts "Path [#{path}] has removed from PATH envvar successfully!"
		else
			puts "Path [#{path}] is not in PATH envvar!"
		end
	end
end
