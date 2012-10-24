require 'spec_helper'

describe Gosu::Color do

  shared_examples "a correctly defined color" do

    let(:expected_red_value) { expected_color_values[0] }
    let(:expected_green_value) { expected_color_values[1] }
    let(:expected_blue_value) { expected_color_values[2] }
    let(:expected_alpha_value) { expected_color_values[3] }

    it "should have the correct red color" do
      subject.red.should eq expected_red_value
    end

    it "should have the correct green color" do
      subject.green.should eq expected_green_value
    end

    it "should have the correct blue color" do
      subject.blue.should eq expected_blue_value
    end

    it "should have the correct alpha value" do
      subject.alpha.should eq expected_alpha_value
    end
  end

  shared_examples "a color defined as white" do
    let(:expected_color_values) { [ 255, 255, 255, 255 ] }
    it_behaves_like "a correctly defined color"
  end

  describe "#initialize" do

    context "when defined with an existing Gosu Color" do
      subject { described_class.new color }
      let(:color) { described_class.new 123, 123, 123, 0 }
      let(:expected_color_values) { [ 123, 123, 0, 123 ] }
      it_behaves_like "a correctly defined color"
    end

    context "when defined with a hexadecimal value" do
      subject { described_class.new hex }
      let(:hex) { 0xFF777777 }
      let(:expected_color_values) { [ 119, 119, 119, 255 ] }
      it_behaves_like "a correctly defined color"
    end

    context "when defined with a gosu color hex string" do
      subject { described_class.new hex }
      let(:hex) { "0xFF777777" }
      let(:expected_color_values) { [ 119, 119, 119, 255 ] }
      it_behaves_like "a correctly defined color"
    end

    context "when defined with a hex string" do
      subject { described_class.new hex }
      let(:hex) { "#777777" }
      let(:expected_color_values) { [ 119, 119, 119, 255 ] }
      it_behaves_like "a correctly defined color"
    end

    context "when defined with a rgb string" do
      subject { described_class.new rgb }
      let(:rgb) { "rgb(127,127,127)" }
      let(:expected_color_values) { [ 127, 127, 127, 255 ] }
      it_behaves_like "a correctly defined color"
    end

    context "when defined with a rgba color" do
      subject { described_class.new rgba }
      let(:rgba) { "rgba(127,127,127,0.5)" }
      let(:expected_color_values) { [ 127, 127, 127, 127 ] }
      it_behaves_like "a correctly defined color"
    end

  end

end