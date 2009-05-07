require "win32ole" if RUBY_PLATFORM =~ /win/
begin 
  word = WIN32OLE.connect("word.application") 
rescue 
  word = WIN32OLE.new("word.application") 
  word.documents.add 
end 
word.visible = true 
selection = word.selection
selection.typeText("Hello WIN32OLE!")
