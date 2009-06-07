require 'dl/import'
LIB = DL.dlopen 'dll.dll'
times2 = LIB['times2', 'II']
r, rs = times2.call(3)
puts "times2(3)= #{r}"

times3 = LIB['times3', 'ii']
r, rs = times3.call(3)
puts "times2(3)= #{rs[0]}"
puts "times2(3)= #{r}"

struct_test = LIB['struct_test', 'P']
r, rs = struct_test.call()
r.struct!('II', :int1, :int2)
puts "st1->int1= #{r[:int1]}"
puts "st1->int2= #{r[:int2]}"

return_intp = LIB['return_intp', 'ii']
r, rs = return_intp.call(3)
puts "return_intp= #{r}"
puts "return_intp= #{rs}"

init_list = LIB['init_list', 'P']
r, rs = init_list.call
puts "Printing linked list..."
until r.nil?
  r.struct! 'IP', :val, :next
  print "->#{r[:val]}"
	r = r[:next]
end
puts


init_phonebook = LIB['init_phonebook', 'P']
r, rs = init_phonebook.call
puts "Printing phoebook..."
until r.nil?
  r.struct! 'SSSP', :first, :last, :number, :next
  print "#{r[:first]}, #{r[:last]}: #{r[:number]} "
	r = r[:next]
end
puts

