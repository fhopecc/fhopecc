require 'RMagick'
# parameter notation
# f -> image files

def resize_pic(f, size)
  img = Magick::ImageList.new(f)
  img.resize(size).write(f)
end

# f image file
def crop_pic(f, x1, y1, x2, y2)
  img = Magick::ImageList.new(f)
  img.crop(x1, y1, x2, y2).write(f)
end
