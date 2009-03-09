class CountersController < ApplicationController

  def show
		id = params[:id]
    @num = 1
		
	  File.open("tmp/#{id}") do |f|
				@num = f.gets.to_i
				@num += 1
				@num = @num.to_s
		end if File.exist?("tmp/#{id}")

		File.open("tmp/#{id}", 'w') do |f|
      f << @num.to_s
		end

    respond_to do |format|
			format.jpeg {
				granite = Magick::ImageList.new('granite:')
				canvas = Magick::ImageList.new
				canvas.new_image(200, 50, Magick::TextureFill.new(granite))
				text = Magick::Draw.new
				text.font_family = 'Ariel'
				text.pointsize = 52
				text.gravity = Magick::CenterGravity
				text.annotate(canvas, 0,0,2,2, @num.to_s) {
					self.fill = 'gray83'
				}
				text.annotate(canvas, 0,0,-1.5,-1.5, @num.to_s) {
					self.fill = 'gray40'
				}
				text.annotate(canvas, 0,0,0,0, @num.to_s) {
					self.fill = 'darkred'
				}
				image = canvas.flatten_images
				image.format = "JPG"
				# send it to the browser
				send_data(image.to_blob, :disposition => 'inline',
				:type => 'image/jpeg')
			}
    end
  end

end
