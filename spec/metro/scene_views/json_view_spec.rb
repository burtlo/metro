require 'spec_helper'

describe Metro::Views::JSONView do

  subject { described_class }
  let(:view_name) { "example" }

  before do
    File.stub(:exists?).and_return(false)
  end

  describe ".exists?" do
    context "when a view file exists with the extension JSON" do
      before do
        File.stub(:exists?).with(filepath_that_exists).and_return(true)
      end

      let(:filepath_that_exists) { "#{view_name}.json" }

      it "should return true" do
        subject.exists?(view_name).should be_true
      end

    end
  end

end