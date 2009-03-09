class HelloController < ApplicationController
  include AuthenticatedSystem
	before_filter :login_required, :only => [:rails]
	def rails
		@hello_string = 'Hello Rails!'
	end
end
