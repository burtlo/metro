module Tmxed
  class TileSet
    attr_accessor :window

    def images
      @images ||= Gosu::Image.load_tiles(window,Metro::AssetPath.with(image).filepath,tilewidth,tileheight,true)
    end
  end
end