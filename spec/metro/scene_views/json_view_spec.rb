require 'spec_helper'

describe Metro::SceneView::JSONView do

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

  # describe ".write" do
  #   context "when given a scene" do
  # 
  #     let(:scene) do
  #       mock "Scene", to_json: expected_data,
  #         view_name: "testscene"
  #     end
  # 
  #     let(:expected_data) { '{ "expected" : "json" }' }
  #     let(:expected_filename) { "testscene.json" }
  # 
  #     it "should write the scene to view name" do
  #       File.should_receive(:write).with(expected_filename,expected_data)
  #       subject.write(scene)
  #     end
  #   end
  # end

end