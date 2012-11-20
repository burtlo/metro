require 'spec_helper'

describe Metro::Model::OptionsProperty::NoOption do

  context "when attempting to an attribute like color of the no option" do

    let(:log) { mock('log') }

    it "should generate a warning message" do
      log.should_receive(:warn).with(subject.warning_message)
      subject.stub(:log) { log }
      subject.color = :unknown
    end
  end

  context "when queried for its action" do

    let(:expected_action) { :missing_menu_action }

    it "should return 'missing_menu_action'" do
      subject.properties[:action].should eq expected_action
    end
  end

end
