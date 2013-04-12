module Tmx

  #
  # Define additional functionaly or override existing functionaliy on
  # the Tmx class to make it compatible with Metro.
  #
  class TileSet
    attr_accessor :window

    def full_width
      tilewidth + spacing
    end

    def full_height
      tileheight + spacing
    end

    def crop_bounds
      #[ margin, margin, tilewidth - spacing, tileheight - spacing ]
      [ margin, margin, tilewidth + margin - spacing + 1, tileheight + margin - spacing + 1 ]
    end

    def image_path
      Metro::AssetPath.with(image).filepath
    end

    def images
      @images ||= begin
        original_images = Gosu::Image.load_tiles window, image_path, full_width,full_height, true
        crop_images original_images
      end
    end

    private

    def crop_images(images)
      # @TODO: Originally the use of Texplay caused corruption on cropping (when reloading) and slowness in execution
      return images unless spacing > 0
      images.map do |image|
        cropped_image = TexPlay.create_image(window,tilewidth,tileheight)
        cropped_image.splice image, 0, 0, crop: crop_bounds
        cropped_image
      end
    end

  end
end