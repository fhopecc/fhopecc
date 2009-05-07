require 'test/unit/assertions'
include Test::Unit::Assertions
desc "java 環境設定"
task :config_java do
	begin
	  assert system("java -version"), "java test failed" 
	  assert system("javac -help"), "javac test failed" 

	rescue Test::Unit::AssertionFailedError
		case $!.message
    when /^javac test failed/ 
			puts "搜尋 javac.exe"
			javacfl = FileList['c:/**/javac.exe']
			javacfl.each_with_index do |item, index|
				puts "[#{index}] #{item}"
			end
			puts "請選擇一個 javac.exe?"
			sel = $stdin.readline.chop
			javacpath = File.dirname(javacfl.entries[sel.to_i])
			os.add_path(javacpath)
			puts "已將 #{javacpath} 新增至程式搜尋路徑中"
    when /^java test failed/ 
			puts "搜尋 java.exe"
			javafl = FileList['c:/**/java.exe']
			javafl.each_with_index do |item, index|
				puts "[#{index}] #{item}"
			end
			puts "請選擇一個 java.exe?"
			sel = $stdin.readline.chop
			javapath = File.dirname(javafl.entries[sel.to_i])
			os.add_path(javapath)
			puts "已將 #{javapath} 新增至程式搜尋路徑中"
		else
			puts "error: #{$!}"
		end
	end
end

desc "強制 java 環境設定"
task :fconfig_java do
	puts "搜尋 javac.exe"
	javacfl = FileList['c:/**/javac.exe']
	javacfl.each_with_index do |item, index|
	  puts "[#{index}] #{item}"
  end
	puts "請選擇一個 javac.exe?"
	sel = $stdin.readline.chop
	javacpath = File.dirname(javacfl.entries[sel.to_i])
	os.del_paths(javacfl.entries.collect {|f| File.dirname(f)})
	os.add_path(javacpath)
	puts "已將 #{javacpath} 新增至程式搜尋路徑中"
	puts "搜尋 java.exe"
	javafl = FileList['c:/**/java.exe']
	javafl.each_with_index do |item, index|
    puts "[#{index}] #{item}"
	end
  puts "請選擇一個 java.exe?"
  sel = $stdin.readline.chop
	javapath = File.dirname(javafl.entries[sel.to_i])
	os.del_paths(javafl.entries.collect {|f| File.dirname(f)})
	os.add_path(javapath)
	puts "已將 #{javapath} 新增至程式搜尋路徑中"
	winsys32path = 'c:/windows/system32'
  os.add_path winsys32path
end

