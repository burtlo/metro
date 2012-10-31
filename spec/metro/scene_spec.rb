require 'spec_helper'

describe Metro::Scene do

  class SpecScene < Metro::Scene ; end

  subject { SpecScene.new }

  let(:expected_view_name) { "spec" }
  its(:view_name) { should eq expected_view_name }
  
  let(:expected_scene_name) { "spec" }
  its(:scene_name) { should eq expected_scene_name }

  let(:expected_view_path) { "views/spec" }
  
  it "should have the correct view_path" do
    SpecScene.view_path.should eq expected_view_path
  end

end