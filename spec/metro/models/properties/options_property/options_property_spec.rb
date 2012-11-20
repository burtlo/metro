require 'spec_helper'

describe Metro::Model::OptionsProperty do

  subject { described_class.new model }
  let(:model) { mock("model", create: 'builds models for a living') }

  describe "#get" do
    context "when the value is nil" do
      context "when no menu has been specified" do
        it "should return empty options" do
          subject.get(nil).count.should eq 0
        end
      end
    end


    context "when the value is an array of options names" do
      before do
        model.stub(:create) { |model_type,options| mock(model_type,options) }
      end

      let(:names) { [ 'Start Game', 'Options', 'Exit Game' ] }
      let(:actions) { [ :start_game, :options, :exit_game ] }

      let(:options) { subject.get(names) }

      it "should return an option for each name" do
        options.count.should eq names.count
      end

      it "should create labels with text with each name" do
        options.map { |option| option.text }.should eq names
      end

      it "should create actions based on each name" do
        options.map { |option| option.action }.should eq actions
      end

      it "should set the default selected as the first item" do
        options.selected.should eq options.first
      end
    end


    context "when the value is a hash which is a set of option names and the selected index" do
      before do
        model.stub(:create) { |model_type,options| mock(model_type,options) }
      end

      let(:names_and_selected_index) do
        { 'selected' => selected_index, 'items' => names  }
      end

      let(:names) { [ 'Start Game', 'Options', 'Exit Game' ] }
      let(:actions) { [ :start_game, :options, :exit_game ] }
      let(:selected_index) { 1 }
      
      let(:label_model_class) { 'metro::ui::label' }
      

      let(:options) { subject.get(names_and_selected_index) }

      it "should return an option for each name" do
        options.count.should eq names.count
      end

      it "should create labels for each name" do
        options.each { |option| option.model.should eq label_model_class }
      end

      it "should create labels with text with each name" do
        options.map { |option| option.text }.should eq names
      end

      it "should create actions based on each name" do
        options.map { |option| option.action }.should eq actions
      end

      it "should set the default selected as the first item" do
        options.selected.should eq options[selected_index]
      end
    end


    context "when the value is hash that contains a set of options (with specific ui details) and the seelcted index" do
      before do
        model.stub(:create) { |model_type,options| mock(model_type,options) }
      end

      let(:names_and_selected_index) do
        { 'selected' => selected_index, 'items' => details  }
      end

      let(:details) do
        [ { model: 'metro::ui::label', text: 'Start Game!', action: 'start_game' },
          { model: 'metro::ui::image', text: 'Settings', action: 'open_settings' },
          { model: 'metro::ui::label', text: 'Exit' } ]
      end
      

      let(:names) { [ 'Start Game!', 'Settings', 'Exit' ] }
      let(:actions) { [ :start_game, :open_settings, :exit ] }
      let(:models) { [ 'metro::ui::label', 'metro::ui::image', 'metro::ui::label' ] }
      
      let(:selected_index) { 1 }
      
      let(:options) { subject.get(names_and_selected_index) }

      it "should return an option for each name" do
        options.count.should eq names.count
      end

      it "should create labels for each name" do
        options.map { |option| option.model }.should eq models
      end

      it "should create labels with text with each name" do
        options.map { |option| option.text }.should eq names
      end

      it "should create actions based on each name" do
        options.map { |option| option.action }.should eq actions
      end

      it "should set the default selected as the first item" do
        options.selected.should eq options[selected_index]
      end
    end

  end

end
