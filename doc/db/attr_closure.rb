require 'set'
def attr_closure a,fds
  i,c=0,[a]
  loop do
    i+=1
    c[i]=c[i-1]
    fds.each_pair do |l,r|
      if c[i].superset? l
        c[i] += r
      end
    end
    break if c[i] == c[i-1]
  end
  c[i]
end
