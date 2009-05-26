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
puts "there is #{r} busses in your machine"
usb_find_devices = LIB['usb_find_devices', 'I']
LIBUSB_PATH_MAX = 512
r, rs = usb_find_devices.call
puts "there is #{r} device in your machine"
=begin
struct usb_bus {
  struct usb_bus *next, *prev;
  char dirname[LIBUSB_PATH_MAX];
  struct usb_device *devices;
  unsigned long location;
  struct usb_device *root_dev;
};
struct usb_bus *usb_get_busses(void);
=end
usb_get_busses = LIB['usb_get_busses', 'P']
r, rs = usb_get_busses.call
puts r.class.name
puts r.size
ref = r.ref
r.struct! 'PPSPLP', :next, :prev, :dirname, 
	                    :devices, :location, :root_dev
next_b = r[:next].null?
puts next_b
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
