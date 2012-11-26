require 'spec_helper'

describe Metro::Parameters::CommandLineArgsParser do

  describe "Class Methods" do

    subject { described_class }

    describe "#parse" do
      context "when given no parameters" do

      end

      context "when given an array of parameters" do

        subject { described_class.parse parameters }
        let(:parameters) { [ '--upset-the-world', expected_filename, '--check-dependencies', 'unread_command' ] }
        let(:expected_filename) { 'metro' }

        it "should maintain an original parameter list" do
          subject.execution_parameters.should eq parameters
        end

        it "should consider the first non-flag the game file" do
          subject.filename.should eq expected_filename
        end

        it "should find all the flags" do
          subject.upset_the_world?.should be_true
          subject.check_dependencies?.should be_true
        end
        
        it "should return false when non-existant flags are present" do
          subject.wants_food_mild?.should be_false
        end
      end

    end

  end

end
