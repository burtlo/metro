require 'spec_helper'

describe Metro::Model::ColorProperty do

  subject { described_class.new model }
  let(:model) { mock("model", window: window) }
  let(:window) { mock('window') }

  describe "#get" do
    let(:expected_color) { mock('color') }

    context "when the value is nil" do
      context "when no default value has been specified" do
        let(:default_color_string) { "rgba(255,255,255,1.0)" }


        it "should return the default value" do
          subject.stub(:create_color).with(default_color_string) { expected_color }
          subject.get(nil).should eq expected_color
        end
      end

      context "when a default value has been specified" do
        subject do
          described_class.new model, default: expected_color_string
        end

        let(:expected_color_string) { "rgba(255,255,127,0.5)" }

        it "should return the specified default value" do
          subject.stub(:create_color).with(expected_color_string) { expected_color }
          subject.get(nil).should eq expected_color
        end
      end
    end

    context "when the value is a string" do

      let(:color_string) { "#666666" }

      it "should return the color" do
        subject.stub(:create_color).with(color_string) { expected_color }
        subject.get(color_string).should eq expected_color
      end
    end

  end

  describe "#set" do
    let(:expected_color) { mock('color') }

    context "when the value is nil" do

      context "when no default value has been specified" do
        let(:expected_color_string) { "rgba(255,255,255,1.0)" }

        it "should return a string representation of the default color" do
          subject.set(nil).should eq expected_color_string
        end
      end

      context "when a default value has been specified" do
        subject do
          described_class.new model, default: expected_color_string
        end

        let(:expected_color_string) { "rgba(0,127,11,0.4)" }

        it "should return a string representation of the specified default color" do
          subject.set(nil).should eq expected_color_string
        end
      end
    end

    context "when the value is a color" do
      let(:color) { Gosu::Color.new expected_color_string }
      let(:expected_color_string) { "rgba(45,12,12,1.0)" }

      it "should return a string representation of the color" do
        subject.set(color).should eq expected_color_string
      end
    end
  end

end