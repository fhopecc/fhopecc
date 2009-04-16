module WINXP
  def set_sysenv(var, val)
  	#change the registry
    require 'win32/registry' 
    Win32::Registry::HKEY_LOCAL_MACHINE.open(
    'System\CurrentControlSet\Control\Session Manager\Environment', Win32::Registry::KEY_WRITE) do |reg|
      reg[var, Win32::Registry::REG_SZ] = val
    end
  
	  # notify all windows the environment variables
	  # is changed
    require "Win32API"
    _HWND_BROADCAST = 0xFFFF
    _WM_SETTINGCHANGE = 26
    sendMessageTimeout = 
      Win32API.new("user32", "SendMessageTimeout", ['L'] * 3 +
	  					    ['P'] + ['L'] * 3, 'L')
    sendMessageTimeout.call _HWND_BROADCAST, _WM_SETTINGCHANGE, 0, 
      "Environment", 0, 10, 0
    ENV[var] = val
  end

  def add_path(path)
		env_paths = ENV['PATH'].split(/;/).push(path).uniq
		strpath =  env_paths.join(";")
		puts "add path #{path}"
    set_sysenv 'PATH', strpath
	end

	# Using RunDll32.exe.
	# the tip is from
	# http://www.dx21.com/SCRIPTING/RUNDLL32/VIEWITEM.ASP?OID=129&CMD=P-A
	def set_default_printer(printer)
    cmd = 'RunDll32.exe printui.dll,PrintUIEntry /y /n "' << printer << '"'
		system cmd
	end
end
