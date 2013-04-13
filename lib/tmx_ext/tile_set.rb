module Tmx

  #
  # Define additional functionaly or override existing functionaliy on
  # the Tmx class to make it compatible with Metro.
  #
  class TileSet
    attr_accessor :window

    def images
      @images ||= raw_image_tiles.map {|image| crop_image(image) }
    end

    private

    def raw_image_tiles
      Gosu::Image.load_tiles(window, image_path, full_image_width, full_image_height, false)
    end

    def crop_image(image)
      Metro::Image.crop window, image, crop_bounds
    end

    def full_image_width
      tilewidth + spacing
    end

    def full_image_height
      tileheight + spacing
    end

    def crop_bounds
      @crop_bounds ||= Metro::Units::RectangleBounds.new left: margin, top: margin,
                        right: tilewidth + spacing, bottom: tileheight + spacing
    end

    def image_path
      Metro::AssetPath.with(image).filepath
    end
  end
end