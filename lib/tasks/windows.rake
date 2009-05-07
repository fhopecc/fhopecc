namespace "mswin" do
  os = OS.instance
  intra_printer = 'intranet'
  inter_printer = 'internet'

	desc "switch to intranet"
	task :switch_intranet do
		setIP =  "netsh interface ip set address local "
		ipConfig="static 10.66.4.56 255.255.255.0 10.66.4.254 1"
		cmd = setIP + ipConfig
		puts cmd
		system cmd

		setDNS =  "netsh interface ip set dns local " 
		dnsConfig="static 10.66.4.5 primary"
		cmd = setDNS + dnsConfig
		puts cmd
		system cmd

		setDNS2 =  "netsh interface ip add dns local " 
		dnsConfig2="168.95.1.1 index=2"
		cmd = setDNS2 + dnsConfig2
		puts cmd
		system cmd

		setWINS =  "netsh interface ip set wins local " 
		winsConfig="static 10.66.4.5"
		cmd = setWINS + winsConfig
		puts cmd
		system cmd

	  os.set_default_printer intra_printer
		puts "set default printer = #{intra_printer}"
	end

	desc "switch internet"
	task :switch_internet do
		setIP =  "netsh interface ip set address local "
		ipConfig="static 192.168.1.101 255.255.255.0 192.168.1.254 1"
		cmd = setIP + ipConfig
		puts cmd
		system cmd

		setDNS =  "netsh interface ip set dns local " 
		dnsConfig="static 192.168.1.4 primary"
		cmd = setDNS + dnsConfig
		puts cmd
		system cmd

		setDNS2 =  "netsh interface ip add dns local " 
		dnsConfig2="172.17.1.5 index=2"
		cmd = setDNS2 + dnsConfig2
		puts cmd
		system cmd

		setWINS =  "netsh interface ip set wins local " 
		winsConfig ="static 192.168.1.4"
		cmd = setWINS + winsConfig
		puts cmd
		system cmd

	  os.set_default_printer inter_printer
		puts "set default printer = #{inter_printer}"
	end
end
