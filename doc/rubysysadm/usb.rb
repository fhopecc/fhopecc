require 'dl/import'
module USB
  extend DL::Importable
  dlload "libusb0.dll"
	extern "void usb_init()"
	extern "int usb_find_busses()"
	extern "int usb_find_devices()"
end
USB.usb_init
c = USB.usb_find_busses
puts "There are #{c.to_s} usb busses."
c = USB.usb_find_devices
puts "There are #{c.to_s} usb devices."
