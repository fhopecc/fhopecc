require 'os'
namespace "env" do
  os = OS.instance
  desc "configurate OS's environment"
  task :os do 
    fhope_home = Dir.pwd
    rblib = "#{fhope_home}/ruby"
    rbhome = 'C:\ruby'
    mingwhome = 'C:\MinGW'

    os.set_sysenv 'RUBYLIB', rblib
    os.set_sysenv 'FHOPE_HOME', Dir.pwd
    os.set_sysenv 'RUBYHOME', rbhome
    os.set_sysenv 'MinGWHome', mingwhome
    os.add_path(mingwhome << '\bin')
    os.del_path("D:/fhopecc")
    os.uniq_path
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
  task :setup_python do
    py_root = 'C:\Python25'
    os.add_path py_root
  end
  desc "configurate ctags environment"
  task :config_ctags do
    ctags_home = 'c:\ctags56'
    set_sysenv 'CTAGS_HOME', ctags_home
    set_sysenv 'PATH', "#{ENV['PATH']};#{ctags_home}"
  end
end
