class DbDumpersController < ApplicationController

  def show
    respond_to do |format|
			format.gz {
				sio = StringIO.new
				YamlDb::Dump.dump sio
				zio = nil 
        Zlib::GzipWriter.new(StringIO.new, Zlib::BEST_COMPRESSION, nil) do |gz|
				  sio.rewind
				  gz << sio.read
					zio = gz.finish
				  zio.rewind
				end
        send_data(zio.read, :filename => "db" ,:type => 'application/octet-stream')
			}
    end
  end

end
