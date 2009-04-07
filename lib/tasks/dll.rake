require "dl/import"
require 'win32ole'
module Hsbdll
  extend DL::Importable
  #dlload "lib/dll/libtiff3.dll"
end

namespace "dll" do
	task :view  do
    #puts Hsbdll.methods.join(';')
		#puts DL::Importable::LIB_MAP["lib/dll/libtiff3.dll"].keys.join(';')
	end

  task :usb do
    wmi = WIN32OLE.connect("winmgmts://")

		devices = wmi.ExecQuery("Select * From Win32_USBControllerDevice")
		for device in devices do
			device_name = device.Dependent.gsub('"', '').split('=')[1]
			usb_devices = wmi.ExecQuery("Select * From Win32_PnPEntity Where DeviceID = '#{device_name}'")
			for usb_device in usb_devices do
        puts usb_device.Description
        if usb_device.Description == 'USB Mass Storage Device'
          # DO SOMETHING HERE
					puts
        end
			end
		end
	end
	
end
