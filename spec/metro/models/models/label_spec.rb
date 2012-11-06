require 'spec_helper'

describe Metro::Models::Label do

  subject do
    label = described_class.new
    label.window = mock('window')
    label
  end

  let(:expected_position) { Metro::Point.new 320, 240 }
  its(:position) { should eq expected_position }

  context "when setting the position" do

    it "should be set succesfully" do
      subject.position = "10,10"
      subject.position.should eq Metro::Point.new 10, 10
    end

    context "when setting the x property" do
      let(:expected_x) { 11 }
      let(:expected_y) { 240 }

      it "should update successfully" do
        subject.x = expected_x
        subject.x.should eq expected_x
        subject.position.x.should eq expected_x
      end

      it "should not effect the paired y property" do
        subject.x = expected_x
        subject.y.should eq expected_y
        subject.position.y.should eq expected_y
      end
    end

    context "when setting the y property" do
      let(:expected_x) { 320 }
      let(:expected_y) { 66 }

      it "should update successfully" do
        subject.y = expected_y
        subject.y.should eq expected_y
        subject.position.y.should eq expected_y
      end

      it "should not effect the paired x property" do
        subject.y = expected_y
        subject.x.should eq expected_x
      end
    end

  end

  its(:x) { should eq expected_position.x }
  its(:y) { should eq expected_position.y }

  let(:expected_scale) { Metro::Scale.default }

  its(:scale) { should eq expected_scale }
  its(:x_factor) { should eq expected_scale.x_factor }
  its(:y_factor) { should eq expected_scale.y_factor }

  let(:expected_color) { Gosu::Color.new "rgb(255,255,255)" }
  let(:expected_alpha) { 255 }

  its(:color) { should eq expected_color }
  its(:alpha) { should eq expected_alpha }


  describe "font" do
    before do
      Metro::Model::FontProperty.stub(:create_font).and_return(font)
    end

    let(:font) { mock('font', name: expected_font_name, size: expected_font_size) }

    let(:expected_font) { font }
    its(:font) { should eq expected_font }

    let(:expected_font_name) { 'mock_font_name' }
    its(:font_name) { should eq expected_font_name }

    let(:expected_font_size) { 12.0 }
    its(:font_size) { should eq expected_font_size }

  end


  context "when setting the scale" do
    it "should set" do
      subject.x_factor = 2.0
      subject.x_factor.should eq 2.0
      subject.scale.x_factor.should eq 2.0
    end
  end

end