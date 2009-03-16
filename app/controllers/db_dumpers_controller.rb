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
        z = Zlib::Deflate.new(Zlib::BEST_COMPRESSION)
        dst = z.deflate(string, Zlib::FINISH)
        z.close
        dst
				# send it to the browser
				send_data(dst, :filename => "dbdump.zip" ,:type => 'binary/zip')
			}
    end
  end

end
