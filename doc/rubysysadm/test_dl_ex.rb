require 'dl/import'
LIB = DL.dlopen 'dl_ex.dll'
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
