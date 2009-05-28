require 'Win32API'
result = "0"*8   # Eight bytes (enough for two longs)
getCursorXY = Win32API.new("user32","GetCursorPos",["P"],"V")
getCursorXY.call(result)
x, y = result.unpack("LL")  # Two longs
puts "The cursor is in (#{x}, #{y})."
