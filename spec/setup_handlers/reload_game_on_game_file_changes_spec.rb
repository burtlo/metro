require 'spec_helper'

describe Metro::SetupHandlers::ReloadGameOnGameFileChanges do

  let(:expected_filepaths) do
    %w[ lib scenes models views assets ]
  end

  its(:watched_filepaths) { should eq expected_filepaths }

  describe "#setup" do
    context "when the game is not in debug mode" do
      before do
        Game.stub(:debug?).and_return(false)
      end

      let(:options) { mock('Options',packaged?: false) }

      it "should not start the watcher" do
        subject.should_not_receive(:start_watcher)
        subject.setup(options)
      end
    end

    context "when the options specify that it is being run in a package" do
      before do
        Game.stub(:debug?).and_return(true)
      end

      let(:options) { mock('Options',packaged?: true) }

      it "should not start the watcher" do
        subject.should_not_receive(:start_watcher)
        subject.setup(options)
      end
    end

    context "when the game is debug mode" do
      before do
        Game.stub(:debug?).and_return(true)
      end

      let(:options) { mock('Options',packaged?: false) }


      it "should start the watcher" do
        subject.should_receive(:start_watcher)
        subject.setup(options)
      end
    end
  end

end
