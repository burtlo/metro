require 'spec_helper'

describe Metro::Model::OptionsProperty::Options do

  describe "ClassMethods" do
    describe "#empty" do
      it "should generate an empty set of options" do
        described_class.empty.should be_kind_of described_class
      end
    end
  end

  subject { described_class.new [ :a, :b ] }

  describe "#current_selected_index" do
    it "should by default be 0" do
      subject.current_selected_index.should eq 0
    end

    context "when the value is set to negative value" do
      let(:expected_index) { subject.count - 1 }

      it "should set the current_selected_index to the last item" do
        subject.current_selected_index = -1
        subject.current_selected_index.should eq expected_index
      end
    end

    context "when the value is set to a value greater than the count" do
      let(:expected_index) { 0 }

      it "should set the current_selected_index to the first item" do
        subject.current_selected_index = 4
        subject.current_selected_index.should eq expected_index
      end
    end
  end

  describe "#next!" do
    before do
      subject.current_selected_index = 0
    end

    let(:expected_index) { 1 }

    it "should move the index to the next item" do
      subject.next!
      subject.current_selected_index.should eq expected_index
    end

    context "when next will pass the last item" do
      before do
        subject.current_selected_index = (subject.count - 1)
      end

      let(:expected_index) { 0 }

      it "should return to the first item" do
        subject.next!
        subject.current_selected_index.should eq expected_index
      end
    end
  end

  describe "#previous!" do
    before do
      subject.current_selected_index = 1
    end

    let(:expected_index) { 0 }

    it "should move to the item previous of the current one" do
      subject.previous!
      subject.current_selected_index.should eq expected_index
    end

    context "when previous! will move before the first item" do
      let(:expected_index) { subject.count - 1 }

      it "should return to the last item" do
        subject.previous!
        subject.previous!
        subject.current_selected_index.should eq expected_index
      end
    end
  end

  describe "#selected" do
    context "when their are options defined" do
      let(:expected_selected) { subject[subject.current_selected_index] }

      it "should return the item at the current_selected index" do
        subject.selected.should eq expected_selected
      end
    end

    context "when there are no options defined" do
      subject { described_class.new [] }

      it "should return a NoOption" do
        subject.selected.should be_kind_of Metro::Model::OptionsProperty::NoOption
      end
    end
  end

  describe "#selected_action" do
    context "when there are options defined" do
      subject { described_class.new [ mock('first-option',properties: { action: expected_action }), mock('second-option') ] }
      let(:expected_action) { :execute_this_action }
      
      it "should return the action defined on the current selected item" do
        subject.selected_action.should eq expected_action
      end
    end
    
    context "when there are no options defined" do
      subject { described_class.new [] }
      
      it "should return the action on the NoOption" do
        subject.selected_action.should eq :missing_menu_action
      end
    end
  end

end
