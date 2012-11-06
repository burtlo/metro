require 'spec_helper'

describe Metro::Model::NumericProperty do

  subject { described_class.new model }
  let(:model) { "model" }

  describe "#get" do
    context "when the value is nil" do
      context "when no default value has been specified" do

        let(:expected_number) { 0.0 }

        it "should return the default position" do
          subject.get(nil).should eq expected_number
        end
      end

      context "when a default value has been specified" do

        subject { described_class.new model, default: expected_number }
        let(:expected_number) { 1.0 }

        it "should return the specified default position" do
          subject.get(nil).should eq expected_number
        end
      end
    end

    context "when the value is a String" do

      let(:number) { "4.3" }
      let(:expected_number) { 4.3 }

      it "should get the float value of the string" do
        subject.get(number).should eq expected_number
      end
    end

  end

  describe "#set" do

  end

end