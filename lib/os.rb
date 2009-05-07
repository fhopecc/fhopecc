# OS.rb
require 'delegate'
require 'singleton'
require 'vista'
require 'winxp'

def CurrentOS
	if system('setx /? >nul 2>nul' )
		VISTA
	else
		WINXP
	end
end

class OS
	include CurrentOS(), Singleton
end

