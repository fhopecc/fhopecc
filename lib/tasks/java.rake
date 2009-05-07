require 'test/unit/assertions'
include Test::Unit::Assertions
desc "java ���ҳ]�w"
task :config_java do
	begin
	  assert system("java -version"), "java test failed" 
	  assert system("javac -help"), "javac test failed" 

	rescue Test::Unit::AssertionFailedError
		case $!.message
    when /^javac test failed/ 
			puts "�j�M javac.exe"
			javacfl = FileList['c:/**/javac.exe']
			javacfl.each_with_index do |item, index|
				puts "[#{index}] #{item}"
			end
			puts "�п�ܤ@�� javac.exe?"
			sel = $stdin.readline.chop
			javacpath = File.dirname(javacfl.entries[sel.to_i])
			os.add_path(javacpath)
			puts "�w�N #{javacpath} �s�W�ܵ{���j�M���|��"
    when /^java test failed/ 
			puts "�j�M java.exe"
			javafl = FileList['c:/**/java.exe']
			javafl.each_with_index do |item, index|
				puts "[#{index}] #{item}"
			end
			puts "�п�ܤ@�� java.exe?"
			sel = $stdin.readline.chop
			javapath = File.dirname(javafl.entries[sel.to_i])
			os.add_path(javapath)
			puts "�w�N #{javapath} �s�W�ܵ{���j�M���|��"
		else
			puts "error: #{$!}"
		end
	end
end

desc "�j�� java ���ҳ]�w"
task :fconfig_java do
	puts "�j�M javac.exe"
	javacfl = FileList['c:/**/javac.exe']
	javacfl.each_with_index do |item, index|
	  puts "[#{index}] #{item}"
  end
	puts "�п�ܤ@�� javac.exe?"
	sel = $stdin.readline.chop
	javacpath = File.dirname(javacfl.entries[sel.to_i])
	os.del_paths(javacfl.entries.collect {|f| File.dirname(f)})
	os.add_path(javacpath)
	puts "�w�N #{javacpath} �s�W�ܵ{���j�M���|��"
	puts "�j�M java.exe"
	javafl = FileList['c:/**/java.exe']
	javafl.each_with_index do |item, index|
    puts "[#{index}] #{item}"
	end
  puts "�п�ܤ@�� java.exe?"
  sel = $stdin.readline.chop
	javapath = File.dirname(javafl.entries[sel.to_i])
	os.del_paths(javafl.entries.collect {|f| File.dirname(f)})
	os.add_path(javapath)
	puts "�w�N #{javapath} �s�W�ܵ{���j�M���|��"
	winsys32path = 'c:/windows/system32'
  os.add_path winsys32path
end

