rule ".exe" => [".c"] do |t| 
	`gcc #{t.source}`
end
