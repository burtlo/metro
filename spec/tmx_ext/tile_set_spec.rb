require 'spec_helper'

describe Tmx::TileSet do

  let(:window) { stub('window') }

  let(:subject) do
    tile_set = described_class.new tilewidth: 10, tileheight: 20,
      margin: 2, spacing: 2, image: "tile_image.png"
    tile_set.window = window
    tile_set
  end

  describe "#images" do
    let(:raw_images) { [ double("image-1"), double("image-2") ] }

    it "returns an array of images" do
      subject.should_receive(:raw_image_tiles).and_return(raw_images)
      subject.should_receive(:crop_image).twice
      subject.images
    end
  end

end