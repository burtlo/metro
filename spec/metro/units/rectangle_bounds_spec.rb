require 'spec_helper'

describe RectangleBounds do

  let(:subject) { described_class.new left: 20, top: 30, right: 40, bottom: 60 }

  shared_examples "valid point" do
    it "correct point" do
      expect(given_point).to eq expected_point
    end
  end

  describe "#top_left" do
    it_behaves_like "valid point" do
      let(:given_point) { subject.top_left }
      let(:expected_point) { Point.at 20, 30 }
    end
  end

  describe "#top_right" do
    it_behaves_like "valid point" do
      let(:given_point) { subject.top_right }
      let(:expected_point) { Point.at 40, 30 }
    end
  end

  describe "#bottom_left" do
    it_behaves_like "valid point" do
      let(:given_point) { subject.bottom_left }
      let(:expected_point) { Point.at 20, 60 }
    end
  end

  describe "#bottom_right" do
    it_behaves_like "valid point" do
      let(:given_point) { subject.bottom_right }
      let(:expected_point) { Point.at 40, 60 }
    end
  end
  
  describe "#center" do
    it_behaves_like "valid point" do
      let(:given_point) { subject.center }
      let(:expected_point) { Point.at 30, 45 }
    end
  end
  

  describe "#dimensions" do
    it "correct dimensions" do
      expect(subject.dimensions).to eq Dimensions.of(20,30)
    end
  end


end