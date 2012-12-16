module Tmxed
  class TileSet
    attr_accessor :window

    def full_width
      tilewidth + spacing
    end

    def full_height
      tileheight + spacing
    end

    def crop_bounds
      [ margin, margin, tilewidth - spacing, tileheight - spacing ]
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
      images
    end
  end
end