require 'dl/import'
require 'scanf'
dllex = DL.dlopen 'dll.dll'
init_list = dllex['init_list', 'PI']
printf "Enter the number of a list:"
num = $stdin.scanf("%d").first
r, rs = init_list.call num
until r.nil?
  r.struct! 'IP', :val, :next
  print "->#{r[:val]}"
	r = r[:next]
end
puts
