require 'spec_helper'

describe Metro::KeyValueCoding do

  class KeyValueCodingObject
    include Metro::KeyValueCoding
    attr_accessor :description, :properties
  end

  subject do
    object = KeyValueCodingObject.new

    object.description = "Describe Yourself"
    object.properties = { height: 100, width: 50 }

    object
  end

  describe "#get" do
    context "when given a key with a single attribute" do
      let(:key) { :description }
      let(:expected_value) { "Describe Yourself" }

      it "should return the value" do
        subject.get(key).should eq expected_value
      end
    end

    context "when given a key with multiple attributes" do
      let(:key) { "properties.keys" }
      let(:expected_value) { [ :height, :width ] }

      it "should return the expected value" do
        subject.get(key).should eq expected_value
      end
    end
  end

  describe "#set" do
    context "when given a key with a single attribute" do
      let(:key) { :description }
      let(:expected_value) { "New Description" }

      it "should set the value" do
        subject.set(key,expected_value)
        subject.get(key).should eq expected_value
      end
    end

    context "when given a key with multiple attributes" do
      let(:key) { "properties.default" }
      let(:expected_value) { 0 }

      it "should set the value" do
        subject.set(key,expected_value)
        subject.get(key).should eq expected_value
      end
    end
  end

end