require 'spec_helper'

describe Metro::Model::ArrayProperty do

  subject { described_class.new model }
  let(:model) { "model" }

  describe "#get" do
    context "when the value is nil" do

      context "when no default value has been specified" do
        let(:expected) { [] }

        it "should return an empty array" do
          subject.get(nil).should eq expected
        end
      end

      context "when a default value has been specified" do
        subject { described_class.new model, default: expected }
        let(:expected) { [:default_1,:default_2] }

        it "should return the specified default" do
          subject.get(nil).should eq expected
        end
      end

    end
  end

  describe "#set" do
    context "when the value is nil" do
      let(:expected) { [] }

      it "should return an empty array" do
        subject.set(nil).should eq expected
      end
    end

    context "when the value contains symbols" do
      let(:input) { [ :a, :b, :c ] }
      let(:expected) { input }

      it "should not convert the items to strings" do
        subject.set(input).should eq expected
      end
    end

    context "when the value contains numbers" do
      let(:input) { [ 1, 5.4, 0xABAB ] }
      let(:expected) { input }

      it "should not convert the items to strings" do
        subject.set(input).should eq expected
      end
    end

  end

end
