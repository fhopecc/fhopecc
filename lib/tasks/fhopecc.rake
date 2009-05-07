#rakefile for fhope project
#fhope@2006/8/24 ¤U¤È 03:21:05
require 'os'
namespace "fhopecc" do
os = OS.instance

desc "configurate OS's environment"
task :setup => :setup_os_env
task :setup_os_env do 
  fhope_home = Dir.pwd
  rblib = "#{fhope_home}/ruby"
	rbhome = 'C:\ruby'
	mingwhome = 'C:\MinGW'

	os.set_sysenv 'RUBYLIB', rblib
  os.set_sysenv 'FHOPE_HOME', Dir.pwd
  os.set_sysenv 'RUBYHOME', rbhome
  os.set_sysenv 'MinGWHome', mingwhome
	os.add_path(mingwhome << '\bin')
end

desc "setup ruby file executable"
task :setup_ruby_executable do
	path = "#{path};d:\\fhopecc\\hltb\\script\\backup"

	os.add_path 'c:\ruby\bin'
  os.add_path 'C:\tiff-3.8.2-1-bin\bin'
	os.add_path 'd:\fhopecc\hltb\script\backup'
	os.add_path 'd:\fhopecc\hltb\script\backup'
  pathext = "#{ENV['PATHEXT']};.RB"
  os.set_sysenv 'PATHEXT', pathext
end

desc "configurate ctags environment"
task :config_ctags do
  ctags_home = 'c:\ctags56'
  set_sysenv 'CTAGS_HOME', ctags_home
  set_sysenv 'PATH', "#{ENV['PATH']};#{ctags_home}"
end
end

def nvl value, default_value
	if value.nil? then default_value else value end
end
