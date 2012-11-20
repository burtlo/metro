require 'spec_helper'

describe Metro::Model::FontProperty do

  subject { described_class.new model }
  let(:model) { mock("model", window: window) }
  let(:window) { mock('window') }

  describe "#get" do
    let(:expected_font) { stub('font') }
    let(:expected_options) { { name: expected_font_name, size: expected_font_size, window: window } }
    
    context "when the value is nil" do
      context "when no default value has been specified" do
        let(:expected_font_name) { Gosu::default_font_name }
        let(:expected_font_size) { 40 }
    
        it "should return the default value" do
          described_class.stub(:font_for).with(expected_options) { expected_font }
          subject.get(nil).should eq expected_font
        end
      end

      context "when a default value has been specified" do
        subject do
          described_class.new model, default: { name: expected_font_name, size: expected_font_size }
        end

        let(:expected_font_name) { 'Times New Roman' }
        let(:expected_font_size) { 60 }

        it "should return the specified default value" do
          described_class.stub(:font_for).with(expected_options) { expected_font }
          subject.get(nil).should eq expected_font
        end
      end
    end

    context "when the value is a hash" do
      let(:expected_font_name) { 'Helvetica' }
      let(:expected_font_size) { 80 }
    
      let(:font_hash) { { name: expected_font_name, size: expected_font_size } }
    
      it "should return the font value" do
        described_class.stub(:font_for).with(expected_options) { expected_font }
        subject.get(font_hash).should eq expected_font
      end
    end

    context "when the same font is requested" do
      let(:expected_font_name) { Gosu::default_font_name }
      let(:expected_font_size) { 40 }
    
      it "should not be created a second time (pullled from memory)" do
        described_class.should_receive(:font_for).twice { expected_font }
        subject.get(nil)
        subject.get(nil)
      end
    end


  end

  describe "#set" do
    context "when the value is nil" do
      context "when no default value has been specified" do
        let(:expected_font_name) { Gosu::default_font_name }
        let(:expected_font_size) { 40 }
        let(:expected_font) { stub('font') }

        let(:expected_result) { { name: expected_font_name, size: expected_font_size } }
        let(:expected_options) { { name: expected_font_name, size: expected_font_size, window: window } }

        it "should return a hash of the default value" do
          described_class.stub(:font_for).with(expected_options) { expected_font }
          subject.set(nil).should eq expected_result
        end
      end

      context "when a default value has been specified" do
        subject do
          described_class.new model, default: { name: expected_font_name, size: expected_font_size }
        end

        let(:expected_font_name) { 'Times New Roman' }
        let(:expected_font_size) { 60 }

        let(:expected_result) { { name: expected_font_name, size: expected_font_size } }

        it "should return the specified default value" do
          subject.set(nil).should eq expected_result
        end
      end
    end

    context "when the value is a font" do

      let(:gosu_font) do
        font = stub('font', name: expected_font_name, height: expected_font_size)
        font.stub(:class) { Metro::Font }
        font
      end

      let(:expected_font_name) { 'Comic Sans' }
      let(:expected_font_size) { 45 }

      let(:expected_result) { { name: expected_font_name, size: expected_font_size } }

      it "should return a hash of the font" do
        subject.set(gosu_font).should eq expected_result
      end
    end

    context "when the value is a hash" do

      let(:expected_font_name) { 'Wingdings' }
      let(:expected_font_size) { 33 }
      let(:expected_result) { { name: expected_font_name, size: expected_font_size } }

      it "should return the hash representation of the font" do
        subject.set(expected_result).should eq expected_result
      end
    end
  end

end