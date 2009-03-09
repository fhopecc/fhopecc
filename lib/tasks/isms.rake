namespace 'isms' do
	root = 'doc/isms_audit'
	desc 'make word'
  task :make_word do
		require "#{root}/gen_erb"
		`gerbil #{root}/isms.fmt #{root}/group1.erb > #{root}/word_script.rb`
		`ruby #{root}/word_script.rb`
		`gerbil #{root}/isms.fmt #{root}/group2.erb > #{root}/word_script.rb`
		`ruby #{root}/word_script.rb`
		`gerbil #{root}/isms.fmt #{root}/group3.erb > #{root}/word_script.rb`
		`ruby #{root}/word_script.rb`
		`gerbil #{root}/isms.fmt #{root}/group4.erb > #{root}/word_script.rb`
		`ruby #{root}/word_script.rb`

	end
end
