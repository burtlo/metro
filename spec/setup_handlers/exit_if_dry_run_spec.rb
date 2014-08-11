require 'spec_helper'

describe Metro::SetupHandlers::ExitIfDryRun do

  describe "#setup" do
    context "when the options specify that this is a dry run" do

      let(:options) { double('Options', dry_run?: true) }

      it "should exit the game" do
        subject.should_receive(:exit)
        subject.setup(options)
      end
    end

    context "when the options DO NOT specify that this is a dry run" do

      let(:options) { double('Options', dry_run?: false) }

      it "should not exit the game" do
        subject.should_not_receive(:exit)
        subject.setup(options)
      end
    end
  end

end
