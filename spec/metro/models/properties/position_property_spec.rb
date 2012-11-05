require 'spec_helper'

describe Metro::Model::PositionProperty do

  subject { described_class.new model }
  let(:model) { "model" }

  describe "#get" do

    context "when the value is nil" do
      context "when no default value has been specified" do

        let(:expected_position) { Metro::Point.new 0.0, 0.0 }

        it "should return the default position" do
          subject.get(nil).should eq expected_position
        end
      end

      context "when a default value has been specified" do

        subject { described_class.new model, default: expected_position }
        let(:expected_position) { Metro::Point.new 0.0, 0.0 }

        it "should return the specified default position" do
          subject.get(nil).should eq expected_position
        end
      end
    end

    context "when the value is a point" do

      let(:point) { Metro::Point.new 10.0, 20.0 }
      let(:expected_position) { point }

      it "should return the same position" do
        subject.get(point).should eq expected_position
      end
    end

    context "when the value is a string" do

      let(:point) { "22.0,33.0" }
      let(:expected_position) { Metro::Point.new 22.0, 33.0 }

      it "should return the position" do
        subject.get(point).should eq expected_position
      end
    end

  end


  describe "#set" do

    context "when the value is nil" do
      context "when no default value has been specified" do

        let(:expected_position) { Metro::Point.new 0.0, 0.0 }

        it "should return the default position" do
          subject.set(nil).should eq expected_position
        end
      end

      context "when a default value has been specified" do

        subject { described_class.new model, default: expected_position }
        let(:expected_position) { Metro::Point.new 0.0, 0.0 }

        it "should return the specified default position" do
          subject.set(nil).should eq expected_position
        end
      end
    end

    context "when the value is a point" do

      let(:point) { Metro::Point.new 10.0, 20.0 }
      let(:expected_position) { point }

      it "should return the same position" do
        subject.set(point).should eq expected_position
      end
    end

    context "when the value is a string" do

      let(:point) { "22.0,33.0" }
      let(:expected_position) { Metro::Point.new 22.0, 33.0 }

      it "should return the position" do
        subject.set(point).should eq expected_position
      end
    end

  end

end