require 'spec_helper'

describe Metro::Scenes do

  subject { described_class }

  class SpecScene < Metro::Scene ; end
  let(:existing_scene_name) { :spec }

  describe ".find" do
    context "when a scene does exist" do

      let(:expected_value) { SpecScene }

      it "should return the scene" do
        subject.find(existing_scene_name).should eq expected_value
      end
    end

    context "when a scene does not exist" do
      let(:unknown_scene_name) { :unknown }

      it "should return a missing scene" do
        missing_scene = subject.find(unknown_scene_name)
        missing_scene.missing_scene.should eq unknown_scene_name
      end
    end
  end

  describe ".generate" do
    let(:existing_scene_name) { :spec }

    context "when the provided scene name does exist" do

      let(:expected_scene_class) { SpecScene }

      it "should return an instance of the scene" do
        subject.generate(existing_scene_name).should be_kind_of expected_scene_class
      end
    end

    context "when the provided scene object does exist" do

      let(:scene_instance) { SpecScene.new }

      it "should return the same instance of scene" do
        subject.generate(scene_instance).should eq scene_instance
      end
    end

    it "should process the scene through the post filters" do
      subject.should_receive(:apply_post_filters)
      subject.generate(existing_scene_name)
    end
  end

  describe ".register_post_filter" do

    class SpecScenesPostFilter
      def self.filter(scene,options)
        scene
      end
    end

    context "when a post filter is added" do
      let(:post_filter) { SpecScenesPostFilter }

      it "should be in the list of post filters" do
        subject.register_post_filter SpecScenesPostFilter
        subject.post_filters.should include(post_filter)
      end
    end

  end


end