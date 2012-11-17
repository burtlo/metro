require 'spec_helper'

describe Metro::Model::DimensionsProperty do

  subject { desribed_class.new model }
  let(:model) { mock("model", window: window) }
  let(:window) do
    mock('window',dimensions: window_dimensions )
  end

  let(:window_dimensions) { Dimensions.of(1,1) }

  context "when defined with a default block" do

    subject do
      described_class.new model do
        window.dimensions
      end
    end

    let(:expected_dimensions) { window_dimensions }

    it "should calculate the correct default value" do
      subject.get(nil).should eq expected_dimensions
    end

  end

end