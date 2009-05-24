require 'ostruct'
dll = "lib/dll/libtiff3.dll"
dll = "lib/dll/hsbdll.dll"
CHARACTERISTICS_MAP = {
  0x1   => "RELOCS_STRIPPED", 
  0x2   => "EXECUTABLE_IMAGE", 
  0x4   => "LINE_NUMS_STRIPPED", 
  0x8   => "LOCAL_SYMS_STRIPPED", 
  0x10  => "AGGRESSIVE_WS_TRIM", 
  0x20  => "LARGE_ADDRESS_AWARE", 
  0x80  => "BYTES_REVERSED_LO", 
  0x100 => "32BIT_MACHINE", 
  0x200 => "DEBUG_STRIPPED", 
  0x400 => "REMOVABLE_RUN_FROM_SWAP" 
}

def get_characteristics flags
	chars = []
	CHARACTERISTICS_MAP.each_key do |k|
	  if flags % k == 0
			chars.push CHARACTERISTICS_MAP[k]
		end
	end
	return chars
end

DLL_CHARACTERISTICS_MAP = {
  0x20   => "DYNAMIC_BASE", 
  0x80   => "FORCE_INTEGRITY", 
  0x100  => "NX_COMPAT", 
  0x200  => "NO_ISOLATION", 
  0x400  => "NO_SEH",  
  0x800  => "NO_BIND",  
  0x2000 => "WDM_DRIVER", 
  0x8000 => "TERMINAL_SERVER_AWARE" 
}

def get_dll_characteristics flags
	chars = []
	DLL_CHARACTERISTICS_MAP.each_key do |k|
	  if flags % k == 0
			chars.push DLL_CHARACTERISTICS_MAP[k]
		end
	end
	return chars
end

OPTIONAL_HEADER_MAGIC = {
  0x10b => "PE32", 
  0x20b => "PE32+"
}

def locate_coff_header f, pe
	c = f.getc
	if c.nil?
		f.rewind
	end
	c = f.getc
	until c.nil?
		if c == 80 #'P'
			if f.getc == 69 #'E'
				if f.getc == 0 #NULL
					if f.getc == 0 #NULL
						rva = pe.rva
						rva.signature = f.pos - 4
					  rva.coff_header = f.pos
					  rva.machine = f.pos
					  rva.number_of_sections = f.pos + 2
					  rva.time_date_stamp = f.pos + 4
					  rva.pointer_to_symbol_table = f.pos + 8
					  rva.number_of_symobls = f.pos + 12
					  rva.size_of_optional_header = f.pos + 16
					  rva.characteristics = f.pos + 18
						return true
					end
				end
			end
		end
		c = f.getc
	end
	return false
end
def parse_coff_header f, pe
	locate_coff_header f, pe
	pe.machine = get_machine f, pe
	pe.number_of_sections = f.read(2).unpack('v')[0]
	pe.time_date_stamp = Time.at(f.read(4).unpack('V')[0])
	pe.pointer_to_symbol_table = f.read(4).unpack('V')[0]
	pe.number_of_symobls = f.read(4).unpack('V')[0]
	pe.size_of_optional_header = f.read(2).unpack('v')[0]
	pe.characteristics = get_characteristics(f.read(2).unpack('v')[0])
end

def get_machine f, pe
	f.seek pe.rva.machine
	machine_code = f.read(2).unpack('v')[0]
	case machine_code
	when 0x14c
		return "intel 386"
	else
    return "unknown"
	end
end

def parse_optional_header f, pe
  pe.rva.optional_header = f.pos 
	pe.optional_header = OpenStruct.new
	optional_header = pe.optional_header
	optional_header.magic = OPTIONAL_HEADER_MAGIC[f.read(2).unpack('v')[0]]
	optional_header.major_linker_version = f.read(1).unpack('c')[0]
	optional_header.minor_linker_version = f.read(1).unpack('c')[0]
	optional_header.size_of_code = f.read(4).unpack('V')[0]
	optional_header.size_of_initialize_data = f.read(4).unpack('V')[0]
	optional_header.size_of_uninitialize_data = f.read(4).unpack('V')[0]
	optional_header.address_of_entry_point = f.read(4).unpack('V')[0]
	optional_header.base_of_code = f.read(4).unpack('V')[0]
	if pe.optional_header.magic == "PE32"
	  optional_header.base_of_data = f.read(4).unpack('V')[0]
		parse_window_specific_field_pe32 f, pe
	else
		parse_window_specific_field_pe32_pluse f, pe
	end
end

