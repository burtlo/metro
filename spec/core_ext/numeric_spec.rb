require 'spec_helper'

describe Numeric do

  before :each do
    Numeric.tick_interval = 16.666666
  end

  describe "#tick(s)" do
    context "when using an Integer" do
      subject { 60 }
      let(:expected_value) { 60 }

      its(:tick) { should eq expected_value }
      its(:ticks) { should eq expected_value }
    end

    context "when using a Float" do
      subject { 70.1 }
      let(:expected_value) { 70.1 }

      its(:tick) { should eq expected_value }
      its(:ticks) { should eq expected_value }
    end
  end

  describe "#second(s)" do

    context "when using an Integer" do
      context "when the tick interval has not been set" do
        subject { 2 }
        let(:expected_value) { 120 }

        its(:second) { should eq expected_value }
        its(:seconds) { should eq expected_value }
        its(:sec) { should eq expected_value }
        its(:secs) { should eq expected_value }
      end

      context "when the tick interval has been set to 33.3333" do
        before :each do
          Numeric.tick_interval = 33.333333
        end

        subject { 2 }
        let(:expected_value) { 60 }

        its(:second) { should eq expected_value }
        its(:seconds) { should eq expected_value }
      end
    end

    context "when using a Float" do
      context "when the tick interval has not been set" do
        subject { 2.5 }
        let(:expected_value) { 150 }

        its(:second) { should eq expected_value }
        its(:seconds) { should eq expected_value }
        its(:sec) { should eq expected_value }
        its(:secs) { should eq expected_value }
      end

      context "when the tick interval has been set" do
        before :each do
          Numeric.tick_interval = 33.333333
        end

        subject { 3.5 }
        let(:expected_value) { 105 }

        its(:second) { should eq expected_value }
        its(:seconds) { should eq expected_value }
      end
    end
  end

end