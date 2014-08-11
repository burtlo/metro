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

      let(:options) { double('Options',packaged?: false) }

      it "should not start the watcher" do
        subject.should_not_receive(:start_watcher)
        subject.setup(options)
      end
    end

    context "when the options specify that it is being run in a package" do
      before do
        Game.stub(:debug?).and_return(true)
      end

      let(:options) { double('Options',packaged?: true) }

      it "should not start the watcher" do
        subject.should_not_receive(:start_watcher)
        subject.setup(options)
      end
    end

    context "when the game is debug mode" do
      before do
        Game.stub(:debug?).and_return(true)
      end

      let(:options) { double('Options',packaged?: false) }


      it "should start the watcher" do
        subject.should_receive(:start_watcher)
        subject.setup(options)
      end
    end
  end

  describe "#reload_game_because_files_changed" do

    before do
      Metro.stub(:game_has_valid_code?).and_return(false)
    end

    let(:changed_files) { [ :new_file, :update_file, :deleted_file ] }

    it "should not ask the current scene to reload if the code is invalid" do
      Game.should_not_receive(:current_scene)
      subject.reload_game_because_files_changed(changed_files)
    end
  end

end
