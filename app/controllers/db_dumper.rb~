class DbDumpersController < ApplicationController

  def show
    respond_to do |format|
			format.text {
				sio = StringIO.new
				YamlDb::Dump.dump sio
				sio.rewind
				string = ""
        sio.each_line do |l|
					string << l + "\n"
					logger.debug "abcddd " + l
				end
				# send it to the browser
				send_data(string, :filename => "dbdump" ,:type => 'text/plain')
			}
    end
  end

end