def parse_window_specific_field_pe32 f, pe
	optional_header = pe.optional_header
	optional_header.image_base = f.read(4).unpack('V')[0]
	optional_header.section_alignment = f.read(4).unpack('V')[0]
	optional_header.file_alignment = f.read(4).unpack('V')[0]
	optional_header.major_operating_system_version = f.read(2).unpack('v')[0]
	optional_header.minor_operating_system_version = f.read(2).unpack('v')[0]
	optional_header.major_image_version = f.read(2).unpack('v')[0]
	optional_header.minor_image_version = f.read(2).unpack('v')[0]
	optional_header.major_subsystem_version = f.read(2).unpack('v')[0]
	optional_header.minor_subsystem_version = f.read(2).unpack('v')[0]
	optional_header.win32_version_value = f.read(4).unpack('V')[0]
	optional_header.size_of_image = f.read(4).unpack('V')[0]
	optional_header.size_of_headers = f.read(4).unpack('V')[0]
	optional_header.checksum = f.read(4).unpack('V')[0]
	optional_header.subsystem = f.read(2).unpack('v')[0]
	optional_header.dll_characteristics = get_dll_characteristics(f.read(2).unpack('v')[0])
	optional_header.size_of_stack_reserve = f.read(4).unpack('V')[0]
	optional_header.size_of_stack_commit  = f.read(4).unpack('V')[0]
	optional_header.size_of_heap_reserve = f.read(4).unpack('V')[0]
	optional_header.size_of_heap_commit  = f.read(4).unpack('V')[0]
	optional_header.loader_flags = f.read(4).unpack('V')[0]
	optional_header.number_of_rva_and_sizes = f.read(4).unpack('V')[0]
	optional_header.export_table = OpenStruct.new 
	optional_header.export_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.export_table.size = f.read(4).unpack('V')[0]
	optional_header.import_table = OpenStruct.new 
	optional_header.import_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.import_table.size = f.read(4).unpack('V')[0]
	optional_header.resource_table = OpenStruct.new 
	optional_header.resource_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.resource_table.size = f.read(4).unpack('V')[0]
	optional_header.exception_table = OpenStruct.new 
	optional_header.exception_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.exception_table.size = f.read(4).unpack('V')[0]
	optional_header.certificate_table = OpenStruct.new 
	optional_header.certificate_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.certificate_table.size = f.read(4).unpack('V')[0]
	optional_header.base_relocation_table = OpenStruct.new 
	optional_header.base_relocation_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.base_relocation_table.size = f.read(4).unpack('V')[0]
	optional_header.debug = OpenStruct.new 
	optional_header.debug.virtual_address = f.read(4).unpack('V')[0]
	optional_header.debug.size = f.read(4).unpack('V')[0]
	optional_header.architecture = OpenStruct.new 
	optional_header.architecture.virtual_address = f.read(4).unpack('V')[0]
	optional_header.architecture.size = f.read(4).unpack('V')[0]
	optional_header.global_ptr = OpenStruct.new 
	optional_header.global_ptr.virtual_address = f.read(4).unpack('V')[0]
	optional_header.global_ptr.size = f.read(4).unpack('V')[0]
	optional_header.tls_table = OpenStruct.new 
	optional_header.tls_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.tls_table.size = f.read(4).unpack('V')[0]
	optional_header.load_config_table = OpenStruct.new 
	optional_header.load_config_table.virtual_address = f.read(4).unpack('V')[0]
	optional_header.load_config_table.size = f.read(4).unpack('V')[0]
	optional_header.bound_import = OpenStruct.new 
	optional_header.bound_import.virtual_address = f.read(4).unpack('V')[0]
	optional_header.bound_import.size = f.read(4).unpack('V')[0]
	optional_header.iat = OpenStruct.new 
	optional_header.iat.virtual_address = f.read(4).unpack('V')[0]
	optional_header.iat.size = f.read(4).unpack('V')[0]
	optional_header.delay_import_descriptor = OpenStruct.new 
	optional_header.delay_import_descriptor.virtual_address = f.read(4).unpack('V')[0]
	optional_header.delay_import_descriptor.size = f.read(4).unpack('V')[0]
	optional_header.clr_runtime_header = OpenStruct.new 
	optional_header.clr_runtime_header.virtual_address = f.read(4).unpack('V')[0]
	optional_header.clr_runtime_header.size = f.read(4).unpack('V')[0]
	optional_header.reserved = f.read(4).unpack('V')[0] * f.read(4).unpack('V')[0]
end

def load_section_table f, pe
  puts f.read(8) 
end

File.open(dll, "rb") do |f|
  pe = OpenStruct.new
	pe.rva = OpenStruct.new
	pe.file = dll
	parse_coff_header f, pe
	parse_optional_header f, pe
	load_section_table f, pe
	puts pe.optional_header.magic
end
