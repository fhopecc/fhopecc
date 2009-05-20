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
USB.usb_init
c = USB.usb_find_busses
puts "There are #{c.to_s} usb busses."
c = USB.usb_find_devices
puts "There are #{c.to_s} usb devices."
=begin
struct usb_bus {
  struct usb_bus *next, *prev;

  char dirname[LIBUSB_PATH_MAX];

  struct usb_device *devices;
  unsigned long location;

  struct usb_device *root_dev;
};
=end
busses = USB.usb_get_busses
puts "It is " + busses.inspect.to_s
busses.struct! 'PPSPLP', :next, :prev, :dirname, 
	             :devices, :location, :root_dev
dn = busses[:dirname]
puts "It is " + dn.inspect.to_s
#puts "Type is " +  dn.class.name
#puts "It is " + dn

l = busses[:location]
puts "It is " + l.inspect.to_s

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
devs = busses[:devices]
puts "It is " + devs.inspect.to_s
puts "devnum is" + devs[:filename]

#puts "There are " + busses.class.name
#devs = 
#devs = busses[:devices]
#puts "There are " + devs.to_s
