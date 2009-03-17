class DbDumpersController < ApplicationController

  def show
    respond_to do |format|
			format.yml {
				sio = StringIO.new
				YamlDb::Dump.dump sio
				#zio = nil 
        #Zlib::GzipWriter.new(StringIO.new, Zlib::BEST_COMPRESSION, nil) do |gz|
				#  sio.rewind
				#  gz << sio.read
				#	zio = gz.finish
				#  zio.rewind
				#end
				sio.rewind
        send_data(sio.read, :filename => "data.yml" ,:type => 'text/yaml')
				#sio.rewind
				#render :text => sio.read
			}
    end
  end

end
