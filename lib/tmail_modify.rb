require 'tmail'
module TMail
	class UNIXMbox
		def fromline2time( line )
			m = /\AFrom \S+ \w+ (\w+) (\d+) (\d+):(\d+):(\d+) (\d+)/.match(line) \
							or return nil
			begin
				Time.local(m[6].to_i, m[1], m[2].to_i, m[3].to_i, m[4].to_i, m[5].to_i)
			rescue
				return nil
			end
		end
	end
end
