require 'doc\db\attr_closure.rb'
#95c3-1
FDS = {
 Set['A','B'] => Set['C'], 
 Set['C','D'] => Set['E'], 
 Set['D','E'] => Set['B','F'], 
 Set['F'] => Set['G'],
 Set['G'] => Set['D'],
}
def print_closure a
  ac = attr_closure a, FDS
  puts "closure[#{a.to_a.join('')}] = #{ac.to_a.join('')}"
end
print_closure Set['A','B']
print_closure Set['A','C']
print_closure Set['A','D']
print_closure Set['A','E']
print_closure Set['A','F']
print_closure Set['A','G']
print_closure Set['A','B','C']
print_closure Set['A','B','D']
print_closure Set['A','B','E']
print_closure Set['A','B','F']
print_closure Set['A','B','G']
print_closure Set['A','E','F']
print_closure Set['A','E','G']
print_closure Set['D','E']
print_closure Set['A','D','E']
print_closure Set['D','E','F']

