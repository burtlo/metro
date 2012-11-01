require 'spec_helper'

describe Metro::View do
  before do
    subject.name = "spec"
  end

  let(:expected_view_path) { "views/spec" }
  its(:view_path) { should eq expected_view_path }

  describe "#parser" do
    before do
      subject.stub(:supported_parsers) { [ mock(exists?: false), expected_parser ] }
    end

    let(:expected_parser) { mock(exists?: true) }

    it "should return the first parser which has a existing view" do
      subject.parser.should eq expected_parser
    end
  end

  describe "#writer" do

    context "when the parser has a format that matches a writer" do
      before do
        subject.stub(:parser) { mock(format: :json) }
        subject.stub(:supported_writers) { [ mock(format: :yaml), expected_writer ] }
      end

      let(:expected_writer) { mock(format: :json) }

      it "should match the parser format" do
        subject.writer.format.should eq :json
      end
    end

    context "when the format has been specified" do
      before do
        subject.stub(:parser) { mock(format: :json) }
        subject.stub(:supported_writers) { [ expected_writer, mock(format: :json) ] }
      end

      let(:expected_writer) { mock(format: :yaml) }

      it "should match the format (ignoring the parser format)" do
        subject.format = :yaml
        subject.writer.format.should eq :yaml
      end
    end
  end

end