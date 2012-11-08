require 'spec_helper'

describe Metro::Model::PositionProperty do

  subject { described_class.new model }
  let(:model) { "model" }

  describe "#get" do

    context "when the value is nil" do
      context "when no default value has been specified" do

        let(:expected_position) { Point.at 0.0, 0.0 }

        it "should return the default position" do
          subject.get(nil).should eq expected_position
        end
      end

      context "when a default value has been specified" do

        subject { described_class.new model, default: expected_position }
        let(:expected_position) { Point.at 4.0, 3.3 }

        it "should return the specified default position" do
          subject.get(nil).should eq expected_position
        end
      end
    end

    context "when the value is a string" do

      let(:point) { "22.0,33.0" }
      let(:expected_position) { Point.at 22.0, 33.0 }

      it "should return the position" do
        subject.get(point).should eq expected_position
      end
    end

  end


  describe "#set" do

    context "when the value is nil" do
      context "when no default value has been specified" do

        let(:expected_position) { "0.0,0.0,0.0" }

        it "should return the default position" do
          subject.set(nil).should eq expected_position
        end
      end

      context "when a default value has been specified" do

        subject { described_class.new model, default: default_point }
        let(:default_point) { Point.at 12, 24 }
        let(:expected_position) { "12.0,24.0,0.0" }

        it "should return the specified default position" do
          subject.set(nil).should eq expected_position
        end
      end
    end

    context "when the value is a point" do

      let(:point) { Point.at 10.0, 20.0 }
      let(:expected_position) { "10.0,20.0,0.0" }

      it "should return the same position" do
        subject.set(point).should eq expected_position
      end
    end

    context "when the value is a string" do

      let(:point) { "22.0,33.0" }
      let(:expected_position) { "22.0,33.0,0.0" }

      it "should return the position" do
        subject.set(point).should eq expected_position
      end
    end

  end

end