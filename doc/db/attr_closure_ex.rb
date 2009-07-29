require 'set'
def attr_closure a,fds
  i,c=0,[a]
	puts "c[0] = #{c[0].to_a.join('')}"
  loop do
    i+=1
		c[i]=c[i-1]
    fds.each_pair do |l,r|
			if c[i].superset? l
			  puts "apply #{l.to_a.join('')} -> #{r.to_a.join('')}"
				c[i] += r
		    puts "c[#{i}] = #{c[i].to_a.join('')}"
      end
		end
		puts "c[#{i}] = #{c[i].to_a.join('')}"
	  break if c[i] == c[i-1]
	end
  c[i]
end
#C J Date Database system 6th example
fds = {
 Set['A'] => Set['B','C'], 
 Set['E'] => Set['C','F'], 
 Set['B'] => Set['E'], 
 Set['C','D'] => Set['E','F'] 
}
a = Set['A','B']
ac = attr_closure a, fds
puts "closure[#{a.to_a.join('')}] = #{ac.to_a.join('')}"
