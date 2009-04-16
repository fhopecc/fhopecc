require 'winxp'
module VISTA
	include WINXP
  def set_sysenv(var, val)
    unless system "setx #{var} #{val} >nul"
			puts "error:setx #{var} \"#{val}\""
		end
	end

  def add_path(path)
		env_paths = ENV['PATH'].split(/;/).push(path).uniq
		strpath =  env_paths.join(";")
    set_sysenv 'PATH', strpath
	end
end
