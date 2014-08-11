require 'spec_helper'

describe Metro::Image do

  describe "Class Methods" do

    let(:subject) { described_class }

    describe ".crop" do

      let(:image) { double('Original Image') }
      let(:window) { double('Gosu::Window') }
      let(:mock_image) { double("TexPlay Created Image",refresh_cache: nil) }
      let(:bounds) { Metro::Units::RectangleBounds.new(left: 2,top: 2,right: 30,bottom:30) }

      let(:expected_crop_params) { [ bounds.left, bounds.top, bounds.right, bounds.bottom ]}

      it "crops the image with the bounds provided" do
        TexPlay.should_receive(:create_image).and_return(mock_image)
        mock_image.should_receive(:splice).with(image,0,0,crop: expected_crop_params)

        subject.crop(window,image,bounds)
      end

      it "refreshes the cache for the image so when Metro reloads the images are not corrupt" do

      end

    end

  end

end