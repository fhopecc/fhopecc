require 'dl/import'
module USB
  extend DL::Importable
  dlload "libusb0.dll"
	LIB = DL.dlopen('libusb0.dll')
	SYM = {
		     :get_busses => LIB["usb_get_busses", 'P']
	}
	extern "void usb_init()"
	extern "int usb_find_busses()"
	extern "int usb_find_devices()"
  extern "struct usb_bus *usb_get_busses()"
end
LIB = DL.dlopen 'libusb0.dll'
usb_init = LIB['usb_init', '0']
r, rs = usb_init.call
usb_find_busses = LIB['usb_find_busses', 'I']
r, rs = usb_find_busses.call
usb_find_devices = LIB['usb_find_devices', 'I']
LIBUSB_PATH_MAX = 512
r, rs = usb_find_devices.call
=begin
struct usb_bus {
  struct usb_bus *next, *prev;
  char dirname[LIBUSB_PATH_MAX];
  struct usb_device *devices;
  unsigned long location;
  struct usb_device *root_dev;
};
=end
usb_get_busses = LIB['usb_get_busses', 'P']
r, rs = usb_get_busses.call
puts r.class.name
puts r.nil?.to_s
next_bus = r[0]
puts r.nil?.to_s
#r.struct! 'PPSPLP', :next, :prev, :dirname, 
	       #           :devices, :location, :root_dev
#puts r.class.name
#puts r[DL.sizeof('PP')].to_ptr.class.name
#dirname = r[DL.sizeof('PP')].to_ptr
#a = dirname.to_a('C', LIBUSB_PATH_MAX)
#puts a.size

#USB.usb_init
#c = USB.usb_find_busses
#puts "There are #{c.to_s} usb busses."
#c = USB.usb_find_devices
#puts "There are #{c.to_s} usb devices."
#busses = USB.usb_get_busses
#puts "It is " + busses.inspect.to_s
#busses.struct! 'PPSPLP', :next, :prev, :dirname, 
	             #:devices, :location, :root_dev
#dn = busses[:dirname]
#puts "It is " + dn.inspect.to_s
#puts "Type is " +  dn.class.name
#puts "It is " + dn

#l = busses[:location]
#puts "It is " + l.inspect.to_s

=begin
struct usb_device {
  struct usb_device *next, *prev;

  char filename[LIBUSB_PATH_MAX];

  struct usb_bus *bus;

  struct usb_device_descriptor descriptor;
  struct usb_config_descriptor *config;

  void *dev;		/* Darwin support */

  unsigned char devnum;

  unsigned char num_children;
  struct usb_device **children;
};
=end
=begin
devs = r[DL.sizeof('PPP')].to_ptr
filename = r[DL.sizeof('PP')].to_ptr
a = filename.to_a 'C', LIBUSB_PATH_MAX
puts a.size
blength = r[DL.sizeof('PPPPC')]
puts blength.to_s
=end
=begin
struct usb_device_descriptor {
  unsigned char  bLength;
  unsigned char  bDescriptorType;
  unsigned short bcdUSB;
  unsigned char  bDeviceClass;
  unsigned char  bDeviceSubClass;
  unsigned char  bDeviceProtocol;
  unsigned char  bMaxPacketSize0;
  unsigned short idVendor;
  unsigned short idProduct;
  unsigned short bcdDevice;
  unsigned char  iManufacturer;
  unsigned char  iProduct;
  unsigned char  iSerialNumber;
  unsigned char  bNumConfigurations;
};

=end
#devs = busses[:devices]
#puts "It is " + devs.inspect.to_s
#puts "devnum is" + devs[:filename]

#puts "There are " + busses.class.name
#devs = 
#devs = busses[:devices]
#puts "There are " + devs.to_s
