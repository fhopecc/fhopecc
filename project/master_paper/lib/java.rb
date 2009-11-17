require 'rake'
require 'fileutils.rb'
class Java
	include FileUtils
  attr_accessor :javac, :source, :target, :extclasspath, :classesdir 
	attr_accessor :jars, :configs, :srcs, :target_dir
	attr_accessor :test_runner

	SwingRunner = "junit.swingui.TestRunner"
	AWTRunner = "junit.awtui.TestRunner"
	TextRunner ="junit.textui.TestRunner"

	def initialize(_source='1.5', _target='1.5')
	  @javac, @source, @target='javac', _source, _target
	  @extclasspath, @classesdir=[], '.'
	  @srcs=Rake::FileList['*.java']
	  @jars=Rake::FileList['*.jar']
	  @configs=Rake::FileList['src/**/log4j.properties','src/**/Proxool.xml']
    @test_runner= TextRunner
    @target_dir = Dir.pwd + "/" + classesdir
	end

  def Java.package_of(javafile)
	  file=File.new(javafile)
    file.each do |line|
      return line.sub(/package /,'').sub(/;/,'').sub(/\s/,'') if line =~ /^package/
    end
    return '' # empty string mean no package
  end	

  def Java.java_path(javafile)
  	return Java.package_of(javafile).gsub(/\./, '/')
  end

	def Java.class_name(javafile)
		return Java.package_of(javafile) + '.' + File.basename(javafile, '.java')
	end

  # infer classpath from the options
  def classpath
		# current dir
		cpath = ['.']
    # from the user config
    cpath |= @extclasspath
  	# add classesdir
  	cpath |= [@classesdir]

  	cpath |= [@target_dir]

  	# add java source pathes
  	#srcs.each do |f|
  	#	fpath=File.dirname(f).sub(Java.java_path(f), '')
    #		cpath |= [fpath]
	  #end

	  # add the jars
	  cpath |= jars.to_a 
	  cpath.join ';'
  end

  def compile_cmd_str 
		sfs = ""
		basedir = Dir.pwd
    srcs.each do |f|
		  dir="#{@target_dir}/#{Java.java_path(f)}"
      mkdir_p dir unless File.exist? dir
      sf=basedir+"/"+f
	  	tf=dir+"/"+File.basename(f, File.extname(f))+".class"
	  	needed=true
	  	if File.exist? tf then
    		if uptodate? tf, sf then 
	  		  puts tf+ " is uptodated."
	  			needed=false
	  	  end
	  	end
      sfs += sf + " "
  	end
    cmd = "#{javac} -source #{source} -target #{target} -classpath #{classpath} -d #{@target_dir} #{sfs} " 
  end
  
	def compile
		puts compile_cmd_str
    system compile_cmd_str
	end

  def run jclass, param=""
		puts "java -classpath #{classpath} #{jclass} #{param}"
    system "java -classpath #{classpath} #{jclass} #{param}"
	end

	def unit_test jclass
		puts jclass
    run test_runner, jclass
	end
end
